#!/bin/bash
for project in $(gcloud projects list 2>/dev/null | grep -v prod | awk '{print $1}')
do
   region=$(echo $project | perl -lne 'print $1 if/^box-\w+-skynet-(.*$)/')
   if [[ "$region" == "asia-ne1" ]];then
     region="asia-northeast1"
   fi
   if [[ "$region" != "" ]];then
     for cluster in $(gcloud container clusters list --project=${project} --region=${region} 2>/dev/null| grep '^apps' | awk '{print $1}')
     do
    kube_cmd="/usr/bin/kubectl --context=${cluster}"
    calico_cmd="calicoctl --context=${cluster}"
    calico_version=$($calico_cmd version 2>/dev/null| grep "Cluster Calico Enterprise Version" | awk '{print $NF}')
    kube_version=$($kube_cmd version -o json 2>/dev/null | jq -r .serverVersion.gitVersion)
    echo "$cluster $kube_version"
     done
   fi
done
