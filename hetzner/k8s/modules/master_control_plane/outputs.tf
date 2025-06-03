# Outputs for the master control plane module

output "id" {
  description = "ID of the master control plane node"
  value       = hcloud_server.master_control_plane.id
}

output "name" {
  description = "Name of the master control plane node"
  value       = hcloud_server.master_control_plane.name
}

output "ipv4_address" {
  description = "Public IPv4 address of the master control plane node"
  value       = hcloud_server.master_control_plane.ipv4_address
}

output "status" {
  description = "Status of the master control plane node"
  value       = hcloud_server.master_control_plane.status
}

output "primary_ip_id" {
  description = "ID of the primary IP"
  value       = hcloud_primary_ip.master_ip.id
}

output "static_ip" {
  description = "Static IP address of the master control plane node in the private network"
  value       = var.static_ip
}

output "kubeconfig_path" {
  description = "Path to the kubeconfig file"
  value       = "${path.module}/.kube/config"
  depends_on  = [null_resource.fetch_kubeconfig]
}