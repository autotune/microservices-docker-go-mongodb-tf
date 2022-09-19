module "asm" {
  providers = {
    kubernetes = kubernetes.cinema
  }
  source                    = "terraform-google-modules/kubernetes-engine/google//modules/asm"
  project_id                = var.project_id
  cluster_name              = module.gke-cinema.name
  cluster_location          = module.gke-cinema.location
  enable_cni                = true
  enable_fleet_registration = true
  enable_mesh_feature       = true
}
