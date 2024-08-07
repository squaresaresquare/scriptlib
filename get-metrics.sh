#!/bin/zsh
function get_date() {
    epoc_time=$1
    date -d @${epoc_time} +"%b/%d/%Y %T"
}

function run_query() {
    local QUERY=$(echo $1| sed 's/ /+/g')
    local START_TIME=$(echo "${START_TIME} * 1000"|bc)
    local END_TIME=$(echo "${END_TIME} * 1000"|bc)
    #echo "curl -s -X GET --header \"Accept: application/json\" --header \"Authorization: Bearer ${TOKEN}\" \"https://box.wavefront.com/api/v2/chart/api?s=${START_TIME}&e=${END_TIME}&i=false&q=${QUERY}\""
    API_CALL=$(curl -s -X GET --header "Accept: application/json" --header "Authorization: Bearer ${TOKEN}" "https://box.wavefront.com/api/v2/chart/api?s=${START_TIME}&e=${END_TIME}&i=false&q=${QUERY}" || echo "FAILED" |tr -d '\n'|tr -d '\t')
    if [[ "${API_CALL}" == "FAILED" ]];then
        echo 2> "Failed to retrieve data from the wavefront API"
        echo 2> "${1}"
        exit
    fi
    DATA=$(echo ${API_CALL}|tr -d '\n'|jq '.timeseries[].data[] | "\(.[0]) \(.[1])"' 2>/dev/null|sed 's/\"//g')
    if [[ ${DATA} != "" ]];then
        #FIRST=$(echo ${DATA}| head -1)
        #LAST=$(echo ${DATA}| tail -1)
        #HIGHEST_POINT=$(echo ${DATA}|awk '{print $2}' | sort -n | tail -1)
        #PEAKS=$(echo $DATA | grep -e "[0-9] ${HIGHEST_POINT}")
        #printf "%-15s %8s %f\n" "First: " "$(get_date $(echo ${FIRST}|awk '{print $1}'))" "$(echo ${FIRST}|awk '{print $2}')"
        #while IFS= read -r line; do
        #    printf "%-15s %8s %f\n" "Peak: " "$(get_date $(echo ${line}|awk '{print $1}'))" "$(echo -n ${line}|awk '{print $2}')"
        #done <<< "${PEAKS}"
        #printf "%-15s %8s %f\n" "Last: " "$(get_date $(echo ${LAST}|awk '{print $1}'))" "$(echo -n ${LAST}|awk '{print $2}')"
        while IFS= read -r line; do
            echo "$(get_date $(echo ${line}|awk '{print $1}')),$(echo -n ${line}|awk '{print $2}')"
        done <<< "${DATA}"
        echo
    else
        echo 2> "No data found, validate query in wavefront"
        echo 2> "${1}"
        echo 2> ""
    fi
}

function usage() {
  echo "Usage: $0 -s <start time in sec> -e <end time in sec> -t <wavefront token> -c <cluster>" 1>&2
}
exit_abnormal() {                         # Function: Exit with error.
  usage
  exit 1
}
while getopts ":s:e:t:c:" arg; do
    case ${arg} in
    s)
        START_TIME=${OPTARG}
        ;;
    e)
        END_TIME=${OPTARG}
        ;;
    t)
        TOKEN=${OPTARG}
        ;;
    c)
        CLUSTER=${OPTARG}
        ;;
    *)
        exit_abnormal
        ;;
    esac
done

projectid="box-prod-skynet-us-west1"
region="us-west1"
cluster="$CLUSTER"
pod="kube-stress-test-app-state*"
polling_period="1m"
cluster_filter=", project_id=\"${projectid}\" and location=\"${region}\" and cluster_name=\"${cluster}\""

filter=", project_id=\"${projectid}\" and location=\"${region}\" and cluster_name=\"${cluster}\" and pod_name=\"${pod}\""

echo "Time,Apiserver request rate per minute"
query="rate(avg(align(${polling_period}, ts(\"kube.apiserver.apiserver_request_total\",cluster=\"${cluster}\"))))"
run_query "${query}"
echo

echo "Time,Aggregated latency for apiserver requests"
query="rawsum(align(${polling_period},ts(kube.apiserver.apiserver_request_duration_seconds.sum,cluster=\"${cluster}\")))"
run_query "${query}"
echo

echo "Time,Pending pods"
query="rawsum(align(${polling_period}, ts(\"gcp.external.prometheus.scheduler.pending_pods\", cluster_name=\"${cluster}\")))"
run_query "${query}"
echo

