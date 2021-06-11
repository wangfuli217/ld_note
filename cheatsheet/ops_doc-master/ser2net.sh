ser2net(手册){
ser2net守护进程允许通过telnet和tcp sessions连接到一个串口设备上，访问此串口。
ser2net以守护进程方式启动，根据配置文件打开tcp监听，等待tcp连接。一旦连接发生，ser2net试着建立连接和打开串口。
如果另一个用户已经建立连接或者使用这个串口设备，新建连接将被拒绝。
-c config-file  指定另一个配置文件，默认配置文件是/etc/ser2net.conf 
-C config-line  按单行配置处理。如果配置文件的一行配置。这会使配置文件失效。所以必须在指定-C config-line之后指定-c config-file
-n              不再作为daemon方式运行，在init文件中很有效
-d              与-n类似，将系统日志输出到前台，在调试时候很有用
-P pidfile      将ser2net程序的pid写入pidfile文件，pidfile文件必须为全路径
-u              UUCP锁-忽略
-b              按照思科IOS提供的方式指定波特率
-p controlport  使能控制端口，同时设置tcp端口来监听指定的控制端口。
                127.0.0.1,2000 or localhost,2000
                如果端口没有指定，则使用标准IO作为输入输出。被用在inetd中
控制端口形式：
showport [<TCP port>]
showshortport [<TCP port>]
help
exit
version
monitor <type> <tcp port>
monitor stop
disconnect <tcp port>
setporttimeout <tcp port> <timeout>
setportconfig <tcp port> <config>
setportcontrol <tcp port> <controls>
setportenable <tcp port> <enable state>

配置文件格式：
 <TCP port>:<state>:<timeout>:<device>:<options> 或者
BANNER:<banner name>:<banner text>

TCP port     [host,]port 例如 127.0.0.1,2000 or localhost,2000
state        raw，rawlp，telnet，off。off 不接收来自此端口的连接。
                                      raw  打开端口，并且传输所有数据在端口和long
                                      rawlp 打开端口，传输所有数据到串口，打开串口没有任何配置更改
                                      telnet 打开端口，打开telnet协议，接收telnet协议指定参数
timeout      多久未传输数据就断开连接，0表示此功能不生效
device       /dev/<device>
device configuration options   波特率               300, 1200, 2400, 4800, 9600, 19200, 38400, 57600, 115200 
                               奇偶校验             EVEN, ODD, NONE
                               停止位               1STOPBIT,  2STOPBITS
                               数据位               7DATABITS, 8DATABITS
                               [-]XONXOFF           打开/关闭软控制
                               [-]RTSCTS            打开/关闭硬控制
                               [-]LOCAL             忽略DCD, DTR等控制线
                               [-]HANGUP_WHEN_DONE  不拉低 DCD, DTR,等控制线
                               NOBREAK              是自动清屏的break设置实效
                               remctl               允许远程控制串口参数
                               <banner name>        给远程一个提示符
banner name   提示符名称
banner text   提示符内容       \d 设备名
                               \p TCP端口
                               \s 串口参数
}
ser2net(){
ser2net顾名思义就是serial to network的缩写，就是一个将串口数据转化成网络的软件。
安装：sudo apt-get install ser2net
查看安装位置：whereis ser2net
配置文件： cat /etc/ser2net.conf(默认的配置)
BANNER:banner:\r\nser2net port \p device \d [\s] (Debian GNU/linux)\r\n\r\n

2000:telnet:600:/dev/ttyS0:9600 8DATABITS NONE 1STOPBIT banner
2001:telnet:600:/dev/ttyS1:9600 8DATABITS NONE 1STOPBIT banner
3000:telnet:600:/dev/ttyS0:19200 8DATABITS NONE 1STOPBIT banner
3001:telnet:600:/dev/ttyS1:19200 8DATABITS NONE 1STOPBIT banner
一般的配置：TCP port:state:timeout:device:options
state：raw（原始数据）、rawlp、off（禁用）、telnet（使用telnet协议）
options：配置波特率等串口信息
}

