cat - <<'EOF'
date -d '1970-01-01 UTC 1312438633.724 seconds' +"%Y-%m-%d %T"  #时间戳转日期
echo `date -d now +%Y%m%d`                                      #显示现在日期
echo `date -d yesterday +%Y%m%d`                                #显示昨天日期
date +%Y%m%d -date="-1 day"                                     #加减时间
date +%Y%m%d%H -date="-1 hour"                                  #加减时间

datetime=$(date -u '+%Y%m%d %H:%M:%S') # UTC time 以UTC形式显示日期和时间
EOF

date_i_man(){ cat - <<'EOF'
  date [OPTIONS] [+FMT] [TIME]
  [-s] TIME       Set time to TIME
  -u              Work in UTC (donot convert to local time)
  -R              Output RFC-822 compliant date string
  -I[SPEC]        Output ISO-8601 compliant date string
                  SPEC='date' (default) for date only,
                  'hours', 'minutes', or 'seconds' for date and
                  time to the indicated precision
  -r FILE         Display last modification time of FILE
  -d TIME         Display TIME, not 'now'
  -D FMT          Use FMT for -d TIME conversion
  
Recognized TIME formats:
   hh:mm[:ss]
   [YYYY.]MM.DD-hh:mm[:ss]
   YYYY-MM-DD hh:mm[:ss]
   [[[[[YY]YY]MM]DD]hh]mm[.ss]
   
-f DATEFILE
--file=DATEFILE 
可以一次处理多个 DATESTR 格式的时间
EOF
}

date_i_format(){ cat - <<'EOF'
自定义格式化显示日期
%a : 星期几 (Sun..Sat)                                                      Mon                                 %a 周
%A : 星期几 (Sunday..Saturday)                                              Monday                              %A 周
%b : 月份 (Jan..Dec)                                                        May                                 %b 月
%B : 月份 (January..December)                                               May                                 %B 月
%c : 直接显示日期与时间                                                     Mon 06 May 2019 03:19:33 PM CST     %c 日期时间
%C : year/100                                                               20                                  %C
%d : 日 (01..31)                                                            06                                  %d 日
%D : 直接显示日期 (mm/dd/yy)                                                05/06/19                            %D 日期
%e : 月内第几天                                          %_d                 6                                  %e 日
%E : 不存在                                                                                                     %E
%F :                                                     %Y-%m-%d           2019-05-06                          %F 日期
%g : 年(00-99)                                                              19                                  %g 年
%G : 年(0000-9999)                                                          2019                                %G 年
%h : 同 %b                                                                  May                                 %h 周
%H : 小时(00..23)                                         hour (00...23)    15                                  %H 时
%I : 小时(01..12)                                         hour (01...12)    03                                  %I 时
%k : 小时(0..23)                                          hour (0...23).    15                                  %k 时
%l : 小时(1..12)                                          hour (1...12).    3                                   %l 时
%j : 一年中的第几天 (001..366)                                              126                                 %j 日
%m : 月份 (01..12)                                                          05                                  %m 月
%M : 分钟(00..59)                                         minute (00...59)  16                                  %M 分
%n : 下一行                                                                                                     %n 
%p : 显示本地 AM 或 PM                                                      AM | PM                             %p 时段
%P : 显示本地 am 或 pm                                                      am | pm                             %P 时段
%r : 直接显示时间 (12 小时制，格式为 hh:mm:ss [AP]M)                        11:11:04 PM                         %r 时间
%R :                                                     %H:%M              16:19                               %R 时间
%s : 从 1970 年 1 月 1 日 00:00:00 UTC 到目前为止的秒数                     1557126970                          %s 秒
%S : 秒(00..61)                                                             03                                  %S 秒
%t : 跳格                                                                                                       %t 
%T : 直接显示时间 (24 小时制)                                               15:18:20                            %T 时间
%u : 一周中第几天 (1-7)                                                     1                                   %u 周
%U : 一年中的第几周 (00..53) (以 Sunday 为一周的第一天的情形)               18                                  %U 周
%w : 一周中的第几天 (0..6)                                                  1                                   %w 周
%W : 一年中的第几周 (00..53) (以 Monday 为一周的第一天的情形)               18                                  %W 周
%y : 年份的最后两位数字 (00.99)                                             19                                  %y 年
%Y : 完整年份 (0000..9999)                                                  2019                                %Y 年
%x : 直接显示日期 (mm/dd/yy)                                                05/06/2019                          %x 日期
%X : 相当于 %H:%M:%S                                                        03:18:40 PM                         %X 时间
%z : 时区                                                                   +0800                               %z 时区
%Z : 显示时区                                                               CST                                 %Z 时区
%N ：nanoseconds (000000000...999999999).  This is a GNU extension.         227196560                           
                                  second | minute  | Hour     | Day | Month     | Year    | am|pm | zone | misc     |  Week
Time %[HIklMNpPrRsSTXzZ]          %sS    | %M      | %H%I%k%l |     |           |         | %pP   | %zZ  | %rR %T%X | 
Date %[aAbBcCdDeFgGhjmuUVwWxyY]          |         |          | dej | %bB%d%m   | %gGyY   |       |      | %D%F%x   | %a%A%u%U%w%W
pad  %n%t
日期时间  %c
日期     %D%F%x
时间     %r%R%T%X
%%       %
EOF
}

