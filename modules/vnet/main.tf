data "azurerm_resource_group" "rg" {
  name = var.resource_group
}

resource "azurerm_virtual_network" "VNET" {
  name                = "vnet-${var.name}"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  address_space       = ["${var.vnet_address_scope}"]
}

resource "azurerm_subnet" "vpn_subnet" {
  name                  = "GatewaySubnet"
  virtual_network_name  = azurerm_virtual_network.VNET.name
  resource_group_name   = data.azurerm_resource_group.rg.name
  address_prefixes      = ["${var.subnet_vpn_address_prefix}"]
}