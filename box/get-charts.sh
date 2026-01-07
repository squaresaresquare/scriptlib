#!/bin/bash
#curl -s -X GET --header "Accept: application/json" --header "Authorization: Bearer 4c98cda1-7afe-40c4-a658-30b7da5312f8" "https://box.wavefront.com/api/v2/dashboard/Skynet-GKE" > Skynet-GKE-dashboard.json

sections_count=$(jq ".response.sections[] | length" Skynet-GKE-dashboard.json|head -1)
for section_num in $(seq 0 ${sections_count})
do 
    if [[ "$(jq \".response.sections[${section_num}].rows[]\" Skynet-GKE-dashboard.json)\"" != "null" ]];then
    rows_count=$(jq ".response.sections[${section_num}].rows[] | length" Skynet-GKE-dashboard.json|head -1)
    for row_num in $(seq 0 ${rows_count})
    do
        if [[ "$(jq \".response.sections[${section_num}].rows[${row_num}].charts[]\" Skynet-GKE-dashboard.json)\"" != "null" ]];then
        charts_count=$(jq ".response.sections[${section_num}].rows[${row_num}].charts[] | length" Skynet-GKE-dashboard.json|head -1)
        for chart_num in $(seq 0 ${charts_count})
        do
            if [[ "$(jq \".response.sections[${section_num}].rows[${row_num}].charts[${chart_num}].name\" Skynet-GKE-dashboard.json)\"" != "null" ]];then
            name=$(jq ".response.sections[${section_num}].rows[${row_num}].charts[${chart_num}].name" Skynet-GKE-dashboard.json)
            echo "name: $name"
            sources_count=$(jq ".response.sections[${section_num}].rows[${row_num}].charts[${chart_num}].sources[] | length" Skynet-GKE-dashboard.json|head -1)
            for source_num in $(seq 0 ${sources_count})
            do
                if [[ $(jq ".response.sections[${section_num}].rows[${row_num}].charts[${chart_num}].sources[${source_num}].query" Skynet-GKE-dashboard.json) != "null" ]];then
                    query=$(jq ".response.sections[${section_num}].rows[${row_num}].charts[${chart_num}].sources[${source_num}].query" Skynet-GKE-dashboard.json)
                    echo "query[${source_num}]: $query"
                fi
            done
            fi
        done
        fi
    done
    fi
done
