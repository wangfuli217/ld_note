#!/bin/sh
### 为调试信息设置输出级别 ###

if [[ "$#" -eq 0 ]]; then
  echo "Usage: $0 -d debug_level" >&2 
  exit 1
fi

#1. 读取脚本的命令行选项参数，并将选项赋值给变量argument。
while getopts d: argument ; do
  #2. 只有到选项为d(-d)时有效，同时将-d后面的参数($OPTARG)赋值给变量debug，表示当前脚本的调试级别。
  case "${argument}" in
  d  ) debug_level="$OPTARG"
    ;;
  \? ) echo "Usage: $0 -d debug_level" >&2
    exit 1
    ;;
  esac
done

#3. 如果debug此时的值为空或者不是0-9之间的数字，给debug变量赋缺省值0.
if [[ -z $debug_level ||  $debug_level != [0-9] ]]; then
  debug_level=0
fi

echo "The current debug_level level is $debug_level."
echo -n "Tell me your name."
read name

name=$( echo $name | tr [a-z] [A-Z] )
if [ "$name" = "STEPHEN" ];then
  #4. 根据当前脚本的调试级别判断是否输出其后的调试信息，此时当debug_level > 0时输出该调试信息。
  [ "$debug_level" -gt 0 ] && echo "This is stephen."
  #do something you want here.
elif [ "$name" = "ANN" ]; then
  #5. 当debug_level > 1时输出该调试信息。
  [ "$debug_level" -gt 1 ] && echo "This is ann."
  #do something you want here.
else
  #6. 当debug_level > 2时输出该调试信息。
  [ "$debug_level" -gt 2 ] && echo "This is others."
  #do any other else.
fi

# /> ./test2-getopts-ebug_level.sh
# Usage: ./test2.sh -d debug_level
# /> ./test2-getopts-ebug_level.sh -d 1
# The current debug level is 1.
# Tell me your name. ann
# /> ./test2-getopts-ebug_level.sh -d 2
# The current debug level is 2.
# Tell me your name. ann
# This is ann.