module "node_local_dns_helm" {
  source = "./modules/node-local-dns-helm"

  chart         = var.node_local_dns_chart
  chart_version = var.node_local_dns_chart_version
  image_repo    = var.node_local_dns_image_repo
  image_tag     = var.node_local_dns_image_tag
  registry      = var.registry

  depends_on = [
    module.operator_nodegroup
  ]
}
