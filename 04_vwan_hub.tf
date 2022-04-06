# Create VWAN - Global
resource "azurerm_virtual_wan" "vwan" {
  location            = "West Europe"
  name                = "vwan"
  resource_group_name = azurerm_resource_group.vwan.name
  depends_on = [
    azurerm_resource_group.vwan
  ]
}