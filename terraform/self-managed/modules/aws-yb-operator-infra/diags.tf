locals {
  # Convert to lowercase, then join all matches of [a-z0-9-]
  # This effectively removes any characters not matching [a-z0-9-].
  clean_cluster_name = join("", regexall("[a-z0-9-]", lower(var.cluster_name)))

  # Compute a SHA1 hash of the AWS account ID and then convert to hex
  # We only take the first 8 characters
  account_id_sha1  = sha1(data.aws_caller_identity.current.account_id)
  account_id_short = substr(local.account_id_sha1, 0, 8)

  # The final bucket name, ensuring it remains all-lowercase
  diags_bucket_name = var.diags_bucket_name == "" ? "yb-diags-${local.clean_cluster_name}-${local.account_id_short}-${lower(var.region)}" : var.diags_bucket_name
}

resource "aws_iam_role" "diags" {
  name = "yb-eks-pod-diags-${var.cluster_name}-${var.region}"
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
            "${var.oidc_provider}:sub" = "system:serviceaccount:${var.namespace}:yb-diags-sa"
          }
        }
      }
    ]
  })
  tags = var.tags
}

resource "aws_iam_role_policy" "diags" {
  name = "diags-upload"
  role = aws_iam_role.diags.name
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "s3:PutObject",
          "s3:GetObject",
          "s3:DeleteObject"
        ],
        "Resource" : "arn:${data.aws_partition.current.partition}:s3:::${local.diags_bucket_name}/*"
      }
    ]
  })
}

resource "aws_s3_bucket" "diags" {
  count = var.diags_bucket_name == "" ? 1 : 0

  bucket = local.diags_bucket_name
  tags   = var.tags

  # This helps ensure that the bucket gets destroyed even if it has objects
  # Just remove if you do *not* want to force object deletion.
  force_destroy = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "diags" {
  count = var.diags_bucket_name == "" ? 1 : 0

  bucket = aws_s3_bucket.diags[0].bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

data "aws_iam_policy_document" "diags_deny_insecure_transport" {
  count = var.diags_bucket_name == "" ? 1 : 0

  statement {
    sid     = "Deny non-TLS"
    effect  = "Deny"
    actions = ["s3:*"]
    principals {
      type        = "*"
      identifiers = ["*"]
    }
    resources = [
      aws_s3_bucket.diags[0].arn,
      "${aws_s3_bucket.diags[0].arn}/*"
    ]
    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"
      values   = ["false"]
    }
  }
}

resource "aws_s3_bucket_policy" "diags" {
  count = var.diags_bucket_name == "" ? 1 : 0

  bucket = aws_s3_bucket.diags[0].id
  policy = data.aws_iam_policy_document.diags_deny_insecure_transport[0].json
}
