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

## Links

- [Fleet - Github](https://github.com/Azure/fleet)
- [Fleet Networking - Github](https://github.com/Azure/fleet-networking)