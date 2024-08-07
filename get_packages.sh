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
adpass=$(cat $(dirname $0)/.sec/${USER})
#curl -s -u "${USER}:${adpass}" -X POST -H "Content-Type: application/json" --data '{"jql":"key = '${issue}'","fields":["description"]}' "https://jira.inside-box.net/rest/api/2/search"
#curl -s -u "${USER}:${adpass}" -X POST -H "Content-Type: application/json" --data '{"jql":"key = '${issue}'","fields":["description"]}' "https://jira.inside-box.net/rest/api/2/search"|perl -lne 'print "$1" while(/Should be \: ([a-z]+\-*.*)\-/g)'
curl -s -u "${USER}:${adpass}" -X POST -H "Content-Type: application/json" --data '{"jql":"key = '${issue}'","fields":["description"]}' "https://jira.inside-box.net/rest/api/2/search"|perl -lne 'print "$1" while(/Should be\s+: (.*?)[-\d\.]*\.el/g)'
