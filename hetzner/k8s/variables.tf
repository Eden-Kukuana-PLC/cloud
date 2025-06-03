# Declare the hcloud_token variable from .tfvars
variable "hcloud_token" {
    sensitive = true # Requires terraform >= 0.14
}

# Network configuration
variable "network_name" {
    description = "Name of the private network"
    type        = string
    default     = "kubernetes-cluster"
}

variable "network_ip_range" {
    description = "IP range of the private network"
    type        = string
    default     = "10.0.0.0/16"
}

# Subnet configuration
variable "subnet_type" {
    description = "Type of the subnet"
    type        = string
    default     = "cloud"
}

variable "subnet_network_zone" {
    description = "Network zone of the subnet"
    type        = string
    default     = "eu-central"
}

variable "subnet_ip_range" {
    description = "IP range of the subnet"
    type        = string
    default     = "10.0.1.0/24"
}

# Primary IP configuration
variable "master_ip_name" {
    description = "Name of the primary IP for master node"
    type        = string
    default     = "master_ip"
}

variable "master_ip_datacenter" {
    description = "Datacenter for the primary IP"
    type        = string
    default     = "fsn1-dc14"
}

variable "master_ip_type" {
    description = "Type of the primary IP"
    type        = string
    default     = "ipv4"
}

variable "master_ip_assignee_type" {
    description = "Assignee type of the primary IP"
    type        = string
    default     = "server"
}

variable "master_ip_auto_delete" {
    description = "Whether to auto-delete the primary IP"
    type        = bool
    default     = true
}

# Master node configuration
variable "master_node_name" {
    description = "Name of the master node"
    type        = string
    default     = "master-node"
}

variable "master_node_image" {
    description = "Image for the master node"
    type        = string
    default     = "ubuntu-24.04"
}

variable "master_node_server_type" {
    description = "Server type for the master node"
    type        = string
    default     = "cx22"
}

variable "master_node_location" {
    description = "Location for the master node"
    type        = string
    default     = "fsn1"
}

variable "master_node_ipv4_enabled" {
    description = "Whether IPv4 is enabled for the master node"
    type        = bool
    default     = true
}

variable "master_node_ipv6_enabled" {
    description = "Whether IPv6 is enabled for the master node"
    type        = bool
    default     = true
}

variable "master_node_static_ip" {
    description = "Static IP for the master node in the private network"
    type        = string
    default     = "10.0.1.1"
}

# Worker nodes configuration
variable "worker_nodes_count" {
    description = "Number of worker nodes"
    type        = number
    default     = 2
}

variable "worker_node_name_prefix" {
    description = "Prefix for worker node names"
    type        = string
    default     = "worker-node"
}

variable "worker_node_image" {
    description = "Image for worker nodes"
    type        = string
    default     = "ubuntu-24.04"
}

variable "worker_node_server_type" {
    description = "Server type for worker nodes"
    type        = string
    default     = "cx22"
}

variable "worker_node_location" {
    description = "Location for worker nodes"
    type        = string
    default     = "nbg1"
}

variable "worker_node_ipv4_enabled" {
    description = "Whether IPv4 is enabled for worker nodes"
    type        = bool
    default     = true
}

variable "worker_node_ipv6_enabled" {
    description = "Whether IPv6 is enabled for worker nodes"
    type        = bool
    default     = true
}

# Agent nodes configuration
variable "agent_nodes" {
    description = "Map of agent nodes to create"
    type = map(object({
        name        = string
        image       = optional(string, "ubuntu-24.04")
        server_type = optional(string, "cx22")
        location    = optional(string, "nbg1")
        ipv4_enabled = optional(bool, true)
        ipv6_enabled = optional(bool, true)
    }))
    default = {}
}

# Additional control planes configuration
variable "additional_control_planes" {
    description = "Map of additional control plane nodes to create"
    type = map(object({
        name        = string
        image       = optional(string, "ubuntu-24.04")
        server_type = optional(string, "cx22")
        location    = optional(string, "nbg1")
        ipv4_enabled = optional(bool, true)
        ipv6_enabled = optional(bool, true)
    }))
    default = {}
}

# SSH key configuration
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
