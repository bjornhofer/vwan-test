output "vnet_name" {
  value = azurerm_virtual_network.VNET.name
}

output "vnet_id" {
  value = azurerm_virtual_network.VNET.id
}

output "subnet_id" {
  value = azurerm_subnet.subnet.id
}

output "vpn_subnet_id" {
  value = azurerm_subnet.vpn_subnet.id
}