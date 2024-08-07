#!/bin/bash

dev_subnet_file="/home/sbobadilla/box-network-global/gcp/dev/box-dev-network-shared/vpc-subnets/skynet/subnets_vars.hcl"
stg_subnet_file="/home/sbobadilla/box-network-global/gcp/stg/box-stg-network-shared/vpc-subnets/skynet/subnets_vars.hcl"
prod_subnet_file="/home/sbobadilla/box-network-global/gcp/prod/box-prod-network-shared/vpc-subnets/skynet/subnets_vars.hcl"

dev_inuse_dir="/home/sbobadilla/skynet-terragrunt/modules/skeleton/development/"
stg_inuse_dir="/home/sbobadilla/skynet-terragrunt/modules/skeleton/staging/"
prod_inuse_dir="/home/sbobadilla/skynet-terragrunt/modules/skeleton/production/"

cd /home/sbobadilla/box-network-global
git checkout master >/dev/null 2>&1
git pull --rebase >/dev/null 2>&1

perl -lne 'print $1 if /^.*\"?(skynet-(infra|apps)(-(services|pods)*)*-subnet(-us-west\d|-us-central\d)*(-\d)*)\".*$/' ${dev_subnet_file} > /home/sbobadilla/development_all

perl -lne 'print $1 if /^.*\"?(skynet-(infra|apps)(-(services|pods)*)*-subnet(-us-west\d|-us-central\d)*(-\d)*)\".*$/' ${stg_subnet_file} > /home/sbobadilla/staging_all

perl -lne 'print $1 if /^.*\"?(skynet-(infra|apps)(-(services|pods)*)*-subnet(-us-west\d|-us-central\d)*(-\d)*)\".*$/' ${prod_subnet_file} > /home/sbobadilla/production_all

cd /home/sbobadilla/skynet-terragrunt/
git checkout master >/dev/null 2>&1
git pull --rebase >/dev/null 2>&1

grep -r 'secondary_range_\|subnet' ${dev_inuse_dir} | perl -lne 'print $2 if /^.*\"?(skynet-(infra|apps)(-(services|pods)*)*-subnet(-us-west\d|-us-central\d)*(-\d)*)\".*$/' > /home/sbobadilla/development_used

grep -r 'secondary_range_\|subnet' ${stg_inuse_dir} | perl -lne 'print $1 if /^.*\"?(skynet-(infra|apps)(-(services|pods)*)*-subnet(-us-west\d|-us-central\d)*(-\d)*)\".*$/' > /home/sbobadilla/staging_used

grep -r 'secondary_range_\|subnet' ${prod_inuse_dir} | perl -lne 'print $1 if /^.*\"?(skynet-(infra|apps)(-(services|pods)*)*-subnet(-us-west\d|-us-central\d)*(-\d)*)\".*$/' > /home/sbobadilla/production_used



echo > /home/sbobadilla/dev.csv
echo > /home/sbobadilla/stg.csv
echo > /home/sbobadilla/prod.csv
echo "Development"
for subnet in $(grep '^skynet-apps-subnet' /home/sbobadilla/development_all)
do
    inuse="no"
    if [[ ! $(grep -rl ${subnet} ${dev_inuse_dir}) == "" ]];then
        inuse="yes"
        cluster=$(grep ${subnet} /home/sbobadilla/used|awk '{print $2}'|grep dev)
    else
        cluster=""
    fi
    subnet_ip=$(grep -A1 "subnet_name               = \"${subnet}\"" ${dev_subnet_file} | grep 'subnet_ip'| awk -F= '{print $2}' | sed 's/\"//g' | sed 's/^ //')
    echo "${subnet},${subnet_ip}" >> /home/sbobadilla/dev.csv
    echo "Subnet,Range,CIDR,in use,cluster" >> /home/sbobadilla/dev.csv
    for range in $(grep -A9 "\"${subnet}\" = \[" ${dev_subnet_file} | grep 'range_name' | awk -F= '{print $2}' | sed 's/\"//g' | sed 's/^ //')
    do
      cidr=$(grep -A9 "\"${subnet}\" = \[" ${dev_subnet_file} |grep -A1 ${range} | grep ip_cidr_range | awk -F= '{print $2}' | sed 's/\"//g' | sed 's/^ //')
      echo "${subnet},${range},${cidr},${inuse},${cluster}" >> /home/sbobadilla/dev.csv
    done
    echo >> /home/sbobadilla/dev.csv
done

echo "Staging"
for subnet in $(grep '^skynet-apps-subnet' /home/sbobadilla/staging_all)
do
    inuse="no"
    if [[ ! $(grep -rl ${subnet} ${stg_inuse_dir}) == "" ]];then
        inuse="yes"
        cluster=$(grep ${subnet} /home/sbobadilla/used|awk '{print $2}'|grep stg)
    else
        cluster=""
    fi
    subnet_ip=$(grep -A1 "subnet_name               = \"${subnet}\"" ${stg_subnet_file} | grep 'subnet_ip'| awk -F= '{print $2}' | sed 's/\"//g' | sed 's/^ //')
    echo "${subnet},${subnet_ip}" >> /home/sbobadilla/stg.csv
    echo "Subnet,Range,CIDR,in use,cluster" >> /home/sbobadilla/stg.csv
    for range in $(grep -A9 "\"${subnet}\" = \[" ${stg_subnet_file} | grep 'range_name' | awk -F= '{print $2}' | sed 's/\"//g' | sed 's/^ //')
    do
      cidr=$(grep -A9 "\"${subnet}\" = \[" ${stg_subnet_file} |grep -A1 ${range} | grep ip_cidr_range | awk -F= '{print $2}' | sed 's/\"//g' | sed 's/^ //')
      echo "${subnet},${range},${cidr},${inuse},${cluster}" >> /home/sbobadilla/stg.csv
    done
    echo  >> /home/sbobadilla/stg.csv
done

echo "Production"
for subnet in $(grep '^skynet-apps-subnet' /home/sbobadilla/production_all)
do
    inuse="no"
    if [[ ! $(grep -rl ${subnet} ${prod_inuse_dir}) == "" ]];then
        inuse="yes"
        cluster=$(grep ${subnet} /home/sbobadilla/used|awk '{print $2}'|grep prod)
    else
        cluster=""
    fi
    subnet_ip=$(grep -A1 "subnet_name               = \"${subnet}\"" ${prod_subnet_file} | grep 'subnet_ip'| awk -F= '{print $2}' | sed 's/\"//g' | sed 's/^ //')
    echo "${subnet},${subnet_ip}" >> /home/sbobadilla/prod.csv
    echo "Subnet,Range,CIDR,in use,cluster" >> /home/sbobadilla/prod.csv
    for range in $(grep -A9 "\"${subnet}\" = \[" ${prod_subnet_file} | grep 'range_name' | awk -F= '{print $2}' | sed 's/\"//g' | sed 's/^ //')
    do
      cidr=$(grep -A9 "\"${subnet}\" = \[" ${dev_subnet_file} |grep -A1 ${range} | grep ip_cidr_range | awk -F= '{print $2}' | sed 's/\"//g' | sed 's/^ //')
      echo "${subnet},${range},${cidr},${inuse},${cluster}" >> /home/sbobadilla/prod.csv
    done
    echo  >> /home/sbobadilla/prod.csv
done
