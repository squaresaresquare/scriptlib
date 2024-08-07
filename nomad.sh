#!/bin/bash
echo $1
curl -s https://nomad.prod.box.net/api/v2/devices/\?fqdn=${1} | jq '.results[0] |
{
    "url": "https://nomad.prod.box.net/devicemgr/devices/\(.id)/",
    "PROVISIONING_ROLES   | enc_role_classes": .sparse.PROVISIONING_ROLES,
    "PROVISIONING_SERVICE | service": .sparse.PROVISIONING_SERVICE,
    "PROVISIONING_SERVICE_VERSION | service_version": .sparse.PROVISIONING_SERVICE_VERSION,
    "SERVICECAT_INTEGRATION_NAME  | service_integration_name": .sparse.SERVICECAT_INTEGRATION_NAME,
    "K8S_UPGRADE_METADATA": .sparse.K8S_UPGRADE_METADATA
}'

#device_id=$(curl -s https://nomad.prod.box.net/api/v2/devices/\?fqdn=${1} | jq '.results[0].id')
#echo $device_id
#curl -s https://nomad.prod.box.net/api/v2/devices/${device_id}/sparse/

