# enable the fleet extension
az extension add --name fleet

# create the hub fleet manager (using --enable-hub)
az fleet create -g $group -n $fleet -l $location --enable-hub

cluster1id=$(az aks show -n $cluster1 -g $group --query id -o tsv | tr -d '\r')
cluster2id=$(az aks show -n $cluster2 -g $group --query id -o tsv | tr -d '\r')

# Join the member clusters
az fleet member create -g $group -f $fleet -n $cluster1 --member-cluster-id $cluster1id
az fleet member create -g $group -f $fleet -n $cluster2 --member-cluster-id $cluster2id

# list the fleet members
az fleet member list -g $group -f $fleet -o table

# Create role assignment ("Azure Kubernetes Fleet Manager RBAC Cluster Admin")
fleetId=$(az fleet show -n $fleet -g $group --query id -o tsv | tr -d '\r')
myId=$(az ad signed-in-user show --query id -o tsv | tr -d '\r')
role="Azure Kubernetes Fleet Manager RBAC Cluster Admin"
az role assignment create --assignee $myId --role "$role" --scope $fleetId