echo "Time,Average pod scheduling latency"
query="align(${polling_period}, ts(\"gcp.external.prometheus.scheduler.e2e_scheduling_duration_seconds.mean\", cluster_name=\"${cluster}\"))"
run_query "${query}"
echo

echo "Time,Cluster operation rate per sec"
query="rate(align(${polling_period}, ts(\"gcp.external.prometheus.apiserver.audit_event_total\", cluster_name=\"${cluster}\")))"
run_query "${query}"
echo

echo "Time,Aggregated workqueue work duration"
query="rawsum(align(${polling_period}, ts(\"gcp.external.prometheus.apiserver.workqueue_work_duration_seconds.mean\", cluster_name=\"${cluster}\")))"
run_query "${query}"
echo


echo "Time,Average Fraction of CPU limit for nodes"
query="avg(align(${polling_period}, ts(\"gcp.kubernetes.container.cpu.limit_utilization\" ${cluster_filter})))"
run_query "${query}"
echo

echo "Time,Average fraction of the memory limit for nodes"
query="avg(align(${polling_period}, ts(\"gcp.kubernetes.container.memory.limit_utilization\" ${cluster_filter})))"
run_query "${query}"
echo

echo "Time,Total CPU usage on all cores of all the containers"
query="rawsum(align(${polling_period}, ts(\"gcp.kubernetes.node.cpu.core_usage_time\" ${cluster_filter})))"
run_query "${query}"
echo

echo "Time,Number of bytes of memory allocatable to the nodes"
query="rawsum(align(${polling_period}, ts(\"gcp.kubernetes.node.memory.total_bytes\" ${cluster_filter})))"
run_query "${query}"
echo

echo "Time,Memory bytes used by the nodes"
query="rawsum(align(${polling_period}, ts(\"gcp.kubernetes.node.memory.used_bytes\" ${cluster_filter})))"
run_query "${query}"
echo 

echo "Time,Increase in number of bytes received by the nodes over the network"
query="rate(rawsum(align(10m,ts(gcp.kubernetes.node.network.received_bytes_count${cluster_filter}))))"
run_query "${query}"
echo

echo "Time,Increase in number of bytes transmitted by the nodes over the network"
query="rawsum(rate(align(${polling_period},ts("gcp.kubernetes.node.network.sent_bytes_count" ${cluster_filter}))))"
run_query "${query}"
echo

echo "Time,Total ephemeral storage usage in bytes for the containers"
query="rawsum((align(${polling_period},ts("gcp.kubernetes.node.ephemeral_storage.used_bytes" ${cluster_filter})) * 100)/align(${polling_period}, ts("gcp.kubernetes.node.ephemeral_storage.total_bytes" ${cluster_filter})))"
run_query "${query}"
echo

echo "Time,The percentage of the node limit used for the nodes"
query="avg(align(${polling_period}, ts(\"gcp.kubernetes.node.pid_used\" ${cluster_filter}))) * 100 / avg(align(${polling_period}, ts(\"gcp.kubernetes.node.pid_limit\" ${cluster_filter})))"
run_query "${query}"
echo

echo "Time,Total number of container restarts"
query="rawsum(align(${polling_period},ts(\"gcp.kubernetes.container.restart_count\" ${cluster_filter})))"
run_query "${query}"
echo

echo "Time,Total memory limit of the container in bytes"
query="rawsum(align(${polling_period}, ts(\"gcp.kubernetes.container.memory.limit_bytes\" ${cluster_filter})))"
run_query "${query}"
echo

echo "Time,Total memory request of the containers in bytes"
query="rawsum(align(${polling_period}, ts(\"gcp.kubernetes.container.memory.request_bytes\" ${cluster_filter})))"
echo "${query}"
run_query "${query}"
echo

echo "Time,Total number of CPU cores requested by the containers"
query="rawsum(align(${polling_period},ts(\"gcp.kubernetes.container.cpu.request_cores\" ${cluster_filter})))"
run_query "${query}"
echo

echo "Time,Average CPU cores limit of the containers"
query="avg(align(${polling_period}, ts(\"gcp.kubernetes.container.cpu.limit_cores\" ${cluster_filter})))"
run_query "${query}"
echo

echo "Time,Total number of cores requested by the containers"
query="rawsum(align(${polling_period}, ts(\"gcp.kubernetes.container.cpu.request_cores\" ${cluster_filter})))"
run_query "${query}"
echo

echo "Time,Total local ephemeral storage usage in bytes for containers"
query="rawsum(align(${polling_period},ts(\"gcp.kubernetes.container.ephemeral_storage.used_bytes\" ${cluster_filter})))"
run_query "${query}"
echo
