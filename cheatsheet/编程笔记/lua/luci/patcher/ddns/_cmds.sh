#!/bin/sh 
tar -cvzT /tmp/_flist -f /tmp/old_ddns.tar.gz -C /
tar -xvz -f /tmp/new_ddns.tar.gz -C /
tar -xvz -f /tmp/old_ddns.tar.gz -C /
