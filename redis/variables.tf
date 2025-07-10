variable "redis_name" {
  type        = string
  description = "Name of the Azure Redis Cache instance"
}

variable "redis_sku" {
  type        = string
  description = "SKU of the Azure Redis Cache (e.g., Basic, Standard, Premium)"
}

variable "redis_family" {
  type        = string
  description = "Redis family: C for Basic/Standard, P for Premium"
}

variable "redis_capacity" {
  type        = number
  description = "Redis capacity (e.g., 0 = 250MB, 1 = 1GB, etc.)"
}

variable "vnet_name" {
  type        = string
  description = "Name of the Azure Virtual Network (used for VNet integration in Premium tier)"
}

variable "region" {
  type        = string
  description = "Azure region where Redis will be deployed"
}

variable "env" {
  type        = string
  description = "Deployment environment (dev, prod, etc.)"
}

variable "auth_enabled" {
  type        = bool
  default     = false
  description = "Not applicable in Azure Redis – authentication is always enabled with access keys"
}

variable "connection_string_secret" {
  type        = string
  default     = ""
  description = "Name of the Azure Key Vault secret to store Redis connection string"
}

variable "product" {
  type        = string
  description = "Product name for tagging"
}

variable "k8s_namespace" {
  type        = string
  description = "Kubernetes namespace"
}

variable "k8s_cluster" {
  type        = string
  description = "Kubernetes cluster name"
}

variable "project_id" {
  type        = string
  description = "Project identifier (not directly used in Azure but kept for compatibility)"
}

variable "redis_version" {
  type        = string
  default     = ""
  description = "Azure Redis version (Azure manages version automatically; this is informational)"
}

variable "resource_group_name" {
  type        = string
  description = "Name of the Azure resource group"
}

variable "location" {
  type        = string
  description = "Azure location (redundant with region, but sometimes both are used)"
}
