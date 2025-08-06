variable "enable_aks_diagnostics" {
  type    = bool
  default = true
}

variable "log_categories" {
  type = list(string)
  default = [
    "kube-apiserver",
    "kube-controller-manager",
    "kube-scheduler",
    "cluster-autoscaler",
    "guard",
    "csi-azuredisk-controller",
    "csi-azurefile-controller",
    "csi-snapshot-controller"
  ]
}

variable "log_retention_period" {
  type    = number
  default = 30
}

resource "azurerm_log_analytics_workspace" "aks_log_workspace" {
  count               = var.enable_aks_diagnostics ? 1 : 0
  name                = "${var.proj_prefix}-aks-law"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "PerGB2018"
  retention_in_days   = var.log_retention_period
}

resource "azurerm_monitor_data_collection_rule" "aks_monitor" {
  count               = var.enable_aks_diagnostics ? 1 : 0
  name                = "${var.proj_prefix}-aks-dcr"
  location            = var.location
  resource_group_name = var.resource_group_name

  data_sources {
    performance_counter {
      name                          = "perf"
      streams                       = ["Microsoft-InsightsMetrics"]
      counter_specifiers            = ["\\Processor(_Total)\\% Processor Time"]
      sampling_frequency_in_seconds = 60
    }
  }

  destinations {
    log_analytics {
      workspace_resource_id = azurerm_log_analytics_workspace.aks_log_workspace[0].id
      name                  = "logAnalyticsDest"
    }
  }

  data_flow {
    streams      = ["Microsoft-InsightsMetrics"]
    destinations = ["logAnalyticsDest"]
  }
}

resource "azurerm_monitor_data_collection_rule_association" "aks_monitor_association" {
  count                   = var.enable_aks_diagnostics ? 1 : 0
  name                    = "${var.proj_prefix}-aks-monitor-association"
  target_resource_id      = azurerm_kubernetes_cluster.main.id
  data_collection_rule_id = azurerm_monitor_data_collection_rule.aks_monitor[0].id
  description             = "Association between AKS and monitoring rule"
}
