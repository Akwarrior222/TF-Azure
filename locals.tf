locals {
  # Base project naming
  project                 = "skcn"
  environment             = "nonprod"
  project_region          = "eastus"                        # Azure region equivalent
  project_region_code     = "eus"                           # Your custom region code
  project_prefix          = "${local.project}-${local.environment}"
  project_id              = "${local.project}-${local.environment}"
  proj_regioncode_prefix  = "${local.project}-${local.environment}-${local.project_region_code}"

  # NSG allowed IPs
  firewall_office_ip_list = [
    "103.214.233.88/32",
    "61.2.141.1/32",
    "14.142.179.226/32",
    "61.2.142.186/32",
    "65.2.23.113/32",
    "103.142.31.94/32",
    "103.214.233.108/32",
    "103.214.233.1/32",
    "103.181.238.106",
    "103.181.238.106/32",
    "103.142.30.151/32",
    "103.138.236.18/32"
  ]

  # Azure Database Disk Size & Tier
  disk_size_gb       = 30
  availability_type  = "ZoneRedundant" # Azure value: "ZoneRedundant" or "HighAvailability"
  tier               = "GP_Gen5_2"     # Azure DB SKU (General Purpose, Gen5, 2 vCores)

  # Private endpoints / DNS labels (used as naming tags)
  private_ips = [
    "redis-dev",
    "redis-stg",
    "es-dev",
    "es-stg",
    "mongodb-dev",
    "mongodb-stg"
  ]

  # Bastion / Jump host configuration (for Azure VM)
  bastion_config = {
    type            = "Standard_B1s"     # Azure VM size (e.g., B-series burstable)
    image           = "Canonical:UbuntuServer:22_04-lts:latest"  # Azure Marketplace format
    ssh_port        = "22"
    instance_name   = "bastion"
    subnet_name     = "${local.project_prefix}-public-1"  # Matching Azure subnet naming
  }
   resource_group = "your-resource-group-name"
}
