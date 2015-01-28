#!/bin/bash

# This script relies on docker to starts the RozoFS cluster based on the
# following containers:
#   * rozofs-exportd        (one by default)
#   * rozofs-storaged       (four by default)
#   * rozofs-rozofsmount    (optional)

function start_exportd()
{
    echo
    echo ">>> Bringing up the exportd node:"
    echo

    name="rozofs-exportd"

    docker run -e "DOCKER_ROZOFS_LAYOUT"=${DOCKER_ROZOFS_LAYOUT} \
               -e "DOCKER_ROZOFS_CLUSTER_SIZE"=${DOCKER_ROZOFS_CLUSTER_SIZE} \
               -e "DOCKER_ROZOFS_NAME_LIST"=${NAME_LIST} \
               -P \
               ${LINK_ARG[@]} \
               --name ${name} \
               -d denaitre/rozofs-exportd > /dev/null 2>&1
    
    echo "Successfully brought up [rozofs-exportd]"
}

function getIPbyContainerName()
{
    if local ip=$(docker inspect -f '{{ .NetworkSettings.IPAddress }}' $1);
    then
        echo "${ip}"
        return 0
    else
        #>&2 echo "[X] Impossible to find IP address of $1"
        return 1
    fi
}

function usage()
{
    echo "Usage: $1 options:"
    echo "      -d|--display            - display the storage configuration"
    echo "      -h|--help               - display this help"
    echo "      -l|--layout <{0,1,2}>   - set the RozoFS layout"
    echo "      -s|--size <size>        - set the number of storage nodes"
    echo "      -v|--volume <volume>    - add a cluster in the selected <volume>"
    exit 1
}

set -e

if env | grep -q "DOCKER_ROZOFS_DEBUG"; then
    set -x
fi

# fetch exportd IP address
exportdIP=$(getIPbyContainerName "rozofs-exportd")

OPTS=$(getopt -o dhl:s:v: -l display,help,layout:,size:,volume: -n $0 -- "$@")
if [ $? != 0 ]; then
    exit 1
fi

eval set -- "$OPTS"

# extract options and their arguments into variables.
while true ; do
    case "$1" in
        -d|--display)
            if [ ! -z ${exportdIP} ]; then
                docker exec rozofs-exportd \
                    rozo volume list --exportd ${exportdIP};
            fi
            exit 0;;
        -h|--help)
            usage $0
            break;;
        -l|--layout)
            DOCKER_ROZOFS_LAYOUT=$2;
            shift 2;;
        -s|--size)
            DOCKER_ROZOFS_CLUSTER_SIZE=$2;
            shift 2;;
        -v|--volume)
            DOCKER_ROZOFS_VID=$2;
            shift 2;;
        --) shift ; break ;;
    esac
done

# Fetch or set future environment variables for containers
#   * DOCKER_ROZOFS_CLUSTER_SIZE: the number of storage nodes in the cluster
#   * DOCKER_ROZOFS_LAYOUT:       the layout set
DOCKER_ROZOFS_CLUSTER_SIZE=${DOCKER_ROZOFS_CLUSTER_SIZE:=4}
DOCKER_ROZOFS_LAYOUT=${DOCKER_ROZOFS_LAYOUT:=0}
DOCKER_ROZOFS_VID=${DOCKER_ROZOFS_VID:=1}

min_storage=$(( ${DOCKER_ROZOFS_LAYOUT}+1 * 4))
if (( ${DOCKER_ROZOFS_CLUSTER_SIZE} < ${min_storage} )); then
    echo -E "At least ${min_storage} storage nodes are required for layout ${DOCKER_ROZOFS_LAYOUT}"
    exit 1
fi

# Define bash arrays to keep records for future configuration
#   * LINK_ARGS:            keep name for inter-container link
#   * STORAGED_IP_LIST:     keep ip address for rozofs-exportd configuration
LINK_ARGS=()
STORAGED_IP_LIST=()

echo
echo ">>> Bringing up cluster storage nodes:"
echo

# Few IDs are defined next:
#   * DOCKER_SID:           the storaged container ID in docker
#   * ROZOFS_SID:    the storage ID in a rozofs cluster
#   * ROZOFS_CID:    the rozofs cluster ID

# if rozofs-storaged containers are defined, fetch the highest SID
declare -i highestDockerSID=0
if res=$(docker ps \
        | grep rozofs-storaged.. \
        | head -1 \
        | sed 's/.*rozofs-storaged\(..\)/\1/g'); then
    # 0x are considered as octal, we have to specify base 10:
    highestDockerSID=10#${res}
fi

# Start rozofs-storaged containers
for ROZOFS_SID in $(seq 1 "${DOCKER_ROZOFS_CLUSTER_SIZE}"); do
    
    # DOCKER_SID != ROZOFS_SID
    DOCKER_SID=$(printf %02g $(( ${ROZOFS_SID} + ${highestDockerSID} )) )
    name="rozofs-storaged${DOCKER_SID}"
    
    # CID is kept in order to retrieve containers IP address (or not...)
    CID=$(docker run -e "DOCKER_ROZOFS_SID"=${ROZOFS_SID} \
               -e "DOCKER_ROZOFS_CID"="" \
               -P \
               --name ${name} \
               -d denaitre/rozofs-storaged )
                # > /dev/null 2>&1)

    # This array contains the list of 'link' parameters of each storaged
    # container used for booting the exportd container 
    LINK_ARG+=("--link $name:$name")

    STORAGED_IP_LIST+=("$(getIPbyContainerName ${name})")

    echo "Successfully brought up [rozofs-storage${DOCKER_SID}]"
done

# If no rozofs-exportd container exists, create it!
if ! docker ps | grep rozofs-exportd; then
    start_exportd
fi

echo
echo ">>> Adding rozofs-storaged containers in the cluster configuration"
echo

# Configure rozofs-exportd to add storaged containers in the cluster
# we use `rozo agent` to manage it easily
docker exec rozofs-exportd \
    rozo volume expand ${STORAGED_IP_LIST[@]} \
        --vid ${DOCKER_ROZOFS_VID} \
        --layout ${DOCKER_ROZOFS_LAYOUT} \
        --exportd localhost

docker exec rozofs-exportd \
    rozo export create ${DOCKER_ROZOFS_VID} \
        --exportd localhost

docker exec rozofs-exportd \
    rozo node start \
        --roles exportd \
        --exportd localhost

echo "Successfully configure the storage volume"
echo
