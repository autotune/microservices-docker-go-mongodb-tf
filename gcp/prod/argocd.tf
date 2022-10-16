resource "argocd_cluster" "gcp-cinema" {
  provider   = argocd
  server     = "https://${module.gke-cinema.endpoint}"
  name       = "gcp-cinema"
  depends_on = [helm_release.argocd, kubernetes_secret.argocd-manager]

  config {
    bearer_token = data.kubernetes_secret.argocd-manager.data["token"]
    tls_client_config {
      ca_data = data.kubernetes_secret.argocd-manager.data["ca.crt"]
    }
  }
}

/*
resource "argocd_project" "metrics-server" {
  depends_on = [helm_release.argocd]
  metadata {
    name      = "metrics-server"
    namespace = "argocd"
    labels = {
      environment = "dev"
    }
  }

  spec {

    cluster_resource_whitelist {
      group = "*"
      kind  = "*"
    }

    namespace_resource_whitelist {
      group = "*"
      kind  = "*"
    }

    description  = "Metrics Server"
    source_repos = ["https://github.com/kubernetes-sigs/metrics-server"]

    destination {
      server    = "https://${module.gke-cinema.endpoint}"
      namespace = "cinama"
    }
  }
}

resource "argocd_application" "metrics-server" {
  depends_on = [argocd_project.cinema]
  metadata {
    name      = "metrics-server"
    namespace = "argocd"
    labels = {
      env = "dev"
    }
  }

  wait = true

  spec {
    project = "cinema"
    source {
      helm {
        release_name = "metrics-server"

        parameter {
          name  = "args[0]"
          value = "--kubelet-insecure-tls"
        }

        parameter {
          name  = "args[1]"
          value = "--kubelet-preferred-address-types=InternalIP,ExternalIP"
        }

      }
      repo_url        = "https://github.com/kubernetes-sigs/metrics-server"
      path            = "charts/metrics-server"
      target_revision = "master"
    }

    destination {
      server    = "https://${module.gke-cinema.endpoint}"
      namespace = "cinema"
    }
  }
}
*/

/*
resource "argocd_cluster" "do-loadtesting" {
  server     = digitalocean_kubernetes_cluster.loadtesting.endpoint
  name       = "do-loadtesting"
  depends_on = [helm_release.argocd]

  config {
    bearer_token = data.kubernetes_secret.loadtesting_manager.data["token"]
    tls_client_config {
      ca_data = data.kubernetes_secret.loadtesting_manager.data["ca.crt"]
    }
  }
}
*/

resource "argocd_repository_credentials" "cinema" {
  depends_on      = [helm_release.argocd]
  url             = "git@github.com:autotune/microservices-docker-go-mongodb-tf.git"
  username        = "git"
  ssh_private_key = tls_private_key.argocd.private_key_openssh
}

resource "argocd_project" "cinema" {
  depends_on = [helm_release.argocd]
  metadata {
    name      = "cinema"
    namespace = "argocd"
    labels = {
      environment = "dev"
    }
  }

  spec {

    cluster_resource_whitelist {
      group = "*"
      kind  = "*"
    }

    description  = "Cinema"
    source_repos = ["https://github.com/autotune/microservices-docker-go-mongodb-tf", "https://kedacore.github.io/charts", "https://robusta-charts.storage.googleapis.com", "https://github.com/kubernetes-sigs/metrics-server"]

    destination {
      server    = "https://kubernetes.default.svc"
      namespace = "cinema"
    }

    destination {
      server    = "https://${module.gke-cinema.endpoint}"
      namespace = "kube-system"
    }
    destination {
      server    = "https://${module.gke-cinema.endpoint}"
      namespace = "cinema"
    }
    destination {
      server    = "https://${module.gke-cinema.endpoint}"
      namespace = "kube-system"
    }
    /*
    destination {
      server    = "https://${module.gke-cinema.endpoint}"
      namespace = "loadtesting"
    }
    */
    destination {
      server    = "https://${module.gke-cinema.endpoint}"
      namespace = "robusta"
    }
  }
}

/*
resource "argocd_project" "loadtesting" {
  depends_on = [helm_release.argocd]
  metadata {
    name      = "loadtesting"
    namespace = "argocd"
    labels = {
      environment = "dev"
    }
  }

  spec {

    cluster_resource_whitelist {
      group = "*"
      kind  = "*"
    }

    description  = "loadtesting"
    source_repos = ["https://github.com/autotune/loadtesting", "https://kedacore.github.io/charts"]

    destination {
      server    = digitalocean_kubernetes_cluster.loadtesting.endpoint
      namespace = "loadtesting"
    }

    destination {
      server    = digitalocean_kubernetes_cluster.loadtesting.endpoint
      namespace = "kube-system"
    }
  }
}
*/

