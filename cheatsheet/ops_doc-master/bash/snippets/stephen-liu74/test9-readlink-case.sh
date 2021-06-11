#!/bin/sh
### 自链接脚本 ### 
#1. basename命令将剥离脚本的目录信息，只保留脚本名，从而确保在相对路径的模式下执行也没有任何差异。
#2. 通过sed命令过滤掉脚本的扩展名。
dowhat=$(basename $0 | sed 's/\.sh//')
#3. 这里的case语句只是为了演示方便，因此模拟了应用场景，在实际应用中，可以为不同的分支执行不同的操作，或将某些变量初始化为不同的值和状态。
case $dowhat in
test9)
  echo "I am test9.sh"
  ;;
test9_1)
  echo "I am test9_1.sh."
  ;;
test9_2)
  echo "I am test9_2.sh."
  ;;
*)
  echo "You are illegal link file."
  ;;
esac

# /> chmod a+x test9.sh
# /> ln -s test9.sh test9_1.sh
# /> ln -s test9.sh test9_2.sh
# /> ls -l
# lrwxrwxrwx. 1 root root   8 Nov 24 14:32 test9_1.sh -> test9.sh
# lrwxrwxrwx. 1 root root   8 Nov 24 14:32 test9_2.sh -> test9.sh
# -rwxr-xr-x. 1 root root 235 Nov 24 14:35 test9.sh

# /> ./test9.sh
# I am test9.sh.
# /> ./test9_1.sh
# I am test9_1.sh.
# /> ./test9_2.sh
# I am test9_2.sh.