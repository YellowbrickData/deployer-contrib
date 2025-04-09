output "cluster_autoscaler_role_arn" {
  description = "The ARN of the IAM role used for the cluster autoscaler."
  value       = module.cluster_autoscaler_infra.iam_role_arn
}

output "fluent_bit_role_arn" {
  description = "The ARN of the IAM role used for fluent-bit."
  value       = module.observability_infra.fluent_bit_role_arn
}

output "yb_compute_cluster_role_arn" {
  description = "The ARN of the IAM role used for the compute cluster."
  value       = module.yb_operator_infra.yb_compute_cluster_role_arn
}

output "yb_diags_role_arn" {
  description = "The ARN of the IAM role used for the diagnostics."
  value       = module.yb_operator_infra.yb_diags_role_arn
}

output "yb_diags_bucket_name" {
  description = "The name of the S3 bucket used for diagnostics."
  value       = module.yb_operator_infra.yb_diags_bucket_name
}

output "yb_manager_role_arn" {
  description = "The ARN of the IAM role used for YB Manager."
  value       = module.yb_operator_infra.yb_manager_role_arn
}

output "yb_operator_role_arn" {
  description = "The ARN of the IAM role used for YB Operator."
  value       = module.yb_operator_infra.yb_operator_role_arn
}
