# Random string for unique resource names
resource "random_string" "suffix" {
  length  = 8
  special = false
  upper   = false
}

# Import existing resources
import {
  to = azurerm_resource_group.main
  id = "/subscriptions/4498449e-cbcd-452c-9a04-69e911ee0ae4/resourceGroups/epicbook-rg"
}

# Resource Group
resource "azurerm_resource_group" "main" {
  name     = var.resource_group_name
  location = var.location

  tags = {
    Environment = "dev"
    Project     = "epicbook"
    ManagedBy   = "Terraform"
  }
}