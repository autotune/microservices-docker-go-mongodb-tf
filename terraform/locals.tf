locals {
  all_project_services           = var.gcp_service_list
  cinema_hub_mesh_update_command = "gcloud alpha container hub mesh update --control-plane automatic --membership ${var.project_id}-cinema --project=${var.project_id}"
}

