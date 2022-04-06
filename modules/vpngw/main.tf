data "azurerm_resource_group" "rg" {
  name = var.resource_group
}

# VNET for VPN
resource "azurerm_virtual_network" "VNET" {
  name                = "vpn-vnet${lower(replace(data.azurerm_resource_group.rg.location, " ", ""))}"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  address_space       = ["${var.vnet_address_scope}"]
}

resource "azurerm_subnet" "subnet" {
  name                  = "vpn-sn${lower(replace(data.azurerm_resource_group.rg.location, " ", ""))}"
  virtual_network_name  = azurerm_virtual_network.VNET.name
  resource_group_name   = data.azurerm_resource_group.rg.name
  address_prefixes      = ["${var.subnet_address_prefix}"]
}

resource "azurerm_subnet" "vpn_subnet" {
  name                  = "GatewaySubnet"
  virtual_network_name  = azurerm_virtual_network.VNET.name
  resource_group_name   = data.azurerm_resource_group.rg.name
  address_prefixes      = ["${var.subnet_vpn_address_prefix}"]
}

# Public IP for VPNGW
resource "azurerm_public_ip" "publicip" {
  name                = "vpn-pip${lower(replace(data.azurerm_resource_group.rg.location, " ", ""))}"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name

  allocation_method = "Dynamic"
}

# 
resource "azurerm_virtual_network_gateway" "vnet-branch-vpngw" {
  location            = data.azurerm_resource_group.rg.location
  name                = "vpn-nw-gw-${lower(replace(data.azurerm_resource_group.rg.location, " ", ""))}"
  resource_group_name = data.azurerm_resource_group.rg.name
  vpn_type            = "RouteBased"
  generation          = "Generation1"
  sku                 = "VpnGw1"
  type                = "Vpn"
  enable_bgp          = true
  active_active       = false
  bgp_settings {
    asn = var.branch_asn
  }
  ip_configuration {
    public_ip_address_id = azurerm_public_ip.publicip.id
    subnet_id            = azurerm_subnet.vpn_subnet.id
  }
}

resource "azurerm_vpn_gateway" "VPNGW" {
  location            = data.azurerm_resource_group.rg.location
  name                = "vpn-gw-${lower(replace(data.azurerm_resource_group.rg.location, " ", ""))}"
  resource_group_name = data.azurerm_resource_group.rg.name
  virtual_hub_id      = var.vwan_hub_id
}

# Local network gateway to define the vWAN Hub side
resource "azurerm_local_network_gateway" "vpn-to-vwan-hub" {
  address_space       = ["${tolist(azurerm_vpn_gateway.VPNGW.bgp_settings[0].instance_0_bgp_peering_address[0].tunnel_ips)[0]}/32"]
  gateway_address     = tolist(azurerm_vpn_gateway.VPNGW.bgp_settings[0].instance_0_bgp_peering_address[0].tunnel_ips)[1]
  location            = data.azurerm_resource_group.rg.location
  name                = "vpn-to-vwan-hub"
  resource_group_name = data.azurerm_resource_group.rg.name
  bgp_settings {
    asn                 = azurerm_vpn_gateway.VPNGW.bgp_settings[0].asn
    bgp_peering_address = tolist(azurerm_vpn_gateway.VPNGW.bgp_settings[0].instance_0_bgp_peering_address[0].tunnel_ips)[0]
  }
}

# VPN Connection
resource "azurerm_virtual_network_gateway_connection" "branch-to-hub-vpn" {
  name                = "branch-to-hub-vpn"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  type       = "IPsec"
  enable_bgp = true

  virtual_network_gateway_id = azurerm_virtual_network_gateway.vnet-branch-vpngw.id
  local_network_gateway_id   = azurerm_local_network_gateway.vpn-to-vwan-hub.id

  shared_key = var.shared_key
}