tty(终端设备的统称){
tty一词源于Teletypes，或者teletypewriters，原来指的是电传打字机，是通过串行线用打印机键盘通过阅读和发送信息的东西，后来这东西被键盘与显示器取代，所以现在叫终端比较合适。
终端是一种字符型设备，它有多种类型，通常使用tty来简称各种类型的终端设备。

pty（伪终端，虚拟终端):但是如果我们远程telnet到主机或使用xterm时不也需要一个终端交互么？是的，这就是虚拟终端pty(pseudo-tty)
pts/ptmx(pts/ptmx结合使用，进而实现pty):
pts(pseudo-terminal slave)是pty的实现方法，与ptmx(pseudo-terminal master)配合使用实现pty。
}
在Linux系统的设备特殊文件目录/dev/下，终端特殊设备文件一般有以下几种：

ttySn(串行端口终端/dev/ttySn){   嵌入式串口设备
串行端口终端(Serial Port Terminal)是使用计算机串行端口连接的终端设备。计算机把每个串行端口都看作是一个字符设备。
有段时间这些串行端口设备通常被称为终端设备，因为那时它的最大用途就是用来连接终端。这些串行端口所对应的设备名称是
/dev/tts/0(或/dev/ttyS0), /dev/tts/1(或/dev/ttyS1)等，设备号分别是(4,0), (4,1)等，分别对应于DOS系统下的COM1、
COM2等。若要向一个端口发送数据，可以在命令行上把标准输出重定向到这些特殊文件名上即可。例如，在命令行提示符下键入
echo test > /dev/ttyS1会把单词"test"发送到连接在ttyS1(COM2)端口的设备上。

}
pty(伪终端/dev/pty/){  待取证
伪终端(Pseudo Terminal)是成对的逻辑终端设备(即master和slave设备, 对master的操作会反映到slave上)

例如/dev/ptyp3和/dev/ttyp3(或者在设备文件系统中分别是/dev/pty/m3和/dev/pty/s3)。它们与实际物理设备并不直接相关。

如果一个程序把ptyp3(master设备)看作是一个串行端口设备，则它对该端口的读/写操作会反映在该逻辑终端设备对应的另一个ttyp3(slave设备)上面。
而ttyp3则是另一个程序用于读写操作的逻辑设备。telnet主机A就是通过"伪终端"与主机A的登录程序进行通信。
}