resource "argocd_application" "cinema" {
  depends_on = [argocd_project.cinema, argocd_cluster.gcp-cinema, argocd_repository_credentials.cinema]
  metadata {
    name      = "cinema"
    namespace = "argocd"
    labels = {
      env = "dev"
    }
  }

  wait = true

  spec {
    project = "cinema"
    source {
      helm {
        release_name = "cinema"

        parameter {
          name  = "website.domainName"
          value = var.domain_name[0]
        }

        parameter {
          name  = "website.domainNametls"
          value = "${replace(var.domain_name[0], ".", "-")}-tls"
        }

      }
      repo_url        = "https://github.com/autotune/microservices-docker-go-mongodb-tf"
      path            = "charts/cinema"
      target_revision = "main"
    }
    destination {
      server    = "https://${module.gke-cinema.endpoint}"
      namespace = "cinema"
    }
  }
}

resource "argocd_application" "cinema-robusta" {
  depends_on = [argocd_project.cinema, kubernetes_namespace.robusta, argocd_cluster.gcp-cinema, argocd_repository_credentials.cinema]
  provider   = argocd
  metadata {
    name      = "robusta"
    namespace = "argocd"
    labels = {
      env = "dev"
    }
  }

  wait = true

  spec {
    project = "cinema"
    source {
      helm {
        release_name = "robusta"

        skip_crds = "false"

        values = <<-EOT
customPlaybooks:
- actions:
  - resource_babysitter:
      fields_to_monitor:
      - replicas
  triggers:
  - on_replicaset_update: 
      name_prefix: ""
EOT 
        parameter {
          name  = "globalConfig.signing_key"
          value = var.robusta_signing_key
        }

        parameter {
          name  = "enablePrometheusStack"
          value = "true"
        }

        parameter {
          name  = "playbooksPersistentVolume"
          value = "true"
        }

        parameter {
          name  = "enablePlatformPlaybooks"
          value = "true"
        }

        parameter {
          name  = "playbookRepos.my_extra_playbooks.url"
          value = "https://github.com/autotune/demo-actions-robusta"
        }

        /*
        parameter {
          name  = "customPlaybooks[0].triggers[0].on_replicaset_update[0].name_prefix"
          value = "{}"
        }

        parameter {
          name  = "customPlaybooks[0].triggers.actions[0].resource_babysitter.fields_to_monitor[0]"
          value = "spec.replicas"
        }
        */

        parameter {
          name  = "runner.sendAdditionalTelemetry"
          value = "false"
        }

        parameter {
          name  = "clusterName"
          value = "gke-cinema"
        }

        parameter {
          name  = "globalConfig.account_id"
          value = var.robusta_account_id
        }

        parameter {
          name  = "sinksConfig[1].slack_sink.name"
          value = "main_slack_sink"
        }

        parameter {
          name  = "sinksConfig[1].slack_sink.slack_channel"
          value = "robusta-gcp"
        }

        parameter {
          name  = "sinksConfig[1].slack_sink.api_key"
          value = var.robusta_slack_api_key
        }

        parameter {
          name  = "sinksConfig[0].robusta_sink.name"
          value = "robusta_ui_sink"
        }

        parameter {
          name  = "sinksConfig[0].robusta_sink.token"
          value = var.robusta_ui_sink_token
        }

        parameter {
          name  = "rsa.pub"
          value = var.robusta_rsa_pub_key
        }

        parameter {
          name  = "rsa.prv"
          value = var.robusta_rsa_priv_key
        }

      }

      repo_url        = "https://robusta-charts.storage.googleapis.com"
      chart           = "robusta"
      target_revision = "0.10.6"
    }
    destination {
      server    = "https://${module.gke-cinema.endpoint}"
      namespace = "robusta"
    }
    # we run into https://blog.ediri.io/kube-prometheus-stack-and-argocd-23-how-to-remove-a-workaround
    # if replace=true not enabled 
    sync_policy {
      sync_options = ["Replace=true"]
    }
  }
}

