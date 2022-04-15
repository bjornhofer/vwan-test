
module "hubspoke" {
  source = "./modules/hubspoke"
  resource_group = azurerm_resource_group.hubspoke.name
  hub_scope = "192.168.0.0/22"
  hub_subnet_scope = "192.168.0.0/24"
  spoke_scope = "192.168.4.0/22"
  spoke_subnet_scope = "192.168.4.0/24"
  depends_on = [
    azurerm_resource_group.hubspoke
    ]
}

# VM in the VNET
module "spoke-vm-germany" {
    source = "./modules/virtualmachine"
    naming_convention = "spokegermany"
    resource_group = azurerm_resource_group.germany.name
    vmname = "vm00"
    subnet_id = module.hubspoke.spoke_sn
    depends_on = [
        azurerm_resource_group.germany,
        module.hubspoke
    ]
}