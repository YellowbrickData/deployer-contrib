locals {
  diags_bucket_name = (var.diags_bucket_name == null && var.create_yb_operator_infra) ? module.yb_operator_infra[0].yb_diags_bucket_name : var.diags_bucket_name
}

module "observability_infra" {
  source = "./modules/aws-observability-infra"

  count = var.create_observability_infra ? 1 : 0

  cluster_name      = var.cluster_name
  diags_bucket_name = module.yb_operator_infra.yb_diags_bucket_name
  namespace         = var.observability_namespace
  oidc_provider     = var.oidc_provider
  region            = var.region

  tags = var.tags
}


