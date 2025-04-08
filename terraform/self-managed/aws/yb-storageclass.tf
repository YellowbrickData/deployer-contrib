locals {
  allowed_topologies = [
    {
      matchLabelExpressions = [
        {
          key : "topology.kubernetes.io/zone"
          values : [data.aws_subnet.nodegroup_subnet.availability_zone]
        }
      ]
    }
  ]
}

data "aws_subnet" "nodegroup_subnet" {
  id = var.node_group_subnet_id
}

module "yb_storageclass_helm" {
  source = "./modules/yb-storageclass-helm"

  allowed_topologies   = var.yb_storageclass_allowed_topologies
  chart                = var.yb_storageclass_chart
  chart_version        = var.yb_storageclass_chart_version
  cloud_provider       = "aws"
  namespace            = var.yb_operator_namespace
  parameters           = var.yb_storageclass_parameters
  registry             = var.registry
  storage_class_prefix = var.yb_storageclass_prefix
}
