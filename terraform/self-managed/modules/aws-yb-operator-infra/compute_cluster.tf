resource "aws_iam_role" "compute_cluster" {
  name = "yb-eks-pod-compute-cluster-${var.cluster_name}-${var.region}"
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
            "${var.oidc_provider}:sub" = "system:serviceaccount:${var.namespace}:${var.namespace}-worker-sa"
          }
        }
      }
    ]
  })
  tags = var.tags
}

resource "aws_iam_role_policy" "compute_cluster" {
  name = "s3-full-bucket-access"
  role = aws_iam_role.diags.name
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "s3:*"
        ],
        "Resource" : "arn:${data.aws_partition.current.partition}:s3:::yb-*/*"
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "s3:GetBucketLocation",
          "s3:ListBucket"
        ],
        "Resource" : "arn:${data.aws_partition.current.partition}:s3:::yb-*"
      }
    ]
  })
}
