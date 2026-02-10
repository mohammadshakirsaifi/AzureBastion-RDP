variable "location" {
  default = "East US"
}

variable "resource_group_name" {
  default = "rg-azure-windows-prod"
}

variable "admin_username" {
  default = "azureadmin"
}

variable "admin_password" {
  description = "VM admin password"
  sensitive   = true
}

variable "aad_admin_object_id" {
  description = "Azure AD Object ID for VM admin access"
}
