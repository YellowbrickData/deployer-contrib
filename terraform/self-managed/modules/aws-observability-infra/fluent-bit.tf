locals {
  fluent_bit_service_account_name = "${var.release_name}-fluent-bit"
}

data "aws_caller_identity" "current" {}
data "aws_partition" "current" {}

resource "aws_iam_role" "fluent_bit" {
  name = "yb-eks-pod-fluent-bit-${var.cluster_name}-${var.region}"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Federated = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/${var.oidc_provider}"
        }
        Action = "sts:AssumeRoleWithWebIdentity"
        Condition = {
          StringEquals = {
            "${var.oidc_provider}:sub" = "system:serviceaccount:${var.namespace}:${local.fluent_bit_service_account_name}"
          }
        }
      }
    ]
  })
  tags = var.tags
}

resource "aws_iam_role_policy" "fluent_bit" {
  name = "logging"
  role = aws_iam_role.fluent_bit.name
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "s3:*"
        ],
        "Resource" : "arn:${data.aws_partition.current.partition}:s3:::${var.diags_bucket_name}/*"
      }
    ]
  })
}
