resource "kubernetes_manifest" "allow-egress-googlemetadata" {
  provider   = kubernetes.cinema
  depends_on = [module.gke-cinema, kubernetes_namespace.cinema]
  namespace  = "cinema"
  manifest = {
    "apiVersion" = "networking.istio.io/v1alpha3"
    "kind"       = "ServiceEntry"
    "metadata" = {
      "name" = "allow-egress-google-metadata"
    }
    "spec" = {
      "addresses" = [
        "169.254.169.254",
      ]
      "hosts" = [
        "metadata.google.internal",
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
