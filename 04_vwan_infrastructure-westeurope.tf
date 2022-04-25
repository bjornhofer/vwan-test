# Germany Region
module "vwan-hub-germany" {
  source = "./modules/vwan_hub"
  resource_group = azurerm_resource_group.germany.name
  vwan_hub_region = "Germany West Central"
  vwan_hub_ip = "172.16.0.0/24"
  vwan_id = azurerm_virtual_wan.vwan.id
  loganalytics_workspace_id = azurerm_log_analytics_workspace.la01.id
  depends_on = [
    azurerm_resource_group.vwan,
    azurerm_virtual_wan.vwan
    ]
}

# VNET with Peering
module "peered-vnet-germany" {
  source = "./modules/vnetvwan"
  resource_group = azurerm_resource_group.germany.name
  vnet_scope = "192.168.8.0/22"
  subnet_pe_prefix = "192.168.8.0/24"
  subnet_vm_prefix = "192.168.9.0/24"
  vwan_hub_id = module.vwan-hub-germany.vwan_hub_id
  enforce_private_link_endpoint_network_policies = true
  loganalytics_workspace_id = azurerm_log_analytics_workspace.la01.id
  depends_on = [
    azurerm_resource_group.vwan,
    azurerm_virtual_wan.vwan,
    module.vwan-hub-germany
    ]
}

/*
# VM in the VNET
module "peered-vm-germany" {
    source = "./modules/virtualmachine"
    naming_convention = "peeredgermany"
    resource_group = azurerm_resource_group.germany.name
    vmname = "vm00"
    subnet_id = module.peered-vnet-germany.subnet_vm_id
    depends_on = [
        azurerm_resource_group.germany,
        module.peered-vnet-germany
    ]
}

# Storage Account with Private Endpoint
module "storage-acount-germany" {
    source = "./modules/storageaccount"
    resource_group = azurerm_resource_group.germany.name
    subnet_id = module.peered-vnet-germany.subnet_pe_id
    depends_on = [
        azurerm_resource_group.germany,
        module.peered-vnet-germany
    ]
}
*/