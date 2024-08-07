#!/bin/bash
WF_TOKEN="4c98cda1-7afe-40c4-a658-30b7da5312f8"
while :
do
    curl -s -X GET --header "Accept: application/json" --header "Authorization: Bearer $WF_TOKEN" "https://box.wavefront.com/api/v2/alert?offset=${offset}" | jq '.' > tmp_file
    jq .response.items[] tmp_file >> json_file
    is_more=$(jq '.response.moreItems' tmp_file)
    if [[ "$is_more" != "true" ]]
    then
        break
    else
        offset=$((${offset}+100))
        >&2 echo -n .
    fi
done
