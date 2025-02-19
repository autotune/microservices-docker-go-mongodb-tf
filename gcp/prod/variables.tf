###############################################################################
# VARIABLES
###############################################################################

variable "billing_account" {
  type        = string
  description = "ID of the billing account to set a budget on."
  default     = "0150C1-937237-2C8418"
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
  default = "wayofthesys-cinema-363715"
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
  default     = "n2-highmem-8" 
}

# at 10 GB robusta fails with cinema and argocd 
# so we need 20 at least
variable "cinema_node_core_disk_size" {
  type        = string
  description = "Cinema node core machine ssd disk size"
  default     = "20"
}

variable "cinema_node_core_min_count" {
  type        = string
  description = "Cinema node core min node count"
  default     = "4"
}

variable "cinema_node_core_max_count" {
  type        = string
  description = "Cinema node core min node count"
  default     = "8"
}

variable "cinema_node_core_initial_count" {
  type        = string
  description = "Cinema node core min node count"
  default     = "4"
}

variable "gke_external_dns_iam_memeber" {
  type        = string
  description = "GKE ExternalDNS IAM Account Member"
  default     = "serviceAccount:terrateam-tf@wayofthesys-cinema-363715.iam.gserviceaccount.com"
}

variable "gke_external_dns_sa_id" {
  type        = string
  description = "gke externaldns iam service account id"
  default     = "gke-external-dns"
}

variable "gke_cloud_dns_sa_id" {
  type        = string
  description = "gke externaldns iam service account id"
  default     = "gke-cloud-dns"
}

variable "gke_external_dns_namespace" {
  type        = string
  description = "gke externaldns namespace"
  default     = "external-dns"
}

variable "gke_service_account" {
  type        = string
  description = "GKE Service Account Member"
  default     = "terrateam-tf@wayofthesys-cinema-363715.iam.gserviceaccount.com"
}

variable "mongodb_rootusername" {
  type        = string
  description = "MongoDB Root User"
}

variable "mongodb_rootpassword" {
  type        = string
  description = "MongoDB Root Password"
}

variable "argocd_oidc_client_secret" {
  type        = string
  description = "ArgoCD OIDC Client Secret"
}

variable "argocd_oidc_client_id" {
  type        = string
  description = "ArgoCD OIDC Client ID"
  sensitive   = true
}

variable "robusta_signing_key" {
  type        = string
  description = "Robusta Signing Key"
  sensitive   = true
}

variable "robusta_account_id" {
  type        = string
  description = "Robusta Account ID"
  sensitive   = true
}

variable "robusta_slack_api_key" {
  type        = string
  description = "Robusta Slack API Key"
  sensitive   = true
}

variable "robusta_ui_sink_token" {
  type        = string
  description = "Robusta Sink UI token "
  sensitive   = true
}

variable "robusta_rsa_pub_key" {
  type        = string
  description = "Robusta Generated Public Key"
  sensitive   = true
}

variable "robusta_rsa_priv_key" {
  type        = string
  description = "Robusta Generated Private Key"
  sensitive   = true
}

variable "gh_username" {
  type        = string
  description = "GitHub username for container registry"
}

variable "argocd_access_token" {
  type        = string
  description = "ArgoCD Access Token"
}
