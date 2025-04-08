output "aks_client_certificate" {
  value     = azurerm_kubernetes_cluster.this.kube_config[0].client_certificate
  sensitive = true
}

output "aks_kube_config" {
  value     = azurerm_kubernetes_cluster.this.kube_config_raw
  sensitive = true
}

output "external_public_ip_address" {
  value = azurerm_public_ip.external.ip_address
}

output "firewall_private_ip_address" {
  value = try(azurerm_firewall.this.ip_configuration[0].private_ip_address, null)
}

output "privatelink_aks_dns_zone_name" {
  value = azurerm_private_dns_zone.privatelink_aks.name
}

output "privatelink_acr_dns_zone_name" {
  value = azurerm_private_dns_zone.privatelink_acr.name
}

output "registry_host" {
  value = azurerm_container_registry.this.login_server
}

output "subnet_default_id" {
  value = azurerm_subnet.default.id
}

output "subnet_default_cidr" {
  value = azurerm_subnet.default.address_prefixes[0]
}

output "subnet_firewall_id" {
  value = try(azurerm_subnet.firewall.id, null)
}

output "subnet_firewall_mgmt_id" {
  value = try(azurerm_subnet.firewall_mgmt.id, null)
}

output "vnet_cidr" {
  value = tolist(azurerm_virtual_network.this.address_space)[0]
}

output "vnet_name" {
  value = azurerm_virtual_network.this.name
}
