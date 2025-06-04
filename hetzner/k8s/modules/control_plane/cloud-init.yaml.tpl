#cloud-config
packages:
  - curl

package_update: true

users:
  - name: cluster
    sudo: ALL=(ALL) NOPASSWD:ALL
    shell: /bin/bash
    ssh-authorized-keys:
      - ${ssh_public_key}

write_files:
  - path: /home/cluster/private_key
    permissions: "0600"
    encoding: b64
    content: |
      ${base64encode(ssh_private_key)}

runcmd:
  - # wait for the master node to be ready by trying to connect to it
  - until curl -k https://${master_node_ip}:6443; do sleep 5; done
  - # copy the token from the master node
  - REMOTE_TOKEN=$(ssh -o StrictHostKeyChecking=accept-new -i /home/cluster/private_key cluster@${master_node_ip} sudo cat /var/lib/rancher/k3s/server/node-token)
  - # Install k3s as an additional control plane node
  - curl -sfL https://get.k3s.io | sh -s - server --disable="traefik" --token $REMOTE_TOKEN --server https://${master_node_ip}:6443 --tls-san=${master_node_ip}