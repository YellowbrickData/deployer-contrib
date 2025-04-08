variable "allowed_topologies" {
  description = "Allowed topologies for the storage class."
  type        = list(any)
  default     = []
}

variable "chart" {
  description = "Chart name to be installed."
  type        = string
}

variable "chart_version" {
  description = "Specify the exact chart version to install."
  type        = string
}

variable "cloud_provider" {
  description = "Cloud provider to be used."
  type        = string
}

variable "create_namespace" {
  description = "Create the namespace if it does not exist."
  type        = bool
  default     = true
}

variable "extra_values" {
  description = "Extra values to be passed to the chart."
  type        = any
  default     = {}
}

variable "namespace" {
  description = "Namespace to install the release into."
  type        = string
}

variable "parameters" {
  description = "Parameters for the storage class."
  type        = map(string)
  default     = {}
}

variable "release_name" {
  description = "Release name. The length must not be longer than 53 characters."
  type        = string
  default     = "yb-storageclass"
}

variable "registry" {
  type = string
}

variable "storage_class_prefix" {
  description = "Prefix for the storage class name."
  type        = string
  default     = ""
}

