resource "kubernetes_secret" "zerossl-eab-hmac-key" {
  provider   = kubernetes.cinema
  depends_on = [module.gke-cinema]
  metadata {
    name      = "zerossl-eab-hmac-key"
    namespace = "kube-system"
  }

  data = {
    secret = var.zerossl_eab_hmac_key
  }

  type = "kubernetes.io/opaque"
}

resource "kubernetes_secret" "zerossl-eab-hmac-key-id" {
  provider   = kubernetes.cinema
  depends_on = [module.gke-cinema]
  metadata {
    name      = "zerossl-eab-hmac-key-id"
    namespace = "kube-system"
  }

  data = {
    secret = var.zerossl_eab_hmac_key_id
  }

  type = "kubernetes.io/opaque"
}

resource "kubernetes_secret" "mongodb-auth" {
  provider   = kubernetes.cinema
  depends_on = [module.gke-cinema, kubernetes_namespace.cinema]
  metadata {
    name      = "mongodb-auth"
    namespace = "cinema"
  }

  data = {
    username = var.mongodb_rootusername
    password = var.mongodb_rootpassword
  }

  type = "kubernetes.io/opaque"
}

resource "kubernetes_secret" "argocd-tls" {
  provider   = kubernetes.cinema
  depends_on = [module.gke-cinema, helm_release.external-dns, kubernetes_namespace.cinema]
  metadata {
    name = "argocd-tls"
    # "${replace(var.domain_name[0], ".", "-")}-tls"
    namespace = "istio-system"
  }
  type = "tls"
  data = {
    "tls.crt" = tls_locally_signed_cert.cert.cert_pem
    "tls.key" = tls_private_key.key.private_key_pem
  }

  lifecycle {
    ignore_changes = [
      data,
      metadata
    ]
  }
}

resource "kubernetes_secret" "wayofthesys-tls" {
  provider   = kubernetes.cinema
  depends_on = [module.gke-cinema, kubernetes_namespace.cinema]
  metadata {
    name      = "${replace(var.domain_name[0], ".", "-")}-tls"
    namespace = "istio-system"
  }

  data = {
    "tls.crt" = tls_locally_signed_cert.cert.cert_pem
    "tls.key" = tls_private_key.key.private_key_pem
  }

  lifecycle {
    ignore_changes = [
      data,
      metadata
    ]

  }
}

resource "kubernetes_secret" "external-dns-credentials" {
  provider   = kubernetes.cinema
  depends_on = [module.gke-cinema, module.external-dns]
  metadata {
    name      = "external-dns"
    namespace = var.gke_external_dns_namespace
  }

  data = {
    "credentials.json" = base64decode(google_service_account_key.external-dns.private_key)
  }

  type = "kubernetes.io/opaque"
}
