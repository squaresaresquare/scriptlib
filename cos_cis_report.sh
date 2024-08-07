#!/bin/bash
gcloud auth print-access-token >/dev/null 2>&1 || gcloud auth login
[ -d cos-cis-reports ] || mkdir cos-cis-reports
projects=($(gcloud projects list 2>/dev/null | grep skynet| grep "prod\|tools" | awk '{print $1}'))
for project in "${projects[@]}"
do
    echo "$project -----"
    [ -d cos-cis-reports/$project ] || mkdir cos-cis-reports/$project
    for cluster in $(gcloud container clusters list --project=$project --format="json" 2>/dev/null | jq '.[] | .name' | sed 's/"//g')
    do
	[ -d cos-cis-reports/$project/$cluster ] || mkdir cos-cis-reports/$project/$cluster
	echo "$cluster -----------------"
	kubectl get no --context=$cluster -o custom-columns=NAME:.metadata.name --no-headers | xargs -I % -P 10 -s 100000 bash -c '
		export host=%;\
                if [ ! -f cos-cis-reports/'$project'/'$cluster'/$host.textproto ];then \
		zone="$(echo $(kubectl get no $host -o json --context='$cluster' | jq .metadata.labels.\"topology.gke.io/zone\")|sed "s/\"//g")";\
                gcloud compute ssh --internal-ip $host --project='$project' --zone=$zone --command="sudo cp /etc/cis-scanner/env_vars /etc/cis-scanner/env_vars.bak;sudo sed -i \"s/^LEVEL=\\\"2\\\"/LEVEL=\\\"2\\\"/\" /etc/cis-scanner/env_vars ; sudo sed -i \"s/^RESULT=\\\".*/RESULT=\\\"\/home\/sbobadilla\/${host}.textproto\\\"/\" /etc/cis-scanner/env_vars ; sudo systemctl start cis-compliance-scanner.service ; sudo mv /etc/cis-scanner/env_vars.bak /etc/cis-scanner/env_vars" 2>/dev/null &&\
                gcloud compute scp --internal-ip ${host}:/home/sbobadilla/${host}.textproto cos-cis-reports/'$project'/'$cluster'/$host.textproto --project='$project' --zone=$zone 2>/dev/null;fi'
    done
done
[ -f cos-cis-reports.tar ] && rm cos-cis-reports.tar
tar -cf cos-cis-reports.tar cos-cis-reports
gzip -9 cos-cis-reports.tar
