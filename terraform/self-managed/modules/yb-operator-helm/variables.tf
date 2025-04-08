locals {
  yb_operator_chart_parts = split("/", var.yb_operator_chart)

  # The chart is always the last part of the array
  chart = local.yb_operator_chart_parts[
    length(local.yb_operator_chart_parts) - 1
  ]

  # If there is only one part, repository = var.registry
  # Otherwise, repository = var.registry + (all parts but the last) joined by "/"
  operator_repo = length(local.yb_operator_chart_parts) > 1 ? join("/", [var.registry, join("/", slice(local.yb_operator_chart_parts, 0, length(local.yb_operator_chart_parts) - 1))]) : var.registry
}

variable "cloud_provider" {
  description = "The cloud provider to use."
  type        = string
}

variable "cluster_name" {
  description = "Name of the k8s cluster."
  type        = string
}

variable "create_namespace" {
  description = "Create the namespace if it does not exist."
  type        = bool
  default     = true
}

variable "diags_bucket_name" {
  description = "The name of the diagnostics bucket."
  type        = string
}

variable "extra_values" {
  description = "Extra values to be passed to the chart."
  type        = any
  default     = {}
}

variable "instance_name" {
  description = "Name of the instance."
  type        = string
}

variable "namespace" {
  description = "Namespace to install the release into."
  type        = string
}

variable "nginx_image_repo" {
  description = "The nginx image repository."
  type        = string
}

variable "nginx_image_tag" {
  description = "The nginx image tag."
  type        = string
}

variable "node_selector" {
  description = "The node selector for the YB manager."
  type        = map(string)
}

variable "observabilty_namespace" {
  description = "The name of the observability namespace."
  type        = string
}

variable "release_name" {
  description = "Release name. The length must not be longer than 53 characters."
  type        = string
  default     = "yb-operator"
}

variable "region" {
  description = "The provider region."
  type        = string
}

variable "registry" {
  type = string
}

variable "registry_host" {
  type = string
}

variable "storage_class" {
  description = "The storage class to use."
  type        = string
}

variable "tolerations" {
  type = list(object({
    effect   = string
    key      = string
    operator = string
    value    = string
  }))
  default = [
    {
      effect   = "NoSchedule"
      key      = "cluster.yellowbrick.io/owned"
      operator = "Equal"
      value    = "true"
    }
  ]
}

variable "yb_compute_cluster_role_arn" {
  description = "The ARN of the YB compute cluster."
  type        = string
}

variable "yb_diags_role_arn" {
  description = "The ARN of the IAM role to be used by the YB diags."
  type        = string
}

variable "yb_manager_image_repo" {
  description = "The container image repo for the YB manager."
  type        = string
}

variable "yb_manager_image_tag" {
  description = "The container image tag for the YB manager."
  type        = string
}

variable "yb_manager_role_arn" {
  description = "The ARN of the IAM role to be used by the YB manager."
  type        = string
}

variable "yb_operator_chart" {
  description = "Chart name to be installed. A path may be used."
  type        = string
}

variable "yb_operator_chart_version" {
  description = "Specify the exact chart version to install."
  type        = string
}

variable "yb_operator_image_repo" {
  type = string
}

variable "yb_operator_image_tag" {
  description = "The container image tag for the YB operator."
  type        = string
}

variable "yb_operator_role_arn" {
  description = "The ARN of the IAM role to be used by the YB operator."
  type        = string
}

variable "yb_template_image_repo" {
  description = "The container image repo for the YB template."
  type        = string
}

variable "yb_template_image_tag" {
  description = "The container image tag for the YB template."
  type        = string
}

