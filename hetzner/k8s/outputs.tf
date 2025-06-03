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

# Master control plane outputs
output "master_control_plane_id" {
  description = "ID of the master control plane node"
  value       = hcloud_server.master-control-plane.id
}

output "master_control_plane_name" {
  description = "Name of the master control plane node"
  value       = hcloud_server.master-control-plane.name
}

output "master_control_plane_ipv4_address" {
  description = "Public IPv4 address of the master control plane node"
  value       = hcloud_server.master-control-plane.ipv4_address
}

output "master_control_plane_private_ip" {
  description = "Private IP address of the master control plane node"
  value       = var.master_node_static_ip
}

# Additional control planes outputs
output "additional_control_planes_ids" {
  description = "IDs of the additional control plane nodes"
  value       = { for k, v in hcloud_server.additional-control-planes : k => v.id }
}

output "additional_control_planes_names" {
  description = "Names of the additional control plane nodes"
  value       = { for k, v in hcloud_server.additional-control-planes : k => v.name }
}

output "additional_control_planes_ipv4_addresses" {
  description = "Public IPv4 addresses of the additional control plane nodes"
  value       = { for k, v in hcloud_server.additional-control-planes : k => v.ipv4_address }
}

# Agent nodes outputs
output "agent_nodes_ids" {
  description = "IDs of the agent nodes"
  value       = { for k, v in hcloud_server.agent-nodes : k => v.id }
}

output "agent_nodes_names" {
  description = "Names of the agent nodes"
  value       = { for k, v in hcloud_server.agent-nodes : k => v.name }
}

output "agent_nodes_ipv4_addresses" {
  description = "Public IPv4 addresses of the agent nodes"
  value       = { for k, v in hcloud_server.agent-nodes : k => v.ipv4_address }
}
