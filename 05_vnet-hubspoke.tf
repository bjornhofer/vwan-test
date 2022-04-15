
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

