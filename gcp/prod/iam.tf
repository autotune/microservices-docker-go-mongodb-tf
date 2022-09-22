/*
resource "google_service_account_key" "external-dns" {
  service_account_id = data.google_service_account.gke-external-dns.name
}

module "external-dns" {
  source  = "nlamirault/external-dns/google"
  version = "1.2.0"

  project = var.project_id

  namespace       = var.gke_external_dns_namespace
  service_account = var.gke_external_dns_sa_id
  depends_on      = [kubernetes_namespace.external-dns]
}
*/
