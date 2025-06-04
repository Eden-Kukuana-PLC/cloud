#cloud-config
packages:
  - curl

package_update: true

users:
  - name: cluster
    ssh-authorized-keys:
      - ${ssh_public_key}
    sudo: ALL=(ALL) NOPASSWD:ALL
    shell: /bin/bash

runcmd:
  - curl https://get.k3s.io | sh -s - server --cluster-init --disable="traefik" --tls-san=${master_node_ip}
  - chown cluster:cluster /etc/rancher/k3s/k3s.yaml
  - chown cluster:cluster /var/lib/rancher/k3s/server/node-token
