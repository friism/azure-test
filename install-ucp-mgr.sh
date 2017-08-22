#!/bin/bash
if [ -z "$UCP_PUBLIC_FQDN" ]; then
    echo 'UCP_PUBLIC_FQDN is undefined'
    exit 1
fi

if [ -z "$UCP_ADMIN_PASSWORD" ]; then
    echo 'UCP_ADMIN_PASSWORD is undefined'
    exit 1
fi

echo "UCP_PUBLIC_FQDN=$UCP_PUBLIC_FQDN"

#start docker service
sudo service docker start

#install UCP
docker run docker/ucp:$UCP_VERSION images --list | xargs -L 1 docker pull
docker run --rm --name ucp \
  -v /var/run/docker.sock:/var/run/docker.sock \
  docker/ucp:$UCP_VERSION \
  install --san $UCP_PUBLIC_FQDN --admin-password $UCP_ADMIN_PASSWORD --debug
