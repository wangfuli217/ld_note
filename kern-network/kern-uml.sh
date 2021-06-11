
build(linux)
{
 1，内核编译：
先说下环境如下，操作系统为CentOS 6.0 64位，除内核被升级为2.6.38.8外，其它基本环境无改变：
[root@localhost uml]# cat /etc/issue
CentOS Linux release 6.0 (Final)
Kernel \r on an \m

[root@localhost uml]# uname -a
Linux localhost.localdomain 2.6.38.8 #5 SMP Sun Aug 19 21:23:53 CST 2012 x86_64 x86_64 x86_64 GNU/Linux

解压配置，就以linux-2.6.38.8为例，因为刚好有这个内核源码压缩包：
[root@localhost uml]# tar xjf linux-2.6.38.8.tar.bz2
[root@localhost uml]# cd linux-2.6.38.8
[root@localhost linux-2.6.38.8]# make ARCH=um menuconfig

}

config(make menuconfig)
{
选下如下几项：
将以虚拟块设备作为根文件系统，并且我这里提供的根文件系统是ext4的：
Device Drivers —>
[*] Block devices —>
[*] Virtual block device
[*] Always do synchronous disk IO for UBD
File systems —>
<*> The Extended 4 (ext4) filesystem

将以虚拟设备作为网络设备，可根据需要选择，比如如下：
[*] Networking support —>
UML Network Devices —>
[*] Virtual network device
[*] Ethertap transport
[*] TUN/TAP transport
[*] SLIP transport
[*] Daemon transport
[ ] VDE transport
[*] Multicast transport
[ ] pcap transport
[*] SLiRP transport

既然是调内核，这两个选项必不可少：
Kernel hacking —>
[*] Compile the kernel with debug info
[*] Compile the kernel with frame pointers
}

compile(make ARCH=um [linux])
{
执行编译：
[root@localhost linux-2.6.38.8]# make ARCH=um
或者只要linux执行文件：
[root@localhost linux-2.6.38.8]# make ARCH=um linux

如果没有错误，那么就算初步成功，否则请参考前面的文章做错误修复：
[root@localhost linux-2.6.38.8]# ls linux -lFh
-rwxr-xr-x. 2 root root 35M Aug 24 14:36 linux*
}

