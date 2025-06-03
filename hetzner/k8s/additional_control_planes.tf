# Additional Control Planes
# These nodes join the main control plane and also run control plane components

resource "hcloud_server" "additional-control-planes" {
  for_each    = var.additional_control_planes
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
  user_data = templatefile("${path.module}/init/additional_control_plane.yaml.tpl", {
    ssh_public_key  = var.ssh_public_key
    ssh_private_key = var.ssh_private_key
    master_node_ip  = var.master_node_static_ip
  })

  depends_on = [hcloud_network_subnet.private_network_subnet, hcloud_server.master-control-plane]
}