tty(控制终端 /dev/tty){   -sh  10 -> /dev/tty 当前的终端中
如果当前进程有控制终端(Controlling Terminal)的话，那么/dev/tty就是当前进程的控制终端的设备特殊文件。
可以使用命令"ps -ax"来查看进程与哪个控制终端相连。对于登录的shell，/dev/tty就是你使用的终端，设备号是(5,0)。
使用命令"tty"可以查看它具体对应哪个实际终端设备。/dev/tty有些类似于到实际所使用终端设备的一个联接。

Q:/dev/tty是什么？
A：tty设备包括虚拟控制台，串口以及伪终端设备。
/dev/tty代表当前tty设备，在当前的终端中输入 echo "hello" > /dev/tty ，都会直接显示在当前的终端中。

/dev/console根据不同系统的设定可以链接到/dev/tty0或者其他tty*上
}
console(控制台终端/dev/ttyn, /dev/console){  Alt+[F1—F6]
在Linux 系统中，计算机显示器通常被称为控制台终端(Console)。它仿真了类型为Linux的一种终端(TERM=Linux)，并且有一些设备特殊文件与之相关联：tty0、tty1、tty2
等。当你在控制台上登录时，使用的是tty1。使用Alt+[F1—F6]组合键时，我们就可以切换到tty2、tty3等上面去。tty1–tty6等称为虚拟终端，而tty0则是当前所使用虚拟终端的一个别名，系统所产生的信息会发送到该终端上（这时也叫控制台终端）。

因此不管当前正在使用哪个虚拟终端，系统信息都会发送到控制台终端上。/dev/console即控制台，是与操作系统交互的设备，系统将一些信息直接输出到控制台上。目前只有在单用户模式下，才允许用户登录控制台。

Q：/dev/console 是什么?
A：/dev/console即控制台，是与操作系统交互的设备，系统将一些信息直接输出到控制台上。目前只有在单用户模式下，才允许用户登录控制台。
}
n(虚拟终端/dev/pts/n){    虚拟终端；telnet；ssh
在Xwindows模式下的伪终端.如我在Kubuntu下用konsole，就是用的虚拟终端，用tty命令可看到/dev/pts/1。
}
telnet(){
HOST [PORT]
}
telnetd(busybox){  select
-l LOGIN      # 指定login进程名称     /bin/login
-f issue_file # 指定issue_inet文件名  /etc/issue.net
-K            # 
-p PORT       # 监听端口           -- inetd子服务时不用
-b ADDR       # 绑定IP             -- inetd子服务时不用
-F            # 前台运行           -- inetd子服务时不用
-i            # 最为inetd的子服务
-----------------------------------------/proc/pid/fd
3 -> socket:[346]     # 监听端口
4 -> socket:[957545]  # 与telnet客户端连接端口
5 -> /dev/ptmx        # 伪终端设备master
6 -> socket:[957561]  # 与telnet客户端连接端口
7 -> /dev/ptmx        # 伪终端设备master
----------------------------------------- buffer
+-------+     wridx1++     +------+     rdidx1++     +----------+
|       | <--------------  | buf1 | <--------------  |          |
|       |     size1--      +------+     size1++      |          |
|  pty  |                                            |  socket  |
|       |     rdidx2++     +------+     wridx2++     |          |
|       |  --------------> | buf2 |  --------------> |          |
+-------+     size2++      +------+     size2--      +----------+
size1: "how many bytes are buffered for pty between rdidx1 and wridx1?"
size2: "how many bytes are buffered for socket between rdidx2 and wridx2?"

Each session has got two buffers. Buffers are circular. If sizeN == 0,
buffer is empty. If sizeN == BUFSIZE, buffer is full. In both these cases
rdidxN == wridxN.
}
script(记录指定shell的){ poll 
script [-afq] [-c COMMAND] [OUTFILE]
-a
-c
-f
-q

script -a  -c rtu_conf script_ouput # 执行rtu_conf，将rtu_conf执行结果追加到script_ouput文件中
script script_ouput_t               # 记录执行过程，包括输入和输出
}
netcat(){
netcat -s 127.0.0.1 -p 1234 -tL /bin/bash -l

}
ptmx(创建伪终端的master和slave对){
/dev/ptmx: 字符设备文件，主设备号5，次设备号2，mode：0666， 用户和组：root和root。
被用来创建伪终端的master和slave对。
     # p = open("/dev/ptmx", O_RDWR); # p为master
     # grantpt(p); 
     # unlockpt(p); 
     # name = ptsname(p);             # name为/dev/pts/下一个文件表示为slave设备文件
fd = xgetpty(tty_name); # fd为master文件描述符 tty_name为从设备文件名

# 主设备文件创建
     # ts->ptyfd = fd; -- fd = xgetpty(tty_name);
# 传入socket 管理
     # ts->sockfd_read = sock;
     # setsockopt(sock, SOL_SOCKET, SO_KEEPALIVE, &const_int_1, sizeof(const_int_1));
     # ndelay_on(sock);
     # ts->sockfd_write = sock;
# 进程管理
     # fflush(NULL); 
     # pid = vfork(); 
     # if (pid < 0) {
     #     free(ts);
     #     close(fd);
     #     return NULL;
     # }
     # if (pid > 0) {
     #     ts->shell_pid = pid;
     #     return ts;
     # }
     # setsid();
# 从设备文件名处理
     # close(0);
     # xopen(tty_name, O_RDWR);
     # xdup2(0, 1);
     # xdup2(0, 2);
     # tcsetpgrp(0, getpid());
# 终端配置管理
     # tcgetattr(0, &termbuf);
     # termbuf.c_lflag |= ECHO; 
     # termbuf.c_oflag |= ONLCR | XTABS;
     # termbuf.c_iflag |= ICRNL;
     # termbuf.c_iflag &= ~IXOFF;
     # tcsetattr_stdin_TCSANOW(&termbuf);
# /etc/issue.net 输出
    # print_login_issue(issuefile, tty_name);
# /bin/login 被执行
    # BB_EXECVP(loginpath, (char **)login_argv);
make_new_session(sock)
}
forkpty(构建基于虚拟终端的登录shell){
pid_t forkpty(int *amaster, char *name, struct termios *termp, struct winsize *winp);
pid_t   : 子进程pid
amaster : master文件描述符
name    : slave设备属性
termp   : 终端属性配置
winp    : 窗口大小

forkpty()  = openpty() + fork(2) + login_tty() 
}

openpty(构建技术/dev/ptmx的虚拟终端){
int openpty(int *amaster, int *aslave, char *name, struct termios *termp, struct winsize *winp);
amaster : master文件描述符
aslave  : slave文件描述符
name    : slave设备属性
termp   : 终端属性配置
winp    : 窗口大小
}

login_tty(准备基于某个文件描述符登录){
int login_tty(int fd);
fd  : slave文件描述符
}


