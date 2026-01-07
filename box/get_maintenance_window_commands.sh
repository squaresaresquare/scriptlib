#!/bin/bash
gcloud auth print-access-token >/dev/null 2>&1 || gcloud auth login

currentdate=$(date +"%s")
starttime=$(date --date="@$currentdate" +"%Y-%m-%dT%H:%M:%SZ")
endtime=$(date --date="@$((currentdate+2592000))" +"%Y-%m-%dT%H:%M:%SZ")
if [[ "$(hostname)" =~ "dev" ]]
then
   projects=($(gcloud projects list 2>/dev/null | grep -v prod | awk '{print $1}'))
else
   projects=($(gcloud projects list 2>/dev/null | grep prod | awk '{print $1}'))
fi
echo "----------------"
command=""
for project in "${projects[@]}"
do
   region=$(echo $project | perl -lne 'print $1 if/^box-\w+-skynet-(.*$)/')
   if [[ "$region" == "asia-ne1" ]];then
     region="asia-northeast1"
   fi
   if [[ "$region" != "" ]];then
     for cluster in $(gcloud container clusters list --project=${project} --region=${region} 2>/dev/null| grep '^apps' | awk '{print $1}')
     do
     if [[ "$command" == "" ]]
     then
         command="gcloud container clusters update ${cluster} --remove-maintenance-exclusion no_updates --project=${project} --region=${region} || true;gcloud container clusters update ${cluster} --remove-maintenance-exclusion no_upgrades --project=${project} --region=${region} || true;gcloud container clusters update ${cluster} --add-maintenance-exclusion-name no_updates --add-maintenance-exclusion-start $starttime --add-maintenance-exclusion-end $endtime --add-maintenance-exclusion-scope no_upgrades --project=${project} --region=${region}"
     else
         command="${command};gcloud container clusters update ${cluster} --remove-maintenance-exclusion no_updates --project=${project} --region=${region} || true;gcloud container clusters update ${cluster} --remove-maintenance-exclusion no_upgrades --project=${project} --region=${region} || true;gcloud container clusters update ${cluster} --add-maintenance-exclusion-name no_upgrades --add-maintenance-exclusion-start $starttime --add-maintenance-exclusion-end $endtime --add-maintenance-exclusion-scope no_upgrades --project=${project} --region=${region}"
     fi
     done
     echo "${command}"
     echo
     echo "----------------"
     command=""
   fi
done
