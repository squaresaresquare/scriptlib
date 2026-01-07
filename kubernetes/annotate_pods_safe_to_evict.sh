#/bin/bash
for namespace in $(/usr/bin/kubectl get deploy -A --no-headers |awk '{print $1}'|sort|uniq); do
  for pod in $(/usr/bin/kubectl get po -n $namespace --no-headers|awk '{print $1}'); do
    echo -n "$namespace : "
            /usr/bin/kubectl annotate pod -n $namespace $pod "cluster-autoscaler.kubernetes.io/safe-to-evict=true" --overwrite
  done
done
