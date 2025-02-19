module "vpc-cinema" {
  source  = "terraform-google-modules/network/google"
  version = "~> 4.0"

  project_id   = var.project_id
  network_name = "cinema"
  routing_mode = "GLOBAL"

  subnets = [
    {
      subnet_name   = "prod"
      subnet_ip     = "10.1.0.0/16"
      subnet_region = "us-central1"
    }
  ]

  secondary_ranges = {
    prod = [
      {
        range_name    = "us-central1-01-gke-01-pods"
        ip_cidr_range = "10.4.0.0/16"
      },
      {
        range_name    = "us-central1-01-gke-01-services"
        ip_cidr_range = "10.8.0.0/16"
      },
    ]
  }

  routes = [
    {
      name              = "egress-internet"
      description       = "route through IGW to access internet"
      destination_range = "0.0.0.0/0"
      tags              = "egress-inet"
      next_hop_internet = "true"
    }
  ]
}

module "vpc-loadtesting" {
  source  = "terraform-google-modules/network/google"
  version = "~> 4.0"

  project_id   = var.project_id
  network_name = "loadtesting"
  routing_mode = "GLOBAL"

  subnets = [
    {
      subnet_name   = "loadtesting"
      subnet_ip     = "10.2.0.0/16"
      subnet_region = "us-central1"
    }
  ]

  secondary_ranges = {
    loadtesting = [
      {
        range_name    = "us-central1-01-gke-02-pods"
        ip_cidr_range = "10.3.0.0/16"
      },
      {
        range_name    = "us-central1-01-gke-02-services"
        ip_cidr_range = "10.9.0.0/16"
      },
    ]
  }

  routes = [
    {
      name              = "egress-internet-loadtesting"
      description       = "route through IGW to access internet"
      destination_range = "0.0.0.0/0"
      tags              = "egress-inet"
      next_hop_internet = "true"
    }
  ]
}
