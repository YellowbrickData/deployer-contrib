locals {
  subnet_cidrs = cidrsubnets(
    var.vnet_cidr,
    var.subnet_bits_firewall,
    var.subnet_bits_firewall_mgmt,
    var.subnet_bits_default
  )

  subnet_prefixes = {
    "firewall"      = [local.subnet_cidrs[0]],
    "firewall_mgmt" = [local.subnet_cidrs[1]],
    "default"       = [local.subnet_cidrs[2]],
  }
}

resource "azurerm_virtual_network" "this" {
  name = "${local.instance_name}-vnet"

  location            = var.azure_location
  resource_group_name = local.azure_resource_group
  address_space       = [var.vnet_cidr]

  tags = local.tags
}

resource "azurerm_subnet" "firewall" {
  name = "AzureFirewallSubnet"

  resource_group_name  = local.azure_resource_group
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = local.subnet_prefixes["firewall"]
}

resource "azurerm_subnet" "firewall_mgmt" {
  name = "AzureFirewallManagementSubnet"

  resource_group_name  = local.azure_resource_group
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = local.subnet_prefixes["firewall_mgmt"]
}

resource "azurerm_subnet" "default" {
  name = "${local.instance_name}-subnet-0"

  resource_group_name  = local.azure_resource_group
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = local.subnet_prefixes["default"]

  service_endpoints = [
    "Microsoft.Storage"
  ]
}

resource "azurerm_route_table" "default" {
  name                = "${local.instance_name}-route-table"
  location            = var.azure_location
  resource_group_name = local.azure_resource_group

  route {
    name                   = "route-firewall"
    address_prefix         = "0.0.0.0/0"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = azurerm_firewall.this.ip_configuration[0].private_ip_address
  }

  route {
    name           = "route-firewall-internet"
    address_prefix = "${azurerm_public_ip.external.ip_address}/32"
    next_hop_type  = "Internet"
  }

  tags = local.tags
}

resource "azurerm_subnet_route_table_association" "default" {
  subnet_id      = azurerm_subnet.default.id
  route_table_id = azurerm_route_table.default.id
}

resource "azurerm_public_ip" "external" {
  name                = "${local.instance_name}-external-ip-public"
  resource_group_name = local.azure_resource_group
  location            = var.azure_location
  allocation_method   = "Static"
  sku                 = "Standard"

  tags = local.tags
}
