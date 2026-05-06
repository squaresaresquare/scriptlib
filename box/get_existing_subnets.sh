#!/bin/bash
#get subnets from terragrunt repos
global_network_repo_dir="${HOME}/box-network-global"
terragrunt_repo_dir="${HOME}/skynet-terragrunt"
dev_subnet_file="${global_network_repo_dir}/gcp/dev/box-dev-network-shared/vpc-subnets/skynet/subnets_vars.hcl"
stg_subnet_file="${global_network_repo_dir}/gcp/stg/box-stg-network-shared/vpc-subnets/skynet/subnets_vars.hcl"
prod_subnet_file="${global_network_repo_dir}/gcp/prod/box-prod-network-shared/vpc-subnets/skynet/subnets_vars.hcl"

dev_inuse_dir="${terragrunt_repo_dir}/modules/skeleton/development/"
stg_inuse_dir="${terragrunt_repo_dir}/modules/skeleton/staging/"
prod_inuse_dir="${terragrunt_repo_dir}/modules/skeleton/production/"

cd ${global_network_repo_dir}
git checkout master >/dev/null 2>&1
git pull --rebase >/dev/null 2>&1

perl -lne 'print $1 if /^.*\"?(skynet-(infra|apps)(-(services|pods)*)*-subnet(-us-west\d|-us-central\d)*(-\d)*)\".*$/' ${dev_subnet_file} > ${HOME}/development_all

perl -lne 'print $1 if /^.*\"?(skynet-(infra|apps)(-(services|pods)*)*-subnet(-us-west\d|-us-central\d)*(-\d)*)\".*$/' ${stg_subnet_file} > ${HOME}/staging_all

perl -lne 'print $1 if /^.*\"?(skynet-(infra|apps)(-(services|pods)*)*-subnet(-us-west\d|-us-central\d)*(-\d)*)\".*$/' ${prod_subnet_file} > ${HOME}/production_all

cd ${terragrunt_repo_dir}/
git checkout master >/dev/null 2>&1
git pull --rebase >/dev/null 2>&1

grep -r 'secondary_range_\|subnet' ${dev_inuse_dir} | perl -lne 'print $2 if /^.*\"?(skynet-(infra|apps)(-(services|pods)*)*-subnet(-us-west\d|-us-central\d)*(-\d)*)\".*$/' > ${HOME}/development_used

grep -r 'secondary_range_\|subnet' ${stg_inuse_dir} | perl -lne 'print $1 if /^.*\"?(skynet-(infra|apps)(-(services|pods)*)*-subnet(-us-west\d|-us-central\d)*(-\d)*)\".*$/' > ${HOME}/staging_used

grep -r 'secondary_range_\|subnet' ${prod_inuse_dir} | perl -lne 'print $1 if /^.*\"?(skynet-(infra|apps)(-(services|pods)*)*-subnet(-us-west\d|-us-central\d)*(-\d)*)\".*$/' > ${HOME}/production_used



echo > ${HOME}/dev.csv
echo > ${HOME}/stg.csv
echo > ${HOME}/prod.csv
echo "Development"
for subnet in $(grep '^skynet-apps-subnet' ${HOME}/development_all)
do
    inuse="no"
    if [[ ! $(grep -rl ${subnet} ${dev_inuse_dir}) == "" ]];then
        inuse="yes"
        cluster=$(grep ${subnet} ${HOME}/used|awk '{print $2}'|grep dev)
    else
        cluster=""
    fi
    subnet_ip=$(grep -A1 "subnet_name               = \"${subnet}\"" ${dev_subnet_file} | grep 'subnet_ip'| awk -F= '{print $2}' | sed 's/\"//g' | sed 's/^ //')
    echo "${subnet},${subnet_ip}" >> ${HOME}/dev.csv
    echo "Subnet,Range,CIDR,in use,cluster" >> ${HOME}/dev.csv
    for range in $(grep -A9 "\"${subnet}\" = \[" ${dev_subnet_file} | grep 'range_name' | awk -F= '{print $2}' | sed 's/\"//g' | sed 's/^ //')
    do
      cidr=$(grep -A9 "\"${subnet}\" = \[" ${dev_subnet_file} |grep -A1 ${range} | grep ip_cidr_range | awk -F= '{print $2}' | sed 's/\"//g' | sed 's/^ //')
      echo "${subnet},${range},${cidr},${inuse},${cluster}" >> ${HOME}/dev.csv
    done
    echo >> ${HOME}/dev.csv
done

echo "Staging"
for subnet in $(grep '^skynet-apps-subnet' ${HOME}/staging_all)
do
    inuse="no"
    if [[ ! $(grep -rl ${subnet} ${stg_inuse_dir}) == "" ]];then
        inuse="yes"
        cluster=$(grep ${subnet} ${HOME}/used|awk '{print $2}'|grep stg)
    else
        cluster=""
    fi
    subnet_ip=$(grep -A1 "subnet_name               = \"${subnet}\"" ${stg_subnet_file} | grep 'subnet_ip'| awk -F= '{print $2}' | sed 's/\"//g' | sed 's/^ //')
    echo "${subnet},${subnet_ip}" >> ${HOME}/stg.csv
    echo "Subnet,Range,CIDR,in use,cluster" >> ${HOME}/stg.csv
    for range in $(grep -A9 "\"${subnet}\" = \[" ${stg_subnet_file} | grep 'range_name' | awk -F= '{print $2}' | sed 's/\"//g' | sed 's/^ //')
    do
      cidr=$(grep -A9 "\"${subnet}\" = \[" ${stg_subnet_file} |grep -A1 ${range} | grep ip_cidr_range | awk -F= '{print $2}' | sed 's/\"//g' | sed 's/^ //')
      echo "${subnet},${range},${cidr},${inuse},${cluster}" >> ${HOME}/stg.csv
    done
    echo  >> ${HOME}/stg.csv
done

echo "Production"
for subnet in $(grep '^skynet-apps-subnet' ${HOME}/production_all)
do
    inuse="no"
    if [[ ! $(grep -rl ${subnet} ${prod_inuse_dir}) == "" ]];then
        inuse="yes"
        cluster=$(grep ${subnet} ${HOME}/used|awk '{print $2}'|grep prod)
    else
        cluster=""
    fi
    subnet_ip=$(grep -A1 "subnet_name               = \"${subnet}\"" ${prod_subnet_file} | grep 'subnet_ip'| awk -F= '{print $2}' | sed 's/\"//g' | sed 's/^ //')
    echo "${subnet},${subnet_ip}" >> ${HOME}/prod.csv
    echo "Subnet,Range,CIDR,in use,cluster" >> ${HOME}/prod.csv
    for range in $(grep -A9 "\"${subnet}\" = \[" ${prod_subnet_file} | grep 'range_name' | awk -F= '{print $2}' | sed 's/\"//g' | sed 's/^ //')
    do
      cidr=$(grep -A9 "\"${subnet}\" = \[" ${dev_subnet_file} |grep -A1 ${range} | grep ip_cidr_range | awk -F= '{print $2}' | sed 's/\"//g' | sed 's/^ //')
      echo "${subnet},${range},${cidr},${inuse},${cluster}" >> ${HOME}/prod.csv
    done
    echo  >> ${HOME}/prod.csv
done
