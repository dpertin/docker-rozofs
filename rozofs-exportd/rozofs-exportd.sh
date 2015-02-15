#!/bin/bash

echo "Restart rpcbind and rozo agent"

service rpcbind restart

echo "Restart rozo agent"

rozo agent restart

echo "Start the rozofs-exportd service"
#exportd

echo "Keep the container alive"

tail -f /var/log/dmesg
