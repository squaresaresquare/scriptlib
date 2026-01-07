#!/bin/bash
adpass=""
while getopts ":i:p:" opt; do
    case $opt in
    i)
        issue=$OPTARG
        ;;
    p) 
        adpass=$OPTARG
        ;;
    esac
done

if [ "$issue" == "" ];then
    >&2 echo "syntax is $0 -i issue"
    exit 1
fi

USER="compliance-patch-s"
dir=$(dirname $0)
if [ -f $dir/.sec/${USER} ];then
    adpass=$(cat $dir/.sec/${USER})
else
    echo "can't find $dir/.sec/${USER}"
    exit 1
fi

output=$(curl -s -u "${USER}:${adpass}" -X POST -H "Content-Type: application/json" --data '{"jql":"key = '${issue}'","fields":["description","customfield_12094"]}' "https://jira.inside-box.net/rest/api/2/search" 2>&1)

if [[ $output =~ 'Forbidden (403)' ]];then
    echo "$USER is locked"
    exit 1
fi

echo ${output}|perl -lne 'print $1 while(/\"customfield_12094\":\"(.*?)\"/g)'|tr ',' '\n'|awk -F':' '{print $1}'|tr -s '\n'| sort -u

