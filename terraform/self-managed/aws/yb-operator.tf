module "yb_operator_infra" {
  source = "./modules/aws-yb-operator-infra"

  count = var.create_yb_operator_infra ? 1 : 0

  cluster_name      = var.cluster_name
  diags_bucket_name = var.diags_bucket_name
  namespace         = var.yb_operator_namespace
  node_role_arn     = var.node_role_arn
  oidc_provider     = var.oidc_provider
  region            = var.region

  tags = var.tags
}
