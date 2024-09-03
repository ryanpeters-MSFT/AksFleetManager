# Get the credentials to log into the hub cluster 
az fleet get-credentials -n $fleet -g $group --overwrite-existing

# Log into cluster using kubelogin
kubelogin convert-kubeconfig -l azurecli

# create namespace to be propagated
kubectl create namespace demo

# create ClusterResourcePlacement resource
kubectl apply -f ../../k8s/clusterresourceplacement-pickall.yaml

# create deployment to be propagated
kubectl apply -f ../../k8s/aks-helloworld.yaml -n demo
