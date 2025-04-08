module "ebs_csi_infra" {
  source = "./modules/aws-ebs-csi-infra"

  cluster_name  = var.cluster_name
  namespace     = var.ebs_csi_namespace
  oidc_provider = local.oidc_provider
  region        = var.region

  tags = var.tags
}

resource "aws_eks_addon" "ebs_csi" {
  addon_name                  = "aws-ebs-csi-driver"
  addon_version               = "v1.41.0-eksbuild.1"
  cluster_name                = data.aws_eks_cluster.this.name
  resolve_conflicts_on_create = "OVERWRITE"
  service_account_role_arn    = module.ebs_csi_infra.iam_role_arn

  tags = var.tags

  depends_on = [
    aws_iam_openid_connect_provider.this,
    module.ebs_csi_infra
  ]
}
