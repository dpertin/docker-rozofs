#!/bin/bash

set -e

if env | grep -q "DOCKER_ROZOFS_DEBUG"; then
    set -x
fi

docker ps -a | egrep "rozofs-client.." | cut -d" " -f1 | xargs -I{} \
    docker rm -f {} > /dev/null

docker ps -a | egrep "rozofs-storaged.." | cut -d" " -f1 | xargs -I{} \
    docker rm -f {} > /dev/null

docker ps -a | egrep "rozofs-exportd" | cut -d" " -f1 | xargs -I{} \
    docker rm -f {} > /dev/null

echo "Stopped the cluster and cleared all the running containers."
