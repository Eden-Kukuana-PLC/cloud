# Agent Module
# This module creates a single agent node
terraform {
  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "1.51.0"
    }
  }
}

resource "hcloud_server" "agent" {
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
    ip         = var.private_network_ip
    alias_ips  = var.private_ip_aliases
  }
  user_data = templatefile("${path.module}/cloud-init.yaml.tpl", {
    ssh_public_key  = var.ssh_public_key
    ssh_private_key = var.ssh_private_key
    master_node_ip  = var.master_node_ip
  })
}