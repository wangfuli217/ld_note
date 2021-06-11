
四、退出命令
exit    退出; DOS内部命令 用于退出当前的命令处理器(COMMAND.COM)     恢复前一个命令处理器。
Ctrl+d  跟exit一样效果，表中止本次操作。
logout  当csh时可用来退出，其他shell不可用。

clear   清屏，清除(之前的内容并未删除，只是没看到，拉回上面可以看回)。相当与DOS下的cls
    Ctrl + Shift + G 清屏(屏幕内容完全清除，拉不回的)



八、时间显示
date 显示时间，精确到秒
    用法   date [-u] mmddHHMM[[cc]yy][.SS]
    date [-u] [+format]
    date -a [-]sss[.fff]
cal 显示日历
    cal 9 2008  显示2008年9月的日历；    cal 显示当月的
    用法 cal [ [月] 年 ]



awk 按一定格式输出(pattern scanning and processing language)
    用法 awk [-Fc] [-f 源代码 | 'cmds'] [文件]



yes      - 在被终止前反复打印字符


软件安装
    在ubuntu上的软件安装，有方便的方式,使用 apt
    sudo apt-get install openjdk-6-jdk # 安装 jdk



history 用户用过的命令
        如: history  可以显示用户过去使用的命令

jobs
    用法  jobs [-l ]
fg ％n
bg ％n
stop ％n 挂起(仅csh能用)
Ctrl+C
Ctrl+Z

rlogin



查看系统信息
    uname [选项]...
    输出一组系统信息。如果不跟随选项，则视为只附加-s 选项。

      -a, --all			以如下次序输出所有信息。其中若-p 和 -i 的探测结果不可知则被省略。
                        如: Linux holemar 2.6.38-11-generic #48-Ubuntu SMP Fri Jul 29 19:05:14 UTC 2011 i686 i686 i386 GNU/Linux
      -s, --kernel-name		输出内核名称。如:  Linux
      -n, --nodename		输出网络节点上的主机名。如:  holemar
      -r, --kernel-release		输出内核发行号。如:  2.6.38-11-generic
      -v, --kernel-version		输出内核版本。 如:  #48-Ubuntu SMP Fri Jul 29 19:05:14 UTC 2011
      -m, --machine		输出主机的硬件架构名称。 如:  i686
      -p, --processor		输出处理器类型或"unknown"。 如:  686
      -i, --hardware-platform	输出硬件平台或"unknown"。 如:  i386
      -o, --operating-system	输出操作系统名称。 如:  GNU/Linux
          --help		显示此帮助信息并退出。
          --version		显示版本信息并退出。



如果执行一个 sh 文件
    方法一(在ubuntu下的):
        cd sh文件的目录
        ./名称.sh   # 执行此文件
    方法二:
        sh 目录/名称.sh


10 个最酷的 Linux 单行命令
    1. sudo !!
       以 root 帐户执行上一条命令。

    2. python -m SimpleHTTPServer
       利用 Python 搭建一个简单的 Web 服务器，可通过 http://$HOSTNAME:8000 访问。

    3. :w !sudo tee %
       在 Vim 中无需权限保存编辑的文件。

    4. cd -
       更改到上一次访问的目录。

    5. ^foo^bar
       将上一条命令中的 foo 替换为 bar，并执行。

    6. cp filename{,.bak}
       快速备份或复制文件。

    7. mtr google.com
       traceroute + ping。

    8. !whatever:p
       搜索命令历史，但不执行。

    9. $ssh-copy-id user@host
       将 ssh keys 复制到 user@host 以启用无密码 SSH 登录。

    10. ffmpeg -f x11grab -s wxga -r 25 -i :0.0 -sameq /tmp/out.mpg
        把 Linux 桌面录制为视频。


