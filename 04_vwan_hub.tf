# Create VWAN - Global
resource "azurerm_virtual_wan" "vwan" {
  location            = "West Europe"
  name                = "vwan"
  resource_group_name = azurerm_resource_group.vwan.name
  depends_on = [
    azurerm_resource_group.vwan
  ]
}

resource "azurerm_log_analytics_workspace" "la01" {
  name                = "la01"
  location            = azurerm_resource_group.default.location
  resource_group_name = azurerm_resource_group.default.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}