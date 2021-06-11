#!/bin/sh
### 用脚本完成which命令的基本功能 ###

#1. 该函数用于判断参数1中的命令是否位于参数2所包含的目录列表中。需要说明的是，函数里面的$1和$2是指函数的参数，而不是脚本的参数，后面也是如此。
#2. cmd=$1和path=$2，将参数赋给有意义的变量名，是一个很好的习惯。
#3. 由于PATH环境变量中，目录之间的分隔符是冒号，因此这里需要临时将IFS设置为冒号，函数结束后再还原。
#4. 在for循环中，逐个变量目录列表中的目录，以判断该命令是否存在，且为可执行程序。
isInPath() {
  cmd=$1        path=$2      result=1
  oldIFS=$IFS   IFS=":"
  for dir in $path
  do
    if [ -x $dir/$cmd ]; then
     result=0
    fi
  done
  IFS=oldifs
  return $result
}
#5. 检查命令是否存在的主功能函数，先判断是否为绝对路径，即$var变量的第一个字符是否为/，如果是，再判断它是否有可执行权限。
#6. 如果不是绝对路径，通过isInPath函数判断是否该命令在PATH环境变量指定的目录中。
checkCommand() {
  var=$1
  if [ ! -z "$var" ]; then
    if [ "${var:0:1}" = "/" ]; then
      if [ ! -x $var ]; then
        return 1
      fi
    elif ! isInPath $var $PATH ; then
      return 2
    fi
  fi
}
#7. 脚本参数的合法性验证。
if [ $# -ne 1 ]; then
    echo "Usage: $0 command" >&2;
fi
#8. 根据返回值打印不同的信息。我们可以在这里根据我们的需求完成不同的工作。
checkCommand $1
case $? in
0) echo "$1 found in PATH." ;;
1) echo "$1 not found or not executable." ;;
2) echo "$1 not found in PATH." ;;
esac
exit 0
# CTRL+D
# /> ./test14-which.sh echo
# echo found in PATH.
# /> ./test14-which.sh MyTest
# MyTest not found in PATH.
# /> ./test14-which.sh /bin/MyTest
# /bin/MyTest not found or not executable.