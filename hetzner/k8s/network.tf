resource "hcloud_network" "private_network" {
  name     = var.network_name
  ip_range = var.network_ip_range
}

resource "hcloud_network_subnet" "private_network_subnet" {
  type         = var.subnet_type
  network_id   = hcloud_network.private_network.id
  network_zone = var.subnet_network_zone
  ip_range     = var.subnet_ip_range
}

# Network outputs
output "network_id" {
  description = "ID of the Hetzner Cloud Network"
  value       = hcloud_network.private_network.id
}

output "network_name" {
  description = "Name of the Hetzner Cloud Network"
  value       = hcloud_network.private_network.name
}

output "network_ip_range" {
  description = "IP range of the Hetzner Cloud Network"
  value       = hcloud_network.private_network.ip_range
}

# Subnet outputs
output "subnet_id" {
  description = "ID of the Hetzner Cloud Network Subnet"
  value       = hcloud_network_subnet.private_network_subnet.id
}

output "subnet_ip_range" {
  description = "IP range of the Hetzner Cloud Network Subnet"
  value       = hcloud_network_subnet.private_network_subnet.ip_range
}

output "subnet_network_zone" {
  description = "Network zone of the Hetzner Cloud Network Subnet"
  value       = hcloud_network_subnet.private_network_subnet.network_zone
}
