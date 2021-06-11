
ps 显示进程。
    ps 命令可以确定有哪些进程正在运行和运行的状态、进程是否结束、进程有没有僵死、哪些进程占用了过多的资源等等.
    用法 ps [ -aAdeflcjLPyZ ] [ -o 格式 ] [ -t 项列表 ]
    [ -u 用户列表 ] [ -U 用户列表 ] [ -G 组列表 ]
    [ -p 进程列表 ] [ -g 程序组列表 ] [ -s 标识符列表 ] [ -z 区域列表 ]
    ps 显示自己的进程。
     -e  显示所有进程、环境变量，包括空闲进程。
     -f  显示详情(全格式)。
     -ef 组合-e和-f，所有进程的详情。
     -U  uidlist(用户列表) 具体查看某人的进程。
     -l  长格式
     -w  宽输出
     a   显示终端上的所有进程,包括其他用户地进程
     r   只显示正在运行的进程
     x   显示没有控制终端的进程
     h  不显示标题
     --help 显示帮助信息.
     --version 显示该命令地版本信息.

    列表含义: PID(进程ID)、TTY(终端名称)、TIME(进程执行时间)、COMMAND(该进程的命令行输入)、%CPU(cpu占用率)、%MEM(内存占用空间)

    例如，查看进程:
    ps aux | grep java  # 表示查看所有进程里CMD是java的进程信息; grep 是搜索, aux 显示所有状态
    ps -ef | grep 进程名 | wc -l # 显示共有多个这样的进程,显示一个int数字


查看端口占用
    用启动服务的账号登录，然后运行命令:
        lsof -i:<端口号>

    用别的账号登陆则:
        lsof -i|grep <端口号>
        netstat -apn|grep <端口号>
    如: netstat -apn|grep 8080

    查看全部占用的端口:
    netstat -apn


kill  可以杀死某个正在进行或者已经是dest状态的进程
    用法:  kill ［信号代码］ 进程ID
    如:  kill -9 [进程PID]  #-9表示强迫进程立即停止
    通常用ps 查看进程PID ，用kill命令终止进程

   常用控制进程的方法:
    kill -STOP [pid]   # 发送SIGSTOP (17,19,23)停止一个进程，而并不消灭这个进程。
    kill -CONT [pid]   # 发送SIGCONT (19,18,25)重新开始一个停止的进程。
    kill -KILL [pid]   # 发送SIGKILL (9)强迫进程立即停止，并且不实施清理操作。
    kill -9 -1         # 终止你拥有的全部进程。


killall  通过程序的名字，直接杀死所有进程
    用法: killall 正在运行的程序名 # 该命令可以使用 -9 参数来强制杀死进程
    格式: killall [-egiqvw] [-signal] name ...
    如果命令名包括斜杠 (/), 那么执行该特定文件的进程将被杀掉, 这与进程名无关。
    如果对于所列命令无进程可杀, 那么 killall 会返回非零值. 如果对于每条命令至少杀死了一个进程, killall 返回 0。
    killall 进程决不会杀死自己 (但是可以杀死其它 killall 进程)。

   PTIONS (选项)
    -e  对于很长的名字, 要求准确匹配. 如果一个命令名长于 15 个字符, 则可能不能用整个名字 (溢出了).
        在这种情况下, killall 会杀死所有匹配名字前 15 个字符的所有进程. 有了 -e 选项,这样的记录将忽略.
        如果同时指定了 -v 选项, killall 会针对每个忽略的记录打印一条消息。
    -g  杀死属于该进程组的进程. kill 信号给每个组只发送一次, 即使同一进程组中包含多个进程。
    -i  交互方式，在杀死进程之前征求确认信息。
    -l  列出所有已知的信号名。
    -q  如果没有进程杀死, 不会提出抱怨。
    -v  报告信号是否成功发送。
    -V  显示版本信息。
    -w  等待所有杀的进程死去. killall 会每秒检查一次是否任何被杀的进程仍然存在, 仅当都死光后才返回.
        注意: 如果信号被忽略或没有起作用, 或者进程停留在僵尸状态, killall 可能会永久等待。


