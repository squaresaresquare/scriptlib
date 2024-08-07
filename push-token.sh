#!/bin/bash
ns=$1
kubectl delete secret artifactory-cache-token -n $ns
sed "s/NAMESPACE/${ns}/" artifactory-cache-token.yaml > artifactory-cache-token-${ns}.yaml
kubectl apply -f artifactory-cache-token-${ns}.yaml
