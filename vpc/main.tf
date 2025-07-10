provider "azurerm" {
  features {}
}

# RESOURCE GROUP
resource "azurerm_resource_group" "rg" {
  name     = "${var.project_prefix}-rg"
  location = var.location
}

# VNET
resource "azurerm_virtual_network" "vnet" {
  name                = "${var.project_prefix}-vnet"
  address_space       = [var.vnet_cidr]
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
}

# PUBLIC SUBNET
resource "azurerm_subnet" "public_subnet" {
  name                 = "${var.project_prefix}-public-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.public_subnet_cidr]
}

# APPLICATION SUBNET
resource "azurerm_subnet" "application_subnet" {
  name                 = "${var.project_prefix}-application-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.application_subnet_cidr]
}

# PUBLIC IPs for NAT Gateway
resource "azurerm_public_ip" "nat_ips" {
  count               = var.nat_ip_count
  name                = "${var.project_prefix}-nat-ip-${count.index + 1}"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

# NAT Gateway
resource "azurerm_nat_gateway" "nat" {
  name                = "${var.project_prefix}-nat-gateway"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  sku_name            = "Standard"
}

resource "azurerm_nat_gateway_public_ip_association" "nat_ip_assoc" {
  count               = var.nat_ip_count
  nat_gateway_id      = azurerm_nat_gateway.nat.id
  public_ip_address_id = azurerm_public_ip.nat_ips[count.index].id
}


# Associate NAT Gateway with Application Subnet
resource "azurerm_subnet_nat_gateway_association" "application_nat_association" {
  subnet_id      = azurerm_subnet.application_subnet.id
  nat_gateway_id = azurerm_nat_gateway.nat.id
}

# Private DNS Zone (for example, for Azure SQL)
resource "azurerm_private_dns_zone" "sql_private_dns" {
  name                = "privatelink.database.windows.net"
  resource_group_name = azurerm_resource_group.rg.name
}

# Link the DNS Zone to the VNet
resource "azurerm_private_dns_zone_virtual_network_link" "sql_dns_link" {
  name                  = "${var.project_prefix}-dnslink"
  resource_group_name   = azurerm_resource_group.rg.name
  private_dns_zone_name = azurerm_private_dns_zone.sql_private_dns.name
  virtual_network_id    = azurerm_virtual_network.vnet.id
  registration_enabled  = false
}

# Private Endpoint for Azure SQL or any other PaaS service
resource "azurerm_private_endpoint" "sql_private_endpoint" {
  name                = "${var.project_prefix}-sql-pe"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  subnet_id           = azurerm_subnet.application_subnet.id

  private_service_connection {
    name                           = "${var.project_prefix}-sql-psc"
    private_connection_resource_id = var.sql_server_id # ID of the Azure SQL server
    subresource_names              = ["sqlServer"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "sql-dns-zone-group"
    private_dns_zone_ids = [azurerm_private_dns_zone.sql_private_dns.id]
  }
}
