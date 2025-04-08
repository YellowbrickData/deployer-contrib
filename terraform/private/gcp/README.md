# Yellowbrick Reference Terraform for GCP

The purpose of this Terraform is to provide a reference architecture for installing Yellowbrick with an existing or private network. Customization is expected. Please refer to the Yellowbrick GCP Private Instructions documentation for more information.

## Infrastructure

This Terraform will create:

- network
- subnet
- firewall

No inbound firewall rules are given in this reference. You may consider custom firewall rules if applicable.

Example of inbound HTTPS to a bastion host tagged `https-access`:

```hcl
resource "google_compute_firewall" "admin_ingress_https" {
  name    = "${local.instance_name}-admin-https"
  network = google_compute_network.this.name

  allow {
    protocol = "tcp"
    ports    = ["443"]
  }

  # Set this to appropriate values
  source_ranges = var.allowlist_cidrs
  direction     = "INGRESS"
  target_tags   = ["https-access"]
  description   = "Allow HTTPS ingress"
}
```

## Creating a tfvars file

A typical installation will require the following variables:

```
project  = "my-project"
region   = "us-east4"
zone     = "us-east4-c"
```

Please see `variables.tf` for descriptions for each variable.

