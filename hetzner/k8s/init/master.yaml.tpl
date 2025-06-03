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
  - ufw allow 6443/tcp #apiserver
  - ufw allow from 10.42.0.0/16 to any #pods
  - ufw allow from 10.43.0.0/16 to any #services
  - curl https://get.k3s.io | sh -s - server --cluster-init --disable="traefik" --tls-san=${master_node_ip}
  - chown cluster:cluster /etc/rancher/k3s/k3s.yaml
  - chown cluster:cluster /var/lib/rancher/k3s/server/node-token
