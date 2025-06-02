#cloud-config
packages:
  - curl
users:
  - name: cluster
    sudo: ALL=(ALL) NOPASSWD:ALL
    shell: /bin/bash


write_files:
  - path: /home/cluster/private_key
    permissions: "0600"
    encoding: b64
    content: |
      ${base64encode(ssh_private_key)}


runcmd:
  - apt-get update -y
  - # wait for the master node to be ready by trying to connect to it
  - until curl -k https://${master_node_ip}:6443; do sleep 5; done
  - # copy the token from the master node
  - REMOTE_TOKEN=$(ssh -o StrictHostKeyChecking=accept-new -i /home/cluster/private_key cluster@${master_node_ip} sudo cat /var/lib/rancher/k3s/server/node-token)
  - # Install k3s worker
  - curl -sfL https://get.k3s.io | K3S_URL=https://${master_node_ip}:6443 K3S_TOKEN=$REMOTE_TOKEN sh -
