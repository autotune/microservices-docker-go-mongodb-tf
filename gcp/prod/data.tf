data "kubernetes_secret" "argocd-manager" {
  depends_on = [kubernetes_secret.argocd-manager]
  provider   = kubernetes.cinema
  metadata {
    name      = "argocd-manager" # kubernetes_service_account.argocd_manager.default_secret_name
    namespace = "kube-system"
  }
}
