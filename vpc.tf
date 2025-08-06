locals {
  vnet_cidr_prefix              = "10.51"
  vnet_public_subnet_cidr      = "${local.vnet_cidr_prefix}.4.0/22"
  vnet_application_subnet_cidr = "${local.vnet_cidr_prefix}.8.0/22"

  aks_subnet_cidr         = "${local.vnet_cidr_prefix}.14.0/28" # /28 is required for AKS
  vpn_subnet_cidr         = "${local.vnet_cidr_prefix}.15.0/24"

  service_endpoint_cidr   = "10.151.0.0/16"
}

module "vnet" {
  source      = "../modules/vnet"
  proj_prefix = local.project_prefix
  region      = local.project_region

  public_subnet_cidr      = local.vnet_public_subnet_cidr
  application_subnet_cidr = local.vnet_application_subnet_cidr
  aks_subnet_cidr         = local.aks_subnet_cidr
  vpn_subnet_cidr         = local.vpn_subnet_cidr

  enable_service_endpoint = true
  service_endpoint_cidr   = local.service_endpoint_cidr
}
