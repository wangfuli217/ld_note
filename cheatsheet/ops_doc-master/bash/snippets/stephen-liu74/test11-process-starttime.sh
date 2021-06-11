#!/bin/sh
### 获取进程的运行时长(单位: 分钟) ###
# ps命令的etime值将给出每个进程的运行时长，其格式主要为以下三种：
# 1. minutes:seconds，如20:30
# 2. hours:minutes:seconds，如1:20:30
# 3. days-hours:minute:seconds，如2-18:20:30
# 该脚本将会同时处理这三种格式的时间信息，并最终转换为进程所流经的分钟数。


#1. 通过ps命令获取所有进程的pid、etime和comm数据。
#2. 再通过grep命令过滤，只获取init进程的数据记录，这里我们可以根据需要替换为自己想要监控的进程名。
#3. 输出结果通常为：1 09:42:09 init
pid_string=$(ps -eo pid,etime,comm | grep "init" | grep -v grep)
#3. 从这一条记录信息中抽取出etime数据，即第二列的值09:42:09，并赋值给exec_time变量。
exec_time=$(echo $pid_string | awk '{print $2}')
#4. 获取exec_time变量的时间组成部分的数量，这里是3个部分，即时:分:秒，是上述格式中的第二种。
time_field_count=$(echo $exec_time | awk -F: '{print NF}')
#5. 从exec_time变量中直接提取分钟数，即倒数第二列的数据(42)。
count_of_minutes=$(echo $exec_time | awk -F: '{print $(NF-1)}')

#6. 判断当前exec_time变量存储的时间数据是属于以上哪种格式。
#7. 如果是第一种，那么天数和小时数均为0。
#8. 如果是后两种之一，则需要继续判断到底是第一种还是第二种，如果是第二种，其小时部分将不存在横线(-)分隔符分隔天数和小时数，否则需要将这两个时间字段继续拆分，以获取具体的天数和小时数。对于第二种，天数为0.
if [ $time_field_count -lt 3 ]; then
  count_of_hours=0
  count_of_days=0
else
  count_of_hours=$(echo $exec_time | awk -F: '{print $(NF-2)}')
  fields=$(echo $count_of_hours | awk -F- '{print NF}')
  if [ $fields -ne 1 ]; then
    count_of_days=$(echo $count_of_hours | awk -F- '{print $1}')
    count_of_hours=$(echo $count_of_hours | awk -F- '{print $2}')
  else
    count_of_days=0
  fi
fi
#9. 通过之前代码获取的各个字段值，计算出该进程实际所流经的分钟数。
#10. bc命令是计算器命令，可以将echo输出的数学表达式计算为最终的数字值。
elapsed_minutes=$(echo "$count_of_days*1440+$count_of_hours*60+$count_of_minutes" | bc)
echo "The elapsed minutes of init process is" $elapsed_minutes "minutes."


# /> ./test11-process-starttime.sh
# The elapsed minutes of init process is 577 minutes.