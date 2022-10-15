resource "kubernetes_namespace" "cinema" {
  depends_on = [module.gke-cinema]
  provider   = kubernetes.cinema
  metadata {
    name = "cinema"
  }
}

resource "kubernetes_namespace" "cert-manager" {
  depends_on = [module.gke-cinema]
  provider   = kubernetes.cinema
  metadata {
    name = "cert-manager"
  }
  labels = {
    "istio-injection" = "enabled"
  }
}

resource "kubernetes_namespace" "external-dns" {
  depends_on = [module.gke-cinema]
  provider   = kubernetes.cinema
  metadata {
    name = "external-dns"
  }
}

resource "kubernetes_namespace" "istio-system" {
  depends_on = [module.gke-cinema]
  provider   = kubernetes.cinema
  metadata {
    name = "istio-system"
  }
}

resource "kubernetes_namespace" "argocd" {
  depends_on = [module.gke-cinema]
  provider   = kubernetes.cinema
  metadata {
    name = "argocd"
  }
}

resource "kubernetes_labels" "default-istio" {
  api_version = "v1"
  provider    = kubernetes.cinema
  kind        = "Namespace"
  metadata {
    name = "default"
  }
  labels = {
    "istio.io/rev" = "asm-managed-regular"
  }
}

resource "kubernetes_annotations" "cinema" {
  api_version = "v1"
  provider    = kubernetes.cinema
  kind        = "Namespace"
  metadata {
    name = "cinema"
  }
  annotations = {
    "mesh.cloud.google.com/proxy" = "{\"managed\":\"true\"}"
  }
}

resource "kubernetes_namespace" "istio-ingress" {
  depends_on = [module.gke-cinema]
  provider   = kubernetes.cinema
  metadata {
    name = "istio-ingress"

    labels = {
      istio-injection = "enabled"
    }

  }
}

resource "kubernetes_namespace" "istio-egress" {
  depends_on = [module.gke-cinema]
  provider   = kubernetes.cinema
  metadata {
    name = "istio-egress"

    labels = {
      istio-injection = "enabled"
    }

  }
} 
