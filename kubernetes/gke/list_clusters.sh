#!/bin/bash
gcloud auth print-access-token >/dev/null 2>&1 || gcloud auth login

projects=($(gcloud projects list 2>/dev/null | grep skynet | awk '{print $1}'))
for project in "${projects[@]}"
do
    gcloud container clusters list --project=$project --format="json" 2>/dev/null | jq '.[] | .name' | sed 's/"//g'
done
