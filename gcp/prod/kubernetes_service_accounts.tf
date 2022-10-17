resource "kubernetes_service_account" "argocd-manager" {
  provider = kubernetes.cinema
  metadata {
    name      = "argocd-manager"
    namespace = "kube-system"
  }
}

resource "kubernetes_service_account" "argocd-loadtesting" {
  provider = kubernetes.loadtesting
  metadata {
    name      = "argocd-loadtesting"
    namespace = "kube-system"
  }
}
