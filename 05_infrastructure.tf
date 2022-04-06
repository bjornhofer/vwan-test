/*
locals{
  locations = fileset("${path.module}/includes/locations/", "*.json")
}

data "azurerm_virtual_hub" "vwanhub" {
  name = "vwan-hub-${lower(replace(local.location, " ", ""))}"
  resource_group_name = azurerm_resource_group.vwan.name
}


module "vnet" {
  for_each = local.locations
    source = "./modules/vnet"
    location_config = "${each.key}"
    naming_convention = local.naming_convention
    resource_group = azurerm_resource_group.default.name
    vnet_address_scope = var.VNET_SCOPE
    subnet_address_prefix = var.SUBNET_PREFIX
    depends_on = [
        azurerm_resource_group.default
    ]
}

# Connect VNET to Hub
resource "azurerm_virtual_hub_connection" "vnet-hub" {
  name                      = module.vnet.vnet_name
  virtual_hub_id            = data.azurerm_virtual_hub.vwanhub.id
  remote_virtual_network_id = module.vnet.vnet_id
}
*/