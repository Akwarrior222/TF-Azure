variable "resource_group_name" {
  description = "Name of the Azure Resource Group"
  type        = string
}

variable "location" {
  description = "Azure region to deploy resources"
  type        = string
}

variable "sql_server_name" {
  description = "Name of the Azure SQL Server"
  type        = string
}

variable "sql_db_name" {
  description = "Name of the Azure SQL Database"
  type        = string
}

variable "sql_sku" {
  description = "SKU name for the SQL database (e.g., Basic, S0, P1)"
  type        = string
  default     = "Basic"
}

variable "admin_login" {
  description = "Administrator login for SQL Server"
  type        = string
}

variable "admin_password" {
  description = "Administrator password for SQL Server"
  type        = string
  sensitive   = true
}
