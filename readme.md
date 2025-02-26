# AKS Fleet Manager Overview

> This is a work in progress!

Azure Kubernetes Fleet Manager (AKS Fleet Manager) allows for the management of multiple AKS clusters at scale. There are two types of AKS Fleet Manager instances: **hub** and **non-hub**.

- **Non-Hub AKS Fleet Manager Instance** - This acts solely as a grouping entity in Azure Resource Manager (ARM) without a central hub. It supports update orchestration but lacks workload orchestration and layer-4 load balancing. It does not incur additional costs.

- **Hub AKS Fleet Manager Instance** - This includes a managed AKS cluster that acts as a central hub. It stores and propagates Kubernetes resources, orchestrates workloads, and provides layer-4 load balancing. It incurs additional costs associated with the hub cluster.

## Quickstart

1. Set resource group and cluster names in [vars.ps1](./vars.ps1)
2. Invoke [clusters.ps1](./clusters.ps1) to create 4 (1-node each) AKS clusters. Two will be assigned to each fleet instance.
3. Invoke [fleet-nonhub.ps1](./fleet-nonhub.ps1) to create a non-hub Fleet resource instance and associate the 1st and 2nd AKS clusters.
4. Invoke [fleet-hub.ps1](./fleet-hub.ps1) to create a hub Fleet cluster resource instance and associate the 3rd and 4th AKS clusters.

At this point, there are 2 Fleet instances with 2 AKS member clusters attached to each. 

### Non-Hub Cluster

This cluster type contains the first two AKS member clusters.

*TBD*

### Hub Cluster

This cluster allows for additional functionality over the non-hub cluster, such as the ability to deploy workloads to a particular namespace and control the placement of those workloads across member clusters. 

After the `fleet-hub.ps1` script is invoked, you should be authenticated to the hub cluster (via Azure RBAC). The next steps are to create a namespace in the cluster, deploy a sample workload, and control the placement of the workloads in that namespace.

```powershell
# create a namespace on the hub cluster called "apps"
kubectl create ns apps

# add a custom resource placement to apply to ALL member cluster for workloads on the "apps" namespace
kubectl apply -f clusterresourceplacement.yaml

# deploy a workload and LoadBalancer service
kubectl apply -f workload.yaml

# to remove the deployment
kubectl delete -f workload.yaml
```

After the workload is deployed, it will be available in the two member clusters (demo3cluster and demo4cluster), in addition to the LoadBalancer service and Azure Load Balancer created for it. In addition, removing the deployment/service resources from the `apps` namespace on the hub cluster will remove the same resources from these two member clusters.

In order to control the placement of workloads to a set of member clusters, we can apply affinity using labels. Each member cluster is represented in the hub cluster as a `MemberCluster` resource and can be viewed by running `kubectl get memberclusters`. 

```powershell
# add the label "env=prod" to the demo4cluster member
kubectl label membercluster demo4cluster env=prod

# add a custom resource placement to apply to only member clustes with the label env=prod
kubectl apply -f clusterresourceplacement-prod.yaml

# deploy a workload and LoadBalancer service
kubectl apply -f workload.yaml

# to remove the deployment
kubectl delete -f workload.yaml
```

After this workload is deployed, the resources are only applied to the docker4demo member cluster.

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