date_t_format(){ cat - <<'EOF'
date # 等同于 date '+%a %b %e %H:%M:%S %Z %Y'
  星期日[SUN] 星期一[MON] 星期二[TUE] 星期三[WED] 星期四[THU] 星期五[FRI] 星期六[SAT]
  一月[JAN] 二月[FEB] 三月[MAR] 四月[APR] 五月[MAY] 六月[JUN] 七月[JUL] 八月[AUG] 九月[SEP] 十月[OCT] 十一月[NOV] 十二月[DEC]
[显示时间]
  date +%Y-%m-%d -d '20110902' # 2011-09-02
  date +%Y-%m-%d_%X            # 2019-05-06_04:49:23 PM
  date +%N                     # 522155341
  date +'%Y-%m-%d'             # 2019-05-06
  date '+%Y-%m-%d %H:%M:%S'    # 2019-05-06 16:49:55
  date '+%Y/%m/%d %H:%M:%S'    # 2019/05/06 16:50:11
  date '+%Y-%m-01 00:00:01'    # 2019-05-01 00:00:01
  date '+%F'                   # 2019-05-06
  date '+%Y-%m-%d-%H-%M'       # 2019-05-06-16-50
  date +%a                     # Mon
  date +%A                     # Monday
  date '+%B %d'                # May 06
  date +%m%d%H%M%Y.%S          # 050616582019.59
EOF
}

date_t_description(){ cat - <<'EOF'
1.2 使用 --date=DATESTR 指定的时间输出，可以包含month names, time zones, 'am' and 'pm', 和yesterday, 其他时刻时间格式化
  date # Mon May  6 16:56:22 CST 2019
  date -d next-day +%Y%m%d     # 20190507
  date -d last-day +%Y%m%d     # 20190507
  date -d yesterday +%Y%m%d    # 20190505
  date -d tomorrow +%Y%m%d     # 20190507
  date -d last-month +%Y%m     # 201904
  date -d next-month +%Y%m     # 201906
  date -d next-year +%Y        # 2020
  date --date='2 days ago'     # Sat May  4 16:58:16 CST 2019
  date --date='3 months 1 day' # Wed Aug  7 16:58:30 CST 2019
  date --date='25 Dec' +%j     # 359
  date --date "Wed mar 15 08:09:16 EDT 2018" +%s # 将日期转换成纪元时
  date --date "Sept 3 2018" +%A                  # 找出指定日期是星期几
  date -d '2 weeks'
  date -d yesterday
  date -d 'next monday'                # 下周一的日期
  date -d 'last-month -1 week'         # 上个月的一周前
  date -d 'jun 30 -2 weeks'            # 相对于6月30号的前两周
  date -d 'jun 30 -2 weeks' +%Y_%m_%d  # 相对于6月30号的前两周
  date -d "7 days ago" +%Y%m%d         # 7天前日期
  date -d "5 minute ago" +%H:%M        # 5分钟前时间
  date -d "1 month ago" +%Y%m%d        # 一个月前
  date -d '1 days' +%Y-%m-%d           # 一天后
  date -d '1 hours' +%H:%M:%S          # 一小时后
  date -d "2012-08-13 14:00:23" +%s    # 换算成秒计算(1970年至今的秒数)
  date -d "@1363867952" +%Y-%m-%d-%T   # 将时间戳换算成日期
  date -d "1970-01-01 UTC 1363867952 seconds" +%Y-%m-%d-%T  # 将时间戳换算成日期
  date -d "`awk -F. '{print $1}' /proc/uptime` second ago" +"%Y-%m-%d %H:%M:%S"    # 格式化系统启动时间(多少秒前)
# at 10:40 10/1/2010
EOF
}

