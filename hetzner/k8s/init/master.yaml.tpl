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
  - curl https://get.k3s.io | INSTALL_K3S_EXEC="--disable traefik" sh -s - server --cluster-init
  - chown cluster:cluster /etc/rancher/k3s/k3s.yaml
  - chown cluster:cluster /var/lib/rancher/k3s/server/node-token
