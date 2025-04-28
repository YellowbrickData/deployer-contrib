module "observability_infra" {
  source = "./modules/aws-observability-infra"

  cluster_name      = var.cluster_name
  diags_bucket_name = module.yb_operator_infra.yb_diags_bucket_name
  namespace         = var.observability_namespace
  oidc_provider     = var.oidc_provider
  region            = var.region

  tags = var.tags
}


