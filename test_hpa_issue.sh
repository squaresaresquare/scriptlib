#!/bin/bash
top="/tmp/top.$$.txt"
pods="/tmp/pods.$$.txt"
kubectl top pods -A | awk ' { print $1 } ' > $top
kubectl get pods -A | grep Running | awk ' { print $1 } ' > $pods
diff $pods $top
