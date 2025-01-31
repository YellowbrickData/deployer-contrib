# Yellowbrick Reference Terraform for Azure

The purpose of this Terraform is to provide a reference architecture for installing Yellowbrick with an existing or private network. Customization is expected. Please refer to the Yellowbrick Azure Private Instructions documentation for more information.

## Infrastructure

This Terraform will create:

- virtual network
- 3 subnets
  - firewall
  - firewall management
  - default
- firewall
- public address (for firewall)
- route tables
- container registry
- aks cluster
- node pools
  - system
  - yb operator
  - monitoring
- private endpoint
  - container registry
- private dns zones
  - privatelink container registry
  - privatelink aks
- user-assigned identity
  - aks cluster
    - network contributor scoped to virtual network
    - network contributor scope to route table
    - private dns zone contributor scoped to aks privatelink dns zone

Some specific outbound connections must be allowed for proper AKS creation. Please see the [Azure documentation](https://learn.microsoft.com/en-us/azure/aks/outbound-rules-control-egress#azure-global-required-fqdn--application-rules) for additional information.

No inbound firewall rules or bastion hosts are given in this reference. You may consider custom firewall rules if applicable. Example of inbound SSH and HTTPS to a bastion host:

```hcl
locals {
  firewall_nat_rules = [
    {
      name                = "inbound-22"
      protocols           = ["TCP"]
      source_addresses    = var.allowlist_cidrs
      destination_address = azurerm_public_ip.external.ip_address
      destination_ports   = ["22"]
      translated_address  = azurerm_network_interface.admin.private_ip_address
      translated_port     = "22"
    },
    {
      name                = "inbound-443"
      protocols           = ["TCP"]
      source_addresses    = var.allowlist_cidrs
      destination_address = azurerm_public_ip.external.ip_address
      destination_ports   = ["443"]
      translated_address  = azurerm_network_interface.admin.private_ip_address
      translated_port     = "443"
    }
  ]
}
```

... and add this block to `azurerm_firewall_policy_rule_collection_group.this`:

```hcl
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
```

## Creating a tfvars file

A typical installation will require the following variables:

```
azure_location                   = "eastus"
azure_resource_group_id          = "/subscriptions/subscription-id/resourceGroups/my-resource-group"
```

Please see `variables.tf` for descriptions for each variable.

