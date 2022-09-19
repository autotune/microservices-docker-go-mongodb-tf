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


resource "kubernetes_manifest" "allow-egress-googleapis" {
  provider   = kubernetes.cinema
  depends_on = [module.gke-cinema, kubernetes_namespace.cinema]
  manifest = {
    "apiVersion" = "networking.istio.io/v1alpha3"
    "kind"       = "ServiceEntry"
    "metadata" = {
      "name"       = "allow-egress-googleapis"
      "namespace"  = "cinema"
    }
    "spec" = {
      "hosts" = [
        "accounts.google.com",
        "*.googleapis.com",
      ]
      "ports" = [
        {
          "name"     = "http"
          "number"   = 80
          "protocol" = "HTTP"
        },
        {
          "name"     = "https"
          "number"   = 443
          "protocol" = "HTTPS"
        },
      ]
    }
  }
}
