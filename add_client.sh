#!/bin/bash

# This script relies on docker to starts a new RozoFS client once a cluster
# has been created.

set -e

if env | grep -q "DOCKER_ROZOFS_DEBUG"; then
    set -x
fi

highestClientID=$(docker ps -a \
    | egrep "rozofs-client.." \
    | wc -l)

exportdIP=$(docker inspect -f \
    '{{ .NetworkSettings.IPAddress }}' "rozofs-exportd")

docker run -e "DOCKER_ROZOFS_EXPORTD_IP=${exportdIP}" \
           --name "rozofs-client$(printf '%02g' $(( $i + 1 )))" \
           --privileged \
           -d "denaitre/rozofs-rozofsmount"
