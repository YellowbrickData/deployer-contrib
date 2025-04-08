output "diags_bucket_name" {
  description = "S3 bucket name for yb-diags"
  value       = var.diags_bucket_name == "" ? aws_s3_bucket.diags[0].bucket : var.diags_bucket_name

  depends_on = [
    aws_s3_bucket_policy.diags
  ]
}

output "yb_compute_cluster_role_arn" {
  description = "IAM role ARN for yb-worker"
  value       = aws_iam_role.compute_cluster.arn

  depends_on = [
    aws_iam_role_policy.compute_cluster
  ]
}

output "yb_diags_role_arn" {
  description = "IAM role ARN for yb-diags"
  value       = aws_iam_role.diags.arn

  depends_on = [
    aws_iam_role_policy.diags
  ]
}

output "yb_manager_role_arn" {
  description = "IAM role ARN for yb-manager"
  value       = aws_iam_role.manager.arn

  depends_on = [
    aws_iam_role_policy.manager_diags_download,
    aws_iam_role_policy.manager_license_metadata
  ]
}

output "yb_operator_role_arn" {
  description = "IAM role ARN for yb-operator"
  value       = aws_iam_role.operator.arn

  depends_on = [
    aws_iam_role_policy.operator
  ]
}
