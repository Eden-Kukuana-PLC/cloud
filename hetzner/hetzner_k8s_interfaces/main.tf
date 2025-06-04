# Main configuration for the hetzner_k8s_interfaces module

terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.33.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.16.1"
    }
  }
}

# Configure the Kubernetes provider
provider "kubernetes" {
  config_path    = var.kubeconfig_path
  config_context = "default"

  # Wait for the kubeconfig to be available
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "cat"
    args        = [var.kubeconfig_path]
  }
}

# Configure the Helm provider
provider "helm" {
  kubernetes {
    config_path    = var.kubeconfig_path
    config_context = "default"

    # Wait for the kubeconfig to be available
    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      command     = "cat"
      args        = [var.kubeconfig_path]
    }
  }
}