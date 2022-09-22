resource "kubernetes_ingress_v1" "cinema" {
  provider   = kubernetes.cinema
  depends_on = [
    helm_release.nginx-ingress-chart, 
    helm_release.cinema 
  ]
  for_each = toset(var.domain_name)
  metadata {
    name = "${each.key}-cinema-ingress"
    namespace  = "cinema"
    annotations = {
        "kubernetes.io/ingress.class" = "nginx"
        "ingress.kubernetes.io/rewrite-target" = "/"
        "cert-manager.io/cluster-issuer" = "zerossl"
    }
  }
  spec {
    dynamic "rule" {
      for_each = toset(var.domain_name)
      content {
        host = "${rule.value}"
        http {
          path {
            backend {
              service {
                name = "cinema-website"
              port {
                number = 80
              }
             }
            }
            path = "/"
          }
        }
      }
    }
    dynamic "tls" {
      for_each = toset(var.domain_name)
      content {
        secret_name = "${replace(tls.value, ".", "-")}-cinema-tls"
        hosts = ["${tls.value}"]
      }
    }
  }
}
