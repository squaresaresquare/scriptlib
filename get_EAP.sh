#!/bin/bash
for project in $(gcloud projects list 2>/dev/null| grep 'box-stg-skynet\|box-dev-skynet' | awk '{print $1}')
do
   region=$(echo $project | perl -lne 'print $1 if/^box-\w+-skynet-(.*$)/')
   if [[ "$region" == "asia-ne1" ]];then
     region="asia-northeast1"
   fi
   if [[ "$region" != "" ]];then
     for cluster in $(gcloud container clusters list --project=${project} --region=${region} 2>/dev/null| grep '^apps' | awk '{print $1}')
     do
       echo "[$cluster]"
       gcloud container clusters describe ${cluster} --project=${project} --region=${region} 2>/dev/null| grep loggingConfig: -A 10 | grep enableComponents: -A6 | grep '^    -'
     done
   fi
done
