#!/bin/sh
### 判断参数是否为数字 ###
#1. $1是脚本的第一个参数，这里作为awk命令的第一个参数传入给awk命令
#2. 由于没有输入文件作为输入流，因此这里只是在BEGIN块中完成。
#3. 在awk中ARGV数组表示awk命令的参数数组，ARGV[0]表示命令本身，ARGV[1]表示第一个参数。
#4. match是awk的内置函数，返回值为匹配的正则表达式在字符串中(ARGV[1])的起始位置，没有找到返回0。
#5. 正则表达式的写法已经保证了匹配的字符串一定是十进制的正整数，如需要浮点数或负数，仅需修改正则即可。
#6. awk执行完成后将结果返回给isdigit变量，并作为其初始化值。
#7. isdigit=$( echo $1 | awk '{ if (match($1, "^[0-9]+$") != 0) print "true"; else print "false" }'  )
#8. 上面的写法也能实现该功能，但是由于有多个进程参与，因此效率低于下面的写法。
isdigit=$( awk 'BEGIN { if (match(ARGV[1],"^[0-9]+$") != 0) print "true"; else print "false" }' $1 )
if [[ $isdigit == "true" ]]; then
  echo "This is numeric variable."
  number=$1
else
  echo "This is not numeric variable."
  number=0
fi

# /> ./test3-awk-match-isdigit.sh 12
# This is numeric variable.
# /> ./test3-awk-match-isdigit.sh 12r
# This is not numeric variable.