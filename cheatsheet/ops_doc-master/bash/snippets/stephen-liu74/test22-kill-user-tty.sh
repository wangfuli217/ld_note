#!/bin/sh
user=""
tty=""
#1. 通过读取脚本的命令行选项获取要kill的用户或终端。-t后面的参数表示终端，-u后面的参数表示用户。这两个选项不能同时使用。
#2. case中的代码对脚本选项进行验证，一旦失败则退出脚本。
while getopts u:t: opt; do
  case $opt in
  u) 
    if [ "$tty" != "" ]; then
      echo "-u and -t can not be set at one time."
      exit 1
    fi
    user=$OPTARG
    ;;
  t)  
    if [ "$user" != "" ]; then
      echo "-u and -t can not be set at one time."
      exit 1
    fi
    tty=$OPTARG
    ;;
  ?) echo "Usage: $0 [-u user|-t tty]" >&2
    exit 1
  esac
done
#3. 如果当前选择的是基于终端kill，就用$tty来过滤ps命令的输出，否则就用$user来过滤ps命令的输出。
#4. awk命令将仅仅打印出pid字段，之后传递给sed命令，sed命令删除ps命令输出的头信息，仅保留后面的进程pids作为输出，并初始化pids数组。
if [ ! -z "$tty" ]; then
  pids=$(ps cu -t $tty | awk "{print \$2}" | sed '1d')
else
  pids=$(ps cu -U $user | awk "{print \$2}" | sed '1d')
fi
#5. 判断数组是否为空，空则表示没有符合要求的进程，直接退出脚本。
if [ -z "$pids" ]; then
  echo "No processes matches."
  exit 1
fi
#6. 遍历pids数组，逐个kill指定的进程。
for pid in $pids; do
  echo "Killing process[pid = $pid]... ..."
  kill -9 $pid
done
exit 0

# /> ./test23.sh -t pts/1
# Killing process[pid = 11875]... ...
# Killing process[pid = 11894]... ...
# /> ./test23.sh -u stephen
# Killing process[pid = 11910]... ...
# Killing process[pid = 11923]... ...