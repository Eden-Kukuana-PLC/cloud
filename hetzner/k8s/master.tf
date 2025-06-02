resource "hcloud_primary_ip" "master_ip" {
  name          = var.master_ip_name
  datacenter    = var.master_ip_datacenter
  type          = var.master_ip_type
  assignee_type = var.master_ip_assignee_type
  auto_delete   = var.master_ip_auto_delete
  labels = {
    "node" : "master"
  }
}

resource "hcloud_server" "master-node" {
  name        = var.master_node_name
  image       = var.master_node_image
  server_type = var.master_node_server_type
  location    = var.master_node_location
  public_net {
    ipv4_enabled = var.master_node_ipv4_enabled
    ipv4         = hcloud_primary_ip.master_ip.id
    ipv6_enabled = var.master_node_ipv6_enabled
  }
  network {
    network_id = hcloud_network.private_network.id
    # IP Used by the master node, needs to be static
    # Here the worker nodes will use 10.0.1.1 to communicate with the master node
    ip         = var.master_node_static_ip
  }
  user_data = templatefile("${path.module}/init/master.yaml.tpl", {
    ssh_public_key = var.ssh_public_key
  })

  # If we don't specify this, Terraform will create the resources in parallel
  # We want this node to be created after the private network is created
  depends_on = [hcloud_network_subnet.private_network_subnet]
}

# Master node outputs
output "master_node_id" {
  description = "ID of the master node"
  value       = hcloud_server.master-node.id
}

output "master_node_name" {
  description = "Name of the master node"
  value       = hcloud_server.master-node.name
}

output "master_node_ipv4_address" {
  description = "Public IPv4 address of the master node"
  value       = hcloud_server.master-node.ipv4_address
}

output "master_node_private_ip" {
  description = "Private IP address of the master node"
  value       = var.master_node_static_ip
}
