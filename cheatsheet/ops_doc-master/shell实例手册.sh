http://scc.qibebt.cas.cn/docs/  # 中国科技大学青能
http://codeshold.me/2017/01/network_tools_knowledge.html # shell 还好
http://codeshold.me/2017/02/linux_unix_help_commands.html

https://github.com/donnemartin # 拓展 涉及思想指导
https://sdn.feisky.xyz/#%E5%9C%A8%E7%BA%BF%E9%98%85%E8%AF%BB # SDN Book 网络基础
https://github.com/superbool/pi-document # 树莓派文档
https://github.com/DanielXH/linux-translate-tool # 翻译工具
https://github.com/ckwongloy/ckwongloy.github.io/wiki/%E8%BD%AF%E4%BB%B6 # 计算机工具
### shell实例手册
https://www.debian.org/doc/manuals/debian-reference/index.zh-cn.html # debian 参考手册
http://wiki.ubuntu.com.cn/%E5%88%86%E7%B1%BB:%E6%9C%8D%E5%8A%A1%E5%99%A8 # Ubuntu 服务配置
http://wiki.ubuntu.com.cn/UbuntuManual # ubuntu参考手册
https://cloud.tencent.com/developer/column/1819    # 运维
http://www.cnblogs.com/Felix-Wong/p/6158195.html   # 杂书
http://siberiawolf.com/free_programming/index.html # 杂书
https://www.jiumodiary.com/                      # download书
http://igit.linuxtoy.org/contents.html           # GIT step step
https://github.com/audreyr/cookiecutter # 一系列模板生成 工具
https://github.com/learnbyexample      # shell实例
http://www.cnblogs.com/stephen-liu74/category/326653.html # shell实例 分类清楚，实例实用

https://www.gnu.org/software/bash/manual/bashref.html  # manual
http://www.tldp.org/LDP/abs/html/index.html            # abs
http://www.cnblogs.com/f-ck-need-u/p/7048359.html      # Linux回炉复习系列文章总目录
http://linuxtools-rst.readthedocs.io/zh_CN/latest/advance/index.html # 工具

dwm - dynamic window manager #http://dwm.suckless.org/
dwm.vim #https://github.com/spolu/dwm.vim
    
http://www.kuqin.com/aixcmds/         # AIX 中文命令
http://www.kuqin.com/docs/vim.html    # VIM简要文档
http://www.kuqin.com/docs/sed.html    # SED简要文档
http://www.kuqin.com/docs/awk.html    # AWK简要文档
https://www.w3cschool.cn/svn/fgn81hnb.html SVn

http://www.thegeekstuff.com/2017/06/brctl-bridge/ # Linux 命令实例多多
http://www.yolinux.com/TUTORIALS/LinuxTutorialOptimization.html # linux手册
http://www.server-world.info/en/                    # 系统管理员-简单入门
https://github.com/jiobxn/one/wiki                  # 系统管理员-简单入门
http://www.linuxprobe.com                           # 系统管理员-简单入门
https://www.linuxprobe.com/author/linuxprobe        # 《Linux就该这么学》

https://github.com/alebcay/awesome-shell/blob/master/README_ZH-CN.md # 去发现

http://www.explainshell.com/          # explainshell shell命令说明
http://www.shellcheck.net             # shellcheck shell命令检查

http://www.cnblogs.com/ggjucheng/archive/2012/08/20/2647927.html
https://github.com/jlevy/the-art-of-command-line/blob/master/README-zh.md # the-art-of-command-line
http://sec.cuc.edu.cn/huangwei/wiki/teaching_cns.html # 中国传媒大学
https://www.learnshell.org/                           # 浸染式学习
https://github.com/poetries/mywiki/issues/41 #shell工具

https://github.com/Yensan/LinuxAndC/tree/master/CommandLine # 一些总结

log4sh
http://sourceforge.net/projects/log4sh/, shell里的日志工具, 和log4系列的其他日志库配置基本差不多
shunit
http://shunit.sourceforge.net/, shell的单元测试工具
bashdb

http://bashdb.sourceforge.net/, shell的调试工具
http://cn.linux.vbird.org/linux_server/  # vbird

https://github.com/judasn/IntelliJ-IDEA-Tutorial  # IntelliJ IDEA 简体中文专题教程
https://github.com/judasn/Linux-Tutorial          # 《Java 程序员眼中的 Linux》

https://github.com/judasn/Linux-Tutorialhttps://github.com/judasn/Linux-Tutorial
Ctrl+Alt+BackSpace  # 重启X Window
Ctrl+Alt+[F1~F6]/F7 # 文件接口/图形接口
startx              # 启动图形接口

bash_completion(){
1. 系统自带的命令补全功能仅限于命令和文件名

2 命令行参数补全
sudo apt-get install bash-completion
# 脚本位于/etc/bash_completion，而该脚本会由/etc/profile.d/bash_completion.sh中导入
source /usr/share/bash-completion/bash_completion
命令补全的脚本存放在/usr/share/bash-completion/completions/目录，可以在这个目录查看支持增强补全功能的命令。

2.1 内置补全命令 (compgen和complete 具体见bash4.0用户手册.pdf )
Bash内置有两个补全命令，分别是compgen和complete。compgen命令根据不同的参数，生成匹配单词的候选补全列表，例如：
$ compgen -W 'hi hello how world' h
hi
hello
how
compgen最常用的选项是-W，通过-W参数指定空格分隔的单词列表。h即我们在命令行当前键入的单词，执行完后会输出候选的匹配列表，
这里是以h开头的所有单词。

2.2 complete命令的参数有点类似compgen，不过它的作用是说明命令如何进行补全，例如同样使用-W参数指定候选的单词列表：
$ complete -W 'word1 word2 word3 hello' foo
$ foo w<Tab>
$ foo word<Tab>
word1  word2  word3
我们还可以通过-F参数指定一个补全函数：
$ complete -F _foo foo

2.3 补全相关的内置变量
除了上面的两个补全命令外，Bash还有几个内置的变量用来辅助补全功能，这里主要介绍其中三个：
    COMP_WORDS: 类型为数组，存放当前命令行中输入的所有单词；
    COMP_CWORD: 类型为整数，当前光标下输入的单词位于COMP_WORDS数组中的索引；
    COMPREPLY: 类型为数组，候选的补全结果；
    COMP_WORDBREAKS: 类型为字符串，表示单词之间的分隔符；
    COMP_LINE: 类型为字符串，表示当前的命令行输入；


3. ubuntu 系统帮助
# 长按super键即可查看全部快捷键。
# 许多快捷键可以前往系统设置>键盘>快捷键更改
}

virsh_failed_to_start(){
virsh managedsave-remove oolite
# error: Failed to start domain oolite
# error: Unable to read from monitor: Connection reset by peer
}

jupyter_install(){
sudo pip install jupyter
sudo pip install librouteros
sudo pip install -U pip
sudo pip install librouteros
sudo pip install -U pip setuptools
sudo pip install librouteros
sudo pip install jupyter

sudo jupyter-notebook --allow-root --ip 0.0.0.0
}

history | awk '{a[$2]++}END{for(i in a){print a[i] " " i}}' | sort -rn | head #列出你最常用的10条命令
logger_man(){
logger [-isd] [-f file] [-p pri] [-t tag] [-u socket] [message ...]
    -i, --id     # 逐行记录每一次logger的进程ID
    -s，--stderr # 输出标准错误到系统日志。
    -d, --udp    # 使用数据报(UDP)而不是使用默认的流连接(TCP)
    -f, --file file_name # 记录特定的文件
    -p， --priority priority_level #  指定输入消息的优先级，优先级可以是数字或者指定为 "facility.level" 的格式。比如："-p local3.info " local3 这个设备的消息级别为info。默认级别是 "user.notice"
    日志级别
        facility：
            auth：         用户授权
            authpriv：     授权和安全
            cron：         计划任务
            daemon：       系统守护进程
            kern：         与内核有关的信息
            lpr            与打印服务有关的信息
            mail           与电子邮件有关的信息
            news           来自新闻服务器的信息
            syslog         由syslog生成的信息
            user           用户的程序生成的信息，默认
            uucp           由uucp生成的信息
            local0~7       用来定义本地策略
        level：
            emerg          系统不可用
            alert          需要立即采取动作
            crit           临界状态
            error          错误状态
            warning        告警状态
            notice         正常但是要注意
            info           正常消息
            debug          调试
    -t， --tag tag # 指定标记记录
    -u， --socket socket # 写入指定的socket，而不是到内置系统日志例程。
}
logger_busybox(){
logger [OPTIONS] [MESSAGE]
将MESSAGE写入系统日志。如果省略了MESSAGE，则记录stdin。
   -将日志记录到stderr以及系统日志中。
   -t TAG 使用指定的标签进行记录（默认为用户名）。
   -p PRIO 优先级（数字或设施级别对）。
   
# busybox 级别logger保留的支持是 优先级和TAG.
}
logger_facility_level(){
@ 对facility和level进行简单测试
facility=(auth authpriv cron daemon kern lpr mail news syslog user uucp)
facility+=(local{0..7})
level=(emerg alert crit error warning notice info debug)
for flty in ${facility[@]}; do
  for lvl in ${level[@]}; do 
    logger -p $flty.$lvl -t loggertest "test $flty.$lvl"
  done
done

@ 结合 /etc/rsyslog.conf 配置文件更好理解下面内容 rsyslogd
默认centos不输出debug级别打印
默认centos不输出authpriv cron mail级别打印
authpriv ->  /var/log/secure
cron -> /var/log/cron
mail -> /var/log/maillog

@ busybox 中syslogd 输出文件大小,轮转个数,输出级别,简单还是复杂格式输出,输出文件名等配置
/sbin/syslogd -O /var/log/messages -s 2000 -b 10 -S -l 6 用来控制message输出级别
Dec 12 13:53:45 loggertest: test user.emerg    -l 0 被忽略
Dec 12 13:53:45 loggertest: test user.alert    -l 1 被忽略
Dec 12 13:53:45 loggertest: test user.crit     -l 2 被忽略
Dec 12 13:53:45 loggertest: test user.error    -l 3 被忽略
Dec 12 13:53:45 loggertest: test user.warning  -l 4 被忽略
Dec 12 13:53:45 loggertest: test user.notice   -l 5 被忽略
Dec 12 13:53:45 loggertest: test user.info     -l 6 被忽略
Dec 12 13:53:45 loggertest: test user.debug    -l 7 被忽略
}
logger_demo(){
    logger System Rebooted    #  无选项输出
# root: System Rebooted
    logger -p info -t kdump "kdump message" #  指定tag和优先级
# kdump: message
    logger -t oddjobd 'oddjobd startup succeeded' # 指定tag
# oddjobd: oddjobd startup succeeded
    logger -p local0.notice -t passwd -f /etc/resolv.conf # 输出指定文件内容
# passwd: nameserver 192.168.1.1
# passwd: nameserver 180.76.76.76
    logger -p user.notice -t passwd -f /etc/resolv.conf   # 输出指定文件内容
    
    logger -i -s -p local3.info -t passwd -f /etc/resolv.conf # stderr 和 message 双输出
# passwd[17085]: nameserver 192.168.1.1
# passwd[17085]: nameserver 180.76.76.76

# 新配置
    vim /etc/rsyslog.conf     #在最后一行加入local3.* /var/log/my_test.log   意思是来自local3的所有消息都记录到/var/log/my_test.log中。
    service rsyslog restart   #重启rsyslog服务
    logger -i -t "my_test" -p local3.notice "test_info" 
    cat /var/log/my_test.log  
    May 5 21:27:37 gino-virtual-machine my_test[3651]: test_info
    -i 在每行都记录进程ID
    -t my_test每行记录都加上"my_test"这个标签
    -p local3.notice 设置记录的设备和级别
    "test_info"  输出信息
}
logger_phd(){
log4sh 
sendmail
}

mutt_intro_mail(){
https://segmentfault.com/a/1190000018131615
Mutt本身是一个框架而已。收件、发件、编辑邮件等功能，是要通过搭配不同的程序来做到的。
mutt怎么搭配呢？
常用选项有这些(User/Transport/Delivery)：
    MUA 收件：fetchmail或getmail或OfflineIMAP
    MTA 发件：sendmail或msmtp或postfix。其中msmtp兼容强，postfix对国内不友好
    MDA 分类: procmail或maildrop
    邮件编辑：VIM。

一般搭配是：
    老式搭配：mutt + getmail + sendmail + procmail
    新式搭配：mutt + fetchmail + msmtp + maildrop
但是maildrop不支持Mac，而procmail比较通用一点。所以这里我们用：
mutt + fetchmail + msmtp + procmail

大概的配置流程是：
    配置收件：~/.fetchmailrc
    配置过滤：~/.procmailrc
    配置发件：~/.msmtprc
    配置mutt框架本身：~/.muttrc
注意：初学过程中，不要一上来就配置mutt。最好是先从各个部件开始：收件->过滤邮件->阅读邮件->发件->mutt界面，按照这种顺序。

@ 收件：配置Fetchmail
    Fetchmail是由著名的《大教堂与集市》作者 Eric Steven Raymond 编写的。
Fetchmail是一个非常简单的收件程序，而且是前台运行、一次性运行的，意思是：你每次手动执行fetchmail命令，都是在前台一次收取完，程序就自动退出了，不是像一般邮件客户端一直在后台运行。
注意：fetchmail只负责收件，而不负责存储！所以它是要调用另一个程序如procmail来进行存储的。
fetchmail的配置文件为~/.fetchmailrc。然后文件权限最少要设置chmod 600 ~/.fetchmailrc

@ 邮件过滤：配置Procmail
Procmail是单纯负责邮件的存储、过滤和分类的，一般配合fetchmail收件使用。
在Pipline中，fetchmail把收到的邮件全部传送到Procmail进行过滤筛选处理，然后Procmail就会把邮件存到本地形成文件，然后给邮件分类为工作、生活、重要、垃圾等。

@ 发件：配置msmtp
msmtp是作为替代sendmail发邮件程序的更好替代品。
msmtp的配置文件为~/.msmtprc，记得改权限：chmod 600 ~/.msmtprc
配置内容比收件还简单，因为发件永远比收件简单。
    Tip: 发件的服务器是smtp协议。收件才是pop3协议。

@ 主界面：配置Mutt
Mutt的配置文件为~/.muttrc，记得改权限：chmod 600 ~/.muttrc
    另外：mutt的配置文件还可以放在~/.mutt/muttrc。这种方法有一个好处，即~/.mutt/目录下可以放很多主题、插件等文件。
}

# 一定要注意:在使用mutt发送邮件之前,一定要保证你的邮箱开通了SMTP/POP3服务,允许使用第三方代理客户端! -> 针对126或腾讯邮箱
mutt_man_mail(){
mutt [-hnpRvxz][-a<文件>][-b<地址>][-c<地址>][-f<邮件文件>][-F<配置文件>][-H<邮件草稿>][-i<文件>][-m<类型>][-s<主题>][邮件地址]
补充说明：mutt 是一个文字模式的邮件管理程序，提供了全屏幕的操作界面。
参数：
    -a <文件> 在邮件中加上附加文件。
    -b <地址> 指定密件副本的收信人地址。
    -c <地址> 指定副本的收信人地址。
    -f <邮件文件> 指定要载入的邮件文件。
    -F <配置文件> 指定mutt程序的设置文件，而不读取预设的.muttrc文件。
    -h 显示帮助。
    -H <邮件草稿> 将指定的邮件草稿送出。
    -i <文件> 将指定文件插入邮件内文中。
    -m <类型> 指定预设的邮件信箱类型。
    -n 不要去读取程序培植文件(/etc/Muttrc)。
    -p 在mutt中编辑完邮件后，而不想将邮件立即送出，可将该邮件暂缓寄出。
    -R 以只读的方式开启邮件文件。
    -s <主题> 指定邮件的主题。
    -v 显示mutt的版本信息以及当初编译此文件时所给予的参数。
    -x 模拟mailx的编辑方式。
    -z 与-f参数一并使用时，若邮件文件中没有邮件即不启动mutt。
}
mutt_demo_mail(){
    echo "Email body" | mutt -s "Email Title" root@einverne.info
echo "body" | mutt -s "mysql backup" root@einverne.info -a /mysql.tar.gz # 带附件
mutt -s "Test" xxxx@qq.com # 读取文本中的信息作为内容
echo "body" | mutt -s "web backup" root@einverne.info -a /mysql.tar.gz -a /web.tar.gz  # 添加多个附件
echo "body" | mutt -s "title" -c cc@gmail.com -b bcc@gmail.com root@einverne.info # 抄送和密送

# mutt+msmtp相结合发送邮件
~/.muttrc
set sendmail="/usr/bin/msmtp"
set use_from=yes
set realname="wangfuli"
set from=ted@nidey.com
set envelope_from=yes

~/.msmtprc
account default
host 192.168.27.125
from ted@nidey.com
auth off
tls off
logfile ~/.msmtp.log

chmod 0600 ~/.msmtprc
echo "Email body" | mutt -s "Email Title" ted@mail.nidey.com
}

sendmail_busybox_demo(){
C:\WINDOWS\system32\drivers\etc\hosts
127.0.0.1       localhost
127.0.0.1       XP-201304241117
192.168.1.57    XP-201304241117
192.168.27.125    nidey.com
192.168.27.125    mail.nidey.com

echo -e "Subject: Main Information" | sendmail -F 192.168.27.253 ted@nidey.com -S 192.168.27.125
-F 用来指定发送邮件来源，如何将该值替换成hed0或eth0上的IP地址。
# rtu
# 在subjuect 中标定那个设备上报的错误
echo -e "Subject: Main Information" | sendmail -f ted@nidey.com ted@nidey.com -S 192.168.27.125 -a /var/log/messages -a /var/log/message.0
echo -e "Subject: Main Information" | sendmail ted@nidey.com -S 192.168.27.125 -a /var/log/messages -a /var/log/messages.0
}

sendmail_mail_man(){
sendmail [OPTIONS] [RECIPIENT_EMAIL]...
Read email from stdin and send it

标准选项。
    -t 从电文中读取其他收件人
    -f sender Sender（必填）
    -o选项 各种选项。隐含的 -oi，其他选项被忽略


Busybox 具体选项：
    -w秒 网络超时
    -H 'PROG ARGS' 运行连接帮助程序。
        例子:
        -H 'exec openssl s_client -quiet -tls1 -starttls smtp。
                -connect smtp.gmail.com:25' <email.txt。
                [4<username_and_passwd.txt | -au<username> -ap<password>] 。
        -H 'exec openssl s_client -quiet -tls1'。
                -connect smtp.gmail.com:465 <email.txt。
                [4<username_and_passwd.txt | -au<username> -ap<password>] 。
    -S server[:port] 服务器
    -au<username> AUTH LOGIN的用户名
    -ap<password> AUTH LOGIN 的密码。
    -am<method> 认证方法。忽略。LOGIN是隐含的。
}

# https://blog.csdn.net/liang19890820/article/details/53115334 
# 通过修改配置文件，可以达到不使用 sendmail 而用外部 smtp 服务器发送邮件的目的??? 
mail_man(){
mail 命令是 Linux 下一个非常轻巧的交互式的命令行邮件客户端.
mail 默认是调用本机 MTA 发送邮件的，这意味着需要在本机上安装 sendmail 或 postfix 或 exim 或…，配置比较麻烦，而且会带来不必要的资源占用。
1. 通过修改配置文件，可以达到不使用 sendmail 而用外部 smtp 服务器发送邮件的目的。

选项         说明
-b address   指定密件副本的收信人地址
-c address   指定副本的收信人地址
-f [file]    读取指定邮件文件中的邮件
-i           忽略终端发出的信息
-I           使用互动模式
-n           启动时禁止读取 /etc/mail.rc
-N           阅读邮件时，不显示邮件的标题
-s subject   指定邮件的主题
-t           要发送的消息应包含带有 To:、Cc:、或 Bcc: 字段的消息头，在命令行上指定的收件人将被忽略。
-u user      读取指定用户的邮件
-v           执行时，显示详细的信息
-V           显示版本信息并退出

1.标准输入录入邮件信息
[root@localhost ~]# mail -s "邮件主题" 123456@qq.com
hello  # 邮件正文
world  # 邮件正文
EOT  # 按 Ctrl+D
[root@localhost ~]# 

echo "邮件正文" | mail -s "邮件主题" 123456@qq.com
cat file.txt | mail -s "邮件主题" 123456@qq.com

mail -s "邮件主题" 123456@qq.com < file.txt
}
mail_demo(){

# 本机
mail -s "helloworld" -r wangfl@xianleidi.com -S smtp-auth-user=wangfl@xianleidi.com -S smtp-auth-password="1qaz@WSX" wangfl@xianleidi.com < iRedMail.bak 
# 本机
mail -s "helloworld" -r ted@nidey.com -S smtp-auth-user=ted@nidey.com  -S smtp-auth-password="ted" ted@nidey.com < network
mail -s "helloworld" -r ted@nidey.com ted@nidey.com < network
}
mail_demo(){
mail -s "主题" 用户名@地址 < 文件

1. 有了 mail 后，直接用命令行测试
echo "mail body" | \
mail -v \
-s "subject" \
-S from=2638394476@qq.com \
-S smtp-auth-password=youpassword \
-S smtp-auth-user=2638394476@qq.com \
-S smtp-auth=login \
-S smtp-use-starttls \
-S smtp=smtps://smtp.qq.com:465 \
-S ssl-verify=ignore \
270130108@qq.com

或

echo "mail body" | \
mail -v \
-r wangfl@xianleidi.com \
-s "subject" \
-S smtp-auth-password=1qaz@WSX \
-S smtp-auth-user=wangfl@xianleidi.com \
-S smtp-auth=login \
-S smtp-use-starttls \
-S ssl-verify=ignore \
wangfl@xianleidi.com

1.  [配置成功后，就可以使用外部 smtp 服务器发送邮件了]
注意，这里用的是 smtps://smtp.qq.com:465
在配置文件里面配置账号
首先找到相应的配置文件
strings `which mail` | grep '\.rc'
/etc/mail.rc
sudo vim /etc/s-nail.rc
在文件末尾添加
set from=2638394476@qq.com             # 发送的邮件地址
set smtp-auth-password=youpassword     # 发件人密码
set smtp-auth-user=2638394476@qq.com   # 发件人账号
set smtp-auth=login                    # 邮件认证方式
set smtp=smtps://smtp.qq.com:465       # 发送邮件服务器
set ssl-verify=ignore
测试
echo "mail body" | mail -s "subject1" 270130108@qq.com

2. Ubuntu 14.04
sudo vim /etc/nail.rc
在文件末尾添加
set from=2638394476@qq.com
set smtp-auth-password=youpassword
set smtp-auth-user=2638394476@qq.com
set smtp-auth=login
set smtp=smtps://smtp.qq.com:465
set ssl-verify=ignore
测试
echo "mail body" | mail -s "subject2" 270130108@qq.com
CentOS 7.2
sudo vim /etc/mail.rc
在文件末尾添加
set from=2638394476@qq.com
set nss-config-dir=/etc/pki/nssdb
set smtp-auth-password=youpassword
set smtp-auth-user=2638394476@qq.com
set smtp-auth=login
set smtp=smtps://smtp.qq.com:465
set ssl-verify=ignore
测试
echo "mail body" | mail -s "subject3" 270130108@qq.com
}

gcc_link_path(){
export LD_LIBRARY_PATH= 
LIBRARY_PATH      #静态库路径
LD_LIBRARY_PATH   #动态库路径
PATH              #执行文件的路径
}

flex_demo(){
src/y.tab.c src/tokens.h : src/p.y
    $(YACC) $(YACCFLAGS) -o src/y.tab.c $<
    -mv src/y.tab.h src/tokens.h
src/tokens.h : src/y.tab.c
src/lex.yy.c : src/l.l
    $(FLEX) $(FLEXFLAGS) -o $@ $<

make src/lex.yy.c
# /usr/bin/flex -i -osrc/lex.y.c src/l.l
make src/y.tab.c 
# bison -y -dvt -o src/y.tab.c src/p.y
}

flex_bison_idea(){  对于每个匹配的模式，执行相关的动作。
    1. 对于每个匹配的模式，执行相关的动作。 不禁想起flex和yacc。初级一点如flex 模式 执行; 高级一点如yacc, 符合结构(高级模式) 执行
flex       是基于流的模式-执行单元组；
awk        是基于行|字段的模式-执行单元组；
sed        是基于行的模式-执行单元组；
bison      是基于token关系的模式-执行单元组
find+xargs 也可以某种意义的模式-执行单元组

sed 缺省的把标准输入复制到标准输出，在把每行写到输出之前可以在其上进行一个或多个编辑命令。给每个命令的输入都是所有前面命令的输出。
这种行为可以通过命令行选项来更改。 -n 告诉 sed 不复制所有的行，只复制 p 函数或在 s 函数后 p 标志所指定的行
    [地址1,地址2]<函数>[参数]
    1. 一个或两个地址是可以省略的；
    2. 可以用任何数目的空白或 tab 把地址和函数分隔开。
    3. 函数必须出现；
    4. 依据给出的是哪个函数，参数可能是必需的或是可选的；
    5. 忽略在这些行开始处的 tab 字符和空格。
awk. 动作与模式: 1. 模式或动作二者都可以但不能同时省略。
    如果一个模式没有动作，简单的把匹配的行复制到输出。(所以匹配多个模式的行可能被打印多次)。 没有动作的'模式-动作'是输出匹配行
    如果一个动作没有模式，则这个动作在所有输入上执行。(不匹配模式的行被忽略)。               没有模式的'模式-动作'是匹配所有行
    因为模式和动作都是可选的，动作必须被包围在花括号中来区别于模式。
    2. 在动作之前的模式充当决定一个动作是否执行的选择者。有多种多样的表达式可以被用做模式: 正则表达式，

awk和sed都是"模式-动作"方式的文本处理工具。每行数据可以对应多条"模式-动作"，即: 一行数据可以被处理多次。
sed 通过模式匹配进行定位(还有数值)，使用特定的函数和模式替换对输入进行处理；
awk 通过模式匹配和条件判断语句匹配进行定位(还有数值)，通过特定函数和位置变量赋值对输入数据进行处理。
sed 通过保存空间保存临时数据，保存空间相当于一个变量
awk 通过位置变量、自定义变量、环境变量和关联数组保存临时数据，所以awk处理数据更加强大。

sed 循环从文件中读取写入模式空间的数据包括换行；
awk 循环从文件中读取写入$0的数据不包括换行；所以，print自带换行(这里的换行源于ORS)，printf输出不带换行

从功能分解上而言: awk处理数据的粒度要比sed更准确，也有更多的控制逻辑，更多的变量类型(数组，内置变量，自定义变量)，更多的内置函数。
所以，如果将要实现的功能落实到代码处理逻辑上，简单行级别处理: 删除，插入，定位后输出行，修改和字段级别的替换使用sed，
当涉及到到统计、字段级别替换、格式化、排序和多文件合并，最好使用awk实现。且awk实现时，能用 执行部分if控制，就别使用 模式控制。

awk 的函数具有lua脚本语言的特性， gsub(r, s [, t]) 
                                  match(s, r [, a]) 
                                  split(s, a [, r]) 
                                  sub(r, s [, t])
                                  substr(s, i [, n]) 
提供了一些默认值，参数可以动态传入。
还有一些命令特性: getline; getline <file; getline var; getline var<file; command | getline [var]; next; print 等空格分割命令行方式；
还提供了数学特性: cos sin int log rand srand 等等
还有时间相关函数: mktime(datespec)  strftime([format [, timestamp[, utc-flag]]]) systime() 
除了扩展性，几乎有了Lua语言所有特性。

awk 使用分号(或换行)来分隔 多个'模式-动作'块；也使用分号和换行来分隔 多动作中的条执行语句。
sed 使用分号(或换行)来分隔 多个'模式-动作'块；也使用分号和换行来分隔多个'模式'。 #  awk '1;{print ""}'  动作1相当于 print $0
awk 模式中，非空字符串和非零数值 被视作匹配所有行的 模式 。         # awk '1{print $0}'  test1.sh 
@ 形式上有差异;功能上一致
seq 6 | sed '1d 
3d 
5d'
seq 6 | sed '1d;3d;5d'
seq 6 | sed '{1d;3d;5d}'
seq 6 | sed '{1d;3d};5d'

seq 3 | sed '/1/b x ; s/^/=/ ; :x ; 3d'
seq 3 | sed -e '/1/bx' -e 's/^/=/' -e ':x' -e '3d'

sed - when you need to do simple text transforms on files.
awk - when you only need simple formatting and summarization or transformation of data.
perl - for almost any task, but especially when the task needs complex regular expressions.
python - for the same tasks that you could use Perl for.
}

Clang_coan(coan){
coan可以用来净化C语言中的预编译指令；可以用于阅读源代码时简化无用的代码。
coan source -UWIN32 -DSIGHUP -U__CYGWIN__ -UWITH_BRIDGE --filter c,h --recurse .

例如学习libevent在Linux下实现时可以使用如下命令
coan source -D_EVENT_HAVE_SYS_IOCTL_H -D_EVENT_HAVE_NETDB_H -D_EVENT_HAVE_STDDEF_H \ 
-D_EVENT_HAVE_STDINT_H  -D_EVENT_HAVE_SYS_TIME_H -D_EVENT_HAVE_SYS_TYPES_H \
-D_EVENT_HAVE_INTTYPES_H \
-D_EVENT_HAVE_SYS_SOCKET_H -D_EVENT_HAVE_UNISTD_H -D_EVENT_HAVE_SYS_EVENTFD_H -D_EVENT_HAVE_SELECT \
-D_EVENT_HAVE_POLL -D_EVENT_HAVE_EPOLL -U__cplusplus -UWIN32 -U_EVENT_HAVE_EVENT_PORTS \
-U_EVENT_HAVE_WORKING_KQUEUE -U_EVENT_HAVE_DEVPOLL -U_EVENT_IN_DOXYGEN -U_MSC_VER \
-U_EVENT_HAVE_SYS_SENDFILE_H --filter c,h --recurse .
}
Clang_construct(){
----------------调试工具--------------------
GNU  Debugger       :gdb
Perl Debugger       :perl -d
Bash Debugger       :bashdb
Python Debugger     :pydb
GNU Make Debugger   :remake
--------------代码静态检查工具--------------
scan-build 
cppcheck   
tscancode  
--------软件构建系统(build system)--------
cmake        http://www.cmake.org
scons        http://www.scons.org
-------------代码版本控制工具---------------
subversion   http://www.subversion.tigris.org
------------------测试框架------------------
cppunit      http://sourceforge.net/projects/cppunit
-------------------python-------------------
python-twill
pylint
-----------编译器/识别器生成工具------------
bison        http://www.gnu.org/software/bison
antlr        http://antlr.org
----------------代码格式化------------------
astyle       http://astyle.sourceforge.net
indent       http://www.gnu.org/software/indent 
------------------在线文档------------------
doxygen      http://www.stack.nl/~dimitri/doxygen 
-----------------离线文档-------------------
docbook      http://www.docbook.org
}
Clang_gprof(){
eg.gcc xxx.c -o xxx -pg
eg.make CFLAGS=-pg LDFLAGS=-pg 
eg.gprof -b xxx gmon.out
----------------
-b 不再输出统计图表中每个字段的详细描述
-p 只输出函数的调用图 
-q 指数除函数的时间消耗列表 
-E name 不再输出函数name及其子函数的调用图
-e name 不再输出函数name及其子函数的调用图 
-F name 输出函数及其子函数的调用图
-f name 输出函数name及其子函数的调用图
-z 显示使用次数为零的例程

    GNU 编译器工具包所提供了一种剖析工具 GNU profiler(gprof)。 gprof 可以为 Linux平台上的程序精确分析性能瓶颈。
gprof精确地给出函数被调用的时间和次数，给出函数调用关系。
1. 可以显示"flat profile"，包括每个函数的调用次数，每个函数消耗的处理器时间，
2. 可以显示"Call graph"，包括函数的调用关系，每个函数调用花费了多少时间。
3. 可以显示"注释的源代码"－－是程序源代码的一个复本，标记有程序中每行代码的执行次数。

    原理：
    通过在编译和链接程序的时候(使用 -pg 编译和链接选项)， gcc 在应用程序的每个函数中都加入了一个名为mcount的函数调用，
 而mcount会在内存中保存一张函数调用图， 并通过函数调用堆栈的形式查找子函数和父函数的地址。这张调用图也保存了所有与函数
 相关的调用时间，调用次数等等的所有信息。 运行程序后在程序运行目录下生成 gmon.out文件(如果原来有gmon.out 文件，将会被重写)。

    用 gprof 工具分析 gmon.out 文件。
一般用法： gprof -b 二进制程序 gmon.out >report.txt
注：export GMON_OUT_PREFIX=x.out 生成的文件名形如x.out.<进程的pid>
Gprof 的具体参数 man gprof

    注意 程序的累计执行时间只是包括gprof能够监控到的函数。 工作在内核态的函数和没有加-pg编译的第三方库函数是无法被gprof能够监控到的

    共享库的支持 对于代码剖析的支持是由编译器增加的，因此如果希望从共享库中获得剖析信息，就需要使用 -pg 来编译这些库。 如果需要分析系统函数(如libc库)，用 –lc_p替换-lc，这样程序会链接libc_p.so或libc_p.a。
    用ldd ./example | grep libc来查看程序链接的是libc.so还是libc_p.so

注意事项
1. 在编译和链接两个过程，都要使用-pg选项。
2. 只能使用静态连接libc库，否则在初始化*.so之前就调用profile代码会引起段错误，
        编译时加上-static-libgcc或-static。
3. 如果不用g++而使用ld直接链接程序，要加上链接文件/lib/gcrt0.o
        ld -o myprog /lib/gcrt0.o myprog.o utils.o -lc_p
        也可能是gcrt1.o
4. 要监控到第三方库函数的执行时间，第三方库也必须是添加 –pg 选项编译的。
5. gprof只能分析应用程序所消耗掉的用户时间.
6. 程序不能以demon方式运行。否则采集不到时间。(可采集到调用次数)
7. 首先使用 time 来运行程序从而判断 gprof 是否能产生有用信息是个好方法。
8. 如果 gprof 不适合您的剖析需要，那么还有其他一些工具可以克服 gprof 部分缺陷，包括 OProfile 和 Sysprof。
9. gprof对于代码大部分是用户空间的CPU密集型的程序用处明显。对于大部分时间运行在内核空间或者由于外部因素(例如操作系统的 I/O 子系统过载)而运行得非常慢的程序难以进行优化。
10.gprof 不支持多线程应用，多线程下只能采集主线程性能数据。原因是gprof采用ITIMER_PROF信号，在多线程内只有主线程才能响应该信号。但是有一个简单的方法可以解决这一问题：http://sam.zoy.org/writings/programming/gprof.html 采用什么方法才能够分析所有线程呢？关键是能够让各个线程都响应ITIMER_PROF信号。可以通过桩子函数来实现，重写pthread_create函数。
11.gprof只能在程序正常结束退出之后才能生成报告(gmon.out)。
        原因： gprof通过在atexit()里注册了一个函数来产生结果信息，任何非正常退出都不会执行atexit()的动作，所以不会产生gmon.out文件。
        程序可从main函数中正常退出，或者通过系统调用exit()函数退出。
        可以使用捕捉信号，在信号处理函数中调用exit的方式来解决部分问题。
        不能捕获、忽略SIGPROF信号。man手册对SIGPROF的解释是：profiling timer expired. 如果忽略这个信号，gprof的输出则是：Each sample counts as 0.01 seconds. no time accumulated.
        
}
Clang_cflow_intro(){
cflow是一款静态分析C语言代码的工具，通过它可以生成函数的调用关系. sourceinsight可以替代
https://www.gnu.org/software/cflow/

sudo apt install cflow
cflow main.c                         生成main.c文件例的函数调用关系
cflow -x main.c                      生成交叉引用表，查看函数调用的位置和文件
cflow -o call_tree.txt main.c        生成调用关系并输出到call_tree.txt文件
cflow -d 5 -o call_tree.txt main.c   指定输出的最大调用深度位5

我只列出我觉得有意思的几个参数:
-T输出函数调用树状图
-m指定需要分析的函数名
-n输出函数所在行号
-r输出调用的反向关系图
--cpp预处理，这个还是很重要的

wget -c https://github.com/tinyclub/linux-0.11-lab/raw/master/tools/tree2dotx # tree2dotx
cflow -T -m main -n main.c > main.txt
cat main.txt | tree2dotx > main.dot
dot -Tgif main.dot -o main.gif  
}

Clang_astyle_intro(){
astyle --style=ansi --indent=tab --mode=c $(find . -path ./.metadata -prune -type f -o -name *.c)
astyle --style=linux --indent=tab --mode=c $(find . -path ./.metadata -prune -type f -o -name *.c)

astyle -n --style=kr --indent-switches --add-brackets *.c

--style=ansi：   ANSI 风格格式和缩进
--style=kr ：    Kernighan&Ritchie 风格格式和缩进
--style=linux ： Linux 风格格式和缩进
--style=gnu ：   GNU 风格格式和缩进
--style=java ：  Java 风格格式和缩进

(1) -f 在两行不相关的代码之间插入空行，如import和public class之间、public class和成员之间等；
(2) -p 在操作符两边插入空格，如=、+、-等。
如：int a=10*60;
处理后变成int a = 10 * 60;
(3) -P 在括号两边插入空格。另，-d只在括号外面插入空格，-D只在里面插入。
如：MessageBox.Show ("aaa");
处理后变成MessageBox.Show ( "aaa" );
(4) -U 移除括号两边不必要的空格。
如：MessageBox.Show ( "aaa" );
处理后变成MessageBox.Show ("aaa");
(5) -V 将Tab替换为空格。

astyle --style=kr -p *.cpp *.h
indent -linux $(find . -path ./.metadata -prune -type f -o -name *.c) 

find -name "*.c" | xargs astyle --style=google >/dev/null 2>&1
find -name "*.h" | xargs astyle --style=google >/dev/null 2>&1
find -name "*.orig" | xargs rm -f
}

Clang_cppcheck_man(){
cppcheck --enable=all --inconclusive --std=posix test.cpp
cppcheck . 2> cppcheck.log         # 检测结果输出在前台，检查过程输出到cppckeck.log文件中
cppcheck --quiet path/to/directory # 递归检测指定目录，不输出测试过程
# 对指定文件使用指定测试，其中error是默认测试项
cppcheck --enable=error|warning|style|performance|portability|information|all path/to/file.cpp
cppcheck --errorlist # 列出所有测试项
cppcheck --suppress=test_id1 --suppress=test_id2 path/to/file.cpp # 检查指定文件，目录指定测试
cppcheck -I include/directory_1 -I include/directory_2 . # 检查当前目录代码，需要包含外部头文件
cppcheck --project=path/to/project.sln # 检查 Microsoft Visual Studio project (*.vcxproj) or solution (*.sln)

Analyze given C/C++ files for common errors.
--check-config  检查cppcheck配置。 正常代码分析，此标志禁用。
--check-library 库文件具有时显示信息消息不完整的信息。
-D<id>          限制检查范围 -DDEBUG=1 -D__cplusplus
-U<id>          显示隐藏要检查代码 -UDEBUG
--enable=all
--enable=error|warning|style|performance|portability|information|all
默认情况下，只显示错误消息，可以通过 --enable 命令启用更多检查
cppcheck --enable=warning file.c             启用警告消息
cppcheck --enable=performance file.c         启用性能消息
cppcheck --enable=information file.c         启用信息消息
cppcheck --enable=style file.c               由于历史原因 --enable=style 可以启用警告、性能、可移植性和样式信息
cppcheck --enable=warning,performance file.c 启用警告和性能消息：
cppcheck --enable=all 启用所有消息
--error-exitcode=<n> 
--errorlist 可能错误列表
--exitcode-suppressions=<file>
--file-list 检查文件列表
--force
-I <dir> 外部头文件
--includes-file=<file> 外部头文件被写在<file>文件中，每行包含一个路径。
--include=<file> 检查一个文件前，强制包含一个头文件， Linux内核如autoconf.h。与GCC -include类似
-i <dir> 给出要排除的源文件或源文件目录从检查。 这仅适用于源文件等源文件包括的头文件不匹配。目录名称与路径的所有部分匹配。
--inconclusive 即使分析是，仍允许Cppcheck报告不确定。这个选项有假阳性。 每个结果必须仔细调查，才知道是否是好是坏。
--inline-suppr  启用内联抑制。 通过放置一个或使用它们
-j 用于指定需要使用的线程数，
cppcheck -j 4 path
--language=<language>, -x <language> 强制cppcheck检查所有文件作为给定语言。 有效值为：c，c ++
--project=<file>  在项目上运行Cppcheck。 <file>可以是Visual Studio解决方案（* .sln），Visual Studio项目
                （* .vcxproj），或编译数据库（compile_commands.json）。 要分析的文件，包括路径，定义，平台和未定义将使用指定的文件。
--platform=<type>, --platform=<file> 
-q, --quiet 不显示进度报告。
--std=<id> posix c89 c99 c11 C++03 C++11
}
Clang_cppcheck_demo(){
.PHONY: cppcheck \
        cppcheck-error \
        cppcheck-information \
        cppcheck-performance \
        cppcheck-portability \
        cppcheck-style \
        cppcheck-warning \
        cppcheck-all
        
CPPCHECK_CMD = cppcheck \
    --inline-suppr \
    --error-exitcode=0 \
    -j 4 \
    --force \
    -I $(top_srcdir)/lib \
    --language=c \
    --std=c99
    
CPPCHECK_DIRS = \
    "$(top_srcdir)/lib" \
    "$(top_srcdir)/src"

CPPCHECK_OUT_PREFIX = $(top_builddir)/cppcheck-
CPPCHECK_OUT_EXT = log.txt

cppcheck:
	$(CPPCHECK_CMD) --enable=all $(CPPCHECK_DIRS) 2>$(CPPCHECK_OUT_PREFIX)all.$(CPPCHECK_OUT_EXT);

cppcheck-all: cppcheck

cppcheck-information:
	$(CPPCHECK_CMD) --enable=information $(CPPCHECK_DIRS) 2>$(CPPCHECK_OUT_PREFIX)information.$(CPPCHECK_OUT_EXT);


cppcheck-performance:
	$(CPPCHECK_CMD) --enable=performance $(CPPCHECK_DIRS) 2>$(CPPCHECK_OUT_PREFIX)performance.$(CPPCHECK_OUT_EXT);


cppcheck-portability:
	$(CPPCHECK_CMD) --enable=portability $(CPPCHECK_DIRS) 2>$(CPPCHECK_OUT_PREFIX)portability.$(CPPCHECK_OUT_EXT);


cppcheck-style:
	$(CPPCHECK_CMD) --enable=style $(CPPCHECK_DIRS) 2>$(CPPCHECK_OUT_PREFIX)style.$(CPPCHECK_OUT_EXT);


cppcheck-warning:
	$(CPPCHECK_CMD) --enable=warning $(CPPCHECK_DIRS) 2>$(CPPCHECK_OUT_PREFIX)warning.$(CPPCHECK_OUT_EXT);


cppcheck-unusedFunction:
	$(CPPCHECK_CMD) --enable=unusedFunction $(CPPCHECK_DIRS) 2>$(CPPCHECK_OUT_PREFIX)unusedFunction.$(CPPCHECK_OUT_EXT);


cppcheck-missingInclude:
	$(CPPCHECK_CMD) --enable=missingInclude $(CPPCHECK_DIRS) 2>$(CPPCHECK_OUT_PREFIX)missingInclude.$(CPPCHECK_OUT_EXT);
}
Clang_indent_man(){ 
indent [参数][源文件] 或 indent [参数][源文件][-o 目标文件]
indent [参数][源文件]                直接修改指定文件(会产生修改备份)
indent [参数][源文件][-o 目标文件]   输出到目标文件  -st 输出到标准输出
1. 使用方式
indent slithy_toves.c -o slithy_toves.out        方式2 -o
indent -st slithy_toves.c > slithy_toves.out     方式2 -st
cat slithy_toves.c | indent -o slithy_toves.out  方式2 -o
indent -br test/metabolism.c -l85                方式1 追加选项
.indent.pro 配置文件 或者 -npro或--ignore-profile 不读取配置文件
2. 通用格式
# Linux 内核格式 
 -nbad -bap -nbc -bbo -hnl -br -brs -c33 -cd33 -ncdb -ce -ci4
 -cli0 -d0 -di1 -nfc1 -i8 -ip0 -l80 -lp -npcs -nprs -npsl -sai
 -saf -saw -ncs -nsc -sob -nfca -cp33 -ss -ts8 -il1
# Berkeley 格式 (-orig)
-nbad -nbap -bbo -bc -br -brs -c33 -cd33 -cdb -ce -ci4 -cli0
-cp33 -di16 -fc1 -fca -hnl -i4 -ip4 -l75 -lp -npcs -nprs -psl
-saf -sai -saw -sc -nsob -nss -ts8
#  Kernighan & Ritchie style (-kr)
-nbad -bap -bbo -nbc -br -brs -c33 -cd33 -ncdb -ce -ci4 -cli0
-cp33 -cs -d0 -di1 -nfc1 -nfca -hnl -i4 -ip0 -l75 -lp -npcs
-nprs -npsl -saf -sai -saw -nsc -nsob -nss
#  GNU Emacs C style (-gnu)
-nbad -bap -nbc -bbo -bl -bli2 -bls -ncdb -nce -cp1 -cs -di2
-ndj -nfc1 -nfca -hnl -i2 -ip5 -lp -pcs -nprs -psl -saf -sai
-saw -nsc -nsob
3. BLANK LINE
-bad -bap -bbb -sob
4. COMMENT
-fca -fc1 -d -d2 -c -cd -cj -cd0 -cdb -sc
5. STATEMENTS
-br([-ce|-nce] ) -bl(-bli -bli0 -lbi2)   if
-cdw -ncdw                               while
-cli cli0 (-cbi0)                        switch
-pcs -cs -bs                             space
-saf  for
-sai  if
-saw  while
-prs  all
6. DECLARATIONS
-di -di16       variable
-bc -nbc        
-bfda -nbfda    function
-bfde -nbfde    
-T -T CODE_ADDR -T COLOR struct and enum
-brs -bls -brf  function
7. INDENTATION
8. BREAKING LONG LINES
-ln
# [ -cn] [ -cdn ] [ -cin ] [ -clin ] [ -dn ] [ -din ]  [ -in ] [ -ln ] [ -lcn ] [ -st ] [ -troff ] 
-bbo或--break-before-boolean-operator                 较长的行，在逻辑运算符前分行
-bli<缩排格数>或--brace-indent<缩排格数>              设置{ }缩排的格数。
-bli0 或 --brace-indent 0                             "{"不继续缩进
-bls 或 --braces-after-struct-decl-line               定义结构，"struct"和"{"分行
-bs或--blank-before-sizeof 　                         在sizeof之后空一格。
-ci<缩排格数>或--continuation-indentation<缩排格数>   叙述过长而换行时，指定换行后缩排的格数。
-cli<缩排格数>或--case-indentation-<缩排格数> 　      使用case时，switch缩排的格数。
-cp<栏数>或-else-endif-column<栏数> 　                将注释置于else与elseif叙述右侧定的栏位。
-c<栏数>或--comment-indentation<栏数>                 将注释置于函数右侧指定的栏位。   -c33  语句后注释开始于行33
-cd<栏数>或--declaration-comment-column<栏数>         将注释置于声明右侧指定的栏位。   -cd33 变量声明后注释开始于行33
-d<缩排格数>或-line-comments-indentation<缩排格数>    针对不是放在程序码右侧的注释，设置其缩排格数。
-di<栏数>或--declaration-indentation<栏数> 　         将声明区段的变量置于指定的栏位。
-i<格数>或--indent-level<格数>                        设置缩排的格数。
-st或--standard-output                                将结果显示在标准输出设备。
-T 　                                                 数据类型名称缩排。
-ts<格数>或--tab-size<格数> 　                        设置tab的长度。
--use-tabs                                            使用tab来缩进

-npro或--ignore-profile               不要读取indent的配置文件.indent.pro。
-gnu或--gnu-style                     指定使用GNU的格式，此为预设值。
-kr或--k-and-r-style                  指定使用Kernighan&Ritchie的格式。
-orig或--original                     使用Berkeley的格式。

# [ -nbad | -bad ] 
-bad或--blank-lines-after-declarations 　     变量声明后加空行
-nbad或--no-blank-lines-after-declarations    在声明区段后不要加上空白行。
# [ -nbap | -bap ] 
-bap或--blank-lines-after-procedures 　       函数结束后加空行
-nbap或--no-blank-lines-after-procedures      函数结束后不加空行
# [ -nbbb | -bbb ] 
-bbb或--blank-lines-after-block-comments      在注释前加空行
-nbbb或--no-blank-lines-after-block-comments  在注释区段后不要加上空白行。
# [ -nbc | -bc ] 
-bc或--blank-lines-after-commas 　            在声明区段中，若出现逗号即换行。
-nbc或--no-blank-lines-after-commas           变量声明中，逗号分隔的变量不分行.
# [ -br | -bl] 
-br或–braces-on-if-line                       if(或是else,for等等)与后面执行跛段的”{“不同行，且”}”自成一行。
-bl或–braces-after-if-line                    if(或是else,for等等)与后面执行区段的”{“不同行，且”}”自成一行。
# [ -ncdb | -cdb ] 
-cdb或--comment-delimiters-on-blank-lines     注释符号自成一行。                     将单行注释变为块注释
-ncdb或--no-comment-delimiters-on-blank-lines 注释符号不要自成一行。
# [ -nce | -ce] 
-ce或--cuddle-else                            将else置于"}"(if执行区段的结尾)之后。
-nce或--dont-cuddle-else                      不要将else置于"}"之后。
# [ -nsc | -sc ]
-cs或--space-after-cast                       在cast之后空一格。
-ncs或--no-space-after-casts                  不要在cast之后空一格。
#  [ -ndj | -dj ]
# [ -ndj | -dj ] [ -nei| -ei ] [ -fa ] [ -nfa ] [ -nps | -ps ] [ -nslb | -slb ] 

# 注释
# [ -nfc1 | -fc1 ]
-fc1或--format-first-column-comments 　       针对放在每行最前端的注释，设置其格式。
-nfc1或--dont-format-first-column-comments    不要格式化放在每行最前端的注释。

-fca或--format-all-comments                   设置所有注释的格式。
-nfca或--dont-format-comments                 不要格式化任何的注释。
-d<缩排格数>或-line-comments-indentation<缩排格数>    针对不是放在程序码右侧的注释，设置其缩排格数。
# [ -nip | -ip ] 
-ip<格数>或--parameter-indentation<格数>      设置参数的缩排格数。
-nip或--no-parameter-indentation              参数不要缩排。
# [ -nlp | -lp ] 
-lp或--continue-at-parentheses                叙述过长而换行，且叙述中包含了括弧时，将括弧中的每行起始栏位内容垂直对其排列。
-nlp或--dont-line-up-parentheses              叙述过长而换行，且叙述中包含了括弧时，不用将括弧中的每行起始栏位垂直对其排列。
# [ -npcs | -pcs ] 
-pcs或--space-after-procedure-calls           在调用的函数名称与"{"之间加上空格。
-npcs或--no-space-after-function-call-names 　在调用的函数名称之后，不要加上空格。
# [ -npsl| -psl ] 
-psl或--procnames-start-lines         程序类型置于程序名称的前一行。
-npsl或--dont-break-procedure-type    程序类型与程序名称放在同一行。
# [ -nsc | -sc ] 
-sc或--start-left-side-of-comments    在每行注释左侧加上星号(*)。
-nsc或--dont-star-comments            注解左侧不要加上星号(*)。
# [ -nsob | -sob ]
-sob或--swallow-optional-blank-lines  删除多余的空白行。
-nsob或--leave-optional-semicolon     不用处理多余的空白行。

-ss或--space-special-semicolon        若for或swile区段今有一行时，在分号前加上空格。
-nss或--dont-space-special-semicolon  若for或while区段仅有一行时，在分号前不加上空格。

-v或--verbose 　                      执行时显示详细的信息。
-nv或--no-verbosity                   不显示详细的信息。
}

# find -name "*.c" | xargs indent -bap -bli0 -i4 -l79 -ncs -npcs -npsl -fca -lc79 -fc1 -ts4
CLang_indent_demo(){
[Stroustrup、Linux内核、BSD KNF] [Allman]      [GNU]                   [Whitesmiths]       [Ratliff]
while (x == y) {    | while (x == y)       | while (x == y)      | while (x == y)      | while (x == y) {
    something();    | {                    |   {                 |    {                |    something();
    somethingelse();|     something();     |     something();    |    something();     |    somethingelse();
}                   |     somethingelse(); |     somethingelse();|    somethingelse(); |    }
                    | }                    |   }                 |    }
                                                                 | 
indent,  # https://www.gnu.org/software/indent/manual/indent.txt
# -st 输出到标准输出; 不指定的情况下要省略mv这个操作
#将somefile.c的样式缩进成像BSD/Allman样式，然后将结果写到标准输出。
indent -st -bap -bli0 -i4 -l79 -ncs -npcs -npsl -fca -lc79 -fc1 -ts4 SomeFile.c

# Linux Kernel Coding Style
indent -kr -i8 -ts8 -sob -l80 -ss -bs -psl <file>

indent -kr -i4 -nut main.c
    -kr 选项表示采用 K&R 风格
    -i4 选项表示缩进 4 个空格
    -nut 选项表示不使用 tab 替换 4 个空格

# demo1
find . -name "*.c" | xargs indent -npro -kr -i4 -ts4 -sob -l120 -ss -ncs -cp1 --no-tabs
find . -name "*.h" | xargs indent -npro -kr -i4 -ts4 -sob -l120 -ss -ncs -cp1 --no-tabs
    
# Linux 内核格式 
 -nbad -bap -nbc -bbo -hnl -br -brs -c33 -cd33 -ncdb -ce -ci4
 -cli0 -d0 -di1 -nfc1 -i8 -ip0 -l80 -lp -npcs -nprs -npsl -sai
 -saf -saw -ncs -nsc -sob -nfca -cp33 -ss -ts8 -il1
# Berkeley 格式 (-orig)
-nbad -nbap -bbo -bc -br -brs -c33 -cd33 -cdb -ce -ci4 -cli0
-cp33 -di16 -fc1 -fca -hnl -i4 -ip4 -l75 -lp -npcs -nprs -psl
-saf -sai -saw -sc -nsob -nss -ts8
#  Kernighan & Ritchie style (-kr)
-nbad -bap -bbo -nbc -br -brs -c33 -cd33 -ncdb -ce -ci4 -cli0
-cp33 -cs -d0 -di1 -nfc1 -nfca -hnl -i4 -ip0 -l75 -lp -npcs
-nprs -npsl -saf -sai -saw -nsc -nsob -nss
#  GNU Emacs C style (-gnu)
-nbad -bap -nbc -bbo -bl -bli2 -bls -ncdb -nce -cp1 -cs -di2
-ndj -nfc1 -nfca -hnl -i2 -ip5 -lp -pcs -nprs -psl -saf -sai
-saw -nsc -nsob
# -i 不输出到标准输出; 指定的情况下要省略mv这个操作
sudo apt-get install clang-format-3.3
clang-format # LLVM, Google, Chromium, Mozilla, WebKit.
clang-format -style=llvm -dump-config > .clang-format
http://clang.llvm.org/docs/ClangFormat.html

cb, pslint, spellcheck
}

CLang_aspell_demo(){ cat - << 'EOF'
===============================================================================
checkword.sh  # 拼写检查与词典操作
#!/bin/bash

word=$1
grep "^$1$" /usr/share/dict/british-english -q
if [ $? -eq 0 ]; then
  echo $word is a dictionary word;
else
  echo $word is not a dictionary word;
fi
# 在grep中，^标记着单词的开始，$标记着单词的结束，-q表示禁止grep产生输出
===============================================================================
aspellcheck.sh # 拼写检查与词典操作
#!/bin/bash

word=$1
output=$(echo "$word" | aspell list)

if [ -z $output  ]; then
  echo $word is a dictionary word;
else
  echo $word is not a dictionary word;
fi

===============================================================================
# 当输入的不是一个词典单词时，aspell list命令会产生输出，否则不会产生任何输出
cat queue.h | aspell list --lang=en | sort | uniq

aspell check {{文件路径}}   # 为一个文件做拼写检查
cat {{文件}} | aspell list  # 列出来自标准输入的拼写错误单词
aspell dicts                # 列出可用的字典语言
aspell --lang={{cs}}        # 指定不同的语言（取 ISO 639 语言代码的 2 个字母）来运行 aspell
cat {{文件}} | aspell --personal={{个人单词列表.pws}} {{列表}} # 列出来自标准输入的拼写错误单词，并且忽略个人单词列表中的单词

aspell --lang=es create master ./list.pws < spanish_word_list  # spanish_word_list 为新字典(可编辑) ->list.pws 为不可编辑
mv list.pws /usr/lib/aspell/                                   # 移到特定位置
echo "add list.pws" >> /usr/lib/aspell/es.multi                # 追加到配置文件
aspell --lang=es                                               # 此时追加的内容就生效了
EOF
}

CLang_aspell_man(){
Commands:
<command> is one of:

usage, -?
    Send a brief Aspell Utility usage message to standard output.  This is a short summary listing more common spell-check commands and options.
help
    Send a detailed Aspell Utility help message to standard output.  This is a complete list showing all commands, options, filters and dictionaries.
version, -v
    Print version number of Aspell Library and Utility to standard output.
check <file>, -c <file>
    Spell-check a single file.
pipe, -a
    Run Aspell in ispell -a compatibility mode.
list
    Produce a list of misspelled words from standard input.
[dump] config
    Dump all current configuration options to standard output.
config <key>
    Send the current value of <key> to standard output.
soundslike
    Output the soundslike equivalent of each word entered.
munch
    Generate possible root words and affixes from an input list of words.
expand [1-4]
    Expands the affix flags of each affix compressed word entered.
clean [strict]
    Cleans an input word list so that every line is a valid word.
munch-list [simple] [single|multi] [keep]
    Reduce the size of a word list via affix compression.
conv <from> <to> [<norm-form>]
    Converts <from> one encoding <to> another.
norm (<norm-map>|<from> <norm-map> <to>) [<norm-form>]
    Perform Unicode normalization.

[dump] dicts|filters|modes
    Lists available dictionaries, filters, or modes.
dump|create|merge master|personal|repl <wordlist>
    dump, create, or merge a master, personal, or replacement word list.

Dictionary Options:
Checker Options:
Filter Options:
Run-Together Word Options:
Misc Options:
Aspell Utility Options:

}

CLang_spell_demo(){
":help vimspell"
:setlocal spell spelllang=en_us
]s 移动到光标之后下一个拼写有问题的单词。
[s 反向搜索
]S 类似于 "]s" 但只检查坏词，不检查偏僻词或其它区域的词。
[S 反向搜索

look    快速检查单词的拼写是否出错
aspell  交互式的拼写检查程序
aspell check --lang=en main.c
%.chk: %.md
	@aspell --home-dir=$(ROOT) --personal=$(KAZOO_DICT) --repl=$(KAZOO_REPL) --lang=en -x check $<
%.chk: %.json
	@aspell --home-dir=$(ROOT) --personal=$(KAZOO_DICT) --repl=$(KAZOO_REPL) --lang=en -x check $<
%.chk: %.erl
	@aspell --add-filter-path=$(ROOT) --mode=erlang --home-dir=$(ROOT) --personal=$(KAZOO_DICT) --repl=$(KAZOO_REPL) --lang=en -x check $<
%.chk: %.escript
	@aspell --add-filter-path=$(ROOT) --mode=erlang --home-dir=$(ROOT) --personal=$(KAZOO_DICT) --repl=$(KAZOO_REPL) --lang=en -x check $<

# Check style:
stylecheck:
	printf "weasel words: "
	sh ./scripts/weasel *.tex
	printf "\npassive voice: "
	sh ./scripts/passive *.tex
	printf "\nduplicates: "
	perl ./scripts/dups *.tex
	printf "\ndone\n"

# Check spelling with aspell
spellcheck:
	find . -name "*.tex" -exec aspell --lang=en --mode=tex --dont-suggest --personal=./.aspell.en.pws check "{}" \;

spell   批处理式的拼写检查程序
look [options] prefix [dictionary_file]
作用：打印以给定字符串prefix开头的单词，这些单词通常位于一个字典文件中(默认为/usr/share/dict/words)。
当你提供自己的字典文件(可以是任何文本文件，只要各行按字母顺序排序即可)时look命令将打印以给定字符串prefix开头的所有行
常用选项：
-f 忽略大小写

格式：aspell [options] file | command
作用：找出无法识别的单词，并给出相应的替代词
常用命令：
aspell -c file 通过交互方式对文件中的所有单词的拼写进行检查和纠正
aspell dump master 在标准输出上显示aspell的主字典
aspell help 打印一个简明的帮助信息
aspell --lang=en -c mytext

sudo apt install aspell-fr


格式：spell [files]
作用：输出给定文件中与其字典相比存在拼写错误的所有单词
}

CLang_CodingStyle(){
Linux Documentation/CodingStyle # https://www.kernel.org/doc/Documentation/zh_CN/CodingStyle
GNU Coding Standard             # http://www.gnu.org/prep/standards/standards.html
Uboot Coding Style              # http://www.denx.de/wiki/U-Boot/CodingStyle
Busybox Style Guide             # http://git.busybox.net/busybox/plain/docs/style-guide.txt

scripts/Lindent        # 内核格式化脚本
scripts/checkpatch.pl  # 更具实践性的不成文约定
scripts/cleanpatch
scripts/cleanfile

dir=$(pwd)
filelist=`find $dir -type f -name "*.c" -or -name "*.h"`

for file in $filelist
do
    astyle --style=ansi --indent=spaces=4 $file
done
}

CLang_cdecl_demo(){

# apt-get install cdecl
-------------------------------------------------------------------------------
cdecl> explain char * const *(*next)()
declare next as pointer to function returning pointer to const pointer to char

cdecl> explain int(*fun())
declare fun as function returning pointer to int

cdecl> explain int(*fun())()  #返回函数指针的 一个函数
declare fun as function returning pointer to function returning int

cdecl> explain int(*foo())[]  #返回指向int数组的指针的 一个函数
declare foo as function returning pointer to array of int

cdecl> explain int(*foo[])()  #函数指针数组
declare foo as array of pointer to function returning int
}

CLang_doxygen_intro(){
doxygen -g

OUTPUT_DIRECTORY。保存生成的文档文件的目录。
INPUT。这是一个以空格分隔的列表，其中包含必须为其生成文档的所有源代码文件和文件夹。
RECURSIVE。如果源代码列表是层次化的，就把这个字段设置为 YES。这样就不必在 INPUT 中指定所有文件夹，只需在 INPUT 中指定顶层文件夹并把这个字段设置为 YES。
EXTRACT_ALL。这个字段必须设置为 YES，这告诉 doxygen 应该从没有文档的所有类和函数中提取文档。
EXTRACT_PRIVATE。这个字段必须设置为 YES，这告诉 doxygen 应该在文档中包含类的私有数据成员。
FILE_PATTERNS。除非项目没有采用一般的 C 或 C++ 源代码文件扩展名，比如 .c、.cpp、.cc、.cxx、.h 或 .hpp，否则不需要在这个字段中添加设置。

OUTPUT_DIRECTORY = /home/tintin/database/docs
INPUT = /home/tintin/project/database
FILE_PATTERNS = 
RECURSIVE = yes
EXTRACT_ALL = yes
EXTRACT_PRIVATE = yes
EXTRACT_STATIC = yes
}
sudo_root_visudo(){ 允许非root用户使用sudo
root身份登录系统，执行'visudo'，根据示例添加新的一个规则(记住输入的密码是当前用户密码，而不是root密码)
#不需要密码执行sudo命令
hadoop        ALL=(ALL)       NOPASSWD: ALL

%wheel ALL = (ALL) ALL                              # 系统里所有wheel群组的用户都可用sudo 
%wheel ALL = (ALL) NOPASSWD: ALL                    # wheel群组所有用户都不用密码NOPASSWD 
User_Alias ADMPW = vbird, dmtsai, vbird1, vbird3    # 加入ADMPW组 
ADMPW ALL = NOPASSWD: !/usr/bin/passwd, /usr/bin/passwd [A-Za-z]*,  !/usr/bin/passwd root # 可以更改使用者密码,但不能更改root密码 (在指令前面加入 ! 代表不可
}

su_user_demo(){
#### sudo  授权许可使用的su ，也是受限制的su  
su -c ls root                             # 变更帐号为  root  并在执行  ls  指令后退出变回原使用者。 
su  -  root  -c "head - n 3 /etc/passwd"  # 对于命令参数要加上引号 
}
  
sudo_root_visudo(){ 允许非root用户使用sudo
root ALL=(ALL) ALL
#用户名 被管理主机的地址=(可使用的身份) 授权命令(绝对路径)
%wheel ALL=(ALL) ALL
#%组名 被管理主机的地址=(可使用的身份) 授权命令(绝对路径)

4 个参数的具体含义如下：
用户名/组名：代表 root 给哪个用户或用户组赋予命令，注意组名加"%"。
用户可以用指定的命令管理指定 IP 地址的服务器。如果写 ALL，则代表用户可以管理任何主机；如果写固定 IP，则代表用户可以管理指定的服务器。如果我们在这里写本机的 IP 地址，则不代表只允许本机的用户使用指定命令，而代表指定的用户可以从任何 IP 地址来管理当前服务器。
可使用的身份：就是把来源用户切换成什么身份使用，(ALL) 代表可以切换成任意身份。这个字段可以省略。
授权命令：代表 root 把什么命令授权给普通用户。默认是 ALL，代表任何命令，这当然不行，如果需要给哪个命令授权，则只需写入命令名即可。不过需要注意，一定要写绝对路径。
}
    
# /etc/sudoers  谁能作什么的一个列表，sudo能用需要在这个文件中定义
sudo_root_man(){ 为非根用户授予根用户的权限
配置文件：/etc/sudoers ; visudo命令编辑修改/etc/sudoers配置文件

别名类型包括如下四种：
  Host_Alias  定义主机名别名；
  User_Alias  用户别名，别名成员能够是用户，用户组(前面要加%号)
  Runas_Alias 用来定义runas别名，这个别名指定的是"目的用户"，即sudo 允许转换至的用户；
  Cmnd_Alias  定义命令别名；
  
  需要注意的是：
  1.在每一种Alias后面定义的别名 NAME 可以是包含大写字母、下划线连同数字，但必须以一个大写字母开头
  2.配置文件中的 Default env_reset 表示重置(就是去除)用户定义的环境变量，也就是说，当你用sudo执行一个命令的时候，你当前用户设置的所有环境变量都是无效的。
放权格式：
  授权用户/组    主机名=(允许转换至的用户)   NOPASSWD:命令动作
  红色标注的三个要素缺一不可，但在动作之前也能够指定转换到特定用户下，在这里指定转换的用户要用( )号括起来，
  假如无需密码直接运行命令的，应该加NOPASSWD:参数，不需要时方可省略，下面介绍中会有NOPASSWD的使用示例。

User_Alias SYSADER=beinan,linuxsir,%beinan
User_Alias DISKADER=lanhaitun
Runas_Alias OP=root
Cmnd_Alias SYDCMD=/bin/chown,/bin/chmod,/usr/sbin/adduser,/usr/bin/passwd [A-Za-z]*,!/usr/bin/passwd root(注意这里的!)
Cmnd_Alias DSKCMD=/sbin/parted,/sbin/fdisk 注：定义命令别名DSKCMD，下有成员parted和fdisk ；
   SYSADER  ALL= SYDCMD,DSKCMD
   DISKADER ALL= (OP) DSKCMD

注解：
第一行：定义用户别名SYSADER 下有成员 beinan、linuxsir和beinan用户组下的成员，用户组前面必须加%号；
第二行：定义用户别名DISKADER ，成员有lanhaitun
第三行：定义Runas用户，也就是目标用户的别名为OP，下有成员root
第四行：定义SYSCMD命令别名，成员之间用,号分隔，最后的!/usr/bin/passwd root 表示不能通过passwd 来更改root密码；
第五行：定义命令别名DSKCMD，下有成员parted和fdisk ；
第六行：表示授权SYSADER下的任何成员，在任何可能存在的主机名的主机下运行或禁止 SYDCMD和DSKCMD下定义的命令。
        更为明确遥说，beinan、linuxsir和beinan用户组下的成员能以root身份运行 chown 、chmod 、adduser、passwd，但不能更改root的密码；
        也能够以root身份运行 parted和fdisk ，
        本条规则的等价规则是；   
    beinan,linuxsir,%beinan ALL=/bin/chown,/bin/chmod,/usr/sbin/adduser,/usr/bin/passwd [A-Za-z]*,!/usr/bin/passwd root,/sbin/parted,/sbin/fdisk
第七行：表示授权DISKADER 下的任何成员，能以OP的身份，来运行 DSKCMD ，无需密码；更为明确的说 lanhaitun 能以root身份运行 parted和fdisk 命令；其等价规则是：
    lanhaitun ALL=(root) /sbin/parted,/sbin/fdisk
       如果我想不输入用户的密码就能转换到root并运行 SYDCMD 和 DSKCMD 下的命令，那应该把把NOPASSWD:加在哪里为好？参考下面例子；
    SYSADER ALL= NOPASSWD: SYDCMD, NOPASSWD: DSKCMD
        
        sudo !!  #以SUDO运行上条命令
        
        su - 直接将自身变为root用户，这个命令需要root用户口令
        sudo 则运行root的命令，由于sodu需要实现配置，且sudo需要输入用户自己的口令，也可以不输入
        # su 让你在不登出当前用户的情况下登录为另外一个用户
        su   # su 命令与 su -　前者在切换到 root 用户之后仍然保持旧的环境，而后者则是创建一个新的环境
             #(由 root 用户 ~/.bashrc 文件所设置的环境)，相当于使用 root 用户正常登录(从登录屏幕登录)。
             
%aixi           ALL=(ALL)       NOPASSWD: ALL  
%aixi           ALL=(ALL)       NOPASSWD: /bin/ls,/bin/mkdir,/bin/rmdir,/usr/bin/who ,!/usr/bin/passwd root
%代表用户组，
ALL=(ALL) 表示登录者的来源主机名，
最后的 ALL 代表可执行的命令。
NOPASSWD 代表不需要密码直接可运行Sudo,
限制多命令一定要写绝对路径，用逗号分开，多行用'\'，用!代表不能执行
             
}

ssh_X11Forwarding_xWindiws(){
Centos安装X window配置ssh X转发
先安装X Window环境：
#http://www.haiyun.me
yum groupinstall "X Window System"

配置SSH开启X转发：
cat /etc/ssh/sshd_config
X11Forwarding yes

/etc/ssh/sshd_config中激活以下设置：  
X11Forwarding yes
ssh -X 192.168.0.2 gimp  #远程访问你的程序
}

linux_ld_so_conf(){
添加某个路径到运行时库，一行一个path
vi /etc/ld.so.conf
/usr/local/lib/
(或者使用环境变量的方式，这种方向不需要root权限)
export LD_LIBRARY_PATH=/xxxxx:$LD_LIBRARY_PATH
}

linux_rename(){

centos下通过shell修改文件扩展名
find -type f|grep 'jpg'|xargs rename 's/\.jpg$/\.png/'  #批量重命名
rename <oldname> <newname> <*.files>
#将所有html扩展名改为htm扩展名
rename .html .htm   *.html
具体参考：http://www.cyberciti.biz/tips/renaming-multiple-files-at-a-shell-prompt.html
#通过mv也可以实现修改扩展名这个功能
mv goodYear.{htm,html}
}

file_union_intersect_difference(){
cat a b | sort | uniq > c   # c is a union b 并集
cat a b | sort | uniq -d > c   # c is a intersect b 交集
cat a b b | sort | uniq -u > c   # c is set difference a - b 差集
}

hostname_demo(){
hostname -i     # Display the IP address of the host. (Linux only)
hostname -fqdn  # domain
hostname -f     # Displays Fully Qualiﬁed Domain Name (FQDN) of the system
}

timeout_help_demo(){
  help timeout # timeout [OPTION] DURATION COMMAND [ARG]...
  timeout [-t SECS] [-s SIG] PROG [ARGS] 
  Runs PROG. Sends SIG to it if it is not gone in SECS seconds. Defaults: SECS: 10, SIG: TERM.
  
  timeout 10s ./script.sh                      # 在有限的时间内运行命令
  while true; do timeout 30m ./script.sh; done # 每30分钟重启一下./script.sh
  # 可用于端口扫描
  timeout 1 bash -c "echo >/dev/tcp/www.baidu.com/100" && echo "port $port is open" || echo "port $port is closed"  
}

echo >/dev/tcp/8.8.8.8/53 && echo "open" #检查远程端口是否对bash开放
echo -e #输出数据支持转移"\n\r\t\a\b"
openssl rand -hex n #产生随机的十六进制，其中n是字符位
ssh -vvv user@ip_address #SSH Debug模式
ssh -vvv user@ip_address #SSH Debug模式
ssh user@ip_address -i key.perm #SSH with perm key


xmllint -noout file.xml #检查xml格式
getent passwd #所有用户列表
pv data.log #shell里的进度条

lockfile #使文件只能通过rm -f移除
flock_man(){
    当多个进程可能会对同样的数据执行操作时,这些进程需要保证其它进程没有在操作,以免损坏数据.通常,这样的进程会使用一个"锁文件",也就是建立一个文件来告诉别的进程自己在运行,如果检测到那个文件存在则认为有操作同样数据的进程在工作.
    这样的问题是,进程不小心意外死亡了,没有清理掉那个锁文件,那么只能由用户手动来清理了.
    
    flock 是对于整个文件的建议性锁;也就是说如果一个进程在一个文件(inode)上放了锁,那么其它进程是可以知道的,(建议性锁不强求进程遵守)最棒的一点是,它的第一个参数是文件描述符,在此文件描述符关闭时,锁会自动释放;而当进程终止时,所有的文件描述符均会被关闭.于是,很多时候就不用考虑解锁的事情.

flock分为两种锁：
    一种是共享锁 使用-s参数
    一种是独享锁 使用-x参数

选项和参数：
-s  --shared：获取一个共享锁,在定向为某文件的FD上设置共享锁而未释放锁的时间内,其他进程试图在定向为此文件的FD上设置独占锁的请求失败,而其他进程试图在定向为此文件的FD上设置共享锁的请求会成功.
-x，-e，--exclusive：获取一个排它锁,或者称为写入锁,为默认项
-u，--unlock： 手动释放锁,一般情况不必须,当FD关闭时,系统会自动解锁,此参数用于脚本命令一部分需要异步执行,一部分可以同步执行的情况.
-n，--nb, --nonblock：非阻塞模式,当获取锁失败时,返回1而不是等待.
-w, --wait, --timeout seconds : 设置阻塞超时,当超过设置的秒数时,退出阻塞模式,返回1,并继续执行后面的语句.
-o, --close : 表示当执行command前关闭设置锁的FD,以使command的子进程不保持锁.
-c, --command command : 在shell中执行其后的语句.

<>打开${LOCK_FILE} (打开LOCK_FILE文件,与文件描述符101绑定),原因是定向文件描述符是先于命令执行的.因此假如在您要执行的语句段中需要读 LOCK_FILE 文件,例如想获得上一个脚本实例的pid,并将此次的脚本实例的pid写入 LOCK_FILE ,此时直接用>打开 LOCK_FILE 会清空上次存入的内容,而用<打开 LOCK_FILE 当它不存在时会导致一个错误.
http://www.netkiller.cn/shell/cli/flock.html
}

logrotate # 切换、压缩以及发送日志文件
shuf #文件中随机选择几行
gpg #加密并签名文件
list_child_dir(){
ls -F #在文件的后面多添加表示文件类型的符号
find ./ -type d -maxdepth 1 #过滤出已知当前目录下中的所有一级目录
ls -l  | grep ^d            #过滤出已知当前目录下中的所有一级目录
ls -F | grep /$             #过滤出已知当前目录下中的所有一级目录
ls -l | grep -v ^-          #过滤出已知当前目录下中的所有一级目录
tree -L 1 /                 #过滤出已知当前目录下中的所有一级目录

rm -i -f #-i表示删除过程进程询问；-f表示强制删除，不进行询问
}
readline_man(){ 
rpm -ql readline
ctrl-x ctrl-e # 外置编辑器 vim或者 emacs
              # export EDITOR=vim
}

man bash (HISTORY EXPANSION)
info history    # 命令行历史管理
info rluserman  # 命令编辑管理
info(){
                    # n(下一个)，p(前一个)，u(上一层)，h(帮助)，q(退出)
info                # 如何连接info系统
info info           # show the general manual for Info readers
info info-stnd      # show the manual specific to this Info program
info emacs          # start at emacs node from top-level dir
info emacs buffers  # start at buffers node within emacs manual
info --show-options emacs   # start at node with emacs' command line options
info --subnodes -o out.txt emacs  # dump entire manual to out.txt
info -f ./foo.info  # show file ./foo.info, not searching dir

帮助h 退出q 向前翻页:空格键 向前翻页:backspace  超级链接之间跳转:tab键 打开超级链接:enter 
} 

生成包关联图表
apt-cache dotty > debian.dot 
dotty debian.dot 

# -MPath 	更改 man 命令搜索手册信息的标准位置。 
# man 命令使用的搜索路径是一个由 :(冒号)隔开的包含手册子目录的目录列表。 MANPATH 环境变量值用作缺省路径。
man -M/usr/share/man:/usr/share/man/local ftp
man iptables | col -b | grep iptables
man iptables | col -b > iptables_man.txt
man hier 
man -k builtins # type      使用 type 命令寻找内置命令
                # which lso 在 bash 中寻找外部命令详细信息
apropos <editor>

ac_demo(){
打印连接时间记录
ac    #打印连接时间记录。
ac    #要获得在当前 wtmp 数据文件的使用期限内登录的所有用户的连接时间的打印输出
ac   smith jones #要获得用户 smith 和 jones 的总连接时间(记录在当前 wtmp 数据文件中)
ac   -p smith jones #要获得用户 smith 和 jones 的连接时间的小计
}
fc-list(){
查找系统中的中文字体
fc-list 查看素有字体
fc-list :lang=zh
}

fc-match(查看字体属于哪个文件){
fc-match -v "AR PL UKai CN"
}
LC_COLLATE_variable(){
按拼音排序
在.profile里加上
export LC_COLLATE="zh_CN.UTF-8"
}
tput_demo(){
查看当前终端是否支持256色
infocmp | grep color
tput colors
}
mktemp_demo(){
使用mktemp创建临时文件或目录
tmpdir=`mktemp -d`
trap "rm -rf '$tmpdir'" EXIT
1. 临时文件
mktemp                      # /tmp/tmp.p8p0v5YzPf
mktemp /tmp/test.XXX        # /tmp/test.d8J
mktemp /tmp/test.XXXXXX     # /tmp/test.cFebDX
mktemp /tmp/test.XXXXXXX    # /tmp/test.CnyLr7C
2. 临时目录
mktemp -d                                       # /tmp/tmp.xg5gFj0w8D
mktemp -d --suffix=.tmp /tmp/test.XXXXX         # /tmp/test.TDpz8.tmp
mktemp -d --suffix=.tmp -p /tmp deploy.XXXXXX   # /tmp/deploy.FwebCc.tmp
3. 仅生成文件名，不创建实际的文件或目录
tmpfile=`mktemp -u`
}
readlink_demo(){
取当前脚本路径
#  $(dirname '$(readlink -f "$0"))'

取当前脚本名称
if [ -s $BASH ]; then 
    file_name=${BASH_SOURCE[0]} 
elif [ -s $ZSH_NAME ]; then 
    file_name=${(%):-%x} 
fi
}

ip_mask2cdr(){

   # Assumes there's no "255." after a non-255 byte in the mask
   local x=${1##*255.}
   set -- 0^^^128^192^224^240^248^252^254^ $(( (${#1} - ${#x})*2 )) ${x%%.*}
   x=${1%%$3*}
   echo $(( $2 + (${#x}/4) ))
}


ip_cdr2mask(){

   # Number of args to shift, 255..255, first non-255 byte, zeroes
   set -- $(( 5 - ($1 / 8) )) 255 255 255 255 $(( (255 << (8 - ($1 % 8))) & 255 )) 0 0 0
   [ $1 -gt 1 ] && shift $1 || shift
   echo ${1-0}.${2-0}.${3-0}.${4-0}
}

gnuplot # sudo apt-get install gnuplot-x11
maxima  # sudo apt-get install maxima maxima-share

chsh_user_demo(){
chsh -l # cat /etc/shells
chsh -s /usr/bin/fish # fish作为登录shell
chsh -s /usr/bin/fish user_2 # user_2使用fish登录
}

pure_bash_bible(){
https://github.com/A-BenMao/pure-bash-bible-zh_CN
太过精巧，难以阅读
}

# let也可以使用(( ))进行替换，它们几乎完全等价。且额外的功能是：如果最后一个算术表达式结果为0，则返回状态码1，其余时候返回状态码0。
# 使用let、(())、$(())或$[]进行基本的整数运算，使用bc进行高级的运算，包括小数运算。其中expr命令也能进行整数运算，还能判断参数是否为整数，具体用法见expr命令全解。
bash_math(){
let i=16#ff
let j=8#37

1. 各种进制转换为十进制。
为变量赋值： ((var=base#number))
显示变量: echo $var
----------------------------------------
例:
((i=0xff10)); echo $i;
((i=32#qfg; echo $i;

2. 十进制转换为其它进制。
利用bc 计算器。
bc命令格式转换为：echo "obase=进制;值" | bc

printf "%d\n" 0x10
printf "%x\n" 100
awk -v c=109 'BEGIN { printf "%c\n", c;}'
### bc
factor #分解因子
echo "(6+3)*2" | bc               # 18 
echo "3+4;5*2;5^2;18/4" |bc       #  7 10  25 4
echo "scale=2;15/4" |bc           # 3.75
echo "ibase=16;A7" |bc            # 167
echo "ibase=2;11111111" |bc       # 252
echo "ibase=16;obase=2;B5-A4" |bc # 1001
bc calc.txt
### expr
expr 6 + 3    # 9
expr 2 \* 3   # 6  (有转义符号)
a=3
expr $a+5     # 3+5(无空格)
expr $a + 5   # 8 (有空格)
expr 'Hello World' : 'Hell\(.*\)rld'
expr length "abc" # 3
expr substr "abcdefgh" 2 3  # bcd
expr index "abcdef" cd  # 3    (从1开始计数)

### $(())  $[]
echo $((3+5))     # 8
$((5 + 2)) ; $((5 - 2)) ; $((5 * 2)) ; $((5 / 2)) ; $((5 % 2)) ; $((5 ** 2)) ;
((a=$a+1))     #add 1 to a
((a = a + 1))  #like above
((a += 1))     #like above
if (( a > 1 )); then echo "a is greater than 1"; fi
result=$((a + 1))
echo "The result of a + 1 is $((a + 1))"

x=2;y=3
echo $(($x+$y))   # 5
echo $x+$y | bc   # 5
echo $[$x+$y]     # 5
### let
let x=$x+1
echo $x     # 3
### awk
awk 'BEGIN{a=3+2;print a}'     # 5
awk 'BEGIN{a=(3+2)*2;print a}' #  10
}

Operations : +, add, -, sub, *, mul, /, div, %, mod, **, exp, and, or, not, eor, p -
dc_demo(){ 
逆波兰表达式
支持浮点运算
echo '2 3 + p' | dc
dc <<< '2 3 + p'
dc <<< '1 1 + p 2 + p'
dc <<< '_1 p'
dc <<< 'A.4 p'
c 清除压栈 d 复制栈顶的值 p 输出栈顶值 q 退出交互模式

dc <<< '4 3 / p'
dc <<< '2k 4 3 / p'
dc <<< '4k 4 3 / p'

dc << EOF
1 1 +
3 *
p
EOF
}
bc_demo(){
echo '2 + 3' | bc
echo '12 / 5' | bc
echo '12 / 5' | bc -l
echo '8 > 5' | bc
echo '10 == 11' | bc
echo '10 == 10 && 8 > 3' | bc
}

expr_usage(){
expr命令可以实现数值运算、数值或字符串比较、字符串匹配、字符串提取、字符串长度计算等功能。
它还具有几个特殊功能，判断变量或参数是否为整数、是否为空、是否为0等。
返回值: 0 表达式结果结果既不是0也不是null 
        1 表达式结果是0或者null
        2 表达是无效
        3 内部错误(算术运算除0)
字符表达式: match substr index length
数值表达式: + - * / %
关系表达式: | & < <= > >= == !=
1. 字符串表达式
------------------------- 
'expr'支持模式匹配和字符串操作。字符串表达式的优先级高于数值表达式和逻辑关系表达式。
'STRING : REGEX'
     执行模式匹配。两端参数会转换为字符格式，且第二个参数被视为正则表达式(GUN基本正则)，它默认会隐含前缀"^"。随后将第一个参数和正则模式做匹配。
     如果匹配成功，且REGEX使用了'\('和'\)'，则此表达式返回( '\('和'\)' )匹配到的。否则，返回当前匹配的位置。
     如果匹配失败，如果REGEX中使用了'\('和'\)'，则此表达式返回空字符串，否则，返回为0。
     只有第一个'\(...\)'会引用返回的值；其余的'\(...\)'只在正则表达式分组时有意义。
     在正则表达式中，'\+'，'\?'和'\|'分表代表匹配一个或多个，0个或1个以及两端任选其一的意思。
'match STRING REGEX'
     等价于'STRING : REGEX'。
     # 要输出匹配到的字符串结果，需要使用"\("和"\)"，否则返回的将是匹配到的字符串数量。
        expr abcde : 'ab\(.*\)' # cde
        expr abcde : 'ab\(.\)'  # c
        expr abcde : 'ab.*'     # 5
        expr abcde : 'ab.'      # 3
        expr abcde : '.*cd*'    # 4
        注意，由于REGEX中隐含了"^"，所以使得匹配时都是从string首字符开始的。
        expr abcde : 'cd.*'     # 0
'substr STRING POSITION LENGTH'
    返回STRING字符串中从POSITION开始，长度最大为LENGTH的子串。如果POSITION或LENGTH为负数，0或非数值，则返回空字符串。
        expr substr abcde 2 3   # bcd
        expr substr abcde 2 4   # bcde
        expr substr abcde 2 5   # bcde
        expr substr abcde 2 0
        expr substr abcde 2 -1
'index STRING CHARSET'
    CHARSET中任意单个字符在STRING中最前面的字符位置。如果在STRING中完全不存在CHARSET中的字符，则返回0。见后文示例。
        从string中搜索chars中某个字符的位置，这个字符是string中最靠前的字符。
        expr index abcde dec    # 3
        expr index abcde xdc    # 3
        如果chars中的所有字符都不存在于string中，则返回0。
        expr index abcde 1      # 0
        expr index abcde 1x     # 0
 'length STRING'
    返回STRING的字符长度。
    该表达式是返回string的长度，其中string不允许为空，否则将报错，所以可以用来判断变量是否为空。
        expr length abcde   #5
        expr length 111     # 3
        expr length $xxx    # expr: syntax error
        if [ $? -ne 0 ];then echo '$xxx is null';fi # $xxx is null
'+ TOKEN'
     将TOKEN解析为普通字符串，即使TOKEN是像MATCH或操作符"/"一样的关键字。这使得'expr length + "$x"'或'expr + "$x" : '.*/\(.\)''可以正常被测试，即使"$x"的值可能是'/'或'index'关键字。这个操作符是一个GUN扩展。
     通用可移植版的应该使用'" $token" : ' \(.*\)''来代替'+ "$token"'。
   要让expr将关键字解析为普通的字符，必须使用引号包围。
   # 将任意token强制解析为普通字符串。
        expr index index d     # expr: syntax error
        expr index length g    # expr: syntax error
        expr index + length g  # 4
    其实可以通过字符串匹配的方式，将关键字转换为字符串。例如：
        expr index 'length : "\(length\)"' g    # 4
    对值为关键字的变量来说，则无所谓。
        len=lenght
        expr index $len g       # 4
2. 算术表达式
-------------------------- 
'expr'支持普通的算术操作，算术表达式优先级低于字符串表达式，高于逻辑关系表达式。
'+ -'
     加减运算。两端参数会转换为整数，如果转换失败则报错。
'* / %'
     乘，除，取模运算。两端参数会转换为整数，如果转换失败则报错。
     
     # 任意操作符两端都需要有空格，否则：
        a=1
        expr 4+$a   # 4+3
        expr 4 +$a  # expr: syntax error
        expr 4 + $a # 5
3. 逻辑关系表达式
--------------------------- 
'expr'支持普通的逻辑连接和逻辑关系。它的优先级最低。
'|'
        如果第一个参数非空且非0，则返回第一个参数的值，否则返回第二个参数的值，但要求第二个参数的值也是非空或非0，否则返回0。
     如果第一个参数是非空或非0时，不会计算第二个参数。
'&'
     如果两个参数都非空且非0，则返回第一个参数，否则返回0。如果第一个参为0或为空，则不会计算第二个参数。
'< <= = == != >= >'
     比较两端的参数，如果为true，则返回1，否则返回0。"=="是"="的同义词。"expr"首先尝试将两端参数转换为整数，并做算术比较，如果转换失败，则按字符集排序规则做字符比较。
括号'()'可以改变优先级，但使用时需要使用反斜线对括号进行转义。
    这些操作符会首先会将两端的参数转换为数值，
    如果转换成功，则采用数值比较，
    如果转换失败，则按照字符集的排序规则进行字符大小比较。
    比较的结果若为true，则expr返回1，否则返回0。
        a=3
        expr $a = 1        # 0
        expr $a = 3        # 1
        expr $a \* 3 = 9   # 1
        expr abc \> ab     # 1
        expr akc \> ackd   # 1
}
kernel_compiling(){
fakeroot debian/rules clean
sudo apt-get build-dep linux-image-`uname -r`

cd /usr/src/linux
make mrproper         # Clean everything, including config files
make oldconfig        # Reuse the old .config if existent
make menuconfig       # or xconfig (Qt) or gconfig (GTK)
make                  # Create a compressed kernel image
make modules          # Compile the modules
make modules_install  # Install the modules
make install          # Install the kernel
reboot
}
hacker_intro(){
1：检查不是由你运行的程序
ps aux | grep -v $(whoami)                    #检查不是由你运行的程序
ps aux--sort=-%cpu | grep -m 11 -v $(whoami)  #列出最占用时间的前十个程序呢：
2：在多个文件中替换掉相同的文本
如果你有个文件，想在多个位置进行替换，这里有很多方法来实现。调用test[someting]把当前目录里所有文件中的Windows替换成Linux，你可以像这样运行它：
perl -i -pe 's/Windows/Linux/;' test*
要替换当前目录以及下层目录里所有文件中的Windows为Linux，你可以这样运行：
find . -name '*.txt' -print | xargs perl -pi -e's/Windows/Linux/ig' *.txt
或者如果你更需要让它只作用于普通文件上： 
find -type f -name '*.txt' -print0 | xargs --null perl -pi -e 's/Windows/Linux/'
3：合并一个不稳定的终端
reset
4. 创造Mozilla关键词
应用程序：Firefox/Mozilla
在浏览器上的一个有用的特征是，它们有一种能力，可以通过输入gg onion来通过Google搜索onion这个词的一切。同一功能在Mozilla上也可实现，通过单击Bookmarks(书签)>Manage Bookmarks(管理书签)然后添加一个新的书签，添加的URL就像这样：
    http://www.google.com/search?q=%s 
现在选择书签编辑器中的条目并且点击Properties(属性)按钮，现在输入一个类似gg的关键字(或者可以是你选择的任何字符)就行了。在URL中的%s将被关键字之后的文本内容替代。你可以用这种方法向其他一些依赖你当前URL信息的网站发送请求。
5. 运行多种X会话
如果你给别人分享了你的Linux box()，而厌烦了不断的登入、登出，当你知道了这不是必要的时候，可能会如释重负。假设你的电脑以图形模式启动(runlevel 5)，通过同时按下Control+Alt+F1键-你将得到一个登陆提示。输入你的登录名以及密码然后执行：
    startx -- :1 
来进入你的图形环境。按下Ctrl+Alt+F7来回到在你之前的用户会话，如果想回到你自己的用户会话则按下Ctrl+Alt+F8。
你可以重复使用这项技巧：F1键到F6键可以识别六个控制台会话，而F7到F12可以识别六个X会话。警告：尽管这在多数情况下是适用的，但是不同的变种可能用不同的方式来实现这项功能。
6. 简单地备份你的网站
如果你想要从一台电脑上备份一个目录，但你仅仅想要复制改变的文件到它的备份而不是复制所有的东西到各自的备份，你可以使用工具rsync来实现它。你需要在这个远程的源备份计算机上有一个账户。下面是这条命令：
    rsync -vare ssh jono@192.168.0.2:/home/jono/importantfiles/* /home/jono/backup/ 
这样我们就备份了192.168.0.2地址上/home/jono/importantfiles/目录下的所有文件到当前机器上的/home/jono/backup目录下。
7. 使你的时钟保持准时
ntpdate ntp.blueyonder.co.uk
8. 消除二进制suid
find / -perm +6000 -type f -exec ls -ld {} \; > setuid.txt & 
chmod a-s program 
9. 停止回应ping
sysctl -w net.ipv4.icmp_echo_ignore_all=1
10. 降低ping速率
sysctl -w net.ipv4.icmp_echoreply_rate=10
}

dns_intro(){

A(Address) 记录
是用来指定主机名(或域名)对应的 IP 地址记录. 用户可以将该域名下的网站服务器指向到自己的 web server 上. 同时可以设置您域名的二级域名.

# CNAME(Canonical Name) 记录
CNAME 记录也被称为规范名字, 通常称别名指向可以将注册的不同域名统统转到一个主域名上去, 与 A 记录不同的是, CNAME 别名记录设置的可以是一个域名的描述而不一定是IP地址.

# NS(Name Server) 记录
是域名服务器记录, 用来指定该域名由哪个 DNS 服务器来进行解析. 您注册域名时, 总有默认的 DNS 服务器, 每个注册的域名都是由一个 DNS 域名服务器来进行解析的, DNS 服务器 NS 记录地址一般以以下的形式出现:
ns1.domain.com
ns2.domain.com

# MX 记录
是邮件交换记录, 它指向一个邮件服务器, 用于电子邮件系统发邮件时根据收信人的地址后缀来定位邮件服务器.
TXT 记录
一般指为某个主机名或域名设置的说明

# AAAA 记录
是一个指向 IPv6 地址的记录. 可以使用 nslookup -qt= 来查看 AAAA 记录.
AX 记录和 CNAMEX 记录
是私有记录类型, 用来提供同一线路中的任意比率的负载均衡策略, 实际解析时会转化为 A 记录和 CNAME 执行.

# SRV 记录
它是 DNS 服务器的数据库中支持的一种资源记录的类型, 它记录了哪台计算机提供了哪个服务这么一个简单的信息.
记录值格式为: 优先级 权重 端口 主机名
主机名必须以 "." 结尾. 例如: 0 8 8080 srv.example.com.

# 301 跳转
被请求的资源已永久移动到新位置, 并且将来任何对此资源的引用都应该使用本响应返回的若干个 URI 之一.
如果可能, 拥有链接编辑功能的客户端应当自动把请求的地址修改为从服务器反馈回来的地址. 除非额外指定, 否则这个响应也是可缓存.

# 302跳转
请求的资源现在临时从不同的 URI 响应请求. 由于这样的重定向是临时的, 客户端应当继续向原有地址发送以后的请求.
只有在 Cache-Control 或 Expires 中进行了指定的情况下, 这个响应才是可缓存的.

# 隐式跳转
隐式跳转, 用 FRAME 的形式, 调用跳转地址, 达到隐藏跳转地址目的.

# SOA
SOA, 即 Start Of Authority, 放在 zone file 中, 用于描述这个 zone 负责的 name server, version number... 等资料, 以及当 slave server 要备份这个 zone 时的一些参数.
每个 zone file 中必须有且仅有一条 SOARR, 并在 zone file 中作为第一条资源记录保存.
}

dig_man_demo(){
域信息搜索器 TOLRN
dig www.sina.com # 查询从www.sina.com的域名服务器返回的信息。
dig google.cn +trace # 根服务器开始追踪域名google.cn的解析过程
dig -x 61.186.154.175  # 对地址61.186.154.175进行逆向查询。
dig -x www.baidu.com                # 解析域名IP
dig +trace -t A 域名                # 跟踪dns
dig +short txt hacker.wp.dg.cx      # 通过 DNS 来读取 Wikipedia 的hacker词条
dig    # dig也是一个很强大的命令，相对host来说输出较为繁杂
dig google.com MX | grep '^;; ANSWER SECTION:' -A 5 # 查询MX记录
dig google.com SOA | grep '^;; ANSWER SECTION:' -A 1 # 查询SOA记录
dig www.baidu.com @8.8.8.8 # 指定DNS Server查询
dig -x 74.125.135.105      # dig反解析-x

dig @server domain query-type query-class
dig [@server] [-b address] [-c class] [-f filename] [-k filename] [ -n ][-p port#] [-t type] [-x addr] [-y name:key] [name] [type] [class] [queryopt...]
server      可为域名或者以点分隔的Internet地址.  如果省略该可选字段, dig 会尝试使用你机器的默认域名服务器.
domain      是指一个你请求信息的域名. -x 选项以获知指定反向地址查询的便捷方法.
query-type  是指你所请求的信息类型(DNS查询类型).  如果省略,默认为"a"(T_A = address).  以下类型是可识别的:
    a       T_A        网络地址
    any     T_ANY      所有/任何与指定域相关的信息
    mx      T_MX       该域的邮件网关
    ns      T_NS       域名服务器
    soa     T_SOA      区域的授权记录
    hinfo   T_HINFO    主机信息
    axfr    T_AXFR     区域传输记录(必须是询问一台授权的服务器)
    txt     T_TXT      任意的字符串信息
query-class 是指在查询中请求的网络等级.如果省略,默认为 "in" (C_IN = Internet).  以下的等级是可识别的:
    in      C_IN       Internet等级的域
    any     C_ANY      所有/任何等级的信息
+[no]trace
切换为待查询名称从根名称服务器开始的代理路径跟踪。缺省情况不使用跟踪。一旦启用跟踪，dig 使用迭代查询解析待查询名称。
    它将按照从根服务器的参照，显示来自每台使用解析查询的服务器的应答。
+[no]stats
    该查询选项设定显示统计信息：查询进行时，应答的大小等等。缺省显示查询统计信息。
}
nslookup_intro(){
nslookup www.moon.com               # 解析域名IP
注：如果在用户主目录 的 .nslookuprc 文件指定， set 子命令的 domain、srchlist、defname、和 search 选项能影响非交互式命令的行为。
set Keyword[=Value]
type=Value 	更改信息查询为下列值之一。缺省值是 A。
A       主机的因特网地址 
ANY     任何可用的选项。 
CNAME   为别名规范名称 
HINFO   主机 CPU 和操作系统 
KEY    安全性密钥记录 
MINFO  邮箱或邮件列表信息 
MX    邮件交换器 
NS   为指定区域的命名服务器 
PTR  如果查询因特网地址则指向主机名；否则，指向其它信息 
SIG 特征符记录 
SOA 域的"start-of-authority"信息 
TXT 文本信息 
UINFO 用户信息 
WKS 支持众所周知的服务
}
wireshark_intro()}{
wireshark -f tcp port 23 and host 192.168.1.102 # 捕捉来自主机192.168.1.102的telnet通信数据
wireshark -f tcp port 23 and not src host 192.168.1.102 # 捕捉所有不是来自主机192.168.1.102的telnet通信数据。
}
ipcalc_intro(){
Usage: ipcalc [OPTION...]
  -c, --check         Validate IP address for specified address family
  -4, --ipv4          IPv4 address family (default)
  -6, --ipv6          IPv6 address family
  -b, --broadcast     Display calculated broadcast address
  -h, --hostname      Show hostname determined via DNS
  -m, --netmask       Display default netmask for IP (class A, B, or C)
  -n, --network       Display network address
  -p, --prefix        Display network prefix
  -s, --silent        Do not ever display error messages

ipcalc [参数] [/前缀] [掩码] 
ipcalc  [-n|-h|-v|-help] <ADDRESS>[[/]<NETMASK>] [NETMASK]
ipcalc 192.168.0.1/24
ipcalc 192.168.0.1/255.255.128.0
ipcalc 192.168.0.1 255.255.128.0 255.255.192.0
ipcalc 192.168.0.1 0.0.63.255

ipcalc -b 192.168.1.1 255.255.255.0
ipcalc -n 192.168.1.1 255.255.255.0
ipcalc -h 192.168.1.1
ipcalc -pnb 192.168.1.1 255.255.255.0
}

du_intro(){ directory usage
-s, --summarize
-h, --human-readable
-c, --total
1. Default size
包含和递归
du    # 递归显示所有目录大小
du -a # 递归显示所有目录大小和文件大小 -> both files and directories
du -s # 显示当前所有目录大小和文件大小 -> without descending into its sub-directories
du -S # 显示当前所有目录大小
2. Various size formats
stat -c %s words.txt
du -b words.txt # byte
du -sk projs    # kilobyte
du -sm projs    # metabyte
du -B projs     # custom byte scale size
du -sh projs/* words.txt # human readable
du -sk projs/* | sort -nr # 排序
du -hs /home/* | sort -k1,1h
du -sh -- *               # the cumulative disk usage of all non-hidden directories, files etc in the current directory in human-readable format.

du -cshD projs py_learn # -c to also show total size at end
du -Sh -t 15M           # -t to provide a threshold comparison

du -h --max-depth=1 | sort -hr  # 深度

过滤
du -ah -d1 projs                   # 目录深度过滤
du -ah --exclude='*addr*' projs    # 包含文件选择
du -ah --exclude='*.'{v,log} projs # 包含文件选择

固定字节倍数和设定字节倍数
du -b words.txt
du -sB 5000 projs     # 指定5000个字节倍数
du -sB 1048576 projs  # 指定1048576个字节倍数
du -sk projs          # KB 1000倍数
du -sm projs          # MB 1000000倍数
du -sh projs/* words.txt # 人可读性 1024倍数
按照字节数而不是占用磁盘空间大小
du -b words.txt
du -h words.txt
包含链接文件与否
du py_learn
du -shD py_learn   # 包含链接文件
du -sh 
du -sh *           # 当前目录下所有文件大小
du -sh .[!.]* *
du -sch .[!.]* *
du -shL            # 包含链接文件
}

pidof_demo(){
pidof -c -m -o $$ -o $PPID -o %PPID -x "$1"
pidof -c -m -o $$ -o $PPID -o %PPID -x "${1##*/}"
该函数使用了pidof命令，获取给定进程的pid值会更加精确，其中使用了几个-o选项，它用于忽略指定的pid
    -o $$表示忽略当前shell进程PID，大多数时候它会继承父shell的pid，但在脚本中时它代表的是脚本所在shell的pid
    -o $PPID表示忽略父shell进程PID
    -o %PPID表示忽略调用pidof命令的shell进程PID
}
unix_skill(){
Linux小技巧
du --block-size=kB | sort -n   #目录size从小到大列举目录
du --block-size=kB | sort -nr  #目录size从大到小列举目录
--max-depth=1  #设置显示深度  du -h --max-depth=1

ps -A --sort -rss -o pid,comm,pmem,rss | less #命令可以显示系统的内存使用

ls -l -S *.d                 # 按文件size从大到小列举文件
ls -l -S *.d | sort  -k 5 -n # 按文件size从小到大列举文件

for p in $(pidof init); do echo "PID # $p has $(lsof -n -a -p $p|wc -l) fd opened."; done #命令打印process进程打开的文件数目。

nmap --reason ip-address # nmap --reason 192.168.23.150 显示当前IP地址上端口的状态及原因。
ss -o state established '( dport = :protocol or sport = :protocol )' #显示指定网络协议的所有连接
# ss -o state established '( dport = :ssh or sport = :ssh )'
lsof -u user | wc -l #@命令可以显示user用户打开的文件数

find folder -type f -ctime -n -print #命令可以显示folder文件夹下最近n天修改过的文件。
ls -ltrF --color | grep ^d           # 
/usr/bin/time -f 'rss=%Mk etime=%E user=%U sys=%S in=%I out=%O' command #命令可以度量执行一个命令花费的时间，占用的内存，文件I/O等参数

# 为搜索出来的字符串加上颜色
grep --color [Cat] <<<"nixCraft" # 可以使用"--color"选项为grep查找出来的字符串着色
egrep --color -i 'Mon' ./scan.txt #

grep "$(date +%b\ %e)" /var/log/syslog # 命令只查看今天的日志信息：
du -hsx * | sort -rh | head -n 1       # 打印当前目录下占磁盘空间最多的n个文件
mount | column -t　 # 使用column -t命令可以用表格化方式显示输出
cat -n /file # 可以显示文本文件内容的行号 等同于cat file |　nl
cat file1 file2 | grep word | wc -1 #列出两个文件的内容.执行对输出的搜索.统计结果行的个数
free -m | tee mem1.log mem2.log # 可以使用tee命令把命令输出到多个日志文件
fuser -k port/tcp(udp) #在Linux平台上kill占用某端口进程命令：
ps -ef | grep redis # -e 为显示所有程序 -f 显示进程中的更多属性，包括UID、PPID等

fuser -k 6379/tcp # 使用一个端口杀死程序
fuser -va 22/tcp  # 列出使用端口22的进程
fuser -va /home   # 列出访问 /home 分区的进程

findpid tail # 显示运行进程的PID

shell中文本内容多行变一行的技巧
xargs < 5201351.txt                           # 
cat 5201351.txt |xargs                        # 方法一、通过xargs命令完成
a=$(cat 5201351.txt);echo $a                  # 方法二、整个文件读入一个变量，然后直接打印
sed -n '1h;1!H;${g;s/\n/ /g;p;}' 5201351.txt  # 方法三、使用sed把文件读入保持空间，到最后一行时，替换换行符为空格符
paste -d " " -s < 5201351.txt                 # 
cat 5201351.txt | paste -d " " -s             # 方法四、使用paste命令格式化打印，-d指定分隔符，-s表示合并成一行
}

findpid_example() { ps axc|awk "{if (\$5==\"$1\") print \$1}"; } # 在Bash中定义如下函数(函数参数为程序名)：

考虑使用 mosh 作为 ssh 的替代品，它使用 UDP 协议。它可以避免连接被中断并且对带宽需求更小，但它需要在服务端做相应的配置。

ssh_direct_redirect_proxy(){
使用ssh正向连接、反向连接、做socks代理的方法
用ssh做正向连接 ~
    说明： client连上server，然后把server能访问的机器地址和端口(当然也包括server自己)镜像到client的端口上。
    命令： $ ssh -L [客户端IP或省略:][客户端端口]:[服务器侧能访问的IP:][服务器侧能访问的IP的端口] 登陆服务器的用户名@服务器IP -p [服务器ssh服务端口(默认22)]
           其中，客户端IP可以省略，省略的话就是127.0.0.1了，也就是说只能在客户端本地访问。服务器IP都可以用域名来代替。
    举例： >
           你的IP是192.168.1.2，你可以ssh到某台服务器8.8.8.8，8.8.8.8可以访问8.8.4.4，你内网里还有一台机器可以访问你。
           如果你想让内网里的另外一台电脑访问8.8.4.4的80端口的http服务，那么可以执行：
           ssh -L 192.168.1.2:8080:8.8.4.4:80 test@8.8.8.8
           也就是说，ssh到8.8.8.8上，然后让8.8.8.8把8.8.4.4的80端口映射到本地的8080端口上，而且和本地192.168.1.2这个IP绑定。
           内网里的另外一台机器可以通过IE浏览器中输入http://192.168.1.2:8080查看8.8.4.4的网页。
           当然，如果是其他服务，比如ftp、ssh、远程桌面也是可以的。不过，VPN貌似是不行的，可能是因为GRE协议无法通过。

用ssh做反向连接 
    说明： client连上server，然后把client能访问的机器地址和端口(也包括client自己)镜像到server的端口上。
           反向连接用得可能更多一些。比如你的客户端在内网，在外网是无法直接访问到的，这时用反向连接打通一条隧道，就可以从外网通过这条隧道进来了。
    命令： $ ssh -R [服务器IP或省略:][服务器端口]:[客户端侧能访问的IP:][客户端侧能访问的IP的端口] 登陆服务器的用户名@服务器IP -p [服务器ssh服务端口(默认22)]
           其中，服务器IP如果省略，则默认为127.0.0.1，只有服务器自身可以访问。指定服务器外网IP的话，任何人都可以通过[服务器IP:端口]来访问服务。
           当然，这个时候服务器本机也要输入外网IP:端口来访问。
    举例： 
           你的IP是192.168.1.2，你可以ssh到外网某台服务器8.8.8.8，你内网里有一台机器192.168.1.3。
           如果你想让外网所有的能访问8.8.8.8的IP都能访问192.168.1.3的http服务，那么可以执行：
           ssh -R 8.8.8.8:8080:192.168.1.3:80 test@8.8.8.8
           也就是说，ssh到8.8.8.8上，然后把本地局域网内192.168.1.3的80端口映射到8.8.8.8的8080端口上，
           这样外网任何一台可以访问8.8.8.8的机器都可以通过8080端口访问到内网192.168.1.3机器的80端口了。
           反向连接同样支持各种服务。

用ssh做socks代理 
    说明： 假设你内网里某台机器可以上网，但是你不能上网，如果你有ssh到那台机器的权限，那么就可以利用ssh方式建立一个代理socks5，通过代理来上网。
    命令： $ ssh -D [本地IP或省略:][本地端口] 登陆服务器的用户名@服务器IP -p [服务器ssh服务端口(默认22)]
           道理和上面是一样的，执行这个命令之后，本地会监听指定的端口等待连接。
           在配置代理的时候直接选择Sock5就可以了，不需要用户名和密码验证。
           windows系统代理配置方法：Internet选项->连接->局域网设置：勾选为LAN使用代理服务器，然后任何字段都不要填，点"高级"按钮，在套接字里面填好相应的配置，其他都留空。
           一个叫做Sockscap的软件，把应用扔进去就能以代理的方式上网了。
如果你想把socks代理转换成http代理，可以用privoxy这个东东。
}
ssh_intro(){
    SSH 协议正是这样做的：它通过非对称加密方法(公钥加密方法)，在预先交换公钥的前提下，通信双方通过对方的公钥加密信息，
而使用自身私钥解开密文。如此一来，若是能保证密钥交换的可信，则基于非对称加密方案的加密信道就是安全的。

当本机发起登录请求时，SSH 会依次执行以下几个主要步骤：
    1. 通过远程主机公钥 hash，确认远程主机身份；
    2. 若通过，远程主机验证登录身份，例如：提示输入远程主机目标用户的口令；
    3. 本地主机将用户键入的口令，使用远程主机的公钥加密，并发送给远程主机；
    4. 远程主机使用上述公钥对应的私钥，对得到的密文进行解密；
    5. 远程主机验证解密后的口令；
    6. 若通过，则建立 SSH 连接，成功登录。
https://liam0205.me/2017/09/12/rescue-your-life-with-SSH-config-file/
}
ssh_no_passwd(){ 无密码的ssh 用以验证客户端的安全性 -> 将客户端生成的公钥传至指定服务器
---------------------------------------
1.Client上某用户执行ssh-keygen命令，生成建立安全信任关系的证书
ssh-keygen -b 1024 -t rsa
2.将公钥证书id_rsa.pub内容复制到Server某用户的~/.ssh/authorized_keys目录中
## 方法1
scp -p ~/.ssh/id_rsa.pub  [username]@[server_ip]:[user_home]/.ssh/authorized_keys
## 方法2
client: cat ~/.ssh/id_rsa.pub #然后复制它
server: vim ~/.ssh/authorized_keys #然后粘贴保存
3.完成
---------------------------------------
#设置rsa以后连接时，不需要再输入密码
ssh-keygen                 #产生密钥对
ssh-copy-id -i <sshhostip> #输入相应登录密码后，将放置对方 /.ssh/authorized_keys中

    出现ssh连接"Host key verification failed ... The authenticity of host can't be established"
vim /etc/ssh/ssh_config
  StrictHostKeyChecking no
  UserKnownHostsFile /dev/null
---------------------------------------  有关加密
对称加密(机密性)：des 3des aes rc4/5；算法简单，适合大量加密
单向加密(完整性)：md5 sha1 sha2；算法简单，不占用计算资源。又称哈希加密，具有不可逆，定长输出，雪崩效应，对应的shell命令有md5sum sha1sum sha224sum等
非对称加密(身份认证，密钥传输)：rsa dsa；不适合大量加密，有公钥和私钥，公钥是私钥中的一部分
        身份认证：自己用私钥加密，发送给他人，他人用公钥解密，可保证发送人的身份有效，又称数字签名
        密钥传输：他人用公钥加密 对称加密用的密钥，传输给具有私钥的人，保证密钥不被窃取
                还可以使用密钥交换，又称IKE技术(dh算法)
}

tftpd_demo(){
tftpd [-cr] [-u USER] [DIR] 
Transfer a file on tftp clients request tftpd should be used as an inetd service. 
tftpd line for inetd.conf: 69 dgram udp nowait root tftpd tftpd /files/to/serve 
It also can be ran from udpsvd: 

udpsvd -vE 0.0.0.0 69 tftpd /files/to/serve 
Options: 
  -r Prohibit upload 
  -c Allow file creation via upload 
  -u Access files as USER
}

tftp [OPTIONS] HOST [PORT] 
Transfer a file from/to tftp server 
Options: 
  -l FILE Local FILE 
  -r FILE Remote FILE 
  -g Get file 
  -p Put file 
  -b SIZE 
Transfer blocks of SIZE octets

tftp -i ip-address-of-tftp-server get toolname.exe 	Retrive a file from your TFTP server onto the local machine.
tftp -i ip-address-of-tftp-server put somefiletoupload.txt 	Send a file from the local machine to your TFTP server.

tftp_client(){
yum install *tftp* -y
vim /etc/xineted.d/tftp

其中server_args = -s /var/lib/tftpboot表示下载的目录，-s表示能下载，-c表示能上传
其中disable = yes改成no表示开启服务

为了防止权限问题，可执行
chmod 777 /var/lib/tftpboot -R

chkconfig tftp on       #未修改配置的启动方式
service xineted restart #修改过配置文件后启动方式

如果怕安全机制影响，可执行
service iptables stop  #关闭防火墙
setenforce 0           #关闭SElinux

tftp <ip>       #进入命令提示符
 > get <file>   #指定名字，默认下载到当前目录
 > put <file>   #默认上传当前目录中文件
}
lftp_script(){
lftp -u user,password sftp://csu_ip 
<<EOF 
cd remote_directory 
lcd local_directory 
put file_name1 
get file_name2 
bye 
EOF
}
dhcp_server_demo(){
18935593994
yum install -y dhcp

vim /etc/dhcp/dhcpd.conf
 
subnet 172.24.40.0 netmask 255.255.255.0{
    range 172.24.40.100 172.24.40.200;
    option routers 172.24.40.254;             #getway
    option domain-name "uplooking.com";
    option domain-name-servers 202.106.0.46;  #dns
}

/etc/init.d/dhcpd start

dhclient eth0
}
chmod_user_man(){
变更文件或目录的权限
模式：'[ugoa]*([-+=]([rwxXst]*|[ugo]))+|[-+=][0-7]+'
用法：chmod [选项]... 模式[,模式]... 文件...
　或：chmod [选项]... 八进制模式 文件...
　或：chmod [选项]... --reference=参考文件 文件...
有关权限代号的部分，列表于下： 
　r：读取权限，数字代号为"4"。 
　w：写入权限，数字代号为"2"。 
　x：执行或切换权限，数字代号为"1"。 
　-：不具任何权限，数字代号为"0"。
  -c或--changes 　效果类似"-v"参数，但仅回报更改的部分。 
　-f或--quiet或--silent 　不显示错误信息。 
　-R或--recursive 　递归处理，将指定目录下的所有文件及子目录一并处理。
<权限范围>+<权限设置> 　开启权限范围的文件或目录的该项权限设置。 
<权限范围>-<权限设置> 　关闭权限范围的文件或目录的该项权限设置。 
<权限范围>=<权限设置> 　指定权限范围的文件或目录的该项权限设置。
chmod +s executablefile     # 允许其他用户以文件所有者的身份来执行文件(setuid)，只能应用于Linux ELF格式二进制文件上
chmod a+t directoryname      # 给目录设置粘滞位(只有目录的所有者才能删除目录中的文件)
chmod u+x file                给file的属主增加执行权限
chmod 751 file                给file的属主分配读、写、执行(7)的权限，给file的所在组分配读、执行(5)的权限，给其他用户分配执行(1)的权限
chmod u=rwx,g=rx,o=x file    上例的另一种形式
chmod =r file                为所有用户分配读权限
chmod 444 file               同上例
chmod a-wx,a+r               同上例
chmod -R u+r directory       递归地给directory目录下所有文件和子目录的属主分配读的权限
chmod 4755                   设置用ID，给属主分配读、写和执行权限，给组和其他用户分配读、执行的权限。
chmod 640 `find ./ -type f -print` # Change permissions to 640 for all files 
chmod 751 `find ./ -type d -print` # Change permissions to 751 for all directories
chmod --reference=install.log install.log.back
}

chgrp_user_man(){
变更文件或目录的所属群组
chgrp [-cfhRv][--help][--version][所属群组][文件或目录...] 
chgrp [-cfhRv][--help][--reference=<参考文件或目录>][--version][文件或目录...]
  -c或--changes  效果类似"-v"参数，但仅回报更改的部分。 
　-f或--quiet或--silent 　不显示错误信息。 
　-h或--no-dereference 　只对符号连接的文件作修改，而不更动其他任何相关文件。 
　-R或--recursive 　递归处理，将指定目录下的所有文件及子目录一并处理。
  --reference=<参考文件或目录> 　把指定文件或目录的所属群组全部设成和参考文件或目录的所属群组相同。
chgrp root test      # 把test的所属组更改root组 
chgrp -R mysql test  # 递归地把test目录及该目录下所有文件和子目录的组属性设置成mysql 
chgrp root *         # 把当前目录中所有文件的组属性设置成root
}

chown_user_man(){
变更文件或目录的拥有者或所属群组
用法：chown [选项]... [所有者][:[组]] 文件...
　或：chown [选项]... --reference=参考文件 文件...

  -c或--changes 　效果类似"-v"参数，但仅回报更改的部分。 
　-f或--quite或--silent 　不显示错误信息。 
　-h或--no-dereference 　之对符号连接的文件作修改，而不更动其他任何相关文件。 
　-R或--recursive 　递归处理，将指定目录下的所有文件及子目录一并处理
  --reference=<参考文件或目录> 　把指定文件或目录的拥有者与所属群组全部设成和参考文件或目录的拥有者与所属群组相同。
  
chown root test 把test文件的属主改进root 
chown -R root test_directory 递归地把test_directory目录下的所有文件属主改成root 
chown --dereference root test_link 把test_link链接的原文件属主改成root，链接文件属主不变 
chown --no-dereference root test_link 把test_link的链接文件属主改成root，原文件属主不变
# chown指定所有者和所属组的方式有两种，使用冒号和点。
chown root.root test
chown root:root test
chown root test     # 只修改所有者
chown :root test    # 自修改组
chown .root test
}

storage_df_demo(){
df -h       # 以友好的格式输出所有已安装文件系统的磁盘容量状态
df -m /home # 以M为单位输出home目录的磁盘容量状态
df -k       # 以K为单位输出所有已安装文件系统的磁盘容量状态
df -i       # 报告空闲的、用过的或部份用过的(百份比)索引节点
df -t ext3  # 仅显示文件类型为ext3的文件系统的磁盘状态
df -x ext3  # 仅显示文件类型不为ext3的文件系统的磁盘状态
df -T       # 除显示文件系统磁盘容量大小外还显示文件系统类型
df -l       # 仅显示本地文件系统。
}

mkbootdisk 建立启动盘
blockdev 从命令行调用区块设备控制程序

让你的硬盘飞起来: Linux下也可以使用32Bit I/O和DMA。使用/sbin/hdparm -c1 
/dev/hda(hdb,hdc..)打开32Bit传输模式，使用命令 /sbin/hdparm -d1 /dev/hda(hdb 
,hdc...) 打开DMA。最后使用/sbin/hdparm -k1 /dev/hda 以使硬盘在Reset之后保持上 
面的设定，这么一来，硬盘读写速度应该可以提高一倍以上。 

storage_hdparm_man(){
hdparm  补充说明：hdparm可检测，显示与设定IDE或SCSI硬盘的参数。

参　　数：
-a<快取分区> 设定读取文件时，预先存入块区的分区数，若不加上<快取分区>选项，则显示目前的设定。
-A<0或1> 启动或关闭读取文件时的快取功能。
-c<I/O模式> 设定IDE32位I/O模式。
-C 检测IDE硬盘的电源管理模式。
-d<0或1> 设定磁盘的DMA模式。
-f 将内存缓冲区的数据写入硬盘，并清楚缓冲区。
-g 显示硬盘的磁轨，磁头，磁区等参数。
-h 显示帮助。
-i 显示硬盘的硬件规格信息，这些信息是在开机时由硬盘本身所提供。
-I 直接读取硬盘所提供的硬件规格信息。
-k<0或1> 重设硬盘时，保留-dmu参数的设定。
-K<0或1> 重设硬盘时，保留-APSWXZ参数的设定。
-m<磁区数> 设定硬盘多重分区存取的分区数。
-n<0或1> 忽略硬盘写入时所发生的错误。
-p<PIO模式> 设定硬盘的PIO模式。
-P<磁区数> 设定硬盘内部快取的分区数。
-q 在执行后续的参数时，不在屏幕上显示任何信息。
-r<0或1> 设定硬盘的读写模式。
-S<时间> 设定硬盘进入省电模式前的等待时间。
-t 评估硬盘的读取效率。
-T 平谷硬盘快取的读取效率。
-u<0或1> 在硬盘存取时，允许其他中断要求同时执行。
-v 显示硬盘的相关设定。
-W<0或1> 设定硬盘的写入快取。
-X<传输模式> 设定硬盘的传输模式。
-y 使IDE硬盘进入省电模式。
-Y 使IDE硬盘进入睡眠模式。
-Z 关闭某些Seagate硬盘的自动省电功能。

hdparm -d  /dev/hda           显示硬盘的DMA模式是不打开，1代表on
hdparm -tT /dev/hda           测试硬盘的写性能
hdparm -d1 /dev/hda           开启dma功能
hdparm -d1 -X68 -c3 -m16 /dev/hda  
选项说明：
-c3：把硬盘的IO模式从16位转成32位。
-m16：改变硬盘的多路扇区的读功能，-m16使硬盘在一次I/O中断中读入16个扇区的数据。
-d1：打开DMA模式。
-X68：支持ATA66的数据传输模式。下面是其它模式的设置对照
ATA33.......参数是-X66 
ATA66.......参数是-X68 
ATA100......参数是-X69 
hdparm -k1 /dev/hda 保存设置

#节省电池电源
hdparm -y /dev/hdb 
hdparm -Y /dev/hdb 
hdparm -S 36 /dev/hdb
}
# dmesg |grep -i raid
# cat /proc/scsi/scsi
显示的信息差不多，raid的厂商，型号，级别，但无法查看各块硬盘的信息。

shutdown_demo(){  可以关闭所有程序，并依用户的需要，进行重启或关机操作。
shutdown -c          # -c cancel取消正在执行的关机程序 
shutdown -f          # -f 重启时不进行磁盘检测(fsck)
shutdown -F          # -F 重启时进行磁盘检测(fsck)
shutdown -h          # -h halt调用init关闭系统，关闭电源
# shutdown -h [-t 秒数] [时间(hh:mm或+m或m或now)] [警告信息]
shutdown -k          # -k 只是向登入用户发送警告信息，并不真正关机
shutdown -n          # -n 不调用init程序关机，强行快速关机
shutdown -r          # -r reboot关闭系统后重新启动 
shutdown -r          # -w 不会真正关机,只是把记录写入/var/log/wtmp
shutdown -t          # 5 在杀死进程和改变运行级别之间确保延时5秒

shutdown -t 30 -h 10 "shutdown..." # 在10分钟后执行shutdown,且在关机之前30秒发送警告讯息
shutdown -h now                    # 立刻关机
init 0                             #关闭系统(2)
telinit 0                          #关闭系统(3)
shutdown -h hours:minutes &   #按预定时间关闭系统
shutdown -h 21:30                  # 今天21：30关机
shutdown -h +10                    # 十分钟后关机
shutdown -r now                    # 立刻重启
shutdown -r +10 "the system will reboot" # 10分钟后重启

# 差异
shutdown命令﹐系统管理员会通知所有登录的用户系统将要关闭。并且login指令会被冻结。
shutdown执行它的工作是送信号(signal)给init程序﹐要求它改变runlevel。Runlevel 0被用来停机

halt     通知硬件来停止所有的 CPU 功能，但是仍然保持通电。你可以用它使系统处于低层维护状态。
  # halt             ### 停止机器
  # halt -p          ### 关闭机器
  # halt --reboot    ### 重启机器
poweroff poweroff 会发送一个 ACPI 信号来通知系统关机。
  # poweroff           ### 关闭机器
  # poweroff --halt    ### 停止机器
  # poweroff --reboot  ### 重启机器
reboot   reboot 通知系统重启
         -w 不会真正关机,只是把记录写入/var/log/wtmp
         -d 不把记录写入/var/log/wtmp(-n包含了-d)
  # reboot           ### 重启机器
  # reboot --halt    ### 停止机器
  # reboot -p        ### 关闭机器
  
init
        
initctl list
这允许您启动或停止作业、列出作业、获取作业状态、发出事件、重启 init 进程等。

定位 systemd 的系统配置目录
pkg-config systemd --variable=systemdsystemconfdir
PKG_CONFIG_PATH=/usr/local/lib/pkgconfig


来自 systemctl 的部分输出
systemctl --no-pager

runlevel #当前Linux服务器的运行级别
0： 关机
1： 单用户
2： 无网络的多用户
3： 命令行模式
4： 未用
5： GUI(图形桌面 模式)
6： 重启
init 数字 切换运行级别
# init N    // 切换到运行级别  N 
# init 0   // 关机 
# init 6   // 重启动系统 

who -r   #当前Linux服务器的运行级别

route -n     #查看Linux的默认网关
netstat -nr  #查看Linux的默认网关

mkinitrd -f -v /boot/initrd-${uname -r}.img ${uname -r}               #
dracut -f                                                             #
dracut -f initramfs-2.x.xx-xxl6.86_64.img      2.6.32-279.el6.x86_64  #
}

cpio_man(){
cpio从stdin获取文件名，并将归档写入stdout
cpio #复制入和复制出的意思
1. cpio用于创建、解压归档文件，也可以对归档文件执行拷入拷出的动作，
   即向归档文件中追加文件，或从归档文件中提取文件。
2. cpio一般从标准输入获取数据，写入到标准输出，所以一般会结合管道、输入重定向、输出重定向使用。
3. cpio有三种运行模式：
    3.1 Copy-out模式：此模式下，cpio将向归档文件中拷入文件，即进行归档操作，所以成为归档模式。
它会从标准输入中读取待归档的文件，将它们归档到目标中，若未指定归档的目标，将归档到标准输出中。
在copy-out模式下，最典型的是使用find来指定待归档文件，在使用find时，最好加上"-depth"以尽可能减少
可能出现的问题，例如目录的权限问题。
    3.2 Copy-in模式：此模式下，cpio将从归档文件中提取文件，或者列出归档文件中的文件列表。它将从
标准输入中读取归档文件。任意cpio的非选项参数都将认为是shell的glob通配pattern，只有文件名匹配了
指定模式时才会从中提取出来或list出来。在cpio中，通配符不能匹配到"."或"/"，所以如有需要，必须
显式指定"."或"/"。如果没有指定匹配模式，则解压或列出所有文件。
    3.3 Copy-pass模式：此模式下，cpio拷贝一个目录树(即目录中所有文件)到另一个目录下，并在目标目录
下以同名的子目录存在。copy-pass模式是copy-in模式再copy-out模式的结合，它中途没有涉及到任何归档行为。
这是cpio的一个特殊用法。它从标准输入中读取待拷贝内容，然后将它们复制到目标路径下。

    在cpio命令行中给出的非选项参数都会认为是pattern。非选项参数的意思是这个参数不是为选项指定的参数。
如cpio -t abc <a.cpio中，"-t"选项的功能是列出文件列表，它不需要参数，但后面给定了abc，则表示列出匹配
abc的文件或目录。
选项说明：
主操作模式
-i, --extract              从包中提取文件 (运行 copy-in 模式)
-o, --create               创建包 (运行 copy-out 模式)
-p, --pass-through         运行 copy-pass 模式
-t, --list                 打印输入内容列表

应用于所有模式的选项:
--block-size=BLOCK-SIZE   设置 I/O 块大小为 BLOCK-SIZE * 512字节
-B                         设置 I/O 块大小为 5120 字节
-c                         使用老的可移植的 (ASCII) 包格式
-C, --io-size=NUMBER       设置 I/O 块大小为指定的 NUMBER 字节
  --force-local            包文件是本地的，尽管名字中含有冒号
-f, --nonmatching          仅拷贝不匹配任意给定的模式的文件
-F, --file=[[用户@]主机:]文件名
                         用"文件名"来替代标准输入和输出。如果是非本地的文件，则用可选的"用户"和"主机"来指定用户名和主机名。
-H, --format=格式        使用指定的包格式
-M, --message=STRING       当到达备份介质的尾部的时候打印STRING
-n, --numeric-uid-gid      在内容列表的详表中，显示数字的 UID和 GID
  --quiet                不要打印已拷贝的块数
  --rsh-command=COMMAND  用 COMMAND 替代 rsh
-v, --verbose              详细列出已处理的文件
-V, --dot                  每处理一个文件就打印一个"."
-W, --warning=FLAG         控制警告信息显示。当前 FLAG
                         可为"none"、"truncate"或"all"。多个选项可以累计。
                         
命令修饰仅在 copy-in 模式中有效:
  -b, --swap
                             交换数据中每个字的两个半字以及每个半字中的两个字节。等价于-sS
  -r, --rename               交互式重命名文件
  -s, --swap-bytes           交换文件中每个半字中的两个字节
  -S, --swap-halfwords       交换文件中每个字(4个字节)中的两个半字
      --to-stdout            提取文件到标准输出
  -E, --pattern-file=FILE    从 FILE中读取额外的用于指定提取或列表的文件名的模式
      --only-verify-crc      当读取一个 CRC格式的包，仅检验包中每个文件的CRC，不提取文件

 应用于 copy-out 模式的选项
  -A, --append               追加到已存在的归档文件。
  -O [[用户@]主机:]文件名    使用包文件名而不是标准输出。如果文件在远程机器上，则可指定用户和主机

 应用于 copy-pass 模式的选项:
  -l, --link                 在可行时链接文件而不是拷贝文件
 应用于 copy-in 及 copy-out  模式的选项:
      --absolute-filenames   文件名不去除文件系统前缀
      --no-absolute-filenames   相对于当前目录来创建所有文件
 应用于 copy-out 及 copy-pass 模式的选项:
  -0, --null                 文件名列表采用 NULL而不是换行作为分割符
  -a, --reset-access-time    文件读取后恢复文件的访问时间
  -I [[用户@]主机:]文件名    从文件读入而不是从标准输入读入。如果文件在远程机器上， 则可指定用户和主机
  -L, --dereference          跟随符号链接(拷贝符号链接指向的文件而不是拷贝链接本身)
  -R, --owner=[用户][:.][组] 设置所有文件的所有权信息到指定的用户和/或组
 应用于 copy-in 和 copy-pass 模式的选项:
  -d, --make-directories     需要时创建目录
      --extract-over-symlinks   Force writing over symbolic links
  -m, --preserve-modification-time 创建文件时保留以前文件的修改时间
      --no-preserve-owner    不改变文件的所有权
      --sparse               把含有大块零的文件以稀疏文件方式写出
  -u, --unconditional        无条件覆盖所有文件
}


cpio_demo(){
cpio -o < name-list [> archive] # 归档 name-list 中的文件到 archive
cpio -i [< archive]             # 从 archive 中提取文件
cpio -p destination-directory < name-lis # 拷贝 name-list 中的文件到目标目录(destination-directory)

# 1. 归档
find ~ -depth | cpio -ov > tree.cpio    # 将家目录下的所有文件都归档到tree.cpio中
find ~ -depth | cpio -ov -F tree.cpio   # 将家目录下的所有文件都归档到tree.cpio中
find ~ -depth | cpio -ov -F /tmp/tree.cpio # 防止上面出现的迭代归档
find ~ -depth -print0 | cpio --null -ov -F /tmp/tree.cpio # 一般出于准确性考虑，会在find上使用"-print0"，然后在cpio上使用"--null"解析空字符。

find . -depth -print0 | cpio --null -o > ../lpicpio.1
find ~/lpi103-2/ -depth -print0 | cpio --null -o > ../lpicpio.2       #  使用 cpio 备份目录
# 2. 列出
cpio -t -F tree.cpio  # 列出归档文件中的文件列表
cpio -t < tree.cpio   # 列出归档文件中的文件列表
cpio -t -F tree.cpio /root/* # 模式匹配列出/root/* 
cpio -t /root/* < tree.cpio  # 模式匹配列出/root/* 
cpio -t -F tree.cpio /root/.* # 列出/root/下的隐藏文件
cpio -t -F tree.cpio /root/{.*,*} # 列出/root/下所有文件
# 3. 追加
ls /root/new.txt | cpio -oA -F tree.cpio
find /boot -depth -print0 | cpio -oA -F tree.cpio

cpio  -i --list  "*backup*" < ../lpicpio.1 backup backup/text1.bkp.1 backup/text1.bkp.2 3 blocks 
cpio  -i --list absolute-filenames "*text1*" < ../lpicpio.2           # 使用 cpio 列出和恢复所选文件
# 4. 提取
cpio -idv -F tree.cpio /root/
cpio -idv "*f1*" "*.bkp.1" < ../../lpicpio.1
cpio -idv "*.bkp.1" < ../../lpicpio.1
cpio -id --no-absolute-filenames "*text1*" < ../../lpicpio.2         #  使用 cpio 恢复所选文件

cpio -covB > [file|device]  # 备份 
cpio -icduv < [file|device] # 还原
# 4. 目录文件复制
find ~ -depth -print0 | cpio --null -pvd /tmp/abc
# 注意，该模式下复制的目录在目标位置上是以子目录形式存在的。
# 例如，例如复制/root目录到/tmp/abc下，则在/tmp/abc下会有root子目录，在/tmp/abc/root下才是源/root中的文件。
}


# 安装开发相关的manual 
sudo apt-get install manpages-dev 
man -a printf  # 在所有section中查找主题为printf的手册页 
man -k printf  # 在所有manual的简述中查找printf关键词 
man -K printf  # 正文中查找
    -M         # 指定手册的搜索路径
man 3 printf   # 直接查看系统调用类帮助文档中主题名为printf的手册页 

bash # HISTORY EXPANSION
man readline # 命令行快捷键 
man unicode # man ascii； man utf-8； man latin1
showkey -a # 取得按键的 ASCII 码

man -f sleep # 查看名为sleep的手册(多个序号) 
man -a sleep # 查看所有名为sleep的帮助信息

man -t errno | ps2pdf - ~/errno.pdf
man epoll | col -b > epoll.txt 
info epoll -o epoll.txt -s  

OEM(ODM OBM){
OEM，又叫定牌生产和贴牌生产，最早流行于欧美等发达国家，它是国际大公司
寻找各自比较优势的一种游戏规则，能降低生产成本，提高品牌附加值。近年来，
这种生产方式在国内家电行业比较流行，如TCL在苏州三星定牌生产洗衣机，长虹在
宁波迪声定牌生产洗衣机等。具体说来，OEM(Orignal Equipment Manufactuce)，
即原始设备制造商，ODM(Orignal Design Manufactuce)即原始设计制造商，OBM
(Orignal Brand Manufactuce)，即原始品牌制造商。A方看中B方的产品，让B方生
产，用A方商标，对A方来说，这叫OEM；A方自带技术和设计，让B方加工，这叫
ODM；对B方来说，只负责生产加工别人的产品，然后贴上别人的商标，这叫OBM。
}


命令的帮助工具 -- type、which、man、apropos、info、whatis、whereis
man_manul(){
    [python实例手册] [shell实例手册] [LazyManage运维批量管理(shell/python两个版本)]
    网盘更新下载地址:    http://pan.baidu.com/s/1sjsFrmX
    github更新下载地址:  https://github.com/liquanzhou/ops_doc
man 1 intro - 一篇对从未接触过Linux的用户的简明教程。
man 2 syscalls - 内核系统请求的列表，按内核版本注释分类，系统编程必备。
man 2 select_tut - 关于select()系统请求的教程。
man 3 string - 在头文件内的所有函数。
man 3 stdio - 关于头文件的使用，标准输入/输出库的说明。
man 3 errno - 所有errorno的取值及说明。(C语言内类似其他语言的异常告知机制)
man 4 console_codes - Linux的终端控制码及其使用解释。
man 4 full - 介绍/dev/full这个总是处于"满"状态的磁盘。(对应/dev/null这个总是空的设备)
man 5 proc - 介绍/proc下的文件系统。
man 5 filesystems - 各种Linux文件系统。
man 7 bootparam - 详细解释内核启动参数。
man 7 charsets - 解释各种语言的编码集。(gbk，gb2312等)
man 7 glob - 解释glob文件名管理机制的工作过程。
man 7 hier - 解释Linux文件系统结构各个部分的作用。
man 7 operator - C语言的运算符的列表。
man 7 regex - 介绍正则表达式。
man 7 suffixes - 常见文件后缀名的列表跟解释。
man 7 time - Linux的时钟机制解释。
man 7 units - 数值单位及其数值的解释。
man 7 utf8 - 描述UTF-8编码。
man 7 url - 解释URL、URI、URN等的标准。
man console_codes # 
man builtins # bash 内置命令
man interfaces # ubuntu interfaces 配置
man         # 阅读文档
man <section> <name>
man -k <editor>
man -K <keyword>
man -f ls   # 命令拥有哪个级别的帮助
            # whatis：这个命令的作用和 man -f 是一致的。
            # apropos：这个命令的作用和 man -k 是一致的
whereis 是搜索系统命令的命令 # whereis 命令不能搜索普通文件，而只能搜索系统命令
    -b: 只査找二制命令
    -m: 只查找帮助文档
which 也是搜索系统命令的命令 # whereis命令可以在查找到二进制命令的同时，查找到帮助文档的位置；
                             # 而which命令在查找到二进制命令的同时，如果这个命令有别名，则还可以找到别名命令。
locate 命令才是可以按照文件名搜索普通文件的命令。 # 关键字只有文件名 且存在 cachedb
find 是 Linux 中强大的搜索命令，不仅可以按照文件名搜索文件，还可以按照权限、大小、时间、inode 号等来搜索文件。

man # 阅读文档
apropos <editor>     # 查找文档
help -d     #  help 只能获取 Shell 内置命令的帮助
help history # 内置命令
type        # 可执行文件、shell 内置命令还是别名

dpkg -l
dpkg -L packageName
dpkg -l | grep -i <edit>

less /var/lib/dpkg/available #Return descriptions of all available packages.
<command-name> --help
}

compgen -b | column  # 相当于bash的help另一种方式
info_demo(){
info info
info bash
info date
info libc
/usr/share/info/ | /usr/local/share/info/
/usr/share/doc/  | /usr/local/share/doc/ 
/usr/share/man/  | /usr/local/share/man/
}

info_man(){ 电子书
info 命令的帮助信息是一套完整的资料，每个单独命令的帮助信息只是这套完整资料中的某一个小章节。
Ta      在有"*"符号的节点间进行切换
回车    进入有"*"符号的子页面，査看详细帮助信息
u       进入上一层信息(回车是进入下一层信息)
n       进入下一小节信息
P       进入上一小节信息
?       査看帮助信息
q       退出info信息
}

bash_t_here(){ sudo ssh cat
sudo -s <<EOF
  a='var'
  echo 'Running serveral commands with sudo'
  mktemp -d
  echo "\$a"
EOF

sudo -s <<'EOF'
  a='var'
  echo 'Running serveral commands with sudo'
  mktemp -d
  echo "$a"
EOF

ssh -p 21 example@example.com <<EOF
  echo 'printing pwd'
  echo "\$(pwd)"
  ls -a
  find '*.txt'
EOF

ssh -p 21 example@example.com <<'EOF'
  echo 'printing pwd'
  echo "$(pwd)"
  ls -a
  find '*.txt'
EOF

cat << EOF > foo.sh 
printf "%s was here" "$name" 
EOF
cat >> foo.sh <<EOF 
printf "%s was here" "$name"
EOF

AUT_RLOSS=`echo "$AUT_RLOSS*1000" | bc`
MXTICS=`echo "$SMPINF_PRECISION*100" | bc`

gnuplot << EOF
set terminal png size 1024,768
set output "$1.png"
set title "curvedata (distance:$STP_DISTANCE_VAL pluse:$STP_PLUSE_VAL wavelen:$WLS_VAL avgs:$ALA_VAL ior:$IOR_VAL sample:$SMPINF_SAMPLES total length:$AUT_LEN)"
set xlabel "samples total length:$AUT_LEN loss:$AUT_LOSS rloss:$AUT_RLOSS"
set ylabel "dB (dB/1000)"
set yrange [ 0 : $AUT_RLOSS ]
plot "$1" using 1:2 title "curvedata" with lines
EOF

ftp -i -n<<EOF
open 192.168.27.253
user root 123456
cd /etc/rtud
lcd /etc/rtud
binary
prompt
get serial
prompt
close
bye
EOF

wget ftp://192.168.27.253:/etc/rtud/* --user=root --password=123456

FTILE_NAME=$1
ftp -n <<- EOF
open 10.10.21.103
user user 123
cd test
bin
put $FTILE_NAME
bye
EOF
}
bash_redirection(){
rev base64 dos2unix fsync tac shred readahead truncate partprobe
truncate bzcat xxd blkid fold fzip xzcat fmt more less fmt md5sum 
tail tee sed iconv od grep cat sort file wc expand unexpand strings cut
nl split paste cmp tee
# cat 的默认输入是终端输入，cat的默认输出是终端输出
}
bash_redirection(){
1. Redirection
  < or 0< is stdin filehandle
  > or 1> is stdout filehandle
  2>      is stderr filehandle
2. Redirecting output of a command to a file
  grep -i 'error' report/*.log > error.log
  grep -i 'fail' test_results_20mar2015.log >> all_fail_tests.log 
  ./script.sh > /dev/null
3. Redirecting output of a command to another command
  ls -q | wc -l
  du -sh * | sort -h
  ./script.sh | tee output.log
4. Combining output of several commands
  (head -5 ~/.vimrc ; tail -5 ~/.vimrc) > vimrc_snippet.txt
  { head -5 ~/.vimrc ; tail -5 ~/.vimrc ; } > vimrc_snippet.txt
5. Command substitution
  sed -i "s|^|$(basename $PWD)/|" dir_list.txt
  file_count=$(ls -q | wc -l)
6. Process Substitution
  comm -23 <(sort file1.txt) <(sort file2.txt)
7. Redirecting error
  xyz 2> cmderror.log
  ./script.sh 2> /dev/null
8. Combining stdout and stderr
  grep 'test' report.log xyz.txt > cmb_out.txt 2>&1
  grep 'test' report.log xyz.txt 2> cmb_out.txt 1>&2
  grep 'test' report.log xyz.txt >> cmb_out.txt 2>&1
  ls report.log xyz.txt 2>&1 | grep '[st]'
9. Redirecting input
  tr a-z A-Z < test_list.txt
  wc -l < report.log
  grep 'test' report.log | diff - test_list.txt
10. Using xargs to redirect output of command as input to another command
  grep -rlZ 'pattern' | xargs -0 sed -i 's/pattern/replace/'
}
bash_brace(){
ls *{txt,log}                                       list all files ending with txt or log in the current directory
cp ~/projects/adders/verilog/{half_,full_}adder.v . copy half_adder.v and full_adder.v to current directory
mv story.txt{,.bkp}                                 rename story.txt as story.txt.bkp
cp story.txt{,.bkp}                                 to create bkp file as well retain original
mv story.txt{.bkp,}                                 rename story.txt.bkp as story.txt
mv story{,_old}.txt                                 rename story.txt as story_old.txt
touch file{1..4}.txt                                same as touch file1.txt file2.txt file3.txt file4.txt
touch file_{x..z}.txt                               same as touch file_x.txt file_y.txt file_z.txt
rm file{1..4}.txt                                   same as rm file1.txt file2.txt file3.txt file4.txt
echo story.txt{,.bkp}                               displays the expanded version 'story.txt story.txt.bkp' , 
                                                    useful to dry run before executing actual command

mv filename.{jar,zip}
mkdir 20{09..11}-{01..12}
echo {001..10}
cp .vimrc{,.bak}
echo {0..10..2}
for c in {a..z..5}; do echo -n $c; done
echo {a..z}
echo {z..a}
echo {1..20}
echo {01..20}
echo {20..1}
echo {20..01}
echo {a..d}{1..3}
mkdir -p toplevel/sublevel_{01..09}/{child1,child2,child3}
}
bash_math(){ 
运算和判断
算术运算符(假设变量a=10,变量b=20)
--------------------------------------------------------------------
#运算符      描述                       例子
--------------------------------------------------------------------
+            加法                       $(expr $a + $b) will give 30
-            减法                       $(expr $a - $b) will give -10
*            乘法                       $(expr $a * $b) will give 200
/            除法                       $(expr $b / $a) will give 2
%            模(取余)                    $(expr $b % $a) will give 0
=            赋值                        a=$b would assign value of b into a
==           等于                        [ $a == $b ] would return false.
!=           不等于                      [ $a != $b ] would return true.
#关系运算符(假设变量a=10,变量b=20)
--------------------------------------------------------------------
运算符       描述                        示例
--------------------------------------------------------------------
-eq          比较两个变量相等            [ $a -eq $b ] is not true.
-ne          比较两个变量不相等          [ $a -ne $b ] is true.
-gt          大于                        [ $a -gt $b ] is not true.
-lt          小于                        [ $a -lt $b ] is true.
-ge          大于等于                    [ $a -ge $b ] is not true.
-le          小于等于                    [ $a -le $b ] is true.
#布尔运算符
--------------------------------------------------------------------
运算符       描述                       示例
--------------------------------------------------------------------
!            逻辑非                      [ ! false ] is true.
-o           逻辑或                      [ $a -lt 20 -o $b -gt 100 ] is true.
-a           逻辑与                      [ $a -lt 20 -a $b -gt 100 ] is fa
#字符串运算符(假设变量a="abc" 和变量b="efg"
--------------------------------------------------------------------
运算符       描述                        示例
--------------------------------------------------------------------
=            字符串是否相等              [ $a = $b ] is not true.
!=           字符串是否不相等            [ $a != $b ] is true.
-z           字符串长度是否为0           [ -z $a ] is not true.
-n           字符串长度是否非0           [ -z $a ] is not false.
str          字符串为非空                [ $a ] is not false.
}

bash_redirection(){
command < filename                         把标准输入重定向到filename文件中
command 0< filename                       把标准输入重定向到filename文件中
command > filename                         把标准输出重定向到filename文件中(覆盖)
command 1> fielname                       把标准输出重定向到filename文件中(覆盖)
command >> filename                       把标准输出重定向到filename文件中(追加)
command 1>> filename                     把标准输出重定向到filename文件中(追加)
command 2> filename                       把标准错误重定向到filename文件中(覆盖)
command 2>> filename                     把标准输出重定向到filename文件中(追加)
command > filename 2>&1               把标准输出和标准错误一起重定向到filename文件中(覆盖)
command >> filename 2>&1             把标准输出和标准错误一起重定向到filename文件中(追加)
command < filename >filename2        把标准输入重定向到filename文件中，把标准输出重定向
                                                        到filename2文件中
command 0< filename 1> filename2   把标准输入重定向到filename文件中，把标准输出重定向
                                                        到filename2文件中
#输出重定向
command>file       重定向到新的文件
command>>file      重定向追加到现有的文件
Here 文档
command << delimiter
document
delimiter
#丢弃输出
command > /dev/null
}
bash_type(){
bash启动类型可分为交互式shell和非交互式shell
  交互式shell还分为交互式的登录shell和交互式非登录shell
  非交互的shell在某些时候可以在bash命令后带上"--login"或短选项"-l"，这时也算是登录式，即非交互的登录式shell。
1. 判断是否为交互式shell有两种简单的方法：
1.1方法一：判断变量"-"，如果值中含有字母"i"，表示交互式。
  echo $- # himBH
  ++ a.sh
  #!/bin/bash
   echo $- # hB
1.2. 方法二：判断变量PS1，如果值非空，则为交互式，否则为非交互式，因为非交互式会清空该变量。
  echo $PS1 # [\u@\h \W]\$
2. 判断是否为登录式的方法也很简单，只需执行"shopt login_shell"即可。值为"on"表示为登录式，否则为非登录式。
  shopt login_shell
3. (1).正常登录(伪终端登录如ssh登录，或虚拟终端登录)时，为交互式登录shell。
  echo $PS1;shopt login_shell # [\u@\h \W]\$ login_shell on
  /etc/profile.d/*.sh goes /etc/profile goes /etc/bashrc goes ~/.bashrc goes ~/.bash_profile goes
  (2).su命令，不带"--login"时为交互式、非登录式shell，带有"--login"时，为交互式、登录式shell。
  su root
  echo $PS1;shopt login_shell # [\u@\h \W]\$ login_shell off
  # /etc/profile.d/*.sh goes /etc/bashrc goes ~/.bashrc goes
  su -
  echo $PS1;shopt login_shell # [\u@\h \W]\$ login_shell on
  # /etc/profile.d/*.sh goes /etc/profile goes /etc/bashrc goes ~/.bashrc goes ~/.bash_profile goes
  (3).执行不带"--login"选项的bash命令时为交互式、非登录式shell。但指定"--login"时，为交互式、登录式shell。
  bash
  echo $PS1;shopt login_shell # [\u@\h \W]\$ login_shell off
  # /etc/profile.d/*.sh goes /etc/bashrc goes ~/.bashrc goes
  bash -l
  echo $PS1;shopt login_shell # [\u@\h \W]\$ login_shell on
  # /etc/profile.d/*.sh goes /etc/profile goes /etc/bashrc goes ~/.bashrc goes ~/.bash_profile goes
  (4).使用命令组合(使用括号包围命令列表)以及命令替换进入子shell时，继承父shell的交互和登录属性。
  (echo $BASH_SUBSHELL;echo $PS1;shopt login_shell) # 1 [\u@\h \W]\$ login_shell     on
  su ; (echo $BASH_SUBSHELL;echo $PS1;shopt login_shell) # 1 [\u@\h \W]\$ login_shell   off
  (5).ssh执行远程命令，但不登录时，为非交互、非登录式。
  ssh localhost 'echo $PS1;shopt login_shell' #  login_shell off
  # /etc/bashrc goes ~/.bashrc goes
  (6).执行shell脚本时，为非交互、非登录式shell。但指定了"--login"时，将为非交互、登录式shell。
  例如，脚本内容如下：
    [root@xuexi ~]# vim b.sh
    #!/bin/bash
    echo $PS1
    shopt login_shell
    不带"--login"选项时，为非交互、非登录式shell。
    [root@xuexi ~]# bash b.sh
    
    login_shell     off
    
    带"--login"选项时，为非交互、登录式shell。
    [root@xuexi ~]# bash -l b.sh
    
    login_shell     on
  (7).在图形界面下打开终端时，为交互式、非登录式shell。
①.交互式登录shell或非交互式但带有"--login"(或短选项"-l"，例如在shell脚本中指定"#!/bin/bash -l"时)
  的bash启动时，将先读取/etc/profile，再依次搜索~/.bash_profile、~/.bash_login和~/.profile，并仅加载
  第一个搜索到且可读的文件。当退出时，将执行~/.bash_logout中的命令。
  #!/bin/bash -l
  /etc/profile goes /etc/bashrc goes ~/.bashrc goes ~/.bash_profile goes
}

bash_config(){ profile 登录shell，bashrc 非交互bash。 .bash_profile 特指bash登录shell
通过如下配置文件进行配置:
    /etc/profile       # 系统范围内初始化文件，对所有用户有效 登录shell
    ~/.bash_profile    # 个人范围内初始化文件，对登录用户有效 登录shell
    # 保存环境变量的设定以及登陆时要执行的命令;而对于从图形界面启动的 shell 和 cron 启动的 shell，则需要单独配置文件。
    ~/.bash_login
    ~/.profile         # bash优先读取.bash_profile，不存在再读取此文件
    /etc/bash.bashrc (非标准: 只对部分发行版有效，Arch包含在这部分中)  #对所有用户有效
    ~/.bashrc          # 个人范围内初始化文件，对用户有效 非登录shell
    # 对当前用户有效 ->保存别名、shell 选项和常用函数;这样做的话你就可以在所有 shell 会话中使用你的设定。
    ~/.bash_logout

常用的配置文件：
    /etc/profile被所有兼容Bourne shell的shell在登录时引用。它在登录时建立了环境并且加载了应用程序特定(/etc/profile.d/*.sh)的设置。
    ~/.profile: 此文件在启动一个交互式的登录shell时被Bash所读入和引用。
    ~/.bashrc 此文件在启动一个交互式的非登录shell时被Bash所读入和引用。比如当你从桌面环境中打开一个虚拟控制台时。这个文件在用户自定义自己的shell环境时特别有用。

配置文件在启动时的引用顺序

这些文件在不同的情形下被Bash所引用。
    如果交互式+登录shell -> /etc/profile 然后按以下顺序读取 ~/.bash_profile, ~/.bash_login, 和 ~/.profile   # session
        Bash会在退出时引用{ic|~/.bash_logout}}。                                                            # session
    如果交互式+非登录shell -> /etc/bash.bashrc 然后 ~/.bashrc                                               # bash self
    如果交互式+传统模式 -> /etc/profile 然后 ~/.profile                                                     # 
1. user login (interactive, login)
    [ /etc/profile ] is running. 
    [ ~/.bash_profile ] is running. 
    [ ~/.bashrc ]  is running. 
    [ /etc/bashrc ] is running.
2. bash --login (interactive, login)
    [ /etc/profile ] is running. 
    [ ~/.bash_profile ] is running. 
    [ ~/.bashrc ]  is running. 
    [ /etc/bashrc ] is running.
3. bash (interactive, non-login)
    [ ~/.bashrc ]  is running. 
    [ /etc/bashrc ] is running.
4. su --login (interactive, login)
    [ /etc/profile ] is running. 
    [ ~/.bash_profile ] is running. 
    [ ~/.bashrc ]  is running. 
    [ /etc/bashrc ] is running. 
5. su (interactive, non-login)
    [ ~/.bashrc ]  is running. 
    [ /etc/bashrc ] is running.
6. 非交互 bash - 既执行脚本 (non-interactive, non-login)
    没有一个配置脚本执行
    
但是，在Arch下，默认的:
    /etc/profile (间接地) 引用 /etc/bash.bashrc
    /etc/skel/.bash_profile Arch鼓励用户将/etc/skel/.bash_profile复制到 ~/.bash_profile, 并引用 ~/.bashrc

这意味着 /etc/bash.bashrc 和 ~/.bashrc 将会为所有的交互式shell所执行, 不管它是不是登录shell.
用户dotfiles的例子可以在/etc/skel/中被找到。

# For BASH: Read down the appropriate column. Executes A, then B, then C, etc.
# The B1, B2, B3 means it executes only the first of those files found.  (A)
# or (B2) means it is normally sourced by (read by and included in) the
# primary file, in this case A or B2.
#
# +---------------------------------+-------+-----+------------+
# |                                 | Interactive | non-Inter. |
# +---------------------------------+-------+-----+------------+
# |                                 | login |    non-login     |
# +---------------------------------+-------+-----+------------+
# |                                 |       |     |            |
# |   ALL USERS:                    |       |     |            |
# +---------------------------------+-------+-----+------------+
# |BASH_ENV                         |       |     |     A      | not interactive or login
# |                                 |       |     |            |
# +---------------------------------+-------+-----+------------+
# |/etc/profile                     |   A   |     |            | set PATH & PS1, & call following:
# +---------------------------------+-------+-----+------------+
# |/etc/bash.bashrc                 |  (A)  |  A  |            | Better PS1 + command-not-found 
# +---------------------------------+-------+-----+------------+
# |/etc/profile.d/bash_completion.sh|  (A)  |     |            |
# +---------------------------------+-------+-----+------------+
# |/etc/profile.d/vte-2.91.sh       |  (A)  |     |            | Virt. Terminal Emulator
# |/etc/profile.d/vte.sh            |  (A)  |     |            |
# +---------------------------------+-------+-----+------------+
# |                                 |       |     |            |
# |   A SPECIFIC USER:              |       |     |            |
# +---------------------------------+-------+-----+------------+
# |~/.bash_profile    (bash only)   |   B1  |     |            | (doesn't currently exist) 
# +---------------------------------+-------+-----+------------+
# |~/.bash_login      (bash only)   |   B2  |     |            | (didn't exist) **
# +---------------------------------+-------+-----+------------+
# |~/.profile         (all shells)  |   B3  |     |            | (doesn't currently exist)
# +---------------------------------+-------+-----+------------+
# |~/.bashrc          (bash only)   |  (B2) |  B  |            | colorizes bash: su=red, other_users=green
# +---------------------------------+-------+-----+------------+
# |                                 |       |     |            |
# +---------------------------------+-------+-----+------------+
# |~/.bash_logout                   |    C  |     |            |
# +---------------------------------+-------+-----+------------+
#
# ** (sources !/.bashrc to colorize login, for when booting into non-gui)
}
                                                           #https://github.com/ali5ter/ansi-color
echo -e '\033[1;31mHello, \033[0m\033[1;33mworld!\033[0m'  #code.google.com/p/ansi-color/
printf '\033[1;31m%s, \033[0m\033[1;33m%d\033[0m and \u4e2d\u6587!\n' "Hello" 34

bash_in_variable(){
$0      === shell名称或shel脚本名称
$1      === 第一个(1)shell参数
...
$9      === 第九个(9)shell参数
$#      === 位置参数的个数
"$*"    === "$1 $2 $3 $4 ... $n"  以整个字符串的形式，传递给脚本或函数的所有参数。
"$@"    === "$1" "$2" "$3" "$4" ... "$n" 以列表的形式名，传递给脚本或函数的所有参数。
$?      === 最近执行的命令的退出状态
$$      === 当前shell脚本的PID
$!      === 最近启动的后台作业的PID
}

bash_queue(){

###逻辑或前如果为真，后边的语句块自动不执行
#1            #2            #3
:||{          ((1))||{      true||{
 注释内容...   注释内容...   注释内容...
}             }             }
###逻辑与前如果为假，后边的语句块自动不执行
#4             #5
((0))&&{       false&&{
 注释内容...    注释内容...
}              }
}

bash_brace_variable(){
形式        如果设置了 var      如果没有设置 var
${var:-string}  $var                string
${var:+string}  string              null
${var:=string}  $var                string 
(并且执行var=string)
${var:?string}  $var                (返回string然后退出)

在此，冒号':'在所有运算表达式中事实上均是可选的。
    有':' === 运算表达式测试'存在'和'非空'。
    没有':' === 运算表达式仅测试'存在'。
    
需要记住的替换参数：
形式          结果
${var%suffix}   删除位于var结尾的suffix最小匹配模式
${var%%suffix}  删除位于var结尾的suffix最大匹配模式
${var#prefix}   删除位于var开头的prefix最小匹配模式
${var##prefix}  删除位于var开头的prefix最大匹配模式
}

bash_scoping(){
1. 动态范围
$ x=3
$ func1 () { echo "in func1: $x"; }
$ func2 () { local x=9; func1; }
$ func2
in func1: 9
$ func1
in func1: 3
动态范围作用域的意思是:变量在调用时范围内查找变量的值，而不是在变量定义时范围内查找变量的值。
}

bash_substitution(){
diff <(curl http://www.example.com/page1) <(curl http://www.example.com/page2)

while IFS=":" read -r user _
do
    # "$user" holds the username in /etc/passwd
done < <(grep "hello" /etc/passwd)

<(grep "hello" /etc/passwd) 产生一个输出流，
< 将输出流绑定到输入流上

cat header.txt body.txt >body.txt # >先将body.txt截断，然后将header.txt body.txt的内容写入body.txt
cat header.txt <(cat body.txt) > body.txt # 先执行<(cat body.txt)将数据缓存到缓冲中，然后截断body.txt，最后将cat

paste <( ls /path/to/directory1 ) <( ls /path/to/directory2 )

2. 避免使用sub-shell,使得count变量不会改变
count=0
find . -maxdepth 1 -type f -print | while IFS= read -r _; do
    ((count++))
done

count=0
while IFS= read -r _; do
    ((count++))
done < <(find . -maxdepth 1 -type f -print
}

operator(&& || !){
[] 使用 ! -o -a
find 使用 ! -o -a
[[]] 使用 && || !
awk 添加和命令部分都是用 && || !
grep 使用(|) 实现或功能
}

deb(软件包名规则){
格式为：Package_Version-Build_Architecture.deb
如：nano_1.3.10-2_i386.deb
* 软件包名称(Package Name): nano
* 版本(Version Number):1.3.10
* 修订号(Build Number):2
* 平台(Architecture):i386
}
ubuntu(查找软件包){  apt-get install aptitude -y
dpkg --get-selections pattern #查找软件包名称包含 pattern 的软件包，可以在后面用 grepinstall/deinstall 来选择是否已经被 remove 的包(曾经安装过了的)
apt-cache search pattern #查找软件包名称和描述包含 pattern 的软件包 (可以是安装了也可以是没有安装)，可以用参数来限制是否已经安装
aptitude search ~i #查找已经安装的软件包
aptitude search ~c #查找已经被 remove 的软件包，还有配置文件存在
aptitude search ~npattern #查找软件包名称包含 pattern 的软件包 (可以是安装了也可以是没有安装)
aptitude search !inpattern #查找还没有安装的软件包名字包含 pattern 的软件包。(前面的 ! 是取反的意思，反划线是 escape 符号)
注：还有很多用法，可以去看看我在 forum 中写的帖子 aptitude Search Patterns[1]
apt-cache depends package #查找名称是 package 软件包的依赖关系
aptitude search Rnpackage #查找名称是 package 软件包的依赖关系，可以同时看到是不是已经安装
apt-cache rdepends package #查找哪些软件包依赖于名称是 package 软件包
aptitude search Dnpackage #查找哪些软件包依赖于名称是 package 软件包
dpkg -I package_name.deb #参数是大写i，查找已经下载但末安装的 package_name.deb 软件包的信息
dpkg -l package #参数是小写L，查找已经安装软件包 package 的信息，精简
apt-cache show pattern ##查找软件包pattern的信息 (可以是安装了也可以是没有安装)
aptitude show ~npattern #显示名称是 pattern 软件包的信息(可以是安装了也可以是没有安装)
apt-cache policy pattern #显示 pattern 软件包的策略(可以是安装了也可以是没有安装)
apt-cache showpkg pattern #显示pattern 软件包的其它信息(可以是安装了也可以是没有安装)
dpkg -S pattern #查找已经安装的文件 pattern 属于哪个软件包
apt-file search pattern #查找文件 pattern 属于哪个软件包(可以是安装了也可以是没有安装)
dpkg -c package_name.deb #查找已经下载但末安装的 package.deb 软件包包含哪些文件
dpkg -L package #查找已经安装 package 软件包包含哪些文件
apt-file show pattern #查找 pattern 软件包(可以是安装了也可以是没有安装)包含哪些文件
}
dpkg(相关文件){
/etc/dpkg/dpkg.cfg  dpkg包管理软件的配置文件【Configuration file with default options】
/var/log/dpkg.log  dpkg包管理软件的日志文件【Default log file (see /etc/dpkg/dpkg.cfg(5) and option --log)】
/var/lib/dpkg/available  存放系统所有安装过的软件包信息【List of available packages.】
/var/lib/dpkg/status   存放系统现在所有安装软件的状态信息
/var/lib/dpkg/info   记安装软件包控制目录的控制信息文件


/var/cache/apt/archives  已经下载到的软件包都放在这里(用 apt-get install 安装软件时，软件包的临时存放路径)
/var/lib/apt/lists    使用apt-get update命令会从/etc/apt/sources.list中下载软件列表，并保存到该目录
}
dpkg(list){
dpkg -l
1)第一字符为期望值(Desired=Unknown/Install/Remove/Purge/Hold)，它包括：
u  Unknown状态未知,这意味着软件包未安装,并且用户也未发出安装请求.
i  Install用户请求安装软件包.
r  Remove用户请求卸载软件包.
p  Purge用户请求清除软件包.
h  Hold用户请求保持软件包版本锁定.

第二列,是软件包的当前状态(Status=Not/Inst/Conf-files/Unpacked/halF-conf/Half-inst/trig-aWait/Trig-pend)
n  Not软件包未安装.
i  Inst软件包安装并完成配置.
c  Conf-files软件包以前安装过,现在删除了,但是它的配置文件还留在系统中.
u  Unpacked软件包被解包,但还未配置.
f  halF-conf试图配置软件包,但是失败了.
h  Half-inst软件包安装,但是但是没有成功.
w trig-aWait触发器等待
t Trig-pend触发器未决

案例说明：
ii # 表示系统正常安装了该软件
pn # 表示安装了该软件，后来又清除了
un # 表示从未安装过该软件
iu # 表示安装了该软件，但是未配置
rc # 该软件已被删除，但配置文件仍在
}
dpkg(命令){  安装离线下载的软件包 *.deb
dpkg是debian最早提出的一个软件包管理工具，因为早期并没有考虑到当下软件包之间这么复杂的依赖关系，所以并不能自动解决软件包的依赖问题，这个命令多用于安装本地的.deb软件包，也可以进行软件包的维护
$sudo dpkg [-isLrP] [软件包或软件名]
-i package安装一个软件包
-s name查看软件包信息
-L name查看软件包的安装路径
-r name卸载软件，保留配置文件
-P name卸载软件，同时删除配置文件

sudo dpkg -i package.deb # 安装 DEB 包命令
sudo dpkg -i package.deb # 升级 DEB 包命令( 和安装命令相同)
sudo dpkg -r package.deb # 不卸载配置文件 (卸载 DEB 包命令)
sudo dpkg -P package.deb # 卸载配置文件 (卸载 DEB 包命令)

sudo dpkg-deb -c package.deb # 查询 DEB 包中包含的文件列表命令
dpkg --info package.deb      # 查询 DEB 包中包含的内容信息命令
dpkg -l package              # 查询系统中所有已安装 DEB 包
dpkg --unpack package-name.deb  # "解包"：解开软件包到系统目录但不配置

dpkg --info package_a.deb    # 查询 DEB 包的依赖关系，可解读 dpkg --info 结果中的 Pre-Depends 字段：

可以。使用— search 参数 , 如在安装了 Notes8.5 的系统中：
dpkg --search /opt/ibm/lotus/notes/notes 返回信息 : ibm-lotus-notes: /opt/ibm/lotus/notes/notes
}

apt(apt-cache){ 用于搜索包
sudo apt-cache pkgnames                #列出当前所有可用的软件包
sudo apt-cache search package_name     #查找一个软件包
sudo apt-cache show package_name       #查看软件包信息
sudo apt-cache showsrc package_name    #查看软件包信息
sudo apt-cache depends package_name    #查看软件包的依赖关系
sudo apt-cache rdepends package_name   #查看软件包的依赖关系
sudo apt-cache policy package_name     #查看软件包信息
sudo apt-cache dump                    #查看每个软件包的简要信息

sudo apt-cache search vsftpd           #查找软件包并列出该软件包的相关信息
sudo apt-cache pkgnames vsftp          #找出所有以vsftpd开头的软件包
sudo apt-cache stats                   #查看软件包总体信息
}

apt-get source linux 下载linux内核
apt(apt-get){
apt-get install package_name       #安装一个软件包
apt-get install vsftpd=2.3.5...    #安装指定版本的包文件
apt-get install package --reinstall # 重新安装包
apt-get -f install                  # 修复安装"-f = ——fix-missing" 
apt-get install packageName --no-upgrade      #--no-upgrade会阻止已经安装过的文件进行更新操作
apt-get install packageName --only-upgrade    #--only-upgrade只会更新已经安装过的文件，并不会安装新文件
apt-get update                     #更新软件包索引文件
apt-get dist-upgrade               # 升级系统
apt-get dselect-upgrade            # 使用 dselect 升级
apt-get upgrade                    #更新已安装的软件包，upgrade子命令会更新当前系统中所有已安装的软件包，并同时所更新的软件包相关的软件包
apt-get remove package_name        #卸载一个软件包但是保留相关的配置文件
apt-get --purge remove package_name #卸载一个软件包同时删除配置文件
apt-get purge package_name         #卸载一个软件包同时删除配置文件
apt-get autoremove package         # 删除包及其依赖的软件包
apt-get clean                      #删除软件包的备份
apt-get --download-only source vsftpd    #只下载软件源码包
apt-get source vsftpd                    #下载并解压包,下载指定软件的源文件
apt-get --compile source goaccess        #下载、解压并编译
apt-get download nethogs                 #仅将软件包下载到当前工作目录中
apt-get changelog vsftpd/apt-get check   #查看软件包的日志信息
apt-get build-dep netcat                 # 在当前系统中的本地包库中查看指定包的依赖包并对以来包进行安装
apt-get clean && apt-get autoclean  # 清理无用的包
}
apt(apt-get的更新过程){
1)执行apt-get update
2)程序分析/etc/apt/sources.list
3)自动连网寻找list中对应的Packages/Sources/Release列表文件，如果有更新则下载之，存入/var/lib/apt/lists/目录
4)然后 apt-get install 相应的包 ，下载并安装。
}
alien(){
在 UBUNTU 中使用 alien 将 rpm 转换为 deb 并安装 :
$ sudo alien -d package.rpm 
$ sudo dpkg -i package.deb
在 RHEL 中使用 alien 将 deb 转换为 rpm 并安装 :
# alien -r package.deb 
# rpm -ivh package.rpm
}

rpm --initdb    
rpm --rebuilddb   # 这个要花好长时间；
rpm_rebuilddb(){
如果 RPM 的底层数据库损坏，RPM 还能使用吗？
如果底层数据库损坏，RPM 将无法正常使用。此时最常用的解决方法是重构数据库：
# rm -f /var/lib/rpm/__* ; rpm -vv --rebuilddb
DPKG 本身不提供底层数据库恢复机制。它的数据库以文件形式保存在 /var/lib/dpkg 目录中。
及时地备份这个目录是最好的预防数据库损坏措施。
}
apt(){
apt-file update 
apt-file search dir/file.h
}
sudo dpkg --configure -a

#### dpkg：处理 smbclient (--configure)时出错：
1.$ sudo mv /var/lib/dpkg/info /var/lib/dpkg/info_old //现将info文件夹更名
2.$ sudo mkdir /var/lib/dpkg/info //再新建一个新的info文件夹
3.$ sudo apt-get update, apt-get -f install //不用解释了吧
4.$ sudo mv /var/lib/dpkg/info/* /var/lib/dpkg/info_old //执行完上一步操作后会在新的info文件夹下生成一些文件，现将这些文件全部移到info_old文件夹下
5.$ sudo rm -rf /var/lib/dpkg/info //把自己新建的info文件夹删掉
6.$ sudo mv /var/lib/dpkg/info_old /var/lib/dpkg/info //把以前的info文件夹重新改回名字

apt(){
                  Debian Ubuntu                Fedora,CentOS(redhat系)             
安装包           apt-get install pkg            yum install pkg                    apt install 
移除包           apt-get remove  pkg            yum erase pkg                      apt remove
更新包列表       apt-get update                 yum check-update                   apt update
更新系统         apt-get upgrade                yum update                         apt upgrade
列出源           cat /etc/apt/sources.list      yum	repolist                       
添加源           edit /etc/apt/sources.list     add 仓库 to/etc/yum.repos.d/       
移除源           edit /etc/apt/sources.list     remove 仓库from /etc/yum.repos.d/  
搜索包           apt-cache	search pkg          yum	search	pkg                    apt search
列出已安装的包   dpkg  -l                      rpm	-qa                            
                 apt-get purge                                                     apt purge
                 apt-get autoremove                                                apt autoremove
                 apt-get dist-upgrade                                              apt full-upgrade
                 apt-get show                                                      apt show
apt list
}

bash(jobs){
&  # 直接将命令丢到后台中"执行"的 &
利用数据流重定向，将输出数据传送至某个文件中
tar -zpcvf /tmp/etc.tar.gz /etc > /tmp/log.txt 2>&1 &

fg %jobnumber # 将后台工作拿到前台来处理
fg % 或者 % # 如果后台仅有一个任务

jobs # 常看目前的后台工作状态
  -l ：除了列出 job number 与命令串之外，同时列出 PID 的号码； 
  -r ：仅列出正在背景 run 的工作； 
  -s ：仅列出正在背景当中暂停 (stop) 的工作。

Ctrl+z # 将目前的工作丢到后台中"暂停"：[ctrl-z]
ctrl-c 
bg %3 # 让工作在后台下的状态变成运行中
kill # 理后台当中的工作
kill %1
pkill -f test.py
kill $(pgrep -f 'python test.py')

nice -n ［新的nice值］ ［程序的名称］
head,tail #head -100 file ; tail -100 file. 支持前n行和前m个字符两种方式
ln
su,exit,adduser,deluser,usermod,groups # useradd -m 创建用户目录
su - <username>  #加载环境变量 如.profile
su <username>    #不会加载环境变量，不推荐使用
date
shutdown
df,du,mount
cat,tac,more # 把档案串连接后传到基本输出
}
sgid(){
如ll /usr/bin/locate，得到-rwx--s--x，其中s就是sgid

1. 对二进制程序，运行者在运行过程中将会获得该程序群组的支持，上面普通用户将得到slocate群组支持
2. 针对目录
3. 使用者若对於此目录具有 r 与 x 的权限时，该使用者能够进入此目录
4. 使用者在此目录下的有效群组(effective group)将会变成该目录的群组
5. 若使用者在此目录下具有 w 的权限(可以新建文件)，则使用者所创建的新文件，该新文件的群组与此目录的群组相同。
}
unix(查看登录信息){
实时的登录
whoami
who
w
ps u
users

登录日志
last <username> <tty>
finger <username>

发信息

write <username> <tty>
wall
}

# 早先在格尔木实现的转发程序: rtu_frontd和rtu_backd可以通过socat程序实现；
rtu: socat tcp-listen:127.0.0.1:port1 tcp-connect:222.41.210.217:port2  # for config
     socet tcp-listen:127.0.0.1:port3 tcp-connect:222.41.210.217:port4  # for report
internal:222.41.210.217
     socat tcp-listen:192.168.10.201:port2 tcp-listen:192.168.10.201:5000 # for config
     socat tcp-listen:192.168.10.201:port4 tcp-connect:192.168.27.116:5000 # for report

# 反弹一个交互式的 shell
连接 : socat tcp-connect:8.8.8.8:6666 exec:'bash -li',pty,stderr,setsid,sigint,sane
监听 : socat file:`tty`,raw,echo=0  tcp-l:6666 # 管理连接过来的服务器

# 正向 shell
socat tcp-l:8888,fork,reuseaddr exec:./bash

socat tcp-l:8888 system:bash,pty,stderr   # server  
socat readline tcp:$target:8888           # client  
用readline替代-，就能支持历史功能了

# 连接执行命令
socat tcp-listen:23 exec:cmd,pty,stderr   # server  把cmd绑定到端口23，同时把cmd的Stderr复位向到stdout。
socat readline tcp:server:23              # client  连接到服务器的23端口，即可获得一个cmd shell。readline具有历史功能

# 文件传递
host1# socat -u open:myfile.exe,binary tcp-listen:999
host2# socat -u tcp:host1:999 open:myfile.exe,create,binary

# 向远程端口发数据
socat -  tcp-listen:1234                           # server
echo 'test' | socat - tcp-connect:127.0.0.1:12345  # client

# 转发
socat TCP4-LISTEN:8888,fork TCP4:www.qq.com:80 # 本地监听8888端口，来自8888的连接重定向到目标www.qq.com:80

# 端口映射
外部 socat tcp-listen:1234 tcp-listen:3389
内部 socat tcp:outerhost:1234 tcp:192.168.12.34:3389
# 外部机器上的3389就映射在内部网192.168.12.34的3389端口上。

# VPN
| 服务端 | socat -d -d TCP-LISTEN:11443,reuseaddr TUN:192.168.255.1/24,up | 
| 客户端 | socat TCP:1.2.3.4:11443 TUN:192.168.255.2/24,up |

#OPENSSL
需要一个证书,否则会失败提示: 2012/04/06 11:29:11 socat[1614] E SSL_connect(): 
error:14077410:SSL routines:SSL23_GET_SERVER_HELLO:sslv3 alert handshake failure
OPENSSL:<host>:<port> 目标机器host对应端口port
OPENSSL-LISTEN:<port> 本机监听端口。

证书生成
FILENAME=60.*.*.*
openssl genrsa -out $FILENAME.key 1024
openssl req -new -key $FILENAME.key -x509 -days 3653 -out $FILENAME.crtcat $FILENAME.key $FILENAME.crt >$FILENAME.pem
在当前目录下生成 server.pem 、server.crt
服务端     socat openssl-listen:4433,reuseaddr,cert=srv.pem,cafile=srv.crt system:bash,pty,stderr
本地      socat readline openssl:localhost:4433,cert=srv.pem,cafile=srv.crt


socat(socat, netcat, ser2net, remserial, conmux){
串口        /dev/tty.SLAB_USBtoUART   接入 MacBook Pro 的 cp2102
主机 IP     192.168.1.168             串口直连的主机 IP 地址
主机端口    54321                     虚拟化以后的端口
虚拟串口    /dev/tty.virt001

2.1 串口转 TCP 端口
    sudo socat tcp-l:54321,reuseaddr,fork file:/dev/tty.SLAB_USBtoUART,waitlock=/var/run/tty0.lock,clocal=1,cs8,nonblock=1,ixoff=0,ixon=0,ispeed=9600,ospeed=9600,raw,echo=0,crtscts=0
也可简单使用：
    sudo socat tcp-l:54321 /dev/tty.SLAB_USBtoUART,clocal=1,nonblock
    
2.2 TCP 端口转虚拟串口
    sudo socat pty,link=/dev/tty.virt001,waitslave tcp:192.168.1.168:54321
    
2.3 远程访问串口
    sudo minicom -D /dev/tty.virt001
或
    telnet 192.168.1.168 54321
}
socat(http://www.dest-unreach.org/socat/){
man socat # 
socat [options] <address> <address>
    其中这2个address就是关键了，如果要解释的话，address就类似于一个文件描述符，socat所做的工作就是在
2个address指定的描述符间建立一个pipe用于发送和接收数据。
那么address的描述就是socat的精髓所在了，几个常用的描述方式如下：
1. -,STDIN,STDOUT ：表示标准输入输出，可以就用一个横杠代替，这个就不用多说了吧….
2. /var/log/syslog : 也可以是任意路径，如果是相对路径要使用./，打开一个文件作为数据流。
3. TCP:: : 建立一个TCP连接作为数据流，TCP也可以替换为UDP
4. TCP-LISTEN: : 建立TCP监听端口，TCP也可以替换为UDP
5. EXEC: : 执行一个程序作为数据流。
以上规则中前面的TCP等都可以小写。
在这些描述后可以附加一些选项，用逗号隔开，如fork，reuseaddr，stdin，stdout，ctty等。
socat - -                # 直接回显
socat - /home/user/chuck # cat文件
echo "hello" | socat - /home/user/chuck # 写文件
nc localhost 80          # 连接远程端口
socat - TCP:localhost:80 # 连接远程端口
nc -lp localhost 700     # 监听端口
socat TCP-LISTEN:700 -   # 监听端口
nc -lp localhost 700 -e /bin/bash   # 正向shell
socat TCP-LISTEN:700 EXEC:/bin/bash # 正向shell
nc localhost 700 -e /bin/bash                                                 # 反弹shell
socat tcp-connect:localhost:700 exec:'bash -li',pty,stderr,setsid,sigint,sane # 反弹shell
socat TCP-LISTEN:80,fork TCP:www.domain.org:80 # 将本地80端口转发到远程的80端口
socat OPENSSL-LISTEN:443,cert=/cert.pem - # SSL服务器
需要首先生成证书文件
SSL客户端
socat - OPENSSL:localhost:443

socat -d -d /dev/ttyUSB1,raw,nonblock,ignoreeof,cr,echo=0 TCP4-LISTEN:5555,reuseaddr # fork服务器
socat READLINE,history=$HOME/.cmd_history /dev/ttyS0,raw,echo=0,crnl # 将终端转发到COM1

socat TCP4-LISTEN:188,reuseaddr,fork TCP4:192.168.1.22:123 & # 在本地监听188端口，并将请求转发至192.168.1.22的123端口
1. TCP4-LISTEN：在本地建立的是一个TCP ipv4协议的监听端口；
2. reuseaddr：绑定本地一个端口；
3. fork：设定多链接模式，即当一个链接被建立后，自动复制一个同样的端口再进行监听
socat启动监听模式会在前端占用一个shell，因此需使其在后台执行。

1、串口转发
socat udp4-listen:11161,reuseaddr,fork UDP:[监控服务器IP]:161
udp4-listen：在本地建立的是一个udp ipv4协议的监听端口；
reuseaddr，绑定本地一个端口；
fork，设定多链接模式，即当一个链接被建立后，自动复制一个同样的端口再进行监听
AT串口/dev/ttyUSB1映射到5555端口：
socat -d -d /dev/ttyUSB1,raw,nonblock,ignoreeof,cr,echo=0 TCP4-LISTEN:5555,reuseaddr
转发到minicom终端： socat /dev/ttyUSB1,raw,nonblock,ignoreeof,cr,echo=0 /dev/ttyS1,raw
转发到终端(电脑端)： socat /dev/ttyUSB1,raw,nonblock,ignoreeof,cr,echo=0 /dev/tty,raw

2. NAT
外部：
socat tcp-listen:1234 tcp-listen:3389
內部：
socat tcp:outerhost:1234 tcp:192.168.12.34:3389
這樣，你外部機器上的3389就影射在內部網192.168.12.34的3389端口上。
}
nc(netcat){
cat file | nc -l 32981
nc localhost 32981 > file

nc -l 32981 | nc www.amazon.com 80

mkfifo pipe 
nc -l 32981 < pipe | nc www.amazon.com 80 > pipe
}
bash(here){
1. here document
# [n] << [-] word
# here-document
# word
# 
# cat <<EOF > /tmp/test
# this is here doc!
# date
# $HOME
# EOF

tr a-z A-Z << END_TEXT 
one two three 
four five six 
END_TEXT

tr a-z A-Z <<- END_TEXT 
one two three 
four five six 
END_TEXT

2. string document # [n]<<< word
tr a-z A-Z <<< one
tr a-z A-Z <<< 'one two three'
FOO='one two three'
tr a-z A-Z <<< $FOO
tr a-z A-Z <<< 'one
two three'
bc <<< 2^10

read a b c <<< 'one two three' 
echo $a $b $c
}
bash(Linux bash shell 逐行读取文件的三种方法){
方法一，指定换行符读取
#! /bin/bash  
  
IFS=" "   
for LINE in `cat /etc/passwd`  
do   
    echo $LINE 
done

如果 for 循环中循环访问的文件名含有空字符(空格、tab 等字符)，只需用 IFS=$'\n' 把内部字段分隔符设为换行符。

方法二，文件重定向给read处理：
#! /bin/bash  
  
cat /etc/passwd | while read LINE  
do
    echo $LINE 
done
 

方法三，用read读取文件重定向：
#! /bin/bash  
while read LINE
do
    echo $LINE 
done < /etc/passwd

访问二和三比较相似，推荐用方法三
}
system(process){
    cat /proc/loadavg  # 查看系统负载
    uptime(09:38:44 up 15:48, load average: 0.00, 0.01, 0.04)
    # 显示平均负载，此项也经常在其他工具中显示。其分别显示1,5,15分钟的负载 如果负载值大于
    # CPU数，这可能意味着CPU饱和了，或线程遭受调度延迟，也可能有磁盘IO的因素，使用其他工具进一步调查
    taskset [-p] [mask] [pid | command [arg]...]
    taskset 03 sshd -b 1024 #启动一个进程并设置进程的亲和性
    taskset -p 700 #获取一个进程的CPU亲和性
    taskset -p 03 700 #设置一个进程的CPU亲和性
    taskset -pc 0,3,7-11 700 #以列表的形式，设置进程的亲和性
    
    top # display and update the top cpu processes
    mpstat 1 # display processors related statistics
    vmstat 2 # display virtual memory statistics
    iostat 2 # display I/O statistics (2 s intervals)
    ipcs -a # information on System V interprocess
    
    sync();
    top(termios);
    ps(top,iotop,ps,pskill,termios);
    ionice(ioprio_get, ioprio_set, cfq);
    iorenice(ioprio_get, ioprio_set, cfq);
    inotifyd(inotify, poll){
inotifyd PROG FILE1[:MASK] ...
Run PROG on filesystem changes. When a filesystem event matching MASK occurs on FILEn, 
PROG <actual_event(s)> <FILEn> [<subfile_name>] is run. Events:
        a       File is accessed
        c       File is modified
        e       Metadata changed
        w       Writable file is closed
        0       Unwritable file is closed
        r       File is opened
        D       File is deleted
        M       File is moved
        u       Backing fs is unmounted
        o       Event queue overflowed
        x       File can not be watched anymore
If watching a directory:
        m       Subfile is moved into dir
        y       Subfile is moved out of dir
        n       Subfile is created
        d       Subfile is deleted

inotifyd waits for PROG to exit. When x event happens for all FILEs, inotifyd exits
    }
    
fuser [-a|-s|-c] [-4|-6] [-n  space ] [-k [-i] [-signal ] ] [-muvf] name ...
    fuser(){ 可以显示出当前哪个程序在使用磁盘上的某个文件、挂载点、甚至网络端口，并给出程序进程的详细信息.
fuser显示使用指定文件或者文件系统的进程ID.默认情况下每个文件名后面跟一个字母表示访问类型。
-k 杀掉访问文件的进程。如果没有指定-signal就会发送SIGKILL信号。
-signal 使用指定的信号，而不是用SIGKILL来杀掉进程。

-i 杀掉进程之前询问用户，如果没有-k这个选项会被忽略。
-l 列出所有已知的信号名称。
-a 显示所有命令行中指定的文件，默认情况下被访问的文件才会被显示。 
-c 和-m一样，用于POSIX兼容。

-n name/space
         # udp/tcp names: [local_port][,[rmt_host][,[rmt_port]]]
fuser -va 22/tcp # List processes using port 22 (Linux)
fuser -va /home # List processes accessing the /home partition

fuser -s /dev/ttyS
sync && fuser -m /dev/hda1 -k     # 使用这条命令后一定可以卸载 

lsof -i # 列出所有网络连接的进程 
lsof -i:22 # 列出占用端口22的进程
    
fuser能识别出正在对某个文件或端口访问的所有进程，类似于lsof。
fuser [option] filename 
举例
fuser /home/work/wahaha.txt     #列出所有使用/home/work/wahaha.txt文件的进程  
fuser -v /home/work/wahaha.txt  #列出进程的详细信息，而不仅仅是进程id  
fuser -u /home/work/wahaha.txt  #同时列出进程的user  
fuser -k /home/work/wahaha.txt  #杀死所有正在使用/home/work/wahaha.txt文件的进程  
fuser -k SIGHUP /home/work/wahaha.txt  #向所有正在使用/home/work/wahaha.txt文件的进程发送HUP信号  
fuser -l   #列出所有支持的信号

快速释放本地指定端口
    方法一： 简单粗暴的办法1
$ lsof -i:端口号
$ kill -s SIGKILL 进程号

方法二： 简单粗暴的办法2
$ fuser -k 9999/tcp # 杀死占用9999/tcp端口的进程

方法三： 稍微稳妥的办法
$ lsof -i # 列出所有网络连接的进程
$ fuser -k 9999/tcp
    }
lsof -h # 有实例
Defaults in parentheses; comma-separated set (s) items; dash-separated ranges.
  -?|-h list help          -a AND selections (OR)     -b avoid kernel blocks
  -c c  cmd c ^c /c/[bix]  +c w  COMMAND width (9)
  +d s  dir s files        -d s  select by FD set     +D D  dir D tree *SLOW?*
                           +|-e s  exempt s *RISKY*   -i select IPv[46] files
  -l list UID numbers      -n no host names           -N select NFS files
  -o list file offset      -O avoid overhead *RISKY*  -P no port names
  -R list paRent PID       -s list file size          -t terse listing
  -T disable TCP/TPI info  -U select Unix socket      -v list version info
  -V verbose search        +|-w  Warnings (+)         -X skip TCP&UDP* files
  -Z Z  context [Z]
  -- end option scan
  +f|-f  +filesystem or -file names     +|-f[gG] flaGs
  -F [f] select fields; -F? for help
  +|-L [l] list (+) suppress (-) link counts < l (0 = all; default = 0)
                                        +m [m] use|create mount supplement
  +|-M   portMap registration (-)       -o o   o 0t offset digits (8)
  -p s   exclude(^)|select PIDs         -S [t] t second stat timeout (15)
  -T qs TCP/TPI Q,St (s) info
  -g [s] exclude(^)|select and print process group IDs
  -i i   select by IPv[46] address: [46][proto][@host|addr][:svc_list|port_list]
  +|-r [t[m<fmt>]] repeat every t seconds (15);  + until no files, - forever.
       An optional suffix to t is m<fmt>; m must separate t from <fmt> and
      <fmt> is an strftime(3) format for the marker line.
  -s p:s  exclude(^)|select protocol (p = TCP|UDP) states by name(s).
  -u s   exclude(^)|select login|UID set s
  -x [fl] cross over +d|+D File systems or symbolic Links
  names  select named files or files on named file systems

output: -F -g -l -n -P -o -s
network: -i -s
directory: +d +D (-x fl)
system: -u -p -g -c
lsof 查看已打开的文件
文件包括:
普通文件、目录、块文件、特殊字符文件、可执行文件、共享库、管道、符号链接、
Socket流、网络Socket、NFS文件(-N)、UNIX域socket(-U)。

查看方式:
1. 查看进程打开的文件；
2. 查看打开文件的进程；
3. 查看进程打开的端口；
4. 找回/恢复删除的文件；
输出内容可以被其他程序识别，见-F和“OUTPUT FOR OTHER PROGRAMS”
输出默认是循环模式，具体见 +|-r[t[m<fmt>]]
negated: -u UID指定用户 -p PID指定进程 -g PGID指定进程组 -c command指定命令名 -s [p:s]指定流 

    lsof(){  lsof替代了netstat和ps的全部工作
-a     ANDed 后续选项都是AND方式过滤, 输出符合所有条件的被打开文件
-b     lstat(2),  readlink(2), stat(2) 防止调用这些函数而被内核阻塞
-c     cmd c ^c /regular expr/[bix] # <进程名>   列出指定进程所打开的文件 '^'取反
       b:basic regluar i:ignore case x:extended regluar
       lsof -c /^..o.$/i -a -d cwd
       kill -HUP `lsof -t -c sshd`
+c     w COMMAND width (9)   # w=0,输出全部名称 w<COMMAND输出长度为'COMMAND', w>COMMAND输出长度大于COMMAND
       UNIX通常将命令名限制在16个内，
-d s   select by FD set      # 输出列表中排除或包含的文件描述符(FD)列表。
       'cwd,1,3' 或 '^6,^2' 或 '0-7' 或 '^0-7'
+d<目录> 限定在具有stat权限的文件 # 列出指定目录下被打开的文件，不列出子目录下被打开文件，
        除非指定-x  l或-x，否则被打开的链接文件不列出；除非指定-x  l或-x，否则被打开的subfilesystem(mount)文件不列出。
-d<文件号> 列出占用该文件号的进程
+D<目录> 限定在具有stat权限的文件 # 递归列出目录下被打开的文件 
         除非指定-x  l或-x，否则被打开的链接文件不列出；
+|-e s 免除路径名为s的文件系统受到可能阻塞的内核函数调用。 +e(stat,lstat,readlink) -e(stat,lstat)
-F f   # OUTPUT FOR OTHER PROGRAMS
       lsof -F ? 查阅
-g  '123' '123,^456' # exclude(^)|选择并打印进程组ID
-l  使用用户ID而不是登录名
+|-L [l] 启用(+)或禁用(-)文件链接计数列表,它们可用-例如,它们不适用于套接字或大多数FIFO和管道.
         如果指定+L且没有跟数字, 则将列出所有链接计数。
         指定-L(默认值)时，不会列出任何链接计数。
         当+L后跟一个数字时，只列出链接数小于该数字的文件。(没有数字可以跟随-L)
-n  不进行地址反解析
-N NFS文件系统
-p s '123' '123,^456' # 选择PID
-P  不进行port反解析成服务名
-o # 将SIZE/OFF输出列标题更改为OFFSET 偏移量
+|-r [t[m<fmt>]] repeat模式，-r无限循环，
    lsof +d /usr/sbin/ +r 4m"%a %d %b %Y %T"
    lsof -rm====%T====
    lsof -r "m==== %T ===="
-R PPID 显示PPID
-S [t]  stat lstat readlink 调用超时时间
-t 选项只返回PID
-T TCP|TPI # lsof -i -Tqs
-u 'abe',  '548,root'  列出UID号进程详情
-U 'UNIX domain socket files'
-x  [fl] # +d +D
    f: parameter enables file system mount point cross-over processing
    l:symbolic  linkcross-over processing
-Z Selinux
lsof  # 不带任何参数运行，列出所有进程打开的所有文件

# 普通文件
lsof /etc/passwd    #那个进程在占用/etc/passwd 
lsof /dev/hd4       # 硬件设备
lsof /dev/log       # 日志文件
lsof $(which httpd) #那个进程在使用apache的可执行文件
lsof -d txt         # programs loaded in memory and executing
lsof abc.txt        # 显示开启文件abc.txt的进程
# 目录
lsof +D /usr/lib   #那个进程在使用/usr/lib目录下的文件 lsof | grep '/usr/lib'
# 字符或设备文件
lsof /dev/hda6     #那个进程在占用hda6 
lsof /dev/cdrom    #那个进程在占用光驱
# 进程
lsof -c mysql -c apache  # 列出多个程序多打开的文件信息
lsof -c apache -c python # 列出多个程序多打开的文件信息
lsof -p 1                # 单个进程
lsof -p 123,456,789      # 多个进程
lsof -p ^1               # 除了某个进程号
# 用户
lsof -u test -c mysql   # 列出某个用户以及某个程序所打开的文件信息
lsof   -u ^root     # 列出除了某个用户外的被打开的文件信息
lsof -u daniel      # Show what a given user has open using -u
lsof -u rms,root    # lsof -u rms -u root
lsof -g 1234        # group id
lsof -u ^daniel     # EXCEPT ^daniel
备注：^这个符号在用户名之前，将会把是root用户打开的进程不让显示
# 网络
lsof -i             # 列出所有的网络连接
1. -i选项
lsof -i[46][protocol][@hostname|hostaddr][:service|port]
--> IPv4 or IPv6
  protocol --> TCP or UDP
  hostname --> Internet host name
  hostaddr --> IPv4地址
  service --> /etc/service中的 service name (可以不止一个)
  port --> 端口号 (可以不止一个)
2. -i选项下的-s选项
lsof -s [p:s] 
--> -iTCP -sTCP:LISTEN
CLOSED,  IDLE,  BOUND,  LISTEN,  ESTABLISHED,  SYN_SENT,  SYN_RCDV, ESTABLISHED, CLOSE_WAIT,  FIN_WAIT1,  CLOSING, LAST_ACK, FIN_WAIT_2, and TIME_WAIT
--> -iUDP -sUDP:Idle
Unbound and Idle
lsof -i 4 -a -p 1234
lsof -i 6           # IPv6 
lsof -i tcp         # 列出所有tcp 网络连接信息
lsof -i -sTCP:LISTEN # lsof -i | grep -i LISTEN
lsof -i -sTCP:ESTABLISHED # lsof -i | grep -i ESTABLISHED
lsof -i udp         # 列出所有udp网络连接信息
lsof -i :3306       # 列出谁在使用某个端口
lsof -i :snmp       # 列出谁在使用某个端口
lsof -i udp:55      # 列出谁在使用某个特定的udp端口
lsof -i UDP:who     # UDP who service port
lsof -i tcp:80      # 特定的tcp端口
lsof -i TCP:25      # TCP and port 25
lsof -i @1.2.3.4    # Internet IPv4 host address 1.2.3.4
lsof -i @[3ffe:1ebc::1]:1234 # Internet IPv6 host address 3ffe:1ebc::1, port 1234
lsof -i @wonderland.cc.purdue.edu:513-515
lsof -i TCP@lsof.itap:513 # TCP, port 513 and host name lsof.itap 
lsof -i tcp@foo:1-10,smtp,99  # TCP, ports 1 through 10, service name smtp, port 99, host name foo
lsof -i tcp@bar:1-smtp #  TCP, ports 1 through smtp, host bar
lsof -i :time # either TCP, UDP or UDPLITE time service port

lsof  -a -u test -i # 列出某个用户的所有活跃的网络端口
lsof -N             # Network File System
lsof -U             # Unix domain socket files
# 关联关系
lsof -a -u pkrumins -c bash # -a AND
lsof -u pkrumins -c apache  # OR
lsof -d mem         # memory-mapped
lsof -i@172.16.12.5 # @host
lsof -i@172.16.12.5:22 # @host:22
lsof -t -c Mail     # Mail命令的PID
lsof -t -i          # 所有与网络相关的程序
lsof -r 1 -u john -i -a # Repeat listing files.
    
[FD：文件描述符，应用程序通过文件描述符识别该文件。如cwd、txt等]
(1)cwd：表示current work dirctory，即：应用程序的当前工作目录，这是该应用程序启动的目录，除非它本身对这个目录进行更改
(2)txt ：该类型的文件是程序代码，如应用程序二进制文件本身或共享库，如上列表中显示的 /sbin/init 程序
(3)lnn：library references (AIX);
(4)er：FD information error (see NAME column);
(5)jld：jail directory (FreeBSD);
(6)ltx：shared library text (code and data);
(7)mxx ：hex memory-mapped type number xx.
(7)mxx ：hex memory-mapped type number xx.
(8)m86：DOS Merge mapped file;
(9)mem：memory-mapped file;
(10)mmap：memory-mapped device;
(11)pd：parent directory;
(12)rtd：root directory;
(13)tr：kernel trace file (OpenBSD);
(14)v86  VP/ix mapped file;
(15)0：表示标准输入
(16)1：表示标准输出
(17)2：表示标准错误
一般在标准输出、标准错误、标准输入后还跟着文件状态模式：r、w、u等
(1)u：表示该文件被打开并处于读取/写入模式
(2)r：表示该文件被打开并处于只读模式
(3)w：表示该文件被打开并处于
(4)空格：表示该文件的状态模式为unknow，且没有锁定
(5)-：表示该文件的状态模式为unknow，且被锁定
同时在文件状态模式后面，还跟着相关的锁
(1) N：for a Solaris NFS lock of unknown type;
(2) r：for read lock on part of the file;
(3) R：for a read lock on the entire file;
(4) w：for a write lock on part of the file;(文件的部分写锁)
(5) W：for a write lock on the entire file;(整个文件的写锁)
(6) u：for a read and write lock of any length;
(7) U：for a lock of unknown type;
(8) x：for an SCO OpenServer Xenix lock on part      of the file;
(9) X：for an SCO OpenServer Xenix lock on the      entire file;
(10) space：if there is no lock.

[TYPE：文件类型，如DIR、REG等，常见的文件类型]
(1) DIR：表示目录
(2) CHR：表示字符类型
(3) BLK：块设备类型
(4) UNIX： UNIX 域套接字
(5) FIFO：先进先出 (FIFO) 队列
(6) IPv4：网际协议 (IP) 套接字
    
    
    iotop()
    {
iotop -oP
命令的含义：只显示有I/O行为的进程
pidstat -d 1
命令的含义：展示I/O统计，每秒更新一次
    }
}


system(stream)
{
    tee(通过标准输入读取，并保存为标准输出和文件){
last | tee last.list | cut -d " " -f1 # 这个范例可以让我们将 last 的输出存一份到 last.list 文件中；
ls -l /home | tee ~/homefile | more   # 这个范例则是将 ls 的数据存一份到 ~/homefile ，同时屏幕也有输出讯息!
ls -l / | tee -a ~/homefile | more    # 要注意! tee 后接的文件会被覆盖，若加上 -a 这个选项则能将讯息累加。
    
ls | tee file # Write output to stdout, and also to a ﬁle
crontab -l | tee crontab-backup.txt | sed 's/old/new/' | crontab -
ls | tee file1 file2 file3 # write the output to multiple ﬁles
ls | tee -a file # Instruct tee command to append to the ﬁle
    }
    cat
    tac
    more
    tail # tail -f | less +F
    less
    head # wc、head 和 tail
}

adjtimex(busybox){
adjtimex [-q] [-o offset] [-f frequency] [-p timeconstant] [-t tick]
Read and optionally set system timebase parameters. See adjtimex(2).
Options:
    -q              Quiet
    -o offset       Time offset, microseconds
    -f frequency    Frequency adjust, integer kernel units (65536 is 1ppm)
                    (positive values make clock run faster)
    -t tick         Microseconds per tick, usually 10000
    -p timeconstant
}
acpid(busybox){
acpid [-d] [-c CONFDIR] [-l LOGFILE] [-e PROC_EVENT_FILE] [EVDEV_EVENT_FILE...]
Listen to ACPI events and spawn specific helpers on event arrival
Options:
    -d      Do not daemonize and log to stderr
    -c DIR  Config directory [/etc/acpi]
    -e FILE /proc event file [/proc/acpi/event]
    -l FILE Log file [/var/log/acpid]
Accept and ignore compatibility options -g -m -s -S -v
}
devmem(){
devmem ADDRESS [WIDTH [VALUE]]
Read/write from physical address
   ADDRESS Address to act upon
   WIDTH   Width (8/16/...)
   VALUE   Data to be written
}
dnsd(busybox){
dnsd [-c config] [-t seconds] [-p port] [-i iface-ip] [-d]
Small static DNS server daemon
Options:
   -c      Config filename
   -t      TTL in seconds
   -p      Listening port
   -i      Listening ip (default all)
   -d      Daemonize
}
install(busybox){
Usage: install [-cdDsp] [-o USER] [-g GRP] [-m MODE] [source] dest|directory
Copy files and set attributes
Options:
  -c      Just copy (default)
  -d      Create directories
  -D      Create leading target directories
  -s      Strip symbol table
  -p      Preserve date
  -o USER Set ownership
  -g GRP  Set group ownership
  -m MODE Set permissions
}
ipcalc(busybox){
ipcalc [OPTIONS] ADDRESS[[/]NETMASK] [NETMASK]
Calculate IP network settings from a IP address
Options:
  -b,--broadcast  Display calculated broadcast address
  -n,--network    Display calculated network address
  -m,--netmask    Display default netmask for IP
  -p,--prefix     Display the prefix for IP/NETMASK
  -h,--hostname   Display first resolved host name
  -s,--silent     Donot ever display error messages
}

nameif(busybox){
nameif [-s] [-c FILE] [{IFNAME MACADDR}]
Rename network interface while it in the down state
Options:
  -c FILE         Use configuration file (default: /etc/mactab)
  -s              Use syslog (LOCAL0 facility)
  IFNAME MACADDR  new_interface_name interface_mac_address
}
nmeter(busybox){
Usage: nmeter format_string
Monitor system in real time
Format specifiers:
 %Nc or %[cN]   Monitor CPU. N - bar size, default 10
                (displays: S:system U:user N:niced D:iowait I:irq i:softirq)
 %[niface]      Monitor network interface 'iface'
 %m             Monitor allocated memory
 %[mf]          Monitor free memory
 %[mt]          Monitor total memory
 %s             Monitor allocated swap
 %f             Monitor number of used file descriptors
 %Ni            Monitor total/specific IRQ rate
 %x             Monitor context switch rate
 %p             Monitor forks
 %[pn]          Monitor # of processes
 %b             Monitor block io
 %Nt            Show time (with N decimal points)
 %Nd            Milliseconds between updates (default:1000)
 %r             Print <cr> instead of <lf> at EOL
}
setlogcons(busybox){
setlogcons N
Redirect the kernel output to console N (0 for current)
}

chpst(busybox){
chpst [-vP012] [-u USER[:GRP]] [-U USER[:GRP]] [-e DIR]
    [-/ DIR] [-n NICE] [-m BYTES] [-d BYTES] [-o N]
    [-p N] [-f BYTES] [-c BYTES] PROG ARGS

Change the process state and run PROG
Options:
  -u USER[:GRP]   Set uid and gid
  -U USER[:GRP]   Set $UID and $GID in environment
  -e DIR          Set environment variables as specified by files
                  in DIR: file=1st_line_of_file
  -/ DIR          Chroot to DIR
  -n NICE         Add NICE to nice value
  -m BYTES        Same as -d BYTES -s BYTES -l BYTES
  -d BYTES        Limit data segment
  -o N            Limit number of open files per process
  -p N            Limit number of processes per uid
  -f BYTES        Limit output file sizes
  -c BYTES        Limit core file size
  -v              Verbose
  -P              Create new process group
  -0              Close standard input
  -1              Close standard output
  -2              Close standard error
}

chrt(busybox){
chrt [OPTIONS] [PRIO] [PID | PROG [ARGS]]
Manipulate real-time attributes of a process
Options:
  -p      Operate on pid
  -r      Set scheduling policy to SCHED_RR
  -f      Set scheduling policy to SCHED_FIFO
  -o      Set scheduling policy to SCHED_OTHER
  -m      Show min and max priorities
}
cksum(busybox){
cksum FILES...
  Calculate the CRC32 checksums of FILES
}
softlimit(busybox){
Usage: softlimit [-a BYTES] [-m BYTES] [-d BYTES] [-s BYTES] [-l BYTES]
        [-f BYTES] [-c BYTES] [-r BYTES] [-o N] [-p N] [-t N]
        PROG ARGS

Set soft resource limits, then run PROG

Options:
        -a BYTES        Limit total size of all segments
        -m BYTES        Same as -d BYTES -s BYTES -l BYTES -a BYTES
        -d BYTES        Limit data segment
        -s BYTES        Limit stack segment
        -l BYTES        Limit locked memory size
        -o N            Limit number of open files per process
        -p N            Limit number of processes per uid
Options controlling file sizes:
        -f BYTES        Limit output file sizes
        -c BYTES        Limit core file size
Efficiency opts:
        -r BYTES        Limit resident set size
        -t N            Limit CPU time, process receives
                        a SIGXCPU after N seconds
}
system(log){
syslogd(busybox){
syslogd -R masterlog:514
syslogd -R 192.168.1.1:601

syslogd [OPTIONS] 
System logging utility. Note that this version of syslogd ignores /etc/syslog.conf.

-n Run in foreground 
-O FILE Log to given file (default:/var/log/messages) 
-l n Set local log level

-S Smaller logging output
-s SIZE Max size (KB) before rotate (default:200KB, 0=off)
-b NUM Number of rotated logs to keep (default:1, max=99, 0=purge)
-R HOST[:PORT] Log to IP or hostname on PORT (default PORT=514/UDP)
-L Log locally and via network (default is network only if -R)

-D Drop duplicates
-C[size(KiB)] Log to shared mem buffer (read it using logread)
}
rsyslogd(){ chkconfig --list | grep rsyslog
rsyslogd 相比 syslogd 具有一些新的特点：
  基于TCP网络协议传输日志信息。
  更安全的网络传输方式。
  有日志信息的即时分析框架。
  后台数据库。
  在配置文件中可以写简单的逻辑判断。
  与syslog配置文件相兼容。

rsyslogd(日志文件){
系统中的重要日志文件
日志文件            说 明
/var/log/cron       记录与系统定时任务相关的曰志
/var/log/cups/      记录打印信息的曰志
/var/log/dmesg      记录了系统在开机时内核自检的信总。也可以使用dmesg命令直接查看内核自检信息
/var/log/btmp       记录错误登陆的日志。这个文件是二进制文件，不能直接用Vi查看，而要使用lastb命令查看。命令如下：
                    [root@localhost log]#lastb
                    root tty1 Tue Jun 4 22:38 - 22:38 (00:00)
                    #有人在6月4 日 22:38便用root用户在本地终端 1 登陆错误
/var/log/lasllog    记录系统中所有用户最后一次的登录时间的曰志。这个文件也是二进制文件.不能直接用Vi 查看。而要使用lastlog命令查看
/var/Iog/mailog     记录邮件信息的曰志
/var/log/message    记录系统里要佶息的日志.这个日志文件中会记录Linux系统的绝大多数重要信息。如果系统出现问题，首先要检查的应该就是这个日志文件
/var/log/secure     记录验证和授权方面的倍息，只要涉及账户和密码的程序都会记录，比如系统的登录、ssh的登录、su切换用户，sudo授权，甚至添加用户和修改用户密码都会记录在这个日志文件中
/var/log/wtmp       永久记录所有用户的登陆、注销信息，同时记录系统的后动、重启、关机事件。同样，这个文件也是二进制文件.不能直接用Vi查看，而要使用last命令查看
/var/tun/ulmp       记录当前已经登录的用户的信息。这个文件会随着用户的登录和注销而不断变化，只记录当前登录用户的信息。同样，这个文件不能直接用Vi查看，而要使用w、who、users等命令查看

日志文件          说明
/var/log/httpd/   RPM包安装的apache取务的默认日志目录
/var/log/mail/    RPM包安装的邮件服务的额外日志因录
/var/log/samba/   RPM色安装的Samba服务的日志目录
/var/log/sssd/    守护进程安全服务目录
}

rsyslogd(格式分析){
日志文件的格式包含以下 4 列：
  事件产生的时间。
  产生事件的服务器的主机名。
  产生事件的服务名或程序名。
  事件的具体信息。
  }
rsyslogd(rsyslog.conf配置文件的格式){
authpriv.* /var/log/secure
#服务名称[连接符号]日志等级 日志记录位置
#认证相关服务.所有日志等级 记录在/var/log/secure日志中

1. 服务名称
我们首先需要确定 rsyslogd 服务可以识别哪些服务的日志，也可以理解为以下这些服务委托 rsyslogd 服务来代为管理日志。这些服务如表 1 所示。
服务名称                说 明
auth(LOG AUTH)          安全和认证相关消息 (不推荐使用authpriv替代)
authpriv(LOG_AUTHPRIV)  安全和认证相关消息(私有的)
cron (LOG_CRON)         系统定时任务cront和at产生的日志
daemon (LOG_DAEMON)     与各个守护进程相关的曰志
ftp (LOG_FTP)           ftp守护进程产生的曰志
kern(LOG_KERN)          内核产生的曰志(不是用户进程产生的)
Iocal0-local7 (LOG_LOCAL0-7)    为本地使用预留的服务
lpr (LOG_LPR)           打印产生的日志
mail (LOG_MAIL)         邮件收发信息
news (LOG_NEWS)         与新闻服务器相关的日志
syslog (LOG_SYSLOG)     存syslogd服务产生的曰志信息(虽然服务名称己经改为reyslogd，但是很多配罝依然沿用了 syslogd服务的，所以这里并没有修改服务名称)
user (LOG_USER)         用户等级类别的日志信息
uucp (LOG_UUCP>         uucp子系统的日志信息，uucp是早期Linux系统进行数据传递的协议，后来 也常用在新闻组服务中
这些日志服务名称是rsyslogd服务自己定义的，并不是实际的Linux的服务。当有服务需要由rsyslogd服务来帮助管理日志时，只需要调用这些服务名称就可以实现日志的委托管理。

2. 连接符号
日志服务连接日志等级的格式如下：
日志服务[连接符号]日志等级 日志记录位置
在这里，连接符号可以被识别为以下三种。
  "."代表只要比后面的等级高的(包含该等级)日志都记录。比如，"cron.info"代表cron服务产生的日志，只要日志等级大于等于info级别，就记录。
  ".="代表只记录所需等级的日志，其他等级的日志都不记录。比如，"*.=emerg"代表人和日志服务产生的日志，只要等级是emerg等级，就记录。这种用法极少见，了解就好。
  ".!"代表不等于，也就是除该等级的日志外，其他等级的日志都记录。

3. 日志等级
等级名称                说 明
debug (LOG_DEBUG)       一般的调试信息说明
info (LOG_INFO)         基本的通知信息
nolice (LOG_NOTICE)     普通信息，但是有一定的重要性
warning(LOG_WARNING)    警吿信息，但是还不会影响到服务或系统的运行
err(LOG_ERR)            错误信息, 一般达到err等级的信息已经可以影响到服务成系统的运行了
crit (LOG_CRIT)         临界状况信思，比err等级还要严®
alert (LOG_ALERT)       状态信息，比crit等级还要严重，必须立即采取行动
emerg (LOG_EMERG)       疼痛等级信息，系统已经无法使用了
*                       代表所有日志等级。比如，"authpriv.*"代表amhpriv认证信息服务产生的日志，所有的日志等级都记录
日志等级还可以被识别为"none"。如果日志等级是none，就说明忽略这个日志服务，该服务的所有日志都不再记录。

4. 日志记录位置
日志文件的绝对路径。这是最常见的日志保存方法，如"/var/log/secure"就是用来保存系统验证和授权信息日志的。
系统设备文件。如"/dev/lp0"代表第一台打印机，如果日志保存位置是打印机设备，当有日志时就会在打印机上打印。
转发给远程主机。因为可以选择使用 TCP 和 UDP 协议传输日志信息，所以有两种发送格式：如果使用"@192.168.0.210：514"，就会把日志内容使用 UDP 协议发送到192.168.0.210 的 UDP 514 端口上；如果使用"@@192.168.0.210：514"，就会把日志内容使用 TCP 协议发送到 192.168.0.210 的 TCP 514 端口上，其中 514 是日志服务默认端口。当然，只要 192.168.0.210 同意接收此日志，就可以把日志内容保存在日志服务器上。
用户名。如果是"root"，就会把日志发送给 root 用户，当然 root 要在线，否则就收不到日志信息了。发送日志给用户时，可以使用"*"代表发送给所有在线用户，如"mail.**"就会把 mail 服务产生的所有级别的日志发送给所有在线用户。如果需要把日志发送给多个在线用户，则用户名之间用"，"分隔。
忽略或丢弃日志。如果接收日志的对象是"~"，则代表这个日志不会被记录，而被直接丢弃。如"local3.* ~"代表忽略 local3 服务类型所有的日志都不记录。
}
rsyslogd(cs){
1. Server:
vi /etc/rsyslog.conf
…省略部分输出…
# Provides TCP syslog reception
$ModLoad imtcp
$InputTCPServerRun 514
2. client
vi /etc/rsyslog.conf
#修改日志服务配置文件
*.* @@192.168.0.210：514
#把所有日志采用TCP协议发送到192.168.0.210的514端口上
}
rsyslogd(日志转储){
    主要依靠 /etc/logrotate.conf 配置文件中的"dateext"参数。
    如果配置文件中有"dateext"参数，那么日志会用日期来作为日志文件的后缀，如"secure-20130605"。
这样日志文件名不会重叠，也就不需要对日志文件进行改名，只需要保存指定的日志个数，删除多余的日志文件即可。
    如果配置文件中没有"dateext"参数，那么日志文件就需要进行改名了。当第一次进行日志轮替时，
当前的"secure"日志会自动改名为"secure.1"，然后新建"secure"日志，用来保存新的日志；
当第二次进行日志轮替时，"secure.1"会自动改名为"secure.2"，当前的"secure"日志会自动改名为"secure.1"，
然后也会新建"secure"日志，用来保存新的日志；以此类推。

 logrotate配置文件的主要参数
参 致                     参数说明
daily                    日志的轮替周期是毎天
weekly                   日志的轮替周期是每周
monthly                  日志的轮控周期是每月
rotate数宇               保留的日志文件的个数。0指没有备份
compress                 当进行日志轮替时，对旧的日志进行压缩
create mode owner group  建立新日志，同时指定新日志的权限与所有者和所属组.如create 0600 root utmp
mail address             当进行日志轮替时.输出内存通过邮件发送到指定的邮件地址
missingok                如果日志不存在，则忽略该日志的警告信息
nolifempty               如果曰志为空文件，則不进行日志轮替
minsize 大小             日志轮替的最小值。也就是日志一定要达到这个最小值才会进行轮持，否则就算时间达到也不进行轮替
size大小                 日志只有大于指定大小才进行日志轮替，而不是按照时间轮替，如size 100k
dateext                  使用日期作为日志轮替文件的后缀，如secure-20130605
sharedscripts            在此关键宇之后的脚本只执行一次
prerotate/cndscript      在日志轮替之前执行脚本命令。endscript标识prerotate脚本结束
postrolaie/endscripl     在日志轮替之后执行脚本命令。endscripi标识postrotate脚本结束
这些参数中较为难理解的应该是 prerotate/endscript 和 postrotate/endscript，

这里有两种方法：
第一种方法是直接在 /etc/logrotate.conf 配置文件中写入该日志的轮替策略，从而把日志加入轮替；
第二种方法是在 /etc/logrotate.d/ 目录中新建立该日志的轮替文件，在该轮替文件中写入正确的轮替策略，因为该目录中的文件都会被包含到主配置文件中，所以也可以把日志加入轮替。
}

rsyslogd(logrotate){  vi /etc/cron.daily/logrotate
logrotate [选项] 配置文件名
选项：
如果此命令没有选项，则会按照配置文件中的条件进行日志轮替
-v： 显示日志轮替过程。加入了-v选项，会显示日志的轮替过程
-f： 强制进行日志轮替。不管日志轮替的条件是否符合，强制配置文件中所有的日志进行轮替
}
logwatch(rsyslogd){
yum -y install logwatch
cp /usr/share/logwatch/default.conf/logwatch.conf /etc/logwatch/conf/logwatch.conf
#查看配置文件
LogDir = /var/log
#logwatch会分析和统计/var/log/中的日志
TmpDir = /var/cache/logwatch
#指定logwatch的临时目录
MailTo = root
#日志的分析结果，给root用户发送邮件
MailFrom = Logwatch
#邮件的发送者是Logwatch，在接收邮件时显示
Print =
#是否打印。如果选择"yes"，那么日志分析会被打印到标准输出，而且不会发送邮件。我们在这里不打印，#而是给root用户发送邮件
#Save = /tmp/logwatch
#如果开启这一项，日志分析就不会发送邮件，而是保存在/tmp/logwatch文件中
#如果开启这一项，日志分析就不会发送邮件，而是保存在/tmp/logwatch文件中
Range = yesterday
#分析哪天的日志。可以识别"All""Today""Yesterday"，用来分析"所有日志""今天日志""昨天日志"
Detail = Low
#日志的详细程度。可以识别"Low""Med""High"。也可以用数字表示，范围为0～10，"0"代表最不详细，"10"代表最详细
Service = All
#分析和监控所有日志
Service = "-zz-network"
#但是不监控"-zz-network"服务的日志。"-服务名"表示不分析和监控此服务的日志
Service = "-zz-sys"
Service = "-eximstats"

}
}
    syslog(file){
        /var/log/cron 	例行工作日志
        /var/log/dmesg 	内核检测过程中分析的系统硬件信息
        /var/log/lastlog 	记录系统上账号最近一次登录的信息
        /var/log/mailog或/var/log/mail/* 	记录邮件往来信息
        /var/log/messages 	系统发生的重要信息(比如错误信息)
        /var/log/secure 	记录涉及到输入用户账号密码时的信息
        /var/log/wtmp,/var/log/failog 	记录正确登录的用户信息,记录错误登录的用户信息
        /var/log/httpd/,/var/log/news/,/var/log/samba/*... 	个别服务制定的日志文件
    }
    syslog(services){
        Linux用于管理日志文件有syslogd/rsyslog,klogd这两个服务与logrotate这个程序
        syslogd/rsyslog: rsyslog已经代替syslogd,其会把系统各种信息分类,放置到相应的日志文件中.
        klogd: 记录内核产生的各项信息
        logrotate:日志文件的轮替,由于时间久了,日志文件会越来越大,影响读取,故将旧文件替换
    }
    logwatch(){}
    rsyslog(){
    系统产生的信息经由rsyslog记录,会产生下面格式的日志信息.
Aug 17 16:36:09 kumho-Inspiron-3421 postfix/pickup[1524]: 6BCA960072: uid=1000 from=<kumho@kumho-Inspiron-3421>
其记录的几个重要数据,时间发生的日期与时间,发生此事件的主机名,启动此事件的服务名称或函数,该信息的实际数据内容

rsyslog的配置文件
    rsyslog的配置文件是/etc/rsyslog.conf与/etc/rsyslog.d/_,通常/etc/rsyslog.conf负责整体的配置信息,/etc/rsyslog.d/_则是负责配置输出的日志信息与日志文件的对应.比如以下是/etc/rsyslog.d/50-default.conf的内容
    
    auth,authpriv.*                 /var/log/auth.log
    *.*;auth,authpriv.none          -/var/log/syslog
    cron.*                         /var/log/cron.log
    daemon.*                       -/var/log/daemon.log
    kern.*                          -/var/log/kern.log
    lpr.*                          -/var/log/lpr.log
    mail.*                          -/var/log/mail.log
    mail.err                        /var/log/mail.err
    其分为日志信息与输出文件两部分
日志信息分类
    因为系统产生的信息各式各样,所以对这些信息进行了分类,如下表
    类型名 	含义
    auth(authpriv) 	主要与认证有关的信息,比如login,su,ssh登录时产生的信息
    cron 	例行工作调度cron/at等信息
    daemon 	与各个daemon有关的信息
    kern 	内核产生的信息
    lpr 	打印相关的信息
    mail 	邮件相关的信息记录
    news 	新闻组信息
    syslog 	就是syslog/rsyslog本身产生的信息
    user,uucp,local0~local7 	与机器相关的一些信息
日志信息等级及连接符
    日志信息等级用来描述事情的情况,如下表
    等级 	名称 	说明
    0 	none 	不输出任何信息
    1 	debug 	调试信息
    2 	info 	基本信息说明
    3 	notice 	注意事项说明
    4 	waring(warn) 	警告信息,但不影响运行
    5 	err(error) 	错误信息,已造成不能运行
    6 	crit 	比err严重,到临界点了
    7 	alert 	比crit还严重
    8 	emerg(panic) 	通常是硬件出错,内核已经无法运行的程度
        . 表示大于等于后接等级的日志信息都会记录
            .* 任意等级
        .= 表示只有等于后接等级的日志信息才记录
        != 表示不等于后接等级的日志信息都会记录
输出日志文件或设备或主机
    我们需要在配置文件中指定日志输出的地方,其可以是如下:
        一般文件: 以绝对路径书写
        设备文件: 比如打印机(/dev/lp0)等
        用户名称: 显示给用户
        远程主机: @对方IP或@域名,需要对方也支持rsyslog服务
        * : 当前系统在线的用户(相当于wall)
    当输出文件前有-,表示日志信息先存在内存中,等数据量大才写入硬盘中.
    }
    logrotate(){
    
1. (根据rotate.conf的设置进行操作，并显示详细信息。)
/usr/sbin/logrotate -v /etc/rotate.conf   
2. (根据rotate.conf的设置进行执行，并显示详细信息,但是不进行具体操作，debug模式)
/usr/sbin/logrotate -d /etc/rotate.conf   
3. (各log文件的具体执行情况)
vi /var/lib/logrotate.status  
4. (通过rpm包安装的软件的logrotate信息会自动添加于此)
ls /etc/logrotate.d/

日志文件的管理：
    1、logrotate 配置
    2、缺省配置 logrotate
    3、使用include 选项读取其他配置文件
    4、使用include 选项覆盖缺省配置
    5、为指定的文件配置转储参数
logrotate 配置
    参数 功能
    compress 通过gzip 压缩转储以后的日志
    nocompress 不需要压缩时，用这个参数
    copytruncate 用于还在打开中的日志文件，把当前日志备份并截断
    nocopytruncate 备份日志文件但是不截断
    create mode owner group 转储文件，使用指定的文件模式创建新的日志文件
    nocreate 不建立新的日志文件
    delaycompress 和 compress 一起使用时，转储的日志文件到下一次转储时才压缩
    nodelaycompress 覆盖 delaycompress 选项，转储同时压缩。
    errors address 专储时的错误信息发送到指定的Email 地址
    ifempty 即使是空文件也转储，这个是 logrotate 的缺省选项。
    notifempty 如果是空文件的话，不转储
    mail address 把转储的日志文件发送到指定的E-mail 地址
    nomail 转储时不发送日志文件
    olddir directory 转储后的日志文件放入指定的目录，必须和当前日志文件在同一个文件系统
    noolddir 转储后的日志文件和当前日志文件放在同一个目录下
    prerotate/endscript 在转储以前需要执行的命令可以放入这个对，这两个关键字必须单独成行
    postrotate/endscript 在转储以后需要执行的命令可以放入这个对，这两个关键字必须单独成行
    daily 指定转储周期为每天
    weekly 指定转储周期为每周
    monthly 指定转储周期为每月
    rotate count 指定日志文件删除之前转储的次数，0 指没有备份，5 指保留5 个备份
    tabootext [+] list 让logrotate 不转储指定扩展名的文件，缺省的扩展名是：.rpm-orig, .rpmsave, v, 和 ~
    size size 当日志文件到达指定的大小时才转储，Size 可以指定 bytes (缺省)以及KB (sizek)或者MB (sizem).
缺省配置 logrotate
    # see "man logrotate" for details
    # rotate log files weekly
    weekly
    
    # keep 4 weeks worth of backlogs
    rotate 4
    
    # send errors to root
    errors root
    # create new (empty) log files after rotating old ones
    create
    
    # uncomment this if you want your log files compressed
    #compress
    1
    # RPM packages drop log rotation information into this directory
    include /etc/logrotate.d
    
    # no packages own lastlog or wtmp --we'll rotate them here
    /var/log/wtmp {
    monthly
    create 0664 root utmp
    rotate 1
    }
    
    /var/log/lastlog {
    monthly
    rotate 1
    }
    
    # system-specific logs may be configured here
    
    
    缺省的配置一般放在logrotate.conf 文件的最开始处，影响整个系统。在本例中就是前面12行。
    
    第三行weekly 指定所有的日志文件每周转储一次。
    第五行 rotate 4 指定转储文件的保留 4份。
    第七行 errors root 指定错误信息发送给root。
    第九行create 指定 logrotate 自动建立新的日志文件，新的日志文件具有和
    原来的文件一样的权限。
    第11行 #compress 指定不压缩转储文件，如果需要压缩，去掉注释就可以了。
使用include 选项读取其他配置文件
    include 选项允许系统管理员把分散到几个文件的转储信息，集中到一个
    主要的配置文件。当 logrotate 从logrotate.conf 读到include 选项时，会从指定文件读入配置信息，就好像他们已经在/etc/logrotate.conf 中一样。
    第13行 include /etc/logrotate.d 告诉 logrotate 读入存放在/etc/logrotate.d 目录中的日志转储参数，当系统中安装了RPM 软件包时，使用include 选项十分有用。RPM 软件包的日志转储参数一般存放在/etc/logrotate.d 目录。
使用include 选项覆盖缺省配置
    当 /etc/logrotate.conf 读入文件时，include 指定的文件中的转储参数将覆盖缺省的参数，如下例：

    # linuxconf 的参数
    /var/log/htmlaccess.log
    { errors jim
    notifempty
    nocompress
    weekly
    prerotate
    /usr/bin/chattr -a /var/log/htmlaccess.log
    endscript
    postrotate
    /usr/bin/chattr +a /var/log/htmlaccess.log
    endscript
    }
    /var/log/netconf.log
    { nocompress
    monthly
    }
    
    在这个例子中，当 /etc/logrotate.d/linuxconf 文件被读入时，下面的参数将覆盖/etc/logrotate.conf中缺省的参数。
    
    Notifempty
    errors jim
为指定的文件配置转储参数
    经常需要为指定文件配置参数，一个常见的例子就是每月转储/var/log/wtmp。为特定文件而使用的参数格式是：
    # 注释
    /full/path/to/file
    {
    option(s)
    }
    
    下面的例子就是每月转储 /var/log/wtmp 一次：
    #Use logrotate to rotate wtmp
    /var/log/wtmp
    {
    monthly
    rotate 1
    }

其他需要注意的问题
    1、尽管花括号的开头可以和其他文本放在同一行上，但是结尾的花括号必须单独成行。
    2、使用 prerotate 和 postrotate 选项
    下面的例子是典型的脚本 /etc/logrotate.d/syslog，这个脚本只是对
    /var/log/messages 有效。
    
    /var/log/messages
    {
    prerotate
    /usr/bin/chattr -a /var/log/messages
    endscript
    postrotate
    /usr/bin/kill -HUP syslogd
    /usr/bin/chattr +a /var/log/messages
    endscript
    }
    
    第一行指定脚本对 /var/log messages 有效
    花括号外的/var/log messages
    }
}

system(ascii){
base64 
    Base64是网络上最常见的用于传输8Bit字节代码的编码方式之一，大家可以查看RFC2045～RFC2049，上面有MIME的详细规范。
    Base64编码可用于在HTTP环境下传递较长的标识信息。
加密字串：echo -n "Hi, I am Hevake Lee" | base64 
加密文件: base64 photo.jpg
解密方法与加密方法是一样的，只不过base64加一个'-d'参数表示解码。

cksum   | echo "10.45aa" |cksum                   # 字符串转数字编码，可做校验，也可用于文件校验
echo xxx | md5sum
md5sum <<< xxx                                    # 查看md5值 
sha1sum |  

md5deep或sha1deep命令可以遍历目录树，计算其中所有文件的校验和

uuencode(对二进制文件编码 解码){
1. uuencode是将二进制文件转换为文本文件的过程，转换后的文件可以通过纯文本e-mail进行传输，在接收方对该文件进行uudecode，即将其转换为初始的二进制文件。
2. uuencode 运算法则将连续的 3字节编码转换成 4字节(8-bit 到 6-bit)的可打印字符· 该编码的效率高于Hex 格式

uuencode - 对二进制文件编码             uuencode [-m] [ file ] name
uuencode  读入文件file(缺省为 标准输入)的内容, 编码后的文件送往标准输出. 
编码只使用可显示 ASCII 字符, 同时 将文件访问模式 和 目标文件名 name 存放在 目标文件中, 供 uudecode 使用。

uudecode - 解码由 uuencode 创建的文件   uudecode [-o outfile] [ file ]...
Uudecode 把 uuencode 编码过的文件 file (缺省是 标准输入) 解码成原来的形式. 产生的文件命名为name  

uuencode busybox busybox
uudecode busybox busybox > busybox.uu
uudecode -o busybox busybox.uu

因此，在一个 uuencoded文件中仅包含字符 0x21 '!'到 0x60 '`'，它们都是可打印和可被 email传送的.
这个转换过程也意味着 uuencoded 文件要比原文件大 33%的.
}

expand(将TAB转换为空格)
unexpand(将空格转换为TAB) #  expand、unexpand 和 tr --- tr ' ' '\t'|cat - text2
dos2unix(将win文档转换转换为uinx文档转换){
dos2unix -o main.sh              # 输入文件为main.sh 输出文件为main.sh
dos2unix -k -o main.sh           # 输入文件为main.sh 输出文件为main.sh，日期信息保存不变
dos2unix -n main.sh main.sh.bak  # 输入文件为main.sh 输出文件为main.sh
}
unix2dos(将unix文档格式转换为win文档格式)
fold(对文档进行定长断行){
fold story.txt         # 自动回行，保证行长不大于80
fold -s story.txt      # 以单词为单位，回行
fold -s -w60 story.txt # 60字节单位回行
}
fmt(编排文本文件) # pr、nl 和 fmt  pr:pr 命令用于格式化文件以执行输出。默认的头部(header)包含文件名和文件创建日期和时间，以及一个页号和两行空白页脚。
nl(添加行号)
od(以八进制或其他格式显示文件内容){ xxd od hexdump 以及 vim -b file.txt
-A    #指定地址基数(最左侧一栏)，包括：
d    #十进制
o    #八进制(系统默认值)
x    #十六进制
n    #不打印位移值

-t    #指定数据的显示格式，主要的参数有(除了选项c都可以跟一个十进制数n，指定每个显示值所包含的字节数)：
c    #ASCII字符或反斜杠序列
d    #有符号十进制数
f    #浮点数
o    #八进制(系统默认值为02)
u    #无符号十进制数
x    #十六进制数

-t：后面可以接各种'类型 (TYPE)'的输出，例如：
    a：利用默认的字符来输出；
    c：使用 ASCII 字符来输出
    d[size]：利用十进制(decimal)来输出数据，每个整数占用 size Bytes ；
    f[size]：利用浮点数值(floating)来输出数据，每个数占用 size Bytes ；
    o[size]：利用八进位(octal)来输出数据，每个整数占用 size Bytes ；
    x[size]：利用十六进制(hexadecimal)来输出数据，每个整数占用 size Bytes ；

-j<BYTES>,--skip-bytes=BYTES：跳过指定数目的字节；
-N,--read-bytes=BYTES：输出指定字节数；
-w<BYTES>,--width=<BYTES>：设置每行显示的字节数，od默认每行显示16字节。如果选项--width不跟数字，默认显示32字节；

od -Ax -tcx1 file.txt 
echo /etc/passwd |od
echo /etc/passwd |od -A x -x
echo /etc/passwd |od -A x -t x1
echo /etc/passwd |od -A x -t x1 -t c    #常用 2个十六进制为一个字节
od -An -w1 -tx1 testfile|awk '{for(i=1;i<=NF;++i){printf "%s",$i}}'
}

xxd(){
索引行数  每组的默认八位字节数为2，其分组大小为4字节  标准列长度为16位，带有空格
0000000:  2f75 7372 2f73 6861 7265 2f6d 616e 2f6f     /usr/share/man/o
0000010:  7665 7272 6964 6573 2f6d 616e 312f 6669     verrides/man1/fi  

1. 实现hexdump实现的功能
2. 将hex内容回转成binary功能
xxd [options] [infile [outfile]]
xxd -r[evert] [options] [infile [outfile]]
u : 输出采用大写

3. -c8, -c 8, -c 010 和 -cols 8 几种表示方式等价

4. 指定起始位置和显示长度
xxd linuxidc.com.txt # hexdump -xC linuxidc.com.txt 
xxd -s 0x30 linuxidc.com.txt
xxd -l 0x30 linuxidc.com.txt

5. 指定显示列宽 (每行输出多少个字节)
xxd -c 5 linuxidc.com.txt
   指定字节分组 (几个字节组成一组)
xxd -g4 linuxidc.com.txt

6. 产生二进制转储 (以2进制格式进行输出)
-b |-Bits切换到位(二进制数字)转储，而不是hexdump。 此选项将八位字节写为八位“1”和“0”
xxd -b linuxidc.com.txt

7. 将文件内容输出成 c的一个数组格式
xxd -i linuxidc.com.txt

8. 以一个整块输出所有的hex， 不使用空格进行分割
xxd -p linuxidc.com.txt

9. 逆向转换 (将hex转换为binary)
xxd -p hex       # 转换为hex
xxd -r -p hex    # 转换为binary
}

http://bvi.sourceforge.net/ #二进制文件编辑
hexdump(以ascii，八进制，十进制，十六机制显示文件内容){ xxd od hexdump 以及 vim -b file.txt
echo /etc/passwd |hexdump
echo /etc/passwd |hexdump -C            #常用
#还原文件
for buff in $(cat a.hex |cut -c10-58) ; do printf "\\x$buff"; done > a.txt
awk '{for(i=2;i<=17;i++) printf "%c",strtonum("0X"$i)}' a.hex > a.txt

echo -e "\x68\x65\x6c\x6c\x6f"   #16进制转换到字符串

hexdump
    -e 指定格式字符串，格式字符串包含在一对单引号中，格式字符串形如：
        'a/b "format1" "format2"'
    每个格式字符串由三部分组成，每个由空格分隔，
    第一个形如a/b，b表示对每b个输入字节应用format1格式，a表示对每a个输入字节应用format2格式，
    一般a>b，且b只能为1，2，4，另外a可以省略，省略则a=1。
    format1和format2中可以使用类似printf的格式字符串，如：
        %02d：两位十进制
        %03x：三位十六进制
        %02o：两位八进制
        %c：单个字符等
    还有一些特殊的用法：
        %_ad：标记下一个输出字节的序号，用十进制表示
        %_ax：标记下一个输出字节的序号，用十六进制表示
        %_ao：标记下一个输出字节的序号，用八进制表示
        %_p：对不能以常规字符显示的用.代替
        同一行如果要显示多个格式字符串，则可以跟多个-e选项
        
    echo abcdefghijklm | hexdump -e '/1 "%_ax) "' -e '/1 "%02X" "\n"'
    
    hexdump -v -n 6 -s $offset -e '5/1 "%02x:" 1/1 "%02x"' /dev/mtdblock0
    
00 01 02 03 04 05 06 07 08 09 0A 0B 0C 0D 0E 0F  
10 11 12 13 14 15 16 17 18 19 1A 1B 1C 1D 1E 1F  
20 21 22 23 24 25 26 27 28 29 2A 2B 2C 2D 2E 2F

hexdump -e '1/1 "%02_ad#    "' -e '/1 "hex = %02X * "' -e '/1 "dec = %03d | "' -e '/1 "oct = %03o"' -e '/1 " \_\n"' -n 20 test 
偏移量(十六进制)  长度 描述
0h                 1   状态。80h 表示活动(或可引导)的分区。
1h                 3   分区中第一个绝对扇区的 CHS(柱面-磁头-扇区)地址
4h                 1   分区类型。
5h                 3   分区中最后一个绝对扇区的 CHS(柱面-磁头-扇区)地址
8h                 4   分区中第一个绝对扇区的逻辑块地址 (LBA)。
Ch                 4   分区中的扇区数量

dd if=/dev/sda bs=510 count=1 2>/dev/null|tail -c 64 |hexdump -C
00000000  00 01 01 00 83 fe 3f 7e  3f 00 00 00 80 21 1f 00  |......?~?....!..|
00000010  00 00 01 7f 82 fe ff ff  bf 21 1f 00 3b 8b 38 01  |.........!..;.8.|
00000020  00 fe ff ff 83 fe ff ff  00 70 85 4a 00 10 00 00  |.........p.J....|
00000030  00 fe ff ff 05 fe ff ff  37 ad 57 01 8a c1 2d 49  |........7.W...-I|
1. 所有这些记录都没有表示可引导分区的 80h 状态。
2. 分区类型为 83h (Linux)、82h(Linux 交换)、83h (Linux) 和 05h(扩展)，所以该磁盘有 3 个主分区和 1 个扩展分区。
除第一个外的所有 CHS 值都为 feffff，这是使用 LBA 的磁盘上的典型情况。
LBA 开始扇区和扇区计数解释为 32 位小端整数，所以 80 21 1f 00 表示 001f2180h，对应的十进制数为 2040192。
所以第一个分区从扇区 63 (3fh) 开始，然后扩展为 2040192 (1F2180h) 个扇区。因此，fdisk 将显示结束扇区为 63+2040255-1=2040254。

# 分区表magic值
hexdump -v -n 2 -s 0x1FE -e '1/2 "0x%04X"' "$disk"
# 分区表type lba num
for part in 1 2 3 4; do
    set -- $(hexdump -v -n 12 -s "$((0x1B2 + $part * 16))" -e '3/4 "0x%08X "' "$disk")

    local type="$(($1 % 256))"
    local lba="$(($2))"
    local num="$(($3))"

    [ $type -gt 0 ] || continue

    printf "%2d %5d %7d\n" $part $lba $num >> "/tmp/partmap.$filename" # 分区表 type lba num 信息
done

1. 指定输出格式
echo /etc/passwd | hexdump -C      <== 规范的十六进制和ASCII码显示(Canonical hex+ASCII display)
echo /etc/passwd | hexdump -b      <== 单字节八进制显示(One-byte octal display)
echo /etc/passwd | hexdump -c      <== 单字节字符显示(One-byte character display)
echo /etc/passwd | hexdump -d      <== 双字节十进制显示(Two-byte decimal display)
echo /etc/passwd | hexdump -o      <== 双字节八进制显示(Two-byte octal display)
echo /etc/passwd | hexdump -x      <== 双字节十六进制显示(Two-byte hexadecimal display)
2. 自定义输出格式
-e format_string
-f format_file

3. 指定输出位置和长度
-n length 
-s offset

常用参数： hexdump -C -n length -s skip file_name
-C 定义了导出的格式，-s skip 指定了从文件头跳过多少字节，或者说是偏移量，默认是十进制。如果是0x开头，则是十六进制。
-n 指定了导出多少长度
如果是寻找文本内容，则经常在后面用管道跟上grep命令：hexdump -C file_name |grep hellokitty
这样就可以找到相关内容的偏移量，然后hexdump -C -n length -s skip file_name 查看文本附近的内容
}

https://blog.csdn.net/charles_neil/article/details/87118497
hexdump_format(){
hexdump -e '<format string>' <filename
1. format unit
format string由format unit组成, 而format unit由如下部分组成:
    iteration count,可选, 一个整数, 表示每个这个format unit被应用的次数, 默认值1
    byte count,可选, 整数, 表示一次iteration处理的字节数, 默认值1
    format, 必选, 是fprintf风格的字符串, 必须使用双引号括起来
其中iteration count和byte count使用/分隔

hexdump -n 16 /bin/ls -e '16/1 "%c"'  # ELF
hexdump -n 16 /bin/ls -e '16/ "%c"'   # ELF
hexdump -n 16 /bin/ls -e '16 "%c"'    # ELF

hexdump -e 'iteraton_count/byte_count      "fprintf_format"' file
            被应用的次数  /被处理的字节数  输出格式fprintf
            
2. iteration count & byte count
while there is data to process:
    for unit in format_string:
        for i: 1->unit.iteration_count:
            consume unit.byte_count byte
            output like unit.format
iteration count是这个unit中的format被应用的次数
byte count是这个unit中format处理的字节数.

hexdump -n 16 /bin/ls -e '4/1 "%c" 12/1 " %02X"'  
4/1 "%c"        先处理第一个unit, 意为一次处理1个byte, 当作字符输出, 处理4次.
12/1 " %02X"    处理第二个unit, 意为一次处理1个byte, 输出为16进制整数, 处理12次.

hexdump -n 16 /bin/ls -e '3/4 " %08x"'
3/4确实是一次处理4个byte, 然后把这4个byte作为一个整体, 应用%08x进行输出, 结合字节序, 原来的02 01 01 00作为16进制输出就是00010102
处理完3次之后, 发现没有其它的format string了, 再次应用format string来处理接下来的内容

3. 多个format string
当有多个format string的时候, 是顺序应用每个format string的, 并且每轮处理, 每个format string的偏移是相同的
hexdump -n 128 -e '16/1 " %02X" "\n"' -e '"offset: %_ad\n"' /bin/ls

4. hexdump格式控制符
%_a[dos]
输出当前位置离起始位置的偏移, dos表示输出的进制.
hexdump -n 1 -s 40 -e '1/1 "%_ad"' /bin/ls 

%_A[dos]
类似上面的, 不过这个是在处理完数据之后的偏移.
hexdump -n 5 -s 40 -e '1/1 "%_Ad" 2/1 "%x" 2/1 " %02x"' /bin/ls

hexdump -n 5 -s 40 -e '2/1 " %02x" 1/1 "%_Ad" 2/1 " %02x"' /bin/ls 
发现凡是%_Ad之后的内容都没有输出, 取而代之的是输出这个format string处理之后的偏移量.

%_c
显示字符, 对于ascii码对应的转义字符, 比如ascii为0, 则显示\0
如果遇到的是其它的控制字符, 比如esc, 显示\033这中八进制表示
printf "\n" | hexdump -e '"%_c"'
printf \033 | hexdump -e '"%_c"'

%_p
显示字符, 对于非打印字符, 显示.
printf "non-printing:\033\n" | hexdump -e '"%_p"'

%_u
显示字符, 对于控制字符, 显示小写的缩写, 比如\n显示成lf(line feed).
printf "non-printing:\033\n" | hexdump -e '"%_u"'
non-printing:esclf

长度分类
1byte的控制序列:%_c, %_p, %_u, %c
默认4byte, 但支持1,2,4byte: %d, %i, %o, %u, %X, %x
默认8byte, 但支持4, 12byte: %E, %e, %f, %G, %g
}

rev(将文件每行反向显示)
ispell(用于拼写检查程序) /usr/lib/ispell/english.hash
strings(打印文件中的可打印字符串)
col(可通过标准输入更换换行字符的过滤器,将\n\r字符更改成\n字符，将空格更改为Tab字符，可删除退格字符){
col是control中co和l的拼接
选项说明 # 在许多UNIX说明文件里，包含控制字符。
  -b:不输出任何退格符,在每列的位置上只打印最后写的那个字符
  -f:允许正向半换行符。通常，处于半行分界线上的字符打印在下一行
  -p:不转换未识别的控制符
  -x:以空格来代替制表符Tab
  -l [缓冲区大小]：设置缓冲区大小，默认缓冲区为128行。
}
colrm(过滤指定行)
comm(逐行比较已排序的文件文件1 和文件2){
comm [选项]... 文件1 文件2
如果不附带选项，程序会生成三列输出。第一列包含文件1 特有的行，第二列包含 文件2 特有的行，而第三列包含两个文件共有的行。
  -1            不输出文件1 特有的行
  -2            不输出文件2 特有的行
  -3            不输出两个文件共有的行
comm -12 文件1 文件2  只打印在文件1 和文件2 中都有的行
comm -3  文件1 文件2  打印在文件1 中有，而文件2 中没有的行。反之亦然。
comm A.txt B.txt -2 -3 删除第二列和第三列，保留只在A.txt中出现的行

1. Without any option, comm gives 3 column output
lines unique to first file
lines unique to second file
lines common to both files
comm colors_1.txt colors_2.txt
  文件1      文件2
colors_1.txt colors_2.txt 
Blue         Black 
Brown        Blue 
Purple       Green 
Red          Red 
Teal         White 
Yellow
2. Suppressing columns
-1 suppress lines unique to first file
-2 suppress lines unique to second file
-3 suppress lines common to both files
comm -3 colors_1.txt colors_2.txt
comm -12 colors_1.txt colors_2.txt
comm -23 colors_1.txt colors_2.txt
comm -13 colors_1.txt colors_2.txt
}
comm compare two sorted files line by line
cmp  compare two files byte by byte
diff compare files line by line
colordiff (1) - a tool to colorize diff output
wdiff (1) - display word differences between text files
diffstat 
vimdiff

使用 diff -r tree1 tree2 | diffstat 查看变更的统计数据。
vimdiff 用于比对并编辑文件。

man_diff(){
echo 'foo 123' > f1; echo 'food 123' > f2
cmp f1 f2
cmp -b f1 f2        # print differing bytes
cmp -i 3:4 f1 f2    # skip given bytes from each file
cmp -n 3 f1 f2      # compare only given number of bytes from start of inputs
cmp -s f1 f2        # suppress output

$ paste d1 d2 
1 1 
2 hello 
3 3 
world 4
diff d1 d2
diff <(seq 4) <(seq 5)
1. use -i option to ignore case
diff -i i1 i2   
2.ignoring difference in white spaces
2.1 -b option to ignore changes in the amount of white space
diff -b <(echo 'good day') <(echo 'good    day')
2.2 -w option to ignore all white spaces
diff -w <(echo 'hi    there ') <(echo ' hi there')
diff -w <(echo 'hi    there ') <(echo 'hithere')
# use -B to ignore only blank lines 
# use -E to ignore changes due to tab expansion 
# use -z to ignore trailing white spaces at end of line
3. side-by-side output
diff -y d1 d
4. Comparing Directories
mkdir dir1 dir2 
echo 'Hello World!' > dir1/i1 
echo 'hello world!' > dir2/i1
5. to report only filenames
diff -sq dir1 dir2
6. to recursively compare sub-directories as well, use -r
mkdir dir1/subdir dir2/subdir 
echo 'good' > dir1/subdir/f1 
echo 'goad' > dir2/subdir/f1 
diff -srq dir1 dir2
}


man_uniq(){
-c 显示输出中，在每行行首加上本行在文件中出现的次数。它可取代-u和-d选项。
-d 只显示重复行。
-u 只显示文件中不重复的各行。
-D 显示所有重复的行，每个重复的行都显示
-f N 忽略文件前几行
-s N 忽略每行前几个字符
-i,--ignore-case 忽略大小写字符的不同
-w,--check-chars=N 指定每行要比较的前N个字符数
#相邻行不重复
uniq word_list.txt
sort word_list.txt | uniq
1. Only duplicates
1.1 只显示重复行，重复行只显示一次
uniq -d word_list.txt        # duplicates adjacent to each other
sort word_list.txt | uniq -d # duplicates in entire file
1.2 显示所有重复的行，每个重复的行都显示
uniq -D word_list.txt        # To get only duplicates as well as show all duplicates
sort word_list.txt | uniq -D
2. Only unique
uniq -u word_list.txt
sort word_list.txt | uniq -u
3. Prefix count
uniq -c word_list.txt
sort word_list.txt | uniq -c
sort word_list.txt | uniq -cd
sort word_list.txt | uniq -c | sort -n
sort word_list.txt | uniq -c | sort -nr
4。Ignoring case
uniq -i another_list.txt
uniq -iD another_list.txt
5. Combining multiple files
sort -f word_list.txt another_list.txt | uniq -i
sort -f word_list.txt another_list.txt | uniq -c
sort -f word_list.txt another_list.txt | uniq -ic
6. Column options
uniq -f1 shopping.txt # skips first field
6.1 Skipping characters
uniq -s2 text
6.2 Upto specified characters
uniq -w2 text
uniq -s3 -w2 text
}

tr [模式1] [模式2] (通过标准输入修改或删除字符，并以标准输出显示)
man_join(){
join [文件1] [文件2] (若在2个文件中发现1对等值字段，就是用join命令将其合并为一个字段，然后添加剩余字段)
将两个文件中指定栏位相同的行连接起来，即按照两个文件中共同拥有的某一列，将对应的行拼接成一行，无法关联的行将不会进行匹配输出
    join -t'\0' -a1 -a2 file1 file2   # Union of sorted files                  两个有序文件的并集
    join -t'\0' file1 file2           # Intersection of sorted files           两个有序文件的交集
    join -t'\0' -v2 file1 file2       # Difference of sorted files             两个有序文件的差集
    join -t'\0' -v1 -v2 file1 file2   # Symmetric Difference of sorted files   两个有序文件的对称差集
    
-a<1或2> 除了显示原来的输出内容之外，还显示指令文件中没有相同栏位的行。
-e<字符串> 若[文件1]与[文件2]中找不到指定的栏位，则在输出中填入选项中的字符串。
-i或--igore-case 比较栏位内容时，忽略大小写的差异。
-o<格式> 按照指定的格式来显示结果。
-t<字符> 使用栏位的分隔字符。
-v<1或2> 跟-a相同，但是只显示文件中没有相同栏位的行。
-1<栏位> 连接[文件1]指定的栏位。
-2<栏位> 连接[文件2]指定的栏位。
}
paste [文件1] [文件2] (合并文本信息)
cut -f [字段号] [文件名](截取文件指定的各行字段，文件中只截取行选择的字段，然后以标准输出显示)
man_cut(){
显示每行从开头算起 num1 到 num2 的文字
  -b byte     指定剪切字节数    <输出范围>
  -c list     指定剪切字符数。  <输出范围>
  -f field    指定剪切域数。    <输出范围>
  -d <分隔符> 指定与空格和tab键不同的域分隔符。 <分隔符>
  -n：与命令选项-b一起使用，不分割宽字符
  
  --complement：反向选择输出字节、字符或字段
  -c 用来指定剪切范围，如下所示：
  -c1,5-7 剪切第1个字符，然后是第5到第7个字符。
  -c2- 剪切第2个到最后一个字符
  -c-5 剪切最开始的到第5个字符
  -c1-50 剪切前50个字符。
  -f 格式与-c相同。
  -f1,5 剪切第1域，第5域。
  -f1,10-12 剪切第1域，第10域到第12域。

cut -d'分隔字符' -f fields #　用于有特定分隔字符
cut -c 字符区间            #　用于排列整齐的讯息

cut -d: -f3 cut_test.txt 　　 # (基于":"作为分隔符，同时返回field 3中的数据) *field从0开始计算。
cut -d: -f1,3 cut_test.txt 　 # (基于":"作为分隔符，同时返回field 1和3中的数据)
cut -d: -c1,5-10 cut_test.txt # (返回第1个和第5-10个字符)
1. select specific fields
1.1 single field
printf 'foo\tbar\t123\tbaz\n' | cut -f2
1.2 multiple fields can be specified by using ,
printf 'foo\tbar\t123\tbaz\n' | cut -f2,4
# output is always ascending order of field numbers
printf 'foo\tbar\t123\tbaz\n' | cut -f3,1
1.3 range can be specified using -
printf 'foo\tbar\t123\tbaz\n' | cut -f1-3
printf 'foo\tbar\t123\tbaz\n' | cut -f3-
2. suppressing lines without delimiter
$ cat marks.txt
jan 2017
foobar  12      45      23
feb 2017
foobar  18      38      19
$ # by default lines without delimiter will be printed
$ cut -f2- marks.txt

$ # use -s option to suppress such lines
$ cut -s -f2- marks.txt
3. specifying delimiters
echo 'foo:bar:123:baz' | cut -d: -f3
echo 'foo:bar:123:baz' | cut -d: -f1,4
echo 'one;two;three;four' | cut -d; -f3
echo 'one;two;three;four' | cut -d';' -f3
4. output-delimiter
printf 'foo\tbar\t123\tbaz\n' | cut --output-delimiter=: -f1-3
echo 'one;two;three;four' | cut -d';' --output-delimiter=' ' -f1,3-
echo 'one;two;three;four' | cut -d';' --output-delimiter=$'\t' -f1,3-
echo 'one;two;three;four' | cut -d';' --output-delimiter=' - ' -f1,3-
5. complement
echo 'one;two;three;four' | cut -d';' -f1,3-
echo 'one;two;three;four' | cut -d';' --complement -f2

1. character
echo 'foo:bar:123:baz' | cut -c4
printf 'foo\tbar\t123\tbaz\n' | cut -c1,4,7
echo 'foo:bar:123:baz' | cut -c8-
echo 'foo:bar:123:baz' | cut --complement -c8-
echo 'foo:bar:123:baz' | cut -c1,6,7 --output-delimiter=' '
echo 'abcdefghij' | cut --output-delimiter='-' -c1-3,4-7,8-
cut -c1-3 marks.txt
}
sed
awk
grep
man_look(){
look指令用于英文单字的查询。您仅需给予它欲查询的字首字符串，它会显示所有开头字符串符合该条件的单字
grep "^word" /usr/share/dict/words -q; 
look word列出默认字典中所有的单词, 
look word /home/wenfeng/test.txt列出文件中以word起头的所有单词
}
    #/usr/share/dict/words; 
    #/usr/share/dict/web2
units(将一种计量单位转换为另一种等效的计量单位){}
ab(性能分析Web服务器){}
mtr(更好的网络调试跟踪工具){}
cssh(可视化的并发shell){}

ntsysv # 设置服务随系统启动时同时启动
}

man_perf_Tracer(Linux){
介绍了目前常用的各类工具:
ftrace
perf_events
eBPF
SystemTap
LTTng
ktap
dtrace4linux
OL DTrace
sysdig
作者非常细心的列出了大量的工具原理及使用教程, 保证会花掉你大把的晚上才能看完.
http://www.brendangregg.com/blog/2015-07-08/choosing-a-linux-tracer.html

}



对于24小时开机运行的服务器可能用不到这种东西，但是非24小时开机，又想定时运行任务的机器还是十分有用的，可以实现异步的调用

Anacron的实现原理以及使用方式
    Anacron是基于cron的，并没有要代替cron，一般的用法是由cron在周期性调用anacron，利用anacron定义的规则来启动
相关的应用。比如系统中在/etc/cron.hourly下一般会有一个0anacron的文件，此文件用于启动/etc/anacrontab中定义的任务。
如果要实现异步的周期性任务，还需要再定义相应的crontab。
    运行crontab -e，并写下按小时调用的规则：
    15 * * * * anacrontab -t $HOME/anacrontab -S $HOME/.anacron
每次调用anacrontab时，会监测一下$HOME/.anacron目录下crawl(任务名称)文件是否存在并且其内容是否为当前今天的日期，
如果是今天的日期，则表明今天已经调用过了，如果不是今天的日期，则启动$HOME/bin/mycrawl程序，再把内容改为今天的
日期。以这种方式实现了即使关机的情况下也会定期运行相关的任务。

anacron(异步的定时任务调度器){
当主机停机期间,安排好的工作并不能执行,哪该怎么办? anacron会帮我们处理这个问题.其本质也是一个crontab

可以定义启动程序的环境变量，其中
    START_HOURS_RANGE=17-23：表示程序在17时至23时之间会启动
    RANDOM_DELAY=5：表示定时触发后随机延迟5分钟以内的时间再启动应用(主要是防止一开机多任务同时启动造成负载过重)。

任务定义的格式：
    1 5 crawl $HOME/bin/mycrawl：第一列表示格几个小时启动一次，第二列表示触发后延迟的分钟数，最终的延迟时间是5+RANDOM_DELAY，第三列是任务名称，第四列是要运行的命令及相关的参数。

1)anacron工作原理

当我们每次处理crontab安排的工作时,都会先处理anacron安排的工作,anacron安排的工作很简单,就是记录这次处理crontab的时间(时间记录在目录/var/spool/anacront/下的子文件).当我们下次处理anacron工作时,会比较与前一个时间的差值,看它是否满足工作记录的要求,不满足就进行差值时间内之前的crontab工作.
2)anacron工作记录文件/etc/anacrontab
# These replace cron's entries
1       5       cron.daily      run-parts --report /etc/cron.daily

# 上面工作记录表示:此条工作名为cron.daily,其每天执行的(1),执行会延迟5分钟才开始
# 执行命令是 run-parts --report /etc/cron.daily
7       10      cron.weekly     run-parts --report /etc/cron.weekly


# 还有下面这条工作记录,应该看得懂吧
period        delay            job-identifier        command
<轮回天数>    <轮回内的重试时间>    <任务描述>        <命令>
7           70              cron.weekly             run-parts /etc/cron.weekly

    首先是轮回天数，即是指任务在多少天内执行一次，monthly 就是一个月(30天)内执行，weekly 即是在一周之内执行一次。
    其实这种说法不太好，因为它用的不是人类的日历来定启动任务的时间，而是利用天数，像"每月"，是指在"每月"执行的任务完成后的三十天内不再执行第二次， 而不是自然月的"三十天左右"，不管什么原因(比如关机了超过一个月)，三十天后 anacron 启动之时该任务依然会被执行，"周"任务同理。

    第二部分 delay 是指轮回内的重试时间，这个意思有两部分，一个是 anacron 启动以后该服务 ready 暂不运行的时间
    (周任务的 70 delay 在 anacron 启动后70分钟内不执行，而处于 ready 状态)，另一个是指如果该任务到达运行时间
    后却因为某种原因没有执行(比如前一个服务还没有运行完成，anacron 在 /etc/init.d 的脚本中加了一个-s 参数，
    便是指在前一个任务没有完成时不执行下一个任务)，依然以周任务和月任务为例，周任务在启动 anacron 后的70分钟执行，
    月任务在服务启动后 75 分钟执行，但是，如果月任务到达服务启动后 75 分钟，可是周任务运行超过5分钟依然没有完成，
    那月任务将会进入下一个 75 分钟的轮回，在下一个 75 分钟时再检查周任务是否完成，如果前一个任务完成了那月任务开始运行。
    (这里有一个问题，如果周任务在后台死掉了，成僵尸进程了，难道月任务永远也不执行？!)

    第三部分 job-identifier 非常简单，anacron 每次启动时都会在 /var/spool/anacron 里面建立一个以 job-identifier 
    为文件名的文件，里面记录着任务完成的时间，如果任务是第一次运行的话那这个文件应该是空的。这里只要注意不要用
    不可以作为文件名的字符串便可，可能的话 文件名也不要太长。注：根据我的理解，其实就是anacron运行时，会去检查
    "/var/spool/anacron/这部分"文件中的内容，内容为一个日期，根据这个日期判断下面的第四部分要不要执行。 比如说
    这里写的是cron.daily，然后/var/spool/anacron/cron.daily文件中记录的日期为昨天的话，那anancron执行后就行执行
    这一行对应第四行的动作。
    
    第四部分最为简单，仅仅是你想运行的命令，run-parts 我原以为是 anacron 配置文件的语法，后来才看到有一个 
    /usr/bin/run-parts，可以一次运行整个目录的可执行程序。
}
man_chattr(){
chattr [+ - =] [ai] 文件或目录名
常用的参数是a(append，追加)和i(immutable，不可更改)，其他参数略。
    设置了a参数时，文件中将只能增加内容，不能删除数据，且不能打开文件进行任何编辑，哪怕是追加内容也不可以，
所以像sed等需要打开文件的再写入数据的工具也无法操作成功。文件也不能被删除。只有root才能设置。
    设置了i参数时，文件将被锁定，不能向其中增删改内容，也不能删除修改文件等各种动作。只有root才能设置。
可以将其理解为设置了i后，文件将是永恒不变的了，谁都不能动它。

文件的特殊属性 - 使用 "+" 设置权限，使用 "-" 用于取消
chattr +a file1 # 只允许以追加方式读写文件
chattr +c file1 # 允许这个文件能被内核自动压缩/解压
chattr +d file1 # 在进行文件系统备份时，dump程序将忽略这个文件
chattr +i file1 # 设置成不可变的文件，不能被删除、修改、重命名或者链接
chattr +s file1 # 允许一个文件被安全地删除
chattr +S file1 # 一旦应用程序对这个文件执行了写操作，使系统立刻把修改的结果写到磁盘
chattr +u file1 # 若文件被删除，系统会允许你在以后恢复这个被删除的文件
lsattr          # 显示特殊的属性

chattr +i filename # 禁止删除 
chattr -i filename # 取消禁止 

chmod a+t directory_name # 粘滞位应用于目录，设置后只有目录的所有者才能够删除目录中的文件，及时其他人有该目录的而写权限也无法执行删除操作

文件属性可以通过 chattr 进行设置，它比文件权限更加底层。
例如，为了保护文件不被意外删除，可以使用不可修改标记：sudo chattr +i /critical/directory/or/file

chattr [-R] [-+=AacDdijsStTu] [-v version] files...
Change file attributes on an ext2 fs
Modifiers:
        -       Remove attributes
        +       Add attributes
        =       Set attributes
Attributes:
        A       Do not track atime
        a       Append mode only
        c       Enable compress
        D       Write dir contents synchronously
        d       Do not backup with dump
        i       Cannot be modified (immutable)
        j       Write all data to journal first
        s       Zero disk storage when deleted
        S       Write file contents synchronously
        t       Disable tail-merging of partial blocks with other files                                                 
        u       Allow file to be undeleted
Options:
        -R      Recursively list subdirectories
        -v      Set the file version/generation number
}

man_backup(){
dump -0aj -f /tmp/home0.bak /home 制作一个 '/home' 目录的完整备份
dump -1aj -f /tmp/home0.bak /home 制作一个 '/home' 目录的交互式备份
restore -if /tmp/home0.bak 还原一个交互式备份
rsync -rogpav --delete /home /tmp 同步两边的目录
rsync -rogpav -e ssh --delete /home ip_address:/tmp 通过SSH通道rsync
rsync -az -e ssh --delete ip_addr:/home/public /home/local 通过ssh和压缩将一个远程目录同步到本地目录
rsync -az -e ssh --delete /home/local ip_addr:/home/public 通过ssh和压缩将本地目录同步到远程目录
dd bs=1M if=/dev/hda | gzip | ssh user@ip_addr 'dd of=hda.gz' 通过ssh在远程主机上执行一次备份本地磁盘的操作
dd if=/dev/sda of=/tmp/file1 备份磁盘内容到一个文件
tar -Puf backup.tar /home/user 执行一次对 '/home/user' 目录的交互式备份操作
( cd /tmp/local/ && tar c . ) | ssh -C user@ip_addr 'cd /home/share/ && tar x -p' 通过ssh在远程目录中复制一个目录内容
( tar c /home ) | ssh -C user@ip_addr 'cd /home/backup-home && tar x -p' 通过ssh在远程目录中复制一个本地目录
tar cf - . | (cd /tmp/backup ; tar xf - ) 本地将一个目录复制到另一个地方，保留原有权限及链接
find /home/user1 -name '*.txt' | xargs cp -av --target-directory=/home/backup/ --parents 从一个目录查找并复制所有以 '.txt' 结尾的文件到另一个目录
find /var/log -name '*.log' | tar cv --files-from=- | bzip2 > log.tar.bz2 查找所有以 '.log' 结尾的文件并做成一个bzip包
dd if=/dev/hda of=/dev/fd0 bs=512 count=1 做一个将 MBR (Master Boot Record)内容复制到软盘的动作
dd if=/dev/fd0 of=/dev/hda bs=512 count=1 从已经保存到软盘的备份中恢复MBR内容
}

man_char(){
字符设置和文件格式转换
dos2unix filedos.txt fileunix.txt 将一个文本文件的格式从MSDOS转换成UNIX
unix2dos fileunix.txt filedos.txt 将一个文本文件的格式从UNIX转换成MSDOS
recode ..HTML < page.txt > page.html 将一个文本文件转换成html
recode -l | more 显示所有允许的转换格式

enconv -L zh_CN -x UTF-8 filename 

convmv -f 源编码 -t 新编码 [选项] 文件名 
-r 递归处理子文件夹 
--notest 真正进行操作，请注意在默认情况下是不对文件 进行真实操作的，而只是试验。 
--list 显示所有支持的编码
--unescap 可以做一下转义，比如把%20变成空格 
比如我们有一个utf8编码 的文件 名 ，转换 成GBK编码 ，命令如下： 
convmv -f UTF-8 -t GBK --notest utf8编码 的文件名 

# iconv命令是用来转换文件的编码方式的,可以将UTF8编码的转换成GB18030的编码，反过来也行.
iconv -f UNICODELITTLE -t MS-ANSI -c resource.h > re.h      ~
-c : 静默丢弃不能识别的字符，而不是终止转换。
-f,--from-code=[encoding]:指定待转换文件的编码。
-t,--to-code=[encoding]:指定目标编码。
-l,--list:列出已知的字符编码。
-o,--output=[file] :列出指定输出文件，而非默认输出到标准输出。
-s,--silent：关闭警告
iconv -f gbk -t utf8 inputFile.txt -o outputFile.txt.utf8 # 将GBK文件转换为UTF8文件
iconv -c -f gbk -t utf8 inputFile.txt -o outputFile.txt.utf8 # 转换时报如下错误：”iconv: 未知 126590 处的非法输入序列”。此时使用-c选项。

# 自动识别文本格式并转换为系统编码
enca 文件1

iconv -l 列出已知的编码
iconv -f from-encoding -t to-encoding inputfile #把输出打印在屏幕上，
iconv -f from-encoding -t to-encoding inputfile -o outputfile # 输出到文件
iconv -f GBK -t UTF-8 file1 -o file2
# -f gb2312是原始编码，-t utf-8是转换编码，-o 文本2 是输出文本文件，-c是忽略一些无法转换的字符，否则会中断。
iconv -f gb2312 -t utf-8 文本1 -o 文本2 -c

iconv -f fromEncoding -t toEncoding inputFile > outputFile creates a new from the given input file by assuming it is encoded in fromEncoding and converting it to toEncoding.
find . -maxdepth 1 -name *.jpg -print -exec convert "{}" -resize 80x60 "thumbs/{}" \; batch resize files in the current directory and send them to a thumbnails directory (requires convert from Imagemagick)
curl -s http://www.google.com.hk/ | iconv -f big5 -t gbk # 将Google香港的Big5编码转换成GBK编码
curl -s http://codingstandards.iteye.com/ | iconv -f utf8 -t gbk # 将我的JavaEye博客首页从UTF8转换成GBK
curl -s http://www.dreamdu.com/ | iconv -futf8 -t gbk # 将梦之都的UTF8转换成GBK
curl -s http://www.dreamdu.com/ | cut -b 4- | iconv -futf8 -t gbk # 那就把前面三个字节去掉试试，果然可以了
 
native2ascii
}

man_mv(){
mv [-iuf] item1 item2 或 mv [-iuf] item... directory
选项说明：
--backup[=CONTROL]：如果目标文件已存在，则对该文件做一个备份，默认备份文件是在文件名后加上波浪线，如/b.txt~
-b：类似于--backup，但不接受参数, 默认备份文件是在文件名后加上波浪线，如/b.txt~
-f：如果目标文件已存在，则强制覆盖文件
-i：如果目标文件已存在，则提示是否要覆盖，这是alias mv的默认选项
-n：如果目标文件已存在，则不覆盖已存在的文件
     如果同时指定了-f/-i/-n，则后指定的生效
     
-u：(update)如果源文件和目标文件不同，则移动，否则不移动

for i in *.pdf; do mv "$i" CS749__"$i"; done # adding-prefix-to-file-name
}
man_cp(复制文件或目录){
cp [-apdriulfs] src dest # 复制单文件或单目录
cp [-apdriuslf] src1 src2 src3......dest_dir # 复制多文件、目录到一个目录下
  -p： 文件的属性(权限、属组、时间戳)也复制过去。如果不指定p选项，谁执行复制动作，文件所有者和组就是谁。
  -b或--backup 　删除，覆盖目标文件之前的备份，备份文件会在字尾加上一个备份字符串。
  -r或-R：递归复制，常用于复制非空目录。
  -d：复制的源文件如果是链接文件，则复制链接文件而不是指向的文件本身。即保持链接属性，复制快捷方式本身。如果不指定-d，则复制的是链接所指向的文件。
  -a：a=pdr三个选项。归档拷贝，常用于备份。
  -i：复制时如果目标文件已经存在，询问是否替换。
  -u：(update)若目标文件和源文件同名，但属性不一样(如修改时间，大小等)，则覆盖目标文件。
  -f：强制复制，如果目标存在，不会进行-i选项的询问和-u选项的考虑，直接覆盖。
  -l：在目标位置建立硬链接，而不是复制文件本身。
  -s：在目标位置建立软链接，而不是复制文件本身
  -d或--no-dereference 　当复制符号连接时，把目标文件或目录也建立为符号连接，并指向与源文件或目录连接的原始文件或目录。
  
# 一般使用cp -a即可，对于目录加上-r选项即可。
cp -ra a.txt test                     # 复制的文件与原文件时间一样
yes | cp -a /etc/skel/. /tmp # 有重复文件，则即使加上-f选项，也一样会交互式询问:解决方法
rm -rf /tmp/.* # 删除/tmp下所有文件包括隐藏文件。
cp -p source destination # 保持复制前用户名，组用户以及读写属性
}

man_yes(){
yes [OPTIONS] [STRING] 
Repeatedly output a line with STRING, or 'y'
}

man_scp(){
如果scp拷贝的源文件在目标位置上已经存在时(文件同名)，scp会替换已存在目标文件中的内容，但保持其inode号。
如果scp拷贝的源文件在目标位置上不存在，则会在目标位置上创建一个空文件，然后将源文件中的内容填充进去。
eg. scp -l 512 xx hy@xx.xx.xx.xx:/home       #将速度限制为512kbit/s 
eg. scp -C xx hy@xx.xx.xx.xx:/home           #开启压缩
eg. scp -c blowfish xx hy@xx.xx.xx.xx:/home  #加密数据的加密方式
}

tree 以树形方式输出指定目录 -L 显示目录深度; -d 仅显示目录
man_ls(){
    sort 特性: -c change time; -S size; -t modification time; -u last access time; -v version
    sort 逆序: -r reverse

    输出内容:  文件名筛选 -a -A 文件属性筛选: -l -o -s  one-line方式 -1
    ls -s                   # s(输出size) S(以文件size排序)
    ls -n # 显示文件和目录的UID(userid，用户ID)和GID(groupid，组ID)
    ls -ld dir-name         # 显示目录属性而不是目录内容
    ls -F                   # 在文件末尾增加文件属性标识符
    ls -al ---  ls -Al      # 全部的文件，连同隐藏文件，但不包括 . 与 .. 这两个目录
    ls -rtl                 # 按时间倒叙列出所有目录和文件 ll -rt
    ls -l -S *.d | sort -k 5 -n  # ls命令按文件size大小列举文件
    ls -rSl                 # 按大小倒叙列出所有目录和文件 ll -rS
    ls # -F：根据文件、目录等信息，给予附加数据结构，例如：*: 代表可可执行文件； /: 代表目录； =: 代表 socket 文件； |: 代表 FIFO 文件；
    ls -lSrh                # "r"的作用是将大的文件列在后面，而'h'则是给出易于人们阅读的输出
    # tree命令按树状结构递归列出目录和子目录中的内容，而ls使用-R选项时才会递归列出。
    -rw-r--r--.                                       1       root   root     2977       Aug 21  2017 x86.xml
    文件类型[-dcbsl]所有者权限+组权限+其他用户权限 硬链接数 所属用户 所属组  文件大小    最近修改时间 文件名
    文件类型: -普通文件 b c C d D l M n p P s ?其他类型
    atime是access time，即上一次的访问时间； 
    mtime是modify time，是文件的修改时间；   # 只有修改文件内容才会改变，更准确的说是修改了它的data block部分
    ctime是change time，也是文件的修改时间； # 修改文件属性时改变的，确切的说是修改了它的元数据部分
    # 修改文件内容也一定会改变ctime
    # 目录里的任何东西都是目录中的内容；而目录的ctime，除了目录的mtime引起ctime改变之外，对目录本身的元数据修改也会改变ctime
    (1).atime只在文件被打开访问时才改变，若不是打开文件编辑内容，则ctime和mtime的改变不会引起atime的改变;
    (2).mtime的改变一定引起ctime的改变，而atime的改变不总是会影响ctime
    mtime(数据内容变化) ctime(数据内容变化|chmod|chown|chgrp) atime(touch|execve|mknod|pipe|utime|read)
}
man_file(){
file -i a.txt # 查看文本编码格式
file -L python # 查看符号链接的文件类型
file -s /dev/sda  # 查看设备的文件系统类型
file -s /dev/sda1 # 查看设备的文件系统类型

在目录上：
r：可以对目录执行ls以列出目录内的所有文件；读是文件的最基本权限，没有读权限，目录的一切操作行为都被限制。
w：可以在此目录创建或删除文件/子目录；
x：可进入此目录，可使用ls -l查看文件的详细信息。
如果目录没有x权限，其他人将无法查看目录内文件属性，所以一般目录都要有x权限。而如果只有执行却没有读权限，则权限拒绝。
一般来说，普通文件的默认权限是644(没有执行权限)，目录的默认权限是755(必须有执行权限，否则进不去)，链接文件的权限是777。
1. 读权限(r)
读取其data block的能力。
普通文件的data block存储的直接就是数据本身， 所以对普通文件具有读权限表示能够读取文件内容。
目录文件的data block存储的内容包括但不限于：目录中文件的inode号以及这些文件的文件类型、文件名。
2. 执行权限(x)
执行权限表示的是能够执行。
读权限是文件的最基本权限，执行权限能正常运行必须得配有读权限。
对目录有执行权限，表示可以通过目录的data block中指向文件inode号的指针定位到inode table中该文件的inode信息，所以可以显示出这些文件的全部属性信息。
3. 写权限(w)
写权限很简单，就是能够将数据写入分配到的data block。

1 suid
suid只针对可执行文件，即二进制文件。它的作用是对某个命令(可执行文件)授予所有者的权限，命令执行完成权限就消失。一般是提权为root权限。
ls -l /usr/bin/passwd
数字4代表suid，
2. sgid
针对二进制文件和目录。
    针对二进制文件时，权限升级为命令的所属组权限。
    针对目录时，目录中所建立的文件或子目录的组将继承默认父目录组，其本质还是提升为目录所属组的权限。
以2代表sgid，如2755，和suid组合如6755。
3. sbit
只对目录有效。对目录设置sbit，将使得目录里的文件只有所有者能删除，即使其他用户在此目录上有rwx权限，即使是root用户。
以1代表sbit。
suid/sgid/sbit的标志位都作用在x位，当原来的x位有x权限时，这些权限位则为s/s/t，如果没有x权限，则变为S/S/T。
例如，/tmp目录的权限有个t位，使得该目录里的文件只有其所有者本身能删除。
}
    du -kx | egrep -v "\./.+/" | sort -n #搜寻最大的目录：
    dos2unix                # windows文本转linux文本
    unix2dos                # linux文本转windows文本
    # 自动识别文本格式并转换为系统编码
    enca filename           # 查看编码  安装 yum install -y enca
    
    md5sum -c *.md5, sha1sum -c *.sha1 # 检查校验和
    对目录进行校验 md5dep -rl . > dircetory.md5(-r 递归方式， -l 相对路径);
    find . -type f -print0 | xargs -0 md5sum >> directory.md
    
    md5sum                  # 查看md5值
    md5sum /tmp/fstab /tmp/fstab1 >/tmp/fs.md5sum  # 将多个文件的md5值和文件对应关系保存到文件中
    md5sum -c /tmp/fs.md5sum                       # 检验文件中md5值和对应文件生成的md5值是否相等
       --status： # 完全不显示任何信息，只能通过命令的退出状态码判断验证结果是否有failed。
                  # 只要有一条failed记录，则状态码为1，否则为0。
                  
    crypt <input_file >output_file加密，
    crypt PASSPARSE -d <encryptedfile >outputfile解密       
    mcrypt -a des --keymode  pkdes --bare --noiv filename
    mcrypt -a enigma --keymode scrypt --bare filename
    mcrypt -a arcfour --mode stream filename

    gpg -c filename加密，
    gpg filename.gpg解密; 
    
    base64 -d file > outputfile
    
    ln 源文件 目标文件      # 硬链接
    ln -s 源文件 目标文件   # 符号连接
    readlink -f /data       # 查看连接真实目录;  获得完整的文件路径
    namei -l /path/to/file.txt    # 列出一个路径中所有的成分，包含符号连接
    cat file | nl |less     # 查看上下翻页且显示行号  q退出
    head                    # 查看文件开头内容
    head -c 10m             # 截取文件中10M内容
    split -C 10M            # 将文件切割大小为10M -C按行
    tail -f file            # 查看结尾 监视日志文件
    tail -F file            # 监视日志并重试, 针对文件被mv的情况可以持续读取
    file                    # 检查文件类型
    umask                   # 更改默认权限
    uniq                    # 删除重复的行
    uniq -c                 # 重复的行出现次数
    uniq -u                 # 只显示不重复行
    
paste(列合并|行合并){  按列合并多个文件
paste -d -s -file1 file2
  选项的含义如下：
  -d 指定不同于空格或t a b键的域分隔符。例如用@分隔域，使用- d @。如果不指定，默认用\t分割
  -s 将每个文件合并成行而不是按行粘贴。
  - 使用标准输入。如果 file 部分写成 - ，表示来自 standard input 的数据的意思。
1. Concatenating files column wise
    ls -l |paste  # 只在一列上显示输出
    paste a b               # 将两个文件合并用tab键分隔开
    paste -d'+' a b         # 将两个文件合并指定'+'符号隔开
    paste -d, <(seq 5) <(seq 6 10)              # 列合并      分隔符为,
    paste -d'|' <(seq 3) <(seq 4 6) <(seq 7 10) # 列合并      分隔符为|
    paste -d'\0' <(seq 3) <(seq 6 8)            # 列合并      分隔符为\0
2. Interleaving lines
    paste -d'\n' <(seq 11 13) <(seq 101 103)    # 列交叉合并  分隔符为\n
3. Lines to multiple columns
    seq 10 | paste -d, - -                      # 多行合并成一行,行之间,分割
    seq 10 | paste -d: - - - - -                # 多行合并成一行,行之间:分割
    printf -- "- %.s" {1..5}                    # - - - - -
    seq 10 | paste -d, $(printf -- "- %.s" {1..5}) # 多行合并
4. Different delimiters between columns
    paste -d',-' <(seq 3) <(seq 4 6) <(seq 7 9)                # 多分隔符，
    paste -d',-' <(seq 3) <(seq 4 6) <(seq 7 9) <(seq 10 12)   # 多分隔符，
    seq 10 | paste -d':,' - - - - -                            # 多分隔符，
    paste -d, <(seq 3) <(seq 4 6) <(seq 7 9) <(seq 10 12)      # 多分隔符，
    
    paste -d' : ' <(seq 3) /dev/null /dev/null <(seq 4 6) /dev/null /dev/null <(seq 7 9)    # 添加空格
    paste -d' :  - ' <(seq 3) /dev/null /dev/null <(seq 4 6) /dev/null /dev/null <(seq 7 9) # 添加空格
    paste -d' :  - ' <(seq 3) e e <(seq 4 6) e e <(seq 7 9)                                 # 添加空格
5. Multiple lines to single row
    paste -sd, colors_1.txt                # 本文件多行合并成一行，然后在合并成一个文件
    paste -sd: colors_1.txt colors_2.txt   # 本文件多行合并成一行，然后在合并成一个文件
    paste -sd, <(seq 3) <(seq 5 9)         # 本文件多行合并成一行，然后在合并成一个文件
    
    sort -u colors_1.txt colors_2.txt | paste -sd,
  
    paste -s a              # 将多行数据合并到一行用tab键隔开
    
    seq 10 | paste -sd, # 1,2,3,4,5,6,7,8,9,10 
    seq 10 | paste -sd, | sed 's/,/ : /g' # 1 : 2 : 3 : 4 : 5 : 6 : 7 : 8 : 9 : 10
    seq 10 | perl -pe 's/\n/ : / if(!eof)' # 1 : 2 : 3 : 4 : 5 : 6 : 7 : 8 : 9 : 10
}
pr(){
1. Converting lines to columns
seq 6 | pr -2ts,
seq 6 | paste -d, - -
seq 9 | pr -3t
seq 9 | pr -3ts' '
seq 9 | pr -3ts':'
}
column(){
column -t       # 空格转换成TAB
1. Pretty printing tables
column -t dishes.txt
paste fruits.txt price.txt
paste fruits.txt price.txt | column -t
2. Specifying different input delimiter
column -s, -t   # ,转换成TAB
paste -d, <(seq 3) <(seq 5 9) <(seq 11 13)
paste -d, <(seq 3) <(seq 5 9) <(seq 11 13) | column -s, -t
column -s, -nt  # 不对TAB或空格合并，即显示空格
}
    chattr +i /etc/passwd   # 不得任意改变文件或目录 -i去掉锁 -R递归
    more                    # 向下分面器
    locate 字符串           # 搜索
wc(使用hexdump -C可以更好理解){
-l 统计0x0a个数， -c统计ASCII字符个数， -w统计以空格|TAB分割的单词个数， -L测算最长行可视长度， -m统计字节个数
    wc -l file              # 查看行数      {word line char [-w -l -c]}
    wc -l < sample.txt      # 查看行数      {-l 统计(newline characters)的个数}
    wc -m file              # 字节数而不是字符数
    wc sample.txt           # line/word/byte count
    wc *.txt                # 本目录所有*.txt 文件，最后一行显示总计数
    wc -L < sample.txt      # 本文件中最长行字符数    {统计包括字符类型的空格|TAB等等}
    wc -L *.txt             # 本目录所有*.txt 文件最长行字符数
1. Various counts
wc sample.txt
wc -l sample.txt
wc -w sample.txt
wc -c sample.txt
wc -l < sample.txt # use shell input redirection if filename is not needed
wc *.txt # multiple file input, automatically displays total at end
wc -L < sample.txt # use -L to get length of longest line
2. subtle differences
printf 'foo\0bar\0baz' | wc -L # foobarbaz     9
printf 'foo\0bar\0baz' | wc -m # foobarbaz     11
printf 'foo\0bar\0baz' | wc -c # foobarbaz     11
printf 'food\tgood' | wc -L    # food    good  12
printf 'food\tgood' | wc -m    # food    good  9
printf 'food\tgood' | wc -c    # food    good  12
}
    vimdiff file1 file2     # 比较文件内容
    cp filename{,.bak}      # 快速备份一个文件
    \cp a b                 # 拷贝不提示 既不使用别名 cp -i
    rev                     # 将行中的字符逆序排列
    comm -12 2 3            # 行和行比较匹配
    echo "10.45aa" |cksum                   # 字符串转数字编码，可做校验，也可用于文件校验
    iconv -f gbk -t utf8 原.txt > 新.txt    # 转换编码
    uconv
    
    xxd /boot/grub/stage1                   # 16进制查看
    hexdump -C /boot/grub/stage1            # 16进制查看
    rename 原模式 目标模式 文件                # 重命名 可正则
    watch -d -n 1 'df; ls -FlAt /path'      # 实时某个目录下查看最新改动过的文件
    cp -v  /dev/dvd  /rhel4.6.iso9660       # 制作镜像
    diff suzu.c suzu2.c  > sz.patch         # 制作补丁
    patch suzu.c < sz.patch                 # 安装补丁
    patch                                   # 就是用来将修改(或补丁)写进文本文件里
    diff -Naur old_file new_file > diff_file
    patch < diff_file
    
    aspell #交互式拼写检查器
    
    diff # 在Linux下如果要比较两个目录，可以使用diff命令，并且需要加上选项-r(递归)。
         # 另外还有两个常用的选项，-b (忽略空白)和 -B (忽略空行)
    diff -r -b -B sch_admin 4sch_admin
    diff -r -b -B --exclude=CVS sch_admin 4sch_admin
 
Ctrl+D 不是信号，表示输入流结束，相当于read返回0
Ctrl+C 发送INT信号，杀死前台运行进程。
stty eof a
stty intr ^-

# cat 的默认输入是终端输入，cat的默认输出是终端输出
cat >file        # 将终端输入输出到file文件中
cat >>file       # 将终端输入追加到file文件中
cat <<END >file  # 使用here-document 将终端输入输出到file文件中
Hello, World.
END

cat <<'fnord'    # 即使 fnord 是命令也可以作为 EOF
Nothing in `here` will be $changed
fnord

system(file cat){ 把档案串连接后传到基本输出; nl,tac,rev
cat /proc/net/bonding/bond0 #查看bond0的状态
    cat -vET # -v：列出一些看不出来的特殊字符
         # -E：将结尾的断行字符 $ 显示出来；
         # -T：将 [tab] 按键以 ^I 显示出来；
    cat -n   # -n：打印出行号，连同空白行也会有行号，与 -b 的选项不同；
    cat -b   # -b：列出行号，仅针对非空白行做行号显示，空白行不标行号
    cat -s file.txt # 可压缩相邻的空白行; 
    cat -T file.py  # 能将制表符标记成^|(对python等文件很有用);
    
    cat file1.gz file2.gz file3.gz > combined.gz  # gz
    cat file1 file2 file3 | gzip > combined.gz    # gz
    
1. Concatenate files
    cat marks_201*
    cat marks_201* > all_marks.txt
2. Accepting input from stdin
    printf 'Name\tMaths\tScience \nbaz\t56\t63\nbak\t71\t65\n' | cat - marks_2015.txt
    printf 'Name\tMaths\tScience \nbaz\t56\t63\nbak\t71\t65\n' | cat marks_2015.txt -
    echo 'Text through stdin' | cat - file.txt 
3. Squeeze consecutive empty lines
    printf 'hello\n\n\nworld\n\nhave a nice day\n'
    printf 'hello\n\n\nworld\n\nhave a nice day\n' | cat -s
4. Prefix line numbers
    cat -n marks_201*
    printf 'hello\n\n\nworld\n\nhave a nice day\n' | cat -sb
    nl marks_201*
5. Viewing special characters
    cat -E marks_2015.txt  # $被看做换行  END
    cat -T marks_2015.txt  # ^I被看做TAB  TAB
    printf 'foo\0bar\0baz\n' | cat -v # 可以看到非打印内容
    printf 'Hello World!\r\n' | cat -v # ^M 被视作 NL
    -A == -ETv
    -e == -vE
6. Writing text to file
    cat > example.txt
This is an example of adding text to new file using cat command
Press Ctrl+d on a newline to save and quit
7. Useless use of cat
    cat report.log | grep -E 'Warning|Error'
    grep -E 'Warning|Error' report.log
    
    cat marks_2015.txt | tr 'A-Z' 'a-z'
    tr 'A-Z' 'a-z' < marks_2015.txt
# 1. cat 从标准输入(键盘)读数据，输入Ctrl-d表示EOF
# 2. cat << str 从键盘输入多行数据，以str为结束符
# 3. cat ... 显示文件文本内容
# 4. cat ... > 合并文件文本内容
cat -n textfile1 > textfile2             # 把 textfile1 的档案内容加上行号后输入 textfile2 这个档案里
cat -b textfile1 textfile2 >> textfile3  # 把textfile1和textfile2的档案内容加上行号(空白行不加)之后将内容附加到 textfile3 里。
}

tail -f /var/log/syslog > log.txt
system(file tail){ 
tail sample.txt         # 默认追后10行
tail -n3 sample.txt     # 最后3行
tail -n +10 sample.txt  # 前10行不显示
seq 13 17 | tail -n +3  # 前3行不显示

echo 'Hi there!' | tail -c3   # 截断字符串
echo 'Hi there!' | tail -c +2 # 截断字符串

head sample.txt
head -n3 sample.txt
head -n -9 sample.txt
seq 13 17 | head -n -2
echo 'Hi there!' | head -c2
echo 'Hi there!' | head -c -4
}
system(file nl){
    nl 显示的时候，顺道输出行号!
    # -b：指定行号指定的方式，主要有两种：
    #     -b a：表示不论是否为空行，也同样列出行号(类似 cat -n)；
    #     -b t：如果有空行，空的那一行不要列出行号(默认值)；
    # -n：列出行号表示的方法，主要有三种：
    #     -n ln：行号在屏幕的最左方显示；
    #     -n rn：行号在自己字段的最右方显示，且不加 0 ；
    #     -n rz：行号在自己字段的最右方显示，且加 0 ；
    # -w：行号字段的占用的字符数。
}
system(file less){ 默认情况下，用于查看manpage内容
cat不适合查看比较大的文件，less支持
查看功能上类似 vi
g         go to start of file
G         go to end of file
q         quit
/pattern  search for the given pattern in forward direction
?pattern  search for the given pattern in backward direction
n         go to next pattern
N         go to previous pattern
}
    cd /usr/src/linux-x.y.z/               #linux-x.y.z.tar.bz2也在/usr/src
    bzip2 -dc ../x.y.z-mm2.bz2 | patch -pl #x.y.z-mm2.bz2在/usr/src


sort -u file1 file2               # Union of unsorted files                  两个未排序文件的并集
sort file1 file2 | uniq -d        # Intersection of unsorted files           两个未排序文件的交集
sort file1 file1 file2 | uniq -u  # Difference of unsorted files             两个未排序文件的差集
sort file1 file2 | uniq -u        # Symmetric Difference of unsorted files   两个未排序文件的对称差集
    sort(将文本文件内容加以排序){
    sort可针对文本文件的内容，以行为单位来排序
        -n  # 依照数值的大小排序
        -r  # 以相反的顺序来排序
        -f  # 排序时，将小写字母视为大写字母
        -b  # 忽略每行前面开始处的空格字符

        -c  # 检查文件是否已经按照顺序排序
        -M  # 前面3个字母依照月份的缩写进行排序
        -h  #  {--human-numeric-sort} 用可读的数字比较 eg: 2k, 
        -u  #  {--unique} 去掉重复行

        -t  # 指定排序时所用的栏位分隔字符
        -k  # 指定域
         
        -i,--ignore-nonprinting # 排序时，只考虑可打印字符，忽略不可打印字符
        -d  # 排序时，处理英文字母、数字及空格字符外，忽略其他的字符
        -m  # 将几个排序好的文件进行合并
        -T  # 指定临时文件目录,默认在/tmp
        +<起始栏位>-<结束栏位>   # 以指定的栏位来排序，范围由起始栏位到结束栏位的前一栏位。
        -o  # 将排序后的结果存入指定的文
2. Various number sorting
    sort -n               # 按数字排序, 不支持负数
    sort -g generic_numbers.txt
1. Reverse sort
    sort -nr              # 按数字倒叙
3. Random sort
    sort -R nums.txt
    shuf nums.txt
4. Specifying output file
    sort -R nums.txt -o rand_nums.txt
    for f in *.txt; do echo sort -V "$f" -o "$f"; done
5. Unique sort
    sort -u               # 过滤重复行
    sort -u duplicates.txt
    sort -nu duplicates.txt
    sort -n duplicates.txt | uniq
    sort -fu words.txt
        sort -m a.txt c.txt   # 将两个文件内容整合到一起
        sort -n -t' ' -k 2 -k 3 a.txt     # 第二域相同，将从第三域进行升降处理
        sort -n -t':' -k 3r a.txt         # 以:为分割域的第三域进行倒叙排列
        sort -k 1.3 a.txt                 # 从第三个字母起进行排序
        sort -t" " -k 2n -u  a.txt        # 以第二域进行排序，如果遇到重复的，就删除
        sort < files.txt > files_sorted.txt
        
        du --block-size=kB | sort -n      #按目录size大小列举目录
        du --block-size=kB | sort -nr     #按目录size大小列举目录
    }

    rename 's/ /_/g' *    # 将文件名中的空格替换成字符_；
    rename 'y/A-Z/a-z/' * # 转换文件名的大小; 
    find . -type f -name "*.mp3" -exec mv {} targetdir \; # 移动mp3文件到特定的目录下；
    find . -type -f -exec rename 's/ /_/g' {} \; # 
    
    rename(文件批量改名){
    rename from to file
      from 源字符。
      to      目标字符。
      file    要改名的文件
    rename .rm .rmvb *      # 把所有文件的后辍由rm改为rmvb
    rename 'tr/A-Z/a-z/' *  # 把所有文件名中的大写改为小写
    
    rename 's/\.bak$/.txt/' *.bak # 使用正则表达式重命名所选文件
    
    mv $files ${files}ts
    
    mv $files  `$files.ts|sed 's/\.//' `
    
    mv $files  $files.txt # file =>file.txt 
    mv $files $(echo ${files}.txt|sed 's/\.//1') # *.04  => *04.txt
    mv $files  `echo ${files}.txt|sed 's/\.//1'`  # *.04  => *04.txt

    # --- 改后缀(.old => .new)
    rename .old .new  *
    mv $files ${file%.old}.new
    mv $files $(echo $files|tr .old .new)
    mv $files $(echo $files|sed 's/\.old/\.new/')
    
    # --- C 去后缀 (*.dat => *)
    mv $files $(echo $files |sed 's/\.dat//' )
    mv $files  $(echo $files|tr .dat  (4空格))
    
    # --- 改前缀 (re* => un*)
    mv $files un${$files#re}
    mv $files $(echo $files | tr re un)
    }
    
    deep_ls(){
function ergodic(){
for file in */$1 ; do
  if [ -d $1"/"$file ] ; then
    ergodic $1"/"$file
  else
    local path=$1"/"$file  #得到文件的完整的目录
    local name=$file        #得到文件的名字
    #做自己的工作.
  fi
done
}
INIT_PATH="/home"
ergodic $INIT_PATH
}

system(etc){

}

stat(取文件长度){

#!/bin/bash 
FILENAME=/home/heiko/dummy/packages.txt 
FILESIZE=$(stat -c %s "$FILENAME") 
echo "Size of $FILENAME = $FILESIZE bytes."

stat <file> # 显示指定文件<file>的状态信息。
stat -f <file> # 显示<file>所在文件系统的状态信息。
stat -t <file> # 以简明格式显示<file>的状态信息。

stat -c %s words.txt # # number of bytes
%a     Access rights in octal                             # 755
%A     Access rights in human readable form               # -rwxr-xr-x
%b     Number of blocks allocated (see %B)                # 80
%B     The size in bytes of each block reported by %b     # 512
%C     SELinux security context string                    # system_u:object_r:home_root_t:s0
%d     Device number in decimal                           # 64771 
%D     Device number in hex                               # fd03
%f     Raw mode in hex                                    # 81ed
%F     File type                                          # regular file
%g     Group ID of owner                                  # 0
%G     Group name of owner                                # root
%h     Number of hard links                               # 1 
%i     Inode number                                       # 1467531
%n     File name                                          # bash-mini.txt 
%N     Quoted file name with dereference if symbolic link # `bash-mini.txt'
%o     I/O block size                                     # 4096 
%s     Total size, in bytes                               # 36962
%t     Major device type in hex                           # 0
%T     Minor device type in hex                           # 0
%u     User ID of owner                                   # 0
%U     User name of owner                                 # root
%x     Time of last access                                # 2019-12-11 16:19:16.329783593 +0800
%X     Time of last access as seconds since Epoch         # 1576052356
%y     Time of last modification                          # 2019-01-07 16:04:41.417546000 +0800
%Y     Time of last modification as seconds since Epoch   # 1546848281
%z     Time of last change                                # 2019-02-20 15:22:04.057620896 +0800
%Z     Time of last change as seconds since Epoch         # 1550647324
Valid format sequences for file systems:                  #
%a     Free blocks available to non-superuser             #
%b     Total data blocks in file system                   #
%c     Total file nodes in file system                    #
%d     Free file nodes in file system                     #
%f     Free blocks in file system                         #
%C     SELinux security context string                    #
%i     File System ID in hex                              #
%l     Maximum length of filenames                        #
%n     File name                                          #
%s     Block size (for faster transfers)                  #
%S     Fundamental block size (for block counts)          #
%t     Type in hex                                        #
%T     Type in human readable form                        #
}

当变量和文件名中包含空格的时候要格外小心。Bash 变量要用引号括起来，比如 "$FOO"。
尽量使用 -0 或 -print0 选项以便用 NULL 来分隔文件名，例如 locate -0 pattern | xargs -0 ls -al 或 find / -print0 -type d | xargs -0 ls -al。
如果 for 循环中循环访问的文件名含有空字符(空格、tab 等字符)，只需用 IFS=$'\n' 把内部字段分隔符设为换行符。

man_find(){


# 1. 与使用者或群组名称有关的参数
-uid n：n   # 为数字，这个数字是使用者的帐号 ID，亦即 UID ，这个 UID 是记录在 /etc/passwd 里面与帐号名称对应的数字。
-gid n：n   # 为数字，这个数字是群组名称的 ID，亦即 GID，这个 GID 记录在/etc/group
-nouser     # 寻找文件的拥有者不存在 /etc/passwd 的人!
-nogroup    # 寻找文件的拥有群组不存在于 /etc/group 的文件!
-user    username             #按文件属主来查找
-group  groupname            #按组来查找
# 2. 与文件权限及名称有关的参数：
-name   filename             #查找名为filename的文件
-perm                        #按执行权限来查找
-type    b/d/c/p/l/f         #查是块设备、目录、字符设备、管道、符号链接、普通文件
-size      n[c]              #查长度为n块[或n字节]的文件
-depth                       #使查找在进入子目录前先行查找完本目录
-fstype                      #查位于某一类型文件系统中的文件，这些文件系统类型通常可 在/etc/fstab中找到
-mount                       #查文件时不跨越文件系统mount点
-follow                      #如果遇到符号链接文件，就跟踪链接所指的文件
-cpio                %;      #查位于某一类型文件系统中的文件，这些文件系统类型通常可 在/etc/fstab中找到
-mount                       #查文件时不跨越文件系统mount点
-follow                      #如果遇到符号链接文件，就跟踪链接所指的文件
-cpio                        #对匹配的文件使用cpio命令，将他们备份到磁带设备中
-prune                       #忽略某个目录  ; 跳过特定的目录

# 3. 与时间有关的选项：共有 -atime, -ctime 与 -mtime ，以 -mtime 说明
-mtime   -n +n                #按文件更改时间来查找文件，-n指n天以内，+n指n天以前
-atime    -n +n               #按文件访问时间来查GIN: 0px">
-ctime    -n +n              #按文件创建时间来查找文件，-n指n天以内，+n指n天以前
-newer   f1 !f2               #查更改时间比f1新但比f2旧的文件
-nogroup                     #查无有效属组的文件，即文件的属组在/etc/groups中不存在
-nouser                      #查无有效属主的文件，即文件的属主在/etc/passwd中不存
# 4. 逻辑运算符
-a：and逻辑与                find. -mtime -3 -a -perm 644
-o：or逻辑或                 find. -name cangls -o -name bols
-not：not逻辑非              find. -not -name cangls
# 5. -exec -ok
"-ok"选项和"-exec"选项的作用基本一致，区别在于："-exec"的命令会直接处理，而不询问；
"-ok"的命令 2 在处理前会先询问用户是否这样处理，在得到确认命令后，才会执行。

-print  返回true;在标准输出打印文件全名，然后是一个换行符
-print0 返回true;在标准输出打印文件全名，然后是一个null字符。这样可以是的处理的输出的程序可以正确地理解带有换行符的文件名。
-printf format 返回true;在标准输出打印format，与-print不同的是，-printf在字符串末端不会添加一个新行。

        # linux文件无创建时间
        # Access 使用时间
        # Modify 内容修改时间
        # Change 状态改变时间(权限、属主)
        # 时间默认以24小时为单位,当前时间到向前24小时为0天,向前48-72小时为2天
        # -and 且 匹配两个条件 参数可以确定时间范围 -mtime +2 -and -mtime -4
        # -or 或 匹配任意一个条件
        
        find -name '*.[ch]' | xargs grep -E 'expr'
        find /etc -name "*http*"     # 按文件名查找
        find . -type f               # 查找某一类型文件
        find . -print                # 列出给定目录下所有的文件和子目录
        find / -perm                 # 按照文件权限查找
        find / -user                 # 按照文件属主查找
        find / -group                # 按照文件所属的组来查找文件
        find / -atime -n             # 文件使用时间在N天以内
        find / -atime +n             # 文件使用时间在N天以前
        find / -mtime +n             # 文件内容改变时间在N天以前
        find / -ctime +n             # 文件状态改变时间在N天前
        find / -mmin +30             # 按分钟查找内容改变
        find . -type f -newermt 2007-06-07 ! -newermt 2007-06-08
        find / -size +1000000c -print                           # 查找文件长度大于1M字节的文件
        find /etc -name "*passwd*" -exec grep "xuesong" {} \;   # 按名字查找文件传递给-exec后命令
        find . -name 't*' -exec basename {} \;                  # 查找文件名,不取路径
        find . -type f -name "err*" -exec  rename err ERR {} \; # 批量改名(查找err 替换为 ERR {}文件
        find 路径 -name *name1* -or -name *name2*               # 查找任意一个关键字
        find ./ -type f -name '.' -exec sed -i 's/\/img01.cfp/\/tj-img01.cfp/g' {} \;
        find . -type f -name ".php" -exec sed -i 's/admup.cfp.cn/tj-admup.cfp.cn/g' {} \; 
        find ./ -type f -name '.php' -exec sed -i 's/219.239.94.108/219.239.94.122/g' {} \;
        find pwd -name '*.php' -exec grep -H 'getbasedir' {} \;
        find /tmp -type f -mtime -13
        find ./ -mtime +7 -type f -name '*.log' -exec rm -f {} \; #查找7天以前的日志并删除之
        
        find . \( -name "*.txt" -o -name "*.pdf" \) -print # 打印出所有的.txt和.pdf文件
        find . -iregex ".*\(\.py\|\.sh\)$"  # 通过正则表达式来匹配.py和.sh文件
        find . -name *.cpp -print0 | xargs -I{} -0 | sed -i 's/Copyright/Copyleft/g' {}
        find . -name *.cpp -exec sed -i 's/Copyright/Copyleft/g' \{\} \; # 为每一个超找到的文件调用一次sed
        find . -name *.cpp -exec sed -i 's/Copyright/Copyleft/g' \{\} \+ # 将多个文件名一并传给sed

find . -maxdepth 3 -mindepth 1 -name "f*"            # 基于目录深度的搜索
find . -type f -perm 644 -name "*.swp" -delete       # 删除当前目录下的.swp文件
find . -name "*.c" -exec cat {} \; > all_c_files.txt # find同命令结合
find . -iname 'power.log'                  # 名字过滤
find -name '*log'                          # 名字过滤
find -not -name '*log'                     # 名字过滤
find . ! -name "*.txt"                     # 否定查询
find -regextype egrep -regex '.*/\w+'      # 名字过滤
find . -type d                             # 查找目录(f/l/c/b/s/p)，s表示套接字设备，p表示FIFO
find /home/guest1/proj -type f             # 文件类型过滤
find /home/guest1/proj -type d             # 文件类型过滤
find /home/guest1/proj -type f -name '.*'  # 文件类型过滤
find -maxdepth 1 -type f                   # 目录深度
find -maxdepth 1 -type f -name '[!.]*'     # 目录深度
find -mindepth 1 -maxdepth 1 -type d       # 目录深度
# -atime -mtime -ctime 访问时间、文件内容修改时间、文件元数据修改时间(权限、所有权)；
# -atime -7表示最近7天内，
# -atime 7恰好在七天前， 
# -atime +7 超过七天, 
# 如find . -type f -atime +7; 类似的有-amin -mmin -cmin(基于分钟的参数)
find -mtime -2                             # 文件时间
find -mtime +7                             # 文件时间
find -daystart -type f -mtime -1           # 文件时间
# -size +2k, -size 2k, -size -2k按文件大小(大于，等于，小于)
find -size +10k                            # 文件大小
find -size -1M                             # 文件大小
find -size 2G                              # 文件大小
find report -name '*log*' -exec rm {} \;     # 后续操作
find report -name '*log*' -delete            # 后续操作
find -name '*.txt' -exec wc {} +             # 后续操作
find -name '*.log' -exec mv {} ../log/ \;    # 后续操作
find -name '*.log' -exec mv -t ../log/ {} +  # 后续操作
}


demo_find(){

# 限定条件
find ~ -maxdepth 1 -type d | wc -l # 查看当前目录下，有多少个目录。-maxdepth/-mindepth限定深度，当前目录为1
find ~ -type d | wc -l # 查找文件类型是目录，并且统计个数。d目录，f普通文件，b块设备，c字符设备，l符号链接
find ~ -name "\*.JPG" # 匹配正则的文件或目录(引号避免shell展开)。-iname 不区分大小写。*匹配任意个任意字符，?匹配1个任意字符，[1a]匹配a或1
find ~ -user "jhon" # 查找属于某个用户的文件或目录(用户名或者id)。-nouser不属于。-group/-nogroup 同理
find ~ -perm 755 # 查找符合权限配置的文件和目录(755或rwx都可)
find ~ -empty # 查找~里面的空文件和目录
# 凡是数量，n是"正好为n"，-n是"少于n"，+n是"大于n"
find ~ -size +1M # 限定大小超过1mb。b>512byte, c>byte, w>2byte, k>kB, M>MB, G>GB
find ~ -amin n # 最后访问时间access正好在之前的 n 分钟。-atime n 是n*24小时。
find ~ -cmin n # 最后属性修改时间change正好在之前的 n 分钟。-ctime n 是n*24小时。
find ~ -mmin n # 最后内容修改时间change正好在之前的 n 分钟。-mtime n 是n*24小时。
find ~ -cnewer f.txt # 查找内容或属性修改时间在 f.txt 之后的文件
find ~ -newer f.txt # 查找内容修改时间在 f.txt 之后的文件。以此为基点，之后进行更新的文件
find ~ -inum n # 查找 inode 号是 n 的文件。
find ~ -samefile f.txt # 查找和文件 f.txt 有同样 inode 号的文件。

# 条件的布尔运算 -or -and -not (会执行常见的短路运算)
find ~ \( -type f -not -perms 0600 ) -or \( -type d -not -perms 0700 )
find . \( -name '*.txt' -o -name '*.pdf' \) -print
find /root -size +20480   -a -size -204800 # 大小在 (10M, 100M) 区间内的文件
# 执行操作
find ~ -type f -name '*.BAK' -print # 这是 find 默认操作，实际上是 find ~ -type f -and -name '*.BAK' -and -print。可以重新安排执行的顺序 find ~ -print -and -type f -and -name '*.BAK'  结果就会很不同
find . -type f -name '*.out' -delete # 找出本目录下，扩展名.out的文件，然后删除
find . -type f -name '*.out' -quit # 找到就退出
find . -type f -name '*.out' -ls # ls -dils
# 自定义操作 -exec command '{}' ';' 括号和分号是Token，需要引起来或者转义
find . -type f -name '*.out' -exec rm -rf '{}' ';' # {}代表的是找到的一个结果
find . -type f -name '*.out' -exec mv '{}' '{}.o' ';' # {} {}.o就是a.out a.o的关系
find . -type f -name '*.out' -ok rm -rf '{}' ';' # 每次删除之前，会让用户决定yes&no
find . -type f -name '*.out' -ok rm -rf '{}' + #所有的find结果，被当作一个参数来执行(';'是多个)，rm -rf 只执行一次

find /opt/lampp/htdocs -type d -exec chmod 755 {} \;
find /opt/lampp/htdocs -type f -exec chmod 644 {} \;

# 自定义操作：xargs从标准输入接受输入，并且转为后面命令的参数列表。而 | xargs command 就将管道转为参数列表
find ~ -type f -name 'foo\*' -print | xargs rm -rf
find ~ -iname '*.jpg' -print0 | xargs -null ls -l # 如 m a.jpg 这样的文件名，中间有空格、换行符之类，就不能正确执行了。而 -print0 产生的字符串，由 null 作为分割符；与之相应地，xargs -null 指定分割符
}

# Ubuntu 上两款英文打字练习软件
typespeed # sudo apt-get install typespeed
ktouch    # sudo apt-get install ktouch
    
sudo iptables -L -n | vim -
grep -v xxx | vim -
VIM编辑远程文件 vim scp://xxx//etc/vimrc
远程执行脚本 ssh xxx bash < xxx.sh
# 全文注释： 
    :0,$ s/^/#/ #m到n行注释： 
    :m,n s/^/#/ #全文去注释： 
    :0,$ s/^#// #m到n行去注释： 
    :m,n s/^#//
# vim列编辑
    在normal模式下按ctrl+v进入列编辑模式
    通过hjkl选中编辑的区域.
    shift+i 或者 shift+a
    输入要插入的内容.
    ctrl+\[或esc  
# vim编辑二进制文件
vim -b file
    :%!xxd # 把文件内容转换成16进制。
    :%!xxd -r: 转换回来
    
:w !sudo tee %             #在以普通用户打开的VIM当中保存一个ROOT用户文件
    # tee是一个把stdin保存到文件的小工具。
    # 而%，是vim当中一个只读寄存器的名字，总保存着当前编辑文件的文件路径。
    # :w !{cmd} -> sudo tee % -> % 只读寄存器的名字，总保存着当前编辑文件的文件路径。
quickfix
    :copen 打开Quickfix窗口
    :cclose 关闭Quickfix窗口
    :cn 跳到下一个Error的所在行
    :cp 调到上一个Error的所在行
% # 在一对匹配的符号之间跳转
:r!seq 100 # 插入一个1到100的序列
:let i=1 | g /^/ s//\=i.". "/ | let i+=1 # 在当前的每一行文字前面增加[序号]
:help即可进入中文帮助
:help user-manual直接进入用户手册
doc      # 帮助文档目录
autoload # Vim启动时自动加载的插件目录
plugin   # 插件目录，一般在使用Vim时通过命令呼出
用 shift v 选中多行文本，输入 : !sort # 对文本进行简单排序：

https://github.com/yangyangwithgnu/use_vim_as_ide
    vim(){  
        vi ${grep -l "define" *.c} #编辑所有含有define的c的源文件, -l指示grep只打印文件名
        gconf-editor           # 配置编辑器
        /etc/vimrc             # 配置文件路径
        vi -R <file>           # 用vi打开<file>指定的文件，但不能编辑，即只读模式。
        vim +24 file           # 打开文件定位到指定行
        vi +/pattern <file>    # 用vi编辑<file>指定的文件，并且将光标定位到符合pattern模式的行。
        vim file1 file2        # 打开多个文件
        vim -O2 file1 file2    # 垂直分屏
        vim -on file1 file2    # 水平分屏
        Ctrl+ U                # 向前翻页
        Ctrl+ D                # 向后翻页
        Ctrl+ww                # 在窗口间切换
        Ctrl+w +or-or=         # 增减高度
        :sp filename           # 上下分割打开新文件
        :vs filename           # 左右分割打开新文件
        :set nu                # 打开行号
        :set nonu              # 取消行号
        :nohl                  # 取消高亮
        :set paste             # 取消缩进
        :set autoindent        # 设置自动缩进
        :set ff                # 查看文本格式
        :set binary            # 改为unix格式
        :%s/字符1/字符2/g      # 全部替换
        :200                   # 跳转到200  1 文件头
        G                      # 跳到行尾
        dd                     # 删除当前行 并复制 可直接p粘贴
        11111dd                # 删除11111行，可用来清空文件
        r                      # 替换单个字符
        R                      # 替换多个字符
        u                      # 撤销上次操作
        *                      # 全文匹配当前光标所在字符串
        $                      # 行尾
        0                      # 行首
        X                      # 文档加密
        v =                    # 自动格式化代码
        Ctrl+v                 # 可视模式
        Ctrl+v I ESC           # 多行操作
        Ctrl+v s ESC           # 批量取消注释
        
#这称得上是一个 Vim 的杀手级 Tip，利用该 Tip，你可以快速处理 '、"、()、[]、{}、<> 等配对标点符号中的文本内容，包括更改、删除、复制等。
#    ci'、ci"、ci(、ci[、ci{、ci< - 分别更改这些配对标点符号中的文本内容
#    di'、di"、di(、di[、di{、di< - 分别删除这些配对标点符号中的文本内容
#    yi'、yi"、yi(、yi[、yi{、yi< - 分别复制这些配对标点符号中的文本内容

    技巧45: 以超级用户权限保存文件
    :W !sudo tee % > /dev/null
    <C -n> 普通关键字
    <C -x> <C -n> 当前缓冲区关键字
    <C -x> <C -i> 包含文件关键字
    <C -x> <C -]> 标签文件关键字
    <C -x> <C -k> 字典查找
    <C -x> <C -l> 整行补全
    <C -x> <C -f> 文件名补全
    <C -x> <C -o> 全能补全
    
    gf：go to file
    
    vim提供了一个动作命令，让我们可以在开、闭括号间跳转。
%命令允许我们在一组开、闭括号间跳转，它可作用于()｛｝以及[]。插件 vim-surround

    文本对象 选择范围
    ==============================================
    iw 当前单词
    aw 当前单词及一个空格
    iW 当前字串
    aW 当前字串及空格
    is 当前句子
    iS 当前句子及空格
    ip 当前段落
    iP 当前段落及一个空行
    
    S   删除一整行后替换文本
    R   进入覆盖模式
    J   合并当前行和下一行为一行
    
    H: 移到屏幕顶端的行 
    M: 移到屏幕中间的行 
    L: 移到屏幕底部的行
# ^M
:%s/^M//g
dos2unix filename
sed -i "s/原字符串/新字符串/g" filename
sed -i "s/^M//g" filename
tr -d "\\r" < filename >newfile
tr -d "\\015" <filename >newfile
strings filename > newfile
    }
    Vundle(){
    只需要维护需要的插件列表就可以统一安装，同样，复制环境时也只需要复制一个文件(.vimrc)
    支持git更新
    支持插件搜索功能
    自动管理插件依赖关系
    
    git clone https://github.com/gmarik/vundle.git ~/.vim/bundle/vundle # 安装
    如果你使用git管理vim配置，还可以使用git submodule
        git submodule add https://github.com/gmarik/vundle.git vim/bundle/vundle 
        会在.gitmodule中增加如下配置：
        
        [submodule "vim/bundle/vundle"]
        path = vim/bundle/vundle
        url = https://github.com/gmarik/vundle.git
        
        之后运行git命令：
        git submodule init
        git submodule update
        
    :BundleInstall # 安装插件
    :h vundle      # 使用帮助
    :BundleList    # 查看插件清单
    :BundleSearch markdown # 搜索插件
    :BundleClean           # 清理不用的插件
    :BundleClean markdown  # 清理不用的插件
    }
    cscope(){
#由于要使用绝对路径，生成一个包含这些路径的文本文件cscope.files
find /absolute/path/to/project/ -name "*.c" -o -name "*.h" -o -name "*.cc" -o -name "*.cpp" > cscope.files
#进入工程目录
cd /absolute/path/to/project/
#指定某些参数和指定路径文件来生成索引
cscope -Rbq -i cscope.files

R 表示把所有子目录里的文件也建立索引 
b 表示cscope不启动自带的用户界面，而仅仅建立符号数据库 
q 生成cscope.in.out和cscope.po.out文件，加快cscope的索引速度 
i 后边接指定的文件名称文本文件 
k 在生成索引文件时，不搜索/usr/include目录
Vim中使用cscope

在源码根目录下打开任意.c文件，使用如下命令：
Ctrl+]将跳到光标所在变量或函数的定义处 Ctrl+T返回
：cs find s ---- 查找C语言符号，即查找函数名、宏、枚举值等出现的地方
：cs find g ---- 查找函数、宏、枚举等定义的位置，类似ctags所提供的功能
：cs find d ---- 查找本函数调用的函数
：cs find c ---- 查找调用本函数的函数
：cs find t: ---- 查找指定的字符串
：cs find e ---- 查找egrep模式，相当于egrep功能，但查找速度快多了
：cs find f ---- 查找并打开文件，类似vim的find功能
：cs find i ---- 查找包含本文件的文
    }
    
    
tmux new -s session_name          # 新建 session
tmux attach -t session_name       # 切换到指定 session
tmux list-sessions                # 列出所有 session
tmux detach                       # 退出当前 session，返回前一个 session 
tmux kill-session -t session-name # 杀死指定 session

    tmux(){Ctrl-b d
    tmux attach-session
    tmux list-sessions
    Ctrl-b ?
    # CRTL-b " CRTL-b % CTRL-b <光标键>
    
    tmux -Lfoo -f/dev/null start\; show -g  # 配置
    tmux -Lfoo -f/dev/null start\; show -gw # 配置
    set -g default-terminal "screen-256color" 或者 set -g default-terminal "tmux-256color" # 配色
    
    保存和恢复 Tmux 会话
    git clone https://github.com/tmux-plugins/tpm.git ~/.tmux/plugins/tpm
        # List of plugins
        set -g @plugin 'tmux-plugins/tpm'
        set -g @plugin 'tmux-plugins/tmux-sensible'
        
        # Other examples:
        # set -g @plugin 'github_username/plugin_name'
        # set -g @plugin 'git@github.com/user/plugin'
        # set -g @plugin 'git@bitbucket.com/user/plugin'
        
        # Initialize TMUX plugin manager (keep this line at the very bottom of tmux.conf)
        run '~/.tmux/plugins/tpm/tpm'
    tmux source ~/.tmux.conf
    安装、升级和反安装插件
        prefix shift-i      # install
        prefix shift-u      # update
        prefix alt-u        # uninstall plugins not on the plugin list
    
    tmux-resurrect
        set -g @plugin 'tmux-plugins/tmux-resurrect'
        prefix shift-i
    tmux-resurrect    
        # tmux-resurrect
        set -g @resurrect-save-bash-history 'on'
        set -g @resurrect-capture-pane-contents 'on'
        set -g @resurrect-strategy-vim 'session'
        # set -g @resurrect-save 'S'
        # set -g @resurrect-restore 'R'
    保存和加载
        至此，tmux-resurrect 已经配置好，可以保存和加载 Tmux 会话的状态了，快捷键是：
        prefix Ctrl-s       # save tmux session to local file
        prefix Ctrl-r       # reload tmux session from local file
    }
    
    vim(ctag){
ctags -R --langmap=c:+.m --c-kinds=+p --fields=+iaS --extra=+q .

find . -maxdepth 1 -type f -name '*.h' -or -name '*.c' > tags_list.file 
ctags --c++-kinds=+p --fields=+iaS --extra=+q -L tags_list.file

ctags -R --c++-kinds=+p --fields=+iaS --extra=+q --languages=c++ --langmap=c++:+.inl ..

ctags -R --c++-kinds=+px --fields=+iaS --extra=+q
ctags -R --languages=c++ --langmap=c++:+.inl -h +.inl --c++-kinds=+px --fields=+aiKSz --extra=+q --exclude=lex.yy.cc --exclude=copy_lex.yy.cc
-R												递归
--languages=c++									只扫描文件内容为c++的文件
--langmap=c++:+.inl								告知ctags,以inl为扩展名的文件是c++语言写的,在加之上述2中的选项,即要求ctags以c++语法扫描以inl为扩展名的文件
-h +.inl										告知ctags,把以inl为扩展名的文件看作是头文件的一种
--c++-kinds=+px									记录类型为函数声明和前向声明的语法元素
--fields=+aiKSz									控制记录的内容
--extra=+q										让ctags额外记录一些东西
--exclude=lex.yy.cc --exclude=copy_lex.yy.cc	告知ctags不要扫描名字是这样的文件
-f tagfile										指定生成的标签文件名,默认是tags

ctags里的kind
	x 					声明一个变量
	f(function)			函数实现
	p(prototype) 		函数声明
	c(class)			类定义
	s(struct)			结构体定义
m(macro) 宏定义
    }
    translate(){
    https://github.com/soimort/translate-shell
    
    wget git.io/trans  # https://raw.githubusercontent.com/soimort/translate-shell/gh-pages/trans
    chmod +x ./trans
    
    trans vorto # From any language to your language
    trans :fr word      # to fr
    trans :zh+ja word   # to fr+ja
    trans -t zh+ja word # to fr+ja
    
    trans 手紙       # from 
    trans ja: 手紙   # from ja
    trans zh: 手紙   # from zh
    trans -s ja 手紙 # from zh
    
    trans en:zh word processor    # 多个单词
    trans en:zh "word processor"  # 多个单词
    
    trans :zh 'To-morrow, and to-morrow, and to-morrow,'   # 句子
    trans :zh 'Out, out, brief candle!'                    # 句子
    trans :zh "Life's but a walking shadow, a poor player" # 句子
    
    trans -b :fr "Saluton, Mondo" # Brief Mode
    trans -d fr: mot              # Dictionary Mode
    trans :fr file://input.txt    # File Mode
    trans :fr http://www.w3.org/  # Web Mode
    trans -shell                  # interactive Mode
    trans -shell en:fr
    
    trans -e bing "Why not test this thing"                # bing
    trans -e yandex "Ничего, были бы кости, а мясо будет"  # yandex
    }
    tmux(保存和加载){
    #!/bin/bash
    tmuxSnapshot=/.tmux_snapshot
    tmuxEXE=/usr/local/bin/tmux
    save_snap()
    {
            ${tmuxEXE} list-windows -a -F"#{session\_name} #{window\_name} #{pane\_current\_command} #{pane\_current\_path}" > ${tmuxSnapshot}
    }
    
    restore_snap()
    {
            ${tmuxEXE} start-server
            while IFS=' ' read -r session_name window_name pane_current_command pane_current_path
            do
                    ${tmuxEXE} has-session -t "${session_name}" 2>/dev/null
                    if [ $? != 0 ]
                    then
                            ${tmuxEXE} new-session -d -s "${session_name}" -n ${window_name}
                    else
                            ${tmuxEXE} new-window -d -t ${session_name} -n "${window_name}"
                    fi
                    ${tmuxEXE} send-keys -t "${session_name}:${window\_name}" "cd ${pane_current_path}; echo \"Hint: last time you are executing '${pane_current_command}'.\"" ENTER
            done < ${tmuxSnapshot}
    }
    
    ps aux|grep -w tmux|grep -v grep
    if [ $? != 0 ]
    then
            restore_snap
    else
            save_snap
    fi
    }
    screen()
    {
screen /dev/ttyUSB0 115200 (on the debug port) ssh: 192.168.0.7 username: steph password: [space]
screen /dev/ttyUSB0 9600

 break       ^B b        fit         F           lastmsg     ^M m        number      N           redisplay   ^L l        suspend     ^Z z        writebuf    >
 clear       C           flow        ^F f        license     ,           only        Q           remove      X           time        ^T t        xoff        ^S s
 colon       :           focus       ^I          lockscreen  ^X x        other       ^A          removebuf   =           title       A           xon         ^Q q
 copy        ^[ [        hardcopy    h           log         H           pow_break   B           reset       Z           vbell       ^G
 detach      ^D d        help        ?           login       L           pow_detach  D           screen      ^C c        version     v
 digraph     ^V          history     { }         meta        a           prev        ^H ^P p ^?  select      "'"          width       W
 displays    *           info        i           monitor     M           quit        \           silence     _           windows     ^W w
 dumptermcap .           kill        K k         next        ^@ ^N sp n  readbuf     <           split       S           wrap        ^R r

C-a ?	显示所有键绑定信息
C-a w	显示所有窗口列表
C-a C-a	切换到之前显示的窗口
C-a c	创建一个新的运行shell的窗口并切换到该窗口
C-a n	切换到下一个窗口
C-a p	切换到前一个窗口(与C-a n相对)
C-a 0..9	切换到窗口0..9
C-a a	发送 C-a到当前窗口
C-a d	暂时断开screen会话
C-a k	杀掉当前窗口
C-a [	进入拷贝/回滚模式 
screen -S test        #创建一个名为test的screen 
screen -r test        #打开名字为test的screen 
screen -r pid         #打开进程号为pid的screen 
screen -ls            #列出所有的screen 
ctrl + a,d            #当在一个screen时，退出screen 
ctrl + a,n            #当在一个screen时，切换到下一个窗口 
ctrl + a,c            #当在一个screen时，创建一个新的窗口
    }
    
c (x1), w (x2), b (x512), kD (x1000), k (x1024), MD (x1000000), M (x1048576), GD(x1000000000) or G (x1073741824)
c =1, w =2, b =512, kB =1000, K =1024, MB =1000*1000, M =1024*1024, xM =M GB =1000*1000*1000, G =1024*1024*1024

dd(读取，转换并输出数据；可以处理原始的,未格式化的的数据)
{
    dd if=otdr_dianming.raw of=otdr_dianming701.raw  bs=1 count=297 skip=298 # otdr_dianming701.raw为otdr_dianming.raw的后298个字符
    dd if=otdr_dianming.raw of=otdr_dianming110.raw  bs=298 count=1          # otdr_dianming110.raw为otdr_dianming.raw的前297个字符

dd if=/dev/rsd1b of=/dev/rsd2b bs=8k skip=8 seek=8 count=3841  # 从raw设备备份到raw设备
dd if=/dev/rsd1b of=/backup/df1.dbf bs=8k skip=8 count=3841    # 裸设备到文件系统
dd if=/dev/hdx  of=/path/to/image  count=1  bs=512 # 备份磁盘开始的512Byte大小的MBR信息到指定文件
dd if=/mnt/windows/Linux.lnx of=/dev/hda bs=512 count=1 # 恢复MBR

# 得到最恰当的block size。 通过比较dd指令输出中所显示的命令执行时间(选时间最少的那个)，
# 即可确定系统最佳的block size大小
dd if=/dev/zero bs=1024 count=1000000 of=/root/1Gb.file
dd if=/dev/zero bs=2048 count=500000 of=/root/1Gb.file
dd if=/dev/zero bs=4096 count=250000 of=/root/1Gb.file
dd if=/dev/zero bs=8192 count=125000 of=/root/1Gb.file
dd if=/dev/hdx | gzip > /path/to/image.gz # 备份/dev/hdx全盘数据，并利用gzip工具进行压缩，保存到指定路径

利用netcat远程备份
在源主机上执行此命令备份/dev/hda：dd if=/dev/hda bs=16065b | netcat < targethost-IP >1234
在目的主机上执行此命令来接收数据并写入/dev/hdc：netcat -l -p 1234 | dd of=/dev/hdc bs=16065b

dd if=/dev/hdx of=/path/to/image # 备份磁盘开始的512Byte大小的MBR信息到指定文件：

if =输入文件(或设备名称)。
of =输出文件(或设备名称)。
ibs = bytes 一次读取bytes字节，即读入缓冲区的字节数。
skip = blocks 忽略读取if指定文件的前多少个块           # 
seek = blocks 指定写入到of指定文件时忽略前多少个块
obs = bytes 一次写入bytes字节，即写 入缓冲区的字节数。
bs = bytes 同时设置读/写缓冲区的字节数(等于设置obs和obs)。 # bs有c(1byte)、w(2bytes)、b(512bytes)、kB(1000bytes)、K(1024bytes)、MB(1000)、M(1024)和GB、G等几种单位
cbs = bytes 一次转换bytes字节。
count = blocks 只拷贝输入的blocks块。                      # 

# 合并文件
## 关注细节
dd if=/tmp/CentOS.iso of=/tmp/CentOS1.iso bs=2M count=250
dd if=/tmp/CentOS.iso of=/tmp/CentOS2.iso bs=2M skip=250
## 忽略细节
cat CentOS1.iso CentOS2.iso >CentOS_m.iso
}
# dd无法以行为单位提取文件数据，也无法直接将文件按大小或行数进行均分(除非借助循环)。
# 另两款数据分割工具split和csplit能够比较轻松地实现这些需求。csplit是split的升级版。

将一个大文件分割成较小的文件，默认每1000行分割成一个小文件。有时需要将文件分割成更小的片段，比如为提高可读性、生成日志等。
split(split可以按行和字节处理对应文件){ 按大小拆分
 ---  cat、od 和 split csplit hexdump tac 
# 既然要生成多个小文件，必然要指定切分文件的单位，支持按行切分以及按文件大小切分，
# 另外还需解决小文件命名的问题。例如，文件名前缀、后缀。如果未明确指定前缀，则默认的前缀为"x"。
split [OPTION]... [INPUT [PREFIX]]
  
-a <长度>：生成长度为N的后缀，默认N=2
-b <字节>：每个小文件的N，即按文件大小切分文件。支持K,M,G,T(换算单位1024)或KB,MB,GB(换算单位1000)等，默认单位为字节
-l <字节>：每个小文件中有N行，即按行切分文件
-d，--numeric-suffixes：指定生成数值格式的后缀替代默认的字母后缀，数值从N开始，默认为0。例如两位长度的后缀01/02/03
--additional-suffix=string：为每个小文件追加额外的后缀，例如加上".log"。有些老版本不支持该选项，在CentOS 7.2上已支持。
-C <字节>，--line-bytes=SIZE：子文件中，单行的最大字节数

INPUT：指定待切分的输入文件，如要切分标准输入，则使用"-"
PREFIX：指定小文件的前缀，如果未指定，则默认为"x"

split -b 10k data.file -d -a 4 splitfile # -d 表示以数字为后缀， -a 表示后缀长度；-l可以通过行来进行切分。
split -l 5 -d -a 2 /etc/fstab fs_ # 每5行切分一次，并指定小文件的前缀为"fs_"，后缀为数值后缀，且后缀长度为2
cat fs_0[0-2] >~/fstab.bak        # 还原
seq 1 2 15 | split -l 3 -d - new_ # 将标准输入的数据进行切分，并分别写入到小文件中
seq 1 2 20 | split -l 3 -d -a 3 --additional-suffix=".log" - new1_ # 为每个小文件追加额外的后缀。
}
csplit(split可以按行、字节、段落、模式处理对应文件){ 按模式拆分
csplit [OPTION]... FILE PATTERN...
  描述：按照PATTERN将文件切分为"xx00","xx01", ...，并在标准输出中输出每个小文件的字节数。
  
选项说明：
  -b FORMAT：指定文件后缀格式，格式为printf的格式，默认为%02d。表示后缀以2位数值，且不足处以0填充。
  -f PREFIX：指定前缀，不指定是默认为"xx"。
  -k：用于突发情况。表示即使发生了错误，也不删除已经分割完成的小文件。
  -m：明确禁止文件的行去匹配PATTERN。
  -s：(silent)不打印小文件的文件大小。
  -z：如果切分后的小文件中有空文件，则删除它们。
  
FILE：待切分的文件，如果要切分标准输入数据，则使用"-"。
模式：
    INTEGER         ：数值，假如为N，表示拷贝1到N-1行的内容到一个小文件中，其余内容到另一个小文件中。
    /REGEXP/[OFFSET]：从匹配到的行开始按照偏移量拷贝指定行数的内容到小文件中。
                    ：其中OFFSET的格式为"+N"或"-N"，表示向后和向前拷贝N行
    %REGEXP%[OFFSET]：匹配到的行被忽略。
    {INTEGER}       ：假如值为N，表示重复N此前一个模式匹配。
    {*}             ：表示一直匹配到文件结尾才停止匹配。

csplit orginal.txt 11 72 98 # xx00 文件包含行 1-10，xx01 文件包含行 11-71，xx02 文件包含行 72-97，xx03 文件包含行 98-最后。
csplit book "/^ Chapter *[k.0-9]k./" {9} # 将 book 的文本以每章一个单独文件来分割，
csplit -f chap book "/^ Chapter *[k.0-9]k./" {9} # 为这些创建自 book 的文件指定前缀 chap， 把 book 分割成文件，命名从 chap00 到 chap09。
csplit file.txt "/pattern/" "{*}" # 以匹配pattern的行作为每个文件的首行 
csplit file.txt "/pattern/+1" "{*}" # 以匹配pattern的行的下一行作为每个文件的首行

cat <<END >test.txt
SERVER-1
[connection] 192.168.0.1 success
[connection] 192.168.0.2 failed
[disconnect] 192.168.0.3 pending
[connection] 192.168.0.4 success
SERVER-2
[connection] 192.168.0.1 failed
[connection] 192.168.0.2 failed
[disconnect] 192.168.0.3 success
[CONNECTION] 192.168.0.4 pending
SERVER-3
[connection] 192.168.0.1 pending
[connection] 192.168.0.2 pending
[disconnect] 192.168.0.3 pending
[connection] 192.168.0.4 failed
END
# 每个SERVER-n表示一个段落，于是要按照段落切分该文件
csplit -f test_ -b %04d.log test.txt /SERVER/ {*}
1. "-f test_" 指定小文件前缀为"test_"
2. "-b %04d.log" 指定文件后缀格式"00xx.log",它自动为每个小文件追加额外的后缀".log"，
3. "/SERVER/" 表示匹配的模式，每匹配到一次，就生成一个小文件，且匹配到的行是该小文件中的内容，
4. "{*}" 表示无限匹配前一个模式即/SERVER/直到文件结尾，假如不知道{*}或指定为{1}，将匹配一次成功后就不再匹配。
csplit -f test1_ -z -b %04d.log test.txt /SERVER/ {*}
5. 生成的空文件可以使用"-z"选项来删除。
csplit -f test2_ -z -b %04d.log test.txt /SERVER/+2 {*}
6. 还可以指定只拷贝匹配到的行偏移数量。

csplit server.log /SERVER/ -n 2 -s {*} -f server -b "%02d.log" ; 
rm server00.log 按日志文件中的某个单词或内容进行切割。
    /[REGEX]/表示文本样式，用来匹配某一行
    {*} 表示匹配重复的次数，中间数字若为*则表示匹配直到文件结尾
    -s静态模式， -n 分割后的文件名后缀的数字数， -f 分割后的文件名前缀， -b 指定后缀格式(同fprint)
}
 sudo apt-get install setserial # 
    ckermit(/home/用户名/.kermrc){
set line /dev/ttyUSB0      //如果是串口就是ttyS0
set speed 115200
set carrier-watch off
set handshake none
set flow-control none
robust
set file type bin
set file name lit
set rec pack 1000
set send pack 1000
set window 5
设置完成,连接
connect
就可以使用了.
----------------------------------
kermit捕捉日志
    ctrl-\ C  进入kermit命令行模式
    log session session.log new //捕捉日志到文件session.log
    log session session.log append //追加日志到文件session.log
    log session off //停止捕捉日志
----------------------------------  
发送文件：
    kermit中输入connect后，跳到u-boot串口界面。
    输入loadb 0xAddress 回车
    按下 ctrl + / ，再按c,切换到kermit。
    输入命令：send /home/zImage
    kermit开始传送数据了，并可以看到传送进度，发送完后，输入c,再回到u-boot界面，然后，再输入：
    go 0xAddress
    内核开始运行.  
    }

    minicom(gtkterm)
    {
        minicom是一个串口通信工具，就像Windows下的超级终端。可用来与串口设备通信，如调试交换机和Modem等。
    它的Debian软件包的名称就叫minicom，用apt-get install minicom即可下载安装。
    1.  minicom -s
    2. _
 [configuration]─-─—┐//配置
│ Filenames and paths │//文件名和路径
│ File transfer protocols│//文件传输协议
│ Serial port setup │//串行端口设置
│ Modem and dialing │//调制解调器和拨号
│ Screen and keyboard │//屏幕和键盘
│ Save setup as dfl │//设置保存到
│ Save setup as.. │//储存设定为
│ Exit │//退出
│ Exit from Minicom │//退出minicom
└──────────┘ 
    2.1 设置serial port setup
使用down箭头选择serial port setup,出现具体各选项的配置：
│A-Serial Device(串口设备): /dev/ttyS0
│B-Lockfile Location(锁文件位置): /var/lock
│C-Callin Program(调入程序):
│D-Callout Program(调出程序):
│E-Bps/Par/Bits(): 115200 8N1
│F-Hardware Flow Control(硬件数据流控制): No
│G-Software Flow Control(软件数据流控制): No
Change which setting? (改变这些设置) 然后选中"Save setup as dfl"，按回车键保存刚才的设置。
2.2 在选中"EXit"退出设置模式，刚才的设置保存到"/etc/minirc.dfl"，接着进入初始化模式。
或可以这样设置，打开终端输入minicom后，初始化进入minicom的欢迎界面，这里提示按"Ctrl+A",再按"Z"键进入主配置目录
按下"O"键,并选择串口配置选项进行配置。接下来的配置是一样的。

3．设置Modem and dialing
使用方向箭头选中modem and dialing 项，则修改modem and dialing 选项中的配置项。
需要修改的是去掉A — initing string ……：，B — Reset string ……：
K — Hang-up string ……三个配置项。
4．选择Save as dfl
选择Save as dfl选项将修改后的配置信息进行保存为默认的配置选项。
5．Exit from minicom
选择Exit from minicom 选项从配置菜单返回到命令行。
6．重新启动Minicom
使用minicom 启动minicom 在linux下通过串口连接器，实现超级终端的功能。
 解析一下minicom命令摘要，命令将被执行当你按下Ctrl+D ,Key是对应的"字母"键。
"D"键：拨号目录
"S"键：发送文件，上传文件有几种方式：zmodem、ymodem、xmodem、kermit、ascii
"P"键：通信参数。对波特率进行设置。
"L"键：捕捉开关。
"F"键：发送中断。
"T"键:终端设置。A-终端仿真：VT102终端B-Backspace键发送：DEL键 C-状态一致：启动D-换行延迟(毫秒):0
"W"键：换行开关
"G"键：运行脚本
"R"键：接收文件
"A"键:添加一个换行符
"H"键：挂断
"M"键：初始化调制解调器
"K"键：运行kermit进行刷屏
"E"键：切换本地回显开关
"C"键:清除屏幕
"O"键：配置minicom
"J"键:暂停minicom
"X"键：退出和复位
"Q"键:退出没有复位
"I"键：光标模式
"Z"键：帮助屏幕
"B"键：滚动返回
    }

cdrecord(){
mkisofs -l -J -L -r -o <target iso file> <files>
mkisofs -l -J -L -r -V config-2 -o /root/haproxy.iso .

cdrecord -v gracetime=2 dev=/dev/cdrom -eject blank=fast -force 清空一个可复写的光盘内容
mkisofs /dev/cdrom > cd.iso 在磁盘上创建一个光盘的iso镜像文件
mkisofs /dev/cdrom | gzip > cd_iso.gz 在磁盘上创建一个压缩了的光盘iso镜像文件
mkisofs -J -allow-leading-dots -R -V "Label CD" -iso-level 4 -o ./cd.iso data_cd 创建一个目录的iso镜像文件
cdrecord -v dev=/dev/cdrom cd.iso 刻录一个ISO镜像文件
gzip -dc cd_iso.gz | cdrecord dev=/dev/cdrom - 刻录一个压缩了的ISO镜像文件
mount -o loop cd.iso /mnt/iso 挂载一个ISO镜像文件
cd-paranoia -B 从一个CD光盘转录音轨到 wav 文件中
cd-paranoia -- "-3" 从一个CD光盘转录音轨到 wav 文件中(参数-3)
cdrecord --scanbus 扫描总线以识别scsi通道
dd if=/dev/hdc | md5sum 校验一个设备的md5sum编码，例如一张 CD
}

tar_intro(){

# *.Z compress 程序压缩的档案； 
# *.bz2 bzip2 程序压缩的档案； 
# *.gz gzip 程序压缩的档案； 
# *.tar tar 程序打包的数据，并没有压缩过； 
# *.tar.gz tar 程序打包的档案，其中并且经过 gzip 的压缩

gzip只能压缩单个文件或数据流
zcat test.gz无需解压直接读取test.gz
bzip2语法同gzip, 但压缩效率更高, test.tar.bz2
lzma 压缩效率比上面的更高, unlzma, test.tar.lzma
zip同时有归档和压缩功能, 
zip -r archive.zip folder1 folder2      # 对目录和文件进行递归操作, 
unzip file.zip, zip file.zip -u newfile # 更新压缩文件中的内容, 
zip -d file.zip file1                   # 删除文件
创建压缩文件系统 squashfs 
mount -o loop compressedfs.squashfs /mnt/squash # 可利用环回形式挂载squashfs文件系统

zip vs gzip: # http://www.netlib.org/gnu/gzip/readme
    zip和gzip(gz)不兼容，虽然它们都是使用相同的deflate压缩算法
    zip更像一个打包器，能把多个多件放到一个zip中；gzip一次只对一个文件压缩，通常与tar命令一起用
tar炸弹
    攻击者利用绝对路径，或者"tar -cf bomb.tar *"的方式创建的tar文件，然后诱骗受害者在根目录下
    解压，或者使用绝对路径解压。可能使受害系统上已有的文件被覆盖掉，或者导致当前工作目录凌乱不堪，
    这就是所谓的"tar炸弹"。
    
1 、*.tar 用  tar  -xvf  解压 
2 、*.gz  用  gzip  -d 或者 gunzip  解压 
3 、* .t a r. g z 和*.tgz 用  tar  -xzf  解压 
4 、*.bz2  用  bzip2 -d 或者用 bunzip2  解压 
5 、*.tar.bz2 用tar  -xjf  解压 
6 、*.Z  用  uncompress 解压 
7 、*.tar.Z  用tar  -xZf  解压 
8 、*.rar 用  unrar e 解压 
9 、*.zip 用  unzip  解压
    zip squash.zip file1 file2 file3
    zip -r squash.zip dir1
    unzip squash.zip
    
    tar -zcvf myfile.tgz .
    tar -zxvf myfile.tgz
}
tar_man(){
    
        使用 tar 命令只要记得参数是『必选+自选+f』即可，我们先来看看『必选!五选一』:
 1. 主操作模式：
    -c, --create               创建一个新归档
    -r, --append               追加文件至归档结尾
    -t, --list                 列出归档内容
        --test-label           测试归档卷标并退出
    -u, --update               仅追加比归档中副本更新的文件
    -x, --extract, --get       从归档中解出文件
        
    -A, --catenate, --concatenate   追加 tar 文件至归档
    -d, --diff, --compare      找出归档和文件系统的差异
        --delete               从归档(非磁带！)中删除
 2. 压缩选项:
        -z 使用 gzip 属性                  # tar -czf posts.tar.gz *.md ; tar -xzf posts.tar.gz
        -j 使用 bz2 属性                   # tar -cjf posts.tar.bz2 *.md ; tar -xjf posts.tar.bz2
        -Z 使用 compress 属性              # tar -cZf posts.tar.Z *.md ; tar -xZf posts.tar.Z
        -J：通过 xz 的支持进行压缩/解压缩  # tar -cJf posts.tar.Z *.md ; tar -xZf posts.tar.xz
        # 此时文件名最好为 *.tar.xz 特别留意， -z, -j, -J 不可以同时出现在一串指令列中
        -J, --xz                   通过 xz 过滤归档
            --lzip                 通过 lzip 过滤归档
            --lzma                 通过 xz 过滤归档
            --lzop
        -a 使用归档后缀名来决定压缩程序    # tar acvf archive.tar.gz file1 file2, 自动选择格式压缩
        -v 意为 verbose，显示详细的操作过程
        -O 将文件输出到标准输出
   3. 本地文件选择:
      --add-file=FILE        添加指定的 FILE 至归档(如果名字以 - 开始会很有用的)
      --backup[=CONTROL]     在删除前备份，选择 CONTROL 版本
  -C, --directory=DIR        改变至目录 DIR
  -h, --dereference          跟踪符号链接；将它们所指向的文件归档并输出
  -K, --starting-file=MEMBER-NAME 从归档中的 MEMBER-NAME 成员处开始
  -N, --newer=DATE-OR-FILE, --after-date=DATE-OR-FILE  只保存比 DATE-OR-FILE 更新的文件
  -P, --absolute-names       不要从文件名中清除引导符'/'
  -T, --files-from=FILE      从 FILE 中获取文件名来解压或创建文件
  -X, --exclude-from=FILE    排除 FILE 中列出的模式串
         
        *.tar -> tar -xf
        *.tar.gz -> tar -xzf
        *.tar.bz2 -> tar -xjf
        *.tar.Z -> tar -xZf
        *.gz -> gzip -d
        *.rar -> unrar e
        *.zip -> unzip
        
gzip aaa.tar            使用gzip压缩aaa.tar
gunzip aaa.tar.gz       解压aaa.tar.gz
bzip2 bbb.tar           使用bzip2压缩bbb.tar
bunzip2 bbb.tar.bz2     解压bbb.tar.gz
        
tar -cf output.tar file1 file2 file3 # 创建
tar -tf output.tar                   # 列出
tar -rvf original.tar newfile        # 向归档文件中添加一个文件
tar -Af file1.tar file2.tar          # 合并两个归档文件
tar -uf archive.tar file1            # 仅当file1比归档文档中的file新时喜爱进行追加
tar -df archive.tar                  # 比较归档文件和文件系统中的内容
tar -f archive.tar --delete file1 file2 或 tar --delete --file archive.tar file1 file2
tar -cf arch.tar * --exclude "*.txt"
tar -cf arch.tar * -X list list # 包含要排除的文件列表
tar --exclude-vcs -czvvf sourcecode.tar.gz mysvn # 在归档时排除版本控制相关的文件和目录

        tar zxvpf gz.tar.gz -C 放到指定目录 包中的目录       # 解包tar.gz 不指定目录则全解压
        tar zcvpf /$path/gz.tar.gz * # 打包gz 注意*最好用相对路径
        tar zcf /$path/gz.tar.gz *   # 打包正确不提示
        tar ztvpf gz.tar.gz          # 查看gz
        tar xvf 1.tar -C 目录        # 解包tar
        tar -cvf 1.tar *             # 打包tar
        tar tvf 1.tar                # 查看tar
        tar -rvf 1.tar 文件名        # 给tar追加文件
        tar --exclude=/home/dmtsai --exclude=*.tar -zcvf myfile.tar.gz /home/* /etc      # 打包/home, /etc ，但排除 /home/dmtsai
        tar -N "2005/06/01" -zcvf home.tar.gz /home      # 在 /home 当中，比 2005/06/01 新的文件才备份
        tar -zcvfh home.tar.gz /home                     # 打包目录中包括连接目录
        tar zcf - ./ | ssh root@IP "tar zxf - -C /xxxx"  # 一边压缩一边解压
        # 命令: bzip2, bzcat/bzmore/bzless/bzgrep
        # 命令: xzless，zless
        zgrep 字符 1.gz              # 查看压缩包中文件字符行
        bzip2  -dv 1.tar.bz2         # 解压bzip2
        bzip2 -v 1.tar               # bzip2压缩
        bzcat                        # 查看bzip2
        #  compress, zip 与 gzip ; 至于 gzip 所创建的压缩文件为 *.gz 的文件名.
        # gzip, zcat/zmore/zless/zgrep
        gzip A                       # 直接压缩文件 # 压缩后源文件消失
        gunzip A.gz                  # 直接解压文件 # 解压后源文件消失
        gzip -dv 1.tar.gz            # 解压gzip到tar
        gzip -v 1.tar                # 压缩tar到gz
        unzip zip.zip                # 解压zip
        zip zip.zip *                # 压缩zip
        # rar3.6下载:  http://www.rarsoft.com/rar/rarlinux-3.6.0.tar.gz
        rar a rar.rar *.jpg          # 压缩文件为rar包
        unrar x rar.rar              # 解压rar包
        7z a 7z.7z *                 # 7z压缩
        7z e 7z.7z                   # 7z解压
        
bzip2 : 管理".bz2"格式的压缩文件
bunzip2 : 解压缩".bz2"格式的压缩文件
bzcat : 显示".bz2"格式的压缩文件内容
bzip2 压缩率高于 gzip, 支持保留源文件
    -c : 将压缩的资料输出到屏幕(实测报错) 
    -d : 解压缩 
    -k : 保留源文件压缩 
    -v : 显示压缩比等信息 
    -# : 同 gzip (实测小文件看不出对比效果)

gzip : 管理".gz"格式的压缩文件
gunzip : 解压缩".gz"格式的文件
gzip 可以打开compress/zip/gzip 等软件压缩的文档, gzip 压缩的文件后缀为 .gz,压缩后会将源文件删除
    -c : 将压缩的资料输出到屏幕(实测一堆乱码)
    -d : 解压缩
    -t : 检验压缩文件的一致性(用于判断文件是否有误
    -v : 显示压缩比等信息
    -# : # 表示数字,设置压缩等级, 1 最快,压缩比最差, 9 最慢,压缩比最好, 默认为 6
 
zip : 管理".zip"格式的压缩文件
unzip : 解压缩".zip"格式的文件
zcat : 显示".zip"格式的压缩文件内容

xz [option] file-name : xz 解/压缩 
    -c : 将压缩的资料输出到屏幕 
    -d : 解压缩 
    -k : 保留源文件压缩 
    -l : 列出压缩文件的而相关信息 
    -v : 显示压缩比等信息 
    -# : 同 gzip (实测小文件看不出对比效果)
    }
q_extract_func() { tar|bunzip2|rar|gunzip|uncompress
    if [ -f $1 ] ; then
        case $1 in
        *.tar.bz2)   tar -xvjf $1    ;;
        *.tar.gz)    tar -xvzf $1    ;;
        *.tar.xz)    tar -xvJf $1    ;;
        *.bz2)       bunzip2 $1     ;;
        *.rar)       rar x $1       ;;
        *.gz)        gunzip $1      ;;
        *.tar)       tar -xvf $1     ;;
        *.tbz2)      tar -xvjf $1    ;;
        *.tgz)       tar -xvzf $1    ;;
        *.zip)       unzip $1       ;;
        *.Z)         uncompress $1  ;;
        *.7z)        7z x $1        ;;
        *)           echo "don't know how to extract '$1'..." ;;
        esac
    else
        echo "'$1' is not a valid file!"
    fi
}
q_compress_func() { tar|bunzip2|rar|gunzip|uncompress
    if [ -n "$1" ] ; then
        FILE=$1
        case $FILE in
        *.tar) shift && tar -cf $FILE $* ;;
        *.tar.bz2) shift && tar -cjf $FILE $* ;;
        *.tar.xz) shift && tar -cJf $FILE $* ;;
        *.tar.gz) shift && tar -czf $FILE $* ;;
        *.tgz) shift && tar -czf $FILE $* ;;
        *.zip) shift && zip $FILE $* ;;
        *.rar) shift && rar $FILE $* ;;
        esac
    else
        echo "usage: q-compress <foo.tar.gz> ./foo ./bar"
    fi
}

svn_update(){
        --force # 强制覆盖
        /usr/bin/svn --username user --password passwd co  $Code  ${SvnPath}src/                 # 检出整个项目
        /usr/bin/svn --username user --password passwd up  $Code  ${SvnPath}src/                 # 更新项目
        /usr/bin/svn --username user --password passwd export  $Code$File ${SvnPath}src/$File    # 导出个别文件
        /usr/bin/svn --username user --password passwd export -r 版本号 svn路径 本地路径 --force # 导出指定版本

    }
android stars:>10:
android in:file           按照文件搜索      
android in:path           按照路径检索      
android language:java     按照语言检索      
android size:>100         按照文件大小      
android extention:css     按照后缀名检索    
android fork:true         按照是否被fork过  
android location:beijing  按照地域检索      
https://github.com/search/advanced

git_man(){

    git clone git@10.10.10.10:gittest.git  ./gittest/  # 克隆项目到指定目录
    git clone  -b develop --depth=1 http://git.a.com/d.git   # 克隆指定分支 克隆一层
    git status                                         # Show the working tree(工作树) status
    git log -n 1 --stat                                # 查看最后一次日志文件
    git branch -a                                      # 列出远程跟踪分支(remote-tracking branches)和本地分支
    git checkout developing                            # 切换到developing分支
    git checkout -b release                            # 切换分支没有从当前分支创建
    git checkout -b release origin/master              # 从远程分支创建本地镜像分支
    git push origin --delete release                   # 从远端删除分区，服务端有可能设置保护不允许删除
    git push origin release                            # 把本地分支提交到远程
    git pull                                           # 更新项目 需要cd到项目目录中
    git fetch -f -p                                    # 抓取远端代码但不合并到当前
    git reset --hard origin/master                     # 和远端同步分支
    git add .                                          # 更新所有文件
    git commit -m "gittest up"                         # 提交操作并添加备注
    git push                                           # 正式提交到远程git服务器
    git push [-u origin master]                        # 正式提交到远程git服务器(master分支)
    git tag [-a] dev-v-0.11.54 [-m 'fix #67']          # 创建tag,名为dev-v-0.11.54,备注fix #67
    git tag -l dev-v-0.11.54                           # 查看tag(dev-v-0.11.5)
    git push origin --tags                             # 提交tag
    git reset --hard                                   # 本地恢复整个项目
    git rm -r -n --cached  ./img                       # -n执行命令时,不会删除任何文件,而是展示此命令要删除的文件列表预览
    git rm -r --cached  ./img                          # 执行删除命令 需要commit和push让远程生效
    git init --bare smc-content-check.git              # 初始化新git项目  需要手动创建此目录并给git用户权限 chown -R git:git smc-content-check.git
    git config --global credential.helper store        # 记住密码
    git config [--global] user.name "your name"        # 设置你的用户名, 希望在一个特定的项目中使用不同的用户或e-mail地址, 不要--global选项
    git config [--global] user.email "your email"      # 设置你的e-mail地址, 每次Git提交都会使用该信息
    git config [--global] user.name                    # 查看用户名
    git config [--global] user.email                   # 查看用户e-mail
    git config --global --edit                         # 编辑~/.gitconfig(User-specific)配置文件, 值优先级高于/etc/gitconfig(System-wide)
    git config --edit                                  # 编辑.git/config(Repository specific)配置文件, 值优先级高于~/.gitconfig
    git cherry-pick  <commit id>                       # 用于把另一个本地分支的commit修改应用到当前分支 需要push到远程
    git log --pretty=format:'%h: %s' 9378b62..HEAD     # 查看指定范围更新操作 commit id
    git config --global core.ignorecase false          # 设置全局大小写敏感
    git ls-remote --heads origin refs/heads/test # 查看

        从远端拉一份新的{
            # You have not concluded your merge (MERGE_HEAD exists)  git拉取失败
            git fetch --hard origin/master
            git reset --hard origin/master
        }

        删除远程分支并新建{
            git checkout master
            git branch -r -d origin/test       # 删除远程分支  但有时候并没有删除 可以尝试使用下面的语句
            git push origin :test              # 推送一个空分支到远程分支，相当于删除远程分支
            git branch -d test                 # 删除本地test分支, -D 强制
            git branch -a |grep test
            git checkout -b test
            git push origin test

            git reset --hard origin/test 
        }

        迁移git项目{
            git branch -r | grep -v '\->' | while read remote; do git branch --track "${remote#origin/}" "$remote"; done
            git fetch --all
            git pull --all
            git remote set-url origin git@git.github.cn:server/gw.git
            git push --all
}


git_intro(){
1. 创建新的仓库
创建一个名为hello的目录，作为仓库目录
    cd hello
    git init
2. git设置
user.name 用户名
    git config -global user.name 'John Doe'
user.email电子邮件
    git config -global user.email johndoe@example.com
3. 将文件添加到仓库中
新建一个hello.c文件， 提交到仓库中
    git add hello.c
    git commit -m "Inital Commit"
3.1 修改并提交文件
    git commit -a
另外，上述命令原来是用来提交Git所管理的所有文件，一次也没有执行git add命令的文件不会提交。
4. 确认工作区状态
    git status
要查看哪些文件在Git的管理范围内，使用：
    git ls-files
显示缓冲区(staging area)与工作区的差别
    git diff
显示最新提交与工作区的差别
    git diff HEAD
显示最新提交与缓存区的差别
    git diff -cached
5. 查看提交记录
    git log
上述命令可以提供查看范围，用提交的Hash值表示
    git log 查看到提交散列值为止
    git log .. 从之后到最新的提交为止
    git log .. 从之后到提交为止
查看指定文件的提交记录
    git log 文件名
    git log -p 文件名， 以段落的形式显示出来
    查看文件中每行的修改记录
    git blame 文件名
    git show commit_id 文件名
6. 修改提交
取消当前仓库最新的提交：
    git revert HEAD
修改某个提交说明
    git commit - -amend
取消提交，但是工作区源代码保持原状
    git reset - -soft HEAD~1
取消提交，将工作区也恢复到相应的状态
    git reset - -hard HEAD
7. 为提交打标签
    git tag tag_name
查看标签列表
    git tag -l
8. 创建分支
以标签ver1的提交为起点，创建名为vert1x的分支：
    git branch ver1x ver1
显示创建分支列表
    git branch
切换分支
    git checkout ver1x (ps:加-b，则当分支不存在时，会自动创建一个分支)
8.1 rebase
    git rebase master
将ver1x分支的起点移到master分支的最新提交中。
因发生冲突而中断的rebase操作，可以在消除冲突后，再执行git rebase -continue
9. 合并分支
    git merge ver1x
通过git status查看是否有冲突，并做修改，提交。
10. 提取补丁
从版本1到版本2的各次提交的差别提取补丁文件：
    git format-patch ver1..ver2
11. 提取源码树
    git archive -format=tar -prefix='hello-v2' ver2 > hello-v2.tar
12. 复制仓库
    git clone
13. 追踪分支
查看追踪分支的列表:
    git branch -r
        origin/HEAD -> origin/master
        origin/master
        origin/ver1x
14. 查看远程分支信息
    git remote show
    git remote show origin
15. 添加远程仓库
    git remote add pb git://test.git
16. 与远程仓库同步
    git pull
    git fetch (不会与本地分支合并)
17. 推送本地修改到远程分支
    git push csdn master
18. 设置代理
    git config -global http.proxy '127.0.0.1:8087'
19. 解决SSL证书失败问题
    git config -global http.sslVerify false
20. 检出指定分支上的某个文件
    git checkout master flash/foo.fla
21. 删除误加入暂存区的文件
    git rm -r -cached superlists/*.pyc
        }
    }
drop_caches_func(){
To free pagecache:
echo 1 > /proc/sys/vm/drop_caches #清理缓存文件
To free dentries and inodes:
echo 2 > /proc/sys/vm/drop_caches #清理缓存文件的元数据
To free pagecache, dentries and inodes: 
echo 3 > /proc/sys/vm/drop_caches #清理上面的两者

    Linux内核的策略是最大程度的利用内存cache 文件系统的数据，提高IO速度，虽然在机制上是有进程需要
更大的内存时，会自动释放Page Cache, 但不排除释放不及时或者释放的内存由于存在碎片不满足进程的内存需求。

    可以通过命令 echo 3 > /proc/sys/vm/drop_caches来手动执行以释放Page Cache， 但是有时仍然发现
释放的内存不够，这是因为Linux 提供了这样一个参数min_free_kbytes，用来确定系统开始回收内存的阀值，值越高， 
free memory也越高，如：echo 10240 > /proc/sys/vm/min_free_kbytes， 就会确保Free Memory有100M。
}

storage_restore(){
恢复rm删除的文件
        # debugfs针对 ext2   # ext3grep针对 ext3   # extundelete针对 ext4
        df -T   # 首先查看磁盘分区格式
        umount /data/     # 卸载挂载,数据丢失请首先卸载挂载,或重新挂载只读
        ext3grep /dev/sdb1 --ls --inode 2         # 记录信息继续查找目录下文件inode信息
        ext3grep /dev/sdb1 --ls --inode 131081    # 此处是inode
        ext3grep /dev/sdb1 --restore-inode 49153  # 记录下inode信息开始恢复目录

}
    
genRandomText_func() { tr -cd '[:alpha:]' < /dev/urandom | head -c "$1"; }
    urandom(自动生成高强度密码){
    < /dev/urandom tr -dc A-Za-z0-9 | head -c 14; echo
    }
    pwgen(自动生成高强度密码){
    pwgen 14 1
    }
    openssl(加密解密){

        openssl rand 15 -base64            # 口令生成
        openssl sha1 filename              # 哈希算法校验文件
        openssl md5 filename               # MD5校验文件
        openssl base64   filename.txt      # base64编码/解码文件(发送邮件附件之类功能会可以使用)
        openssl base64 -d   filename.bin   # base64编码/解码二进制文件
        openssl enc -aes-128-cbc   filename.aes-128-cbc                  # 加密文档
        # 推荐使用的加密算法是bf(Blowfish)和-aes-128-cbc(运行在CBC模式的128位密匙AES加密算法)，加密强度有保障
        openssl enc -d -aes-128-cbc -in filename.aes-128-cbc > filename  # 解密文档

        # 随机8位字符串和数字
        echo $RANDOM |　md5sum | cut -c 1-8
        openssl rand -base64 4
        cat /proc/sys/kernel/random/uuid | cut -c 1-8
        # 随机8位数字
        echo $RANDOM | cksum | cut -c 1-8
        openssl rand -base64 4 | cksum | cut -c 1-8
        date +%N | cut -c 1-8
        cksum：打印CRC效验和统计字节
        
        # 用Linux命令行生成随机密码的十种方法
        date | md5sum
        date +%s | sha256sum | base64 | head -c 32 ; echo
        < /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c${1:-32};echo;
        tr -cd '[:alnum:]' < /dev/urandom | fold -w30 | head -n1
        strings /dev/urandom | grep -o '[[:alnum:]]' | head -n 30 | tr -d 'n'; echo
        < /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c6
        dd if=/dev/urandom bs=1 count=32 2>/dev/null | base64 -w 0 | rev | cut -b 2- | rev
        randpw(){ < /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c${1:-16};echo;}
# UUID      
uuidgen
c58ecaa3-283b-4b8e-a038-2e42c216ae4d
cat /proc/sys/kernel/random/uuid
3972f570-735c-4711-8908-e4a2422af80e
    }
}

gpg -c file   # 加密
gpg file.gpg  # 解密
https://www.gnupg.org/howtos/zh/index.html
http://www.ruanyifeng.com/blog/2013/07/gpg.html
gpg(){ 
GnuPG 或 GNU Privacy Guard
GPG有许多用途，本文主要介绍文件加密。至于邮件的加密，不同的邮件客户端有不同的设置，
sudo apt-get install gnupg
yum install gnupg

1. 生成密钥
gpg --gen-key
1.1 选择您要使用的密钥种类
# (1) RSA and RSA (default)    加密和签名都使用RSA算法
# (2) DSA and Elgamal
# (3) DSA (仅用于签名)　
# (4) RSA (仅用于签名)
1.2 密钥的长度
RSA 密钥长度应在 1024 位与 4096 位之间。
　　您想要用多大的密钥尺寸？(2048)
1.3 密钥的有效期
请设定这把密钥的有效期限。
　　　0 = 密钥永不过期
　　　<n> = 密钥在 n 天后过期
　　　<n>w = 密钥在 n 周后过期
　　　<n>m = 密钥在 n 月后过期
　　　<n>y = 密钥在 n 年后过期
　　密钥的有效期限是？(0)
1.4 提供个人信息
"Heinrich Heine (Der Dichter) <heinrichh@duesseldorf.de>"
　　真实姓名：
　　电子邮件地址：
　　注释：
更改姓名(N)、注释(C)、电子邮件地址(E)或确定(O)/退出(Q)？
输入O表示"确定"。

1.5 您需要一个密码来保护您的私钥：
gpg: 密钥 EDDD6D76 被标记为绝对信任
    　　公钥和私钥已经生成并经签名。
请注意上面的字符串"EDDD6D76"，这是"用户ID"的Hash字符串，可以用来替代"用户ID"。
最好再生成一张"撤销证书"，以备以后密钥作废时，可以请求外部的公钥服务器撤销你的公钥。
    gpg --gen-revoke [用户ID]
    
2. 列出密钥
list-keys参数列出系统中已有的密钥．
    gpg --list-keys
显示结果如下：
    /home/ruanyf/.gnupg/pubring.gpg
    -------------------------------
    pub 4096R/EDDD6D76 2013-07-11
    uid Ruan YiFeng <yifeng.ruan@gmail.com>
    sub 4096R/3FA69BE4 2013-07-11
第一行显示公钥文件名(pubring.gpg)，
第二行显示公钥特征(4096位，Hash字符串和生成时间)，
第三行显示"用户ID"，
第四行显示私钥特征。
如果你要从密钥列表中删除某个密钥，可以使用delete-key参数。
    gpg --delete-key [用户ID]
    
3. 输出密钥
公钥文件(.gnupg/pubring.gpg)以二进制形式储存，armor参数可以将其转换为ASCII码显示。
    gpg --armor --output public-key.txt --export [用户ID]
"用户ID"指定哪个用户的公钥，output参数指定输出文件名(public-key.txt)。
类似地，export-secret-keys参数可以转换私钥。
    gpg --armor --output private-key.txt --export-secret-keys

4. 上传公钥
公钥服务器是网络上专门储存用户公钥的服务器。send-keys参数可以将公钥上传到服务器。
    gpg --send-keys [用户ID] --keyserver hkp://subkeys.pgp.net
    
由于公钥服务器没有检查机制，任何人都可以用你的名义上传公钥，所以没有办法保证服务器
上的公钥的可靠性。通常，你可以在网站上公布一个公钥指纹，让其他人核对下载到的公钥是
否为真。fingerprint参数生成公钥指纹。
    gpg --fingerprint [用户ID]
5. 输入密钥
除了生成自己的密钥，还需要将他人的公钥或者你的其他密钥输入系统。这时可以使用import参数。
    gpg --import [密钥文件]
为了获得他人的公钥，可以让对方直接发给你，或者到公钥服务器上寻找。
    gpg --keyserver hkp://subkeys.pgp.net --search-keys [用户ID]

6 加解密
6.1 加密
假定有一个文本文件demo.txt，怎样对它加密呢？
encrypt参数用于加密。
    gpg --recipient [用户ID] --output demo.en.txt --encrypt demo.txt
recipient参数指定接收者的公钥，output参数指定加密后的文件名，encrypt参数指定源文件。
运行上面的命令后，demo.en.txt就是已加密的文件，可以把它发给对方。

6.2 解密
对方收到加密文件以后，就用自己的私钥解密。
    gpg --decrypt demo.en.txt --output demo.de.txt
decrypt参数指定需要解密的文件，output参数指定解密后生成的文件。运行上面的命令，demo.de.txt就是解密后的文件。
GPG允许省略decrypt参数。
    gpg demo.en.txt
运行上面的命令以后，解密后的文件内容直接显示在标准输出。

7. 对文件签名
有时，我们不需要加密文件，只需要对文件签名，表示这个文件确实是我本人发出的。sign参数用来签名。
    gpg --sign demo.txt
    运行上面的命令后，当前目录下生成demo.txt.gpg文件，这就是签名后的文件。这个文件默认采用二进制储存，
如果想生成ASCII码的签名文件，可以使用clearsign参数。
    gpg --clearsign demo.txt
运行上面的命令后 ，当前目录下生成demo.txt.asc文件，后缀名asc表示该文件是ASCII码形式的。

如果想生成单独的签名文件，与文件内容分开存放，可以使用detach-sign参数。
    gpg --detach-sign demo.txt
运行上面的命令后，当前目录下生成一个单独的签名文件demo.txt.sig。该文件是二进制形式的，如果想采用ASCII码形式，要加上armor参数。
    gpg --armor --detach-sign demo.txt

8. 签名+加密
上一节的参数，都是只签名不加密。如果想同时签名和加密，可以使用下面的命令。
    gpg --local-user [发信者ID] --recipient [接收者ID] --armor --sign --encrypt demo.txt
local-user参数指定用发信者的私钥签名，
recipient参数指定用接收者的公钥加密，
armor参数表示采用ASCII码形式显示，
sign参数表示需要签名，
encrypt参数表示指定源文件。

9. 验证签名
我们收到别人签名后的文件，需要用对方的公钥验证签名是否为真。verify参数用来验证。
    gpg --verify demo.txt.asc demo.txt

}
mkfifo_demo(){ 
用于进程通信和终端之间通信
mkfifo fifo_test    #通过mkfifo命令创建一个有名管道
echo "fewfefe" > fifo_test
#试图往fifo_test文件中写入内容，但是被阻塞，要另开一个终端继续下面的操作
cat fifo_test        #另开一个终端，记得，另开一个。试图读出fifo_test的内容
fewfefe

mkfifo myPipe
ls -l > myPipe
grep ".log" < myPipe

ls -l /tmp > myPipe &
cat < myPipe

1. Output: Prints ls -l data and then prints file3 contents on screen
$ { ls -l && cat file3; } >mypipe &
$ cat <mypipe    

2. Output: This prints on screen the contents of mypipe.
$ ls -l >mypipe &
$ cat file3 >mypipe &
$ cat <mypipe

3. Output: Prints the output of ls directly on screen
$ { pipedata=$(<mypipe) && echo "$pipedata"; } &
$ ls >mypipe

4. Output : Prints correctly the contents of mypipe
$ export pipedata
$ pipedata=$(<mypipe) &
$ ls -l *.sh >mypipe
$ echo "$pipedata"  
}
software(rpm){

    rpm_demo(){
        rpm -ivh lynx.rpm   # rpm安装
        rpm -ivh --nodeeps lynx.rpm   #安装一个rpm包而忽略依赖关系警告
        rpm -e lynx            # 卸载包
        rpm -e lynx --nodeps   # 强制卸载
        rpm -qa                # 查看所有安装的rpm包
        rpm -qlp package       # 查询 RPM 包中包含的文件列表命令
        rpm -qip package       # 查询 RPM 包中包含的内容信息命令
        rpm -qa                # 查询系统中所有已安装 RPM 包
        rpm -qa | grep lynx    # 查找包是否安装
        rpm -ql                # 软件包路径
        rpm -Uvh               # 升级包
        rpm -U package.rpm        #更新一个rpm包但不改变其配置文件
        rpm --test lynx        # 测试
        rpm -qc                # 软件包配置文档
        rpm --import  /etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-6     # 导入rpm的签名信息
        rpm --initdb           # 初始化rpm 数据库
        rpm --rebuilddb        # 重建rpm数据库  在rpm和yum无响应的情况使用 先 rm -f /var/lib/rpm/__db.00* 在重建
        
        rpm -i --relocate /usr/bin=/home/easwy/bin --relocate /usr/share/doc=/home/easwy/doc ext3grep-0.10.0-1.el5.rf.i386.rpm
        
        rpm2cpio hadoop.rpm | cpio -idmv    #查看rpm包文件
        # 查询系统已安装
        rpm -q gaim                 查询系统已安装的软件
        rpm -qf /usr/lib/libacl.la  查询一个已经安装的文件属于哪个软件包
        rpm -ql  软件名             查询已安装软件包都安装到何处
        rpm  -qi 软件名             软件名 
        rpm  -qc 软件名             查看一下已安装软件的配置文件；
        rpm  -qd 软件名             查看一个已经安装软件的文档安装位置：
        rpm  -qR 软件名             查看一下已安装软件所依赖的软件包及文件
        
        # 查询系统未安装
        rpm -qpi file.rpm   查看一个软件包的用途、版本等信息；
        rpm -qpl  file.rpm  查看一件软件包所包含的文件
        rpm -qpc  lynx-2.8.5-23.i386.rpm   查看一个软件包的配置文件
        rpm  -qpR  file.rpm  查看一个软件包的依赖关系   

        # RPM 验证与数字证书： 
        rpm --import 签名文件 举例：  
        rpm --import RPM -GPG-KEY 
        rpm --import RPM -GPG-KEY-fedora
        RPM 验证作用是使用/var/lib/rpm 下面的数据库内容来比较目前 linux 系统的环境下的所有软件文件，也就
是说当你有数据不小心丢失，或者不小心修改到某个软件的文件内容，就用这个简单的方法验证一下原本的
文件系统 
#rpm -Va    列出目前系统上面所有可能被改动过的文件 


    rpm2cpio file.rpm |cpio  -div # 从rpm 软件包抽取文件
    }

system_rpm_yum(){
1. 主二进制文件
2. 配置文件 
2.1 当文件配置               # mysql mysqld mysqladmin
2.2 将主配置文件划分为多个，存放在多个目录中   # /etc/yum.conf /etc/yum.d/*
2.3 单文件在内部划分多个片断 # [mysql] [mysqld]
3. 库文件   静态库                 动态库
4. 帮助文件 手册页(/usr/share/man) 文档(/usr/share/doc)
---------------------------------------
1. 二进制文件 /bin /sbin /usr/bin /usr/sbin/ /usr/local/bin /usr/local/sbin/ 
2. 库文件     /lib /usr/lib  # /etc/ld.so.conf    /etc/ld.so.conf.d/*.conf
3. 配置文件   /etc/ /etc/httpd /usr/local/etc
4. 帮助文件   /usr/share/man(/etc/man.conf)  /usr/share/doc
5. 头文件     /usr/include
--------------------------------------- rpm包组成
1. 主 rpm 包      # name-version-release.arch.rpm
2. 子 rpm 包      # name-subname-version.rpm
3. 库文件和头文件 # name-devel-version.rpm
--------------------------------------- rpm包命名格式
1. version  # major主(整体架构更新主版本号) minor次(增加新功能会更新次版本号) release发行(用于更新bug信息)
2. release  # 软件包制作成发行包的版本号
3. arch架构 # i386 i486 i586 i686 X86_64 noarch
4. 平台号   # el5 redhat5 el6 redhat6
--------------------------------------- rpm安装内容
1. 要执行的脚本 pre安装前执行的脚本 post安装后执行的脚本  preun卸载前执行的脚本 postun卸载后执行的脚本
2. rpm -i /PATH/TO/PACKAGE  # -h 显示进度 -v 详细过程 -vv 更详细的过程
3. rpm -e PACKAGENAME
4. rpm -Uvh /PATH/TO/PACKAGE  # 如果装有老版本的，则升级；否则，则安装
   rpm -Fvh /PATH/TO/PACKAGE  # 如果装有老版本的，则升级；否则，则退出
5. /var/lib/rpm # 数据库
   rpm  --rebuilddb  # 重建数据库，一定会重新建立
   rpm  --initdb     # 初始化数据库，如果没有则建立，如果有则不建立
---------------------------------------yum组成
primary.xml.gz  # 所有RPM包的列表；依赖关系列表；每个RPM安装生成的文件列表
filelist.xml.gz # 当前仓库中所有的RPM包的所有文件信息
other.xml.gz    # 额外信息，RPM包的修改日志
repond.xml      # 记录上面三个文件的时间戳和校验和
}
    yum(软件安装){

        yum list                 # 所有软件列表
        yum list all             # 列出仓库中所有的软件包 
        yum install 包名         # 安装包和依赖包
        yum -y update            # 升级所有包版本,依赖关系，系统版本内核都升级
        yum -y update 软件包名   # 升级指定的软件包
        yum -y upgrade           # 不改变软件设置更新软件，系统版本升级，内核不改变
        yum search mail          # yum搜索相关包
        yum grouplist            # 软件包组
        yum -y groupinstall "Virtualization"   # 安装软件包组
        repoquery -ql gstreamer  # 不安装软件查看包含文件
        yum clean all            # 清除var下缓存
        
        yum repolist            #列出可用的仓库 
        yum repolist all        #列出所有仓库
        yum make cache          #缓存远程仓库缓存信息
        
        yum clean all           #情况YUM缓存
        yum history
    }

    yum(yum使用epel源){

        # 包下载地址: http://download.fedoraproject.org/pub/epel   # 选择版本5\6\7
        rpm -Uvh  http://mirrors.hustunique.com/epel//6/x86_64/epel-release-6-8.noarch.rpm

        # 自适配版本
        yum install epel-release

    }

    yum(自定义yum源){

        find /etc/yum.repos.d -name "*.repo" -exec mv {} {}.bak \;

        vim /etc/yum.repos.d/yum.repo
        [yum]
        #http
        baseurl=http://10.0.0.1/centos5.5
        #挂载iso
        #mount -o loop CentOS-5.8-x86_64-bin-DVD-1of2.iso /data/iso/
        #本地
        #baseurl=file:///data/iso/
        enable=1

        #导入key
        rpm --import  /etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-5
        
        []      []中填写YUM源唯一的ID，可以为任意字符串
        name    指定yum源名称,可以为任意字符串
        baseurl 指定YUM源的URL地址(可以是HTTP、FTP、本地地址)
        mirrorlist 指定镜像站点目录
        enabled 是否激活该YUM源(0代表禁止、1代表激活，默认是激活)
        gpgcheck 安装软件时是否检查签名(0代表禁止，1代表激活)
        gpgkey   检查签名的密钥文件
        
        releasever    代表系统发行版本号               CentOS release 6.5 (Final)   CentOS release 6.3 (Final)
        arch          代表CPU架构                      x86_64   i686   unknown
        basearch      代表系统架构                     x86_64   i686   armv7l
        YUM0-9        使用Shell对应的0-9个同名变量替换
        uname -r -v -m -n -o # 内核的发行信息,内核版本、机器硬件名称、网络节点、主机名和操作系统
        -s, --kernel-name
        -n, --nodename
        -r, --kernel-release
        -v, --kernel-version
        -m, --machine
        -p, --processor
        -i, --hardware-platform
        -o, --operating-system
        cat /etc/redhat-release
    }
    
    yum(downloadonly)
    {
        yum install yum-plugin-downloadonly              #安装工具
        yum install --downloadonly <package-name>        #下载package-name类型rpm包
        #默认情况下/var/cache/yum/的rhel-{arch}-channel/packageslocation目录里面
        
        yum install --downloadonly --downloaddir=<directory> <package-name> 
        yum install --downloadonly --downloaddir=/root/mypackages httpd 
        yum install --downloadonly --downloaddir=/root/mypackages httpd-2.2.6-40.e17
        yum install --downloadonly --downloaddir=/root/mypackages httpd vsftpd
        
        yum install yum-utils
        yumdownloader httpd
        yumdownloader --resolve httpd #下载到当前工作目录
        yumdownloader --resolve --destdir=/root/mypackages/ httpd #下载到当前工作目录
        yumdownloader --resolve "@Deevelopment Tools"  --destdir=/root/mypackages/ #下载到当前工作目录
        
    }    
    compile(编译){

gcc -m32 -o hello hello.c
gcc -m32 -c hello.o hello.c
ld -m elf_i386 -o kernel main.o hello.o
    
        configure()
        {
            #!/bin/sh
            LIBTOOLIZE=libtoolize
            SYSNAME=$(uname)
            if [ "x$SYSNAME" = "xDarwin" ] ; then
            LIBTOOLIZE=glibtoolize
            fi
            aclocal && \
                autoheader && \
                $LIBTOOLIZE && \
                autoconf && \
                automake --add-missing --copy
        }
        compile(源码安装){  PKG_CONFIG_PATH=/usr/local/lib/pkgconfig # 
            ./configure --help                   # 查看所有编译参数
            ./configure  --prefix=/usr/local/    # 配置参数
            make                                 # 编译
            # make -j 8                          # 多线程编译,速度较快,但有些软件不支持
            make install                         # 安装包
            make clean                           # 清除编译结果
            
            make VERBOSE=1                       # 详细信息
# 编译内核相关的一些命令
make deb-pkg # 生成Deb源码包
make -C /lib/modules/ PWD # 在源码树外编译模块
make -C /lib/modules/ PWD modules_install # 在源码树外安装砌块
make ARCH=arm CROSS_COMPILE=armv5tel-linux- uImage # 编译Arm平台镜像文件
make ARCH=arm CROSS_COMPILE=armv5tel-linux- modules # 编译Arm平台模块
make ARCH=arm CROSS_COMPILE=armv5tel-linux- INSTALL_MOD_PATH=~/armroot-2.6.38 modules_install # 指定模块安装存放路径
        }

        compile(perl程序编译){
            perl Makefile.PL
            make
            make test
            make install
        }

        compile(python程序编译){
            python file.py

            # 源码包编译安装
            python setup.py build
            python setup.py install
        }

        compile(编译c程序){
            gcc -g hello.c -o hello
        }
    }
}
python(){
cat index.json | python -mjson.tool > index1.json
}

ubuntu: 192.168.10.80 
ubuntu 666666
/home/android4.4/android4.4/android_release/prebuilts/gcc/linux-x86/arm/arm-linux-androideabi-4.6/bin/arm-linux-androideabi-gcc

adb connect 172.181.9.201:5566
adb shell

rtu http://192.168.10.16:8080/FiberSystem/loginSystem.do# admin:123
candao(){
http://192.168.27.76:10000/zentao/my/
http://192.168.27.76:10000/zentao
禅道系统登录密码
# wangfl
# ld123456
ubuntu操作系统登录密码
# zentao
# 123456
}

web(){
192.168.10.103
root
leidi123@abc
}

wangchaofeng(){
192.168.10.200
devcu
devcu001
}

kaizhuang(){
192.168.10.81:8080/fibersystem
user:admin
password:123

192.168.10.81
user:administrator
password:abc@123
}
system_common(){
    wall        　  　          # 给其它用户发消息
    whereis ls                  # 用来找一条命令的二进制文件、源和手册的所在的路径
    which                       # 查看当前要执行的命令所在的路径
    clear                       # 清空整个屏幕
    reset                       # 重新初始化屏幕
    cal                         # 显示月历
    echo -n 123456 | md5sum     # md5加密
    mkpasswd                    # 随机生成密码   -l位数 -C大小 -c小写 -d数字 -s特殊字符
    netstat -ntupl | grep port  # 是否打开了某个端口
    ntpdate cn.pool.ntp.org     # 同步时间, pool.ntp.org: public ntp time server for everyone(http://www.pool.ntp.org/zh/)
    # 设置时区
        ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
        sudo ntpdate cn.pool.ntp.org
    tzselect                    # 选择时区 #+8=(5 9 1 1) # (TZ='Asia/Shanghai'; export TZ)括号内写入 /etc/profile
    date -s 20161115
    date -s 08:45:00
    /etc/shadow                 # 账户影子文件
    LANG=en                     # 修改语言
    vim /etc/sysconfig/i18n     # 修改编码  LANG="en_US.UTF-8"
    export LC_ALL=C             # 强制字符集
    vi /etc/hosts               # 查询静态主机名
    alias(){
1. define or create
alias name=value
alias name='command'
alias name='command arg1 arg2'
alias name='/path/to/script'
alias name='/path/to/script.pl arg1'

2. disable
## path/to/full/command
/usr/bin/clear
## call alias with a backslash ##
\c
## use /bin/ls command and avoid ls alias ##
command ls

3. delete/remove
unalias aliasname

4. permanent
~/.bashrc     # self
/etc/bashrc   # all
    }

    
    watch uptime                # 监测命令动态刷新 监视
    ipcs -a                     # 查看Linux系统当前单个共享内存段的最大值
    ldconfig                    # 动态链接库管理命令
    ldconfig -p 
    ldconfig -p | grep lib-name # 输出所有的动态链接库
    ldd `which cmd`             # 查看命令的依赖库
    dist-upgrade                # 会改变配置文件,改变旧的依赖关系，改变系统版本
    /boot/grub/grub.conf        # grub启动项配置
    ps -mfL <PID>               # 查看指定进程启动的线程 线程数受 max user processes 限制
    ps uxm |wc -l               # 查看当前用户占用的进程数 [包括线程]  max user processes
    top -p  PID -H              # 查看指定PID进程及线程
    lsof |wc -l                 # 查看当前文件句柄数使用数量  open files
    lsof |grep /lib             # 查看加载库文件
    sysctl -a                   # 查看当前所有系统内核参数
    sysctl -p                   # 修改内核参数/etc/sysctl.conf，让/etc/rc.d/rc.sysinit读取生效
    strace -p pid               # 跟踪系统调用
    ps -eo "%p %C  %z  %a"|sort -k3 -n            # 把进程按内存使用大小排序
    ps -e -o "%C : %p : %z : %a"|sort -k5 -nr     # 把进程按内存使用大小排序
    ps -e -o 'pid,comm,srgs,pcpu,rsz,vsz,stime,user,uid' | grep wdxtub | sort nrk5 # 按照内存排序，这里的 grep 可以过滤特定的用户
    ps -aux | sort -rnk 4 | head -20 # 找出当前系统内存使用量较高的进程
    ps -aux | sort -rnk 3 | head -20 # 找出当前系统CPU使用量较高的进程
    sudo apt-get install multitail   # 同时查看多个日志或数据文件
    netstat -nat | awk '{print $6}' |sort|uniq -c|sort -rn # 查看tcp连接状态
    netstat -anlp|grep 80|grep tcp|awk '{print $5}'|awk -F: '{print $1}'|sort|uniq -c|sort -nr|head -n20 # 查找80端口请求数最高的前20个IP
    ps -e -o "%C : %p : %z : %a"|sort -nr         # 按cpu利用率从大到小排列
    strace uptime 2>&1|grep open                  # 查看命令打开的相关文件
    grep Hugepagesize /proc/meminfo               # 内存分页大小
    mkpasswd -l 8  -C 2 -c 2 -d 4 -s 0            # 随机生成指定类型密码
    echo 1 > /proc/sys/net/ipv4/tcp_syncookies    # 使TCP SYN Cookie 保护生效  # "SYN Attack"是一种拒绝服务的攻击方式
    grep Swap  /proc/25151/smaps |awk '{a+=$2}END{print a}'    # 查询某pid使用的swap大小

init_script(开机启动脚本顺序){
        /etc/profile
        /etc/profile.d/*.sh
        ~/bash_profile
        ~/.bashrc
        /etc/bashrc
    }
    import(终端截图){ import -window root screenshot.png, import screenshot.png}
    initrd(){}      # http://imghch.com/doc/bootcd_initrd.html
    initramfs(){}   # http://imghch.com/doc/bootcd_initramfs.html
    process(进程管理){
1. 在命令尾处键入&把作业发送到后台
2. 也可以把正在运行的命令发送到后台运行，首先键入Ctrl+Z挂起作业(此时是挂起状态)，然后键入bg移动后台继续执行
3. bg %jobnumber 或bg %name
4. fg %jobnumber 把后台作业带到前台来
5. kill -18 pid 也是唤醒
6. kill %jobnumber 删除后台作业
7. jobs -l将PID显示 -r运行中显示 -s显示停止
8. disown %jobnumber从后台列表中移除任务，并没有终止
9. nohup command & 如果你正在运行一个进程，而且你觉得在退出帐户时该进程还不会结束，那么可以使用nohup命令。该命令可以在你退出帐户之后继续运行相应的进程。
    9.1 阻止SIGHUP信号发到这个进程。
    9.2 关闭标准输入。该进程不再能够接收任何输入，即使运行在前台。
    9.3 重定向标准输出和标准错误到文件nohup.out。

        disown
        setsid ping www.ibm.com
        (ping www.ibm.com &)
        disown  # 移出最近一个正在执行的后台任务
        disown -r   # 移出所有正在执行的后台任务
        disown -a   # 移出所有后台任务
        disown -h   # 不移出后台任务，但是让它们不会收到SIGHUP信号
        disown %2   # 根据jobId，移出指定的后台任务
        disown -h %2 # 根据jobId，移出指定的后台任务
# 使用disown命令之后，还有一个问题。那就是，退出 session 以后，如果后台进程与标准I/O有交互，它还是会挂掉。
node server.js > stdout.txt 2> stderr.txt < /dev/null &
disown
        用disown -h jobspec 来使某个作业忽略HUP信号。
        用disown -ah 来使所有的作业都忽略HUP信号。
        用disown -rh 来使正在运行的作业忽略HUP信号。
        
        用screen -dmS session name 来建立一个处于断开模式下的会话(并指定其会话名)。
        用screen -list 来列出所有会话。
        用screen -r session name 来重新连接指定会话。
        用快捷键CTRL-a d 来暂时断开当前会话。
        
        ps -eaf               # 查看所有进程
        kill -9 PID           # 强制终止某个PID进程
        kill -15 PID          # 安全退出 需程序内部处理信号
        kill -s TERM 4712                  # same as kill -15 4712
        killall -1 httpd                   # Kill HUP processes by exact name
        killall -9 sshd                    #杀死进程名称为sshd的进程，
                                           # 即把所有通过ssh登录到系统的账户登出
        pkill -9 http                      # Kill TERM processes by (part of) name
        pkill -TERM -u www                 # Kill TERM processes owned by www
        fuser -k -TERM -m /home            # Kill every process accessing /home (to umount)
        cmd &                 # 命令后台运行
        nohup cmd &           # 后台运行不受shell退出影响
        nohup ping www.ibm.com &
        ctrl+z                # 将前台放入后台(暂停)
        jobs                  # 查看后台运行程序
        bg 2                  # 启动后台暂停进程
        fg 2                  # 调回后台进程
        pstree                # 进程树 -> pstree -p
        vmstat 1 9            # 每隔一秒报告系统性能信息9次
        sar                   # 查看cpu等状态
        lsof file             # 显示打开指定文件的所有进程
        lsof /var/log/Xorg.0.log
        lsof -i:32768         # 查看端口的进程
        # renice设定正在运行的进程 nice设定将要启动进程
        renice +1 180         # 把180号进程的优先级加1 #进程优先级范围：-20至19,最高等级：-20,最低等级：19
                              # 系统管理员有权将进程优先级设置为-1至-20，而普通用户只能设置0至19。
        renice -5 586         # Stronger priority
        renice <等级> <PID>                   #调整指定PID进程的等级
        renice <等级> <用户名1> <用户名2> ... #调整指定用户的所有进程的等级
        renice <等级> -g <组名1>              #调整指定组的所有用户的所有进程的等级

        nice -n -5 top # Stronger priority (/usr/bin/nice) 
        nice -n 5 top  # Weaker priority (/usr/bin/nice) 
        nice +5 top    # tcsh builtin nice (same as above!)
         # disk 排队方式
        ionice c3 -p123 # 给 pid 123 设置为 idle 类型
        ionice -c2 -n0 firefox # 用 best effort 类型运行 firefox 并且设为高优先级
        
        accton 打开或关闭进程统计
        lastcomm 显示以前使用过的命令的信息
        sa 报告、清理并维护进程统计文件
chrt(优先级：命令){
Set policy:
  chrt [options] <policy> <priority> {<pid> | <command> [<arg> ...]}

Get policy:
  chrt [options] {<pid> | <command> [<arg> ...]}

Scheduling policies:
  -b | --batch         set policy to SCHED_BATCH
  -f | --fifo          set policy to SCHED_FIFO
  -i | --idle          set policy to SCHED_IDLE
  -o | --other         set policy to SCHED_OTHER
  -r | --rr            set policy to SCHED_RR (default)
# SCHED_FIFO、SCHED_RR，而对于非实时进程则是：SCHED_OTHER、SCHED_OTHER、SCHED_IDLE。
Scheduling flags:
  -R | --reset-on-fork set SCHED_RESET_ON_FORK for FIFO or RR
}
nice(优先级：概念){
1.  Linux 系统可以在同一个系统上扩展多个调度算法，在同一个系统上面优先级也有了不同的含义.
2. 对于没有时间片限制的一些调度算法来说，只有最高优先级的进程主动让出 cpu
   (完成它自己的工作)，次低一点优先级的进程才可以获取 cpu 使用权。
3. 实时调度类    SCHED_RR、SCHED_FIFO 两种； 更硬的实时调度策略->SCHED_DEADLINE，采用 EDF 调度算法
   非实时调度类  完全公平调度 CFS 即SCHED_OTHER 或者 SCHED_NORMAL
                 SCHED_BATCH 与 SCHED_IDLE 这两种，不过不是很常用，不过他们同属于 CFS 调度算法

           |- CFS (OTHER IDLE)
调度算法 --|— EDF (DEADLINE)
           |- RT  (RR FIFO)
内核：task_struct
    int prio, static_prio, normal_prio;
    unsigned int rt_priority;
    
1. prio：动态优先级。该值使用 effective_prio 函数进行计算，在 CFS 类或者 EDF 类的
   调度策略中与 normal_prio 是一致的，在 RT 策略当中就直接返回当前的动态优先级值
   (其值与静态优先级相同)，该值主要是用于在运行过程中动态改变程序优先级的值，
   保证调度的公平性，低优先级的进程在长时间得不到运行状况下会暂时调高其动态优先级，
   这个计算过程比较复杂，这里不深入。
2. static_prio：静态优先级。只有 CFS 类的才有静态优先级，其他的类在内核当中也为其
   设置了该成员，但是并没有实际的物理意义，也就是静态优先级只有在 CFS 类中才有其
   实际的作用，其它的只是个幌子。该值的计算方式是通过一个宏定义来完成：
   #define NICE_TO_PRIO(nice)    ((nice) + DEFAULT_PRIO)，
   展开之后就是 nice + (100+(19-(-20)+1)/2)。
3. normal_prio：归一化优先级。所谓归一化就是统一的意思，因为对于不同的调度类来说，
   它们的优先级的概念是不一样的，但是对于内核来说，它需要一个简单的概念来区分归根
   结底到底是谁的优先级更高一点。可以理解为不同的调度类优先级就是不同国家的货币，
   归一化优先级就是黄金，把不同国家的货币(不同调度类)转换为等量黄金，之后才能够
   比较到底谁才是土豪(谁拥有优先调度权)。
4. rt_priority：RT 调度算法类的优先级，其值与用户空间传进来的值一致(用户空间使用 
   sched_setparam 等函数传递)，取值范围 1~99.
   
INIT_TASK 宏定义中可以看到上面三个值初始化默认都是 MAX_PRIO-20，也就是 120.
内核里面的归一化优先级值越小，代表实际优先级越高，目前最小的值是 -1
1. DEADLINE 调度类
归属于该调度类的进程其归一化优先级都是 -1，在该调度类内部不再区分多个优先级，统一归为 -1.
struct sched_attr attr;

memset(&attr, 0, sizeof(attr));
attr.size = sizeof(attr);

/* This creates a 200ms / 1s reservation */
attr.sched_policy = SCHED_DEADLINE;
attr.sched_runtime = 20*1000*1000;
attr.sched_deadline = attr.sched_period = 33*1000*1000;
ret = sched_setattr(0, &attr, flags);
2. FIFO、RR 等 RT 调度类
从内核的定义中可以看到宏定义：
#define MAX_USER_RT_PRIO    100
#define MAX_RT_PRIO        MAX_USER_RT_PRIO
可以看到它的优先级最大是 100，转换之后就是 99(内核要减去1)，也就是 RT 类型的调度类
优先级范围在 0~99 之间，该调度类可以采用 sched_setparam 函数来完成优先级的设置，
该函数的参数是 pid 号与一个叫做 sched_param 的结构体，该结构体只有一个参数，
那就是优先级的值，该值越大(用户空间值越大优先级越高)表示优先级越高，范围是 1~99，
需要注意的是从内核的角度来看归一化优先级的值越小，优先级才越高，也就是说用户在 user 
空间设置的这个值是与内核里面的值是翻转着来的。

3. CFS 调度类
主要就是 NORMAL/OTHER，BATCH 这两种调度类。它们的优先级可以通过 setpriority 函数来进行设置，
可以设置的范围是 -20~19，需要注意的是这个范围指的是 nice 值，它与优先级有一定的区别，
分别对应内核里面的归一化优先级 100~139.

调度类的优先级
SCHED_DEADLINE > SCHED_FIFO/SCHEDRR > SCHED_NORMAl/SCHED_OTHER/SCHED_BATCH > SCHED_IDLE
normal_prio(struct task_struct *p)
task_has_dl_policy(p) -> prio = MAX_DL_PRIO-1;              -1
task_has_rt_policy(p) -> MAX_RT_PRIO-1 - p->rt_priority;    0~98
                      -> prio = __normal_prio(p);
调度类             内核归一化优先级范围          user 可设置优先级/NICE范围  设置函数         调度算法
SCHED_OTHER/NORMAL  100~139                      -20~19                     sched_setpriority   CFS
SCHED_IDLE          100~139                      -20~19                     sched_setpriority   CFS
SCHED_BATCH         00~139                       -20~19                     sched_setpriority   CFS
SCHED_RR            0~98                         99~1                       sched_setparam      RT
SCHED_FIFO          0~98                         99~1                       sched_setparam      RT
SCHED_DEADLINE      -1                           不可设置                   sched_setparam      EDF
}
nice:友好程度，越友好的程序 NI 值越大(取值范围 -20~19)，也就越慷慨，它们会使用相对较少的 cpu 时间
     nice值叫做静态优先级
priority:PRI 就是优先级，这个优先级不对应内核里面任何一个优先级的概念，可以看到它的值跟随 NI 值不断变化
         在 CFS 调度时关系看起来就像是：PRI = 20+NI。实际上：PRI(new)=PRI(old)+nice，
         用户空间的进程刚初始化是默认都是 PRI=20，NI=0，当 NI 的值改变的时候，PRI 的值就显而易见。
     priority叫做动态优先级
         
nice(优先级：实践){ 
Linux进程的调度优先级数字会在好几个地方出现：内核，用户，top命令。他们各自都有自己的表示法。
int main(){
while(1);
return 0;
}
gcc main.c -o main
sudo chrt -f 50 ./main # 把调度策略设置为SCHED_FIFO，优先级设置为50
#top 
main的PR(优先级是)-51，CPU利用率100%。
从内核的视角上面来看，又会用99减去用户在chrt里面设置的优先级
prio = MAX_RT_PRIO - 1 - p->rt_priority; # normal_prio
-> #define MAX_RT_PRIO MAX_USER_RT_PRIO
--> #define MAX_USER_RT_PRIO 100
所以上述进程的优先级，在三个不同视角的值分别为：
用户  内核  Top  NI
50    49    -51
51    48    -52
88    11    -89
99    0     RT
Linux的RT调度策略和普通进程在调度算法上面有差异，RT的SCHED_FIFO和SCHED_RR采用的是一个bitmap：
每次从第0bit开始往后面搜索第一个有进程ready的bit，然后调度这个优先级上面的进程执行，所以在内核里面，prio数值越小，优先级越高。
但是从用户态的API里面，则是数值越大，优先级越高。下面的代码，一个线程通过调用API把自己设置为SCHED_FIFO，优先级50
总之：从用户的视角来看，数值变大，优先级变高。从内核的视角来看，数值越小，优先级越高

从top命令的视角。对于RT的进程而言，TOP的视角里面的
PR= -1 - 用户视角
最高优先级的RT进程，才在top里面显示为rt。


nice值，-20~19之间，nice越低，优先级越高，权重越大，在CFS的红黑树左边的机会大
sudo nice -n 5 ./main
sudo nice -n -5 ./main
用户  内核  Top(PR) Top(NI)
 5            25      5
 -5           15      -5
PR=20+NICE

用户       内核        Top
RT 50      49 (99-50)  -51 (-1-50)
RT 99      0           rt
NICE 5                 25
NICE -5                15
由此发现，在top里面，RT策略的PR都显示为负数；最高优先级的RT，显示为rt。top命令里面也是，数字越小，优先级越高。
}
全部线程数量：pstree -p | wc -l
全部线程数量：ps -eLf | wc -l
某进程的线程数量：pstree -p pid | wc -l
ps auxefw   # Extensive list of all running process
ps axjf     # All processes in a tree format (Linux)
ps axww     # wide output
ps -e -o pid,args --forest # List processes in a hierarchy
ps -e -o pcpu,cpu,nice,state,cputime,args --sort pcpu | sed '/^ 0.0 /d' # List processes by % cpu usage
ps -C firefox-bin -L -o pid,tid,pcpu,state # List all threads for a particular process

# CentOS下如何查看并杀死僵尸进程
ps -A -o stat,ppid,pid,cmd | grep -e '^[Zz]'
ps -A -o stat,ppid,pid,cmd | grep -e '^[Zz]' | awk '{print $2}' | xargs kill -9

ps -eo pid,tty,user,comm,lstart,etime | grep init # 查看进程启动时间
        ps(pstree|pgrep|pkill){
    au(x) 输出格式 :   
    USER PID %CPU %MEM VSZ RSS TTY STAT START TIME COMMAND
    USER: 进程拥有者   
    PID: pid   
    %CPU: 占用的 CPU 使用率   
    %MEM: 占用的记忆体使用率   
    VSZ: 占用的虚拟记忆体大小   
    RSS: 占用的记忆体大小   
    TTY: 终端的次要装置号码 (minor device number of tty)   
    STAT: 该行程的状态:   
        D: 不可中断的静止   
        R: 正在执行中   
        S: 静止状态   
        T: 暂停执行   
        Z: 不存在但暂时无法消除   
        W: 没有足够的记忆体分页可分配   
        <: 高优先序的行程   
        N: 低优先序的行程   
        L: 有记忆体分页分配并锁在记忆体内 (即时系统或捱A I/O)   
    START: 进程开始时间   
    TIME: 执行的时间   
    COMMAND:所执行的指令
    
ps -e -o pid,args --forest # List processes in a hierarchy
ps -e -o pcpu,cpu,nice,state,cputime,args --sort pcpu | sed '/^ 0.0 /d' # List processes sorted by % cpu usage
ps -e -orss=,args= | sort -b -k1,1n # List processes sorted by mem (KB) usage
ps -C firefox-bin -L -o pid,tid,pcpu,state # List all threads for a particular process

排序过程中关注: vsize, rss, resident, size,   # 内存
                cutime, utime, pcpu           # CPU
    ps -eo pid,user,args
      KEY   LONG         DESCRIPTION
       c     cmd          simple name of executable                  # 可执行的简单名称
       C     pcpu         cpu utilization                            # CPU占用率
       f     flags        flags as in long format F field            # 长模式标志
       g     pgrp         process group ID                           # 进程组ID
       G     tpgid        controlling tty process group ID           # 终端控制进程组ID
       j     cutime       cumulative user time                       # 累积用户态占用时间
       J     cstime       cumulative system time                     # 累积内核态占用时间
       k     utime        user time                                  # 用户态占用时间
       m     min_flt      number of minor page faults                # 最小缺页数
       M     maj_flt      number of major page faults                # 最大缺页数
       n     cmin_flt     cumulative minor page faults               # 累积最小缺页数
       N     cmaj_flt     cumulative major page faults               # 累积最大缺页数
       o     session      session ID                                 # 会话
       p     pid          process ID                                 # 进程ID
       P     ppid         parent process ID                          # 父进程ID
       r     rss          resident set size                          # 物理内存占用
       R     resident     resident pages                             # 物理内存占用
       s     size         memory size in kilobytes                   # 虚拟内存占用
       S     share        amount of shared pages                     # 共享内存
       t     tty          the device number of the controlling tty   # tty值
       T     start_time   time process was started                   # 启动时间
       U     uid          user ID number                             # 用户ID
       u     user         user name                                  # 用户名
       v     vsize        total VM size in kB                        # 虚拟内存
       y     priority     kernel scheduling priority                 # 内核调度
    ps -U root -u root u
        -U 参数按真实用户ID(RUID)筛选进程，它会从用户列表中选择真实用户名或 ID。真实用户即实际创建该进程的用户。
        -u 参数用来筛选有效用户ID(EUID)。
    # ps -eo pid,tid,class,rtprio,ni,pri,psr,pcpu,stat,wchan:14,comm
    # ps axo stat,euid,ruid,tty,tpgid,sess,pgrp,ppid,pid,pcpu,comm
    # ps -eopid,tt,user,fname,tmout,f,wchan
          简单选择(已定义选择进程及输出选项)    指定选择(根据选项选择进程)
********* simple selection *********  ********* selection by list *********
-A all processes                      -C by command name
-N negate selection                   -G by real group ID (supports names)
-a all w/ tty except session leaders  -U by real user ID (supports names)
-d all except session leaders         -g by session OR by effective group name
-e all processes                      -p by process ID
T  all processes on this terminal     -s processes in the sessions given
a  all w/ tty, including other users  -t by tty
g  OBSOLETE -- DO NOT USE             -u by effective user ID (supports names)
r  only running processes             U  processes for specified users
x  processes w/o controlling ttys     t  by tty
          输出内容(根据字段选择输出)         指定选择(根据选项选择进程)
          svuX 已定义选择内容 -f -F -O 
*********** output format **********  *********** long options ***********
-o,o user-defined  -f full            --Group --User --pid --cols --ppid
-j,j job control   s  signal          --group --user --sid --rows --info
-O,O preloaded -o  v  virtual memory  --cumulative --format --deselect
-l,l long          u  user-oriented   --sort --tty --forest --version
-F   extra full    X  registers       --heading --no-heading --context
                           杂项
                    ********* misc options *********
-V,V  show version      L  list format codes  f  ASCII art forest
-m,m,-L,-T,H  threads   S  children in sum    -y change -l format
-M,Z  security data     c  true command name  -c scheduling class
-w,w  wide output       n  numeric WCHAN,UID  -H process hierarchy

watchdog(){
watchdog [-t N[ms]] [-T N[ms]] [-F] DEV
Periodically write to watchdog device DEV
  -T N Reboot after N seconds if not reset (default 60) 
  -t N Reset every N seconds (default 30) 
  -F Run in foreground 
Use 500ms to specify period in milliseconds
}
watch(){
watch "ls -larth" # 监控命令(每2秒运行一次)
  -n Loop period in seconds (default 2) 
  -t Do not print header
  
watch -n1 'cat /proc/interrupts'
}
watch -n 1 'ps -aux --sort -pmem,-pcpu | head -n 20'
watch -n 1 'ps -aux --sort -pmem,-pcpu | head 20'
watch -n 1 'ps -aux --sort -pmem,-pcpu | head 20'
    ps -u pungki                    # 查看用户'pungki'的进程
    ps -aux --sort -pcpu | less     # 根据 CPU 使用来升序排序
    ps -aux --sort -pmem | less     # 根据 内存使用 来升序排序
    ps -aux --sort -pcpu,+pmem | head -n 10 # 合并到一个命令
    ps -f -C getty                   # 进程名
    ps -L 1213                       # 进程ID
    watch -n 1 'ps -aux --sort -pmem,-pcpu'
    
    ps aux |grep -v USER | sort -nk +4 | tail       # 显示消耗内存最多的10个运行中的进程，以内存使用量排序.cpu +3
    # USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
    %CPU     # 进程的cpu占用率
    %MEM     # 进程的内存占用率
    VSZ      # 进程虚拟大小,单位K(即总占用内存大小,包括真实内存和虚拟内存)
    RSS      # 进程使用的驻留集大小即实际物理内存大小
    START    # 进程启动时间和日期
    占用的虚拟内存大小 = VSZ - RSS

ps -u $USER -o pid,rss,cmd --sort -rss  # 查看当前用户程序实际内存占用，并排序
ps -eo fname,rss|awk '{arr[$1]+=$2} END {for (i in arr) {print i,arr[i]}}'|sort -k2 -nr  # 统计程序的内存耗用
ps -eo "%C : %p : %z : %a" |sort -k5 -nr # 按内存从大到小排列进程
ps -eo "%C : %p : %z : %a" | sort -nr    # 按cpu利用率从大到小排列进程
       CODE   NORMAL   HEADER
       %C     pcpu     %CPU
       %G     group    GROUP
       %P     ppid     PPID
       %U     user     USER
       %a     args     COMMAND
       %c     comm     COMMAND
       %g     rgroup   RGROUP
       %n     nice     NI
       %p     pid      PID
       %r     pgid     PGID
       %t     etime    ELAPSED
       %u     ruser    RUSER
       %x     time     TIME
       %y     tty      TTY
       %z     vsz      VSZ
ps -eal | awk '{ if ($2 == "Z") {print $4}}' | xargs sudo kill -9 # 清除僵尸进程
ps -eo pid,fname,rss|grep php-cgi|grep -v grep|awk '{if($3>=120000) print $1}' | xargs sudo kill -9 # 将大于120M内存的php-cgi都杀掉
renice +10 ps aux | awk '{ if ($3 > 0.8 && id -u $1 > 500) print $2}' # Linux系统中如何限制用户进程CPU占用率

            ps -eo pid,lstart,etime,args         # 查看进程启动时间
# 1. minutes:seconds，如20:30
# 2. hours:minutes:seconds，如1:20:30
# 3. days-hours:minute:seconds，如2-18:20:30
            ps -eo pid,etime,comm 
            
            ps -auxefw                         # Extensive list of all running process
            ps axjf # All processes in a tree format (Linux) -- pstree
            ps aux | grep 'ss[h]' # Find all ssh pids without the grep pid
            ps aux | sort -nk +4 | tail #显示消耗内存最多的 10 个运行中的进程，以内存使用量排序
            
            ps -A --sort -rss -o pid,comm,pmem,rss | less #显示系统的内存使用
        }
uptime(top 平均负载){  Show how long the system has been running + load
1. 什么是平均负载
    平均负载是指单位时间内，系统处于可运行状态和不可中断状态的平均进程数，也就是平均活跃进程数。
    比如当平均负载为 2 时，意味着什么呢？
        在只有 2 个 CPU 的系统上，意味着所有的 CPU 都刚好被完全占用。
        在 4 个 CPU 的系统上，意味着 CPU 有 50% 的空闲。
        而在只有 1 个 CPU 的系统中，则意味着有一半的进程竞争不到CPU。
​ 那么。平均负载多少为合理呢？首先需要知道自己电脑的核数。

2. CPU使用率与平均负载
    平均负载不仅还包含了正在使用CPU的进程，还包括等待CPU和等待IO的进程。二CPU使用率是
单位时间内CPU繁忙情况的统计，二者是不一样的。只有在CPU密集型进程中，二者才一致。

3. 简单工具记录
# uptime 输出平均负载情况 
# stress 模拟 CPU 使用场景
# mpstat 实时查看每个CPU的性能指标以及所以CPU的平均指标
# pdstat 用来实时查看进程的CPU、内存、IO以及上下文切换等性能指标
}
nmon(){ 与atop类似，额外具有nmonanalyser 分析工具
c代表cpu
m代表Memory
d代表磁盘io
k : 查看内核统计数据
n : 查看网络统计数据
N : 查看 NFS 统计数据
j : 查看文件系统统计数据
t : 查看高耗进程
V : 查看虚拟内存统计数据

nmon -f -t -s 60 -c 30nmon -f -t -s 60 -c 30
-f：按标准格式输出文件：_YYYYMMDD_HHMM.nmon；
-f 参数:生成文件,文件名=主机名+当前时间.nmon
-T 参数:显示资源占有率较高的进程
-s 参数:-s 10表示每隔10秒采集一次数据
-c 参数:-s 10表示总共采集十次数据
-m 参数:指定文件保存目录

借助nmon analyser可以把nmon采集的数据生成直观的Excel表
}
        top(){
        1. 记录和列信息
         1) Summary Area (l toggle)
            前五行是系统整体的统计信息。
            第一行: 任务队列信息，同 uptime 命令的执行结果。内容如下：
                01:06:48 当前时间
                up 1:22 系统运行时间，格式为时:分
                1 user 当前登录用户数
                load average: 0.06, 0.60, 0.48 系统负载，即任务队列的平均长度。
                三个数值分别为 1分钟、5分钟、15分钟前到现在的平均值。
* 系统的核数 = CPU1 x CPU1的核数 + CPU2 x CPU2的核数 + CPUn x CPUn的核数 + …… # grep -c 'model name' /proc/cpuinfo
* 根据 load average 观察系统负载首先要看系统中共有多少 "核", 单处理器单核的饱和值为 1, 单处理器双核的饱和值为 2, 双处理器单核的饱和值也为 2.
* 在实际应用中, 重点关注 5 分钟，15 分钟的负载均值，当达到 0.7 时，就需要调查原因了。

            第二、三行:为进程和CPU的信息。当有多个CPU时，这些内容可能会超过两行。内容如下：
                Tasks: 29 total 进程总数 (t toggle)
                1 running 正在运行的进程数
                28 sleeping 睡眠的进程数
                0 stopped 停止的进程数
                0 zombie 僵尸进程数
                Cpu(s): 
                0.3% us  # 用户空间占用CPU百分比  User CPU time
                1.0% sy  # 内核空间占用CPU百分比  System CPU time
                0.0% ni  # 用户进程空间内改变过优先级的进程占用CPU百分比    Nice CPU time
                98.7% id # 空闲CPU百分比
                0.0% wa  # 等待输入输出的CPU时间百分比  iowait
                0.0% hi  # CPU硬中断时间百分比         Hardware IRQ
                0.0% si  # CPU软中断时间百分比         Software Interrupts
                0.0% st  # CPU为了其他任务从虚拟机管理程序窃取的时间  Steal Time

            第四、五行:为内存信息。内容如下：
                Mem:  (m toggle)
                191272k total 物理内存总量
                173656k used 使用的物理内存总量
                17616k free 空闲内存总量
                22052k buffers 用作内核缓存的内存量
                Swap: 192772k total 交换区总量
                0k used 使用的交换区总量
                192772k free 空闲交换区总量
                123988k cached 缓冲的交换区总量。
                内存中的内容被换出到交换区，而后又被换入到内存，但使用过的交换区尚未被覆盖，
                该数值即为这些内容已存在于内存中的交换区的大小。
                相应的内存再次被换出时可不必再对交换区写入。
            2) Message/Prompt  Line;
            3) Columns Header; 
            4) Task Area (f selection)
            进程信息区,各列的含义如下:  # 显示各个进程的详细信息
            序号 列名    含义
            a   PID      进程id               Process Id
            b   PPID     父进程id             Parent Process Pid
            c   RUSER    Real user name       Real User Name
            d   UID      进程所有者的用户id   User Id
            e   USER     进程所有者的用户名   User Name
            f   GROUP    进程所有者的组名     Group Name
            g   TTY      启动进程的终端名。   Controlling Tty
            h   PR       优先级               Priority
            i   NI       nice值。负值表示高优先级，正值表示低优先级  Nice value
                         -- ni是优先值(nice value)，也就是任务的优先值。优先值为负数，则说明任务有更高的优先级，
                         -- 正数值说明任务有更低的优先级，该值为0意味着进程的优先级没有调整。
            j   P        最后使用的CPU，仅在多CPU环境下有意义           Last used CPU (SMP)
            k   %CPU     上次更新到现在的CPU时间占用百分比              CPU usage 
            l   TIME     进程使用的CPU时间总计，单位秒                  CPU Time 
            m   TIME+    进程使用的CPU时间总计，单位1/100秒             CPU Time, hundredths 
            n   %MEM     进程使用的物理内存百分比                       Memory usage (RES)
            o   VIRT     进程使用的虚拟内存总量，单位kb。VIRT=SWAP+RES  Virtual Image (kb)
            p   SWAP     进程使用的虚拟内存中，被换出的大小，单位kb。   Swapped size (kb)
            q   RES      进程使用的、未被换出的物理内存大小，单位kb。RES=CODE+DATA  Resident size (kb)
            r   CODE     可执行代码占用的物理内存大小，单位kb           Code size (kb)
            s   DATA     可执行代码以外的部分(数据段+栈)占用的物理内存大小，单位kb   Data+Stack size (kb)
            t   SHR      共享内存大小，单位kb                   Shared Mem size (kb)
            u   nFLT     页面错误次数                           Page Fault count
            v   nDRT     最后一次写入到现在，被修改过的页面数。 Dirty Pages count
            w   S        进程状态。                             Process Status
                D=不可中断的睡眠状态
                R=运行
                S=睡眠
                T=跟踪/停止
                Z=僵尸进程 父进程在但并不等待子进程
            x   COMMAND  命令名/命令行                              Command line or Program name
            y   WCHAN    若该进程在睡眠，则显示睡眠中的系统函数名   Sleeping in Function
            z   Flags    任务标志，参考 sched.h                     Task Flags
        2. 命令行选项                                              

           top -hv | -bcHisS -d delay -n iterations -p pid [, pid ...] 
            -h  # 显示版本及帮助信息
            -b  # 以批次的方式执行top; 很容易将top输出信息传递给其他命令和输入文件(Batch mode operation)
                top -b -n 2 > /tmp/top.txt # 将 top 的信息进行 2 次，然后将结果输出到 /tmp/top.txt
            -c  # 显示完整的命令行 (COMMAND), 想查看进程执行的具体位置时，非常有用 (Command line/Program name toggle)
            -n  # 后边加数字，通常和-b搭配，表示运行top几次
            -d  # 后面加秒数，top显示的内容更新的秒数，默认5s (Delay time interval) 交互-d和-s可以覆盖
            -p  # 后面加PID号，指定监测某个进程(-p : Monitor PIDs as:  -pN1 -pN2 ...  or  -pN1, N2 [,...])
            -H  # 显示线程(Threads toggle)
            -i  # 不显示任何闲置或者僵死进程 (Idle Processes toggle)
            -n  # -n<次数>：指定循环显示的次数，到了次数自己退出。(Number of iterations)
            -u  # Monitor by user as:  -u somebody
            -U  # Monitor by user as:  -U somebody
            -s  # 使用保密模式 Secure mode operation
            -S  # 指定累计模式 Cumulative time mode toggle
        3. 交互
          帮助和切换
          <Enter> or <Space>  #立即刷新
          <?> or <h>  #帮助信息
          <q> or <Ctrl-C>#退出
        3.1 字段管理
          *<f> #增加或减少进程显示标志 (Fields select)                 字段选择 (选择显示的列)
          H    # 显示线程 - Toggle
          *<o> # (Order fields) -> ANOPQRSTUVXbcdefgjlmyzWHIK 字符串   字段顺序（显示列排序 小写字母选择向下排，大写字母选择向上排）
          *<F|O> # 排序方式                                     列排序 (指定排序了列) 
          *<R> # 反向排序    -Toggle                             正向逆向选择(正向|逆向排序)
          <>   # 排序列左右之间移动，相当于实时选在排序列
        3.2 配置管理
          *<W> #保存对top的设置到文件~/.toprc，下次启动将自动调用toprc文件的设置
        3.3 字段管理(排序快捷键)
          <P> #以cpu的使用率排序显示       排序
          <M> #以Memory的使用资源排序显示  排序
          <T> #以TIME+为准进行排序显示     排序
          <N> #以PID排序显示               排序
        3.4 进程管理(排序)
          <k> #kill掉某个进程              kill
          <r> #修改某进程nice值            renice
        3.5 字段管理(字段显示快捷键)
          <c> #显示或隐藏命令完全模式                 显示或隐藏   Toggle
          <t> #显示或隐藏Tasks和Cpu(s)的状态信息      显示或隐藏   Toggle
          <m> #显示或隐藏Mem和swap的状态信息          显示或隐藏   Toggle
          <l> #显示或隐藏uptime信息(第一行)         显示或隐藏     Toggle
          <1> # 查看 CPU 每个核的使用情况             显示或隐藏
          <i> #忽略闲置和僵死进程，这是一个开关式命令 显示或隐藏   Toggle
        3.6 杂项
          <s> #设置刷新时间间隔
          <S> #累计模式，会把已完成或退出的子进程占用的CPU时间累计到父进程的MITE+    Toggle
          <u> #指定显示用户进程
          <n> 或 <#> 任务的数量
          <x|y> # 切换高亮信息：'x'将排序字段高亮显示(纵列)；'y'将运行进程高亮显示(横行)。 Toggle
          <z|Z> # 切换彩色，即打开或关闭彩色显示。                                         Toggle
          
Toggle: ltm(load task memory) 1I(SMP Iirx) RH(normal/reverse thread) c,i,S(cmdname/line idle cumulative) x,y(highlights)
KILL : k
RENICE: r
resave config: W
field selection: fo(selection order) 
sort: FO(select sort field) <>(next col left; next col right)
‘d’ 或‘s’: 设置显示的刷新间隔
    4. 配置文件
Global_defaults
   'A' - Alt display      Off (full-screen)
 * 'd' - Delay time       3.0 seconds
   'I' - Irix mode        On  (no, 'solaris' smp)
 * 'p' - PID monitoring   Off
 * 's' - Secure mode      Off (unsecured)
   'B' - Bold enable      Off
Summary_Area_defaults
   'l' - Load Avg/Uptime  On  (thus program name)
   't' - Task/Cpu states  On  (1+1 lines, see '1')
   'm' - Mem/Swap usage   On  (2 lines worth)
   '1' - Single Cpu       On  (thus 1 line if smp)
Task_Area_defaults
   'b' - Bold hilite      On  (not 'reverse')
 * 'c' - Command line     Off (name, not cmdline)
 * 'H' - Threads          Off (show all threads)
 * 'i' - Idle tasks       On  (show all tasks)
   'R' - Reverse sort     On  (pids high-to-low)
 * 'S' - Cumulative time  Off (no, dead children)
   'x' - Column hilite    Off (no, sort field)
   'y' - Row hilite       On  (yes, running tasks)
   'z' - color/mono       Off (no, colors)
        }

        pstack(gstack){pstack 108633 一个有意思的脚本}
        ftrace(内核级函数的追踪){
1, 创建一个文件夹，比如我创建到了/debug，然后挂载debugfs到这个文件夹
mount -t debugfs nodev /debug
2, 进入/debug/tracing，可以看到很多文件，其中available_tracers是可以选择的ftrace tracers，current_tracer是当前的tracer，默认是nop，就是没有。可以把一个想用的tracer写到current_tracer文件，然后将1写入tracing_on文件(默认其实就是1，只不过用了nop所以相当于没开)开启追踪。
# 检查可用tracers和当前使用的tracer
$> cat available_tracers                                                                                           
blk function_graph wakeup_dl wakeup_rt wakeup function nop
$> cat current_tracer
nop
# 设置并开启tracer
$> echo function > current_tracer
$> echo 1 > tracing_on
3, 可以打开/sys/kernel/debug/tracing/trace文件查看追踪内容，比如我这里用的是function tracer，所以可以看到调用关系，这个文件貌似有个最大长度的限制。
$> vim /sys/kernel/debug/tracing/trace

https://www.ibm.com/developerworks/cn/linux/l-cn-ftrace/
https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/6/html/developer_guide/ftrace
        }
        crash(内核分析工具){http://people.redhat.com/anderson/}
        Kprobes(将 printk 插入到运行中的 Linux 内核){https://www.ibm.com/developerworks/cn/linux/l-kprobes.html}
        misc(列出正在占用swap的进程){

            #!/bin/bash
            echo -e "PID\t\tSwap\t\tProc_Name"
            # 拿出/proc目录下所有以数字为名的目录(进程名是数字才是进程，其他如sys,net等存放的是其他信息)
            for pid in `ls -l /proc | grep ^d | awk '{ print $9 }'| grep -v [^0-9]`
            do
                # 让进程释放swap的方法只有一个：就是重启该进程。或者等其自动释放。放
                # 如果进程会自动释放，那么我们就不会写脚本来找他了，找他都是因为他没有自动释放。
                # 所以我们要列出占用swap并需要重启的进程，但是init这个进程是系统里所有进程的祖先进程
                # 重启init进程意味着重启系统，这是万万不可以的，所以就不必检测他了，以免对系统造成影响。
                if [ $pid -eq 1 ];then continue;fi
                grep -q "Swap" /proc/$pid/smaps 2>/dev/null
                if [ $? -eq 0 ];then
                    swap=$(grep Swap /proc/$pid/smaps \
                        | gawk '{ sum+=$2;} END{ print sum }')
                    proc_name=$(ps aux | grep -w "$pid" | grep -v grep \
                        | awk '{ for(i=11;i<=NF;i++){ printf("%s ",$i); }}')
                    if [ $swap -gt 0 ];then
                        echo -e "${pid}\t${swap}\t${proc_name}"
                    fi
                fi
            done | sort -k2 -n | awk -F'\t' '{
                pid[NR]=$1;
                size[NR]=$2;
                name[NR]=$3;
            }
            END{
                for(id=1;id<=length(pid);id++)
                {
                    if(size[id]<1024)
                        printf("%-10s\t%15sKB\t%s\n",pid[id],size[id],name[id]);
                    else if(size[id]<1048576)
                        printf("%-10s\t%15.2fMB\t%s\n",pid[id],size[id]/1024,name[id]);
                    else
                        printf("%-10s\t%15.2fGB\t%s\n",pid[id],size[id]/1048576,name[id]);
                }
            }'

        }

        signal(linux操作系统提供的信号){

            kill -l                    # 查看linux提供的信号
            trap "echo aaa"  2 3 15    # shell使用 trap 捕捉退出信号

            # 发送信号一般有两种原因:
            #   1(被动式)  内核检测到一个系统事件.例如子进程退出会像父进程发送SIGCHLD信号.键盘按下control+c会发送SIGINT信号
            #   2(主动式)  通过系统调用kill来向指定进程发送信号
            # 进程结束信号 SIGTERM 和 SIGKILL 的区别:  SIGTERM 比较友好，进程能捕捉这个信号，根据您的需要来关闭程序。在关闭程序之前，您可以结束打开的记录文件和完成正在做的任务。在某些情况下，假如进程正在进行作业而且不能中断，那么进程可以忽略这个SIGTERM信号。
            # 如果一个进程收到一个SIGUSR1信号，然后执行信号绑定函数，第二个SIGUSR2信号又来了，第一个信号没有被处理完毕的话，第二个信号就会丢弃。

            SIGHUP  1          A     # 终端挂起或者控制进程终止
            SIGINT  2          A     # 键盘终端进程(如control+c)
            SIGQUIT 3          C     # 键盘的退出键被按下
            SIGILL  4          C     # 非法指令
            SIGABRT 6          C     # 由abort(3)发出的退出指令
            SIGFPE  8          C     # 浮点异常
            SIGKILL 9          AEF   # Kill信号  立刻停止
            SIGSEGV 11         C     # 无效的内存引用
            SIGPIPE 13         A     # 管道破裂: 写一个没有读端口的管道
            SIGALRM 14         A     # 闹钟信号 由alarm(2)发出的信号
            SIGTERM 15         A     # 终止信号,可让程序安全退出 kill -15
            SIGUSR1 30,10,16   A     # 用户自定义信号1
            SIGUSR2 31,12,17   A     # 用户自定义信号2
            SIGCHLD 20,17,18   B     # 子进程结束自动向父进程发送SIGCHLD信号
            SIGCONT 19,18,25         # 进程继续(曾被停止的进程)
            SIGSTOP 17,19,23   DEF   # 终止进程
            SIGTSTP 18,20,24   D     # 控制终端(tty)上按下停止键
            SIGTTIN 21,21,26   D     # 后台进程企图从控制终端读
            SIGTTOU 22,22,27   D     # 后台进程企图从控制终端写

            缺省处理动作一项中的字母含义如下:
                A  缺省的动作是终止进程
                B  缺省的动作是忽略此信号，将该信号丢弃，不做处理
                C  缺省的动作是终止进程并进行内核映像转储(dump core),内核映像转储是指将进程数据在内存的映像和进程在内核结构中的部分内容以一定格式转储到文件系统，并且进程退出执行，这样做的好处是为程序员提供了方便，使得他们可以得到进程当时执行时的数据值，允许他们确定转储的原因，并且可以调试他们的程序。
                D  缺省的动作是停止进程，进入停止状况以后还能重新进行下去，一般是在调试的过程中(例如ptrace系统调用)
                E  信号不能被捕获
                F  信号不能被忽略
        }

        perfance(系统性能状态){

            vmstat 1 9

            r      # 等待执行的任务数。当这个值超过了cpu线程数，就会出现cpu瓶颈。
            b      # 等待IO的进程数量,表示阻塞的进程。
            swpd   # 虚拟内存已使用的大小，如大于0，表示机器物理内存不足，如不是程序内存泄露，那么该升级内存。
            free   # 空闲的物理内存的大小
            buff   # 已用的buff大小，对块设备的读写进行缓冲
            cache  # cache直接用来记忆我们打开的文件,给文件做缓冲，(把空闲的物理内存的一部分拿来做文件和目录的缓存，是为了提高 程序执行的性能，当程序使用内存时，buffer/cached会很快地被使用。)
            inact  # 非活跃内存大小，即被标明可回收的内存，区别于free和active -a选项时显示
            active # 活跃的内存大小 -a选项时显示
            si   # 每秒从磁盘读入虚拟内存的大小，如果这个值大于0，表示物理内存不够用或者内存泄露，要查找耗内存进程解决掉。
            so   # 每秒虚拟内存写入磁盘的大小，如果这个值大于0，同上。
            bi   # 块设备每秒接收的块数量，这里的块设备是指系统上所有的磁盘和其他块设备，默认块大小是1024byte
            bo   # 块设备每秒发送的块数量，例如读取文件，bo就要大于0。bi和bo一般都要接近0，不然就是IO过于频繁，需要调整。
            in   # 每秒CPU的中断次数，包括时间中断。in和cs这两个值越大，会看到由内核消耗的cpu时间会越多
            cs   # 每秒上下文切换次数，例如我们调用系统函数，就要进行上下文切换，线程的切换，也要进程上下文切换，这个值要越小越好，太大了，要考虑调低线程或者进程的数目,例如在apache和nginx这种web服务器中，我们一般做性能测试时会进行几千并发甚至几万并发的测试，选择web服务器的进程可以由进程或者线程的峰值一直下调，压测，直到cs到一个比较小的值，这个进程和线程数就是比较合适的值了。系统调用也是，每次调用系统函数，我们的代码就会进入内核空间，导致上下文切换，这个是很耗资源，也要尽量避免频繁调用系统函数。上下文切换次数过多表示你的CPU大部分浪费在上下文切换，导致CPU干正经事的时间少了，CPU没有充分利用。
            us   # 用户进程执行消耗cpu时间(user time)  us的值比较高时，说明用户进程消耗的cpu时间多，但是如果长期超过50%的使用，那么我们就该考虑优化程序算法或其他措施
            sy   # 系统CPU时间，如果太高，表示系统调用时间长，例如是IO操作频繁。
            id   # 空闲 CPU时间，一般来说，id + us + sy = 100,一般认为id是空闲CPU使用率，us是用户CPU使用率，sy是系统CPU使用率。
            wt   # 等待IOCPU时间。Wa过高时，说明io等待比较严重，这可能是由于磁盘大量随机访问造成的，也有可能是磁盘的带宽出现瓶颈。

            如果 r 经常大于4，且id经常少于40，表示cpu的负荷很重。
            如果 pi po 长期不等于0，表示内存不足。
            如果 b 队列经常大于3，表示io性能不好。

        }
    }
nmon(perfance){
1.4. 参考资料
Nmon在IBM的官方网站
http://www.ibm.com/developerworks/wikis/display/WikiPtype/nmon
nmon for linux的官方网站
http://nmon.sourceforge.net/pmwiki.php
文章一：《nmon 性能：分析 AIX 和 Linux 性能的免费工具》
http://www.ibm.com/developerworks/cn/aix/library/analyze_aix/
文章二：《nmon analyser——生成 AIX 性能报告的免费工具》
http://www.ibm.com/developerworks/cn/aix/library/nmon_analyser/index.html：

1.5. 获取该工具 
下载nmon工具的可执行文件nmon_x86_sles10。 
http://nmon.sourceforge.net/pmwiki.php?n=Site.Download
也可以下载源码自己编译特定的版本。(推荐这个)
http://nmon.sourceforge.net/pmwiki.php?n=Site.CompilingNmon
下载nmon Analyser V3.3 
http://www.ibm.com/developerworks/wikis/display/Wikiptype/nmonanalyser
下载nmon Consolidator
http://www.ibm.com/developerworks/wikis/display/WikiPtype/nmonconsolidator
ibm的其他性能测试工具
http://www.ibm.com/developerworks/wikis/display/WikiPtype/Performance+Other+Tools

2. nmon 
2.1. 安装
该工具是一个独立的二进制文件(不同的 AIX 或 Linux 版本中该文件也有所不同)。安装过程非常简单： 
1. 将 nmon_x86_sles10文件复制到计算机，rz—>在弹出框选择nmon_x86_sles10。
2. 修改nmon_x86_sles10的文件权限，chmod 777 ./nmon_x86_sles10
3. 要启动 nmon 工具，输入 ./ nmon_x86_sles10。
 
2.2. 运行
Nmon可以交互式运行
l 启动该工具 ./ nmon_x86_sles10
l 使用单键命令来查看您所需要的数据。例如，要获取 CPU、内存和磁盘统计信息，启动 nmon 并输入： c m d 
l 获取相关的帮助信息，按 h 键。
使用下面这些键来切换显示状态：
c = CPU l = CPU Long-term  - = Faster screen updates   
m = Memory j = Filesystems + = Slower screen updates  
d = Disks n = Network V = Virtual Memory 
r = Resource N = NFS v = Verbose hints 
k = kernel t = Top-processes . = only busy disks/procs 
h = more options q = Quit    
2.3. 捕获数据到文件
捕获数据到文件，只要运行带 -f 标志的 nmon 命令。执行nmon -f ***后，nmon 将转为后台运行。要查看该进程是否仍在运行，可以输入： ps -ef | grep nmon。
示例：
每1秒捕获数据快照，捕获20次
nmon -f -s 1 -c 20
每30秒捕获数据快照，捕获120次，包含进程信息
nmon -ft -s 30 -c 120 
命令将在当前目录中创建输出文件，其名称为： <hostname>_date_time.nmon。该文件采用逗号分隔值 (CSV) 的格式，并且可以将其直接导入到电子表格中，可进行分析和绘制图形
}
    histroy(日志管理){
        last                         # 查看历史登录记录 读取位于/var/log/wtmp的文件，并把该给文件的内容记录的登录系统的用户名单全部显示出来。
        lastb                        # 查看失败登录记录 读取位于/var/log/btmp的文件，并把该文件内容记录的登入系统失败的用户名单，全部显示出来。
        ac # ac命令根据当前的/var/log/wtmp文件中的登录进入和退出来报告用户连接的时间(小时),如果不使用标志,则报告总的时间
            -d 按每天的统计数据打印。 
            -y 在显示日期的时候输出年份。 
            -p 打印每个账号的总的连接时间。 
        echo > ~/.bash_history       # 清除操作命令历史
        history                      # 历时命令默认1000条
        HISTTIMEFORMAT="%Y-%m-%d %H:%M:%S "   # 让history命令显示具体时间
        history  -c                  # 清除记录命令
        cat $HOME/.bash_history      # 历史命令记录文件
        lastb -a                     # 列出登录系统失败的用户相关信息  清空二进制日志记录文件 echo > /var/log/btmp
        last                         # 查看登陆过的用户信息  清空二进制日志记录文件 echo > /var/log/wtmp   默认打开乱码
        last reboot                  # 机器重启记录
        who /var/log/wtmp            # 查看登陆过的用户信息
        w        # 可显示开机多久，当前登录的所有用户，平均负载 
        who      # 显示当前登录的所有用户 
        last     # 显示每个用户最后的登录时间
        lastlog                      # 用户最后登录的时间
        tail -f /var/log/messages    # 系统日志
        tail -f /var/log/secure      # ssh日志
        tail -F /var/log/messages    #和-f比多个重试的功能，就是文件不存在了，会不断尝试

        ln -s /dev/null .mysql_history # .mysql_history    
        ln -s /dev/null .bash_history  # 从安全角度考虑禁止记录history
        1. 定制.bash_history格式
        export HISTSIZE=1000
        export HISTFILESIZE=2000
        export HISTTIMEFORMAT="%Y-%m-%d-%H:%M:%S "
        export HISTFILE="~/.bash_history"
        2. HISTIGNORE 可以设置那些命令不记入history列表。
        HISTIGNORE="ls:ll:la:cd:exit:clear:logout"
        HISTTIMEFORMAT="[%Y-%m-%d - %H:%M:%S] "
        HISTFILE=~/.history
        HISTSIZE=50000
        SAVEHIST=50000
    }
    script(scriptreplay){
使用script命令录制，使用scriptreplay播放录制的操作。共享终端的操作，则需要使用命名管道来实现。
开始录制会话
script -t 2> timing.log -a output.session，
录制完后键入exit退出，
最后通过scriptreplay timing.log output.session回放
  timing.log 用来存在时序信息(-t参数表示将时序信息重定向到stderr)
  output.session 存储命令输出信息
1. "-t 2> timing.log"是要回放的必须选项，不加"2>"将导致开启录制后的任何输入都是乱码状态-不能使用scriptreplay来回放。
2. timing.log记录的是每个时间段输入了多少字符。通过timing.log和output.session配合可以实现回放。
3. 注意点是，录制前保证timing.log和output.session是空文件，否则将导致回放时操作不一致。
[root@xuexi test]# scriptreplay timing.log output.session # 回放


# 终端屏幕分享
# 通过管道来传输信息实现。需要一个pipe文件，并在需要展示的终端打开这个管道文件。
# 在终端1(作为主终端，即演示操作的终端)上使用mkfifo创建管道文件。
[root@xuexi tmp]# mkfifo scriptfifo
[root@xuexi tmp]# ll scriptfifo
prw-r--r-- 1 root root 0 Sep 26 13:04 scriptfifo   # 权限位前面的第一个p代表的就是pipe文件。
在终端2上打开pipe文件。
[root@xuexi ~]# cat /tmp/scriptfifo      # 分享端
在终端1上打开pipe文件。
[root@xuexi ~]# script -f scriptfifo     # 演示端
    }

    free(查看剩余内存){
        free -m
        #-/+ buffers/cache:       6458       1649
        #6458M为真实使用内存  1649M为真实剩余内存(剩余内存+缓存+缓冲器)
        #linux会利用所有的剩余内存作为缓存，所以要保证linux运行速度，就需要保证内存的缓存大小
        
        -b #以bytes显示内存数量 
        -g #以gigabytes显示内存数量 
        -k #以kilobytes显示内存数量(默认) 
        -m #以megabytes显示内存数量 
        -l #显示详细的高低内存统计 
        -c count #显示几次结果，须和-s一起使用 
        -s delay #时间间隔 -V #显示版本号 
        -o #以旧版本方式输出，仅仅是没有buffer adjusted行 
        -t #显示一个总计的行
* buffers 和 cache 都是内存中存放的数据，不同的是，
* buffers 存放的是准备写入磁盘的数据，而cache 存放的是从磁盘中读取的数据
* 手动把buffers写入硬盘并清空cachesync && echo 3 > /proc/sys/vm/drop_caches
free
             total       used       free     shared    buffers     cached
Mem:      32872632   12393128   20479504          0      23308    7496048
-/+ buffers/cache:    4873772   27998860
Swap:            0          0          0
    
第一行(Mem)：
total：内存总数 32872632 KB
used：已使用的内存数 12393128 KB
free：空闲的内存数 20479504 KB
shared：多个进程共享的内存，总是0
buffers：缓存内存数 23308 KB
cached：缓存内存数 7496048 KB

第二行(-/+ buffers/cache)：
used：第一行Mem中的 used - buffers - cached = 12393128 - 23308 - 7496048 = 4873772 KB
free：第一行Mem中的 free + buffers + cached = 20479504 + 23308 + 7496048 = 27998860 KB
可见这一行[used-buffers/cache]反映的是被程序实实在在吃掉的内存，[used+buffers/cache]反映的是可以挪用的内存总数。
    }

system_version(){
        uname -a              # 获取内核版本(和BSD版本)
# Linux agent109.cloud.com 2.6.32-279.el6.x86_64 #1 SMP Fri Jun 22 12:19:21 UTC 2012 x86_64 x86_64 x86_64 GNU/Linux
        cat /proc/version     # 查看内核版本
# Linux version 2.6.32-279.el6.x86_64 (mockbuild@c6b9.bsys.dev.centos.org) (gcc version 4.4.6 20120305 (Red Hat 4.4.6-4) (GCC) ) #1 SMP Fri Jun 22 12:19:21 UTC 2012
        cat /proc/cmdline     # init 的命令行参数
# ro root=/dev/mapper/VolGroup-lv_root rd_DM_UUID=ddf1_4c5349202020202080861d60000000004711471100001450 rd_NO_LUKS LANG=en_US.UTF-8 rd_NO_MD rd_LVM_LV=VolGroup/lv_swap SYSFONT=latarcyrheb-sun16 crashkernel=129M@0M rd_LVM_LV=VolGroup/lv_root  KEYBOARDTYPE=pc KEYTABLE=us rhgb quiet
        cat /etc/issue        # 查看系统版本 本机登录的欢迎界面(root 可编辑修改)
        cat /etc/motd         # 远程登录的欢迎界面(root 可编辑修改)
        cat /etc/issus.net    # 
        cat /etc/*-release    # 操作系统版本信息
        cat /etc/*_version
        cat /etc/lsb-release  # 不确定有
        cat /etc/os-release   # 不确定有
        cat /etc/debian_version # 不确定有
        cat /etc/redhat-release #同上                        cat /etc/*-release
        cat /etc/SuSe-release   #suse系统下才可使用，同上    cat /etc/*-release
        cat /etc/issue.net
        cat /etc/debian_version 
        getconf LONG_BIT      #查看操作系统位数
        getconf #  将系统配置变量值打印到输出屏幕上
        getconf -a  # 将所有系统配置变量值输出 
        lsb_release -a          #用来查看Linux兼容性的发行版信息
        dmesg | grep Linux

dmesg(){
dmesg 将所有消息从内核环形缓冲区写入标准输出
sysctl -w kernel.dmesg_restrict 指定非特权用户是否可以使用dmesg
dmesg | less 分页查看
dmesg | grep usb
dmesg 从/proc/kmsg虚拟文件中读取内核生成的消息，只能由一个进程打开
dmesg -H | --hunman # Centos未实现
dmesg -T | --ctime  # Centos未实现
dmesg --time-format=delta | ctime reltime delta notime iso # Centos未实现
dmesg -f kern.daemon 
kern   内核消息
user   用户级消息
mail   邮件系统
daemon 系统守护进程
auth   安全/授权消息
syslog 内部syslogd消息
lpr    行式打印子系统
news   网络新闻子系统

dmesg -l err.crit
emerg  系统无法使用
alert  必须立即采取措施
crit   紧急情况
err    错误条件 
warn   告警条件
notice 正常但重要的条件
info   信息性
debug  调试消息

dmesg -c 清除缓冲区
}


        locale -a             # 列出所有语系
        locale                # 当前环境变量中所有编码
                              # 保存语言信息的文件在/etc/sysconfig/i18n中。
        /etc/sysconfig/i18n   # 设置文件 # 
        LANG=en               # 使用英文字体
        # 要记得 /lib 不可以与 / 分别放在不同的 partition
        hwclock               # 查看时间
        who                   # 当前在线用户
        w                     # 当前在线用户
        whoami                # 查看当前用户名
        logname               # 查看初始登陆用户名
        uptime                # 查看服务器启动时间
        sar -n DEV 1 10       # 查看网卡网速流量
        dmesg                 # 显示开机信息 /var/log/dmesg
                              # 使用 dmesg 来查看一些硬件或驱动程序的信息或问题。
                              # 选项：-c显示后清除buffer，-s设置缓冲区大小，-n设置记录信息层次
        dmesg -c              # 清除开机信息，但/var/log/dmesg文件中仍然有这些信息。
        lsmod                 # 查看内核模块
        
        last reboot           # 最近reboot日志
        last pts/0            # 指定终端
        last tty0             # 指定终端
        last root             # 指定用户
        lastb                 # 登录失败日志
        finger user           # 显示用户信息
    }
system_hardware(){
    dmesg
    arch      #显示机器的处理器架构(1)
    uname -m  #显示机器的处理器架构(2)
    uname -r  #显示正在使用的内核版本
    cat /proc/devices # 设备信息，外部各设备类型在内核的主设备号
    1. cpu
        yum install lm_sensors -y && sh -c "yes|sensors-detect" && modprobe i2c-dev 
        sensors # cpu 温度
        /sys/bus/acpi/devices/LNXTHERM:00/thermal_zone/temp # cpu温度
        getconf LONG_BIT                                         # cpu运行的位数
        more /proc/cpuinfo                                       # 查看cpu信息
        lscpu                                                    # 查看cpu信息
        cat /proc/cpuinfo | grep name | cut -f2 -d: | uniq -c    # 查看cpu型号和逻辑核心数
        cat /proc/cpuinfo | grep 'physical id' |sort| uniq -c    # 物理cpu个数
        cat /proc/cpuinfo | grep "processor" | wc -l             # 查看逻辑CPU的个数
        cat /proc/cpuinfo | grep "cores"| uniq                   # 查看CPU是几核
        cat /proc/cpuinfo | grep MHz | uniq                      # 查看CPU的主频
        cat /proc/cpuinfo | grep flags | grep ' lm ' | wc -l     # 结果大于0支持64位
        cat /proc/cpuinfo |grep flags                             # 查看cpu是否支持虚拟化 pae支持半虚拟化  IntelVT 支持全虚拟化
        cat /proc/cpuinfo | grep name | cut -f2 -d: | uniq -c
    2. 内存
        more /proc/meminfo                                       # 查看内存信息
        grep MemTotal /proc/meminfo # 显示物理内存大小
        free -m         Used and free memory (-m for MB)
    3. 中断
        watch -n 1 $(cat /proc/interrupts)                       # 监控内核处理的所有中断
        watch -n1 'cat /proc/interrupts'
    4. dmidecode                                                # 查看全面硬件信息 Desktop Management Interface
        # -t type   查看指定类型的信息，比如bios,system,memory,processor等。
        # -s keyword   查看指定的关键字的信息，比如system-manufacturer, system-product-name, system-version, system-serial-number等。
        dmidecode | grep "Product Name"                          # 查看服务器型号
        dmidecode | grep -P -A5 "Memory\s+Device" | grep Size | grep -v Range       # 查看内存插槽
        dmidecode | grep -P  'Maximum\s+Capacity'                                   # 查看最大支持内存容量
        dmidecode -t memory|grep -E 'Asset|Manufacturer'                            # 查看内存
        dmidecode -t 4 | grep ID # CPU ID
        dmidecode | grep Serial  # Serial Number
        dmidecode -t 4           # CPU
        dmidecode -t 0           # BIOS
        dmidecode -t bios        # 查看BIOS信息
        dmidecode |grep -A16 "System Information$"
        dmidecode -t 2           # 主板
        dmidecode -t 11          # OEM
        dmidecode|grep "System Information" -A9|egrep  "Manufacturer|Product|Serial" # 服务器型号序列号
    5. 通过日志查看硬件信息
        dmesg | grep -i vga  # 显卡：
        dmesg | grep IDE     # 查看启动时IDE设备检测状况
    6. 特定总线硬件 lscpu lspci lsusb lshw 
        lspci | grep -i eth  # 网卡：
        lspci | grep -i vga  # 声卡：
        sudo apt-get install hddtemp sudo hddtemp /dev/sda       # 查看硬盘温度
        cat /proc/mdstat                                         # 查看软raid信息
        cat /proc/scsi/scsi                                      # 查看Dell硬raid信息(IBM、HP需要官方检测工具)
        lspci                                                    # 查看硬件信息 /sys/bus/pci/devices
        lspci|grep RAID                                          # 查看是否支持raid
        lspci -vvv |grep Ethernet                                # 查看网卡型号
        lspci -vvv |grep Kernel|grep driver                      # 查看驱动模块
        lspci -tv                                                # 列出所有PCI设备
        modinfo tg2                                              # 查看驱动版本(驱动模块)
     7. 网卡信息
        ethtool -i em1                                           # 查看网卡驱动版本
        ethtool em1                                              # 查看网卡带宽
        ethtool eth0 # Show the ethernet status (replaces mii-diag) 
        ethtool -s eth0 speed 100 duplex full # Force 100Mbit Full duplex 
        ethtool -s eth0 autoneg off # Disable auto negotiation 
        ethtool -p eth1 # Blink the ethernet led - very useful when supported
        ifconfig fxp0 media 100baseTX mediaopt full-duplex # 100Mbit full duplex (FreeBSD)
        sudo apt-get install wakeonlan 或 sudo ethtool -s eth0 wol g
        lshal  # 显示所有设备属性列表，通过 lshal 和hal-device-manager 也能知道硬件相关信息，
        lshw
        lshw -numeric -class network
        lshw -html > lshw.html # 生成网页形式的页面。
        lshw -short            # 查看硬件的简要信息。
        lshw -c network        # 查看网卡基本信息
    8. USB 信息
        lsusb              # /sys/bus/usb/devices/
        lsusb -tv          # 列出所有USB设备
        mount | column -t  # 查看挂接的分区状态
    9. BIOS
        dd if=/dev/mem bs=1k skip=768 count=256 2>/dev/null | strings -n 8 # 读取 BIOS 信息Linux
        losetup # LOOP_SET_STATUS64 | LOOP_SET_FD | LOOP_CLR_FD | 0x4C07 | 0x4C82
    10. disk  
        lsblk lshw 
        hdparm -i /dev/sda      #罗列一个磁盘的架构特性
        hdparm -tT /dev/sda     #在磁盘上执行测试性读取操作
        badblocks -s /dev/sda   Test for unreadable blocks on disk sda     
        smartctl -x /dev/sda1   使用 smartctl -x <device> 命令来查看厂商，型号等。
        lsblk --help -o
        lsblk --noheadings --output UUID /dev/mapper/vg-swap # disk uuid
        cat /proc/mounts      #显示已加载的文件系统
    } 
    iozone(){
sudo iozone -i 0 -i 1 -i 2 -s 4g -r 32k -Rab ./iozone.xls
       -i #表示要求做的测试项目。 
    0=write/rewrite,1=read/re-read, 2=random-read/write
    3=Read-backwards,4=Re-write-record, 5=stride-read, 6=fwrite/re-fwrite,7=fread/Re-fread,
    8=randommix, 9=pwrite/Re-pwrite, 10=pread/Re-pread, 11=pwritev/Re-pwritev,12=preadv/Repreadv
     可以多次使用-i 选项，表示执行多种测试。
     -s  表示文件大小。  默认单位是k字节。m表示MB,g表示GB。
     -r    一次读写的块大小。  
      也可以使用返回表示的文件和块大小。      -n  文件最小尺寸。  -g 文件最大尺寸。 -y 块最小尺寸。 -q 块最大尺寸。
    }
    
    iwconfig()
    {
        iwconfig
        ip link set wlan0 up
        iw dev wlan0 scan | less 
        1. iw dev wlan0 connect [网络 SSID]
        2. iw dev wlan0 connect [网络 SSID] key 0:[WEP 密钥]
        3   /etc/wpasupplicant/wpa_supplicant.conf
            network={    ssid="[网络 ssid]"    psk="[密码]"    priority=1}
            wpa_supplicant -i wlan0 -c /etc/wpa_supplicant/wpa_supplicant.conf
        dhcpcd wlan0
        iwconfig
        
        iwconfig eth0 rate 2M #强制使广播总是同步在2Mbps，即使还存在其他可用速度。
        iwconfig eth0 rate 5.5M auto #让驱动器将速度上限设为5.5Mbps，只慢不快。
        iwconfig eth0 rate auto #通常卡在1Mbps时比它们在11Mbps时可以延伸的更远。
    }

    teminal(终端快捷键){
        Ctrl+A        　    # 行前
        Ctrl+E        　    # 行尾
        Ctrl+S        　    # 终端锁屏
        Ctrl+Q        　　  # 解锁屏
        Ctrl+D      　　    # 退出
    }

    开机启动模式{

        vi /etc/inittab
        id:3:initdefault:    # 3为多用户命令
        #ca::ctrlaltdel:/sbin/shutdown -t3 -r now   # 注释此行 禁止 ctrl+alt+del 关闭计算机

    }

repeat(){ 持续运行命令直至成功

repeat()    # 函数
{
    while true
    do
        $@ && return
    done
}

repeat() { while :; do $@ && return; done }              # 一种更快的方法

repeat() { while :; do $@ && return; sleep 30; done }    # 加入延时

}

man_systemctl(){
    systemctl is-active *.service      # 查看服务是否运行
    systemctl is-enabled *.service     # 查询服务是否开机启动
    systemctl mask *.service           # 注销指定服务
    systemctl unmask cups.service      # 取消注销cups服务
    systemctl enable *.service         # 开机运行服务
    systemctl disable *.service        # 取消开机运行
    systemctl start *.service          # 启动服务
    systemctl stop *.service           # 停止服务
    systemctl restart *.service        # 重启服务
    systemctl reload *.service         # 重新加载服务配置文件
    systemctl status *.service         # 查询服务运行状态
    systemctl --failed                 # 显示启动失败的服务
    systemctl poweroff                 # 系统关机
    systemctl reboot                   # 重新启动
    systemctl rescue                   # 强制进入救援模式
    systemctl emergency                # 强制进入紧急救援模式
    systemctl list-dependencies        # 查看当前运行级别target(mult-user)启动了哪些服务
    systemctl list-unit-files          # 查看开机启动的状态
    journalctl -r -u elasticsearch.service  # 查看日志 r倒序 u服务名
    /etc/systemd/system/falcon-agent.service
        [Unit]
        Description=This is zuiyou monitor agent
        After=network.target remote-fs.target nss-lookup.target

        [Service]
        User= root
        Type=simple
        PIDFile=/opt/falcon-agent/var/app.pid
        ExecStartPre=/usr/bin/rm -f /opt/falcon-agent/var/app.pid
        ExecStart=/opt/falcon-agent/control start
        ExecReload=/bin/kill -s HUP $MAINPID
        KillMode=process
        KillSignal=SIGQUIT
        TimeoutStopSec=5
        PrivateTmp=true
        Restart=always
        LimitNOFILE=infinity

        [Install]
        WantedBy=multi-user.target

systemctl daemon-reload # 加载配置
}

system_init()
    {
init # 切换运行级别
RHEL系列                        Debian系列
0 停机                          0 停机
1 单用户模式                    1 单用户模式
2 无网络服务的多用户模式        2 多用户模式
3 完全多用户模式(标准运行级)    3 多用户模式
4 保留                          4 多用户模式
5 图形界面模式                  5 多用户模式
6 重启系统                      6 重启系统
init 0 关闭系统 
telinit 0 关闭系统 
logout 注销

    }
    terminal(终端提示显示){

        echo $PS1                   # 环境变量控制提示显示
        PS1='[\u@ \H \w \A \@#]\$'
        PS1='[\u@\h \W]\$'
        export PS1='[\[\e[32m\]\[\e[31m\]\u@\[\e[36m\]\h \w\[\e[m\]]\$ '     # 高亮显示终端

    }

    ulimit -a        # 显示用戶可以使用的资源限制
    ulimit unlimited # 不限制用戶可以使用的资源，但本設定對可打开的最大文件数(max open files) 
　　                 # 和可同时执行的最大进程數(max user processes)无效
    ulimit -n <可以同时打开的文件数> # 设定用戶可以同时打开的最大文件数(max open files) 
1. Per shell/script ulimit适用于bash的脚本文件
    ulimit(){
    # 限制以下命令的内存使用
        ulimit -Sv 1000 # 1000 KBs = 1 MB 
        ulimit -Sv unlimited # Remove limit
        
        ulimit -SHn 65535  # 临时设置文件描述符大小 进程最大打开文件柄数 还有socket最大连接数, 等同配置 nofile
        ulimit -SHu 65535  # 临时设置用户最大进程数
        ulimit -a          # 查看
        
-H  设置硬资源限制，一旦设置不能增加。                        # ulimit - Hs 64；限制硬资源，线程栈大小为 64K。  
-S  设置软资源限制，设置后可以增加，但是不能超过硬资源设置。  # ulimit - Sn 32；限制软资源，32 个文件描述符。  
-a  显示当前所有的 limit 信息。                  # ulimit - a；显示当前所有的 limit 信息。  
-c  最大的 core 文件的大小， 以 blocks 为单位。  # ulimit - c unlimited； 对生成的 core 文件的大小不进行限制。  
-d  进程最大的数据段的大小，以 Kbytes 为单位。   # ulimit -d unlimited；对进程的数据段大小不进行限制。  
-f  进程可以创建文件的最大值，以 blocks 为单位。 # ulimit - f 2048；限制进程可以创建的最大文件大小为 2048 blocks。  
-l  最大可加锁内存大小，以 Kbytes 为单位。       # ulimit - l 32；限制最大可加锁内存大小为 32 Kbytes。  
-m  最大内存大小，以 Kbytes 为单位。             # ulimit - m unlimited；对最大内存不进行限制。  
-n  可以打开最大文件描述符的数量。               # ulimit - n 128；限制最大可以使用 128 个文件描述符。  
-p  管道缓冲区的大小，以 Kbytes 为单位。         # ulimit - p 512；限制管道缓冲区的大小为 512 Kbytes。  
-s  线程栈大小，以 Kbytes 为单位。               # ulimit - s 512；限制线程栈的大小为 512 Kbytes。  
-t  最大的 CPU 占用时间，以秒为单位。            # ulimit - t unlimited；对最大的 CPU 占用时间不进行限制。  
-u  用户最大可用的进程数。                       # ulimit - u 64；限制用户最多可以使用 64 个进程。  
-v 进程最大可用的虚拟内存，以 Kbytes 为单位。    # ulimit - v 200000；限制最大可用的虚拟内存为 200000 Kbytes。
    }
2. Per user/process limits.conf 适用于登录用户和守护进程
    limits.conf(){
        /etc/security/limits.conf

        # 文件描述符大小  open files
        # lsof |wc -l   查看当前文件句柄数使用数量
        * soft nofile 16384         # 设置太大，进程使用过多会把机器拖死
        * hard nofile 32768

        # 用户最大进程数  max user processes
        # echo $((`ps uxm |wc -l`-`ps ux |wc -l`))  查看当前用户占用的进程数 [包括线程]
        user soft nproc 16384
        user hard nproc 32768

        # 如果/etc/security/limits.d/有配置文件，将会覆盖/etc/security/limits.conf里的配置
        # 即/etc/security/limits.d/的配置文件里就不要有同样的参量设置
        /etc/security/limits.d/90-nproc.conf    # centos6.3的默认这个文件会覆盖 limits.conf
        user soft nproc 16384
        user hard nproc 32768

        sysctl -p    # 修改配置文件后让系统生效
3. System wide 系统范围配置
        sysctl -a                          # View all system limits
        sysctl fs.file-max                 # View max open files limit
        sysctl fs.file-max=102400          # Change max open files limit
        echo "1024 50000" > /proc/sys/net/ipv4/ip_local_port_range  # port range
        cat /etc/sysctl.conf
        fs.file-max=102400                   # Permanent entry in sysctl.conf
        # cat /proc/sys/fs/file-nr           # How many file descriptors are in use
    }

    portrange(随机分配端口范围){

        # 本机连其它端口用的
        echo "10000 65535" > /proc/sys/net/ipv4/ip_local_port_range

    }

    network(百万长链接设置){

        # 内存消耗需要较大
        vim /root/.bash_profile
        # 添加如下2行,退出bash重新登陆
        # 一个进程不能使用超过NR_OPEN文件描述符
        echo 20000500 > /proc/sys/fs/nr_open
        # 当前用户最大文件数
        ulimit -n 10000000
        
        sysctl fs.file-max=20000500 # 更改系统最大文件打开数
    }
    network(question){
1. TCP: time wait bucket table overflow

# net.ipv4.tcp_max_tw_buckets
# TCP: time wait bucket table overflow
# time_wait的sockets过多，需增大net.ipv4.tcp_max_tw_buckets的值
vim /etc/sysctl.conf => sysctl -p
net.ipv4.tcp_max_buckets=655350

2. socket: Too many open files (24)

# socket: Too many open files (24)
# 调整用户/进程最大打开文件数
/etc/security/limits.conf
* soft nproc 65535
* hard nproc 65535
* soft nofile 65535
* hard nofile 65535

3. kernel: possible SYN flooding on port 80. Sending cookies
# kernel: possible SYN flooding on port 80. Sending cookies.
# syn队列已满，触发了syncookies
/etc/sysctl.conf
net.ipv4.tcp_fin_timeout=30
net.ipv4.tcp_keepalive_time=1200
net.ipv4.tcp_syncookies=1
net.ipv4.tcp_tw_reuse=1
net.ipv4.tcp_tw_recycle=1 # Enabling this option is not recommended since this causes problems when working with NAT
net.ipv4.ip_local_port_range=1024 65000
net.ipv4.tcp_max_syn_backlog=8192
net.ipv4.tcp_max_tw_buckets=8000
net.ipv4.tcp_synack_retries=2
net.ipv4.tcp_syn_retries=2

4. nf_conntrack: table full, gropping packet
# nf_conntrack: table full, gropping packet.
# netfilters跟踪连接数过高，超出系统限制
modprobe nf_conntrack
/etc/sysctl.conf
net.nf_conntrack_max=655360
net.netfilter.nf_conntrack_tcp_timeout_established=36000
# old version
modprobe ip_conntrack
/etc/sysctl.conf
net.ipv4.ip_conntrack_max=655350
net.ipv4.netfilter.ip_conntrack_tcp_timeout_established=10800
    }

    libc(libc.so故障修复){

        # 由于升级glibc导致libc.so不稳定,突然报错,幸好还有未退出的终端
        grep: error while loading shared libraries: /lib64/libc.so.6: ELF file OS ABI invalid

        # 看看当前系统有多少版本 libc.so
        ls /lib64/libc-[tab]

        # 更改环境变量指向其他 libc.so 文件测试
        export LD_PRELOAD=/lib64/libc-2.7.so    # 如果不改变LD_PRELOAD变量,ln不能用,需要使用 /sbin/sln 命令做链接

        # 当前如果好使了，在执行下面强制替换软链接。如不好使，测试其他版本的libc.so文件
        ln -f -s /lib64/libc-2.7.so /lib64/libc.so.6

    }
    second(ms毫秒 μs微秒 ns纳秒 ps皮秒){
        皮秒，符号ps(英语：picosecond )
        纳秒，符号ns(英语：nanosecond )
        微秒，符号μs(英语：microsecond )
        毫秒，符号ms(英语：millisecond )
        秒，  second
    }
    color(){
    红 red，橙 orange，黄 yellow，绿 green，青 cyan，蓝 blue，紫 purple，灰 gray，粉 pink ，黑 black，白 white，棕 brown
    blink 闪烁
    }
    
john(shadow密码破解){
john hash

passwd文件
root:x:0:0:root:/root:/bin/bash
用户名:密码:用户ID:组ID:用户全名:主目录:登录shell

shadow文件
root:$1$V5B5ubR0$V7Br7YjVC6b/FHTN51l40.:14304:0:99999:7:::
登录名:加密口令:最后一次修改时间:最小时间间隔:最大时间间隔:警告时间:不活动时间:

将shadow文件放到run目录下(/john-1.*/run/)
john的字典模式破解shadow文件
语句：john -wordlist=password.lst shadow

john的-show参数查看破解后的账户密码
语句：john -show shadow
}
hashcat(shadow密码破解){

}

system_boot(Reset root password){
方法1 bootloader
At the boot loader (lilo or grub), enter the following boot option:
    init=/bin/sh
If, after booting, the root partition is mounted read only, remount it rw:
    mount -o remount,rw / 
    passwd                       # or delete the root password (/etc/shadow) 
    sync; mount -o remount,ro /  # sync before to remount read only 
    reboot
方法2 live CD
mount -o rw /dev/ad4s3a /mnt 
chroot /mnt # chroot into /mnt 
passwd 
reboot
}

    system(用户与组){
1. 用户帐号，用户密码，用户组信息和用户组密码均是存放在不同的配置文件中的。/etc/passwd /etc/shadow /etc/group /etc/gshadow
2. id groups gpasswd groupdel groupmod groupadd passwd userdel usermod useradd last whoami who w 
/etc/passwd: 用户帐号的相关信息
  初始群组:
  /etc/passwd里记录的就是初始群组,一登入系统就会取得这个群组的权限,所以并不用写进/etc/group
/etc/gshadow
  1.群组名称
  2.密码栏
  3.群组管理员的账号
  4.该群组的所属账号
/etc/group: 组帐号的相关信息
  1.群组名称
  2.密码,通常不需要
  3.GID
  4.支持的账号名称
/etc/shadow: 用户密码及相关属性
  1.账号名称
  2.加密后的密码,如果是*或!,表示这个账号不会被登入
  3.最近更动密码的日期,1970年1月1日为1,每天累加1
  4.密码不可被更动的天数,如果为0表示随时可以更动
  5.密码需要重新变更的天数,如果为99999的话,表示不需要更动密码
  6.密码需要变更前的警告期限
  7.密码过期的恕限时间
  8.账号失效日期,和3一样都是从1970年1月1日到某天的天数
9.保留,看以后有没有新功能加入
/etc/gshadow: 组密码及相关属性

/etc/passwd:文件结构 man 5 passwd
  1字段：用户名称 
  2字段：用户密码,早期密码就在这个字段，后因安全问题，改放到/etc/shadow 
  3字段：UID，该帐号是登录用户，UID(CentOS7)分配为1000+ 
  4字段：GID 
  5字段：对用户的说明信息，(注释) 
  6字段：用户的家目录 
  7字段：用户的shell 
/etc/shadow:文件结构 man 5 shadow # 用户真实的密码采用 MD5 加密算法加密后，保存在 / etc/shadow 配置文件中
　1字段：用户名称 
  2字段：用户密码,该用户暂未设置密码 
  3字段：最后一次变更密码的日期，从1970年1月1日开始计算 
  4字段：密码变更锁定天数，与第3段相比锁定天数过后才可变更密码 
  5字段：密码使用期限，与第3段相比在此天数内需要重设你的密码 
  6字段：密码变更前警告期，与第5段相比密码快要到期时，系统会依据这个字段的天数设置发出"警告" 
  7字段：密码过期宽限时间，在此天数内用户没有登录变更密码，那么该帐号的密码将会"失效" 
  8字段：帐号失效日期，无论密码是否过期，这个帐号都不能再被使用 
  9字段：保留字段 
/etc/group:文件结构 man 5 group
  1字段：组名称 
  2字段：用户组密码,因安全问题，改放到/etc/gshadow 
  3字段：GID 
  4字段：以此组为附加组的用户名称 
/etc/gshadow:文件结构 man 5 gshadow
  1字段：组名称 
  2字段：用户组密码,该用户组暂未设置密码 
  3字段：用户组管理者，缺省代表没有管理者 
  4字段：组内用户列表，因为这是用户的私有组所以没有其他用户
  
deluser USER # Delete USER from the system

useradd(新建用户){
useradd -u UID -g initial_group -G other_group -Mm -c 说明栏 -d home -s shell username 新增使用者
  [OPTIONS]选项参数如下： 
    -u:指定UID 
    -g:指定GID(此组需存在) 
    -G:指定用户附加组，多个附加组需使用逗号分隔开(此组需存在) 
    -n:不为用户创建私有用户组
    
    -c:指定注释信息 
    -d:指定用户家目录 DIR
    -D:修改用户默认选项(修改的是/etc/default/useradd中选项)
    -s:指定shell，可在/etc/shells文件里查看shell可用种类 
    -m:若主目录不存在，则创建它。-r 与 - m 相结合，可为系统账户创建主目录
    -M:不创建主目录
    -r:创建一个用户 ID 小于 500 的系统账户，默认不创建对应的主目录
    
    -e date : 指定账户过期的日期。日期格式为 MM/DD/YY
    -f days : 帐号过期几日后永久停权。若指定为 -，则立即被停权，若为 - 1，则关闭此功能
    
    -p password 为新建用户指定登录密码。
# 创建用户账户时，系统会自动创建该用户对应的主目录，该目录默认放在 / home 目录下，若要改变位置，可以利用 - d 参数指定；
# 对于用户登录时使用的 shell，默认为 / bin/bash，若要更改，则使用 - s 参数指定
}
passwd(添加密码){
passwd [OPTIONS] username 
  [OPTIONS]选项参数如下： 
    -l:锁定指定用户密码 
    -u -unlock :解锁指定用户密码 
    -d --delete :删除用户密码，仅能以root权限操作； 
    -e:终止用户密码 
    -i, -- inactive=DAYS # 在密码过期后多少天，用户被禁掉，仅能以root操作；
    -x, --maximum= DAYS #两次密码修正的最大天数，后面接数字；仅能root权限操作； 
    -n, --minimum=DAYS  #两次密码修改的最小天数，后面接数字，仅能root权限操作； 
    -w, --warning=DAYS #：在距多少天提醒用户修改密码；仅能root权限操作；
    -k, -- keep -tokens  # 保留即将过期的用户在期满后能仍能使用；
    -f, -- force   #强制操作；仅root权限才能操作；
    -S, -- status  #查询用户的密码状态，仅能 root用户操作；
    -stdin:echo "12345678" | passwd -stdin username,将12345678设定为username的密码，一般用于批量新建用户初始密码
# 只有 root 用户才有权设置指定账户的密码。一般用户只能设置或修改自己账户的密码(不带参数)
passwd -l 帐户名
passwd -l beinan    # 锁定用户 beinan 不能更改密码；
passwd -d beinan  # 当我们清除一个用户的密码时，登录时就无需密码；这一点要加以注意； 
passwd -u 帐户名    # 解锁账户密码
passwd -S 账户名    # 要查询当前账户的密码是否被锁定
passwd -d 帐户名    # 帐户密码被删除后，将不能登录系统，除非重新设置密码。
passwd -S root
root PS 2017-09-27 0 99999 7 -1 (Password set, SHA512 crypt.)
# 除了用户账户可被锁定外，账户密码也可被锁定，任何一方被锁定后，都将无法登录系统。只有 root 用户才有权执行该命令.
}
chage(修改用户密码有效期限){ 见 passwd
chage [- l] [ -m 最小天数] [-M 最大天数] [-W  警告] [-I  失效日] [-E  过期日] [-d  最后日] 用户 
chage [OPTIONS] username 
  [OPTIONS]选项参数如下： 
    -l:列出该用户的密码详细参数 
    -d:修改shadow第3段(最后一次变更密码的日期)设置为0时，用户首次登录需要变更密码 
    -m:修改shadow第4段(密码变更锁定天数) 
    -M:修改shadow第5段(密码使用期限) 
    -W:修改shadow第6段(密码变更前警告期) 
    -I:修改shadow第7段(密码过期宽限时间) 
    -E:修改shadow第8段(帐号失效日期)　
}
usermod(用户属性修改){
usermod 不仅能改用户的SHELL类型，所归属的用户组，也能改用户密码的有效期，还能改登录名。usermod 如此看来就
是能做到用户帐号大转移；比如我把用户A 改为新用户B；
usermod   [ -u uid [-o]] [-g group] [-G group,...] 
                         [- d  主目录 [ - m]] [- s shell] [ -c 注释] [- l  新名称] 
                         [- f  失效日] [ -e 过期日] [-p 密码] [-L|- U] 用户名 
                         
usermod [OPTIONS] username 
  [OPTIONS]选项参数如下： 
    -u uid 用户ID 值。必须为唯一的 ID值，除非用-o 选项。数字不可为负值。预设为最小不得小于/etc/login.defs 中定义的
        UID_MIN 值。0 到UID_MIN 值之间是传统上保留给系统帐号使用。
    -g initial_group  更新用户新的起始登入用户组。用户组名须已存在。用户组ID必须参照既有的的用户组。用户组ID预设值为1 。
    -G:定义用户为一堆 groups的成员。每个用户组使用"," 区格开来，不可以夹杂空白字元。
    -c comment :更新用户帐号 password 档中的注解栏，一般是使用chfn(1) 来修改。
    -d home_dir :更新用户新的登入目录。如果给定-m 选项，用户旧目录会搬到新的目录去，如旧目录不存在则建个新的。 
    -s:指定shell，可在/etc/shells文件里查看shell可用种类 
    -r:创建系统用户 
    -l login_name : 变更用户 login 时的名称为login_name。其它不变。特别是，用户目录名应该也会跟着更动成新的登入名。
    -e expire_date : 加上用户帐号停止日期。日期格式为 MM/DD/YY. 
    -f inactive_days: 帐号过期几日后永久停权。当值为 0 时帐号则立刻被停权。而当值为- 1 时则关闭此功能。预设值为- 1。
    
    -L:锁定用户，密码前添加"!" 
    -U:解锁用户,去掉密码前的"!"
    
    警告:usermod不允许你改变正在线上的用户帐号名称。当 usermod 用来改变userID,必须确认这名 user没在电脑上执行任何
程序。你需手动更改用户的crontab 档。也需手动更改用户的 at工作档。采用 NISserver 须在server上更动相关的 NIS 设定。 
    
# usermod -l 新用户名 原用户名
# usermod -L nsj0820
# usermod -U nsj0820
# 对于已创建好的用户，可使用 usermod 命令来修改和设置账户的各项属性，包括登录名，主目录，用户组，登录 shell 等

usermod -d /opt/linuxfish -m     -l fishlinux -U linuxfish 
注：把linuxfish 用户名改为fishlinux ，并且把其家目录转移到  /opt/linuxfish ；
more  /etc/passwd |grep fishlin ux    注：查看有关fishlinux 的记录； 
fishlinux:x:512:512::/opt/linuxfish:/bin/bash 
通过上面的例子，我们发现文件的用户组还没有变，如果您想改变为 fishlinux 用户组，如果想用通过  usermod 来修改，就要
先添加fishlinux 用户组；然后用usermod -g  来修改  ，也可以用 chown -R fishlinux:fishlinux /opt/finshlinux 来改；
}
userdel(删除用户){
userdel [-r] 帐户名 # -r 为可选项，若带上该参数，则在删除该账户的同时，一并删除该账户对应的主目录。
# 若要设置所有用户账户密码过期 的时间，则可通过修改 / etc/login.defs 
# 配置文件中的 PASS_MAX_DAYS 配置项的值来实现，其默认值为 99999，代表用户账户密码永不过期。
# 其中 PASS_MIN_LEN 配置项用于指定账户密码的最小长度，默认为 5 个字符。

userdel bnnb    # 删除用户 bnnb ，但不删除其家目录及文件；
userdel -r lanhaitun   # 删除用户 lanhaitun，其家目录及文件一并删除； 
}

finger(查询用户信息，侧重用户家目录、登录SHELL){
最常用finger  来查询用户家目录、用户真实名、所用SHELL 类型、以及办公地址和电话，这是以参数  -l  长格式输出的；
而修改用户的家目录、真实名字、办公地址及办公电话，我们一般要能过 chfn 命令进行；
finger -l root
Login     Name       Tty      Idle  Login Time   Office     Office Phone
root      root       pts/1          May 15 08:56 (172.16.200.53)

看看finger  -s  和w  及who的输出有什么异同，
w 和who 是查询哪些用户登录主机的；而 finger  -s  呢，无论是登录还是不登录的用户都可以查；
但所查到的内容侧重有所不同；
}

w(who users查询登录主机的用户工具){
}
delgroup [USER] GROUP # Delete group GROUP from the system or user USER from group GROUP
groupadd(新建组){  Add a group or add a user to a group
groupadd [OPTIONS] groupname 
  [OPTIONS]选项参数如下： 
    -g:指定GID 
    -r:创建系统组
# 新建一个用户组，或者将一个用户添加到指定组内。

若命令带有 - r 参数，则创建系统用户组，该类用户组的 GID 值小于 500；
若没有 - r 参数，则创建普通用户组，其 GID 值大于或等于 500.
}

groups(用户所归属的用户组查询){
groups    用户名  
}
gpasswd(组密码){
gasswd [OPTIONS] groupname 
  [OPTIONS]选项参数如下： 
    -a user:将用户user添加进该组 
    -d user:将用户user移除该组 
    -A userlist:设置有组管理权限的用户列表
    
gpasswd -a 用户账户  用户组名  # 可以将用户添加到指定的组，使其成为该组的成员
gpasswd -d 用户账户  用户组名  # 若要从用户组中移除某用户，
gpasswd -A 用户账户 要管理的用户组
命令功能：将指定的用户设置为指定用户组的用户管理员。用户管理员只能对授权的用户组进行用户管理
          (添加用户到组或从组中删除用户)，无权对其他用户组进行管理。
[root@localhost home]# gpasswd -a nisj student
Adding user nisj to group student
[root@localhost home]# gpasswd -A nisj student
[root@localhost home]# useradd stu
[root@localhost home]# gpasswd -a stu student
Adding user stu to group student
[root@localhost home]# groups stu
stu : stu student
[root@localhost home]# su - nisj
[nisj@localhost ~]$ gpasswd -d stu student
Removing user stu from group student
[nisj@localhost ~]$ gpasswd -d stu stu
gpasswd: Permission denied.
}
groupmod(组属性修改){
groupmod [OPTIONS] groupname 
  [OPTIONS]选项参数如下： 
    -g:修改GID 
    -n:修改组名称
    
groupmod -n 新用户组名  原用户组名   # 对于用户组改名，不会改变其 GID 的值
groupmod -n teacher student
groupmod -g new_GID 用户组名称  # 
groupmod -g 506 teacher
}
groupdel(){
groupdel 用户组名

在删除用户组时，被删除的用户组不能是某个账户的私有用户组，否则将无法删除，
若要删除，则应先删除引用该私有用户组的账户，然后再删除用户组。
}
    }
pam(){
    Linux用户密码的有效期,是否可以修改密码可以通过 login.defs 文件控制。对login.defs 文件修只影响后续
建立的用户,如果要改变以前建立的用户的有效期等可以使用 chage 命令. 
    Linux用户密码的复杂度可以通过 pam pam_cracklib module 或pam_passwdqc module 控制,两者不能同时
使用.  个人感觉 pam_passwdqc更好用. 
/etc/login.defs 密码策略 
PASS_MAX_DAYS      99999         # 密码的最大有效期, 99999:永久有期 
PASS_MIN_DAYS       0                   #是否可修改密码,0 可修改,非0 多少天后可修改 
PASS_MIN_LEN       5                  #密码最小长度,使用pam_cracklib module, 该参数不再有效 
PASS_WARN_AGE      7                 #密码失效前多少天在用户登录时通知用户修改密码 

pam_cracklib 主要参数说明: 
tretry=N: 重试多少次后返回密码修改错误 
difok=N:新密码必需与旧密码不同的位数 
dcredit=N: N >= 0:密码中最多有多少个数字;N < 0 密码中最少有多少个数字. 
lcredit=N: 小宝字母的个数 
ucredit=N 大宝字母的个数 
credit=N: 特殊字母的个数 
minclass=N: 密码组成( 大/小字母,数字,特殊字符) 
pam_passwdqc主要参数说明: 
mix:设置口令字最小长度，默认值是 mix=disabled。 
max: 设置口令字的最大长度，默认值是 max=40。 
passphrase: 设置口令短语中单词的最少个数，默认值是passphrase=3 ，如果为0 则禁用口令短语。 
atch: 设置密码串的常见程序，默认值是 match=4。 
similar: 设置当我们重设口令时，重新设置的新口令能否与旧口令相似，它可以是 similar=permit 允
许相似或 similar=deny 不允许相似。 
rando m:设置随机生成口令字的默认长度。默认值是 random=42 。设为 0 则禁止该功能。 
enforce:设置约束范围，enforce=none 表示只警告弱口令字，但不禁止它们使用；enforce=users 将
对系统上的全体非根用户实行这一限制；enforce=everyone 将对包括根用户在内的全体用户实行这
一限制。 
non - unix: 它告诉这个模块不要使用传统的 getpwnam 函数调用获得用户信息， 
retry:设置用户输入口令字时允许重试的次数，默认值是 retry=3  
   
密码复杂度通过/etc/pam.d /system- auth 实施 
如: 
要使用 pam_cracklib 将注释去掉,把pam_passwdqc.so 注释掉即可. 
#password        requisite          /lib/security/$ISA/pam_cracklib.so retry=3 difok=1  
password        requisite          /lib/security/$ISA/pam_passwdqc.so min=disabled,24,12,8,7 passphrase=3 
password        sufficient        /lib/security/$ISA/pam_unix.so nullok use_authtok md5 shadow  
   
#password        requisite          /lib/security/$ISA/pam_cracklib.so retry=3 difok=1  
新密码至少有一位与原来的不同   
  PASS_MIN_DAYS 参数则设定了在本次密码修改后，下次允许更改密码之前所需的最少天数。
PASS_WARN_AGE 的设定则指明了在口令失效前多少天开始通知用户更改密码（一般在用户刚刚登陆系统时
就会收到警告通知）。 
你也会编辑/etc/default/useradd 文件，寻找 INACTIVE 和EXPIRE 两个关键词： 
INACTIVE=14  
EXPIRE=

这会指明在口令失效后多久时间内，如果口令没有进行更改，则将账户更改为失效状态。在本例中，
这个时间是 14天。而 EXPIRE 的设置则用于为所有新用户设定一个密码失效的明确时间（具体格式为“年份-月份-日期” ）。 
        显然，上述这些设定更改之后，只能影响到新建立的用户。要想修改目前已存在的用户具体设置，
需要使用 chage 工具。 
# chage - M 60 joe 
这条命令将设置用户 joe 的PASS_MAX_DAYS 为60，并修改对应的 shadow文件。 
        你可以使用 chage  - l 的选项，列出当前的账户时效情况，而使用- m 选项是设置 PASS_MIN_DAYS ，用 -W
则是设置 PASS_WARN_AGE，等等。chage 工具可以让你修改特定账户的所有密码时效状态。 
        注意，chage 仅仅适用于本地系统的账户，如果你在使用一个类似 LDAP这样的认证系统时，该工具
会失效。如果你在使用 LDAP作为认证，而你又打算使用 chage，那么，哪怕仅仅是试图列出用户密码的时
效信息，你也会发现 chage 根本不起作用。

}
    
    time(){
modification time (mtime)：
    当该文件的'内容数据'变更时，就会更新这个时间!内容数据指的是文件的内容，而不是文件的
属性或权限喔!
status time (ctime)：
    当该文件的'状态 (status)'改变时，就会更新这个时间，举例来说，像是权限与属性被更改了，
    都会更新这个时间啊。
access time (atime)：
    当'该文件的内容被取用'时，就会更新这个读取时间(access)。举例来说，我们使用 cat 去
读取 /etc/man_db.conf ， 就会更新该文件的 atime 了。
    }
### shell脚本示例：计算毫秒级、微秒级时间差
# start=1502758855.907197692 end=1502758865.066894173
# timediff $start $end
timediff() {
# time format:date +"%s.%N", such as 1502758855.907197692
    start_time=$1
    end_time=$2
    
    start_s=${start_time%.*}
    start_nanos=${start_time#*.}
    end_s=${end_time%.*}
    end_nanos=${end_time#*.}
    
    # end_nanos > start_nanos? 
    # Another way, the time part may start with 0, which means
    # it will be regarded as oct format, use "10#" to ensure
    # calculateing with decimal if [ "$end_nanos" -lt "$start_nanos" ];then
        end_s=$(( 10#$end_s - 1 ))
        end_nanos=$(( 10#$end_nanos + 10**9 ))
    fi
    
# get timediff
    time=$(( 10#$end_s - 10#$start_s )).$(( (10#$end_nanos - 10#$start_nanos)/10**6 ))
    
    echo $time
}
    byte(KB：全称千字节Kbyte；MB：全称兆字节MByte；GB：全称吉字节GByte)
    {
        1KB=1024B
        1MB=1024KB
        1GB=1024MB
        1TB=1024GB
        1PB=1024TB
        1EB=1024PB
        1ZB=1024EB
        1YB=1024ZB
    }
    
    grub(repair){
    
# Boot from a live cd, mount the linux partition, add /proc and /dev and use grub-install /dev/xyz. Suppose linux lies on /dev/sda6:
    mount /dev/sda6 /mnt               # mount the linux partition on /mnt
    mount --bind /proc /mnt/proc       # mount the proc subsystem into /mnt
    mount --bind /dev /mnt/dev         # mount the devices into /mnt
    chroot /mnt                        # change root to the linux partition
    grub-install /dev/sda              # reinstall grub with your old settings
    }
    grub(grub开机启动项添加){

        vim /etc/grub.conf
        title ms-dos
        rootnoverify (hd0,0)
        chainloader +1
    }
    /usr/share/lib/terminfo     包含终端能力数据库。
    reset(初始化终端){
    reset [ -e C ] [ -k C ] [ -i C ] [ - ] [ -s ] [ -n ] [ -I ] [ -Q ] [ -m [ Identifier ] [ TestBaudRate ] :Type ] ... [ Type ]
    reset 命令链接到 tset 命令。如果 tset 命令在作为 reset 命令运行， 它先执行下列操作，然后再完成所有依靠终端的处理：
    将伪造和回显模式设置为打开
    关闭 cbreak 和"原始"模式
    打开换行转换
    恢复特殊字符到敏感状态。
    }
    tset(初始化终端){
    tset [ -e C ] [ -k C ] [ -i C ] [ - ] [ -s ] [ -I ] [ -Q ] [  -m [ Identifier ] [ TestBaudRate ] :Type ] ... [ Type ]
    tset 命令可设置终端特征。它执行终端依赖性的处理，比如：设置擦除和杀死字符、设置或复位延迟以及发送任何需要的序列以正常初始化终端。
    }
    slattach(串口转网口)
    {
        slattach /dev/tty00 # 
        ifconfig sl0 inet 192.168.1.1 192.168.1.2 #
        slattach /dev/tty00 # 
        ifconfig sl0 inet 192.168.1.2 192.168.1.1 #
        ping 192.168.1.1
        nslookup www.google.com   #  服务器地址，域名请求类型和域名对应多个IP地址
        dig www.google.com        #  服务器地址，域名请求类型和域名对应多个IP地址
        
    }

    stty(串口通信){
    见serial.sh 文件中 stty详解
    
        stty ispeed 115200 ospeed -F /dev/ttyS0    # 本端
        stty ispeed 115200 ospeed -F /dev/ttyS0    # 对端
        cat /dev/ttyS0                             # 本端
        echo hello /dev/ttyS0                      # 对端
        slatach                                    # 连接串行线路作为网络接口。
        #stty时一个用来改变并打印终端行设置的常用命令
        
        stty iuclc          # 在命令行下禁止输出大写
        stty -iuclc         # 恢复输出大写
        stty olcuc          # 在命令行下禁止输出小写
        stty -olcuc         # 恢复输出小写
        stty size           # 打印出终端的行数和列数
        stty eof "string"   # 改变系统默认ctrl+D来表示文件的结束
        stty -echo          # 禁止回显
        stty echo           # 打开回显
        stty -echo;read;stty echo;read  # 测试禁止回显
        stty igncr          # 忽略回车符
        stty -igncr         # 恢复回车符
        stty erase '#'      # 将#设置为退格字符
        stty erase '^?'     # 恢复退格字符

        stty(定时输入){

            timeout_read(){
                timeout=$1
                old_stty_settings=`stty -g`　　# save current settings
                stty -icanon min 0 time 100　　# set 10seconds,not 100seconds
                eval read varname　　          # =read $varname
                stty "$old_stty_settings"　　  # recover settings
            }

            read -t 10 varname    # 更简单的方法就是利用read命令的-t选项

        }

        stty(检测用户按键){

            #!/bin/bash
            old_tty_settings=$(stty -g)   # 保存老的设置(为什么?).
            stty -icanon
            Keypress=$(head -c1)          # 或者使用$(dd bs=1 count=1 2> /dev/null)
            echo "Key pressed was \""$Keypress"\"."
            stty "$old_tty_settings"      # 恢复老的设置.
            exit 0
        }
        stty命令不带参数可以打印终端行设置，加上-a参数可以打印得更详细些。
        stty size可以显示终端的大小，即行数和列数。
        stty命令还可以更改终端行的设置，格式如下：
        stty SETTING CHAR
        其中，SETTING可以是如下
            eof : 输入结束，文件结束，默认为Ctrl+D。比如：用cat >file来创建文件时，按Ctrl+D来结束输入。
            erase : 向后删除字符，擦除最后一个输入字符，默认为Ctrl+?。注意默认情况下退格键Backspace不是删除字符。
            intr : 中断当前程序，默认为Ctrl+C。
            kill : 删除整条命令，删除整行，默认为Ctrl+U。
            quit :退出当前程序，默认为Ctrl+\或Ctrl+|。
            start : 启动屏幕输出，默认为Ctrl+Q。
            stop :停止屏幕输出，默认为Ctrl+S。有时候终端突然僵死了，可能是不小心按了Ctrl+S的缘故，因为我们习惯性的按Ctrl+S来保存文件。
            susp : terminal stop当前程序，默认为Ctrl+Z。这样当前进程就会变成后台进程了。
        werase：删除最后一个单词，默认为Ctrl+W。
        stty命令还有一些其他用法，如：
            stty -echo 关闭回显。比如在脚本中用于输入密码时。
            stty echo 打开回显。
        输入密码的脚本片段：stty -echo; read var; stty echo; 或 read -s var # -echo 禁止将输出发送到终端，而选项echo则允许发送输出
    }
    slatach(连接串行线路作为网络接口){
    /usr/sbin/slattach TTYName [ BaudRate DialString [ DebugLevel ] ]
    /usr/sbin/slattach 命令给网络接口分配一根 TTY 线路。
    在系统启动期间，slattach 文件由 /etc/rc.net 命令运行以自动配置"系统管理界面程序"(SMIT)所定义的任何"串行网络协议"(SLIP)网络接口。
    示例部分表明也可以手工配置 SLIP 接口。
    
    BaudRate    设置连接速度。缺省值是 9600。
    DebugLevel  设置所需的调试信息级别。可以指定从 0 到 9 的数字。0 值指定没有调试信息；9 指定最多的调试信息。缺省值是 0。
    DialString  使用基本网络实用程序(BNU)／ UNIX 到 UNIX 的复制程序(UUCP)的 chat 语法指定望望／响应序列的字符串。
    TTYName     指定 TTY 线路。此字符串是 ttyxx 或 /dev/ttyxx 的格式。
    
    要使用直接连接把 SLIP 网络接口连接到 tty1 端口上，发出以下命令：
    slattach /dev/tty1
    
    该命令把 tty1 连接到 SLIP 所使用的网络接口上。
    要使用调制解调器连接把 SLIP 网络接口连接到 tty1 上，请发出下列命令：
    slattach /dev/tty1 9600 '""AT OK \pATF1 OK \pATDT34335 CONNECT""'
    }
interfaces(){
    # The primary network interface
    auto eth0
    iface eth0 inet static
    address 192.168.3.90
    gateway 192.168.3.2
    netmask 255.255.255.0
    network 192.168.3.0
    broadcast 192.168.3.255
    
sudo nm-connection-editor & #图形化配置
}

dev_tty(){
当程序打开此文件是，Linux会自动将它重定向到一个终端窗口，因此该文件对于读取人工输入时特别有用。见如下Shell代码：
#!/bin/bash
printf "Enter new password: "    #提示输入
stty -echo                               #关闭自动打印输入字符的功能
read password < /dev/tty         #读取密码
printf "\nEnter again: "             #换行后提示再输入一次
read password2 < /dev/tty       #再读取一次以确认
printf "\n"                               #换行
stty echo                                #记着打开自动打印输入字符的功能
echo "Password = " $password #输出读入变量
echo "Password2 = " $password2
echo "All Done"
}
daemon(daemon守护进程){
相关目录
    /etc/init.d/*启动脚本放置处
    /etc/sysconfig/*各服务的初始化环境配置文件
    /etc/xinetd.conf, /etc/xinetd.d/*super daemon 配置文件
    /etc/*各服务各自的配置文件
    /var/lib/*各服务产生的数据库
    /var/run/*各服务的程序之 PID 记录处
}
    iptables(){

        内建三个表：nat mangle 和 filter
        filter预设规则表，有INPUT、FORWARD 和 OUTPUT 三个规则链
        vi /etc/sysconfig/iptables    # 配置文件
        INPUT    # 进入
        FORWARD  # 转发
        OUTPUT   # 出去
        ACCEPT   # 将封包放行
        REJECT   # 拦阻该封包
        DROP     # 丢弃封包不予处理
        -A       # 在所选择的链(INPUT等)末添加一条或更多规则
        -D       # 删除一条
        -E       # 修改
        -p       # tcp、udp、icmp    0相当于所有all    !取反
        -P       # 设置缺省策略(与所有链都不匹配强制使用此策略)
        -s       # IP/掩码    (IP/24)    主机名、网络名和清楚的IP地址 !取反
        -j       # 目标跳转，立即决定包的命运的专用内建目标
        -i       # 进入的(网络)接口 [名称] eth0
        -o       # 输出接口[名称]
        -m       # 模块
        --sport  # 源端口
        --dport  # 目标端口

        iptables -F                        # 将防火墙中的规则条目清除掉  # 注意: iptables -P INPUT ACCEPT
        iptables-restore < 规则文件        # 导入防火墙规则
        /etc/init.d/iptables save          # 保存防火墙设置
        /etc/init.d/iptables restart       # 重启防火墙服务
        iptables -L -n                     # 查看规则
        iptables -t nat -nL                # 查看转发

        iptables实例{
iptables -L -n -v --line-numbers
iptables -L INPUT -n -v --line-numbers
iptables -L OUTPUT -n -v --line-numbers
iptables -L FORWARD -n -v --line-numbers
            iptables -L INPUT                   # 列出某规则链中的所有规则
            iptables -X allowed                 # 删除某个规则链 ,不加规则链，清除所有非内建的
            iptables -Z INPUT                   # 将封包计数器归零
            iptables -N allowed                 # 定义新的规则链
            iptables -P INPUT DROP              # 定义过滤政策
            iptables -A INPUT -s 192.168.1.1    # 比对封包的来源IP   # ! 192.168.0.0/24  ! 反向对比
            iptables -A INPUT -d 192.168.1.1    # 比对封包的目的地IP
            iptables -A INPUT -i eth0           # 比对封包是从哪片网卡进入
            iptables -A FORWARD -o eth0         # 比对封包要从哪片网卡送出 eth+表示所有的网卡
            iptables -A INPUT -p tcp            # -p ! tcp 排除tcp以外的udp、icmp。-p all所有类型
            iptables -D INPUT 8                 # 从某个规则链中删除一条规则
            iptables -D INPUT --dport 80 -j DROP         # 从某个规则链中删除一条规则
            iptables -R INPUT 8 -s 192.168.0.1 -j DROP   # 取代现行规则
            iptables -I INPUT 8 --dport 80 -j ACCEPT     # 插入一条规则
            iptables -A INPUT -i eth0 -j DROP            # 其它情况不允许
            iptables -A INPUT -p tcp -s IP -j DROP       # 禁止指定IP访问
            iptables -A INPUT -p tcp -s IP --dport port -j DROP               # 禁止指定IP访问端口
            iptables -A INPUT -s IP -p tcp --dport port -j ACCEPT             # 允许在IP访问指定端口
            iptables -A INPUT -p tcp --dport 22 -j DROP                       # 禁止使用某端口
            iptables -A INPUT -i eth0 -p icmp -m icmp --icmp-type 8 -j DROP   # 禁止icmp端口
            iptables -A INPUT -i eth0 -p icmp -j DROP                         # 禁止icmp端口
            iptables -t filter -A INPUT -i eth0 -p tcp --syn -j DROP                  # 阻止所有没有经过你系统授权的TCP连接
            iptables -A INPUT -f -m limit --limit 100/s --limit-burst 100 -j ACCEPT   # IP包流量限制
            iptables -A INPUT -i eth0 -s 192.168.62.1/32 -p icmp -m icmp --icmp-type 8 -j ACCEPT  # 除192.168.62.1外，禁止其它人ping我的主机
            iptables -A INPUT -p tcp -m tcp --dport 80 -m state --state NEW -m recent --update --seconds 5 --hitcount 20 --rttl --name WEB --rsource -j DROP  # 可防御cc攻击(未测试)

        }

        iptables(iptables配置实例文件){

            # Generated by iptables-save v1.2.11 on Fri Feb  9 12:10:37 2007
            *filter
            :INPUT ACCEPT [637:58967]
            :FORWARD DROP [0:0]
            :OUTPUT ACCEPT [5091:1301533]
            # 允许的IP或IP段访问 建议多个
            -A INPUT -s 127.0.0.1 -p tcp -j ACCEPT
            -A INPUT -s 192.168.0.0/255.255.0.0 -p tcp -j ACCEPT
            # 开放对外开放端口
            -A INPUT -p tcp --dport 80 -j ACCEPT
            # 指定某端口针对IP开放
            -A INPUT -s 192.168.10.37 -p tcp --dport 22 -j ACCEPT
            # 拒绝所有协议(INPUT允许)
            -A INPUT -p tcp -m tcp --tcp-flags FIN,SYN,RST,PSH,URG RST -j DROP
            # 允许已建立的或相关连的通行
            -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
            # 拒绝ping
            -A INPUT -p tcp -m tcp -j REJECT --reject-with icmp-port-unreachable
            COMMIT
            # Completed on Fri Feb  9 12:10:37 2007

        }

        iptables(iptables配置实例){

            # 允许某段IP访问任何端口
            iptables -A INPUT -s 192.168.0.3/24 -p tcp -j ACCEPT
            # 设定预设规则 (拒绝所有的数据包，再允许需要的,如只做WEB服务器.还是推荐三个链都是DROP)
            iptables -P INPUT DROP
            iptables -P FORWARD DROP
            iptables -P OUTPUT ACCEPT
            # 注意: 直接设置这三条会掉线
            # 开启22端口
            iptables -A INPUT -p tcp --dport 22 -j ACCEPT
            # 如果OUTPUT 设置成DROP的，要写上下面一条
            iptables -A OUTPUT -p tcp --sport 22 -j ACCEPT
            # 注:不写导致无法SSH.其他的端口一样,OUTPUT设置成DROP的话,也要添加一条链
            # 如果开启了web服务器,OUTPUT设置成DROP的话,同样也要添加一条链
            iptables -A OUTPUT -p tcp --sport 80 -j ACCEPT
            # 做WEB服务器,开启80端口 ,其他同理
            iptables -A INPUT -p tcp --dport 80 -j ACCEPT
            # 做邮件服务器,开启25,110端口
            iptables -A INPUT -p tcp --dport 110 -j ACCEPT
            iptables -A INPUT -p tcp --dport 25 -j ACCEPT
            # 允许icmp包通过,允许ping
            iptables -A OUTPUT -p icmp -j ACCEPT (OUTPUT设置成DROP的话)
            iptables -A INPUT -p icmp -j ACCEPT  (INPUT设置成DROP的话)
            # 允许loopback!(不然会导致DNS无法正常关闭等问题)
            IPTABLES -A INPUT -i lo -p all -j ACCEPT (如果是INPUT DROP)
            IPTABLES -A OUTPUT -o lo -p all -j ACCEPT(如果是OUTPUT DROP)

        }

        iptables(centos6的iptables基本配置){
            *filter
            :INPUT ACCEPT [0:0]
            :FORWARD ACCEPT [0:0]
            :OUTPUT ACCEPT [0:0]
            -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
            -A INPUT -p icmp -j ACCEPT
            -A INPUT -i lo -j ACCEPT
            -A INPUT -s 222.186.135.61 -p tcp -j ACCEPT
            -A INPUT -p tcp  --dport 80 -j ACCEPT
            -A INPUT -m state --state NEW -m tcp -p tcp --dport 22 -j ACCEPT
            -A INPUT -j REJECT --reject-with icmp-host-prohibited
            -A INPUT -p tcp -m tcp --tcp-flags FIN,SYN,RST,PSH,URG RST -j DROP
            -A FORWARD -j REJECT --reject-with icmp-host-prohibited
            COMMIT
        }

        iptables(添加网段转发){

            # 例如通过vpn上网
            echo 1 > /proc/sys/net/ipv4/ip_forward       # 在内核里打开ip转发功能
            iptables -t nat -A POSTROUTING -s 10.8.0.0/24 -j MASQUERADE  # 添加网段转发
            iptables -t nat -A POSTROUTING -s 10.0.0.0/255.0.0.0 -o eth0 -j SNAT --to 192.168.10.158  # 原IP网段经过哪个网卡IP出去
            iptables -t nat -nL                # 查看转发
            
            # iptables互联网连接共享 
            echo 1> /proc/sys/net/ipv4/ip_forward  
            iptables -A FORWARD -i $1 -o $2 -s 10.10.0.0/16 -m conntrack --ctstate NEW -j ACCEPT  
            iptables -A FORWARD -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT  
            iptables -A POSTROUTING -t nat -j MASQUERADE

        }

        iptables(端口映射){

            # 内网通过有外网IP的机器映射端口
            # 内网主机添加路由
            route add -net 10.10.20.0 netmask 255.255.255.0 gw 10.10.20.111     # 内网需要添加默认网关，并且网关开启转发
            # 网关主机
            echo 1 > /proc/sys/net/ipv4/ip_forward       # 在内核里打开ip转发功能
            iptables -t nat -A PREROUTING -d 外网IP  -p tcp --dport 9999 -j DNAT --to 10.10.20.55:22    # 进入
            iptables -t nat -A POSTROUTING -s 10.10.20.0/24 -j SNAT --to 外网IP                         # 转发回去
            iptables -t nat -nL                # 查看转发

        }

    }

}

service(){
    service --status-all # + 正在运行 - 停止运行
    
    sendmail 为本地或网络交付传送邮件
    mail E-mail管理程序
    mailq 显示待寄邮件的清单
    mailstats 显示关于邮件流量的统计信息
    mutt 电子邮件管理程序

    /etc/init.d/sendmail start                   # 启动服务
    /etc/init.d/sendmail stop                    # 关闭服务
    /etc/init.d/sendmail status                  # 查看服务当前状态
    /date/mysql/bin/mysqld_safe --user=mysql &   # 启动mysql后台运行
    vi /etc/rc.d/rc.local                        # 开机启动执行  可用于开机启动脚本
    /etc/rc.d/rc3.d/S55sshd                      # 开机启动和关机关闭服务连接    # S开机start  K关机stop  55级别 后跟服务名
    ln -s -f /date/httpd/bin/apachectl /etc/rc.d/rc3.d/S15httpd   # 将启动程序脚本连接到开机启动目录
    ipvsadm -ln                                  # lvs查看后端负载机并发
    ipvsadm -C                                   # lvs清除规则
    xm list                                      # 查看xen虚拟主机列表
    virsh                                        # 虚拟化(xen\kvm)管理工具  yum groupinstall Virtual*
    ./bin/httpd -M                               # 查看httpd加载模块
    httpd -t -D DUMP_MODULES                     # rpm包httpd查看加载模块
    echo 内容| /bin/mail -s "标题" 收件箱 -f 发件人       # 发送邮件
    "`echo "内容"|iconv -f utf8 -t gbk`" | /bin/mail -s "`echo "标题"|iconv -f utf8 -t gbk`" 收件箱     # 解决邮件乱码
    /usr/local/nagios/bin/nagios -v /usr/local/nagios/etc/nagios.cfg   # 检测nagios配置文件

    chkconfig(Centos){ 服务管理
        chkconfig 服务名 on|off|set              # 设置非独立服务启状态
        chkconfig --level 35   httpd   off       # 让服务不自动启动
        chkconfig --level 35   httpd   on        # 让服务自动启动 35指的是运行级别
        chkconfig --list                         # 查看所有服务的启动状态
        chkconfig --list |grep httpd             # 查看某个服务的启动状态
        chkconfig –-list [服务名称]              # 查看服务的状态
    update-rc.d(Debian){ 服务管理
update-rc.d sshd defaults # Activate sshd with the default runlevels
update-rc.d sshd start 20 2 3 4 5 . stop 20 0 1 6 . # With explicit arguments
update-rc.d -f sshd remove # Disable sshd for all runlevels
    }
    net(Windows){ 服务管理
net command  "service name" or "service description"
net stop WSearch
net start WSearch # start search service
net stop "Windows Search"
net start "Windows Search" # same as above using descr.
    }
ntsysv chkconfig
必须开启的服务有：	crond/messagebus/network/iptables/sshd/syslog/sysstat/snmpd
关闭不必要的服务脚本：
for i in $(chkconfig --list |awk '/3:on/ {print $1}'|grep -v "crond\|messagebus\|sshd\|iptables\|network\|syslog\|snmpd\|sysstat"); 
  do  chkconfig --level 345 ${i} off; 
done
开启需要的服务脚本：
for i in "crond" "messagebus" "iptables" "network" "snmpd" "sshd" "syslog" "sysstat";
  do  chkconfig --level 345 ${i} on; 
done
    }
    inxi()                                          -x -A     -x -G    -xx -A
    {                                               -x -A     -x -i    -xx -B
        inxi -<color> -<option>                     -x -B     -x -I    -xx -D
        inxi -c4 -I               #-c指定显示颜色   -x -C     -x -m    -xx -G
        inxi -v4 -c6                                -x -d     -x -N    -xx -I
        inxi -bDc 6                                 -x -D     -x -R    -xx -m
        -A 声卡信息                                           -x -S    -xx -M
        -b #inxi -v 2 简短输出 #-x                            -x -t    -xx -N
        -B #电池信息。依赖dmidecode                           -x -w    -xx -R
        -c [0-32] #可以获得的配色主题；                                -xx -S
           0-42   # 正常可以支持的配色主题                             -xx -w
        -c [94-99] # 选择不同显示的配色主题                            -xx -@
        -c 94 - Console, out of X.
                # -c 95 - Terminal, running in X - like xTerm.
                # -c 96 - Gui IRC, running in X - like Xchat, Quassel, Konversation etc.
                # -c 97 - Console IRC running in X - like irssi in xTerm.
                # -c 98 - Console IRC not in X.
                # -c 99 - Global - Overrides/removes all settings.
        -C  # -x -xx             CPU信息
        -d  # -x -xx 等同于-Dd   磁盘信息
        -D  # total + used percentage 磁盘信息
        -f  # cpu flags
        -F  # 等同于 -d -f -l -m -o -p -r -t -u -x; 显示整体配置信息，可以添加-s 和 -n
        -G  # 显卡信息
        -h --help # 帮助提示
        -H # 开发者帮助
        -i # 网卡信息， 等同于 -Nni. 依赖ifconfig
        -I # 启动时间，内存信息，运行级别， -x and -xx
        -l # 分区label 简要-P 详细-p 或者 -pl (or -plu)
        -m # 内存 依赖 dmidecode
        -M # 机器信息
        -n # 网络接口信息 -Nn.
        -N # -x PCI BUS driver
        -o # mount的磁盘及分区信息
        -p # 分区简要信息
        -P # 分区简要信息
        -R # RAID卡
        -s # sensors 
        -S # System information: 
        -t # -t [c or m or cm or mc NUMBER] CPU和内存
        -u # 磁盘UUID
        -v 0 # inxi CPU Mem Kernel HDD Process Client inix version
        -v 1 # System CPU Graphics Devices Info
        -v 2 # System Machine CPU Graphics Network Devices Info
        -v 3 # System Machine CPU Graphics Network Devices Info #-x;
        -v 4 # System Machine CPU Graphics Network Devices Partition Info
        -v 5 # System Machine CPU Graphics Audio Network Devices Partition  RAID Sensors Info
        -v 6 # System Machine CPU Graphics Audio Network Devices Partition  RAID Unmount Sensors Info -xx
        -v 7 # System Machine CPU Graphics Audio Network Devices Partition  RAID Unmount Sensors Info -xxxx
        -w   # 天气信息
    }
    inxi(debug)
    {
-% Overrides defective or corrupted data.
-@ Triggers debugger output. Requires debugging level 1-14 
-@ [1-7] - On screen debugger output.
-@ 8 - Basic logging. Check /home/yourname/.inxi/inxi*.log
-@ 9 - Full file/sys info logging.
-@ 10 - Color logging.
-@ <11-14> The following create a tar.gz file of system data, 
inxi -xx@ <11-14>
For alternate ftp upload locations: Example:
inxi -! ftp.yourserver.com/incoming -xx@ 14
-@ 11 - With data file of xiin read of /sys
-@ 12 - With xorg conf and log data, xrandr, xprop, xdpyinfo, glxinfo etc.
-@ 13 - With data from dev, disks, partitions, etc., plus xiin data file.
-@ 14 - Everything, full data collection.
    }
    
    
    nginx(){

        yum install -y make gcc  openssl-devel pcre-devel  bzip2-devel libxml2 libxml2-devel curl-devel libmcrypt-devel libjpeg libjpeg-devel libpng libpng-devel openssl

        groupadd nginx
        useradd nginx -g nginx -M -s /sbin/nologin

        mkdir -p /opt/nginx-tmp

        wget http://labs.frickle.com/files/ngx_cache_purge-1.6.tar.gz
        tar fxz ngx_cache_purge-1.6.tar.gz
        # ngx_cache_purge 清除指定url缓存
        # 假设一个URL为 http://192.168.12.133/test.txt
        # 通过访问      http://192.168.12.133/purge/test.txt  就可以清除该URL的缓存。

        tar zxvpf nginx-1.4.4.tar.gz
        cd nginx-1.4.4

        # ./configure --help
        # --with                 # 默认不加载 需指定编译此参数才使用
        # --without              # 默认加载，可用此参数禁用
        # --add-module=path      # 添加模块的路径
        # --add-module=/opt/ngx_module_upstream_check \         # nginx 代理状态页面
        # ngx_module_upstream_check  编译前需要打对应版本补丁 patch -p1 < /opt/nginx_upstream_check_module/check_1.2.6+.patch
        # --add-module=/opt/ngx_module_memc \                   # 将请求页面数据存放在 memcached中
        # --add-module=/opt/ngx_module_lua \                    # 支持lua脚本 yum install lua-devel lua

        ./configure \
        --user=nginx \
        --group=nginx \
        --prefix=/usr/local/nginx \
        --with-http_ssl_module \
        --with-http_realip_module \
        --with-http_gzip_static_module \
        --with-http_stub_status_module \
        --add-module=/opt/ngx_cache_purge-1.6 \
        --http-client-body-temp-path=/opt/nginx-tmp/client \
        --http-proxy-temp-path=/opt/nginx-tmp/proxy \
        --http-fastcgi-temp-path=/opt/nginx-tmp/fastcgi \
        --http-uwsgi-temp-path=/opt/nginx-tmp/uwsgi \
        --http-scgi-temp-path=/opt/nginx-tmp/scgi

        make && make install

        /usr/local/nginx/sbin/nginx -t             # 检查Nginx配置文件 但并不执行
        /usr/local/nginx/sbin/nginx -t -c /opt/nginx/conf/nginx.conf  # 检查Nginx配置文件
        /usr/local/nginx/sbin/nginx                # 启动nginx
        /usr/local/nginx/sbin/nginx -s reload      # 重载配置
        /usr/local/nginx/sbin/nginx -s stop        # 关闭nginx服务

    }
    python -m SimpleHTTPServer       #.以HTTP方式共享当前文件夹的文件 http://localhost:8000/
    python -m SimpleHTTPServer 8080  # http://localhost:8080/
    python -m http.server 7777       # Python3
    python -m smtpd -n -c DebuggingServer localhost:25 #用 python 快速开启一个 SMTP 服务
 
    httpd(){

        编译参数{

            # so模块用来提供DSO支持的apache核心模块
            # 如果编译中包含任何DSO模块，则mod_so会被自动包含进核心。
            # 如果希望核心能够装载DSO，但不实际编译任何DSO模块，则需明确指定"--enable-so=static"

            ./configure --prefix=/usr/local/apache --enable-so --enable-mods-shared=most --enable-rewrite --enable-forward  # 实例编译

            --with-mpm=worker         # 已worker方式运行
            --with-apxs=/usr/local/apache/bin/apxs  # 制作apache的动态模块DSO rpm包 httpd-devel  #编译模块 apxs -i -a -c mod_foo.c
            --enable-so               # 让Apache可以支持DSO模式
            --enable-mods-shared=most # 告诉编译器将所有标准模块都动态编译为DSO模块
            --enable-rewrite          # 支持地址重写功能
            --enable-module=most      # 用most可以将一些不常用的，不在缺省常用模块中的模块编译进来
            --enable-mods-shared=all  # 意思是动态加载所有模块，如果去掉-shared话，是静态加载所有模块
            --enable-expires          # 可以添加文件过期的限制，有效减轻服务器压力，缓存在用户端，有效期内不会再次访问服务器，除非按f5刷新，但也导致文件更新不及时
            --enable-deflate          # 压缩功能，网页可以达到40%的压缩，节省带宽成本，但会对cpu压力有一点提高
            --enable-headers          # 文件头信息改写，压缩功能需要
            --disable-MODULE          # 禁用MODULE模块(仅用于基本模块)
            --enable-MODULE=shared    # 将MODULE编译为DSO(可用于所有模块)
            --enable-mods-shared=MODULE-LIST   # 将MODULE-LIST中的所有模块都编译成DSO(可用于所有模块)
            --enable-modules=MODULE-LIST       # 将MODULE-LIST静态连接进核心(可用于所有模块)

            # 上述 MODULE-LIST 可以是:
            1、用引号界定并且用空格分隔的模块名列表  --enable-mods-shared='headers rewrite dav'
            2、"most"(大多数模块)  --enable-mods-shared=most
            3、"all"(所有模块)

        }

        转发{

            #针对非80端口的请求处理
            RewriteCond %{SERVER_PORT} !^80$
            RewriteRule ^/(.*)         http://fully.qualified.domain.name:%{SERVER_PORT}/$1 [L,R]

            RewriteCond %{HTTP_HOST} ^ss.aa.com [NC]
            RewriteRule  ^(.*)  http://www.aa.com/so/$1/0/p0?  [L,R=301]
            #RewriteRule 只对?前处理，所以会把?后的都保留下来
            #在转发后地址后加?即可取消RewriteRule保留的字符
            #R的含义是redirect，即重定向，该请求不会再被apache交给后端处理，而是直接返回给浏览器进行重定向跳转。301是返回的http状态码，具体可以参考http rfc文档，跳转都是3XX。
            #L是last，即最后一个rewrite规则，如果请求被此规则命中，将不会继续再向下匹配其他规则。
        }

    }

mysql(config){

#run sql statement
function runsql(){
	dbUserName="-uroot"
	dbPwd="-proot@mysql"
	dbName="inv_join_grp"
	dbContext="${dbUserName} ${dbPwd} ${dbName}"
	echo $*|mysql ${dbContext};
}
#使用示例
runsql [u sql statement]
runsql "select * from myTableName"
这里需要注意一点，shell编程中变量含有星号*，被解释成当前目录下的文件列表，容易出现如下错误：
sql="select * from mytable"
echo "execute sql =" ${sql}
}


mysql(){ Change mysql root or username password

Method 1
# /etc/init.d/mysql stop
or
# killall mysqld
# mysqld --skip-grant-tables
# mysqladmin -u root password 'newpasswd'
# /etc/init.d/mysql start

Method 2
# mysql -u root mysql
mysql> UPDATE USER SET PASSWORD=PASSWORD("newpassword") where user='root';
mysql> FLUSH PRIVILEGES;                           # Use username instead of "root"
mysql> quit

}
# 192.168.10.117 email 服务器
mysql -uroot --password="ld123()"
    mysql(){
MySQL修改root密码
    mysql -u root 
    mysql> SET PASSWORD FOR 'root'@'localhost' = PASSWORD('newpass');
MySQL常用命令 
    > mysql -uroot -p 
    use <database_name>; 
    show tables; 
    show columns from <table_name>; 
    select * from <table_name> into outfile '/tmp/output.txt';

    }
    mysql(源码安装){
        groupadd mysql
        useradd mysql -g mysql -M -s /bin/false
        tar zxvf mysql-5.0.22.tar.gz
        cd mysql-5.0.22
        ./configure  --prefix=/usr/local/mysql \
        --with-client-ldflags=-all-static \
        --with-mysqld-ldflags=-all-static \
        --with-mysqld-user=mysql \
        --with-extra-charsets=all \
        --with-unix-socket-path=/var/tmp/mysql.sock
        make  &&   make  install
        # 生成mysql用户数据库和表文件，在安装包中输入
        scripts/mysql_install_db  --user=mysql
        vi ~/.bashrc  # 在用户的目录下".profile"和".bashrc"会默认地被调用作为用户配置。
        export PATH="$PATH: /usr/local/mysql/bin"
        # 配置文件,有large,medium,small三个，根据机器性能选择
        cp support-files/my-medium.cnf /etc/my.cnf
        cp support-files/mysql.server /etc/init.d/mysqld
        chmod 700 /etc/init.d/mysqld
        cd /usr/local
        chmod 750 mysql -R
        chgrp mysql mysql -R
        chown mysql mysql/var -R
        cp  /usr/local/mysql/libexec/mysqld mysqld.old
        ln -s /usr/local/mysql/bin/mysql /sbin/mysql
        ln -s /usr/local/mysql/bin/mysqladmin /sbin/mysqladmin
        ln -s -f /usr/local/mysql/bin/mysqld_safe /etc/rc.d/rc3.d/S15mysql5
        ln -s -f /usr/local/mysql/bin/mysqld_safe /etc/rc.d/rc0.d/K15mysql5
    }

    mysql(常用命令){

        ./mysql/bin/mysqld_safe --user=mysql &   # 启动mysql服务
        ./mysql/bin/mysqladmin -uroot -p -S ./mysql/data/mysql.sock shutdown    # 停止mysql服务
        mysqlcheck -uroot -p -S mysql.sock --optimize --databases account       # 检查、修复、优化MyISAM表
        mysqlcheck -o <databasename> #整理你的数据库
        mysqlbinlog slave-relay-bin.000001              # 查看二进制日志(报错加绝对路径)
        mysqladmin -h myhost -u root -p create dbname   # 创建数据库

        flush privileges;             # 刷新
        show databases;               # 显示所有数据库
        use dbname;                   # 打开数据库
        show tables;                  # 显示选中数据库中所有的表
        desc tables;                  # 查看表结构
        drop database name;           # 删除数据库
        drop table name;              # 删除表
        create database name;         # 创建数据库
        select 列名称 from 表名称;      # 查询
        show processlist;             # 查看mysql进程
        show full processlist;        # 显示进程全的语句
        select user();                # 查看所有用户
        show slave status\G;          # 查看主从状态
        show variables;               # 查看所有参数变量
        show status;                  # 运行状态
        show table status             # 查看表的引擎状态
        show grants for dbbackup@'localhost';           # 查看用户权限
        drop table if exists user                       # 表存在就删除
        create table if not exists user                 # 表不存在就创建
        select host,user,password from user;            # 查询用户权限 先use mysql
        create table ka(ka_id varchar(6),qianshu int);  # 创建表
        show variables like 'character_set_%';          # 查看系统的字符集和排序方式的设定
        show variables like '%timeout%';                # 查看超时(wait_timeout)
        delete from user where user='';                 # 删除空用户
        delete from user where user='sss' and host='localhost' ;    # 删除用户
        drop user 'sss'@'localhost';                                # 使用此方法删除用户更为靠谱
        ALTER TABLE mytable ENGINE = MyISAM ;                       # 改变现有的表使用的存储引擎
        SHOW TABLE STATUS from  库名  where Name='表名';              # 查询表引擎
        mysql -uroot -p -A -ss -h10.10.10.5 -e "show databases;"    # shell中获取数据不带表格 -ss参数
        CREATE TABLE innodb (id int, title char(20)) ENGINE = INNODB                     # 创建表指定存储引擎的类型(MyISAM或INNODB)
        grant replication slave on *.* to '用户'@'%' identified by '密码';               # 创建主从复制用户
        ALTER TABLE player ADD INDEX weekcredit_faction_index (weekcredit, faction);     # 添加索引
        alter table name add column accountid(列名)  int(11) NOT NULL(字段不为空);          # 插入字段
        update host set monitor_state='Y',hostname='xuesong' where ip='192.168.1.1';     # 更新数据

        自增表{

            create table xuesong  (id INTEGER  PRIMARY KEY AUTO_INCREMENT, name CHAR(30) NOT NULL, age integer , sex CHAR(15) );  # 创建自增表
            insert into xuesong(name,age,sex) values(%s,%s,%s)  # 自增插入数据

        }

        登录mysql的命令{

            # 格式： mysql -h 主机地址 -u 用户名 -p 用户密码
            mysql -h110.110.110.110 -P3306 -uroot -p
            mysql -uroot -p -S /data1/mysql5/data/mysql.sock -A  --default-character-set=GBK

        }

        shell执行mysql命令{
        
            mysql -u root -p'123' xuesong < file.sql   # 针对指定库执行sql文件中的语句,好处不需要转义特殊符号,一条语句可以换行.不指定库执行时语句中需要先use
            mysql -u$username -p$passwd -h$dbhost -P$dbport -A -e "
            use $dbname;
            delete from data where date=('$date1');
            "    # 执行多条mysql命令
            mysql -uroot -p -S mysql.sock -e "use db;alter table gift add column accountid  int(11) NOT NULL;flush privileges;"    # 不登陆mysql插入字段

        }

        备份数据库{

            mysqldump -h host -u root -p --default-character-set=utf8 dbname >dbname_backup.sql               # 不包括库名，还原需先创建库，在use
            mysqldump -h host -u root -p --database --default-character-set=utf8 dbname >dbname_backup.sql    # 包括库名，还原不需要创建库
            /bin/mysqlhotcopy -u root -p    # mysqlhotcopy只能备份MyISAM引擎
            mysqldump -u root -p -S mysql.sock --default-character-set=utf8 dbname table1 table2  > /data/db.sql    # 备份表
            mysqldump -uroot -p123  -d database > database.sql    # 备份数据库结构

            # 最小权限备份
            grant select on db_name.* to dbbackup@"localhost" Identified by "passwd";
            # --single-transaction  InnoDB有时间戳 只备份开始那一刻的数据,备份过程中的数据不会备份
            mysqldump -hlocalhost -P 3306 -u dbbackup --single-transaction  -p"passwd" --database dbname >dbname.sql

            # xtrabackup备份需单独安装软件 优点: 速度快,压力小,可直接恢复主从复制
            innobackupex --user=root --password="" --defaults-file=/data/mysql5/data/my_3306.cnf --socket=/data/mysql5/data/mysql.sock --slave-info --stream=tar --tmpdir=/data/dbbackup/temp /data/dbbackup/ 2>/data/dbbackup/dbbackup.log | gzip 1>/data/dbbackup/db50.tar.gz

        }

        还原数据库{

            mysql -h host -u root -p dbname < dbname_backup.sql
            source 路径.sql   # 登陆mysql后还原sql文件

        }

        赋权限{

            # 指定IP: $IP  本机: localhost   所有IP地址: %   # 通常指定多条
            grant all on zabbix.* to user@"$IP";             # 对现有账号赋予权限
            grant select on database.* to user@"%" Identified by "passwd";     # 赋予查询权限(没有用户，直接创建)
            grant all privileges on database.* to user@"$IP" identified by 'passwd';         # 赋予指定IP指定用户所有权限(不允许对当前库给其他用户赋权限)
            grant all privileges on database.* to user@"localhost" identified by 'passwd' with grant option;   # 赋予本机指定用户所有权限(允许对当前库给其他用户赋权限)
            grant select, insert, update, delete on database.* to user@'ip'identified by "passwd";   # 开放管理操作指令
            revoke all on *.* from user@localhost;     # 回收权限

        }

        更改密码{
            update user set password=password('passwd') where user='root'
            mysqladmin -u root password 'xuesong'
        }

        mysql忘记密码后重置{
            cd /data/mysql5
            /data/mysql5/bin/mysqld_safe --user=mysql --skip-grant-tables --skip-networking &
            use mysql;
            update user set password=password('123123') where user='root';
        }{
        skip-grant-tables >> /etc/my.cnf # [mysqld]
        /etc/init.d/mysql restart
        mysql -u root -p -S /tmp/mysql3306.sock 或
        mysql -u root -p -S /var/lib/mysql/mysql.sock
        
        use mysql;
        update user set password=password('123123') where user='root';
        
        使用ALTER修改root用户密码；
        ALTER user 'root'@'localhost' IDENTIFIED BY 'Qian123#'
        }

        mysql主从复制失败恢复{

            slave stop;
            reset slave;
            change master to master_host='10.10.10.110',master_port=3306,master_user='repl',master_password='repl',master_log_file='master-bin.000010',master_log_pos=107,master_connect_retry=60;
            slave start;

        }

        sql语句使用变量{

            use xuesong;
            set @a=concat('my',weekday(curdate()));    # 组合时间变量
            set @sql := concat('CREATE TABLE IF NOT EXISTS ',@a,'( id INT(11) NOT NULL )');   # 组合sql语句
            select @sql;                    # 查看语句
            prepare create_tb from @sql;    # 准备
            execute create_tb;              # 执行

        }

        检测mysql主从复制延迟{

            1、在从库定时执行更新主库中的一个timeout数值
            2、同时取出从库中的timeout值对比判断从库与主库的延迟

        }

        mysql慢查询{

            select * from information_schema.processlist where command in ('Query') and time >5\G      # 查询操作大于5S的进程

            开启慢查询日志{

                # 配置文件 /etc/my.conf
                [mysqld]
                log-slow-queries=/var/lib/mysql/slowquery.log         # 指定日志文件存放位置，可以为空，系统会给一个缺省的文件host_name-slow.log
                long_query_time=5                                     # 记录超过的时间，默认为10s
                log-queries-not-using-indexes                         # log下来没有使用索引的query,可以根据情况决定是否开启  可不加
                log-long-format                                       # 如果设置了，所有没有使用索引的查询也将被记录    可不加
                # 直接修改生效
                show variables like "%slow%";                         # 查看慢查询状态
                set global slow_query_log='ON';                       # 开启慢查询日志 变量可能不同，看上句查询出来的变量

            }

            mysqldumpslow慢查询日志查看{

                -s  # 是order的顺序，包括看了代码，主要有 c,t,l,r和ac,at,al,ar，分别是按照query次数，时间，lock的时间和返回的记录数来排序，前面加了a的时倒序
                -t  # 是top n的意思，即为返回前面多少条的数据
                -g  # 后边可以写一个正则匹配模式，大小写不敏感的

                mysqldumpslow -s c -t 20 host-slow.log                # 访问次数最多的20个sql语句
                mysqldumpslow -s r -t 20 host-slow.log                # 返回记录集最多的20个sql
                mysqldumpslow -t 10 -s t -g "left join" host-slow.log # 按照时间返回前10条里面含有左连接的sql语句

                show global status like '%slow%';                     # 查看现在这个session有多少个慢查询
                show variables like '%slow%';                         # 查看慢查询日志是否开启，如果slow_query_log和log_slow_queries显示为on，说明服务器的慢查询日志已经开启
                show variables like '%long%';                         # 查看超时阀值
                desc select * from wei where text='xishizhaohua'\G;   # 扫描整张表 tepe:ALL  没有使用索引 key:NULL
                create index text_index on wei(text);                 # 创建索引

            }

        }

        mysql操作次数查询{

            select * from information_schema.global_status;

            com_select
            com_delete
            com_insert
            com_update

        }

    }

    mongodb{

        一、启动{

            # 不启动认证
            ./mongod --port 27017 --fork --logpath=/opt/mongodb/mongodb.log --logappend --dbpath=/opt/mongodb/data/
            # 启动认证
            ./mongod --port 27017 --fork --logpath=/opt/mongodb/mongodb.log --logappend --dbpath=/opt/mongodb/data/ --auth

            # 配置文件方式启动
            cat /opt/mongodb/mongodb.conf
              port=27017                       # 端口号
              fork=true                        # 以守护进程的方式运行，创建服务器进程
              auth=true                        # 开启用户认证
              logappend=true                   # 日志采用追加方式
              logpath=/opt/mongodb/mongodb.log # 日志输出文件路径
              dbpath=/opt/mongodb/data/        # 数据库路径
              shardsvr=true                    # 设置是否分片
              maxConns=600                     # 数据库的最大连接数
            ./mongod -f /opt/mongodb/mongodb.conf

            # 其他参数
            bind_ip         # 绑定IP  使用mongo登录需要指定对应IP
            journal         # 开启日志功能,降低单机故障的恢复时间,取代dur参数
            syncdelay       # 系统同步刷新磁盘的时间,默认60秒
            directoryperdb  # 每个db单独存放目录,建议设置.与mysql独立表空间类似
            repairpath      # 执行repair时的临时目录.如果没开启journal,出现异常重启,必须执行repair操作
            # mongodb没有参数设置内存大小.使用os mmap机制缓存数据文件,在数据量不超过内存的情况下,效率非常高.数据量超过系统可用内存会影响写入性能

        }

        二、关闭{

            # 方法一:登录mongodb
            ./mongo
            use admin
            db.shutdownServer()

            # 方法:kill传递信号  两种皆可
            kill -2 pid
            kill -15 pid

        }

        三、开启认证与用户管理{

            ./mongo                      # 先登录
            use admin                    # 切换到admin库
            db.addUser("root","123456")                     # 创建用户
            db.addUser('zhansan','pass',true)               # 如果用户的readOnly为true那么这个用户只能读取数据，添加一个readOnly用户zhansan
            ./mongo 127.0.0.1:27017/mydb -uroot -p123456    # 再次登录,只能针对用户所在库登录
            #虽然是超级管理员，但是admin不能直接登录其他数据库，否则报错
            #Fri Nov 22 15:03:21.886 Error: 18 { code: 18, ok: 0.0, errmsg: "auth fails" } at src/mongo/shell/db.js:228
            show collections                                # 查看链接状态 再次登录使用如下命令,显示错误未经授权
            db.system.users.find();                         # 查看创建用户信息
            db.system.users.remove({user:"zhansan"})        # 删除用户

            #恢复密码只需要重启mongodb 不加--auth参数

        }

        四、登录{

            192.168.1.5:28017      # http登录后可查看状态
            ./mongo                # 默认登录后打开 test 库
            ./mongo 192.168.1.5:27017/databaseName      # 直接连接某个库 不存在则创建  启动认证需要指定对应库才可登录

        }

        五、查看状态{

            #登录后执行命令查看状态
            db.runCommand({"serverStatus":1})
                globalLock         # 表示全局写入锁占用了服务器多少时间(微秒)
                mem                # 包含服务器内存映射了多少数据,服务器进程的虚拟内存和常驻内存的占用情况(MB)
                indexCounters      # 表示B树在磁盘检索(misses)和内存检索(hits)的次数.如果这两个比值开始上升,就要考虑添加内存了
                backgroudFlushing  # 表示后台做了多少次fsync以及用了多少时间
                opcounters         # 包含每种主要擦撞的次数
                asserts            # 统计了断言的次数

            #状态信息从服务器启动开始计算,如果过大就会复位,发送复位，所有计数都会复位,asserts中的roolovers值增加

            #mongodb自带的命令
            ./mongostat
                insert     #每秒插入量
                query      #每秒查询量
                update     #每秒更新量
                delete     #每秒删除量
                locked     #锁定量
                qr|qw      #客户端查询排队长度(读|写)
                ar|aw      #活跃客户端量(读|写)
                conn       #连接数
                time       #当前时间

        }

        六、常用命令{

            db.listCommands()     # 当前MongoDB支持的所有命令(同样可通过运行命令db.runCommand({"listCommands" : `1})来查询所有命令)

            db.runCommand({"buildInfo" : 1})                # 返回MongoDB服务器的版本号和服务器OS的相关信息。
            db.runCommand({"collStats" : 集合名})           # 返回该集合的统计信息，包括数据大小，已分配存储空间大小，索引的大小等。
            db.runCommand({"distinct" : 集合名, "key" : 键, "query" : 查询文档})     # 返回特定文档所有符合查询文档指定条件的文档的指定键的所有不同的值。
            db.runCommand({"dropDatabase" : 1})             # 清空当前数据库的信息，包括删除所有的集合和索引。
            db.runCommand({"isMaster" : 1})                 # 检查本服务器是主服务器还是从服务器。
            db.runCommand({"ping" : 1})                     # 检查服务器链接是否正常。即便服务器上锁，该命令也会立即返回。
            db.runCommand({"repaireDatabase" : 1})          # 对当前数据库进行修复并压缩，如果数据库特别大，这个命令会非常耗时。
            db.runCommand({"serverStatus" : 1})             # 查看这台服务器的管理统计信息。
            # 某些命令必须在admin数据库下运行，如下两个命令：
            db.runCommand({"renameCollection" : 集合名, "to"：集合名})     # 对集合重命名，注意两个集合名都要是完整的集合命名空间，如foo.bar, 表示数据库foo下的集合bar。
            db.runCommand({"listDatabases" : 1})                           # 列出服务器上所有的数据库

        }

        七、进程控制{

            db.currentOp()                  # 查看活动进程
            db.$cmd.sys.inprog.findOne()    # 查看活动进程 与上面一样
                opid   # 操作进程号
                op     # 操作类型(查询\更新)
                ns     # 命名空间,指操作的是哪个对象
                query  # 如果操作类型是查询,这里将显示具体的查询内容
                lockType  # 锁的类型,指明是读锁还是写锁

            db.killOp(opid值)                         # 结束进程
            db.$cmd.sys.killop.findOne({op:opid值})   # 结束进程

        }

        八、备份还原{

            ./mongoexport -d test -c t1 -o t1.dat                 # 导出JSON格式
                -c         # 指明导出集合
                -d         # 使用库
            ./mongoexport -d test -c t1 -csv -f num -o t1.dat     # 导出csv格式
                -csv       # 指明导出csv格式
                -f         # 指明需要导出那些例

            db.t1.drop()                    # 登录后删除数据
            ./mongoimport -d test -c t1 -file t1.dat                           # mongoimport还原JSON格式
            ./mongoimport -d test -c t1 -type csv --headerline -file t1.dat    # mongoimport还原csv格式数据
                --headerline                # 指明不导入第一行 因为第一行是列名

            ./mongodump -d test -o /bak/mongodump                # mongodump数据备份
            ./mongorestore -d test --drop /bak/mongodump/*       # mongorestore恢复
                --drop      #恢复前先删除
            db.t1.find()    #查看

            # mongodump 虽然能不停机备份,但市区了获取实时数据视图的能力,使用fsync命令能在运行时复制数据目录并且不会损坏数据
            # fsync会强制服务器将所有缓冲区的数据写入磁盘.配合lock还阻止对数据库的进一步写入,知道释放锁为止
            # 备份在从库上备份，不耽误读写还能保证实时快照备份
            db.runCommand({"fsync":1,"lock":1})   # 执行强制更新与写入锁
            db.$cmd.sys.unlock.findOne()          # 解锁
            db.currentOp()                        # 查看解锁是否正常

        }

        九、修复{

            # 当停电或其他故障引起不正常关闭时,会造成部分数据损坏丢失
            ./mongod --repair      # 修复操作:启动时候加上 --repair
            # 修复过程:将所有文档导出,然后马上导入,忽略无效文档.完成后重建索引。时间较长,会丢弃损坏文档
            # 修复数据还能起到压缩数据库的作用
            db.repairDatabase()    # 运行中的mongodb可使用 repairDatabase 修复当前使用的数据库
            {"repairDatabase":1}   # 通过驱动程序

        }

        十、python使用mongodb{

            原文: http://blog.nosqlfan.com/html/2989.html

            easy_install pymongo      # 安装(python2.7+)
            import pymongo
            connection=pymongo.Connection('localhost',27017)   # 创建连接
            db = connection.test_database                      # 切换数据库
            collection = db.test_collection                    # 获取collection
            # db和collection都是延时创建的，在添加Document时才真正创建

            文档添加, _id自动创建
                import datetime
                post = {"author": "Mike",
                    "text": "My first blog post!",
                    "tags": ["mongodb", "python", "pymongo"],
                    "date": datetime.datetime.utcnow()}
                posts = db.posts
                posts.insert(post)
                ObjectId('...')

            批量插入
                new_posts = [{"author": "Mike",
                    "text": "Another post!",
                    "tags": ["bulk", "insert"],
                    "date": datetime.datetime(2009, 11, 12, 11, 14)},
                    {"author": "Eliot",
                    "title": "MongoDB is fun",
                    "text": "and pretty easy too!",
                    "date": datetime.datetime(2009, 11, 10, 10, 45)}]
                posts.insert(new_posts)
                [ObjectId('...'), ObjectId('...')]

            获取所有collection
                db.collection_names()    # 相当于SQL的show tables

            获取单个文档
                posts.find_one()

            查询多个文档
                for post in posts.find():
                    post

            加条件的查询
                posts.find_one({"author": "Mike"})

            高级查询
                posts.find({"date": {"$lt": "d"}}).sort("author")

            统计数量
                posts.count()

            加索引
                from pymongo import ASCENDING, DESCENDING
                posts.create_index([("date", DESCENDING), ("author", ASCENDING)])

            查看查询语句的性能
                posts.find({"date": {"$lt": "d"}}).sort("author").explain()["cursor"]
                posts.find({"date": {"$lt": "d"}}).sort("author").explain()["nscanned"]

        }

    }

    JDK安装{

        chmod 744 jdk-1.7.0_79-linux-i586.bin
        ./jdk-1.7.0_79-linux-i586.bin
        vi /etc/profile   # 添加环境变量
        JAVA_HOME=/usr/java/jdk1.7.0_79
        CLASSPATH=.:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/tools.jar
        PATH=$JAVA_HOME/bin:$PATH
        export JAVA_HOME PATH CLASSPATH

        . /etc/profile    # 加载新的环境变量
        jps -ml           # 查看java进程
    }
    JDK(){
1.官网下载JDK
    网址: http://www.oracle.com/technetwork/articles/javase/index-jsp-138363.html
    选择相应的 .gz包下载 (这里我选择了"jdk-8u92-linux-i586.tar.gz")
2.解压缩,放到指定目录(以jdk-8u92-linux-i586.tar.gz为例)

    创建目录
    sudo mkdir /home/kumho/usr/lib/jvm
    解压文件至目录
    sudo tar -zxvf jdk-8u92-linux-i586.tar.gz -C /home/kumho/usr/lib/jvm

3. 修改环境变量
    sudo vim ~/.bashrc
    文件的末尾追加下面内容:
    
    #set oracle jdk environment 
    export JAVA_HOME=/home/kumho/usr/lib/jvm/jdk1.8.0_92  ##这里要注意目录要换成自己解压的jdk 目录
    export JRE_HOME=${JAVA_HOME}/jre 
    export CLASSPATH=.:${JAVA_HOME}/lib:${JRE_HOME}/lib
    export PATH=${JAVA_HOME}/bin:$PATH
    
    使环境变量马上生效source ~/.bashrc
4.设置系统默认jdk 版本
    sudo update-alternatives --install /usr/bin/java java /home/kumho/usr/lib/jvm/jdk1.8.0_92/bin/java 300
    sudo update-alternatives --install /usr/bin/javac javac /home/kumho/usr/lib/jvm/jdk1.8.0_92/bin/javac 300
    sudo update-alternatives --install /usr/bin/jar jar /home/kumho/usr/lib/jvm/jdk1.8.0_92/bin/jar 300
    sudo update-alternatives --install /usr/bin/javah javah /home/kumho/usr/lib/jvm/jdk1.8.0_92/bin/javah 300
    sudo update-alternatives --install /usr/bin/javap javap /home/kumho/usr/lib/jvm/jdk1.8.0_92/bin/javap 300
    然后执行:
    sudo update-alternatives --config java
    若是初次安装jdk,会有下面的提示
    There is only one alternative in link group java (providing /usr/bin/java):
    /home/kumho/usr/lib/jvm/jdk1.8.0_92/bin/java
    否则,选择合适的jdk
    }
    redis动态加内存{

        ./redis-cli -h 10.10.10.11 -p 6401
        save                                # 保存当前快照
        config get *                        # 列出所有当前配置
        config get maxmemory                # 查看指定配置
        config set maxmemory  15360000000   # 动态修改最大内存配置参数

    }

    nfs{
# 注意，rpc的远程procedure调用的概念不是在本地向远程主机发起procedure的调用，而是将要执行的procedure
# 包装后通过rpc发送出去，让远程主机上的对应程序自己去执行procedure并返回数据。也就是说rpc的作用是
# 封装和发送，而不是发起调用。
        # 依赖rpc服务通信 portmap[centos5] 或 rpcbind[centos6]
        yum install nfs-utils portmap    # centos5安装
        yum install nfs-utils rpcbind    # centos6安装

        vim /etc/exports                 # 配置文件
        # sync                           # 同步写入
        # async                          # 暂存并非直接写入
        # no_root_squash                 # 开放用户端使用root身份操作
        # root_squash                    # 使用者身份为root则被压缩成匿名使用,即nobody,相对安全
        # all_squash                     # 所有NFS的使用者身份都被压缩为匿名
        /data/images 10.10.10.0/24(rw,sync,no_root_squash)

        service  portmap restart         # 重启centos5的nfs依赖的rpc服务
        service  rpcbind restart         # 重启centos6的nfs依赖的rpc服务
        service  nfs restart             # 重启nfs服务  确保依赖 portmap 或 rpcbind 服务已启动
        service  nfs reload              # 重载NFS服务配置文件
        showmount -e                     # 服务端查看自己共享的服务
        showmount -a                     # 显示已经与客户端连接上的目录信息
        showmount -e 10.10.10.3          # 列出服务端可供使用的NFS共享  客户端测试能否访问nfs服务
        mount -t nfs 10.10.10.3:/data/images/  /data/img   # 挂载nfs  如果延迟影响大加参数 noac

        # 服务端的 portmap 或 rpcbind 被停止后，nfs仍然工作正常，但是umout财会提示： not found / mounted or server not reachable  重启服务器的portmap 或 rpcbind 也无济于事。 nfs也要跟着重启，否则nfs工作仍然是不正常的。
        # 同时已挂载会造成NFS客户端df卡住和挂载目录无法访问。请先用 mount 查看当前挂载情况，记录挂载信息，在强制卸载挂载目录，重新挂载
        umount -f /data/img/             # 强制卸载挂载目录  如还不可以  umount -l /data/img/

        nfsstat -c                       # 客户机发送和拒绝的RPC和NFS调用数目的信息
        nfsstat -cn                      # 显示和打印与客户机NFS调用相关的信息
        nfsstat -r                       # 显示和打印客户机和服务器的与RPC调用相关的信息
        nfsstat -s                       # 显示关于服务器接收和拒绝的RPC和NFS调用数目的信息
        
exportfs 
-a # 全部mount或者umount /etc/exports中的内容
-r # 重新mount /etc/exports中分享出来的目录
-u # umount目录
-v # 在export的时候,将详细的信息输出到屏幕上

nfsstat # 列出nfs客户端和服务端的工作状态
-s # 仅列出服务端
-c # 仅列出客户端
-n # 仅列出nfs状态,默认显示客户端和服务端
-2 # 仅列出nfs版本2的状态
-3 # 仅列出nfs版本3的状态
-4 # 仅列出nfs版本4的状态
-m # 打印已加载的nfs文件系统状态,用在客户端
-r # 仅打印rpc状态

showmount # 显示关于 NFS 服务器文件系统挂载的信息
-a # 以host:dir这样的格式来显示客户机名和挂载点目录
-d # 仅显示被客户挂载的目录名
-e # ip 显示NFS服务器的输出清单(要扫描某一台主机的导出信息时,可以使用此命令,也可以在nfs服务器上查看)
-h # 显示帮助信息
-v # 显示版本信息
    }

    hdfs{
        hdfs --help                  # 所有参数

        hdfs dfs -help               # 运行文件系统命令在Hadoop文件系统
        hdfs dfs -ls /logs           # 查看
        hdfs dfs -ls /user/          # 查看用户
        hdfs dfs -cat
        hdfs dfs -df
        hdfs dfs -du
        hdfs dfs -rm
        hdfs dfs -tail
        hdfs dfs -put localSrc dest  # 上传文件

        hdfs dfsadmin -help          # hdfs集群节点管理
        hdfs dfsadmin -report        # 基本的文件系统统计信息
    }
}
aria2c(){ 支持 HTTP/HTTPS、FTP、SFTP、 BitTorrent 和 Metalink 协议
aria2c 下载工具
    下载:
        aria2c url
        aria2c 'xxx.torrnet'
        aria2c '磁力链接'

    恢复下载：
        aria2c -c url

    列出种子内容:
        aria2c -S target.torrent

    下载种子内编号为 1、4、5、6、7 的文件:
        aria2c -select-file=1,4-7 a.torrent aria2 命令行直接下载一个 BitTorrent 种子文件：
        aria2c https://torcache.net/torrent/C86F4E743253E0EBF3090CCFFCC9B56FA38451A3.torrent?title=[kat.cr]irudhi.suttru.2015.official.teaser.full.hd.1080p.pathi.team.sr
        
    下载磁力链接的种子文件:
        aria2c --bt-metadata-only=true --bt-save-metadata=true 'magnet:?xtxxxx'
        aria2c 'magnet:?xt=urn:btih:248D0A1CD08284299DE78D5C1ED359BB46717D8C'  可以通过 BitTorrent 磁力链接直接下载一个种子文件：
        aria2c https://curl.haxx.se/metalink.cgi?curl=tar.bz2 过 aria2 命令行直接下载一个 Metalink 文件。

    需要cookies验证(Chrome插件: 'cookie.txt export'):
        aria2c -load-cookies=cookie_file url

    限速下载:
        单个文件最大下载速度： aria2c -max-download-limit=300K
        整体下载最大速度： aria2c -max-overall-download-limit=300k

aria2c --http-user=xxx --http-password=xxx https://download.owncloud.org/community/owncloud-9.0.0.tar.bz2
aria2c --ftp-user=xxx --ftp-password=xxx ftp://ftp.gnu.org/gnu/wget/wget-1.17.tar.gz
aria2c -i test-aria2.txt 从文件获取输入
aria2c -Z https://download.owncloud.org/community/owncloud-9.0.0.tar.bz2 ftp://ftp.gnu.org/gnu/wget/wget-1.17.tar.gz

    其他常用选项:
        -x 最大的链接线程数
        -j 最大下载的文件个数
        -o 重命名下载的文件
}
wget(){
wget -r --no-parent --reject "index.html*" http://hostname/ -P /home/user/dirs # 用 wget 抓取完整的网站目录结构，存放到本地目录中

wget -r -np -nd http://example.com/packages/
#这条命令可以下载 http://example.com 网站上 packages 目录中的所有文件。其中，-np 的作用是不遍历父目录，-nd 表示不在本机重新创建目录结构。
wget -r -np -nd --accept=iso http://example.com/centos-5/i386/
#与上一条命令相似，但多加了一个 --accept=iso 选项，这指示 wget 仅下载 i386 目录中所有扩展名为 iso 的文件。你也可以指定多个扩展名，只需用逗号分隔即可。
wget -i filename.txt
#此命令常用于批量下载的情形，把所有需要下载文件的地址放到 filename.txt 中，然后 wget 就会自动为你下载所有文件了。
wget -c http://example.com/really-big-file.iso
#这里所指定的 -c 选项的作用为断点续传。
wget -m -k (-H) http://www.example.com/
#该命令可用来镜像一个网站，wget 将对链接进行转换。如果网站中的图像是放在另外的站点，那么可以使用 -H 选项。
wget --random-wait -r -p -e robots=off -U Mozilla www.example.com #用 Wget 的递归方式下载整个网站

-a<日志文件>：在指定的日志文件中记录资料的执行过程；
-A<后缀名>：指定要下载文件的后缀名，多个后缀名之间使用逗号进行分隔；
-b：进行后台的方式运行wget；
-B<连接地址>：设置参考的连接地址的基地地址；
-c：继续执行上次终端的任务；
-C<标志>：设置服务器数据块功能标志on为激活，off为关闭，默认值为on；
-d：调试模式运行指令；
-D<域名列表>：设置顺着的域名列表，域名之间用"，"分隔；
-e<指令>：作为文件".wgetrc"中的一部分执行指定的指令；
-h：显示指令帮助信息；
-i<文件>：从指定文件获取要下载的URL地址；
-l<目录列表>：设置顺着的目录列表，多个目录用"，"分隔；
-L：仅顺着关联的连接；
-r：递归下载方式；
-nc：文件存在时，下载文件不覆盖原有文件；
-nv：下载时只显示更新和出错信息，不显示指令的详细执行过程；
-q：不显示指令执行过程；
-nh：不查询主机名称；
-v：显示详细执行过程；
-V：显示版本信息；
--passive-ftp：使用被动模式PASV连接FTP服务器；
--follow-ftp：从HTML文件中下载FTP连接文件。

wget -t 5 www.codeshold.me, wget -t 0 www.codeshold.me # 无限次尝试, -O outfile.html, -o out.log
# 可限速 --limit-rate 20k, 可限制配额 --quota 100m或-Q 100m

wget --mirror --convert-links www.codeshold.me # 镜像整个网站 
wget -r -N -k -l DEPTH URL，                   # 镜像整个网站  其中-k和--convert-links指示wget将页面的链接地址转换为本地地址，-N使用文件的文件戳
    1>wget 批量下载网页:
        eg. wget -c -r -np -k -L --restrict-file-names=nocontrol http://www.kerneltravel.net/kernel-book/
    2>下载整个http或者ftp站点:
        eg. wget http://place.your.url/here   # -x 会强制建立服务器上一模一样的目录,-nd 从服务器上下载的所有内容都会加到本地目录.
        eg. wget -r http://place.your.url/here  #按照递归的方法,下载服务器上所有目录和文件. -i number 参数来指定下载层次.
        eg. wget -m http://place.your.url/here  #制作镜像站点. 
    3>断点续传:
        eg.wget -c http://the.url.of/incomplete/file   # -t 重试次数 -t 100 . -t 0 表示无穷此重试直到连接成功. -T 表示超时时间 -T 120 表示等待120秒链接不上就算超时. 
    4>批量下载:
        eg.wget -i download.txt   #download.txt 添加要下载的内容即可. 
    5>选择性的下载:
        eg. wget -m -reject=gif http://target.web.site/subdirectory  #表示下载http://target.web.site/subdirectory，但是忽略gif文件. -accept=LIST可以接受的文件类型.
    6>密码和认证:
        eg. --http-user=USER 设置http用户  -http-passwd=PASS 设置http密码.  对于需要证书做认证的网站,只能利用其他下载工具(curl).
    7.利用代理服务器进行下载:
        需要在当前用户的目录创建一个 .wgetrc 文件, 加入代理服务地址即可.
        eg. http-proxy = 11.11.11.11:8080 
            ftp-proxy = 11.11.11.11:8080 
        分别代表http的代理服务器和ftp的代理服务器. 如果需要密码则使用下面的例子.
        eg. -proxy-user=USER  #设置代理用户 
            -proxy-passwd=PASS  #设置代理密码  
            -proxy=on/off  #使用或关闭代理 
    8>定时下载,添加cron定时任务:
        eg. 0 23 * * 1-5 wget -c -N http://place.your.url/here 
            0 6 * * 1-5 killall wget 
            
wget http://10.108.255.249/cgi-bin/do_login --post-data "username=$name&password={TEXT}$pass&drop=0&type=1&n=100"i -q
}

curl wget httpie
curl(){
[curl]
    curl 是一个向服务器发送/接收数据的工具，可以支持下列协议DICT, FILE, FTP, FTPS, GOPHER, 
HTTP, HTTPS, IMAP, IMAPS, LDAP, LDAPS, POP3, POP3S, RTMP, RTSP, SCP, SFTP, SMTP, SMTPS, TELNET, TFTP。
这个工具被设置为一次性请求，而不是交互式的.
    curl提供了很多有用的功能比如：代理支持、用户认证、FTP上传、HTTP post、SSL连接、cookies支持、
文件断点传输、Metalink等等。

[URL]
  URL是协议独立的。详细信息可以参考RFC 3986
  你可以使用{}指定多个URL或者URL部分：
  http://site.{one,two,three}.com
  也可以使用[]制定一个字母或者数字序列：
  ftp://ftp.numericals.com/file[1-100].txt
  ftp://ftp.numericals.com/file[001-100].txt    ##with leading zeros
  ftp://ftp.letters.com/file[a-z].txt
  
  不能嵌套使用这些标记，但是可以在一个URL中同时使用多个：
  http://any.org/archive[1996-1999]/vol[1-4]/part{a,b,c}.html
  也可以指定步进值：
  http://www.numericals.com/file[1-100:10].txt
  http://www.letters.com/file[a-z:2].txt
  
可以在命令行中指定任意数量的URL。curl会按照给出的顺序一个一个的取数据
    如果你指定的URL没有协议前缀，curl会默认使用HTTP协议进行取数据，并且会根据你的主机前缀进行猜测，
比如：ftp.test.com curl会尝试使用FTP协议进行连接；curl不会进行URL的合法性检查
    在一个命令中向同一个服务器请求多个资源时，curl会尝试重用TCP连接，这样可以加快速度

[处理进度]
    curl在处理过程中默认会显示一个处理进度，表示已经传输的数据、传输速度、和消耗的时间信息，
curl默认将这些信息打印到终端；如果你的curl请求会返回大量的数据则curl不会显示这些信息
    可以使用-#来用一个进度条代替常规的进度信息

[选项]
    选项使用一个或者两个连字符开始，很多选项需要指定一个参数；
    使用一个连字符时，比如：-d，它和后面的选项参数之间可以有空格也可以没有空格，
    使用两个连字符的选项和后面的参数之间必须有至少一个空格；
    不需要参数的选项可以连在一起写，比如：-OLv
    
    通常布尔类型的参数，比如使用--option启用的都可以使用--no-option禁用，
    
    这些选项中有的连续使用多次是有意义的，比如-d；但是另外一些可能无意义，这样有的是第一个起作用，有的是最后一个起作用，
    
-#
使用#作为进度条来代替默认的处理进度信息

-0/--http1.0 --http1.1 --http2.0
使用http1.0 http1.1 http2.0协议来发送请求，默认使用http1.1，http2.0需要底层的libcurl编译支持

-1/--tlsv1 -2/--sslv2 -3/--sslv3 在向远程的TLS/SSL服务器发送请求时使用的协议
-4/--ipv4 -6/--ipv6 将请求的主机名仅仅解析为ipv4地址/ipv6地址

-a/--append
在使用FTP/SFTP协议进行上传数据时，告诉服务器将内容添加到目标文件，而不是覆盖。
如果文件不存在则创建这个文件。SSH服务器会忽略这个选项

-A/--user-agent <agent string>
(HTTP)指定User-Agent头信息，如果agent string中有空格则使用单引号引用；这个选项可以使用-H --header选项代替

--anyauth
(HTTP)告诉curl发送请求并选择一个服务器返回的可支持的最安全的认证方法。具体的做法是先发送一个请求，并检查服务器的响应头信息拿到所有可支持的认证方法，这需要多一次的HTTP请求。这用来代替直接指定认证方法：--basic --digest --ntlm --negotiate
  注意在有提交/上传请求时不要使用这个参数，这可能会导致两次提交
    
-b/--cookie <name=data>
(HTTP)将name=data作为cookie数据传送给http服务器。通常是上一次请求中从服务器收到的Set-Cookie头信息的内容。
数据格式为NAME1=VALUE1; NAME2=VALUE2
    如果参数中不包含=则被当作是一个文件名，会根据请求地址从文件中查找匹配的cookies信息；
使用这个方法可以启用curl的cookie parser，这样可以保存本次请求收到的cookies信息，也可以
制定-L --location选项来手动处理本次请求收到的cookies；文件的格式应该是文本格式包含HTTP头信息，
或者是Netscape/Mozilla的cookie文件格式

-B/--use-ascii
(FTP/LDAP)启用ASCII传输。在FTP协议中可以使用在URL末尾加上;type=A的方法达成同样的效果

--basic
(HTTP)使用--basic认证方法，这是默认使用的方法。一般不同指定这个选项，除非你之前的请求使用了别的认证方法，
然后在这次请求中要改变它

-c/--cookie-jar <file name>
(HTTP)指定curl将所有cookies写入的文件。curl将之前从文件中读取的cookis和从服务器收到的cookies都写入到这个文件。
如果没有使用cookies则不会写文件。文件使用Netscapecookie文件格式；如果使用-代替文件名则cookie被写到标准输出
    使用这个选项可以启用curl的cookie处理系统来记录和使用cookie；如果因为其他原因导致文件不能写入，
则curl不会执行失败或者报错，使用-V选项可以得到一个警告信息

-C, --continue-at <offset>
    根据特定的offset继续/重启一个之前进行的文件传输。给定的offset表示会被跳过的精确的字节数，
从之前准备传输的文件的开始进行计数。如果用在ftp上传文件中，curl不会使用FTP服务器的SIZE命令来获取上传的字节数
# 使用-C -表示让curl自动计算出从哪里开始继续传输。然后在文件中找到相应的位置

--ciphers <list of ciphers>
(SSL)指定使用的加密套件。list of ciphers必须是合法的加密套件。关于SSl加密套件列表详情可以查看这里

--compressed
(HTTP)请求返回一个curl支持的压缩方法的压缩响应内容，然后curl进行解压缩并返回数据。
如果使用这个选项并且服务器返回一个不支持的压缩格式，则curl报错

--connect-timeout <seconds>
指定在连接阶段的超时时间(秒)；如果连接已经建立则这个选项不起作用

--create-dirs
和-o选项连用时，curl会根据需求在本地创建-o选项指定的目录结构。如果-o选择没有指定目录或者目录已经存在则不会创建
使用FTP SFTP协议时，如果要在远程创建目录可以使用--ftp-create-dirs选项

--crlf
--crlfile <file>
(HTTPS FTPS)提供一个pem格式的吊销证书列表来指定对端的证书已经准备被吊销

-d, --data <data>
--data-ascii <data>
--data-binary <data>
    在HTTP协议中使用POST请求发送指定的数据到服务器，就像在浏览器中填写表单然后点击提交按钮一样。
使用这参数curl会在http头中将Content-type设置为application/x- www-form-urlencoded，表示由表单提交过来的数据。
可以和-F --form对比一下
    这个选项等同于--data-ascii选项。要使用二进制方式提交数据，需要添加--data-binary选项；
如果已经对提交的数据进行过URL编码，请使用--data-urlencode选项
    如果使用多个-d选项，则效果等同于使用&将他们连接起来，合并提交
    如果data以@开始，则其他部分被认为是一个文件名，然后从文件中读取数据；data也可以是-表示从标准输入中读取。
也可以指定多个文件，文件中的空行被忽略
--data-binary表示数据/文件不经任何处理直接提交

-D, --dump-header <file>
(HTTP)用来保存服务器发送过来的响应头信息到file中，然后可以在请求中使用-b选项读取文件中的cookies信息；
-c选项可以以更合理的方式存储cookies
# 也可以用在FTP协议中，ftp响应行被当作头信息存储

--data-urlencode <data>
(HTTP)表示将数据进行URL-encoding然后再POST提交，<data>可以是如下格式：
    content : 如果指定的内容中不包括@ =字符，则curl直接进行URL-encoding然后提交，否则按下面规则
    =content : 将content进行编码和提交，内容不包括=
    name=content : 将content进行编码和提交，name应该是已经编码过的内容
    @filename : 从文件中读取内容(包括换行)，然后编码提交
}

1. Headers
-A <str>         # --user-agent
-b name=val      # --cookie
-b FILE          # --cookie
-H "X-Foo: y"    # --header
--compressed     # use deflate/gzip
2. Request
-X POST          # --request
-L               # follow link if page redirects
3. Data
-d 'data'    # --data: HTTP post data, URL encoded (eg, status="Hello")
-d @file     # --data via file
-G           # --get: send -d data via get
4. SSL
    --cacert <file>
    --capath <dir>
-E, --cert <cert>     # --cert: Client cert file
    --cert-type       # der/pem/eng
-k, --insecure        # for self-signed certs

# Post data:
1. curl -d password=x http://x.com/y
# Auth/data:
2. curl -u user:pass -d status="Hello" http://twitter.com/statuses/update.xml
# multipart file upload
3. curl -v -include --form key1=value1 --form upload=@localfilename URL 
curl(){

-A/--user-agent <string> 设置用户代理发送给服务器，即告诉服务器浏览器为什么
-basic 使用HTTP基本验证
--tcp-nodelay 使用TCP_NODELAY选项
-e/--referer <URL> 来源网址，跳转过来的网址
--cacert <file> 指定CA证书 (SSL)
--compressed 要求返回是压缩的形势，如果文件本身为一个压缩文件，则可以下载至本地
-H/--header <line>自定义头信息传递给服务器
-I/--head 只显示响应报文首部信息
--limit-rate <rate> 设置传输速度
-u/--user <user[:password]>设置服务器的用户和密码
-0/--http1.0 使用HTTP 1.0

curl http://www.google.com/ # 基本用法
1. post 表单数据
curl -d "user=neo&password=chen" http://www.example.com/login.php 
curl --data "user=neo&password=chen" http://www.example.com/login.php 
curl -F "upload=@card.txt;type=text/plain" "http://www.example.com/upload.php"
2. connect-timeout
curl -o /dev/null --connect-timeout 30 -m 30 -s -w %{http_code} http://www.google.com/
3. max-time
# -m, --max-time SECONDS Maximum time allowed for the transfer
curl -o /dev/null --max-time 10 http://www.netkiller.cn/
4. compressed
--compressed Request compressed response (using deflate or gzip)
curl --compressed http://www.example.com
5. -w, --write-out <format> 输出格式定义
计时器				描述
time_connect		建立到服务器的 TCP 连接所用的时间
time_starttransfer	在发出请求之后,Web 服务器返回数据的第一个字节所用的时间
time_total			完成请求所用的时间
time_namelookup		DNS解析时间,从请求开始到DNS解析完毕所用时间(记得关掉 Linux 的 nscd 的服务测试)
speed_download		下载速度，单位-字节每秒。
curl -o /dev/null -s -w %{time_connect}:%{time_starttransfer}:%{time_total} http://www.example.net 
curl -o /dev/null -s -w "Connect: %{time_connect}\nTransfer: %{time_starttransfer}\nTotal: %{time_total}\n" https://www.netkiller.cn/index.html 
curl -o /dev/null -s -w "Connect: %{time_connect} \nTransfer: %{time_starttransfer}\nTotal: %{time_total}\nNamelookup: %{time_namelookup}\nDownload: %{speed_download}\n" https://www.netkiller.cn/index.html 
Connect: 0.024241 
Transfer: 0.117727 
Total: 0.117842 
Namelookup: 0.004367 
Download: 129877.000
5.1 测试页面所花费的时间
date ; curl  -s  -w 'Connect: %{time_connect} TTFB: %{time_starttransfer} Total time: %{time_total} \n'  -H "Host: www.example.com" http://172.16.0.1/webapp/test.jsp ; date ;
curl -o /dev/null -s -w %{time_connect}, %{time_starttransfer}, %{time_total}, %{time_namelookup}, %{speed_download} http://www.netkiller.cn
5.2 返回HTTP状态码
curl -s -I http://netkiller.sourceforge.net/ | grep HTTP | awk '{print $2" "$3}'
curl -o /dev/null -s -w %{http_code} http://netkiller.sourceforge.net/
curl --connect-timeout 5 --max-time 60 --output /dev/null -s -w %{response_code} http://www.netkiller.cn/
curl -w '\nLookup time:\t%{time_namelookup}\nConnect time:\t%{time_connect}\nPreXfer time:\t%{time_pretransfer}\nStartXfer time:\t%{time_starttransfer}\n\nTotal time:\t%{time_total}\n' -o /dev/null -s http://www.netkiller.cn
Lookup time:	0.125
Connect time:	0.125
PreXfer time:	0.125
StartXfer time:	0.125
Total time:	0.126		
6. -A/--user-agent <agent string>
设置用户代理，这样web服务器会认为是其他浏览器访问
curl -A "Mozilla/4.0 (compatible; MSIE 5.01; Windows NT 5.0)" http://www.example.com
7. referer
curl -v -o /dev/null -e "http://www.example.com" http://www.your.com/
8. -o, --output FILE Write output to <file> instead of stdout
curl -o /dev/null http://www.example.com
curl -o index.html http://www.example.com
9. -H/--header <line> Custom header to pass to server (H)
9.1 Last-Modified / If-Modified-Since
    If-Modified-Since
curl -I http://www.126.com
curl -H "If-Modified-Since: Fri, 12 May 2011 18:53:33 GMT" -I http://www.126.com
9.2 ETag / If-None-Match
curl -H 'If-None-Match: "1984705864"' -I http://images.example.com/test/test.html
9.3 Accept-Encoding:gzip,defalte
curl -H Accept-Encoding:gzip,defalte -I http://www.example.com/product/374218.html
curl -H Accept-Encoding:gzip,defalte http://www.example.com/product/374218.html | gunzip
9.4 HOST
curl -H HOST:www.example.com -I http://172.16.1.10/product/374218.html
9.5 未认证返回401
# curl --compressed http://webservice.example.com/members
<html>
<head><title>401 Authorization Required</title></head>
<body bgcolor="white">
<center><h1>401 Authorization Required</h1></center>
<hr><center>nginx</center>
</body>
</html>
-u/--user <user[:password]> Set server user and password
使用 -u或者 --user 指定用户与密码
# curl --compressed -uneo:chen http://webservice.example.com/members
9.6 Accept	
-H "Accept: application/json"
9.7 Content-Type			
-H "Content-Type: application/json"
10.指定网络接口或者地址 
curl --interface 127.0.0.1 http://www.netkiller.cn
11. Cookie 处理
cookie 可以从 http header 设置
curl -LO -H "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/8u131-b11/d54c1d3a095b4ff2b6607d096fa80163/jdk-8u131-linux-x64.rpm		
curl 还提供两个参数用于处理 cookie
 -b, --cookie STRING/FILE  Read cookies from STRING/FILE (H) 读取 cookie 文件
 -c, --cookie-jar FILE  Write cookies to FILE after operation (H) 将 cookie 写入文件
curl -c cookie.txt -d "user=neo&password=123456" http://www.netkiller.cn/login
curl -b cookie.txt http://www.netkiller.cn/user/profile
12. RestFul 应用 JSON 数据处理
下面提供一些使用 curl 操作 restful 的实例
GET 操作
curl http://api.netkiller.cn/v1/withdraw/get/15.json
用户认证的情况
curl http://test:123456@api.netkiller.cn/v1/withdraw/get/id/815.json		
POST 操作	
curl -i -H "Accept: application/json" -H "Content-Type: application/json" -X POST -d '
{
"id":"B040200000000000000","name":"Neo","amount":12,"password":"12345","createdate":"2016-09-12 13:10:10"

}' https://test:123456@api.netkiller.cn/v1/withdraw/create.json


curl-config
curl-config --features
}
bridge(/sys/devices/virtual/net/cloudbr0/bridge)
{
新建一个网桥：
# brctl addbr bridge_name

添加一个设备(例如eth0)到网桥：
# brctl addif bridge_name eth0

显示当前存在的网桥及其所连接的网络端口：
# brctl show

启动网桥：
# ip link set up dev bridge_name

删除网桥，需要先关闭它：
# ip link set dev bridge_name down
# brctl delbr bridge_name

------------------------------------------------
创建一个网桥并设置其状态为已启动：
# ip link add name bridge_name type bridge
# ip link set dev bridge_name up

添加一个网络端口(比如 eth0)到网桥中，要求先将该端口设置为混杂模式并启动该端口：
# ip link set dev eth0 promisc on
# ip link set dev eth0 up

把该端口添加到网桥中，再将其所有者设置为 bridge_name 就完成了配置：
# ip link set dev eth0 master bridge_name

要显示现存的网桥及其关联的端口，可以用 bridge 工具(它也是 iproute2 的组成部分)。详阅 man bridge。
# bridge link show

若要删除网桥，应首先移除它所关联的所有端口，同时关闭端口的混杂模式并关闭端口以将其恢复至原始状态。
# ip link set eth0 promisc off
# ip link set eth0 down
# ip link set dev eth0 nomaster

当网桥的配置清空后就可以将其删除：
# ip link delete bridge_name type bridge

分配 IP 地址
# ip addr add dev bridge_name 192.168.66.66/24
}

brctl(http://www.thegeekstuff.com/2017/06/brctl-bridge/){
brctl command               Description
setageing bridge time       Set ageing time
setbridgeprio bridge prio   Set bridge priority (between 0 and 65535)
setfd bridge time           Set bridge forward delay
sethello bridge time        Set hello time
setmaxage bridge time       Set max message age
setgcint bridge time        Set garbage collection interval in seconds
sethashel bridge int        Set hash elasticity
sethashmax bridge int       Set hash max
setmclmc bridge int         Set multicast last member count
setmcrouter bridge int      Set multicast router
setmcsnoop bridge int       Set multicast snooping
setmcsqc bridge int         Set multicast startup query count
setmclmi bridge time        Set multicast last member interval
setmcmi bridge time         Set multicast membership interval
setmcqpi bridge time        Set multicast querier interval
setmcqi bridge time         Set multicast query interval
setmcqri bridge time        Set multicast query response interval
setmcqri bridge time        Set multicast startup query interval
setpathcost bridge port cost        Set path cost
setportprio bridge port prio        Set port priority (between 0 and 255)
setportmcrouter bridge port int	    Set port multicast router
sethashel bridge int                Set hash elasticity value

STP 多个以太网桥可以工作在一起组成一个更大的网络，利用802.1d协议在两个网络之间寻找最短路径，STP的作用是防止以太网桥之间形成回路，如果确定只有一个网桥，则可以关闭STP。
brctl setbridgeprio <bridge> <priority> #设置网桥的优先级，<priority>的值为0-65535，值小的优先级高，优先级最高的是根网桥。
brctl setfd <bridge> <time>  #设置网桥的'bridge forward delay'转发延迟时间，时间以秒为单位
brctl sethello <bridge> <time> # 设置网桥的'bridge hello time'存活检测时间
brctl setmaxage <bridge> <time> # 设置网桥的'maximum message age'时间
brctl setpathcost <bridge> <port> <cost> # 设置网桥中某个端口的链路花费值
brctl setportprio  <bridge>  <port> <priority> # 设置网桥中某个端口的优先级
 
}


VLAN()
{
创建 VLAN 设备
# ip link add link eth0 name eth0.100 type vlan id 100

执行 ip link 命令确认 VLAN 已创建。
# ip -d link show eth0.100

添加 IP
# ip addr add 192.168.100.1/24 brd 192.168.100.255 dev eth0.100
# ip link set dev eth0.100 up

关闭设备
# ip link set dev eth0.100 down

移除设备
# ip link delete eth0.100
}
parallel(){
cat list | parallel do_something | process_output
https://www.gnu.org/software/parallel/parallel_tutorial.html

find . -name "*.foo" | parallel grep bar #　=　 find . -name "*.foo" -exec grep bar {} +
find . -name "*.foo" -print0 | parallel -0 grep bar
find . -name "*.foo" | parallel -X mv {} /tmp/trash
find . -maxdepth 1 -type f -name "*.ogg" | parallel -X -r cp -v -p {} /home/media #cp -v -p *.ogg /home/media
}

#并行进程执行  &

#!/bin/bash

PIDARRAY=()
for file in File1.iso File2.iso
do
    md5sum $file &
    PIDARRAY+=("$!")
done
wait ${PIDARRAY[@]}

# $!获得最近一个后台进程的PID，将这些PID放入数组，然后使用wait命令等待这些进程结束

system(network){
    rz   # 通过ssh上传小文件
    sz   # 通过ssh下载小文件
    ifconfig eth0 down                  # 禁用网卡
    ifconfig eth0 up                    # 启用网卡
    ifup eth0:0                         # 启用网卡
    mii-tool em1                        # 查看网线是否连接
    traceroute www.baidu.com            # 测试跳数
    vi /etc/resolv.conf                 # 设置DNS  nameserver IP 定义DNS服务器的IP地址
    host -t txt hacker.wp.dg.cx         # 通过 DNS 来读取 Wikipedia 的hacker词条
    tcpdump tcp port 22                 # 抓包
    tcpdump -n -vv udp port 53          # 抓udp的dns包 并显示ip
    lynx                                # 文本上网
    lynx -dump -stdin                   # 将 HTML 转为文本
    wget -P 路径 -O 重命名 http地址     # 下载  包名:wgetrc   -q 安静
    dhclient eth1                       # 自动获取IP
    mtr -r www.baidu.com                # 测试网络链路节点响应时间 # trace ping 结合
    ipcalc -m "$ip" -p "$num"           # 根据IP和主机最大数计算掩码
    curl -I www.baidu.com               # 查看网页http头
    curl -s www.baidu.com               # 不显示进度
    queryperf -d list -s DNS_IP -l 2    # BIND自带DNS压力测试  [list 文件格式:www.turku.fi A]
    telnet ip port                      # 测试端口是否开放,有些服务可直接输入命令得到返回状态
    echo "show " |nc $ip $port          # 适用于telnet一类登录得到命令返回
    nc -l -p port                       # 监听指定端口
    nc -nv -z 10.10.10.11 1080 |grep succeeded                            # 检查主机端口是否开放
    curl -o /dev/null -s -m 10 --connect-timeout 10 -w %{http_code} $URL  # 检查页面状态
    curl -X POST -d "user=xuesong&pwd=123" http://www.abc.cn/Result       # 提交POST请求
    curl -s http://20140507.ip138.com/ic.asp                              # 通过IP138取本机出口外网IP
    curl http://IP/ -H "X-Forwarded-For: ip" -H "Host: www.ttlsa.com"     # 连到指定IP的响应主机,HTTPserver只看 Host字段
    ifconfig eth0:0 192.168.1.221 netmask 255.255.255.0                   # 增加逻辑IP地址
    echo 1 > /proc/sys/net/ipv4/icmp_echo_ignore_all                      # 禁ping
    net rpc shutdown -I IP_ADDRESS -U username%password                   # 远程关掉一台WINDOWS机器
    wget --random-wait -r -p -e robots=off -U Mozilla www.example.com     # 递归方式下载整个网站
    sshpass -p "$pwd" rsync -avzP /dir  user@$IP:/dir/                    # 指定密码避免交互同步目录
    rsync -avzP --delete /dir user@$IP:/dir                               # 无差同步目录 可以快速清空大目录
    rsync -avzP -e "ssh -p 22 -e -o StrictHostKeyChecking=no" /dir user@$IP:/dir         # 指定ssh参数同步

# 网卡配置相关
/etc/sysconfig/network-scripts/ifcfg-Interface-Name #　/usr/share/doc/initscripts-9.03.31
1. DEVICE=eth0 # 关联的设备名称
2. BOOTPROTO={none|static|dhcp|bootp} # 引导协议，
3. IPADDR=
4. NETMASK=
5. GATEWAY=
6. ONBOOT=
7. HWADDR= # 硬件地址，可与硬件中的地址保持一致，可省略
8. USERCTL={yes|no} # 是否允许普通用户控制此接口
9. PEERDNS={yes|no} # 是否接收由dhcp分配的dns地址
# 一个网卡配置多个IP地址
/etc/sysconfig/network-scripts/ifcfg-ethX:X 
ifconfig ifcfg-ethX:X IP/NETMASK
/etc/sysconfig/network-scripts/ifcfg-ethX:X  # 临时生效
1. DEVICE=ethX:X # 关联的设备名称            # 永久生效
# 网络配置文件 
/etc/sysconfig/network
NETWORKING=yes       # 启用网络服务
NETWORKING_IPV6=yes  # 启用IPv6协议栈
HOSTNAME=agent.cloud.com # 设置主机名
# 指定本地解析 /etc/hosts
# DNS配置文件  /etc/resolv.conf
# 路由相关配置
/etc/sysconfig/network-scripts/route-ethX
格式1： DEST via NESTHOP
        172.16.0.0/24 via 192.168.10.254
格式2： IPADDRESS=    | IPADDRESS=172.16.0.0
        NETMASK=      | NETMASK=255.255.255.0
        GATEWAY=      | GATEWAY=192.168.10.254
ifconfig(){
ifconfig {interface} {up|down}
ifconfig em1 hw ether 00:1c:bf:87:25:d5 # 硬件地址欺骗
ifconfig interface {option} # mtu netmask broadcast
ifconfig <dev> up|down
ifconfig <dev> <ip> [netmask <mask> broadcast <ip>]
ifconfig <dev> add|del 33ffe:3240:800:1005::2/64
ifconfig <dev> hw ether 00:AA:BB:CC:dd:EE
ifconfig <dev> arp/ifconfig eth0 -arp
ifconfig <dev> mtu 1500

ifconfig [-a] interface [address]
Configure a network interface
Options:
  [add ADDRESS[/PREFIXLEN]]
  [del ADDRESS[/PREFIXLEN]]
  [[-]broadcast [ADDRESS]] [[-]pointopoint [ADDRESS]]
  [netmask ADDRESS] [dstaddr ADDRESS]
  [outfill NN] [keepalive NN]
  [hw ether|infiniband ADDRESS] [metric NN] [mtu NN]
  [[-]trailers] [[-]arp] [[-]allmulti]
  [multicast] [[-]promisc] [txqueuelen NN] [[-]dynamic]
  [mem_start NN] [io_addr NN] [irq NN]
  [up|down] ...
}
ifup {interface}
ifdown {interface}
hostname
route
ip route show
ip route add 192.168.10.0/24 dev eth0                          # 内部路由
ip route add 192.168.10.0/24 via 192.168.1.1 dev eth0          # 外部路由
ip route add default 192.168.10.0/24 via 192.168.1.1 dev eth0  # 外部默认路由
ping(fping | phping){
fping 
1. Probing options: 探测选项
1.1 报文内容
-4, --ipv4 | -6, --ipv6  指定协议
-b, --size=BYTES         携带数据量
-R, --random             随机数据量大小
-B, --backoff=N          设置指数退避因子
-c, --count=N            每个目标发送报文次数
-l, --loop               无限循环发送
-H, --ttl=N              TTL值
-O, --tos=N              服务质量
-M, --dontfrag           报文不分片
-S, --src=IP             指定源IP地址
1.2. 系统和收发机制
-I, --iface=IFACE        接口绑定
-p, --period=MSEC        报文发送间隔
-t, --timeout=MSEC       接收超时时间
-r, --retry=N            失败重试次数
1.3 目标管理
-m, --all                探测DNS返回的所有IP地址，与-A一起使用
-f, --file=FILE          从文件读取目标
-g, --generate           fping -g 192.168.1.0 192.168.1.255 or fping -g 192.168.1.0/24
2. Output options:  输出选项
2.1 在线
-a, --alive              只显示在线
-A, --addr               显示目标地址(包含-a内容，附加收发过程)
2.2 时间
-D, --timestamp          时间戳 (包含-e内容，包含收到时间戳)
-e, --elapsed            响应报文与发送报文时差
-C, --vcount=N           最后显示特定地址的收发时间差
-i, --interval=MSEC      发送报文间隔
2.3 输出格式
-N, --netdata            支持netdata格式
-o, --outage             outage格式
-s, --stats              收发数据包统计
-u, --unreach            显示unreachable报文
2.4 DNS反解析
-n, --name               进行DNS反解析

ping [ -LRUbdfnqrvVaAB]  [ -c count]  [ -i interval]  [ -l preload]  [ -p pattern]  [ -s packetsize]  [ -t ttl]
[ -w deadline]  [ -F flowlabel]  [ -I interface]  [ -M hint]  [ -Q tos]  [ -S sndbuf]  [ -T  timestamp  option]
[ -W timeout]  [ hop ...]  destination
       
phping
traceroute
mtr
lynx
elinks
}

# 循环体放入()&，()中的命令会在子shell中运行，&会将其放入后台
#!/bin/bash
for ip in 172.29.1.{1..255};
do
    (
        ping $ip -c 2 &> /dev/null;

        if [ $? -eq 0 ];
        then
            echo $ip is alive
        fi
    )&
done
wait

wait等待所有子进程结束后再终止脚本

---------------------------------------
/etc/hosts ：记录hostname对应的ip地址
/etc/resolv.conf ：设置DNS服务器的ip地址
/etc/host.conf ：指定域名解析的顺序(是从本地的hosts文件解析还是从DNS解析)
# host命令和dig命令很相像，但是host命令的输出要更简洁
host   # 可以不适用/etc/resolv.conf来进行DNS解析
host www.google.com         # 使用resolv.conf解析
host www.google.com 8.8.8.8 # 使用8.8.8.8解析
host 173.194.72.147         # 反解析
host -t SOA google.com      # 查询SOA记录信息
host -t MX google.com       # 查询MX记录
host -C google.com          # -C对比认证DNS SOA信息
host -c CH -t txt version.bind 8.8.8.8 # 查询DNS Server软件版本信息,10.10.10.2为DNS Server
---------------------------------------

dhcprelay(){
dhcprelay CLIENT_IFACE[,CLIENT_IFACE2...] SERVER_IFACE [SERVER_IP] 
Relay DHCP requests between clients and server
}
udhcpc(){

}

ftpd [-wvS] [-t N] [-T N] [DIR] # Anonymous FTP server
tcpsvd -vE 0.0.0.0 21 ftpd /files/to/serve

ftpget [OPTIONS] HOST LOCAL_FILE REMOTE_FILE 
ftpput [OPTIONS] HOST REMOTE_FILE LOCAL_FILE



tcpsvd(){
tcpsvd [-hEv] [-c N] [-C N[:MSG]] [-b N] [-u USER] [-l NAME] IP PORT PROG 
Create TCP socket, bind to IP:PORT and listen for incoming connection. Run PROG for each connection.

  IP IP to listen on. '0' = all 
  PORT Port to listen on 
  PROG [ARGS] Program to run

  -l NAME Local hostname (else looks up local hostname in DNS)
  -u USER[:GRP]   Change to user/group after bind
  -c N Handle up to N connections simultaneously
  -b N Allow a backlog of approximately N TCP SYNs
  -h Look up peers hostname
  -E Do not set up environment variables
  
  -C N[:MSG] Allow only up to N connections from the same IP
             New connections from this IP address are closed
             immediately. MSG is written to the peer before close
}

udpsvd(){
udpsvd [-hEv] [-c N] [-u USER] [-l NAME] IP PORT PROG 
Create UDP socket, bind to IP:PORT and wait for incoming packets. 
Run PROG for each packet, redirecting all further packets with same peer ip:port to it.

  IP IP to listen on. '0' = all 
  PORT Port to listen on 
  PROG [ARGS] Program to run
  
  -l NAME Local hostname (else looks up local hostname in DNS)
  -u USER[:GRP] Change to user/group after bind
  -c N Handle up to N connections simultaneously
  -h Look up peer hostname
  -E Do not set up environment variables
}

traceroute(TTL icmp|udp){
1. ICMP time exceeded     # 目的主站支持ping
2. ICMP port unreachable  # 目的主站不支持ping
traceroute [-dFlnrvx][-f<存活数值>][-g<网关>...][-i<网络界面>][-m<存活数值>][-p<通信端口>][-s<来源地址>][-t<服务类型>][-w<超时秒数>][主机名称或IP地址][数据包大小]
-d 使用Socket层级的排错功能。                              -d Set SO_DEBUG options to socket
-f 设置第一个检测数据包的存活数值TTL的大小。               
-F 设置勿离断位。                                          -F Set the do not fragment bit
-g 设置来源路由网关，最多可设置8个。                       -g Loose source route gateway (8 max)
-i 使用指定的网络界面送出数据包。                          
-I 使用ICMP回应取代UDP资料信息。                           -I Use ICMP ECHO instead of UDP datagrams
-m 设置检测数据包的最大存活数值TTL的大小。                 -m max_ttl Max time-to-live (max number of hops)
-n 直接使用IP地址而非主机名称。                            -n      Print hop addresses numerically rather than symbolically
-p 设置UDP传输协议的通信端口。                             -p port# Base UDP port number used in probes (default 33434)
-r 忽略普通的Routing Table，直接将数据包送到远端主机上。   -r Bypass the normal routing tables and send directly to a host
-s 设置本地主机送出数据包的IP地址。                        -s src_addr IP address to use as the source address
-t 设置检测数据包的TOS数值。                               -t tos Type-of-service in probe packets (default 0)
-v 详细显示指令的执行过程。                                
-w 设置等待远端主机回报的时间。                            -w wait Time in seconds to wait for a response (default 3 sec)
-x 开启或关闭数据包的正确性检验。                          
# 探测数据包向每个网关发送三个数据包后，网关响应后返回的时间；

[root@localhost ~]# traceroute www.baidu.com
  traceroute to www.baidu.com (61.135.169.125), 30 hops max, 40 byte packets
   1  192.168.74.2 (192.168.74.2)  2.606 ms  2.771 ms  2.950 ms
   2  211.151.56.57 (211.151.56.57)  0.596 ms  0.598 ms  0.591 ms
   3  211.151.227.206 (211.151.227.206)  0.546 ms  0.544 ms  0.538 ms
   4  210.77.139.145 (210.77.139.145)  0.710 ms  0.748 ms  0.801 ms
   5  202.106.42.101 (202.106.42.101)  6.759 ms  6.945 ms  7.107 ms
   6  61.148.154.97 (61.148.154.97)  718.908 ms * bt-228-025.bta.net.cn (202.106.228.25)  5.177 ms
   7  124.65.58.213 (124.65.58.213)  4.343 ms  4.336 ms  4.367 ms
   8  202.106.35.190 (202.106.35.190)  1.795 ms 61.148.156.138 (61.148.156.138)  1.899 ms  1.951 ms
   9  * * *
  30  * * *
  说明：
  记录按序列号从1开始，每个纪录就是一跳 ，每跳表示一个网关，我们看到每行有三个时间，单位是 ms，其实就是-q的默认参数。
  探测数据包向每个网关发送三个数据包后，网关响应后返回的时间；如果您用 traceroute -q 4 www.58.com ，表示向每个网关发送4个数据包。
# 有时我们traceroute 一台主机时，会看到有一些行是以星号表示的。出现这样的情况，可能是防火墙封掉了ICMP的返回信息，
# 所以我们得不到什么相关的数据包返回数据。
  有时我们在某一网关处延时比较长，有可能是某台网关比较阻塞，也可能是物理设备本身的原因。当然如果某台DNS出现问题时，
  不能解析主机名、域名时，也会有延时长的现象；您可以加-n 参数来避免DNS解析，以IP格式输出数据。
  如果在局域网中的不同网段之间，我们可以通过traceroute 来排查问题所在，是主机的问题还是网关的问题。
  如果我们通过远程来访问某台服务器遇到问题时，我们用到traceroute 追踪数据包所经过的网关，提交IDC服务商，也有助于解决问题；
  但目前看来在国内解决这样的问题是比较困难的，就是我们发现问题所在，IDC服务商也不可能帮
  
1. 记录按序列号从1开始，每个纪录就是一跳 ，每跳表示一个网关，我们看到每行有三个时间，单位是 ms，其实就是-q的默认参数。
2. 以星号表示的。出现这样的情况，可能是防火墙封掉了ICMP的返回信息，所以我们得不到什么相关的数据包返回数据。
3. 有时我们在某一网关处延时比较长，有可能是某台网关比较阻塞，也可能是物理设备本身的原因。
   当然如果某台DNS出现问题时，不能解析主机名、域名时，也会有延时长的现象；您可以加-n 参数来避免DNS解析，以IP格式输出数据。

traceroute -m 10 www.baidu.com  # 跳数设置
traceroute -n www.baidu.com     # 显示IP地址，不查主机名
traceroute -p 6888 www.baidu.com # 探测包使用的基本UDP端口设置6888
traceroute -q 4 www.baidu.com   # 把探测包的个数设置为值4
traceroute -r www.baidu.com     # 绕过正常的路由表，直接发送到网络相连的主机
traceroute -w 3 www.baidu.com   # 把对外发探测包的等待响应时间设置为3秒

Traceroute最简单的基本用法是：
    traceroute hostname Traceroute程序的设计是利用ICMP及IP header的TTL(Time To Live)栏位（field）。 
首先，traceroute送出一个TTL是1的IP datagram（其实，每次送出的为3个40字节的包，包括源地址，目的地址
和包发出的时间标签）到目的地， 当路径上的第一个路由器（router）收到这个datagram时，它将TTL减1。
此时，TTL变为0了，所以该路由器会将此datagram丢掉， 并送回一个「ICMP time exceeded」消息（包括发IP包
的源地址，IP包的所有内容及路由器的IP地址），traceroute 收到这个消息后， 便知道这个路由器存在于这个
路径上，接着traceroute 再送出另一个TTL是2 的datagram，发现第2 个路由器......

traceroute每次将送出的datagram的TTL 加1来发现另一个路由器，这个重复的动作一直持续到某个datagram 抵达目的地。
当datagram到达目的地后，该主机并不会送回ICMP time exceeded消息，因为它已是目的地了，那么traceroute如何得知目的地到达了呢？

    Traceroute在送出UDP datagrams到目的地时，它所选择送达的port number 是一个一般应用程序都不会用的号码（30000 以上），
所以当此UDP datagram 到达目的地后该主机会送回一个「ICMP port unreachable」的消息，而当traceroute 收到这个消息时，
便知道目的地已经到达了。所以traceroute 在Server端也是没有所谓的Daemon 程式。
}

netstat
/etc/init.d/network

tcpdump -D # 查看那些接口可以被监听, 一些USB HUB类接口也可以被监听
tcpdump -i eth0 # tcpdump -i any 从监听指定接口到监听任意接口
tcpdump -v # tcpdump -vv更加详细  -> tcpdump -vvv 非常详细
tcpdump -v -X # tcpdump -v -XX 输出hex和ASCII(包括链路层)  >  -x 与 -X 同时使用
tcpdump -F <file> # 选项越来越有用。这一选项通知 TCPDump 读取 <file> 文件的内容
tcpdump -r capture.cap

tcpdump -v icmp # arp ip tcp udp icmp 

tcpdump -n "broadcast or multicast"

tcpdump -n tcp dst portrange 1-1023
tcpdump -n udp dst portrange 1-1023
tcpdump -n dst portrange 1-1023

# 0x0800 ipv4    0x0806 arp    0x8100 tags vlan
# 0x8137 ipx  0x8808 flow control 0x86dd ipv6
# 0x8863 pppoe discovery 发现帧  0x8864 pppoe session 会话帧  0x8870 巨帧
tcpdump -i eth0 ether proto 0x0800 # ipv4
tcpdump -i eth0 ether proto 0x8100 # vlan
tcpdump -i eth0 -n ether proto 0x8863 '||' ether proto 0x8864 # pppoe

### 类型方向协议
type  # host, net, and port tcpdump net 1.2.3.0/24 | tcpdump port 3389 | tcpdump src port 1025
dir   # src, dst            tcpdump src 2.3.4.5    | tcpdump dst 3.4.5.6
proto # tcp, udp, icmp, ah  tcpdump icmp           | tcpdump ip6
tcpdump -i any
tcpdump -i eth0
tcpdump -ttttnnvvS
tcpdump host 1.2.3.4 
tcpdump -nnvXSs 0 -c1 icmp
tcpdump portrange 21-23
tcpdump less 32  | tcpdump greater 64 | tcpdump <= 128 # Packet Size
tcpdump port 80 -w capture_file
tcpdump -r capture_file
### 与或非
AND # and or &&
OR  # or or ||
EXCEPT #  not or !
tcpdump -nnvvS src 10.5.2.3 and dst port 3389
tcpdump -nvX src net 192.168.0.0/16 and dst net 10.0.0.0/8 or 172.16.0.0/16
tcpdump dst 192.168.0.2 and src net and not icmp
tcpdump -vv src mars and not dst port 22
tcpdump 'src 10.0.2.4 and (dst port 3389 or 22)'

### TCP 详细信息
TCP flag(s).
tcpdump 'tcp[13] & 32!=0'  # Show me all URGENT (URG) packets…
tcpdump 'tcp[13] & 16!=0'  # Show me all ACKNOWLEDGE (ACK) packets…
tcpdump 'tcp[13] & 8!=0'   # Show me all PUSH (PSH) packets…
tcpdump 'tcp[13] & 4!=0'   # Show me all RESET (RST) packets…
tcpdump 'tcp[13] & 2!=0'   # Show me all SYNCHRONIZE (SYN) packets…
tcpdump 'tcp[13] & 1!=0'   # Show me all FINISH (FIN) packets…
tcpdump 'tcp[13]=18'       # Show me all SYNCHRONIZE/ACKNOWLEDGE (SYNACK) packets…
tcpdump 'tcp[tcpflags] == tcp-syn'
tcpdump 'tcp[tcpflags] == tcp-rst'
tcpdump 'tcp[tcpflags] == tcp-fin'
tcpdump 'tcp[13] = 6'
tcpdump 'tcp[32:4] = 0x47455420'
tcpdump 'tcp[(tcp[12]>>2):4] = 0x5353482D'
tcpdump 'ip[8] < 10'
tcpdump 'ip[6] & 128 != 0'

# 基本原语
算数运算符 # +、-、*、/、>、<、>=、<=、=、!= 及其他运算符
broadcast
gateway
greater
less

算数运算符包括 +、-、*、/、>、<、>=、<=、=、!= 及其他运算符。


tcpdump -i any -s 1500 -C "$fragment" -W "$splits"  port "$port" -w ./cbtc.pcap -Z root 

# wireshark，tshark 和 ngrep
tcpdump(用户拦截和显示发送或收到过网络连接到该计算机的TCP/IP和其他数据包){
 -A #以ASCII码方式显示每一个数据包(不会显示数据包中链路层头部信息). 在抓取包含网页数据的数据包时, 可方便查看数据(nt: 即Handy for capturing web pages).
 -b #Print the AS number in BGP packets in ASDOT notation rather than ASPLAIN notation.
 -B #设置操作系统的捕获缓冲区大小buffer_size
 -c #tcpdump将在接受到count个数据包后退出
 -C file-size   #(nt: 此选项用于配合-w file 选项使用)该选项使得tcpdump 在把原始数据包直接保存到文件中之前, 检查此文件大小是否超过file-size. 如果超过了, 将关闭此文件,另创一个文件继续用于原始数据包的记录. 新创建的文件名与-w 选项指定的文件名一致, 但文件名后多了一个数字.该数字会从1开始随着新创建文件的增多而增加. file-size的单位是百万字节(nt: 这里指1,000,000个字节,并非1,048,576个字节, 后者是以1024字节为1k, 1024k字节为1M计算所得, 即1M=1024 ＊ 1024 = 1,048,576)
 -d #以容易阅读的形式,在标准输出上打印出编排过的包匹配码, 随后tcpdump停止(human readable, 容易阅读的,通常是指以ascii码来打印一些信息)
 -dd        #以C语言的形式打印出包匹配码.
 -ddd       #以十进制数的形式打印出包匹配码(会在包匹配码之前有一个附加的'count'前缀).
 -D #
# 打印系统中所有tcpdump可以在其上进行抓包的网络接口. 每一个接口会打印出数字编号, 相应的接口名字, 以及可能的一个网络接口描述. 其中网络接口名字和数字编号可以用在tcpdump 的-i flag 选项(nt: 把名字或数字代替flag), 来指定要在其上抓包的网络接口.
# 此选项在不支持接口列表命令的系统上很有用(nt: 比如, Windows 系统, 或缺乏 ifconfig -a 的UNIX系统); 接口的数字编号在windows 2000 或其后的系统中很有用, 因为这些系统上的接口名字比较复杂, 而不易使用.
# 如果tcpdump编译时所依赖的libpcap库太老,-D 选项不会被支持, 因为其中缺乏 pcap_findalldevs()函数.
 -e			#每行的打印输出中将包括数据包的数据链路层头部信息
 -E  spi@ipaddr algo:secret,...			#
# 可通过spi@ipaddr algo:secret 来解密IPsec ESP包(nt | rt:IPsec Encapsulating Security Payload,IPsec 封装安全负载, IPsec可理解为, 一整套对ip数据包的加密协议, ESP 为整个IP 数据包或其中上层协议部分被加密后的数据,前者的工作模式称为隧道模式; 后者的工作模式称为传输模式 . 工作原理, 另需补充).
# 需要注意的是, 在终端启动tcpdump 时, 可以为IPv4 ESP packets 设置密钥(secret).
# 可用于加密的算法包括des-cbc, 3des-cbc, blowfish-cbc, rc3-cbc, cast128-cbc, 或者没有(none).默认的是des-cbc(nt: des, Data Encryption Standard, 数据加密标准, 加密算法未知, 另需补充).
# secret 为用于ESP 的密钥, 使用ASCII 字符串方式表达. 如果以 0x 开头, 该密钥将以16进制方式读入.
# 该选项中ESP 的定义遵循RFC2406, 而不是 RFC1827. 并且, 此选项只是用来调试的, 不推荐以真实密钥(secret)来使用该选项, 因为这样不安全: 在命令行中输入的secret 可以被其他人通过ps 等命令查看到.
# 除了以上的语法格式(nt: 指spi@ipaddr algo:secret), 还可以在后面添加一个语法输入文件名字供tcpdump 使用(nt：即把spi@ipaddr algo:secret,... 中...换成一个语法文件名). 此文件在接受到第一个ESP　包时会打开此文件, 所以最好此时把赋予tcpdump 的一些特权取消(nt: 可理解为, 这样防范之后, 当该文件为恶意编写时,不至于造成过大损害).
 -f			#
#  显示外部的IPv4 地址时(nt: foreign IPv4 addresses, 可理解为, 非本机ip地址), 采用数字方式而不是名字.(此选项是用来对付Sun公司的NIS服务器的缺陷(nt: NIS, 网络信息服务, tcpdump 显示外部地址的名字时会用到她提供的名称服务): 此NIS服务器在查询非本地地址名字时,常常会陷入无尽的查询循环).
#  由于对外部(foreign)IPv4地址的测试需要用到本地网络接口(nt: tcpdump 抓包时用到的接口)及其IPv4 地址和网络掩码. 如果此地址或网络掩码不可用, 或者此接口根本就没有设置相应网络地址和网络掩码(nt: linux 下的 'any' 网络接口就不需要设置地址和掩码, 不过此'any'接口可以收到系统中所有接口的数据包), 该选项不能正常工作.
 -F			#使用file 文件作为过滤条件表达式的输入, 此时命令行上的输入将被忽略
 -G			#
#  If  specified,  rotates  the  dump file specified with the -w option every rotate_seconds seconds.  Savefiles will have the name specified by -w which should include a time format as defined by strftime(3).  If no time format is specified, each new file will overwrite the previous.
#  If used in conjunction with the -C option, filenames will take the form of "file<count>".
 -h			#显示tcpdump和libpcap版本号，打印用法信息
 -H			#Attempt to detect 802.11s draft mesh headers.
 -i interface   #
 # 指定tcpdump 需要监听的接口。如果没有指定, tcpdump 会从系统接口列表中搜寻编号最小的已配置好的接口(不包括 loopback 接口).一但找到第一个符合条件的接口, 搜寻马上结束.
 # 在采用2.2版本或之后版本内核的Linux 操作系统上, 'any' 这个虚拟网络接口可被用来接收所有网络接口上的数据包(nt: 这会包括目的是该网络接口的, 也包括目的不是该网络接口的). 需要注意的是如果真实网络接口不能工作在'混杂'模式(promiscuous)下,则无法在'any'这个虚拟的网络接口上抓取其数据包.
 # 如果 -D 标志被指定, tcpdump会打印系统中的接口编号，而该编号就可用于此处的interface 参数.
 -I			#
 # Put the interface in "monitor mode"; this is supported only on IEEE 802.11 Wi-Fi interfaces, and supported only on some operating systems.
 # Note that in monitor mode the adapter might disassociate from the network with which it's associated, so that you will not be able to use any wireless  networks  with  that adapter.   This  could prevent accessing files on a network server, or resolving host names or network addresses, if you are capturing in monitor mode and are not connected to another network with another adapter.
 # This flag will affect the output of the -L flag.  If -I isn't specified, only those link-layer types available when not in monitor mode will be shown; if -I  is  specified,only those link-layer types available when in monitor mode will be shown.
 -j			#Set the time stamp type for the capture to tstamp_type. The names to use for the time stamp types are given in pcap-tstamp-type(7); not all the types listed there will necessarily be valid for any given interface.
 -J			#List the supported time stamp types for the interface and exit.  If the time stamp type cannot be set for the interface, no time stamp types are listed.
 -K			#Don't attempt to verify IP, TCP, or UDP checksums.  This is useful for interfaces that perform some or all of those checksum calculation in hardware; otherwise, all outgoing TCP checksums will be flagged as bad.
 -l			#
 对标准输出进行行缓冲(nt: 使标准输出设备遇到一个换行符就马上把这行的内容打印出来).在需要同时观察抓包打印以及保存抓包记录的时候很有用. 比如, 可通过以下命令组合来达到此目的:
 "tcpdump  -l  |  tee dat" or "tcpdump  -l   > dat  &  tail  -f  dat".(nt: 前者使用tee来把tcpdump 的输出同时放到文件dat和标准输出中, 而后者通过重定向操作'>', 把tcpdump的输出放到dat 文件中, 同时通过tail把dat文件中的内容放到标准输出中)
 -L			#列出指定网络接口所支持的数据链路层的类型后退出.(nt: 指定接口通过-i 来指定)
 -m module		#通过module 指定的file 装载SMI MIB 模块(nt: SMI，Structure of Management Information, 管理信息结构MIB, Management Information Base, 管理信息库. 可理解为, 这两者用于SNMP(Simple Network Management Protoco)协议数据包的抓取. 具体SNMP 的工作原理未知, 另需补充).此选项可多次使用, 从而为tcpdump 装载不同的MIB 模块.
 -M secret		#如果TCP 数据包(TCP segments)有TCP-MD5选项(在RFC 2385有相关描述), 则为其摘要的验证指定一个公共的密钥secret.
 -n			#不对地址(比如, 主机地址, 端口号)进行数字表示到名字表示的转换.
 -N			#不打印出host 的域名部分. 比如, 如果设置了此选现, tcpdump 将会打印'nic' 而不是 'nic.ddn.mil'.
 -O			#不启用进行包匹配时所用的优化代码. 当怀疑某些bug是由优化代码引起的, 此选项将很有用.
 -p			#一般情况下, 把网络接口设置为非'混杂'模式. 但必须注意 , 在特殊情况下此网络接口还是会以'混杂'模式来工作； 从而, '-p' 的设与不设, 不能当做以下选现的代名词:'ether host {local-hw-add}' 或  'ether broadcast'(nt: 前者表示只匹配以太网地址为host 的包, 后者表示匹配以太网地址为广播地址的数据包).
 -q			#快速(也许用'安静'更好?)打印输出. 即打印很少的协议相关信息, 从而输出行都比较简短.
 -R			#设定tcpdump 对 ESP/AH 数据包的解析按照 RFC1825而不是RFC1829(nt: AH, 认证头, ESP， 安全负载封装, 这两者会用在IP包的安全传输机制中). 如果此选项被设置, tcpdump 将不会打印出'禁止中继'域(nt: relay prevention field). 另外,由于ESP/AH规范中没有规定ESP/AH数据包必须拥有协议版本号域,所以tcpdump不能从收到的ESP/AH数据包中推导出协议版本号.
 -r file		#从文件file 中读取包数据. 如果file 字段为 '-' 符号, 则tcpdump 会从标准输入中读取包数据.
 -S			#打印TCP 数据包的顺序号时, 使用绝对的顺序号, 而不是相对的顺序号.(nt: 相对顺序号可理解为, 相对第一个TCP 包顺序号的差距,比如, 接受方收到第一个数据包的绝对顺序号为232323, 对于后来接收到的第2个,第3个数据包, tcpdump会打印其序列号为1, 2分别表示与第一个数据包的差距为1 和 2. 而如果此时-S 选项被设置, 对于后来接收到的第2个, 第3个数据包会打印出其绝对顺序号:232324, 232325).
 -s snaplen		#设置tcpdump的数据包抓取长度为snaplen, 如果不设置默认将会是68字节(而支持网络接口分接头(nt: NIT, 上文已有描述,可搜索'网络接口分接头'关键字找到那里)的SunOS系列操作系统中默认的也是最小值是96).68字节对于IP, ICMP(nt: Internet Control Message Protocol,因特网控制报文协议), TCP 以及 UDP 协议的报文已足够, 但对于名称服务(nt: 可理解为dns, nis等服务), NFS服务相关的数据包会产生包截短. 如果产生包截短这种情况, tcpdump的相应打印输出行中会出现''[|proto]''的标志(proto 实际会显示为被截短的数据包的相关协议层次). 需要注意的是, 采用长的抓取长度(nt: snaplen比较大), 会增加包的处理时间, 并且会减少tcpdump 可缓存的数据包的数量， 从而会导致数据包的丢失. 所以, 在能抓取我们想要的包的前提下, 抓取长度越小越好.把snaplen 设置为0 意味着让tcpdump自动选择合适的长度来抓取数据包.
 -T type		#强制tcpdump按type指定的协议所描述的包结构来分析收到的数据包.  目前已知的type 可取的协议为:aodv (Ad-hoc On-demand Distance Vector protocol, 按需距离向量路由协议, 在Ad hoc(点对点模式)网络中使用),cnfp (Cisco  NetFlow  protocol),  rpc(Remote Procedure Call), rtp (Real-Time Applications protocol),rtcp (Real-Time Applications con-trol protocol), snmp (Simple Network Management Protocol),tftp (Trivial File Transfer Protocol, 碎文件协议), vat (Visual Audio Tool, 可用于在internet 上进行电视电话会议的应用层协议), 以及wb (distributed White Board, 可用于网络会议的应用层协议).
 -t			#在每行输出中不打印时间戳
 -tt			#不对每行输出的时间进行格式处理(nt: 这种格式一眼可能看不出其含义, 如时间戳打印成1261798315)
 -ttt			#输出时, 打印现在和以前的行之间的时间增量(以毫秒为单位)
 -tttt			#在每行打印的时间戳之前添加日期的打印
 -ttttt			#输出时, 打印现在和最开始的行之间的时间增量(以毫秒为单位)
 -u			#打印出未加密的NFS 句柄(nt: handle可理解为NFS 中使用的文件句柄, 这将包括文件夹和文件夹中的文件)
 -U			#
 # 使得当tcpdump在使用-w 选项时, 其文件写入与包的保存同步.(nt: 即, 当每个数据包被保存时, 它将及时被写入文件中,而不是等文件的输出缓冲已满时才真正写入此文件)
 -U 标志在老版本的libcap库(nt: tcpdump 所依赖的报文捕获库)上不起作用, 因为其中缺乏pcap_cump_flush()函数.
 -v			#
 # 当分析和打印的时候, 产生详细的输出. 比如, 包的生存时间, 标识, 总长度以及IP包的一些选项. 这也会打开一些附加的包完整性检测, 比如对IP或ICMP包头部的校验和
 # 当用-w选项写入到一个文件中时候，报告，每10秒捕获的数据包数量
 -vv			#产生比-v更详细的输出. 比如, NFS回应包中的附加域将会被打印, SMB数据包也会被完全解码.
 -vvv			#产生比-vv更详细的输出.  (For example, telnet SB ... SE options are printed in full.  With -X Telnet options are printed in hex as well)
 -w			#把包数据直接写入文件而不进行分析和打印输出. 这些包数据可在随后通过-r 选项来重新读入并进行分析和打印
 -W filecount			#
 # 此选项与-C 选项配合使用, 这将限制可打开的文件数目, 并且当文件数据超过这里设置的限制时, 依次循环替代之前的文件, 这相当于一个拥有filecount 个文件的文件缓冲池. 同时, 该选项会使得每个文件名的开头会出现足够多并用来占位的0, 这可以方便这些文件被正确的排序.
 # 此选项与-G选项一起使用，这将限制已建立的循环调试文件的数量  当达到限制数，会退出返回0，同样的，如果使用-C，这种行为会导致每时间段周期性文件
 -x			#当分析和打印时, tcpdump 会打印每个包的头部数据, 同时会以16进制打印出每个包的数据(但不包括连接层的头部).总共打印的数据大小不会超过整个数据包的大小与snaplen 中的最小值. 必须要注意的是, 如果高层协议数据没有snaplen 这么长,并且数据链路层(比如, Ethernet层)有填充数据, 则这些填充数据也会被打印.(nt: so for link  layers  that pad, 未能衔接理解和翻译)
 -xx			#tcpdump 会打印每个包的头部数据, 同时会以16进制打印出每个包的数据, 其中包括数据链路层的头部.
 -X			#当分析和打印时, tcpdump 会打印每个包的头部数据, 同时会以16进制和ASCII码形式打印出每个包的数据(但不包括连接层的头部).这对于分析一些新协议的数据包很方便.
 -XX			#当分析和打印时, tcpdump 会打印每个包的头部数据, 同时会以16进制和ASCII码形式打印出每个包的数据, 其中包括数据链路层的头部.这对于分析一些新协议的数据包很方便.
 -y datalinktype	#设置tcpdump 只捕获数据链路层协议类型是datalinktype的数据包
 -z			# Used in conjunction with the -C or -G options, this will make tcpdump run " command file " where file is the savefile being closed after each rotation. For example,  specifying -z gzip or -z bzip2 will compress each savefile using gzip or bzip2.
            # Note that tcpdump will run the command in parallel to the capture, using the lowest priority so that this does not disturb the capture process.
            # And in case you would like to use a command that itself takes flags or different arguments, you can always write a shell script that will take the savefile name as the only argument, make the flags & arguments arrangements and execute the command that you want.
 -Z user		#
 # 使tcpdump 放弃自己的超级权限(如果以root用户启动tcpdump, tcpdump将会有超级用户权限), 并把当前tcpdump的用户ID设置为user, 组ID设置为user首要所属组的ID(nt: tcpdump 此处可理解为tcpdump 运行之后对应的进程)
 # 此选项也可在编译的时候被设置为默认打开. 
    }
    网卡流量查看{

        watch more /proc/net/dev    # 实时监控流量文件系统 累计值
        iptraf                      # 网卡流量查看工具
        nethogs -d 5 eth0 eth1      # 按进程实时统计网络流量 epel源nethogs
        iftop -i eth0 -n -P         # 实时流量监控

statistics(){
1.  输出当前系统中占用内存最多的5条命令:
#1) 通过ps命令列出当前主机正在运行的所有进程。
#2) 按照第五个字段基于数值的形式进行正常排序(由小到大)。
#3) 仅显示最后5条输出。
/> ps aux | sort -k 5n | tail -5

2.  找出cpu利用率高的20个进程:
#1) 通过ps命令输出所有进程的数据，-o选项后面的字段列表列出了结果中需要包含的数据列。
#2) 将ps输出的Title行去掉，grep -v PID表示不包含PID的行。
#3) 基于第一个域字段排序，即pcpu。n表示以数值的形式排序。
#4) 输出按cpu使用率排序后的最后20行，即占用率最高的20行。
/> ps -e -o pcpu,pid,user,sgi_p,cmd | grep -v PID | sort -k 1n | tail -20

3.  获取当前系统物理内存的总大小:
#1) 以兆(MB)为单位输出系统当前的内存使用状况。
#2) 通过grep定位到Mem行，该行是以操作系统为视角统计数据的。
#3) 通过awk打印出该行的第二列，即total列。
/> free -m | grep "Mem" | awk '{print $2, "MB"}'

1.  获取当前或指定目录下子目录所占用的磁盘空间，并将结果按照从大到小的顺序输出:
#1) 输出/usr的子目录所占用的磁盘空间。
#2) 以数值的方式倒排后输出。
/> du -s /usr/* | sort -nr

3.  统计当前目录下文件和目录的数量:
#1) ls -l命令列出文件和目录的详细信息。
#2) ls -l输出的详细列表中的第一个域字段是文件或目录的权限属性部分，如果权限属性部分的第一个字符为d，
#    该文件为目录，如果是-，该文件为普通文件。
#3) 通过wc计算grep过滤后的行数。
/> ls -l * | grep "^-" | wc -l
/> ls -l * | grep "^d" | wc -l

5.  将查找到的文件打包并copy到指定目录:
#1) 通过find找到当前目录下(包含所有子目录)的所有*.txt文件。
#2) tar命令将find找到的结果压缩成test.tar压缩包文件。
#3) 如果&&左侧括号内的命令正常完成，则可以执行&&右侧的shell命令了。
#4) 将生成后的test.tar文件copy到/home/.目录下。
/> (find . -name "*.txt" | xargs tar -cvf test.tar) && cp -f test.tar /home/.
}
pidstat(显示进程|任务的相关的统计){
        
   # pidstat主要用于监控全部或指定进程占用系统资源的情况，如CPU，内存、设备IO、任务切换、线程等。
   # pidstat首次运行时显示自系统启动开始的各项统计信息，之后运行pidstat将显示自上次运行该命令以后的统计信息。
   # 用户可以通过指定统计的次数和时间来获得所需的统计信息。
   
 -C comm		#只显示那些包含字符串(可是正则表达式)comm的命令的名字
 -d			#显示I/O统计信息(须内核2.6.20及以后)
    PID			        #进程号
    kB_rd/s			#每秒此进程从磁盘读取的千字节数
    kB_wr/s			#此进程已经或者将要写入磁盘的每秒千字节数
    kB_ccwr/s			#由任务取消的写入磁盘的千字节数
    Command			#命令的名字
 -h			#显示所有的活动的任务
 -I			#在SMP环境，指出任务的CPU使用(等同于选项-u)应该被除于cpu的总数
 -l			#显示进程的命令名和它的参数
 -p { pid [,...] | SELF | ALL }		#指定线程显示其报告
 -r			#显示分页错误的内存利用率
    When reporting statistics for individual tasks, the following values are displayed:
    PID			        #进程号
    minflt/s			#每秒次缺页错误次数(minor page faults)，次缺页错误次数意即虚拟内存地址映射成物理内存地址产生的page fault次数
    majflt/s			#每秒主缺页错误次数(major page faults)，当虚拟内存地址映射成物理内存地址时，相应的page在swap中，这样的page fault为major page fault，一般在内存使用紧张时产生
    VSZ			        #该进程使用的虚拟内存(以kB为单位)
    RSS			        #该进程使用的物理内存(以kB为单位)
    %MEM			#当前任务使用的有效内存的百分比
    Command			#任务的命令名             
    When reporting global statistics for tasks and all their children, the following values are displayed:
    PID			        #PID号
    minflt-nr			#在指定的时间间隔内收集的进程和其子进程的次缺页错误次数
    majflt-nr			#在指定的时间间隔内收集的进程和其子进程的主缺页错误次数
    Command			#命令名
 -s			#堆栈的使用
 -t			#显示与所选任务相关的线程的统计数据
 -T { TASK | CHILD | ALL }	#指定必须监测的内容：TASK是默认的，单个任务的报告；CHILD：指定的进程和他们的子进程的全局报告，ALL：相当于TASK和CHILD
 -u			#报告CPU使用
    When reporting statistics for individual tasks, the following values are displayed: 
    PID
    %usr			#用户层任务正在使用的CPU百分比(with or without nice priority ，NOT include time spent running a virtual processor)
    %system			#系统层正在执行的任务的CPU使用百分比
    %guest			#运行虚拟机的CPU占用百分比
    %CPU			#所有的使用的CPU的时间百分比
    CPU			        #处理器数量
    Command			#命令
    When reporting global statistics for tasks and all their children, the following values are displayed:
    PID			        #PID号
    usr-ms			#在指定时间内收集的在用户层执行的进程和它的子进程占用的CPU时间(毫秒){with or without nice priority，NOT include time spent running a virtual processor)
    system-ms			#在指定时间内收集的在系统层执行的进程和它的子进程占用的CPU时间(毫秒)
    guest-ms			#花在虚拟机上的时间
    Command			#命令
 -V			#版本号
 -w			#报告任务切换情况
    PID			        #PID号
    cswch/s			#每秒自动上下文切换
    nvcswch/s			#每秒非自愿的上下文切换
    Command			#命令
    
pidstat 2 5                     
pidstat -r -p 1643 2 5          
pidstat -C "fox|bird" -r -p ALL 
pidstat -T CHILD -r 2 5 
    }
    fbset(){
    mode "1280x800-60"
        # D: 79.008 MHz, H: 49.504 kHz, V: 60.004 Hz
        geometry 1280 800 1280 1600 32
        timings 12657 180 100 6 16 36 3
        accel false
        rgba 8/16,8/8,8/0,8/24
    endmode
    }
      nmeter(Monitor system in real time){ busybox
      nmeter '%250d%t %20c int %i bio %b mem %m forks%p'
      }
strees(){
strees: 压测命令，–cpu cpu压测选项，-i io压测选项，-c 进程数压测选项，–timeout 执行时间
stress -i 1 --hdd 1 --timeout 600 # --hdd表示读写临时文件 %iowait
stress --cpu 8 --io 4 --vm 2 --vm-bytes 128M -- timeout 100s
}

http://brick.kernel.dk/snaps/ 
  fio(){
filename=/dev/emcpowerb　支持文件系统或者裸设备，-filename=/dev/sda2或-filename=/dev/sdb
direct=1                 测试过程绕过机器自带的buffer，使测试结果更真实
rw=randwread             测试随机读的I/O
rw=randwrite             测试随机写的I/O
rw=randrw                测试随机混合写和读的I/O
rw=read                  测试顺序读的I/O
rw=write                 测试顺序写的I/O
rw=rw                    测试顺序混合写和读的I/O
bs=4k                    单次io的块文件大小为4k
bsrange=512-2048         同上，提定数据块的大小范围
size=5g                  本次的测试文件大小为5g，以每次4k的io进行测试
numjobs=30               本次的测试线程为30
runtime=1000             测试时间为1000秒，如果不写则一直将5g文件分4k每次写完为止
ioengine=psync           io引擎使用pync方式，如果要使用libaio引擎，需要yum install libaio-devel包
rwmixwrite=30            在混合读写的模式下，写占30%
group_reporting          关于显示结果的，汇总每个进程的信息
此外
lockmem=1g               只使用1g内存进行测试
zero_buffers             用0初始化系统buffer
nrfiles=8                每个进程生成文件的数量

# 测试用例
100%随机，100%读， 4K
fio -filename=/dev/emcpowerb -direct=1 -iodepth 1 -thread -rw=randread -ioengine=psync -bs=4k -size=1000G -numjobs=50 -runtime=180 -group_reporting -name=rand_100read_4k
100%随机，100%写， 4K
fio -filename=/dev/emcpowerb -direct=1 -iodepth 1 -thread -rw=randwrite -ioengine=psync -bs=4k -size=1000G -numjobs=50 -runtime=180 -group_reporting -name=rand_100write_4k
100%顺序，100%读 ，4K
fio -filename=/dev/emcpowerb -direct=1 -iodepth 1 -thread -rw=read -ioengine=psync -bs=4k -size=1000G -numjobs=50 -runtime=180 -group_reporting -name=sqe_100read_4k
100%顺序，100%写 ，4K
fio -filename=/dev/emcpowerb -direct=1 -iodepth 1 -thread -rw=write -ioengine=psync -bs=4k -size=1000G -numjobs=50 -runtime=180 -group_reporting -name=sqe_100write_4k
100%随机，70%读，30%写 4K
fio -filename=/dev/emcpowerb -direct=1 -iodepth 1 -thread -rw=randrw -rwmixread=70 -ioengine=psync -bs=4k -size=1000G -numjobs=50 -runtime=180 -group_reporting -name=randrw_70read_4k
# 输出内容
io=执行了多少M的IO

bw=平均IO带宽
iops=IOPS
runt=线程运行时间
slat=提交延迟
clat=完成延迟
lat=响应时间
bw=带宽
cpu=利用率
IO depths=io队列
IO submit=单个IO提交要提交的IO数
IO complete=Like the above submit number, but for completions instead.
IO issued=The number of read/write requests issued, and how many of them were short.
IO latencies=IO完延迟的分布

io=总共执行了多少size的IO
aggrb=group总带宽
minb=最小.平均带宽.
maxb=最大平均带宽.
mint=group中线程的最短运行时间.
maxt=group中线程的最长运行时间.

ios=所有group总共执行的IO数.
merge=总共发生的IO合并数.
ticks=Number of ticks we kept the disk busy.
io_queue=花费在队列上的总共时间.
util=磁盘利用率
  }
  
slurm(网络监测){
slurm -i <网卡名称>
   slurm 界面中可以执行如下选项：
I：显示lx/tx状态
c：切换到经典界面
r：手动刷新界面
q：退出工具
}
sar - nethogs ngxtop vmstat
        sar(收集，报告或保存系统活动信息) {

        sar(网络监测){
        # 可以从多方面对系统的活动进行报告，如CPU利用率，磁盘I/O，内存的使用等等。
          -n参数有6个不同的开关: DEV, EDEV, NFS, NFSD, SOCK, IP, EIP, ICMP, EICMP, TCP, ETCP, UDP, SOCK6, IP6, EIP6, ICMP6,EICMP6 and UDP6.
          DEV显示网络接口信息
          EDEV显示关于网络错误的统计数据
          NFS统计活动的NFS客户端的信息
          NFSD统计NFS服务器的信息
          SOCK显示套接字信息
          ALL显示所有5个开关
}
1. 怀疑CPU存在瓶颈，可用 sar -u 和 sar -q 等来查看
2. 怀疑内存存在瓶颈，可用 sar -B、sar -r 和 sar -W 等来查看
3. 怀疑I/O存在瓶颈，可用 sar -b、sar -u 和 sar -d 等来查看

        sar -n DEV 1 10

-A			#等同于指定-bBdHqrRSuvwWy -I SUM -I XALL -m ALL -n ALL -u ALL -P ALL
-b			#IO和传输速率统计
   tps				#每秒设备发出的传输总数。一次传输就是对设备的一个I/O请求，多个逻辑请求可被整合成一个单一的I/O请求。因此一次传输具体无法确定大小。
   rtps				#每秒发给设备的读请求数
   wtps				#每秒发给设备的写请求数
   bread/s			#每秒从设备读的数据总数，用blocks表示，等同于扇区数，因此有一个大小512 bytes
   bwrtn/s			#每秒写到设备的数据总数
-B			#分页信息
   pgpgin/s			#每秒系统从磁盘置入分页的千字节数 
   pgpgout/s			#每秒系统从磁盘移出分页的千字节数
   fault/s			#由系统造成的分页错误数，这不是一个产生的I/ O页面错误数，因为一些缺页故障可以解决without I/O
   majflt/s			#系统每秒产生的严重故障，这些必须要加载一个存储页面从磁盘
   pgfree/s			#系统每秒强加于空闲列表的页数
   pgscank/s			#每秒页面交换守护进程已扫描的页数
   pgscand/s			#每秒直接扫描的页数
   pgsteal/s			#系统满足自身的内存需要，每秒从缓存回收的页数
   %vmeff			#Calculated as pgsteal/pgscan，衡量分页回收有效性的指标。If it is near 100% then  almost  every  page coming off the tail of the inactive list is being reaped. If it gets too low (e.g. less than 30%) then the virtual memory is having some difficulty.  This field  is  displayed  as zero if no pages have been scanned during the interval of time.
-C			#When reading data from a file, tell sar to display comments that have been inserted by sadc.
-d			#磁盘设备的信息
   tps				#同-b选项的tps         
   rd_sec/s			#从设备读取的扇区数，每个删除512bytes
   wr_sec/s			#写入设备的扇区数
   avgrq-sz			#发给设备的请求的平均大小(in sectors)
   avgqu-sz			#发给设备的请求的平均队列长度
   await			#设备处理的I/O请求的平均时间(in milliseconds)，包含请求在队列中的时间和处理它们的时间
   svctm			#This field will be removed in a future sysstat version.
   %util			#发给设备的I/O请求的时间占用CPU时间的百分比
-e [ hh:mm:ss ]		#指定报告结束时间，不指定时间，默认为18:00:00
-f [ filename ]		#从文件中提取报告，不指定文件默认：/var/log/sysstat/sadd
-h			#帮助信息
-H			#hugepage使用情况
   kbhugfree			#还没有被分派的内存hugepages的千字节数
   kbhugused			#已被分派的内存hugepages的千字节数
   %hugused			#已被分派的内存hugepages所占的百分比
-i interval		#Select data records at seconds as close as possible to the number specified by the interval parameter.
-I { int [,...] | SUM | ALL | XALL }		#中断统计，int为中断号，SUM为每秒接收到的中断数，ALL为统计前16个中断，XALL显示所有中断
-m { keyword [,...] | ALL }		#电源管理信息(Possible keywords are CPU, FAN, FREQ, IN, TEMP and USB)
-n { keyword [,...] | ALL }			#网络统计信息(Possible  keywords  are DEV, EDEV, NFS, NFSD, SOCK, IP, EIP, ICMP, EICMP, TCP, ETCP, UDP, SOCK6, IP6, EIP6,ICMP6, EICMP6 and UDP6.)
   DEV			#统计来自网络设备的信息
   EDEV			#统计从网络设备错误信息
   NFS 			#关于NFS客户端的活动状态统计
   NFSD			#关于NFS服务端的活动状态统计
   SOCK			#正在用的套接字的统计信息
   IP			#关于IPv4的网络流量的统计
   EIP			#关于IPv4网络错误信息的统计
   ICMP			#关于ICMPv4网络流量的信息统计
   EICMP		#关于ICMPv4错误信息的统计
   TCP			#关于TCPv4的网络流量的统计
   ETCP			#TCPv4的网络错误的统计
   UDP			#UDPv4网络流量的信息统计
   SOCK6		#正在用的SOCK的信息(IPv6)
   IP6			#关于IPv6的网络流量报告
   EIP6			#IPv6网络错误信息
   ICMP6		#ICMPv6网络流量
   EICMP6		#ICMPv6网络错误
   UDP6			#UDPv6网络流量
-o [ filename ]				#保存显示的信息到一个文件中，默认在/var/log/sysstat/sadd
-P { cpu [,...] | ALL }			#处理器的统计信息，cpu为CPU的编号，ALL为每一个CPU的信息和全局的CPU信息
-p		#显示设备名字，与-d一起使用
-q		#队列长度和平均负载
   runq-sz		#运行的队列长度(number of tasks waiting for run time).
   plist-sz		#在任务列表中的任务数
   ldavg-1		#1分钟内的负载The load average is calculated as the average number of runnable or running tasks (R state), and the number of tasks in uninterruptible sleep (D state) over the specified interval.
   ldavg-5		#5分钟内的负载
   ldavg-15		#15分钟内的负载
   blocked		#当前被阻塞的任务数
-r		#报告内存的使用
   kbmemfree		#可用的空闲内存(kilobytes)
   kbmemused		#已用的内存(kilobytes，This does not take into account memory used by the kernel itself.)
   %memused		#使用内存的百分比
   kbbuffers		#作为内核缓存区的被使用的内存
   kbcached		#作为缓存数据的被使用的内存
   kbcommit		#对于现在的工作量需要的内存，是估算多少内存被需要以保证不会内存不足
   %commit		#正在使用的内存占总内存(RAM+swap)的的百分比
   kbactive		#活动的内存
   kbinact		#不活动的内存
-R			#内存信息
   frmpg/s			#每秒释放的内存页，负数代表被指派的内存数(a page has a size of 4 kB or 8 kB)
   bufpg/s			#每秒辅助存储的页被用做缓冲区的数
   campg/s			#每秒辅助存储器重的页被用做缓存的数目
-s [ hh:mm:ss ]			#设定报告开始的时间，默认为08:00:00
-S			#交换空间的使用
   kbswpfree			#空闲的交换空间数(kilobytes)
   kbswpused			#被使用的交换空间数
   %swpused			#使用的空间所占的百分比
   kbswpcad			#用作内存缓冲的交换(kilobytes)
   %swpcad			#用作内存缓冲的空间所占总的已使用的交换空间的百分比
-t			#读取文件时，指定时间
-u [ ALL ]		#CPU使用情况，指定ALL表示显示所有字段
   %user			#在用户层执行的程序所占的CPU利用率(Note that this field includes time spent running virtual processors.)
   %usr				#在用户层执行的程序所占的CPU利用率(Note that this field NOT includes time spent running virtual processors.)
   %nice			#在用户层有优先权的程序所占的CPU利用率
   %system		        #在系统层执行的程序所占的CPU利用率Note  that this field includes time spent servicing hardware and software interrupts
   %sys				#在系统层执行的程序所占的CPU利用率Note  that this field NOT include time spent servicing hardware and software interrupts
   %iowait		        #系统因未解决的磁盘IO请求而闲置的时间百分比
   %steal			#显示当管理程序维护另一个虚拟处理器，虚拟的cpu花在强制等待的时间百分比
   %irq				#CPU服务于硬件中断所花费的时间的百分比
   %soft			#CPU服务于软件中断所花费的时间的百分比
   %guest			#CPU运行一个虚拟处理器所花的时间百分比
   %idle			#系统没有未解决的磁盘IO请求，CPU闲置的时间百分比
-v                      #Report status of inode, file and other kernel tables
   dentunusd                    #目录缓存中没有使用的缓存条目
   file-nr			#系统中使用的文件处理数
   inode-nr			#系统中使用的节点处理数
   pty-nr			#伪终端数
-V			#显示版本号
-w			#任务的创建和系统转换状态
   proc/s			#每秒创建的任务数
   cswch/s		        #每秒的上下文切换数
-W			#交换统计信息
   pswpin/s			#每秒系统引入的交换页
   pswpout/s		        #每秒系统导出入的交换页
-y			#TTY设备状态
   rcvin/s			#在当前串行口每秒收到的中断数
   xmtin/s			#每秒的传输中断数
   framerr/s		        #每秒的帧错误
   prtyerr/s		        #每秒的奇偶校验误差
   brk/s			#每秒的破坏
   ovrun/s			#每秒的数据溢出错误

   sar -u 2 3 
   sar -d 2 3 
   sar -d -o abc.file 2 3
   sar -r -n DEV -f /var/log/sysstat/sa16
        }
    }
    sar(cpu){ 每10秒采样一次，连续采样3次，观察CPU 的使用情况，并将采样结果以二进制形式存入当前目录下的文件test中
    sar -u -o test 10 3
Linux 2.6.32-696.el6.x86_64 (centos6-vm01)  01/04/18    _x86_64_    (4 CPU)
00:09:49        CPU     %user     %nice   %system   %iowait    %steal     %idle
00:09:59        all      0.00      0.00      0.03      0.05      0.00     99.92
00:10:09        all      0.05      0.00      0.08      0.10      0.00     99.77
00:10:19        all      0.00      0.00      0.00      0.05      0.00     99.95
Average:        all      0.02      0.00      0.03      0.07      0.00     99.88
CPU：all 表示统计信息为所有 CPU 的平均值。
%user：显示在用户级别(application)运行使用 CPU 总时间的百分比。
%nice：显示在用户级别，用于nice操作，所占用 CPU 总时间的百分比。
%system：在核心级别(kernel)运行所使用 CPU 总时间的百分比。
%iowait：显示用于等待I/O操作占用 CPU 总时间的百分比。
%steal：管理程序(hypervisor)为另一个虚拟进程提供服务而等待虚拟 CPU 的百分比。
%idle：显示 CPU 空闲时间占用 CPU 总时间的百分比。

1. 若 %iowait 的值过高，表示硬盘存在I/O瓶颈
2. 若 %idle 的值高但系统响应慢时，有可能是 CPU 等待分配内存，此时应加大内存容量
3. 若 %idle 的值持续低于1，则系统的 CPU 处理能力相对较低，表明系统中最需要解决的资源是 CPU 
如果要查看二进制文件test中的内容，需键入如下sar命令：
[root@jumpserver01 ~]# sar -u -f test
    }
    sar(inode、文件和其他内核表监控){ 每10秒采样一次，连续采样3次，观察核心表的状态
[root@jumpserver01 ~]# sar -v 10 3
Linux 2.6.32-696.el6.x86_64 (centos6-vm01)  01/04/18    _x86_64_    (4 CPU)

00:13:17    dentunusd   file-nr  inode-nr    pty-nr
00:13:27       106660       960     64780         2
00:13:37       106660       960     64780         2
00:13:47       106660       960     64780         2
Average:       106660       960     64780         2
输出项说明：
dentunusd：目录高速缓存中未被使用的条目数量
file-nr：文件句柄(file handle)的使用数量
inode-nr：索引节点句柄(inode handle)的使用数量
pty-nr：使用的pty数量
    }
    sar(内存和交换空间监控){ 每10秒采样一次，连续采样3次，监控内存分页
[root@jumpserver01 ~]# sar -r 10 3
Linux 2.6.32-696.el6.x86_64 (centos6-vm01)  01/04/18    _x86_64_    (4 CPU)

00:14:42    kbmemfree kbmemused  %memused kbbuffers  kbcached  kbcommit   %commit
00:14:52       551360   5441372     90.80    142256   4907464    135520      1.12
00:15:02       551360   5441372     90.80    142256   4907464    135520      1.12
00:15:12       551360   5441372     90.80    142260   4907464    135520      1.12
Average:       551360   5441372     90.80    142257   4907464    135520      1.12

输出项说明：
kbmemfree：这个值和free命令中的free值基本一致,所以它不包括buffer和cache的空间.
kbmemused：这个值和free命令中的used值基本一致,所以它包括buffer和cache的空间.
%memused：这个值是kbmemused和内存总量(不包括swap)的一个百分比.
kbbuffers和kbcached：这两个值就是free命令中的buffer和cache.
kbcommit：保证当前系统所需要的内存,即为了确保不溢出而需要的内存(RAM+swap).
%commit：这个值是kbcommit与内存总量(包括swap)的一个百分比.
    }
    sar(内存分页监控){ 每10秒采样一次，连续采样3次，监控内存分页：
    [root@jumpserver01 ~]# sar -B 10 3
Linux 2.6.32-696.el6.x86_64 (centos6-vm01)  01/04/18    _x86_64_    (4 CPU)

00:16:29     pgpgin/s pgpgout/s   fault/s  majflt/s  pgfree/s pgscank/s pgscand/s pgsteal/s    %vmeff
00:16:39         0.00      0.40      7.21      0.00     12.61      0.00      0.00      0.00      0.00
00:16:49         0.00      0.00      4.30      0.00     12.60      0.00      0.00      0.00      0.00
00:16:59         0.00      0.00      3.40      0.00     12.20      0.00      0.00      0.00      0.00
Average:         0.00      0.13      4.97      0.00     12.47      0.00      0.00      0.00      0.00

输出项说明：
pgpgin/s：表示每秒从磁盘或SWAP置换到内存的字节数(KB)
pgpgout/s：表示每秒从内存置换到磁盘或SWAP的字节数(KB)
fault/s：每秒钟系统产生的缺页数,即主缺页与次缺页之和(major + minor)
majflt/s：每秒钟产生的主缺页数.
pgfree/s：每秒被放入空闲队列中的页个数
pgscank/s：每秒被kswapd扫描的页个数
pgscand/s：每秒直接被扫描的页个数
pgsteal/s：每秒钟从cache中被清除来满足内存需要的页个数
%vmeff：每秒清除的页(pgsteal)占总扫描页(pgscank+pgscand)的百分比
    }
    sar(I/O和传送速率监控){ 每10秒采样一次，连续采样3次，报告缓冲区的使用情况
[root@jumpserver01 ~]# sar -b 10 3
Linux 2.6.32-696.el6.x86_64 (centos6-vm01)  01/04/18    _x86_64_    (4 CPU)

00:18:06          tps      rtps      wtps   bread/s   bwrtn/s
00:18:16         0.00      0.00      0.00      0.00      0.00
00:18:26         0.00      0.00      0.00      0.00      0.00
00:18:36         0.00      0.00      0.00      0.00      0.00
Average:         0.00      0.00      0.00      0.00      0.00

输出项说明：
tps：每秒钟物理设备的 I/O 传输总量
rtps：每秒钟从物理设备读入的数据总量
wtps：每秒钟向物理设备写入的数据总量
bread/s：每秒钟从物理设备读入的数据量，单位为 块/s
bwrtn/s：每秒钟向物理设备写入的数据量，单位为 块/s 
    }
    sar(进程队列长度和平均负载状态监控){ 每10秒采样一次，连续采样3次，监控进程队列长度和平均负载状态
[root@jumpserver01 ~]# sar -q 10 3
Linux 2.6.32-696.el6.x86_64 (centos6-vm01)  01/04/18    _x86_64_    (4 CPU)

00:19:25      runq-sz  plist-sz   ldavg-1   ldavg-5  ldavg-15
00:19:35            0       231      0.00      0.20      4.50
00:19:45            0       231      0.00      0.19      4.45
00:19:55            0       231      0.00      0.18      4.40
Average:            0       231      0.00      0.19      4.45

输出项说明：
runq-sz：运行队列的长度(等待运行的进程数)
plist-sz：进程列表中进程(processes)和线程(threads)的数量
ldavg-1：最后1分钟的系统平均负载(System load average)
ldavg-5：过去5分钟的系统平均负载
ldavg-15：过去15分钟的系统平均负载
    }
    sar(系统交换活动信息监控){ 每10秒采样一次，连续采样3次，监控系统交换活动信息
    [root@jumpserver01 ~]# sar -W 10 3
Linux 2.6.32-696.el6.x86_64 (centos6-vm01)  01/04/18    _x86_64_    (4 CPU)

00:21:06     pswpin/s pswpout/s
00:21:16         0.00      0.00
00:21:26         0.00      0.00
00:21:36         0.00      0.00
Average:         0.00      0.00

输出项说明：
pswpin/s：每秒系统换入的交换页面(swap page)数量
pswpout/s：每秒系统换出的交换页面(swap page)数量
    }
    sar(设备使用情况监控){ 每10秒采样一次，连续采样3次，报告设备使用情况
    [root@jumpserver01 ~]# sar -d 10 3 -p
Linux 2.6.32-696.el6.x86_64 (centos6-vm01)  01/04/18    _x86_64_    (4 CPU)

00:24:26          DEV                   tps       rd_sec/s  wr_sec/s  avgrq-sz  avgqu-sz  await     svctm     %util
00:24:36          sr0                   0.00      0.00      0.00      0.00      0.00      0.00      0.00      0.00
00:24:36          vda                   0.00      0.00      0.00      0.00      0.00      0.00      0.00      0.00
00:24:36    vg_centos6vm01-lv_root      0.00      0.00      0.00      0.00      0.00      0.00      0.00      0.00
00:24:36    vg_centos6vm01-lv_swap      0.00      0.00      0.00      0.00      0.00      0.00      0.00      0.00
00:24:36    vg_centos6vm01-lv_home      0.00      0.00      0.00      0.00      0.00      0.00      0.00      0.0

其中：
参数-p可以打印出sda,hdc等磁盘设备名称,如果不用参数-p,设备节点则有可能是dev8-0,dev22-0
tps:每秒从物理磁盘I/O的次数.多个逻辑请求会被合并为一个I/O磁盘请求,一次传输的大小是不确定的.
rd_sec/s:每秒读扇区的次数.
wr_sec/s:每秒写扇区的次数.
avgrq-sz:平均每次设备I/O操作的数据大小(扇区).
avgqu-sz:磁盘请求队列的平均长度.
await:从请求磁盘操作到系统完成处理,每次请求的平均消耗时间,包括请求队列等待时间,单位是毫秒(1秒=1000毫秒).
svctm:系统处理每次请求的平均时间,不包括在请求队列中消耗的时间.
%util:I/O请求占CPU的百分比,比率越大,说明越饱和.
1)avgqu-sz 的值较低时，设备的利用率较高。
2)当%util的值接近 1% 时，表示设备带宽已经占满。
    }
tcp_wrapper(){
wrap简介
  wrap工作在内核空间和应用程序中间的库层次中。在内核接受到数据包准备传送到用户空间时都会经过库层次，
对于部分(只是部分)应用程序会在经过库层次时会被wrap库文件阻挡下来检查一番，如果允许通过则交给应用程序。

1.2 查看是否支持wrapper
  wrap只会检查tcp数据包，所以称为tcpwrapper。但还不是检查所有类型的tcp数据包，例如httpd就不支持。
是否支持，可以通过查看应用程序是否依赖于libwrap.so库文件。
ldd $(which sshd) | grep wrap    # libwrap.so.0 => /lib64/libwrap.so.0 (0x00007f110efb7000)
ldd $(which vsftpd) | grep wrap  # libwrap.so.0 => /lib64/libwrap.so.0 (0x00007f1e73185000)
ldd $(which httpd) | grep wrap
静态编译进程序
strings $(which portmap) | grep hosts
如果筛选出的结果中有hosts_access或者/etc/hosts.allow和/etc/hosts.deny这两个文件，则说明是支持的。后两个文件正是wrap访问控制的文件。
1.3 配置文件格式
hosts.allow和hosts.deny两个文件的语法格式是一样的，如下：
    daemon_list:   client_list  [:options]
1.3.1 "daemon_list:"的表示方法：程序名必须是which查出来同名的名称，例如此处的in.telnetd
sshd:
sshd,vsftpd,in.telnetd:
ALL
daemon@host:
最后一项daemon@host指定连接IP地址，针对多个IP的情况。如本机有192.168.100.8和172.16.100.1两个地址，但是只想控制从其中一个ip连接的vsftpd服务，可以写"vsftpd@192.168.100.8:"。
1.3.2 "client_list"的表示方法
单IP：192.168.100.8
网段：两种写法："172.16."和10.0.0.0/255.0.0.0
主机名或域匹配：fqdn或".a.com"
宏：ALL、KNOWN、UNKNOWN、PARANOID、EXCEPT
ALL表示所有主机；LOCAL表示和主机在同一网段的主机；(UN)KNOWN表示DNS是否可以解析成功的；PARANOID表示正解反解不匹配的；EXCEPT表示"除了"。

它们的语法可以man hosts_access。
tcpwrapper的检查顺序：hosts.allow --> hosts.deny --> 允许(默认规则)
例如sshd仅允许172.16网段主机访问。
hosts.allow:
sshd: 172.16.
hosts.deny:
sshd: ALL
telnet服务不允许172.16网段访问但允许172.16.100.200访问。有几种表达方式：
表达方式一：
hosts.allow:
in.telnetd: 172.16.100.200
hosts.deny:
in.telnetd: 172.16.
表达方式二：
hosts.deny:
    in.telnetd: 172.16. EXCEPT 172.16.100.200
此法不能写入hosts.allow："in.telnetd: 172.16.100.200 EXCEPT 172.16."
表达方式三：
hosts.allow:
    in.telnetd: ALL EXCEPT 172.16. EXCEPT 172.16.100.200
hosts.deny:
    in.telnetd: ALL
EXCEPT的最形象描述是"在其前面的范围内挖一个洞，在洞范围内的都不匹配"。
1.3.3 :options的表达方式
:ALLOW
:DENY
:spawn
ALLOW和DENY可以分别写入deny文件和allow文件，表示在allow文件中拒绝在deny文件中接受。如allow文件中：
in.telnetd: 172.16. :DENY
spawn表示启动某程序的意思(/etc/inittab中的respawn表示重启指定程序)。例如启动一个echo程序。
in.telnetd: 172.16 :spawn echo "we are good $(date) >> /var/log/telnetd.log"


}
udev()
{
udev 规则以管理员身份编写并保存在 /etc/udev/rules.d/ 目录，其文件名必须以 .rules 结尾。各种软件包提供的规则文件位于 /lib/udev/rules.d/。
如果 /usr/lib 和 /etc 这两个目录中有同名文件，则 /etc 中的文件优先。

udevadm info -a -p $(udevadm info -q path -n /dev/rtc)

udevadm monitor --environment --udev

列出设备属性
# udevadm info -a -n [device name]
# udevadm info -a -p /sys/class/backlight/acpi_video0

加载前测试规则
# udevadm test $(udevadm info -q path -n [device name]) 2>&1
# udevadm test /sys/class/backlight/acpi_video0/

加载新规则
如果规则自动重载失败
# udevadm control --reload
可以手工强制触发规则
# udevadm trigger
}
alias ports='netstat -tulanp'
netstat -s # System-wide statistics for each network protocol
    netstat(显示网络相关信息：如网络连接，路由表，端口统计，伪连接，多播成员等){

        # 几十万并发的情况下netstat会没有响应，建议使用 ss 命令
        -a     # 显示所有连接中的Socket
        -t     # 显示TCP连接
        -u     # 显示UDP连接
        -n     # 显示所有已建立的有效连接
        --verbose,-v #详细显示用户正在进行的工作。尤其是一些未配置的address families的有用的信息
        -c, --continuous	#连续显示查询出的信息
        -e, --extend		#显示附加信息
        -p, --program		#显示程序的PID和name
        -F			#从路由表显示路由信息
        -C			#从路由缓存中显示路由信息
        
        netstat -anlp           # 查看链接
        netstat -tnlp           # 只查看tcp监听端口
        netstat -r              # 查看路由表
        
        # 参数：(netstat打印Linux网络子系统的信息，由第一个参数决定打印出来什么信息类型)
        (none)     #By default, netstat displays a list of open sockets.If you don't specify any address families, 
                   # then the active sockets of all configured address families will be printed.
        --route,-r #显示路由表信息(netstat -r and route -e produce the same output.) 
        --groups,-g #为IPv4和IPv6组播组成员信息 
        --interfaces,-i #显示所有网络接口 
        --masquerade,-M #显示伪连接信息 
        --statistics,-s #每个连接的摘要统计
        
        netstat -n | awk '/^tcp/ {++S[$NF]} END {for(a in S) print a, S[a]}'
        netstat -an | grep LISTEN 
        lsof -i # Linux list all Internet connections 
        socklist # Linux display list of open sockets 
        sockstat -4 # FreeBSD application listing 
        netstat -anp --udp --tcp | grep LISTEN # Linux 
        netstat -tup # List active connections to/from system (Linux) 
        netstat -tupl # List listening ports from system (Linux)
        netstat -nr  # 路由配置信息  ip route show
        netstat -nrC # 路由缓存信息  ip route show cached
    }

    tcp(tcp 11种状态){
netstat -n | awk '/^tcp/ {++S[$NF]} END {for(a in S) print a, S[a]}'
CLOSED      //无连接是活动的或正在进行
LISTEN      //服务器在等待进入呼叫
SYN_RECV    //一个连接请求已经到达，等待确认
SYN_SENT    //应用已经开始，打开一个连接
ESTABLISHED //正常数据传输状态/当前并发连接数
FIN_WAIT1   //应用说它已经完成
FIN_WAIT2   //另一边已同意释放
COLSE_WAIT  //等待所有分组死掉
CLOSING     //两边同时尝试关闭
TIME_WAIT   //另一边已初始化一个释放
LAST_ACK    //等待所有分组死掉

在TIME_WAIT状态中收到一个RST引起状态过早地终止。这就叫作TIME_WAIT断开
tcp_keepalive_intvl:探测消息发送的频率
tcp_keepalive_probes:TCP发送keepalive探测以确定该连接已经断开的次数
tcp_keepalive_time:当keepalive打开的情况下，TCP发送keepalive消息的频率
    }
    
ss_conntracked(){
cat /proc/net/nf_conntrack
conntrack -L
}

man_ss(){
显示socket状态. 
显示PACKET sockets, TCP sockets, UDP sockets, DCCP sockets, RAW sockets, Unix domain sockets等等统计
实用、快速、有效的跟踪IP连接和sockets的新工具
time netstat -ant | grep EST | wc -l   性能比较
time ss -o state established | wc -l   性能比较
netstat是遍历/proc下面每个PID目录，ss直接读/proc/net下面的统计信息。所以ss执行的时候消耗资源以及消耗的时间都比netstat少很多

    ss -o state established '( dport = :ssh or sport = :ssh )' -t  
    
ss 显示处于活动状态的套按字信息,比netstat快速高效
  -h：显示帮助信息；                   --help
  -V：显示指令版本信息；               --version
  -H: 不显示标题头                     --no-header
1. IP地址和端口反解析                  
  -n：不解析服务名称，以数字方式显示； --numeric
  -r: 尽力解析数字的IP地址和端口名     --resolve
2. listen 和 non-listen                
  -a：显示所有的套接字；               --all
  -l：显示处于监听状态的套接字；       --listening
3. 扩展信息                            
  -e：扩展信息                         --extended
  -o：显示计时器信息；                 --options
  -m：显示套接字的内存使用情况；       --memory
  -p：显示使用套接字的进程信息；       --processes
  -i：显示内部的TCP信息；              --info
  -z: 进程安全上下文                   --context (SELinux)
  -Z:
4. 协议选择                            
  -4：只显示ipv4的套接字；             --ipv4
  -6：只显示ipv6的套接字；             --ipv6
  -0：packet sockets                   --packet
  -t：只显示tcp套接字；                
  -u：只显示udp套接字；                
  -d：只显示DCCP套接字；               
  -w：仅显示RAW套接字；                
  -x：仅显示UNIX域套接字。             
  -s: 显示socket摘要信息               --summary
  -N NSNAME, 指定网络名空间            --net=NSNAME 
  -f FAMILY, --family=FAMILY           unix, inet, inet6, link, netlink.
  -A QUERY, --query=QUERY, --socket=QUERY 
     QUERY := {all|inet|tcp|udp|raw|unix|unix_dgram|unix_stream|unix_seqpacket|packet|netlink}[,QUERY]
5. 过滤
ss -4 state FILTER-NAME-HERE 
ss -6 state FILTER-NAME-HERE 
说明： FILTER-NAME-HERE 可以代表以下任何一个：
FILTER := [ state STATE-FILTER ] [ EXPRESSION ]
tcp-state:      established, 
                syn-sent, 
                syn-recv,  
                fin-wait-1,  
                fin-wait-2,  
                time-wait,  
                closed,  
                close-wait, 
                last-ack, 
                listen and closing.
all             所有以上状态
connected       除了listen and closed的所有状态
synchronized    所有已连接的状态除了syn-sent
bucket          显示状态为maintained as minisockets,如：time-wait和syn-recv.
big : 和bucket相反.
6. 重定向
   -D, --diag=FILE     Dump raw information about TCP sockets to FILE 
}
demo_ss(){
过滤：
    源端口：ss -nt 'src :2333'     目的端口：ss -nt 'dst :ssh'
    源端口：ss -nt 'sport = :2333' 目的端口：ss -nt 'dport = :ssh'
    地址和端口：ss -nt 'dst 101.68.62.5:6777'
    显示目的端口号小于1000的套接字：ss -nt 'dport \< :1000'
    显示源端口号大于1024的套接字：ss -nt 'sport gt :1024'
    
# netstat是遍历/proc下面每个PID目录，ss直接读/proc/net下面的统计信息。所以ss执行的时候消耗资源以
    # 及消耗的时间都比netstat少很多
# 他的最大特点是快, 当你的系统有上万个tcp链接要了解的时候的时候, 你就知道我说什么了. netstat等
    # 常规工具变成废铁了, 这时候他的作用就非常明显了.
    ss -s          # 显示 Sockets 摘要(列出当前已经连接，关闭，等待的tcp连接)
    ss -t -a       # 显示TCP连接
    ss -l          # 显示本地打开的所有端口
    ss -lp         # 显示进程使用的socket
    ss -lp | grep 3306 # 找出打开套接字/端口应用程序
    ss -tnlp       # 显示每个进程具体打开的socket
    ss -ant        # 显示所有TCP socket
    ss -u -a       # 显示所有UDP Socekt
    ss -o state established '( dport = :smtp or sport = :smtp )' # 显示所有状态为established的SMTP连接
    ss -o state established '( dport = :http or sport = :http )' # 显示所有状态为Established的HTTP连接
    ss -o state fin-wait-1 '( sport = :http or sport = :https )' dst 193.233.7/24 # 列举出处于 FIN-WAIT-1状态的源端口为 80或者 443，目标网络为 193.233.7/24所有 tcp套接字
    ss -x src /tmp/.X11-unix/*     # 找到所有连接X服务器的进程
--------------------------------------- 怎样匹配本地地址和端口号? ss src ADDRESS_PATTERN
ss src 75.126.153.214 
ss src 75.126.153.214:http 
ss src 75.126.153.214:80 
ss src 75.126.153.214:smtp 
ss src 75.126.153.214:25  
--------------------------------------- 怎样将本地或者远程端口和一个数比较? ss dport OP PORT | sport OP PORT 
ss  sport = :http 
ss  dport = :http 
ss  dport \> :1024 
ss  sport \> :1024 
ss sport \< :32000 
ss  sport eq :22 
ss  dport != :22 
ss  state connected sport = :http 
ss \( sport = :http or sport = :https \) 
ss -o state fin-wait-1 \( sport = :http or sport = :https \) dst 192.168.1/24
--------------------------------------- 怎样匹配远程地址和端口号? ss dst ADDRESS_PATTERN
ss dst 192.168.119.113         # 匹配远程地址
ss dst 192.168.119.113:http    # 匹配远程地址和端口号
ss dst 192.168.119.113:3844    # 匹配远程地址和端口号
ss src 192.168.119.103:16021   # 匹配本地地址和端口号
ss -o state established '( dport = :smtp or sport = :smtp )'        # 显示所有已建立的SMTP连接
ss -o state established '( dport = :http or sport = :http )'        # 显示所有已建立的HTTP连接
ss -x src /tmp/.X11-unix/*         # 找出所有连接X服务器的进程
--------------------------------------- 怎样用TCP 状态过滤Sockets?        
ss -4 state FILTER-NAME-HERE 
ss -6 state FILTER-NAME-HERE  
established
syn-sent
syn-recv
fin-wait-1
fin-wait-2
time-wait
closed
close-wait
last-ack
listen
closing
    }
TIME_WAIT(){
https://huoding.com/2013/12/31/316

http://www.bdkyr.com/653.html ss
www.toptip.ca/2010/02/linux-eaddrnotavail-address-not.html 

https://testerhome.com/topics/7509 # nf_conntrack: table full, dropping packet
nat 根据转发规则修改源/目标地址，靠nf_conntrack的连接记录才能让返回的包能路由到发请求的机器
state 直接用 nf_conntrack 记录的连接状态(NEW/ESTABLISHED/RELATED/INVALID)来匹配过滤规则
}
    并发数查看{
        netstat -n | awk '/^tcp/ {++S[$NF]} END {for(a in S) print a, S[a]}'
        SYN_RECV     # 正在等待处理的请求
        ESTABLISHED  # 正常数据传输状态,既当前并发数
        TIME_WAIT    # 处理完毕，等待超时结束的请求
        CLOSE_WAIT   # 客户端异常关闭,没有完成4次挥手  如大量可能存在攻击行为
    }

    ssh_demo(){ [user@]hostname [command]
        ssh -p 22 user@192.168.1.209                            # 从linux ssh登录另一台linux
        ssh -p 22 root@192.168.1.209 CMD                        # 利用ssh操作远程主机
        scp -P 22 文件 root@ip:/目录                            # 把本地文件拷贝到远程主机
        scp -l 100000  文件 root@ip:/目录                       # 传输文件到远程，限制速度100M
        sshpass -p '密码' ssh -n root@$IP "echo hello"          # 指定密码远程操作
        ssh -o StrictHostKeyChecking=no $IP                     # ssh连接不提示yes
        ssh -t "su -"                                           # 指定伪终端 客户端以交互模式工作
        scp root@192.168.1.209:远程目录 本地目录                # 把远程指定文件拷贝到本地
        pscp -h host.ip /a.sh /opt/sbin/                        # 批量传输文件
        ssh -N -L2001:remotehost:80 user@somemachine            # 用SSH创建端口转发通道
        ssh -t host_A ssh host_B                                # 嵌套使用SSH
        ssh -t -p 22 $user@$Ip /bin/su - root -c {$Cmd};        # 远程su执行命令 Cmd="\"/sbin/ifconfig eth0\""
        ssh-keygen -t rsa                                       # 生成密钥
        ssh-copy-id -i xuesong@10.10.10.133                     # 传送key
        vi $HOME/.ssh/authorized_keys                           # 公钥存放位置
        sshfs name@server:/path/to/folder /path/to/mount/point  # 通过ssh挂载远程主机上的文件夹
        fusermount -u /path/to/mount/point                      # 卸载ssh挂载的目录
        fuser -va 22/tcp                   # List processes using port 22 (Linux)
        fuser -va /home # List processes accessing the /home partition
        fuser -m /home # List processes accessing /home 
        lsof /home
        ssh user@host cat /path/to/remotefile | diff /path/to/localfile -                # 用DIFF对比远程文件跟本地文件
        su - user -c "ssh user@192.168.1.1 \"echo -e aa |mail -s test mail@163.com\""    # 切换用户登录远程发送邮件

        ssh-copy-id remote-machine    #免密码SSH登录主机
        # 这个命令如果用手工完成，是这样的：
        your-machine$ scp ~/.ssh/identity.pub remote-machine:
        your-machine$ ssh remote-machine
        remote-machine$ cat identity.pub >> ~/.ssh/authorized_keys

        SSH反向连接{
            # 外网A要控制内网B
            ssh -NfR 1234:localhost:2223 user1@123.123.123.123 -p22    # 将A主机的1234端口和B主机的2223端口绑定，相当于远程端口映射
            ss -ant   # 这时在A主机上sshd会listen本地1234端口
            # LISTEN     0    128    127.0.0.1:1234       *:*
            ssh localhost -p1234    # 在A主机连接本地1234端口
            
            # hostb 公网 12.34.56.78
            # hosta 内网 建立一个从hosta到hostb的ssh会话，同时将8080端口映射到hostb的1080端口。
            ssh -R 1080:localhost:8080 root@12.34.56.78
            
ssh -L 8000:www.codeshold.me:80 user@localhost    # 将本地端口8000的流量转发到www.codeshold.me:80上
ssh -fL 8000:www.codeshold.me:80 user@localhost   # -N, -f后台运行， -N无需执行命令，只进行端口转发
# 反向端口转发: ssh -R 8000:localhost:80 user@REMOTEMACHINE
# [-L [bind_address:]port:host:hostport]
# [-R [bind_address:]port:host:hostport]
        }
        
        TCPKeepAlive=yes 
        ServerAliveInterval=15 
        ServerAliveCountMax=6 
        Compression=yes 
        ControlMaster auto 
        ControlPath /tmp/%r@%h:%p 
        ControlPersist yes
    }
    sshfs(){ https://www.linuxjournal.com/article/8904
    sudo apt-get install sshfs
    sudo yum install fuse-sshfs
    mkdir /home/user/testdir
    sshfs user@server.com:/remote/dir /home/user/testdir
    fusermount -u /home/user/testdir
    }

    ssh_agent(TODO){}
    ssh_add(TODO){}
    percol(TODO){}
    fzf(TODO){}
    fpp(TODO){}
    ag(TODO){}
    jq(TODO){}
    csvkit(TODO){
    in2csv，csvcut，csvjoin，csvgrep
    }
    datamash(TODO){}
    网卡配置文件{
        vi /etc/sysconfig/network-scripts/ifcfg-eth0

        DEVICE=eth0
        BOOTPROTO=none
        BROADCAST=192.168.1.255
        HWADDR=00:0C:29:3F:E1:EA
        IPADDR=192.168.1.55
        NETMASK=255.255.255.0
        NETWORK=192.168.1.0
        ONBOOT=yes
        TYPE=Ethernet
        GATEWAY=192.168.1.1
        #ARPCHECK=no     # 进制arp检查
    }
1. Print routing table
route -n                  # Linux or use "ip route"
netstat -rn               # Linux, BSD and UNIX
route print               # Windows
2. Linux
route add -net 192.168.20.0 netmask 255.255.255.0 gw 192.168.16.254
ip route add 192.168.20.0/24 via 192.168.16.254       # same as above with ip route
route add -net 192.168.20.0 netmask 255.255.255.0 dev eth0
route add default gw 192.168.51.254
ip route add default via 192.168.51.254 dev eth0      # same as above with ip route
route delete -net 192.168.20.0 netmask 255.255.255.0
3. Windows
Route add 192.168.50.0 mask 255.255.255.0 192.168.51.253
Route add 0.0.0.0 mask 0.0.0.0 192.168.51.254
route add 172.181.9.205 mask 255.255.255.255  192.168.3.20  METRIC 3 IF 2
    route() {
        route                           # 查看路由表
        route -n                        # 用数组代替主机名
        route add default  gw 192.168.1.1  dev eth0                        # 添加默认路由
        route add -net 192.56.76.0 netmask 255.255.255.0 dev eth0          # 通过
        route add -net 172.16.0.0 netmask 255.255.0.0 gw 10.39.111.254     # 添加静态路由网关
        route del -net 172.16.0.0 netmask 255.255.0.0 gw 10.39.111.254     # 删除静态路由网关
    }

    静态路由{
        vim /etc/sysconfig/static-routes
        any net 192.168.12.0/24 gw 192.168.0.254
        any net 192.168.13.0/24 gw 192.168.0.254
    }

    解决ssh链接慢{
        sed -i 's/GSSAPIAuthentication yes/GSSAPIAuthentication no/' /etc/ssh/sshd_config
        sed -i '/#UseDNS yes/a\UseDNS no' /etc/ssh/sshd_config
        /etc/init.d/sshd reload
    }

    ftp上传{
        ftp -i -v -n $HOST <<END
        user $USERNAME $PASSWORD
        cd /ftp
        mkdir data
        cd data
        mput *.tar.gz
        bye
END
    }

busybox pscan 192.168.10.107
nmap -sT 192.168.10.107
pscan_busybox(){
pscan [-cb] [-p MIN_PORT] [-P MAX_PORT] [-t TIMEOUT] [-T MIN_RTT] HOST
Scan a host, print all open ports
Options:
  -c      Show closed ports too
  -b      Show blocked ports too
  -p      Scan from this port (default 1)
  -P      Scan up to this port (default 1024)
  -t      Timeout (default 5000 ms)
  -T      Minimum rtt (default 5 ms, increase for congested hosts)
}
nmap_demo(){
  nmap --iflist  # Show host interfaces and routes
  
  nmap --top-ports 10 192.168.1.1 # 扫描最常用的10个端口
  nmap -v 192.168.1.1             # verbosity verbosity  -vv 描述探测过程的细节(不包括报文)
  nmap -d 192.168.1.1             # debugging debugging  -dd 描述探测总纲(tcp udp port范围), 以及收发数据包
  nmap --packet-trace 192.168.1.1 # 跟踪探测报文  数据包收发过程

  nmap -A 192.168.0.101           # 扫描操作系统信息和路由跟踪 -A: Enable OS detection, version detection, script scanning, and traceroute
  nmap -O server2.tecmint.com     # 使用选项"-O"和"-osscan-guess"也帮助探测操作系统信息。 OS detection
  nmap -sA 192.168.0.101          # 扫描主机侦测防火墙
  nmap -PN 192.168.0.101          # 扫描主机检测是否有防火墙保护
  nmap -F 192.168.0.101           # 仅扫描列在nmap-services文件中的端口而避开所有其它的端口。

  nmap -p T:8888,80 server2.tecmint.com # .扫描TCP端口 具体的端口类型和端口号来让nmap扫描。
  nmap -sU 53 server2.tecmint.com       # 扫描UDP端口
  nmap -PS 192.168.0.101                # 使用TCP ACK (PA)和TCP Syn (PS)扫描远程主机
  nmap -PA -p 22,80 192.168.0.101       # 使用TCP ACK扫描远程主机上特定的端口
  nmap -sT 192.168.0.101                # 使用TCP Syn扫描最常用的端口
  nmap -sN 192.168.0.101                # 执行TCP空扫描以骗过防火墙
  nmap localhost                                  # host
  nmap 192.168.10.0/24                            # net
  nmap -p1-10000 192.168.10.0/24                  # portrange
  nmap -p22,23,10000-15000 192.168.10.0/24        # select port
  nmap -sU host                                   # udp scan
  nmap -sO host                                   # IP  scan
  # 可以使用-sn选项禁止扫描端口，以加速扫描主机是否存活。
  -sS/sT/sA/sW: # TCP SYN/Connect()/ACK/Window，其中sT扫描表示TCP扫描
  nmap -[sS/sT/sA/sW] host                        # tcp prorocol
  nmap -sF host                                   # tcp prorocol
  nmap -sX host                                   # tcp prorocol
  nmap -sN host                                   # tcp prorocol
  -PE/PP/PM:  # 分别是基于echo/timestamp/netmask的ICMP探测报文方式。使用echo最快
  nmap -[PE/PP/PM] host                        # tcp prorocol
  nmap -sP network                                # icmp ping scan
  
  # -T<0-5>：这表示直接使用namp提供的扫描模板，不同的模板适用于不同的环境下，默认的模板为"-T 3"
  nmap -sT -p3389 218.206.112.0/24 # 扫描指定网段的远程桌面连接端口
  nmap -sT -p3389 218.206.112.0/24 | grep -B2 open # 如果觉得输出太多，可以用 grep 命令过滤
}
nmap_intro(){
目标主机是否在线，端口表，反向域名，操作系统猜测，设备类型，和MAC地址
1. Open(开放的)意味着目标机器上的应用程序正在该端口监听连接/报文。
2. filtered(被过滤的) 意味着防火墙，过滤器或者其它网络障碍阻止了该端口被访问，Nmap无法得知 它是 open(开放的) 还是 closed(关闭的)。
3. closed(关闭的) (关闭的)关闭的端口对于Nmap也是可访问的(它接受Nmap的探测报文并作出响应)，但没有应用程序在其上监听。
4. unfiltered(未被过滤的) 当端口对Nmap的探测做出响应，但是Nmap无法确定它们是关闭还是开放时.
5. 如果Nmap报告状态组合 open|filtered 和 closed|filtered时，那说明Nmap无法确定该端口处于两个状态中的哪一个状态。
# NMAP 只会扫描绝大多数熟知的 1000 多个端口。
nmap [Scan Type(s)] [Options] {target specification} # 用于指定扫描类型；用于指定选项；用于指定扫描目标
nmap  -sS   -T2        192.168.1.44 -oN # 10.0.2.1-255 10.0.2.1/24        -p 1-100 -p 53,137,3389
命令  选项  计时选择   目标         输出选项
# -s 指定扫描类型；                      # 选项说明：                          # 目标格式:
-sP (ping扫描) 存活主机探测              -P0 [指定端口] (无ping扫描)           -iL <inputfilename>
-sS (TCP SYN扫描 隐身扫描) 默认扫描方式  -PU [指定端口] (udp ping扫描)         -iR <num hosts>
-sT (tcp 扫描) syn 不能用时就tcp扫描     -PS [指定端口] (TCP SYN ping 扫描)    --exclude <host1[,host2][,host3],...>
-sU (UDP 扫描)                         -PA [指定端口] (tcp ack ping扫描)     --excludefile <exclude_file>:
-sA (ACK扫描) 三次握手                 -PI 使用真正的pingICMP echo请求来扫描目标主机是否正在运行 
-sV (版本探测)                         -iL 指定扫描主机列表
-A 操作系统探测                          -iR 随机选择目标
-O (启用操作系统检测)                   -exclude 排除扫描目标
                                         -excludefile 排除文件中目标列表
                                         -n (不用域名解析)
                                         -R (为所有目标解析域名)
                                         -T 时间优化(每隔多久发一次包) -T5 最快 -T0 最慢
                                         -F 快速扫描
                                         -e 指定网络接口
                                         -M 设置tcp扫描线程
# Scan Types              Scan Options                           Ping Options             OS detection                       Misc
-sA ACK Scan              -p <port range>                        -PI Ping                 -A OS version Detection            --datadir <dirname>
-sF FIN Scan              -scanflags <TCP flags>                 -P0 No Ping              -O OS scan                         -6 Enable IPv6
-sI Idel Scan             -spoof_mac <macaddress/prefix/vendor>  -PS [port list] TCP SYN  --os scan_limit promosing targets  -V Print version number
-sL List/DNS Scan         -F Fast scan                           -PA [port list] TCP ACK                                     --privileged User is a root/admin
-sM Maimon Scan FIN/ACK   -r ports consecutively                 -PU [port list] UDP                                         -f frag mentation
-sN NULL Scan             --randomize_hosts                      -PE ICMP Echo                                               -mtu <val>
-sO Protocol Scan         -S SRC_IP_ADDR                         -PP ICMP Timestamp                                          --data_length <num>
-sP Ping Scan             -D <decoy1[,decoy2][,ME],>             -PM ICMP netmask request                                    -ttl <val>
-sR RPC Scan              -e <interface >                        -PT TCP ping                                                -N DNS resolution
-sS SYN Scan              --send_eth/--send_ip                   -PB =PT+PI                                                  -R Do reverse look up
-sT TCP Connect (Default)                                                                                                    -n No DNS resolution
-sU UDP Scan                                                                                                                 -h Help
-sW Window  Scan
-s X XMAS S ca n
-b <ftp relay host>:FTP bounce Scan
# Service/Version Detection
-sV  Version/Service Info
--versionlight
--version_ trace
--version_all

# 四种通用扫描类型 # 
PING 扫描-sP # "-sP" 命令，发送一个arp广播包请求，是ping echo检查，但是不会发包ICMP、TCP协议数据包给服务端，所以非常的轻量。
TCP SYN 扫描-sS  # SYN <-> SYN|ACK  RST <-> SYN|RST : 端口打开  SYN <-> RST : 端口关闭  SYN <-> 没响应 : 防火墙丢掉(端口可能是被过滤、或者可能打开、或者可能没打开)
TCP Connect() 扫描-sT # SYN <-> SYN|ACK <-> ACK RST <-> SYN|RST : 端口打开 ... 如上
UDP 扫描-sU  # 注意: 只有最前面的 1024 个常用端口会被扫描。
-sA ACK扫描 辨别靶机是否开启防火墙。
若防火墙启用，结果应该是All 1000 scanned ports on 192.168.1.44 are filtered
若防火墙未启用，结果应该是All 1000 scanned ports on 192.168.1.44 are unfiltered

"-T0" 慢速扫描，最小化被发现，串行的扫描方式，两次扫描之前的间隔最少5分钟。扫描500个UDP端口可能需要3小时。
该选项只应在需要隐蔽而且时间充裕时使用
"-T1" 比T0略快。保持慢速扫描的隐蔽性同时，减少了扫描需要的时间。同为串行扫描，两次扫描之间的间隔15s
"-T2" 最后一个串行扫描选项，两次扫描间隔400ms，单次扫描延时默认1分钟。
"-T3" 默认扫描方式，并行扫描，单次扫描延时1s，一秒后当前端口被放弃并进行下一个端口扫描。
"-T4" 单次扫描延时10ms，部分系统易出错。
"-T5" 速度最快。单次扫描延时5ms。

# 输出
-oN 将标准输出直接写入指定的文件 
-oX 输出xml文件 
-oS 将所有的输出都改为大写 
-oG 输出便于通过bash或者perl处理的格式,非xml 
-oA BASENAME 可将扫描结果以标准格式、XML格式和Grep格式一次性输出 
-v 提高输出信息的详细度 -d level 设置debug级别,最高是9 
--reason 显示端口处于带确认状态的原因 
--open 只输出端口状态为open的端口 
--packet-trace 显示所有发送或者接收到的数据包 
--iflist 显示路由信息和接口,便于调试 
--log-errors 把日志等级为errors/warings的日志输出 
--append-output 追加到指定的文件 
--resume FILENAME 恢复已停止的扫描 
--stylesheet PATH/URL 设置XSL样式表，转换XML输出 
--webxml 从namp.org得到XML的样式 
--no-sytlesheet 忽略XML声明的XSL样式表
# 扫描巨大网络
sn 不扫描端口，只ping主机
-PE 通过ICMP echo判定主机是否存活 # Nmap给每个主机发送ping echo包，和多个nmap库中可以探测的TCP syn包，主机对任何一种的响应都会被Nmap得到。
-n 不反向解析IP地址到域名
-min-hostgroup 1024 最小分组设置为1024个IP地址，当IP太多时，nmap需要分组，然后串行扫描
-min-parallelism 1024 这个参数非常关键，为了充分利用系统和网络资源，我们将探针的数目限定最小为1024
-oX nmap_output.xml 将结果以XML格式输出，文件名为nmap_output.xml

nmap -sS -P0 -sV -O # 获取远程主机的系统类型及开放端口
nmap -sP -PI -PT -oN 192.168.1.0/24 # 获取ip和mac地址：
nmap -sP -n 192.168.10.0/24 | cut -d " " -f5 | awk "/192/" # 扫描存活主机
nmap -P0 -script=smb-check-vulns -script-args=unsafe=1 -iL ip.txt # 漏洞探测
    
1. 目标规则：可以指定主机名，IP地址和网络段地址 
# scanme.nmap.org,       主机名
# microsoft.com/24,      网络段地址 
# 192.168.0.1;           IP地址
# 10.0-255.0-255.1-254   将略过在该范围内以.0和.255结束的地址
# 192.168.0-255.1-254    将略过在该范围内以.0和.255结束的地址
# 0-255.0-255.13.37      将在整个互联网范围内扫描所有以13.37结束的地址
-iL <inputfilename>: Input from list of hosts/networks        # 从列表中输入
-iR <num hosts>: Choose random targets                        # 随机选择目标；不合需要的IP如特定的私有，组播或者未分配的地址自动 略过。选项 0 意味着永无休止的扫描。
--exclude <host1[,host2][,host3],...>: Exclude hosts/networks # 排除主机/网络
--excludefile <exclude_file>: Exclude list from file          # 排除文件中的列表
2. 主机发现： # TCP ACK报文到80端口和一个ICMP回声请求到每台目标机器。
-sL: List Scan     # 列出探测IP地址集合; 会进行域名解析功能
-sP: Ping Scan     # 发送一个ICMP回声请求和一个TCP报文到80|433端口。 -sP == -sn
# 如果非特权用户执行，就发送一个SYN报文到目标机的80端口(第一次握手)和发送ACK报文到目标机的80端口(第二次握手)。
# 当特权用户扫描局域网上的目标机时，只会发送ARP请求(-PR)。 
-sn (No port scan) # icmp探测 && 80端口 && 433端口探测   --- 不同网段
                   # arp探测 && 80端口 && 433端口探测    --- 相同网段
-P0: Treat all hosts as online -- skip host discovery  # Nmap只对正在运行的主机进行高强度的探测如 端口扫描，版本探测，或者操作系统探测。
-Pn (No ping) : -Pn = -P0 + -PN. # 相同网段仍会进行ARP检测
-PS/PA/PU [portlist]: TCP SYN Ping/TCP ACK Ping/UDP Ping发现   # 
-PS [portlist] (TCP SYN Ping) # nmap -p 1-65535 -PS 222.41.217.210            # SYN
-PA [portlist] (TCP ACK Ping) # nmap -p 1-65535 -PA 222.41.217.210            # ACK
-PU [portlist] (UDP Ping)     # nmap -p 1-65535 -PU 222.41.217.210 # root用户 # UDP
# -PN, -PO, -PI, -PB, -PE, -PM, -PP, -PA, -PU, -PT, or -PT80
-PE/PP/PM: 使用ICMP echo, timestamp and netmask 请求包发现主机    # 都是先进行ping，然后进行端口扫描
-PR (ARP Ping) # ARP --- 相同网段
-n/-R 不对IP进行域名反向解析/为所有的IP都进行域名的反响解析
3. 端口扫描技术 # TCP SYN/TCP connect()/ACK/TCP窗口扫描/TCP Maimon扫描
-sS (TCP SYN扫描)       # sudo nmap -sS -T4 <IP>     # SYN 扫描(利用基本的SYN扫描方式探测其端口开放状态) --- 默认扫描方式
-sT (TCP connect()扫描) # sudo nmap -sT -T4 <IP>     # ACK 扫描(利用基本的ACK扫描方式探测其端口开放状态)
-sU (UDP扫描)           # sudo nmap -sU -T4 <IP>     # UDP 扫描(利用基本的UDP扫描方式探测其端口开放状态)
-sA (TCP ACK扫描)       # sudo nmap -sU -T4 <IP>     # 三次握手 用于探测出防火墙过滤端口 实际渗透中没多大用
Null扫描 (-sN) #不设置任何标志位(tcp标志头是0)
FIN扫描 (-sF)  # 只设置TCP FIN标志位。
Xmas扫描 (-sX) # 设置FIN，PSH，和URG标志位，就像点亮圣诞树上所有的灯一样。
-sW (TCP窗口扫描)
-sM (TCP Maimon扫描)
--scanflags (定制的TCP扫描)
-sI <zombie host[:probeport]> (Idlescan) # nmap -sL 192.168.1.6 192.168.1.1
#Idlescan是一种先进的扫描技术，它不是用你真实的主机Ip发送数据包，而是使用另外一个目标网络的主机发送数据包.
-sO (IP协议扫描)
---------------------------------------
-p <port ranges> (只扫描指定的端口) # 指定扫描端口 1. -p80,443 或者 -p1-65535  2. 扫描udp的某个端口, -p U:53
-F (快速 (有限的端口) 扫描)        # nmap-services配置文件;快速扫描模式,比默认的扫描端口还少
-r (不要按随机顺序扫描端口)        # 顺序扫描指定端口;不随机扫描端口,默认是随机扫描的
4. 服务和版本探测
-sV (版本探测) # 开放版本探测,可以直接使用-A同时打开操作系统探测和版本探测
--allports (不为版本探测排除任何端口) 
--version-intensity "level" (设置版本扫描强度) # 强度水平说明了应该使用哪些探测报文。数值越高，服务越有可能被正确识别。默认是7
--version-light (打开轻量级模式) # 打开轻量级模式,为--version-intensity 2的别名
--version-all (尝试每个探测)     # 尝试所有探测,为--version-intensity 9的别名
--version-trace (跟踪版本扫描活动) # 显示出详细的版本侦测过程信息
-sR (RPC扫描)
5. 操作系统探测
-O (启用操作系统检测)                        # 启用操作系统检测,-A来同时启用操作系统检测和版本检测
--osscan-limit (针对指定的目标进行操作系统检测) # 针对指定的目标进行操作系统检测(至少需确知该主机分别有一个open和closed的端口)
--osscan-guess; --fuzzy (推测操作系统检测结果)  # 推测操作系统检测结果,当Nmap无法确定所检测的操作系统时，会尽可能地提供最相近的匹配，Nmap默认进行这种匹配
6. 脚本扫描
-sC                         # 根据端口识别的服务,调用默认脚本 
--script="Lua scripts"      # 调用的脚本名 
--script-args=n1=v1,[n2=v2] # 调用的脚本传递的参数 
--script-args-file=filename # 使用文本传递参数 
--script-trace              # 显示所有发送和接收到的数据 
--script-updatedb           # 更新脚本的数据库 
--script-help="Lua scripts" # 显示指定脚本的帮助
7. 防火墙/IDS躲避和哄骗
-f; --mtu value 指定使用分片、指定数据包的MTU. 
-D decoy1,decoy2,ME 使用诱饵隐蔽扫描 
-S IP-ADDRESS 源地址欺骗 
-e interface 使用指定的接口 
-g/ --source-port PROTNUM 使用指定源端口 
--proxies url1,[url2],... 使用HTTP或者SOCKS4的代理 
--data-length NUM 填充随机数据让数据包长度达到NUM 
--ip-options OPTIONS 使用指定的IP选项来发送数据包 
--ttl VALUE 设置IP time-to-live域 
--spoof-mac ADDR/PREFIX/VEBDOR MAC地址伪装 
--badsum 使用错误的checksum来发送数据包

-iL <inputfilename>:从输入文件中读取主机或者IP列表作为探测目标
-sn: PING扫描，但是禁止端口扫描。默认总是会扫描端口。禁用端口扫描可以加速扫描主机
-n/-R: 永远不要/总是进行DNS解析，默认情况下有时会解析
-PE/PP/PM:分别是基于echo/timestamp/netmask的ICMP探测报文方式。使用echo最快
-sS/sT/sA/sW:TCP SYN/Connect()/ACK/Window，其中sT扫描表示TCP扫描
-sU:UDP扫描
-sO:IP扫描
-p <port ranges>: 指定扫描端口
--min-hostgroup/max-hostgroup <size>: 对目标主机进行分组然后组之间并行扫描
--min-parallelism/max-parallelism <numprobes>: 设置并行扫描的探针数量
-oN/-oX/ <file>: 输出扫描结果到普通文件或XML文件中。输入到XML文件中的结果是格式化的结果
-v:显示详细信息，使用-vv或者更多的v显示更详细的信息

# nmap -n -p 20-2000 --min-hostgroup 1024 --min-parallelism 1024 192.168.100.70/24
}

nmap_demo(){
网络探测工具和安全端口扫描工具
map [Scan Type(s)] [Options] {target specification}
# -n    不进行反向域名解析 PTR请求 AAAA请求
# -v    详细输出扫描情况
# -T4:可以加快执行速度
1. 主机发现：
nmap -PR -v -n 192.168.1.1/24      # ARP扫描，域名地址解析，tcp端口扫描  --- 不支持跨网段探测
nmap -sn 192.168.56.0/24           #在我的网络中找到并 ping 所有活动主机
nmap -sP 192.168.0.*               # nmap -sP 192.168.0.0/24     不同网段(icmp探测 && 80端口 && 433端口探测)
                                   # nmap -sP 192.168.1.100-254  相同网段(arp探测 && 80端口 && 433端口探测)
nmap -p80,21,23 192.168.1.1        # 扫描特定主机上的80,21,23端口
nmap -PT 192.168.1.1-111           # 先ping在扫描主机开放端口
nmap -P0 192.168.1.1-111           # 不ping直接扫描
nmap -p 20-30,139,60000-           # 端口范围  表示：扫描20到30号端口，139号端口以及所有大于60000的端口
nmap -P0 -sV -O -v 192.168.30.251  # 组合扫描(不ping、软件版本、内核版本、详细信息)
nmap -T4 -A 127.0.0.1     # 全面扫描  -A:用来进行操作系统及其版本的探测，
nmap -T4 -sn 127.0.0.1    # 主机发现
nmap -sS -P0 -sV -O <target> # 获取远程主机的系统类型及开放端口；-sS TCP SYN 扫描 (又称半开放,或隐身扫描)
# -P0 允许你关闭 ICMP pings. -sV 打开系统版本检测 -O 尝试识别远程操作系统 或 nmap -sS -P0 -A -v < target >
sudo nmap -sS 192.168.0.10 -D 192.168.0.2 # 使用诱饵扫描方法来扫描主机端口
2. 端口扫描技术
nmap -sS 192.168.1.1-111 # 因为没有形成会话。这个就是SYN扫描的优势.如果Nmap命令中没有指出扫描类型,默认的就是Tcp SYN.
nmap -sF 192.168.1.1-111 # 有时候TcpSYN扫描不是最佳的扫描模式,因为有防火墙的存在.目标主机有时候可能有IDS和IPS系统的存在,防火墙会阻止掉SYN数据包。
nmap -sS -T4 -p1-65535 -sV 192.168.1.169 # 同时对开放的端口进行端口识别，并查看相应的服务器版本
nmap -sS -T4 -A 192.168.1.169            # 探测操作系统的类型和版本，并显示traceroute的结果。
nmap -sV -v -p139,445 192.168.1.0/24     # 在子网中发现开放netbios的IP
nmap -sX 192.168.1.1-111
nmap -sN 192.168.1.1-111
nmap -sC 192.168.56.102 -p 21 #--script=default
nmap -sT 192.168.1.1 # Tcp connect()扫描需要完成三次握手,并且要求调用系统的connect().Tcp connect()扫描技术只适用于找出TCP和UDP端口.
nmap -sU 192.168.1.1 # 如果返回ICMP不可达的错误消息，说明端口是关闭的，如果得到正确的适当的回应，说明端口是开放的.
nmap -sT -p 80 -oG - 192.168.1.* | grep open # 列出开放了指定端口的主机列表
3. 服务和版本探测
nmap -sV 192.168.1.1-111           # 扫描端口的软件版本
nmap -T4 -sV 127.0.0.1    # 服务扫描
4. 操作系统探测
nmap -O 192.168.1.1       # 扫描出系统内核版本 nmap -O -PN 192.168.1.1/24  nmap -O --osscan-guess 192.168.1.1
nmap -T4 -O 127.0.0.1     # 操作系统扫描
5. 输出
nmap -d 192.168.1.1-111            # 详细信息
nmap -sS -p1-65525 192.168.1.169 -oG output.txt # 将扫描的结果输出到屏幕，同时存储一份到output.txt。
nmap -sS -p1-65525 192.168.1.169 --webxml -oX - | xsltproc --output  file.html # 扫描结果输出为html
6.防火墙/IDS躲避和哄骗
nmap -D 192.168.1.1-111   # 无法找出真正扫描主机(隐藏IP) --- 使用诱饵隐蔽扫描
nmap --iflist             # 查看本地路由
}
nmap_script(){
    nmap脚本
    nmap脚本主要分为以下几类，在扫描时可根据需要设置--script=类别这种方式进行比较笼统的扫描：
    # auth: 负责处理鉴权证书(绕开鉴权)的脚本
    # broadcast: 在局域网内探查更多服务开启状况，如dhcp/dns/sqlserver等服务
    # brute: 提供暴力破解方式，针对常见的应用如http/snmp等
    # default: 使用-sC或-A选项扫描时候默认的脚本，提供基本脚本扫描能力
    # discovery: 对网络进行更多的信息，如SMB枚举、SNMP查询等
    # dos: 用于进行拒绝服务攻击
    # exploit: 利用已知的漏洞入侵系统
    # external: 利用第三方的数据库或资源，例如进行whois解析
    # fuzzer: 模糊测试的脚本，发送异常的包到目标机，探测出潜在漏洞 intrusive: 入侵性的脚本，此类脚本可能引发对方的IDS/IPS的记录或屏蔽
    # malware: 探测目标机是否感染了病毒、开启了后门等信息
    # safe: 此类与intrusive相反，属于安全性脚本
    # version: 负责增强服务与版本扫描(Version Detection)功能的脚本
    # vuln: 负责检查目标机是否有常见的漏洞(Vulnerability)，如是否有MS08_067
    nmap -sU --script nbstat.nse -p 137 target # 扫描指定netbios的名称
    nmap --script=broadcast-netbios-master-browser 192.168.137.4 发现网关 
    nmap -p 873 --script rsync-brute --script-args 'rsync-brute.module=www' 192.168.137.4 破解rsync 
    nmap --script informix-brute -p 9088 192.168.137.4 informix数据库破解 
    nmap -p 5432 --script pgsql-brute 192.168.137.4 pgsql破解 
    nmap -sU --script snmp-brute 192.168.137.4 snmp破解 
    nmap -sV --script=telnet-brute 192.168.137.4 telnet破解 
    nmap --script=http-vuln-cve2010-0738 --script-args 'http-vuln-cve2010-0738.paths={/path1/,/path2/}' <target> jboss autopwn 
    nmap --script=http-methods.nse 192.168.137.4 检查http方法 
    nmap --script http-slowloris --max-parallelism 400 192.168.137.4 dos攻击，对于处理能力较小的站点还挺好用的 'half-HTTP' connections
    nmap --script=samba-vuln-cve-2012-1182 -p 139 192.168.137.4
    nmap --script=auth 192.168.137.*  #负责处理鉴权证书(绕开鉴权)的脚本,也可以作为检测部分应用弱口令
    nmap --script=brute 192.168.137.*  #提供暴力破解的方式  可对数据库，smb，snmp等进行简单密码的暴力猜解
    nmap --script=default 192.168.137.* 或者 nmap -sC 192.168.137.* # 默认的脚本扫描，主要是搜集各种应用服务的信息，收集到后，可再针对具体服务进行攻击
    nmap --script=vuln 192.168.137.* #检查是否存在常见漏洞
    nmap -n -p445 --script=broadcast 192.168.137.4 #在局域网内探查更多服务开启状况
    nmap --script external 202.103.243.110 #利用第三方的数据库或资源，例如进行whois解析
nmap -PN -T4 -p139,445 -n -v --script=smb-check-vulns --script-args safe=1 192.168.0.1-254 # 在局域网上扫找 Conficker 蠕虫病毒
nmap -A -p1-85,113,443,8080-8100 -T4 --min-hostgroup 50 --max-rtt-timeout 2000 --initial-rtt-timeout 300 --max-retries 3 --host-timeout 20m --max-scan-delay 1000 -oA wapscan 10.0.0.0/8
 # 扫描网络上的恶意接入点 (rogue APs).
 nmap --script-args=unsafe=1 --script smb-check-vulns.nse -p 445,169 #扫描指定的目标,同时检测相关漏洞
 
 常见脚本资源
    github
https://github.com/atimorin/scada-tools
https://github.com/atimorin/PoC2013
https://github.com/drainware/scada-tools
https://github.com/drainware/nmap-scada

python-nmap使用
pip install python-nmap
文档: http://xael.org/pages/python-nmap-en.html
libnmap使用
文档: https://libnmap.readthedocs.org/en/latest/
实例参考: http://www.freebuf.com/tools/32092.html
 }
nmap_intro(){
规避原理
1    分片(Fragmentation)
    将可疑的探测包进行分片处理(例如将TCP包拆分成多个IP包发送过去)，某些简单的防火墙为了加快处理速度可能不会进行重组检查，
以此避开其检查。
2    IP诱骗(IP decoys)
    在进行扫描时，将真实IP地址和其他主机的IP地址(其他主机需要在线，否则目标主机将回复大量数据包到不存在的主机，从而实质
构成了拒绝服务攻击)混合使用，以此让目标主机的防火墙或IDS追踪检查大量的不同IP地址的数据包，降低其追查到自身的概率。注意，
某些高级的IDS系统通过统计分析仍然可以追踪出扫描者真实IP地址。
3    IP伪装(IP Spoofing)
    顾名思义，IP伪装即将自己发送的数据包中的IP地址伪装成其他主机的地址，从而目标机认为是其他主机在与之通信。需要注意，
如果希望接收到目标主机的回复包，那么伪装的IP需要位于统一局域网内。另外，如果既希望隐蔽自己的IP地址，又希望收到目标主机
的回复包，那么可以尝试使用idle scan或匿名代理(如TOR)等网络技术。
4    指定源端口
    某些目标主机只允许来自特定端口的数据包通过防火墙。例如FTP服务器配置为：允许源端口为21号的TCP包通过防火墙与FTP服务端通信，
但是源端口为其他端口的数据包被屏蔽。所以，在此类情况下，可以指定Nmap将发送的数据包的源端口都设置特定的端口。
5    扫描延时
    某些防火墙针对发送过于频繁的数据包会进行严格的侦查，而且某些系统限制错误报文产生的频率(例如，Solaris 系统通常会限制
每秒钟只能产生一个ICMP消息回复给UDP扫描)，所以，定制该情况下发包的频率和发包延时可以降低目标主机的审查强度、节省网络带宽。
6    其他技术
    Nmap还提供多种规避技巧，比如指定使用某个网络接口来发送数据包、指定发送包的最小长度、指定发包的MTU、指定TTL、指定伪装
的MAC地址、使用错误检查和(badchecksum)。

-f; --mtu : 指定使用分片、指定数据包的MTU.  
-D : 用一组IP地址掩盖真实地址，其中ME填入自己的IP地址。  
-S : 伪装成其他IP地址  
-e : 使用特定的网络接口  
-g/--source-port 
--data-length : 填充随机数据让数据包长度达到Num。  
--ip-options : 使用指定的IP选项来发送数据包。  
--ttl : 设置time-to-live时间。  
--spoof-mac : 伪装MAC地址  
--badsum: 使用错误的checksum来发送数据包(正常情况下，该类数据包被抛弃，如果收到回复，说明回复来自防火墙或IDS/IPS)。  
}

1. 指定端口：   连续端口或者枚举端口 <--> 内置著名端口 /etc/service
2. 指定网段：   连续网段、枚举地址、子网掩码 
3. 扫描类型：   ARP，TCP，UDP，ICMP
4. DNS解析与否：-n 不进行dns， -R 总是进行dns解析，  --dns-servers 指定dnsserver, --system-dns 使用系统dns系统
5. 跟踪数据包： 
nmap_classic(){
1. -A 全面扫描/综合扫描
nmap -A 127.0.0.1
扫描指定段
nmap -A 127.0.0.1-200
nmap -A 127.0.0.1/24

2.Nmap 主机发现
2.1 -sP ping扫描    (ARP)
nmap -sP 127.0.0.1
2.2 -p0             (ARP+TCP[--dport 0] RST)
# -P0 无ping扫描 备注:【协议1,协议2】【目标】扫描 
如果想知道这些协议是如何判断目标主机是否存在可以使用--packet-trace选项
nmap -p0 --packet-trace 127.0.0.1
2.3 -PS TCP SYN Ping扫描  (ARP TCP[SYN SYN+ACK RST]端口开放 TCP[SYN RST]端口关闭)
nmap -PS -v 127.0.0.1 
指定端口:
nmap -PS -p80,100-200 -v 127.0.0.1
nmap -PS22 或者 -PS22-25,80,113,1050,35000 -v 127.0.0.1
2.4 -PA TCP ACK Ping扫描   (ARP TCP[SYN SYN+ACK RST]端口开放 TCP[SYN RST]端口关闭)
nmap -PA -v 127.0.0.1

2.5 -PU UDP Ping扫描
nmap -PU -v 127.0.0.1
  
2.6 -PE;-PP;-PM
  -PE;-PP;-PM ICMP Ping Types 扫描
  使用ICMP Echo扫描方式
  例如:nmap -PE -v 127.0.0.1
  使用ICMP时间戳Ping扫描
  例如:nmap -PP -v 127.0.0.1
  使用ICMP地址掩码Ping扫描
  例如:nmap -PM -v 127.0.0.1
  
}
nmap_port_demo(){
nmap -p [port] hostName
## Scan port 80
nmap -p 80 192.168.1.1 ## Scan TCP port 80
nmap -p T:80 192.168.1.1 ## Scan UDP port 53
nmap -p U:53 192.168.1.1 ## Scan two ports ##
nmap -p 80,443 192.168.1.1 ## Scan port ranges ##
nmap -p 80-200 192.168.1.1 ## Combine all options ##
nmap -p U:53,111,137,T:21-25,80,139,8080 192.168.1.1
nmap -p U:53,111,137,T:21-25,80,139,8080 server1.cyberciti.biz
nmap -v -sU -sT -p U:53,111,137,T:21-25,80,139,8080 192.168.1.254 ## Scan all ports with * wildcard ##
nmap -p "*" 192.168.1.1 ## Scan top ports i.e. scan $number most common ports ##
nmap --top-ports 5 192.168.1.1
nmap --top-ports 10 192.168.1.1
}

nmap_os_demo(){
nmap -O 192.168.1.1 
nmap -O --osscan-guess 192.168.1.1 
nmap -v -O --osscan-guess 192.168.1.1
windows 主机容易被猜出来
}

nmap_service_demo(){
service version
nmap -sV 192.168.1.1  # 
}
nmap_output_demo(){
nmap -oN output.txt 192.168.1.1  # Text
nmap 192.168.1.1 > output.txt    # Text
nmap -oG output.txt 192.168.1.1  # Grepable format
nmap -oX output.xml 192.168.1.1  # XML format

nmap -dd 192.168.1.1  # debugging
nmap -vv 192.168.1.1  # verbosity
nmap --open 192.168.1.1 # 处于打开状态的TCP端口
nmap --packet-trace 192.168.1.1 # 收发报文

nmap --iflist # 接口的路由信息
}

nmap_speedup_demo(Speedup){
nmap -v -sS -A -T4 192.168.2.5 # -T<0-5>: Set timing template (higher is faster)
}

nmap_spoof_demo(){ 
spoof MAC 欺骗你的MAC地址
nmap --spoof-mac MAC-ADDRESS-HERE 192.168.1.1
nmap -v -sT -PN --spoof-mac MAC-ADDRESS-HERE 192.168.1.1

### Use a random MAC address ### 
### The number 0, means nmap chooses a completely random MAC address ###
nmap -v -sT -PN --spoof-mac 0 192.168.1.1
}
nmap_firewall_demo(){
nmap -f 192.168.1.1
nmap -f 15 fw2.nixcraft.net.in
## Set your own offset size with the --mtu option ## 
nmap --mtu 32 192.168.1.1
-f (报文分段); --mtu (使用指定的 MTU)
}
nmap_ip_demo(ip){
nmap -sO 192.168.10.107
}

snort(嗅探器){
嗅探器模式仅仅是从网络上读取数据包并作为连续不断的流显示在终端上。
snort -v # 如果你只要把TCP/IP包头信息打印在屏幕上，
snort -vd # 如果你要看到应用层的数据
snort -vde # 显示数据链路层的信息 snort -d -v -e
}
snort(数据包记录器){
数据包记录器模式把数据包记录到硬盘上。
snort -dev -l ./log # ./log目录必须存在，否则snort就会报告错误信息并退出。
snort -dev -l ./log -h 192.168.1.0/24 # 为了只对本地网络进行日志
snort -l ./log -b # 所谓的二进制日志文件格式就是tcpdump程序使用的格式
snort -dv -r packet.log # 如果你想在嗅探器模式下把一个tcpdump格式的二进制文件中的包打印到屏幕上
snort -dvr packet.log icmp # 你只想从日志文件中提取ICMP包
}
snort(网络入侵检测系统){
    网路入侵检测模式是最复杂的，而且是可配置的。我们可以让snort分析网络数据流以匹配用户定义的一些规则，并根据检测
结果采取一定的动作。
snort -dev -l ./log -h 192.168.1.0/24 -c snort.conf
https://github.com/erasin/notes/blob/master/linux/safe/snort.md
}

    ip(流量切分线路){

        # 程序判断进入IP线路，设置服务器路由规则控制返回
        vi /etc/iproute2/rt_tables
        #添加一条策略
        252   bgp2  #注意策略的序号顺序
        ip route add default via 第二个出口上线IP(非默认网关) dev eth1 table bgp2
        ip route add from 本机第二个ip table bgp2
        #查看
        ip route list table 252
        ip rule list
        #成功后将语句添加开机启动

    }

    snmp(){

        snmptranslate .1.3.6.1.2.1.1.3.0    # 查看映射关系
            DISMAN-EVENT-MIB::sysUpTimeInstance
        snmpdf -v 1 -c public localhost                            # SNMP监视远程主机的磁盘空间
        snmpnetstat -v 2c -c public -a 192.168.6.53                # SNMP获取指定IP的所有开放端口状态
        snmpwalk -v 2c -c public 10.152.14.117 .1.3.6.1.2.1.1.3.0  # SNMP获取主机启动时间
        # MIB安装(ubuntu)
        # sudo apt-get install snmp-mibs-downloader
        # sudo download-mibs
        snmpwalk -v 2c -c public 10.152.14.117 sysUpTimeInstance   # SNMP通过MIB库获取主机启动时间

    }

    tc(TC流量控制){

        # 针对ip段下载速率控制
        tc qdisc del dev eth0 root handle 1:                                                              # 删除控制1:
        tc qdisc add dev eth0 root handle 1: htb r2q 1                                                    # 添加控制1:
        tc class add dev eth0 parent 1: classid 1:1 htb rate 12mbit ceil 15mbit                           # 设置速率
        tc filter add dev eth0 parent 1: protocol ip prio 16 u32 match ip dst 10.10.10.1/24 flowid 1:1    # 指定ip段控制规则

        # 检查命令
        tc -s -d qdisc show dev eth0
        tc class show dev eth0
        tc filter show dev eth0

        限制上传下载{

            tc qdisc del dev tun0 root
            tc qdisc add dev tun0 root handle 2:0 htb
            tc class add dev tun0 parent 2:1 classid 2:10 htb rate 30kbps
            tc class add dev tun0 parent 2:2 classid 2:11 htb rate 30kbps
            tc qdisc add dev tun0 parent 2:10 handle 1: sfq perturb 1
            tc filter add dev tun0 protocol ip parent 2:0 u32 match ip dst 10.18.0.0/24 flowid 2:10
            tc filter add dev tun0 parent ffff: protocol ip u32 match ip src 10.18.0.0/24 police rate 30kbps burst 10k drop flowid 2:11


            tc qdisc del dev tun0 root                                     # 删除原有策略
            tc qdisc add dev tun0 root handle 2:0 htb                      # 定义最顶层(根)队列规则，并指定 default 类别编号，为网络接口 eth1 绑定一个队列，类型为 htb，并指定了一个 handle 句柄 2:0 用于标识它下面的子类
            tc class add dev tun0 parent 2:1 classid 2:10 htb rate 30kbps  # 设置一个规则速度是30kbps
            tc class add dev tun0 parent 2:2 classid 2:11 htb rate 30kbps
            tc qdisc add dev tun0 parent 2:10 handle 1: sfq perturb 1      # 调用随机公平算法
            tc filter add dev tun0 protocol ip parent 2:0 u32 match ip dst 10.18.0.0/24 flowid 2:10  # 规则2:10应用在目标地址上，即下载
            tc filter add dev tun0 parent ffff: protocol ip u32 match ip src 10.18.0.0/24 police rate 30kbps burst 10k drop flowid 2:11 # 上传限速

        }

    }

}

disk(){
1. 管理分区
1.1 查看内存的分区表
lsblk
cat /proc/partitions 
ls /dev/sd*
1.2 查看硬盘上的分区表
fdisk /dev/sdc -l
1.3 列出块设备
lsblk
1.4 创建分区使用:
    fdisk 创建MBR分区
    gdisk 创建GPT分区
    parted 高级分区操作
1.5 磁盘分区
1.5.1 为什么分区
    优化I/O性能
    实现磁盘空间配额限制
    提高修复速度
    隔离系统和程序
    安装多个OS
    采用不同文件系统
1.5.2 分区
两种分区方式:MBR，GPT
如何分区:按柱面
0磁道0扇区:512bytes
    446bytes: boot loader
    64bytes:分区表
        16bytes: 标识一个分区
    2bytes: 55AA
        hexdump -C -n 512 /dev/sda
4个主分区;3主分区+1扩展(N个逻辑分区)
1.6 支持的文件系统
    ls /lib/modules/3.10.0-693.el7.x86_64/kernel/fs
}

disk(原理){
所有的盘片都是同时同步转动，所有的磁头也是同步移动。
扇区上记录了物理数据、扇区号、磁头号(或者盘片号)及磁道号。
1. 柱面
1.1 将所有盘片相同磁道数的磁道划分为柱面。和磁道号的标记方式一样，从外向内从0开始逐数增加。
1.2 之所以划分柱面，是因为所有磁盘同步旋转，所有磁头同步移动，所有的磁头在任意一个时刻总是会出在同一个磁道同一个扇区上。读写数据时，任意一段数据总是按柱面来读写的。所以盘片数越多，读写所扫的扇区数就越少，所需的时间相对就越少，性能就越好。
1.3 盘片同步旋转，转动一个角度，外圈比内圈的线速度更快，磁头能够扫过的扇区数更多，因此读写越外圈磁道中的数据比越内圈更快。
1.4 向磁盘写数据是从外圈柱面向内圈柱面写的，只有写完一个柱面才写下一个柱面。因此磁盘用过一段时间后存储东西的速度会有所减慢就是因为外圈柱面已经用掉了。
2 扇区 磁道
2.1 读写磁头在停止状态下，在盘片旋转时磁头扫过的一圈轨迹称为磁道，所有的磁道都是同心圆。从盘片外圈开始向内数，磁道号从0开始逐数增加。
2.2 每个磁道以512字节等分为多个弧段。所以外圈磁道的扇区数较多，内圈磁道的扇区数较少，有些硬盘参数上写的磁道扇区数通常用一个范围来标识，如373-768表示最外圈磁道有768个扇区，最内圈有373个扇区，这就可以计算出每个磁道的字节数。
2.3 每个扇区512字节，扇区是磁盘控制器的最小读写单元。Windows操作系统以"簇"为存储单元，一个"簇"是多个扇区(可以是2、4、8...个扇区)，但是读写请求发送到磁盘控制器上仍是以扇区为单位的。之所以以"簇"为单元是因为可以适当避免碎片使得同一个文件的数据所在的扇区出现物理间隔，这样不断的移动磁头会严重降低读写速度。
3. 磁盘或分区容量计算
disk       磁盘
heads      磁头。Linux系统中查看到的heads一般包括很多虚拟磁头，实际的物理磁盘的一块盘片上下两面一面一磁头，即2个磁头。
sectors    扇区。一磁道上划分多个扇形区域，一般默认一扇区512字节。
track      磁道。盘片上一圈算一磁道。
cylinders  柱面。所有盘片的同一半径的磁道组成一柱面。柱面数=盘片数*盘片上的磁道数。
units      单元块。大小等于一个柱面大小。

磁盘或分区大小计算方法：
磁盘大小=units×柱面数(cylinders)
磁盘大小=磁头数(heads)×每磁道上的扇区数(sectors)×512×柱面数(cylinders)
查看/dev/sda3。

[root@xuexi tmp]# fdisk -l /dev/sda3
Disk /dev/sda3: 19.1 GB, 19116589056 bytes         # 总大小19G
255 heads, 63 sectors/track, 2324 cylinders        # 磁头255 柱面2324  每磁道扇区数63(这是平均数)
Units = cylinders of 16065 * 512 = 8225280 bytes   # 单元块大小
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0x00000000

Units=255×63×512=16065×512=8225280
磁盘大小=255*63*2324*512=19115550720= 19.11555072GB，不用1024算，用1000算。

4. 分区
分区是为了在逻辑上将某些柱面隔开形成边界。它是以柱面为单位来划分的，首先划分外圈柱面，然后不断向内划分。
由于读写越外圈磁道中的数据比越内圈更快，所以第一个分区在读写性能上比后面的分区更好。在Windows操作系统上，C盘的速度是最快的，越后面的区越慢就是这个原因。
在磁盘数据量非常大的情况下，划分分区的好处是扫描块位图等更快速：不用再扫描整块磁盘的块位图，只需扫描对应分区的块位图。
5. 分区方法(MBR和GPT)
    MBR格式的磁盘中，会维护磁盘第一个扇区——MBR扇区，在该扇区中第446字节之后的64字节是分区表，
每个分区占用16字节，所以限制了一块磁盘最多只能有4个主分区(Primary,P)，如果多于4个区，只能将主分区少于4个，
通过建立扩展分区(Extend,E)，然后在扩展分区建立逻辑分区(Logical,L)的方式来突破4个分区的限制。
在Linux中，MBR格式的磁盘主分区号从1-4，扩展分区号从2-4，逻辑分区号从5-15，也就是最大限制是15个分区。
例如，一块盘想分成6个分区，可以：
1P+5L：sda1+sda5+sda6+sda7+sda8+sda9
2P+4L：sda1+sda2+sda5+sda6+sda7+sda8
3P+3L：sda1+sda2+sda3+sda5+sda6+sda7
而GPT格式突破了MBR的限制，它不再限制只能存储4个分区表条目，而是使用了类似MBR扩展分区表条目的格式，它允许有128个主分区，这也使得它可以对超过2TB的磁盘进行分区。
6. MBR
    在MBR格式分区表中，MBR扇区占用512个字节，前446个字节是主引导记录，即boot loader。中间64字节记录着
分区表信息，每个主分区信息占用16字节，因此最多只能有4个主分区，最后2个字节是有效标识位。如果使用扩展分区，
则扩展分区对应的16字节记录的是指向扩展分区中扩展分区表的指针。
    在MBR磁盘上，分区和启动信息是保存在一起的，如果这部分数据被覆盖或破坏，只能重建MBR。而GPT在整个磁盘上
保存多个这部分信息的副本，因此它更为健壮，并可以恢复被破坏的这部分信息。GPT还为这些信息保存了循环冗余
校验码(CRC)以保证其完整和正确，如果数据被破坏，GPT会发现这些破坏，并从磁盘上的其他地方进行恢复。
7.  EFI部分可以分为4个区域：EFI信息区(GPT头)、分区表、GPT分区区域和备份区域。
    EFI信息区(GPT头)：起始于磁盘的LBA1，通常也只占用这个单一扇区。其作用是定义分区表的位置和大小。GPT头还包含头和分区表的校验和，这样就可以及时发现错误。
    分区表：分区表区域包含分区表项。这个区域由GPT头定义，一般占用磁盘LBA2～LBA33扇区，每扇区可存储4个主分区的分区信息，所以共能分128个主分区。分区表中的每个分区项由起始地址、结束地址、类型值、名字、属性标志、GUID值组成。分区表建立后，128位的GUID对系统来说是唯一的。
    GPT分区：最大的区域，由分配给分区的扇区组成。这个区域的起始和结束地址由GPT头定义。
    备份区：备份区域位于磁盘的尾部，包含GPT头和分区表的备份。它占用GPT结束扇区和EFI结束扇区之间的33个扇区。其中最后一个扇区用来备份1号扇区的EFI信息，其余的32个扇区用来备份LBA2～LBA33扇区的分区表。
}
disk(命令){
1. Linux上磁盘热插拔。
ls /sys/class/scsi_host/  # 查看主机scsi总线号 ->host0  host1  host2
2. 重新扫描scsi总线以热插拔方式添加新设备。
echo "- - -" > /sys/class/scsi_host/host0/scan
echo "- - -" > /sys/class/scsi_host/host1/scan
echo "- - -" > /sys/class/scsi_host/host2/scan
fdisk -l      # 再查看就有了
2.1 如果scsi_host目录系很多hostN目录，则使用循环来完成。
ls /sys/class/scsi_host/
# host0   host11  host14  host17  host2   host22  host25  host28  host30  host4  host7
# host1   host12  host15  host18  host20  host23  host26  host29  host31  host5  host8
# host10  host13  host16  host19  host21  host24  host27  host3   host32  host6  host9
for i in /sys/class/scsi_host/host*/scan;do echo "- - -" >$i;done
3. 使用fdisk分区工具
fdisk工具用来分MBR磁盘上的区。要分GPT磁盘上的区，可以使用gdisk。parted工具对这两种格式的磁盘分区都支持
}
fsck(检查和修复Linux文件系统){
fsck [-sAVRTMNP] [-C [fd]] [-t fstype] [filesys...]  [--] [fs-specific-options]
filesys: 可以为一个设备名称/dev/sda1 /dev/hdc1； 也可以是一个挂载点 /mnt / /usr /home
         或者是ext2的label或者uuid(UUID=8868abf6-88c5-4a83-98b8-bfc24057f7bd  or  LABEL=root)
通常，fsck会试着以并行的方式同时在不同的物理磁盘上运行文件系统检查，这样可以减少对所有文件系统进行检查的时间
如果没有在命令行指定文件系统，并且没有指定-A选项，fsck将默认顺序地检查/etc/fstab中登记的文件系统。这和使用-As选项是相同的。

fsck返回值：当检测多个文件系统时，退出的返回值是对每个文件系统检查的返回值按位或的结果
0   没有错误
1   文件系统有错但已修复
2   系统应当重启
4   文件系统错误没有修复
8   运行错误
16  用法或语法错误
32  用户撤销了fsck 操作
128 共享库出错

fsck是fsck.fstype的前端fsck.ext2 fsck.ext3 fsck.ext4 fsck.ext4dev-> e2fsck ; fsck.msdos fsck.vfat -> dosfsck; fsck.cramfs
fsck 后端先在/sbin中查找，然后再在/etc/fs and /etc中查找；最后在PATH环境变量中列出的路径中搜索。

-s 顺序执行fsck操作：常用于一次检查多个文件系统和交互模式执行检查。e2fsck默认为交互模式；
   当需要自动修正磁盘上错误的时候，e2fsck非交互模式执行，需要执行-s或-p选项。e2fsck执行-n选项则执行在交互模式下
-t  指定要检查的文件系统的类型。当指定了 -A 标志时，只有fslist中列出的类型的文件系统会被检查。
   fslist参数是一个以逗号分隔的文件系统类型列表以及选项说明符。
   可以在这个以逗号分隔的列表的所有文件系统前面加上否定前缀'no'或'!'来使得只有没有列在 fslist 中的文件系统将被检查。
   如果并非fslist中列出的所有文件系统都加上了否定前缀，那么只有 fslist 中列出的文件系统将被检查。
   
   选项说明符也可能包含在这个以逗号分隔的列表 fslist 中。它们的格式是 opts=fs-option。
   如果出现了选项说明符，那么只有在 /etc/fstab 中它们的挂载选项字段中不包含 fs-option 的文件系统将被检查。
   如果选项说明符有否定前缀，那么只有在 /etc/fstab 中它们的挂载选项字段中包含 fs-option 的文件系统将被检查。
   例如，如果 fslist 中出现了 opts=ro 那么只有 /etc/fstab 中，挂载选项包含 ro 的文件系统将被检查。
   
   一般地，文件系统类型是在 /etc/fstab 中通过搜索与 filesys 相应的条目得到的。
   如果不能这样推知类型，并且 -t 选项只有一个文件系统参数，fsck 将使用指定的文件系统类型。
   如果不能使用这种类型，将使用默认的文件系统类型(当前是ext2)。

-A 搜索 /etc/fstab 文件，一次检查所有在文件中有定义的文件系统。/etc/rc
   如果没有使用-P选项，则根文件系统将第一个被检查。之后，将按/etc/fstab文件中第六字段fs_passno指定的顺序对各文件系统进行检查。
    fs_passno 值为0 的文件系统将被跳过，不会被检查。fs_passno值大于0的文件系统将被按顺序检查，
    fs_passno 值最小的文件系统将被最先检查。如果多个文件系统有相同的pass号，fsck将试着并行处理这些文件系统，尽管它不允许在同一个物理磁盘上同时运行多个文件系统检查程序。

    因此，/etc/fstab  文件中的一个很普遍的设置是将root文件系统的fs_passno设为1，定义其它文件系统的 fs_passno
    为2。这样就充许 fsck 程序自动以并行的方式运行文件系统检查，
    如果这样有好处的话。系统管理员可能会出于某些原因而不希望并行运行多个文件系统检查--例如，如果内存不够，那么过多的换页会成为系统瓶颈。
-C  如果文件系统检查器支持的话(当前只有ext2)，显示进度条。fsck将管理各文件系统检查器，使得同一时间它们中只能有一个可以显示进度条。
-N  不执行，仅仅显示将执行的操作。
-P  当设置了 -A 标志时，将并行检查root文件系统和其他文件系统。
    这样是世界上最不安全的做法，因为如果root文件系统有问题，
    这样的程序可执行文件将被破坏！这个选项是为不想把root文件系统分得小而紧凑(这才是正确的做法)的系统管理员准备的。
-R  当使用 -A 标志来检查所有文件系统时，跳过root文件系统 (它可能已经被挂载为可读写)。
-T  启动时不显示标题。
-V  产生冗余输出，包含所有被执行的特定文件系统的命令。 

-a  不提问，自动修复文件系统
-r  交互式地修复文件系统错误(询问确认)。
-y  对于fsck的所有问题都假定一个'yes'响应；在这样使用的时候，必须特别的小心，因为它实际上允许程序无条件的继续运行，即使是遇到了一些非常严重的错误。
-n  
}

storage_system_intro(){
1. 文件系统配置文件
/etc/filesystems ：系统指定的测试挂载文件系统类型 
/proc/filesystems：Linux系统已经加载的文件系统类型 
/lib/modules/2.6.18-274.el5/kernel/fs/   文件系统类型的驱动所在目录 
/etc/fstab  
/etc/mtab 
2. man 帮助文档
man 5 filesystems
man 5 fstab
3. 文件系统操作命令 
    df -Ph                                # 查看硬盘容量
    df -T                                 # 查看磁盘分区格式
    ls -i                                 # 查看inode节点  
    df -i                                 # 查看inode节点   如果inode用满后无法创建文件
    du -h 目录                            # 检测目录下所有文件大小
    du -sh    # 显示当前目录大小 
    du -sh /  # 显示/目录下的所有目录大小 
    du -sh *                              # 显示当前目录中子目录的大小
    du -sh <dir>                          # 查看指定目录的大小 
    du -sh * | sort -nr | head            # 空间占用 du
    du -lh <dir>                          #查看指定目录各文件的大小
    dumpe2fs /dev/mapper/VolGroup-lv_home # 显示当前的磁盘状态
    mount -l                              # 查看分区挂载情况
    fdisk -l                              # 查看磁盘分区状态
    fdisk /dev/hda3                       # 分区
# GPT分区转MBR分区
    sudo apt-get install gdisk // input your storage device node. 
    sudo gdisk /dev/sdc 
        r // switch to recovery mode 
        g // GPT to MBR
    
    mkfs -t ext3  /dev/hda3               # 格式化分区
    fsck -y /dev/sda6                     # 对文件系统修复
    lsof |grep delete                     # 释放进程占用磁盘空间  列出进程后，查看文件是否存在，不存在则kill掉此进程
    tmpwatch -afv 10   /tmp               # 删除10小时内未使用的文件  勿在重要目录使用
    cat /proc/filesystems                 # 查看当前系统支持文件系统
    
    df -T
    fsck -N /dev/sda3
    fsck -N /dev/sdb1
    lsblk
  # NAME：设备名称；
  # MAJ:MIN：主设备号和此设备号；
  # RM：是否为可卸载设备，1表示可卸载设备。可卸载设备如光盘、USB等。并非能够umount的就是可卸载的；
  # SIZE：设备总空间大小；
  # RO：是否为只读；
  # TYPE：是磁盘disk，还是分区part，亦或是rom，还有loop设备；
  # mountpoint：挂载点。
  lsblk -f # 查看到文件系统类型，和文件系统的uuid和挂载点。
  blkid    # 查看器文件系统类型和uuid. Print UUIDs of all filesystems
  file -s /dev/sda # 
  blkid /dev/sda3                       # 查看当前系统块设备的UUID号
  file -sl /dev/sda3
  iotop                                 # 磁盘IO占用情况排序   yum install iotop

storage_smartctl_man(){
1、smartctl -a  <device>              # 检查该设备是否已经打开SMART技术。
2、smartctl -s on <device>            # 如果没有打开SMART技术，使用该命令打开SMART技术。
3、smartctl -t short <device>         # 后台检测硬盘，消耗时间短；
      smartctl -t long <device>       # 后台检测硬盘，消耗时间长；
      smartctl -C -t short <device>   # 前台检测硬盘，消耗时间短；
      smartctl -C -t long <device>    # 前台检测硬盘，消耗时间长。
其实就是利用硬盘SMART的自检程序。
4、smartctl -X <device>               # 中断后台检测硬盘。
5、smartctl -l selftest <device>      # 显示硬盘检测日志。
6、smartctl -l error <device>         # 显示硬盘错误汇总。

smartctl -H /dev/sda                  # 检测硬盘状态  # yum install smartmontools
smartctl -i /dev/sda                  # 检测硬盘信息
smartctl -a /dev/sda                  # 检测所有信息
}    

storage_mount_man(){
mount -t <fstype> 指定文件系统类型,通常不需指定,自动匹配正确类型 
   -o <options> 指定设备的挂载方式,多选时以逗号分开 
      defaults 默认值auto/nouser/rw/suid 
      auto/noauto 允许/不允许以-a选项安装 
      dev/nodev 对/不对文件系统上特殊设备进行解释 
      exec/noexec 允许/不允许执行二进制代码 
      suid/nosuid 确认/不确认suid和sgid位 
      user/nouser 允许/不允许一般用户挂载 
      codepage=XXX 代码页 
      iocharset=XXX 字符集 
      ro 只读方式挂载 
      rw 读写方式挂载 
      remount 重新挂载已挂载的文件系统 
      loop 挂载回旋设备 
   -r 只读方式挂载 
   -w 可写方式挂载,默认 
   -a 挂载/etc/fstab中列出所有文件系统 
   -n 不把挂载记录写入到/etc/mtab中 
   -l 显示已加载文件系统列表 
   -v 显示详细挂载信息
}
storage_mount_demo(){
  mount  -o remount,rw,auto /  # 重新挂载 
  mount  -n -o remount,rw  /   # 重新挂载根目录，设置为可读写 
  
  mount -o remount,rw /                 # 修改只读文件系统为读写
  tune2fs -j /dev/sda                   # ext2分区转ext3分区
  tune2fs -l /dev/sda                   # 查看文件系统信息
  mke2fs -b 2048 /dev/sda5              # 指定索引块大小
  dumpe2fs -h /dev/sda5                 # 查看超级块的信息
  mount -t iso9660 /dev/dvd  /mnt       # 挂载光驱
  mount -t ntfs-3g /dev/sdc1 /media/yidong        # 挂载ntfs硬盘
  mount -t nfs 10.0.0.3:/opt/images/  /data/img   # 挂载nfs 需要重载 /etc/init.d/nfs reload  重启需要先启动 portmap 服务
  mount -o loop  /software/rhel4.6.iso   /mnt/    # 挂载镜像文件
  mount -t iso9660 -o loop file.iso /mnt                # Mount a CD image
  mount -t ext3 -o loop file.img /mnt                   # Mount an image with ext3 fs
  mount -t tmpfs tmpfs /tmpram -o size=512m
  mount -t tmpfs -o size=1024m tmpfs /mnt/ram
  
  mount -t cifs -o credentials=/home/user/.smb //192.168.16.229/myshare /mnt/smbshare
  mount -t auto /dev/cdrom /mnt/cdrom # typical cdrom mount command 
  mount /dev/hdc -t iso9660 -r /cdrom # typical IDE 
  mount /dev/scd0 -t iso9660 -r /cdrom # typical SCSI cdrom 
  mount /dev/sdc0 -t ntfs-3g /windows # typical SCSI
  
  smbclient -U usertest -L //192.168.27.125/
  smbclient -U user -I 192.168.16.229 -L //smbshare/ # List the shares 
  mount -t smbfs -o username=winuser //smbserver/myshare /mnt/smbshare 
  mount -t smbfs -o username=administrator,password=pldy123 //10.140.133.23/c$ /mnt/samba
  mount -t cifs -o username=winuser,password=winpwd //192.168.16.229/myshare /mnt/share
  mount  -t smbfs -o username=administrator,password=pldy123 //10.140.133.23/c$ /mnt/samba
  
  mount -t ntfs -o iocharset=cp936 /dev/sdc1 /mnt/usbhd1  # 若汉字文件名显示为乱码或不显示
  
  1. 从光盘制作光盘镜像文件。将光盘放入光驱，执行下面的命令。 
  #cp /dev/cdrom /home/sunky/mydisk.iso  或 
  #dd if=/dev/cdrom of=/home/sunky/mydisk.iso  
  注：执行上面的任何一条命令都可将当前光驱里的光盘制作成光盘镜像文件/home/sunky/mydisk.iso  
  2.将文件和目录制作成光盘镜像文件，执行下面的命令。 
  #mkisofs  -r  - J  - V mydisk  - o /home/sunky/mydisk.iso /home/sunky/ mydir 
  注：这条命令将/home/sunky/mydir目录下所有的目录和文件制作成光盘镜像文件
/home /sunky/mydisk.iso，光盘卷标为：mydisk  
  3.光盘镜像文件的挂接(mount) 
  #mkdir /mnt/vcdrom 
  注：建立一个目录用来作挂接点(mount point)  
   #mount - o loop  -t iso9660 /home/sunky/mydisk.iso /mnt/vcdrom 
  注：使用/mnt/vcdrom 就可以访问盘镜像文件 mydisk.iso里的所有文件了
}
    
    dd if=/dev/hdc of=/tmp/mycd.iso bs=2048 conv=notrunc
    mkisofs -J -L -r -V TITLE -o imagefile.iso /path/to/dir
    
    growisofs -dvd-compat -Z /dev/dvd=imagefile.iso # Burn existing iso image 
    growisofs -dvd-compat -Z /dev/dvd -J -R /p/to/data # Burn directly
    
# 启动分区表示 
root=LABEL=System
root=UUID=0a3407de-014b-458b-b5c1-848e92a327a3
root=/dev/disk/by-id/wwn-0x60015ee0000b237f-part2
root=PARTUUID=98a81274-10f7-40db-872a-03df048df366
root=PARTLABEL=GNU\057Linux

ls -l /dev/disk/{by-id|by-label|by-path|by-uuid}
uuid(disk){
1、如何获取uuid
ls -l /dev/disk/by-uuid/ # 通过浏览 /dev/disk/by-uuid/ 下的设备文件信息。
vol_id /dev/sdb5         # 通过 vol_id 命令
blkid /dev/sdb5          # 通过 blkid 命令
lsblk -f

2、配置uuid
uuidgen | xargs tune2fs /dev/sda[0-9] -U  # uuidgen 会返回一个合法的 uuid，结合 tune2fs 可以新生成一个 uuid 并写入 ext2,3,4 分区中
tune2fs -U $UUID /dev/sda[0-9]            # 把 fstab 里找到的原 uuid 写回分区

mkntfs -U, --with-uuid

swapon -s
swapon off
mkswap -U random /dev/sda7
swapon /dev/sda7
}
uuid(意义){
原因1：它是真正的唯一标志符
    UUID为系统中的存储设备提供唯一的标识字符串，不管这个设备是什么类型的。如果你在系统中添加了新的存储设备
如硬盘，很可能会造成一些麻烦，比如说启动的时候因为找不到设备而失败，而使用UUID则不会有这样的问题。

原因2：设备名并非总是不变的
    自动分配的设备名称并非总是一致的，它们依赖于启动时内核加载模块的顺序。如果你在插入了USB盘时启动了系统，
而下次启动时又把它拔掉了，就有可能导致设备名分配不一致。
    使用UUID对于挂载移动设备也非常有好处──例如我有一个24合一的读卡器，它支持各种各样的卡，而使用UUID总可以
使同一块卡挂载在同一个地方。

原因3：Ubuntu中的许多关键功能现在开始依赖于UUID
例如grub──系统引导程序，现在可以识别UUID，打开你的/boot/grub/menu.lst，你可以看到类似如下的语句：
title Ubuntu hardy (development branch), kernel 2.6.24-16-generic
root (hd2,0)
kernel /boot/vmlinuz-2.6.24-16-generic root=UUID=c73a37c8-ef7f-40e4-b9de-8b2f81038441 ro quiet splash
initrd /boot/initrd.img-2.6.24-16-generic
quiet
}
label(disk){
lsblk -f                 # label查询
blkid
# 如果后面指定新label则为分区设定新label；如果后面不指定label，则显示分区的当前label

swap        swaplabel -L <label> /dev/XXX using util-linux
ext2/3/4    e2label /dev/XXX <label> using e2fsprogs
btrfs       btrfs filesystem label /dev/XXX <label> using btrfs-progs
reiserfs    reiserfstune -l <label> /dev/XXX using reiserfsprogs
jfs         jfs_tune -L <label> /dev/XXX using jfsutils
xfs         xfs_admin -L <label> /dev/XXX using xfsprogs
fat/vfat    fatlabel /dev/XXX <label> using dosfstools
            mlabel -i /dev/XXX ::<label> using mtools
            dosfslabel device [label]
exfat       exfatlabel /dev/XXX <label> using exfat-utils
ntfs        ntfslabel /dev/XXX <label> using ntfs-3g
zfs         this filesystem does not support /dev/disk/by-label

mkfs  -L  lable # 指定label
}


man fstab
//192.168.10.109/root /mnt cifs username=root,password=123456 0 0   # samba
fstab(){ uuid -> blkid|lsblk -f ; label -> lsblk
+-------------+--------+----------+----------+----+----+
| LABEL=/boot | /boot  |   ext3   | defaults | 1  | 2  |
|    设备名   | 挂载点 | 文件系统 |   选项   |频率|次序|
+-------------+--------+----------+----------+----+----+
<file system> <dir> <type> <options> <dump> <pass>
<file system>: 
  内核名称 : fdisk -l  /dev/sdb1
  UUID     : lsblk -f  LABEL=
  label    : lsblk -f  UUID=
  lsblk --noheadings --output UUID /dev/mapper/VolGroup-lv_root
<dir>: 如果挂载的路径中有空格，可以使用 "\040" 转义字符来表示空格
type: 支持许多种不同的文件系统：ext2, ext3, ext4, reiserfs, xfs, jfs, smbfs, iso9660, vfat, ntfs, swap 及 auto。 
      设置成auto类型，mount 命令会猜测使用的文件系统类型，对 CDROM 和 DVD 等移动设备是非常有用的。
      
<options> - 挂载时使用的参数，注意有些 参数是特定文件系统才有的。一些比较常用的参数有 (mount(8))：
    auto - 在启动时或键入了 mount -a 命令时自动挂载。
    noauto - 只在你的命令下被挂载。
    exec - 允许执行此分区的二进制文件。
    noexec - 不允许执行此文件系统上的二进制文件。
    ro - 以只读模式挂载文件系统。
    rw - 以读写模式挂载文件系统。
    user - 允许任意用户挂载此文件系统，若无显示定义，隐含启用 noexec, nosuid, nodev 参数。
    users - 允许所有 users 组中的用户挂载文件系统.
    nouser - 只能被 root 挂载。
    owner - 允许设备所有者挂载.
    sync - I/O 同步进行。
    async - I/O 异步进行。
    dev - 解析文件系统上的块特殊设备。
    nodev - 不解析文件系统上的块特殊设备。
    suid - 允许 suid 操作和设定 sgid 位。这一参数通常用于一些特殊任务，使一般用户运行程序时临时提升权限。
    nosuid - 禁止 suid 操作和设定 sgid 位。
    noatime - 不更新文件系统上 inode 访问记录，可以提升性能(参见 atime 参数)。
    nodiratime - 不更新文件系统上的目录 inode 访问记录，可以提升性能(参见 atime 参数)。
    relatime - 实时更新 inode access 记录。只有在记录中的访问时间早于当前访问才会被更新。(与 noatime 相似，但不会打断如 mutt 或其它程序探测文件在上次访问后是否被修改的进程。)，可以提升性能(参见 atime 参数)。
    flush - vfat 的选项，更频繁的刷新数据，复制对话框或进度条在全部数据都写入后才消失。
    defaults - 使用文件系统的默认挂载参数，例如 ext4 的默认参数为:rw, suid, dev, exec, auto, nouser, async.

<dump> dump 工具通过它决定何时作备份. dump 会检查其内容，并用数字来决定是否对这个文件系统进行备份。 
      允许的数字是 0 和 1 。0 表示忽略， 1 则进行备份。大部分的用户是没有安装 dump 的 ，对他们而言 
      <dump> 应设为 0。

<pass> fsck 读取 <pass> 的数值来决定需要检查的文件系统的检查顺序。允许的数字是0, 1, 和2。 
       根目录应当获得最高的优先权 1, 其它所有需要被检查的设备设置为 2. 0 表示设备不会被 fsck 所检查。
}

# dstat -cdlmnpsy
----total-cpu-usage---- -dsk/total- ---load-avg--- ------memory-usage----- -net/total- ---procs--- ----swap--- ---system--
usr sys idl wai hiq siq| read  writ| 1m   5m  15m | used  buff  cach  free| recv  send|run blk new| used  free| int   csw
  0   0 100   0   0   0|1025B 3382B|   0 0.02    0|1302M  704M 1969M 3871M|   0     0 |  0   0 0.3|   0  7984M| 155   307
  
dstat(通用的系统资源统计工具 sar ){
 -c,--cpu 			#显示CPU状态(system, user, idle, wait, hardware interrupt, software interrupt) 
 -C 0,3,total 		#指定其中一个CPU的状态或者全部
 -d,--disk 			#显示磁盘状态(read, write)
 -D total,sda 		#指定其中一个磁盘的状态或者全部的
 -g,--page			#显示page状态(page in, page out)
 -i,--int			#显示interrupt(中断)状态
 -l,--load			#显示平均负载(1 min, 5 mins, 15mins)
 -m,--mem			#显示内存状态(used, buffers, cache, free)
 -n,--net			#网络状态(receive, send)
 -N eth1,total		#指定相应的网卡设备或全部
 -p,--proc			#线程状态 (runnable, uninterruptible, new)
 -r,--io			#IO状态(read, write requests)
 -s,--swap			#交换空间状态(used, free)
 -S swap1,total 	#include swap1 and total (when using -s/--swap)
 -t,--time			#打印出来时间
 -T,--epoch			#打印出时间计算器(seconds since epoch)
 -y,--sys			#系统状态(interrupts, context switches

 --aio 				#异步I/O状态(asynchronous I/O)
 --fs   			#文件系统(open files, inodes)
 --ipc  			#enable ipc stats (message queue, semaphores, shared memory)
 --lock 			#文件锁 (posix, flock, read, write)
 --raw  			#enable raw stats (raw sockets)
 --socket			#套接字状态(total, tcp, udp, raw, ip-fragments)	
 --tcp  			#enable tcp stats (listen, established, syn, time_wait, close)
 --udp  			#enable udp stats (listen, active)
 --unix 			#enable unix stats (datagram, stream, listen, active)
 --vm   			#enable vm stats (hard pagefaults, soft pagefaults, allocated, free)

 --plugin-name 		#enable (external) plugins by plugin name, see PLUGINS for options
 --list 			#显示内部和外部的插件名字

 -a,--all			#等同于-cdngy (default)
 -f,--full			#等同于-C, -D, -I, -N and -S discovery lists            
 -v,--vmstat			#等同于-pmgdsc -D total
	
 --float			#force float values on screen (mutual exclusive with --integer)
 --integer			#force integer values on screen (mutual exclusive with --float)

 --bw,--blackonwhite		#change colors for white background terminal
 --nocolor			#disable colors (implies --noupdate)
 --noheaders			#disable repetitive headers
 --noupdate			#disable intermediate updates when delay > 1
 --output file			#导出结果CSV文件
 --profile			#show profiling statistics when exiting dstat
} 
    
    mpstat 1 # 可以查看多核心cpu中每个计算核心的统计数据
    mpstat(处理器相关统计报告){
    -A       #相当于使用-I ALL -u -P ALL
-I {SUM | CPU | SCPU | ALL}             #报告中断的统计资料
  SUM：      #mpstat命令报告每个处理器的中断总数。显示的值如下：
    CPU：    #处理器编号，all表示显示统计信息的值为所有处理器的平均值
    intr/s： #显示每秒接收到的CPU或CPUs的中断总数。
  CPU:       #显示CPU每秒接收到的每个中断的数量
  SCPU：     #显示CPU每秒接收到的每一个单独的软件中断的数量，此选项仅适用于内核2.6.31和更高版本。
  ALL：      #相当于指定以上所有关键字
-P { cpu [,...] | ON | ALL }          #指定处理器编号显示其统计报告
  cpu：   #cpu为处理器编号，处理器0是所述第一个处理器。
  ON：    #每一个正在使用的处理器的统计报告
  ALL：   #所有处理器的统计报告。
-u      #报告的CPU利用率，显示的值如下：
  CPU：      #处理器编号，all表示显示统计信息的值为所有处理器的平均值
  %usr：     #用户层使用的CPU利用率的百分比                            (usr/total)*100
  %nice：    #有优先级的用户层使用的CPU利用率的百分比                  (nice/total)*100
  %sys：     #内核层使用的CPU利用率的百分比，此步包含软硬中断的时间    (system/total)*100
  %iowait    #CPU因为未解决的磁盘IO的请求而闲置的时间百分比            (iowait/total)*100
  %irq：     #显示CPU服务于硬件中断所花费的时间的百分比                (irq/total)*100
  %soft：    #显示CPU服务于软件中断所花费的时间的百分比                (softirq/total)*100
  %steal：   #显示当管理程序维护另一个虚拟处理器，虚拟的cpu花在强制等待时间百分比
  %guest：   #显示CPU运行一个虚拟处理器所花的时间百分比
  %idle：    #显示系统没有未解决的磁盘IO请求，CPU闲置的时间百分比       (idle/total)*100
                                        #NOTE：重点关注%iowait，%idle
-V  #显示版本号
# 计算公式如下
    total_cur=user+system+nice+idle+iowait+irq+softirq
    total_pre=pre_user+ pre_system+ pre_nice+ pre_idle+ pre_iowait+ pre_irq+ pre_softirq
    user=user_cur - user_pre
    total=total_cur-total_pre
    其中_cur 表示当前值，_pre表示interval时间前的值。上表中的所有值可取到两位小数点。

mpstat 2 5 #显示全局统计5次，时间间隔为2s 
mpstat -P ALL 2 5 #显示所有cpu的统计5次，时间间隔为2
    }
    
    pidstat -d 1 # 展示I/O统计，每秒更新一次
    iotop -oP # 只显示有I/O行为的进程
    IO(){
I/O 调度算法再各个进程竞争磁盘I/O的时候担当了裁判的角色。他要求请求的次序和时机做最优化的处理，以求得尽可能最好的整体I/O性能。
下面列出4种调度算法：
    CFQ (Completely Fair Queuing 完全公平的排队)(elevator=cfq)： 这是默认算法，对于通用服务器来说通常是最好的选择。它试图均匀地分布对I/O带宽的访问。
    Deadline (elevator=deadline)： 这个算法试图把每次请求的延迟降至最低。该算法重排了请求的顺序来提高性能。
    NOOP (elevator=noop): 这个算法实现了一个简单FIFO队列。他假定I/O请求由驱动程序或者设备做了优化或者重排了顺序(就像一个智能控制器完成的工作那样)。在有些SAN环境下，这个选择可能是最好选择。
    Anticipatory (elevator=as): 这个算法推迟I/O请求，希望能对它们进行排序，获得最高的效率。对于桌面工作站来说，这个算法可能是一个不错的选择，但对服务器则很少会理想。
# cat /sys/block/{DEVICE-NAME}/queue/scheduler
# cat /sys/block/sda/queue/scheduler
# echo {SCHEDULER-NAME} > /sys/block/{DEVICE-NAME}/queue/scheduler
# echo noop > /sys/block/hda/queue/scheduler
    }
    vmstat 2 # display virtual memory statistics 
    iostat 2 # display I/O statistics (2 s intervals)
iostat(磁盘IO性能检测){
         -c #只显示CPU利用率的报告
         -d #只显示块设备的使用报告
         -m #以mbps显示
         -p[ { device [,...] | ALL } ]  #指定设备名，all为所有
         -t #显示时间 
         -V #显示版本
         -x #显示扩展的统计
         -z #省略不活动的设备
        iostat -mxz 15 # 可以让你获悉 CPU 和每个硬盘分区的基本信息和性能表现。
        
        iostat -x 1 10
        iostat  #显示从开机的所有CPU和Devices的报告
        iostat -d 2     #每隔2秒显示一次device的报告
        iostat -d 2 6   #每隔2秒显示6次设备的信息统计
        iostat -x sda sdb 2 6 #每隔2秒显示6次sda和sdb的扩展统计
        iostat -p sda 2 6     #每隔2秒显示6次sda和它的分区的统计
        iostat -d -k 1 10     #查看TPS和吞吐量信息(磁盘读写速度单位为KB)
        iostat -d -m 2        #查看TPS和吞吐量信息(磁盘读写速度单位为MB)
        iostat -d -x -k 1 10  #查看设备使用率%util、响应时间await
# iostat -c 1 10 # 获取cpu部分状态值
        % user     # 显示了在用户级(应用程序)执行时生成的 CPU 使用率百分比。
        % system   # 显示了在系统级(内核)执行时生成的 CPU 使用率百分比。
        % idle     # 显示了在 CPU 空闲并且系统没有未完成的磁盘 I/O 请求时的时间百分比。
        % iowait   # 显示了 CPU 空闲期间系统有未完成的磁盘 I/O 请求时的时间百分比。
# iostat -d -k 1 10
        tps          # 该设备每秒的传输次数
        # "一次传输"意思是"一次I/O请求"。多个逻辑请求可能会被合并为"一次I/O请求"。"一次传输"请求的大小是未知的。
        kB_read/s    # 每秒从设备(drive expressed)读取的数据量；
        kB_wrtn/s    # 每秒向设备(drive expressed)写入的数据量；
        kB_read      # 读取的总数据量；
        kB_wrtn      # 写入的总数量数据量；这些单位都为Kilobytes。
# iostat -d sda 2 -x
        rrqm/s       # 每秒进行 merge 的读操作数目。即 delta(rmerge)/s
        wrqm/s       # 每秒进行 merge 的写操作数目。即 delta(wmerge)/s
        r/s          # 每秒完成的读 I/O 设备次数。即 delta(rio)/s
        w/s          # 每秒完成的写 I/O 设备次数。即 delta(wio)/s
        rsec/s       # 每秒读扇区数。即 delta(rsect)/s
        wsec/s       # 每秒写扇区数。即 delta(wsect)/s
        rkB/s        # 每秒读K字节数。是 rsect/s 的一半，因为每扇区大小为512字节。(需要计算)
        wkB/s        # 每秒写K字节数。是 wsect/s 的一半。(需要计算)
        avgrq-sz     # 平均每次设备I/O操作的数据大小 (扇区)。delta(rsect+wsect)/delta(rio+wio)
        avgqu-sz     # 平均I/O队列长度。即 delta(aveq)/s/1000 (因为aveq的单位为毫秒)。
        await        # 平均每次设备I/O操作的等待时间 (毫秒)。即 delta(ruse+wuse)/delta(rio+wio)
        # 这里可以理解为IO的响应时间，一般地系统IO响应时间应该低于5ms，如果大于10ms就比较大了。
        # 这个时间包括了队列时间和服务时间，也就是说，一般情况下，await大于svctm，它们的差值越小，则说明队列时间越短，反之差值越大，队列时间越长，说明系统出了问题。
        svctm        # 平均每次设备I/O操作的服务时间 (毫秒)。即 delta(use)/delta(rio+wio)
        # 表示平均每次设备I/O操作的服务时间(以毫秒为单位)。如果svctm的值与await很接近，表示几乎没有I/O等待，磁盘性能很好，如果await的值远高于svctm的值，则表示I/O队列等待太长， 
        %util        # 一秒中有百分之多少的时间用于 I/O 操作，或者说一秒中有多少时间 I/O 队列是非空的。即 delta(use)/s/1000 (因为use的单位为毫秒)
        
        IO性能衡量标准{

            1、 如果 %util 接近 100%，说明产生的I/O请求太多，I/O系统已经满负荷，该磁盘可能存在瓶颈。
            2、 idle 小于70% IO压力就较大了,一般读取速度有较多的wait.
            3、 同时可以结合 vmstat 查看查看b参数(等待资源的进程数)和wa参数(IO等待所占用的CPU时间的百分比,高过30%时IO压力高)
            4、 svctm 一般要小于 await (因为同时等待的请求的等待时间被重复计算了),svctm 的大小一般和磁盘性能有关,CPU/内存的负荷也会对其有影响,请求过多也会间接导致 svctm 的增加. await 的大小一般取决于服务时间(svctm) 以及 I/O 队列的长度和 I/O 请求的发出模式. 如果 svctm 比较接近 await,说明 I/O 几乎没有等待时间;如果 await 远大于 svctm,说明 I/O 队列太长,应用得到的响应时间变慢,如果响应时间超过了用户可以容许的范围,这时可以考虑更换更快的磁盘,调整内核 elevator 算法,优化应用,或者升级 CPU
            5、 队列长度(avgqu-sz)也可作为衡量系统 I/O 负荷的指标，但由于 avgqu-sz 是按照单位时间的平均值，所以不能反映瞬间的 I/O 洪水。
        }
vmstat(查看虚拟内存){
        Procs
          r       # 运行队列中进程数量，这个值也可以判断是否需要增加CPU。(长期大于1)
          # r(运行队列)展示了正在执行和等待CPU资源的任务个数。当这个值超过了CPU数目，就会出现CPU瓶颈了。
          b       # 等待IO的进程数量
        Memory 
          swpd    # 使用虚拟内存大小
          free    #空闲的内存大小
          buff    #缓冲区的内存大小
          cache   #用于高速缓存的内存大小
          inact   #不活跃的内存大小(-a option)
          active  #活跃的内存大小(-a option)
        Swap
          si      #从磁盘交换到内存的数量(/s)
          so      #从内存交换到磁盘的的数量(/s)
        IO
          bi      #从一个块设备接收到的块数量(blocks/s)
          bo      #发送给一个块设备的块数量(blocks/s)
          # 注意：随机磁盘读写的时候，这2个值越大(如超出1024k)，能看到CPU在IO等待的值也会越大。
        System
          in      #每秒的中断数,包含时间中断
          cs      #每秒上下文切换的数
          # 注意：上面2个值越大，会看到由内核消耗的CPU时间会越大。
          CPU     #总CPU时间的百分比
          us      #运行非内核程序的时间(user time, including nice time)
          # 注意： us的值比较高时，说明用户进程消耗的CPU时间多，但是如果长期超50%的使用，那么我们就该考虑优化程序算法或者进行加速。
          sy      #运行内核程序的时间
          # 注意：sy的值高时，说明系统内核消耗的CPU资源多，这并不是良性表现，我们应该检查原因。
          id      #系统空闲时间(Prior to Linux 2.5.41, this includes IO-wait time)
          wa      #用在IO等待的时间
          # 注意：wa的值高时，说明IO等待比较严重，这可能由于磁盘大量作随机访问造成，也有可能磁盘出现瓶颈(块操作)。
          st      #从一虚拟机窃取的时间
 # 当us＋sy的值接近100的时候，表示CPU正在接近满负荷工作。但要注意的是，CPU 满负荷工作并不能说明什么，Linux总是试图要CPU尽可能的繁忙，
 # 使得任务的吞吐量最大化。唯一能够确定CPU瓶颈的还是r(运行队列)的值。   
        -a：显示活跃和非活跃内存
        -f：显示从系统启动至今的fork数量 。
        -m：显示slabinfo
        -n：只在开始时显示一次各字段名称。
        -s：显示内存相关统计信息及多种系统活动数量。
        delay：刷新时间间隔。如果不指定，只显示一条结果。
        count：刷新次数。如果不指定刷新次数，但指定了刷新时间间隔，这时刷新次数为无穷。
        -d：显示磁盘相关统计信息。
        -p：显示指定磁盘分区统计信息
        -S：使用指定单位显示。参数有 k 、K 、m 、M ，分别代表1000、1024、1000000、1048576字节(byte)。默认单位为K(1024 bytes)
        
/> vmstat 1 3    #这是vmstat最为常用的方式，其含义为每隔1秒输出一条，一共输出3条后程序退出。
procs  -----------memory----------   ---swap-- -----io---- --system-- -----cpu-----
 r  b   swpd      free      buff   cache   si   so     bi    bo     in   cs  us  sy id  wa st
 0  0        0 531760  67284 231212  108  0     0  260   111  148  1   5 86   8  0
 0  0        0 531752  67284 231212    0    0     0     0     33   57   0   1 99   0  0
 0  0        0 531752  67284 231212    0    0     0     0     40   73   0   0 100 0  0
/> vmstat 1       #其含义为每隔1秒输出一条，直到按CTRL+C后退出。
下面将给出输出表格中每一列的含义说明：
有关进程的信息有：(procs)
r:  在就绪状态等待的进程数。
b: 在等待状态等待的进程数。   
有关内存的信息有：(memory)
swpd:  正在使用的swap大小，单位为KB。
free:    空闲的内存空间。
buff:    已使用的buff大小，对块设备的读写进行缓冲。
cache: 已使用的cache大小，文件系统的cache。
有关页面交换空间的信息有：(swap)
si:  交换内存使用，由磁盘调入内存。
so: 交换内存使用，由内存调入磁盘。 
有关IO块设备的信息有：(io)
bi:  从块设备读入的数据总量(读磁盘) (KB/s)
bo: 写入到块设备的数据总理(写磁盘) (KB/s)  
有关故障的信息有：(system)
in: 在指定时间内的每秒中断次数。
sy: 在指定时间内每秒系统调用次数。
cs: 在指定时间内每秒上下文切换的次数。  
有关CPU的信息有：(cpu)
us:  在指定时间间隔内CPU在用户态的利用率。
sy:  在指定时间间隔内CPU在核心态的利用率。
id:  在指定时间间隔内CPU空闲时间比。
wa: 在指定时间间隔内CPU因为等待I/O而空闲的时间比。  
vmstat 可以用来确定一个系统的工作是受限于CPU还是受限于内存：如果CPU的sy和us值相加的百分比接近100%，或者运行队列(r)中等待的进程数总是不等于0，且经常大于4，同时id也经常小于40，则该系统受限于CPU；如果bi、bo的值总是不等于0，则该系统受限于内存。

        }
    }

    blktrace(Linux内核中块设备I/O层的跟踪工具，用来收集磁盘IO信息中当IO进行到块设备层(block层，所以叫blk trace)时的详细信息--如IO请求提交，入队，合并，完成等等一些列的信){
    blktrace是一个可以显示block的io详细信息的工具，但他的输出信息太专业了，很难看懂，可以同通过blkiomon、blkparse，btt等工具来查看
    blktrace工作原理：
    
blktrace架构图参照：
http://blog.yufeng.info/archives/2524
block层位置图参照：
http://blog.yufeng.info/archives/751
    
    
(1)blktrace测试的时候，会分配物理机上逻辑cpu个数个线程，并且每一个线程绑定一个逻辑cpu来收集数据
(2)blktrace在debugfs挂载的路径(默认是/sys/kernel/debug )下每个线程产生一个文件(就有了对应的文件描述符)，然后调用ioctl函数(携带文件描述符， _IOWR(0x12,115,struct blk_user_trace_setup)，& blk_user_trace_setup三个参数)，产生系统调用将这些东西给内核去调用相应函数来处理，由内核经由debugfs文件系统往此文件描述符写入数据
(3)blktrace需要结合blkparse来使用，由blkparse来解析blktrace产生的特定格式的二进制数据
(4)blkparse仅打开blktrace产生的文件，从文件里面取数据做展示以及最后做per cpu的统计输出，但blkparse中展示的数据状态(如 A，U，Q，详细见下)是blkparse在t->action & 0xffff之后自己把数值转换为'A，Q，U之类的状态'来展示的。
    
blktrace安装：
sudo apt-get install blktrace
Debugfs挂载：
由blktrace工作原理可知，blktrace需要借助内核经由debugfs文件系统(debugfs文件系统在内存中)来输出信息，所以用blktrace工具之前需要先挂载debugfs文件系统
 sudo mount -t debugfs debugfs /sys/kernel/debug
 
 blktrace语法：

 blktrace -d dev [ -r debugfs_path ] [ -o output ] [-k ] [ -w time ] [ -a action ] [ -A action_mask ] [ -v ]
 blktrace选项：
 -A hex-mask			#设置过滤信息mask成十六进制mask
 -a mask			    #添加mask到当前的过滤器
 -b size			    #指定缓存大小for提取的结果，默认为512KB
 -d dev			        #添加一个设备追踪
 -I file			    #Adds the devices found in file as devices to trace
 -k			            #杀掉正在运行的追踪
 -n num-sub			    #指定缓冲池大小，默认为4个子缓冲区 
 -o file			    #指定输出文件的名字
 -r rel-path			#指定的debugfs挂载点
 -V			            #版本号 
 -w seconds			    #设置运行的时间
    
输出方式：
  1. 文件输出：
  blktrace -d /dev/sda -o test1
  #对/dev/sda的trace，输出文件名为test1. Blktrace.[0-cpu数-1](文件里面存的是二进制数据，需要blkparse来解析)(如之前在blktrace原理中提到，每个逻辑cpu都有一个线程，产生一个文件，故会产生cpu数目个文件)
  2.  终端输出：
  blktrace -d /dev/sda -o - | blkparse  -i -
  #输出到终端用'-'表示，可是都是一堆二进制东西，没法看，所以需要实时blkparse来解析
  #Blkparse 的'-i'后加文件名，blktrace输出为'-'代表终端(代码里面写死了，就是用这个符号来代表终端)，blkparse也用'-'来代表终端解析
几个例子： 
    blktrace -d /dev/sda -o - |blkparse -i - 
    # 此命令是将blktrace的结果输出到屏幕，然后blkparse将屏幕中的blktrace的结果作为分析的输入，最后将分析的结果同样输出到屏幕。这里需要指出的是，blkparse是基于blktrace的分析工具，因为blktrace本身并不具有分析功能，它只是进行监测，其余的工作都是由blkparse来进行的
    
    blktrace -d /dev/sda |blkparse -i - 
    # 此命令是将blktrace的结果输出到本地文件夹，文件名为sda.blktrace.0和sda.blktrace.1，这里之所以有两个文件是因为运行机器有两个CPU的缘故，blktrace根据CPU的个数来生成文件，对应每个CPU都有一个相应的监测数据文件

    lktrace -d /dev/sda -o trace |blkparse -i - 
    # 此命令是将blktrace的结果输出到已经事先指定好的文件trace中，注意这个trace文件必须在本地文件夹中存在，无需带有任何后缀。运行之后会产生两个新的文件叫做trace.blktrace.0和trace.blktrace.1。
    
    blkparse -i trace
    # 此命令是将trace文件作为blkparse的输入，blkparse的结果依然输出到屏幕

    blkparse -i trace -o /root/trace.txt
    # 此命令是将trace文件作为blkparse的输入，同时将分析结果输出到/root/trace.txt这个文件，以便人工进行更加深入的分析，因为trace文件是人眼不可读的，所以如果要进行更多后续的人工或程序处理最好还是将结果转化为文本文档来处理。
    }
    
    iotop(用来监视磁盘I/O使用状况的 top 类工具，可监测到哪一个程序使用的磁盘IO的信息){
    --version			#显示版本号
 -h, --help			#显示帮助信息
 -o, --only			#显示进程或者线程实际上正在做的I/O，而不是全部的，可以随时切换按o
 -b, --batch			#运行在非交互式的模式
 -n NUM, --iter=NUM		#在非交互式模式下，设置显示的次数，
 -d SEC, --delay=SEC		#设置显示的间隔秒数，支持非整数值
 -p PID, --pid=PID		#只显示指定PID的信息
 -u USER, --user=USER		#显示指定的用户的进程的信息
 -P, --processes		#只显示进程，一般为显示所有的线程
 -a, --accumulated		#显示从iotop启动后每个线程完成了的IO总数
 -k, --kilobytes		#以千字节显示
 -t, --time			#在每一行前添加一个当前的时间
 -q, --quiet			#suppress some lines of header (implies --batch). This option can be specified up to three times to remove header lines.
   -q     column names are only printed on the first iteration,
   -qq    column names are never printed,
   -qqq   the I/O summary is never printed.
    
    }
    
    slabtop(实时的显示内核slab缓存信息，透过/proc/slabinfo){
 --delay=n, -d n		#每n秒更新一次显示的信息，默认是每3秒
 --sort=S, -s S			#指定排序标准进行排序(排序标准，参照下面或者man手册)
 --once, -o			#显示一次后退出
 --version, -V			#显示版本
 --help				#显示帮助信息

排序标准：
 a:     sort by number of active objects
 b:     sort by objects per slab
 c:     sort by cache size
 l:     sort by number of slabs
 v：    sort by number of active slabs
 n:     sort by name
 o:     sort by number of objects
 p:     sort by pages per slab
 s:     sort by object size
 u:     sort by cache utilization

输出界面可用的命令：
 <SPACEBAR>：	        刷新显示内容
 Q：			退出
    }
    
vm.swappiness决定了系统在物理内存使用达到什么值(百分比)时开始使用swap.系统默认此参数的值为60. 对应的系统文件是 /proc/sys/vm/swappiness.
echo 10 > /proc/sys/vm/swappiness    # 临时调整
sysctl vm.swappiness=10              # 临时调整
cat /etc/sysctl.conf|grep swappiness # 开机启动即调整

    swap(创建swap文件方法){
        fallocate -l 10g /mnt/10GB.swap #等同于dd命令
        dd if=/dev/zero of=/swap bs=1024 count=4096000            # 创建一个足够大的文件
        # count的值等于1024 x 你想要的文件大小, 4096000是4G
        mkswap /swap                      # 把这个文件变成swap文件
        swapon /swap                      # 启用这个swap文件
        /swap swap swap defaults 0 0      # 在每次开机的时候自动加载swap文件, 需要在 /etc/fstab 文件中增加一行
        cat /proc/swaps                   # 查看swap
        swapoff -a                        # 关闭swap
        swapon -a                         # 开启swap
        
# 交换分区最大容量为 64G ，最多只能建 32个, 
  1. 创建交换分区 
  #fdisk /dev/ hdan+容量pt( 修改系统 ID)分区号82pw 
  #mkswap /dev/hda2  （以上划分的分区号）  构建swap格式 
  #swapon  /dev/hda2  加载即完成增加 swap 
  #swapon  - s        显示目前使用的 Swap设备 
  2. 创建交换文件 
  # dd if=/dev/hda1 of=/aixi/swap bs=1M count=64  创建大文件 
  #mkswap /aixi/swap  
  #swapon /aixi/swap   完成 
  3. 取消交换分区或者交换文件 
  #swapon  - s        显示目前使用的 Swap设备 
  #swapoff /aixi/swap  
  #swapoff /dev/hda2 
  #free - m 查看
    }

    mount(fdisk mkfs mount){
  
  fdisk 不支持大于 2T 的磁盘 
  fdisk /dev/sdc # (mbr)
  l    # 列出分区类型
  t    # 修改分区类型
  p    #  打印分区
  d    #  删除分区
  n    #  创建分区，(一块硬盘最多4个主分区，扩展占一个主分区位置。p主分区 e扩展)p/e/l # 选择分区类型
  w    #  保存退出
     # 分区结束时按w保存分区表有时候会失败，提示重启，这时候运行partprobe命令可以代替重启就生效。   
  partprobe /dev/sdb &>/dev/null # 重读分区表
  fdisk -l | grep "^/dev/sdb"  &>/dev/null # 检查分区状态
        mkfs -t ext3 -L 卷标  /dev/sdc1        # 格式化相应分区
        mount /dev/sdc1  /mnt                  # 挂载
        vi /etc/fstab                          # 添加开机挂载分区
        LABEL=/data            /data                   ext3    defaults        1 2      # 用卷标挂载
        /dev/sdb1              /data4                  ext3    defaults        1 2      # 用真实分区挂载
        /dev/sdb2              /data4                  ext3    noatime,defaults        1 2

        第一个数字"1"该选项被"dump"命令使用来检查一个文件系统应该以多快频率进行转储，若不需要转储就设置该字段为0
        第二个数字"2"该字段被fsck命令用来决定在启动时需要被扫描的文件系统的顺序，根文件系统"/"对应该字段的值应该为1，其他文件系统应该为2。若该文件系统无需在启动时扫描则设置该字段为0
        当以 noatime 选项加载(mount)文件系统时，对文件的读取不会更新文件属性中的atime信息。设置noatime的重要性是消除了文件系统对文件的写操作，文件只是简单地被系统读取。由于写操作相对读来说要更消耗系统资源，所以这样设置可以明显提高服务器的性能.wtime信息仍然有效，任何时候文件被写，该信息仍被更新。

        把 tmp目录挂载到内存
            #修改run/shm的最大容量
            tmpfs /run/shm tmpfs defaults,size=5120M 0 0
            #把/tmp目录挂载到内存
            tmpfs /tmp tmpfs defaults,size=2048M,noatime 0 0
            把chrome的cache目录放到内存：
            google-chrome --disk-cache-dir="/run/shm/chrome-cache"
    }
    gdisk(gpt){
    yum -y install gdisk
    gdisk /dev/sdb
       ?     # 
       d     # 删除分区
       i     # 列出分区详细信息
       l     # 列出所以已知的分区类型
       n     # 添加新分区
       o     # 创建一个新的空的guid分区表
       p     # 输出分区表信息
       q     # 退出gdisk工具
       t     # 修改分区类型 v       verify disk
       w     # 将分区信息写入到磁盘


    partprobe  /dev/sdb # 执行partprobe重新读取分区表信息。
    x
    s    # 修改分区表大小，注意不是分区大小
    u    # 将分区表导出
    z    # 损毁gpt上的数据
    }

    parted(大磁盘2T和16T分区 mbr gpt){
# 常用的命令是mklabel/rm/print/mkpart/help/quit，
# 至于parted中一些看上去很好的功能如mkfs/mkpartfs/resize等可能会损毁当前数据而不够安全，所以只要使用它的5个常用命令即可。
# mklabel创建标签或分区表，最常见的标签(分区表)为"msdos"和"gpt"，其中msdos分区就是MBR格式的分区表，也就是会有主分区、扩展分区和逻辑分区
        parted /dev/sdb                # 针对磁盘分区
        (parted) mklabel gpt           # 设置为 gpt
        (parted) print
        (parted) mkpart  primary 0KB 22.0TB        # 指定分区大小
        Is this still acceptable to you?
        Yes/No? Yes
        Ignore/Cancel? Ignore
        (parted) print
        Model: LSI MR9271-8i (scsi)
        Disk /dev/sdb: 22.0TB
        Sector size (logical/physical): 512B/512B
        Partition Table: gpt
        Number  Start   End     Size    File system  Name     Flags
         1      17.4kB  22.0TB  22.0TB               primary
        (parted) quit

        mkfs.ext4 /dev/sdb1        # e2fsprogs升级后支持大于16T硬盘

        # 大于16T的单个分区ext4格式化报错，需要升级e2fsprogs
        Size of device /dev/sdb1 too big to be expressed in 32 bits using a blocksize of 4096.

        yum -y install xfsprogs
        mkfs.xfs -f /dev/sdb1              # 大于16T单个分区也可以使用XFS分区,但inode占用很大,对大量的小文件支持不太好

    # subcommand
    检查 MINOR                           #对文件系统进行一个简单的检查 
    cp [FROM-DEVICE] FROM-MINOR TO-MINOR #将文件系统复制到另一个分区 
    help [COMMAND]                       #打印通用求助信息，或关于 COMMAND 的信息 
    mklabel 标签类型                      #创建新的磁盘标签 (分区表) 
    mkfs MINOR 文件系统类型               #在 MINOR 创建类型为'文件系统类型'的文件系统 
    mkpart 分区类型 [文件系统类型] 起始点 终止点    #创建一个分区 
    mkpartfs 分区类型 文件系统类型 起始点 终止点    #创建一个带有文件系统的分区 
    move MINOR 起始点 终止点              #移动编号为 MINOR 的分区 
    name MINOR 名称                      #将编号为 MINOR 的分区命名为'名称' 
    print [MINOR]                        #打印分区表，或者分区 
    quit                                 #退出程序 
    rescue 起始点 终止点                  #挽救临近'起始点'、'终止点'的遗失的分区 
    resize MINOR 起始点 终止点            #改变位于编号为 MINOR 的分区中文件系统的大小 
    rm MINOR                             #删除编号为 MINOR 的分区 
    select 设备                          #选择要编辑的设备 
    set MINOR 标志 状态                   #改变编号为 MINOR 的分区的标志
    
    # process
    fdisk -l 查看磁盘信息
    parted /dev/sdb  使用parted工具操作磁盘/dev/sdb
    mktable gpt  或者 mklabel gpt 把磁盘/dev/sdb 格式化为 gpt分区表
    mkpart primary  0MB 100MB  创建一个50M大小的主分区
    mkpart extended 100MB 200MB 创建一个50M大小的扩展分区
    rm 1 删除number为1 的分区
    print 显示磁盘 /dev/sdb的相关信息
    help  显示帮助命令
    退出parted命令，在linux命令行窗口对分区进行格式化
    mkfs.ext4 /dev/sdb2 格式化磁盘/dev/sdb的第二个分区为ext4格式的分区
    磁盘自动挂载
    vim /etc/fstable
    /dev/sdb2 /opt/test ext4  defaults   1 2
    }
    parted(){
    
    fdisk 不支持大于 2T 的磁盘 ; parted：2T 以上磁盘分区工具
    parted /dev/mapper/VolGroup-lv_home print
    
  parted命令只能一次非交互一个命令中的所有动作。如下所示：
  parted /dev/sdb mklabel msdos                 # 设置硬盘flag
  parted /dev/sdb mkpart primary ext4 1 1000    # mbr格式分区，分别是partition type/fstype/start/end
  parted /dev/sdb mkpart 1 ext4 1M 10240M       # gpt格式分区，分别是name/fstype/start/end
  parted /dev/sdb mkpart 1 10G 15G              # 省略fstype的交互式分区
  parted /dev/sdb rm 1                          # 删除分区
  parted /dev/sdb p                             # 输出信息
  parted /dev/hda mkpart primary ext3 120MB 200MB   # 创建分区，
         primary代表主分区，还可以是extended 扩展分区，logical 逻辑分区;
         ext3 代表分区类型，
         120MB 是开始位置，最好是接上一分区的结束位置，
         200M 是结束位置

  partprobe  #  更新分区表/磁盘 
  用于重读分区表，当出现删除文件后,出现仍然占用空间。可以 partprobe在不重启的情况下重读分区 
  partprobe  
  这个命令执行完毕之后不会输出任何返回信息，你可以使用 mke2fs 命令在新的分区上创建文件系统
  
  
  如果不确定分区的起点大小，可以加上-s选项使用script模式，该模式下parted将回答一切默认值，如yes、no。
  
  shell> parted -s /dev/sdb mkpart 3 14G 16G
  Warning: You requested a partition from 14.0GB to 16.0GB.                
  The closest location we can manage is 15.0GB to 16.0GB.
  Is this still acceptable to you?
  Information: You may need to update /etc/fstab.
    }
mkfs(mke2fs){
mkfs.ext2/mkfs.ext3/mkfs.ext4或mkfs -t extX其实都是在调用mke2fs工具。
该工具创建文件系统时，会从/etc/mke2fs.conf配置中读取默认的配置项。
mke2fs -t ext4 -I 256 /dev/sdb2 -b 4096

mke2fs [ -c ] [ -b block-size ] [ -f fragment-size ] [ -g blocks-per-group ] [ -G number-of-groups ] 
       [ -i bytes-per-inode ] [ -I inode-size ] [ -j ] [ -N number-of-inodes ] [ -m reserved-blocks-percentage ] 
       [ -q ] [ -r fs-revision-level ] [ -v ] [ -L volume-label ] [ -S ] [ -t fs-type ] device [ blocks-count ]

选项说明：
-t fs-type         ：指定要创建的文件系统类型(ext2,ext3 ext4)，若不指定，则从/etc/mke2fs.conf中获取默认的文件系统类型。
-b block-size      ：指定每个block的大小，有效值有1024、2048和4096，单位是字节。
-I inode-size      ：指定inode大小，单位为字节。必须为2的幂次方，且大于等于128字节。值越大，说明inode的集合体inode table占用越多的空
                     间，这不仅会挤占文件系统中的可用空间，还会降低性能，因为要扫描inode table需要消耗更多时间，但是在linux kernel 2.6.10
                     之后，由于使用inode存储了很多扩展的额外属性，所以128字节已经不够用了，因此ext4默认的inode size已经变为256，尽管
                     inode大小增大了，但因为使用inode存储扩展属性带来的性能提升远高于inode size变大导致的负面影响，所以仍建议使用256字
                     节的inode。
-i bytes-per-inode ：指定每多少个字节就为其分配一个inode号。值越大，说明一个文件系统中分配的inode号越少，更适用于存储大量大文件，值越
                     小，inode号越多，更适用于存储大量小文件。该值不能小于一个block的大小，因为这样会造成inode多余。
                     注意，创建文件系统后该值就不能再改变了。
-c                 ：创建文件系统前先检查设备是否有bad blocks。
-f fragment-size   ：指定fragments的大小，单位字节。
-g blocks-per-group：指定每个块组中的block数量。不建议修改此项。
-G number-of-groups：该选项用于ext4文件系统(严格地说是启用了flex_bg特性)，指定虚拟块组(即一个extent)中包含的块组个数，必须为2的幂次方。
                     对于ext4文件系统来说，使用extent的功能能极大提升其性能。
-j                 ：创建带有日志功能的文件系统，即ext3。如果要指定关于日志方面的设置，在-j的基础上再使用-J指定，不过一般默认即可，具体可
                     指定的选项看man文档。 
-L new-volume-label：指定卷标名称，名称不得超出16字节。
-m reserved-blocks-percentage：指定文件系统保留block数量的比例，保留一部分block，可以降低物理碎片。默认比例为5%。
-N number-of-inodes ：强制指定该文件系统应该分配多少个inode号，它会覆盖通过计算得出inode数量的结果(根据block大小、数量和每多少字节分配
                      一个inode得出Inode数量)，但是不建议这么做。
-q                  ：安静模式，可用于脚本中
-S                  ：重建superblock和group descriptions。在所有的superblock和备份的superblock都损坏时有用。它会重新初始化superblock和
                      group descriptions，但不会改变inode table、bmap和imap(若真的改变，该分区数据就全丢了，还不如重新格式化)。在重建
                      superblock后，应该执行e2fsck来保证文件系统的一致性。但要注意，应该完全正确地指定block的大小，其改选项并不能完全保
                      证数据不丢失。
-v                  ：输出详细执行过程 

所以，有可能用到的选项也就"-t"指定文件系统类型，"-b"指定block大小，"-I"指定inode大小，"-i"指定分配inode的比例。
}
tune2fs(修改ext文件系统属性){
  文件系统创建好后很多属性是固定不能修改的，能修改的属性很有限，且都是无关紧要的。
  但有些时候还是可以用到它做些事情，例如刚创建完ext文件系统后会提示修改自检时间。
  tune2fs [  -c  max-mount-counts ] [ -i interval-between-checks ] [ -j ] device
  -j：将ext2文件系统升级为ext3；
  -c：修改文件系统最多挂载多少次后进行自检，设置为0或-1将永不自检；
  -i：修改过了多少时间进行自检。时间单位可以指定为天(默认)/月/星期[d|m|w]，设置为0将永不自检。
  tune2fs -i 0 /dev/sdb1
}
dumpe2fs(){
用于查看ext类文件系统的superblock及块组信息。使用-h选项将只显示superblock信息。
dumpe2fs -h /dev/sda2  # /dev/sda2 显示磁盘inode table,block group等信息
}
extundelete(文件恢复){
安装：./configure && make clean && make && make install
恢复：
    extundelete /dev/<device> --inode < / 的 inode>
    extundelete /dev/<device> --restore-file <file-name>
    extundelete /dev/<device> --restore-inode <inode-num>
    extundelete /dev/<device> --restore-directory <directory-name>
    extundelete /dev/<device> --restore-all
    ls RECOVERED_FILES/
}
storage_e2label_man(){
设置磁盘卷标
  e2label 设备名称  新label 名称，可以用 dumpe2fs查看卷标 
  [root@centos57 ~]# e2label /dev/hda1 aixi 
  e2label /dev/sda5                     # 查看卷标
  e2label /dev/sda5 new-label           # 创建卷标
  ntfslabel -v /dev/sda8 new-label      # NTFS添加卷标
}

    raid(raid原理与区别){
        raid0至少2块硬盘.吞吐量大,性能好,同时读写,但损坏一个就完蛋
        raid1至少2块硬盘.相当镜像,一个存储,一个备份.安全性比较高.但是性能比0弱
        raid5至少3块硬盘.分别存储校验信息和数据，坏了一个根据校验信息能恢复
        raid6至少4块硬盘.两个独立的奇偶系统,可坏两块磁盘,写性能非常差
    }
    
PV(Physical Volume)即物理卷 # pvcreate system ID为8e
VG(Volume Group)即卷组      # 
PE(Physical Extend)PE是VG中的存储单元
LV(Logical Volume)VG相当于整合过的硬盘，那么LV就相当于分区，只不过该分区是通过VG来划分的。
LE(logical extent)PE是物理存储单元，而LE则是漏记存储单元，也即为lv中的逻辑存储单元，

线性模式(linear)：先写完来自于同一个PV的PE，再写来自于下一个PV的PE。
条带模式(striped)：一份数据拆分成多份，分别写入该LV对应的每个PV中，所以读写性能较好，类似于RAID 0。
    lvm(){
    http://www.cnblogs.com/f-ck-need-u/p/7049233.html
    1) PV阶段
        pvcreate : 将物理分区(System Id 要改为8e)新建成PV
        pvscan: 扫描并列出所有的pv
        pvdisplay: 显示目前系统的PV状态
        pvremove: 将PV属性删除,物理无法不具有PV属性
        pvmove:移动pv中的数据
        以下命令将sda6,7,8,9构建成pv
    pvcreate /dev/sda{6,7,8,9}  #pv名同设备名
    
    2) VG阶段
        vgcreate:新建vg,基本格式是 vgcreate -s PE大小 VG名 PV名
        vgscan:扫描并列出所有的vg
        vgdisplay:显示目前系统的vg状态
        vgextend:vg内增加额外的pv 格式是vgextend VG名 PV名
        vgreduce:vg内删除pv,格式类似vgextend
        vgchange:激活/失活vg,在删除pv时都要失活vg,格式vgchange -a n vg名
        vgremove:删除vg
        以下命令是将sda6,7,8构成一个vg,再添加sda9
    vgcreate -s 4M vg1 /dev/sda{6,7,8}  #构成出的vg1设备名是/dev/vg1
    vgextend vg1 /dev/sda9
    
    3) LV阶段
        lvcreate:新建LV,可以直接指定大小(-L)或者通过PE个数来指定大小(-l) 基本格式是lvcreate -l num -n lv名 vg名
        lvdisplay:显示目前系统的lv状态
        lvresize:对LV进行容量大小调整(+|-)
        lvremove:删除一个LV
        以下命令是在vg1下构建一个由365个PE构成的lv
    lvcreate -l 365 -n lv1 /dev/vg1 # 构建成的lv 设备名是/dev/vg1/lv1
    最后就可以直接格式话化lv,并进行挂载

1)放大LV容量
    其过程可以在线完成(即vg活动时),一般步骤如下:
        构建pv (pvcreate)
        将pv加入vg (vgextend)
        放大lv容量 (lvresize)
        修改文件系统容量(修改超级块信息,resize2fs):resize2fs格式是resize2fs 设备 [size]
        以下将sda10加入到vg,以扩展lv
    
    pvcreate /dev/sda10 # 创建pv
    vgextend vg1 /dev/sda10  # 向vg添加pv
    lvresize -l +179 /dev/vg1/lv1  # 放大lv容量
    resize2fs /dev/vg1/lv1    # 修改文件系统容量

2)缩小LV容量
    缩小lv容量不能在vg活动时进入,具体过程就是放大lv容量的逆过程(注意:一定要先resize2fs,不然可能文件系统损坏)
    以下将/dev/sda10移出vg1
    e2fsck -f /dev/vg1/lv1  # 系统要求在resize2fs时先进行磁盘检查
    resize2fs /dev/vg1/lv1 6900M # 修改文件系统size,以减去/dev/sda10的大小
    vgchange -a n vg1  (-a y 是激活) # 失活vg1
    lvresize -l -179 /dev/vg1/lv1 # lv缩小容量
    vgreduce vg1 /dev/sda10 # vg1移出/dev/sda10
    pvremove /dev/sda10 # /dev/sda10删除pv属性
    vgchange -a y vg1 # 激活vg1
    
LVM的关闭步骤如下:
    使用lvremove删除所有lv
    使vg失活 vgchange -a n vgname
    使用vgremove删除vg
    使用pvremoe删除pv
    fdisk 回收 分区
    }
}
lvm(过程){
磁盘->PV->VG->LV->格式化，挂载
过程：
    添加硬盘，分区
    创建PV：pvcreate <device>/pvcreate /dev/sda[1-2]
    创建VG：vgcreate <group_name> <device>/vgcreate group_name /dev/sda[1-2]
        指定PE大小：vgcreate -s 16M
        扩展：vgextend <group_name> </dev/sda3>
        缩减：vgreduce <group_name> </dev/sda2>
    创建LV：lvcreate -n <name> -L <1.5G> <group_name>
        扩展：lvextend -L <+200M> /dev/<group_name>/<name>
            更新：xfs_growfs /dev/<group_name>/<name>
        缩减：lvreduce -L <1G> /dev/<group_name>/<name>
            更新：xfs_growfs /dev/<group_name>/<name>
    格式化，挂载：mkfs -t xfs /dev/<group_name>/<name> mount /dev/<group_name>/<name> <mount_point>

删除：lvremove->vgremove->pvremove
快照：

    信息：
        冷备份：卸载文件系统，不能读写
        温备份：不卸载文件系统，不能写
        热备份：不卸载文件系统，能读写
    创建：lvcreate -s -n <lvname> -L <300M> <volume_name>
}

# pv，pycp，progress，rsync --progress

rsync -vrR --progress \
          -u \
          -l -p -t -g -o -D \
          -z \
          -b --backup-dir=$BKDIR --suffix=$SFX \
          --delete --delete-after --force --ignore-errors \
          -C --exclude-from=$ExcludeFile \
          --password-file=$PassFile \
          $SRC $DES

# r    l      p        t        g    o    D
# 递归 软链接 文件权限 文件时间 属组 属主 设备文件信息

#--include-from=FILE    不排除FILE指定模式匹配的文件
#--log-format=FORMAT    指定日志文件格式

rsync rdiff-backup duplicity

# [android]
rsync -zaH android_release /data/android_release # ubuntu:666666 192.168.10.80  cd /home/android4.4/android4.4

# [svn]
# crontab -e
21 23 * * 2 /usr/bin/rsync -avz  192.168.10.107::svndata /home/svndata/  &

# [iaas]
rsync -azv --stats root@192.168.10.107:/home/svndata1  ./            # /home/svndata
rsync -a 192.168.10.201:/var/lib/mysql ./                            # /home/201iaas
rsync -a --stats --progress  rsync_backup@192.168.10.118::user ./    # /home/118iaas


-n 参数: 如果不确定 rsync 执行后会产生什么结果，可以先用-n或--dry-run参数模拟执行的结果。
--delete 参数 : 默认情况下，rsync 只确保源目录的所有内容（明确排除的文件除外）都复制到目标目录。
它不会使两个目录保持相同，并且不会删除文件。如果要使得目标目录成为源目录的镜像副本，则必须使用--delete参数，
这将删除只存在于目标目录、不存在于源目录的文件。

# rsync 的最大特点是会检查发送方和接收方已有的文件，仅传输有变动的部分(默认规则是文件大小或修改时间有变动)。
rsync(同步远程数据){ http://www.ruanyifeng.com/blog/2020/08/rsync.html
rsync [OPTION]... SRC [SRC]... DEST                                    本地模式
		rsync [OPTION]... SRC [SRC]... [USER@]HOST:DEST                远程Shell模式
		rsync [OPTION]... SRC [SRC]... [USER@]HOST::DEST               rsync守护模式
		rsync [OPTION]... SRC [SRC]... rsync://[USER@]HOST[:PORT]/DEST 列表模式
		rsync [OPTION]... [USER@]HOST:SRC [DEST]                       远程Shell模式
		rsync [OPTION]... [USER@]HOST::SRC [DEST]                      rsync守护模式
		rsync [OPTION]... rsync://[USER@]HOST[:PORT]/SRC [DEST]        列表模式
守护模式需配置/etc/xinetd.d/rsync和/etc/rsyncd.conf等等
rsync [-avz] [--progress] [--delete] [-e ssh] [-rl] 常用参数,以下带*表示常用
      -v, --verbose                                 *详细模式输出
      -q, --quiet                                   精简输出模式
      -c, --checksum                                打开校验开关，强制对文件传输进行校验
      -a, --archiv                                  *归档模式，表示以递归方式传输文件，并保持所有文件属性，等于-rlptgoD
      -r, --recursive                               *对子目录以递归模式处理
      -R, --relative                                使用相对路径信息
      -b, --backup                                  创建备份，也就是对于目的已经存在有同样的文件名时，将老的文件重新命名为~filename。可以使用--suffix选项来指定不同的备份文件前缀。
      --backup-dir                                  将备份文件(如~filename)存放在在目录下。
      -suffix=SUFFIX                                定义备份文件前缀
      -u, --update                                  *仅仅进行更新，也就是跳过所有已经存在于DST，并且文件时间晚于要备份的文件。(不覆盖更新的文件)
      -l, --links                                   *保留软链结
      -L, --copy-links                              *想对待常规文件一样处理软链结
      --copy-unsafe-links                           仅仅拷贝指向SRC路径目录树以外的链结
      --safe-links                                  忽略指向SRC路径目录树以外的链结
      -H, --hard-links                              保留硬链结
      -p, --perms                                   *保持文件权限
      -o, --owner                                   保持文件属主信息
      -g, --group                                   保持文件属组信息
      -D, --devices                                 保持设备文件信息
      -t, --times                                   *保持文件时间信息
      -S, --sparse                                  对稀疏文件进行特殊处理以节省DST的空间
      -n, --dry-run                                 现实哪些文件将被传输
      -W, --whole-file                              拷贝文件，不进行增量检测
      -x, --one-file-system                         不要跨越文件系统边界
      -B, --block-size=SIZE                         检验算法使用的块尺寸，默认是700字节
      -e, --rsh=COMMAND                             *指定使用rsh、ssh方式进行数据同步
      --rsync-path=PATH                             指定远程服务器上的rsync命令所在路径信息
      -C, --cvs-exclude                             使用和CVS一样的方法自动忽略文件，用来排除那些不希望传输的文件
      --existing                                    仅仅更新那些已经存在于DST的文件，而不备份那些新创建的文件
      --delete                                      *删除那些DST中SRC没有的文件
      --delete-excluded                             同样删除接收端那些被该选项指定排除的文件
      --delete-after                                传输结束以后再删除
      --ignore-errors                               及时出现IO错误也进行删除
      --max-delete=NUM                              最多删除NUM个文件
      --partial                                     *保留那些因故没有完全传输的文件，以是加快随后的再次传输
      --force                                       强制删除目录，即使不为空
      --numeric-ids                                 不将数字的用户和组ID匹配为用户名和组名
      --timeout=TIME IP                             超时时间，单位为秒
      -I, --ignore-times                            不跳过那些有同样的时间和长度的文件
      --size-only                                   当决定是否要备份文件时，仅仅察看文件大小而不考虑文件时间
      --modify-window=NUM                           决定文件是否时间相同时使用的时间戳窗口，默认为0
      -T --temp-dir=DIR                             在DIR中创建临时文件
      --compare-dest=DIR                            同样比较DIR中的文件来决定是否需要备份
      -P                                            等同于--partial
      --progress                                    *显示备份过程
      -z, --compress                                *对备份的文件在传输时进行压缩处理
      --exclude=PATTERN                             指定排除不需要传输的文件模式
      --include=PATTERN                             指定不排除而需要传输的文件模式
      --exclude-from=FILE                           排除FILE中指定模式的文件
      --include-from=FILE                           不排除FILE指定模式匹配的文件
      --version                                     打印版本信息
      --address                                     绑定到特定的地址
      --config=FILE                                 指定其他的配置文件，不使用默认的rsyncd.conf文件
      --port=PORT                                   指定其他的rsync服务端口
      --blocking-io                                 对远程shell使用阻塞IO
      -stats                                        给出某些文件的传输状态
      --progress                                    *在传输时现实传输过程
      --log-format=formAT                           指定日志文件格式
      --password-file=FILE                          从FILE中得到密码
      --bwlimit=KBPS                                限制I/O带宽，KBytes per second
      -h, --help                                    显示帮助信息
}
dump(restore){
dump命令用于备份ext2或者ext3文件系统。可将目录或整个文件系统备份至指定的设备，或备份成一个大文件。
dump -0 -u -f /temp/homebackup /home
dump -<0~9>         指定备份层级
     -f <备份设备>  指定备份设备
     -b <blocksize> 指定数据块大小(KB)
     -B  <blocknum> 指定数据快数目
     -T <日期>      指定备份的时间和日期
     -u             备份完毕后记录备份的文件系统,层级,日期与时间到/etc/dumpdates中
     -h <层级>      当备份层级大于等于指定的层级,将不备份标示为nodump的文件

     -c             修改备份磁带预设的密度与容量
     -d <密度>      设置磁带的密度(BPI)
     -s <磁带长度>  备份磁带的长度(英尺)

     -n             当备份需要管理员介入时向所有operateor群组的使用者发出通知
     -w             仅显示需要备份的文件
     -W             显示需要备份的文件及其最后一次备份的层级,时间,日期
参数
  备份源：指定要备份的文件、目录或者文件系统。

还原dump命令生成的备份文件
用例：restore -rf /dev/hda3 /home/glenn 或 restore -ft /dev/hda3

restore -f <备份设备> 从指定设备文件读取备份数据进行还原操作
        -r            进行还原操作
        -x            提取单独的文件而不是整个文件系统
        -i            交互模式,将依序询问用户
        -t <filename> 从备份文件查找文件
        -v            显示执行过程
}
system(user){
# useradd会参考/etc/default/useradd与/etc/login.defs文件来新建用户,
# 其会去修改上述的/etc/passwd 用户信息；/etc/shadow 用户密码信息,/etc/group用户组信息,/etc/gshadow用户组密码信息
    useradd -s /sbin/nologin ak47 #创建用户并禁止远程登录
    useradd -g www -M  -s /sbin/nologin  www   # 指定组并不允许登录的用户,nologin允许使用服务
    useradd -g www -M  -s /bin/false  www      # 指定组并不允许登录的用户,false最为严格
    useradd -d /data/song -g song song         # 创建用户并指定家目录和组
    useradd -c "Colin Barschel" -g admin -m colin
# m 强制创建用户主目录
# M 强制不创建用户主目录
# r 创建系统账号
# G 次要用户组,如果要添加用户组,也可以在这里指定 - aG
# s 指定shell
# d 指定用户主目录
    usermod -l 新用户名 老用户名               # 修改用户名
    usermod -g user group                      # 修改用户所属组
    usermod -d 目录 -m 用户                    # 修改用户家目录
    usermod -G group user                      # 将用户添加到附加组
    usermod -d /home/hdfs -U hdfs #修改linux用户目录
    /etc/default/useradd          # 家目录默认设置
# l 修改用户名,后接新的用户名
# L 冻结用户密码,使其无法登录(其实就是在/etc/shadow中的密码字段最前面加了!!)
# U 解冻用户
userdel -r              # 删除帐号及家目录
# userdel -r 会删除用户相关数据,删除了/etc/passwd,/etc/shadow,/etc/group,/etc/gshadow相关数据
# 与/home/username,/var/spool/mail/username
    users                   # 显示所有的登录用户
    groups                  # 列出当前用户和他所属的组
    who -q                  # 显示所有的登录用户
    groupadd                # 添加组
    useradd user            # 建立用户
    passwd 用户             # 修改密码
    passwd -l hadoop        # 无法远程登录(root only) 锁定用户
    passwd -u hadoop        # 解锁用户(root only) 
    passwd -d hadoop        # 清空用户账户 
    passwd -S               # 查看密码状态可以使用 
    # 其中如果想在shell script中输入用户密码可以
    echo "Userpasswd" | passwd --stdin $username 
    printf "Userpasswd\nUserpasswd\n" | passwd $username
    
pwck     检查/etc/passwd内的信息与实际的家目录是否存在等信息,还可比对/etc/passwd与/etc/shadow内的信息是否一致
grpck    检查用户组
groups   
pwconv   将/etc/passwd内的账号与密码移到/etc/shadow内
chpasswd 读入未加密前的密码并经过加密再写入到/etc/shadow内

    # chpasswd也是用来修改密码的,其格式一定要"username:password"这个形式,如下
    echo "username:password" | chpasswd -m # -m 以MD5加密
    
    chage -l root           # 可以更直观地列出/etc/shadow中有关密码时间的信息
    
    chown -R user:group     # 修改目录拥有者(R递归)
    chown y\.li:mysql       # 修改所有者用户中包含点"."
    umask                   # 设置用户文件和目录的文件创建缺省屏蔽值
    umask -S                # 查看当前用户的umask值
    umask 0066              # 修改当前用户的umask值

    groupadd  -r            # 会修改系统用户组 - 新建用户组 
    groupmod                # groupmod会去修改/etc/group相关字段
    groupdel                # 删除用户组
    gpasswd groupname                  # 添加用户组密码
    gpasswd -r groupname               # 删除用户组密码
    gpasswd -A user1,user2.. groupname # 添加用户组管理员(那么其可以执行gpasswd)
    gpasswd -M user1,user2...groupname # 添加用户组成员
    gpasswd -a user1 groupname         # 添加用户至用户组
    gpasswd -d user1 groupname         # 删除用户
    
    chgrp                   # 修改用户组
    finger                  # 查找用户显示信息
    echo "xuesong" | passwd user --stdin       # 非交互修改密码
    

    gpasswd -d user group                      # 从组中删除用户
    su - user -c " #命令1; "                   # 切换用户执行

    恢复密码{
        # 即进入单用户模式: 在linux出现grub后，在安装的系统上面按"e"，然后出现grub的配置文件，按键盘移动光标到第二行"Ker……"，再按"e"，然后在这一行的结尾加上：空格 single或者空格1回车，然后按"b"重启，就进入了"单用户模式"
    }
chattr [+-=] [选项] 文件或目录名
  +：増加权限；
  -：删除权限；
  =：等于某权限；
  i：如果对文件设置属性，那么不允许对文件进行删除、改名，也不能添加和修改数据；如果对目录设置 i 属性，那么只能修改目录下文件中的数据，但不允许建立和删除文件；
  a：如果对文件设置 a 属性，那么只能在文件中増加数据，但是不能删除和修改数据；如果对目录设置 a 属性，那么只允许在目录中建立和修改文件，但是不允许删除文件；
  e：Linux 中的绝大多数文件都默认拥有 e 属性，表示该文件是使用 ext 文件系统进行存储的，而且不能使用"chattr -e"命令取消 e 属性；
lsattr 选项 文件名
  -a：显示所有文件和目录；
  -d：如果目标是目录，则仅列出目录本身的属性，而不会列出文件的属性；

    特殊权限{
    chmod u+s, g+s, o+t ftest
    chmod u-s, g-s, o-t ftest
        s或 S (SUID)：对应数值4  chmod 4755 ftest
        s或 S (SGID)：对应数值2  chmod 2755 ftest
        t或 T ：对应数值1        chmod 1755 dtest
        大S：代表拥有root权限，但是没有执行权限
        小s：拥有特权且拥有执行权限，这个文件可以访问系统任何root用户可以访问的资源
        T或T(Sticky)：/tmp和 /var/tmp目录供所有用户暂时存取文件，亦即每位用户皆拥有完整的权限进入该目录，去浏览、删除和移动文件

SUID: 置于 u  的 x 位，原位置有执行权限，就置为 s，没有了为 S . 
SGID: 置于 g  的 x 位，原位置有执行权限，就置为 s，没有了为 S . 
STICKY : 粘滞位，置于 o 的 x  位，原位置有执行权限，就置为 t  ，否则为 T .
        
SetUID 的功能：
  只有可以执行的二进制程序才能设定 SetUID 权限。
  命令执行者要对该程序拥有 x(执行)权限。
  命令执行者在执行该程序时获得该程序文件属主的割分(在执行程序的过程中变为文件的属主)。
  SetUID 权限只在该程序执行过程中有效，也就是说身份改变只在程序执行过程中有效。
SetGID 既可以针对文件生效，也可以针对目录生效，这和 SetUID 明显不同。如果针对文件，那么 SetGID 的含义如下：
  只有可执行的二进制程序才能设置 SetGID 权限。
  命令执行者要对该程序拥有 x(执行)权限。
  命令执行者在执行程序的时候，组身份升级为该程序文件的属组。
  SetGID 权限同样只在该程序执行过程中有效，也就是说，组身份改变只在程序执行过程中有效。
SetGID针对目录的作用
  如果 SetGID 针对目录设置，则其含义如下：
  普通用户必须对此目录拥有 r 和 x 权限，才能进入此目录。
  普通用户在此目录中的有效组会变成此目录的属组。
  若普通用户对此目录拥有 w 权限，则新建文件的默认属组是这个目录的属组。
Sticky BIT 意为粘着位(或粘滞位)，也简称为 SBIT。它的作用如下：
  粘着位目前只对目录有效。
  普通用户对该目录拥有 w 和 x 权限，即普通用户可以在此目录中拥有写入权限。
  如果没有粘着位，那么，因为普通用户拥有 w 权限，所以可以删除此目录下的所有文件，包括其他用户建立的文件。
一旦被赋予了粘着位，除了 root 可以删除所有文件，普通用户就算拥有 w 权限，也只能删除自己建立的文件，
而不能删除其他用户建立的文件。

# 只有所有者和root可以删除他。
drwxrwxrwt.  10 root root    36864 May 15 13:20 tmp

特殊权限：(出现在相应域的可执行位上) ~
    s (SUID,Set UID)：   仅作用于"拥有者域"
                         文件：常作用于可执行文件。任意执行该文件的"使用者"都将获得"拥有者"的特权，如"/bin/passwd"命令就是如此
                         目录：
    s (SGID,Set GID)：   仅作用于"拥有者所在组域"
                         文件：常作用于可执行文件。任意执行该文件的"使用者"都将获得"拥有者所在的组"的特权
                         目录："使用者"在该目录创建的所有文件都获得"拥有者所在组"的特权
    t (SBIT,Sticky Bit)：仅作用于"其他组域"
                         文件：不可以作用于文件
                         目录："使用者"在该目录创建的文件只有该用户自己和ROOT可以修改，其他用户无权修改，如"/tmp"目录
    }

}
ACL(access control list){
主要用于在提供传统的owner 、group、others 的read 、write、execute权限之外进行细部权限设置。
让/目录支持ACL： 
#mount - o remount ,acl / 
#mount |grep /      // 查看是否有挂载 
开机启动ACL： 
将要启动 ACL 的分区写入/etc/fstab 中： 
#vi /etc/fstab 
/dev/hda5       /                ext3         default,acl       1      2  


    传统的Linux文件系统的权限控制是通过user 、group、other与 r(读)、w(写)、x(执行) 的不同组合来
实现的。随着应用的发展，这些权限组合已不能适应现时复杂的文件系统权限控制要求。例如，目录  /data 
的权限为：drwxr- x--- ，所有者与所属组均为  root ，在不改变所有者的前提下，要求用户  tom  对该目录有完
全访问权限  (rwx). 考虑以下 2 种办法  ( 这里假设  to m 不属于  root group)  
(1)给/data 的 other 类别增加  rwx permission，这样由于  tom  会被归为 other 类别，那么他也将拥有rwx权限。 
(2)  将  tom  加入到  root group，为  root group  分配  rwx  权限，那么他也将拥有  rwx  权限。 
以上  2  种方法其实都不合适，所以传统的权限管理设置起来就力不从心了。

ACL 就是可以设置特定用户或者用户组对于一个文件的操作权限。 
ACL 有两种，
一种是存取 ACL (access ACLs)，针对文件和目录设置访问控制列表。
一种是默认 ACL (default ACLs)，只能针对目录设置。如果目录中的文件没有设置 ACL，它就会使用该目录的默认ACL.

    在我的电脑里首先有一个用户叫 NEU.我们学校的简称.同时还有一个用户,software,我的专业名称. 
    我以neu 用户进行操作,在其目录下建立一个文件 fileofneu.  
可以看到它的初始权限为- rw- rw-r -- 然后我把这个文件权限进行下修改.使用的命令为 chmod,修改后的文
件权限为-rw- rw----现在这个文件的权限就不允许其它用户访问了
    然后切换到 sofeware 用户,来证实这个文件的不可访问性. 
    
setfacl  -m u:softeware:rw-  fileofneu  
setfacl  -R -m u:softeware:rw-  fileofneu (-R 一定要在-m 前面，表示目录下所有文件) 
setfacl  -x u:softeware fileofneu      （去掉单个权限） 
setfacl  -b  （去掉所有acl权限）

    如果我们希望在一个目录中新建的文件和目录都使用同一个预定的 ACL，那么我们可以使用默认(Default) 
ACL。在对一个目录设置了默认的 ACL 以后，每个在目录中创建的文件都会自动继承目录的默认 ACL 作为自
己的ACL。用 setfacl 的- d 选项就可以做到这一点
setfacl  -d  -- set g:testg1:rwx dir1
}
acl(getfacl setfacl){
使用 getfacl 和 setfacl 以保存和恢复文件权限。例如：
   getfacl -R /some/path > permissions.txt
   setfacl --restore=permissions.txt

    ACL可以针对单一用户,单一用户组,单个文件进行rwx的权限设置.
    首先查看文件系统的挂载情况:mount
    比如我要设置的文件在/的文件系统下,其挂载至/dev/sda9,我们用dumpe2fs -h /dev/sda9的超级块的Default mount options情况.
    如果没有acl功能,可以在/etc/fstab中options加入acl.这样开机就是启动acl.

    系统的基本权限是针对文档所有者、所属组或其他账户进行控制的。无法针对某个单独的账户进行控制。
所以就有了ACL访问控制列表的概念。
    用于解决所有者、所属组和其他这三个权限位无法合理设置单个用户权限的问题。
    需要明确的是，扩展ACL是文件系统上的功能，且工作在内核，默认在ext4/xfs上都已开启。
    dumpe2fs -h /dev/sda2 | grep -i acl # ext2 ext3 ext4   支持
    dmesg | grep -i acl                 # xfs              支持
    mount -o remount, acl /
    UUID=c2ca6f57-b15c-43ea-bca0-f239083d8bd2 /ext4 defaults, acl 1 1 # fstab
    开启ACL功能后，不代表就使用ACL功能。是否使用该功能，不同文件系统控制方法不一样，对于ext家族来说，通过mount挂载选项来控制，
    
  getfacl 1.test                      # 查看文件ACL权限
  setfacl -R -m u:xuesong:rw- 1.test  # 对文件增加用户的读写权限 -R 递归
  setfacl [options] u:[用户列表]:[rwx] 目录/文件名    # 对用户设置使用u
  setfacl [options] g:[组列表]:[rwx]   目录/文件名    # 对组设置使用g
  -b # 删除所有附加的ACL条目
  -k # 删除默认的ACL
  -d # 设定默认ACL权限，只对目录有效，设置后子目录(文件)继承默认ACL，只对未来文件有效
  -m # 添加ACL条目
  -x # 删除指定的ACL条目
  -R # 递归处理所有的子文件和子目录
  -n # 不重置mask
  -M # 写了ACL条目的文件，将从此文件中读取ACL条目，需要配合-m，所以-M指定的是modify file 
  -X # 写了ACL条目的文件，将从此文件中读取ACL条目，需要配合-x，所以-X指定的是remove file
  
选项-m 和-x 后边跟以 acl规则。多条 acl规则以逗号(,) 隔开。选项- M 和- X 用来从文件或标准输入读取acl规则。 
选项--set 和--set-file 用来设置文件或目录的 acl规则，先前的设定将被覆盖。 
选项-m(--modify)和-M(--modify-file) 选项修改文件或目录的 acl规则。 
选项-x(--remove) 和- X( --remove-file) 选项删除 acl规则。

setfacl 命令可以识别以下的规则格式。 
[d[efault]:] [u[ser]:]uid [:perms]  
   指定用户的权限，文件所有者的权限（如果 uid没有指定）。 
[d[efault]:] g[roup]:gid [:perms]  
   指定群组的权限，文件所有群组的权限（如果 gid没有指定） 
[d[efault]:] m[ask][:] [:perms]  
   有效权限掩码 
[d[efault]:] o[ther] [:perms ] 
   其他的权限
   
  setfacl -m u:user1:rw test.txt
  setfacl -m g:user1:r test.txt
  setfacl -x g:user1 test.txt
  setfacl -x u:user1 test.txt
  setfacl -b test.txt
  
  ACL:mask # 设置mask后会将mask权限与已有的acl权限进行与计算，计算后的结果会成为新的ACL权限。
  setfacl -m m:[rwx] 目录/文件名
  使用setfacl的"-n"选项，它表示此次设置不会重置mask值。
  
  # 设置递归和默认ACL权限
  递归ACL权限只对目录里已有文件有效，默认权限只对未来目录里的文件有效。
  设置递归ACL权限：
  setfacl -m u:username:[rwx] -R 目录名   # -R选项只能放在后面。
  设置默认ACL权限：
  setfacl -m d:u:username:[rwx] 目录名
  # 删除ACL权限
  setfacl -x u:用户名 文件名       # 删除指定用户ACL
  setfacl -x g:组名 文件名         # 删除指定组名ACL
  setfacl -b 文件名                # 指定文件删除ACL，会删除所有ACL
  }
    selinux{

        sestatus -v                    # 查看selinux状态
        getenforce                     # 查看selinux模式
        setenforce 0                   # 设置selinux为宽容模式(可避免阻止一些操作)
        semanage port -l               # 查看selinux端口限制规则
        semanage port -a -t http_port_t -p tcp 8000  # 在selinux中注册端口类型
        vi /etc/selinux/config         # selinux配置文件
        SELINUX=enfoceing              # 关闭selinux 把其修改为  SELINUX=disabled
        
setenforce 设置SELinux模式
getenforce 查看SELinux模式
setsebool 设置SELinux布尔值
getsebool 查看SELinux布尔值
togglesebool 翻转SELinux布尔值
sestatus SELinux状态查看工具
avcstat 显示AVC统计信息
audit why：转换审计消息
audit allow：生成策略允许规则
load policy：装载策略
semanage 管理SELinux策略
semodule 管理策略模块
chcat 改变语境类别
restorecon 恢复文件安全语境
chcon 改变文件安全语境
setfiles 设置文件安全语境
seinfo 提取策略的规则数量统计信息
sesearch 搜索policy.conf或二进制策略中特别的类型
checkmodule 编译策略模块
sealert SELinux信息诊断客户端工具
selinuxenabled 查询系统的SELinux是否启用
    }
    
enscript(将文本文件转换为PostScript格式){
这个命令可以用来指定字体、标题、限定的格式化选项和假脱机选项。
enscript [参数][SpoolerO ptions][文件...]

实例1：在名为printer的打印机上打印文件/usr/share/doc/grep-2.5.1/README。
[root@localhost ~]#enscript -d printer /usr/share/do c/grep-2.5.1/README

实例2：在缺省打印机上打印文件/root/enscript-1.6.4/src/main.c的双联印刷的效果。
[root@localhost ~]#enscript -2r /root/enscript-1.6.4/ src/main.c 
}
ps2pdf()
{
    PostScript是一种编程语言，最适用于列印图像和文字(无论是在纸、胶片或非物质的CRT都可)。用现今的行话讲
，它是页面描述语言。它既可以像程序代码一样具有可读性，又能表示出可任意放大和缩小的矢量图。
man -t errno | ps2pdf - ~/errno.pdf
man -t bash | ps2pdf - ~/bash.pdf
在线html转pdf
http://www.htm2pdf.co.uk/
}

https://github.com/limingth/share/blob/master/markdown-demo/demo.md
Markdown(如何转换Markdown到html/doc/pdf/ppt格式){
工具安装
    sudo apt-get install pandoc
    sudo apt-get install texlive
    sudo apt-get install xelatex
    sudo apt-get install unoconv

md->html (demo.html)
  pandoc --ascii -f markdown -t html -o demo.html demo.md  

md->doc (demo.doc)
  pandoc demo.md -o demo.doc
  	(目录无数字标题1.1.1)

md->doc->pdf (demo.pdf)
  unoconv -f pdf demo.doc 
  	(目录无数字标题1.1.1)

md->tex->doc.pdf (demo.doc.pdf)
  pandoc demo.md -o demo2doc.tex
  xelatex demo.doc.tex
  	(demo.doc.tex 是自制doc tex模板文件, 自动生成数字标题1.1.1)

md->tex->ppt.pdf (demo.ppt.pdf)
  pandoc -t beamer --slide-level 2 demo.md -o demo.tex
  xelatex demo.ppt.tex
  	(demo.ppt.tex 是自制ppt tex模板文件)
}

system(script参考){
    #!/bin/sh         # 在脚本第一行脚本头 # sh为当前系统默认shell,可指定为bash等shell
    sh -x             # 执行过程
    sh -n             # 检查语法
    (a=bbk)           # 括号创建子shell运行
    basename /a/b/c   # 从文件名中去掉路径和扩展名
    basename include/stdio.h .h # stdio
    dirname           # 取路径
    $RANDOM           # 随机数
    $$                # 进程号
    source FileName   # 在当前bash环境下读取并执行FileName中的命令  # 等同 . FileName
    sleep 5           # 间隔睡眠5秒  
    usleep 500000     # 微秒
    trap              # 在接收到信号后将要采取的行动
    trap "" 2 3       # 禁止ctrl+c
    $PWD              # 当前目录
    $HOME             # 家目录
    $OLDPWD           # 之前一个目录的路径
    cd -              # 返回上一个目录路径
    local ret         # 局部变量
    yes               # 重复打印 指定的字符串，并且每个字符串占一行 (将交互式命令转换成批处理命令)
    yes again
    yes | my_interactive_command
    yes |rm -i *      # 自动回答y或者其他
    ls -p /home       # 区分目录和文件夹
    ls -d /home/      # 查看匹配完整路径
    time a.sh         # 测试程序执行时间
    echo -n aa;echo bb                    # 不换行执行下一句话 将字符串原样输出
    echo -e "s\tss\n\n\n"                 # 使转义生效
    echo $a | cut -c2-6                   # 取字符串中字元
    echo {a,b,c}{a,b,c}{a,b,c}            # 排列组合(括号内一个元素分别和其他括号内元素组合)
    echo $((2#11010))                     # 二进制转10进制
    echo aaa | tee file                   # 打印同时写入文件 默认覆盖 -a追加
    echo {1..10}                          # 打印10个字符
    printf '%10s\n'|tr " " a              # 打印10个字符
    pwd -P                                # 返回链接的真实路径名
    cd !$                                 # 把上个命令的参数作为cd参数使用
    pwd | awk -F/ '{ print $2 }'          # 返回目录名
    tac file |sed 1,3d|tac                # 倒置读取文件  # 删除最后3行
    tail -3 file                          # 取最后3行
    outtmp=/tmp/$$`date +%s%N`.outtmp     # 临时文件定义
    :(){ :|:& };:                         # 著名的 fork炸弹,系统执行海量的进程,直到系统僵死
    echo -e "\e[32m颜色\e[0m"             # 打印颜色
    echo -e "\033[32m颜色\033[m"          # 打印颜色
    echo -e "\033[0;31mL\033[0;32mO\033[0;33mV\033[0;34mE\t\033[0;35mY\033[0;36mO\033[0;32mU\e[m"    # 打印颜色

bash(Debugging){
1. Checking the syntax of a script with "-n"
2. bashdb
  l - show local lines, press l again to scroll down
  s - step to next line
  print $VAR - echo out content of variable
  restart - reruns bashscript, it re-loads it prior to execution.
  eval - evaluate some custom command, ex: eval echo hi
  b  set breakpoint on some line
  c - continue till some breakpoint
  i b - info on break points
  d  - delete breakpoint at line #
  shell - launch a sub-shell in the middle of execution, this is handy for manipulating variables
3. Debugging a bash script with "-x"
  set -x   # Enable debugging
  # some code here
  set +x   # Disable debugging output.
}
bash(glob){
extglob
    ?(pattern-list) 匹配0个或者1个pattern-list
    *(pattern-list) 匹配0个或者多个pattern-list
    +(pattern-list) 匹配1个或者多个pattern-list
    @(pattern-list) 匹配1个pattern-list
    !(pattern-list) 匹配不符合pattern-list模式
    ls +(ab|def)*.+(jpeg|gif) # 列出当前目录下以“ab”或者“def”打头的JPEG或者GIF文件
    ls ab+(2|3).jpg           # 列出当前目录下匹配与正则表达式ab(2|3)+\.jpg相同匹配结果的所有文件
    rm -rf !(*.jpeg|*.gif)    # 删除当前目录下除了以jpeg或者gif为后缀的文件
    ls !(+(ab|def)*.+(jpeg|gif))

$ mkdir globbing
$ cd globbing
$ mkdir -p folder/{sub,another}folder/content/deepfolder/
touch macy stacy tracy "file with space" folder/{sub,another}folder/content/deepfolder/file
.hiddenfile
$ shopt -u nullglob
$ shopt -u failglob
$ shopt -u dotglob
$ shopt -u nocaseglob
$ shopt -u extglob
$ shopt -u globstar

$ echo no*match
no*match

$ shopt -s nullglob
$ echo no*match
$

$ shopt -s failglob
$ echo no*match
bash: no match: no*match
$
failglob > nullgolb 

shopt -s globstar
echo *   # 显示本目录
echo **  # 显示本目录和子目录

shopt -s extglob
?(pattern-list) - Matches zero or one occurrence of the given patterns
*(pattern-list) - Matches zero or more occurrences of the given patterns
+(pattern-list) - Matches one or more occurrences of the given patterns
@(pattern-list) - Matches one of the given patterns
!(pattern-list) - Matches anything except one of the given patterns
$ echo *([r-t])acy
stacy tracy
$ echo *([r-t]|m)acy
macy stacy tracy
$ echo ?([a-z])acy
macy
}

bash(word splitting){ 什么时候避免单词分割，什么时候强调单词分割
set -x
var='I am
a
multiline string'
fun() {
    echo "-$1-"
    echo "*$2*"
    echo ".$3."
}
fun $var # fun I am a multiline string

$ a='I am a string with spaces'
$ [ $a = $a ] || echo "didn't match"
bash: [: too many arguments
didnot match

[ $a = something ] || echo "didn't match"

Looping through space separated words:
words='foo bar baz'
for w in $words;do
    echo "W: $w"
done

packs='apache2 php php-mbstring php-mysql'
sudo apt-get install $packs

packs='
apache2
php
php-mbstring
php-mysql
'
sudo apt-get install $packs

# showarg
#!/usr/bin/env bash
printf "%d args:" $#
printf " <%s>" "$@"
echo

var="This is an example"
showarg $var
4 args: <This> <is> <an> <example>

var="This/is/an/example"
showarg $var
1 args: <This/is/an/example>

IFS=/
var="This/is/an/example"
showarg $var
args: <This> <is> <an> <example>

单词分割
1. shell扫描参数扩展、命令替换和算术扩展 之后进行 单词分割，如果结果包含在双引号中则不进行单词分割。
2. shell将$IFS的每一个字符作为分隔符，使用分隔符将其他扩展的结果分隔为单个的word。
3. 如果IFS未设置，或者它的值就是<space> <tab> <newline>这些默认值，
   则扩展结果中的开始的和结束的一串默认分隔符都被忽略，其他位置的一串默认分隔符用来分隔操作。
4. 如果IFS非默认值，则扩展结果中开始和结束的一连串的空格和tab也被忽略，就像空格字符也在$IFS中一样。
   IFS中的其他字符用来作为 单词分割 的分隔符。一系列的空格也被当做是一个分隔符。
5. 如果IFS为空值，则不进行 单词分割. 显式的给IFS赋空值(""或者'')，则IFS为空值。
}
    bash(正则表达式){
        ^              # 行首定位
        $              # 行尾定位
        .              # 匹配除换行符以外的任意字符
        *              # 匹配0或多个重复字符
        +              # 重复一次或更多次
        ?              # 重复零次或一次
        ?              # 结束贪婪因子 .*? 表示最小匹配
        []             # 匹配一组中任意一个字符
        [^]            # 匹配不在指定组内的字符
        \              # 用来转义元字符
        <              # 词首定位符(支持vi和grep)  <love
        >              # 词尾定位符(支持vi和grep)  love>
        x\{m\}         # 重复出现m次
        x\{m,\}        # 重复出现至少m次
        x\{m,n\}       # 重复出现至少m次不超过n次
        X?             # 匹配出现零次或一次的大写字母 X
        X+             # 匹配一个或多个字母 X
        ()             # 括号内的字符为一组
        (ab|de)+       # 匹配一连串的(最少一个) abc 或 def；abc 和 def 将匹配
        [[:alpha:]]    # 代表所有字母不论大小写
        [[:lower:]]    # 表示小写字母
        [[:upper:]]    # 表示大写字母
        [[:digit:]]    # 表示数字字符
        [[:digit:][:lower:]]    # 表示数字字符加小写字母

        元字符{
            \d       # 匹配任意一位数字
            \D       # 匹配任意单个非数字字符
            \w       # 匹配任意单个字母数字下划线字符，同义词是 [:alnum:]
            \W       # 匹配非数字型的字符
        }

        字符类:空白字符{
            \s       # 匹配任意的空白符
            \S       # 匹配非空白字符
            \b       # 匹配单词的开始或结束
            \n       # 匹配换行符
            \r       # 匹配回车符
            \t       # 匹配制表符
            \b       # 匹配退格符
            \0       # 匹配空值字符
        }

        字符类:锚定字符{
            \b       # 匹配字边界(不在[]中时)
            \B       # 匹配非字边界
            \A       # 匹配字符串开头
            \Z       # 匹配字符串或行的末尾
            \z       # 只匹配字符串末尾
            \G       # 匹配前一次m//g离开之处
        }

        捕获{
            (exp)                # 匹配exp,并捕获文本到自动命名的组里
            (?<name>exp)         # 匹配exp,并捕获文本到名称为name的组里，也可以写成(?'name'exp)
            (?:exp)              # 匹配exp,不捕获匹配的文本，也不给此分组分配组号
        }

        零宽断言{
            (?=exp)              # 匹配exp前面的位置
            (?<=exp)             # 匹配exp后面的位置
            (?!exp)              # 匹配后面跟的不是exp的位置
            (?<!exp)             # 匹配前面不是exp的位置
            (?#comment)          # 注释不对正则表达式的处理产生任何影响，用于注释
        }

        特殊字符{
            http://en.wikipedia.org/wiki/Ascii_table
            ^H  \010 \b
            ^M  \015 \r
            匹配特殊字符: ctrl+V ctrl不放在按H或M 即可输出^H,用于匹配
        }
    }

    流程结构{

        if判断{
            if [ $a == $b ]
            then
                echo "等于"
            else
                echo "不等于"
            fi
        }

        case分支选择{
            case $xs in
            0) echo "0" ;;
            1) echo "1" ;;
            *) echo "其他" ;;
            esac
        }

        while循环{
            # while true  等同   while :
            # 读文件为整行读入
            num=1
            while [ $num -lt 10 ]
            do
            echo $num
            ((num=$num+2))
            done
            ###########################
            grep a  a.txt | while read a
            do
                echo $a
            done
            ###########################
            while read a
            do
                echo $a
            done < a.txt
        }

        for循环{
            # 读文件已空格分隔
            w=`awk -F ":" '{print $1}' c`
            for d in $w
            do
                $d
            done
            ###########################
            for ((i=0;i<${#o[*]};i++))
            do
            echo ${o[$i]}
            done
        }

        until循环{
            #  当command不为0时循环
            until command
            do
                body
            done
        }

        流程控制{

            break N     #  跳出几层循环
            continue N  #  跳出几层循环，循环次数不变
            continue    #  重新循环次数不变
        }
    }

    bash(变量){
        A="a b c def"           # 将字符串复制给变量
        A=`cmd`                 # 将命令结果赋给变量
        A=$(cmd)                # 将命令结果赋给变量
        eval a=\$$a             # 间接调用
        i=2&&echo $((i+3))      # 计算后打印新变量结果
        i=2&&echo $[i+3]        # 计算后打印新变量结果
        a=$((2>6?5:8))          # 判断两个值满足条件的赋值给变量
        $1  $2  $*              # 位置参数 *代表所有
        env                     # 查看环境变量
        env | grep "name"       # 查看定义的环境变量
        set                     # 查看环境变量和本地变量
        read name               # 输入变量
        readonly name           # 把name这个变量设置为只读变量,不允许再次设置
        readonly                # 查看系统存在的只读文件
        export name             # 变量name由本地升为环境
        export name="RedHat"    # 直接定义name为环境变量
        export Stat$nu=2222     # 变量引用变量赋值
        unset name              # 变量清除
        export -n name          # 去掉只读变量
        shift                   # 用于移动位置变量,调整位置变量,使$3的值赋给$2.$2的值赋予$1
        name + 0                # 将字符串转换为数字
        number " "              # 将数字转换成字符串
        a='ee';b='a';echo ${!b} # 间接引用name变量的值
        : ${a="cc"}             # 如果a有值则不改变,如果a无值则赋值a变量为cc

        bash(数组){
            A=(a b c def)         # 将变量定义为数組
            ${#A[*]}              # 数组个数
            ${A[*]}               # 数组所有元素,大字符串
            ${A[@]}               # 数组所有元素,类似列表可迭代
            ${A[2]}               # 脚本的一个参数或数组第三位
        }

        bash(定义变量类型){
            declare 或 typeset
            -r 只读(readonly一样)
            -i 整形
            -a 数组
            -f 函数
            -x export
            declare -i n=0
        }

        bash(系统变量){
            $0   #  脚本启动名(包括路径)
            $n   #  第n个参数,n=1,2,…9
            $*   #  所有参数列表(不包括脚本本身)
            $@   #  所有参数列表(独立字符串)
            $#   #  参数个数(不包括脚本本身)
            $$   #  当前程式的PID
            $!   #  执行上一个指令的PID
            $?   #  执行上一个指令的返回值
        }

        bash(变量引用技巧){
            ${name:+value}        # 如果设置了name,就把value显示,未设置则为空
            ${name:-value}        # 如果设置了name,就显示它,未设置就显示value
            ${name:?value}        # 未设置提示用户错误信息value 
            ${name:=value}        # 如未设置就把value设置并显示<写入本地中>
            ${#A}                 # 可得到变量中字节
            ${A:4:9}              # 取变量中第4位到后面9位
            ${A:(-1)}             # 倒叙取最后一个字符
            ${A/www/http}         # 取变量并且替换每行第一个关键字
            ${A//www/http}        # 取变量并且全部替换每行关键字

            定义了一个变量： file=/dir1/dir2/dir3/my.file.txt
            ${file#*/}     # 去掉第一条 / 及其左边的字串：dir1/dir2/dir3/my.file.txt
            ${file##*/}    # 去掉最后一条 / 及其左边的字串：my.file.txt
            ${file#*.}     # 去掉第一个 .  及其左边的字串：file.txt
            ${file##*.}    # 去掉最后一个 .  及其左边的字串：txt
            ${file%/*}     # 去掉最后条 / 及其右边的字串：/dir1/dir2/dir3
            ${file%%/*}    # 去掉第一条 / 及其右边的字串：(空值)
            ${file%.*}     # 去掉最后一个 .  及其右边的字串：/dir1/dir2/dir3/my.file
            ${file%%.*}    # 去掉第一个 .  及其右边的字串：/dir1/dir2/dir3/my
            #   # 是去掉左边(在键盘上 # 在 $ 之左边)
            #   % 是去掉右边(在键盘上 % 在 $ 之右边)
            #   单一符号是最小匹配﹔两个符号是最大匹配
        }

    }

    bash(test条件判断){

        # 符号 [ ] 等同  test命令

        bash(expression为字符串操作){
            -n str   # 字符串str是否不为空
            -z str   # 字符串str是否为空
        }

        bash(expression为文件操作){
            -a     # 并且，两条件为真
            -b     # 是否块文件
            -p     # 文件是否为一个命名管道
            -c     # 是否字符文件
            -r     # 文件是否可读
            -d     # 是否一个目录
            -s     # 文件的长度是否不为零
            -e     # 文件是否存在
            -S     # 是否为套接字文件
            -f     # 是否普通文件
            -x     # 文件是否可执行，则为真
            -g     # 是否设置了文件的 SGID 位
            -u     # 是否设置了文件的 SUID 位
            -G     # 文件是否存在且归该组所有
            -w     # 文件是否可写，则为真
            -k     # 文件是否设置了的粘贴位
            -t fd  # fd 是否是个和终端相连的打开的文件描述符(fd 默认为 1)
            -o     # 或，一个条件为真
            -O     # 文件是否存在且归该用户所有
            !      # 取反
        }

        bash(expression与或操作){
            expr1 -a expr2   # 如果 expr1 和 expr2 评估为真，则为真
            expr1 -o expr2   # 如果 expr1 或 expr2 评估为真，则为真
        }

        bash(两值比较){
            整数     字符串
            -lt      <         # 小于
            -gt      >         # 大于
            -le      <=        # 小于或等于
            -ge      >=        # 大于或等于
            -eq      ==        # 等于
            -ne      !=        # 不等于
        }

        test 10 -lt 5       # 判断大小
        echo $?             # 查看上句test命令返回状态  # 结果0为真,1为假
        test -n "hello"     # 判断字符串长度是否为0
        [ $? -eq 0 ] && echo "success" || exit　　　# 判断成功提示,失败则退出

    }
    
    test(linux test命令){
一、test命令的应用类型
1. 在[[]] 中 < > 只能用于比较字符串，不能用于比较数字，
2. 在[] [[]] 中比较数字都可以用 lt le eq ne gt ge。 在[]中比较数字也可以使用 < >
3.  ((...)) 可以使用C-style方式进行数值比较
 
1、判断表达式
if test (表达式为真)
if test !表达式为假
test 表达式1 -a 表达式2             两个表达式都为真
test 表达式1 -o 表达式2             两个表达式有一个为真

2、判断字符串 # 1.未初始化、2.初始化为空、3.初始化为空格、4.初始化非空格
test -n 字符串                    字符串的长度非零
test -z 字符串                    字符串的长度为零
[[ -n "$string" ]];          "$string is non-empty"   # 初始化非空
[[ -z "${string// }" ]];     "$string is empty or contains only spaces" # 初始化非空 且 非空格
[[ -z "$string" ]];          "$string is empty"       # 初始化为空
[[ -n "${string+x}" ]];      "$string is set, possibly to the empty string" # 
[[ -n "${string-x}" ]];      "$string is either unset or set to a non-empty string" # 
[[ -z "${string+x}" ]];      "$string is unset" # 
[[ -z "${string-x}" ]];      "$string is set to an empty string" # 
+-----------------------+-------+-------+-----------+
$string is:             | unset | empty | non-empty |
+-----------------------+-------+-------+-----------+
| [[ -z ${string} ]]    | true  | true  | false     |
| [[ -z ${string+x} ]]  | true  | false | false     |
| [[ -z ${string-x} ]]  | false | true  | false     |
| [[ -n ${string} ]]    | false | false | true      |
| [[ -n ${string+x} ]]  | false | true  | true      |
| [[ -n ${string-x} ]]  | true  | false | true      |
+-----------------------+-------+-------+-----------+

case ${var+x$var} in
  (x) echo empty;;                     # 初始化为空
  ("") echo unset;;                    # 未初始化
  (x*[![:blank:]]*) echo non-blank;;   # 初始化非空格
  (*) echo blank                       # 初始化为空格
esac

# 字符串比较需要使用 " " 双引号
test 字符串1=字符串2              字符串相等
test 字符串1!=字符串2            字符串不等
[ "$string1" == "$string2" ]
[ "$string1" != "$string2" ]
# 模式匹配，支持*?[]方式匹配
[[ "$string" == $pattern1 ]]
[[ "$string" != $pattern1 ]]
# 字符串判断只有 == = != > < 几种操作符，不支持 >=或者 <= 这两个操作符
3、判断整数
test 整数1 -eq 整数2             整数相等(equal)
test 整数1 -ge 整数2             整数1大于等于整数2(greater than or equal)
test 整数1 -gt 整数2             整数1大于整数2(greater than)
test 整数1 -le 整数2             整数1小于等于整数2(less than or equal)
test 整数1 -lt 整数2             整数1小于整数2(less than)
test 整数1 -ne 整数2             整数1不等于整数2(not equal)

4、判断文件
test File1 -ef File2             两个文件具有同样的设备号和i结点号
test File1 -nt File2             文件1比文件2 新(newer than)
test File1 -ot File2             文件1比文件2 旧(older than)
test -b File                     文件存在并且是块设备文件
test -c File                     文件存在并且是字符设备文件
test -d File                     文件存在并且是目录
test -e File                     文件存在
test -f File                     文件存在并且是正规文件
test -g File                     文件存在并且是设置了组ID
test -G File                     文件存在并且属于有效组ID
test -h File                     文件存在并且是一个符号链接(同-L)
test -k File                     文件存在并且设置了sticky位
test -b File                     文件存在并且是块设备文件
test -L File                     文件存在并且是一个符号链接(同-h)
test -o File                     文件存在并且属于有效用户ID
test -p File                     文件存在并且是一个命名管道
test -r File                     文件存在并且可读
test -s File                     文件存在并且是一个套接字
test -t FD                       文件描述符是在一个终端打开的
test -u File                     文件存在并且设置了它的set-user-id位
test -w File                     文件存在并且可写
test -x File                     文件存在并且可执行
# broken link 1. 链接文件存在，2. 链接文件是断链文件、3. 链接文件是非断链文件
[[ -L $filename || -e $filename ]]  "$filename exists (but may be a broken symbolic link)"
[[ -L $filename && ! -e $filename ]] "$filename is a broken symbolic link"
    }

    redirect(exec){
   自定义文件描述符 exec 3<input.txt 
                    exec 5>>output.txt
    通过使用 <(some command) 可以将输出视为文件。例如，对比本地文件 /etc/hosts 和一个远程文件：
      diff /etc/hosts <(ssh somehost cat /etc/hosts)
      
        #  标准输出 stdout 和 标准错误 stderr  标准输入stdin
        cmd 1> fiel              # 把 标准输出 重定向到 file 文件中
        cmd > file 2>&1          # 把 标准输出 和 标准错误 一起重定向到 file 文件中
        cmd 2> file              # 把 标准错误 重定向到 file 文件中
        cmd 2>> file             # 把 标准错误 重定向到 file 文件中(追加)
        cmd >> file 2>&1         # 把 标准输出 和 标准错误 一起重定向到 file 文件中(追加)
        some-command >logfile 2>&1 #  some-command &>logfile
        cmd < file >file2        # cmd 命令以 file 文件作为 stdin(标准输入)，以 file2 文件作为 标准输出
        cat <>file               # 以读写的方式打开 file
        cmd < file cmd           # 命令以 file 文件作为 stdin
        cmd << delimiter
        cmd; #从 stdin 中读入，直至遇到 delimiter 分界符
delimiter
        
    read line < file # 输入重定向操作符< file打开并读取文件file，然后将它作为read命令的标准输入。
    > file                        # 如果此时文件不存在则先创建，存在则将其大小截取为0。
    echo "some string" > file     # 替换文件的内容，或者创建一个包含指定内容的文件
    echo "foo bar baz" >> file    # 如果文件不存在则先创建它。追加的内容之后，紧跟着换行符。
    echo -n "foo bar baz" >> file # 不追加换行符
    read -r line < file           # 读取文件的首行并赋值给变量
    # -r选项保证读入的内容是原始的内容，意味着反斜杠转义的行为不会发生。
    
    # read命令会删除包含在IFS变量中出现的所有字符，Bash 根据 IFS 中定义的字符来分隔单词。
    # 默认情况下，IFS包含空格，制表符和回车，这意味着开头和结尾的空格和制表符都会被删除。如果你想保留这些符号，可以通过设置IFS为空来完成
    IFS= read -r line < file
    line=$(head -1 file)
    
    # 依次读入文件每一行
    while read -r line; do  # read命令会删除首尾多余的空白字符，所以如果你想保留，请设置 IFS 为空值:
      # do something with $line 
    done < file
    cat file | while IFS= read -r line; do # 如果你不想将< file放在最后，可以通过管道将文件的内容输入到 while 循环中
      # do something with $line 
    done
    
    # 随机读取一行并赋值给变量
    read -r random_line <<(shuf file)     
    read -r random_line < <(sort -R file) # -R选项可以随机排序文件
    random_line=$(sort -R file | head -1) # -R选项可以随机排序文件
    
    # 读取文件首行前三个字段并赋值给变量
    while read -r field1 field2 field3 throwaway; do  # throwaway变量，否则的话，当文件的一行大于三个字段时，第三个变量的内容会包含所有剩余的字段。
      # do something with $field1, $field2, and $field3 
    done < file
    # 为了书写方便，可以简单地用_来替换throwaway变量
    while read -r field1 field2 field3 _; do 
      # do something with $field1, $field2, and $field3 
    done < file
    
    read lines words chars _ < <(wc file-with-5-lines) # 保存lines words chars
    
    info="20 packets in 10 seconds"
    packets=$(echo $info | awk '{ print $1 }')  # 10
    time=$(echo $info | awk '{ print $4 }')     # 20
    read packets _ _ time _ <<< "$info"         # packets=10 time=20
    
    size=$(wc -c < file) # 保存文件的大小到变量
    
    filename=${path##*/}  # 从文件路径中获取文件名
    dirname=${path%/*}    # 从文件路径中获取目录名
    
    cp /path/to/file{,_copy} # cp /path/to/file /path/to/file_copy 
    mv /path/to/file{,_old}  # mv /path/to/file /path/to/file_old
    echo {a..z}              # 生成从 a 到 z 的字母表
    printf "%c" {a..z}       # 生成从 a 到 z 的字母表，字母之间不包含空格，无换行
    # printf命令之后指定一个列表，最终它会循环依次打印每个元素，直到完成为止。
    printf "%c" {a..z} $'\n' # 生成从 a 到 z 的字母表，字母之间不包含空格，有换行
    echo $(printf "%c" {a..z})
    printf "%c\n" {a..z}     # 每一行仅输出一个字母，在字符后面增加一个换行符
    echo {1..100}            # seq 1 100
    printf "%02d " {0..9}    # echo {00..09}  seq -w 1 10
    echo {w,t,}h{e{n{,ce{,forth}},re{,in,fore,with{,al}}},ither,at} # 生成 30 个英文单词
    echo {a,b,c}{1,2,3} # a1 a2 a3 b1 b2 b3 c1 c2 c3
    echo foo{,,,,,,,,,,} # 重复输出 10 次字符串
    echo "$x$y"           # 拼接字符串 不省略""
    var=$x$y              # 拼接字符串 可以省略""
    IFS=- read -r x y z <<< "$str" # str="foo-bar-baz"
    IFS=- read -ra parts <<< "foo-bar-baz" # -a 选项告诉read命令将分割后的元素保存到数组parts中
    # 让read命令依次读入一个字符，类似地，-n2说明每次读入两个字符。
    while IFS= read -rn1 c; do 
      # do something with $c 
    done <<< "$str"
    
    echo ${str/foo/bar} # 将字符串中的 foo 替换成 bar
    
    if [[ $file = *.zip ]]; then  # 检查字符串是否匹配模式
      # do something 
    fi
    # 通配符包括* ? [...]。其中，
    # *可以匹配一个或者多个字符， 
    # ?只能匹配单个字符，
    # [...]能够匹配任意出现在中括号里面的字符或者一类字符集。
# 对于非bash内置命令，通配方法可能不一样，命令有自己的通配标准，
# 如find中的"*"可以匹配点开头的文件，但如果它采用的仍然是bash的通配方式，则 .*
    if [[ $answer = [Yy]* ]]; then 
      # do something 
    fi
    
    if [[ $str =~ [0-9]+\.[0-9]+ ]]; then  # 检查字符串是否匹配某个正则表达式
      # do something 
    fi
    # bash 4以下使用。tr命令就可以
    declare -l var  # var="foo bar" -> FOO BAR 转换成小写
    declare -u var  # var="FOO BAR" -> foo bar 转换成大写
    
    >&n    # 使用系统调用 dup (2) 复制文件描述符 n 并把结果用作标准输出
    <&n    # 标准输入复制自文件描述符 n
    <&-    # 关闭标准输入(键盘)
    >&-    # 关闭标准输出
    n<&-   # 表示将 n 号输入关闭
    n>&-   # 表示将 n 号输出关闭
    
    command 2> file # 重定向命令的 stderr 到文件
    command &>file  # 重定向命令的 stdout 和 stder 到同一个文件中
    command >file 2>&1 # 重定向命令的 stdout 和 stder 到同一个文件中
    command > /dev/null # 丢弃命令的 stdout 输出
    command >/dev/null 2>&1 # 丢弃命令的 stdout stderr 输出
    command &>/dev/null     # 丢弃命令的 stdout stderr 输出
    command <file # 重定向文件到命令的 stdin
    read -r line < file
    command <<EOL # 重定向一堆字符串到命令的 stdin
your
multi-line
text
goes
here
EOL
    
    command <<< "foo bar baz"     # 重定向一行文本到命令的 stdin
    echo "foo bar baz" | command  # 重定向一行文本到命令的 stdin
    exec 2>file                   # 重定向所有命令的 stderr 到文件中
    exec 3<file                   # 打开文件并通过特定文件描述符读
    read -u 3 line
    grep "foo" <&3
    exec 3>&-                     # 关闭该文件
    exec 4>file                   # 打开文件并通过特定文件描述符写
    echo "foo" >&4                # 
    exec 4>&-                     # 关闭该文件
    exec 3<>file                  # 打开文件并通过特定文件描述符读写
    
    (command1; command2) >file    # 重定向一组命令的 stdout 到文件中
    
    # 在 Shell 中通过文件中转执行的命令
    打开两个 shell，在第一个中执行以下命令：
    mkfifo fifo
    exec < fifo
    而在第二个中，执行：
    exec 3> fifo;
    echo 'echo test' >&3
# 命名管道可以被多个进程打开同时读写，当多个进程通过 FIFO 交换数据时，
# 内核并没有写到文件系统中，而是自己私下里传递了这些数据。

    # 通过 Bash 访问 Web 站点
    exec 3<>/dev/tcp/www.google.com/80  # Bash 将/dev/tcp/host/port当作一种特殊的文件，它并不需要实际存在于系统中，这种类型的特殊文件是给 Bash 建立 tcp 连接用的。
    echo -e "GET / HTTP/1.1\n\n" >&3    # 写入GET / HTTP/1.1\n\n
    cat <&3                             # 
    
    set -o noclobber # 重定向输出时防止覆盖已有的文件
    program > file 
    bash: file: cannot overwrite existing file
    program >| file # 如果你100%确定你要覆盖一个文件，可以使用>|重定向操作符
    
    command1 2>&1 | command2 # 重定向进程的标准输出和标准错误到另外一个进程的标准输入
    
    command >>(stdout_cmd) 2>>(stderr_cmd) # 重定向标准输出和标注错误输出给不同的进程
    echo 'pants are cool' | grep 'moo' | sed 's/o/x/' | awk '{ print $1 }'  # 获得管道流中的退出码
    echo ${PIPESTATUS[@]} 
    0 1 0 0
    
    tee
    
    exec 2>testerror
    echo "This is the start of the script"
    echo "now redirecting all output to another location"
    
    exec 1>testout
    echo "This output should go to testout file"
    echo "but this should go the the testerror file" >& 2
    
    exec 3 >> testout # 以追加的方式重定向：
    exec 3>-          # 取消重定向：

    }

    bash(运算符){

        $[]等同于$(())  # $[]表示形式告诉shell求中括号中的表达式的值
        ~var            # 按位取反运算符,把var中所有的二进制为1的变为0,为0的变为1
        var\<<str       # 左移运算符,把var中的二进制位向左移动str位,忽略最左端移出的各位,最右端的各位上补上0值,每做一次按位左移就有var乘2
        var>>str        # 右移运算符,把var中所有的二进制位向右移动str位,忽略最右移出的各位,最左的各位上补0,每次做一次右移就有实现var除以2
        var&str         # 与比较运算符,var和str对应位,对于每个二进制来说,如果二都为1,结果为1.否则为0
        var^str         # 异或运算符,比较var和str对应位,对于二进制来说如果二者互补,结果为1,否则为0
        var|str         # 或运算符,比较var和str的对应位,对于每个二进制来说,如二都该位有一个1或都是1,结果为1,否则为0

        运算符优先级{
            级别      运算符                                  说明
#            1      =,+=,-=,/=,%=,*=,&=,^=,|=,<<=,>>=      # 赋值运算符
#            2         ||                                  # 逻辑或 前面不成功执行
#            3         &&                                  # 逻辑与 前面成功后执行
#            4         |                                   # 按位或
#            5         ^                                   # 按位异或
#            6         &                                   # 按位与
#            7         ==,!=                               # 等于/不等于
#            8         <=,>=,<,>                           # 小于或等于/大于或等于/小于/大于
#            9        \<<,>>                               # 按位左移/按位右移 (无转意符号)
#            10        +,-                                 # 加减
#            11        *,/,%                               # 乘,除,取余
#            12        ! ,~                                # 逻辑非,按位取反或补码
#            13        -,+                                 # 正负
        }

    }

    bash(数学运算){

        $(( ))        # 整数运算
        + - * / **    # 分別为 "加、減、乘、除、密运算"
        & | ^ !       # 分別为 "AND、OR、XOR、NOT" 运算
        %             # 余数运算

        let{
数值运算:
# id++, id--      variable post-increment, post-decrement
# ++id, --id      variable pre-increment, pre-decrement
# -, +            unary minus, plus
# !, ~            logical and bitwise negation
# **              exponentiation
# *, /, %         multiplication, division, remainder
# +, -            addition, subtraction
# <<, >>          left and right bitwise shifts
# <=, >=, <, >    comparison
# ==, !=          equality, inequality
# &               bitwise AND
# ^               bitwise XOR
# |               bitwise OR
# &&              logical AND
# ||              logical OR
# expr ? expr : expr
#                 conditional operator
# =, *=, /=, %=,
# +=, -=, <<=, >>=,
# &=, ^=, |=      assignment
        
            let # 运算
            let x=16/4
            let x=5**5
let num=1+2        # right
let num="1+2"      # right
let 'num= 1 + 2'   # right
let num=1 num+=2   # right
                  
let num = 1 + 2    #wrong
let 'num = 1 + 2'  #right
let a[1] = 1 + 1   #wrong
let 'a[1] = 1 + 1' #right
        }

        expr(简要说明)
        {
             ARG1 | ARG2       若ARG1 的值不为0 或者为空，则返回ARG1，否则返回ARG2
             ARG1 & ARG2       若两边的值都不为0 或为空，则返回ARG1，否则返回 0
             
             ARG1 < ARG2       ARG1 小于ARG2
             ARG1 <= ARG2      ARG1 小于或等于ARG2
             ARG1 = ARG2       ARG1 等于ARG2
             ARG1 != ARG2      ARG1 不等于ARG2
             ARG1 >= ARG2      ARG1 大于或等于ARG2
             ARG1 > ARG2       ARG1 大于ARG2
             
             ARG1 + ARG2       计算 ARG1 与ARG2 相加之和
             ARG1 - ARG2       计算 ARG1 与ARG2 相减之差
             
             ARG1 * ARG2       计算 ARG1 与ARG2 相乘之积
             ARG1 / ARG2       计算 ARG1 与ARG2 相除之商
             ARG1 % ARG2       计算 ARG1 与ARG2 相除之余数
             
             match 字符串 表达式等于"字符串 :表达式" #expr match $string substring 返回匹配到的substring字符串的长度
             substr 字符串 偏移量 长度替换字符串的子串，偏移的数值从 1 起计
             index 字符串 字符在字符串中发现字符的地方建立下标，或者标0
             length 字符串字符串的长度
        }
        expr(整数运算&字符match,substr,index,length,:){

            expr 9 + 8 - 7 \* 6 / 5 + \( 4 - 3 \) \* 2
        
            expr 14 % 9                    # 整数运算
            SUM=`expr 2 \* 3`              # 乘后结果赋值给变量
            LOOP=`expr $LOOP + 1`          # 增量计数(加循环即可) LOOP=0
            expr length "bkeep zbb"        # 计算字串长度
            expr substr "bkeep zbb" 4 9    # 抓取字串
            expr index "bkeep zbb" e       # 抓取第一个字符数字串出现的位置
            expr 30 / 3 / 2                # 运算符号有空格
            expr bkeep.doc : '.*'          # 模式匹配(可以使用expr通过指定冒号选项计算字符串中字符数)
            expr bkeep.doc : '\(.*\).doc'  # 在expr中可以使用字符串匹配操作，这里使用模式抽取.doc文件附属名

            $str="123 456 789"
            expr match "$str" .*5          # 字符串指定位置截取
            echo ${str:5}
            echo ${str:5:3}
            expr substr "$str" 5 3
            
            echo ${#str}                   # 字符串长度获取
            expr length "$str"
            
            expr(数值测试){

                #如果试图计算非整数，则会返回错误
                rr=3.4
                expr $rr + 1
                expr: non-numeric argument
                rr=5
                expr $rr + 1
                6

            }

        }

        bc(用于任意精度计算的语言){
            有四个特殊变量，scale, ibase, obase, 和 last。 
            scale 定义了某些操作如何 使 用小数点后的数字。scale 的默认值是 0。 
            ibase 和 obase 定义了在输入和 输出数字之间的数制转换。输入和输出的默认基数都是 10。
            last (属于扩展)是一个变量，保存了上一次输出的数字。
                
            obase=16   设置16进制输出
            ibase=10   设置10进制输入
            65536         输入十进制 65536
            10000         输出16进制 10000
            obase      查看当前输出进制
            16
            ibase      查看当前输入进制
            
            scale=5 /*指定精度为5*/
    
echo "obase=16; ibase=10; 100" | bc
echo "obase=2; ibase=10; 100" | bc
echo "obase=16; ibase=2; 111111" | bc
echo "obase=5; ibase=10; 100" | bc

    
            echo "obase=16;65536" | bc  #10000
            echo "obase=8;65536" | bc   #200000
            echo "m^n"|bc            # 次方计算
            seq -s '+' 1000 |bc      # 从1加到1000
            seq 1 1000 |tr "\n" "+"|sed 's/+$/\n/'|bc   # 从1加到1000
            echo "scale=5;9+8-7*6/5^2"|bc
            echo "s(2/3*a(1))"|bc -l
            echo "scale=5;sqrt(15)"|bc
            echo "ibase=16;obase=2;ABC"|bc
            value=$(bc<<EOF
scale=3
r=3 3.1415*r*r
EOF)
echo $value
            echo $(seq -s "+" 10)=$(seq -s "+" 10|bc)
            echo $(seq -s "+" 10)=$(($(seq -s "+" 10)))
            echo $(seq -s "+" 10)=$(seq -s " + " 10|xargs expr)
            -expr
            ++var
            --var
            var++
            var--
            expr + expr
            expr - expr
            expr * expr
            expr / expr
            expr ^ expr
            (expr)
            var = expr
            var <op>= expr  等价于 var = var <op> expr
            expr1 < expr2
            expr1 <= expr2
            expr1 > expr2
            expr1 >= expr2
            expr1 != expr2
            !expr
            expr && expr
            expr || expr
            
            print list
            { statement_list }
            if ( expression ) statement1 [else statement2]
            while ( expression ) statement
            for ( [expression1] ; [expression2] ; [expression3] ) statement
            break
            continue
            halt
            return
            return (expression)
        }
        
        bash(整数计算)
        {
            这两个对与expr的优点是：运算符号全部不需要转义。
            echo $(( 2 + 5 )); echo $(( 2 * 5 )); echo $(( 2 - 5 )); echo $(( 2 % 5 )); 
            echo $[ 2 % 5 ] ;  echo $[ 2 - 5 ];   echo $[ 2 * 5 ];   echo $[ 2 + 5 ];
        }
        bash(keyword)
        {
            true, false, test, case, esac, break, continue, eval, exec, exit, export, readonly, return, set, 
            shift, source, time, trap, unset, time, date, do, done, if, fi, else, elif, function, for, in, 
            then, until, while, select
        }
    }
    
grep NW testfile                    #打印出testfile中所有包含NW的行。
grep '^n' testfile                  #打印出以n开头的行。
grep '4$' testfile                  #打印出以4结尾的行。
grep '5\..' testfile                #打印出第一个字符是5，后面跟着一个.字符，在后面是任意字符的行。
grep '\.5' testfile                 #打印出所有包含.5的行。
grep '^[we]' testfile               #打印出所有以w或e开头的行。
grep '[^0-9]' testfile              #打印出所有不是以0-9开头的行。
grep '[A-Z][A-Z] [A-Z]' testfile    #打印出所有包含前两个字符是大写字符，后面紧跟一个空格及一个大写字母的行。
grep '[a-z]\{9\}' testfile          #打印所有包含每个字符串至少有9个连续小写字符的字符串的行。
grep '\<north' testfile             #打印所有以north开头的单词的行。
grep '\<north\>' testfile           #打印所有包含单词north的行。
grep '^n\w*' testfile               #第一个字符是n，后面是任意字母或者数字。
    
egrep 'NW|EA' testfile              #打印所有包含NW或EA的行。
grep 'NW\|EA' testfile              #对于标准grep，如果在扩展元字符前面加\，grep会自动启用扩展选项-E。
egrep '3+' testfile
grep -E '3+' testfile
grep '3\+' testfile                 #这3条命令将会打印出相同的结果，即所有包含一个或多个3的行。
egrep '2\.?[0-9]' testfile
grep -E '2\.?[0-9]' testfile
grep '2\.\?[0-9]' testfile          #首先含有2字符，其后紧跟着0个或1个点，后面再是0和9之间的数字。
egrep '(no)+' testfile
grep -E '(no)+' testfile
grep '\(no\)\+' testfile            #3个命令返回相同结果，即打印一个或者多个连续的no的行。
egrep '[Ss](h|u)' testfile
grep -E '[Ss](h|u)' testfile
grep '[Ss]\(h\|u\)' testfile        #3个命令返回相同结果，即以S或s开头，紧跟着h或者u的行。
egrep 'w(es)t.*\1' testfile         #west开头，其中es为\1的值，后面紧跟着任意数量的任意字符，最后还有一个es出现在该行。


https://www.gnu.org/software/grep/manual/grep.html
返回值：
    0: 至少有1行匹配
    1: 没有1行匹配
    2: 发生错误
-G --basic-regexp     BRE     grep
-E --extended-regexp  ERE     egrep
-F --fixed-strings    无模式  fgrep
-P --perl-regexp      PRE
在BRE中，?, +, {, |, (, 和 ) 不作为meta-character. \?, \+, \{, \|, \(, \) 被作为 metacharacter
在ERE中，?, +, {, |, (, 中 ) 被作为meta-character. \?, \+, \{, \|, \(, \) 不作为 metacharacter
形式不同，功能相同。
https://github.com/learnbyexample/Command-line-text-processing/blob/master/gnu_grep.md

ag REGEX # search recursive 

grep_egrep_fgrep(){ cat - <<'EOF'
        egrep fgrep   # 打印匹配给定模式的行
        -?    #同时显示匹配行上下的?行，如：grep -2 pattern filename同时显示匹配行的上下2行。
        -c    # 显示匹配到得行的数目，不显示内容
        -h    # 不显示文件名 -h, --no-filename
        -H    #              -H, --with-filename
        -i    # 忽略大小写   --ignore-case
        -q，--quiet # 取消显示，只返回退出状态。0则表示找到了匹配的行。
        -l    # 只列出匹配行所在文件的文件名  -l, --files-with-matches
        -L    #                               -L, --files-without-match
        -n    # 在每一行中加上相对行号 --line-number
        -s    # 无声操作只显示报错，检查退出状态
        -v    # 反向查找          -v, --invert-match
        -w    # 精确匹配          -w, --word-regexp
        -wc   # 精确匹配次数
        -o    # 查询所有匹配字段  --only-matching
        -r    # -R, -r, --recursive
        -e    # -e PATTERN, --regexp=PATTERN  使用模式 PATTERN 作为模式；在保护以 - 为起始的模式时有用。
        -P    # 使用perl正则表达式   --perl-regexp
        -f    # -f FILE, --file=FILE 从文件 FILE 中获取模式，每行一个。空文件含有0个模式，因此不匹配任何东西。
        -G,   #                      --basic-regexp 将模式 PATTERN 作为一个基本的正则表达式
        -a    # --text 将一个二进制文件视为一个文本文件来处理；它与 --binary-files=text 选项等价
        -b,   # --byte-offset 在输出的每行前面同时打印出当前行在输入文件中的字节偏移量。
        -A3   # 打印匹配行和下三行   --after-context=NUM
        -B3   # 打印匹配行和上三行   --before-context=NUM
        -C3   # 打印匹配行和上下三行 --context=NUM
        -e<范本样式> --regexp=<范本样式>   #指定字符串做为查找文件内容的样式。   
        -E      --extended-regexp   #将样式为延伸的普通表示法来使用。
错误写法：
netstat -an|grep "ESTABLISHED|WAIT"      #默认grep不支持多条件匹配    
正确写法：
netstat -an|grep -E "ESTABLISHED|WAIT"     #加上-E 多条件用""包起来，然后多条件之间用|管道符分开
netstat -an|grep -e ESTABLISHED -e WAIT    #而-e呢不用""包起来，-e 指定一个匹配条件
        
        fgrep # grep -F  所有的字母都看作单词，也就是说，正则表达式中的元字符表示回其自身的字面意义
        egrep # grep -E --extended-regexp 支持更多的re元字符
        rgrep # grep -r
        agrep (approximate grep) #grep的模糊匹配版本
        zgrep #对压缩文件进行grep, 接受的选项和grep完全一样
        sgrep (structured grep) #对结构化的文本, 如SGML、XML、HTML进行搜索、抽取, 功能非常强大
        nrgrep (Nondeterministic Reverse grep) #类似agrep

        grep -i pattern files   # 不区分大小写地搜索。默认情况区分大小写，
4. File names in output
        grep -l pattern files   # 只列出匹配的文件名，
        grep -L pattern files   # 列出不匹配的文件名，
        grep -h pattern files   # 不显示文件名
        grep -H pattern files   # 显示文件名
5. Match whole word or line
        grep -w pattern files   # 只匹配整个单词，而不是字符串的一部分(如匹配‘magic’，而不是‘magical’)，
        grep -x pattern files   # 全行匹配
        
        grep -C number pattern files        # 匹配的上下文分别显示[number]行，
        grep pattern1 | pattern2 files      # 显示匹配 pattern1 或 pattern2 的行，
        grep pattern1 files | grep pattern2 # 显示既匹配 pattern1 又匹配 pattern2 的行。
6. Get only matching portion
        grep -oi '[a-z]*' poem.txt | sort            # 以单词换行输出
        grep -o 'are' poem.txt         # 查询所有匹配字段
        grep -o 'e' poem.txt | wc -l   # 查询所有匹配字段
        
        grep -v "a" txt                              # 过滤关键字符行
        grep -w 'a\>' txt                            # 精确匹配字符串
        grep -i "a" txt                              # 大小写敏感
        grep  "a[bB]" txt                            # 同时匹配大小写
        grep '[0-9]\{3\}' txt                        # 查找0-9重复三次的所在行
        grep -E "word1|word2|word3"   file           # 任意条件匹配
        grep word1 file | grep word2 |grep word3     # 同时匹配三个
        grep linuxtechi /etc/passwd /etc/shadow /etc/gshadow #在多个文件中查找模式
        grep -l linuxtechi /etc/passwd /etc/shadow /etc/fstab /etc/mtab #使用-l参数列出包含指定模式的文件的文件名
        
        grep -B 4"games" /etc/passwd #a)使用-B参数输出匹配行的前4行
        grep -A 4"games" /etc/passwd #b)使用-A参数输出匹配行的后4行
        grep -C 4"games" /etc/passwd #c)使用-C参数输出匹配行的前后各4行
        
        grep '\*\*' file # grep '\*\*' *.html */*.html >filtered.txt
        
        echo quan@163.com |grep -Po '(?<=@.).*(?=.$)'                           # 零宽断言截取字符串  #　63.co
        echo "I'm singing while you're dancing" |grep -Po '\b\w+(?=ing\b)'      # 零宽断言匹配
        echo 'Rx Optical Power: -5.01dBm, Tx Optical Power: -2.41dBm' |grep -Po '(?<=:).*?(?=d)'           # 取出d前面数字 # ?为最小匹配
        echo 'Rx Optical Power: -5.01dBm, Tx Optical Power: -2.41dBm' | grep -Po '[-0-9.]+'                # 取出d前面数字 # ?为最小匹配
        echo '["mem",ok],["hardware",false],["filesystem",false]' |grep -Po '[^"]+(?=",false)'             # 取出false前面的字母
        echo '["mem",ok],["hardware",false],["filesystem",false]' |grep -Po '\w+",false'|grep -Po '^\w+'   # 取出false前面的字母

        grep -F -x -v -f /tmp/partmap.bootdisk /tmp/partmap.image # 通过grep进行文件比对;
                                                                  # 文件内容相同，则返回$? = 1 没有打印输出，否则有打印输出，返回 $? = 0 
EOF
}
}
        grep用于if判断{
            if echo abc | grep "a"  > /dev/null 2>&1
            then
                echo "abc"
            else
                echo "null"
            fi
        }

grep -rnw '/path/to/somewhere/' -e 'pattern'
grep --include=\*.{c,h} -rnw '/path/to/somewhere/' -e "pattern"
grep --exclude=*.o -rnw '/path/to/somewhere/' -e "pattern"
grep --exclude-dir={dir1,dir2,*.dst} -rnw '/path/to/somewhere/' -e "pattern"

        inotifywait,socat,inotifywatch, glob(7) regcomp
        suffixes(7) cscope xcscope make(1p) lex(1p) yacc(1p) cflow(1p)
# cat directory any write
inotifywait -qme close_write . | while read -r fil ; do cat $fil ; done

grep_pattern(){ cat - <<'EOF'
基本的构造块是匹配单个字符的正则表达式。
大部分字符，包括所有字母和数字，是匹配它们自身的正则表达式。
任何具有特殊含义的元字符可以通过前置一个反斜杠来引用。
  1. 方括号表达式是一个字符序列，放在[和]当中。它匹配序列中的任何一个字符；如果序列中的第一个字符是脱字符^那么它匹配 不在序列中的任何一个字符。
例如，正则表达式 [0123456789] 匹配任何一个数字。
     在方括号表达式之中，一个范围表达式由两个字符组成，中间用一个连字符分隔。它匹配在这两个字符之间的任何一个字符，使用本地化的序列顺序和字符集。
例如，在默认的C locale中[a-d]与[abcd]等价。
     最后，在方括号表达式中有一些预定义的字符类，如下所示。它们的名字是自说明的，它们是
     [:alpha:] [:cntrl:] [:digit:] [:graph:] [:lower:] [:print:] [:punct:] [:space:] [:upper:] [:xdigit:] 
例如， [[:alnum:]]  意思是  [0-9A-Za-z]  ，但是后一种表示方法依赖于locale C和ASCII字符编码，
     为了包含一个字面意义的]，需要将它放在序列的最前。
     为了包含一个字面意义的^，需要将它放在除了序列最前之外的其他位置。
     为了包含一个字面意义的-，需要将它放在序列最后。
  2. 句点符 (period) .  匹配任何一个字符。
  3. 符号 \w 是 [[:alnum:]] 的同义词， 
  4. 符号 \W 是 [^[:alnum]] 的同义词。
  5. 脱字符^ 和美元标记$ 分别是匹配一行的首部和尾部的空字串的元字符。
  6. 符号 \< 和 \> 分别是匹配一个词的首部和尾部的空字串的元字符.
  7. \b匹配一个词边缘的空字串，符号 \B 匹配不处于一个词的边缘的空字串。
  8. 一个正则表达式后面可以跟随多种重复操作符之一。
       ?      先前的项是可选的，最多匹配一次。
       *      先前的项可以匹配零次或多次。
       +      先前的项可以匹配一次或多次。
       {n}    先前的项将匹配恰好 n 次。
       {n,}   先前的项可以匹配 n 或更多次。
       {n,m}  先前的项将匹配至少 n 词，但是不会超过 m 次。
  9. 两个正则表达式可以连接到一起；得出的正则表达式可以匹配任何由两个分别匹配连接前的子表达式的子字符串连接而成的字符串。
  10. 两个正则表达式可以用中缀操作符 | 联合到一起，得出的正则表达式可以匹配任何匹配联合前的任何一个子表达式的字符串
  11. 重复操作符的优先级比连接高，接下来又比选择的优先级高。一个完整的子表达式可以用圆括号括住来超越这些优先级规则。
a. Basic vs Extended Regular Expressions
  12. 在基本正则表达式中，元字符?,  +,  {, |, (, 和 )丧失了它们的特殊意义；作为替代，使用加反斜杠的 (backslash) 版本 \?, \+,
     \{, \|, \(, 和 \) 。
  13. 传统的egrep不支持元字符{，并且一些egrep的实现通过支持\{来代替它，因此可移植的脚本应当避免在egrep中使用  {
     模式，应当使用 [{] 来匹配一个字面意义的 { 。
GNU egrep 通过假设如果 { 处于 an invalid interval specification 的起始，就不是一个特殊字符，来支持传统的用法。例如，shell
命令egrep '{1' 将会搜索这个两字符的字符串{1而不是报告在正则表达式中发生了语法错误。
       
       grep -E "[a-z]+" filename 和 egrep "[a-z]+" filename;
       }
EOF
}

tr_man_demo(){ 
翻译和删除字符的功能
    translate or delete characters
    
        -c          # 用字符串1中字符集的补集替换此字符集，要求字符集为ASCII
        -d          # 删除字符串1中所有输入字符
        -s          # 删除所有重复出现字符序列，只保留第一个:即将重复出现字符串压缩为一个字符串
        [a-z]       # a-z内的字符组成的字符串
        [A-Z]       # A-Z内的字符组成的字符串
        [0-9]       # 数字串
        \octal      # 一个三位的八进制数，对应有效的ASCII字符
        [O*n]       # 表示字符O重复出现指定次数n。因此[O*2]匹配OO的字符串
        tr中特定控制字符表达方式{

            \a Ctrl-G    \007    # 铃声
            \b Ctrl-H    \010    # 退格符
            \f Ctrl-L    \014    # 走行换页
            \n Ctrl-J    \012    # 新行
            \r Ctrl-M    \015    # 回车
            \t Ctrl-I    \011    # tab键
            \v Ctrl-X    \030

        }
        cat /proc/3994/environ | tr '\0' '\n'  # 查看环境变量
https://github.com/learnbyexample/Command-line-text-processing/blob/master/miscellaneous.md
1. translation
echo 'foo bar cat baz' | tr 'abc' '123'
echo 'foo bar cat baz' | tr 'a-f' '1-6'
echo 'foo bar cat baz' | tr 'a-z' 'A-Z'
echo 'Hello World' | tr 'a-zA-Z' 'A-Za-z'
echo 'foo;bar;baz' | tr ';' ':'
tr 'a-z' 'A-Z' < marks.txt
1.1 if arguments are of different lengths 
1.1.1 when second argument is longer, the extra characters are ignored
echo 'foo bar cat baz' | tr 'abc' '1-9'
1.1.2 when first argument is longer the last character of second argument gets re-used
echo 'foo bar cat baz' | tr 'a-z' '123'
2. escape sequences and character classes
cat /proc/3994/environ | tr '\0' '\n'  # 查看环境变量
printf 'foo\tbar\t123\tbaz\n' | tr '\t' ':'
echo 'foo:bar:123:baz' | tr ':' '\n'
echo '/foo-bar/baz/report' | tr -- '-a-z' '_A-Z'
3. deletion
echo '2017-03-21' | tr -d '-'
echo 'Hi123 there. How a32re you' | tr -d '1-9'
echo '"Foo1!", "Bar.", ":Baz:"' | tr -d '[:punct:]'
tr -d '\r' < greeting.txt | cat -v
echo '"Foo1!", "Bar.", ":Baz:"' | tr -cd '[:alpha:],\n'

echo hello 1 char 2 next 4 | tr -d -c '0-9\n' # 补集

4. squeeze
echo 'FFoo seed 11233' | tr -s 'a-z'
echo 'FFoo seed 11233' | tr -s '[:alnum:]'
echo 'FFoo seed 11233' | tr -sc '[:alpha:]'
echo 'FFoo seed 11233' | tr -s 'A-Z' 'a-z'
printf 'foo\t\tbar \t123     baz\n' | tr -s '[:blank:]' ' '

        tr -d '0-9'       # 删除指定集合中的字符, 
        tr -d -c '0-9 \n' # 将不在集合中的所有字符删除,
        tr -s ' '         # 将连续空格压缩为一个空格
        
        tr A-Z a-z                             # 将所有大写转换成小写字母
        tr " " "\n"                            # 将空格替换为换行
        tr -s "[\012]" < plan.txt              # 删除空行
        tr -s ["\n"] < plan.txt                # 删除空行
        tr -s "[\015]" "[\n]" < file           # 删除文件中的^M，并代之以换行
        tr -s "[\r]" "[\n]" < file             # 删除文件中的^M，并代之以换行
        tr -s "[:]" "[\011]" < /etc/passwd     # 替换passwd文件中所有冒号，代之以tab键
        tr -s "[:]" "[\t]" < /etc/passwd       # 替换passwd文件中所有冒号，代之以tab键
        echo $PATH | tr ":" "\n"               # 增加显示路径可读性
        1,$!tr -d '\t'                         # tr在vi内使用，在tr前加处理行范围和感叹号('$'表示最后一行)
        tr "\r" "\n"<macfile > unixfile        # Mac -> UNIX
        tr "\n" "\r"<unixfile > macfile        # UNIX -> Mac
        tr -d "\r"<dosfile > unixfile          # DOS -> UNIX  Microsoft DOS/Windows 约定，文本的每行以回车字符(\r)并后跟换行符(\n)结束
        awk '{ print $0"\r" }'<unixfile > dosfile   # UNIX -> DOS：在这种情况下，需要用awk，因为tr不能插入两个字符来替换一个字符

echo "thIs iSS aa Test" | tr "[:lower:]" "[:upper:]"   # out: THIS ISS AA TEST           (1)
echo "thIs iSS aa Test" | tr "a-z" "A-Z"               # out: THIS ISS AA TEST           (2)
echo "thIs iSS aa Test" | tr -s "a-zA-Z"               # out: thIs iS a Test             (3)
echo "thIs iSS aa Test" | tr -s "a-zA-Z" "a-za-z"      # out: this is a test             (4)
echo "thIs iSS aa Test" | tr -d "a-z"                  # out: I SS  T                    (5)
echo "thIs iSS aa Test" | tr -cd "a-z\n\40"            # out: ths i aa est               (6)
}
 
touch_demo(){
atime|mtime|ctime
-c：强制不创建文件
-a：修改文件access time(atime)
-m：修改文件modification time(mtime)
-t：使用"[[CC]YY]MMDDhhmm[.ss]"格式的时间替代当前时间
-d：使用字符串描述的时间格式替代当前时间
1. Creating empty file
touch -c foo.txt # 修改时间，不修改文件
# access and modification timestamp to current time
2. Updating timestamps
stat -c %x fruits.txt & stat -c %y fruits.txt
touch fruits.txt 
stat -c %x fruits.txt & stat -c %y fruits.txt

touch -a greeting.txt # atime && ctime
touch -m sample.txt   # mtime && ctime
touch -c sample.txt   # mtime && ctime && atime
3. Using timestamp from another file to update
touch -r power.log report.log             # 两个文件之间同步时间
4. Using date string to update
touch -d '2010-03-17 17:04:23' report.log # 通过字符串更新
touch -d "2016-09-22" filename  # 也用-c -m参数，表示更改文件访问时间和内容修改时间
touch -a -t 201212211212 file # 将file文件的atime修改为2012年12月21号12点12分
}

seq_man_demo(){ 
    打印一个字符序列
    输出一系列整数或实数，适用于其他程序的管道。
seq [OPTION]... LAST                  # 指定输出的结尾数字，初始值和步长默认都为1
seq [OPTION]... FIRST LAST            # 指定开始和结尾数字，步长默认为1
seq [OPTION]... FIRST INCREMENT LAST  # 指定开始值、步长和结尾值

OPTION：
    # 不指定起始数值，则默认为 1
    -s   # 选项主要改变输出的分格符, 预设是 \n
    -w   # 根据需要打印前导零，以使所有行的宽度相同。
    -f   # 格式化输出，就是指定打印的格式
        seq 5                    # 生成序列从1到5的数字
        seq 10 100               # 列出10-100
        seq 3 3 10               # 生成序列3到10中间隔多少个数字
        seq -w 10                # 生成两位数的数字并对齐；不足补零
        seq -w 008 010           # 生成两位数的数字并对齐；不足补零
        seq 1 10 |tac            # 倒叙列出
        seq -s '+' 90 100 | bc   # 从90加到100
        seq -f 'dir%g' 1 10 | xargs mkdir     # 创建dir1-10
        seq -f 'dir%03g' 1 10 | xargs mkdir   # 创建dir001-010
        seq -f'%.3f' -s':' -2 0.75 3
        seq -f'%.3e' 1.2e2 1.22e2
        seq 0.5 2.5
        seq -s':' -2 0.75 3
        seq 1.2e2 1.22e2
        
        一行命令算术运算
        seq 100 | echo $[ $(tr '\n' '+') 0]
        seq 5 3 20 | echo $[ $(tr '\n' '*') 1]
}

trap_help_demo(){
http://www.cnblogs.com/f-ck-need-u/p/7454174.html
        信号         说明
        HUP(1)     # 挂起，通常因终端掉线或用户退出而引发
        INT(2)     # 中断，通常因按下Ctrl+C组合键而引发
        QUIT(3)    # 退出，通常因按下Ctrl+\组合键而引发
        ABRT(6)    # 中止，通常因某些严重的执行错误而引发
        ALRM(14)   # 报警，通常用来处理超时
        TERM(15)   # 终止，通常在系统关机时发送

        trap捕捉到信号之后，可以有三种反应方式：
            1、执行一段程序来处理这一信号
            2、接受信号的默认操作
            3、忽视这一信号

        第一种形式的trap命令在shell接收到 signal list 清单中数值相同的信号时，将执行双引号中的命令串：
        trap 'commands' signal-list   # 单引号，要在shell探测到信号来的时候才执行命令和变量的替换，时间一直变
        trap "commands" signal-list   # 双引号，shell第一次设置信号的时候就执行命令和变量的替换，时间不变
        
        trap 'commands' signal-list   # 当脚本收到signal-list清单内列出的信号时,trap命令执行双引号中的命令.
        trap signal-list              # trap不指定任何命令,接受信号的默认操作.默认操作是结束进程的运行.
        trap ' ' signal-list          # trap命令指定一个空命令串,允许忽视信号.
        trap - signal list            # 恢复到默认信号处理
}

    
posix(){
C API http://pubs.opengroup.org/onlinepubs/9699919799/functions/contents.html
CLI   http://pubs.opengroup.org/onlinepubs/9699919799/utilities/contents.html
Shell http://pubs.opengroup.org/onlinepubs/9699919799/utilities/V3_chap02.html#tag_18
Environment Variables http://pubs.opengroup.org/onlinepubs/9699919799/basedefs/V1_chap08.html#tag_08
Program exit status   http://pubs.opengroup.org/onlinepubs/9699919799/utilities/V3_chap02.html#tag_18_08
Regular Expressions   http://pubs.opengroup.org/onlinepubs/9699919799/basedefs/V1_chap09.html#tag_09
Directory struture    http://pubs.opengroup.org/onlinepubs/9699919799/basedefs/V1_chap10.html#tag_10
Filenames             http://pubs.opengroup.org/onlinepubs/9699919799/basedefs/V1_chap03.html#tag_03_267
Command line utility API conventions http://pubs.opengroup.org/onlinepubs/9699919799/basedefs/V1_chap12.html
POSIX ACLs
}

pattern_awk(){
Element     ERE          BRE             awk
Group       ( and )      \( and \)       ( and ) 
1 or more  + or {1,}     \+ or \{1,\}    +
0 or 1     ? or {0,1}    \? or \{0,1\}   ?
N          {N}           \{N\}           Not portable *
N or less  {,N}          \{,N\}          Not portable *
OR         ∣            \∣             |
单词边界  \< and \>     \< and \> (same) Not portable *

以下特殊字符用于形成扩展正则表达式：
1. +   指定如果一个或多个字符或扩展正则表达式的具体值(在 +(加号)前)在这个字符串中，则字符串匹配。命令行：
awk '/smith+ern/' testfile
将包含字符 smit，后跟一个或多个 h 字符，并以字符 ern 结束的字符串的任何记录打印至标准输出。此示例中的输出是：
smithern, harry
smithhern, anne

2. ?    指定如果零个或一个字符或扩展正则表达式的具体值(在?(问号)之前)在字符串中，则字符串匹配。命令行：
awk '/smith?/' testfile
将包含字符 smit，后跟零个或一个 h 字符的实例的所有记录打印至标准输出。此示例中的输出是：
smith, alan
smithern, harry
smithhern, anne
smitters, alexis

3. | 指定如果以 |(垂直线)隔开的字符串的任何一个在字符串中，则字符串匹配。命令行：
awk '/allen 
| 
alan /' testfile
将包含字符串 allen 或 alan 的所有记录打印至标准输出。此示例中的输出是：
smiley, allen
smith, alan

3. ( )  在正则表达式中将字符串组合在一起。命令行：
awk '/a(ll)?(nn)?e/' testfile
将具有字符串 ae 或 alle 或 anne 或 allnne 的所有记录打印至标准输出。此示例中的输出是：
smiley, allen
smithhern, anne

4. {m}  指定如果正好有 m 个模式的具体值位于字符串中，则字符串匹配。命令行：
awk '/l{2}/' testfile
打印至标准输出
smiley, allen

5. {m,}     指定如果至少 m 个模式的具体值在字符串中，则字符串匹配。命令行：
awk '/t{2,}/' testfile
打印至标准输出：
smitters, alexis

6. {m, n}   指定如果 m 和 n 之间(包含的 m 和 n)个模式的具体值在字符串中(其中m <= n)，则字符串匹配。命令行：
awk '/er{1, 2}/' testfile
打印至标准输出：
smithern, harry
smithern, anne
smitters, alexis

7. [String]     指定正则表达式与方括号内 String 变量指定的任何字符匹配。命令行：
awk '/sm[a-h]/' testfile
将具有 sm 后跟以字母顺序从 a 到 h 排列的任何字符的所有记录打印至标准输出。此示例的输出是：
smawley, andy

8. [^ String]   在 [ ](方括号)和在指定字符串开头的 ^ (插入记号) 指明正则表达式与方括号内的任何字符不匹配。这样，命令行：
awk '/sm[^a-h]/' testfile
打印至标准输出：
smiley, allen
smith, alan
smithern, harry
smithhern, anne
smitters, alexis

9. ~,!~     表示指定变量与正则表达式匹配(代字号)或不匹配(代字号、感叹号)的条件语句。命令行：
awk '$1 ~ /n/' testfile
将第一个字段包含字符 n 的所有记录打印至标准输出。此示例中的输出是：
smithern, harry
smithhern, anne

10. ^   指定字段或记录的开头。命令行：
awk '$2 ~ /^h/' testfile
将把字符 h 作为第二个字段的第一个字符的所有记录打印至标准输出。此示例中的输出是：
smithern, harry

11. $   指定字段或记录的末尾。命令行：
awk '$2 ~ /y$/' testfile
将把字符 y 作为第二个字段的最后一个字符的所有记录打印至标准输出。此示例中的输出是：
smawley, andy
smithern, harry

12. . (句号)  表示除了在空白末尾的终端换行字符以外的任何一个字符。命令行：
awk '/a..e/' testfile
将具有以两个字符隔开的字符 a 和 e 的所有记录打印至标准输出。此示例中的输出是：
smawley, andy
smiley, allen
smithhern, anne

13. * (星号) 表示零个或更多的任意字符。命令行：
awk '/a.*e/' testfile
将具有以零个或更多字符隔开的字符 a 和 e 的所有记录打印至标准输出。此示例中的输出是：
smawley, andy
smiley, allen
smithhern, anne
smitters, alexis

14. \ (反斜杠)     转义字符。当位于在扩展正则表达式中具有特殊含义的任何字符之前时，转义字符除去该字符的任何特殊含义。例如，命令行：
/a\/\//
将与模式 a // 匹配，因为反斜杠否定斜杠作为正则表达式定界符的通常含义。要将反斜杠本身指定为字符，则使用双反斜杠。

B. 扩展部分
\y         matches the empty string at either the beginning or the end of a word.
\B         matches the empty string within a word.
\<         matches the empty string at the beginning of a word.
\>         matches the empty string at the end of a word.
\w         matches any word-constituent character (letter, digit, or underscore).
\W         matches any character that is not word-constituent.
\?         matches the empty string at the beginning of a buffer (string).
\?         matches the empty string at the end of a buffer.
C. POSIX 扩展字符集
}

pattern_sed(){
1. 基础正则表达式(BRE)中的元字符：
\   转义符，若后接特殊字符，则将该特殊字符视为普通字符；若后接普通字符，则将该字符和、的组合视为具有特殊含义的非打印字符。
  \n 匹配换行符。
  \\ 匹配 \。
  \( 则匹配 )
^           # 锚定行的开始 如：/^sed/匹配所有以sed开头的行。 
$           # 锚定行的结束 如：/sed$/匹配所有以sed结尾的行。 
.           # 匹配任意一个字符(可单独使用) -- 不包括换行 如：/s.d/匹配s后接一个任意字符，然后是d。 
*           # 匹配任意多个前导字符(不可单独使用) 如：/ *sed/匹配所有模板是一个或多个空格后紧跟sed的行。 
[]          # 匹配一个指定范围内的字符，如/[Ss]ed/匹配sed和Sed。 
[^]         # 匹配一个不在指定范围内的字符，如：/[^A-RT-Z]ed/匹配不包含A-R和T-Z的一个字母开头，紧跟ed的行。 
[-]         # 匹配方括号内字符范围中的任意一个字符。
注意: ]视为普通字符，必须放在首位，- 视为普通字符，必须放在首位或末尾，^ 视为普通字符，不能放在首位
      $, *, ., [, \, 被视为普通字符
\<          # 锚定单词的开始，如:/\<love/匹配包含以love开头的单词的行。
\>          # 锚定单词的结束，如/love\>/匹配包含以love结尾的单词的行。
# 转义之后实现元字符功能
\?           # 匹配 0 个或 1 个前导字符(不可单独使用)。 egrep 'ab?c' file 可匹配 ac 和 abc；
\+           # 匹配 1 个或多个前导字符(不可单独使用).   egrep 'ab+c' file 可匹配 abc、abbc、abbbbbbc 等。
x\{m\}       # 重复字符x，m次，如：/0\{5\}/匹配包含5个o的行。      m=[0,255]
x\{m,\}      # 重复字符x,至少m次，如：/o\{5,\}/匹配至少有5个o的行。
x\{m,n\}     # 重复字符x，至少m次，不多于n次，如：/o\{5,10\}/匹配5--10个o的行。
\(regexp\)   # 匹配模式 regexp
regexp1\|regexp2 # 匹配 reexp1 或 regexp2
&           # 保存搜索字符用来替换其他字符，如s/love/**&**/，love这成**love**。 
\DIGIT      # 用以引用前面\( \)中的匹配内容
sed -E -n '/^(.)o\1$/p' /usr/share/dict/words           # bob
sed -E -n '/^(.)(.)(.)\3\2\1$/p' /usr/share/dict/words  # redder
echo "James Bond" | sed -E 's/(.*) (.*)/The name is \2, \1 \2./' # The name is Bond, James Bond.
\n          # 匹配换行

\xxx
echo 'a^c' | sed 's/^/b/'    # ba^c 
echo 'a^c' | sed 's/\x5e/b/' # ba^c
echo abc | sed 's/[a]/x/'       # xbc
echo abc | sed 's/\x5ba\x5d/x/' # xbc
echo 'a^c' | sed 's/\^/b/'     # abc
echo 'a^c' | sed 's/\\\x5e/b/' # a^c
2. 扩展正则表达式
2.1 限定符(确定重复次数)
?           # 匹配 0 个或 1 个前导字符(不可单独使用)。 egrep 'ab?c' file 可匹配 ac 和 abc；
+           # 匹配 1 个或多个前导字符(不可单独使用).   egrep 'ab+c' file 可匹配 abc、abbc、abbbbbbc 等。
x{m}      # 重复字符x，m次，如：/0\{5\}/匹配包含5个o的行。      m=[0,255]
x{m,}     # 重复字符x,至少m次，如：/o\{5,\}/匹配至少有5个o的行。
x{m,n}    # 重复字符x，至少m次，不多于n次，如：/o\{5,10\}/匹配5--10个o的行。

注意
限定符没有 {,m} 的写法。
*、+和?限定符都是贪婪的，因为它们会尽可能多的匹配文字，只有在它们的后面加上一个 ? 就可以实现非贪婪或最小匹配。
不能对定位符（^、$、\b、\B）使用限定符。
2.2 () 分组  # egrep 'a(boy)+c' file 可匹配 aboyc, aboyboyboyc 等。
\(..\)       # 保存匹配的字符，如s/\(love\)able/\1rs，loveable被替换成lovers。
             # 使用1: \(abcd\)*; 使用2: 后续引用
2.3 |  或   REGEXP1\|REGEXP2 
grep '^[a-z]{3}|(abc)$' file;      # x 
grep '^[a-z]\{3\}\|\(abc\)$' file; # √
另外，若在支持 ERE 的工具(如 egrep)中，在 ERE 特有元字符前加上转义符，则该元字符不发挥其特殊作用，被视为普通字符匹配。
\w   单个单词字符(字母、数字与_)      [0-9a-zA-Z_] or [[:alnum:]_]
echo "abc %-= def." | sed 's/\w/X/g'  # XXX %-= XXX.
\W   单个非单词字符                   [^0-9a-zA-Z_] or [^[:alnum:]_]
echo "abc %-= def." | sed 's/\W/X/g'  # abcXXXXXdefX
\b   单词边界
echo "abc %-= def." | sed 's/\b/X/g'  # XabcX %-= XdefX.
\B   非单词边界
echo "abc %-= def." | sed 's/\B/X/g'  # aXbXc X%X-X=X dXeXf.X
\s   单个空白字符                     [[:space:]]
echo "abc %-= def." | sed 's/\s/X/g'  # abcX%-=Xdef.
\S   单个非空白字符                   [^[:space:]]
echo "abc %-= def." | sed 's/\S/X/g'  # XXX XXX XXXX
\<   beginning word
echo "abc %-= def." | sed 's/\</X/g'  # Xabc %-= Xdef.
\>   end word
echo "abc %-= def." | sed 's/\>/X/g'  # abcX %-= defX.
\`
printf "a\nb\nc\n" | sed 'N;N;s/^/X/gm'
Xa
Xb
Xc
printf "a\nb\nc\n" | sed 'N;N;s/\`/X/gm'
Xa 
b 
c
\'
printf "a\nb\nc\n" | sed "N;N;s/\'/X/gm"  
a 
b 
Xc

1. BRE VS ERE
? + () {} | 在BRE中不是特殊字符串，在ERE中是特殊字符
Basic (BRE) Syntax       | Extended (ERE) Syntax
$ echo 'a+b=c' > foo     | $ echo 'a+b=c' > foo
$ sed -n '/a+b/p' foo    | $ sed -E -n '/a\+b/p' foo
a+b=c                    | a+b=c
-----------------------------------------------------
$ echo aab > foo         | $ echo aab > foo 
$ sed -n '/a\+b/p' foo   | $ sed -E -n '/a+b/p' foo
aab                      | aab

abc?             abc(零个或一个c)   | abc?
c\+              c(一个或多个c)     | c+
a\{3,\}          a(3个或更多a)      | a{3,}
\(abc\)\{2,3\}   (abc)(2个或3个abc) | (abc){2,3}
\(abc*\)\1       (abc*)(abc*)       | (abc*)\1
a\|b             a或b               | a|b


echo "foo and bar and baz land good" | sed 's/foo.*ba/123 789/'        # 123 789z land good
echo "foo and bar and baz land good" | sed -E 's/foo \w+ ba/123 789/'  # 123 789r and baz land good
echo "foo and bar and baz land good" | perl -pe 's/foo.*?ba/123 789/'  # 123 789r and baz land good

echo 'foo=123,baz=789,xyz=42' | sed 's/foo=.*,//'    # xyz=42
echo 'foo=123,baz=789,xyz=42' | sed 's/foo=[^,]*,//' # baz=789,xyz=42

echo 'get {} and let' | sed 's/{}/[]/'          # get [] and let
echo 'get {} and let' | sed 's/\{\}/[]/'

echo 'like 42 and 37' | sed -E 's/\d+/xxx/g'    # like 42 anxxx 37
echo 'like 42 and 37' | sed 's/[0-9]+/xxx/g'    # like 42 and 37
echo 'like 42 and 37' | sed  's/[0-9]\+/xxx/g'  # like xxx and xxx
echo 'like 42 and 37' | sed -E 's/[0-9]+/xxx/g' # like xxx and xxx

printf 'foo bar \n123 789\t\n' | sed -E 's/\w+$/xyz/'
foo bar 
123 789 
printf 'foo bar \n123 789\t\n' | sed 's/\([a-z0-9]*[\t ]*\)$/xyz/'  或
printf 'foo bar \n123 789\t\n' | sed 's/\([a-z0-9]*[\t ]\+\)$/xyz/' 或
printf 'foo bar \n123 789\t\n' | sed 's/\([a-z0-9]\+[\t ]\+\)$/xyz/' 或
printf 'foo bar \n123 789\t\n' | sed -E 's/\w+\s*$/xyz/'
foo xyz 
123 xyz 
}

pattern_grep(){
1. grep正则表达式元字符集(基本集)
.       # 匹配任一一个字符
*       # 匹配零个或多个先前字符 
?       # 匹配其前面的字符0次或者1次；
+       # 匹配其前面的字符1次或者多次； [egrep 或  grep -E]
x{m}    # 重复字符x，m次，如：'0\{5\}'匹配包含5个o的行。 
x{m,}   # 重复字符x,至少m次，如：'o\{5,\}'匹配至少有5个o的行。 
x{,n}   # 重复字符x,至多m次，
x{m,n}  # 重复字符x，至少m次，不多于n次，如：'o\{5,10\}'匹配5--10个o的行。
|  或   REGEXP1\|REGEXP2 

2. 字符集
2.1 自定义字符集
'[]'    #  匹配一个指定范围内的字符 
'[^]'   # 匹配指定范围外的任意单个字符
2.2. POSIX字符类
为了在不同国家的字符编码中保持一至，POSIX(The Portable Operating System Interface)增加了特殊的字符类，
如[:alnum:]是A-Za-z0-9的另一个写法。要把它们放到[]号内才能成为正则表达式，如[A-Za-z0-9]或[[:alnum:]]。
在linux下的grep除fgrep外，都支持POSIX的字符类。
[:alnum:] # 文字数字字符                       [a-zA-Z0-9]
[:alpha:] # 文字字符                           [a-zA-Z]
[:digit:] # 数字字符                           [0-9]
[:graph:] # 非空字符(非空格、控制字符)         [:alnum:] and [:punct:]
[:lower:] # 小写字符                           [a-z]
[:cntrl:] # 控制字符                           first 32 ASCII characters and 127th (DEL)
[:print:] # 非空字符(包括空格)                 [:alnum:], [:punct:] and space
[:punct:] # 标点符号                           All the punctuation characters
[:space:] # 所有空白字符(新行，空格，制表符)   tab, newline, vertical tab, form feed, carriage return and space
[:blank:] #                                    Space and tab characters
[:upper:] # 大写字符                           [A-Z]
[:xdigit:] # 十六进制数字(0-9，a-f，A-F)       [0-9a-fA-F]

[[:alnum:]] # 文字数字字符

3. 转义
\b    # 单词锁定符，如: '\bgrep\b'只匹配grep。
\brat\b 匹配 rat
\B    # 单词不锁定符，
\Brat\B 匹配 crate
\w    # 匹配文字和数字字符，也就是[0-9a-zA-Z_]，如：'G\w*p'匹配以G后跟零个或多个文字或数字字符，然后是p。[0-9a-zA-Z_]
\W    # \w的反置形式，匹配一个或多个非单词字符，如点号句号等。                                           [^0-9a-zA-Z_]
\<    # 到匹配正则表达式的行开始，如:'\<grep'匹配包含以grep开头的单词的行。
\>    # 到匹配正则表达式的行结束，如'grep\>'匹配包含以grep结尾的单词的行。
\s    # 单个空白字符        [[:space:]]
\S    # 单个非空白字符      [^[:space:]]
4. 锚点
^ #匹配行的开始 如：'^grep'匹配所有以grep开头的行。    
$  #匹配行的结束 如：'grep$'匹配所有以grep结尾的行。

5. 引用
\DIGIT      # 用以引用前面\( \)中的匹配内容

基本集中'?', '+', '{', '|','(', 和 ')' 不具有特殊意义，如使其具有特殊意义，需要转义'\?', '\+', '\{', '\|','\(', 和 ')'
egrep 传统上不知 { 元字符，有些支持 { 元字符，所有应该避免使用元字符 '{'
grep -E 使用[\{] 来匹配 '{' 字符

grep -w -e '\(.\)\(.\).\2\1' file
grep -E -e '^(.?)(.?)(.?)(.?)(.?)(.?)(.?)(.?)(.?).?\9\8\7\6\5\4\3\2\1$' file
netstat -an|grep -E "ESTABLISHED|WAIT"     #加上-E 多条件用""包起来，然后多条件之间用|管道符分开
6. 用于egrep和 grep -E的元字符扩展集
+
    匹配一个或多个先前的字符。如：'[a-z]+able'，匹配一个或多个小写字母后跟able的串，如loveable,enable,disable等。
    匹配零个或多个先前的字符。如：'gr p'匹配gr后跟一个或没有字符，然后是p的行。
a|b|c
    匹配a或b或c。如：grep|sed匹配grep或sed
()
    分组符号，如：love(able|rs)ov+匹配loveable或lovers，匹配一个或多个ov。
x{m},x{m,},x{m,n} # 这是grep -E或egrep的格式，如果是grep格式如下:
    作用同x\{m\},x\{m,\},x\{m,n\}

Element    ERE          BRE
Group      ( and )      \( and \)
1 or more + or {1,}     \+ or \{1,\}
0 or 1    ? or {0,1}    \? or \{0,1\}
N         {N}           \{N\}
N or less {,N}          \{,N\}
OR        ∣            \∣
单词边界  \< and \>     \< and \> (same)

positive lookahead (?=
negative lookahead (?!
positive lookbehind (?<=
negative lookbehind (?<!
}

# regrex 实例
[A-Za-z0-9._]+@[A-Za-z0-9.]+\.[a-zA-Z]{2,4}  # 匹配电子邮件地址的正则表达式
egrep -o '[A-Za-z0-9._]+@[A-Za-z0-9.]+\.[a-zA-Z]{2,4}' url_email.txt
http://[a-zA-Z0-9.]+\.[a-zA-Z]{2,3}          # 匹配URL的正则表达式
egrep -o "http://[a-zA-Z0-9.]+\.[a-zA-Z]{2,3}" url_email.txt

[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3} # 匹配IP地址
( +[a-zA-Z]+ +)                                # 匹配任意单词
第一个+和最后一个+表示匹配一个或多个空格


正则表达式 -> 文本查找 和 文本替换
两者的不同总结如下：
1. BRE不支持+，?和|。
2. ERE不支持\1、\2 ... \9这样的后向引用。
GNU支持BRE和ERE，只是表示方式有差异
在BRE中可以通过\+，\?和\|来使用ERE中的+，?和|。ERE中同样可以使用反向引用。

方括号表达式[]，区间表达式{}，以及分组()尤为关键；
一个字符，一个字符集
一个单词，一个单词集
后向引用，引用的仅仅是匹配后的文本内容，而不是正则表达式本身！
锚点    ，^ $
重复次数：? + * {n} {n,} {n,m}
贪婪与否: 
转义元字符: 
pattern(regex){  ed(BRE)  egrep(ERE)
一、正则表达式分类：
1、基本的正则表达式（Basic Regular Expression 又叫 Basic RegEx  简称 BREs）
2、扩展的正则表达式（Extended Regular Expression 又叫 Extended RegEx 简称 EREs）
3、Perl 的正则表达式（Perl Regular Expression 又叫 Perl RegEx 简称 PREs）

1. [grep | egrep]; [sed | sed -E]
在BRE中，?, +, {, |, (, 和 ) 不作为meta-character. \?, \+, \{, \|, \(, \) 被作为 metacharacter
在ERE中，?, +, {, |, (, 中 ) 被作为meta-character. \?, \+, \{, \|, \(, \) 不作为 metacharacter

1. grep/egrep/fgrep
    grep (grep 支持：BREs、EREs、PREs 正则表达式)
        grep 指令后不跟任何参数，则表示要使用 BREs。
        grep 指令后跟 -E 参数，则表示要使用 EREs。
        grep 指令后跟 -P 参数，则表示要使用 PREs。 P.S.
        使用 grep 的"或"匹配： grep -E ‘a|b’ file 或 egrep ‘a|b’ file。
        使用 grep 的"和"匹配： grep 'word1' 文件名 | grep 'word2'。
    egrep (egrep 支持：EREs、PREs 正则表达式)
        egrep 指令后不跟任何参数，则表示要使用 EREs。
        egrep 指令后跟 -P 参数，则表示要使用 PREs。
    fgrep (fgrep 不支持正则匹配，但搜索速度最快)

2. sed (sed 文本工具支持：BREs、EREs)
    sed 指令默认是使用 BREs。
    sed 命令参数 -r ，则表示要使用 EREs。

3. awk/gawk (awk 文本工具支持：EREs)
    awk 指令默认是使用 EREs。 
    NOTE: grep 系和 sed 在处理文本时，都是按行处理的；而 awk 是按列处理的。

除了+, ?, |, ｛｝and （） 需要用用反斜杠的转义来达到特殊功能。而这个在ERE中是不需要的。但是有的grep BRE并不支持|，这个是需要注意的

四、三种不同类型正则表达式比较
#     注意： 当使用 BERs（基本正则表达式）时，必须在下列这些符号前加上转义字符（'\'），
# 屏蔽掉它们的 speical meaning  "?,+,|,{,},（,）" 这些字符，需要加入转义符号"\"
    注意：修饰符用在正则表达式结尾，例如：/dog/i，其中 " i " 就是修饰符，它代表的含义就是：
匹配时不区分大小写，那么修饰符有哪些呢？常见的修饰符如下:
    g   全局匹配（即：一行上的每个出现，而不只是一行上的第一个出现）
    s    把整个匹配串当作一行处理
    m    多行匹配
    i    忽略大小写
    x    允许注释和空格的出现
    U    非贪婪匹配

1. 正则表达式的基本组成部分。
正则表达式      描述                                  示例                                                     Basic-RegEx  Extended-RegEx  Python-RegEx    Perl-RegEx
:---:   :------------------------                     :---------------------------------------                 :---------:  :------------:  :----------:    :--------:
\       转义符，将特殊字符进行转义，忽略其特殊意义    a\\.b匹配a.b，但不能匹配ajb，.被转义为特殊意义           \            \                \              \
^       匹配行首，awk中，^则是匹配字符串的开始        ^tux匹配以tux开头的行                                    ^            ^                ^              ^
$       匹配行尾，awk中，$则是匹配字符串的结尾        tux$匹配以tux结尾的行                                    $            $                $              $
.       匹配除换行符\n之外的任意单个字符，awk则中可以 ab.匹配abc或bad，不可匹配abcd或abde，只能匹配单字符      .            .                .              .
[]      匹配包含在[字符]之中的任意一个字符            coo[kl]可以匹配cook或cool                                []           []               []             []
[^]     匹配\[^字符]之外的任意一个字符                123\[^45]不可以匹配1234或1235，1236、1237都可以          [^]          [^]              [^]            [^]
[-]     匹配[]中指定范围内的任意一个字符，要写成递增  [0-9]可以匹配1、2或3等其中任意一个数字                   [-]          [-]              [-]            [-]
?       匹配之前的项1次或者0次                        colou?r可以匹配color或者colour，不能匹配colouur          不支持       ?                ?              ?
+       匹配之前的项1次或者多次                       sa-6+匹配sa-6、sa-666，不能匹配sa-                       不支持       +                +              +
*       匹配之前的项0次或者多次                       co*l匹配cl、col、cool、coool等                           *            *                *              *
()      匹配表达式，创建一个用于匹配的子串            ma(tri)+匹配matritri                                     不支持       ()               ()             ()
{n}     匹配之前的项n次，n是可以为0的正整数           [0-9]{3}匹配任意一个三位数，可以扩展为\[0-9]\[0-9]\[0-9] 不支持       {n}              {n}            {n}
{n,}    之前的项至少需要匹配n次                       [0-9]{2,}匹配任意一个两位数或更多位数                    不支持       {n,}             {n,}           {n,}
{n,m}   指定之前的项至少匹配n次，最多匹配m次，n<=m    [0-9]{2,5}匹配从两位数到五位数之间的任意一个数字         不支持       {n,m}            {n,m}          {n,m}
｜      交替匹配｜两边的任意一项                      ab(c｜d)匹配abc或abd                                     不支持       ｜               ｜             ｜

2.POSIX字符类是一个形如**[:...:]**的特殊元序列（meta sequence），他可以用于匹配特定的字符范围。
正则表达式      描述                                       示例               Basic-RegEx Extended-RegEx Python-RegEx Perl-RegEx
:--------:      ----------------------------------------   :--------------    :---------:   :---------:  :---------:  :---------:
[:alnum:]       匹配任意一个字母或数字字符                 [[:alnum:]]+       [:alnum:]     [:alnum:]    [:alnum:]    [:alnum:]
[:alpha:]       匹配任意一个字母字符（包括大小写字母）     [[:alpha:]]{4}     [:alpha:]     [:alpha:]    [:alpha:]    [:alpha:]
[:blank:]       空格与制表符（横向和纵向）                 [[:blank:]]*       [:blank:]     [:blank:]    [:blank:]    [:blank:]
[:digit:]       匹配任意一个数字字符                       [[:digit:]]?       [:digit:]     [:digit:]    [:digit:]    [:digit:]
[:lower:]       匹配小写字母                               [[:lower:]]{5,}    [:lower:]     [:lower:]    [:lower:]    [:lower:]
[:upper:]       匹配大写字母                               ([[:upper:]]+)?    [:upper:]     [:upper:]    [:upper:]    [:upper:]
[:punct:]       匹配标点符号                               [[:punct:]]        [:punct:]     [:punct:]    [:punct:]    [:punct:]
[:space:]       匹配一个包括换行符、回车等在内的所有空白符 [[:space:]]+       [:space:]     [:space:]    [:space:]    [:space:]
[:graph:]       匹配任何一个可以看得见的且可以打印的字符   [[:graph:]]        [:graph:]     [:graph:]    [:graph:]    [:graph:]
[:xdigit:]      任何一个十六进制数（即：0-9，a-f，A-F）    [[:xdigit:]]+      [:xdigit:]    [:xdigit:]   [:xdigit:]   [:xdigit:]
[:cntrl:]       任何一个控制字符                           [[:cntrl:]]        [:cntrl:]     [:cntrl:]    [:cntrl:]    [:cntrl:]
[:print:]       任何一个可以打印的字符                     [[:print:]]        [:print:]     [:print:]    [:print:]    [:print:]

元字符
元字符（meta character）是一种Perl风格的正则表达式，只有一部分文本处理工具支持它，并不是所有的文本处理工具都支持。
正则表达式      描述                  示例                    Basic-RegEx | Extended-RegEx | Python-RegEx | Perl-RegEx |
\b      单词边界                      \bcool\b 匹配cool，不匹配coolant   \b      \b      \b      \b
\B      非单词边界                    cool\B 匹配coolant，不匹配cool     \B      \B      \B      \B
\d      单个数字字符                  b\db 匹配b2b，不匹配bcb            不支持  不支持  \d      \d
\D      单个非数字字符                b\Db 匹配bcb，不匹配b2b            不支持  不支持  \D      \D
\w      单个单词字符（字母、数字与_） \w 匹配1或a，不匹配&               \w      \w      \w      \w
\W      单个非单词字符                 \W 匹配&，不匹配1或a              \W      \W      \W      \W
\n      换行符                        \n 匹配一个新行                    不支持  不支持  \n      \n
\s      单个空白字符                  x\sx 匹配x x，不匹配xx             不支持  不支持  \s      \s
\S      单个非空白字符                x\S\x 匹配xkx，不匹配xx            不支持  不支持  \S      \S
\r      回车                          \r 匹配回车                        不支持  不支持  \r      \r
\t      横向制表符                    \t 匹配一个横向制表符              不支持  不支持  \t      \t
\v      垂直制表符                     \v 匹配一个垂直制表符             不支持  不支持  \v      \v
\f      换页符                         \f 匹配一个换页符                 不支持  不支持  \f      \f
    
几种POSIX流派的regex说明 
+---------------------------------------------------------------------------+
| 流派      说明                                        工具                |
| BRE       (、)、{、}必须转义，不支持+、?、|           grep、sed、vi、more | #vi有些不一样
| GNU BRE   (、)、{、}、+、?、|必须转义                 GNU grep、GNU sed   |
| ERE       (、)、{、}、+、?、|直接使用, \1、\2不确定   egrep、awk          |
| GNU ERE   (、)、{、}、+、?、|直接使用, 支持\1、\2     grep -E、GNU awk    |
+---------------------------------------------------------------------------+
| BRE ERE 共同支持的元字符有: \.*^$[]                                       |
+---------------------------------------------------------------------------+

常用Linux/Unix工具中regex的表示法 
+---------------------------------------------------------------+
| Perl        awk       grep -E   grep       sed        vi/vim  |
| \.*^$[]     ...       ...       ...        ...        ...     |
| +           +         +         \+         \+         \+      |
| ?           ?         ?         \?         \?         \=      |
| {m,n}       {m,n}     {m,n}     \{m,n\}    \{m,n\}    \{m,n}  |
| \b          \< \>     \< \>     \< \>      \< \>      \< \>   |
| |           |         |         \|         \|         \|      |
| (…)         (…)       (…)       \(…\)      \(…)       \(…\)   |
| \1 \2       不支持    \1 \2     \1 \2      \1 \2      \1 \2   |
| (?=atom)                                              atom\@= |
| (?!atom)                                              atom\@! |
+---------------------------------------------------------------+

非打印字符
\f: 匹配一个换页符。等价于 \x0c 和 \cL。
\n: 匹配一个换行符。等价于 \x0a 和 \cJ。
\r: 匹配一个回车符。等价于 \x0d 和 \cM。
\s: 匹配任何空白字符，包括空格、制表符、换页符等等。等价于 [ \f\n\r\t\v]。
\S: 匹配任何非空白字符。等价于 [^ \f\n\r\t\v]。
\t: 匹配一个制表符。等价于 \x09 和 \cI。
\v: 匹配一个垂直制表符。等价于 \x0b 和 \cK。

Anchors (锚点)
    ^       Start of line +
    $       End of line+ 
    \A      Start of string+ 
    \Z      End of string+
    \b      Word boundary+  (字边界)
    \B      Not word boundary+ (非字边界)
    \<      Start of word
    \>      End of word

POSIX Character Classes
    [:upper:]   Upper case letters
    [:lower:]   Lower case letters
    [:alpha:]   All letters
    [:alnum:]   Digits and letters 
    [:digit:]   Digits
    [:xdigit:]  Hexadecimal digits
    [:punct:]   Punctuation(标点符号)
    [:blank:]   Space and tab
    [:space:]   Blank characters
    [:cntrl:]   Control characters
    [:graph:]   Printed characters
    [:print:]   Printed characters and spaces
    [:word:]    Digits,letters and underscore(下划线)
    
Character Classes
    \c      Control character
    \s      White space
    \S      Not white space
    \d      Digit
    \D      Not digit 
    \w      word
    \W      Not word
    \xhh    Hexadecimal character hh
    \Oxxx   Octal character xxx
    
Special Characters
    \        cape Character+
    \n       New line+
    \r       Carriage return+
    \t       Tab+
    \v       Vertical tab+
    \f       Form feed+
    \a       Alarm
    [\b]     Backspace
    \e       Escape
    \N{name} NamedCharacter

Quantifiers
    *       0 or more +
    *?      0 or more,ungreedy(贪心)+
    +       1 ore more + 
    +?      1 or more ,ungreedy +
    ?       0 or 1 +
    ??      0 or 1, ungreedy+
    {3}     Excactly 3 +
    {3,}    3 or more +
    {3,5}   3,4 or 5 +
    {3,5}? 3,4 or 5 ungreedy+
    
Ranges
    .       Any character except new line (\n)+
    (a|b)   a or b +
    (...)   Group +
    (?:...) Passive Group +
    [abc]   Range(a or b or c ) +
    [^abc]  Not a or b or c +
    [a-q]   Letter between a and q +
    [A-Q]   Upper case letter between A and Q +
    [0-7]   Digit between 0 and 7 +
    \n nth  group /subpattern +
    
Pattern Modifiers
    g       Global match
    i       Case-insensitive
    m       Multiple lines
    s       Treat string as single line
    x       Allow comments and white space in pattern
    e       Evaluate replacement
    U       Ungreedy pattern
    
Assertions
    ?=          Lookahead assertion +
    ?!          Negative lookahead +
    ?<=         Lookbehind assertion +
    ?!= or ?<!  Negative lookbehind + 
    ?>          Once-only Subexpression
    ?()         Condition [if then] 
    ?()|        condition [if then else ] 
    ?#          Comment
Metacharacters ( must be escaped ) ^ [ . $ { * \ +  ) | ? < >

# String Replacement(Backreferences)
#     $n      nth non-passive group
#     $2      "xyz" in /^(abc(xyz))$/
#     $1      "xyz" in /^(?:abc)(xyz)$/
#     $`      Before matched string
#     $'      After matched string
#     $+      Last matched string
#     $&      Entire matched string
#     $_      Entire input string
#     $$      Literal "$"

(?=pattern) 零宽正向先行断言
(?!pattern) 零宽负向先行断言
(?<=pattern) 零宽正向后行断言
(?<!pattern) 零宽负向后行断言
}

paste -sd "\t" colors_1.txt  | awk ' {for(i=1;i<NF;i=i+3) printf("%s\t%s\t%s\n", "help", $(i+1), $(i+2));} '

awk(manual){
For each file, 
  For each input line, 
    For each pattern,
}

man 1p awk (gawk) 
man 1  awk 
    awk : 基本操作是在一组文件上查找模式，并在包含这些模式实例的那些行或字段上进行指定的动作。
awk 使得特定数据的选择和变换操作更易于表达；
    awk 模式可以包括正则表达式和在字符串、数值、字段、变量、数组元素上的关系算符的任意的布尔组合。
动作可以包括同在模式中一样的模式匹配构造，还有算术和字符串表达式与赋值，if-else、while、for 语句，和多个输出流。
    《The AWK Programming Language》在介绍 AWK 的编程示例中，言简意赅地介绍了文本处理、数据库、编译原理、
排序以及图的遍历等计算机科学基础知识。也许每一本讲授编程语言的书，都应该借鉴《The AWK Programming Language》的写法。

awk: 数据的选择和变换操作；信息检索和文本操作。
0. 动作与模式: 1. 模式或动作二者都可以但不能同时省略。
    如果一个模式没有动作，简单的把匹配的行复制到输出。(所以匹配多个模式的行可能被打印多次)。 没有动作的'模式-动作'是输出匹配行
    如果一个动作没有模式，则这个动作在所有输入上执行。(不匹配模式的行被忽略)。               没有模式的'模式-动作'是匹配所有行
    因为模式和动作都是可选的，动作必须被包围在花括号中来区别于模式。
    2. 在动作之前的模式充当决定一个动作是否执行的选择者。有多种多样的表达式可以被用做模式: 正则表达式，
算术关系表达式，字符串值的表达式，和它们的任意的布尔组合。BEGIN 在第一个记录被读取之前和 END 最后一个记录已经被处理之后
1. 多输入 1. 一个或多个文件: 命令行支持指定多个文件。 ARGV和ARGC 与之相关联。
          2. 标准输入: 或通过cat和管道也可以实现多文件输入)
          3. 其它命令的输出: getline命令
2. 多输出 : 1. print printf 和 sprintf 简单输出 指定格式输出和定向格式输出。 1. 标准输出
            2. 生成多个输出文件，'>'新建 '>>'追加  2. 重定向输出 # { print $1 >"foo1"; print $2 >"foo2" } 或 print $1 >>"foo" 
            3. 默认情况下，print printf输出到stdout中。
            4. 标准错误输出被用于输出错误信息。
3. 行模式匹配: 每行输入可以对应多个模式匹配 '/pattern/' 或者 每行输入可以对应多个条件判断语句匹配'{if(/pattern/ ~! regular)}'。
           即: 每行输入可以对应多个 'pattern {action}; pattern {action}; ... '
 1. 输入的每行都要依次针对每个模式做匹配。对于每个匹配的模式，执行相关的动作。
    以'行'作为模式匹配的最大单元，以'字段'作为模式的最小单元。
    以'行'作为动作执行(数据操作)最大单位；以'字段'作为动作执行最小单元。
    一行数据可以被检索多次，每次检索或多次检索成功后，会执行输出或者数组统计操作。
 2. 如果记录分隔符为空，把空输入行作为记录分隔符，并把空格、tab 和换行作为字段分隔符处理。
    行: NR,RS(记录分隔符),ORS
    字段:NF,FS(字段分隔符),OFS 
    FS: 可以同时使用多个域分隔符，这时应该把分隔符写成放到方括号中，如$awk -F'[:\t]' '{print $1,$3}' test，表示以空格、冒号和tab作为分隔符。
    OFS: 输出域的分隔符默认是一个空格，保存在OFS中。如$ awk -F: '{print $1,$5}' test，$1和$5间的逗号就是OFS的值。
4. 模式匹配: 字符串处理，数值计算，变量判断和数组元素的字符串或数值判断，以及正则表达式的匹配结果之间的布尔异或操作。
 1. /正则表达式/：正则表达式是包围在斜杠内的文字的字符串。圆括号用做组合，| 用做选择，+ 用做'一或多个'，? 用于'零或一个'。
 2. 关系表达式：常用的关系算符 <、<=、==、!=、>=、> 的关系表达式，可以是字符串或数字的比较，如$2>$1选择第二个字段比第一个字段长的行。
    在关系测试中，如果操作数(operand)都不是数值，则做字符串比较；否则做数值比较。
 3. 模式匹配表达式：~ 和 !~ 指定任何行或字段或变量匹配(或不匹配)一个正则表达式。
    脱字符号 ^ 指称一行或一个字段的开始处；美元号 $ 指称结束处。'.' 表示除'\n'之外的所有字符，而'$'可以视作'\n'字符。
    $1 ~ /[jJ]ohn/ 第一个字段匹配"john"或"John"的所有行。 $1 ~ /^[jJ]ohn$/ 精确的限制它为 [jJ]ohn。
 4. 模式的组合: 可以是模式的使用算符 ||(或)、&&(与)和 !(非)的任意布尔组合。
    在布尔表达式上下文中，对于数值而言，0视作false，非0视作true。对于字符串而言，null视作false，非null视作true
 5. 模式，模式：指定一个行的范围。/start/, /stop/ 或者 NR == 100, NR == 200 { ... }
    范围模板匹配从第一个模板的第一次出现到第二个模板的第一次出现之间所有行。如果有一个模板没出现，则匹配到开头或末尾。
 7. BEGIN：让用户指定在第一条输入记录被处理之前所发生的动作，通常可在这里设置全局变量。
    END：让用户在最后一条输入记录被读取之后发生的动作。
    BEGIN 和 END 从而提供了在处理之前和之后获得控制的方式，用来做初始化和总结。
    如果 BEGIN 出现，它必须是第一模式；END 必须是最后一个模式，如果用到了的话。
5. 动作执行: 数值计算结果，字符串截断替换和数组(k-v数组)运算，以及for,while,if-else控制语句
 1. awk 动作是用换行或分号终止的动作语句的序列。这些动作语句可以被用来做各种各样的簿记和字符串操纵任务。 
 2. 变量、表达式和赋值 : 
    字符串:字段值，getline获得值，FILENAME，ARGV，ENVIRON，split产生数组，通过命令行赋值和赋值都视作字符串。未初始化的字符串为空字符串
    字符串: gsub(ere, repl[, in]) index(s, t)  length[([s])]  match(s, ere) split(s, a[, fs  ]) sprintf(fmt, expr, expr, ...) 
             sub(ere, repl[, in]) substr(s, m[, n  ]) tolower(s) toupper(s)
    数值  : NUMBER， 通过sprintf将数值格式化成字符串。未初始化的数值是0.
    数值  : atan2(y,x) cos(x) sin(x) exp(x) log(x) sqrt(x) int(x) rand() srand([expr])
    布尔值: condtion条件表达式，NOT AND 和 OR，for的第二个判断条件，if的判断条件，while的判断条件，/pattern/模式匹配
    a.在awk中，变量不需要定义就可以直接使用，变量类型可以是数字或字符串。注意，字符串一定要用双引号。
    b. 可以在命令行中给变量赋值，然后将这个变量传输给awk脚本。如$ awk -F: -f awkscript month=4 year=2004 test，
    x = 1; x = "smith"; x = "3" + "4" 算术算符有 +、-、*、/、%(模)。
    C 语言的增加 ++ 和减少 −− 算符也可用，还有赋值算符 +=、-=、*=、/=、%=。
 3. 位置字段变量:可以被赋值; 一个字段被认为是数值还是字符串依赖于上下文; 对$1 $2 ...的赋值会影响$0变量
 4. 输出命令 close(expression) expression |  getline [var]; getline; getline  var; getline [var]  < expression; system(expression)
 5. 数组    : 数组元素不用声明；在被提及到的时候才导致它的存在。下标可以有任何非空的值，包括非数值的字符串. 
              动态大小，初始为空。对于字符串索引来说，数组元素插入顺序与遍历顺序不一致。视作散列表。可以通过嵌套实现顺序性。
              delete函数用于删除数组元素。如：$ awk '{line[x++]=$1} END{for(x in line) delete(line[x])}' test。
 6. 内置函数: length sqrt log exp int substr index sprintf split(s, array, sep)
 7. 控制流命令: break 语句导致从围绕它 while 或 for 中立即退出，
                continue 语句导致开始下一次重复。
                next next语句从输入文件中读取一行，然后从头开始执行awk脚本
                exit 语句用于结束awk程序，但不会略过END块。退出状态为0代表成功，非零值表示出错。
 注释: 在 awk 程序中可以放置注释: 它们开始于字符 # 并结束于本行的结束处。
6. 环境变量: 环境变量，BEGIN(特殊模式)，END(特殊模式)，数组(统计)，内置函数
7. 赋值:  字段可以被赋值。行也可以被赋值
8. 模式匹配型条件和执行语句中条件:  awk '{if ($0 ~ /pattern/) print $0}' 执行语句内条件判断
                                    awk '$0 ~ /pattern/ {print $0}'      模式匹配型条件判断
awk -F: 'NF != 7{printf("line %d:%s\n",NR,$0)} 
         $1 !~ /[A-Za-z0-9]/{printf("line %d,%s\n,NR,$0)} 
         $2 == "*" {printf("line %d, no password: %s\n",NR,$0)}'         模式匹配型多条件判断
awk -F: '{ if(NF != 7) {printf("line %d:%s\n",NR,$0)}; 
           if($1 !~ /[A-Za-z0-9]/){ printf("line %d,%s\n,NR,$0)};
           if($2 == "*"){printf("line %d, no password: %s\n",NR,$0)}} '  执行语句内多条件判断

模式: + ? | () {m} {m,} {m,n} [string] [^string] ~ !~ $ . * \
awk模式形式
BEGIN
END
/regular expression/
relational expression
pattern && pattern
pattern || pattern
pattern ? pattern : pattern
(pattern)
! pattern
pattern1, pattern2

subshell(){
在shell中是否进入子shell的情况可以分为几种：
1. 执行bash内置命令时。
如果将内置命令放在管道后，则此内置命令将和管道左边的进程同属于一个进程组，所以仍然会创建子shell。
cd | expr $BASHPID      # 管道使得任何命令都进入进程组，会进入子shell
2. 执行bash命令本身时
但因重新加载了环境配置项，所以子shell没有继承普通变量，更准确的说是覆盖了从父shell中继承的变量。
3. 执行shell脚本时
它仅只继承父shell的某些环境变量，其余环境一概初始化。
4. 执行shell函数时。
其实shell函数就是命令，它和bash内置命令的情况一样。直接执行时不会进入子shell，但放在管道后会进入子shell。
5. 执行非bash内置命令时
6. 命令替换
echo $(echo $BASHPID)      # 使用命令替换$()进入子shell
7. 使用括号()组合一系列命令
(echo $BASHPID)  # 使用括号()的命令组合进入子shell
8. 放入后台运行的任务
它不仅是一个独立的子进程，还是在子shell环境中运行的。例如"echo hahha &"。
9.进程替换
cat <(echo $BASHPID) # 进程替换"<()"进入子shell
进程替换可以视为命名管道的一端，其必然需要bash或者cat等命令关联到另一端上，实现数据在管道内流动。
进程替换可以视为精简版的有关管道实现方式。
}

line_field_charactor(){
1. 指定分隔符
1.1 分隔符为 单个字符
read: <space><tab><newline>

1.2 分隔符为 多个字符
awk:  FS='[\t:;,]'

2. 支持行处理
read line
awk $0

3. 支持单词处理
read -a array
awk NF

4. 支持字符处理
read -n nchars 
awk FS=""
}


xargs_demo(){
    sudo netstat -plnt | grep :50 | awk '{print $7}' | awk -F/ '{print $1}' | xargs kill -9 # xargs kill
    
# 之所以要用到xargs，是因为由于很多命令不支持使用管道|来传递参数
find /sbin -perm +700 |xargs ls -l # 这样才是正确的

xargs [-I replace-str] [-n max-args] [command] [initial-arguments]   
-I  |replace-str|  使用 replace-str 代替输入的参数
-n  |max-args|     每次提供的最大参数个数
-d  |sep-char|     每个参数的分隔符，当文件内包含空格的时候非常有用，如：find -name "*.txt" | xargs -d '\n' chmod -x
xargs会把标准输入的数据的所有回车去掉.
当xargs什么参数都不加的时候, 默认把标准输入的参数作为执行命令最尾的参数.

控制每行参数个数(-L)和最大并行数(-P).如果你不确定它们是否会按你想的那样工作，先使用 xargs echo 查看一下。
find . -name '*.py' | xargs grep some_function 
cat hosts | xargs -I{} ssh root@{} hostname

对xargs内执行多个命令:
使用sh -c "commands"方式传入多个指令，如：
ls | xargs -n1 -I{} sh -c 'echo -e {} && cat {}' 

cat example.txt | xargs        # 多行输入转换成单行输出
cat example.txt | xargs -n 3   # 单行变多行
# 分隔符; xargs默认使用空白字符分割输入并执行/bin/echo; -d选项指定分隔符 
echo "split1Xsplit2Xsplit3X" | xargs -d X # split1 split2 split3

xargs [OPTIONS] [PROG [ARGS]]  # PROG 默认是echo
Run PROG on every item given by standard input
}
xargs_man(){
xargs   管道实现的是将前面的stdout作为后面的stdin,但有些命令不接受管道的传递方式,如ls,有时,希望传递是参数,直接用管道无法传递到命令的参数位,这时需要xargs,xargs实现的是将管道传输过来的stdin进行处理后传递到命令的参数位上
        也就是说,xargs实现了2个行为,处理管道传输过来的stdin;将处理后的传递到正确的参数位上
        会将所有空格,制表符,换行符替换为空格
        处理顺序: 先分割,再分批,然后传递到参数位
分割:
    独立的xargs
    -d      -d与-o可以配合起来使用,指定分割符,是单个字符, xargs -0是xargs -d的一种,等价于xargs -d'\0'
        替换：将接收stdin的所有的标记意义的符号替换为\n，替换完成后所有的符号（空格、制表符、分行符）变成字面意义上的普通符号，即文本意义的符号。
        分段：根据-d指定的分隔符进行分段并用空格分开每段，由于分段前所有符号都是普通字面意义上的符号，所以有的分段中可能包含了空格、制表符、分行符。也就是说除了-d导致的分段空格，其余所有的符号都是分段中的一部分。
        输出：最后根据指定的分批选项来输出。这里需要注意，分段前后有特殊符号时会完全按照符号输出。
    -o
分批:
    从逻辑上来说是-n与-L,但当指定了传递阶段选项-i后,会忽略-n与-L
    -n      num     按空格分段,不管是文本意义上的还是标记意义上的,也就是说,如"ont Imag"的文件名会被分为2个
    -L/-i  	num     按段划批,文本意义的符号不被处理,如"ont Img"的文件就不会被分为2个文件名
    
    -p      交互询问式,每次输入y或Y才会执行
    -t      每次执行前会打印命令(是在stderror上)
    -s <num>:命令行的最大字符数，指的是xargs后面那个命令的最大命令行字符数,包括命令、空格和换行符。每个参数单独传入xargs后面的命令。
传递:     
    -i      如果不使用-i,则默认是将分割后处理后的结果整体传递到命令的最尾部,但有时需要传递多个位置,使用xargs -i与大括号{}作为替换号,传递的时候看到{}就将被结果替换
-I 和-i一样,只是-i默认使用大括号作为替换符,-I则可以指定其他符号,必须用引号括起来,如xargs -I {} cp ../tmp/{} tmp
}
xargs_pipe(){
将管道传输过来的stdin进行处理然后传递到命令的参数位上
xargs的作用不仅仅限于简单的stdin传递到命令的参数位，
它还可以将stdin或者文件stdin分割成批，每个批中有很多分割片段，然后将这些片段按批交给xargs后面的命令进行处理。
###
# 管道实现的是将前面的stdout作为后面的stdin，但是有些命令不接受管道的传递方式，最常见的就是ls命令。
# 有些时候命令希望管道传递的是参数，但是直接用管道有时无法传递到命令的参数位，这时候需要xargs，
# xargs实现的是将管道传输过来的stdin进行处理然后传递到命令的参数位上。也就是说xargs完成了两个行为：
# 处理管道传输过来的stdin；将处理后的传递到正确的位置上。
###
# echo "/etc/inittab" | cat         # 直接将标准输入的内容传递给cat
# echo "/etc/inittab" | xargs cat   # 将标准输入的内容经过xargs处理后传递给cat
# find /etc -maxdepth 1 -name "*.conf" -print0 | xargs -0 -i grep "hostname" -l {}  # 将搜索的文件传递给grep的参数位进行搜索，若不使用xargs，则grep将报错
###
# 通俗的讲就是原来只能一个一个传递，分批可以实现10个10个传递，每传递一次，xargs后面的命令处理这10个中的每一个，处理完了处理下一个传递过来的批，
1. 如何分割(xargs、xargs -d、xargs -0)
2. 分割后如何划批(xargs -n、xargs -L)
3. 参数如何传递(xargs -i)
4. 提供询问交互式处理(-p选项)
5. 预先打印一遍命令的执行情况(-t选项)
6. 传递终止符(-E选项)
# xargs处理的优先级或顺序了：先分割，再分批，然后传递到参数位。
# 优先级从-n --> -L --> -i逐渐变高，当指定高优先级的分批选项会覆盖低优先级的分批选项
1. 文本意义上的空格、制表符、反斜线、引号   # 未经处理就已经存在的符号，文本的内容中出现这些符号以及在文件名上出现了
2. 非文本意义上的空格、制表符、反斜线、引号 # 标记意义上的符号：处理后出现的符号，
a. 将分行处理掉不是echo实现的，而是管道传递过来的stdin经过xargs处理后的：将所有空格、制表符和分行符都
   替换为空格并压缩到一行上显示，这一整行将作为一个整体，这个整体的所有空格属性继承xargs处理前的符号属性，
   即原来是文本意义的或标记意义的在替换为空格后符号属性不变。
b. 如果想要保存制表符、空格等特殊符号，需要将它们用单引号或双引号包围起来，但是单双引号(和反斜线)都会被xargs去掉。
c. 如果对独立的xargs指定分批选项，则有两种分批可能：指定-n时按空格分段，然后划批，不管是文本意义的空格
   还是标记意义的空格，只要是空格都是-n的操作对象；指定-L或者-i时按段划批，文本意义的符号不被处理。
}

awk -F ':' '{print $1}' /etc/passwd | xargs # xargs 可以单行变多行，多行变单行
# xargs 可以和find一起用，批量删除，为了防止误删，如hello world.txt，会被看成hello和world.txt两个文件，所以要加-0参数
find . -type f -name "*.txt" -print0 | xargs -0 rm -f
find . -name '*.c' -print | xargs rm
ls | xargs gzip
    xargs(先分割，再分批，然后传递到参数位){
        # 命令替换
        -t 先打印命令，然后再执行
        -i 用每项替换 {}
        find / -perm +7000 | xargs ls -l                    # 将前面的内容，作为后面命令的参数
        seq 1 10 |xargs  -i date -d "{} days " +%Y-%m-%d    # 列出10天日期
        
        find . -name \*.py | xargs grep some_function
        cat hosts | xargs -I{} ssh root@{} hostname
        
        find . -type f -print0 | xargs -0 rm
        find . -type f -print0 | xargs -0 rm
        find . -name "*.foo" -print0 | xargs -0 -i mv {} /tmp/trash #使用-i参数将{}中内容替换为列表中的内容
        ls *.jpg | xargs -n1 -i cp {} /external-hard-drive/directory #拷贝所有的图片文件到一个外部的硬盘驱动

0. 对于xargs，它将接收到的stdout处理后传递到xargs后面的命令参数位，不写命令时默认的命令是echo。
    cat shdir/1.sh | xargs       # 功能相同
    cat shdir/1.sh | xargs echo  # 功能相同
    将所有空格、制表符和分行符都替换为空格并压缩到一行上显示，这一整行将作为一个整体，
这个整体的所有空格属性继承xargs处理前的符号属性。
    单双引号(和反斜线)都会被xargs去掉。
    ls | xargs -n 2          # one和space.log分割开了，说明-n是按空格分割的
    ls | xargs -L 2          # one space.log作为一个分段，文件名中的空格没有分割这个段
    ls | xargs -i -p echo {} # one space.log也没有被文件名中的空格分割
1. 使用xargs -p或xargs -t观察命令的执行过程
使用-p选项是交互询问式的，只有每次询问的时候输入y(或yes)才会执行，直接按enter键是不会执行的。
使用-t选项是在每次执行xargs后面的命令都会先在stderr上打印一遍命令的执行过程然后才正式执行。
使用-p或-t选项就可以根据xargs后命令的执行顺序进行推测，xargs是如何分段、分批以及如何传递的，这通过它们有助于理解xargs的各种选项。
    ls | xargs -n 2 -t
    ls | xargs -n 2 -p
2. 分割行为之：xargs -d
xargs -d有如下行为：
    xargs -d可以指定分段符，可以是单个符号、字母或数字。如指定字母o为分隔符：xargs -d"o"。
    xargs -d是分割阶段的选项，所以它优先于分批选项(-n、-L、-i)。
    xargs -d不是先xargs再-d处理的，它是区别于独立的xargs的另一个分割选项。
xargs -d整体执行有几个阶段：
    替换：将接收stdin的所有的标记意义的符号替换为\n，替换完成后所有的符号(空格、制表符、分行符)变成字面意义上的普通符号，即文本意义的符号。
    分段：根据-d指定的分隔符进行分段并用空格分开每段，由于分段前所有符号都是普通字面意义上的符号，所以有的分段中可能包含了空格、制表符、分行符。也就是说除了-d导致的分段空格，其余所有的符号都是分段中的一部分。
    输出：最后根据指定的分批选项来输出。这里需要注意，分段前后有特殊符号时会完全按照符号输出。
从上面的阶段得出以下两结论：
(1)xargs -d会忽略文本意义上的符号。对于文本意义上的空格、制表符、分行符，除非是-d指定的符号，否则它们从来不会被处理，它们一直都是每个分段里的一部分；
(2)由于第一阶段标记意义的符号会替换为分行符号，所以传入的stdin的每个标记意义符号位都在最终的xargs -d结果上分行了，但是它们已经是分段中的普通符号了，除非它们是-d指定的符号。
例如对ls的结果指定"o"为分隔符。
2.1 如果使用xargs -d时不指定分批选项，则整个结果将作为整体输出。 # ls | xargs -d"o" -p
2.2 如果指定了分批选项，则按照-d指定的分隔符分段后的段分批，这时使用-n、-L或-i的结果是一样的。例如使用-n选项来观察是如何分批的。
# ls | xargs -d"o" -n 2 -p
  ls | xargs -d"o" -n 1
3. 分割行为之：xargs -0
xargs -0的行为和xargs -d基本是一样的，只是-d是指定分隔符，-0是指定固定的\0作为分隔符。其实xargs -0就是特殊的xargs -d的一种，它等价于xargs -d"\0"。
xargs -0行为如下： 
    xargs -0是分割阶段的选项，所以它优先于分批选项(-n、-L、-i)。
    xargs -0不是先xargs再-0处理的，它是区别于独立的xargs的另一个分割选项。
    xargs -0可以处理接收的stdin中的null字符(\0)。如果不使用-0选项或- -null选项，检测到\0后会给出警告提醒，并只向命令传递非\0段。xargs -0和- -null是一样的效果。
xargs -0整体执行有几个阶段：
    替换：将接收stdin的所有的标记意义的符号替换为\n，替换完成后所有的符号(空格、制表符、分行符)变成字面意义上的普通符号，即文本意义的符号。
    分段：将检测到的null字符(\0)使用标记意义上的空格来分段，由于分段前所有符号都是普通字面意义上的符号，所以有的分段中可能包含了空格、制表符、分行符。也就是说除了-0导致的分段空格，其余所有的符号都是分段中的一部分。
如果没有检测到\0，则接收的整个stdin将成为一个不可分割的整体，任何分批选项都不会将其分割开，因为它只有一个段。
    输出：最后根据指定的分批选项来输出。这里需要注意，分段前后有特殊符号时会完全按照符号输出。
根据上面的结论可知，xargs -0会忽略所有文本意义上的符号，它的主要目的是处理\0符号。
ls | tr " " "\t" | xargs -0 #忽略文本意义上的制表符
ls | tr " " " " | xargs -0 #忽略文本意义上的空格

4. xargs -n
    xargs -n分两种情况：和独立的xargs一起使用，这时按照每个空格分段划批；和xargs -d或xargs -0一起使用，
这时按段分批，即不以空格、制表符和分行符分段划批。
5. xargs -L
和-n选项类似，唯一的区别是-L永远是按段划批，而-n在和独立的xargs一起使用时是按空格分段划批的。
该选项的一个同义词是-l，但是man推荐使用-L替代-l，因为-L符合POSIX标准，而-l不符合。使用--max-lines也可以。
也许你man xargs时发现-L选项是指定传递时最大传递行数量的，man的结果如下图。但是通过下面的实验可以验证其实-L是指定传递的最大段数，也就是分批。
6. xargs -i和xargs -I
xargs -i选项在逻辑上用于接收传递的分批结果。
如果不使用-i，则默认是将分割后处理后的结果整体传递到命令的最尾部。但是有时候需要传递到多个位置，不使用-i就不知道传递到哪个位置了，例如重命名备份的时候在每个传递过来的文件名加上后缀.bak，这需要两个参数位。
使用xargs -i时以大括号{}作为替换符号，传递的时候看到{}就将被结果替换。可以将{}放在任意需要传递的参数位上，如果多个地方使用{}就实现了多个传递。
xargs -I(大写字母i)和xargs -i是一样的，只是-i默认使用大括号作为替换符号，-I则可以指定其他的符号、字母、数字作为替换符号，但是必须用引号包起来。man推荐使用-I代替-i，但是一般都图个简单使用-i，除非在命令中不能使用大括号，如touch {1..1000}.log时大括号就不能用来做替换符号。
7. 分批选项的优先级
-i选项优先级最高，-L选项次之，-n选项优先级最低。当然，如果什么分批选项也不指定，肯定是不指定优先级最低(这是废话？)。
多个分批选项同时指定时，高优先级的选项会覆盖低优先级的选项。也就是说这时候指定低优先级的选项是无意义的。

rm -fr /tmp/longshuai/*.log # -bash: /bin/rm: Argument list too long
cd /tmp/longshuai/ && ls | xargs -n 10000 rm -rf
cd /tmp/longshuai/ && ls | xargs rm -rf
8. 终止行为之：xargs -E
指定终止符号，搜索到了指定的终止符就完全退出传递，命令也就到此结束。
-e选项也是，但是官方建议使用-E替代-e，因为-E是POSIX标准兼容的，而-e不是。
-E会将结果空格、制表符、分行符替换为空格并压缩到一行上显示。
据我测试，-E似乎只能和独立的xargs使用，和-0、-d配合使用时都会失效。那么稍后我就只测试和独立的xargs配合使用的情况了。
-E优先于-n、-L和-i执行。如果是分批选项先执行，则下面的第二个结果将压缩在一行上。
指定的终止符必须是完整的，例如想在遇到"xyz.txt"的符号终止时，只能指定完整的xyz.txt符号，不能指定.txt或者txt这样的符号。如何判断指定的终止符号是否完整，就-E与独立的xargs配合的情况而言分两种情况：如果没指定分批选项或者指定的分批选项是-n或者-L时，以空格为分割符，两个空格之间的段都是完整的；如果指定的分批选项是-i，则以段为分割符。


xargs
1. 空格、制表符、分行符替换为空格，引号和反斜线删除。处理完后只有空格。如果空格、制表符和分行符使用引号包围则可以保留
2. 结果继承处理前的符号性质(文本
3.1 -n      以分段结果中的每个空格分段，进而分批。不管是文本还是标记意义的空格，只要是空格
3.2 -L、-i  以标记意义上的空格分段，进而分批
3.3 不指定	结果作为整体输出
xargs -d
1. 不处理文本意义上的符号，所有标记意义上的符号替换为换行符\n，将-d指定的分割符替换为标记意义上的空格。
2. 按照-d指定的符号进行分段，每个段中可能包含文本意义上的空格、制表符、甚至是分行符。
3.1 -n、-L、-i 以标记意义上的符号(即最后的空行和-d指定分隔符位的空格)分段，进而分批。分段结果中保留所有段中的符号，包括制表符和分行符。
3.2 不指定     结果作为整体输出
xargs -0
1. 不处理文本意义上的符号，将非\0的标记意义上的符号替换为\n，将\0替换为空格。结果中除了最后空行和\0位的空格，其余都是文本意义上的符号
2. 以替换\0位的空格分段，每个段中可能包含文本意义上的空格、制表符、甚至是分行符。如果没检测到\0，则只有一个不可分割的段。
3.1 -n、-L、-i  检测到\0时，以标记意义上的符号(即最后的空行和\0位的空格)分段，进而分批。分段结果中保留所有段中的符号，包括制表符和分行符。
                未检测到\0时，整个结果作为不可分割整体，使用分批选项是无意义的
3.2 不指定      结果作为整体输出
    http://www.cnblogs.com/f-ck-need-u/p/5925923.html
    }
xargs_learnbyexample(){
1. echo
printf ' foo\t\tbar \t123     baz \n' | xargs | cat -e
printf ' foo\t\tbar \t123     baz \n' | xargs -n2
seq 6 | xargs -n3
1.1 使用 -a 指定文件，而不是stdin
$ cat marks.txt 
jan 2017 
foobar 12 45 23 
feb 2017 
foobar 18 38 19 

xargs -a marks.txt
xargs -L2 -a marks.txt
}
Linux磁盘配额的特点：
作用范围：针对指定的文件系统（分区）
限制对象：用户帐号、组帐号
限制类型：磁盘容量、文件数量（i节点）
限制方法：软限制、硬限制
quota_intro(){
什么是quota
在Linux系统中，多用户多任务的环境会经常抢占资源，quota则是制定用户/用户组，对硬盘资源的进行配额 ， 妥善分配资源。
  quota的一般用途
    针对WWW server ， 例如：限制用户的网页空间容量
    针对 mail server ， 例如 ： 限制用户的邮件空间
    针对 file server ， 例如 ： 限制用户最大的可能网络磁盘空间
    限制某用户的最大磁盘配额
    限制某用户组的最大磁盘配额
    以LINK方式对目录进行用户/用户组配额
  quota的使用限制
    仅能针对整个文件系统， 如果某文件系统没有设置quota，其下的文件可以通过link来指向设置了quota的文件系统
    内核必须支持quota
    只对一般身份用户有效(root没效)
    quota的日志文件:kernel2.6的日志文件是aquota.user aquota.group ，文件名比旧版的quota前面多了个a
  quota的设置选项
    quota可以限制文件系统的block与inode的大小：限制block的大小就是其使用文件系统容量，限制inode就是限制其可创建的文件数
    限制值(soft/hard) ：hard表示用户使用的容量绝对不能超过此值。soft表示用户超过此值就会警告，并倒数宽限时间，超过宽限时间后hard=soft。
    宽限时间(grace time)
      
# 文件系统启用quota
下面以/home的文件系统为例
    # 查看/home是否启用quota
    # mount | grep home
    /dev/mapper/vg1-lv1 on /home type ext4 (rw)  # 没有
    
    # 启用 quota (用户限制与用户组限制)
    # mount -o remount,usrquota,grpquota /home
    /dev/mapper/vg1-lv1 on /home type ext4 (rw,usrquota,grpquota)
    
    # 如果要开机就启用quota
    # 可以修改/etc/fstab文件系统的选项  
    
新建quota日志文件
    quota日志文件除了进行日志记录时，也是对用户/用户组的额度进行配置
    使用quotacheck ： 扫描文件系统并新建quota日志文件(aquota.user aquota.group)
    命令格式 ： quotacheck -vug /mount_point : v：显示进度 u：新建用户日志 g：新建用户组日志
    选项：
    -u : 基于用户的配额文件
    -g : 基于组的配额文件
    -c : 创建配额数据文件
    -v : 显示执行过程信息
    -a : 检测所有可用的分区
    -m : 重新创建配额数据文件，会把以前的配额文件清除
    
启动/停止quota与限制值设置
    启动quota：quotaon /mount_point
    停止quota：quotaoff /mount_point
    
    限制值设置：edquota与setquota
    
    # 以限制用户额度为例
    # edquota -u user1 [-g groupname]  #其会打开一个关于此用户限值设置的文档
    FileSystem Blocks  soft hard Inodes  soft  hard
    /dev/sda9     80    0     0       10     0   0
    
    FileSystem：针对的文件系统
    Blocks：磁盘容量,单位KB
    soft：blocks的soft 单位KB,0表示不限制
    hard：block的hard
    inodes： Inode数量，单位个数
    soft:Inode的soft
    hard: Inode的hard
    
    我们通常只会设置block的soft与hard
    
    setquota可以帮助我们在shell script中设置quota
    其格式为：setquota [-u name][-g name] blockSoft blockHard inodeSoft inodeHard /mount_point
    
    设置宽限时间
    edquota -t

quota当前情况报表以及警告信息
    针对用户/用户组的报表 ： quota [-u|-g]vs name
    针对文件系统的报表： repquota -augvs
    发送警告信息：warnquota(当有用户超过soft时，才会成功送出两份mail，分别给root与该用户)，
如果要明天定时执行warnquota，可以在/etc/cron.daily/warnquota中写入warnquota命令的绝对路径
}
quota_ext4(){
quota一定要是独立的分区,要有quota.user和quota.group两件文件,
在/etc/fstab添加一句: 
/dev/hda3 /home ext3 defaults,usrquota,grpquota 1 2

chmod 600 quota* 设置完成,重启生效 
edquota 编辑用户或群组的quota [u]用户,[g]群组,[p]复制,[t]设置宽限期限 
edquota -a yang 
edquota -p yang -u young # 复制

quota 显示磁盘已使用的空间与限制
quotacheck 检查磁盘的使用空间与限制

quotaoff 关闭磁盘空间限制
quotaoff -a
quotaoff -ug /mount_point
	-a	全部的filesystem的quota都关闭(根据/etc/mtab)
	-u	仅针对后面接的那个/mount_point关闭user quota
-g 仅针对后面接的那个/mount_point关闭group quota

quotaon 开启磁盘空间限制
quotaon	-avug
quotaon -vug	/mount_point
	-u	针对使用者启动quota(aquota.user)
	-g	针对群组启动quota(aquota.group)
	-v	显示启动过程的相关讯息
-a 根据/etc/mtab内的filesystem设定启动有关的quota,若不加a的话,则后面就需要加上特定的那个filesystem

quotastats 显示磁盘空间限制
repquota 检查磁盘空间限制的状态

edquota -u username -g groupname
edquota -t	修改恕限时间
edquota -p	username_demo -u username
	-u	后面接账号名称
	-g	后面接群组名称
	-t	可以修改恕限时间
    -p 复制范本.意义为将username_demo这个人的quotq限制值复制给username


报告磁盘空间限制状态――repquota
repquota命令语法：
repquota [参数] [文件系统...]
repquota -a # 实例1显示所有分区中所有用户磁盘限额状况信息。
repquota -ags # 实例2以可读性较好的方式报告所有分区中群组的磁盘限额状况信息。
repquota -ugs /home/sheriff/sdb1 # 实例3报告文件系统"/home/sheriff/sdb1"的用户和群组的磁盘限额状况信息。

显示使用空间与限制――quota
quota命令语法：
quota [参数][-u 用户...][ -g 群组...][ -f 文件系统...]
quota -u root # 实例1：查看用户root的磁盘限额及其使用情况。
quota -s -u root # 实例2：以可读性较好的方式查看root用户的磁盘限额及其使用情况。
quota -g sheriff # 实例3：查看群组sheriff的磁盘限额及其使用情况。
quota           # 显示磁盘已使用的空间与限制
quota -guvs     # 秀出目前 root 自己的 quota 限制
quota -vu       # 查询

检验磁盘使用空间与限制 quotacheck
quotacheck  -avug  /mount_point
  -a  扫描所有在/etc/mtab内,含有quota支持的filesystem,加上此参数后,/mount_point可不必写,因为扫描是扫描所有的filesystem
  -u  仅针对使用者扫描档案与目录的使用情况,会建立aquota.user
  -g  针对群组扫描档案与目录的使用情况,会建立aquota.group
  -v  显示扫描过程的信息
  -M 强制进行quotacheck的扫描

实例1：创建文件系统/home/sheriff/test下的磁盘限额文件。
第1步，挂载磁盘分区/dev/sdb1到挂载点/home/sheriff/test。
mkdir /home/sheriff/test
mount -t vfat /dev/sdb1 /home/sheriff/test/
第2步，开启磁盘分区文件系统/dev/sdb1的quota功能，即编辑配置文件/etc/fstab，使得准备要开放quota功能
的磁盘分区可以支持quota。目前/home/sheriff/test是一个独立的分区的挂载点，挂载了磁盘分区/dev/sdb1。
为了开启指定磁盘分区/dev/sdb1的quota功能，用vi来编辑配置文件/etc/fstab。只要在/etc/fstab里头增加
usrquota,grpquota即可。
df
vi /etc/fstab
umount /dev/sdb1
mount -a
more /etc/mtab
第3步，扫瞄磁盘分区文件系统/dev/sdb1的使用者使用状况，并产生重要的aquota.group与aquota.user磁盘限额文件。
quotacheck -avug
ll /home/sheriff/test/

实例2：依据/etc/fstab文件，除根分区外，建立所有分区的磁盘限额文件(即文件aquota.user和aquota.group)。
第1步，挂载磁盘分区/dev/sdb1到挂载点/home/sheriff/sdb1，磁盘分区/dev/sdb5到挂载点/home/sheriff/sdb5。
mkdir /home/sheriff/sdb1
mkdir /home/sheriff/sdb5
mount -t ext3 /dev/sdb1 /home/sherif f/sdb1/
mount -t ext3 /dev/sdb5 /home/sheri ff/sdb5/
第2步，开启磁盘分区文件系统/dev/sdb1、/dev/sdb5的quota功能，即编辑配置文件/etc/fstab，使得准备要开放
quota功能的磁盘分区可以支持quota。目前/home/sheriff/sdb1，/home/sheriff/sdb5均是独立的分区的挂载点，
分别挂载了磁盘分区/dev/sdb1，/dev/sdb5。为了开启指定磁盘分区/dev/sdb1，/dev/sdb5的quota功能， 
vi来编辑配置文件/etc/fstab。只要在/etc/fstab里头增加了usrquota和grpquota即可。
df
vi /etc/fstab
ll /home/sheriff/sdb1 /home/she riff/sdb5
umount /dev/sdb1 /dev/sdb5
mount -a
more /etc/mtab
第3步，扫描除根分区外，建立的所有分区(即扫瞄磁盘分区文件系统/dev/sdb1，/dev/sdb5)的使用者使用状况，
并产生重要的aquota.group与aquota.user磁盘限额文件。
quotacheck -aRvug
ll /home/sheriff/sdb1 /home/she riff/sdb5
执行quotacheck命令后，在/home/sheriff/sdb1，/home/sheriff/sdb5目录下分别创建了两个文件aquota.user和aquota.group。

开启磁盘空间限制――quotaon
quotaon命令语法：
/sbin/quotaon [参数] [文件系统...]
实例1：启动所有分区文件系统的配额限制。
通过执行下面的more命令，可以知道当前系统中进行配额限制的分区是/dev/sdb1，/dev/sdb5。
[root@localhost ~]# more /etc/mtab
接下来执行quotaon命令，启动当前系统中进行配额限制的分区(分区/dev/sdb1和/dev/sdb5)的配额限制功能。
[root@localhost ~]# quotaon -av
实例2：启动目录/home/sheriff/sdb1所在分区用户的磁盘空间限制。
通过执行下面的quotaoff命令，关闭当前系统中进行配额限制的分区(分区/dev/sdb1和/dev/sdb5)的配额限制功能(包括对用户和群组的配额限制)。接下来，执行下面的quotaon命令，启动目录/home/sheriff/sdb1所在分区用户的磁盘空间限制。
quotaoff -av
quotaon -uv /home/sheriff/sdb1

关闭磁盘空间限制――quotaoff
quotaoff命令语法：
quotaoff [参数][文件系统...]
实例：关闭所有文件系统的配额限制。
quotaoff -av

编辑磁盘空间限制――edquota
edquota命令语法：
edquota [参数][用户或群组...]
实例1：修改用户sheriff的quota用量。
edquota -u sheriff
实例2：将用户sheriff的quota配置应用到用户cjacker上。
首先创建一个用户cjacker，然后使用如下命令将用户sheriff的quota配置应用到用户cjacker上。
edquota -p sheriff -u cjacker 
}
quota_xfs_quota(){
XFS磁盘配额

格式：xfs_quota [ -x ] [ -p prog ] [ -c cmd ] ... [ -d project ] ... [ path ... ]
选项：
    -x : 专家模式
    -p : 错误消息提示
    -c : 命令
    -d : 项目

交互模式
~]# xfs_quota -x /mnt/xfs

非交互式模式-查看帮助
~]# xfs_quota -x -c "help"
更多帮助信息，请参阅
~]# man xfs_quota

# 1. 加载文件系统 和 设置fstab
~]# mount -o uquota,gquota /dev/sdb1 /mnt/xfs
OR
~]# echo "/dev/sdb1   /mnt/xfs    xfs    defaults,uquota,gquota  0 0" >>/etc/fstab

# 2. 添加用户
~]# useradd user1
~]# chown user1.user1 /mnt/xfs

# 3. 设置用户文件数限制(700)
~]# xfs_quota -x -c 'limit isoft=500 ihard=700 user1' /mnt/xfs/

# 4. 设置组容量限制(500MB)
~]# xfs_quota -x -c 'limit -g bsoft=300m bhard=500m user1' /mnt/xfs/

# 5. 测试
~]# su - user1
~]$ dd if=/dev/zero of=/mnt/xfs/big.bin bs=1M count=501
dd: error writing '/mnt/xfs/big.bin': Disk quota exceeded
501+0 records in
500+0 records out
524288000 bytes (524 MB) copied, 0.241775 s, 2.2 GB/s

# 6. 查看
~]# xfs_quota -x -c "report -h" /mnt/xfs/
}
banner_issue_motd_system(){
sudo apt-get install sysvbanner toilet figlet
1)banner：使用#生成banner
2)figlet：使用一些普通字符生成banner             # figlet "Fu Yajun" 
3)toilet：使用一些复杂的彩色特殊字符生成banner

修改telnet banner
/etc/issue.net # 登录前显示 Linux终端登录的欢迎语句存储文件  telnet远程登录程序使用
/etc/motd
telnet 192.168.2.196

/etc/issue     # 登录前显示 Linux终端登录的欢迎语句存储文件  网络用户或通过串口登录系统
/etc/motd      # 登录后显示 message of the day 布告栏信息
1. 管理员通知用户系统何时进行软件或硬件的升级、何时进行系统维护等
2. 远程登陆是否显示欢迎信息还要看ssh的配置文件，/etc/ssh/sshd_config 的 Banner 字段
\d  (Thursday, 03 May 2018)                         本地端时间的日期
\l  (/dev/pts/1)                                    显示第几个终端机的接口
\m  (armv7l)                                        显示硬件的等级(i386/i486/i586/i686....)
\n  (rdmcu)                                         显示主机的网络名称
\o  ((none))                                        显示 domain name
\r  (3.0.15)                                        操作系统的版本 (类似 uname-r)
\t  (11:40:08)                                      显示本地端时间的时间
\s  (Linux)                                         操作系统的名称
\v  (#57 SMP PREEMPT Fri Jun 16 10:56:52 CST 2017)  操作系统的版本
}
netpbm(不同的图片格式之间相互转换){
Netpbm是Linux下的一套工具，它可以在不同的图片格式之间相互转换。
它包括300多个命令行工具在100多种不同的图片格式之间相互转换
http://netpbm.sourceforge.net/doc/
}
boxes_vim_edit(){
echo "text"|boxes -d xx # -d 选项用来设置要使用的图案的名字 
boxes -l   # -l 选项列出所有图案,它显示了在配置文件中的所有框线设计图.
-d 参数表示选择哪一个盒子模型，
-a 参数表示对齐方式。

VI,VIM中插入日期:
    vi处理命令状态 Shift+!! 键入 date 即可插入时间 
    或者
    :r!date 
    1,3!boxes -d c # shell c-cmt
eg. 有如下文本
  #!/bin/bash 
  Purpose:Backup mysql database to remote server. 
  Author:Vivek Gite 
  Last updated on :Tue Jun,12 2016 
  ##将光标移到第二行,也就是以"Purpose:..." 开头的行,输入 3!!boxes 
  #!/bin/bash 
  /**************************************/
  /*Purpose:Backup mysql database to remote server. */
  /*Author:Vivek Gite */
  /*Last updated on :Tue Jun,12 2016 */
  /*************************************/ 
eg. echo "This is a test" | boxes 
eg. echo -e "\n\t Vivek Gite\n\tVivek@nixcraft.com\n\twww.cyberciti.biz" | boxes -d dog 
}
asciiview_man(asciiview,以ASCII形式查看任何图片){
asciiview,以ASCII形式查看任何图片
我不太确定这项命令是否具备实际作用，但其无疑非常有趣; asciiview是一款将图片转化为ASCII风格的工具。
大家能够在aview软件包中找到asciiview，而其运行则要求配合imagemagik软件包。
}
chrootkit(chrootkit, 您被root过吗){
这里列出了全部root工具包、蠕虫以及可加载内核模块(简称LKM)，一旦其进入您的计算机，那么安全性将被彻底破坏。
面对这样的情况，当选百大网络安全工具殊荣的chrootkit能够帮助大家的系统保持清爽，并在有异常代码介入时发出提醒。
}
chroot(说明){
在经过 chroot 之后，系统读取到的目录和文件将不在是旧系统根下的而是新根下(即被指定的新的位置)的目录结构和文件，
1. 在经过 chroot 之后，在新根下将访问不到旧系统的根目录结构和文件，这样就增强了系统的安全性。
   一般是在登录 (login) 前使用 chroot，以此达到用户不能访问一些特定的文件。
2. 使用 chroot 后，系统读取的是新根下的目录和文件，这是一个与原系统根下文件不相关的目录结构。在这个新的环境中，
   可以用来测试软件的静态编译以及一些与系统不相关的独立开发。
3. 切换系统的根目录位置，引导 Linux 系统启动以及急救系统等。
}
chroot(命令){
$ ls -l /bin/ls
lrwxrwxrwx    1 root     root          12 Apr 13 00:46 /bin/ls -> /BusyBox\n
# mount /dev/hdc1 /mnt -t minix
# chroot /mnt
# ls -l /bin/ls
-rwxr-xr-x    1 root     root        40816 Feb  5 07:45 /bin/ls*
}
switch_root(跳转的新的root目录执行新的init进程){ runit模块内命令|busybox
switch_root  [-c /dev/console] NEW_ROOT    NEW_INIT       [ARGUMENTS_TO_INIT]
switch_root                    /mnt        /sbin/init
                               新根目录   新文件系统的init
使用PID1进程释放initramfs，然后跳转到新的root目录，然后执行新的INIT程序
1. switch_root命令必须由PID=1的进程调用，也就是必须由initramfs的init程序直接调用，不能由init派生的其他进程调用，否则会出错，
2. init脚本调用switch_root命令必须用exec命令调用，否则也会出错，
exec switch_root  /mnt /sbin/init              # 转换
}
chpst(跳转进程状态执行新进程){  runit模块内命令|busybox
chpst  [-vP012]  [-u user] [-U user] [-b argv0] [-e dir] [-/ root] [-n inc] [-l|-L lock] [-m bytes] [-d bytes] [-o n] [-pn] [-f bytes] [-c bytes] prog
-u [:]user[:group]   setuidgid
-U [:]user[:group]   envuidgid
-b argv0
-/ DIR      Chroot to DIR
-n NICE     Add NICE to nice value
-m BYTES    Same as -d BYTES -s BYTES -l BYTES
-d BYTES    Limit data segment
-o N        Limit number of open files per process
-p N        Limit number of processes per uid
-f BYTES    Limit output file sizes
-c BYTES    Limit core file size
-P 创建新的进程组
-0 关闭标准输入
-1 关闭标准输出
-2 关闭错误输出
}
runsv(){}
runsvdir(){}
sv(){}
svlogd(){}

figlet(一款简单的横幅制作工具){
多年以来，互联网上一直在利用ASCII码生成横幅字体。大家知道它们是如何产生的吗？答案正是figlet。大家可以利用多种
不同字体进行横幅渲染; 另外，如果大家不打算在自有设备上运行figlet，还可以使用在线Figlet服务器及服务
}
inotify-tools(追踪文件系统事件){
，inotify是'一套Linux内核子系统，能够作为扩展文件系统以通知一切指向该文件系统的变更，同时将变更报告至其它应用'。
如果大家需要以异步方式操作文件，并希望对文件创建、修改或者删除事件加以追踪，那么这款软件包将值得一试。
}

pandoc(命令行文件类型转换工具@Pandoc只能够处理基于文本的文件){
Pandoc 是一个命令行工具，用于将文件从一种标记语言转换为另一种标记语言。
标记语言使用标签来标记文档的各个部分。
常用的标记语言包括 Markdown、ReStructuredText、HTML、LaTex、ePub 和 Microsoft Word DOCX。
sudo apt-get install pandoc pandoc-citeproc texlive

# 由包含数学公式的 LaTeX 文件创建的网页
% Pandoc math demos
$a^2 + b^2 = c^2$
$v(t) = v_0 + \frac{1}{2}at^2$
$\gamma = \frac{1}{\sqrt{1 - v^2/c^2}}$
$\exists x \forall y (Rxy \equiv Ryx)$
$p \wedge q \models p$
$\Box\diamond p\equiv\diamond p$
$\int_{0}^{1} x dx = \left[ \frac{1}{2}x^2 \right]_{0}^{1} = \frac{1}{2}$
$e^x = \sum_{n=0}^\infty \frac{x^n}{n!} = \lim_{n\rightarrow\infty} (1+x/n)^n$
# pandoc math.tex -s --mathml -o mathMathML.html
-s 告诉 Pandoc 生成一个独立的网页(而不是网页片段，因此它将包括 HTML 中的 head 和 body 标签)
-mathml 参数强制 Pandoc 将 LaTeX 中的数学公式转换成 MathML，从而可以由现代浏览器进行渲染。

pandoc -t revealjs -s --self-contained SLIDES \ -V theme=white -V slideNumber=true -o index.html
-t revealjs 表示将输出一个 revealjs 演示文稿
-s 告诉 Pandoc 生成一个独立的文档
--self-contained 生成没有外部依赖关系的 HTML 文件
-V 设置以下变量：
theme=white 将幻灯片的主题设为白色
slideNumber=true 显示幻灯片编号
-o index.html 在名为 index.html 的文件中生成幻灯片

https://opensource.com/article/18/9/intro-pandoc
pandoc -s -V css=style-epub.css document.md document.epub 
pandoc -s -V css=style-html.css document.md document.html

pandoc -t rst myFile.html -o myFile.rst #实现从HTML格式转换为reStructuredText格式
}
jq(man){
jq ′.′
        "Hello, world!"
    => "Hello, world!"

jq ′.foo′
    {"foo": 42, "bar": "less interesting data"}
    => 42
    jq ′.foo′
    {"notfoo": true, "alsonotfoo": false}
    => null
    
jq ′.[0]′
    [{"name":"JSON", "good":true}, {"name":"XML", "good":false}]
    => {"name":"JSON", "good":true}
    
    jq ′.[2]′
    [{"name":"JSON", "good":true}, {"name":"XML", "good":false}]
    => null   
    
jq ′.[]′
    [{"name":"JSON", "good":true}, {"name":"XML", "good":false}]
    => {"name":"JSON", "good":true}, {"name":"XML", "good":false}
    
    jq ′.[]′
    []
    =>
jq ′.foo, .bar′
    {"foo": 42, "bar": "something else", "baz": true}
    => 42, "something else"
    
    jq ′.user, .projects[]′
    {"user":"stedolan", "projects": ["jq", "wikiflow"]}
    => "stedolan", "jq", "wikiflow"
    
    jq ′.[4,2]′
    ["a","b","c","d","e"]
    => "e", "c"

jq ′.[] | .name′
    [{"name":"JSON", "good":true}, {"name":"XML", "good":false}]
    => "JSON", "XML"
}
当你要处理棘手的 XML 时候，xmlstarlet 算是上古时代流传下来的神器。 # man

# 使用 shyaml 处理 YAML。
# 要处理 Excel 或 CSV 文件的话，csvkit 提供了 in2csv，csvcut，csvjoin，csvgrep 等方便易用的工具。


LibreOffice(命令行文件类型转换工具@LibreOffice幻灯片转换成PDF){
soffice --headless --convert-to pdf mySlides.odp
soffice --headless --convert-to odt *.docx
}
LibreOffice(命令行文件类型转换工具@音频和视频格式文件转换领域的'瑞士军刀'){
ffmpeg -i myVideo.avi myvideo.ogg
}

restore(){
foremost    命令行     formost 是一个基于文件头和尾部信息以及文件的内建数据结构恢复文件的命令行工具
    apt-get install foremost
    #rm -f /dev/sdb1/photo1.png
    #foremost -t png -i /dev/sdb1
    #foremost -v -T -t doc,pdf,jpg,gif -i /dev/sda6 -o /media/disk/Recover
extundelete 命令行      Extundelete 是 ext3、ext4 文件系统的恢复工具
    apt-get install extundelete
    # extundelete /dev/sdd1 --restore-file del1.txt
    如果恢复一个目录
    # extundelete /dev/sdd1 --restore-directory /backupdate/deldate
    恢复所有文件
    # extundelete /dev/sdd1 --restore-all
    获取恢复文件校验码，对比检测是否恢复成功
    # md5sum RECOVERED_FILES/ del1.txt                         
    66fb6627dbaa37721048e4549db3224d  RECOVERED_FILES/del1.txt
scalpel     命令行      scalpel 是一种快速文件恢复工具，它通过读取文件系统的数据库来恢复文件。它是独立于文件系统的
    scalpel /dev/sdb1 -o /RECOVERY/
testdisk    字符终端    Testdisk 支持分区表恢复、raid 恢复、分区恢复
    apt-get install testdisk
    #testdisk
        ［Create］新建  ->
            选择连接状态的磁盘设备 ->
                选择 [None ] Non partitioned media ->
                    对分区进行分析->
                        选择"Deep Search"进行一次深入检测->
                            红色的文件名称就是已经被删除的文件 ->
        ［Append］追加
        ［No Log］不纪录
phtorec     字符终端    photorec 用来恢复硬盘、光盘中丢失的视频、文档、压缩包等文件，或从数码相机存储卡中恢复丢失的图片
    photorec 是 testdisk 的伴侣程序，安装 testdisk 后 photorec 就可以使用了
}
quick(){
bpython或 ptpython：具有自动补全支持的 Python REPL。
http-prompt：交互式 HTTP 客户端。
mycli：MySQL、MariaDB 和 Percona 的命令行界面，具有自动补全和语法高亮。
pgcli：具有自动补全和语法高亮，是对 psql 的替代工具。
wharfee：用于管理 Docker 容器的 shell。
}
    dialog(对话框){

        # 默认将所有输出用 stderr 输出，不显示到屏幕   使用参数  --stdout 可将选择赋给变量
        # 退出状态  0正确  1错误

        窗体类型{
            --calendar          # 日历
            --checklist         # 允许你显示一个选项列表，每个选项都可以被单独的选择 (复选框)
            --form              # 表单,允许您建立一个带标签的文本字段，并要求填写
            --fselect           # 提供一个路径，让你选择浏览的文件
            --gauge             # 显示一个表，呈现出完成的百分比，就是显示出进度条。
            --infobox           # 显示消息后，(没有等待响应)对话框立刻返回，但不清除屏幕(信息框)
            --inputbox          # 让用户输入文本(输入框)
            --inputmenu         # 提供一个可供用户编辑的菜单(可编辑的菜单框)
            --menu              # 显示一个列表供用户选择(菜单框)
            --msgbox(message)   # 显示一条消息,并要求用户选择一个确定按钮(消息框)
            --password          # 密码框，显示一个输入框，它隐藏文本
            --pause             # 显示一个表格用来显示一个指定的暂停期的状态
            --radiolist         # 提供一个菜单项目组，但是只有一个项目，可以选择(单选框)
            --tailbox           # 在一个滚动窗口文件中使用tail命令来显示文本
            --tailboxbg         # 跟tailbox类似，但是在background模式下操作
            --textbox           # 在带有滚动条的文本框中显示文件的内容  (文本框)
            --timebox           # 提供一个窗口，选择小时，分钟，秒
            --yesno(yes/no)     # 提供一个带有yes和no按钮的简单信息框
        }

        窗体参数{
            --separate-output          # 对于chicklist组件,输出结果一次输出一行,得到结果不加引号
            --ok-label "提交"          # 确定按钮名称
            --cancel-label "取消"      # 取消按钮名称
            --title "标题"             # 标题名称
            --stdout                   # 将所有输出用 stdout 输出
            --backtitle "上标"         # 窗体上标
            --no-shadow                # 去掉窗体阴影
            --menu "菜单名" 20 60 14   # 菜单及窗口大小
            --clear                    # 完成后清屏操作
            --no-cancel                # 不显示取消项
            --insecure                 # 使用星号来代表每个字符
            --begin <y> <x>            # 指定对话框左上角在屏幕的上的做坐标
            --timeout <秒>             # 超时,返回的错误代码255,如果用户在指定的时间内没有给出相应动作,就按超时处理
            --defaultno                # 使选择默认为no
            --default-item <str>       # 设置在一份清单，表格或菜单中的默认项目。通常在框中的第一项是默认
            --sleep 5                  # 在处理完一个对话框后静止(延迟)的时间(秒)
            --max-input size           # 限制输入的字符串在给定的大小之内。如果没有指定，默认是2048
            --keep-window              # 退出时不清屏和重绘窗口。当几个组件在同一个程序中运行时，对于保留窗口内容很有用的
        }

        dialog --title "Check me" --checklist "Pick Numbers" 15 25 3 1 "one" "off" 2 "two" "on"         # 多选界面[方括号]
        dialog --title "title" --radiolist "checklist" 20 60 14 tag1 "item1" on tag2 "item2" off        # 单选界面(圆括号)
        dialog --title "title" --menu "MENU" 20 60 14 tag1 "item1" tag2 "item2"                         # 单选界面
        dialog --title "Installation" --backtitle "Star Linux" --gauge "Linux Kernel"  10 60 50         # 进度条
        dialog --title "标题" --backtitle "Dialog" --yesno "说明" 20 60                                 # 选择yes/no
        dialog --title "公告标题" --backtitle "Dialog" --msgbox "内容" 20 60                            # 公告
        dialog --title "hey" --backtitle "Dialog" --infobox "Is everything okay?" 10 60                 # 显示讯息后立即离开
        dialog --title "hey" --backtitle "Dialog" --inputbox "Is okay?" 10 60 "yes"                     # 输入对话框
        dialog --title "Array 30" --backtitle "All " --textbox /root/txt 20 75                          # 显示文档内容
        dialog --title "Add" --form "input" 12 40 4 "user" 1 1 "" 1 15 15 0 "name" 2 1 "" 2 15 15 0     # 多条输入对话框
        dialog --title  "Password"  --insecure  --passwordbox  "请输入密码"  10  35                     # 星号显示输入--insecure
        dialog --stdout --title "日历"  --calendar "请选择" 0 0 9 1 2010                                # 选择日期
        dialog --title "title" --menu "MENU" 20 60 14 tag1 "item1" tag2 "item2" 2>tmp                   # 取到结果放到文件中(以标准错误输出结果)
        a=`dialog --title "title"  --stdout --menu "MENU" 20 60 14 tag1 "item1" tag2 "item2"`           # 选择操作赋给变量(使用标准输出)

        dialog菜单实例{
            while :
            do
            clear
            menu=`dialog --title "title"  --stdout --menu "MENU" 20 60 14 1 system 2 custom`
            [ $? -eq 0 ] && echo "$menu" || exit         # 判断dialog执行,取消退出
                while :
                do
                    case $menu in
                    1)
                        list="1a "item1" 2a "item2""     # 定义菜单列表变量
                    ;;
                    2)
                        list="1b "item3" 2b "item4""
                    ;;
                    esac
                    result=`dialog --title "title"  --stdout --menu "MENU" 20 60 14 $list`
                    [ $? -eq 0 ] && echo "$result" || break    # 判断dialog执行,取消返回菜单,注意:配合上层菜单循环
                    read
                done
            done
        }

    }

    whiptail(){
    whiptail - display dialog boxes from shell scripts
    # --msgbox
    whiptail --title "Example Dialog" --msgbox "This is an example of a message box. You must hit OK to continue." 8 78
    # --infobox
    whiptail --title "Example Dialog" --infobox "This is an example of a message box. You must hit OK to continue." 8 78
    # whiptail - yesno
        #! /bin/bash
        # http://archives.seul.org/seul/project/Feb-1998/msg00069.html
        if (whiptail --title "PPP Configuration" --backtitle "Welcome to SEUL" --yesno "
        Do you want to configure your PPP connection?"  10 40 )
        then 
                echo -e "\nWell, you better get busy!\n"
        elif    (whiptail --title "PPP Configuration" --backtitle "Welcome to
        SEUL" --yesno "           Are you sure?" 7 40)
                then
                        echo -e "\nGood, because I can't do that yet!\n"
                else
                        echo -e "\nToo bad, I can't do that yet\n"
        fi

        whiptail --title "Example Dialog" --yesno "This is an example of a yes/no box." 8 78
        exitstatus=$?
        if [ $exitstatus = 0 ]; then
            echo "User selected Yes."
        else
            echo "User selected No."
        fi
         
        echo "(Exit status was $exitstatus)"

        设置--yes-button，--no-button，--ok-button 按钮的文本
        whiptail --title "Example Dialog" --yesno "This is an example of a message box. You must hit OK to continue." 8 78 --no-button 取消 --yes-button 确认
    
    # whiptail - inputbox
    result=$(tempfile) ; chmod go-rw $result
    whiptail --inputbox "Enter some text" 10 30 2>$result
    echo Result=$(cat $result)
    rm $result
    
    COLOR=$(whiptail --inputbox "What is your favorite Color?" 8 78 --title "Example Dialog" 3>&1 1>&2 2>&3)
    exitstatus=$?
    if [ $exitstatus = 0 ]; then
        echo "User selected Ok and entered " $COLOR
    else
        echo "User selected Cancel."
    fi
    
    echo "(Exit status was $exitstatus)"				

        # --passwordbox
        # whiptail - passwordbox			
        whiptail --title "Example Dialog" --passwordbox "This is an example of a password box. You must hit OK to continue." 8 78			
        
        # --textbox
        # whiptail - passwordbox
        whiptail --title "Example Dialog" --textbox /etc/passwd 20 60
                    
        
        # 为文本取添加滚动条功能
        whiptail --title "Example Dialog" --textbox /etc/passwd 20 60 --scrolltext
        
        # --checklist
        whiptail --title "Check list example" --checklist \
        "Choose user's permissions" 20 78 16 \
        "NET_OUTBOUND" "Allow connections to other hosts" ON \
        "NET_INBOUND" "Allow connections from other hosts" OFF \
        "LOCAL_MOUNT" "Allow mounting of local devices" OFF \
        "REMOTE_MOUNT" "Allow mounting of remote devices" OFF
        
        # --radiolist
        whiptail --title "Check list example" --radiolist \
        "Choose user's permissions" 20 78 16 \
        "NET_OUTBOUND" "Allow connections to other hosts" ON \
        "NET_INBOUND" "Allow connections from other hosts" OFF \
        "LOCAL_MOUNT" "Allow mounting of local devices" OFF \
        "REMOTE_MOUNT" "Allow mounting of remote devices" OFF
        
        # --menu
        whiptail --title "Menu example" --menu "Choose an option" 22 78 16 \
        "<-- Back" "Return to the main menu." \
        "Add User" "Add a user to the system." \
        "Modify User" "Modify an existing user." \
        "List Users" "List all users on the system." \
        "Add Group" "Add a user group to the system." \
        "Modify Group" "Modify a group and its list of members." \
        "List Groups" "List all groups on the system."
    }
    select菜单{

        # 输入项不在菜单自动会提示重新输入
        select menuitem in pick1 pick2 pick3 退出
        do
            echo $menuitem
            case $menuitem in
            退出)
                exit
            ;;
            *)
                select area in area1 area2 area3 返回
                do
                    echo $area
                    case $area in
                    返回)
                        break
                    ;;
                    *)
                        echo "对$area操作"
                    ;;
                    esac
                done
            ;;
            esac
        done

    }

    shift{

        ./cs.sh 1 2 3
        #!/bin/sh
        until [ $# -eq 0 ]
        do
            echo "第一个参数为: $1 参数个数为: $#"
            #shift 命令执行前变量 $1 的值在shift命令执行后不可用
            shift
        done

    }
    
    getopt(){
-------------------------------------------------------------------------------
    getopt [options] -o|--options optstring [options] [--] parameters
    -a：使getopt长参数支持"-"符号打头，必须与-l同时使用
    -l：后面接getopt支持长参数列表
    -n program：如果getopt处理参数返回错误，会指出是谁处理的这个错误，这个在调用多个脚本时，很有用
    -o：后面接短参数列表，这种用法与getopts类似
    -u：不给参数列表加引号，默认是加引号的(不使用-u选项)，例如在加不引号的时候 --longoption "arg1 arg2" ，只会取到"arg1"，而不是完整的"arg1 arg2"
-------------------------------------------------------------------------------
ARGV=($(getopt -o 短选项1[:]短选项2[:]...[:]短选项n -l 长选项1,长选项2,...,长选项n -- "$@"))
for((i = 0; i < ${#ARGV[@]}; i++)) {
    eval opt=${ARGV[$i]}
    case $opt in
    -短选项1|--长选项1)
       process
       ;;
    # 带参数
    -短选项2|--长选项2)
       ((i++));
       eval opt=${ARGV[$i]}
       ;;
    ...
    -短选项n|--长选项n)
       process
       ;;
    --)
       break
       ;;
    esac
}
-------------------------------------------------------------------------------
ARGV=($(getopt -o 短选项1[:]短选项2[:]...[:]短选项n -l 长选项1,长选项2,...,长选项n -- "$@"))
eval set -- "$ARGV"
while true
do
    case "$1" in
    -短选项1|--长选项1)
        process
        shift
        ;;
    -短选项2|--长选项2)
        # 获取选项
        opt = $2
        process
        shift 2
        ;;
    ......
    -短选项3|--长选项3)
        process
        ;;
    --)
break
;;
esac
}
-------------------------------------------------------------------------------
ARGS=`getopt -a -o I:D:T:e:k:LMSsth -l instence:,database:,table:,excute:,key:,list,master,slave,status,tableview,help -- "$@"`
[ $? -ne 0 ] && usage
#set -- "${ARGS}"
eval set -- "${ARGS}"
while true
do
        case "$1" in
        -I|--instence)
                instence="$2"
                shift
                ;;
        -D|--database)
                database="$2"
                shift
                ;;
        -T|--table)
                table="$2"
                shift
                ;;
        -e|--excute)
                excute="yes"
                shift
                ;;
        -k|--key)
                key="$2"
                shift
                ;;
        -L|--list)
                LIST="yes"
                ;;
        -M|--master)
                MASTER="yes"
                ;;
        -S|--slave)
                SLAVE="yes"
                ;;
        -A|--alldb)
                ALLDB="yes"
                ;;
        -s|--status)
                STATUS="yes"
                ;;
        -t|--tableview)
                TABLEVIEW="yes"
                ;;
        -h|--help)
                usage
                ;;
        --)
                shift
                break
                ;;
        esac
shift
done

   }

    getopts(给脚本加参数){

        #!/bin/sh
        while getopts :ab: name
        do
            case $name in
            a)
                aflag=1
            ;;
            b)
                bflag=1
                bval=$OPTARG
            ;;
            \?)
                echo "USAGE:`basename $0` [-a] [-b value]"
                exit  1
            ;;
            esac
        done
        if [ ! -z $aflag ] ; then
            echo "option -a specified"
            echo "$aflag"
            echo "$OPTIND"
        fi
        if [ ! -z $bflag ] ; then
            echo  "option -b specified"
            echo  "$bflag"
            echo  "$bval"
            echo  "$OPTIND"
        fi
        echo "here  $OPTIND"
        shift $(($OPTIND -1))
        echo "$OPTIND"
        echo " `shift $(($OPTIND -1))`  "

    }

    vsftp(安装)
    {
    # 安装vsftp服务 
    yum install vsftpd -y 
    # 启动vsftp服务 
    service vsftpd start 
    # 设置vsftp开机启动 
    chkconfig vsftpd on 
    chkconfig |grep vsftpd 
    # 查看vsftp端口 
    netstat -tan |grep vsftpd

    }
    
    vsftp(配置)
    {
        vi /etc/vsftpd/vsftpd.conf 
        # 关闭匿名访问 默认为YES, 修改为NO
        anonymous_enable=NO
        
        # ADD 增加以下
        # vsftp用户主目录 (可选), 针对系统用户 /var/www/html
        local_root=/home/www
        
        # 锁定主目录 NO为不锁定
        chroot_local_user=YES
        
        # 开启 userlist 用户列表文件 /etc/vsftpd/user_list
        userlist_deny=NO
        
        # 是否使用主机的时间
        use_localtime=Yes
        
        # 添加此行: 修改vsftpd服务端口 (TCP)
        listen_port=2121
        
        # 数据传输端口 (TCP)
        ftp_data_port=2020
        
        # 被动连接端口 (最小)
        pasv_min_port=50001
        
        # 被动连接端口 (最大)
        pasv_max_port=51000
        
        # 激活时，将关闭PASV模式的安全检查 (防火墙里添加被动端口后无需关闭安全检查)
        pasv_promiscuous=YES
    }
    
    vsftp(添加用户)
    {
    # 创建用户, 添加用户组, 指定用户证目录 
    useradd 用户名 -g 用户组 -d /指定用户目录 -s /sbin/nologin 
    # 设置用户密码 
    passwd 用户名
    # 重新启动vsftp服务 
    service vsftpd restart 
    # 测试vsftpd连接 
    fpn -n 
    >open ftp服务器地址 端口 
    >user 用户名 密码 
    # 出现类似以下信息, 表示成功! 
    # 331 Please specify the password. 
    # 230 Login successful.
    }
    
    postfix()
    {
        postfix的产生是为了替代传统的sendmail.相较于sendmail,postfix在速度，性能和稳定性上都更胜一筹。现在目前非常多
    的主流邮件服务其实都在采用postfix. 当我们需要一个轻量级的的邮件服务器是，postfix不失为一种选择。
    
    安装postfix.
    redhat6.0以上版本应该是默认集成了postfix服务的，假如没有安装的话，可以手动安装。
    rpm -qa | grep postifx (查看是否安装)
    yum install postfix
    
    安装完成后，修改配置文件：/etc/postfix/main.cfg
    vi /etc/postfix/main.cf
    myhostname = sample.test.com　 ← 设置系统的主机名
    mydomain = test.com　 ← 设置域名(我们将让此处设置将成为E-mail地址'@'后面的部分)
    myorigin = $mydomain　 ← 将发信地址'@'后面的部分设置为域名(非系统主机名)
    inet_interfaces = all　 ← 接受来自所有网络的请求
    mydestination = $myhostname, localhost.$mydomain, localhost, $mydomain　 ← 指定发给本地邮件的域名
    home_mailbox = Maildir/　 ← 指定用户邮箱目录
    
    为本机添加DNS server.
    vim /etc/resolv.conf 
    添加如下行:
    nameserver 8.8.8.8
    nameserver 8.8.4.4
    
    测试一下邮件是否能够发送成功：
    命令行输入$: > echo "Mail Content" | mail -s "Mail Subject" ldyjs@agent109.cloud.com
    
    查看log，确认邮件发送状态：
    Postfix邮件的log位置是：/var/log/maillog
    发送成功的话，会返回250和OK，也可以去自己的邮件客户端查收。
    一切OK的话，那Postfix mail service应该就搭建成功了。
    &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
    一些有用的postfix维护命令，一遍日常的检测和维护：
    mailq :会列出当前在postfix发送队列中的所有邮件
    postsuper -d ALL:删除当前等待发送队列的所有邮件，包括发送失败的退信
    当然还有很多，就不一一列举了，大家可以网上搜索扩展，Good Luck!
    }
    tclsh(){

        set foo "a bc"                   # 定义变量
        set b {$a};                      # 转义  b的值为" $a " ,而不是变量结果
        set a 3; incr a 3;               # 数字的自增.  将a加3,如果要减3,则为 incr a -3;
        set c [expr 20/5];               # 计算  c的值为4
        puts $foo;                       # 打印变量
        set qian(123) f;                 # 定义数组
        set qian(1,1,1) fs;              # 多维数组
        parray qian;                     # 打印数组的所有信息
        string length $qian;             # 将返回变量qian的长度
        string option string1 string2;   # 字符相关串操作
        # option 的操作选项:
        # compare           按照字典的排序方式进行比较。根据string1 <,=,>string2分别返回-1,0,1
        # first             返回string2中第一次出现string1的位置，如果没有出现string1则返回-1
        # last              和first相反
        # trim              从string1中删除开头和结尾的出现在string2中的字符
        # tolower           返回string1中的所有字符被转换为小写字符后的新字符串
        # toupper           返回string1中的所有字符串转换为大写后的字符串
        # length            返回string1的长度
        set a 1;while {$a < 3} { set a [incr a 1;]; };puts $a    # 判断变量a小于3既循环
        for {initialization} {condition} {increment} {body}      # 初始化变量,条件,增量,具体操作
        for {set i 0} {$i < 10} {incr i} {puts $i;}              # 将打印出0到9
        if { 表达式 } {
             #运算;
        } else {
             #其他运算;
        }
        switch $x {
            字符串1 { 操作1 ;}
            字符串2 { 操作2 ;}
        }
        foreach element {0 m n b v} {
        # 将在一组变元中进行循环，并且每次都将执行他的循环体
               switch $element {
                     # 判断element的值
             }
        }

        expect(expect自动登陆不退出){
set timeout 10 #timeout is 10s
spawn ssh $USER@$SERVER
expect {
"(yes/no)?"
{
        send "yes\n"
        expect "*assword:" { send "$PASSWARD"}
}
"*assword:"
{
        send "$PASSWARD"
}
}
interact
        }
        expect(expect自动登陆执行指定命令并退出){
        expect自动登陆执行指定命令并退出

spawn ssh $USER@$SERVER
expect {
"(yes/no)?"
{
        send "yes\n"
        expect "*assword:" { send "$PASSWARD"}
}
"*assword:"
{
        send "$PASSWARD"
}
}

expect "# "
send "$YOUR_CMD\n"
expect "$EXPECT_PRINTS"
send "exit\n"
expect eof
        }
        expect交互(){

            exp_continue         # 多个spawn命令时并行
            interact             # 执行完成后保持交互状态，把控制权交给控制台
            expect "password:"   # 判断关键字符
            send "passwd\r"      # 执行交互动作，与手工输入密码的动作等效。字符串结尾加"\r"

            ssh后sudo{

                #!/bin/bash
                #sudo注释下行允许后台运行
                #Defaults requiretty
                #sudo去掉!允许远程
                #Defaults !visiblepw

                /usr/bin/expect -c '
                set timeout 5
                spawn ssh -o StrictHostKeyChecking=no xuesong1@192.168.42.128 "sudo grep xuesong1 /etc/passwd"
                expect {
                    "passphrase" {
                        send_user "sshkey\n"
                        send "xuesong\r";
                        expect {
                            "sudo" {
                            send_user "sudo\n"
                            send "xuesong\r"
                            interact
                            }
                            eof {
                            send_user "sudo eof\n"
                            }
                        }
                    }
                    "password:" {
                        send_user "ssh\n"
                        send "xuesong\r";
                        expect {
                            "sudo" {
                            send_user "sudo\n"
                            send "xuesong\r"
                            interact
                            }
                            eof {
                            send_user "sudo eof\n"
                            }
                        }
                    }
                    "sudo" {
                            send_user "sudo\n"
                            send "xuesong\r"
                            interact
                            }
                    eof {
                        send_user "ssh eof\n"
                    }
                }
                '

            }

            ssh执行命令操作{

                /usr/bin/expect -c "
                proc jiaohu {} {
                    send_user expect_start
                    expect {
                        password {
                            send ${RemotePasswd}\r;
                            send_user expect_eof
                            expect {
                                \"does not exist\" {
                                    send_user expect_failure
                                    exit 10
                                }
                                password {
                                    send_user expect_failure
                                    exit 5
                                }
                                Password {
                                    send ${RemoteRootPasswd}\r;
                                    send_user expect_eof
                                    expect {
                                        incorrect {
                                            send_user expect_failure
                                            exit 6
                                        }
                                        eof
                                    }
                                }
                                eof
                            }
                        }
                        passphrase {
                            send ${KeyPasswd}\r;
                            send_user expect_eof
                            expect {
                                \"does not exist\" {
                                    send_user expect_failure
                                    exit 10
                                }
                                passphrase{
                                    send_user expect_failure
                                    exit 7
                                }
                                Password {
                                    send ${RemoteRootPasswd}\r;
                                    send_user expect_eof
                                    expect {
                                        incorrect {
                                            send_user expect_failure
                                            exit 6
                                        }
                                        eof
                                    }
                                }
                                eof
                            }
                        }
                        Password {
                            send ${RemoteRootPasswd}\r;
                            send_user expect_eof
                            expect {
                                incorrect {
                                    send_user expect_failure
                                    exit 6
                                }
                                eof
                            }
                        }
                        \"No route to host\" {
                            send_user expect_failure
                            exit 4
                        }
                        \"Invalid argument\" {
                            send_user expect_failure
                            exit 8
                        }
                        \"Connection refused\" {
                            send_user expect_failure
                            exit 9
                        }
                        \"does not exist\" {
                            send_user expect_failure
                            exit 10
                        }

                        \"Connection timed out\" {
                            send_user expect_failure
                            exit 11
                        }
                        timeout {
                            send_user expect_failure
                            exit 3
                        }
                        eof
                    }
                }
                set timeout $TimeOut
                switch $1 {
                    Ssh_Cmd {
                        spawn ssh -t -p $Port -o StrictHostKeyChecking=no $RemoteUser@$Ip /bin/su - root -c \\\"$Cmd\\\"
                        jiaohu
                    }
                    Ssh_Script {
                        spawn scp -P $Port -o StrictHostKeyChecking=no $ScriptPath $RemoteUser@$Ip:/tmp/${ScriptPath##*/};
                        jiaohu
                        spawn ssh -t -p $Port -o StrictHostKeyChecking=no $RemoteUser@$Ip /bin/su - root -c  \\\"/bin/sh /tmp/${ScriptPath##*/}\\\" ;
                        jiaohu
                    }
                    Scp_File {
                        spawn scp -P $Port -o StrictHostKeyChecking=no -r $ScpPath $RemoteUser@$Ip:${ScpRemotePath};
                        jiaohu
                    }
                }
                "
                state=`echo $?`

            }

            交互双引号引用较长变量{

                #!/bin/bash
                RemoteUser=xuesong12
                Ip=192.168.1.2
                RemotePasswd=xuesong
                Cmd="/bin/echo "$PubKey" > "$RemoteKey"/authorized_keys"

                /usr/bin/expect -c "
                set timeout 10
                spawn ssh -o StrictHostKeyChecking=no $RemoteUser@$Ip {$Cmd};
                expect {
                    password: {
                        send_user RemotePasswd\n
                        send ${RemotePasswd}\r;
                        interact;
                    }
                    eof {
                        send_user eof\n
                    }
                }
                "

            }

            telnet(交互expect){
                #!/bin/bash
                Ip="10.0.1.53"
                a="\{\'method\'\:\'doLogin\'\,\'params\'\:\{\'uName\'\:\'bobbietest\'\}"
                /usr/bin/expect -c"
                        set timeout 15
                        spawn telnet ${Ip} 8000
                        expect "Escape"
                        send "${a}\\r"
                        expect {
                                -re "\"err.*none\"" {
                                        exit 0
                                }
                                timeout {
                                        exit 1
                                }
                                eof {
                                        exit 2
                                }
                        }
                "
                echo $?
            }
            telent(交互管道){
echo "My own command..." &&
(sleep 1; echo "root"; \
 sleep 1; echo "123456"; \
 sleep 1; echo "cd /usr/local"; \
 sleep 1; echo "rtu_conf"; \
 while [[ true ]]; do \
     sleep 1; \
     exit; \
 done;) | telnet 192.168.1.241
            }

            模拟ssh登录{
                #好处:可加载环境变量

                #!/bin/bash
                Ip='192.168.1.6'            # 循环就行
                RemoteUser='user'           # 普通用户
                RemotePasswd='userpasswd'   # 普通用户的密码
                RemoteRootPasswd='rootpasswd'
                /usr/bin/expect -c "
                set timeout -1
                spawn ssh -t -p $Port -o StrictHostKeyChecking=no $RemoteUser@$Ip
                expect {
                    password {
                        send_user RemotePasswd
                        send ${RemotePasswd}\r;
                        expect {
                            \"does not exist\" {
                                send_user \"root user does not exist\n\"
                                exit 10
                            }
                            password {
                                send_user \"user passwd error\n\"
                                exit 5
                            }
                            Last {
                                send \"su - batch\n\"
                                expect {
                                    Password {
                                        send_user RemoteRootPasswd
                                        send ${RemoteRootPasswd}\r;
                                        expect {
                                            \"]#\" {
                                                send \"sh /tmp/update.sh update\n \"
                                                expect {
                                                    \"]#\" {
                                                        send_user ${Ip}_Update_Done\n
                                                    }
                                                    eof
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                    \"No route to host\" {
                        send_user \"host not found\n\"
                        exit 4
                    }
                    \"Invalid argument\" {
                        send_user \"incorrect parameter\n\"
                        exit 8
                    }
                    \"Connection refused\" {
                        send_user \"invalid port parameters\n\"
                        exit 9
                    }
                    \"does not exist\" {
                        send_user \"root user does not exist\"
                        exit 10
                    }
                    timeout {
                        send_user \"connection timeout \n\"
                        exit 3
                    }
                    eof
                }
                "
                state=`echo $?`

            }

        }

    }

}

system(性能){
CPU占用最高的10个进程
    ps axww -o user,pid,pcpu,pmem,start,time,comm | head -1;ps axww -o user,pid,pcpu,pmem,start,time,comm  | grep -v PID |  sort -nr -k 3 | head
    ps aux|head -1;ps aux|grep -v PID|sort -rn -k +3|head
    ps auxw|head -1;ps auxw|sort -rn -k3|head -10
内存占用最高的10个进程
    ps axww -o user,pid,pcpu,pmem,start,time,comm | head -1 ;ps axww -o user,pid,pcpu,pmem,start,time,comm  | grep -v PID |  sort -nr -k 4 | head
    ps aux|head -1;ps aux|grep -v PID|sort -rn -k +4|head
    ps auxw|head -1;ps auxw|sort -rn -k4|head -10
虚拟内存使用最多的前10个进程
    ps auxw|head -1;ps auxw|sort -rn -k5|head -10
查看系统负载
    dstat --top-mem --top-io --top-cpu --nocolor 1 10
统计当前连接数
    ss -an | grep -v "State" | awk '{++S[$1]} END {for(a in S) print a, S[a]}'
    netstat -tan  | awk '/^tcp/ {++S[$NF]} END {for(a in S) print a, S[a]}'
当前连接数最多的10个进程
    ss -tnp | grep -v "State" | awk '{print $6}' | awk -F '"' '{print $2}' | awk '{++S[$1]} END {for(a in S) print a, S[a]}' | sort -nr -k2 | head
    netstat -tnp | grep -v "Active" | grep -v "TIME_WAIT" | grep -v "State" | awk -F '/' '{print $NF}' | awk '{++S[$1]} END {for(a in S) print a, S[a]}' | sort -nr -k2 | head

top # display and update the top cpu processes 
mpstat 1 # display processors related statistics 
vmstat 2 # display virtual memory statistics 
iostat 2 # display I/O statistics (2 s intervals)
ipcs -a # information on System V interprocess
}
system(instance){

    从1叠加到100{
        echo $[$(echo +{1..100})]
        echo $[(100+1)*(100/2)]
        seq -s '+' 100 |bc
    }

    判断参数是否为空-空退出并打印null{
        #!/bin/sh
        echo $1
        name=${1:?"null"}
        echo $name
    }

    循环数组{
        for ((i=0;i<${#o[*]};i++))
        do
            echo ${o[$i]}
        done
    }

    判断路径{
        if [ -d /root/Desktop/text/123 ];then
            echo "找到了123"
            if [ -d /root/Desktop/text ]
            then echo "找到了text"
            else echo "没找到text"
            fi
        else echo "没找到123文件夹"
        fi
    }

    找出出现次数最多{
        awk '{print $1}' file|sort |uniq -c|sort -k1r
    }

    判断脚本参数是否正确{
        ./test.sh  -p 123 -P 3306 -h 127.0.0.1 -u root
        #!/bin/sh
        if [ $# -ne 8 ];then
            echo "USAGE: $0 -u user -p passwd -P port -h host"
            exit 1
        fi

        while getopts :u:p:P:h: name
        do
            case $name in
            u)
                mysql_user=$OPTARG
            ;;
            p)
                mysql_passwd=$OPTARG
            ;;
            P)
                mysql_port=$OPTARG
            ;;
            h)
                mysql_host=$OPTARG
            ;;
            *)
                echo "USAGE: $0 -u user -p passwd -P port -h host"
                exit 1
            ;;
            esac
        done

        if [ -z $mysql_user ] || [ -z $mysql_passwd ] || [ -z $mysql_port ] || [ -z $mysql_host ]
        then
            echo "USAGE: $0 -u user -p passwd -P port -h host"
            exit 1
        fi

        echo $mysql_user $mysql_passwd $mysql_port  $mysql_host
        #结果 root 123 3306 127.0.0.1
    }

    正则匹配邮箱{
        ^[_a-z0-9-]+(\.[_a-z0-9-]+)*@[a-z0-9-]+(\.[a-z0-9-]+)*(\.[a-z]{2,4})$
    }
    打印表格{

        #!/bin/sh
        clear
        awk 'BEGIN{
        print "+--------------------+--------------------+";
        printf "|%-20s|%-20s|\n","Name","Number";
        print "+--------------------+--------------------+";
        }'
        a=`grep "^[A-Z]" a.txt |sort +1 -n |awk '{print $1":"$2}'`
        #cat a.txt |sort +1 -n |while read list
        for list in $a
        do
            name=`echo $list |awk -F: '{print $1}'`
            number=`echo $list |awk -F: '{print $2}'`
            awk 'BEGIN{printf "|%-20s|%-20s|\n","'"$name"'","'"$number"'";
            print "+--------------------+--------------------+";
            }'
        done
        awk 'BEGIN{
        print "              *** The End ***              "
        print "                                           "
        }'

    }
    判断日期是否合法{

        #!/bin/sh
        while read a
        do
          if echo $a | grep -q "-" && date -d $a +%Y%m%d > /dev/null 2>&1
          then
            if echo $a | grep -e '^[0-9]\{4\}-[01][0-9]-[0-3][0-9]$'
            then
                break
            else
                echo "您输入的日期不合法，请从新输入!"
            fi
          else
            echo "您输入的日期不合法，请从新输入!"
          fi
        done
        echo "日期为$a"

    }
    打印日期段所有日期{

        #!/bin/bash
        qsrq=20010101
        jsrq=20010227
        n=0
        >tmp
        while :;do
        current=$(date +%Y%m%d -d"$n day $qsrq")
        if [[ $current == $jsrq ]];then
            echo $current >>tmp;break
        else
            echo $current >>tmp
            ((n++))
        fi
        done
        rq=`awk 'NR==1{print}' tmp`

    }

    打印提示{

        cat <<EOF
        #内容
EOF

        }

    登陆远程执行命令{

        # 特殊符号需要 \ 转义
        ssh root@ip << EOF
        #执行命令
EOF

        }

    数学计算的小算法{

        #!/bin/sh
        A=1
        B=1
        while [ $A -le 10 ]
        do
            SUM=`expr $A \* $B`
            echo "$SUM"
            if [ $A = 10 ]
            then
                B=`expr $B + 1`
                A=1
            fi
            A=`expr $A + 1`
        done

    }

    多行合并{

        sed '{N;s/\n//}' file                   # 将两行合并一行(去掉换行符)
        awk '{printf(NR%2!=0)?$0" ":$0" \n"}'   # 将两行合并一行
        awk '{printf"%s ",$0}'                  # 将所有行合并
        awk '{if (NR%4==0){print $0} else {printf"%s ",$0}}' file    # 将4行合并为一行(可扩展)

    }

    横竖转换{

        cat a.txt | xargs           # 列转行
        cat a.txt | xargs -n1       # 行转列

    }

    竖行转横行{

        cat file|tr '\n' ' '
        echo $(cat file)

        #!/bin/sh
        for i in `cat file`
        do
              a=${a}" "${i}
        done
        echo $a

    }
    取用户的根目录{

        #! /bin/bash
        while read name pass uid gid gecos home shell
        do
            echo $home
        done < /etc/passwd
    }

    远程打包{
        ssh -n $ip 'find '$path' /data /opt -type f  -name "*.sh" -or -name "*.py" -or -name "*.pl" |xargs tar zcvpf /tmp/data_backup.tar.gz'
    }

    把汉字转成encode格式{
        echo 论坛 | tr -d "\n" | xxd -i | sed -e "s/ 0x/%/g" | tr -d " ,\n"
        %c2%db%cc%b3
        echo 论坛 | tr -d "\n" | xxd -i | sed -e "s/ 0x/%/g" | tr -d " ,\n" | tr "[a-f]" "[A-F]"  # 大写的
        %C2%DB%CC%B3
    }

    把目录带有大写字母的文件名改为全部小写{

        #!/bin/bash
        for f in *;do
            mv $f `echo $f |tr "[A-Z]" "[a-z]"`
        done

    }

    查找连续多行，在不连续的行前插入{

        #/bin/bash
        lastrow=null
        i=0
        cat incl|while read line
        do
        i=`expr $i + 1`
        if echo "$lastrow" | grep "#include <[A-Z].h>"
        then
            if echo "$line" | grep -v  "#include <[A-Z].h>"
            then
                sed -i ''$i'i\\/\/All header files are include' incl
                i=`expr $i + 1`
            fi
        fi
        lastrow="$line"
        done

    }

    查询数据库其它引擎{
    
        #/bin/bash
        path1=/data/mysql/data/
        dbpasswd=db123
        #MyISAM或InnoDB
        engine=InnoDB

        if [ -d $path1 ];then

        dir=`ls -p $path1 |awk '/\/$/'|awk -F'/' '{print $1}'`
            for db in $dir
            do
            number=`mysql -uroot -p$dbpasswd -A -S "$path1"mysql.sock -e "use ${db};show table status;" |grep -c $engine`
                if [ $number -ne 0 ];then
                echo "${db}"
                fi
            done
        fi

    }

    批量修改数据库引擎{

        #/bin/bash
        for db in test test1 test3
        do
            tables=`mysql -uroot -pdb123 -A -S /data/mysql/data/mysql.sock -e "use $db;show tables;" |awk 'NR != 1{print}'`

            for table in $tables
            do
                mysql -uroot -pdb123 -A -S /data/mysql/data/mysql.sock -e "use $db;alter table $table engine=MyISAM;"
            done
        done

    }

    将shell取到的数据插入mysql数据库{

        mysql -u$username -p$passwd -h$dbhost -P$dbport -A -e "
        use $dbname;
        insert into data values ('','$ip','$date','$time','$data')
        "

    }

    两日期间隔天数{

        D1=`date -d '20070409' +"%s"`
        D2=`date -d '20070304 ' +"%s"`
        D3=$(($D1 - $D2))
        echo $(($D3/60/60/24))

    }

    while执行ssh只循环一次{

        cat -    # 让cat读连接文件stdin的信息
        seq 10 | while read line; do ssh localhost "cat -"; done        # 显示的9次是被ssh吃掉的
        seq 10 | while read line; do ssh -n localhost "cat -"; done     # ssh加上-n参数可避免只循环一次

    }

    ssh批量执行命令{

        #版本1
        #!/bin/bash
        while read line
        do
        Ip=`echo $line|awk '{print $1}'`
        Passwd=`echo $line|awk '{print $2}'`
        ssh -n localhost "cat -"
        sshpass -p "$Passwd" ssh -n -t -o StrictHostKeyChecking=no root@$Ip "id"
        done<iplist.txt

        #版本2
        #!/bin/bash
        Iplist=`awk '{print $1}' iplist.txt`
        for Ip in $Iplist
        do
        Passwd=`awk '/'$Ip'/{print $2}' iplist.txt`
        sshpass -p "$Passwd" ssh -n -t -o StrictHostKeyChecking=no root@$Ip "id"
        done

    }

    在同一位置打印字符{

        #!/bin/bash
        echo -ne "\t"
        for i in `seq -w 100 -1 1`
        do
            echo -ne "$i\b\b\b";      # 关键\b退格
            sleep 1;
        done

    }

    多进程后台并发简易控制{
        #!/bin/bash
        test () {
            echo $a
            sleep 5
        }
        for a in $(seq 1 30)
        do
            test &
            echo $!
            ((num++))
            if [ $num -eq 6 ];then
            echo "wait..."
            wait
            num=0
            fi
        done
        wait
    }
    
    job_num=10
    function do_work()
    {
      echo "Do work.."
    }
    for ((i=0; i < job_num ;i++)); do
      echo "Fork job $i"
      (do_work) &
    done
    
    wait   # wait for all job done
    echo "All job have been done!"
    
注意最后的wait命令，作用是等待所有子进程结束。
exec 3>&-  # 关闭文件描述
exec 4<&-  # 关闭文件描述
exec 4<>$tmpfile  # 创建文件标示4，以读写方式操作管道$tmpfile
    shell并发{

        #!/bin/bash
        tmpfile=$$.fifo   # 创建管道名称
        mkfifo $tmpfile   # 创建管道
        exec 4<>$tmpfile  # 创建文件标示4，以读写方式操作管道$tmpfile
        rm $tmpfile       # 将创建的管道文件清除
        thred=4           # 指定并发个数
        seq=(1 2 3 4 5 6 7 8 9 21 22 23 24 25 31 32 33 34 35) # 创建任务列表

        # 为并发线程创建相应个数的占位
        {
        for (( i = 1;i<=${thred};i++ ))
        do
            echo;  # 因为read命令一次读取一行，一个echo默认输出一个换行符，所以为每个线程输出一个占位换行
        done
        } >&4      # 将占位信息写入管道

        for id in ${seq}  # 从任务列表 seq 中按次序获取每一个任务
        do
          read  # 读取一行，即fd4中的一个占位符
          (./ur_command ${id};echo >&4 ) &   # 在后台执行任务ur_command 并将任务 ${id} 赋给当前任务；任务执行完后在fd4种写入一个占位符
        done <&4    # 指定fd4为整个for的标准输入
        wait        # 等待所有在此shell脚本中启动的后台任务完成
        exec 4>&-   # 关闭管道

        #!/bin/bash

        FifoFile="$$.fifo"
        mkfifo $FifoFile
        exec 6<>$FifoFile
        rm $FifoFile
        for ((i=0;i<=20;i++));do echo;done >&6

        for u in `seq 1 $1`
        do
            read -u6
            {
                curl -s http://ch.com >>/dev/null
                [ $? -eq 0 ] && echo "${u} 次成功" || echo "${u} 次失败"
                echo >&6
            } &
        done
        wait
        exec 6>&-

    }

    shell并发函数{

        function ConCurrentCmd()
        {
            #进程数
            Thread=30

            #列表文件
            CurFileName=iplist.txt

            #定义fifo文件
            FifoFile="$$.fifo"

            #新建一个fifo类型的文件
            mkfifo $FifoFile

            #将fd6与此fifo类型文件以读写的方式连接起来
            exec 6<>$FifoFile
            rm $FifoFile

            #事实上就是在文件描述符6中放置了$Thread个回车符
            for ((i=0;i<=$Thread;i++));do echo;done >&6

            #此后标准输入将来自fd5
            exec 5<$CurFileName

            #开始循环读取文件列表中的行
            Count=0
            while read -u5 line
            do
                read -u6
                let Count+=1
                # 此处定义一个子进程放到后台执行
                # 一个read -u6命令执行一次,就从fd6中减去一个回车符，然后向下执行
                # fd6中没有回车符的时候,就停在这了,从而实现了进程数量控制
                {
                    echo $Count

                    #这段代码框就是执行具体的操作了
                    function

                    echo >&6
                    #当进程结束以后,再向fd6中追加一个回车符,即补上了read -u6减去的那个
                } &
            done

            #等待所有后台子进程结束
            wait

            #关闭fd6
            exec 6>&-

            #关闭fd5
            exec 5>&-
        }

        并发例子{

            #!/bin/bash

            FifoFile="$$.fifo"
            mkfifo $FifoFile
            exec 6<>$FifoFile
            rm $FifoFile
            for ((i=0;i<=20;i++));do echo;done >&6

            for u in `seq 1 $1`
            do
                read -u6
                {
                    curl -s http://m.chinanews.com/?tt_from=shownews >>/dev/null
                    [ $? -eq 0 ] && echo "${u} 次成功" || echo "${u} 次失败"
                    echo >&6
                } &
            done
            wait
            exec 6>&-

        }
    }

    函数{

        ip(){
            echo "a 1"|awk '$1=="'"$1"'"{print $2}'
        }
        web=a
        ip $web

    }

    检测软件包是否存在{

        rpm -q dialog >/dev/null
        if [ "$?" -ge 1 ];then
            echo "install dialog,Please wait..."
            yum -y install dialog
            rpm -q dialog >/dev/null
            [ $? -ge 1 ] && echo "dialog installation failure,exit" && exit
            echo "dialog done"
            read
        fi

    }

    游戏维护菜单-修改配置文件{

        #!/bin/bash

        conf=serverlist.xml
        AreaList=`awk -F '"' '/<s/{print $2}' $conf`

        select area in $AreaList 全部 退出
        do
            echo ""
            echo $area
            case $area in
            退出)
                exit
            ;;
            *)
                select operate in "修改版本号" "添加维护中" "删除维护中" "返回菜单"
                do
                    echo ""
                    echo $operate
                    case $operate in
                    修改版本号)
                        echo 请输入版本号
                        while read version
                        do
                            if echo $version | grep -w 10[12][0-9][0-9][0-9][0-9][0-9][0-9]
                            then
                                break
                            fi
                            echo 请从新输入正确的版本号
                        done
                        case $area in
                        全部)
                            case $version in
                            101*)
                                echo "请确认操作对 $area 体验区 $operate"
                                read
                                sed -i 's/101[0-9][0-9][0-9][0-9][0-9][0-9]/'$version'/' $conf
                            ;;
                            102*)
                                echo "请确认操作对 $area 正式区 $operate"
                                read
                                sed -i 's/102[0-9][0-9][0-9][0-9][0-9][0-9]/'$version'/' $conf
                            ;;
                            esac
                        ;;
                        *)
                            type=`awk -F '"' '/'$area'/{print $14}' $conf |cut -c1-3`
                            readtype=`echo $version |cut -c1-3`
                            if [ $type != $readtype ]
                            then
                                echo "版本号不对应，请从新操作"
                                continue
                            fi

                            echo "请确认操作对 $area 区 $operate"
                            read

                            awk -F '"' '/'$area'/{print $12}' $conf |xargs -i sed -i '/'{}'/s/10[12][0-9][0-9][0-9][0-9][0-9][0-9]/'$version'/' $conf
                        ;;
                        esac
                    ;;
                    添加维护中)
                        case $area in
                        全部)
                            echo "请确认操作对 $area 区 $operate"
                            read
                            awk -F '"' '/<s/{print $2}' $conf |xargs -i sed -i 's/'{}'/&维护中/' $conf
                        ;;
                        *)
                            echo "请确认操作对 $area 区 $operate"
                            read
                            sed -i 's/'$area'/&维护中/' $conf
                        ;;
                        esac
                    ;;
                    删除维护中)
                        case $area in
                        全部)
                            echo "请确认操作对 $area 区 $operate"
                            read
                            sed -i 's/维护中//' $conf
                        ;;
                        *)
                            echo "请确认操作对 $area 区 $operate"
                            read
                            sed -i '/'$area'/s/维护中//' $conf
                        ;;
                        esac
                    ;;
                    返回菜单)
                        break
                    ;;
                    esac
                done
            ;;
            esac
            echo "回车重新选择区"
        done

    }

    keepalive剔除后端服务{

        #!/bin/bash
        #行数请自定义,默认8行
        if [ X$2 == X ];then
            echo "error: IP null"
            read
            exit
        fi
        case $1 in
        del)
            sed -i '/real_server.*'$2'.*8888/,+8 s/^/#/' /etc/keepalived/keepalived.conf
            /etc/init.d/keepalived reload
        ;;
        add)
            sed -i '/real_server.*'$2'.*8888/,+8 s/^#//' /etc/keepalived/keepalived.conf
            /etc/init.d/keepalived reload
        ;;
        *)
            echo "Parameter error"
        ;;
        esac

    }

    申诉中国反垃圾邮件联盟黑名单{

        #!/bin/bash

        IpList=`awk '$1!~"^#"&&$1!=""{print $1}' host.list`

        QueryAdd='http://www.anti-spam.org.cn/Rbl/Query/Result'
        ComplaintAdd='http://www.anti-spam.org.cn/Rbl/Getout/Submit'

        CONTENT='我们是一家正规的XXX。xxxxxxx。恳请将我们的发送服务器IP移出黑名单。谢谢!
        处理措施：
        1.XXXX。
        2.XXXX。'
        CORP='abc.com'
        WWW='www.abc.cm'
        NAME='def'
        MAIL='def@163.com.cn'
        TEL='010-50000000'
        LEVEL='0'

        for Ip in $IpList
        do
            Status=`curl -d "IP=$Ip" $QueryAdd |grep 'Getout/ShowForm?IP=' |grep -wc '申诉脱离'`
            if [ $Status -ge 1 ];then
                IpStatus="黑名单中"
                results=`curl -d "IP=${Ip}&CONTENT=${CONTENT}&CORP=${CORP}&WWW=${WWW}&NAME=${NAME}&MAIL=${MAIL}&TEL=${TEL}&LEVEL=${LEVEL}" $ComplaintAdd |grep -E '您的黑名单脱离申请已提交|该IP的脱离申请已被他人提交|申请由于近期内有被拒绝的记录'`
                echo $results
                if echo $results | grep '您的黑名单脱离申请已提交'  > /dev/null 2>&1
                then
                    complaint='申诉成功'
                elif echo $results | grep '该IP的脱离申请已被他人提交'  > /dev/null 2>&1
                then
                    complaint='申诉重复'
                elif echo $results | grep '申请由于近期内有被拒绝的记录'  > /dev/null 2>&1
                then
                    complaint='申诉拒绝'
                else
                    complaint='异常'
                fi
            else
                IpStatus='正常'
                complaint='无需申诉'
            fi
            echo "$Ip    $IpStatus    $complaint" >> $(date +%Y%m%d_%H%M%S).log
        done

}

    Web Server in Awk{

        #gawk -f file
        BEGIN {
          x        = 1                         # script exits if x < 1
          port     = 8080                      # port number
          host     = "/inet/tcp/" port "/0/0"  # host string
          url      = "http://localhost:" port  # server url
          status   = 200                       # 200 == OK
          reason   = "OK"                      # server response
          RS = ORS = "\r\n"                    # header line terminators
          doc      = Setup()                   # html document
          len      = length(doc) + length(ORS) # length of document
          while (x) {
             if ($1 == "GET") RunApp(substr($2, 2))
             if (! x) break
             print "HTTP/1.0", status, reason |& host
             print "Connection: Close"        |& host
             print "Pragma: no-cache"         |& host
             print "Content-length:", len     |& host
             print ORS doc                    |& host
             close(host)     # close client connection
             host |& getline # wait for new client request
          }
          # server terminated...
          doc = Bye()
          len = length(doc) + length(ORS)
          print "HTTP/1.0", status, reason |& host
          print "Connection: Close"        |& host
          print "Pragma: no-cache"         |& host
          print "Content-length:", len     |& host
          print ORS doc                    |& host
          close(host)
        }

        function Setup() {
          tmp = "<html>\
          <head><title>Simple gawk server</title></head>\
          <body>\
          <p><a href=" url "/xterm>xterm</a>\
          <p><a href=" url "/xcalc>xcalc</a>\
          <p><a href=" url "/xload>xload</a>\
          <p><a href=" url "/exit>terminate script</a>\
          </body>\
          </html>"
          return tmp
        }

        function Bye() {
          tmp = "<html>\
          <head><title>Simple gawk server</title></head>\
          <body><p>Script Terminated...</body>\
          </html>"
          return tmp
        }

        function RunApp(app) {
          if (app == "xterm")  {system("xterm&"); return}
          if (app == "xcalc" ) {system("xcalc&"); return}
          if (app == "xload" ) {system("xload&"); return}
          if (app == "exit")   {x = 0}
        }

    }

}

megacli(){
显示Rebuid进度
/opt/MegaRAID/MegaCli/MegaCli64 -PDRbld -ShowProg -physdrv[20:2] -aALL
查看ES
/opt/MegaRAID/MegaCli/MegaCli64 -PDList -aAll -NoLog | grep -Ei "(enclosure|slot)"
查看所有硬盘的状态
/opt/MegaRAID/MegaCli/MegaCli64 -LDInfo -LALL -aAll
/opt/MegaRAID/MegaCli/MegaCli64 -PDList -aAll -NoLog
如果RAID卡被设置成了writethrough。这个是完全不利用卡上内存的一种做法，操作系统需要确认磁盘全部写入后再返回，io latency很大，而且性能差。

可以强制让他一定使用writeback模式，命令：

/opt/MegaCli64 -LDSetProp -ForcedWB -Immediate -Lall -aAll
RAID卡上电池没电，单个盘损坏，都会造成RAID策略的变化，所以需要及时检测。

查看所有Virtual Disk的状态

/opt/MegaRAID/MegaCli/MegaCli64 -LdPdInfo -aAll -NoLog
RAID Level对应关系：

RAID Level : Primary-1, Secondary-0, RAID Level Qualifier-0 RAID 1
RAID Level : Primary-0, Secondary-0, RAID Level Qualifier-0 RAID 0
RAID Level : Primary-5, Secondary-0, RAID Level Qualifier-3 RAID 5
RAID Level : Primary-1, Secondary-3, RAID Level Qualifier-0 RAID 10
在线做Raid

/opt/MegaRAID/MegaCli/MegaCli64 -CfgLdAdd -r0[0:11] WB NORA Direct CachedBadBBU -strpsz64 -a0 -NoLog
/opt/MegaRAID/MegaCli/MegaCli64 -CfgLdAdd -r5 [12:2,12:3,12:4,12:5,12:6,12:7] WB Direct -a0
点亮指定硬盘(定位)

/opt/MegaRAID/MegaCli/MegaCli64 -PdLocate -start -physdrv[252:2] -a0
清除Foreign状态
1
/opt/MegaRAID/MegaCli/MegaCli64 -CfgForeign -Clear -a0
查看RAID阵列中掉线的盘

/opt/MegaRAID/MegaCli/MegaCli64 -pdgetmissing -a0
替换坏掉的模块

/opt/MegaRAID/MegaCli/MegaCli64 -pdreplacemissing -physdrv[12:10] -Array5 -row0 -a0
手动开启rebuid

/opt/MegaRAID/MegaCli/MegaCli64 -pdrbld -start -physdrv[12:10] -a0
查看Megacli的log

/opt/MegaRAID/MegaCli/MegaCli64 -FwTermLog dsply -a0 > adp2.log
设置HotSpare

/opt/MegaRAID/MegaCli/MegaCli64 -pdhsp -set [-Dedicated [-Array2]] [-EnclAffinity] [-nonRevertible] -PhysDrv[4:11] -a0
/opt/MegaRAID/MegaCli/MegaCli64 -pdhsp -set [-EnclAffinity] [-nonRevertible] -PhysDrv[32：1}] -a0
关闭Rebuild

/opt/MegaRAID/MegaCli/MegaCli64 -AdpAutoRbld -Dsbl -a0
设置rebuild的速率

/opt/MegaRAID/MegaCli/MegaCli64 -AdpSetProp RebuildRate -30 -a0

MegaCli常用参数组合介绍：
MegaCli -cfgdsply -aALL | grep "Error"                  【正常都是0】
MegaCli -LDGetProp -Cache -LALL -a0                 【写策略】
MegaCli -cfgdsply -aALL   | grep "Memory"          【内存大小】

MegaCli -LDInfo -Lall -aALL                         【查RAID级别】
MegaCli -AdpAllInfo -aALL                           【查RAID卡信息】
MegaCli -PDList -aALL                                     【查看硬盘信息】
MegaCli -AdpBbuCmd -aAll                           【查看电池信息】
MegaCli -FwTermLog -Dsply -aALL           【查看RAID卡日志】

MegaCli -adpCount                                    【显示适配器个数】
MegaCli -AdpGetTime -aALL               【显示适配器时间】
MegaCli -AdpAllInfo -aAll                     【显示所有适配器信息】
MegaCli -LDInfo -LALL -aAll                【显示所有逻辑磁盘组信息】
MegaCli -PDList -aAll                               【显示所有的物理信息】

MegaCli -AdpBbuCmd -GetBbuStatus -aALL |grep "Charger Status" 【查看充电状态】

MegaCli -AdpBbuCmd -GetBbuStatus -aALL                      【显示BBU状态信息】
MegaCli -AdpBbuCmd -GetBbuCapacityInfo -aALL        【显示BBU容量信息】
MegaCli -AdpBbuCmd -GetBbuDesignInfo -aALL            【显示BBU设计参数】
MegaCli -AdpBbuCmd -GetBbuProperties -aALL             【显示当前BBU属性】
MegaCli -cfgdsply -aALL
}

MAC(随机生成MAC地址的N种方法){
# openssl
openssl rand -hex 6 | sed 's/(..)/1:/g; s/.$//'
a0:77:d4:ef:08:7d
openssl rand 6 | xxd -p | sed 's/(..)/1:/g; s/:$//'
3b:7f:95:c8:39:6d

# od
od -An -N10 -x  /dev/random  | md5sum | sed -r 's/^(.{10}).*$/1/; s/([0-9a-f]{2})/1:/g; s/:$//;'
b0:85:1a:41:b1
od /dev/urandom -w6 -tx1 -An|sed -e 's/ //' -e 's/ /:/g'|head -n 1
d8:d3:67:20:c5:f2

# for循环生成
for i in {1..6}; do printf "%0.2X:" $[ $RANDOM % 0x100 ]; done | sed 's/:$/n/'
8E:9E:FB:AE:FF:D2
h=0123456789ABCDEF;for c in {1..12};do echo -n ${h:$(($RANDOM%16)):1};if [[ $((c%2)) = 0 && $c != 12 ]];then echo -n :;fi;done;echo
19:7F:A9:41:E2:20


二、perl生成法
perl -e 'printf("%.2x:",rand(255))for(1..5);printf("%.2x\n",rand(255))'
    f8:42:c1:d4:a8:28
perl -e 'print join(":", map { sprintf "%0.2X",rand(256) }(1..6))."\n"'
    A7:02:BD:BC:59:E2
    
四、python生成法
python -c "from itertools import imap; from random import randint; print ':'.join(['%02x'%x for x in imap(lambda x:randint(0,255), range(6))])"
    52:75:80:68:3a:cc
    
#!/usr/bin/python
# macgen.py script to generate a MAC address for Red Hat Virtualization guests
#
import random
#
def randomMAC():
	mac = [ 0x00, 0x16, 0x3e,
		random.randint(0x00, 0x7f),
		random.randint(0x00, 0xff),
		random.randint(0x00, 0xff) ]
	return ':'.join(map(lambda x: "%02x" % x, mac))
#
print randomMAC()
    
}

animation(定点输出){
1. 回车符(\r)是把光标返回到行首，而换行符(\n)才是把光标移到下一行。
   尽管在 Linux 中，是采用换行符作为新行的标识，但终端模拟器中还是会响应回车符。
   
在脚本中做一些很有意思的动画。
#!/bin/bash
 
spin=('\' '|' '/' '-')
cnt=0
while(true)
do
    echo -n "handling $((cnt++)), please wait... ${spin[$((cnt % 4))]}"
    echo -n -e \\r
    sleep 0.2
done
   
2. 光标移动(CSI码)
    单纯在同一行做文章，可能还无法满足一些动画。这时候，可以采用 CSI 码来手动移动光标。
CSI(private mode character) 是用来格式化终端的输出。其序列定义为 [ESC][ + N1; N2; ... S，
而 ESC 可以用 \e，\033 和 \x1B 来表示。这里我们简单的控制一下输出：
echo -en '\e[2J\e[7;40f this is a test\e[6;38f this is another teset\n\n'

    这条命令首先用 \e[2J 来清屏，\e[7;40f 把光标移到到 7,40，输出内容，然后 \e[6;38f 把光标
移动到 6,38，再输出内容。具体的 CSI 码可以在 wiki 找到，发挥你的想象力吧。
    Linux 下有一个 tput 命令，可以设置终端的属性，若不想用 CSI 码，可以用 tput 代替，具体可以查看 
tput 联机文档。

3. 色彩化输出
    现在输出位置可以自由控制了，那就只剩下颜色了。终端中的颜色也是通过 SGR(select graphic rendition) 
码来控制。SGR 是 CSI 的一个子集，其格式为 CSI + N + m。其中 N 就是指定颜色的。可以利用 SGR 码来设定字体、
加粗、下划线、背景色和前景色。具体效果可以在 flogisoft 查看，做的很全。这里只举一些基本的例子。

echo -e 'this is a \e[1mtest'
echo -e 'this is a \e[1;31mtest'
echo -e 'this is a \e[1;4;31mtest'

4. 
#!/bin/bash
 
while true
do
    for i in {20..1}
    do
        echo -en "\e[38;5;$((RANDOM % 256))m"
        # expand twice
        eval printf \' %.0s\' {1..$((41 - i))}
        eval printf \''#%.0s'\' {1..$((2*i -1))}
        echo -e "\e[0m"
    done
 
    echo -en "\e[20F"
    sleep 0.2
done
}

log(){
比如，如果只是为了抓取串口的输出，可以直接用minicom -C指定记录日志的文件名。
1. [minicom]
sudo apt-get install minicom
minicom -D /dev/ttyUSB0 -C /tmp/minicom.cap
又比如，用screen -L可以记录之后的所有操作以及输出日志，直到主动键入exit退出。日志文件保存在：screenlog.0中。

2. [screen]
sudo apt-get install screen
screen -L
cat /proc/version
exit
ls screenlog.0
但是上面适合人机交互的场景，如果想自动执行一些命令并记录这些命令的输出甚至想确认这些命令是否执行成功，则可以用script。

3. [script]
script -e -c "make CROSS_COMPILE=arm-none-linux-gnueabi- -j8" -a compile.log
其中，-a指定日志文件，如果不指定，默认为typescript；-c指定要执行的命令；-e记录所执行命令的退出状态。
}

locale(){
sudo vim /etc/locale.conf

使用"localectl list-locales"查看可用的 LANG 值

[huzhifeng@CentOS72 ~]$ localectl list-locales | grep en_US
en_US
en_US.iso88591
en_US.iso885915
en_US.utf8
[huzhifeng@CentOS72 ~]$ localectl list-locales | grep zh_CN
zh_CN
zh_CN.gb18030
zh_CN.gb2312
zh_CN.gbk
zh_CN.utf8
[huzhifeng@CentOS72 ~]$

修改为英文

[huzhifeng@CentOS72 ~]$ localectl set-locale LANG=en_US.UTF-8
[huzhifeng@CentOS72 ~]$ cat /etc/locale.conf
LANG=en_US.UTF-8

修改为中文

[huzhifeng@CentOS72 ~]$ localectl set-locale LANG=zh_CN.UTF-8
[huzhifeng@CentOS72 ~]$ cat /etc/locale.conf
LANG=zh_CN.UTF-8

以上修改都需要重启系统才能生效
}
byzanz(){
sudo apt-get install byzanz

-d, --duration=SECS：录像持续时间，默认是10秒
--delay=SECS：设置几秒种后开始录像，默认是1秒
-l, --loop：设置录像循环播放
-c, --cursor：记录鼠标指针
-x, --x=PIXEL：录像区域的起始横坐标，默认是0(左上角)
-y, --y=PIXEL：录像区域的起始纵坐标，默认是0(左上角)
-w, --width=PIXEL：录像区域宽度
-h, --height=PIXEL：录像区域高度
--display=DISPLAY：指定显示设备
}

ubuntu_64bit_run_32bit(64bit exec 32bit){
sudo dpkg --add-architecture i386
sudo apt-get update
sudo apt-get install zlib1g:i386 libstdc++6:i386 libc6:i386
# 64位系统运行32位程序: 
sudo apt install libc6:i386 libncurses5:i386 libstdc++6:i386
}

ubuntu(man){

Ubuntu 安装补充man手册
$ sudo apt-get install glibc-doc
$ sudo apt-get install manpages-posix-dev

Ubuntu: 安装扩展man手册
sudo apt-get install libstdc++-4.8-doc
man std::vector

安装caffe的CPU版本
sudo apt-get install libgflags-dev libgoogle-glog-dev liblmdb-dev
cd caffe && make -j4 && make test -j4 && make runtest
cd caffe && make -j4 && make test -j4 && make runtest
}


kvm_web_link(){
https://www.cnblogs.com/halberd-lee/p/13355393.html

}

firewalld_web_link(){
https://www.cnblogs.com/halberd-lee/p/11397242.html
}

crosstool(ubuntu安装和卸载){
ubuntu中可以使用命令行
sudo apt install gcc-arm-Linux-gnueabi
自动安装交叉编译工具，但是往往软件版本太过超前了。因为交叉编译工具的版本不兼容，所以要卸载了安装对应版本的交叉编译工具
只卸载gcc-arm-linux-gnueabi的话使用命令：
sudo apt remove gcc-arm-linux-gnueabi
将其相关文件全部卸载：
sudo apt remove --auto-remove gcc-arm-linux-gnueabi

}
mstsc(远程桌面连接Ubuntu14.04){
sudo apt-get install xrdp
sudo apt-get install vnc4server
sudo apt-get install xubuntu-desktop
echo "xfce4-session" >~/.xsession
sudo service xrdp restart
安装完之后就可以在Window下使用远程桌面进行登录了
}
不定期更新下载地址：
http://pan.baidu.com/s/1sjsFrmX
https://github.com/liquanzhou/ops_doc

For Linux User
    Getting informations: id, groups, users, date, cal, pwd, ps, which, whatis, whoami, ls, cd, w, who, last, ip, free, df, du, file, lscpu, lspci, lsusb, lslogins, lsblk, top, uptime, uname.
    Getting help: help cmd, cmd --help, cmd -h, man, apropos, info.
    Manange files: >file, touch, mkdir, rm, rmdir, mv, cp, , ln, chmod, chown, chgrp, cat, less, more, head, tail, tar, gzip, gunzip, bzip2, bunzip2, zip, unzip, chksum, md5sum.
    Find file or string: locate, find, grep.
    Jobs: C-C, C-D, C-Z, jobs, fg, pushd, popd, dirs, kill, nice, renice, wait, sleep, at, batch, cron, crontab.
    Text manipulate: echo, printf, seq, cat, split, join, col, colmun, pr, lp, lpr, strings, spell, tee, fmt, wc, sort, uniq, cut, paste, cmp, comm, diff, patch, tr, od, iconv, expand, unexpand, sed, awk, vi[m], emacs.
    Connection tools: mail, ssh, telnet, lynx, w3m...
    Download tools: scp, wget, curl, ftp, smbget...
    Packages management: tar, rpm, dpkg, apt-get, yum, pacman...

For Linux Developer
    Build tools: make, cmake, automake, autoconf, libtools...
    Version control: diff, patch, git, cvs
    Writing Code: vim, emacs, indent, clang-format,
    Code Analysis: ctags, cscope, splint, cflow, doxygen, graphviz.
    Compiler and interpreter: gcc, clang, sdcc, perl, python, ruby, php.
    Debug tools: gdb, lldb, valgrind, llvm, strace, lsof, gprof, gperf, pmap, ldd, fuser, stat, strings, xxd, od, hexdump, binutils, ipcs, ipcrm, netstat, ltrace, vmstat, mpstat, iostat, time, mtrace,
    


system(命令分类){
线上查询及帮助命令(2 个)
man help 
文件和目录操作命令(13 个) 
ls tree pwd mkdir rmdir cd touch cp mv rm ln find rename 
查看文件及内容处理命令(22 个) 
cat tac more less head tail cut split paste sort uniq wc iconv dos2unix file diff vimd ff chattr lsattr rev grep egrep 
文件压缩及解压缩命令(4 个) tar unzip gzip zip 
信息显示命令(12 个)
 uname hostname dmesg uptime file stat du df top free date cal 
搜索文件命令(4 个)
 which find whereis locate 
用户管理命令(10 个) 
useradd usermod userdel groupadd passwd chage id su visudo sudo 
基础网络操作命令(10 个) 
telnet ssh scp wget ping route ifconfig ifup ifdown netstat 
深入网络操作命令(6 个)
 lsof route mail mutt nslookup dig 
有关磁盘文件系统的命令(8 个)
mount umount df du fsck dd dumpe2fs dump
关机和查看系统信息的命令(3个)
shutdown halt init 
系统管理相关命令(8个)
uptime top free vmstat mpstat iostat sar chkconfig 
系统安全相关命令(10 个)
 chmod chown chgrp chage passwd su sudo umask chattr lsattr 
查看系统用户登陆信息的命令(7 个)
 whoami who w last lastlog users finger
查看硬件信息相关命令(8 个) 
ifconfig free fdisk ethtool mii-tool dmidecode dmesg lspci 
其它(19 个)
 echo printf rpm yum watch alias unalias date clear history eject time nohup nc xargs exec export unset type 
系统性能监视高级命令(12 个) 
内存:top free vmstat mpstat iostat sar 
CPU:top vmstat mpstat iostat sar
 I/O:vmstat mpstat iostat sar 
进程:ipcs ipcrm lsof strace lstrace 
负载:uptime mount umount df du fsck dd dumpe2fs dump 
关机和查看系统信息的命令(3 个)
 shutdown halt init 
系统管理相关命令(8 个)
 uptime top free vmstat mpstat iostat sar chkconfig 
系统安全相关命令(10 个)
 chmod chown chgrp chage passwd su sudo umask chattr
}}