# Variables for the hetzner_k8s_interfaces module

variable "hcloud_token" {
  description = "Hetzner Cloud API token"
  type        = string
  sensitive   = true
}

variable "kubeconfig_path" {
  description = "Path to the kubeconfig file"
  type        = string
}

variable "network_id" {
  description = "The id of the private network"
  type = string
}

variable "clusterCIDR" {
  description = "cluster clusterCIDR"
  type = string
}
