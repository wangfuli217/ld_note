#!/bin/sh
### 在循环中使用管道的技巧 ###
#1. 先将ls -l命令的结果通过管道传给grep命令作为管道输入。
#2. grep命令过滤掉包含total的行，之后再通过管道将数据传给while循环。
#3. while read line命令从grep的输出中读取数据。注意，while是管道的最后一个命令，将在子Shell中运行。
ls -l | grep -v total | while read line
do
  #4. all变量是在while块内声明并赋值的。
  all="$all $line"
  echo "$line"
done
#5. 由于上面的all变量在while内声明并初始化，而while内的命令都是在子Shell中运行，包括all变量的赋值，因此该变量的值将不会传递到while块外，因为块外地命令是它的父Shell中执行。
echo "all = $all" 

# /> ./test8_1-while-pipe.sh
# -rw-r--r--.  1 root root 193 Nov 24 11:25 outfile
# -rwxr-xr-x. 1 root root 284 Nov 24 10:01 test7.sh
# -rwxr-xr-x. 1 root root 108 Nov 24 12:48 test8_1.sh
# all =