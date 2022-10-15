resource "kubernetes_service_account" "argocd-manager" {
  provider = kubernetes.cinema
  metadata {
    name      = "argocd-manager"
    namespace = "kube-system"
  }
  secret {
    name = kubernetes_secret.argocd-manager.metadata.0.name
  }
}

/*
resource "kubernetes_service_account" "loadtesting_manager" {
  provider = kubernetes.loadtesting
  metadata {
    name      = "loadtesting-manager"
    namespace = "kube-system"
  }
}
*/
