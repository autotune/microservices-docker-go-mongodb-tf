resource "kubernetes_manifest" "argocd_virtualservice" {
  provider = kubernetes.cinema
  depends_on = [helm_release.argocd] 
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

resource "kubernetes_manifest" "cinema_virtualservice" {
  provider = kubernetes.cinema
  depends_on = [helm_release.argocd]
  manifest = {
    "apiVersion" = "networking.istio.io/v1beta1"
    "kind"       = "VirtualService"
    "metadata" = {
      "name"      = "cinema"
      "namespace" = "cinema"
    }
    "spec" = {
      "gateways" = [
        "cinema",
      ]
      "hosts" = [
        var.domain_name[0],
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
                "host" = "cinema-website"
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

resource "kubernetes_manifest" "cinema_bookings_virtualservice" {
  provider = kubernetes.cinema
  depends_on = [helm_release.argocd]
  manifest = {
    "apiVersion" = "networking.istio.io/v1beta1"
    "kind"       = "VirtualService"
    "metadata" = {
      "name"      = "cinema-bookings"
      "namespace" = "cinema"
    }
    "spec" = {
      "gateways" = [
        "cinema",
      ]
      "hosts" = [
        var.domain_name[0],
      ]
      "http" = [
        {
          "match" = [
            {
              "uri" = {
                "prefix" = "/api/bookings"
              }
            },
          ]
          "route" = [
            {
              "destination" = {
                "host" = "cinema-bookings"
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

resource "kubernetes_manifest" "cinema_showtimes_virtualservice" {
  provider = kubernetes.cinema
  depends_on = [helm_release.argocd]
  manifest = {
    "apiVersion" = "networking.istio.io/v1beta1"
    "kind"       = "VirtualService"
    "metadata" = {
      "name"      = "cinema-bookings"
      "namespace" = "cinema"
    }
    "spec" = {
      "gateways" = [
        "cinema",
      ]
      "hosts" = [
        var.domain_name[0],
      ]
      "http" = [
        {
          "match" = [
            {
              "uri" = {
                "prefix" = "/api/showtimes"
              }
            },
          ]
          "route" = [
            {
              "destination" = {
                "host" = "cinema-showtimes"
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
