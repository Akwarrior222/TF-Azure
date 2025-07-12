# Grafana Monitoring Managed Identity
module "cloud_monitoring_grafana" {
  source         = "../../common/modules/aks_mi"
  name           = "grafana"
  proj_prefix    = local.project_prefix
  resource_group = local.resource_group
  location       = local.project_region

  # Assign Reader role for Azure Monitor
  roles = [
    {
      role_name       = "Monitoring Reader"
      scope_resource  = data.azurerm_subscription.primary.id
    }
  ]

  # Kubernetes SA mapping (for AKS Pod Identity)
  k8s_sa = [{
    k8s_service_account_name      = "grafana-sa"
    k8s_service_account_namespace = "monitoring"
  }]
}

# External Secrets Managed Identity (for Azure Key Vault access)
module "external_secrets" {
  source         = "../../common/modules/aks_mi"
  name           = "external-secrets"
  proj_prefix    = local.project_prefix
  resource_group = local.resource_group
  location       = local.project_region

  roles = [
    {
      role_name      = "Key Vault Secrets User"
      scope_resource = azurerm_key_vault.kv.id
    }
  ]

  k8s_sa = [{
    k8s_service_account_name      = "external-secrets"
    k8s_service_account_namespace = "external-secrets"
  }]
}

# GitHub OIDC Federated Credential (for workload identity federation)
module "github_oidc" {
  source          = "../modules/github-oidc"
  github_org_name = "skillscaravan"
  resource_group  = local.resource_group
  location        = local.project_region
}

# Managed Identity for Cert Manager (Azure DNS Challenge)
module "cert_issuer" {
  source         = "../../common/modules/aks_mi"
  name           = "cert-issuer"
  proj_prefix    = local.project_prefix
  resource_group = local.resource_group
  location       = local.project_region

  roles = [
    {
      role_name      = "DNS Zone Contributor"
      scope_resource = azurerm_dns_zone.dns_zone.id
    }
  ]

  k8s_sa = [{
    k8s_service_account_name      = "cert-manager-sa"
    k8s_service_account_namespace = "cert-manager"
  }]
}

# Custom Role Assignment for Cert Manager (Granular DNS)
module "cert_manager_issuer_custom" {
  source                = "../../common/modules/custom_roles"
  role_name             = "cert-manager-issuer-custom"
  principal_id          = module.cert_issuer.managed_identity_principal_id

  granular_permissions = [
    "Microsoft.Network/dnsZones/read",
    "Microsoft.Network/dnsZones/A/write",
    "Microsoft.Network/dnsZones/A/delete",
    "Microsoft.Network/dnsZones/TXT/write",
    "Microsoft.Network/dnsZones/TXT/delete"
  ]

  scope = azurerm_dns_zone.dns_zone.id

  depends_on = [module.cert_issuer]
}
