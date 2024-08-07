#!/bin/bash
echo "cluster,project"
if [[ "$(hostname)" =~ "dev" ]]
then
   projects=($(gcloud projects list 2>/dev/null | grep -v prod | grep skynet | awk '{print $1}'))
else
   projects=($(gcloud projects list 2>/dev/null | grep prod | grep skynet | awk '{print $1}'))
fi
for project in "${projects[@]}"
do
    for cluster in $(gcloud container clusters list --project=$project --format="json" 2>/dev/null | jq '.[] | .name' | sed 's/"//g')
    do 
        echo "$cluster,$project"
    done
done
