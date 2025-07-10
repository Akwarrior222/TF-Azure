# General Variables
variable "project_prefix" {
  description = "A name prefix used in resource names to ensure uniqueness across a project."
  type        = string
}

variable "location" {
  description = "Azure region where resources will be deployed."
  type        = string
}

# Subnet CIDR Blocks
variable "public_subnet_cidr" {
  description = "The IP address range of the public subnet in CIDR notation."
  type        = string
}

variable "application_subnet_cidr" {
  description = "The IP address range of the application subnet in CIDR notation."
  type        = string
}

# Virtual Network CIDR
variable "vnet_cidr" {
  description = "The CIDR block for the virtual network."
  type        = string
}

# NAT IP Count
variable "nat_ip_count" {
  description = "Number of Public IPs to associate with NAT Gateway."
  type        = number
  default     = 1
}

# Optional Logging Configuration Placeholder (Not used in Azure subnets directly)
variable "log_config" {
  description = "Logging configuration - placeholder for compatibility with GCP-style modules."
  default     = null
}

# Private Link and Private Endpoint Configuration
variable "enable_private_endpoint" {
  description = "Flag to enable private endpoint connection to Azure PaaS service (e.g., Azure SQL)."
  type        = bool
  default     = false
}

variable "sql_server_id" {
  description = "The Azure SQL Server resource ID for private endpoint connection."
  type        = string
  default     = ""
}
