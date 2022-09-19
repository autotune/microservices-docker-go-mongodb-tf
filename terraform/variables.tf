###############################################################################
# VARIABLES
###############################################################################

variable "billing_account" {
  type        = string
  description = "ID of the billing account to set a budget on."
  default     = "015525-9D090C-CC8778"
}

variable "billing_spend" {
  type        = string
  description = "Max billing spend to alert on"
  default     = "300"
}

variable "project_id" {
  type        = string
  nullable    = false
  description = "The project ID for the resources"
  # https://cloud.google.com/resource-manager/docs/creating-managing-projects#before_you_begin
  validation {
    # Must be 6 to 30 characters in length.
    # Can only contain lowercase letters, numbers, and hyphens.
    # Must start with a letter.
    # Cannot end with a hyphen.
    condition     = can(regex("^[a-z][a-z0-9-]{4,28}[a-z0-9]$", var.project_id))
    error_message = "Invalid project ID!"
  }
  default = "terrateam-cinema"
}

variable "user_zone_name" {
  type        = string
  description = "User zone name"
  default     = "wayofthesys-com"
}

variable "managed_zone_name" {
  type        = string
  description = "Managed zone name"
  default     = "wayofthesys.com."
}

variable "domain_name" {
  type        = list(any)
  description = "Domain name for ExternalDNS"
  default     = ["wayofthesys.com"]
}

variable "zerossl_email" {
  type        = string
  description = "ZeroSSL Email Address"
}

variable "zerossl_eab_hmac_key" {
  type        = string
  description = "ZeroSSL EAB HMAC KEY"
}

variable "zerossl_eab_hmac_key_id" {
  type        = string
  description = "ZeroSSL EAB HMAC KEY ID"
}

variable "cinema_node_core_machine_type" {
  type        = string
  description = "Cinema node core machine type"
  default     = "n2d-standard-2" // 2 vCPU 8 GB memory
}

variable "cinema_node_core_disk_size" {
  type        = string
  description = "Cinema node core machine ssd disk size"
  default     = "10"
}

variable "cinema_node_core_min_count" {
  type        = string
  description = "Cinema node core min node count"
  default     = "2"
}

variable "cinema_node_core_max_count" {
  type        = string
  description = "Cinema node core min node count"
  default     = "8"
}

variable "cinema_node_core_initial_count" {
  type        = string
  description = "Cinema node core min node count"
  default     = "2"
}

variable "gke_external_dns_iam_memeber" {
  type        = string
  description = "GKE ExternalDNS IAM Account Member"
  default     = "serviceAccount:terrateam-tf@terrateam-cinema.iam.gserviceaccount.com"
}

variable "gke_external_dns_sa_id" {
  type        = string
  description = "gke externaldns iam service account id"
  default     = "gke-external-dns"
}

variable "gke_external_dns_namespace" {
  type        = string
  description = "gke externaldns namespace"
  default     = "dns"
}

variable "gke_service_account" {
  type        = string
  description = "GKE Service Account Member"
  default     = "terrateam-tf@terrateam-cinema.iam.gserviceaccount.com"
}

variable "mongodb_rootusername" {
  type        = string
  description = "MongoDB Root User"
}

variable "mongodb_rootpassword" {
  type        = string
  description = "MongoDB Root Password"
}

variable "gcp_service_list" {
  type        = list(any)
  description = "GCP APIs to enable"
  default = ["mesh.googleapis.com",
    "gkehub.googleapis.com"
  ]
}
