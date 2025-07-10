output "server_id" {
  value = azurerm_linux_virtual_machine.vm.id
}

output "server_zone" {
  value = azurerm_linux_virtual_machine.vm.zone
}

output "server_subnet_id" {
  value = var.subnet_id
}

output "server_private_ip" {
  value = azurerm_network_interface.nic.private_ip_address
}

# Optional Public IP Output
# Uncomment if using a public IP
# output "server_public_ip" {
#   value = azurerm_public_ip.public[0].ip_address
# }
