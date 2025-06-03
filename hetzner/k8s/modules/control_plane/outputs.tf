# Outputs for the control plane module

output "id" {
  description = "ID of the control plane node"
  value       = hcloud_server.control_plane.id
}

output "name" {
  description = "Name of the control plane node"
  value       = hcloud_server.control_plane.name
}

output "ipv4_address" {
  description = "Public IPv4 address of the control plane node"
  value       = hcloud_server.control_plane.ipv4_address
}

output "status" {
  description = "Status of the control plane node"
  value       = hcloud_server.control_plane.status
}