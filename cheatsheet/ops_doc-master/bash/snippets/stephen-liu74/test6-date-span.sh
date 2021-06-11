#!/bin/sh
### 获取当前时间距纪元时间(1970年1月1日)所经过的天数 ###
#1. 将date命令的执行结果(秒 分 小时 日 月 年)赋值给数组变量DATE。
declare -a DATE=( $(date +"%S %M %k %d %m %Y") )
#2. 为了提高效率，这个直接给出1970年1月1日到新纪元所流经的天数常量。
epoch_days=719591
#3. 从数组中提取各个时间部分值。
year=${DATE[5]}
month=${DATE[4]}
day=${DATE[3]}
hour=${DATE[2]}
minute=${DATE[1]}
second=${DATE[0]}
#4. 当月份值为1或2的时候，将月份变量的值加一，否则将月份值加13，年变量的值减一，这样做主要是因为后面的公式中取月平均天数时的需要。
if [ "$month" -gt 2 ]; then
    month=$((month+1))
else
    month=$((month+13))
    year=$((year-1))
fi
#5. year变量参与的运算是需要考虑闰年问题的，该问题可以自行去google。
#6. month变量参与的运算主要是考虑月平均天数。
#7. 计算结果为当前日期距新世纪所流经的天数。
today_days=$(((year*365)+(year/4)-(year/100)+(year/400)+(month*306001/10000)+day))
#8. 总天数减去纪元距离新世纪的天数即可得出我们需要的天数了。
days_since_epoch=$((today_days-epoch_days))
echo $days_since_epoch
seconds_since_epoch=$(((days_since_epoch*86400)+(hour*3600)+(minute*60)+second))
echo $seconds_since_epoch

# /> . ./test6.sh
# 15310
# 1322829080