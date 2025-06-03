# Master Control Plane Module

## Overview
The Master Control Plane Module creates the primary Kubernetes control plane node in Hetzner Cloud. This node initializes the Kubernetes cluster and serves as the main control plane for the cluster.

## Features
- Creates a Hetzner Cloud server configured as the master Kubernetes control plane node
- Initializes a new Kubernetes cluster using k3s
- Configures firewall rules for Kubernetes communication
- Creates and assigns a primary IP address
- Automatically fetches the kubeconfig file to the local machine
- Provides outputs for connecting additional nodes to the cluster

## Usage

```hcl
module "master_control_plane" {
  source = "path/to/modules/master_control_plane"

  name            = "k8s-master"
  network_id      = module.network.network_id
  static_ip       = "10.0.1.2"
  primary_ip_name = "k8s-master-ip"
  ssh_public_key  = var.ssh_public_key
  ssh_private_key = var.ssh_private_key
  
  # Optional parameters
  # server_type    = "cx31"
  # image          = "ubuntu-24.04"
  # datacenter     = "nbg1-dc3"
  # ipv4_enabled   = true
  # ipv6_enabled   = true
  # primary_ip_type = "ipv4"
  # auto_delete     = false
}
```

## Requirements
- Hetzner Cloud API token with read/write permissions
- Existing network for the Kubernetes cluster
- SSH key pair for machine-to-machine communication

## Input Variables

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| name | Name of the master control plane node | string | n/a | yes |
| image | Image for the master control plane node | string | "ubuntu-24.04" | no |
| server_type | Server type for the master control plane node | string | "cx22" | no |
| datacenter | Datacenter for the primary IP | string | "nbg1-dc3" | no |
| ipv4_enabled | Whether IPv4 is enabled for the master control plane node | bool | true | no |
| ipv6_enabled | Whether IPv6 is enabled for the master control plane node | bool | true | no |
| network_id | ID of the network to attach the master control plane node to | string | n/a | yes |
| static_ip | Static IP address for the master control plane node in the private network | string | n/a | yes |
| ssh_public_key | SSH public key for machine-to-machine communication | string | n/a | yes |
| ssh_private_key | SSH private key for machine-to-machine communication | string | n/a | yes |
| primary_ip_name | Name of the primary IP | string | n/a | yes |
| primary_ip_type | Type of the primary IP | string | "ipv4" | no |
| assignee_type | Assignee type of the primary IP | string | "server" | no |
| auto_delete | Whether to auto-delete the primary IP | bool | false | no |

## Outputs

| Name | Description |
|------|-------------|
| id | ID of the master control plane node |
| name | Name of the master control plane node |
| ipv4_address | Public IPv4 address of the master control plane node |
| status | Status of the master control plane node |
| primary_ip_id | ID of the primary IP |
| static_ip | Static IP address of the master control plane node in the private network |
| kubeconfig_path | Path to the kubeconfig file |

## Notes
- The kubeconfig file is automatically fetched from the master node and saved to `.kube/config` in the module directory
- The kubeconfig is configured to use the public IP address of the master node
- The module waits for k3s to be fully initialized before fetching the kubeconfig