rootfs(http://fs.devloop.org.uk/)
{
2，UML执行：
首先需要一个根文件系统，从这个网址：http://fs.devloop.org.uk/下载即可：
[root@localhost linux-2.6.38.8]# cp linux ../
[root@localhost linux-2.6.38.8]# cd ..
[root@localhost uml]# ls
linux linux-2.6.38.8 linux-2.6.38.8.tar.bz2 rootfs
[root@localhost uml]# ./linux ubda=./rootfs mem=256m
正常进入到UML系统，退出输入halt或init 0即可。

}

gdb(linux)
{
3，初次调试内核：
首先找到uml对应的进程，一般会有多个：
[root@localhost uml]# ps uf | grep linux | grep -v grep
root 26897 4.3 5.6 270320 57112 pts/0 S+ 14:48 0:12 \_ ./linux ubda=./rootfs mem=256m
root 26904 0.0 5.6 270320 57112 pts/0 S+ 14:48 0:00 \_ ./linux ubda=./rootfs mem=256m
root 26905 0.4 5.6 270320 57112 pts/0 S+ 14:48 0:01 \_ ./linux ubda=./rootfs mem=256m
root 26906 0.0 5.6 270320 57112 pts/0 S+ 14:48 0:00 \_ ./linux ubda=./rootfs mem=256m
root 26907 0.0 0.1 3776 1516 pts/0 t+ 14:48 0:00 \_ ./linux ubda=./rootfs mem=256m
root 27058 0.2 0.0 3120 772 pts/0 t+ 14:48 0:00 \_ ./linux ubda=./rootfs mem=256m
root 27342 0.0 0.0 3152 644 pts/0 t+ 14:48 0:00 \_ ./linux ubda=./rootfs mem=256m
root 27636 0.0 0.0 3400 664 pts/0 t+ 14:48 0:00 \_ ./linux ubda=./rootfs mem=256m
root 27663 0.0 0.1 4036 1376 pts/0 t+ 14:48 0:00 \_ ./linux ubda=./rootfs mem=256m
root 27672 0.0 0.1 4056 1768 pts/0 t+ 14:48 0:00 \_ ./linux ubda=./rootfs mem=256m
一般情况下，用gdb attach到主进程即可：
[root@localhost uml]# gdb -p 26897
进入gdb后立即设置：(gdb) set follow-fork-mode parent
因为UML在运行的过程中可能会fork新的子进程（比如UML启动了新的系统服务），如果不做这个设置，会导致gdb跟丢UML。
试试在schedule()函数处下个断点，按c继续后马上被中断（这是当然的）：
(gdb) b schedule
Breakpoint 1 at 0x601ca50f: file kernel/sched.c, line 4017.
(gdb) c
Continuing.

Breakpoint 1, schedule () at kernel/sched.c:4017
4017 if (need_resched())
(gdb) up
#1 0×0000000060012424 in default_idle () at arch/um/kernel/process.c:246
246 schedule();
(gdb) list
241 /*
242 * although we are an idle CPU, we do not want to
243 * get into the scheduler unnecessarily.
244 */
245 if (need_resched())
246 schedule();
247
248 tick_nohz_stop_sched_tick(1);
249 nsecs = disable_timer();
250 idle_sleep(nsecs);
(gdb)

}

network(tap|tun)
{
4，网络支持：
以TUN/TAP为例。关于更多的信息可以参考：
http://user-mode-linux.sourceforge.net/old/networking.html
UML可以利用host机器的TUN/TAP虚拟网络设备来创建虚拟网卡与外界通信。这里先在host机器上创建tap设备，创建tap设备需要的
应用层工具tunctl可从此处下载：http://sourceforge.net/projects/tunctl/files/

[root@localhost uml]# tar xzf tunctl-1.5.tar.gz
[root@localhost uml]# cd tunctl-1.5
[root@localhost tunctl-1.5]# make
[root@localhost tunctl-1.5]# make install
[root@localhost tunctl-1.5]# tunctl -t tap1
[root@localhost tunctl-1.5]# ifconfig tap1 10.0.0.1

这就在host机器里创建了tap类型的虚拟网络设备，再以如下命令执行UML，从而在UML里创建一个可与该虚拟网络设备通信的网卡eth0：
[root@localhost uml]# ./linux ubda=./rootfs mem=256m eth0=tuntap,tap1,,

在UML里ping host机的tap1的操作：
[root@localhost ~]# ifconfig eth1 10.0.0.2
[root@localhost ~]# ping 10.0.0.1
PING 10.0.0.1 (10.0.0.1) 56(84) bytes of data.
64 bytes from 10.0.0.1: icmp_seq=1 ttl=64 time=67.2 ms
64 bytes from 10.0.0.1: icmp_seq=2 ttl=64 time=0.338 ms
^C
— 10.0.0.1 ping statistics —
2 packets transmitted, 2 received, 0% packet loss, time 1569ms
rtt min/avg/max/mdev = 0.338/33.814/67.290/33.476 ms
[root@localhost ~]#

在host机里ping UML的eth0：
[root@localhost tunctl-1.5]# ping 10.0.0.2
PING 10.0.0.2 (10.0.0.2) 56(84) bytes of data.
64 bytes from 10.0.0.2: icmp_seq=1 ttl=64 time=0.411 ms
64 bytes from 10.0.0.2: icmp_seq=2 ttl=64 time=0.177 ms
^C
— 10.0.0.2 ping statistics —
2 packets transmitted, 2 received, 0% packet loss, time 1312ms
rtt min/avg/max/mdev = 0.177/0.294/0.411/0.117 ms
[root@localhost tunctl-1.5]#

可以创建多个tap虚拟网络设备，让UML创建更多的虚拟网卡：
[root@localhost tunctl-1.5]# tunctl -t tap2
[root@localhost tunctl-1.5]# ifconfig tap2 20.0.0.1
再以“./linux ubda=./rootfs mem=256m eth0=tuntap,tap1,, eth1=tuntap,tap2,,”执行UML即可。其它虚拟网络设备，比如ethertap、Multicast、switch daemon、slip、slirp等也都可以利用，这里有一套官方工具：http://user-mode-linux.sourceforge.net/uml_utilities_20070815.tar.bz2。

5，利用uml_switch对UML虚拟机进行组网：
首先，使用uml_switch命令创建三台虚拟交换机：switch1、switchA和switchB，其中：
switch1的网络为10.0.0.0/24，并且其对应的tap1的host ip地址为10.0.0.1，启动和配置方式为：
[root@localhost af]# nohup uml_switch -tap tap1 -unix /tmp/switch1 &
[root@localhost af]# ifconfig tap1 10.0.0.1
switchA的网络为192.168.11.0/24，启动方式为：
[root@localhost af]# nohup uml_switch -tap tapA -unix /tmp/switchA &
switchB的网络为192.168.22.0/24，启动方式为：
[root@localhost af]# nohup uml_switch -tap tapB -unix /tmp/switchB &

接着，启用serverA，使其有两个网卡，一个连接switch1(eth0)，一个连接switchA(eth1)，启动serverA的命令为：
[root@localhost net_simu]# ./serverA/linux ubda=./serverA/rootfs mem=128m eth0=daemon,,unix,/tmp/switch1 eth1=daemon,,unix,/tmp/switchA
执行成功登陆UML系统后，可看到有两个网卡表示正常。

启动serverB，使其也有两个网卡，一个连接switch1(eth0)，一个连接switchA(eth1)，启动serverB的命令为：
[root@localhost net_simu]# ./serverB/linux ubda=./serverB/rootfs mem=128m eth0=daemon,,unix,/tmp/switch1 eth1=daemon,,unix,/tmp/switchB

启动clientA1，使其有一个网卡，连接switchA(eth0)，启动命令为：
[root@localhost net_simu]# ./clientA1/linux ubda=./clientA1/rootfs mem=128m eth0=daemon,,unix,/tmp/switchA

启动clientB1，使其有一个网卡，连接switchB (eth0)，启动命令为：
[root@localhost net_simu]# ./clientB1/linux ubda=./clientB1/rootfs mem=128m eth0=daemon,,unix,/tmp/switchB

启动clientB2，使其有一个网卡，连接switchB (eth0)，启动命令为：
[root@localhost net_simu]# ./clientB2/linux ubda=./clientB2/rootfs mem=128m eth0=daemon,,unix,/tmp/switchB

做网络测试：
在clientB2上ping clientB1和serverB没问题，其它几个switch域内互ping也没问题；
在serverA上ping host机器OK，ping google的DNS服务器不行，那是当然的，需要我们再在host机器上加上NAT才能当UML的数据发送出去，先对host机器做如下设置：
[root@www ~]# echo 1 > /proc/sys/net/ipv4/ip_forward

[root@www ~]# iptables -F INPUT

[root@www ~]# iptables -F OUTPUT

[root@www ~]# iptables -F FORWARD

[root@www ~]# iptables -t nat -F POSTROUTING

[root@www ~]# iptables -t nat -F PREROUTING

[root@www ~]# iptables -t nat -A POSTROUTING -o eth3 -s 10.0.0.0/24 -j MASQUERADE

再试试ping google DNS服务器，就已经可以了。
}

rootfs(busybox)
{
STEP 1：构建目录结构 
创建根文件系统目录，主要包括以下目录
/dev  /etc /lib  /usr  /var /proc /tmp /home /root /mnt /bin  /sbin  /sys 
#mkdir     /home/rootfs
#cd        /home/rootfs
#mkdir  dev  etc  lib  usr  var  proc  tmp  home  root  mnt   sys

STEP 2:    使用busybox构建/bin /sbin linuxrc
进入busybox-1.16.1目录，执行
#make defconfig
#make menuconfig

Busybox Setting ----->
    Build Options ----->
        //1选择将busybox进行静态编译
        [*]Build BusyBox as a static binary (no shared libs)
        //2.指定交叉编译器为
        (/usr/local/arm/4.3.2/bin/arm-linux-)Cross Compiler prefix[填入交叉工具链的前缀，这里是arm-none-linux-gnueab-]

Installation Options ----->[安装路径，我喜欢用这个默认值]

        //3.选择上 Don’t use /usr
Busybox Library Tuning--->
    [*]Username completion
    [*]Fancy shell prompts
    [*]Query  cursor  position  from  terminal
        //4.编译出的busybox的shell命令解释器支持显示当前路径及主机信息
保存退出

#make   
#make install

在busybox目录下会看见 _install目录，里面有/bin /sbin linuxrc三个文件
将这三个目录或文件拷到第一步所建的rootfs文件夹下。
#cp bin/ sbin/ linuxrc /home/rootfs -ra 
切记一定要带上-a的参数，因为bin目录里大部分都是链接，如果不带-a的参数，拷过去之后会做相应的复制，不再是链接的形式

STEP 3  构建etc目录：
    1)进入根文件系统rootfs的etc目录，执行如下操作：
       拷贝Busybox-1.16.1/examples/bootfloopy/etc/* 到当前目录下
        #cp –r busybox-1.16.1/examples/bootfloopy/etc/*  rootfs/etc
        修改inittab，把第二项改为::respawn:-/bin/login
        删除第三、第四行代码   

    2)拷贝虚拟机上的/etc/passwd, /etc/group, /etc/shadow到rootfs/etc下
        # cp /etc/passwd   rootfs/etc
        # cp /etc/group    rootfs/etc
        # cp /etc/shadow   roofs/etc

        对以下三个文件修改，只保存与root相关的项，根据具体情况内容会有所不同。
        修改passwd为root:x:0:0:root:/root:/bin/sh，即只保存与root相关项，而且最后改成/bin/ash。
        修改group为root:x:0:root
        修改shadow为root:$1$x9yv1WlB$abJ2v9jOlOc9xW/y0QwPs.:14034:0:99999:7:::

    登陆开发板时需输入用户名密码，同虚拟机相同
    3)修改profile
        PATH=/bin:/sbin:/usr/bin:/usr/sbin          //可执行程序 环境变量
        export LD_LIBRARY_PATH=/lib:/usr/lib        //动态链接库 环境变量
        /bin/hostname sunplusedu
        USER="`id -un`"
        LOGNAME=$USER
        HOSTNAME='/bin/hostname'
        PS1='[\u@\h \W]# '                          //显示主机名、当前路径等信息：
    4)修改 etc/init.d/rc.S文件
        /bin/mount -n -t ramfs ramfs /var
        /bin/mount -n -t ramfs ramfs /tmp
        /bin/mount -n -t sysfs none /sys
        /bin/mount -n -t ramfs none /dev
        /bin/mkdir /var/tmp
        /bin/mkdir /var/modules
        /bin/mkdir /var/run
        /bin/mkdir /var/log
        /bin/mkdir -p /dev/pts                    //telnet服务需要
        /bin/mkdir -p /dev/shm                    //telnet服务需要
        echo /sbin/mdev > /proc/sys/kernel/hotplug//USB自动挂载需要
        /sbin/mdev -s         //启动mdev在/dev下自动创建设备文件节点
        /bin/mount -a

    5)修改etc/fstab文件，增加以下文件
        none   /dev/pts    devpts   mode=0622      0 0
       tmpfs  /dev/shm    tmpfs    defaults       0 0
}

busybox(/etc/inittab)
{
::sysinit:/etc/init.d/rcS
::ctrlaltdel:/sbin/reboot
::shutdown:/sbin/swapoff -a
::shutdown:/bin/umount -a -r
::restart:/sbin/init

ttyS2::respawn:-/bin/sh
}

busybox(/etc/init.d/rcS)
{
mount -a　　　　　　　　　　　　　　　　　　　　　　# 挂载在/etc/fstab中定义的所有挂载点
echo /sbin/mdev > /proc/sys/kernel/hotplug　　# 设置热插拔事件处理程序为mdev
mdev -s　　　　　　　　　　　　　　　　　　　　　　　#设备节点维护程序mdev初始化
mkdir /dev/pts　　　　　　　　　　　　　　　　　　　#为telnetd创建pts目录
mount -t devpts devpts /dev/pts　　　　　　　　　　#挂载pts目录
/bin/hostname -F /etc/hostname　　　　　　　　　　# 设置主机名。/etc/hostname 的内容为主机名字符串

mkdir /var/run　　　　　　　　　　　　　　　　　　　　#ifup需要该目录
/sbin/ifup -a　　　　　　　　　　　　　　　　　　　　#根据/etc/network/interface设置网卡

/usr/sbin/telnetd &　　　　　　　　　　　　　　　　#运行telnetd
}

busybox(/etc/fstab)
{
/etc/fstab的内容

tmpfs /dev tmpfs  defaults 0 0
proc /proc proc defaults 0 0
sysfs /sys sysfs defaults 0 0
tmpfs /var tmpfs defaults 0 0
tmpfs /tmp tmpfs defaults 0 0
}

busybox(ifup)
{
IP=192.168.0.254
Mask=255.255.255.0
Gateway=192.168.0.1
DNS=8.8.8.8
MAC=00:00:FF:FF:00:00
}

kernel(--help)
{
User Mode Linux v3.0.0
        available at http://user-mode-linux.sourceforge.net/

--showconfig
    Prints the config file that this UML binary was generated from.

iomem=<name>,<file>
    Configure <file> as an IO memory region named <name>.

mem=<Amount of desired ram>
    This controls how much "physical" memory the kernel allocates
    for the system. The size is specified as a number followed by
    one of 'k', 'K', 'm', 'M', which have the obvious meanings.
    This is not related to the amount of memory in the host.  It can
    be more, and the excess, if it is ever used, will just be swapped out.
        Example: mem=64M

--help
    Prints this message.

debug
    this flag is not needed to run gdb on UML in skas mode

root=<file containing the root fs>
    This is actually used by the generic kernel in exactly the same
    way as in any other kernel. If you configure a number of block
    devices and want to boot off something other than ubd0, you
    would use something like:
        root=/dev/ubd5

--version
    Prints the version number of the kernel.

umid=<name>
    This is used to assign a unique identity to this UML machine and
    is used for naming the pid file and management console socket.

con[0-9]*=<channel description>
    Attach a console or serial line to a host channel.  See
    http://user-mode-linux.sourceforge.net/old/input.html for a complete
    description of this switch.

ssl[0-9]*=<channel description>
    Attach a console or serial line to a host channel.  See
    http://user-mode-linux.sourceforge.net/old/input.html for a complete
    description of this switch.

eth[0-9]+=<transport>,<options>
    Configure a network device.

mconsole=notify:<socket>
    Requests that the mconsole driver send a message to the named Unix
    socket containing the name of the mconsole socket.  This also serves
    to notify outside processes when UML has booted far enough to respond
    to mconsole requests.

udb
    This option is here solely to catch ubd -> udb typos, which can be
    to impossible to catch visually unless you specifically look for
    them.  The only result of any option starting with 'udb' is an error
    in the boot output.

ubd<n><flags>=<filename>[(:|,)<filename2>]
    This is used to associate a device with a file in the underlying
    filesystem. When specifying two filenames, the first one is the
    COW name and the second is the backing file name. As separator you can
    use either a ':' or a ',': the first one allows writing things like;
        ubd0=~/Uml/root_cow:~/Uml/root_backing_file
    while with a ',' the shell would not expand the 2nd '~'.
    When using only one filename, UML will detect whether to treat it like
    a COW file or a backing file. To override this detection, add the 'd'
    flag:
        ubd0d=BackingFile
    Usually, there is a filesystem in the file, but
    that's not required. Swap devices containing swap files can be
    specified like this. Also, a file which doesn't contain a
    filesystem can have its contents read in the virtual
    machine by running 'dd' on the device. <n> must be in the range
    0 to 7. Appending an 'r' to the number will cause that device
    to be mounted read-only. For example ubd1r=./ext_fs. Appending
    an 's' will cause data to be written to disk on the host immediately.
    'c' will cause the device to be treated as being shared between multiple
    UMLs and file locking will be turned off - this is appropriate for a
    cluster filesystem and inappropriate at almost all other times.

fake_ide
    Create ide0 entries that map onto ubd devices.

xterm=<terminal emulator>,<title switch>,<exec switch>
    Specifies an alternate terminal emulator to use for the debugger,
    consoles, and serial lines when they are attached to the xterm channel.
    The values are the terminal emulator binary, the switch it uses to set
    its title, and the switch it uses to execute a subprocess,
    respectively.  The title switch must have the form '<switch> title',
    not '<switch>=title'.  Similarly, the exec switch must have the form
    '<switch> command arg1 arg2 ...'.
    The default values are 'xterm=xterm,-T,-e'.  Values for gnome-terminal
    are 'xterm=gnome-terminal,-t,-x'.

aio=2.4
    This is used to force UML to use 2.4-style AIO even when 2.6 AIO is
    available.  2.4 AIO is a single thread that handles one request at a
    time, synchronously.  2.6 AIO is a thread which uses the 2.6 AIO
    interface to handle an arbitrary number of pending requests.  2.6 AIO
    is not available in tt mode, on 2.4 hosts, or when UML is built with
    /usr/include/linux/aio_abi.h not available.  Many distributions do not
    include aio_abi.h, so you will need to copy it from a kernel tree to
    your /usr/include/linux in order to build an AIO-capable UML

noptraceldt
    Turns off usage of PTRACE_LDT, even if host supports it.
    To support PTRACE_LDT, the host needs to be patched using
    the current skas3 patch.

noptracefaultinfo
    Turns off usage of PTRACE_FAULTINFO, even if host supports
    it. To support PTRACE_FAULTINFO, the host needs to be patched
    using the current skas3 patch.

noprocmm
    Turns off usage of /proc/mm, even if host supports it.
    To support /proc/mm, the host needs to be patched using
    the current skas3 patch.

nosysemu
    Turns off syscall emulation patch for ptrace (SYSEMU) on.
    SYSEMU is a performance-patch introduced by Laurent Vivier. It changes
    behaviour of ptrace() and helps reducing host context switch rate.
    To make it working, you need a kernel patch for your host, too.
    See http://perso.wanadoo.fr/laurent.vivier/UML/ for further
    information.

mode=skas0
    Disables SKAS3 and SKAS4 usage, so that SKAS0 is used.

skas0
    Disables SKAS3 and SKAS4 usage, so that SKAS0 is used

uml_dir=<directory>
    The location to place the pid and umid files.

hostfs=<root dir>,<flags>,...
    This is used to set hostfs parameters.  The root directory argument
    is used to confine all hostfs mounts to within the specified directory
    tree on the host.  If this isn't specified, then a user inside UML can
    mount anything on the host that is accessible to the user that's running
    it.
    The only flag currently supported is 'append', which specifies that all
    files opened by hostfs will be opened in append mode.
}

kgdb()
{
    硬件         目标机                      目标机
IP地址          192.168.5.13                192.168.6.13
端口连接        COM1                        COM1                            调试选用串口连接，调试的端口可以选用以太网口
操作系统        Fedora                      Fedora
linux内核       Linux2.6.7                  Linux2.6.7
kgdb内核补丁    Linux2.6.7-kgdb.2.2.tar.gz  Linux2.6.7-kgdb.2.2.tar.gz
串口线                        调制解调器电缆

kgdb补丁的版本遵循如下命名模式：Linux-A-kgdb-B，其中A表示Linux的内核版本号，B为kgdb的版本号。以试验使用的kgdb补丁为例，linux内核的版本为linux-2.6.7，补丁版本为kgdb-2.2。
物理连接好串口线后，使用以下命令来测试两台机器之间串口连接情况，stty命令可以对串口参数进行设置：
在development机上执行：
stty ispeed 115200 ospeed 115200 -F /dev/ttyS0
在target机上执行：
stty ispeed 115200 ospeed 115200 -F /dev/ttyS0
在developement机上执行：
echo hello > /dev/ttyS0
在target机上执行：
cat /dev/ttyS0
如果串口连接没问题的话在将在target机的屏幕上显示"hello"。


开发机（developement）
I、内核的配置与编译
[root@lisl tmp]# tar -jxvf linux-2.6.7.tar.bz2
[root@lisl tmp]#tar -jxvf linux-2.6.7-kgdb-2.2.tar.tar
[root@lisl tmp]#cd inux-2.6.7
请参照目录补丁包中文件README给出的说明，执行对应体系结构的补丁程序。由于试验在i386体系结构上完成，所以只需要安装一下
补丁：core-lite.patch、i386-lite.patch、8250.patch、eth.patch、core.patch、i386.patch。应用补丁文件时，请遵循kgdb软件
包内series文件所指定的顺序，否则可能会带来预想不到的问题。eth.patch文件是选择以太网口作为调试的连接端口时需要运用的
补丁。
应用补丁的命令如下所示：
[root@lisl tmp]#patch -p1 <../linux-2.6.7-kgdb-2.2/core-lite.patch
如果内核正确，那么应用补丁时应该不会出现任何问题（不会产生*.rej文件）。为Linux内核添加了补丁之后，需要进行内核的配置。内核的配置可以按照你的习惯选择配置Linux内核的任意一种方式。
[root@lisl tmp]#make menuconfig
在内核配置菜单的Kernel hacking选项中选择kgdb调试项，例如：
  [*] KGDB: kernel debugging with remote gdb
       Method for KGDB communication (KGDB: On generic serial port (8250))  --->  
  [*] KGDB: Thread analysis 
  [*] KGDB: Console messages through gdb
[root@lisl tmp]#make


内核编译完成后，使用scp命令进行将相关文件拷贝到target机上(当然也可以使用其它的网络工具，如rcp)。
[root@lisl tmp]#scp arch/i386/boot/bzImage root@192.168.6.13:/boot/vmlinuz-2.6.7-kgdb
[root@lisl tmp]#scp System.map root@192.168.6.13:/boot/System.map-2.6.7-kgdb
如果系统启动使所需要的某些设备驱动没有编译进内核的情况下，那么还需要执行如下操作：
[root@lisl tmp]#mkinitrd /boot/initrd-2.6.7-kgdb 2.6.7
[root@lisl tmp]#scp initrd-2.6.7-kgdb root@192.168.6.13:/boot/ initrd-2.6.7-kgdb


http://www.ibm.com/developerworks/cn/linux/l-kdb/index.html
}