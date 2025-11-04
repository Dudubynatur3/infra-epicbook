output "frontend_public_ip" {
  description = "Public IP of frontend VM"
  value       = azurerm_public_ip.frontend.ip_address
}

output "backend_public_ip" {
  description = "Public IP of backend VM"
  value       = azurerm_public_ip.backend.ip_address
}

output "backend_private_ip" {
  description = "Private IP of backend VM"
  value       = azurerm_network_interface.backend.private_ip_address
}

output "mysql_fqdn" {
  description = "MySQL server FQDN"
  value       = azurerm_mysql_flexible_server.main.fqdn
}

output "mysql_admin_username" {
  description = "MySQL admin username"
  value       = azurerm_mysql_flexible_server.main.administrator_login
}

output "resource_group_name" {
  description = "Resource group name"
  value       = azurerm_resource_group.main.name
}