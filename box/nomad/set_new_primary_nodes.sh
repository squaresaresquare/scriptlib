#!/bin/bash
file=$1
for node in $(cat $file);do
    ./set_eav_attribute.py $node PROVISIONING_ROLE compute-node
    ./set_eav_attribute.py $node PROVISIONING_PRIMARY_ROLE COMPUTE_NODE_RHEL7
    ./set_eav_attribute.py $node SERVICECAT_INTEGRATION_NAME compute-node
    ./set_eav_attribute.py $node PROVISIONING_ROLES k8s::node_primary
    ./set_eav_attribute.py $node PROVISIONING_SERVICE_VERSION lv7_k8s_c1_v1_21_14
    ./set_eav_attribute.py $node NOMAD_BOOTSTRAP_DIFFS '{"PROVISIONING_ROLES": {"current": "k8s::node_primary", "expected": "k8s::node_primary"}, "_SIN_": "compute-node"}'
    ./set_eav_attribute.py $node K9S_UPGRADE_METADATA ' '
done
