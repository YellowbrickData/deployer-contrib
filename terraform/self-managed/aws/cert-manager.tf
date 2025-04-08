resource "aws_eks_addon" "cert_manager" {
  addon_name                  = "cert-manager"
  addon_version               = "v1.17.1-eksbuild.2"
  cluster_name                = data.aws_eks_cluster.this.name
  resolve_conflicts_on_create = "OVERWRITE"

  tags = var.tags

  depends_on = [
    module.operator_nodegroup
  ]
}
