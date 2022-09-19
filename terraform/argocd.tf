module "argocd" {
  source              = "https://github.com/autotune/infrastructure/tree/master/terraform/modules/terraform-argocd"
  git_url             = var.argocd_gitops_repo
  git_access_token    = var.argocd_access_token
  ingress_host        = "argocd.${var.managed_zone_name}"
  ingress_annotations = local.argocd_ingress_annotations

  module_depends_on = [hem_release.external_dns, helm_release.nginx-ingress-chart, helm_release.cert_manager]
}
