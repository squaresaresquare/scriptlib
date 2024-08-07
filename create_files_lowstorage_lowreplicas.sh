#!/bin/bash
for i in $(seq -w 101 300)
do
    cat skynet-test-app-stateful-stress-test-lowstorage-lowreplicas.json | sed "s/skynet-test-app-stateful-dev-stress-test/skynet-test-app-stateful-dev-stress-test-${i}/g" > stress_test_configs_lowstorage_lowreplicas/skynet-test-app-stateful-stress-test-lowstorage-lowreplicas-${i}.json 
done
