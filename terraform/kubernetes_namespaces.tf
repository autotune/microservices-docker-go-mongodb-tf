resource "kubernetes_namespace" "cinema" {
  depends_on = [module.gke-cinema]
  provider   = kubernetes.cinema
  metadata {
    name = "cinema"
  }
}

resource "kubernetes_namespace" "external-dns" {
  depends_on = [module.gke-cinema]
  provider   = kubernetes.cinema
  metadata {
    name = "dns"
  }
}

resource "kubernetes_namespace" "istio-gateway" {
  depends_on = [module.gke-cinema]
  provider   = kubernetes.cinema
  metadata {
    name = "istio-gateway"
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
