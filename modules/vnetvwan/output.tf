output "subnet_pe_id" {
  value = azurerm_subnet.vnetvwan-subnet-pe.id
}

output "subnet_vm_id" {
  value = azurerm_subnet.vnetvwan-subnet-vm.id
}