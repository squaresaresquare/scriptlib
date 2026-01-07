#!/bin/bash
project=$1
if [[ "$project" == "" ]];then
    project=$(gcloud config get project 2>/dev/null)
    if [[ "$project" == "" ]];then
        echo "pass the project as an argument"
        exit
    fi
fi

region=""

if [[ "$project" =~ "west1" ]];then
    region="us-west1"
elif [[ "$project" =~ "central1" ]];then
    region="us-central1"
elif [[ "$project" =~ "west4" ]];then
    region="us-west4"
else
    echo "unable to get region from project name"
    exit
fi

gcloud compute forwarding-rules list --project $project 2>/dev/null | grep -E '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | awk '{print $3}' > /tmp/filter

echo > /tmp/load-balancer-ips

for cluster in $(gcloud container clusters list --project $project --format=json 2>/dev/null | jq .[].name | sed 's/"//g')
do
    gcloud container clusters get-credentials $cluster --region $region --project $project --quiet > /dev/null 2>&1
    /usr/bin/kubectl get services -A | grep -f /tmp/filter | awk '{print $4}' >> /tmp/load-balancer-ips 2>/dev/null
done
orphans=$(gcloud compute forwarding-rules list --project $project | grep -vf /tmp/load-balancer-ips)
echo "-------------------------"
if [[ "$orphans" == "" ]];then
    echo "No orphaned forwarding rules"
else
    echo "Orphaned forwarding Rules"
    echo "$orphans"
fi
rm /tmp/load-balancer-ips /tmp/filter
