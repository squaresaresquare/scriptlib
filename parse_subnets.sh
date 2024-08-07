#!/bin/bash
git_repo_dir="${HOME}"
environment="staging"

while getopts "g:e:h" options; do
    case "${options}" in
    g)
        git_repo_dir=${OPTARG}
        ;;
    e)
        environment=${OPTARG}
        ;;
    h|*)
        echo "syntax: $0 -g dir -e environment" 
        echo "   -g <directory with skynet-terragrunt and box-global-network repos have been clones, default is ${environment}"
        echo "   -e <environment, development staging or production. Default it ${environment}"
        exit
    esac
done

if [ -z ${git_repo_dir} ];then
    echo 2> "using default git repo directory ${git_repo_dir}"
fi
if [ -z ${environment} ];then
    echo 2> "using default git repo directory ${environment}"
fi

case ${environment} in
    production)
        env="prod"
        ;;
    development)
        env="dev"
        ;;
    staging)
        env="stg"
        ;;
    *)
        echo "unknown environment ${environment}"
        exit
        ;;
esac

config_file="${git_repo_dir}/box-network-global/gcp/${env}/box-${env}-network-shared/vpc-subnets/skynet/subnets_vars.hcl"
terragrunt_dir="${git_repo_dir}/skynet-terragrunt/modules/skeleton/${environment}/gke-apps/"
subnets=$(perl -lne 'print "$1" if/(skynet\-apps\-subnet\-.*?\-\d)/' ${config_file} | sort -u)

declare -A node_subnets
for subnet in $(echo "$subnets")
do
    output=$(grep "      subnet_name               = \"${subnet}\"" -A 1 ${config_file})
    name=$(echo "$output" | grep subnet_name | awk '{print $NF}' | sed 's/\"//g')
    range=$(echo "$output" | grep subnet_ip | awk '{print $NF}' | sed 's/\"//g')
    node_subnets[${name}]=${range}
done 

echo "Cluster,Type,Name,cidr"
for node_subnet in "${!node_subnets[@]}"
do 
    cluster=$(grep -rl ${node_subnet} ${terragrunt_dir} |awk -v env="${env}" -F/ '{printf "apps-%s-%s-%s", $9, env, $11}')
    if [[ $cluster =~ 'instance' ]];then
        cluster=$(grep -rl ${node_subnet} ${terragrunt_dir} |awk -v env="${env}" -F/ '{printf "apps-%s-%s-%s", $9, $10, env}')
    fi
    if [[ "$cluster" == "" ]];then
        cluster="not used by ${env} apps cluster"
    fi
    echo "$cluster,apps,${node_subnet},${node_subnets[${node_subnet}]}"
    subnet_block=$(sed -n "/^[[:space:]]*\"${node_subnet}\" = \[/, /^[[:space:]]*\]$/p" ${config_file})
    services_subnet=$(echo "$subnet_block" | awk '/^\s+range_name\s* = \"skynet-apps-services.*\"$/,/^\s+ip_cidr_range = \".*\"$/')
    name=$(echo "$services_subnet" | grep range_name | awk '{print $NF}'| sed 's/\"//g')
    cidr=$(echo "$services_subnet" | grep ip_cidr_range | awk '{print $NF}'| sed 's/\"//g')
    echo "$cluster,services,${name},${cidr}"
    pods_subnet=$(echo "$subnet_block" | awk '/^\s+range_name\s* = \"skynet-apps-pods.*\"$/,/^\s+ip_cidr_range = \".*\"$/')
    name=$(echo "$pods_subnet" | grep range_name | awk '{print $NF}'| sed 's/\"//g')
    cidr=$(echo "$pods_subnet" | grep ip_cidr_range | awk '{print $NF}'| sed 's/\"//g')
    if [[ "${name}" == "" ]];then
        name="blank"
    fi
    if [[ "${cidr}" == "" ]];then
        cidr="blank"
    fi
    echo "$cluster,pods,${name},${cidr}"
done
