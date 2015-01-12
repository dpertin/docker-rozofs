#!/bin/bash

echo "===> Restart rpcbind service"
service rpcbind restart
service rsyslog restart

echo "===> Set the appropriate IP address in /etc/rozofs/export.conf"
sed -i "s/localhost/$(hostname -i)/" /etc/rozofs/export.conf

echo "===> Start rozofs-storaged service" 
storaged

echo "===> Start rozofs-exportd service" 
exportd

echo "===> Start rozofs-rozofsmount to mount RozoFS in the container" 
rozofsmount -H localhost -E /srv/rozofs/exports/export_1 /mnt

