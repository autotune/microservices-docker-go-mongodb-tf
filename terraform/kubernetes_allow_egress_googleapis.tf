resource "kubernetes_manifest" "allow-egress-googleapis" {
  provider   = kubernetes.cinema
  depends_on = [module.gke-cinema, kubernetes_namespace.cinema]
  manifest = {
    "apiVersion" = "networking.istio.io/v1alpha3"
    "kind"       = "ServiceEntry"
    "metadata" = {
      "name"       = "allow-egress-googleapis"
      "namespace"  = "cinema"
    }
    "spec" = {
      "hosts" = [
        "accounts.google.com",
        "*.googleapis.com",
      ]
      "ports" = [
        {
          "name"     = "http"
          "number"   = 80
          "protocol" = "HTTP"
        },
        {
          "name"     = "https"
          "number"   = 443
          "protocol" = "HTTPS"
        },
      ]
    }
  }
}
