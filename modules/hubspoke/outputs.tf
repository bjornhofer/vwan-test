output "hub" {
  value = azurerm_virtual_network.hub.name
}

output "spoke" {
  value = azurerm_virtual_network.spoke.name
}
