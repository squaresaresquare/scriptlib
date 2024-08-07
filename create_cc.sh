#!/bin/bash
#credentials
jira_user="jiracieapi"
jira_pass="ZGFCusBEYBE3IpFoSpb9"
jira_uri="https://jira.inside-box.net"
#Risk Assessment
tested="Yes"                     # Yes or No
incrementally="Yes"              # Yes or No
primary_golden_signal="Yes"      # Yes or No
canary_golden_signal="https://box.wavefront.com/u/1RT9Kw25T8?t=box"
five_min_rollback="No"           # Yes or No
have_tier_1_golden_signal="Yes"  # Yes or No
tier_1_golden_signal="https://box.wavefront.com/u/94hmZH01T0?t=box"
description="Upgrade cluster apps-europe-west2-prod-01 and nodepools to 1.25.16-gke.1360000"

#Details
summary="Upgrade cluster apps-europe-west2-prod-01 and nodepools to 1.25.16-gke.1360000"
components="Kubernetes"
type="Change Control"
priority="Critical"
project="PAAS"
parent="PAAS-15158"
systems_affected="apps-europe-west2-prod-01"
services_changed="kubernetes"
allow_overlap="Yes"
change_pipeline="Other"
automation_status="Partially Automated"

#fields
deployment_plan="Run the [cluster validation pipeline|https://jenkins-k8ssre.dev.box.net/job/Cluster%20Automations/job/Cluster%20Validation/job/master/]\\\\\\\\\\\\n\\\\\\\\\\\\rRun the update command for the cluster\\\\\\\\\\\\n\\\\\\\\\\\\r{noformat}gcloud container clusters upgrade apps-europe-west2-prod-01 --cluster-version=1.25.16-gke.1360000 --master --region=europe-west2 --project=box-prod-skynet-europe-west2 --quiet\\\\\\\\\\\\n\\\\\\\\\\\\r{noformat}\\\\\\\\\\\\n\\\\\\\\\\\\r\\\\\\\\\\\\n\\\\\\\\\\\\rRun the [cluster validation pipeline|https://jenkins-k8ssre.dev.box.net/job/Cluster%20Automations/job/Cluster%20Validation/job/master/] again\\\\\\\\\\\\n\\\\\\\\\\\\r\\\\\\\\\\\\n\\\\\\\\\\\\rRun the nodepool upgrade commands\\\\\\\\\\\\n\\\\\\\\\\\\r{noformat}\\\\\\\\\\\\n\\\\\\\\\\\\rgcloud container clusters upgrade apps-europe-west2-prod-01 --cluster-version=1.25.16-gke.1360000 --node-pool=n2d64m180d100-v1-a --region=europe-west2 --project=box-prod-skynet-europe-west2 --quiet\\\\\\\\\\\\n\\\\\\\\\\\\r{noformat}"
rollback_pr="No rollback possible"
validation_steps="Check the cluster version\\\\\\\\\\\\n\\\\\\\\\\\\r{noformat}kubectl version{noformat}\\\\\\\\\\\\n\\\\\\\\\\\\rCheck nodes\\\\\\\\\\\\n\\\\\\\\\\\\r{noformat}kubectl get no | grep -v 1.25.16-gke.1360000{noformat}\\\\\\\\\\\\n\\\\\\\\\\\\rCheck the [cluster cluster validation|https://jenkins-k8ssre.dev.box.net/job/Cluster%20Automations/job/Cluster%20Validation/job/master/]"
#Dates
deployment_start="2024-02-22T10:00:00.000-0800"
deployment_end="2024-02-22T17:00:00.000-0800"

