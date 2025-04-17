resource "aws_eks_addon" "cert_manager" {
  count = var.create_cert_manager ? 1 : 0

  addon_name                  = "cert-manager"
  addon_version               = var.cert_manager_version
  cluster_name                = data.aws_eks_cluster.this.name
  resolve_conflicts_on_create = "OVERWRITE"

  tags = var.tags
}
