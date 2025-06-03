resource "hcloud_network" "private_network" {
  name     = var.network_name
  ip_range = var.network_ip_range
}

resource "hcloud_network_subnet" "private_network_subnet" {
  type         = var.subnet_type
  network_id   = hcloud_network.private_network.id
  network_zone = var.subnet_network_zone
  ip_range     = var.subnet_ip_range
}
