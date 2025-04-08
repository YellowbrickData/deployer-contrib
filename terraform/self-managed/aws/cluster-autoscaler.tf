module "cluster_autoscaler_infra" {
  source = "./modules/aws-cluster-autoscaler-infra"

  cluster_name  = var.cluster_name
  namespace     = var.cluster_autoscaler_namespace
  oidc_provider = local.oidc_provider
  region        = var.region
  tags          = var.tags
}

module "cluster_autoscaler_helm" {
  source = "./modules/cluster-autoscaler-helm"

  chart         = var.cluster_autoscaler_chart
  chart_version = var.cluster_autoscaler_chart_version
  cluster_name  = var.cluster_name
  registry      = var.registry

  extra_values = {
    "awsRegion" : var.region,
    "cloudProvider" : "aws",
    "image" : {
      "repository" : var.cluster_autoscaler_image_repo,
      "tag" : var.cluster_autoscaler_image_tag
    },
    "nodeSelector" : var.yb_operator_labels,
    "rbac" : {
      "serviceAccount" : {
        "annotations" : {
          "eks.amazonaws.com/role-arn" : module.cluster_autoscaler_infra.iam_role_arn
        },
        "name" : "cluster-autoscaler"
      }
    },
    "tolerations" : var.cluster_autoscaler_tolerations
  }

  depends_on = [
    aws_iam_openid_connect_provider.this,
    module.operator_nodegroup
  ]
}
