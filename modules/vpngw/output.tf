output "public_ip" {
  value = azurerm_public_ip.publicip.ip_address
}

output "subnet_address_prefix" {
  value = azurerm_subnet.subnet.address_prefixes
}