date_t_datestr(){  cat - <<'EOF'
date +%FT%T.%N # iso time 
date +%Y-%m-%dT%H:%M:%S # iso time 
date --date="6 months ago" # past time 
date --date="6 months" # future time 
date --date="2001-09-09 03:46:40+02:00" +%s # convert timestamp 
date --date="Friday" # today future midnight 
date --date="Monday" # today future midnight 
date --date="Saturday" # today future midnight 
date --date="Sunday" # today future midnight 
date --date="Thursday" # today future midnight 
date --date="Tuesday" # today future midnight 
date --date="Wednesday" # today future midnight 
date --date="now" # time 
date --date="yesterday" # time 
date --rfc-3339=ns --date="2001-02-03T04:05:06.7 + 1 year 2 months 3 days 4 hours 5 minutes 6.7 seconds" # dst time iso 
date --rfc-3339=seconds --date="@1000000000" # convert timestamp 
EOF
}

date_t_set(){ cat - <<'EOF'
1.3 设置时间 --set DATESTR 时间格式和 -d 格式相同
  date --set='+2 minutes'  # 设置时间
  date -s "2 OCT 2006 18:00:00"
  date --set="2 OCT 2006 18:00:00"
  date +%Y%m%d -s "20081128"
  date +%T -s "10:13:13"
  date +%T%p -s "6:10:30AM"
  
  # 日期偏移量
  # 昨天 (前一天)
  date --date='1 days ago' "+%Y-%m-%d"
  date -d '1 days ago' "+%Y-%m-%d"
  date -d yesterday "+%Y-%m-%d"
  # 明天 (後一天)
  date --date='1 days' "+%Y-%m-%d"
  date -d '1 days' "+%Y-%m-%d"
  date -d tomorrow "+%Y-%m-%d"
  date -d fri # What date is it this friday. See also day
   
   [ $(date -d '12:00 today +1 day' +%d) = '01' ] || exit # exit a script unless it's the last day of the month
   
  # day
  date -d '-1 day' +'%Y-%m-%d 00:00:01'
  date -d '+5 day' +'%Y-%m-%d 00:00:01'
  
  # month
  date -d '+2 month' +'%Y-%m-%d 00:00:01'
  date -d '-1 month' +'%Y-%m-%d 00:00:01'
  
  # year
  date -d '-5 year' +'%Y-%m-%d'
  date -d '+1 year' +'%Y-%m-%d'
  
  # 时间偏移
  # 1小時前
  date --date='1 hours ago' "+%Y-%m-%d %H:%M:%S"
  # 1小時後
  date --date='1 hours' "+%Y-%m-%d %H:%M:%S"
  # 1分鐘前
  date --date='1 minutes ago' "+%Y-%m-%d %H:%M:%S"
  # 1分鐘後
  date --date='1 minutes' "+%Y-%m-%d %H:%M:%S"
  # 1秒前
  date --date='1 seconds ago' "+%Y-%m-%d %H:%M:%S"
  # 1秒後
  date --date='1 seconds' "+%Y-%m-%d %H:%M:%S"
  
  # 时间戳
  date +%s # 计算当天的时间戳
  date -d "2015-08-05 09:45:44" +%s # 计算指定日期的时间戳
  date -d @1438739144 # 时间戳转换成时间
  date -d @1440661395 +%Y-%m-%d-%H-%M # 格式输出
  
  date -s 20091112                     # 设日期
  date -s 18:30:50                     # 设时间
  
  date -s "21 June 2019 11:02:55"  # 设置日期和时间
  date -s 06/09/2004  # 修改日期(按月日年格式)
  date -s 13:56:00    # 修改时间(按时分秒格式)
EOF
}

date_i_hwclock(){ cat - <<'EOF'
Usage: hwclock [-r|--show] [-s|--hctosys] [-w|--systohc] [-l|--localtime] [-u|--utc] [-f FILE]
Query and set hardware clock (RTC)
Options:
  -r      Show hardware clock time
  -s      Set system time from hardware clock
  -w      Set hardware clock to system time
  -u      Hardware clock is in UTC
  -l      Hardware clock is in local time
  -f FILE Use specified device (e.g. /dev/rtc2)
  
clock -r 查询BIOS时间 
clock -w 把修改后的时间写回BIOS

        hwclock -w 把系统时间写到硬件时间
        hwclock -hctosys 把硬件时间写到系统时间
        hwclock -s -date="09/09/14 11:18"
        /sbin/hwclock -w            # 时间保存到硬件
        hwclock --set --date='10/11/2016 17:07:00' #硬件时间修改
        hwclock --hctosys           # 系统时间与硬件时间同步

例1：查看硬件时间 
# hwclock --show 
# clock   --show 

例2：设置硬件时间 
# hwclock --set  --date="07/07/06 10:19"   (月/日/年  时:分:秒) 
# clock   --set   --date="07/07/06 10:19"  (月/日/年  时:分:秒) 

例3：硬件时间和系统时间的同步 
按照前面的说法，重新启动系统，硬件时间会读取系统时间，实现同步，但是在不重新启动的时候，需
要用hwclock或clock命令实现同步。 
硬件时钟与系统时钟同步： 
# hwclock --hctosys (hc 代表硬件时间，sys 代表系统时间) 
# clock   --hctosys  

例4：系统时钟和硬件时钟同步： 
# hwclock --systohc   
# clock   --systohc  

例5：强制将系统时间写入 CMOS，使之永久生效，避免系统重启后恢复成原时间 
# clock  -w 
# hwclock -w
EOF
}

