locals {
  firewall_nat_rules = []

  # https://learn.microsoft.com/en-us/azure/aks/outbound-rules-control-egress#azure-global-required-fqdn--application-rules
  hosts_required_install = [
    "*.data.mcr.microsoft.com",
    "*.hcp.${var.azure_location}.azmk8s.io",
    "acs-mirror.azureedge.net",
    "login.microsoftonline.com",
    "management.azure.com",
    "mcr-0001.mcr-msedge.net",
    "mcr.microsoft.com",
  ]
  host_required_provision = [
    "*.blob.core.windows.net",
    "aka.ms",
    "azure.archive.ubuntu.com",
    "packages.microsoft.com",
  ]
  hosts_all = concat(local.hosts_required_install, local.host_required_provision)
}

resource "azurerm_firewall" "this" {
  name                = "${local.instance_name}-firewall"
  location            = var.azure_location
  resource_group_name = local.azure_resource_group
  sku_name            = "AZFW_VNet"
  sku_tier            = var.azure_firewall_sku_tier

  firewall_policy_id = azurerm_firewall_policy.this.id

  ip_configuration {
    name                 = "cfg"
    subnet_id            = azurerm_subnet.firewall.id
    public_ip_address_id = azurerm_public_ip.external.id
  }

  management_ip_configuration {
    name                 = "cfg-mgmt"
    subnet_id            = azurerm_subnet.firewall_mgmt.id
    public_ip_address_id = azurerm_public_ip.firewall_mgmt.id
  }

  tags = local.tags
}

resource "azurerm_firewall_policy" "this" {
  name                = "${local.instance_name}-fwpolicy"
  resource_group_name = local.azure_resource_group
  location            = var.azure_location
  sku                 = var.azure_firewall_sku_tier

  tags = local.tags
}

resource "azurerm_firewall_policy_rule_collection_group" "this" {
  name               = "${local.instance_name}-fwpolicy-rcg"
  firewall_policy_id = azurerm_firewall_policy.this.id
  priority           = 500

  nat_rule_collection {
    name     = "inbound"
    priority = 100
    action   = "Dnat"

    dynamic "rule" {
      for_each = local.firewall_nat_rules
      content {
        name                = rule.value["name"]
        protocols           = rule.value["protocols"]
        source_addresses    = rule.value["source_addresses"]
        destination_address = rule.value["destination_address"]
        destination_ports   = rule.value["destination_ports"]
        translated_address  = rule.value["translated_address"]
        translated_port     = rule.value["translated_port"]
      }
    }
  }

  application_rule_collection {
    name     = "aks-application"
    priority = 500
    action   = "Allow"

    rule {
      name = "http-outbound"
      protocols {
        type = "Http"
        port = 80
      }
      source_addresses  = ["*"]
      destination_fqdns = local.hosts_all
    }

    rule {
      name = "https-outbound"
      protocols {
        type = "Https"
        port = 443
      }
      source_addresses  = ["*"]
      destination_fqdns = local.hosts_all
    }
  }
}

resource "azurerm_public_ip" "firewall_mgmt" {
  name                = "${local.instance_name}-fwmgmt-ip-public"
  resource_group_name = local.azure_resource_group
  location            = var.azure_location
  allocation_method   = "Static"
  sku                 = "Standard"

  tags = local.tags
}
