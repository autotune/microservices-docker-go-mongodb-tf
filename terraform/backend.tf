terraform {
  backend "gcs" {
    bucket = "terrateam"
    prefix = "cinema/prod"
  }
}