ser2net(){
2003:raw:0:/dev/ttySAC1:115200 8DATABITS EVEN 1STOPBIT -RTSCTS -XONXOFF LOCAL
port：    tcp/ip的端口号，用于接收该设备上来的连接，可以加IP信息如 127.0.0.1，2000  或者localhost,2000;  如果这里指定了IP则只能绑定在这个固定的IP上了；
state ：   raw/   rawlp/  telnet/  off     四种可选状态； off: 禁止该端口的连接， 
off      关闭端口
raw   原始数据
rawlp    
telnet   使用telnet协议时用
timeout：   超时，以秒为单位，；  当没有活动的连接时。可以设置这个时间关闭端口；常写0，关闭该功能，即不会超时；
<device>  指定映射本机的哪个串口 This   must be in the form of /dev/<device>  
<options>options  设置波特率，奇偶校验，停止位，数据位，是否开流控，硬件流控，等

下面是一个配置例子，通过telnet协议，网口转usb，再通过usb转串口接线，转串口
20053:telnet:14400:/dev/ttyUSB5:115200 8DATABITS NONE 1STOPBIT LOCAL banner
LOCAL 必须添加，否则使用telnet登陆会闪退。提示链接被关闭的信息
use : telnet localhost 20053 , or telnet 192.168.1.100 20053

四：配置好配置文件之后，设置开机启动
我们知道Linux系统开机后的会启动一系列的脚本， 最后的最后会启动   /etc/rc.local  脚本；
这个脚本是留给用户自定义的，所以我们可以在这个脚本的 exit(0)之前添启动ser2net的命令；
/sbin/ser2net   -c    /etc/ser2net.conf   &         后台启动ser2net    -c指定使用的配置文件
}

ser2net -C "3001:telnet:0:/dev/ttyUSB0:9600 NONE 1STOPBIT 8DATABITS -XONXOFF -LOCAL -RTSCTS -XONXOFF -LOCAL -RTSCTS" 
ser2net -c /etc/ser2net.conf 

This is ser2net, a program for allowing network connections to serial ports. See the man page for information 
about using the program. Note that ser2net supports RFC 2217 (remote control of serial port parameters), but 
you must have a compliant client. The only one I know if is kermit (http://www.columbia.edu/kermit). 

If you want the opposite of ser2net (you want to connect to a "local" serial port device that is really remote) 
then Cyclades has provided a tool for this at http://www.coker.com.au/cyclades. It is capable of connecting to 
ser2net using RFC2217.


sonet(串口虚拟化：通过网络访问串口){
1 简介
串口是嵌入式设备中常见的调试、通信和下载接口。通常情况下，仅仅需要在开发主机上访问该串口，可通过标准的串口线或者 
USB 线连到串口上。
如果要在开发主机之外也能访问到串口呢？

2 Serial Port Over Network
通过网络虚拟化串口的基本需求很简单，首先要把串口虚拟化为网络端口，之后在网络中的另外一台主机上通过 telnet 等工具
直接访问该网络端口或者反过来把网络端口逆向为一个虚拟化的串口，进而通过串口的 minicom 等工具也可以访问。
这样的工具有 socat, netcat, ser2net, remserial, conmux，发现 socat 非常好用，这里在参考 socat-ttyovertcp.txt 的基础
上介绍它的用法。

在具体实验之前，我们做如下假设：

串口           /dev/tty.SLAB_USBtoUART        接入 MacBook Pro 的 cp2102
主机 IP       192.168.1.168	                 串口直连的主机 IP 地址
主机端口      54321	                         虚拟化以后的端口
虚拟串口      /dev/tty.virt001

2.1 串口转 TCP 端口
sudo socat tcp-l:54321,reuseaddr,fork file:/dev/tty.SLAB_USBtoUART,waitlock=/var/run/tty0.lock,clocal=1,cs8,
nonblock=1,ixoff=0,ixon=0,ispeed=9600,ospeed=9600,raw,echo=0,crtscts=0
也可简单使用：
sudo socat tcp-l:54321 /dev/tty.SLAB_USBtoUART,clocal=1,nonblock

2.2 TCP 端口转虚拟串口
sudo socat pty,link=/dev/tty.virt001,waitslave tcp:192.168.1.168:54321

2.3 远程访问串口
sudo minicom -D /dev/tty.virt001
或
telnet 192.168.1.168 54321
}

