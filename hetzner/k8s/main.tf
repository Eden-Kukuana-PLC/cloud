terraform {
  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "1.51.0"
    }

    null = {
      source  = "hashicorp/null"
      version = "3.2.3"
    }

    # Helm provider is now configured in the hetzner_k8s_interfaces module
    helm = {
      source  = "hashicorp/helm"
      version = "2.16.1"
    }

    # Kubernetes provider is now configured in the hetzner_k8s_interfaces module
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.33.0" # check the latest version for compatibility
    }
  }
}

provider "hcloud" {
  token = var.hcloud_token
}
