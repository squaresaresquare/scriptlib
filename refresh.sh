export JENKINS_USER=sbobadilla
export JENKINS_TOKEN=11c7709652198ef107d564f1317d76a03c

vault login -method=ldap username=${USER}

curl -v -X POST "https://$JENKINS_USER:$JENKINS_TOKEN@jenkins-k8ssre.dev.box.net/credentials/store/system/domain/_/createCredentials" --data-urlencode 'json={
  "": "0",
  "credentials": {
    "scope": "GLOBAL",
    "id": "ansible-vault-dev",
    "username": "ansible-vault-dev",
    "password": "rFTGVgtjARQL0JiKpQihSUgTNPtxqmk",
    "description": "ansible-vault-dev",
    "$class": "com.cloudbees.plugins.credentials.impl.UsernamePasswordCredentialsImpl"
  }'

curl -X POST "https://$JENKINS_USER:$JENKINS_TOKEN@jenkins-k8ssre.dev.box.net/credentials/store/system/domain/_/createCredentials" --data-urlencode 'json={
  "": "0",
  "credentials": {
    "scope": "GLOBAL",
    "id": "ansible-vault-prod",
    "username": "ansible-vault-prod",
    "password": "691QG9jS2D2BBFnVYrbRCs94OxofAbl",
    "description": "ansible-vault-prod",
    "$class": "com.cloudbees.plugins.credentials.impl.UsernamePasswordCredentialsImpl"
  }'
curl -X POST "https://$JENKINS_USER:$JENKINS_TOKEN@jenkins-k8ssre.dev.box.net/credentials/store/system/domain/_/createCredentials" --data-urlencode 'json={
  "": "0",
  "credentials": {
    "scope": "GLOBAL",
    "id": "ansible-vault-stg",
    "username": "ansible-vault-stg",
    "password": "Uv37mnf3QIJVcnaeB7lB9OlDIyMh2Is",
    "description": "ansible-vault-stg",
    "$class": "com.cloudbees.plugins.credentials.impl.UsernamePasswordCredentialsImpl"
  }'
