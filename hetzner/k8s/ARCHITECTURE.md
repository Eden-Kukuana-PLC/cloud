# Hetzner Kubernetes Cluster Architecture

This document describes the architecture of the Hetzner Kubernetes cluster module.

## Overview

The module creates a Kubernetes cluster on Hetzner Cloud with a flexible architecture that allows for declarative creation of different node types.

## Components

### 1. Master Control Plane

The master control plane is the central node for the Kubernetes control plane. It is initialized as a K3s server with the `--cluster-init` flag, which sets it up as the first node in a highly available cluster.

Key characteristics:
- Single node (not scalable through count)
- Has a static IP address in the private network
- Runs the Kubernetes API server, controller manager, and scheduler
- Serves as the entry point for the cluster

### 2. Additional Control Planes

Additional control planes are nodes that join the main master control plane and also run control plane components. They are initialized as K3s servers that join the main master.

Key characteristics:
- Scalable through count
- Join the main master control plane
- Run control plane components
- Provide high availability for the control plane
- Can be declaratively created and named

### 3. Agent Nodes

Agent nodes are worker nodes that join the Kubernetes cluster but don't run control plane components. They are initialized as K3s agents.

Key characteristics:
- Scalable through count
- Join the main master control plane
- Run workloads but not control plane components
- Can be declaratively created and named

## Networking

All nodes are connected to a private network for internal communication. The master control plane has a static IP address in this network, which is used by other nodes to communicate with it.

## Initialization

Nodes are initialized using cloud-init templates:
- `master.yaml.tpl`: Initializes the master control plane
- `additional_control_plane.yaml.tpl`: Initializes additional control planes
- `agent_node.yaml.tpl`: Initializes agent nodes

## Usage

The module allows for declarative creation of different node types:
- A single master control plane
- Multiple additional control planes
- Multiple agent nodes

Each node type can be configured independently with different server types, locations, and other parameters.