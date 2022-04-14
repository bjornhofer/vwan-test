# Germany Region
module "vwan-hub-germany" {
  source = "./modules/vwan_hub"
  resource_group = azurerm_resource_group.germany.name
  vwan_hub_region = "Germany West Central"
  vwan_hub_ip = "172.16.0.0/24"
  vwan_id = azurerm_virtual_wan.vwan.id
  depends_on = [
    azurerm_resource_group.vwan,
    azurerm_virtual_wan.vwan
    ]
}

# VNET Peering
module "peered-vnet-germany" {
  source = "./modules/vnetvwan"
  resource_group = azurerm_resource_group.germany.name
  vnet_scope = "192.168.8.0/22"
  subnet_prefix = "192.168.8.0/24"
  vwan_hub_id = module.vwan-hub-germany.vwan_hub_id
  depends_on = [
    azurerm_resource_group.vwan,
    azurerm_virtual_wan.vwan,
    module.vwan-hub-germany
    ]
}

# VPN not implemented yet
/*
module "vpngw-germany" {
  source = "./modules/vpngw"
  resource_group = azurerm_resource_group.germany.name
  vnet_address_scope = "192.168.0.0/22"
  subnet_address_prefix = "192.168.0.0/24"
  subnet_vpn_address_prefix = "192.168.1.0/24"
  vwan_hub_id = module.vwan-hub-germany.vwan_hub_id
  shared_key = "asdljasldkjfalskdjflaksjd!!!222"
  branch_asn = "4441"
  depends_on = [
    azurerm_resource_group.vwan,
    azurerm_virtual_wan.vwan
    ]
}

# S2S endpoint for hub
module "s2s-vpngw-germany" {
  source = "./modules/s2s-vpngw"
  resource_group = azurerm_resource_group.germanys2s.name
  vnet_address_scope = "192.168.4.0/22"
  subnet_address_prefix = "192.168.4.0/24"
  subnet_vpn_address_prefix = "192.168.5.0/24"
  hub_vpn_ip = module.vpngw-germany.public_ip
  shared_key = "asdljasldkjfalskdjflaksjd!!!222"
  branch_asn = "4441"
  depends_on = [
    azurerm_resource_group.germanys2s,
    ]
}
*/


