resource "aws_lb" "this" {
  name               = var.load_balancer_name
  internal           = true
  load_balancer_type = "network"
  ip_address_type    = "ipv4"
  tags               = var.tags

  dynamic "subnet_mapping" {
    for_each = var.subnet_mappings
    content {
      subnet_id            = subnet_mapping.value.subnet_id
      private_ipv4_address = subnet_mapping.value.private_ipv4_address
    }
  }
}

data "aws_lb_target_group" "this" {
  for_each = { for tg in var.target_groups : tg.target_group_name => tg }
  name     = each.key
}

resource "aws_lb_listener" "this" {
  for_each = { for tg in var.target_groups : tg.target_group_name => tg }

  load_balancer_arn = aws_lb.this.arn
  port              = each.value.listener_port
  protocol          = each.value.listener_protocol
  tags              = var.tags

  default_action {
    type             = "forward"
    target_group_arn = data.aws_lb_target_group.this[each.key].arn
  }

}
