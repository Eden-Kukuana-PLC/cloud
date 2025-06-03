# Master Control Plane Module
# This module creates a single master control plane node
terraform {
  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "1.51.0"
    }
  }
}

resource "hcloud_primary_ip" "master_ip" {
  name          = var.primary_ip_name
  datacenter    = var.datacenter
  type          = var.primary_ip_type
  assignee_type = "server"
  auto_delete   = var.auto_delete
  labels = {
    "node" : "master"
  }
}

resource "hcloud_server" "master_control_plane" {
  name        = var.name
  image       = var.image
  server_type = var.server_type
  datacenter = var.datacenter
  public_net {
    ipv4_enabled = var.ipv4_enabled
    ipv4         = hcloud_primary_ip.master_ip.id
    ipv6_enabled = var.ipv6_enabled
  }
  network {
    network_id = var.network_id
    ip         = var.static_ip
  }
  user_data = templatefile("${path.module}/cloud-init.yaml.tpl", {
    ssh_public_key = var.ssh_public_key
    master_node_ip = var.static_ip
  })

}

# Fetch kubeconfig from master node
resource "null_resource" "fetch_kubeconfig" {
  depends_on = [hcloud_server.master_control_plane]

  # Create .kube directory if it doesn't exist
  provisioner "local-exec" {
    command = "mkdir -p ${path.module}/.kube"
  }

  # Wait for k3s to be fully initialized and fetch kubeconfig
  provisioner "local-exec" {
    command = <<-EOT
      # Create a temporary file for the SSH private key
      mkdir -p ${path.module}/.ssh
      cat > ${path.module}/.ssh/id_temp << 'EOK'
${var.ssh_private_key}
EOK
      chmod 600 ${path.module}/.ssh/id_temp

      # Wait for k3s to be fully initialized (up to 2 minutes)
      echo "Waiting for k3s to be fully initialized..."
      for i in {1..12}; do
        if ssh -o StrictHostKeyChecking=no -i ${path.module}/.ssh/id_temp cluster@${hcloud_server.master_control_plane.ipv4_address} 'test -f /etc/rancher/k3s/k3s.yaml && sudo k3s kubectl get nodes'; then
          echo "k3s is initialized and ready"
          break
        fi
        echo "Waiting for k3s to be ready... ($i/12)"
        sleep 10
      done

      # Fetch kubeconfig from master node
      echo "Fetching kubeconfig from master node..."
      ssh -o StrictHostKeyChecking=no -i ${path.module}/.ssh/id_temp cluster@${hcloud_server.master_control_plane.ipv4_address} 'sudo cat /etc/rancher/k3s/k3s.yaml' | sed 's/127.0.0.1/${hcloud_server.master_control_plane.ipv4_address}/g' > ${path.module}/.kube/config
      chmod 600 ${path.module}/.kube/config

      # Clean up the temporary key file
      rm -f ${path.module}/.ssh/id_temp
      echo "Kubeconfig successfully fetched and configured"
    EOT
  }

  # This ensures the resource is recreated when the master node changes
  triggers = {
    always_run = timestamp()
  }
}

# Output the path to the kubeconfig file

