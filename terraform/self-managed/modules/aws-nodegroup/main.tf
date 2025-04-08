resource "aws_launch_template" "this" {
  image_id               = var.ami_id
  instance_type          = var.instance_type
  key_name               = var.node_key_name
  name                   = "${var.node_group_name}-${var.cluster_name}"
  tags                   = var.tags
  user_data              = var.user_data
  vpc_security_group_ids = var.security_group_ids

  metadata_options {
    http_endpoint               = "enabled"
    http_put_response_hop_limit = 2
    http_tokens                 = "optional"
  }

  placement {
    group_name = var.placement_group_name
  }

  tag_specifications {
    resource_type = "instance"
    tags          = var.tags
  }
  tag_specifications {
    resource_type = "volume"
    tags          = var.tags
  }
}

resource "aws_eks_node_group" "this" {
  count = 1

  capacity_type   = var.capacity_type
  cluster_name    = var.cluster_name
  labels          = var.labels
  node_group_name = "${var.node_group_name}-${count.index}"
  node_role_arn   = var.node_role_arn
  subnet_ids      = [var.subnet_id]
  tags            = var.tags

  launch_template {
    id      = aws_launch_template.this.id
    version = "$Default"
  }

  lifecycle {
    ignore_changes = [
      scaling_config[0].desired_size,
    ]
  }

  dynamic "taint" {
    for_each = var.taints
    content {
      effect = value.effect
      key    = value.key
      value  = value.value
    }
  }

  scaling_config {
    desired_size = var.desired_size
    min_size     = var.min_size
    max_size     = var.max_size
  }

  update_config {
    max_unavailable_percentage = 100
  }
}
