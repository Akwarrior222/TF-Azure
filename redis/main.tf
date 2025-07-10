# Ensure the Microsoft.Cache provider is registered (similar to enabling redis.googleapis.com)
resource "azurerm_provider_registration" "redis_provider" {
  name                 = "Microsoft.Cache"
  resource_group_name  = var.resource_group_name
}

# Create Azure Redis Cache instance
resource "azurerm_redis_cache" "cache" {
  name                = var.redis_name
  location            = var.location
  resource_group_name = var.resource_group_name
  capacity            = var.redis_capacity      # Corresponds to memory size
  family              = var.redis_family        # "C" for basic/standard, "P" for premium
  sku_name            = var.redis_sku           # e.g., "Basic", "Standard", "Premium"
  minimum_tls_version = "1.2"

  redis_configuration {
    maxmemory_policy = "allkeys-lru"
  }

  tags = {
    product       = var.product
    k8s-namespace = var.k8s_namespace
    k8s-cluster   = var.k8s_cluster
    team          = "infra"
    env           = var.env
    managed-by    = "terraform"
  }

  depends_on = [azurerm_provider_registration.redis_provider]
}
