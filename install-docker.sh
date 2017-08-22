#!/bin/bash
sudo apt-get update
sudo apt-get install -y --no-install-recommends \
    linux-image-extra-$(uname -r) \
    linux-image-extra-virtual \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common
curl -fsSL https://storebits.docker.com/ee/ubuntu/sub-40aca674-a217-4881-93fe-021c5ab3c5db/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository \
   "deb [arch=amd64] https://storebits-stage.docker.com/ee/ubuntu/sub-2026a9b9-2aed-41a7-b138-45d2ea80d429/ubuntu \
   $(lsb_release -cs) \
   test"
sudo apt-get update
sudo apt-get install -y docker-ee=$DOCKER_LINUX_VERSION~ubuntu
