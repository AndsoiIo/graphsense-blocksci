#!/bin/sh
set -o errexit
set -o nounset
IFS=$(printf '\n\t')
# Docker
sudo apt-get remove --yes docker docker-engine docker.io containerd runc
sudo apt-get update

sudo apt-get --yes --no-install-recommends apt-transport-https ca-certificates curl gnupg-agent software-properties-common

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository \
   "deb [arch=$(dpkg --print-architecture)] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

sudo apt-get update
sudo apt-get --yes --no-install-recommends install docker-ce docker-ce-cli containerd.io
sudo usermod --append --groups docker "$USER"
printf '\nDocker installed successfully\n\n'
echo docker --version

# Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/download/1.26.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

printf '\nDocker Compose installed successfully\n\n'
echo docker-compose --version