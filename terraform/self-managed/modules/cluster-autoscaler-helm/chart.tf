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

resource "helm_release" "this" {
  chart      = local.chart
  version    = var.chart_version
  name       = var.release_name
  namespace  = var.namespace
  repository = local.repository

  values = [
    yamlencode(
      merge(
        {
          "affinity" : {
            "podAntiAffinity" : {
              "requiredDuringSchedulingIgnoredDuringExecution" : [
                {
                  "labelSelector" : {
                    "matchExpressions" : [
                      {
                        "key" : "app.kubernetes.io/name",
                        "operator" : "In",
                        "values" : [
                          var.release_name
                        ]
                      }
                    ]
                  },
                  "namespaceSelector" : {},
                  "topologyKey" : "kubernetes.io/hostname"
                }
              ]
            }
          },
          "autoDiscovery" : {
            "clusterName" : var.cluster_name,
            "tags" : [
              "k8s.io/cluster-autoscaler/enabled",
              "k8s.io/cluster-autoscaler/${var.cluster_name}",
              "k8s.io/cluster-autoscaler/node-template/label/cluster.yellowbrick.io/owned"
            ]
          },
          "extraArgs" : {
            "ignore-daemonsets-utilization" : true,
            "logtostderr" : true,
            "max-empty-bulk-delete" : "10",
            "max-graceful-termination-sec" : "600",
            "max-node-provision-time" : "15m",
            "max-total-unready-percentage" : "45",
            "new-pod-scale-up-delay" : "0s",
            "ok-total-unready-count" : "3",
            "scale-down-delay-after-add" : "10m",
            "scale-down-delay-after-delete" : "10s",
            "scale-down-delay-after-failure" : "3m",
            "scale-down-unneeded-time" : "10m",
            "scale-down-unready-time" : "10m",
            "scale-down-utilization-threshold" : "0.5",
            "scan-interval" : "10s",
            "skip-nodes-with-local-storage" : "false",
            "skip-nodes-with-system-pods" : "false",
            "stderrthreshold" : "info",
            "v" : 4
          },
          "extraVolumeMounts" : [
            {
              "mountPath" : "/etc/ssl/certs/ca-certificates.crt",
              "name" : "ssl-certs",
              "readOnly" : true
            }
          ],
          "extraVolumes" : [
            {
              "hostPath" : {
                "path" : "/etc/ssl/certs/ca-bundle.crt"
              },
              "name" : "ssl-certs"
            }
          ],
          "podAnnotations" : {
            "cluster-autoscaler.kubernetes.io/safe-to-evict" : "false"
          },
          "podDisruptionBudget" : null,
        },
        var.extra_values
      )
    )
  ]
}
