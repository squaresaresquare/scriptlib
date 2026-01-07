#!/bin/bash
fqdn=$1
if [ "$fqdn" != "" ];then
    CAB=$(curl -s -X GET -H "Content-Type: application/json" https://nomad.prod.box.net/devicemgr/api/devices/?fqdn=${fqdn}|jq .results[].cabinet|sed 's/"//g')
    HOSTS=$(curl -s -X GET -H "Content-Type: application/json" https://nomad.prod.box.net/devicemgr/api/devices/?cabinet=${CAB} | jq .results[].fqdn|sed 's/"//g'|sort)
    echo "$HOSTS"
fi
