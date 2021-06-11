uml(2.6.16)
{
.config
http://uml.devloop.org.uk/kernels.html
UML执行：
首先需要一个根文件系统，从这个网址：http://fs.devloop.org.uk/下载即可：

ext: http://blog.csdn.net/larryliuqing/article/details/8178958           启动和编译
ext: http://blog.csdn.net/ztz0223/article/details/7874759                启动和编译
ext: http://www.360doc.com/content/14/1106/10/19184777_423005335.shtml   管理
make mrproper ARCH=um
make defconfig ARCH=um
make menuconfig ARCH=um
make ARCH=um [linux]   # make ARCH -B V=1

dd if=/dev/zero of=root_fs seek=100 count=1 bs=1M
mkfs.ext2 ./root_fs
mkdir /mnt/rootfs
mount -o loop root_fs /mnt/rootfs/

./linux ubd0_fs
./kernel ubda=root_fs mem=128M

$ dd if=/dev/zero of=swap bs=1M count=128
$ ./kernel ubda= root_fs ubdb=swap mem=128M

serial line 0 assigned pty /dev/ptyp1
粘贴用户喜爱的终端程序到相应的tty，如：minicom，方法如下：
host% minicom -o -p /dev/ttyp1

arch/um/os-Linux/mem.c: In function ‘create_tmp_file’:
arch/um/os-Linux/mem.c:216: error: implicit declaration of function ‘fchmod’
make[1]: *** [arch/um/os-Linux/mem.o] Error 1
make: *** [arch/um/os-Linux] Error 2

编辑文件arch/um/os-Linux/mem.c，加入头文件#include 即可。
}

uml(tool)
{
使用UML和管理UML的工具说明如下：
UMLd – 用于创建UML实例、管理实例启动/关闭的后台程序。
umlmgr –用于管理正运行的UML实例的前台工具程序。
UML Builder – 编译根文件系统映像（用于UML模式操作系统安装）。
uml switch2 用于后台传输的用户空间虚拟切换。
VNUML – 基于XML的语言，定义和启动基于UML的虚拟网络场景。
UMLazi – 配置和运行基于虚拟机的UML的管理工具。
vmon – 运行和监管多个UML虚拟机的轻量级工具，用Python 书写。
umvs – umvs是用C++和Bash脚本写的工具，用于管理UML实例。该应用程序的目的是简化UML的配置和管理。它使用了模板，使得编写不同的UML配置更容易。
MLN - MLN (My Linux Network) 是一个perl程序，用于从配置文件创建UML系统的完整网络，使得虚拟网络的配置和管理更容易。MLN基于它的描述和简单的编程语言编译和配置文件系统模板，并用一种组织方式存储它们。它还产生每个虚拟主机的启动和停止脚本，在一个网络内启动和停止单个虚拟机。MLN可以一次使用几个独立的网络、项目，甚至还可以将它们连接在一起。
Marionnet – 一个完全的虚拟网络实验，基于UML，带有用户友好的图形界面。
}

dir()
{
   套接字：
1. 一般协议族 net/socket.c net/protocols.c
   INET协议族 net/ipv4/core/sock.c net/ipv4/af_inet.c net/ipv4/protocol.c
   网络内核最顶层是支持应用程序开发的函数接口，这是一系列标准函数，即套接字接口。套接字支持多种不同类型的协议族。
UNIX域协议族、TCP/IP协议族、IPX协议族等。
   套接字又包括3个基本类型：SOCK_STREAM SOCK_DGRAM SOCK_RAW。通过SOCK_STREAM套接字可以访问TCP协议，通过SOCK_DGRAM
套接字可以访问UDP协议，通过SOCK_RAW套接字可以直接访问IP协议。

   传输层
2. UDP /net/ipv4/udp.c net/ipv4/datagram.c
   TCP net/ipv4/tcp_input.c net/ipv4/tcp_output.c net/ipv4/tcp.c
   
   网络层
3. IPv4 net/ipv4/ip_input.c net/ipv4/ip_output.c net/ipv4/forward.c

  数据链路层
4. drivers/net/ppp_generic.c drivers/net/pppoe.c

   网络设备驱动
5. driver/net   

include/linux/skbuff.h 套接字缓冲区类型
net/core/dev.c         dev_queue_xmit
}

