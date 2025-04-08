variable "chart" {
  description = "Chart name to be installed."
  type        = string
}

variable "chart_version" {
  description = "Specify the exact chart version to install."
  type        = string
}

variable "extra_values" {
  description = "Extra values to be passed to the chart."
  type        = any
  default     = {}
}

variable "image_repo" {
  description = "The repository where the image is stored."
  type        = string
}

variable "image_tag" {
  description = "The tag of the image to be used."
  type        = string
}

variable "namespace" {
  description = "Namespace to install the release into."
  type        = string
  default     = "kube-system"
}

variable "pillar_dns_server" {
  description = "Pillar DNS server IP address."
  type        = string
  default     = "10.0.0.10"
}

variable "release_name" {
  description = "Release name. The length must not be longer than 53 characters."
  type        = string
  default     = "node-local-dns"
}

variable "registry" {
  type = string
}
