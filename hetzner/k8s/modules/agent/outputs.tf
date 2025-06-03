# Outputs for the agent module

output "id" {
  description = "ID of the agent node"
  value       = hcloud_server.agent.id
}

output "name" {
  description = "Name of the agent node"
  value       = hcloud_server.agent.name
}

output "ipv4_address" {
  description = "Public IPv4 address of the agent node"
  value       = hcloud_server.agent.ipv4_address
}

output "status" {
  description = "Status of the agent node"
  value       = hcloud_server.agent.status
}