#!/bin/bash
for i in $(seq -w 1 100)
do
    cat skynet-test-app-stateful-stress-test-lowmem.json | sed "s/skynet-test-app-stateful-dev-stress-test/skynet-test-app-stateful-dev-stress-test-${i}/g" > stress_test_configs/skynet-test-app-stateful-stress-test-lowmem-${i}.json     
done
