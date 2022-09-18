resource "kubernetes_namespace" "cinema" {
  depends_on = [module.gke-cinema]
  provider   = kubernetes.cinema
  metadata {
    name = "cinema"
  }
}

resource "kubernetes_namespace" "external-dns" {
  depends_on = [module.gke-cinema]
  provider   = kubernetes.cinema
  metadata {
    name = "dns"
  }
}
