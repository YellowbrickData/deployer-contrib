locals {
  subnet_cidrs = cidrsubnets(
    var.network_cidr,
    var.subnet_bits_private,
  )
}

resource "google_compute_network" "this" {
  name                    = local.instance_name
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "private" {
  name                     = "${local.instance_name}-0"
  ip_cidr_range            = local.subnet_cidrs[0]
  region                   = var.region
  network                  = google_compute_network.this.id
  private_ip_google_access = true

  depends_on = [
    google_compute_network.this
  ]
}
