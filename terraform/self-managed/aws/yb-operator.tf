module "yb_operator_infra" {
  source = "./modules/aws-yb-operator-infra"

  cluster_name  = var.cluster_name
  namespace     = var.yb_operator_namespace
  node_role_arn = var.node_role_arn
  oidc_provider = var.oidc_provider
  region        = var.region

  tags = var.tags
}
