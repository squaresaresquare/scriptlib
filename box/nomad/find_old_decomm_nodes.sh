#!/bin/bash
trap ctrl_c INT

function ctrl_c() {
   if [ -f $file ];then
     rm $file
   fi
   exit 1
}

file="tmp$$.json"
curl --output $file -s -H 'Prefer: return=representation, wait=300' -H 'content-type: application/json'  https://nomad.prod.box.net/devicemgr/api/devices/?fqdn__startswith=compute-node&eav_PROVISIONING_ROLES=k8s::decomm >/dev/null
echo wait for response to complete. This can take awhile.

until [ -f $file ]
do
  echo -n .
  sleep 1
done
count=0
until [ jq . $file >/dev/null 2>/dev/null ]
do
  if [ $count -gt 300 ];then
    break
  fi
  echo -n .
  sleep 10
  ((count++))
done
echo

previous_hostname=""
jq '.results[] | select(.logentry_set[].changes.eav_PROVISIONING_ROLES[1] != null)| "\(.fqdn) \(.logentry_set[].timestamp) \(.logentry_set[].changes.eav_PROVISIONING_ROLES[1])"' $file | grep -v null | while read line
do
    hostname=$(echo $line | awk '{print $1}')
    timestamp=$(echo $line | awk '{print $2}')
    roles=$(echo $line | awk '{print $3}')
    if [[ "$hostname" != "$previous_hostname" ]];then
        previous_hostname=$hostname
        if [[ "$roles" == "k8s::decomm" ]];then
            day_ago=$(date --date "1 day ago" +'%s')
            ts=$(date --date "$timestamp" +'%s')
            if [ $ts < $day_ago ];then
                echo $line
            fi
        fi
    fi
done
