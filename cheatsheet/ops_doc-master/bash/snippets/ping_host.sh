#!/bin/bash
# 本脚本使用了将循环体放入()&的方法，（）中的命令作为子shell来运行，而&的作用就是将其丢入后台运行。wait是指等子shell进程全部结束

for ip in 10.148.60.{1..255};
do
    (
    ping $ip -c 2 &>/dev/null
    if [ $? -eq 0 ];then
        echo $ip is alive
    fi
    )&
done
wait