#!/bin/bash
echo "list tigera-operator-onprem secrets"
sudo /usr/bin/kubectl --kubeconfig=/box/kubernetes/etc/kubeconfig.kubelet get secret -n tigera-operator-onprem
echo "list tigera-operator-onprem configmaps"
sudo /usr/bin/kubectl --kubeconfig=/box/kubernetes/etc/kubeconfig.kubelet get configmap -n tigera-operator-onprem
echo "list calico-system pods"
sudo /usr/bin/kubectl --kubeconfig=/box/kubernetes/etc/kubeconfig.kubelet get pods -n calico-system
 
## tigera-operator-onprem namespace
echo "Expiry dates for tigera-operator's typha-ca"
sudo /usr/bin/kubectl --kubeconfig=/box/kubernetes/etc/kubeconfig.kubelet get cm -n tigera-operator-onprem typha-ca -ojsonpath='{.data.caBundle}' | openssl x509  -noout -dates
echo "Expiry dates for tigera-operator's typha-certs"
sudo /usr/bin/kubectl --kubeconfig=/box/kubernetes/etc/kubeconfig.kubelet get secret -n tigera-operator-onprem typha-certs -o json | jq '.data."cert.crt"' -r | base64 -d | openssl x509 -noout -dates
echo "Expiry dates for tigera-operator's node-certs"
sudo /usr/bin/kubectl --kubeconfig=/box/kubernetes/etc/kubeconfig.kubelet get cm -n tigera-operator-onprem node-certs -o json | jq '.data."cert.crt"' -r| openssl x509 -noout -dates
echo "Expiry dates for tigera-operator's node-certs secrets"
sudo /usr/bin/kubectl --kubeconfig=/box/kubernetes/etc/kubeconfig.kubelet get secret -n tigera-operator-onprem node-certs -o json | jq '.data."cert.crt"' -r | base64 -d | openssl x509 -noout -dates
 
## calico-system namespace
echo "Expiry dates for calico-system's typha-ca" 
sudo /usr/bin/kubectl --kubeconfig=/box/kubernetes/etc/kubeconfig.kubelet get cm -n calico-system typha-ca -ojsonpath='{.data.caBundle}' | openssl x509  -noout -dates
echo "Expiry dates for calico-system's typha-certs" 
sudo /usr/bin/kubectl --kubeconfig=/box/kubernetes/etc/kubeconfig.kubelet  get secret -n calico-system typha-certs -o json | jq '.data."cert.crt"' -r | base64 -d | openssl x509 -noout -dates
echo "Expiry dates for calico-system's node-certs" 
sudo /usr/bin/kubectl --kubeconfig=/box/kubernetes/etc/kubeconfig.kubelet get secret -n calico-system node-certs -o json | jq '.data."cert.crt"' -r | base64 -d | openssl x509 -noout -dates
