# Kubernetes resources for the hetzner_k8s_interfaces module

# Create the Kubernetes Secret for Hetzner Cloud Controller Manager
resource "kubernetes_secret" "hcloud" {
  metadata {
    name      = "hcloud"
    namespace = "kube-system"
  }

  type = "Opaque"

  # In Kubernetes YAML, this would be stringData
  data = {
    token = var.hcloud_token
    network = var.network_id
  }

}