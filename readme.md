# AKS Fleet Manager Overview

> This is a work in progress!

Azure Kubernetes Fleet Manager (AKS Fleet Manager) allows for the management of multiple AKS clusters at scale. There are two types of AKS Fleet Manager instances: **hub** and **non-hub**.

- **Non-Hub AKS Fleet Manager Instance** - This acts solely as a grouping entity in Azure Resource Manager (ARM) without a central hub. It supports update orchestration but lacks workload orchestration and layer-4 load balancing. It does not incur additional costs.

- **Hub AKS Fleet Manager Instance** - This includes a managed AKS cluster that acts as a central hub. It stores and propagates Kubernetes resources, orchestrates workloads, and provides layer-4 load balancing. It incurs additional costs associated with the hub cluster.

## Comparison Chart

| Feature                        | Hub AKS Fleet Manager Instance | Non-Hub AKS Fleet Manager Instance |
|--------------------------------|--------------------------------|------------------------------------|
| **Hub Cluster Hosting**        | ✅                              | ❌                                  |
| **Update Orchestration**       | ✅                              | ✅                                  |
| **Workload Orchestration**     | ✅                              | ❌                                  |
| **Layer-4 Load Balancing**     | ✅                              | ❌                                  |
| **Billing Considerations**     | Costs associated with the hub  | No additional cost                 |
| **Conversion**                 | Cannot be downgraded           | Can be upgraded                    |

## Agents Installed 

- **fleet-hub-agent** - controller that creates and reconciles all the fleet-related CRs in the *hub* cluster.
- **fleet-member-agent** - controller that creates and reconciles all the fleet-related CRs in the *member* cluster.

## Common CRDs

- **MemberCluster** - Represents a Kubernetes cluster that is part of the managed fleet. It provides metadata and configuration details required for integrating and managing the cluster within the fleet, including connectivity, resource usage, and status information.

- **ClusterResourcePlacement** - Used to define how and where workloads are distributed across a fleet of clusters. It allows administrators to specify policies and constraints for deploying resources, ensuring efficient utilization and adherence to placement strategies across the managed clusters.

- **MultiClusterService** - Used to manage and expose services across multiple clusters within the fleet. It facilitates the seamless routing of traffic to the appropriate cluster, enabling consistent and reliable service access across the entire fleet.


## Fleet Hub Update Stages and Groups

![](https://learn.microsoft.com/en-us/azure/kubernetes-fleet/media/conceptual-update-orchestration.png#lightbox)

### Definitions

- **Update Run** - Represents an update that is to be applied to a collection of AKS clusters

## Prerequisites

- [az cli](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli)
- `kubectl` and `kubelogin`:
  - Windows/Linux: `az aks install-cli`

## Setup

1. Open shell terminal
1. Clone this git repository using: 
    ```
    git clone <this repo url>
    ```
1. Change directory: 
    ```
    cd AksFleetManager/infra/sh
    ```
1. Export required environment variables: 
    ```
    source ./vars.sh
    ```
1. Create 2 AKS clusters by running: 
    ```
    ./create-cluster.sh
    ```
1. Next create Fleet Manager Hub and add AKS clusters as cluster members using:
    ```
    ./create-fleet-hub.sh
    ```

## Use Case 1: Update AKS clusters in fleet hub

1. Use the following script to update the AKS version to 1.30.1 (based on value in `vars.sh`) for
   both control plane and worker nodes (full) of the member clusters in the fleet hub:
   ```
   ./update-fleet-hub.sh
   ```

## Use Case 2: Propagate resources to cluster member in fleet hub

1. Use the following script to create a "cluster resource placement" resource.
   The script then deploys a workload which will get propagated to all resources specified 
   in the resource placement.
   ```
   ./propagate-resources.sh
   ```

## Cleanup

1. Delete resource group using:
   ```
   az group delete -g $group
   ```

## Links

- [Fleet - Github](https://github.com/Azure/fleet)
- [Fleet Networking - Github](https://github.com/Azure/fleet-networking)