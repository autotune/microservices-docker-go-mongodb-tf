resource "google_identity_platform_oauth_idp_config" "oauth_idp_config" {
  name          = "ArgoCD"
  display_name  = "ArgoCD"
  client_id     = "argocd"
  issuer        = "https://accounts.google.com"
  enabled       = true
  client_secret = var.argocd_oidc_secret
}