/*
resource "argocd_application" "cinema-keda" {
  depends_on = [argocd_project.cinema, argocd_cluster.gcp-cinema]
  metadata {
    name      = "cinema-keda"
    namespace = "argocd"
    labels = {
      env = "dev"
    }
  }

  wait = true

  spec {
    project = "cinema"
    source {
      helm {
        release_name = "keda"
      }
      repo_url        = "https://kedacore.github.io/charts"
      chart           = "keda"
      target_revision = "2.8.2"
    }
    destination {
      server    = "https://${module.gke-cinema.endpoint}"
      namespace = "cinema"
    }
  }
}

resource "argocd_application" "keda-loadtesting" {
  depends_on = [argocd_project.loadtesting]
  metadata {
    name      = "keda-loadtesting"
    namespace = "argocd"
    labels = {
      env = "dev"
    }
  }

  wait = true

  spec {
    project = "loadtesting"
    source {
      helm {
        release_name = "keda"
      }
      repo_url        = "https://kedacore.github.io/charts"
      chart           = "keda"
      target_revision = "2.8.2"
    }
    destination {
      server    = digitalocean_kubernetes_cluster.loadtesting.endpoint
      namespace = "loadtesting"
    }
  }
}

resource "argocd_application" "keda-scaledobject-cinema-bookings" {
  depends_on = [argocd_application.cinema-keda]
  metadata {
    name      = "keda-cinema-bookings"
    namespace = "argocd"
    labels = {
      env = "dev"
    }
  }

  wait = true

  spec {
    project = "cinema"
    source {
      helm {
        release_name = "keda-cron"
        parameter {
          name  = "keda.name"
          value = "cinema-bookings"
        }
        parameter {
          name  = "keda.namespace"
          value = "cinema"
        }
        parameter {
          name  = "keda.scaletargetname"
          value = "cinema-bookings"
        }
      }
      repo_url        = "https://github.com/autotune/microservices-docker-go-mongodb-tf"
      target_revision = "main"
      path            = "charts/keda"
    }
    destination {
      server    = "https://${module.gke-cinema.endpoint}"
      namespace = "cinema"
    }
  }
}

resource "argocd_application" "keda-scaledobject-cinema-users" {
  depends_on = [argocd_application.cinema-keda]
  metadata {
    name      = "keda-cinema-users"
    namespace = "argocd"
    labels = {
      env = "dev"
    }
  }

  wait = true

  spec {
    project = "cinema"
    source {
      helm {
        release_name = "keda-cron"
        parameter {
          name  = "keda.name"
          value = "cinema-users"
        }
        parameter {
          name  = "keda.namespace"
          value = "cinema"
        }
        parameter {
          name  = "keda.scaletargetname"
          value = "cinema-users"
        }
      }
      repo_url        = "https://github.com/autotune/microservices-docker-go-mongodb-tf"
      target_revision = "main"
      path            = "charts/keda"
    }
    destination {
      server    = "https://${module.gke-cinema.endpoint}"
      namespace = "cinema"
    }
  }
}

resource "argocd_application" "keda-scaledobject-cinema-movies" {
  depends_on = [argocd_application.cinema-keda]
  metadata {
    name      = "keda-cinema-movies"
    namespace = "argocd"
    labels = {
      env = "dev"
    }
  }

  wait = true

  spec {
    project = "cinema"
    source {
      helm {
        release_name = "keda-cron"
        parameter {
          name  = "keda.name"
          value = "cinema-movies"
        }
        parameter {
          name  = "keda.namespace"
          value = "cinema"
        }
        parameter {
          name  = "keda.scaletargetname"
          value = "cinema-movies"
        }
      }
      repo_url        = "https://github.com/autotune/microservices-docker-go-mongodb-tf"
      target_revision = "main"
      path            = "charts/keda"
    }
    destination {
      server    = "https://${module.gke-cinema.endpoint}"
      namespace = "cinema"
    }
  }
}

resource "argocd_application" "keda-scaledobject-cinema-showtimes" {
  depends_on = [argocd_application.cinema-keda]
  metadata {
    name      = "keda-cinema-showtimes"
    namespace = "argocd"
    labels = {
      env = "dev"
    }
  }

  wait = true

  spec {
    project = "cinema"
    source {
      helm {
        release_name = "keda-cron"
        parameter {
          name  = "keda.name"
          value = "cinema-showtimes"
        }
        parameter {
          name  = "keda.namespace"
          value = "cinema"
        }
        parameter {
          name  = "keda.scaletargetname"
          value = "cinema-showtimes"
        }
      }
      repo_url        = "https://github.com/autotune/microservices-docker-go-mongodb-tf"
      target_revision = "main"
      path            = "charts/keda"
    }
    destination {
      server    = "https://${module.gke-cinema.endpoint}"
      namespace = "cinema"
    }
  }
}
*/

/*
resource "argocd_application" "locust" {
  depends_on = [argocd_project.cinema]
  metadata {
    name      = "locust"
    namespace = "argocd"
    labels = {
      env = "dev"
    }
  }

  wait = true

  spec {
    project = "loadtesting"
    source {
      helm {
        release_name = "locust"
      }
      repo_url        = "https://github.com/autotune/loadtesting"
      path            = "stable/locust"
      target_revision = "master"
    }
    destination {
      server    = digitalocean_kubernetes_cluster.loadtesting.endpoint
      namespace = "loadtesting"
    }
  }
}
*/
