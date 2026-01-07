#!/bin/bash
function cleanup()
{
    rm $tmp_json
}

WF_API_KEY="4c98cda1-7afe-40c4-a658-30b7da5312f8"
dashboards_json="dashboards.json"
tmp_json="tmp.json"
rm $dashboards_json $tmp_json
touch $dashboards_json
ls $dashboards_json

touch $tmp_json
echo > $dashboards_json
echo > $tmp_json
report_path="$(pwd)/dash_board_metrics.$(date "+%Y.%m.%d.%H.%M.%S").csv"
echo > $report_path
offset=100
ls $dashboards_json

trap cleanup SIGINT INT QUIT TERM EXIT

>&2 echo "Fetching Dashboards, this takes awhile"
while :
do
    curl -s -X GET --header "Accept: application/json" --header "Authorization: Bearer $WF_API_KEY" "https://box.wavefront.com/api/v2/dashboard?offset=${offset}" | jq '.response' > $tmp_json
    jq .items[] $tmp_json >> $dashboards_json
    is_more=$(jq '.moreItems' $tmp_json)
    if [[ "$is_more" != "true" ]]
    then
        break
    else
        offset=$((${offset}+100))
        >&2 echo -n .
    fi
done
rm $tmp_json

echo "Create indented report dashboard_metrics.txt"
jq '. | select(.sections[].rows[].charts[].sources[].query | contains("gcp")) | "Dashboard: " + .name, [.sections[].rows[].charts[] | select(.sources[].query | contains("gcp")) | ["Chart: " + .name, [.sources[].query | scan("(gcp(\\.[a-z]+)+)")]]]' dashboards.json | grep 'Dashboard\|Chart\|gcp' > dashboard_metrics.txt
echo done