date_i_tzselect(){ cat - <<'EOF'
时区的设置 
# tzselect  
# vi /etc/sysconfig/clock   
Z/Shanghai (查/usr/share/zoneinfo下面的文件)  
UTC=false  
ARC=false 
# rm /etc/localtime  
# ln  - sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime  
EOF
}


date_i_ntpdate(){ cat - <<'EOF'
/usr/sbin/ntpdate -s time-b.nist.gov # 使用ntpdate来设置日期和时间 

例1：同步时间 
# ntpdate 210.72.145.44     (210.72.145.44 是中国国家授时中心的官方服务器)
例2：定时同步时间 
# crontab -e 添加脚本例子如下： 
*/20 * * * *       /usr/sbin/ntpdate  210.72.145.44            // 每20分钟执行一次 
30 5 * * *        /usr/sbin/ntpdate 210.72.145.44            // 每天早晨 5 点半执行 
*  前面五个*号代表五个数字，数字的取值范围和含义如下：分钟(0 -59)  小時(0 -23)  日 期(1- 31) 
月份(1 -12)  星期(0 -6)//0 代表星期天设定完毕后，可使用# crontab -l  查看上面的设定。
EOF
}

date_i_ntp(){ cat - <<'EOF'
Linux提供了ntpd和ntpdate两种方式来实现时间同步，但它们在同步原理上则有着本质的区别：
ntpd在实际同步时间时是一点点的校准时间的，也可以理解为ntpd是平滑同步；
而ntpdate不会考虑其他程序是否会阵痛，就立即同步。因此在生产环境中慎用ntpdate。
1. 这样做不安全。ntpdate的设置依赖于ntp服务器的安全性，攻击者可以利用一些软件设计上的缺陷，拿下ntp服务器并令与其同步的服务器执行某些消耗性的任务。
2. 这样做不精确。一旦ntp服务器宕机，跟随它的服务器也就会无法同步时间。与此不同，ntpd不仅能够校准计算机的时间，而且能够校准计算机的时钟。
3. 这样做不够优雅。由于是跳变，而不是使时间变快或变慢，依赖时序的程序会出错

唯一一个可以令时间发生跳变的点，是计算机刚刚启动，但还没有启动很多服务的那个时候。
其余的时候，理想的做法是使用ntpd来校准时钟，而不是调整计算机时钟上的时间。

NTPD 在和时间服务器的同步过程中，会把 BIOS 计时器的振荡频率偏差，或者说 Local Clock 的自然漂移
(drift)记录下来。这样即使网络有问题，本机仍然能维持一个相当精确的走时。
EOF
}

date_i_UTC(){ cat - <<'EOF'
Local vs.UTC
首先，一个重要的问题是你使用UTC还是 local time 。
    UTC(Universal Time Coordinated) =GMT(Greenwich Mean Time), 中国是GMT+8 。传统的POSIX计算机(Solaris, bsd, unix)使用UTC格式
    Local time 就是你手表上的时间。Windows 使用的是 local time
Linux 可以处理UTC时间和 local time 。
到底是使用UTC还是 local time 可以这样来确定: 如果机器上同时安装有 Linux 和 Windows, 建议使用local time; 如果机器上只安装有Linux, 则建议使用UTC。
确定后编辑/etc/sysconfig/clock,UTC=0 代表 local time;UTC=1 代表UTC(GMT) 。

确定 timezone
    运行tzselect，回答问题后会告诉你时区的名称，比如 "Asia/Shanghai"，把他记下来(后面我用$timezone代替)。
设定 timezone
    # cp /usr/share/zoneinfo/$timezone /etc/localtime
EOF
}


