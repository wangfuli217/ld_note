tty(设备)
{
物理设备：串口、USB到串口的转换器、还有需要特殊处理才能正常工作的调制解调器。
虚拟设备：虚拟控制台，它能通过键盘及网络连接或者通过xterm会话登录到计算机上。

用户程序  TTY核心<字符驱动> TTY线路规程 TTY驱动程序 硬件设备;

TTY线路规程对于tty驱动程序来说是不透明的。驱动程序不能直接与线路规程通信，甚至不知道它的存在。
从某种意义上讲：驱动程序的作用是将发送给它的数据格式化成硬件能理解的格式，并从硬件那里接收数据。

三种类型的tty驱动程序：控制台，串口和pty.
控制台和pty驱动程序已经被编写好了，而且可能也不必为这两类tty驱动程序编写其他的驱动程序。


1. 串行端口/TTY:
串行端口终端（Serial Port Terminal）是使用计算机串行端口连接的终端设备。计算机把每个串行端口都看作是一个字符设备。
有段时间这些串行端口设备通常被称为终端设备，因为那时它的最大用途就是用来连接终端。这些串行端口所对应的设备名称是
/dev/tts/0（或/dev/ttyS0),/dev/tts/1（或/dev/ttyS1）等，设备号分别是（4,0），（4,1）等，分别对应于DOS系统下的
COM1、COM2等。若要向一个端口发送数据，可以在命令行上把标准输出重定向到这些特殊文件名上即可。例如，在命令行提示符
下键入：echo test > /dev/ttyS1会把单词”test”发送到连接在ttyS1(COM2）端口的设备上。

2. 伪终端/TTY
伪终端(Pseudo Terminal）是成对的逻辑终端设备（即master和slave设备，对master的操作会反映到slave上）。
例如/dev/ptyp3和/dev/ttyp3（或者在设备文件系统中分别是/dev/pty /m3和 /dev/pty/s3）。它们与实际物理设备并不直接相关。
如果一个程序把ptyp3(master设备）看作是一个串行端口设备，则它对该端口的读/ 写操作会反映在该逻辑终端设备对应的另一个
ttyp3(slave设备）上面。而ttyp3则是另一个程序用于读写操作的逻辑设备。telnet主机A就是通过“伪终端”与主机A的登录程序
进行通信。

3. 控制终端/TTY 
如果当前进程有控制终端(Controlling Terminal）的话，那么/dev/tty就是当前进程的控制终端的设备特殊文件。可以使用命令
”ps –ax”来查看进程与哪个控制终端相连。对于你登录的shell，/dev/tty就是你使用的终端，设备号是（5,0）。使用命令”tty”
可以查看它具体对应哪个实际终端设备。/dev/tty有些类似于到实际所使用终端设备的一个联接。

4. 控制台/TTY 
在Linux 系统中，计算机显示器通常被称为控制台终端(Console）。它仿真了类型为Linux的一种终端(TERM=Linux），并且有
一些设备特殊文件与之相关联：tty0、tty1、tty2 等。当你在控制台上登录时，使用的是tty1。使用Alt+[F1—F6]组合键时，
我们就可以切换到tty2、tty3等上面去。tty1–tty6等称为虚拟终端，而tty0则是当前所使用虚拟终端的一个别名，系统所
产生的信息会发送到该终端上（这时也叫控制台终端）。因此不管当前正在使用哪个虚拟终端，系统信息都会发送到控制台终端上。
/dev/console即控制台，是与操作系统交互的设备，系统将一些信息直接输出到控制台上。只有在单用户模式下，
才允许用户登录控制台。

5. 虚拟终端/TTY 
在Xwindow模式下的伪终端.如在Kubuntu下用konsole，就是用的虚拟终端，用tty命令可看到/dev/pts/name， name为当前用户名。

6. 其他终端
Linux系统中还针对很多不同的字符设备存在有很多其它种类的终端设备特殊文件。例如针对ISDN设备的/dev/ttyIn终端设备等。
tty设备包括虚拟控制台，串口以及伪终端设备。
/dev/tty代表当前tty设备，在当前的终端中输入 echo “hello” > /dev/tty ，都会直接显示在当前的终端中。

}

tty_uart(uart设备是继tty_driver的又一层封装)
{
最开始的时候，老搞不清楚uart和tty的区别，以为uart驱动就是tty驱动。其实不是这样的，tty驱动程序是通用的一个tty设备程序框架，
tty设备包含uart设备。也就是说，tty设备的驱动框架可以用来驱动uart设备，但是在Linux程序中，uart设备的驱动程序被开发者单独
写出来了，不过uart的程序框架也是在tty基础上。

    uart设备是继tty_driver的又一层封装.实际上uart_driver就是对应tty_driver.在它的操作函数中,将操作转入uart_port.
在写操作的时候,先将数据放入一个叫做circ_buf的环形缓存区.然后uart_port从缓存区中取数据,将其写入到串口设备中.当
uart_port从serial设备接收到数据时,会将设备放入对应line discipline的缓存区中.这样.用户在编写串口驱动的时候,只先
要注册一个uart_driver.它的主要作用是定义设备节点号.然后将对设备的各项操作封装在uart_port.
驱动工程师没必要关心上层的流程,只需按硬件规范将uart_port中的接口函数完成就可以了.
}
tty(/proc/tty/drivers)
{
/dev/tty             /dev/tty        5       0 system:/dev/tty
/dev/console         /dev/console    5       1 system:console
/dev/ptmx            /dev/ptmx       5       2 system
/dev/vc/0            /dev/vc/0       4       0 system:vtmaster
serial               /dev/ttyS       4 64-95 serial
pty_slave            /dev/pts      136 0-1048575 pty:slave
pty_master           /dev/ptm      128 0-1048575 pty:master
unknown              /dev/tty        4 1-63 console

驱动程序的名称   
默认的节点名称 
驱动程序的主设备号 
驱动程序所使用的次设备号范围 
tty驱动程序的类型
}
tty(/proc/tty/driver)
{
如果tty驱动程序执行了所包含的功能，则/proc/tty/driver/目录下包含了若干独立文件为tty驱动程序所使用。
默认的串口驱动在该目录下创建一个文件，显示了许多关于串口硬件的特殊信息。
}

tty(/sys/class/tty)
{
    当前注册并存在于内核的tty设备在/sys/class/tty下都有自己的子目录。在这些子目录中，有一个"dev"文件包含了
分配给该tty的主设备号和次设备号。
}
tty_driver()
{
任何tty驱动程序的主要数据结构是结构tty_driver.他被用来向tty核心注册和注销驱动程序。
struct tty_driver *alloc_tty_driver(int lines)
void tty_set_operations(struct tty_driver *driver, const struct tty_operations *op)
int tty_register_driver(struct tty_driver *driver)

struct device *tty_register_device(struct tty_driver *driver, unsigned index, struct device *device)

driver_name: 在内核所有的tty驱动程序中，driver_name变量被设置成简短、描述性的、唯一的值。 
             在/proc/tty/drivers文件中要向用户描述驱动的情况。
             
name:在/dev目录中，定义分配给单独tty节点的名字。通过在该名字末尾添加tty设备序号来创建tty设备.
     在/sys/class/tty目录中创建设备名。

     type和subtype变量声明该驱动程序是什么类型的tty驱动程序。
type:    常规类型的串口驱动程序。
subtype: 呼出类型，呼出设备传统上被用来控制设备的线路规程设置。

呼出设备：数据的发送或者接收都通过某个设备节点进行，而任何对线路设置的改变将被发往不同的设备节点，这就是呼出设备。
幸运的是，几乎所有驱动设备都在同一个设备节点上处理数据和线路设置，在新的驱动程序中，呼出类型已经很少使用了。

flags:tty驱动程序和tty核心都是用flags变量标明当前驱动程序的状态以及该tty驱动程序的类型。
TTY_DRIVER_RESET_TERMIOS：
TTY_DRIVER_REAL_RAW：
TTY_DRIVER_DEVPTS_MEM：

open
close
}

termios()
{
在结构tty_driver中的init_termios变量是一个termios结构。
tc_flag_t c_iflag;  输入模式标志
tc_flag_t c_oflag;  输出模式标志
tc_flag_t c_cflag;  控制模式标志
tc_flag_t c_lflag;  本地模式标志
cc_t c_line;        线路规程类型
cc_t c_cc[NCCS];    控制字符数组
}

termios(include/linux/tty.h)
{
内核提供了一套有用的宏来获得不同位的值。
}

