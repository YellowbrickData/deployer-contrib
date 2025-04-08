output "iam_role_arn" {
  description = "IAM role ARN for the VPC CNI IAM role."
  value       = aws_iam_role.this.arn

  depends_on = [
    aws_iam_role_policy_attachment.this
  ]
}
