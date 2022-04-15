data "azurerm_resource_group" "rg" {
  name = var.resource_group
}

# create random name
resource "random_string" "storage" {
  length           = 16
  special          = false
}

# Storage account
resource "azurerm_storage_account" "storage" {
  name                     = lower(random_string.storage.result)
  resource_group_name      = data.azurerm_resource_group.rg.name
  location                 = data.azurerm_resource_group.rg.location
  account_kind              = "StorageV2"
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_share" "fileshare" {
  name                 = "share"
  storage_account_name = azurerm_storage_account.storage.name
  quota                = 50
}

# Private Endpoint
resource "azurerm_private_endpoint" "storage" {
  name                = "pe-vwan-${lower(replace(data.azurerm_resource_group.rg.location, " ", ""))}"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  subnet_id           = var.subnet_id

    private_service_connection {
    name                           = "psc-file-vwan-${lower(replace(data.azurerm_resource_group.rg.location, " ", ""))}"
    is_manual_connection           = false
    private_connection_resource_id = azurerm_storage_account.storage.id
    subresource_names              = ["file"]
  }
}