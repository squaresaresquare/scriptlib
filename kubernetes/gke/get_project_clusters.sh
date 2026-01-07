#!/bin/bash
for project in $(gcloud projects list --filter="name ~ 'box-(dev|prod|stg)-skynet'" --format="value(name)")
do
    echo $project
    IFS=$'\n'
    if gcloud --format="value(name,location)" container clusters list --project=${project} >/dev/null 2>&1
    then
    for cluster_out in $(gcloud --format="value(name,location)" container clusters list --project=${project})
    do
        cluster=$(echo $cluster_out | awk '{print $1}') 
        echo "${project} ${cluster}"
    done
    fi
done
