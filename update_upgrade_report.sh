#!/bin/bash

while getopts "c:t:" OPTION; do
    case $OPTION in
    c)
        cluster=$OPTARG
        ;;
    t)
        target_version=$(echo $OPTARG|tr '-' '_')
        
        ;;
    *)
        echo "syntax $(basename($0)) -c <cluster> -t <target_version>"
        exit 1
        ;;
    esac
done

CUR_PATH=$(pwd)
cd /home/sbobadilla/k8s-ansible/
git checkout cluster_upgrade_status_report
#ansible-playbook plays/cluster_upgrade_status_report.yml --limit cluster_${cluster} -e upgrade_report_base_dir=/home/sbobadilla -e ansible_password='G0_back_to_the_Shadow!_You_cannot_pass' -e ansible_ssh_private_key_file=/home/sbobadilla/.ssh/id_rsa.pub
ansible-playbook plays/cluster_upgrade_status_report.yml --limit cluster_${cluster} -e upgrade_report_base_dir=/home/sbobadilla -e ansible_ssh_private_key_file=/home/sbobadilla/.ssh/id_rsa.pub -e target_version=${target_version}
cd ${CUR_PATH}
rsync -qa --no-motd rolling_upgrade_report sbobadilla.dev.box.net:~/
ssh -q -o StrictHostKeyChecking=no sbobadilla.dev.box.net "sudo cp -r /home/sbobadilla/rolling_upgrade_report /var/www/html/"
ssh -q -o StrictHostKeyChecking=no sbobadilla.dev.box.net "sudo /usr/bin/chmod 777 /var/www/html/rolling_upgrade_report"
ssh -q -o StrictHostKeyChecking=no sbobadilla.dev.box.net "sudo /usr/sbin/semanage fcontext -a -t httpd_sys_content_t /var/www/http/*"
ssh -q -o StrictHostKeyChecking=no sbobadilla.dev.box.net "sudo /usr/sbin/restorecon -Rv  /var/www/html"
