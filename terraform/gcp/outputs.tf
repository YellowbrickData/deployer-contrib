output "instance_name" {
  value = local.instance_name
}

output "subnet_cidr" {
  value = google_compute_subnetwork.private.ip_cidr_range
}

output "zone" {
  value = var.zone
}
