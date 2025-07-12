resource "azurerm_resource_provider_registration" "required_providers" {
  for_each = toset([
    "Microsoft.Authorization",
    "Microsoft.Network",
    "Microsoft.Compute",
    "Microsoft.ContainerService",
    "Microsoft.DBforPostgreSQL",
    "Microsoft.DBforMySQL",
    "Microsoft.Storage",
    "Microsoft.KeyVault",
    "Microsoft.Cache",            # Redis
    "Microsoft.App",              # App Services or Container Apps
    "Microsoft.OperationalInsights" # Log Analytics
  ])

  name = each.key
}
