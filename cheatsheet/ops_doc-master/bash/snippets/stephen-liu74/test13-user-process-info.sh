#!/bin/sh
### 格式化输出指定用户的当前运行进程 ###
#1. 循环读取脚本参数，构造egrep可以识别的用户列表变量(基于grep的扩展正则表达式)。
#2. userlist变量尚未赋值，则直接使用第一个参数为它赋值。
#3. 如果已经赋值，且脚本参数中存在多个用户，这里需要在每个用户名之间加一个竖线，在egrep中，竖线是分割的元素之间是或的关系。
#4. shift命令向左移动一个脚本的位置参数，这样可以使循环中始终操作第一个参数。
while [ "$#" -gt 0 ]; do
  if [ -z "$userlist" ]; then
    userlist="$1"
  else
    userlist="$userlist|$1"
  fi
   shift
done
#5. 如果没有用户列表，则搜索所有用户的进程。
#6. "^ *($userlist) ": 下面的调用方式，该正则的展开形式为"^ *(root|avahi|postfix|rpc|dbus) "。其含义为，以0个或多个空格开头，之后将是root、avahi、postfix、rpc或dbus之中的任何一个字符串，后面再跟随一个空格。
if [ -z "$userlist" ]; then
  userlist="."
else
  userlist="^ *($userlist) "
fi
#7. ps命令输出所有进程的user和命令信息，将结果传递给sed命令，sed将删除ps的title部分。
#8. egrep过滤所有进程记录中，包含指定用户列表的进程记录，再将过滤后的结果传递给sort命令。
#9. sort命令中的-b选项将忽略前置空格，并以user，再以进程名排序，将结果传递个uniq命令。
#10.uniq命令将合并重复记录，-c选项将会使每条记录前加重复的行数。
#11.第二个sort将再做一次排序，先以user，再以重复计数由大到小，最后以进程名排序。将结果传给awk命令。
#12.awk命令将数据进行格式化，并删除重复的user。
ps -eo user,comm | sed -e 1d | egrep "$userlist" |
    sort -b -k1,1 -k2,2 | uniq -c | sort -b -k2,2 -k1nr,1 -k3,3 |
        awk ' { user = (lastuser == $2) ? " " : $2;
          lastuser = $2;
          printf("%-15s\t%2d\t%s\n",user,$1,$3)
        }'

# /> ./test13-user-process-info.sh root avahi postfix rpc dbus
# avahi             2      avahi-daemon
# dbus             1      dbus-daemon
# postfix          1      pickup
#                     1      qmgr
# root              5      mingetty
#                     3      udevd
#                     2      sort
#                     2      sshd
# ... ...
# rpc               1      rpcbind