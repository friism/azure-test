#!/bin/bash
if [ -z "$UCP_PUBLIC_FQDN" ]; then
    echo 'UCP_PUBLIC_FQDN is undefined'
    exit 1
fi

if [ -z "$UCP_ADMIN_PASSWORD" ]; then
    echo 'UCP_ADMIN_PASSWORD is undefined'
    exit 1
fi

if [ -z "$DTR_PUBLIC_FQDN" ]; then
    echo 'DTR_PUBLIC_FQDN is undefined'
    exit 1
fi

if [ -z "$UCP_NODE"]; then
  export UCP_NODE=$(docker node ls | grep mgr0 | awk '{print $3}');
fi

#start docker service
sudo service docker start

docker login -p $HUB_PASSWORD -u $HUB_USERNAME

#install DTR
docker run --rm \
  docker pull dockerhubenterprise/dtr:$DTR_VERSION install \
  --ucp-url $UCP_PUBLIC_FQDN \
  --ucp-node $UCP_NODE \
  --dtr-external-url $DTR_PUBLIC_FQDN \
  --ucp-username admin --ucp-password $UCP_ADMIN_PASSWORD \
  --ucp-insecure-tls \
  --replica-http-port 8081 \
  --replica-https-port 8443 \
  --hub-username $HUB_USERNAME \
  --hub-password $HUB_PASSWORD