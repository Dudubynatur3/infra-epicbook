# Private DNS Zone for MySQL
resource "azurerm_private_dns_zone" "mysql" {
  name                = "epicbook-mysql.mysql.database.azure.com"
  resource_group_name = azurerm_resource_group.main.name
}

# Link DNS Zone to VNet
resource "azurerm_private_dns_zone_virtual_network_link" "mysql" {
  name                  = "mysql-vnet-link"
  resource_group_name   = azurerm_resource_group.main.name
  private_dns_zone_name = azurerm_private_dns_zone.mysql.name
  virtual_network_id    = azurerm_virtual_network.main.id
}

# MySQL Flexible Server
resource "azurerm_mysql_flexible_server" "main" {
  name                = "epicbook-mysql-${random_string.suffix.result}"
  resource_group_name = azurerm_resource_group.main.name
  location            = "westeurope"

  administrator_login    = var.mysql_admin_username
  administrator_password = var.mysql_admin_password

  backup_retention_days = 7
  sku_name              = var.mysql_sku
  version               = var.mysql_version

  delegated_subnet_id = azurerm_subnet.mysql.id
  private_dns_zone_id = azurerm_private_dns_zone.mysql.id

  depends_on = [
    azurerm_private_dns_zone_virtual_network_link.mysql
  ]

  tags = {
    Environment = "dev"
    Project     = "epicbook"
  }
}

# MySQL Database
resource "azurerm_mysql_flexible_database" "epicbook" {
  name                = "epicbook_db"
  resource_group_name = azurerm_resource_group.main.name
  server_name         = azurerm_mysql_flexible_server.main.name
  charset             = "utf8mb4"
  collation           = "utf8mb4_unicode_ci"
}
