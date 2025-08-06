variable "proj_prefix" {
  type        = string
  description = "The prefix to use for all named Azure resources."
}

variable "region" {
  type        = string
  description = "The Azure region where the resources should be created."
  default     = "Central India"
}

variable "location_zonal_type" {
  type        = bool
  description = "Whether to use zone-specific location (not directly used in Azure AKS, but kept for parity)."
  default     = false
}

variable "zone" {
  type        = string
  description = "The availability zone to use (if applicable)."
  default     = null
}

variable "environment" {
  type        = string
  description = "The name of the environment (e.g., dev, stage, prod)."
}

variable "vpc" {
  type        = string
  description = "The name of the Azure Virtual Network (for informational parity)."
}

variable "subnetwork" {
  type        = string
  description = "The name of the Azure Subnet (for informational parity)."
}

variable "subnet_id" {
  type        = string
  description = "The full resource ID of the subnet for AKS node pool."
}

variable "master_ipv4_cidr_block" {
  type        = string
  description = "Not applicable in Azure AKS (included for parity with GKE)."
  default     = null
}

variable "channel_type" {
  type        = string
  description = "Used for GKE release channel (not applicable in AKS)."
  default     = "UNSPECIFIED"
}

variable "log_exclude_namespace" {
  type        = list(object({
    name  = string
    value = string
  }))
  description = "List of namespaces to exclude (not supported directly in Azure, informational only)."
  default     = []
}

variable "gke_custom_log_config" {
  type        = bool
  description = "Whether to enable custom log configuration."
  default     = false
}

variable "log_include_filter" {
  type        = string
  description = "Log inclusion filter (used in GCP only)."
  default     = ""
}

variable "kubernetes_version" {
  type        = string
  description = "AKS Kubernetes version."
  default     = "1.29.2"
}

variable "node_vm_size" {
  type        = string
  description = "The size of the VM to use for AKS nodes."
  default     = "Standard_DS2_v2"
}

variable "dns_service_ip" {
  type        = string
  description = "DNS service IP address used by the AKS cluster."
  default     = "10.2.0.10"
}

variable "docker_bridge_cidr" {
  type        = string
  description = "Docker bridge CIDR for AKS networking."
  default     = "172.17.0.1/16"
}

variable "service_cidr" {
  type        = string
  description = "Service CIDR range for AKS networking."
  default     = "10.2.0.0/24"
}

variable "api_server_authorized_ips" {
  type        = list(string)
  description = "List of CIDR blocks allowed to access the AKS API server."
  default     = ["0.0.0.0/0"]
}

variable "resource_group_name" {
  type        = string
  description = "Azure resource group in which to create all resources."
}


variable "location" {
  type        = string
  description = "The Azure region to deploy resources into."
  default     = "Central India"
}
