data "azurerm_resource_group" "rg" {
  name = var.resource_group
}

# Storage account
resource "azurerm_storage_account" "storage" {
  name                     = "stgvwanbj${lower(replace(data.azurerm_resource_group.rg.location, " ", ""))}"
  resource_group_name      = data.azurerm_resource_group.rg.name
  location                 = data.azurerm_resource_group.rg.location
  account_kind              = "StorageV2"
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "container" {
  name                  = "demo"
  storage_account_name  = azurerm_storage_account.storage.name
  container_access_type = "private"
}

# Private Endpoint
resource "azurerm_private_endpoint" "storage" {
  name                = "pe-vwan-${lower(replace(data.azurerm_resource_group.rg.location, " ", ""))}"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  subnet_id           = var.subnet_id

  private_service_connection {
    name                           = "psc-vwan-${lower(replace(data.azurerm_resource_group.rg.location, " ", ""))}"
    is_manual_connection           = false
    private_connection_resource_id = azurerm_storage_account.storage.id
    subresource_names              = ["blob"]
  }

}