#Check typha logs for cert errors.
#!/bin/bash
kubectl get pods -n calico-system --no-headers | awk '{print $1}' | xargs -I % -P20 bash -c "kubectl logs % -n calico-system 2>&1 | grep -q 'x509: certificate signed by unknown authority' && echo pod % has cert errors"
