#!/bin/bash
echo "cluster,kubernetes_version,calico_version"
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
        calico_version=$(calicoctl --context=${cluster} version 2>/dev/null| grep "Cluster Calico Enterprise Version" | awk '{print $NF}')
        kubernetes_verion=$(/usr/bin/kubectl --context=${cluster} version -o json 2>/dev/null | jq -r .serverVersion.gitVersion)
        echo "$cluster,$kubernetes_verion,$calico_version"
    done
done
