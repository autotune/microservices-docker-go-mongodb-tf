# UNCOMMENT AFTER CLUSTER CREATION
/*
resource "kubernetes_manifest" "argocd_virtualservice" {
  provider   = kubernetes.cinema
  depends_on = [module.gke-cinema, helm_release.argocd]
  manifest = {
    "apiVersion" = "networking.istio.io/v1beta1"
    "kind"       = "VirtualService"
    "metadata" = {
      "name"      = "argocd"
      "namespace" = "argocd"
    }
    "spec" = {
      "gateways" = [
        "argocd",
      ]
      "hosts" = [
        "argocd.${var.domain_name[0]}",
      ]
      "http" = [
        {
          "match" = [
            {
              "uri" = {
                "prefix" = "/"
              }
            },
          ]
          "route" = [
            {
              "destination" = {
                "host" = "argocd-server"
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
*/
