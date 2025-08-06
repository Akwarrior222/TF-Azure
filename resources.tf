# Container Registry for app images
module "acr_repo" {
  source        = "../modules/acr"
  location      = local.project_region
  registry_name = "${local.project_prefix}acr"
}

# Container Registry for Helm charts
module "acr_helm" {
  source        = "../modules/acr"
  location      = local.project_region
  registry_name = "${local.project_prefix}helm"
}

# Storage Account for Azure Blob Storage (equivalent to GCS)
module "storage_account" {
  source      = "../modules/storage"
  proj_prefix = local.project_prefix
  location    = local.project_region
}

# Ingress controller like Traefik for AKS
module "traefik" {
  source      = "../modules/traefik"
  proj_prefix = local.project_prefix
  region      = local.project_region
}

# PostgreSQL DB
module "postgres" {
  source              = "../modules/azure-db"
  name                = "${local.project_prefix}-pgsql-db"
  admin_username      = "postgresadmin"
  admin_password      = var.azure_postgres_password
  db_engine           = "PostgreSQL"
  db_version          = "13"
  tier                = "GeneralPurpose"
  storage_mb          = local.disk_size_gb * 1024
  backup_retention    = 7
  geo_redundant_backup = "Disabled"
  project_prefix      = local.project_prefix
  resource_group      = local.resource_group
  location            = local.project_region
  subnet_id           = module.vnet.application_subnet_id
}

# MySQL DB
module "mysql" {
  source              = "../modules/azure-db"
  name                = "${local.project_prefix}-mysql-db"
  admin_username      = "mysqladmin"
  admin_password      = var.azure_mysql_password
  db_engine           = "MySQL"
  db_version          = "8.0"
  tier                = "GeneralPurpose"
  storage_mb          = local.disk_size_gb * 1024
  backup_retention    = 7
  geo_redundant_backup = "Disabled"
  project_prefix      = local.project_prefix
  resource_group      = local.resource_group
  location            = local.project_region
  subnet_id           = module.vnet.application_subnet_id
}

# Internal IPs (equivalent to Google Compute Address)
resource "azurerm_private_endpoint" "private_ips" {
  for_each            = toset(local.private_ips)
  name                = "${local.project}-${each.key}"
  resource_group_name = local.resource_group
  location            = local.project_region
  subnet_id           = module.vnet.application_subnet_id
  private_service_connection {
    name                           = "${each.key}-connection"
    private_connection_resource_id = each.value
    subresource_names              = ["sqlServer"] # or redis, etc.
    is_manual_connection           = false
  }
}

# Bastion Host VM (Linux jumpbox)
module "bastionhost" {
  source             = "../modules/vm"
  project_prefix     = local.project_prefix
  instance_name      = "bastion"
  vm_size            = local.bastion_config.type
  os_disk_size_gb    = 30
  image              = local.bastion_config.image
  associate_public_ip = true
  network_interface {
    subnet_id      = data.azurerm_subnet.public.id
    private_ip     = null
    public_ip_name = "${local.project_prefix}-bastion-ip"
  }
  ssh_port = 22
  network_tags = [
    "${local.environment}-bastion",
    "allow-ssh",
    "bastion-instance"
  ]
  create_identity = true
}

# Bastion NSG (Firewall rule)
resource "azurerm_network_security_group" "bastion_nsg" {
  name                = "${local.project_prefix}-allow-ssh"
  location            = local.project_region
  resource_group_name = local.resource_group

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefixes    = local.firewall_office_ip_list
    destination_address_prefix = "*"
  }
}

# Redis Cache (Azure equivalent of GCP Redis)
module "redis" {
  source          = "../modules/redis"
  redis_name      = "${local.project_prefix}-redis"
  redis_version   = "6"
  sku_name        = "Premium" # For HA setup
  capacity        = 2
  enable_auth     = false
  vnet_id         = module.vnet.vnet_id
  subnet_id       = module.vnet.application_subnet_id
  location        = local.project_region
  resource_group  = local.resource_group
  namespace       = local.project_id
  aks_cluster     = "${local.project_prefix}-aks-cluster"
  environment     = local.environment
}
