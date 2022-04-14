data "azurerm_resource_group" "rg" {
  name = var.resource_group
}

resource "azurerm_public_ip" "publicip" {
  name                = "pip-${var.naming_convention}"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  allocation_method   = "Dynamic"
  domain_name_label   = "pip-${var.naming_convention}"
}

resource "azurerm_network_interface" "nic" {
  name                = "nic-${var.naming_convention}"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "ipconfig-${var.naming_convention}"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    primary                       = true
    public_ip_address_id          = azurerm_public_ip.publicip.id
  }
}

resource "azurerm_linux_virtual_machine" "virtualmachine" {
  name                = "${var.vmname}-${var.naming_convention}"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  size                =  "${var.vmsize}"
  admin_username      = "azuser"
  network_interface_ids = [
    azurerm_network_interface.nic.id
  ]

  admin_ssh_key {
    username   = "azuser"
    public_key = file("includes/id_rsa.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
}