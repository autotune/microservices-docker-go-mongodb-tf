terraform {
  backend "gcs" {
    bucket = "terrateam-cinema"
    prefix = "cinema/prod"
  }
}
