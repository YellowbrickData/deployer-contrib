module "yb_operator_infra" {
  source = "./modules/aws-yb-operator-infra"

  cluster_name  = var.cluster_name
  namespace     = var.yb_operator_namespace
  node_role_arn = local.node_role_arn
  oidc_provider = local.oidc_provider
  region        = var.region
  tags          = var.tags
}

module "yb_operator_helm" {
  source = "./modules/yb-operator-helm"

  cloud_provider              = "aws"
  cluster_name                = var.cluster_name
  instance_name               = var.instance_name
  namespace                   = var.yb_operator_namespace
  nginx_image_repo            = var.nginx_image_repo
  nginx_image_tag             = var.nginx_image_tag
  node_selector               = var.yb_operator_labels
  diags_bucket_name           = module.yb_operator_infra.diags_bucket_name
  observabilty_namespace      = var.observability_namespace
  region                      = var.region
  registry                    = var.registry
  registry_host               = var.yb_operator_registry_host
  storage_class               = module.yb_storageclass_helm.aws_general_purpose_storage_class
  yb_compute_cluster_role_arn = module.yb_operator_infra.yb_compute_cluster_role_arn
  yb_diags_role_arn           = module.yb_operator_infra.yb_diags_role_arn
  yb_manager_image_repo       = var.yb_manager_image_repo
  yb_manager_image_tag        = var.yb_manager_image_tag
  yb_manager_role_arn         = module.yb_operator_infra.yb_manager_role_arn
  yb_operator_chart           = var.yb_operator_chart
  yb_operator_chart_version   = var.yb_operator_chart_version
  yb_operator_image_repo      = var.yb_operator_image_repo
  yb_operator_image_tag       = var.yb_operator_image_tag
  yb_operator_role_arn        = module.yb_operator_infra.yb_operator_role_arn
  yb_template_image_repo      = var.yb_template_image_repo
  yb_template_image_tag       = var.yb_template_image_tag

  depends_on = [
    aws_iam_openid_connect_provider.this,
    module.operator_nodegroup,
    module.yb_storageclass_helm
  ]
}
