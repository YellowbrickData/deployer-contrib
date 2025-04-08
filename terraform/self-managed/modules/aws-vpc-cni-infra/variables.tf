variable "cluster_name" {
  description = "The name of the EKS cluster."
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

variable "tags" {
  description = "Tags to apply to the resources."
  type        = map(string)
  default     = {}
}
