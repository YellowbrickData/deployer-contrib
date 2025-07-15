variable "load_balancer_name" {
  type        = string
  description = "Name of the load balancer"
}

variable "subnet_mappings" {
  type = list(object({
    subnet_id            = string
    private_ipv4_address = string
  }))
  description = "List of subnet mappings with static private IPs"
  validation {
    condition     = alltrue([for m in var.subnet_mappings : can(m.subnet_id) && can(m.private_ipv4_address)])
    error_message = "Each subnet_mapping must include both subnet_id and private_ipv4_address."
  }
}

variable "vpc_id" {
  type        = string
  description = "VPC ID for the load balancer"
}

variable "target_groups" {
  type = list(object({
    listener_port     = number
    listener_protocol = string
    target_group_name = string
  }))
  description = "List of target groups and listener configurations"
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to the load balancer"
  default     = {}
}
