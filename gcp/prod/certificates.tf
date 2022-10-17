resource "kubernetes_manifest" "certificate_argo" {
  depends_on = [module.gke-cinema]
  provider = kubernetes.cinema
  manifest = {
    "apiVersion" = "cert-manager.io/v1"
    "kind"       = "Certificate"
    "metadata" = {
      "name"      = "argocd-cert"
      "namespace" = "istio-system"
    }
    "spec" = {
      "commonName" = "argocd.${var.domain_name[0]}"
      "dnsNames" = [
        "argocd.${var.domain_name[0]}",
      ]
      "issuerRef" = {
        "kind" = "ClusterIssuer"
        "name" = "zerossl"
      }
      "secretName" = "argocd-tls"
    }
  }
}

resource "kubernetes_manifest" "certificate_cinema" {
  depends_on = [module.gke-cinema]
  provider = kubernetes.cinema
  manifest = {
    "apiVersion" = "cert-manager.io/v1"
    "kind"       = "Certificate"
    "metadata" = {
      "name"      = "cinema-cert"
      "namespace" = "cinema"
    }
    "spec" = {
      "commonName" = var.domain_name[0]
      "dnsNames" = [
        var.domain_name[0],
      ]
      "issuerRef" = {
        "kind" = "ClusterIssuer"
        "name" = "zerossl"
      }
      "secretName" = "${replace(var.domain_name[0], ".", "-")}-tls"
    }
  }
}
