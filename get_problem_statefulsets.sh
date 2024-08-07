#!/bin/bash
good_zone=$1
for pv in $(kubectl get pv --no-headers| awk '{print $1}')
do
  json_out=$(kubectl get pv $pv -o json)
  zone=$(echo $json_out | jq '.spec.nodeAffinity.required.nodeSelectorTerms[0].matchExpressions[0].values[0]'|sed 's/\"//g')
  if [[ "$zone" != "$good_zone" ]];then
      ns=$(echo $json_out | jq '.spec.claimRef.namespace')
      echo $ns|sed 's/\"//g'
  fi
done | sort -u
