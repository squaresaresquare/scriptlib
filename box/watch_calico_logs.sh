#!/bin/bash
trap ctrl_c INT

function ctrl_c() {
    /usr/bin/rm /tmp/tmp.log
    exit
}

while : 
do 
    /usr/bin/kubectl get pods -n calico-system --no-headers | /usr/bin/awk '{print $1}' | /usr/bin/xargs -I % -P 2100 /usr/bin/bash -c "export POD=%;/usr/bin/kubectl logs -n calico-system \${POD} | sed \"s/^/\$POD : /\" | grep -i 'http\&error'" > /tmp/tmp.log
    /usr/bin/grep -vf /tmp/calico_http_errors.log /tmp/tmp.log > /tmp/tmp2.log
    /usr/bin/cat /tmp/tmp2.log
    /usr/bin/mv /tmp/tmp2.log /tmp/calico_http_errors.log
    /usr/bin/echo > /tmp/tmp.log
    /usr/bin/sleep 2
done
