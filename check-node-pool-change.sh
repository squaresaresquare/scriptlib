#!/bin/bash
fqdn="$1"
id=$(curl -s https://nomad.prod.box.net/api/v2/devices/?fqdn=${fqdn} | jq '.results[] | .id' | sed 's/\"//g')
output=$(curl -s https://nomad.prod.box.net/devicemgr/api/devices/${id}/logs/ | jq '.results[] | "\(.changes.eav_PROVISIONING_ROLES[0]) \(.changes.eav_PROVISIONING_ROLES[1])"' | grep '"k8s::node_primary k8s::decomm"\|"k8s::decomm k8s::node"')

if [[ "$output" =~ 'k8s::node_primary' ]];then
  echo "$fqdn"
#  echo "$output"
fi
