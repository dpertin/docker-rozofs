#!/bin/bash

# This script relies on docker to starts the RozoFS cluster based on the
# following containers:
#   * rozofs-exportd    (one by default)
#   * rozofs-storaged   (four by default)

set -e

if env | grep -q "DOCKER_ROZOFS_DEBUG"; then
    set -x
fi

# Fetch or set future environment variables for containers
#   * DOCKER_ROZOFS_CLUSTER_SIZE: the number of storage nodes in the cluster
#   * DOCKER_ROZOFS_LAYOUT:       the layout set
DOCKER_ROZOFS_CLUSTER_SIZE=${DOCKER_ROZOFS_CLUSTER_SIZE:=4}
DOCKER_ROZOFS_LAYOUT=${DOCKER_ROZOFS_LAYOUT:=0}

# Define a bash array to keep records of link configuration
LINK_ARG=()

# If the cluster was previously launched and/or is still running, it must be
# stoped using `./stop_cluster.sh`
if docker ps -a | grep "denaitre/rozofs-exportd" >/dev/null; then
    echo ""
    echo "It looks like you already have some RozoFS containers running."
    echo "Please take them down before attempting to bring up another"
    echo "cluster with the following command:"
    echo ""
    echo " make stop-cluster"
    echo ""

    exit 1
fi

echo
echo "Bringing up cluster storage nodes:"
echo

for index in $(seq -f "%02g" "1" "${DOCKER_ROZOFS_CLUSTER_SIZE}"); do

    name="rozofs-storaged${index}"

    docker run -e "DOCKER_ROZOFS_STORAGE_ID"=$(expr "${index}" + 0) \
               -P \
               --name ${name} \
               -d denaitre/rozofs-storaged # > dev/null 2>&1
               #-e "DOCKER_ROZOFS_CLUSTER_ID" \

    # This array contains the list of 'link' parameters of each storaged
    # container used for booting the exportd container 
    LINK_ARG+=("--link $name:$name")

    echo "Successfully brought up [rozofs-storage${index}]"
done

echo
echo "Bringing up the exportd node:"
echo

docker run -P \
           ${LINK_ARG[@]} \
           --name "rozofs-exportd" \
           -d denaitre/rozofs-exportd # > dev/null 2>&1
echo "Successfully brought up [rozofs-exportd]"
