#!/bin/bash
node=$1
if [[ "${node}" == "" ]];then
   echo "script requires a node"
   echo "$0 <node>"
   exit 1
fi 
echo "for pasting into a ticket:"
echo $node
echo "||Pod||Namespace||GB used||"
kubectl get --raw "/api/v1/nodes/${node}/proxy/stats/summary" | jq '.pods[] | [.podRef.namespace, .podRef.name , ."ephemeral-storage".usedBytes]' |tr '\n' ' ' | sed 's/\] \[/:/g' | tr ':' '\n' | sed 's/\]//g' | sed 's/\[//g' | sed 's/ //g' | sed 's/"//g'| while read -r line
do
   namespace=$(echo $line | awk -F, '{print $1}')
   name=$(echo $line | awk -F, '{print $2}')
   bytes=$(echo $line | awk -F, '{print $3}')
   gb=$(printf "%.3f" $(echo "$bytes / 1073741824"|bc -l))
   echo "|$name|$namespace|$gb|"
done | sort -n -k3 | tail -5 | sed 's/|$/Gib|/'
