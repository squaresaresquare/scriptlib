#!/bin/bash
for cluster in $(kubectl cg --list | grep '^     🌟 Cluster:' | awk '{print $NF}')
do
  echo $cluster
  while IFS= read -a record
  do
    pv=$(echo "$record" | awk '{print $1}')
    ns=$(echo "$record" | awk '{print $6}' | awk -F/ '{print $1}')
    kubectl get pv $pv -n $ns --context=$cluster
    pv_date=$(kubectl get pv $pv -n $ns --context=$cluster -o json | jq .metadata.creationTimestamp |sed 's/Z//' |sed 's/T/ /'|sed 's/"//g')
    date_with_spaces=$(echo $pv_date|awk '{print $1}'|tr '-' ' ')
    us_date=$(echo $pv_date|awk '{print $1}'|tr '-' ' '|awk '{printf "%s/%s/%s", $2, $3, $1}')
    time=$(echo $pv_date | awk '{print $NF}')
    pv_secs=$(date +"%s" --date "$us_date $time")
    last_month=$(date +'%s' -d 'last month')
    if [ $pv_secs -lt $last_month ];then
	    kubectl delete pv $pv --context=$cluster
    fi
  done < <(kubectl get pv -A --context=$cluster | grep Released)
done
