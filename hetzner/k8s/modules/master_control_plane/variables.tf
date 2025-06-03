# Variables for the master control plane module

variable "name" {
  description = "Name of the master control plane node"
  type        = string
}

variable "image" {
  description = "Image for the master control plane node"
  type        = string
  default     = "ubuntu-24.04"
}

variable "server_type" {
  description = "Server type for the master control plane node"
  type        = string
  default     = "cx22"
}

variable "ipv4_enabled" {
  description = "Whether IPv4 is enabled for the master control plane node"
  type        = bool
  default     = true
}

variable "ipv6_enabled" {
  description = "Whether IPv6 is enabled for the master control plane node"
  type        = bool
  default     = true
}

variable "network_id" {
  description = "ID of the network to attach the master control plane node to"
  type        = string
}

variable "static_ip" {
  description = "Static IP address for the master control plane node in the private network"
  type        = string
}

variable "ssh_public_key" {
  description = "SSH public key for machine-to-machine communication"
  type        = string
  sensitive   = true
}

variable "primary_ip_name" {
  description = "Name of the primary IP"
  type        = string
}

variable "datacenter" {
  description = "Datacenter for the primary IP"
  type        = string
  default     = "nbg1-dc3"
}

variable "primary_ip_type" {
  description = "Type of the primary IP"
  type        = string
  default     = "ipv4"
}

variable "assignee_type" {
  description = "Assignee type of the primary IP"
  type        = string
  default     = "server"
}

variable "auto_delete" {
  description = "Whether to auto-delete the primary IP"
  type        = bool
  default     = false
}

variable "ssh_private_key" {
  description = "SSH private key for machine-to-machine communication"
  type        = string
  sensitive   = true
}