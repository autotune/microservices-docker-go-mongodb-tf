resource "google_dns_managed_zone" "primary" {
  name        = var.user_zone_name
  dns_name    = var.managed_zone_name
  description = "${var.user_zone_name} DNS zone"
}

resource "google_dns_record_set" "do" {
  name         = "do.${google_dns_managed_zone.primary.dns_name}"
  managed_zone = google_dns_managed_zone.primary.name
  type         = "NS"
  ttl          = 300

  rrdatas = ["ns1.digitalocean.com", "ns2.digitalocean.com", "ns3.digitalocean.com"]
}
