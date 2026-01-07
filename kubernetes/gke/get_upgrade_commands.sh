#!/bin/bash
if [[ "$1" != "" ]];then
    version="$1"
else
    version="1.25.12-gke.500"
fi

gcloud auth print-access-token >/dev/null 2>&1 || gcloud auth login

if [[ "$(hostname)" =~ "dev" ]]
then
   projects=($(gcloud projects list 2>/dev/null | grep -v prod | grep skynet | awk '{print $1}'))
else
   projects=($(gcloud projects list 2>/dev/null | grep prod | grep skynet | awk '{print $1}'))
fi
for project in "${projects[@]}"
do
    IFS=$'\n'
    if gcloud --format="value(name,location)" container clusters list --project=${project} >/dev/null 2>&1
    then
    for cluster_out in $(gcloud --format="value(name,location)" container clusters list --project=${project})
    do
        cluster=$(echo $cluster_out | awk '{print $1}') 
        location=$(echo $cluster_out | awk '{print $2}') 
        echo "--- $cluster --"
        echo -n "gcloud container clusters upgrade $cluster --cluster-version=$version --master --region=$location --project=$project --quiet"
        for nodepool in $(gcloud --format="value(name)" container node-pools list --region=${location} --cluster=${cluster} --project=${project})
        do
            echo -n " && gcloud container clusters upgrade $cluster --cluster-version=$version --node-pool=$nodepool --region=$location --project=$project --quiet"        
        done
        echo
    done
    echo "----"
    fi
done
