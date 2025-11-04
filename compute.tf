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

# Associate NSG to Frontend NIC
resource "azurerm_network_interface_security_group_association" "frontend" {
  network_interface_id      = azurerm_network_interface.frontend.id
  network_security_group_id = azurerm_network_security_group.frontend.id
}

# Associate NSG to Backend NIC
resource "azurerm_network_interface_security_group_association" "backend" {
  network_interface_id      = azurerm_network_interface.backend.id
  network_security_group_id = azurerm_network_security_group.backend.id
}

# Frontend VM
resource "azurerm_linux_virtual_machine" "frontend" {
  name                = "epicbook-frontend"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  size                = "Standard_B2s"
  admin_username      = var.admin_username

  network_interface_ids = [
    azurerm_network_interface.frontend.id,
  ]

  admin_ssh_key {
    username   = var.admin_username
    public_key = file(var.ssh_public_key_path)
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}

# Backend VM
resource "azurerm_linux_virtual_machine" "backend" {
  name                = "epicbook-backend"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  size                = "Standard_B2s"
  admin_username      = var.admin_username

  network_interface_ids = [
    azurerm_network_interface.backend.id,
  ]

  admin_ssh_key {
    username   = var.admin_username
    public_key = file(var.ssh_public_key_path)
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}