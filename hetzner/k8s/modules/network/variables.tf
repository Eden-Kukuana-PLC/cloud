# Variables for the network module

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