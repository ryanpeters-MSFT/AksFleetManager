# list member cluster CRD resources
kubectl get memberclusters

# list the custom placements
kubectl get clusterresourceplacements

# list fleet-specific resources
kubectl api-resources | findstr /c:fleet /i