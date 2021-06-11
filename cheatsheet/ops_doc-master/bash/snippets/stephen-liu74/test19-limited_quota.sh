#!/bin/sh
### 监控指定目录下磁盘使用空间过大的用户 ###
#1. 该脚本仅用于演示一种处理技巧，其中很多阈值都是可以通过脚本参来初始化的，如limited_qutoa和dirs等变量。
limited_quota=200
dirs="/home /usr /var"
#2. 以冒号作为分隔符，截取passwd文件的第一和第三字段，然后将输出传递给awk命令。
#3. awk中的$2表示的是uid，其中1-99是系统保留用户，>=100的uid才是我们自己创建的用户，awk通过print输出所有的用户名给for循环。
#4. 注意echo命令的输出是由八个单词构成，同时由于-n选项，echo命令并不输出换行符。
#5. 之所以使用find命令，也是为了考虑以点(DOT)开头的隐藏文件。这里的find将在指定目录列表内，搜索指定用户的，类型为普通文件的文件。并通过-ls选项输出找到文件的详细信息。其中输出的详细信息的第七列为文件大小列。
#6. 通过awk命令累加find输出的第七列，最后再在自己的END块中将sum的值用MB计算并输出。该命令的输出将会与上面echo命令的输出合并作为for循环的输出传递给后面的awk命令。这里需要指出的是，该awk的输出就是后面awk命令的$9，因为echo仅仅输出的8个单词。
#7. 从for循环管道获取数据的awk命令，由于awk命令执行的动作是用双引号括起的，所以表示域字段的变量的前缀$符号，需要用\进行转义。变量$limited_quota变量将会自动完成命令替换，从而构成该awk命令的最终动作参数。
for name in $(cut -d: -f1,3 /etc/passwd | awk -F: '$2 > 99 {print $1}'); do
  echo -n "User $name exceeds disk quota. Disk Usage is: "
  find $dirs -user $name -type f -ls |\
    awk '{ sum += $7 } END { print sum / (1024*1024) " MB" }'
done | awk "\$9 > $limited_quota { print \$0 }"

# ./test20.sh