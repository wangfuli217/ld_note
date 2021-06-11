atd(){
Linux工作调度种类
    周期工作: crontab进行周期工作调度,其由cron服务支持
    单次工作: at进行单次工作调度,其是一次性的,由atd服务支持
}
at(){
2.1 atd服务的启动

单次工作调度：at需有atd服务支持,其启动方法如下

/etc/init.d/atd restart

# 开机启动atd方法,Ubuntu不支持chkconfig,其会默认启动atd
chkconfig atd on 

2.2 at用户限制

at进行工作调度,其是针对执行at命令的用户,我们并不想让所有用户都可以执行at(某些用户可能执行破坏系统的命令),所以我们会限制可at的用户.

at工作时会区查找/etc/at.allow和/etc/at.deny中限制的用户名单(通常at.allow与at.deny不同时存在)
1)/etc/at.allow

当其存在时,只有at.allow中的用户才能执行at
2)/etc/at.deny

当/etc/at.allow不存在,at会查找/etc/at.deny,这个文件内的用户都不能执行at
3)以上两个文件都不存在

只有root才能执行at
2.3 at进行工作调度

at命令格式如下：
at time: 进行工作调度安排,以[CTRL]+[d]结束工作安排,并返回一个工作编号
at -l: 显示当前存在的工作
at -d 工作编号:取消某个工作
at -c 工作编号:显示某个工作具体的执行过程
其中time的格式可以有HH:MM HH:MM YYYY-MM-DD now + num [minutes| hours | days | weeks]等

一个例子:
主机预计在5小时后关机

# at now + 5 hours    # 进入at shell的环境
at >  /bin/sync  #命令最好以绝对路径写,因为at shell的环境是其父进程的环境
                        #比如我直接新建一个文件,其会在执行at时的目录下新建
at > /bin/sync
at > /sbin/shutdown -h 0
at > <EOF>
job 5 at 2016-8-11 12:00
}

crontab(){
3.1 cron服务

Linux原本就有很多周期性例行工作,所以cron服务会默认启动
3.2 crontab用户限制

与at用户限制类似,crontab也会限制执行的用户,crontab会去查找/etc/cron.allow与/etc/cron.deny这两个文件,如果这两个文件不存在,我们可自行创建,文件写入的用户名会被限制(一般只保留cron.deny)
3.3 用户的周期工作调度

上面提到的是对执行crontab命令的用户进行限制,当一个用户执行crontab,crontab会在/var/spool/cron/crontabs(Ubuntu)创建一个同用户名的文件,来记录用户的周期工作.
CentOS会在/var/spool/cron目录下创建同用户名的记录文件.

我们可以通过crontab -e来打开这个文件

这个文件的一条工作记录格式如下

0   12   *   *    *   echo "Hello World!" > /tmp/test.log
#一条工作记录由5个字段组成,分别是
#分 时 日 月 周 命令
#时间参数可以用特殊值来表示如下:
*  :  代表任何时刻都接受
,   :  代表时刻A和时刻B都接受,比如 0 3,6 * * * 每天3点和6点
-   :  代表某个时间段,比如0,3-6 * * * 每天3点到6点
/n : 代表间隔n个时间单位,比如*/5 * * * * 每5分钟

如果要删除某个工作,用crontab -e打开文件后删除相应的工作记录即可.

如果root要为某用户安排工作,可以使用crontab -u username -e 或者直接打开用户的工作记录文件.
}

anacron(){
系统的周期工作记录文件在/etc/crontab中,我们打开/etc/crontab,可以看到如下类似的工作记录

 # m h dom mon dow user  command
25 6    * * *   root    cd / &&run-parts --report /etc/cron.daily

# 工作记录与用户的工作记录类似,多了一个user字段
# 上面的工作是每天6时25分钟时执行/etc/cron.daily目录下的所有可执行文件.
# run-parts是执行指定目录下的所有文件
# 执行者是root
# 当然我们可以不进行run-parts,直接执行某个命令.
# 也可以指定某个目录,放置要执行的script文件,再进行run-parts

3.5 唤醒停机期间的工作调度:anacron

当主机停机期间,安排好的工作并不能执行,哪该怎么办?
anacron会帮我们处理这个问题.其本质也是一个crontab
1)anacron工作原理

当我们每次处理crontab安排的工作时,都会先处理anacron安排的工作,anacron安排的工作很简单,就是记录这次处理crontab的时间(时间记录在目录/var/spool/anacront/下的子文件).当我们下次处理anacron工作时,会比较与前一个时间的差值,看它是否满足工作记录的要求,不满足就进行差值时间内之前的crontab工作.
2)anacron工作记录文件/etc/anacrontab

# These replace cron's entries
1       5       cron.daily      run-parts --report /etc/cron.daily

# 上面工作记录表示:此条工作名为cron.daily,其每天执行的(1),执行会延迟5分钟才开始
# 执行命令是 run-parts --report /etc/cron.daily

7       10      cron.weekly     run-parts --report /etc/cron.weekly

# 还有下面这条工作记录,应该看得懂吧

如果我们自己要安排一些周期工作,又担心系统停机后没处理到数据,那就可以在/etc/anacrotab中指定.anacron记录的时间在文件/var/spool/anacron/工作名中
}