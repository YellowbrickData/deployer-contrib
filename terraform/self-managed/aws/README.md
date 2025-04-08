# Self-Managed Yellowbrick Deployment on AWS

This is a reference for deploying Yellowbrick on AWS using Terraform.

## Components

The following components will be created in this reference:

- aws-ebs-csi-driver add-on
- aws-ebs-csi-driver iam role
- cert-manager add-on
- cluster-autoscaler helm chart
- cluster-autoscaler iam role
- core-dns add-on
- kube-proxy add-on
- metrics-server add-on
- node-local-dns
- node iam role
- openid connect provider
- vpc-cni add-on
- vpc-cni iam role
- yb-op-standard nodegroup
- yb-storageclass
- yb-operator
- yb-resources

The following variables allow for existing resources to be used, rather than creating new ones:

| variable             | desc                                           |
| -------------------- | ---------------------------------------------- |
| node_role_arn        | use this value for the nodegroup role          |
| oidc_provider_url    | use this value for the openid connect provider |
| placement_group_name | use this value for the ec2 placement group     |

## Install

```
terraform apply
```

## Sample Variables

This is an example of what a variables file will look like. This will assume
artifacts have been pushed with `yb-install` and exist in private ECR
repositories with the Yellowbrick naming convention.

| variable        | description                                |
| --------------- | ------------------------------------------ |
| ACCOUNT_ID      | The account ID of your AWS account         |
| INSTALL_VERSION | The version of Yellowbrick being installed |
| INSTANCE_NAME   | The name of your Yellowbrick instance      |
| NODE_KEY_NAME   | (Optional) EC2 SSH access keypair name     |
| REGION          | The AWS region, e.g. us-east-1             |
| SUBNET_ID | The primary subnet to create the Yellowbrick Operator node group |

Please note it is up to the user to ensure these values are configured
correctly.

