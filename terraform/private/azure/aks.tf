resource "azurerm_user_assigned_identity" "aks_cluster" {
  name                = "${local.instance_name}-cluster"
  resource_group_name = local.azure_resource_group
  location            = var.azure_location
}

resource "azurerm_role_assignment" "aks_cluster_network_contributor" {
  scope                = azurerm_virtual_network.this.id
  role_definition_name = "Network Contributor"
  principal_id         = azurerm_user_assigned_identity.aks_cluster.principal_id
}

resource "azurerm_role_assignment" "aks_cluster_private_dns_zone_contributor" {
  scope                = azurerm_private_dns_zone.privatelink_aks.id
  role_definition_name = "Private DNS Zone Contributor"
  principal_id         = azurerm_user_assigned_identity.aks_cluster.principal_id
}

resource "azurerm_role_assignment" "aks_cluster_route_table_contributor" {
  scope                = azurerm_route_table.default.id
  role_definition_name = "Network Contributor"
  principal_id         = azurerm_user_assigned_identity.aks_cluster.principal_id
}

resource "azurerm_kubernetes_cluster" "this" {
  name                = local.instance_name
  location            = var.azure_location
  resource_group_name = local.azure_resource_group

  azure_policy_enabled                = true
  dns_prefix_private_cluster          = local.instance_name
  kubernetes_version                  = var.aks_version
  local_account_disabled              = false
  oidc_issuer_enabled                 = true
  private_cluster_enabled             = true
  private_cluster_public_fqdn_enabled = false
  private_dns_zone_id                 = azurerm_private_dns_zone.privatelink_aks.id
  workload_identity_enabled           = true

  sku_tier = "Standard"

  api_server_access_profile {
    authorized_ip_ranges = var.aks_allowlist_cidrs
  }

  auto_scaler_profile {
    balance_similar_node_groups      = false
    expander                         = "random"
    empty_bulk_delete_max            = "10"
    max_graceful_termination_sec     = "600"
    max_node_provisioning_time       = "15m"
    max_unready_percentage           = "45"
    new_pod_scale_up_delay           = "0s"
    max_unready_nodes                = "3"
    scale_down_delay_after_add       = "10m"
    scale_down_delay_after_delete    = "10s"
    scale_down_delay_after_failure   = "3m"
    scale_down_unneeded              = "10m"
    scale_down_unready               = "10m"
    scale_down_utilization_threshold = "0.5"
    scan_interval                    = "10s"
    skip_nodes_with_local_storage    = false
    skip_nodes_with_system_pods      = true
  }

  azure_active_directory_role_based_access_control {
    admin_group_object_ids = var.aks_admin_group_object_ids
    azure_rbac_enabled     = true
  }


  default_node_pool {
    name = "akssystem"

    node_count = 3
    max_count  = 5
    min_count  = 3

    vnet_subnet_id         = azurerm_subnet.default.id
    node_public_ip_enabled = false

    auto_scaling_enabled = true
    orchestrator_version = var.aks_version

    vm_size                 = "Standard_D4ds_v5"
    os_disk_size_gb         = 128
    os_disk_type            = "Managed"
    kubelet_disk_type       = "OS"
    type                    = "VirtualMachineScaleSets"
    host_encryption_enabled = false
    ultra_ssd_enabled       = false
    os_sku                  = "Ubuntu"
    fips_enabled            = false

    node_labels = {
      "cluster.yellowbrick.io/node_type" : "akssystem",
      "cluster.yellowbrick.io/hardware_type" : "Standard_D4ds_v5"
    }
  }

  identity {
    type = "UserAssigned"
    identity_ids = [
      azurerm_user_assigned_identity.aks_cluster.id
    ]
  }

  network_profile {
    load_balancer_sku = "standard"
    network_plugin    = "kubenet"
    outbound_type     = "userDefinedRouting"
    pod_cidr          = "10.244.0.0/16"
    service_cidr      = "10.0.0.0/16"
    dns_service_ip    = "10.0.0.10"
  }

  storage_profile {
    snapshot_controller_enabled = true
  }

  depends_on = [
    azurerm_role_assignment.aks_cluster_network_contributor,
    azurerm_role_assignment.aks_cluster_private_dns_zone_contributor,
    azurerm_role_assignment.aks_cluster_route_table_contributor,
    azurerm_firewall_policy_rule_collection_group.this
  ]

  tags = local.tags
}

resource "azurerm_kubernetes_cluster_node_pool" "operator" {
  name                  = "ybsystem"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.this.id

  node_count = 1
  max_count  = 5
  min_count  = 1

  vnet_subnet_id         = azurerm_subnet.default.id
  node_public_ip_enabled = false

  auto_scaling_enabled = true
  orchestrator_version = var.aks_version

  vm_size                 = "Standard_D4ds_v5"
  os_disk_size_gb         = 128
  os_disk_type            = "Managed"
  kubelet_disk_type       = "OS"
  host_encryption_enabled = false
  ultra_ssd_enabled       = false
  os_sku                  = "Ubuntu"
  fips_enabled            = false

  node_labels = {
    "cluster.yellowbrick.io/node_type" : "yb-operator",
    "cluster.yellowbrick.io/hardware_type" : "Standard_D4ds_v5",
    "cluster.yellowbrick.io/owned" : "true"
  }

  node_taints = [
    "cluster.yellowbrick.io/owned=true:NoSchedule"
  ]

  tags = local.tags
}
