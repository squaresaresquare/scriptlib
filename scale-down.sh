#!/bin/bash
#kubectl scale deployment --replicas=0 kube-applier -n kube-applier
#until [[ $(kubectl get pods -n kube-applier --no-headers) == "" ]]
#do
#   sleep 30
#done
#kubectl delete ns kube-applier 2>/dev/null
for i in $(kubectl get ns --no-headers | awk '{print $2}')
do
    break
    if [ $(kubectl get pods -n $i --no-headers 2>/dev/null | wc -l) -gt 0 ];then
        deployments="$(kubectl get deployments -n $i --no-headers 2>/dev/null| awk '{print $1}')"
        sts="$(kubectl get sts -n $i --no-headers 2>/dev/null| awk '{print $1}')"
        echo "$deployments"
        echo "$sts"
        if [[ ! "$deployments" == "" ]];then 
          echo "$deployments"
          for j in $deployments  
          do
              echo "deployment $j : namespace $i"
              kubectl scale deployment --replicas=0 $j -n $i 
          done
        fi
        if [[ ! "$sts" == "" ]];then 
          for j in $sts 
          do
              echo "sts $j : namespace $i"
              kubectl scale sts --replicas=0 $j -n $i 
          done
        fi
    fi
done
