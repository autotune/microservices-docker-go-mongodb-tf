resource "google_dns_managed_zone" "primary" {
  name        = var.user_zone_name
  dns_name    = var.managed_zone_name
  description = "${var.user_zone_name} DNS zone"
}

