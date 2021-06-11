#!/bin/sh
### 将Shell命令赋值给指定变量，以保证脚本的移植性 ###
#1. 通过uname命令获取当前的系统名称，之后再根据OS名称的不同，给PING变量赋值不同的ping命令的全称。
osname="$(uname -s)"
#2. 可以在case的条件中添加更多的操作系统名称。
case "$osname" in
"Linux")
    PING=/usr/sbin/ping ;;
"FreeBSD")
    PING=/sbin/ping ;;
"SunOS")
    PING=/usr/sbin/ping ;;
*)
    ;;
esac

# /> . ./test5.sh
# /> echo $PING
# /usr/sbin/ping