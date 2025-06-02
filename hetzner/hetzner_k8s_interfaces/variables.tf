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


variable "module_depends_on" {
  description = "Dependencies for the module"
  type        = any
  default     = []
}