```
alertmanager_image_repo          = "ACCOUNT_ID.dkr.ecr.REGION.amazonaws.com/yb-INSTANCE_NAME/prometheus/alertmanager"
alertmanager_image_tag           = "v0.27.0"
ami_id                           = "ami-019fe02267d7e97fa"
cluster_autoscaler_chart         = "yb-INSTANCE_NAME/cluster-autoscaler"
cluster_autoscaler_chart_version = "9.35.0"
cluster_autoscaler_image_repo    = "ACCOUNT_ID.dkr.ecr.REGION.amazonaws.com/yb-INSTANCE_NAME/autoscaling/cluster-autoscaler"
cluster_autoscaler_image_tag     = "v1.29.4"
cluster_name                     = "INSTANCE_NAME"
configmap_reload_image_repo      = "ACCOUNT_ID.dkr.ecr.REGION.amazonaws.com/yb-INSTANCE_NAME/jimmidyson/configmap-reload"
configmap_reload_image_tag       = "v0.8.0"
downloads_dashboard_image_repo   = "ACCOUNT_ID.dkr.ecr.REGION.amazonaws.com/yb-INSTANCE_NAME/curlimages/curl"
downloads_dashboard_image_tag    = "8.11.1"
fluent_bit_image_repo            = "ACCOUNT_ID.dkr.ecr.REGION.amazonaws.com/yb-INSTANCE_NAME/yellowbrickdata/fluent-bit-plugin-loki"
fluent_bit_image_tag             = "2.8.8-13"
grafana_image_repo               = "ACCOUNT_ID.dkr.ecr.REGION.amazonaws.com/yb-INSTANCE_NAME/grafana/grafana"
grafana_image_tag                = "10.2.6"
grafana_sidecar_image_repo       = "ACCOUNT_ID.dkr.ecr.REGION.amazonaws.com/yb-INSTANCE_NAME/kiwigrid/k8s-sidecar"
grafana_sidecar_image_tag        = "1.28.0"
init_chown_data_image_repo       = "ACCOUNT_ID.dkr.ecr.REGION.amazonaws.com/yb-INSTANCE_NAME/library/busybox"
init_chown_data_image_tag        = "1.31.1"
instance_name                    = "INSTANCE_NAME"
kube_state_metrics_image_repo    = "ACCOUNT_ID.dkr.ecr.REGION.amazonaws.com/yb-INSTANCE_NAME/kube-state-metrics/kube-state-metrics"
kube_state_metrics_image_tag     = "v2.13.0"
loki_image_repo                  = "ACCOUNT_ID.dkr.ecr.REGION.amazonaws.com/yb-INSTANCE_NAME/grafana/loki"
loki_image_tag                   = "2.9.8"
loki_log_trimmer_image_repo      = "ACCOUNT_ID.dkr.ecr.REGION.amazonaws.com/yb-INSTANCE_NAME/yellowbrickdata/loki-log-trimmer"
loki_log_trimmer_image_tag       = "v5"
nginx_image_repo                 = "ACCOUNT_ID.dkr.ecr.REGION.amazonaws.com/yb-INSTANCE_NAME/nginx"
nginx_image_tag                  = "1.27.1-alpine"
node_exporter_image_repo         = "ACCOUNT_ID.dkr.ecr.REGION.amazonaws.com/yb-INSTANCE_NAME/prometheus/node-exporter"
node_exporter_image_tag          = "v1.8.0"
node_group_subnet_id             = "SUBNET_ID"
node_key_name                    = "NODE_KEY_NAME"
node_local_dns_chart             = "yb-INSTANCE_NAME/node-local-dns"
node_local_dns_chart_version     = "INSTALLER_VERSION"
node_local_dns_image_repo        = "ACCOUNT_ID.dkr.ecr.REGION.amazonaws.com/yb-INSTANCE_NAME/dns/k8s-dns-node-cache"
node_local_dns_image_tag         = "INSTALLER_VERSION"
observability_chart              = "yb-INSTANCE_NAME/loki-stack"
observability_chart_version      = "INSTALLER_VERSION"
observability_ingress            = false
process_exporter_image_repo      = "ACCOUNT_ID.dkr.ecr.REGION.amazonaws.com/yb-INSTANCE_NAME/ncabatoff/process-exporter"
process_exporter_image_tag       = "sha-7ef0b73"
prometheus_server_image_repo     = "ACCOUNT_ID.dkr.ecr.REGION.amazonaws.com/yb-INSTANCE_NAME/prometheus/prometheus"
prometheus_server_image_tag      = "v2.49.1"
pushgateway_image_repo           = "ACCOUNT_ID.dkr.ecr.REGION.amazonaws.com/yb-INSTANCE_NAME/prom/pushgateway"
pushgateway_image_tag            = "v1.9.0"
region                           = "REGION"
registry                         = "oci://ACCOUNT_ID.dkr.ecr.REGION.amazonaws.com"
tags                             = { ybass-owner = "john.adamson@yellowbrick.com", ybass-org = "product-dev" }
yb_manager_image_repo            = "ACCOUNT_ID.dkr.ecr.REGION.amazonaws.com/yb-INSTANCE_NAME/yellowbrick/yb-manager"
yb_manager_image_tag             = "INSTALLER_VERSION"
yb_operator_chart                = "yb-INSTANCE_NAME/yb-operator"
yb_operator_chart_version        = "INSTALLER_VERSION"
yb_operator_image_repo           = "ACCOUNT_ID.dkr.ecr.REGION.amazonaws.com/yb-INSTANCE_NAME/yellowbrick/yb-operator"
yb_operator_image_tag            = "INSTALLER_VERSION"
yb_operator_namespace            = "yb-INSTANCE_NAME"
yb_resources_chart               = "yb-INSTANCE_NAME/yb-resources"
yb_resources_chart_version       = "INSTALLER_VERSION"
yb_storageclass_chart            = "yb-INSTANCE_NAME/yb-storageclass"
yb_storageclass_chart_version    = "INSTALLER_VERSION"
yb_template_image_repo           = "ACCOUNT_ID.dkr.ecr.REGION.amazonaws.com/yb-INSTANCE_NAME/yellowbrick/yb-template"
yb_template_image_tag            = "INSTALLER_VERSION"
```


### AMI ID

To determine the `ami_id` to use:

```bash
aws ec2 describe-images \
    --region REGION \
    --owner 732123782549 \
    --filters "Name=name,Values=yb-enterprise-eks-node-1.30-v20250115-20250116232817"
```

The owner `732123782549` is the Yellowbrick official account for the commercial
AWS partition. A newer version of the AMI may be available, so consider using
`yb-enterprise-eks-node-` and choosing a value for your specific version of
EKS.
