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

## Deployer permissions

The deployer's identity (the installer VM's managed identity or a dedicated service principal) must be granted the custom role described in the [Yellowbrick Azure installation permissions documentation](https://docs.yellowbrick.com/latest/platforms/cloud/ee/cloud_install/cloud_install_permissions_azure.html), typically scoped to the resource group.

Note that in-place upgrades re-assert the AKS cluster's user-assigned identity (created by this Terraform as `<instance_name>-cluster`), which requires the deployer to hold `Microsoft.ManagedIdentity/userAssignedIdentities/assign/action` on that identity. This action is included in the documented custom role. If the deployer was granted an older version of the role that lacks it, either update the role definition to match the current documentation, or assign the built-in `Managed Identity Operator` role to the deployer, scoped to the cluster identity — otherwise upgrades fail with `LinkedAuthorizationFailed`.

## Creating a tfvars file

A typical installation will require the following variables:

```
azure_location                   = "eastus"
azure_resource_group_id          = "/subscriptions/subscription-id/resourceGroups/my-resource-group"
```

Please see `variables.tf` for descriptions for each variable.

## Azure Government

To deploy into Azure Government, select the Government cloud and a Government region in your tfvars:

```
azure_environment = "usgovernment"
azure_location    = "usgovvirginia"
```

All cloud-dependent endpoints and DNS zone names — the firewall egress FQDNs, the ARM and Entra login endpoints, the blob DNS suffix, and the AKS and container registry private-link zones — are resolved from `azure_environment`; no edits to the resources are required. The required Government egress FQDNs are listed in the "Azure US Government" section of the [Azure documentation](https://learn.microsoft.com/en-us/azure/aks/outbound-rules-control-egress) referenced above.

The operator running Terraform must be logged in to the Government cloud:

```
az cloud set --name AzureUSGovernment
az login
```

## Authentication

For authenticating, please see the [Terraform strategy](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/guides/azure_cli) that matches your needs.