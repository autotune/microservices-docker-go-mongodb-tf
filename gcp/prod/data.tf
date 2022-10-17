data "kubernetes_secret" "argocd-manager" {
  depends_on = [kubernetes_secret.argocd-manager]
  provider   = kubernetes.cinema
  metadata {
    name      = "argocd-manager" # kubernetes_service_account.argocd-manager.default_secret_name
    namespace = "kube-system"
  }
}

data "kubernetes_secret" "loadtesting-manager" {
  depends_on = [kubernetes_secret.loadtesting-manager]
  provider   = kubernetes.loadtesting
  metadata {
    name      = "loadtesting-manager" # kubernetes_service_account.argocd-manager.default_secret_name
    namespace = "kube-system"
  }
}
