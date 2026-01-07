#!/bin/bash
gcloud auth print-access-token >/dev/null 2>&1 || gcloud auth login

if [[ "$(hostname)" =~ "dev" ]]
then
   projects=($(gcloud projects list 2>/dev/null | grep -v prod | grep skynet | awk '{print $1}'))
else
   projects=($(gcloud projects list 2>/dev/null | grep prod | grep skynet | awk '{print $1}'))
fi
echo "Cluster,Kubernetes version,Istio versions,Node Type"
for project in "${projects[@]}"
do
    IFS=$'\n'
    if gcloud --format="value(name,location)" container clusters list --project=${project} >/dev/null 2>&1
    then
    for cluster_out in $(gcloud --format="value(name,location)" container clusters list --project=${project})
    do
        cluster=$(echo $cluster_out | awk '{print $1}') 
        location=$(echo $cluster_out | awk '{print $2}') 
        k8s_version=$(kubectl version --context=${cluster} -o json 2>/dev/null | jq -r .serverVersion.gitVersion)
        sample_node=$(kubectl get no  --context=${cluster} -l box.com/pool=default --no-headers | head -1 | awk '{print $1}')
        machine_type=$(kubectl get no $sample_node  --context=${cluster} --show-labels | tr ',' '\n' | grep "beta.kubernetes.io/instance-type" | awk -F= '{print $NF}')
        istio_versions=""
        for deployment in $(kubectl get deployments  --context=${cluster} -n istio-operator | grep istio-operator | awk '{print $1}')
        do
           if [[ "$istio_versions" == "" ]];then
             istio_versions="\"$(kubectl get deployment --context=${cluster} $deployment -n istio-operator -o jsonpath='{.spec.template.spec.containers[*].env[?(@.name=="REVISION")]}' 2>/dev/null| jq .value | sed 's/"//g')"
           else
             istio_versions="$istio_versions,$(kubectl get deployment --context=${cluster} $deployment -n istio-operator -o jsonpath='{.spec.template.spec.containers[*].env[?(@.name=="REVISION")]}' 2>/dev/null| jq .value | sed 's/"//g')"
           fi
        done
        istio_versions="$istio_versions\""
        echo "$cluster,$k8s_version,$istio_versions,$machine_type"
    done
    fi
done
