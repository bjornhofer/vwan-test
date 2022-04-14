data "azurerm_resource_group" "rg" {
  name = var.resource_group
}

# VNET
resource "azurerm_virtual_network" "vnetvwan" {
  name                = "vwan-vnet-${lower(replace(data.azurerm_resource_group.rg.location, " ", ""))}"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  address_space       = ["${var.vnet_scope}"]
}

resource "azurerm_subnet" "vnetvwan-subnet" {
  name                  = "vwan-vnet-sn-${lower(replace(data.azurerm_resource_group.rg.location, " ", ""))}"
  virtual_network_name  = azurerm_virtual_network.vnetvwan.name
  resource_group_name   = data.azurerm_resource_group.rg.name
  address_prefixes      = ["${var.subnet_prefix}"]
}

resource "azurerm_virtual_hub_connection" "vnet2hub" {
  name                      = "vwan-vnet-peering-${lower(replace(data.azurerm_resource_group.rg.location, " ", ""))}"
  virtual_hub_id            = var.vwan_hub_id
  remote_virtual_network_id = azurerm_virtual_network.vnetvwan.id
}