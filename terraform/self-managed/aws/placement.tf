locals {
  placement_group_name = (var.placement_group_name == null && var.create_placement_group) ? aws_placement_group.this[0].name : var.placement_group_name
}

resource "aws_placement_group" "this" {
  count = (var.placement_group_name == null && var.create_placement_group) ? 1 : 0

  name     = "yellowbrick-${var.cluster_name}"
  strategy = "partition"

  tags = var.tags
}
