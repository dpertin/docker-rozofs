#!/bin/bash

DOCKER_ROZOFS_CLUSTER_SIZE=${DOCKER_ROZOFS_CLUSTER_SIZE:=4}

function get_ip()
{
    local ip=$(getent hosts "$1" | cut -d " " -f1)
    echo "${ip}"
}

echo "Set the rozofs-exportd configuration file"

for index in $(seq -f "%02g" "1" "${DOCKER_ROZOFS_CLUSTER_SIZE}"); do
    name="rozofs-storaged${index}"
    # sed -i "s/rozofs-storaged${index}/$(getip rozofs-storaged${index})/" \
    sed -i "s/${name}/$(getent hosts "${name}" | cut -d " " -f1)/" \
        /etc/rozofs/export.conf
done


echo "Restart rpcbind"

service rpcbind restart

echo "Start the rozofs-exportd service"

exportd
