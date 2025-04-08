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

  values = [
    yamlencode(merge(
      {
        "pillar_dns_server" : var.pillar_dns_server,
        "pillar_local_dns" : "169.254.0.53",
        "image" : {
          "repository" : "${var.image_repo}",
          "tag" : "${var.image_tag}"
        },
      }
      ,
    var.extra_values))
  ]
}
