#!/bin/bash
echo "Restart the calico typha pods one at a time";for i in $(kubectl --context=apps-us-central1-dev-02 get pods -n calico-system -l k8s-app=calico-typha --no-headers | awk '{print $1}');do kubectl --context=apps-us-central1-dev-02 delete pod $i -n calico-system;sleep 1;num_deps="$(kubectl --context=apps-us-central1-dev-02 get deployment.apps/calico-typha -n calico-system --no-headers | awk '{print $2}' | awk -F/ '{print $2}')";until [[ "$(kubectl --context=apps-us-central1-dev-02 get pods -n calico-system -l k8s-app=calico-typha --no-headers | grep -c '1/1')" == "$num_deps" ]];do echo "    wait for the typha pod to come back up...";sleep 10;done;done;echo "wait a minute to see if errors show up in the log";sleep 60;for i in $(kubectl --context=apps-us-central1-dev-02 get pods -n calico-system -l k8s-app=calico-typha --no-headers | awk '{print $1}');do kubectl --context=apps-us-central1-dev-02 logs $i -n calico-system | grep -i RemoteClusterConfiguration | grep x509;done;echo "complete"

echo "Restart the calico typha pods one at a time";for i in $(kubectl --context=apps-us-central1-dev-03 get pods -n calico-system -l k8s-app=calico-typha --no-headers | awk '{print $1}');do kubectl --context=apps-us-central1-dev-03 delete pod $i -n calico-system;sleep 1;num_deps="$(kubectl --context=apps-us-central1-dev-03 get deployment.apps/calico-typha -n calico-system --no-headers | awk '{print $2}' | awk -F/ '{print $2}')";until [[ "$(kubectl --context=apps-us-central1-dev-03 get pods -n calico-system -l k8s-app=calico-typha --no-headers | grep -c '1/1')" == "$num_deps" ]];do echo "    wait for the typha pod to come back up...";sleep 10;done;done;echo "wait a minute to see if errors show up in the log";sleep 60;for i in $(kubectl --context=apps-us-central1-dev-03 get pods -n calico-system -l k8s-app=calico-typha --no-headers | awk '{print $1}');do kubectl --context=apps-us-central1-dev-03 logs $i -n calico-system | grep -i RemoteClusterConfiguration | grep x509;done;echo "complete"

echo "Restart the calico typha pods one at a time";for i in $(kubectl --context=apps-us-central1-stg-01 get pods -n calico-system -l k8s-app=calico-typha --no-headers | awk '{print $1}');do kubectl --context=apps-us-central1-stg-01 delete pod $i -n calico-system;sleep 1;num_deps="$(kubectl --context=apps-us-central1-stg-01 get deployment.apps/calico-typha -n calico-system --no-headers | awk '{print $2}' | awk -F/ '{print $2}')";until [[ "$(kubectl --context=apps-us-central1-stg-01 get pods -n calico-system -l k8s-app=calico-typha --no-headers | grep -c '1/1')" == "$num_deps" ]];do echo "    wait for the typha pod to come back up...";sleep 10;done;done;echo "wait a minute to see if errors show up in the log";sleep 60;for i in $(kubectl --context=apps-us-central1-stg-01 get pods -n calico-system -l k8s-app=calico-typha --no-headers | awk '{print $1}');do kubectl --context=apps-us-central1-stg-01 logs $i -n calico-system | grep -i RemoteClusterConfiguration | grep x509;done;echo "complete"

echo "Restart the calico typha pods one at a time";for i in $(kubectl --context=apps-us-central1-stg-02 get pods -n calico-system -l k8s-app=calico-typha --no-headers | awk '{print $1}');do kubectl --context=apps-us-central1-stg-02 delete pod $i -n calico-system;sleep 1;num_deps="$(kubectl --context=apps-us-central1-stg-02 get deployment.apps/calico-typha -n calico-system --no-headers | awk '{print $2}' | awk -F/ '{print $2}')";until [[ "$(kubectl --context=apps-us-central1-stg-02 get pods -n calico-system -l k8s-app=calico-typha --no-headers | grep -c '1/1')" == "$num_deps" ]];do echo "    wait for the typha pod to come back up...";sleep 10;done;done;echo "wait a minute to see if errors show up in the log";sleep 60;for i in $(kubectl --context=apps-us-central1-stg-02 get pods -n calico-system -l k8s-app=calico-typha --no-headers | awk '{print $1}');do kubectl --context=apps-us-central1-stg-02 logs $i -n calico-system | grep -i RemoteClusterConfiguration | grep x509;done;echo "complete"

echo "Restart the calico typha pods one at a time";for i in $(kubectl --context=apps-us-central1-stg-03 get pods -n calico-system -l k8s-app=calico-typha --no-headers | awk '{print $1}');do kubectl --context=apps-us-central1-stg-03 delete pod $i -n calico-system;sleep 1;num_deps="$(kubectl --context=apps-us-central1-stg-03 get deployment.apps/calico-typha -n calico-system --no-headers | awk '{print $2}' | awk -F/ '{print $2}')";until [[ "$(kubectl --context=apps-us-central1-stg-03 get pods -n calico-system -l k8s-app=calico-typha --no-headers | grep -c '1/1')" == "$num_deps" ]];do echo "    wait for the typha pod to come back up...";sleep 10;done;done;echo "wait a minute to see if errors show up in the log";sleep 60;for i in $(kubectl --context=apps-us-central1-stg-03 get pods -n calico-system -l k8s-app=calico-typha --no-headers | awk '{print $1}');do kubectl --context=apps-us-central1-stg-03 logs $i -n calico-system | grep -i RemoteClusterConfiguration | grep x509;done;echo "complete"
