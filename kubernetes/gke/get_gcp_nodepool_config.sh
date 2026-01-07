#!/bin/bash
tmp_file="/tmp/tmpfile$$.json"
[ -e $tmp_file ] && sudo rm $tmp_file
touch $tmp_file
echo "Cluster,Nodepool,Pool,Pods per node,Min CPU Platform,Locations"
for project in $(gcloud projects list | awk '{print $1}' | grep skynet)
do
   gcloud container clusters list --project=$project --format="json" 2>/dev/null > $tmp_file
   clusters=$(jq '.[] | .name' $tmp_file)
   for cluster in $clusters
   do
       for nodepool in $(jq ".[] | select (.name == $cluster) | .nodePools[].name" $tmp_file)
       do
           pool=$(jq ".[] | select (.name == $cluster) | .nodePools[] | select (.name == $nodepool) | .config.labels.\"box.com/pool\"" $tmp_file)
           podsPerNode=$(jq ".[] | select (.name == $cluster) | .nodePools[] | select (.name == $nodepool) | .maxPodsConstraint.maxPodsPerNode" $tmp_file)
           minCPU=$(jq ".[] | select (.name == $cluster) | .nodePools[] | select (.name == $nodepool) | .config.minCpuPlatform" $tmp_file)
           locations=$(jq ".[] | select (.name == $cluster) | .nodePools[] | select (.name == $nodepool) | .locations[]" $tmp_file | sed 's/"//g' | tr '\n' ' '|sed 's/ $//'|sed 's/^/"/'|sed 's/$/"/')
           echo "$cluster,$nodepool,$pool,$podsPerNode,$minCPU,$locations"
       done 
   done 
done
rm $tmp_file
