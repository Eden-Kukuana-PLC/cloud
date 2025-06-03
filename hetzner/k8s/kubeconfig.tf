# Fetch kubeconfig from master node
resource "null_resource" "fetch_kubeconfig" {
  depends_on = [hcloud_server.master-control-plane]

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
        if ssh -o StrictHostKeyChecking=no -i ${path.module}/.ssh/id_temp cluster@${hcloud_server.master-control-plane.ipv4_address} 'test -f /etc/rancher/k3s/k3s.yaml && sudo k3s kubectl get nodes'; then
          echo "k3s is initialized and ready"
          break
        fi
        echo "Waiting for k3s to be ready... ($i/12)"
        sleep 10
      done

      # Fetch kubeconfig from master node
      echo "Fetching kubeconfig from master node..."
      ssh -o StrictHostKeyChecking=no -i ${path.module}/.ssh/id_temp cluster@${hcloud_server.master-control-plane.ipv4_address} 'sudo cat /etc/rancher/k3s/k3s.yaml' | sed 's/127.0.0.1/${hcloud_server.master-control-plane.ipv4_address}/g' > ${path.module}/.kube/config
      chmod 600 ${path.module}/.kube/config

      # Clean up the temporary key file
      rm -f ${path.module}/.ssh/id_temp
      echo "Kubeconfig successfully fetched and configured"
    EOT
  }

  # This ensures the resource is recreated when the master node changes
  triggers = {
    master_node_id = hcloud_server.master-control-plane.id
  }
}

# Output the path to the kubeconfig file
output "kubeconfig_path" {
  description = "Path to the kubeconfig file"
  value       = "${path.module}/.kube/config"
  depends_on  = [null_resource.fetch_kubeconfig]
}
