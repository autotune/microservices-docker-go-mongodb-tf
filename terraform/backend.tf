terraform {
  backend "gcs" {
    bucket = "terrateam"
    prefix = "cinema/production"
  }
}
