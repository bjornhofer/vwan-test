data "azurerm_resource_group" "rg" {
  name = var.resource_group
}

resource "azurerm_virtual_hub" "vwan_hub" {
  address_prefix      = var.vwan_hub_ip
  location            = var.vwan_hub_region
  name                = "vwan-hub-${lower(replace(var.vwan_hub_region, " ", ""))}"
  resource_group_name = data.azurerm_resource_group.rg.name
  virtual_wan_id      = var.vwan_id
}

resource "azurerm_firewall" "test" {
  name                = "vwan-hub-fw-${lower(replace(var.vwan_hub_region, " ", ""))}"
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = var.vwan_hub_region
  //threat_intel_mode   = ""
  sku_tier            = "Premium"
  sku_name            = "AZFW_Hub"
  virtual_hub {
    virtual_hub_id = azurerm_virtual_hub.vwan_hub.id
  }
}

/*
resource "azurerm_monitor_diagnostic_setting" "default" {
  name               = "default"
  target_resource_id = azurerm_firewall.test.id
  log_analytics_workspace_id = var.loganalytics_workspace_id

  log {
    category = "AzureFirewallApplicationRule"
    enabled  = true
    retention_policy {
      enabled = false
    }
  }

  log {
    category = "AzureFirewallNetworkRule"
    enabled  = true
    retention_policy {
      enabled = false
    }
  }
  log {
    category = "AzureFirewallDnsProxy"
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
*/