#!/bin/sh

# TODO: 注意根据datetime.sh的实际位置更改
. /opt/shtools/commons/datetime.sh

echo "当前时间（date）：$(date)"
echo "昨天（yesterday）：$(yesterday)"
echo "今天（today）：$(today)"
echo "现在（now）：$(now)"
echo "现在（curtime）：$(curtime)"
echo "上月（last_month）：$(last_month)"
echo "上月（last_month_packed）：$(last_month_packed)"
echo "上月第一天（first_date_of_last_month）：$(first_date_of_last_month)"
echo "上月最后一天（last_date_of_last_month）：$(last_date_of_last_month)"
echo "今天星期几（day_of_week）：$(day_of_week)"
echo "上个小时（last_hour）：$(last_hour)"
echo "当前的小时（the_hour）：$(the_hour)"
echo "当前的分钟（the_minute）：$(the_minute)"
echo "当前的秒钟（the_second）：$(the_second)"
echo "当前的年份（the_year）：$(the_year)"
echo "当前的月份（the_month）：$(the_month)"
echo "当前的日期（the_date）：$(the_date)"
echo "前天（days_ago 2）：$(days_ago 2)"
echo "明天（days_ago -1）：$(days_ago -1)"
echo "后天（days_ago -2）：$(days_ago -2)"
echo "十天前的日期（days_ago 10）：$(days_ago 10)"
echo "中文的日期星期（chinese_date_and_week）：$(chinese_date_and_week)"
echo "随机数字（rand_digit）：$(rand_digit)"
echo "随机数字（rand_digit）：$(rand_digit)"
echo "自1970年来的秒数（seconds_of_date）：$(seconds_of_date)"
echo "自1970年来的秒数（seconds_of_date 2010-02-27）：$(seconds_of_date 2010-02-27)"
echo "自1970年来的秒数（seconds_of_date 2010-02-27 15:53:21）：$(seconds_of_date 2010-02-27 15:53:21)"
echo "自1970年来的秒数对应的日期（date_of_seconds 1267200000）：$(date_of_seconds 1267200000)"
echo "自1970年来的秒数对应的日期时间（datetime_of_seconds 1267257201）：$(datetime_of_seconds 1267257201)"

if leap_year 2010; then
	echo "2010年是闰年";
fi
if leap_year 2008; then
	echo "2008年是闰年";
fi
if validity_of_date 2007 02 03; then
	echo "2007 02 03 日期合法"
fi
if validity_of_date 2007 02 28; then
	echo "2007 02 28 日期合法"
fi
if validity_of_date 2007 02 29; then
	echo "2007 02 29 日期合法"
fi
if validity_of_date 2007 03 00; then
	echo "2007 03 00 日期合法"
fi

echo "2010年2月的天数（days_of_month 2 2010）：$(days_of_month 2 2010)"
echo "2008年2月的天数（days_of_month 2 2008）：$(days_of_month 2 2008)"

