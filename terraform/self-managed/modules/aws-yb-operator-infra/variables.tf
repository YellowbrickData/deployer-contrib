data "aws_caller_identity" "current" {}
data "aws_partition" "current" {}

variable "cluster_name" {
  description = "The name of the EKS cluster."
  type        = string
}

variable "namespace" {
  description = "The Kubernetes namespace for the cluster autoscaler."
  type        = string
}

variable "node_role_arn" {
  description = "The ARN of the IAM role for the EKS nodes."
  type        = string
}

variable "diags_bucket_name" {
  description = "The name of the S3 bucket for diagnostics."
  type        = string
  default     = ""
}

variable "oidc_provider" {
  description = "The OIDC provider URL."
  type        = string
}

variable "region" {
  description = "The AWS region."
  type        = string
}

variable "tags" {
  description = "Tags to apply to the resources."
  type        = map(string)
  default     = {}
}
