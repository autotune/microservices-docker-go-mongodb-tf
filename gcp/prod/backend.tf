terraform {
  backend "gcs" {
    bucket = "wayofthesys-cinema"
    prefix = "cinema/production"
  }
}
