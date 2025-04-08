resource "aws_eks_addon" "metrics_server" {
  addon_name                  = "metrics-server"
  addon_version               = "v0.7.2-eksbuild.2"
  cluster_name                = data.aws_eks_cluster.this.name
  resolve_conflicts_on_create = "OVERWRITE"

  depends_on = [
    module.operator_nodegroup
  ]
}
