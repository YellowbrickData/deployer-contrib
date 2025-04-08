variable "chart" {
  description = "Chart name to be installed."
  type        = string
}

variable "chart_version" {
  description = "Specify the exact chart version to install."
  type        = string
}

variable "cluster_name" {
  description = "Name of the k8s cluster."
  type        = string
}

variable "extra_values" {
  description = "Extra values to be passed to the chart."
  type        = any
  default     = {}
}

variable "namespace" {
  description = "Namespace to install the release into."
  type        = string
  default     = "kube-system"
}

variable "release_name" {
  description = "Release name. The length must not be longer than 53 characters."
  type        = string
  default     = "cluster-autoscaler"
}

variable "registry" {
  type = string
}
