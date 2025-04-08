resource "aws_placement_group" "this" {
  count = var.placement_group_name == "" ? 1 : 0

  name     = "yellowbrick-${var.cluster_name}"
  strategy = "partition"
  tags     = var.tags
}

resource "aws_iam_role" "node" {
  count = var.node_role_arn == "" ? 1 : 0

  name = "yb-eks-node-${data.aws_eks_cluster.this.name}-${var.region}"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_eks_access_entry" "node" {
  count = var.node_role_arn == "" ? 1 : 0

  cluster_name  = var.cluster_name
  principal_arn = aws_iam_role.node[0].arn
  type          = "EC2_LINUX"
}

resource "aws_iam_role_policy_attachment" "node_role_AmazonEKSWorkerNodePolicy" {
  count = var.node_role_arn == "" ? 1 : 0

  policy_arn = "arn:${data.aws_partition.current.partition}:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.node[0].name
}

resource "aws_iam_role_policy_attachment" "node_role_AmazonEC2ContainerRegistryPullOnly" {
  count = var.node_role_arn == "" ? 1 : 0

  policy_arn = "arn:${data.aws_partition.current.partition}:iam::aws:policy/AmazonEC2ContainerRegistryPullOnly"
  role       = aws_iam_role.node[0].name
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

module "operator_nodegroup" {
  source = "./modules/aws-nodegroup"

  ami_id               = var.ami_id
  cluster_name         = var.cluster_name
  instance_type        = var.yb_operator_instance_type
  labels               = var.yb_operator_labels
  node_group_name      = "yb-op-standard"
  node_key_name        = var.node_key_name
  node_role_arn        = local.node_role_arn
  placement_group_name = local.placement_group_name
  security_group_ids   = local.security_group_ids
  subnet_id            = var.node_group_subnet_id
  tags                 = var.tags
  taints               = var.operator_taints
  user_data            = data.cloudinit_config.simple.rendered

  depends_on = [
    aws_iam_role.node[0],
    aws_eks_access_entry.node[0],
    aws_iam_role_policy_attachment.node_role_AmazonEKSWorkerNodePolicy[0],
    aws_iam_role_policy_attachment.node_role_AmazonEC2ContainerRegistryPullOnly[0],
  ]
}
