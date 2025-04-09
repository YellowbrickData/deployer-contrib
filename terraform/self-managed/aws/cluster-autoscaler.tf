module "cluster_autoscaler_infra" {
  source = "./modules/aws-cluster-autoscaler-infra"

  cluster_name  = var.cluster_name
  namespace     = var.cluster_autoscaler_namespace
  oidc_provider = var.oidc_provider
  region        = var.region

  tags = var.tags
}


