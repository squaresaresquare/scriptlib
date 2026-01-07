#!/bin/bash
function cleanup()
{
    rm $json_file
    rm $tmp_file
    rm $report_path
}

WF_TOKEN="4c98cda1-7afe-40c4-a658-30b7da5312f8"
json_file="/tmp/alert$$.json"
tmp_file="/tmp/tmp$$.json"
report_path="$(pwd)/alert_metrics$(date "+%Y.%m.%d.%H.%M.%S").csv"
echo > $json_file
echo > $tmp_file
echo > $report_path
offset=100

trap cleanup SIGINT INT QUIT TERM EXIT

>&2 echo "Fetching Alerts, this takes awhile"
while :
do
    curl -s -X GET --header "Accept: application/json" --header "Authorization: Bearer $WF_TOKEN" "https://box.wavefront.com/api/v2/alert?offset=${offset}" | jq '.' > $tmp_file
    jq .response.items[] $tmp_file >> $json_file
    is_more=$(jq '.response.moreItems' $tmp_file)
    if [[ "$is_more" != "true" ]]
    then
        break
    else
        offset=$((${offset}+100))
        >&2 echo -n .
    fi
done
>&2 echo
rm $tmp_file
max=$(jq .name $json_file | wc -l)
count=0
while read -r alert
do
   count=$(($count+1))
   #>&2 echo -ne "%\033[0K\r"
   >&2 echo "Alert: $alert ($count/$max)"
   search_all_this=$(jq ". | select(.name == $alert)" $json_file)
   while read -r query
   do
       query_metrics=$(echo "$search_all_this" | grep -q 'gcp\.' &&  echo "$search_all_this" | perl -lne 'print "$1" while(/(([a-z\.]+)*gcp(\.[a-z]+)+)/g)')
       if [[ "$query_metrics" != "" ]];then
           metrics+="\n$query_metrics"
       fi
   done <<< $(echo $alert_queries | jq ". | select(.name == $alert) .alertSources[].query")
   if [[ "$(echo $metrics | grep -v '^$')" != "" ]];then
       echo "$alert :"
       echo -e "$metrics" | grep -v '^$' | sort -u | sed "s/^/    /"
       message+=$(echo -e "$metrics" | grep -v '^$' | sort -u | sed "s/^/$alert,/")
   fi
done <<< "$(jq .name $json_file)"
echo $message > $report_path
rm $json_file
>&2 echo "Report located $report_path"
