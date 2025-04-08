module "vpc_cni_infra" {
  source = "./modules/aws-vpc-cni-infra"

  cluster_name  = data.aws_eks_cluster.this.name
  namespace     = var.vpc_cni_namespace
  oidc_provider = local.oidc_provider
  region        = var.region
  tags          = var.tags
}

resource "aws_eks_addon" "vpc_cni" {
  addon_name                  = "vpc-cni"
  addon_version               = "v1.19.3-eksbuild.1"
  cluster_name                = data.aws_eks_cluster.this.name
  resolve_conflicts_on_create = "OVERWRITE"
  service_account_role_arn    = module.vpc_cni_infra.iam_role_arn

  configuration_values = jsonencode({
    env = {
      MINIMUM_IP_TARGET = "4"
      WARM_IP_TARGET    = "2"
    }
  })

  tags = var.tags

  depends_on = [
    aws_iam_openid_connect_provider.this,
    module.vpc_cni_infra
  ]
}



