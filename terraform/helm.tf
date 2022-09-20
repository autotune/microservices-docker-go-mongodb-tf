resource "helm_release" "cluster-issuer" {
  provider  = helm.cinema
  name      = "cluster-issuer"
  chart     = "../charts/cluster-issuer"
  namespace = "kube-system"
  depends_on = [
    helm_release.cert-manager,
    module.gke-cinema,
  ]
  set_sensitive {
    name  = "zerossl_email"
    value = var.zerossl_email
  }
  set_sensitive {
    name  = "zerossl_eab_hmac_key"
    value = var.zerossl_eab_hmac_key
  }
  set_sensitive {
    name  = "zerossl_eab_hmac_key_id"
    value = var.zerossl_eab_hmac_key
  }
}

resource "helm_release" "cert-manager" {
  provider   = helm.cinema
  depends_on = [module.gke-cinema]
  name       = "cert-manager"
  repository = "https://charts.jetstack.io"
  chart      = "cert-manager"
  version    = "v1.9.1"
  namespace  = "kube-system"
  timeout    = 120
  set {
    name  = "createCustomResource"
    value = "true"
  }
  set {
    name  = "installCRDs"
    value = "true"
  }
}

resource "helm_release" "external-dns" {
  provider   = helm.cinema
  depends_on = [module.gke-cinema, module.external-dns, kubernetes_secret.external-dns-credentials]
  name       = "external-dns"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "external-dns"
  version    = "v6.9.0"
  namespace  = var.gke_external_dns_namespace
  timeout    = 120
  set {
    name  = "provider"
    value = "google"
  }
  set {
    name  = "google.serviceAccountSecret"
    value = "external-dns"
  }
  set {
    name  = "policy"
    value = "sync"
  }
  set {
    name  = "rbac.create"
    value = "true"
  }
  set {
    name  = "domainFilters"
    value = "{${var.domain_name[0]}}"
  }
  set {
    name  = "sources"
    value = "{ingress,service}"
  }
}

resource "helm_release" "nginx-ingress-chart" {
  provider   = helm.cinema
  name       = "nginx-ingress-controller"
  namespace  = "default"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "nginx-ingress-controller"
}

resource "helm_release" "cinema" {
  provider   = helm.cinema
  name       = "cinema"
  namespace  = "cinema"
  chart      = "../charts/cinema"
  depends_on = [kubernetes_namespace.cinema, kubernetes_secret.mongodb-auth]
  set {
    name  = "mongodb.auth.enabled"
    value = "true"
  }
  set_sensitive {
    name  = "mongodb.auth.rootUser"
    value = var.mongodb_rootusername
  }
  set_sensitive {
    name  = "mongodb.auth.rootPassword"
    value = var.mongodb_rootpassword
  }
}

resource "helm_release" "istio-base" {
  provider        = helm.cinema
  repository      = local.istio-repo
  name            = "istio-base"
  chart           = "base"
  cleanup_on_fail = true
  force_update    = true
  namespace       = kubernetes_namespace.istio-system.metadata.0.name

  depends_on = [kubernetes_namespace.istio-system]
}

resource "helm_release" "istiod" {
  provider        = helm.cinema
  repository      = local.istio-repo
  name            = "istiod"
  chart           = "istiod"
  cleanup_on_fail = true
  force_update    = true
  namespace       = kubernetes_namespace.istio-system.metadata.0.name

  set {
    name  = "meshConfig.accessLogFile"
    value = "/dev/stdout"
  }

  set {
    name  = "grafana.enabled"
    value = "true"
  }

  set {
    name  = "kiali.enabled"
    value = "true"
  }

  set {
    name  = "servicegraph.enabled"
    value = "true"
  }

  set {
    name  = "tracing.enabled"
    value = "true"
  }

  depends_on = [helm_release.istio-base]
}

resource "helm_release" "istio-ingress" {
  repository = local.istio-repo
  name       = "istio-ingressgateway"
  chart      = "gateway"

  cleanup_on_fail = true
  force_update    = true
  namespace       = kubernetes_namespace.istio-system.metadata.0.name

  /*
  set {
    name  = "service.loadBalancerIP"
    value = var.loadBalancer_IP
  }
  */
  depends_on = [helm_release.istiod]
}

resource "helm_release" "istio-egress" {
  repository = local.istio-repo
  name       = "istio-egressgateway"
  chart      = "gateway"

  cleanup_on_fail = true
  force_update    = true
  namespace       = kubernetes_namespace.istio-system.metadata.0.name

  set {
    name  = "service.type"
    value = "ClusterIP"
  }
  depends_on = [helm_release.istiod]
}
