module "observability_infra" {
  source = "./modules/aws-observability-infra"

  cluster_name      = var.cluster_name
  diags_bucket_name = module.yb_operator_infra.diags_bucket_name
  namespace         = var.cluster_autoscaler_namespace
  oidc_provider     = local.oidc_provider
  region            = var.region
  tags              = var.tags
}

module "observability_helm" {
  source = "./modules/observability-helm"

  alertmanager_image_repo        = var.alertmanager_image_repo
  alertmanager_image_tag         = var.alertmanager_image_tag
  chart                          = var.observability_chart
  chart_version                  = var.observability_chart_version
  cloud_provider                 = "aws"
  configmap_reload_image_repo    = var.configmap_reload_image_repo
  configmap_reload_image_tag     = var.configmap_reload_image_tag
  downloads_dashboard_image_repo = var.downloads_dashboard_image_repo
  downloads_dashboard_image_tag  = var.downloads_dashboard_image_tag
  fluent_bit_image_repo          = var.fluent_bit_image_repo
  fluent_bit_image_tag           = var.fluent_bit_image_tag
  fluent_bit_role_arn            = module.observability_infra.fluent_bit_role_arn
  grafana_image_repo             = var.grafana_image_repo
  grafana_image_tag              = var.grafana_image_tag
  grafana_sidecar_image_repo     = var.grafana_sidecar_image_repo
  grafana_sidecar_image_tag      = var.grafana_sidecar_image_tag
  grafana_storage_class          = module.yb_storageclass_helm.aws_general_purpose_storage_class
  grafana_node_selector          = var.grafana_node_selector
  init_chown_data_image_repo     = var.init_chown_data_image_repo
  init_chown_data_image_tag      = var.init_chown_data_image_tag
  kube_state_metrics_image_repo  = var.kube_state_metrics_image_repo
  kube_state_metrics_image_tag   = var.kube_state_metrics_image_tag
  loki_image_repo                = var.loki_image_repo
  loki_image_tag                 = var.loki_image_tag
  loki_log_trimmer_image_repo    = var.loki_log_trimmer_image_repo
  loki_log_trimmer_image_tag     = var.loki_log_trimmer_image_tag
  namespace                      = var.observability_namespace
  node_exporter_image_repo       = var.node_exporter_image_repo
  node_exporter_image_tag        = var.node_exporter_image_tag
  node_selector                  = var.yb_operator_labels
  process_exporter_image_repo    = var.process_exporter_image_repo
  process_exporter_image_tag     = var.process_exporter_image_tag
  prometheus_server_image_repo   = var.prometheus_server_image_repo
  prometheus_server_image_tag    = var.prometheus_server_image_tag
  pushgateway_image_repo         = var.pushgateway_image_repo
  pushgateway_image_tag          = var.pushgateway_image_tag
  registry                       = var.registry

  depends_on = [
    module.yb_operator_helm,
    module.yb_storageclass_helm
  ]
}
