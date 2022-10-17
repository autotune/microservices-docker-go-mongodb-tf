resource "kubernetes_service_account" "argocd-manager" {
  provider = kubernetes.cinema
  metadata {
    name      = "argocd-manager"
    namespace = "kube-system"
  }
}

resource "kubernetes_service_account" "loadtesting-manager" {
  provider = kubernetes.loadtesting
  metadata {
    name      = "loadtesting-manager"
    namespace = "kube-system"
  }
}
