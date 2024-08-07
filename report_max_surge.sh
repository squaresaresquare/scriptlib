#!/bin/bash

if [[ "$(hostname)" =~ "prod" ]];then
    filter="name ~ 'box-prod-skynet'"
else
    filter="name ~ 'box-(dev|stg)-skynet'"
fi

echo "project,cluster,nodePool,maxSurge,number_of_nodes,percentage"
for project in $(gcloud projects list --filter="$filter" --format="value(name)")
do
   region=$(echo $project | perl -lne 'print $1 if/^box-\w+-skynet-(.*$)/')
   if [[ "$region" == "asia-ne1" ]];then
     region="asia-northeast1"
   fi
   if [[ "$region" != "" ]];then
     for cluster in $(gcloud container clusters list --project=${project} --region=${region} 2>/dev/null| grep '^apps' | awk '{print $1}')
     do
        for pool in $(gcloud container node-pools list --cluster=$cluster --project=${project} --region=${region} --format="value(name)")
        do
            num_nodes=$(kubectl get no -l cloud.google.com/gke-nodepool=$pool --no-headers --context=$cluster 2>/dev/null| wc -l)
            max_surge=$(gcloud container node-pools describe $pool --cluster=$cluster --project=${project} --region=${region}| grep maxSurge: | awk '{print $NF}')
            [ $num_nodes -gt 0 ] && float=$(echo "$max_surge / $num_nodes * 100" | bc -l)
            [ $num_nodes -gt 0 ] && percent=$(printf "%.0f" $float) || percent=-1
            [ $percent -gt 100 ] && percent=100
            [ $percent -eq -1 ] && percent="∞%"
            echo "$project,$cluster,$pool,$max_surge,$num_nodes,$percent" 
        done
     done
   fi
done
