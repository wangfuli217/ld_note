#!/bin/sh
### 在循环中使用管道的技巧 ###
#1. 将命令的结果传给一个变量    
OUTFILE=$( ls -l | grep -v total )
while read line
do
  all="$all $line"
  echo $line
done <<EOF
#2. 将该变量作为该循环的HERE文档输入。
$OUTFILE
EOF
#3. 在循环外部输出循环内声明并初始化的变量all的值。
echo "all = " $all

./test8_3-while-pipe.sh
-rwxr-xr-x. 1 root root 284 Nov 24 10:01 test7.sh
-rwxr-xr-x. 1 root root 135 Nov 24 13:16 test8_3.sh
all =  -rwxr-xr-x. 1 root root 284 Nov 24 10:01 test7.sh -rwxr-xr-x. 1 root root 135 Nov 24 13:16 test8_3.sh