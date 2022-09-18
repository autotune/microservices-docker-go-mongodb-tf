resource "google_service_usage_consumer_quota_override" "override" {
  provider       = google-beta
  dimensions = {
    region = "us-central1"
  }
  project        = data.google_project.cinema.project_id
  service        = "compute.googleapis.com"
  metric         = urlencode("compute.googleapis.com/n2_cpus")
  limit          = urlencode("/project/region")
  override_value = "8"
  force          = true
}
