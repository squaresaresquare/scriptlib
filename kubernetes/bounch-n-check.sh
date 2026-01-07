#!/bin/bash
for i in $(kubectl get pods -n calico-system -l k8s-app=calico-typha --no-headers | awk '{print $1}')
do 
    kubectl delete pod $i -n calico-system
    until [[ "$(kubectl get pods -n calico-system -l k8s-app=calico-typha --no-headers | grep -c '1/1')" == "3" ]]
    do 
        echo "."
        sleep 10
    done
    sleep 30
done
sleep 60
for i in $(kubectl get pods -n calico-system -l k8s-app=calico-typha --no-headers | awk '{print $1}')
do 
    echo $i
    echo
    kubectl logs $i -n calico-system | grep -i RemoteClusterConfiguration | grep x509
done
