# ===================================================================
# DATABASE CONFIGURATION - Azure MySQL Flexible Server
# ===================================================================

# Random suffix for unique MySQL name
resource "random_string" "suffix" {
  length  = 8
  special = false
  upper   = false
}

# MySQL Flexible Server
resource "azurerm_mysql_flexible_server" "main" {
  name                   = "epicbook-mysql-${random_string.suffix.result}"
  resource_group_name    = azurerm_resource_group.main.name
  location               = azurerm_resource_group.main.location
  administrator_login    = "mysqladmin"
  administrator_password = var.mysql_admin_password
  sku_name               = var.mysql_sku
  version                = var.mysql_version

  storage {
    size_gb = 20
  }

  backup_retention_days = 7

  lifecycle {
    prevent_destroy = true
  }

  depends_on = [azurerm_resource_group.main]
}

# MySQL Database
resource "azurerm_mysql_flexible_database" "epicbook" {
  name                = "epicbookdb"
  resource_group_name = azurerm_resource_group.main.name
  server_name         = azurerm_mysql_flexible_server.main.name
  charset             = "utf8mb3"
  collation           = "utf8mb3_general_ci"

  depends_on = [azurerm_mysql_flexible_server.main]
}

# Firewall Rule - Allow Azure Services
resource "azurerm_mysql_flexible_server_firewall_rule" "azure_services" {
  name                = "AllowAzureServices"
  resource_group_name = azurerm_resource_group.main.name
  server_name         = azurerm_mysql_flexible_server.main.name
  start_ip_address    = "0.0.0.0"
  end_ip_address      = "0.0.0.0"

  depends_on = [azurerm_mysql_flexible_server.main]
}

# Firewall Rule - Allow Backend Subnet
resource "azurerm_mysql_flexible_server_firewall_rule" "backend" {
  name                = "AllowBackendSubnet"
  resource_group_name = azurerm_resource_group.main.name
  server_name         = azurerm_mysql_flexible_server.main.name
  start_ip_address    = "10.0.2.0"
  end_ip_address      = "10.0.2.255"

  depends_on = [azurerm_mysql_flexible_server.main]
}

# ===================================================================
# OUTPUTS
# ===================================================================
