# Import existing public IPs
import {
  to = azurerm_public_ip.frontend
  id = "/subscriptions/4498449e-cbcd-452c-9a04-69e911ee0ae4/resourceGroups/epicbook-rg/providers/Microsoft.Network/publicIPAddresses/frontend-pip"
}

import {
  to = azurerm_public_ip.backend
  id = "/subscriptions/4498449e-cbcd-452c-9a04-69e911ee0ae4/resourceGroups/epicbook-rg/providers/Microsoft.Network/publicIPAddresses/backend-pip"
}

# Public IP - Frontend
resource "azurerm_public_ip" "frontend" {
  name                = "frontend-pip"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

# Public IP - Backend
resource "azurerm_public_ip" "backend" {
  name                = "backend-pip"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

# Network Interface - Frontend
resource "azurerm_network_interface" "frontend" {
  name                = "frontend-nic"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.frontend.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.frontend.id
  }
}

# Network Interface - Backend
resource "azurerm_network_interface" "backend" {
  name                = "backend-nic"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.backend.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.backend.id
  }
}

# Virtual Machine - Frontend
resource "azurerm_linux_virtual_machine" "frontend" {
  name                = "frontend-vm"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  size                = "Standard_B2s"
  admin_username      = "azureuser"

  network_interface_ids = [
    azurerm_network_interface.frontend.id,
  ]

  admin_ssh_key {
    username   = "azureuser"
    public_key = var.admin_ssh_public_key
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  tags = {
    Environment = "dev"
    Project     = "epicbook"
    Role        = "frontend"
  }
}

# Virtual Machine - Backend
resource "azurerm_linux_virtual_machine" "backend" {
  name                = "backend-vm"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  size                = "Standard_B2s"
  admin_username      = "azureuser"

  network_interface_ids = [
    azurerm_network_interface.backend.id,
  ]

  admin_ssh_key {
    username   = "azureuser"
    public_key = var.ssh_public_key
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  tags = {
    Environment = "dev"
    Project     = "epicbook"
    Role        = "backend"
  }
}