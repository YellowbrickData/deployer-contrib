provider "azurerm" {
  environment                     = var.azure_environment
  resource_provider_registrations = "none"
  features {}
}
