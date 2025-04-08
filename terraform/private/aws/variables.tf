locals {
  instance_name = var.instance_name

  tags = {
    cluster_yellowbrick_io_name  = "${local.instance_name}"
    cluster_yellowbrick_io_owner = "yb-install"
  }
}

variable "aws_region" {
  type        = string
  description = "The AWS region to deploy to"
}

variable "instance_name" {
  type        = string
  description = "The name of the instance. This is used to tag resources."
}

variable "primary_zone" {
  type        = string
  description = "The primary availability zone"
}

variable "secondary_zone" {
  type        = string
  description = "The primary secondary zone. This will be mostly unused."
}

variable "subnet_bits_public" {
  default     = 12
  description = "The number of additional bits for the public NAT gateway subnet"
}

variable "subnet_bits_primary" {
  default     = 6
  description = "The number of addition bits for the primary private subnet"
}

variable "subnet_bits_secondary" {
  default     = 10
  description = "The number of addition bits for the secondary private subnet"
}

variable "vpc_cidr" {
  default     = "10.200.0.0/16"
  description = "The address space to use for the VPC."
}
