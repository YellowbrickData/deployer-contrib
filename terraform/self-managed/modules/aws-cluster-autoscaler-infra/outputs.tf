output "iam_role_arn" {
  description = "IAM role ARN for the cluster autoscaler"
  value       = aws_iam_role.this.arn

  depends_on = [
    aws_iam_role_policy.this
  ]
}
