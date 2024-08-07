#!/bin/bash
function set_project {
  echo "$cluster not in project. Set project" >&2
  projects=( $(gcloud projects list --filter="name ~ 'box-(dev|prod|stg)-skynet'" --format="value(name)") )
  for index in "${!projects[@]}";
  do
    echo "$index: ${projects[$index]}"
  done | ./draw-box.sh >&2
  read -p "Select the project to set to: " answer
  gcloud config set project ${projects[$answer]}
}
function validate_gcloud {
  if [[ $(gcloud auth describe $(gcloud auth list --format="value(account)" | grep ${USER}) 2>/dev/null 1>&2;echo $?) -ne 0 ]];then
    echo "authentication has expired" >&2
    exit 1
  fi
  if ! gcloud container clusters list --format="value(name)" | grep $(/usr/bin/kubectl config current-context);then
    set_project
  fi
}
