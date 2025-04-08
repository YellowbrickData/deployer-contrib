resource "azurerm_resource_group" "this" {
  count = var.create_resource_group ? 1 : 0

  name     = local.azure_resource_group
  location = var.azure_location
}
