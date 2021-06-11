#!/bin/sh
### 在循环中使用管道的技巧 ###
#1. 这里我们已经将命令的结果重定向到一个临时文件中。
ls -l | grep -v total > outfile
while read line
do
  #2. all变量是在while块内声明并赋值的。
  all="$all $line"
  echo "$line"
  #3. 通过重定向输入的方式，将临时文件中的内容传递给while循环。
done < outfile
#4. 删除该临时文件。
rm -f outfile
#5. 在while块内声明和赋值的all变量，其值在循环外部仍然有效。
echo "all = $all" 

# /> ./test8_2-while-pipe.sh
# -rw-r--r--.  1 root root   0 Nov 24 12:58 outfile
# -rwxr-xr-x. 1 root root 284 Nov 24 10:01 test7.sh
# -rwxr-xr-x. 1 root root 140 Nov 24 12:58 test8_2.sh
# all =  -rwxr-xr-x. 1 root root 284 Nov 24 10:01 test7.sh -rwxr-xr-x. 1 root root 135 Nov 24 13:16 test8_2.sh