family()
{
PF_UNIX
PF_INET
PF_IPX
PF_PACKET:套接字直接访问网络设备
PF_NETLINK：内核与用户态程序之间交换数据
}

.config()
{
下面两者一样
/lib/modules/2.6.32-279.el6.x86_64/build/.config
/boot/config-2.6.32-279.el6.x86_64



}

kallsyms(在内核中通过/proc/kallsyms获得符号的地址)
{
关注文件
---------------------------------------------------------------------------
/usr/src/kernels/2.6.32-279.el6.x86_64/scripts/kallsyms
/proc/kallsyms

    符号属性
若符号在内核中是全局性的，则属性为大写字母，如T、U等。
A(Absolute):符号的值是绝对值，并且在进一步链接过程中不会被改变
b(BSS):符号在未初始化数据区（BSS）
c(Common):普通符号，是未初始化区域
d(Data):符号在初始化数据区
g(Global):符号针对小object，在初始化数据区
i(Inderect):非直接引用其他符号的符号
n(Debugging):调试符号
r(Read only):符号在只读数据区
s(Small):符号针对小object，在未初始化数据区
t(Text):符号在代码段
u:符号未定义

Linux内核符号表/proc/kallsyms的形成过程
---------------------------------------------------------------------------
./scripts/kallsyms.c负责生成System.map          用户态解析函数   kallsyms命令
./scripts/kallsyms.c解析vmlinux(.tmp_vmlinux)生成kallsyms.S(.tmp_kallsyms.S)，然后内核编译过程中将kallsyms.S
(内核符号表)编入内核镜像uImage

./kernel/kallsyms.c负责生成/proc/kallsyms       内核态解析函数
内核启动后./kernel/kallsyms.c解析uImage形成/proc/kallsyms

/proc/kallsyms包含了内核中的函数符号(包括没有EXPORT_SYMBOL)、全局变量(用EXPORT_SYMBOL导出的全局变量)


CONFIG_KALLSYMS
---------------------------------------------------------------------------
在2.6内核中，为了更好地调试内核，引入了kallsyms。kallsyms抽取了内核用到的所有函数地址(全局的、静态的)和非栈数据
变量地址，生成一个数据块，作为只读数据链接进kernel image，相当于内核中存了一个System.map。需要配置CONFIG_KALLSYMS

.config
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y 符号表中包括所有的变量(包括没有用EXPORT_SYMBOL导出的变量)
CONFIG_KALLSYMS_EXTRA_PASS=y

make menuconfig
General setup  --->  
    [*] Configure standard kernel features (for small systems)  --->
        [*]   Load all symbols for debugging/ksymoops
        [*]     Include all symbols in kallsyms
        [*]     Do an extra kallsyms pass  

注: 配置CONFIG_KALLSYMS_ALL之后，就不需要修改all_symbol静态变量为1了


arch/arm/kernel/vmlinux.lds.S
---------------------------------------------------------------------------
                   |--------------------|
                   |                    |
                   |                    |
                   ~                    ~
                   |                    |
                   |                    |
0xc05d 1dc0        |--------------------| _end
                   |                    |
                   |                    |
                   |    BSS             |
                   |                    |
                   |                    |
0xc05a 4500        |--------------------| __bss_start
                   |                    |
0xc05a 44e8        |--------------------| _edata
                   |                    |
                   |                    |
                   |    DATA            |
                   |                    |
                   |                    |
0xc058 2000        |--------------------| __data_start  init_thread_union
                   |                    |
0xc058 1000 _etext |--------------------|
                   |                    |
                   | rodata             |
                   |                    |
0xc056 d000        |--------------------| __start_rodata
                   |                    |
                   |                    |
                   | Real text          |
                   |                    |
                   |                    |
0xc02a 6000   TEXT |--------------------| _text        __init_end    
                   |                    |
                   | Exit code and data | DISCARD 这个section在内核完成初始化后
                   |                    |         会被释放掉
0xc002 30d4        |--------------------| _einittext
                   |                    |
                   | Init code and data |
                   |                    |
0xc000 8000 _stext |--------------------|<------------ __init_begin
                   |                    |
0xc000 0000        |--------------------|

}