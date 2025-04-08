resource "helm_release" "this" {
  chart      = local.chart
  version    = var.yb_operator_chart_version
  name       = var.release_name
  namespace  = var.namespace
  repository = local.operator_repo

  create_namespace = var.create_namespace

  values = [
    yamlencode(
      merge(
        {
          "config" : {
            "data" : {
              "provider" : var.cloud_provider,
              "region" : var.region,
              "diagsContainer" : "diags",
              "registryHost" : var.registry_host,
              "observabilityBucketName" : var.diags_bucket_name,
              "klusterName" : var.cluster_name,
              "monitoringNamespace" : var.observabilty_namespace,
              "additionalTags" : {
                "cluster_yellowbrick_io_creator" : "yb-install",
                "cluster_yellowbrick_io_name" : var.instance_name,
                "cluster_yellowbrick_io_owner" : "yb-install"
              }
            }
          },
          "installCrd" : true,
          "diags" : {
            "serviceAccount" : {
              "annotations" : {
                "eks.amazonaws.com/role-arn" : var.yb_diags_role_arn
              }
            }
          }
          "image" : {
            "registry" : var.registry_host,
            "repository" : "yellowbrick/yb-operator",
            "tag" : var.yb_operator_image_tag
          },
          "monitoringNamespace" : var.observabilty_namespace,
          "nodeSelector" : var.node_selector,
          "pvc" : {
            "storageClassName" : var.storage_class
          },
          "serviceAccount" : {
            "annotations" : {
              "eks.amazonaws.com/role-arn" : var.yb_operator_role_arn
            }
          },
          "yb-manager" : {
            "enabled" : true
            "cloudProvider" : var.cloud_provider
            "containerImage" : "${var.yb_manager_image_repo}:${var.yb_manager_image_tag}",
            "instance" : {
              "global" : true
            },
            "loadBalancer" : {
              "internal" : false
            },
            "nginxRepository" : "${var.nginx_image_repo}",
            "nodeSelector" : var.node_selector,
            "serviceAccount" : {
              "annotations" : {
                "eks.amazonaws.com/role-arn" : var.yb_manager_role_arn
              }
            },
            "storageClassName" : var.storage_class,
            "tolerations" : var.tolerations,
            "ybTemplateImage" : "${var.yb_template_image_repo}:${var.yb_template_image_tag}",
          },
          "worker" : {
            "serviceAccount" : {
              "annotations" : {
                "eks.amazonaws.com/role-arn" : var.yb_compute_cluster_role_arn
              }
            },
          }
        },
        var.extra_values
      )
    )
  ]
}
