resource "azurerm_container_registry" "this" {
  name                = local.azure_registry_name
  resource_group_name = local.azure_resource_group
  location            = var.azure_location

  admin_enabled                 = var.azure_registry_admin_enabled
  data_endpoint_enabled         = true
  public_network_access_enabled = true
  sku                           = "Premium"

  tags = local.tags
}

resource "azurerm_private_endpoint" "registry" {
  name                = "${local.instance_name}-registry"
  location            = var.azure_location
  resource_group_name = local.azure_resource_group
  subnet_id           = azurerm_subnet.default.id

  private_service_connection {
    name                           = "${local.instance_name}-registry"
    private_connection_resource_id = azurerm_container_registry.this.id
    subresource_names              = ["registry"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name = "${local.instance_name}-registry"
    private_dns_zone_ids = [
      azurerm_private_dns_zone.privatelink_acr.id
    ]
  }
}
