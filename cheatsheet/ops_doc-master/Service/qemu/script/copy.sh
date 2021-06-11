#!/bin/bash

while true; do 
   rsync --progress --partial --append -v -e ssh "root@172.17.100.5:/root/disk/*" files/
   if [ "$?" = "0" ] ; then
      echo "rsync completed normally"
      exit
   else
      echo "rsync failure. Retrying in a minute..."
      sleep 60
    fi
done