module "gke-cinema" {
  depends_on                 = [module.vpc-cinema, google_project_service.enabled_apis]
  source                     = "terraform-google-modules/kubernetes-engine/google"
  project_id                 = "terrateam-362405"
  name                       = "cinema"
  region                     = "us-central1" 
  zones                      = ["us-central1-a", "us-central1-b"]
  network                    = "cinema"
  subnetwork                 = "prod"
  ip_range_pods              = "us-central1-01-gke-01-pods"
  ip_range_services          = "us-central1-01-gke-01-services"
  http_load_balancing        = true
  network_policy             = false
  horizontal_pod_autoscaling = true
  filestore_csi_driver       = false
  default_max_pods_per_node  = 65
  remove_default_node_pool   = true // if not enabled we run out of ip addresses in subnet 
  cluster_resource_labels = {
    "mesh_id" : "proj-${data.google_project.cinema.number}"
  }

  node_pools = [
    {
      name               = "core"
      machine_type       = var.cinema_node_core_machine_type # slightly above minimum required for Anthos Service Mesh. We easily hit quota with n2
      node_locations     = "us-central1-a,us-central1-b"
      min_count          = var.cinema_node_core_min_count # 2 per zone, with extra for ASM 
      max_count          = var.cinema_node_core_max_count # need to allow for load testing
      local_ssd_count    = 1 
      spot               = false
      disk_size_gb       = var.cinema_node_core_disk_size 
      disk_type          = "pd-standard"
      image_type         = "COS_CONTAINERD"
      enable_gcfs        = false
      enable_gvnic       = false
      auto_repair        = true
      auto_upgrade       = true
      service_account    = var.gke_service_account
      preemptible        = false
      initial_node_count = var.cinema_node_core_initial_count
    },
  ]

  node_pools_oauth_scopes = {
    all = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]
  }

  node_pools_labels = {
    all = {}

    default-node-pool = {
      default-node-pool = true
    }
  }

  node_pools_tags = {
    all = []

    default-node-pool = [
      "default-node-pool",
    ]
  }
}
