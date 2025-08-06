locals {
  location = var.location != null ? var.location : "centralindia"
}

data "azurerm_client_config" "current" {}
data "azurerm_subscription" "current" {}

# data "azurerm_availability_zones" "available" {
#   location = var.region
# }

provider "azurerm" {
  features {}
  subscription_id = "9ab7ab94-d8d0-4de5-b31f-3ce088b0423b"
  tenant_id       = "deaef897-b598-44df-ae17-982bbdce0b3e"
  client_id       = "50613311-682c-47e2-a5ff-f9a2dbcf4978"
  client_secret   = "LnS8Q~WAQd_75KLCUiWKDJg4SZBOH2FycR.uJchH"
}
resource "azurerm_log_analytics_workspace" "log" {
  name                = "${var.proj_prefix}-law"
  location            = var.region
  resource_group_name = var.resource_group_name
  sku                 = "PerGB2018"
  retention_in_days   = var.log_retention_period
}

resource "azurerm_kubernetes_cluster" "main" {
  name                = "${var.proj_prefix}-aks-cluster"
  location            = local.location
  resource_group_name = var.resource_group_name
  dns_prefix          = "${var.proj_prefix}-aks"
  kubernetes_version  = var.kubernetes_version
  sku_tier            = "Standard"
  
  

  default_node_pool {
    name                = "default"
    node_count          = 1
    vm_size             = var.node_vm_size
    vnet_subnet_id      = var.subnet_id

  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin     = "azure"
    network_policy     = "azure"
    load_balancer_sku  = "standard"
    dns_service_ip     = var.dns_service_ip
    service_cidr       = var.service_cidr
  }

  oms_agent {
    log_analytics_workspace_id = azurerm_log_analytics_workspace.log.id
  }

  azure_policy_enabled = true

  role_based_access_control_enabled = true
  private_cluster_enabled           = false

  api_server_access_profile {
    authorized_ip_ranges = var.api_server_authorized_ips
  }

  tags = {
    environment = var.environment
  }

  lifecycle {
    ignore_changes = [default_node_pool[0].node_count]
  }
}

# Optional identity (only needed if you want to assign specific roles)
resource "azurerm_user_assigned_identity" "nodepool" {
  name                = "${var.proj_prefix}-nodepool-identity"
  resource_group_name = var.resource_group_name
  location            = var.region
}

resource "azurerm_role_assignment" "node_identity_roles" {
  for_each = toset([
    "Reader",
    "Monitoring Metrics Publisher",
    "Log Analytics Contributor"
  ])

  scope                = data.azurerm_subscription.current.id
  role_definition_name = each.key
  principal_id         = azurerm_user_assigned_identity.nodepool.principal_id
}

resource "azurerm_virtual_network" "vnet" {
  name                = "${var.proj_prefix}-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = var.region
  resource_group_name = var.resource_group_name
}

resource "azurerm_subnet" "subnet" {
  name                 = "${var.proj_prefix}-subnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}
