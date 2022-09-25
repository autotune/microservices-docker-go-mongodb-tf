resource "kubernetes_ingress_v1" "argocd_ingress" {
  provider = kubernetes.cinema
  metadata {
    name      = "argocd-ingress"
    namespace = "argocd"
    annotations = {
      "kubernetes.io/ingress.class" = "nginx"
    }
  }

  spec {
    backend {
      service_name = "argocd-argo-cd-server"
      service_port = 80
    }

    rule {
     host = "argocd.wayofthesys.org"
      http {
        path {
          backend {
            service_name = "argocd-argo-cd-server"
            service_port = 80
          }

          path = "/"
        }
       }
      }
    }
  
  // tls {
  //  secret_name = "argocd-secret"
  // }
}

