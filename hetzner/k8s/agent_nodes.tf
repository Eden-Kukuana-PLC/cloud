# Agent Nodes
# These nodes join the Kubernetes cluster as worker nodes

resource "hcloud_server" "agent-nodes" {
  for_each    = var.agent_nodes
  name        = each.value.name
  image       = each.value.image
  server_type = each.value.server_type
  location    = each.value.location
  public_net {
    ipv4_enabled = each.value.ipv4_enabled
    ipv6_enabled = each.value.ipv6_enabled
  }
  network {
    network_id = hcloud_network.private_network.id
  }
  user_data = templatefile("${path.module}/init/agent_node.yaml.tpl", {
    ssh_public_key  = var.ssh_public_key
    ssh_private_key = var.ssh_private_key
    master_node_ip  = var.master_node_static_ip
  })

  depends_on = [hcloud_network_subnet.private_network_subnet, hcloud_server.master-control-plane]
}
