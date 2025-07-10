resource "azurerm_public_ip" "traefik_public" {
  name                = "${var.project_prefix}-traefik"
  location            = var.location
  resource_group_name = var.resource_group_name

  allocation_method   = "Static"
  sku                 = "Standard"

  tags = {
    environment = var.environment
  }
}
