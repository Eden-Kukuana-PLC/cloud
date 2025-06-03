# Agent Module

## Overview
The Agent Module creates a single Kubernetes agent node in Hetzner Cloud. This node joins the Kubernetes cluster as a worker node, connecting to the master control plane node.

## Features
- Creates a Hetzner Cloud server configured as a Kubernetes agent node
- Automatically joins the Kubernetes cluster using the master node's token
- Configures firewall rules for Kubernetes communication
- Sets up machine-to-machine communication with SSH keys

## Usage

```hcl
module "agent" {
  source = "path/to/modules/agent"

  name           = "k8s-agent-1"
  network_id     = module.network.network_id
  master_node_ip = module.master_control_plane.static_ip
  ssh_public_key = var.ssh_public_key
  ssh_private_key = var.ssh_private_key
  
  # Optional parameters
  # server_type   = "cx31"
  # image         = "ubuntu-22.04"
  # datacenter    = "fsn1"
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
| name | Name of the agent node | string | n/a | yes |
| image | Image for the agent node | string | "ubuntu-24.04" | no |
| server_type | Server type for the agent node | string | "cx22" | no |
| datacenter | Location for the agent node | string | "nbg1" | no |
| ipv4_enabled | Whether IPv4 is enabled for the agent node | bool | true | no |
| ipv6_enabled | Whether IPv6 is enabled for the agent node | bool | true | no |
| network_id | ID of the network to attach the agent node to | string | n/a | yes |
| ssh_public_key | SSH public key for machine-to-machine communication | string | n/a | yes |
| ssh_private_key | SSH private key for machine-to-machine communication | string | n/a | yes |
| master_node_ip | IP address of the master node | string | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| id | ID of the agent node |
| name | Name of the agent node |
| ipv4_address | Public IPv4 address of the agent node |
| status | Status of the agent node |