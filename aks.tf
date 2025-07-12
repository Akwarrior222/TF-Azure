module "aks" {
  source                   = "../modules/aks-cluster"
  proj_prefix              = local.project_prefix
  environment              = local.environment
  location                 = local.project_region
  resource_group_name      = module.vnet.resource_group_name
  vnet_subnet_id           = module.vnet.aks_subnet_id
  kubernetes_version       = "1.29.2"
  location_zonal_type      = true
  aks_custom_log_config    = true
  log_retention_period     = 90
  log_exclude_namespace = [
    {
      name  = "argocd"
      value = "argocd"
    },
    {
      name  = "cert-manager"
      value = "cert-manager"
    },
    {
      name  = "external-secrets"
      value = "external-secrets"
    },
    {
      name  = "kube-node-lease"
      value = "kube-node-lease"
    },
    {
      name  = "kube-public"
      value = "kube-public"
    },
    {
      name  = "kube-system"
      value = "kube-system"
    },
    {
      name  = "lms-infra-dev"
      value = "lms-infra-dev"
    },
    {
      name  = "lms-infra-stg"
      value = "lms-infra-stg"
    },
    {
      name  = "monitoring"
      value = "monitoring"
    },
    {
      name  = "podidentitywebhook"
      value = "podidentitywebhook"
    }
  ]
}

module "aks_preemptible_pool" {
  source                       = "../modules/aks-node-pool"
  proj_prefix                  = local.project_prefix
  environment                  = local.environment
  cluster_name                 = module.aks.cluster_name
  cluster_location             = module.aks.cluster_location
  azure_service_principal_id   = module.aks.azure_service_principal_id
  node_pool_name               = "preemptible-pool"
  preemptible_node             = true
  node_pool_min_node_count     = 1
  node_pool_max_node_count     = 15
  node_pool_machine_type       = "Standard_E2s_v3"
}

module "aks_node_pool" {
  source                       = "../modules/aks-node-pool"
  proj_prefix                  = local.project_prefix
  environment                  = local.environment
  cluster_name                 = module.aks.cluster_name
  cluster_location             = module.aks.cluster_location
  azure_service_principal_id   = module.aks.azure_service_principal_id
  node_pool_name               = "node-pool"
  preemptible_node             = false
  node_pool_min_node_count     = 1
  node_pool_max_node_count     = 5
  node_pool_machine_type       = "Standard_N2s_v3"
}

module "aksbackup" {
  source                    = "../modules/aks-backup"
  cluster_name              = module.aks.cluster_id
  backup_namespace          = ["lms-infra-stg"]
  backup_schedule           = "0 */12 * * *"
  backup_location           = "centralindia"
  backup_retention_period   = 5
  include_secrets           = true
  include_volume_data       = true
  backup_delete_lock_days   = 1
  depends_on                = [module.aks]
}
