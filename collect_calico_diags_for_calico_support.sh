#!/bin/bash
echo "Collect diags"
for i in $(cat dev_clusters)
do
    echo "collect $i diags"
    kconfig --context=$i
    calicoctl --context=$i cluster diags
    mv ./calico-diagnostics.tar.gz calico-diagnostics-for-00006883/$i-calico-diagnostics-after-rcc-refresh-on-all-cluster.tar.gz
done

echo "Restart the calico typha pods one at a time";
for context in $(cat half_dev_clusters)
do
     echo "cluster: $context"
     echo "check logs for errors"
     for i in $(kubectl --context=$context get pods -n calico-system -l k8s-app=calico-typha --no-headers | awk '{print $1}')
     do
         echo "checking $i"
         kubectl --context=$context logs $i -n calico-system | grep -i RemoteClusterConfiguration | grep x509
     done
     for i in $(kubectl --context=$context get pods -n calico-system -l k8s-app=calico-typha --no-headers | awk '{print $1}')
     do 
         kubectl --context=$context delete pod $i -n calico-system
         sleep 1
         num_deps="$(kubectl --context=$context get deployment.apps/calico-typha -n calico-system --no-headers | awk '{print $2}' | awk -F/ '{print $2}')"
         until [[ "$(kubectl --context=$context get pods -n calico-system -l k8s-app=calico-typha --no-headers | grep -c '1/1')" == "$num_deps" ]]
         do 
             echo "    wait for the typha pod to come back up..."
             sleep 10
         done
     done
     echo "wait a minute to see if errors show up in the log"
     sleep 60
     for i in $(kubectl --context=$context get pods -n calico-system -l k8s-app=calico-typha --no-headers | awk '{print $1}')
     do
         kubectl --context=$context logs $i -n calico-system | grep -i RemoteClusterConfiguration | grep x509
     done
     echo "$context complete"
     sleep 30
done
sleep 300
for i in $(cat dev_clusters)
do 
    kconfig --context=$i
    calicoctl --context=$i cluster diags
    mv ./calico-diagnostics.tar.gz calico-diagnostics-for-00006883/$i-calico-diagnostics-post-typha-restart.tar.gz
done
