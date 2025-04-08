variable "cluster_name" {
  description = "The name of the EKS cluster."
  type        = string
}

variable "diags_bucket_name" {
  description = "The name of the S3 bucket for diagnostics."
  type        = string
}

variable "namespace" {
  description = "The Kubernetes namespace for the cluster autoscaler."
  type        = string
}

variable "oidc_provider" {
  description = "The OIDC provider URL."
  type        = string
}

variable "region" {
  description = "The AWS region."
  type        = string
}

variable "release_name" {
  description = "The name of the Loki Helm release."
  type        = string
  default     = "loki"
}

variable "tags" {
  description = "Tags to apply to the resources."
  type        = map(string)
  default     = {}
}
