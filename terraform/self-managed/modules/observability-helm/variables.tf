locals {
  chart_parts = split("/", var.chart)

  # The chart is always the last part of the array
  chart = local.chart_parts[
    length(local.chart_parts) - 1
  ]

  # If there is only one part, repository = var.registry
  # Otherwise, repository = var.registry + (all parts but the last) joined by "/"
  repository = length(local.chart_parts) > 1 ? join("/", [var.registry, join("/", slice(local.chart_parts, 0, length(local.chart_parts) - 1))]) : var.registry
}

variable "alertmanager_image_repo" {
  description = "The Alertmanager image repository."
  type        = string
}

variable "alertmanager_image_tag" {
  description = "The Alertmanager image tag."
  type        = string
}

variable "alertmanager_node_selector" {
  description = "Node selector for the Prometheus Alertmanager."
  type        = map(string)
  default = {
    "cluster.yellowbrick.io/node_type" = "yb-mon-standard"
  }
}

variable "alertmanager_tolerations" {
  description = "Tolerations for the Prometheus Alertmanager."
  type = list(object({
    key      = string
    operator = string
    value    = string
    effect   = string
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

variable "chart" {
  description = "Chart name to be installed. A path may be used."
  type        = string
}

variable "chart_version" {
  description = "Specify the exact chart version to install."
  type        = string
}

variable "cloud_provider" {
  description = "The cloud provider to use."
  type        = string
}

variable "configmap_reload_image_repo" {
  description = "The configmap-reload image repository."
  type        = string
}

variable "configmap_reload_image_tag" {
  description = "The configmap-reload image tag."
  type        = string
}

variable "create_namespace" {
  description = "Create the namespace if it does not exist."
  type        = bool
  default     = true
}

variable "downloads_dashboard_image_repo" {
  description = "The downloads dashboard image repository."
  type        = string
}

variable "downloads_dashboard_image_tag" {
  description = "The downloads dashboard image tag."
  type        = string
}

variable "extra_values" {
  description = "Extra values to be passed to the chart."
  type        = any
  default     = {}
}

variable "fluent_bit_image_repo" {
  description = "The fluent-bit image repository."
  type        = string
}

variable "fluent_bit_image_tag" {
  description = "The fluent-bit image tag."
  type        = string
}

variable "fluent_bit_node_selector" {
  description = "The node selector for the fluent-bit daemonset."
  type        = map(string)
  default = {
    "cluster.yellowbrick.io/owned" : "true"
  }
}

variable "fluent_bit_role_arn" {
  description = "The role ARN for the fluent-bit daemonset."
  type        = string
}

variable "fluent_bit_tolerations" {
  description = "The tolerations for the fluent-bit daemonset."
  type = list(object({
    key      = string
    operator = string
    value    = string
    effect   = string
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

variable "grafana_image_repo" {
  description = "The Grafana image repository."
  type        = string
}

variable "grafana_image_tag" {
  description = "The Grafana image tag."
  type        = string
}

variable "grafana_node_selector" {
  description = "The node selector for the Grafana deployment."
  type        = map(string)
  default = {
    "cluster.yellowbrick.io/node_type" : "yb-mon-standard"
  }
}

variable "grafana_sidecar_image_repo" {
  description = "The Grafana sidecar image repository."
  type        = string
}

variable "grafana_sidecar_image_tag" {
  description = "The Grafana sidecar image tag."
  type        = string
}

variable "grafana_storage_class" {
  description = "The storage class for the Grafana persistent volume."
  type        = string
}

variable "grafana_tolerations" {
  description = "The tolerations for the Grafana deployment."
  type = list(object({
    key      = string
    operator = string
    value    = string
    effect   = string
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

variable "init_chown_data_image_repo" {
  description = "The init-chown-data image repository."
  type        = string
}

variable "init_chown_data_image_tag" {
  description = "The init-chown-data image tag."
  type        = string
}

variable "ingress" {
  description = "Ingress configuration."
  type        = bool
  default     = false
}

variable "kube_state_metrics_image_repo" {
  description = "The kube-state-metrics image repository."
  type        = string
}

variable "kube_state_metrics_image_tag" {
  description = "The kube-state-metrics image tag."
  type        = string
}

variable "kube_state_metrics_node_selector" {
  description = "Node selector for the kube-state-metrics."
  type        = map(string)
  default = {
    "cluster.yellowbrick.io/node_type" = "yb-mon-standard"
  }
}

variable "kube_state_metrics_tolerations" {
  description = "Tolerations for the kube-state-metrics."
  type = list(object({
    key      = string
    operator = string
    value    = string
    effect   = string
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

variable "loki_image_repo" {
  description = "The Loki image repository."
  type        = string
}

variable "loki_image_tag" {
  description = "The Loki image tag."
  type        = string
}

variable "loki_node_selector" {
  description = "Node selector for the Loki pods."
  type        = map(string)
  default = {
    "cluster.yellowbrick.io/node_type" = "yb-mon-standard"
  }
}

variable "loki_tolerations" {
  description = "Tolerations for the Loki pods."
  type = list(object({
    key      = string
    operator = string
    value    = string
    effect   = string
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

variable "loki_log_trimmer_image_repo" {
  description = "The Loki log trimmer image repository."
  type        = string
}

variable "loki_log_trimmer_image_tag" {
  description = "The Loki log trimmer image tag."
  type        = string
}

variable "namespace" {
  description = "Namespace to install the release into."
  type        = string
}

variable "node_exporter_image_repo" {
  description = "The node-exporter image repository."
  type        = string
}

variable "node_exporter_image_tag" {
  description = "The node-exporter image tag."
  type        = string
}

variable "node_exporter_node_selector" {
  description = "Node selector for the Prometheus Node Exporter."
  type        = map(string)
  default = {
    "cluster.yellowbrick.io/owned" = "true"
  }
}

variable "node_exporter_tolerations" {
  description = "Tolerations for the Prometheus Node Exporter."
  type = list(object({
    key      = string
    operator = string
    value    = string
    effect   = string
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

variable "node_selector" {
  description = "The node selector for the YB manager."
  type        = map(string)
}

variable "process_exporter_image_repo" {
  description = "The process-exporter image repository."
  type        = string
}

variable "process_exporter_image_tag" {
  description = "The process-exporter image tag."
  type        = string
}

variable "process_exporter_node_selector" {
  description = "Node selector for the Prometheus Process Exporter."
  type        = map(string)
  default = {
    "cluster.yellowbrick.io/owned" = "true"
  }
}

variable "process_exporter_tolerations" {
  description = "Tolerations for the Prometheus Process Exporter."
  type = list(object({
    key      = string
    operator = string
    value    = string
    effect   = string
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

variable "prometheus_server_image_repo" {
  description = "The Prometheus server image repository."
  type        = string
}

variable "prometheus_server_image_tag" {
  description = "The Prometheus server image tag."
  type        = string
}

variable "prometheus_node_selector" {
  description = "Node selector for the main Prometheus server."
  type        = map(string)
  default = {
    "cluster.yellowbrick.io/node_type" = "yb-mon-standard"
  }
}

variable "prometheus_tolerations" {
  description = "Tolerations for the main Prometheus server."
  type = list(object({
    key      = string
    operator = string
    value    = string
    effect   = string
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

variable "pushgateway_image_repo" {
  description = "The Pushgateway image repository."
  type        = string
}

variable "pushgateway_image_tag" {
  description = "The Pushgateway image tag."
  type        = string
}

variable "pushgateway_node_selector" {
  description = "Node selector for the Prometheus Pushgateway."
  type        = map(string)
  default = {
    "cluster.yellowbrick.io/node_type" = "yb-mon-standard"
  }
}

variable "pushgateway_tolerations" {
  description = "Tolerations for the Prometheus Pushgateway."
  type = list(object({
    key      = string
    operator = string
    value    = string
    effect   = string
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

variable "registry" {
  type = string
}
