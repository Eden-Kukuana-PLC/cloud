# Variables for the control plane module

variable "name" {
  description = "Name of the control plane node"
  type        = string
}

variable "image" {
  description = "Image for the control plane node"
  type        = string
  default     = "ubuntu-24.04"
}

variable "server_type" {
  description = "Server type for the control plane node"
  type        = string
  default     = "cx22"
}

variable "datacenter" {
  description = "Datacenter for the primary IP"
  type        = string
  default     = "nbg1-dc3"
}
variable "ipv4_enabled" {
  description = "Whether IPv4 is enabled for the control plane node"
  type        = bool
  default     = true
}

variable "ipv6_enabled" {
  description = "Whether IPv6 is enabled for the control plane node"
  type        = bool
  default     = true
}

variable "network_id" {
  description = "ID of the network to attach the control plane node to"
  type        = string
}

variable "ssh_public_key" {
  description = "SSH public key for machine-to-machine communication"
  type        = string
  sensitive   = true
}

variable "ssh_private_key" {
  description = "SSH private key for machine-to-machine communication"
  type        = string
  sensitive   = true
}

variable "master_node_ip" {
  description = "IP address of the master node"
  type        = string
}

variable "private_network_ip" {
  description = "The private IP of the of the agent, should be in the subnet ip range"
  type        = string
}

variable "private_ip_aliases" {
  type        = list(string)
  default     = []
  description = "An optional list with a default empty value"
}