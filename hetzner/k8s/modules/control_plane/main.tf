# Control Plane Node Module
# This module creates a single control plane node
terraform {
  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "1.51.0"
    }
  }
}

resource "hcloud_server" "control_plane" {
  name        = var.name
  image       = var.image
  server_type = var.server_type
  datacenter = var.datacenter
  public_net {
    ipv4_enabled = var.ipv4_enabled
    ipv6_enabled = var.ipv6_enabled
  }
  network {
    network_id = var.network_id
  }
  user_data = templatefile("${path.module}/cloud-init.yaml.tpl", {
    ssh_public_key  = var.ssh_public_key
    ssh_private_key = var.ssh_private_key
    master_node_ip  = var.master_node_ip
  })
}