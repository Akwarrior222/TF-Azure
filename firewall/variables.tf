variable "proj_prefix" {
  description = "Project prefix for naming Azure resources"
  type        = string
}

variable "private_source_ranges" {
  description = "CIDR range used for internal/private network traffic"
  type        = string
  default     = "10.0.0.0/16"
}

variable "office_ip_list" {
  description = "List of office IP CIDR blocks allowed for inbound rules"
  type        = list(string)
  default     = []
}

variable "vnet_name" {
  description = "Name of the virtual network to associate with resources"
  type        = string
}

variable "location" {
  description = "Azure region where resources will be deployed"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}
