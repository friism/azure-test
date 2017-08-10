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
   "deb [arch=amd64] https://storebits.docker.com/ee/ubuntu/sub-ccfd5e0b-f831-4f72-bdd1-4ec1df0db808/ubuntu \
   $(lsb_release -cs) \
   test"
sudo apt-get update
sudo apt-get install -y docker-ee=$DOCKER_LINUX_VERSION~ubuntu
