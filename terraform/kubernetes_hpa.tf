# Copyright 2021 Google LLC
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
## modified and converted for use in terraform by Brian Adams


resource "kubernetes_manifest" "istioingress-hpa" {
  provider   = kubernetes.cinema
  depends_on = [module.gke-cinema, kubernetes_namespace.cinema]
  manifest = {
    "apiVersion" = "autoscaling/v2beta1"
    "kind"       = "HorizontalPodAutoscaler"
    "metadata" = {
      "name"      = "istio-ingressgateway"
      "namespace" = "istio-system"
    }
    "spec" = {
      "maxReplicas" = 5
      "metrics" = [
        {
          "resource" = {
            "name"                     = "cpu"
            "targetAverageUtilization" = 80
          }
          "type" = "Resource"
        },
      ]
      "minReplicas" = 2
      "scaleTargetRef" = {
        "apiVersion" = "apps/v1"
        "kind"       = "Deployment"
        "name"       = "istio-ingressgateway"
      }
    }
  }
}


resource "kubernetes_manifest" "istioegress-hpa" {
  provider   = kubernetes.cinema
  depends_on = [module.gke-cinema, kubernetes_namespace.cinema]
  manifest = {
    "apiVersion" = "autoscaling/v2beta1"
    "kind"       = "HorizontalPodAutoscaler"
    "metadata" = {
      "name"      = "istio-egressgateway"
      "namespace" = "istio-system"
    }
    "spec" = {
      "maxReplicas" = 5
      "metrics" = [
        {
          "resource" = {
            "name"                     = "cpu"
            "targetAverageUtilization" = 80
          }
          "type" = "Resource"
        },
      ]
      "minReplicas" = 2
      "scaleTargetRef" = {
        "apiVersion" = "apps/v1"
        "kind"       = "Deployment"
        "name"       = "istio-egressgateway"
      }
    }
  }
}
