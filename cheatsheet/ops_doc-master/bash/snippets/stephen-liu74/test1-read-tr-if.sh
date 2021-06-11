#!/bin/sh
####  将输入信息转换为大写字符后再进行条件判断 ### 

echo -n "Please let me know your name. "
read name
#将变量name的值通过管道输出到tr命令，再由tr命令进行大小写转换后重新赋值给name变量。
name=$(echo $name | tr [a-z] [A-Z])
if [[ $name == "STEPHEN" ]]; then
  echo "Hello, Stephen."
else
  echo "You are not Stephen."
fi

# 我们在读取用户的正常输入后，很有可能会将这些输入信息用于条件判断，那么在进行比较时，我们将不得不考虑这些信息的大小写匹配问题。
# ./test1-read-tr-if.sh
#       Please let me know your name. stephen
#       Hello, Stephen.


