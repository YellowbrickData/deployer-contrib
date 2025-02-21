locals {
  azure_registry_name     = substr(join("", [local.instance_name, sha1(var.azure_resource_group_id)]), 0, 50)
  azure_resource_group    = element(local.azure_resource_group_id, length(local.azure_resource_group_id) - 1)
  azure_resource_group_id = split("/", var.azure_resource_group_id)
  instance_name           = var.instance_name

  tags = {
    cluster_yellowbrick_io_creator = "yb-install"
    cluster_yellowbrick_io_owner   = "yb-install"
  }
}

variable "aks_admin_group_object_ids" {
  type        = list(string)
  default     = []
  description = "The object IDs of the Azure AD groups that will have admin access to the AKS cluster"
}

variable "aks_dns_prefix" {
  type        = string
  default     = "yb-aks"
  description = "Specifies the DNS prefix to use with private clusters. Possible values must begin and end with a letter or number, contain only letters, numbers, and hyphens and be between 1 and 54 characters in length. Changing this forces a new resource to be created"
}

variable "aks_allowlist_cidrs" {
  type        = list(string)
  default     = []
  description = "The list of CIDRs that are allowed to access the Kubernetes API server."
}

variable "aks_version" {
  type        = string
  default     = "1.30"
  description = "The version of the Kubernetes cluster to deploy."
}

variable "azure_firewall_sku_tier" {
  type        = string
  default     = "Standard"
  description = "value must be Standard or Premium"
}

variable "azure_location" {
  type        = string
  description = "value must be a valid Azure region"
}

variable "azure_registry_admin_enabled" {
  type        = bool
  default     = false
  description = "Enable admin user for the Azure Container Registry"
}

variable "azure_resource_group_id" {
  type        = string
  description = "The Azure resource group ID"
}

variable "create_resource_group" {
  type        = bool
  default     = false
  description = "Create the Azure resource group"
}

variable "instance_name" {
  type        = string
  description = "The name of the instance. This will be used to prefix resources. Please use only numbers, letters, or hyphens < 20 characters."
}

variable "subnet_bits_default" {
  type        = number
  default     = 6
  description = "The number of additional bits to extend the hub VPC CIDR for the default subnet"
}

variable "subnet_bits_firewall" {
  type        = number
  default     = 10
  description = "The number of additional bits to extend the hub VPC CIDR for the firewall subnet"
}

variable "subnet_bits_firewall_mgmt" {
  type        = number
  default     = 10
  description = "The number of additional bits to extend the hub VPC CIDR for the firewall management subnet"
}

variable "vnet_cidr" {
  default     = "10.200.0.0/16"
  description = "The CIDR block for the virtual network"
}
