#!/bin/bash
trap cleanup SIGINT

cleanup () {
rm $filter $ds
exit
}
if [[ ! $1 ]];then
   context=$(kubectl config current-context)
else
  context=$1
fi

filter="/tmp/filter.$$"
ds="/tmp/ds.$$"

cat >${ds} <<EOL
calico-system
edgedelta
gke-node-fluentd
gke-prometheus-collector
kernel-adjuster
kube-perf-collector
kube-system
lacework-agent
metrics-router-staging
tigera-fluentd
vector-obs
velero
EOL
kubectl get no --context=$context| grep "Ready,SchedulingDisabled" | awk '{print $1}' > $filter
while : ;do
kubectl get pods -A -o wide --context=$context| grep -f $filter | grep -vf $ds | awk '{print $1,$2}' | xargs -P20 -I % bash -c "kubectl delete pod -n % --context=$context"
echo "..."
sleep 60
done
rm $filter $ds
