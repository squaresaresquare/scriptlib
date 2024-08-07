#!/bin/bash
while : 
do
OCTO_NUM=$(kubectl get no -l box.com/pool=octoproxy --no-headers|wc -l)
MASTER_NUM=$(kubectl get no -l box.com/pool=master --no-headers|wc -l)
INCOMPLETE=$(kubectl get no --no-headers|grep -v v1.21.14|wc -l)
DAT_COMPLETE=$(echo "$(kubectl get no --no-headers|grep v1.21.14|wc -l) - $MASTER_NUM - $OCTO_NUM"|bc)
printf "Dataplane is %.2f%% upgraded.\n" $(echo "$DAT_COMPLETE / $INCOMPLETE * 100" | bc -l)
sleep 600
done
