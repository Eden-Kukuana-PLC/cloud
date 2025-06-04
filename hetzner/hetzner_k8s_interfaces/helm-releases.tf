# Helm releases for the hetzner_k8s_interfaces module

resource "helm_release" "hccm" {
  name             = "hccm"
  repository       = "https://charts.hetzner.cloud"
  chart            = "hcloud-cloud-controller-manager"
  namespace        = "kube-system"
  create_namespace = true
  timeout          = 300

  set {
    name  = "networking.enabled"
    value = true
  }

  set {
    name = "networking.clusterCIDR"
    value = var.clusterCIDR
  }

  depends_on = [
  kubernetes_secret.hcloud
  ]
}

resource "helm_release" "hcloud_csi" {
  name             = "hcloud-csi"
  repository       = "https://charts.hetzner.cloud"
  chart            = "hcloud-csi"
  namespace        = "kube-system"
  create_namespace = true

  depends_on = [
    kubernetes_secret.hcloud,
  ]
}

resource "helm_release" "traefik" {
  name             = "traefik"
  repository       = "https://traefik.github.io/charts"
  chart            = "traefik"
  namespace        = "traefik"
  create_namespace = true
  version          = "33.0.0"

  depends_on = [helm_release.hcloud_csi]

  values = [
    yamlencode({
      ports = {
        web = {
          redirectTo = {
            port = "websecure"
          }
        }
        websecure = {
          tls = {
            enabled      = true
            certResolver = "letsEncrypt"
          }
        }
      }

      additionalArguments = [
        "--api.insecure=true",
        "--serversTransport.insecureSkipVerify=true",
        "--tcpServersTransport.tls.insecureSkipVerify=true"
      ]

      autoscaling = {
        enabled     = true
        maxReplicas = 6
      }

      # This is disabled by autoscaling
      # comment autoscaling out to use this block
      # deployment = {
      #   replicas = 3
      # }

      logs = {
        access = {
          enabled = true
        }
      }

      metrics = {
        addInternals = true
        otlp = {
          enabled = true
          http = {
            enabled = true
            endpoint = "http://grafana-k8s-monitoring-alloy-receiver.monitoring.svc.cluster.local:4318/v1/metrics"
            insecureSkipVerify = true
          }
        }
      }

      tracing = {
        addInternals = true
        otlp = {
          enabled = true
          http = {
            enabled = true
            endpoint = "http://grafana-k8s-monitoring-alloy-receiver.monitoring.svc.cluster.local:4318/v1/traces"
            insecureSkipVerify = true
          }
        }
      }


      providers = {
        kubernetesCRD = {
          enabled = true
        }
      }

      persistence = {
        enabled      = true
        size         = "128Mi"
        name         = "success-factors"
        path         = "/traefik/tls"
      }

      securityContext = {
        runAsNonRoot = false
        runAsGroup   = 0
        runAsUser    = 0
      }

      certificatesResolvers = {
        letsEncrypt = {
          acme = {
            tlschallenge = {}
            caServer     = "https://acme-v02.api.letsencrypt.org/directory"
            email        = "emmanuel@uplanit.co.uk"
            storage      = "/traefik/tls/acme.json"
            httpChallenge = {
              entryPoint = "web"
            }
          }
        }
      }
    })
  ]
}


resource "helm_release" "kubevela" {
  name             = "vela-core"
  repository       = "https://kubevela.github.io/charts"
  chart            = "vela-core"
  namespace        = "vela-system"
  create_namespace = true
  version          = "1.10.3"
}

resource "helm_release" "postgres-operator" {
  name             = "postgres-operator"
  chart            = "${path.module}/crunchy-data-postgres-operator"
  namespace        = "postgres-operator"
  create_namespace = true

  values = [yamlencode({
    replicas = 1
  })]
}
