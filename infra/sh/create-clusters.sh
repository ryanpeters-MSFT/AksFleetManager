# create the RG
az group create -n $group -l $location

# create two clusters
az aks create -n $cluster1 -g $group -c 1 --kubernetes-version $initial_aks_version
az aks create -n $cluster2 -g $group -c 1 --kubernetes-version $initial_aks_version
