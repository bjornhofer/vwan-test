data "azurerm_resource_group" "rg" {
  name = var.resource_group
}

# VNET
resource "azurerm_virtual_network" "VNET" {
  name                = "s2svpn-vnet${lower(replace(data.azurerm_resource_group.rg.location, " ", ""))}"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  address_space       = ["${var.vnet_address_scope}"]
}

resource "azurerm_subnet" "subnet" {
  name                  = "s2svpn-sn${lower(replace(data.azurerm_resource_group.rg.location, " ", ""))}"
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
  name                = "s2s-vpn-pip${lower(replace(data.azurerm_resource_group.rg.location, " ", ""))}"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name

  allocation_method = "Dynamic"
}

# VPN Gateway
resource "azurerm_virtual_network_gateway" "vnet-branch-vpngw" {
  location            = data.azurerm_resource_group.rg.location
  name                = "s2s-vpn-nw-gw-${lower(replace(data.azurerm_resource_group.rg.location, " ", ""))}"
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

# Local Network Gateway
resource "azurerm_local_network_gateway" "tohub" {
  name                = "s2s-vpn-nw-gw-${lower(replace(data.azurerm_resource_group.rg.location, " ", ""))}"
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location
  gateway_address     = var.hub_vpn_ip
    bgp_settings {
    asn                 = var.asn
    bgp_peering_address = tolist(azurerm_vpn_gateway.VPNGW.bgp_settings[0].instance_0_bgp_peering_address[0].tunnel_ips)[0]
  }
}

# VPN Connection
resource "azurerm_virtual_network_gateway_connection" "vnet-to-hub" {
  name                = "s2s-vpn-connection-${lower(replace(data.azurerm_resource_group.rg.location, " ", ""))}"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  type       = "IPsec"
  enable_bgp = true

  virtual_network_gateway_id = azurerm_virtual_network_gateway.vnet-branch-vpngw.id
  local_network_gateway_id   = azurerm_local_network_gateway.tohub.id

  shared_key = var.shared_key
}