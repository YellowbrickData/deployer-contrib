locals {
  node_role_arn        = var.node_role_arn == "" ? aws_iam_role.node[0].arn : var.node_role_arn
  oidc_provider        = replace(local.oidc_provider_url, "https://", "")
  oidc_provider_url    = var.oidc_provider_url == "" ? data.aws_eks_cluster.this.identity[0].oidc[0].issuer : var.oidc_provider_url
  placement_group_name = var.placement_group_name == "" ? aws_placement_group.this[0].name : var.placement_group_name
  security_group_ids   = length(var.security_group_ids) == 0 ? [data.aws_eks_cluster.this.vpc_config[0].cluster_security_group_id] : var.security_group_ids
}

data "aws_caller_identity" "current" {}

data "aws_ecr_authorization_token" "token" {}

data "aws_eks_cluster" "this" {
  name = var.cluster_name
}

data "aws_partition" "current" {}

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

variable "ami_id" {
  type = string
}

variable "cluster_autoscaler_chart" {
  description = "The name of the cluster-autoscaler chart."
  type        = string
}

variable "cluster_autoscaler_chart_version" {
  description = "The version of the cluster-autoscaler chart."
  type        = string
}

variable "cluster_autoscaler_image_repo" {
  type = string
}

variable "cluster_autoscaler_image_tag" {
  type = string
}

variable "cluster_autoscaler_namespace" {
  type    = string
  default = "kube-system"
}

variable "cluster_autoscaler_tolerations" {
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

variable "cluster_name" {
  type = string
}

variable "configmap_reload_image_repo" {
  description = "The configmap-reload image repository."
  type        = string
}

variable "configmap_reload_image_tag" {
  description = "The configmap-reload image tag."
  type        = string
}

variable "diags_bucket_name" {
  type    = string
  default = ""
}

variable "downloads_dashboard_image_repo" {
  description = "The downloads dashboard image repository."
  type        = string
}

variable "downloads_dashboard_image_tag" {
  description = "The downloads dashboard image tag."
  type        = string
}

variable "ebs_csi_namespace" {
  type    = string
  default = "kube-system"
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
      "effect" : "NoSchedule",
      "key" : "cluster.yellowbrick.io/owned",
      "operator" : "Equal",
      "value" : "true"
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
      "effect" : "NoSchedule",
      "key" : "cluster.yellowbrick.io/owned",
      "operator" : "Equal",
      "value" : "true"
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

variable "instance_name" {
  type = string
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

variable "loki_log_trimmer_image_repo" {
  description = "The Loki log trimmer image repository."
  type        = string
}

variable "loki_log_trimmer_image_tag" {
  description = "The Loki log trimmer image tag."
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

variable "nginx_image_repo" {
  type = string
}

variable "nginx_image_tag" {
  type = string
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

variable "node_group_subnet_id" {
  description = "The subnet ID for the operator nodegroup. This AZ will also be considered the primary AZ."
  type        = string
}

variable "node_key_name" {
  type    = string
  default = ""
}

variable "node_local_dns_chart" {
  type = string
}

variable "node_local_dns_chart_version" {
  type = string
}

variable "node_local_dns_image_repo" {
  type = string
}

variable "node_local_dns_image_tag" {
  type = string
}

variable "node_local_dns_namespace" {
  type    = string
  default = "kube-system"
}

variable "node_role_arn" {
  type    = string
  default = ""
}

variable "oidc_provider_url" {
  type    = string
  default = ""
}

variable "observability_chart" {
  description = "The name of the observability chart."
  type        = string
}

variable "observability_chart_version" {
  description = "The version of the observability chart."
  type        = string
}

variable "observability_ingress" {
  type    = bool
  default = false
}

variable "observability_namespace" {
  type    = string
  default = "yb-monitoring"
}

variable "operator_taints" {
  type = list(object({
    effect   = string
    key      = string
    operator = string
    value    = string
  }))
  default = []
}

variable "placement_group_name" {
  type    = string
  default = ""
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

variable "region" {
  type = string
}

variable "registry" {
  type = string
}

variable "security_group_ids" {
  type    = list(string)
  default = []
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

variable "tags" {
  type    = map(string)
  default = {}
}

variable "vpc_cni_namespace" {
  type    = string
  default = "kube-system"
}

variable "yb_manager_image_repo" {
  type = string
}

variable "yb_manager_image_tag" {
  type = string
}

variable "yb_operator_chart" {
  type = string
}

variable "yb_operator_chart_version" {
  type = string
}

variable "yb_operator_image_repo" {
  type = string
}

variable "yb_operator_image_tag" {
  type = string
}

variable "yb_operator_instance_type" {
  type    = string
  default = "t3.large"
}

variable "yb_operator_labels" {
  type = map(string)
  default = {
    "cluster.yellowbrick.io/hardware_type" = "t3.large",
    "cluster.yellowbrick.io/node_type"     = "yb-op-standard"
  }
}

variable "yb_operator_namespace" {
  type = string
}

variable "yb_operator_registry_host" {
  type = string
}

variable "yb_resources_chart" {
  type = string
}

variable "yb_resources_chart_version" {
  type = string
}

variable "yb_storageclass_allowed_topologies" {
  type    = list(any)
  default = []
}

variable "yb_storageclass_chart" {
  type = string
}

variable "yb_storageclass_chart_version" {
  type = string
}

variable "yb_storageclass_parameters" {
  type    = map(any)
  default = {}
}

variable "yb_storageclass_prefix" {
  type    = string
  default = "yb-"
}

variable "yb_template_image_repo" {
  type = string
}

variable "yb_template_image_tag" {
  type = string
}
