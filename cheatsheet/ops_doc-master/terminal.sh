command(){
1. 查看串口是否可用，可以对串口发送数据比如对com1口，echo lyjie126 > /dev/ttyS0 
2. 查看串口名称使用 ls -l /dev/ttyS* 一般情况下串口的名称全部在dev下面，如果你没有外插串口卡的话默认是dev下的ttyS* ,一般ttyS0对应com1，ttyS1对应com2，当然也不一定是必然的； 
3. 查看串口驱动：cat /proc/tty/drivers/serial 
4. 查看串口设备：dmesg | grep ttyS*
5. 查一下板子上的串口有没有设备
   grep tty /proc/devices
   如果有ttyS设备，再看/dev/有没有ttyS*，如没有就建立一个：mknod /dev/ttyS0 c 4 64
   如果板子的设备中没有标准串口设备ttyS0，也没有ttySAC0。/dev下应该有一个USB串口：/dev/ttyUSB0.
   当一个串行卡或数据卡被侦测到时，它会被指定成为第一个可用的串行设备。通常是/dev/ttyS1(cua1)或/dev/ttyS2(cua2)，这完成看原已内建的串口数目。ttyS*设备会被报告在/var/run/stab内。
PC上的串口一般是ttyS，板子上Linux的串口一般叫做ttySAC

stty -a    这个命令用来查看当前终端的设置情况
stty sane    如果不小心设错了终端模式,可用这个命令恢复,另一种恢复办法是在设置之前保存当前stty设置,在需要时再读出
stty -g > save_stty    将当前设置保存到文件save_atty中
stty $(cat save_stty)    读出save_atty文件,恢复原终端设置
}

driver(){
------------------ s3c2410 ------------------
/proc/tty/driver/s3c2410_serial
serinfo:1.0 driver revision:
0: uart:S3C6400/10 mmio:0x13800000 irq:16 tx:23654784 rx:8084178 fe:124370 brk:124370 RTS|CTS|DTR|DSR|CD
1: uart:S3C6400/10 mmio:0x13810000 irq:20 tx:0 rx:0 DSR|CD
2: uart:S3C6400/10 mmio:0x13820000 irq:24 tx:12827 rx:0 RTS|DTR|DSR|CD
3: uart:S3C6400/10 mmio:0x13830000 irq:28 tx:0 rx:0 DSR|CD

/sys/class/tty/ttySAC0/device

# dmesg | grep ttyS*
console [ttySAC2] enabled
s5pv210-uart.3: ttySAC3 at MMIO 0x13830000 (irq = 28) is a S3C6400/10

# stty -a -F /dev/ttySAC0  -- MCU板和其他板卡进行通信
speed 57600 baud; rows 24; columns 80; # 波特率
intr = <undef>; quit = <undef>; erase = <undef>; kill = <undef>; eof = <undef>; eol = <undef>; eol2 = <undef>; start = <undef>; # c_cc  控制字符
stop = <undef>; susp = <undef>; rprnt = <undef>; werase = <undef>; lnext = <undef>; flush = <undef>; min = 1; time = 0;         # c_cc  控制字符
-parenb -parodd cs8 -hupcl -cstopb cread clocal -crtscts                                                # c_cflag  控制模式标志
ignbrk -brkint -ignpar -parmrk -inpck -istrip -inlcr -igncr -icrnl -ixon -ixoff -iuclc -ixany -imaxbel  # c_iflag  输入模式标志
-opost -olcuc -ocrnl -onlcr -onocr -onlret -ofill -ofdel nl0 cr0 tab0 bs0 vt0 ff0                       # c_oflag  输出模式标志
-isig -icanon -iexten -echo -echoe -echok -echonl -noflsh -xcase -tostop -echoprt -echoctl -echoke      # c_lflag  本地模式标志

# stty -a -F /dev/ttySAC2 -- RTU后面用于调试
speed 115200 baud; rows 24; columns 80;
intr = ^C; quit = ^\; erase = ^?; kill = ^U; eof = ^D; eol = <undef>; eol2 = <undef>; start = ^Q; stop = ^S; susp = ^Z; rprnt = ^R;
werase = ^W; lnext = ^V; flush = ^O; min = 1; time = 0;
-parenb -parodd cs8 -hupcl -cstopb cread clocal -crtscts
-ignbrk -brkint -ignpar -parmrk -inpck -istrip -inlcr -igncr icrnl ixon ixoff -iuclc -ixany -imaxbel
opost -olcuc -ocrnl onlcr -onocr -onlret -ofill -ofdel nl0 cr0 tab0 bs0 vt0 ff0
isig icanon iexten echo echoe echok -echonl -noflsh -xcase -tostop -echoprt echoctl echoke
------------------ PC ------------------
# 16550A与用于8250的软件兼容，而前者提供更高的性能。16550A的管脚与8250、8250A和16450相同。
/proc/tty/driver/serial
serinfo:1.0 driver revision:
0: uart:16550A port:000003F8 irq:4 tx:0 rx:0

# find -name irq -type f | xargs grep 4
./devices/pnp0/00:08/tty/ttyS0/irq:4
./devices/platform/serial8250/tty/ttyS2/irq:4

# dmesg | grep ttyS*
console [tty0] enabled
00:08: ttyS0 at I/O 0x3f8 (irq = 4, base_baud = 115200) is a 16550A
------------------ PC RD330 ------------------
serinfo:1.0 driver revision:
0: uart:16550A port:000003F8 irq:4 tx:0 rx:0
1: uart:16550A port:000002F8 irq:5 tx:0 rx:0
2: uart:16550A port:000003E8 irq:3 tx:0 rx:0
3: uart:unknown port:000002E8 irq:3

# dmesg | grep ttyS*
console [tty0] enabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
serial8250: ttyS1 at I/O 0x2f8 (irq = 5) is a 16550A
serial8250: ttyS2 at I/O 0x3e8 (irq = 3) is a 16550A
00:04: ttyS2 at I/O 0x3e8 (irq = 3) is a 16550A
00:05: ttyS1 at I/O 0x2f8 (irq = 5) is a 16550A
}

