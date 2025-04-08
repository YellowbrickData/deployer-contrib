resource "aws_eks_addon" "coredns" {
  addon_name                  = "coredns"
  addon_version               = "v1.11.4-eksbuild.2"
  cluster_name                = data.aws_eks_cluster.this.name
  resolve_conflicts_on_create = "OVERWRITE"

  depends_on = [
    module.operator_nodegroup
  ]
}
