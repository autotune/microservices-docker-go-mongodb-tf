resource "kubernetes_manifest" "cinema-virtualservice" {
  provider   = kubernetes.cinema
  depends_on = [module.gke-cinema, kubernetes_namespace.cinema]
  manifest = {
    "apiVersion" = "networking.istio.io/v1alpha3"
    "kind"       = "VirtualService"
    "metadata" = {
      "name"      = "website-ingress"
      "namespace" = "cinema"
    }
    "spec" = {
      "gateways" = [
        "website-gateway",
      ]
      "hosts" = [
        var.domain_name[0],
      ]
      "http" = [
        {
          "route" = [
            {
              "destination" = {
                "host" = "website"
                "port" = {
                  "number" = 80
                }
              }
            },
          ]
        },
      ]
    }
  }
}
