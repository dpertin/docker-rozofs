#!/bin/bash

echo "Restart rpcbind and rozo agent"

service rpcbind restart
rozo agent restart
