#!/bin/bash
export USE_GKE_GCLOUD_AUTH_PLUGIN=True
hostname=$1
zone=$(/usr/bin/kubectl get node ${hostname} -o json | jq '.metadata.labels."topology.gke.io/zone"' | sed 's/\"//g')
location=$(/usr/bin/kubectl get node ${hostname} -o json | jq '.metadata.labels."topology.kubernetes.io/region"' | sed 's/\"//g')
cluster=$(/usr/bin/kubectl config current-context)
project=$(gcloud config get-value project)

gcloud container clusters describe ${cluster} --region=${location} --format=json | jq '.instanceGroupUrls' | grep -v '\[\|\]' | sed 's/"//g' | sed 's/,//g' | tr -d ' '

for instance_group_url in $(gcloud container clusters describe ${cluster} --region=${location} --format=json | jq '.instanceGroupUrls' | grep -v '\[\|\]' | sed 's/"//g' | sed 's/,//g' | tr -d ' ')
do
  echo $instance_group_url
  zone=$(echo "$instance_group_url" | grep -Po "/zones/\K(.*?)(?=/)")
  instance_group=${instance_group_url##*/}
  if gcloud compute instance-groups managed list-instances --zone=$zone $instance_group --format="value(instance)" | grep -q ${hostname}; then
    break
  fi
done
echo "gcloud compute instance-groups managed delete-instances $instance_group --instances=$hostname --zone=${zone} --project=${project}"
