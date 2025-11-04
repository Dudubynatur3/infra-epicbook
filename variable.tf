variable "resource_group_name" {
  description = "Name of the resource group"
  default     = "epicbook-rg"
}

variable "location" {
  description = "Azure region"
  default     = "East US"
}

variable "admin_username" {
  description = "Admin username for VMs"
  default     = "azureuser"
}

variable "ssh_public_key_path" {
  description = "Path to SSH public key"
  default     = "~/.ssh/epicbook_key.pub"
}

variable "mysql_admin_password" {
  description = "MySQL admin password"
  sensitive   = true
  default     = "P@ssw0rd1234!"
}