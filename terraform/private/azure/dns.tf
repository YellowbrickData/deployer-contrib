resource "azurerm_private_dns_zone" "privatelink_acr" {
  name                = "privatelink.azurecr.io"
  resource_group_name = local.azure_resource_group

  tags = local.tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "privatelink_acr" {
  name                  = "privatelink_acr"
  resource_group_name   = local.azure_resource_group
  private_dns_zone_name = azurerm_private_dns_zone.privatelink_acr.name
  virtual_network_id    = azurerm_virtual_network.this.id

  tags = local.tags
}

resource "azurerm_private_dns_zone" "privatelink_aks" {
  name                = "privatelink.${var.azure_location}.azmk8s.io"
  resource_group_name = local.azure_resource_group

  tags = local.tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "privatelink_aks" {
  name                  = "privatelink_aks"
  resource_group_name   = local.azure_resource_group
  private_dns_zone_name = azurerm_private_dns_zone.privatelink_aks.name
  virtual_network_id    = azurerm_virtual_network.this.id

  tags = local.tags
}
