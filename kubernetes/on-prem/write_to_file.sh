#!/bin/bash

if [[ "$1" != "" ]] && [[ "$2" != "" ]];then
    PODS=()
    if [ $2 -lt 10 ];then
        for i in $(seq $1 $2);do 
            PODS+=( $(kubectl get pods -n skynet-test-app-stateful-dev-stress-test-00${i} --no-headers | awk '{print $1}') )
        done
    elif [ $2 -lt 100 ] && [ $2 -ge 10 ];then
        for i in $(seq -w $1 $2);do
            PODS+=( $(kubectl get pods -n skynet-test-app-stateful-dev-stress-test-0${i} --no-headers | awk '{print $1}') )
        done
    elif [ $2 -ge 100 ];then
        for i in $(seq -w $1 $2);do
            PODS+=( $(kubectl get pods -n skynet-test-app-stateful-dev-stress-test-${i} --no-headers | awk '{print $1}') )
        done
    fi
else 
    PODS=( $(kubectl get pods -n skynet-test-app-stateful-dev-stress-test --no-headers | awk '{print $1}') )
fi

if [ ! -f big_file-10g.txt ];then
   ./create-10g-file.sh 
fi

ls -lh big_file-10g.txt

for POD in "${PODS[@]}"
do
    echo "${POD}"
    NAMESPACE=$(echo ${POD}| sed -r 's/\-[0-9]+$//')
    echo "${NAMESPACE}"
    echo "kubectl exec -ti ${POD} -n ${NAMESPACE} -- df -h /usr/share/nginx/html 2>/dev/null | tail -1|awk '{print \$4}'"
    GIGS_FREE=$(kubectl exec -ti ${POD} -n ${NAMESPACE} -- df -h /usr/share/nginx/html 2>/dev/null | tail -1|awk '{print $4}')
    echo ${GIGS_FREE}
    echo "${GIGS_FREE}" | grep -q "G"
    if [ $? -eq 0 ];then
        GIGS_FREE=$(echo ${GIGS_FREE} | sed 's/G//')
        GIGS_FREE=$(printf "%.0f\n" "${GIGS_FREE}")
        echo ${GIGS_FREE}
        if [ ${GIGS_FREE} -ge 10 ];then
            echo "kubectl cp --no-preserve=true big_file-10g.txt ${POD}:/usr/share/nginx/html/index.html -n ${NAMESPACE} -c app"
            #kubectl cp --no-preserve=true big_file-10g.txt ${POD}:/usr/share/nginx/html/index.html -n ${NAMESPACE} -c app
        fi
    fi
done

#rm big_file-10g.txt
