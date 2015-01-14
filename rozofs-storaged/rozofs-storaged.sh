#!/bin/bash

echo "Set the rozofs-storaged configuration file"

DOCKER_ROZOFS_CLUSTER_ID=${DOCKER_ROZOFS_CLUSTER_ID:=1}
DOCKER_ROZOFS_STORAGE_ID=${DOCKER_ROZOFS_STORAGE_ID:=1}

sed -i "s/cidToDefine/${DOCKER_ROZOFS_CLUSTER_ID}/" /etc/rozofs/storage.conf
sed -i "s/sidToDefine/${DOCKER_ROZOFS_STORAGE_ID}/" /etc/rozofs/storage.conf

