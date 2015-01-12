#!/bin/bash


echo '===> Start RozoFS management agent.'
rozo agent start
          
echo '===> Local storage definition'
rozo volume expand localhost localhost localhost localhost

echo '===> Export definition' 
rozo export create 1