#People
reporter="sbobadilla"
asignee="sbobadilla"
director="jlavine"
vp="gtaylor"
manager="rogeryao"
#description=$(echo ${description}|perl -p -e 's/\%/\\\\\\\\\\\\%/g')
#description=$(echo ${description}|perl -p -e 's/\[/\\\\\\\\\\\\[/g')
#description=$(echo ${description}|perl -p -e 's/\]/\\\\\\\\\\\\]/g')
#description=$(echo ${description}|perl -p -e 's/\}/\\\\\\\\\\\\}/g')
#description=$(echo ${description}|perl -p -e 's/\{/\\\\\\\\\\\\{/g')
#description=$(echo ${description}|perl -p -e 's/\"/\/\\\\\\\\\\"/g')
#description=$(echo ${description}|perl -p -e "s/\'/\\\\\\\\\\\\'/g")
#deployment_plan=$(echo ${deployment_plan}|perl -p -e 's/\%/\\\\\\\\\\\\%/g')
#deployment_plan=$(echo ${deployment_plan}|perl -p -e 's/\[/\\\\\\\\\\\\[/g')
#deployment_plan=$(echo ${deployment_plan}|perl -p -e 's/\]/\\\\\\\\\\\\]/g')
#deployment_plan=$(echo ${deployment_plan}|perl -p -e 's/\}/\\\\\\\\\\\\}/g')
#deployment_plan=$(echo ${deployment_plan}|perl -p -e 's/\{/\\\\\\\\\\\\{/g')
#deployment_plan=$(echo ${deployment_plan}|perl -p -e 's/\"/\\\\\\\\\\\\"/g')
#deployment_plan=$(echo ${deployment_plan}|perl -p -e "s/\'/\\\\\\\\\\\\'/g")
#rollback_pr=$(echo ${rollback_pr}|perl -p -e 's/\%/\\\\\\\\\\\\%/g')
#rollback_pr=$(echo ${rollback_pr}|perl -p -e 's/\[/\\\\\\\\\\\\[/g')
#rollback_pr=$(echo ${rollback_pr}|perl -p -e 's/\]/\\\\\\\\\\\\]/g')
#rollback_pr=$(echo ${rollback_pr}|perl -p -e 's/\}/\\\\\\\\\\\\}/g')
#rollback_pr=$(echo ${rollback_pr}|perl -p -e 's/\{/\\\\\\\\\\\\{/g')
#rollback_pr=$(echo ${rollback_pr}|perl -p -e 's/\"/\\\\\\\\\\\\"/g')
#rollback_pr=$(echo ${rollback_pr}|perl -p -e "s/\'/\\\\\\\\\\\\'/g")
#validation_steps=$(echo ${validation_steps}|perl -p -e 's/\%/\\\\\\\\\\\\%/g')
#validation_steps=$(echo ${validation_steps}|perl -p -e 's/\[/\\\\\\\\\\\\[/g')
#validation_steps=$(echo ${validation_steps}|perl -p -e 's/\]/\\\\\\\\\\\\]/g')
#validation_steps=$(echo ${validation_steps}|perl -p -e 's/\}/\\\\\\\\\\\\}/g')
#validation_steps=$(echo ${validation_steps}|perl -p -e 's/\{/\\\\\\\\\\\\{/g')
#validation_steps=$(echo ${validation_steps}|perl -p -e 's/\"/\\\\\\\\\\\\"/g')
#validation_steps=$(echo ${validation_steps}|perl -p -e "s/\'/\\\\\\\\\\\\'/g")
# create your token here https://jira.inside-box.net/secure/ViewProfile.jspa?selectedTab=com.atlassian.pats.pats-plugin:jira-user-personal-access-tokens

echo $deployment_plan
read -d '\n' data << EOT
'{
  "fields": {
    "summary": "${summary}",
    "priority": {
      "name": "${priority}"
    },
    "issuetype": {
      "name": "${type}"
    },
    "assignee": {
      "name": "${asignee}"
    },
    "customfield_12990": {
      "name": "${director}"
    },
    "customfield_19395": {
      "name": "${vp}"
    },
    "customfield_20897": {
      "name": "${manager}"
    },
    "components": [
      { "name": "${components}" }
    ],
    "project": {
      "key": "${project}"
    },
    "description": "${description}",
    "parent": {
      "key": "${parent}"
    },
    "customfield_10053": "${systems_affected}",
    "customfield_15603": "${services_changed}",
    "customfield_13890": {
      "value": "${allow_overlap}"
    },
    "customfield_19923": {
      "value": "${change_pipeline}"
    },
    "customfield_19697": {
      "value": "${automation_status}"
    },
    "customfield_13091": "${deployment_start}",
    "customfield_13092": "${deployment_end}",
    "customfield_10051": "${deployment_plan}",
    "customfield_10052": "${rollback_pr}",
    "customfield_12291": "${validation_steps}",
    "customfield_22637": {
      "value": "${tested}"
    },
    "customfield_22638": {
      "value": "${incrementally}"
    },
    "customfield_22639": {
      "value": "${primary_golden_signal}"
    },
    "customfield_22640": "${canary_golden_signal}",
    "customfield_22641": {
      "value": "${five_min_rollback}"
    },
    "customfield_22642": {
      "value": "${have_tier_1_golden_signal}"
    },
    "customfield_22643": "${tier_1_golden_signal}"
  },
  "update": {}
}'
EOT
data=$(echo ${data}|perl -p -e 's/\-\-/\\-\\-/g')
echo $data
curl --request POST \
  --url "${jira_uri}/rest/api/2/issue" \
  --user "$jira_user:$jira_pass" \
  --header 'Accept: application/json' \
  --header 'Content-Type: application/json' \
  --data ${data}
