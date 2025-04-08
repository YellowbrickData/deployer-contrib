locals {
  chart_parts = split("/", var.chart)

  # The chart is always the last part of the array
  chart = local.chart_parts[
    length(local.chart_parts) - 1
  ]

  # If there is only one part, repository = var.registry
  # Otherwise, repository = var.registry + (all parts but the last) joined by "/"
  repository = length(local.chart_parts) > 1 ? join("/", [var.registry, join("/", slice(local.chart_parts, 0, length(local.chart_parts) - 1))]) : var.registry
}

resource "helm_release" "this" {
  chart      = local.chart
  version    = var.chart_version
  name       = var.release_name
  namespace  = var.namespace
  repository = local.repository

  create_namespace = var.create_namespace

  values = [
    yamlencode(merge(
      {
        "cloudProvider" : var.cloud_provider,
        "storageClass" : {
          "allowedTopologies" : var.allowed_topologies,
          "parameters" : var.parameters
          "prefix" : var.storage_class_prefix,
        }
      },
    var.extra_values))
  ]
}
