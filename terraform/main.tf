terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
    }
  }
}

provider "google" {
  project = "terrateam-362405"
  region  = "us-central1"
}

data "google_client_config" "default" {
}

