#!/bin/bash
export STARTTIME=$(date)
for i in $(seq -w 1 5)
do 
    kubectl apply -f /tmp/stress_test_configs/skynet-test-app-stateful-stress-test-himem-00${i}.json
done
for i in $(seq -w 1 5)
do
    until [[ "$(kubectl get pods -n skynet-test-app-stateful-dev-stress-test-00${i} 2>/dev/null | grep -c '3/3')" == "3" ]]
    do
        sleep 1
    done
done
export ENDTIME=$(date)
echo
echo "start time: ${STARTTIME}"
echo "end time:  ${ENDTIME}"
