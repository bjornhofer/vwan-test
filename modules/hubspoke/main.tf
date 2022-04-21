data "azurerm_resource_group" "rg" {
  name = var.resource_group
}

resource "azurerm_virtual_network" "hub" {
  name                = "hub-${lower(replace(data.azurerm_resource_group.rg.location, " ", ""))}"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  address_space       = ["${var.hub_scope}"]
}

resource "azurerm_subnet" "hubsubnet" {
  name                  = "hub-sn${lower(replace(data.azurerm_resource_group.rg.location, " ", ""))}"
  virtual_network_name  = azurerm_virtual_network.hub.name
  resource_group_name   = data.azurerm_resource_group.rg.name
  address_prefixes      = ["${var.hub_subnet_scope}"]
}

resource "azurerm_virtual_network" "spoke" {
  name                = "spoke-${lower(replace(data.azurerm_resource_group.rg.location, " ", ""))}"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  address_space       = ["${var.spoke_scope}"]
}

resource "azurerm_subnet" "spokesubnet" {
  name                  = "spoke-sn${lower(replace(data.azurerm_resource_group.rg.location, " ", ""))}"
  virtual_network_name  = azurerm_virtual_network.spoke.name
  resource_group_name   = data.azurerm_resource_group.rg.name
  address_prefixes      = ["${var.spoke_subnet_scope}"]
}

// Peering classic
resource "azurerm_virtual_network_peering" "hub" {
  count                     = var.vwanhubpeering ? 0 : 1
  name                      = "hub2spoke"
  resource_group_name       = data.azurerm_resource_group.rg.name
  virtual_network_name      = azurerm_virtual_network.hub.name
  remote_virtual_network_id = azurerm_virtual_network.spoke.id
}


resource "azurerm_virtual_network_peering" "spoke" {
  count                     = var.vwanhubpeering ? 0 : 1
  name                      = "spoke2hub"
  resource_group_name       = data.azurerm_resource_group.rg.name
  virtual_network_name      = azurerm_virtual_network.spoke.name
  remote_virtual_network_id = azurerm_virtual_network.hub.id
}

// Peering Hub
resource "azurerm_virtual_hub_connection" "vnet2hub" {
  count                     = var.vwanhubpeering ? 1 : 0
  name                      = "vwan"
  virtual_hub_id            = var.vwan_hub_id
  remote_virtual_network_id = azurerm_virtual_network.spoke.id
}



