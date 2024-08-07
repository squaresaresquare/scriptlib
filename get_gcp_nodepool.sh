#!/bin/bash
for project in $(gcloud projects list | awk '{print $1}' | grep skynet)
do
   gcloud container clusters list --project=$project --format="json" 2>/dev/null| jq '.[] |"\(.name),\(.nodePools[].name),\(.nodePools[].config.labels."box.com/pool"),\(.nodePools[].maxPodsConstraint.maxPodsPerNode),\(.nodePools[].config.minCpuPlatform),\(.nodePools[].locations[])"' 2>/dev/null | sed 's/"//g'
done
