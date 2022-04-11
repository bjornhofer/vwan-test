data "azurerm_resource_group" "rg" {
  name = var.resource_group
}

resource "azurerm_virtual_network" "hub" {
  name                = "vnetone-${var.name}"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  address_space       = ["${var.hub_scope}"]
}

resource "azurerm_virtual_network" "spoke" {
  name                = "vnettwo-${var.name}"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  address_space       = ["${var.spoke_scope}"]
}

resource "azurerm_virtual_network_peering" "hub" {
  name                      = "hub2spoke"
  resource_group_name       = data.azurerm_resource_group.rg
  virtual_network_name      = azurerm_virtual_network.hub.name
  remote_virtual_network_id = azurerm_virtual_network.spoke.id
}

resource "azurerm_virtual_network_peering" "spoke" {
  name                      = "spoke2hub"
  resource_group_name       = data.azurerm_resource_group.rg
  virtual_network_name      = azurerm_virtual_network.spoke.name
  remote_virtual_network_id = azurerm_virtual_network.hub.id
}

