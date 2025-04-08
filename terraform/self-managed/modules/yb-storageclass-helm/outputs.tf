output "aws_general_purpose_storage_class" {
  value = "${var.storage_class_prefix}gp3"
}

output "aws_nvme_scaled_storage_class" {
  value = "${var.storage_class_prefix}io1-scaled"
}

output "aws_nvme_standard_storage_class" {
  value = "${var.storage_class_prefix}io1-standard"
}

output "storage_class_prefix" {
  value = var.storage_class_prefix
}
