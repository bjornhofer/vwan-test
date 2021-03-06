##################################################################################
# Resource group
##################################################################################

resource "azurerm_resource_group" "default" {
  name     = "rg-${local.naming_convention}"
  location = local.location
}

resource "azurerm_resource_group" "vwan" {
  name     = "rg-vwan-${local.naming_convention}"
  location = local.location
}

resource "azurerm_resource_group" "germany" {
  name     = "rg-vwan-germany"
  location = "Germany West Central"
}

resource "azurerm_resource_group" "hubspoke" {
  name     = "rg-vwan-hubspoke-germany"
  location = "Germany West Central"
}