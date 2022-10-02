locals {
  istio-repo    = "https://istio-release.storage.googleapis.com/charts"
  jetstack-repo = "https://charts.jetstack.io"
  bookinfo-repo = "https://evry-ace.github.io/helm-charts"
  argocd-repo   = "https://argoproj.github.io/argo-helm"
  argocd_dex_google = yamlencode(
    {
      server = {
        config = {
          "admin.enabled" = "true"
          "url"           = "https://argocd.${var.domain_name[0]}"
          "dex.config" = yamlencode(
            {
              connectors = [
                {
                  id   = "google"
                  type = "oidc"
                  name = "Google"
                  config = {
                    issuer       = "https://accounts.google.com"
                    clientID     = var.argocd_oidc_client_id
                    clientSecret = var.argocd_oidc_client_secret
                  }
                  requestedScopes = [
                    "-openid",
                    "-profile",
                    "-email"
                  ]
                }
              ]
            }
          )
        }
      }
    }
  )
  argocd_dex_rbac = yamlencode(
    {
      server = {
        rbacConfig = {
          "policy.csv" = replace(yamlencode(
            [
              "g, autotune@contrasting.org, role:admin",
            ],
            "policy.default: readOnly",
            "scopes: '[email]'"
            ),
          "\"-", "")
        }
      }
    }
  )
}
