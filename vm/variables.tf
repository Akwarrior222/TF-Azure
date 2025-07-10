## Common
variable "project_prefix" {
  description = "Prefix for naming Azure resources"
  type        = string
}

variable "instance_name" {
  description = "Base name of the virtual machine"
  type        = string
}

## Network
variable "subnet_id" {
  description = "ID of the existing subnet where the VM will be placed"
  type        = string
}

variable "private_ip_address" {
  description = "Static private IP address to assign to the NIC"
  type        = string
}

variable "associate_public_ip" {
  description = "Whether to associate a static public IP"
  type        = bool
  default     = false
}

## VM
variable "ssh_port" {
  description = "SSH port to be opened"
  type        = number
  default     = 22
}

variable "machine_disk_size" {
  description = "OS disk size in GB"
  type        = number
  default     = 30
}

variable "image_publisher" {
  description = "Image publisher (e.g., Canonical)"
  type        = string
  default     = "Canonical"
}

variable "image_offer" {
  description = "Image offer (e.g., UbuntuServer)"
  type        = string
  default     = "UbuntuServer"
}

variable "image_sku" {
  description = "Image SKU (e.g., 20_04-lts)"
  type        = string
  default     = "20_04-lts"
}

variable "vm_size" {
  description = "Azure VM size (e.g., Standard_B2s)"
  type        = string
  default     = "Standard_B1s"
}

variable "vm_zone" {
  description = "Availability zone to place the VM in (null for random)"
  type        = number
  default     = null
}

variable "machine_ssh_keys" {
  description = "List of SSH keys with username and key"
  type = list(object({
    username = string
    key      = string
  }))
  default = []
}

## Service Principal / Managed Identity
variable "service_account_email" {
  description = "Optional pre-created Managed Identity email (not required in Azure, kept for compatibility)"
  type        = string
  default     = null
}

variable "create_service_account" {
  description = "Whether to create a User Assigned Managed Identity"
  type        = bool
  default     = true
}

variable "iam_roles" {
  description = "List of IAM roles to assign to the managed identity"
  type        = list(string)
  default     = []
}

## Startup Script
variable "custom_startup_script" {
  description = "Custom startup script to append after the default"
  type        = string
  default     = ""
}

## Resource Group / Region
variable "resource_group_name" {
  description = "Azure Resource Group name"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

## Tags (optional)
variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}
variable "admin_username" {
  description = "Admin username for the virtual machine"
  type        = string
}
