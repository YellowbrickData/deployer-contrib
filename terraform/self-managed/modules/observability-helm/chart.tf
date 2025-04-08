resource "helm_release" "this" {
  chart      = local.chart
  version    = var.chart_version
  name       = "loki"
  namespace  = var.namespace
  repository = local.repository

  create_namespace = var.create_namespace

  values = [
    yamlencode(merge(
      {
        "fluent-bit" : {
          "additionalOutput" : "",
          "enabled" : true,
          "image" : {
            "repository" : var.fluent_bit_image_repo,
            "tag" : var.fluent_bit_image_tag
          },
          "nodeSelector" : var.fluent_bit_node_selector,
          "serviceAccount" : {
            "annotations" : {
              "eks.amazonaws.com/role-arn" : var.fluent_bit_role_arn
            }
          },
          "tolerations" : var.fluent_bit_tolerations
        },

        "grafana" : {
          "deploymentStrategy" : {
            "type" : "Recreate"
          },
          "downloadDashboardsImage" : {
            "repository" : var.downloads_dashboard_image_repo,
            "tag" : var.downloads_dashboard_image_tag
          },
          "image" : {
            "repository" : var.grafana_image_repo,
            "tag" : var.grafana_image_tag
          },
          "initChownData" : {
            "image" : {
              "repository" : var.init_chown_data_image_repo,
              "tag" : var.init_chown_data_image_tag
            }
          },
          "nodeSelector" : var.grafana_node_selector,
          "persistence" : {
            "storageClassName" : var.grafana_storage_class
          },
          "sidecar" : {
            "image" : {
              "repository" : var.grafana_sidecar_image_repo,
              "tag" : var.grafana_sidecar_image_tag
            }
          },
          "tolerations" : var.grafana_tolerations
        },

        "ingress" : {
          "enabled" : var.ingress
        },

        "loki" : {
          "extraContainers" : [
            {
              "command" : [
                "/bin/sh",
                "-c",
                "trap cleanup 15\n                              cleanup()\n                              {\n                                  echo \"Shutting down the loki pvc monitor\"\n                                  exit\n                              }\n\n                              while true; do\n                                  /delete_files_if_low_memory.sh\n                                  sleep 360 &\n                                  PID=$!\n                                  wait $PID\n                              done;"
              ],
              "env" : [
                {
                  "name" : "SPACEMONITORING_FOLDER",
                  "value" : "/data/loki/chunks"
                }
              ],
              "image" : "${var.loki_log_trimmer_image_repo}:${var.loki_log_trimmer_image_tag}",
              "name" : "pvcleanup",
              "volumeMounts" : [
                {
                  "mountPath" : "/data",
                  "name" : "storage"
                }
              ]
            }
          ],
          "image" : {
            "repository" : var.loki_image_repo,
            "tag" : var.loki_image_tag
          },
          "nodeSelector" : var.loki_node_selector,
          "persistence" : {
            "size" : "200Gi",
            "storageClassName" : var.grafana_storage_class
          },
          "tolerations" : var.loki_tolerations
        },

        "prometheus" : {
          "alertmanager" : {
            "enabled" : false,
            "image" : {
              "repository" : var.alertmanager_image_repo,
              "tag" : var.alertmanager_image_tag
            },
            "nodeSelector" : var.alertmanager_node_selector,
            "tolerations" : var.alertmanager_tolerations
          },

          "alertmanagerFiles" : {},

          "configmapReload" : {
            "alertmanager" : {
              "enabled" : true,
              "image" : {
                "repository" : var.configmap_reload_image_repo,
                "tag" : var.configmap_reload_image_tag
              }
            },
            "prometheus" : {
              "image" : {
                "repository" : var.configmap_reload_image_repo,
                "tag" : var.configmap_reload_image_tag
              }
            }
          },

          "kube-state-metrics" : {
            "image" : {
              "repository" : var.kube_state_metrics_image_repo,
              "tag" : var.kube_state_metrics_image_tag
            },
            "nodeSelector" : var.kube_state_metrics_node_selector,
            "tolerations" : var.kube_state_metrics_tolerations
          },

          "nodeExporter" : {
            "image" : {
              "repository" : var.node_exporter_image_repo,
              "tag" : var.node_exporter_image_tag
            },
            "nodeSelector" : var.node_exporter_node_selector,
            "tolerations" : var.node_exporter_tolerations
          },

          "processExporter" : {
            "image" : {
              "repository" : var.process_exporter_image_repo,
              "tag" : var.process_exporter_image_tag
            },
            "nodeSelector" : var.process_exporter_node_selector,
            "tolerations" : var.process_exporter_tolerations
          },

          "pushgateway" : {
            "image" : {
              "repository" : var.pushgateway_image_repo,
              "tag" : var.pushgateway_image_tag
            },
            "nodeSelector" : var.pushgateway_node_selector,
            "tolerations" : var.pushgateway_tolerations
          },

          "server" : {
            "image" : {
              "repository" : var.prometheus_server_image_repo,
              "tag" : var.prometheus_server_image_tag
            },
            "nodeSelector" : var.prometheus_node_selector,
            "persistentVolume" : {
              "enabled" : true,
              "size" : "100Gi",
              "storageClass" : var.grafana_storage_class
            },
            "tolerations" : var.prometheus_tolerations
          },

          "serverFiles" : {
            "alerting_rules.yml" : {
              "groups" : [
                {
                  "name" : "Host alerts",
                  "rules" : [
                    {
                      "alert" : "PVCUtilizationHigh",
                      "annotations" : {
                        "message" : "The persistentVolume used by {{ $labels.persistentvolumeclaim }} is {{ $value | humanize }}% utilized. Please check and take appropriate action.",
                        "summary" : "PVC utilization on PVC {{ $labels.persistentvolumeclaim }} is high"
                      },
                      "expr" : "100 * sum(kubelet_volume_stats_used_bytes) by(persistentvolumeclaim) /sum(kubelet_volume_stats_capacity_bytes) by (persistentvolumeclaim) > 90",
                      "for" : "5m",
                      "labels" : {
                        "severity" : "warning"
                      }
                    },
                    {
                      "alert" : "HostOutOfDiskSpace",
                      "annotations" : {
                        "description" : "Disk is almost full (< 80% left)\n  VALUE = {{ $value | humanize }}\n  LABELS: {{ $labels }}",
                        "message" : "Disk is almost full (< 80% left)\n  VALUE = {{ $value | humanize }}%\n  Node Name: {{ $labels.node }}",
                        "summary" : "Host out of disk space (instance {{ $labels.node }})"
                      },
                      "expr" : "100 - ((node_filesystem_avail_bytes{mountpoint=\"/\"} * 100) / node_filesystem_size_bytes{mountpoint=\"/\"}) > 80",
                      "for" : "1s",
                      "labels" : {
                        "severity" : "warning"
                      }
                    }
                  ]
                }
              ]
            }
          }
        }
      },
    var.extra_values))
  ]
}
