module "firewall" {
  source         = "../modules/nsg"
  proj_prefix    = local.project_prefix
  vnet_name      = module.vnet.vnet_name
  location       = local.project_region
  resource_group = azurerm_resource_group.main.name
  office_ip_list = local.firewall_office_ip_list
}
