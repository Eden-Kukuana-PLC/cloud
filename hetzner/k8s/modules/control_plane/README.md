# Control Plane Module

## Overview
The Control Plane Module creates a single Kubernetes control plane node in Hetzner Cloud. This node joins an existing Kubernetes cluster as an additional control plane node, connecting to the master control plane node.

## Features
- Creates a Hetzner Cloud server configured as a Kubernetes control plane node
- Automatically joins the existing Kubernetes cluster
- Configures firewall rules for Kubernetes communication
- Sets up machine-to-machine communication with SSH keys

## Usage

```hcl
module "control_plane" {
  source = "path/to/modules/control_plane"

  name           = "k8s-control-plane-1"
  network_id     = module.network.network_id
  master_node_ip = module.master_control_plane.static_ip
  ssh_public_key = var.ssh_public_key
  ssh_private_key = var.ssh_private_key
  
  # Optional parameters
  # server_type   = "cx31"
  # image         = "ubuntu-24.04"
  # datacenter    = "nbg1-dc3"
  # ipv4_enabled  = true
  # ipv6_enabled  = true
}
```

## Requirements
- Hetzner Cloud API token with read/write permissions
- Existing network for the Kubernetes cluster
- Running master control plane node
- SSH key pair for machine-to-machine communication

## Input Variables

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| name | Name of the control plane node | string | n/a | yes |
| image | Image for the control plane node | string | "ubuntu-24.04" | no |
| server_type | Server type for the control plane node | string | "cx22" | no |
| datacenter | Datacenter for the primary IP | string | "nbg1-dc3" | no |
| ipv4_enabled | Whether IPv4 is enabled for the control plane node | bool | true | no |
| ipv6_enabled | Whether IPv6 is enabled for the control plane node | bool | true | no |
| network_id | ID of the network to attach the control plane node to | string | n/a | yes |
| ssh_public_key | SSH public key for machine-to-machine communication | string | n/a | yes |
| ssh_private_key | SSH private key for machine-to-machine communication | string | n/a | yes |
| master_node_ip | IP address of the master node | string | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| id | ID of the control plane node |
| name | Name of the control plane node |
| ipv4_address | Public IPv4 address of the control plane node |
| status | Status of the control plane node |