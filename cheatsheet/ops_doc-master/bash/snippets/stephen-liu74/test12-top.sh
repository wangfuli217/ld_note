#!/bin/sh
#1. 将ps命令的title赋值给一个变量，这样在每次输出时，直接打印该变量即可。
header=$(ps aux | head -n 1)
#2. 这里是一个无限循环，等价于while true
#3. 每次循环先清屏，之后打印uptime命令的输出。
#4. 输出ps的title。
#5. 这里需要用sed命令删除ps的title行，以避免其参与sort命令的排序。
#6. sort先基于CPU%倒排，再基于owner排序，最后基于pid排序，最后再将结果输出给head命令，仅显示前20行的数据。
#7. 每次等待5秒后刷新一次。
while : ; do
  clear
  uptime
  echo "$header"
  ps aux | sed -e 1d | sort -k3nr -k1,1 -k2n | head -n 20
  sleep 5
done
   
# /> ./test12-top.sh
# 21:55:07 up 13:42,  2 users,  load average: 0.00, 0.00, 0.00
# USER       PID %CPU %MEM    VSZ   RSS   TTY      STAT START   TIME   COMMAND
# root      6408     2.0      0.0   4740   932   pts/2    R+    21:45     0:00   ps aux
# root      1755     0.2      2.0  96976 21260   ?        S      08:14     2:08   nautilus
# 68        1195     0.0      0.4   6940   4416    ?        Ss    08:13     0:00   hald
# postfix   1399    0.0      0.2  10312  2120    ?        S      08:13     0:00   qmgr -l -t fifo -u
# postfix   6021    0.0      0.2  10244  2080    ?        S      21:33     0:00   pickup -l -t fifo -u
# root         1       0.0      0.1   2828   1364    ?        Ss     08:12    0:02   /sbin/init