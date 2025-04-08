locals {
  instance_name = var.instance_name

  tags = {
    cluster_yellowbrick_io_name  = "${local.instance_name}"
    cluster_yellowbrick_io_owner = "yb-install"
  }
}

variable "instance_name" {
  type        = string
  description = "The name of the instance. This is used to name related resources."
}

variable "network_cidr" {
  default     = "10.200.0.0/16"
  description = "The network address space. This is only used to calculate subnet address space by bits."
}

variable "project" {
  type        = string
  description = "The GCP project to target."
}

variable "region" {
  type        = string
  description = "The GCP region to target."
}

variable "subnet_bits_private" {
  default     = 6
  description = "The number of addition bits for the subnet."
}

variable "zone" {
  type        = string
  description = "The subnet availability zone."
}
