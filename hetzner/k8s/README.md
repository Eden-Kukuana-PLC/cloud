# Hetzner Kubernetes Cluster Module

This Terraform module creates a Kubernetes cluster on Hetzner Cloud.

## Usage

```hcl
module "k8s_cluster" {
  source = "path/to/module"

  # Authentication
  hcloud_token = var.hcloud_token

  # Network configuration
  network_name       = "kubernetes-cluster"
  network_ip_range   = "10.0.0.0/16"
  subnet_type        = "cloud"
  subnet_network_zone = "eu-central"
  subnet_ip_range    = "10.0.1.0/24"

  # Primary IP configuration
  primary_ip_name        = "master-ip"
  primary_ip_datacenter  = "fsn1-dc14"
  primary_ip_type        = "ipv4"
  primary_ip_assignee_type = "server"
  primary_ip_auto_delete = true

  # Master node configuration
  master_node_name       = "master-node"
  master_node_image      = "ubuntu-24.04"
  master_node_server_type = "cx22"
  master_node_location   = "fsn1"
  master_node_ipv4_enabled = true
  master_node_ipv6_enabled = true
  master_node_static_ip  = "10.0.1.1"

  # Worker nodes configuration
  worker_nodes_count     = 2
  worker_node_name_prefix = "worker-node"
  worker_node_image      = "ubuntu-24.04"
  worker_node_server_type = "cx22"
  worker_node_location   = "nbg1"
  worker_node_ipv4_enabled = true
  worker_node_ipv6_enabled = true

  # SSH and authentication configuration
  ssh_public_key = var.ssh_public_key
  ssh_private_key = var.ssh_private_key
}
```

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.0 |
| hcloud | 1.51.0 |
| null | 3.2.3 |
| helm | 2.16.1 |
| kubernetes | 2.33.0 |

## Providers

| Name | Version |
|------|---------|
| hcloud | 1.51.0 |
| kubernetes | 2.33.0 |
| helm | 2.16.1 |

## Module Structure

This module is organized into the following components:

1. **Main Module**: Handles the core infrastructure (networks, servers)
2. **hetzner_k8s_interfaces Module**: Manages Kubernetes resources and Helm releases

The separation of Kubernetes resources into a submodule helps avoid issues with kubeconfig availability and ensures proper dependency management.

## Resources

