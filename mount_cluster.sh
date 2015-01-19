#!/bin/bash

# This script mounts automatically the remote RozoFS volume defined by a
# cluster built by Docker, given few parameters as the name of the exportd
# container, exportd path and mountpoint path.

# It expects the user to give the mount path as a parameter. The following
# returns $1 if the user gives a non-null parameter, or prints the message and
# aborts the script.
: ${1?"Usage: $0 MOUNTPOINT_PATH"}

name_exportd=${name_exportd:="rozofs-exportd"}
path_exportd=${path_exportd:="/srv/rozofs/exports/"}

ip_exportd=$(docker inspect -f '{{ .NetworkSettings.IPAddress }}' \
    ${name_exportd})

echo
echo "Trying to mount the remote RozoFS volume..."
echo

rozofsmount -H "${ip_exportd}" -E "${path_exportd}" "$1"

echo
echo "The remote RozoFS volume should be mounted"
echo
