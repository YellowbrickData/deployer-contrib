locals {
  security_group_ids = length(var.security_group_ids) == 0 ? [data.aws_eks_cluster.this.vpc_config[0].cluster_security_group_id] : var.security_group_ids
}

data "cloudinit_config" "simple" {
  gzip          = true
  base64_encode = true

  part {
    content_type = "text/cloud-config"
    content = templatefile("./assets/user-data-simple.yml.tpl", {
      certificate_authority = data.aws_eks_cluster.this.certificate_authority[0].data
      cluster_endpoint      = data.aws_eks_cluster.this.endpoint
      cluster_name          = data.aws_eks_cluster.this.id
      kubelet_extra_args    = "--cluster-dns=169.254.0.53"
    })
  }
}

module "yb_operator_nodegroup" {
  source = "./modules/aws-nodegroup"

  ami_id               = var.ami_id
  cluster_name         = var.cluster_name
  instance_type        = var.yb_operator_instance_type
  labels               = var.yb_operator_labels
  node_group_name      = "yb-op-standard"
  node_key_name        = var.node_key_name
  node_role_arn        = var.node_role_arn
  placement_group_name = local.placement_group_name
  security_group_ids   = local.security_group_ids
  subnet_id            = var.node_group_subnet_id
  taints               = var.yb_operator_nodegroup_taints
  user_data            = data.cloudinit_config.simple.rendered

  depends_on = [
    aws_placement_group.this
  ]

  tags = var.tags
}
