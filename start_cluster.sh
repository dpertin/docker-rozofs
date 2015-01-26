#!/bin/bash

# This script relies on docker to starts the RozoFS cluster based on the
# following containers:
#   * rozofs-exportd    (one by default)
#   * rozofs-storaged   (four by default)

function usage()
{
    echo "Usage: $1 options:"
    echo "      -h|--help               - display this help"
    echo "      -l|--layout {0,1,2}     - set the RozoFS layout"
    echo "      -s|--size #             - set the number of storage nodes"
    exit 1
}

set -e

if env | grep -q "DOCKER_ROZOFS_DEBUG"; then
    set -x
fi

# read the options
OPTS=$(getopt -o hl:s: -l help,layout:,size: -n $0 -- "$@")
if [ $? != 0 ]; then
    exit 1
fi

eval set -- "$OPTS"

# extract options and their arguments into variables.
while true ; do
    case "$1" in
        -h|--help)
            usage $0
            break;;
        -l|--layout)
            DOCKER_ROZOFS_LAYOUT=$2;
            shift 2;;
        -s|--size)
            DOCKER_ROZOFS_CLUSTER_SIZE=$2;
            shift 2;;
        --) shift ; break ;;
    esac
done

# Fetch or set future environment variables for containers
#   * DOCKER_ROZOFS_CLUSTER_SIZE: the number of storage nodes in the cluster
#   * DOCKER_ROZOFS_LAYOUT:       the layout set
DOCKER_ROZOFS_CLUSTER_SIZE=${DOCKER_ROZOFS_CLUSTER_SIZE:=4}
DOCKER_ROZOFS_LAYOUT=${DOCKER_ROZOFS_LAYOUT:=0}

min_storage=$(( ${DOCKER_ROZOFS_LAYOUT}+1 * 4))
if (( ${DOCKER_ROZOFS_CLUSTER_SIZE} < ${min_storage} )); then
    echo -E "At least ${min_storage} storage nodes are required for layout ${DOCKER_ROZOFS_LAYOUT}"
    exit 1
fi

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
               -d denaitre/rozofs-storaged > /dev/null 2>&1
               #-e "DOCKER_ROZOFS_CLUSTER_ID" \

    # This array contains the list of 'link' parameters of each storaged
    # container used for booting the exportd container 
    LINK_ARG+=("--link $name:$name")

    echo "Successfully brought up [rozofs-storage${index}]"
done

echo
echo "Bringing up the exportd node:"
echo

name="rozofs-exportd"

docker run -e "DOCKER_ROZOFS_LAYOUT"=${DOCKER_ROZOFS_LAYOUT} \
           -e "DOCKER_ROZOFS_CLUSTER_SIZE"=${DOCKER_ROZOFS_CLUSTER_SIZE} \
           -P \
           ${LINK_ARG[@]} \
           --name ${name} \
           -d denaitre/rozofs-exportd > /dev/null 2>&1
echo "Successfully brought up [rozofs-exportd]"

export DOCKER_ROZOFS_EXPORTD_IP=$(docker inspect -f \
    '{{ .NetworkSettings.IPAddress }}' ${name})