serial.sh                          文本
stty reset tset setserial slattach 命令
socat                              扩展
proc       # cat /proc/tty/driver/serial
statserial # statserial /dev/ttyS0
stty       # stty -F /dev/ttyS0 -a

ctermid(终端标识){
在大多数UNIX系统中，控制终端的名字是/dev/tty。POSIX.1提供了一个运行时函数，可被用来确定控制终端的名字。
#include <stdio.h>  
char *ctermid(char *ptr); //若成功则返回指向控制终端名的指针，若出错则返回指向空字符串的指针。
如果ptr非null，则它被认为是一个指针，指向长度至少为L_ctermid字节的数组，进程控制终端名存放在该数组中。
常量L_ctermid定义在<stdio.h>中。若ptr是一个空指针，则该函数为数组分配空间（通常为静态变量）。
同样，进程的控制终端名存放在该数组中。
}
isatty(是否为终端设备){
isatty在文件描述符引用一个终端设备时返回真
#include<unistd.h>  
int isatty(int filedes); //若为终端设备则返回1，否则返回0.
}
ttyname(终端设备的路径名){
返回在该文件描述符上打开的终端设备的路径名。
#include<unistd.h>  
char *ttyname(int filedes); //返回值：指向终端路径名的指针，出错则返回NULL。
}

winsize(终端界面大小){
大多数UNIX都提供了一种功能，可以对当前终端的大小进行跟踪，在窗口大小发生变化时，使内核通知前台进程组。内核
为每个终端和伪终端保存一个winsize结构：
struct winsize{
unsigned short ws_row; //rows in characters
unsigned short ws_col; //columns, in characters
unsigned short ws_xpixel; //horizontal size, pixels (unused)
unsigned short ws_ypixel; //vertical size, pixels (unused)
};
此结构的作用如下：
用ioctl的TIOCGWINSZ命令可以取此结构的当前值。
用ioctl的TIOCSWINSZ命令可以将此结构的新值存放到内核中，如果此新值与存放在内核中的当前值不同，则向前台进程组
发送SIGWINCH信号。
除了存放此结构的当前值以及在此值改变时产生一个信号以外，内核对该结构不进行任何操作。
提供这种功能的目的是，当窗口大小发生变化时通知应用程序，应用程序接到此信号后，它可以取窗口大小的新值，然后重绘屏幕。
}

#include <stdio.h>
#include <termios.h>
#include <sys/ioctl.h>
#include <signal.h>
#include <unistd.h>

static void pr_winsize(int fd){
    struct winsize size;
    if(ioctl(fd,TIOCGWINSZ,(char*)&size) < 0){
        perror("ioctl");
        return;
    }
    printf("%d rows, %d columns\n",size.ws_row, size.ws_col);
}

static void sig_winch(int signo){
    printf("SIGWINCH received.\n");
    pr_winsize(STDIN_FILENO);
}

int main(void){
    if(isatty(STDIN_FILENO) == 0){
        perror("isatty");
        return -1;
    }
    
    if(signal(SIGWINCH,sig_winch) == SIG_ERR){ // SIGWINCH窗口大小发生变化
        perror("signal");
        return -1;
    }
    
    pr_winsize(STDIN_FILENO);
    for(;;){
        pause();
    }
}

posix_openpt(打开下一个可用的伪终端主设备){
打开下一个可用的伪终端主设备
#include<stdlib.h>  
#include<fcntl.h>  
int posix_openpt(int oflag); //成功则返回下一个可用的PTY主设备的文件描述符，出错则返回-1。

参数oflag是一个位屏蔽字，指定如何打开主设备，它类似于open的oflag参数，但是并不支持所有打开标志。对于posix_openpt，
我们可以指定O_RDWR，要求打开主设备进行读、写；可以指定O_NOCTTY以防止主设备成为调用者的控制终端。其他
打开标志会导致未定义的行为。
}
在伪终端从设备可被使用之前，必须设置它的权限，使得应用程序可以访问它。grantpt函数提供这样的功能。它把从设备
节点的用户ID设置为调用者的实际用户ID，设置其组ID为一个非指定值，通常是可以访问该终端设备的组。将权限设置为：
对单个所有者是读写，对组所有者是写。
grantpt(){
注意：在grantpt和unlockpt这两个函数中，文件描述符参数是与主伪终端关联的文件描述符。
#include<stdlib.h>  
int grantpt(int filedes);  
}
unlockpt(){
unlockpt函数用于准许对伪终端从设备的访问，从而允许应用程序打开该设备。阻止其他进程打开从设备后，建立该设备的
应用程序有机会在使用主从设备之前正确地初始化这些设备。
#include<stdlib.h>  
int unlockpt(int filedes);
}
ptsname(在给定主伪终端设备的文件描述符时，找到从伪终端设备的路径名){
这使应用程序可以独立于给定平台的
某种惯例而标识从设备。注意，该函数返回的名字可能存放在静态存储区中，所以以后的调用可能会覆盖它。
    #include<stdlib.h>  
    char *ptsname(int filedes); //若成功则返回指向PTY从设备名的指针，出错则返回NULL。
}
