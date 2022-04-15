output "hub" {
  value = azurerm_virtual_network.hub.name
}

output "spoke" {
  value = azurerm_virtual_network.spoke.name
}

output "spoke_sn" {
  value = azurerm_subnet.spokesubnet.id
}