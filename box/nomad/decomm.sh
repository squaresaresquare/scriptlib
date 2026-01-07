#!/bin/bash
file=$1
for node in $(cat $file);do
    ./set_eav_attribute.py $node PROVISIONING_ROLES k8s::decomm
done
