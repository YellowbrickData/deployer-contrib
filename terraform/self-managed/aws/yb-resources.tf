module "yb_resources_helm" {
  source = "./modules/yb-resources-helm"

  chart                = var.yb_resources_chart
  chart_version        = var.yb_resources_chart_version
  cloud_provider       = "aws"
  namespace            = var.yb_operator_namespace
  registry             = var.registry
  storage_class_prefix = module.yb_storageclass_helm.storage_class_prefix

  depends_on = [
    module.yb_operator_helm
  ]
}
