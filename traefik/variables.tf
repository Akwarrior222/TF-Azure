variable "project_prefix" {
  description = "Prefix used for naming Azure resources"
  type        = string
}

variable "region" {
  description = "Azure region where resources will be deployed"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the Azure Resource Group where resources will be deployed"
  type        = string
}

variable "environment" {
  description = "Environment label (e.g., dev, staging, prod)"
  type        = string
  default     = "dev"
}
variable "location" {
  description = "Azure region where resources will be deployed"
  type        = string
}