signal   - 可用信号列表
ps       - 报告当前进程的快照
pkill    - 通过程序的名字，直接杀死所有进程
           用法: pkill 正在运行的程序名
skill    - 发送一个信号或者报告进程状态
xkill    - 杀死桌面图形界面的程序
           应用情形实例: firefox出现崩溃不能退出时，运行xkill，哪个图形程序崩溃一点就OK了。
           如果您想终止xkill ，就按右键取消；
           调用方法:  xkill

sleep


nohup
    用nohup命令让Linux下程序永远在后台执行
　　用途：不挂断地运行命令。
　　语法：nohup Command [ Arg ... ] [　& ]
　　描述：nohup 命令运行由 Command 参数和任何相关的 Arg 参数指定的命令，忽略所有挂断（SIGHUP）信号。
          在注销后使用 nohup 命令运行后台中的程序。要运行后台中的 nohup 命令，添加 & （ 表示"and"的符号）到命令的尾部。
    如： nohup python ~/projects/ppf/service/run.py &  # 后台执行，且输出到执行程序同目录下的 nohup.out 文件中

    注： 在当shell中提示了nohup成功后还需要按回车键退回到shell输入命令窗口，然后通过在shell中输入exit来退出终端；
         而在nohup执行成功后直接点关闭程序按钮关闭终端，会断掉该命令所对应的session，导致nohup对应的进程被通知需要一起shutdown。
    指定输出文件： nohup command > myout.file 2>&1 &


exit    退出; DOS内部命令 用于退出当前的命令处理器(COMMAND.COM)     恢复前一个命令处理器。



关机命令
    shutdown    安全地将系统关机。
　　 [-t] 在改变到其它runlevel之前，告诉init多久以后关机。指定的范围为 0 - 600 秒。如： shutdown -t 100 将在100秒后关机
　　 [-r] 重启计算器。如： shutdown -r 5  系统将关机，且在5分钟后重启。
　　 [-k] 并不真正关机，只是送警告信号给每位登录者〔login〕。
　　 [-h] 关机后关闭电源〔halt〕。
　　 [-n] 不用init，而是自己来关机。不鼓励使用这个选项，而且该选项所产生的后果往往不总是你所预期得到的。
　　 [-c] cancel current process取消目前正在执行的关机程序。所以这个选项当然没有时间参数，但是可以输入一个用来解释的讯息，而这信息将会送到每位使用者。
　　 [-f] 在重启计算器〔reboot〕时忽略fsck。
　　 [-F] 在重启计算器〔reboot〕时强迫fsck。
　　 [-time] 设定关机〔shutdown〕前的时间。

    halt    最简单的关机命令
　　 其实halt就是调用shutdown -h。halt执行时，杀死应用进程，执行sync系统调用，文件系统写操作完成后就会停止内核。
　　 [-n] 防止sync系统调用，它用在用fsck修补根分区之后，以阻止内核用老版本的超级块〔superblock〕覆盖修补过的超级块。
　　 [-w] 并不是真正的重启或关机，只是写wtmp〔/var/log/wtmp〕纪录。
　　 [-d] 不写wtmp纪录〔已包含在选项[-n]中〕。
　　 [-f] 没有调用shutdown而强制关机或重启。
　　 [-i] 关机〔或重启〕前，关掉所有的网络接口。
　　 [-p] 该选项为缺省选项。就是关机时调用poweroff。

    reboot
     reboot的工作过程差不多跟halt一样，不过它是引发主机重启，而halt是关机。它的参数与halt相差不多。

    init
     init是所有进程的祖先，它的进程号始终为1，所以发送TERM信号给init会终止所有的用户进程、守护进程等。shutdown 就是使用这种机制。
     init定义了8个运行级别(runlevel)，init 0为关机，init 1为重启。关于init可以长篇大论，这里就不再叙述。
     另外还有telinit命令可以改变init的运行级别，比如，telinit -iS可使系统进入单用户模式，并且得不到使用shutdown时的信息和等待时间。

    poweroff    部分泛UNIX/LINUX系统才支持，红旗LINUX亦适用。
     其实是 halt -p 命令。
