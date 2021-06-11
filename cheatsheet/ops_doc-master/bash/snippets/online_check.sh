#!/bin/bash

# 如果不能上网就重启树莓派或网络

while :
do
    ping -c 4 -W 1 10.148.60.1 >/dev/null 2>>/tmp/online_check_err.log
    if [ $? -ne 0 ];then
        systemctl restart networking >/dev/null 2>/dev/null
        systemctl daemon-reload >/dev/nell 2>/dev/null
        if [ $? -ne 0 ];then
            reboot
        fi
    fi
    sleep 30
done