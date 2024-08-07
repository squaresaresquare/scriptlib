#!/bin/bash
declare -A cluster_nodepools
while read -r path junk1 junk2 name
do
    environment=$(echo $path|awk -F / '{print $3}')
    region=$(echo $path|awk -F / '{print $5}')
    number=$(echo $path|awk -F / '{print $7}') 
    case $environment in
    development ) 
       env="dev"
       ;;
    staging ) 
       env="stg"
       ;;
    production ) 
       env="prod"
       ;;
    esac
    cluster="apps-$region-$env-$number"
    cluster_nodepools[$cluster]+=$name
done <<< "$(find  modules/skeleton/ -name pool.hcl -exec bash -c "echo -n {} && grep label {} " \;)"
echo result:
echo "${#cluster_nodepools[@]}"
for key in "${!cluster_nodepools[@]}"
do
   if [[ ! $key =~ "prod" ]];then
   echo "$key:"
   for i in $(echo ${cluster_nodepools[$key]} | sed 's/\"\"/ /g' | sed 's/\"//g' | tr ' ' '\n')
   do
     echo "    $i"
   done
   fi
done
