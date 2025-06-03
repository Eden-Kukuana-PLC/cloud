# Outputs for the network module

output "network_id" {
  description = "ID of the private network"
  value       = hcloud_network.private_network.id
}

output "network_name" {
  description = "Name of the private network"
  value       = hcloud_network.private_network.name
}

output "network_ip_range" {
  description = "IP range of the private network"
  value       = hcloud_network.private_network.ip_range
}

output "subnet_id" {
  description = "ID of the subnet"
  value       = hcloud_network_subnet.private_network_subnet.id
}

output "subnet_ip_range" {
  description = "IP range of the subnet"
  value       = hcloud_network_subnet.private_network_subnet.ip_range
}

output "subnet" {
  description = "The subnet resource"
  value       = hcloud_network_subnet.private_network_subnet
}