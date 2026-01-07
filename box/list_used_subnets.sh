for subnet in $(cat ~/all);do
    for instance in $(grep -rl $subnet skynet-terragrunt/modules/skeleton/);do
        env=$(echo "$instance" | awk -F/ '{print $4}')
        cluster_type=$(echo "$instance" | awk -F/ '{print $5}' | sed 's/gke\-//')
        region=$(echo "$instance" | awk -F/ '{print $6}')
        cluster=$(echo "$instance" | awk -F/ '{print $7}')
        case $env in
        production)
            env="prod"
            ;;
        development)
            env="dev"
            ;;
        staging)
            env="stg"
            ;;
        esac
        if [[ "$cluster" == "regional" ]];then
          number=$(echo "$instance" | awk -F/ '{print $8}')
          echo -e "${subnet}\t${cluster_type}-${region}-${env}-${number}"
        else
          echo -e "${subnet}\t${cluster_type}-${region}-${cluster}-${env}"
        fi
    done
done
