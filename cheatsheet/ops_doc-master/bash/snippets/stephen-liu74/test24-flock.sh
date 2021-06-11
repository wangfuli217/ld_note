#!/bin/sh
### 文件锁定 ###

#1. 这里需要先确认flock命令是否存在。
if [ -z $(which flock) ]; then
    echo "flock doesn't exist."
    exit 1
fi
#2. flock中的-e选项表示对该文件加排它锁，-w选项表示如果此时文件正在被加锁，当前的flock命令将等待20秒，如果能锁住该文件，就继续执行，否则退出该命令。
#3. 这里锁定的文件是/var/lock/lockfile1，-c选项表示，如果成功锁定，则指定其后用双引号括起的命令，如果是多个命令，可以用分号分隔。
#4. 可以在两个终端同时启动该脚本，然后观察脚本的输出，以及lockfile1文件的内容。
flock -e -w 20 /var/lock/lockfile1 -c "sleep 10;echo `date` | cat >> /var/lock/lockfile1"
if [ $? -ne 0 ]; then
    echo "Fail."
    exit 1
else
    echo "Success."
    exit 0
fi