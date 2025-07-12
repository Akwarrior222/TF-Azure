# Azure PostgreSQL
variable "azure_postgres_password" {
  description = "The administrator login password for the Azure PostgreSQL server."
  type        = string
  sensitive   = true
  default     = ""
}

# Azure MySQL
variable "azure_mysql_password" {
  description = "The administrator login password for the Azure MySQL server."
  type        = string
  sensitive   = true
}
