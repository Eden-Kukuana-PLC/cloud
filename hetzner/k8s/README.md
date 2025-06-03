# Hetzner Kubernetes Cluster Module

This Terraform module creates a Kubernetes cluster on Hetzner Cloud with a flexible architecture.

## Architecture

The module creates three types of resources:

1. **Master Control Plane**: The central node for the Kubernetes control plane
2. **Additional Control Planes**: Additional control plane nodes that reference the main master
3. **Agent Nodes**: Worker nodes that join the cluster but don't run control plane components

This architecture allows you to declaratively create and name multiple control planes and agent nodes.

### Modular Resource Approach

The module now uses a modular approach for additional control planes and agent nodes:

- Each control plane and agent node is created as a separate resource
- This prevents recreation of all nodes when adding or removing individual nodes
- You can add new nodes by simply declaring new resources in your configuration
- Each node must specify its own SSH details and server configuration

This approach ensures that when you need to add or remove nodes, only the affected nodes are created or destroyed, without impacting existing infrastructure.

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
  master_ip_name        = "master-ip"
  master_ip_datacenter  = "fsn1-dc14"
  master_ip_type        = "ipv4"
  master_ip_assignee_type = "server"
  master_ip_auto_delete = true

  # Master control plane configuration
  master_node_name       = "master-control-plane"
  master_node_image      = "ubuntu-24.04"
  master_node_server_type = "cx22"
  master_node_location   = "fsn1"
  master_node_ipv4_enabled = true
  master_node_ipv6_enabled = true
  master_node_static_ip  = "10.0.1.1"

  # Additional control planes configuration
  # Each control plane is defined as a separate resource
  additional_control_planes = {
    "control-plane-1" = {
      name        = "control-plane-1"
      image       = "ubuntu-24.04"
      server_type = "cx22"
      location    = "nbg1"
      ipv4_enabled = true
      ipv6_enabled = true
    }
  }

  # To add another control plane, simply add a new entry
  # This won't affect existing control planes
  # additional_control_planes = {
  #   "control-plane-1" = { ... },
  #   "control-plane-2" = {
  #     name        = "control-plane-2"
  #     server_type = "cx22"
  #     location    = "fsn1"
  #   }
  # }

  # Agent nodes configuration
  # Each agent node is defined as a separate resource
  agent_nodes = {
    "agent-1" = {
      name        = "agent-1"
      image       = "ubuntu-24.04"
      server_type = "cx22"
      location    = "nbg1"
      ipv4_enabled = true
      ipv6_enabled = true
    }
  }

  # To add another agent node, simply add a new entry
  # This won't affect existing agent nodes
  # agent_nodes = {
  #   "agent-1" = { ... },
  #   "agent-2" = {
  #     name        = "agent-2"
  #     server_type = "cx22"
  #     location    = "fsn1"
  #   }
  # }

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
| [module.master_control_plane](./modules/master_control_plane) | module |
| [module.additional_control_plane](./modules/additional_control_plane) | module |
| [module.agent](./modules/agent) | module |
| [module.hetzner_k8s_interfaces](../hetzner_k8s_interfaces) | module |

### Master Control Plane Module Resources

| Name | Type |
|------|------|
| [hcloud_primary_ip.master_ip](https://registry.terraform.io/providers/hetznercloud/hcloud/latest/docs/resources/primary_ip) | resource |
| [hcloud_server.master_control_plane](https://registry.terraform.io/providers/hetznercloud/hcloud/latest/docs/resources/server) | resource |

### Additional Control Plane Module Resources

| Name | Type |
|------|------|
| [hcloud_server.additional_control_plane](https://registry.terraform.io/providers/hetznercloud/hcloud/latest/docs/resources/server) | resource |

### Agent Module Resources

| Name | Type |
|------|------|
| [hcloud_server.agent](https://registry.terraform.io/providers/hetznercloud/hcloud/latest/docs/resources/server) | resource |

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
| additional_control_plane_name | Name of the additional control plane node | `string` | `"additional-control-plane"` | no |
| additional_control_plane_image | Image for the additional control plane node | `string` | `"ubuntu-24.04"` | no |
| additional_control_plane_server_type | Server type for the additional control plane node | `string` | `"cx22"` | no |
| additional_control_plane_location | Location for the additional control plane node | `string` | `"nbg1"` | no |
| additional_control_plane_ipv4_enabled | Whether IPv4 is enabled for the additional control plane node | `bool` | `true` | no |
| additional_control_plane_ipv6_enabled | Whether IPv6 is enabled for the additional control plane node | `bool` | `true` | no |
| agent_name | Name of the agent node | `string` | `"agent-node"` | no |
| agent_image | Image for the agent node | `string` | `"ubuntu-24.04"` | no |
| agent_server_type | Server type for the agent node | `string` | `"cx22"` | no |
| agent_location | Location for the agent node | `string` | `"nbg1"` | no |
| agent_ipv4_enabled | Whether IPv4 is enabled for the agent node | `bool` | `true` | no |
| agent_ipv6_enabled | Whether IPv6 is enabled for the agent node | `bool` | `true` | no |
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
| master_control_plane_id | ID of the master control plane node |
| master_control_plane_name | Name of the master control plane node |
| master_control_plane_ipv4_address | Public IPv4 address of the master control plane node |
| master_control_plane_private_ip | Private IP address of the master control plane node |
| additional_control_planes_ids | Map of IDs of the additional control plane nodes |
| additional_control_planes_names | Map of names of the additional control plane nodes |
| additional_control_planes_ipv4_addresses | Map of public IPv4 addresses of the additional control plane nodes |
| agent_nodes_ids | Map of IDs of the agent nodes |
| agent_nodes_names | Map of names of the agent nodes |
| agent_nodes_ipv4_addresses | Map of public IPv4 addresses of the agent nodes |

### hetzner_k8s_interfaces Module Outputs

| Name | Description |
|------|-------------|
| kubernetes_secret_hcloud_id | ID of the Kubernetes secret for Hetzner Cloud |
| helm_release_hccm_id | ID of the Hetzner Cloud Controller Manager Helm release |
| helm_release_hcloud_csi_id | ID of the Hetzner CSI Helm release |
