# Crate a run to do a full upgrade of the cluster to a specific AKS version
# --ugprade-type can be either Full, ControlPlaneOnly or NodeImageOnly (default is Full)
az fleet updaterun create --resource-group $group --fleet-name $fleet --name upgrade-run --upgrade-type Full --kubernetes-version $upgrade_aks_version

# Start the run to upgrade
az fleet updaterun start --resource-group $group --fleet-name $fleet --name upgrade-run

# Monitor the update status
az aks show -g $group -n $cluster1 --output table
az aks show -g $group -n $cluster2 --output table

# To get more detailed status or to troubleshoot, use the following kubectl commands
# Get the credentials for the cluster 1
az aks get-credentials -g $group --name $cluster1
# Get nodes to check current version using kubectl
kubectl get nodes
# Get events
kubectl get events
az aks get-credentials -g $group --name $cluster2