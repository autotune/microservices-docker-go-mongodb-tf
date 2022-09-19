locals {
  # Example annotations when using Nginx ingress controller as shown here https://argoproj.github.io/argo-cd/operator-manual/ingress/#option-1-ssl-passthrough
  argocd_ingress_annotations = {
    "kubernetes.io/ingress.class" = "nginx"
    "nginx.ingress.kubernetes.io/force-ssl-redirect" = "true"
    "nginx.ingress.kubernetes.io/ssl-passthrough" = "true"
  }
}

