#!/bin/bash
#for auditing wavefront dashboards
#read from config file
config_file="$1"
token=$(awk -F "=" '/token/ {print $2}' "${config_file}")
dashboard_url=$(awk -F "=" '/wf_url/ {print $2}' "${config_file}")
json_file=$(awk -F "=" '/dashboard_json/ {print $2}' "${config_file}")

curl -s -X GET --header "Accept: application/json" --header "Authorization: Bearer ${token}" "${dashboard_url}"
" > Skynet-GKE-dashboard.json

sections_count=$(jq ".response.sections[] | length" ${json_file}|head -1)
for section_num in $(seq 0 ${sections_count})
do 
    if [[ "$(jq \".response.sections[${section_num}].rows[]\" ${json_file})\"" != "null" ]];then
    rows_count=$(jq ".response.sections[${section_num}].rows[] | length" ${json_file}|head -1)
    for row_num in $(seq 0 ${rows_count})
    do
        if [[ "$(jq \".response.sections[${section_num}].rows[${row_num}].charts[]\" ${json_file})\"" != "null" ]];then
        charts_count=$(jq ".response.sections[${section_num}].rows[${row_num}].charts[] | length" ${json_file}|head -1)
        for chart_num in $(seq 0 ${charts_count})
        do
            if [[ "$(jq \".response.sections[${section_num}].rows[${row_num}].charts[${chart_num}].name\" ${json_file})\"" != "null" ]];then
            name=$(jq ".response.sections[${section_num}].rows[${row_num}].charts[${chart_num}].name" ${json_file})
            echo "name: $name"
            sources_count=$(jq ".response.sections[${section_num}].rows[${row_num}].charts[${chart_num}].sources[] | length" ${json_file}|head -1)
            for source_num in $(seq 0 ${sources_count})
            do
                if [[ $(jq ".response.sections[${section_num}].rows[${row_num}].charts[${chart_num}].sources[${source_num}].query" ${json_file}) != "null" ]];then
                    query=$(jq ".response.sections[${section_num}].rows[${row_num}].charts[${chart_num}].sources[${source_num}].query" ${json_file})
                    echo "query[${source_num}]: $query"
                fi
            done
            fi
        done
        fi
    done
    fi
done
