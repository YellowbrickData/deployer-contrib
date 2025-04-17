output "cluster_autoscaler_role_arn" {
  description = "The ARN of the IAM role used for the cluster autoscaler."
  value       = try(module.cluster_autoscaler_infra[0].iam_role_arn, null)
}

output "fluent_bit_role_arn" {
  description = "The ARN of the IAM role used for fluent-bit."
  value       = try(module.observability_infra[0].fluent_bit_role_arn, null)
}

output "yb_compute_cluster_role_arn" {
  description = "The ARN of the IAM role used for the compute cluster."
  value       = try(module.yb_operator_infra[0].yb_compute_cluster_role_arn, null)
}

output "yb_diags_role_arn" {
  description = "The ARN of the IAM role used for the diagnostics."
  value       = try(module.yb_operator_infra[0].yb_diags_role_arn, null)
}

output "yb_diags_bucket_name" {
  description = "The name of the S3 bucket used for diagnostics."
  value       = try(module.yb_operator_infra[0].yb_diags_bucket_name, null)
}

output "yb_manager_role_arn" {
  description = "The ARN of the IAM role used for YB Manager."
  value       = try(module.yb_operator_infra[0].yb_manager_role_arn, null)
}

output "yb_operator_role_arn" {
  description = "The ARN of the IAM role used for YB Operator."
  value       = try(module.yb_operator_infra[0].yb_operator_role_arn, null)
}
