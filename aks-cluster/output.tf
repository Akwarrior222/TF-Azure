output "cluster_name" {
  value = azurerm_kubernetes_cluster.main.name
}

output "cluster_location" {
  value = azurerm_kubernetes_cluster.main.location
}

output "aks_service_principal_id" {
  value = azurerm_kubernetes_cluster.main.identity[0].principal_id
}

output "cluster_id" {
  value = azurerm_kubernetes_cluster.main.id
}

output "subnet_id" {
  value = azurerm_subnet.subnet.id
}