| Name | Type |
|------|------|
| [hcloud_network.private_network](https://registry.terraform.io/providers/hetznercloud/hcloud/latest/docs/resources/network) | resource |
| [hcloud_network_subnet.private_network_subnet](https://registry.terraform.io/providers/hetznercloud/hcloud/latest/docs/resources/network_subnet) | resource |
| [hcloud_primary_ip.primary_ip_1](https://registry.terraform.io/providers/hetznercloud/hcloud/latest/docs/resources/primary_ip) | resource |
| [hcloud_server.master-node](https://registry.terraform.io/providers/hetznercloud/hcloud/latest/docs/resources/server) | resource |
| [hcloud_server.worker-nodes](https://registry.terraform.io/providers/hetznercloud/hcloud/latest/docs/resources/server) | resource |
| [module.hetzner_k8s_interfaces](../hetzner_k8s_interfaces) | module |

### hetzner_k8s_interfaces Module Resources

| Name | Type |
|------|------|
| [kubernetes_secret.hcloud](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret) | resource |
| [helm_release.hccm](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.hcloud_csi](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| hcloud_token | Hetzner Cloud API Token | `string` | n/a | yes |
| network_name | Name of the private network | `string` | `"kubernetes-cluster"` | no |
| network_ip_range | IP range of the private network | `string` | `"10.0.0.0/16"` | no |
| subnet_type | Type of the subnet | `string` | `"cloud"` | no |
| subnet_network_zone | Network zone of the subnet | `string` | `"eu-central"` | no |
| subnet_ip_range | IP range of the subnet | `string` | `"10.0.1.0/24"` | no |
| primary_ip_name | Name of the primary IP for master node | `string` | `"kukuana_ip"` | no |
| primary_ip_datacenter | Datacenter for the primary IP | `string` | `"fsn1-dc14"` | no |
| primary_ip_type | Type of the primary IP | `string` | `"ipv4"` | no |
| primary_ip_assignee_type | Assignee type of the primary IP | `string` | `"server"` | no |
| primary_ip_auto_delete | Whether to auto-delete the primary IP | `bool` | `true` | no |
| master_node_name | Name of the master node | `string` | `"master-node"` | no |
| master_node_image | Image for the master node | `string` | `"ubuntu-24.04"` | no |
| master_node_server_type | Server type for the master node | `string` | `"cx22"` | no |
| master_node_location | Location for the master node | `string` | `"fsn1"` | no |
| master_node_ipv4_enabled | Whether IPv4 is enabled for the master node | `bool` | `true` | no |
| master_node_ipv6_enabled | Whether IPv6 is enabled for the master node | `bool` | `true` | no |
| master_node_static_ip | Static IP for the master node in the private network | `string` | `"10.0.1.1"` | no |
| worker_nodes_count | Number of worker nodes | `number` | `2` | no |
| worker_node_name_prefix | Prefix for worker node names | `string` | `"worker-node"` | no |
| worker_node_image | Image for worker nodes | `string` | `"ubuntu-24.04"` | no |
| worker_node_server_type | Server type for worker nodes | `string` | `"cx22"` | no |
| worker_node_location | Location for worker nodes | `string` | `"nbg1"` | no |
| worker_node_ipv4_enabled | Whether IPv4 is enabled for worker nodes | `bool` | `true` | no |
| worker_node_ipv6_enabled | Whether IPv6 is enabled for worker nodes | `bool` | `true` | no |
| ssh_public_key | SSH public key for machine-to-machine communication | `string` | n/a | yes |
| ssh_private_key | SSH private key for machine-to-machine communication | `string` | n/a | yes |
| root_password | Password for root user access | `string` | n/a | yes |

## Authentication Management with GitHub Actions

This module uses a simplified authentication approach:

1. **SSH Key for Machine-to-Machine Communication**: A single SSH key pair is used for communication between nodes
2. **Password Authentication for Root User**: Password-based authentication is enabled for the root user

When running in a GitHub Actions workflow, you should:

1. **Generate SSH keys**: Generate a new SSH key pair specifically for machine-to-machine communication
2. **Generate a secure password**: Create a strong password for root user access
3. **Store credentials as GitHub Secrets**:
   - Store the public key as `SSH_PUBLIC_KEY`
   - Store the private key as `SSH_PRIVATE_KEY`
   - Store the root password as `ROOT_PASSWORD`
4. **Use secrets in your workflow**:

```yaml
jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3

      - name: Setup Terraform
        uses: hashicorp/setup-terraform@v2

      - name: Terraform Apply
        env:
          TF_VAR_hcloud_token: ${{ secrets.HCLOUD_TOKEN }}
          TF_VAR_ssh_public_key: ${{ secrets.SSH_PUBLIC_KEY }}
          TF_VAR_ssh_private_key: ${{ secrets.SSH_PRIVATE_KEY }}
          TF_VAR_root_password: ${{ secrets.ROOT_PASSWORD }}
        run: |
          terraform init
          terraform apply -auto-approve
```

Alternatively, you can generate credentials dynamically during the workflow:

```yaml
jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3

      - name: Generate credentials
        run: |
          # Generate SSH key
          ssh-keygen -t ed25519 -f ./id_ed25519 -N ""
          echo "TF_VAR_ssh_public_key=$(cat ./id_ed25519.pub)" >> $GITHUB_ENV

          # Use multiline syntax for private key
          echo "TF_VAR_ssh_private_key<<EOF" >> $GITHUB_ENV
          cat ./id_ed25519 >> $GITHUB_ENV
          echo "EOF" >> $GITHUB_ENV

          # Generate random password
          ROOT_PWD=$(openssl rand -base64 12)
          echo "TF_VAR_root_password=$ROOT_PWD" >> $GITHUB_ENV

          # Save password to an artifact for later access
          echo "Root password: $ROOT_PWD" > root_credentials.txt

      - name: Setup Terraform
        uses: hashicorp/setup-terraform@v2

      - name: Terraform Apply
        env:
          TF_VAR_hcloud_token: ${{ secrets.HCLOUD_TOKEN }}
        run: |
          terraform init
          terraform apply -auto-approve

      - name: Save credentials
        uses: actions/upload-artifact@v3
        with:
          name: credentials
          path: |
            ./id_ed25519
            ./id_ed25519.pub
            root_credentials.txt
```

> **Important**: If you generate credentials dynamically, make sure to save them as artifacts or in a secure location for future access to your infrastructure.

## Outputs

### Main Module Outputs

| Name | Description |
|------|-------------|
| network_id | ID of the Hetzner Cloud Network |
| network_name | Name of the Hetzner Cloud Network |
| network_ip_range | IP range of the Hetzner Cloud Network |
| subnet_id | ID of the Hetzner Cloud Network Subnet |
| subnet_ip_range | IP range of the Hetzner Cloud Network Subnet |
| subnet_network_zone | Network zone of the Hetzner Cloud Network Subnet |
| master_node_id | ID of the master node |
| master_node_name | Name of the master node |
| master_node_ipv4_address | Public IPv4 address of the master node |
| master_node_private_ip | Private IP address of the master node |
| worker_nodes_ids | IDs of the worker nodes |
| worker_nodes_names | Names of the worker nodes |
| worker_nodes_ipv4_addresses | Public IPv4 addresses of the worker nodes |
| worker_nodes_private_ips | Private IP addresses of the worker nodes |

### hetzner_k8s_interfaces Module Outputs

| Name | Description |
|------|-------------|
| kubernetes_secret_hcloud_id | ID of the Kubernetes secret for Hetzner Cloud |
| helm_release_hccm_id | ID of the Hetzner Cloud Controller Manager Helm release |
| helm_release_hcloud_csi_id | ID of the Hetzner CSI Helm release |
