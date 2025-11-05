variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
  default     = "epicbook-rg"
}

variable "location" {
  description = "Azure region"
  type        = string
  default     = "East US"
}

variable "admin_username" {
  description = "Admin username for VMs"
  type        = string
  default     = "azureuser"
}

# ✅ FIXED: Changed from file path to actual key content
variable "admin_ssh_public_key" {
  description = "SSH public key content for VM access"
  type        = string
  sensitive   = true
}

variable "mysql_admin_password" {
  description = "MySQL admin password"
  type        = string
  sensitive   = true
  default     = "P@ssw0rd1234!"
}

variable "mysql_sku" {
  description = "The SKU name for the MySQL Flexible Server"
  type        = string
  default     = "B_Standard_B1ms"
}

variable "mysql_version" {
  description = "The MySQL server version"
  type        = string
  default     = "8.0.21"
}