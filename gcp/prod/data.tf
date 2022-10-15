data "kubernetes_secret" "argocd-manager" {
  depends_on = [kubernetes_secret.argocd-manager]
  provider   = kubernetes.cinema
  metadata {
    name      = kubernetes_service_account.argocd-manager.default_secret_name
    namespace = "kube-system"
  }
}
