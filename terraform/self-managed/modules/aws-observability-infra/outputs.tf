output "fluent_bit_role_arn" {
  description = "IAM role ARN for the fluent-bit IAM role."
  value       = aws_iam_role.fluent_bit.arn

  depends_on = [
    aws_iam_role_policy.fluent_bit
  ]
}
