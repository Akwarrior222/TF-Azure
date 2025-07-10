provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_mssql_server" "sql_server" {
  name                         = var.sql_server_name
  resource_group_name          = azurerm_resource_group.rg.name
  location                     = azurerm_resource_group.rg.location
  version                      = "12.0"
  administrator_login          = var.admin_login
  administrator_login_password = var.admin_password

  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_mssql_database" "sql_db" {
  name           = var.sql_db_name
  server_id      = azurerm_mssql_server.sql_server.id
  sku_name       = var.sql_sku
  collation      = "SQL_Latin1_General_CP1_CI_AS"
  max_size_gb    = 5
  zone_redundant = false
  depends_on     = [azurerm_mssql_server.sql_server]
}
