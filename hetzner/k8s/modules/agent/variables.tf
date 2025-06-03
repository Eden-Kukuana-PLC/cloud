# Variables for the agent module

variable "name" {
  description = "Name of the agent node"
  type        = string
}

variable "image" {
  description = "Image for the agent node"
  type        = string
  default     = "ubuntu-24.04"
}

variable "server_type" {
  description = "Server type for the agent node"
  type        = string
  default     = "cx22"
}

variable "datacenter" {
  description = "Location for the agent node"
  type        = string
  default     = "nbg1"
}

variable "ipv4_enabled" {
  description = "Whether IPv4 is enabled for the agent node"
  type        = bool
  default     = true
}

variable "ipv6_enabled" {
  description = "Whether IPv6 is enabled for the agent node"
  type        = bool
  default     = true
}

variable "network_id" {
  description = "ID of the network to attach the agent node to"
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
