#!/bin/bash

DOCKER_ROZOFS_CLUSTER_SIZE=${DOCKER_ROZOFS_CLUSTER_SIZE:=4}
DOCKER_ROZOFS_LAYOUT=${DOCKER_ROZOFS_LAYOUT:=0}

function getHostIP()
{
    local ip=$(getent hosts "$1" | cut -d " " -f1)
    echo "${ip}"
}

echo "Set the rozofs-exportd configuration file"

#IP_ARG=()
#
#for index in $(seq -f "%02g" "1" "${DOCKER_ROZOFS_CLUSTER_SIZE}"); do
#    IP_ARG+=($(getent hosts "rozofs-storaged${index}"))
#done

# The export.conf is preset with four storage nodes
# The following adds storage nodes in the config file if required
for index in $(seq -f "%02g" "5" "${DOCKER_ROZOFS_CLUSTER_SIZE}"); do
    sed -i '9i \\t\t\t\t\t{ sid = '$(expr ${index} + 0)'; host = "rozofs-storaged'${index}'"; },' \
        /etc/rozofs/export.conf
done

# Replace hostnames by IP address, required for host *storcli* to bind *storio*
for index in $(seq -f "%02g" "1" "${DOCKER_ROZOFS_CLUSTER_SIZE}"); do
    name="rozofs-storaged${index}"
    hostIP="$(getHostIP ${name})"
    sed -i "s/${name}/${hostIP}/" \
        /etc/rozofs/export.conf
done

# Set the layout in the config file
sed -i 's/layout = 0/layout = '${DOCKER_ROZOFS_LAYOUT}'/' \
        /etc/rozofs/export.conf

echo "Restart rpcbind"

service rpcbind restart

echo "Start the rozofs-exportd service"

exportd
