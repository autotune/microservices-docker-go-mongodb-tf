terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = "us-central1"
}

data "google_client_config" "default" {
}

data "google_project" "cinema" {
  project_id = var.project_id
}

data "google_service_account" "gke-external-dns" {
  account_id = module.external-dns.service_account
  depends_on = [module.external-dns]
}

provider "helm" {
  kubernetes {
    host                   = "https://${module.gke-cinema.endpoint}"
    cluster_ca_certificate = base64decode(module.gke-cinema.ca_certificate)
    token                  = data.google_client_config.default.access_token
  }
  alias = "cinema"
}

provider "kubernetes" {
  host                   = "https://${module.gke-cinema.endpoint}"
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(module.gke-cinema.ca_certificate)
  alias                  = "cinema"
}

output "project" {
  value = data.google_client_config.default.project
}

