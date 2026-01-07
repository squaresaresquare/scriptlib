#!/bin/bash
function cleanup()
{
    echo cleanup here
    #rm $dashboards_json
    #rm $tmp_json
    #rm $report_path
}

WF_API_KEY="4c98cda1-7afe-40c4-a658-30b7da5312f8"
dashboards_json="/tmp/dashboards.$$.json"
tmp_json="/tmp/tmp.$$.json"
for file in $dashboards_json $tmp_json
do
    [ -e $file ] && rm $file
    touch $file
    ls $file
done
report_path="$(pwd)/dash_board_metrics.$(date "+%Y.%m.%d.%H.%M.%S").csv"
echo > $report_path
ls $report_path
offset=100
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
echo
echo $dashboards_json
exit
>&2 echo
rm $tmp_json
max=$(jq .name $dashboards_json | wc -l)
count=0
while read -r dashboard
do
   count=$(($count+1))
   #>&2 echo -ne "%\033[0K\r"
   >&2 echo "Dashboard: $dashboard ($count/$max)"
   dashboard_charts=$(jq ". | select(.name == $dashboard) .sections[].rows[].charts[]" $dashboards_json)
   metrics=""
   while read -r chart
   do
       while read -r query
       do
           query_metrics=$(echo "$query" | grep -q 'gcp\.' &&  echo "$query" | perl -lne 'print "$1" while(/(([a-z\.]+)*gcp(\.[a-z]+)+)/g)')
           if [[ "$query_metrics" != "" ]];then
               metrics+="\n$query_metrics"
           fi
       done <<< $(echo $dashboard_charts | jq ". | select(.name == $chart) .sources[].query")
   done <<< "$(echo $dashboard_charts | jq .name)" 
   if [[ "$(echo $metrics | grep -v '^$')" != "" ]];then
       echo -e "$metrics" | grep -v '^$' | sort -u | sed "s/^/$dashboard,/" | tee -a dash_board_metrics.csv
       message+=$(echo -e "$metrics" | grep -v '^$' | sort -u | sed "s/^/$dashboard,/")
   fi
done <<< "$(jq .name $dashboards_json)"
rm $dashboards_json
>&2 echo "Report located $report_path"
