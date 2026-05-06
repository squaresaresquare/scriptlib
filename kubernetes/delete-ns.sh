#!/bin/bash
#helper script for shutting down tigera pods stuck because they need to be finalized
for i in $(kubectl get ns | grep tigera | awk '{print $1}')
do
    #kubectl delete ns $i &
    kubectl get ns $i -o json > $i-ns.json
    vi $i-ns.json
    curl -k -H "Content-Type: application/json" -X PUT --data-binary @${i}-ns.json http://127.0.0.1:8001/api/v1/namespaces/${i}/finalize
done
