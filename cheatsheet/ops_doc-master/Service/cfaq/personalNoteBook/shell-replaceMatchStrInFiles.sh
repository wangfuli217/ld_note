#!/bin/bash
#set -x
set -e
for i in $(grep -l "PsCommon/ActiveCellSRS" *.rtm)
  do
    sed -i "/require.*ActiveCellSRS/c require PsCommon/ActiveCell" $i
    sed -i "/require.*ActiveCell/a require PsCommon/ConfigCellSRS" $i 
  done

echo "done"



////////////////////////
这个脚本的功能是：在当前目录下所有的rtm文件中查找包含内容 PsCommon/ActiveCellSRS 的文件，并修改这些文件的内容：
1）替换"require  PsCommon/ActiveCellSRS" 为 "require PsCommon/ActiveCell"
2) 在替换行后面追加一行 "require PsCommon/ConfigCellSRS"


在bash的脚本中，你可以使用 set -x 来debug输出。使用 set -e 来当有错误发生的时候abort执行。考虑使用 set -o pipefail 来限制错误。
在bash 脚本中，subshells (写在圆括号里的) 是一个子命令。一个常用的例子是临时地到另一个目录中执行命令，执行完后回到当前目录。
检查一个变量是否存在: ${name:?errormessage}，比如一个bash的脚本需要一个参数，也许就是这样一个表达式： input_file=${1:?usage: $0 input_file}
