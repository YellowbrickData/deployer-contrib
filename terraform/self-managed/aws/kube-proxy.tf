resource "aws_eks_addon" "kube_proxy" {
  addon_name                  = "kube-proxy"
  addon_version               = "v1.31.3-eksbuild.2"
  cluster_name                = data.aws_eks_cluster.this.name
  resolve_conflicts_on_create = "OVERWRITE"

  depends_on = [
    module.operator_nodegroup
  ]
}
