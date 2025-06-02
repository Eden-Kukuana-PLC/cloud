resource "hcloud_server" "worker-nodes" {
  count = var.worker_nodes_count

  # The name will be worker-node-0, worker-node-1, worker-node-2...
  name        = "${var.worker_node_name_prefix}-${count.index}"
  image       = var.worker_node_image
  server_type = var.worker_node_server_type
  location    = var.worker_node_location
  public_net {
    ipv4_enabled = var.worker_node_ipv4_enabled
    ipv6_enabled = var.worker_node_ipv6_enabled
  }
  network {
    network_id = hcloud_network.private_network.id
  }
  user_data = templatefile("${path.module}/init/agent.yaml.tpl", {
    ssh_public_key = var.ssh_public_key
    ssh_private_key = var.ssh_private_key
    master_node_ip = var.master_node_static_ip
  })

  depends_on = [hcloud_network_subnet.private_network_subnet, hcloud_server.master-node]
}

# Worker nodes outputs
output "worker_nodes_ids" {
  description = "IDs of the worker nodes"
  value       = hcloud_server.worker-nodes[*].id
}

output "worker_nodes_names" {
  description = "Names of the worker nodes"
  value       = hcloud_server.worker-nodes[*].name
}


