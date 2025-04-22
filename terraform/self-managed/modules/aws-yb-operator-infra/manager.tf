resource "aws_iam_role" "manager" {
  name = "yb-eks-pod-yb-manager-${var.cluster_name}-${var.region}"
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
            "${var.oidc_provider}:sub" = "system:serviceaccount:${var.namespace}:yb-manager-serviceaccount"
          }
        }
      }
    ]
  })
  tags = var.tags
}

resource "aws_iam_role_policy" "manager_diags_download" {
  name = "diags-download"
  role = aws_iam_role.manager.name
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "s3:GetObject"
        ],
        "Resource" : "arn:${data.aws_partition.current.partition}:s3:::${local.diags_bucket_name}/*"
      }
    ]
  })
}

resource "aws_iam_role_policy" "manager_license_metadata" {
  name = "license-metadata"
  role = aws_iam_role.manager.name
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : "ec2:DescribeTags",
        "Resource" : "*"
      }
    ]
  })
}
