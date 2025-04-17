# Self-Managed Yellowbrick Deployment on AWS

This is a reference for deploying Yellowbrick on AWS using Terraform. When
installing Yellowbrick via Helm, this provides AWS cloud infrastructure to
support that deployment.

## Components

The following components will be created in this reference:

- cert-manager add-on
- cluster-autoscaler iam role
- compute cluster iam role
- diags iam role
- diags s3 bucket
- fluent-bit iam role
- yb-op-standard nodegroup, launch template
- placement group
- yb-manager iam role
- yb-operator iam role

## Install

```
terraform apply
```

## Sample Variables

This is an example of what a variables file will look like. This will assume
artifacts have been pushed with `yb-install` and exist in private ECR
repositories with the Yellowbrick naming convention.

| variable        | description                                                      |
| --------------- | ---------------------------------------------------------------- |
| ACCOUNT_ID      | The account ID of your AWS account                               |
| INSTALL_VERSION | The version of Yellowbrick being installed                       |
| INSTANCE_NAME   | The name of your Yellowbrick instance                            |
| NODE_KEY_NAME   | (Optional) EC2 SSH access keypair name                           |
| REGION          | The AWS region, e.g. us-east-1                                   |
| SUBNET_ID       | The primary subnet to create the Yellowbrick Operator node group |

Please note it is up to the user to ensure these values are configured
correctly.

This is an example of required variables:

```
ami_id                = "ami-019fe02267d7e97fa"
cluster_name          = "INSTANCE_NAME"
node_group_subnet_id  = "SUBNET_ID"
oidc_provider         = "oidc.eks.REGION.amazonaws.com/id/F79517766CFE7A4CCA1CBD1B998062B5"
region                = "REGION"
yb_operator_namespace = "yb-INSTANCE_NAME"
```

This is a sample of optional variables:

```
diags_bucket_name    = "yb-diags-bucket-samplename"
node_key_name        = "NODE_KEY_NAME"
node_role_arn        = "arn:aws:iam::ACCOUNT_ID:role/yb-eks-node-INSTANCE_NAME-REGION"
placement_group_name = "my-custom-placement-group"
security_group_ids   = ["sg-12345678901234567"]
tags                 = { owner = "email", org = "dev" }
```

By default, all components will be created, but they can be individually controlled:

- create_cert_manager
- create_cluster_autoscaler_infra
- create_node_role
- create_observability_infra
- create_placement_group
- create_yb_operator_infra
- create_yb_operator_node_group

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
