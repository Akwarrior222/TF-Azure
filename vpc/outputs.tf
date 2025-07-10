output "network" {
  value = azurerm_virtual_network.vnet.id
}

output "vnet_id" {
  value = azurerm_virtual_network.vnet.id
}

output "public_subnet" {
  value = azurerm_subnet.public_subnet.id
}

output "application_subnet" {
  value = azurerm_subnet.application_subnet.id
}

output "public_subnet_primary_cidr" {
  value = azurerm_subnet.public_subnet.address_prefixes[0]
}

output "application_subnet_primary_cidr" {
  value = azurerm_subnet.application_subnet.address_prefixes[0]
}

output "public_subnet_cidrs" {
  value = azurerm_subnet.public_subnet.address_prefixes
}

output "application_subnet_cidrs" {
  value = azurerm_subnet.application_subnet.address_prefixes
}

output "all_subnet_cidrs" {
  value = concat(
    azurerm_subnet.public_subnet.address_prefixes,
    azurerm_subnet.application_subnet.address_prefixes,
  )
}
