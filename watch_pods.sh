while :
do
    for i in $(seq 1 8);do
    pod=$(kubectl get pods -n kube-stress-test-app-stateless-dev-000$i --no-headers 2>/dev/null|head -1|awk '{print $1}');
    if [[ "$pod" != "" ]];then
    echo "kube-stress-test-app-stateless-dev-000$i $pod"
    output="$(kubectl describe pod $pod -n kube-stress-test-app-stateless-dev-000$i)"
    echo "$output" | grep '^Status'
    echo "$output" | grep -A 100 "Events:"
    echo
    fi
    done
    sleep 1
done
