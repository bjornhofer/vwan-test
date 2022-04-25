data "azurerm_resource_group" "rg" {
  name = var.resource_group
}

# VNET
resource "azurerm_virtual_network" "vnetvwan" {
  name                = "vwan-vnet-${lower(replace(data.azurerm_resource_group.rg.location, " ", ""))}"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  address_space       = ["${var.vnet_scope}"]
}

resource "azurerm_subnet" "vnetvwan-subnet-pe" {
  name                  = "vwan-vnet-sn-pe${lower(replace(data.azurerm_resource_group.rg.location, " ", ""))}"
  virtual_network_name  = azurerm_virtual_network.vnetvwan.name
  resource_group_name   = data.azurerm_resource_group.rg.name
  address_prefixes      = ["${var.subnet_pe_prefix}"]
  enforce_private_link_endpoint_network_policies = var.enforce_private_link_endpoint_network_policies
}

resource "azurerm_subnet" "vnetvwan-subnet-vm" {
  name                  = "vwan-vnet-sn-vm-${lower(replace(data.azurerm_resource_group.rg.location, " ", ""))}"
  virtual_network_name  = azurerm_virtual_network.vnetvwan.name
  resource_group_name   = data.azurerm_resource_group.rg.name
  address_prefixes      = ["${var.subnet_vm_prefix}"]
}

resource "azurerm_virtual_hub_connection" "vnet2hub" {
  name                      = "vwan-vnet-peering-${lower(replace(data.azurerm_resource_group.rg.location, " ", ""))}"
  virtual_hub_id            = var.vwan_hub_id
  remote_virtual_network_id = azurerm_virtual_network.vnetvwan.id
}

resource "azurerm_monitor_diagnostic_setting" "default" {
  name               = "default"
  target_resource_id = azurerm_virtual_network.vnetvwan.id
  log_analytics_workspace_id = var.loganalytics_workspace_id

  log {
    category = "VMProtectionAlerts"
    enabled  = true
    retention_policy {
      enabled = false
    }
  }

  metric {
    category = "AllMetrics"

    retention_policy {
      enabled = false
    }
  }
}