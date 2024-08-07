#!/bin/bash
for context in $(cat dev_clusters)
do
     for i in $(kubectl --context=$context get pods -n calico-system -l k8s-app=calico-typha --no-headers | awk '{print $1}')
     do
         echo "$i logs"
         kubectl --context=$context logs $i -n calico-system | grep -i RemoteClusterConfiguration | grep x509
         echo
     done
done
