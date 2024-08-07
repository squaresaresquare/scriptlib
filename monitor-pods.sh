#!/bin/bash
kubectl get pods -A | grep -v Running | awk '{print $1}' | sort | uniq -c | awk '{$1=$1;print}' |sort -r
