http://www.cnblogs.com/lovemo1314/archive/2010/10/29/1864327.html
https://blog.csdn.net/todd911/article/details/20794923  《UNIX环境高级编程》笔记
http://www.cnblogs.com/dartagnan/archive/2013/04/25/3042417.html

全双工--计算机可以同时收发数据,它有两个独立的数据通道，一个输入，一个输出，
半双工意味着计算机不能同时收发信息,只能有一个通道进行通信.

hardware(UART与COM){
嵌入式里面说的串口，一般是指UART口, 但是我们经常搞不清楚它和COM口的区别, 以及RS232,TTL等关系,  
# UART,COM指物理接口形式(硬件物理结构), TTL、RS-232指电平标准(电信号).
# UART是TTL电平的串口；COM是RS232电平的串口
1. UART有4个pin(VCC, GND, RX, TX), 用的TTL电平：逻辑1为 2.6-5V；逻辑0为0-0.4V
2. COM口9个pin，用的RS232电平, 它是负逻辑电平，在TxD和RxD上：逻辑1(MARK)=-3V～-15V；逻辑0(SPACE)=+3～+15V
在RTS、CTS、DSR、DTR和DCD控制线上：信号有效(接通，ON状态，正电压)=+3V～+15V；信号无效(断开，OFF状态，负电压)=-3V～-15V 
对于数据(信息码)：逻辑"1"(传号)的电平低于-3V，逻辑"0"(空号)的电平高于+3V；
对于控制信号；接通状态(ON)即信号有效的电平高于+3V，断开状态(OFF)即信号无效的电平低于-3V，
  1. 也就是当传输电平的绝对值大于3V时，电路可以有效地检查出来，
  2. 介于-3～+3V之间的电压无意义，
  3. 低于-15V或高于+15V的电压也认为无意义，
  实际工作时，应保证电平在±(3～15)V之间
  
1 DCD 载波检测          2 RXD 接收数据      3 TXD 发送数据
4 DTR 数据终端准备好    5 SGND信号地线      6 DSR 数据准备好
7 RTS 请求发送          8 CTS 清除发送      9 RI 振铃提示
  
UART的特征
  一般UART控制器在嵌入式系统里面都做在cpu一起，像飞思卡尔的IMX6芯片就是这样，有多个UART控制器。
引脚介绍(COM口比较多pin，但是常用的也是这几个)：
VCC：供电pin，一般是3.3v，在我们的板子上没有过电保护，这个pin一般不接更安全
GND：接地pin，有的时候rx接受数据有问题，就要接上这个pin，一般也可不接
RX：接收数据pin。
TX：发送数据pin，
    在调试的时候, 多数情况下我们只引出RX,TX即可. 
使用方法：
  我们常用UART口进行调试，但是UART的数据要传到电脑上分析就要匹配电脑的接口，通常我们电脑使用接口有COM口和USB口
  
UART是通用异步收发器(异步串行通信口)的英文缩写，它包括了RS232、RS499、RS423、RS422和RS485等接口标准规范
      和总线标准规范，即UART是异步串行通信口的总称。
  
总结
1、UART,COM指物理接口形式(硬件物理结构), TTL、RS-232指电平标准(电信号). 
2、接设备的时候，一般只接GND RX TX。不会接VCC或者+3.3v的电源线，避免与目标设备上的供电冲突。 
3、PL2303、CP2102芯片是 USB 转 TTL串口 的芯片，用USB来扩展串口(TTL电平)
4、MAX232芯片是 TTL电平与RS232电平的专用双向转换芯片，可以TTL转RS-232，也可以RS-232转TTL。 
5、TTL标准是低电平为0，高电平为1（+5V电平）。RS-232标准是正电平为0，负电平为1（±15V电平）。 
6、RS-485与RS-232类似，但是采用差分信号负逻辑。这里略过不讲。

串口进行通信的方式有两种：同步通信方式和异步通信方式
SPI(Serial Peripheral Interface：串行外设接口);
I2C(INTER IC BUS：意为IC之间总线)，一（host）对多，以字节为单位发送。
UART(Universal Asynchronous Receiver Transmitter：通用异步收发器) 一对一，以位为单位发送。

每次传送一个字节，顺序：起始电平->数据位->校验位->停止位
  起始电平1个Bit;
  数据位一般7或8个bit
  校验位1 个或者无
  停止位1，2个bit ;
}
uart(基本参数){
波特率：即每秒传输的位数(bit)。一般选波特率都会有9600,19200,115200等选项。其实意思就是每秒传输这么多个比特位数(bit)。
起始位: 先发出一个逻辑"0"的信号，表示传输数据的开始。
数据位: 可以选择的值有5,6,7,8这四个值，可以传输这么多个值为0或者1的bit位。
        这个参数最好为8，因为如果此值为其他的值时当你传输的是ASCII值时一般解析肯定会出问题。
        理由很简单，一个ASCII字符值为8位，如果一帧的数据位为7，那么还有一位就是不确定的值，这样就会出错。
校验位：数据位加上这一位后，使得"1"的位数应为偶数(偶校验)或奇数(奇校验)，以此来校验数据传送的正确性。就比如传输"A"(01000001)为例。
         1、当为奇数校验："1"字符的8个bit位中有两个1,那么奇偶校验位为1才能满足1的个数为奇数(奇校验)。
         2、当为偶数校验："1"字符的8个bit位中有两个1,那么奇偶校验位为0才能满足1的个数为偶数(偶校验)。
         此位还可以去除，即不需要奇偶校验位。
停止位：它是一帧数据的结束标志。可以是1bit、1.5bit、2bit的空闲电平。
        可能大家会觉得很奇怪，怎么会有1.5位~没错，确实有的。所以我在生产此uart信号时用两个波形点来表示一个bit。
        这个可以不必深究。。。
空闲位：没有数据传输时线路上的电平状态。为逻辑1。
传输方向：即数据是从高位(MSB)开始传输还是从低位(LSB)开始传输。比如传输"A"如果是MSB那么就是01000001，
          如果是LSB那么就是10000010
uart传输数据的顺序就是：刚开始传输一个起始位，接着传输数据位，接着传输校验位(可不需要此位)，最后传输停止位。
                        这样一帧的数据就传输完了。接下来接着像这样一直传送。在这里还要说一个参数。
帧间隔:即传送数据的帧与帧之间的间隔大小，可以以位为计量也可以用时间(知道波特率那么位数和时间可以换算)。
       比如传送"A"完后，这为一帧数据，再传"B"，那么A与B之间的间隔即为帧间隔
}
    大多数UNIX系统在一个称为终端行规程（terminal line discipline）的模块中进行规范处理。
它位于内核通用读、写函数和实际设备驱动程序之间的模块。
            用户进程
   | ----------------------  | ------
   | +---------------------+ |
   | |     读、写函数      | |
   | +---------------------+ |
   |         |    |          |
   | +---------------------+ |
   | |      终端行规程     | | 内核
   | +---------------------+ |
   |         |     |         |
   | +---------------------+ |
   | |   终端设备驱动程序  | |
   | +---------------------+ |
   |  ---------------------- | ------
             实际设备

mode(规范模式,非规范模式,原始模式){
  1. 终端有三种工作模式：规范模式、非规范模式、原始模式
  2. 在termios结构的c_lflag中设置ICANNON标志来定义终端以何种模式工作，默认为规范模式。
     启用规范模式 (canonical mode)。允许使用特殊字符 EOF, EOL, EOL2, ERASE, KILL, LNEXT, REPRINT, STATUS, 和 WERASE，以及按行的缓冲。
     2.1 行如何被分割：NL,  EOL,  EOL2; or EOF。除EOF字符，其他分隔符被包含在读取缓冲区中
     2.2 行可以被编辑：ERASE, KILL，(IEXTEN flag is set:) WERASE,  REPRINT,  LNEXT
  3. 规范模式：所有输入基于行进行处理。在用户输入一个行结束符(回车符、EOF等)之前，系统调用read()函数读不到用户输入的任何字符。
               其次，除了EOF之外的行结束符与普通字符一样会被read()函数读取到缓冲区中。一次调用read()只能读取一行数据。
  4. 非规范模式：所有输入时即时有效的，不需要用户另外输入行结束符。
              MIN (c_cc[VMIN]) 和 TIME (c_cc[VTIME]) 决定read()读返回。
  5. 原始模式：是一种特殊的非规范模式，所有的输入数据以字节为单位被处理。即有一个字节输入时，触发输入有效。
  6. 通过调用cfmakeraw()函数可以将终端设置为原始模式。
     cfmakeraw(&tlocal);   # 设置终端属性为原始数据方式
  对于具体一次传输多少字节也不去追究了，总之通讯过程中无法保证一次发送的数据肯定是一次接收的，所以必须写代码 
来一次一次的接收，直到接收满足预定的为止，当然在此过程中得使用select/poll来避免超时接收。
}
mode(模式:规范模式){
规范模式很简单：发一个读请求，输入完一行后，终端驱动程序即返回。(终端的行缓冲应该就是通过终端IO函数来实现的)
                (终端输入以行为单位进行处理。对于每个读要求，终端驱动程序最多返回一行)
下列几个条件都会造成读返回。
1.所要求的字节数已读到时，读返回。无需读一个完整的行。如果读了部分行，那么也不会丢失任何信息，下一次读从前一次
  读的停止处开始。
2.但读到一个定界符时，读返回。在规范模式中下列字符为解释成行结束：NL、EOL、EOL2和EOF。另外，如若已设置ICRNL，
  但未设置IGNCR，则CR字符的作用于NL字符一样，所以它也终止一行。在这5个行定界符中，其中只有一个EOF字符在终端
  驱动程序对其进行处理后即被删除。其他四个字符则作为该行的最后一个字符返回给调用者。
3.如果捕捉到信号而且该函数并不自动重启动，则读也返回。
}
mode(模式:非规范模式){
   (输入字符不以行为单位进行装配)
  关闭termios结构中的c_flag字段的ICANNON标志就能使终端处于非规范模式。在非规范模式中，输入数据并不组成行，不处理
下列特殊字符：ERASE，KILL，EOF，NL，EOL，EOL2，CR，REPRINT，STATUS和WERASE。
  在规范模式很简答：系统每次返回一行。但在非规范模式下，系统怎么才能知道在什么时候将数据返回给我们呢？如果它一次返回
一个字节，那么系统开销就很大。在启动读数据之前，往往不知道要读多少数据，所以系统不能总是一次返回多个字节。
}
mode(非规范模式:MIN|TIME){
解决方法：当已读了指定量的数据后（猜测用于实现终端的全缓冲），或者已经过了给定的时间后，即通知系统返回。这种技术
使用了termios结构中c_cc数组的两个变量MIN和TIME。c_cc数组中的这两个元素的下表VMIN和VTIME。
MIN说明一个read返回前的最小字节数。TIME说明等待数据到达的分秒数。(秒的1/10为分秒)。有下列四种情形。
情形A：MIN>0，TIME>0
  1. TIME说明字节间的计时器，在直到第一个字节时才启动它。在该计时器超时之前，若已接到MIN个字节，则read返回MIN个字节。
  2. 如果在直到MIN个字节之前，该计时器已超时，则read返回已接收到的字节。(因为只有在接到第一个字节时才启动，所以在计时器超时时，至少返回了1个字节)。
  在这种情形中，在接到第一个字节之前，调用者阻塞。如果在调用read时数据已经可用，则这如同在read后数据立即被接收到一样。
情形B：MIN>0，TIME == 0
  1. 已经接收到MIN个字节时，read才返回。这可以造成read无期限地阻塞
情形C：MIN == 0，TIME > 0
  1. TIME指定了一个调用read时启动的读计时器。在接收到一个字节或者该计时器超时时，read即返回。
  2. 如果是计时器超时，则read返回0.
情形D：MIN==0，TIME == 0
  1. 如果有数据可用，则read最多返回所要求的字节数。
  2. 如果无数据可用，则read立即返回0。
|-----------|---------------------------------------------|-----------------------------------------|
|           |       MIN >  0                              |     MIN == 0                            |
|-----------|---------------------------------------------|-----------------------------------------|
|TIME > 0   | A. 在计时器超时前，read返回[MIN,nbytes];    |   C. 在计时器超时前，read返回[1,nbytes];|
|           |    若计时器超时，read返回[1, MIN)           |      若计时器超时，read返回0，          |
|           |    (TIME=字节间计时器，调用者可能无限阻塞)  |      (TIME=read计时器)                  |
|TIME == 0  | B. 可用时，read返回[MIN,nbytes];            |   D. read立即返回[0,nbytes];            |
|           |    (调用者可能无限阻塞)                     |                                         |
|-----------|---------------------------------------------|-----------------------------------------|
}
mode(模式:cbreak模式){
V7和BSD类的终端驱动程序支持三种终端输入方式：
规范模式          精细加工方式(输入装配成行，并对特殊字符进行处理)；
非规范模式        原始方式(输入不装配成行，也不对特殊字符进行处理)；
cbreak模式        cbreak方式(输入不装配成行，但对某些特殊字符进行处理)。

对cbreak方式的定义是：
    非规范方式。这种方式不对某些输入特殊字符进行处理。这种方式仍对信号进行处理，所以用户可以键入任一终端产生的信号。调用者应当捕捉这些信号，否则这种信号就可能终止程序，并且终端将仍处于cbreak方式。作为一般规则，在编写更改终端方式的程序时，应当捕捉大多数信号，以便在程序终止前恢复终端方式；
    关闭回送(ECHO)标志；
    每次输入一个字节。为此将MIN设置为1，将TIME设置为0。至少有一个字节可用时，read再返回。

对原始方式的定义是：
    非规范方式。另外，还关闭了对信号产生字符(ISIG)和扩充输入字符的处理(IEXTEN)。关闭BRKINT，这样就使BREAK字符不再产生信号；
    关闭回送(ECHO)标志；
    关闭ICRNL、INPCK、ISTRIP和IXON标志。于是：不再将输入的CR字符变换为NL(ICRNL)、使输入奇偶校验不起作用(INPCK)、不再剥离输入字节的第8位(ISTRIP)、不进行输出流控制(IXON)；
    8位字符(CS8)，不产生奇偶位，不进行奇偶性检测(PARENB)；
    禁止所有输出处理(OPOST)；
    每次输入一个字节(MIN = 1，TIME = 0)。
    
# 详情查看curses库中的cbreak()和 raw()函数。
}

mode(模式:直接模式){
  一般地串口的读写模式有直接模式和缓存模式，
  在直接模式下，串口的读写都是单字节的，也就是说一次的read或write只能操作一个字节；
}
mode(模式:缓存模式){
  但是大部份串口芯片都支持缓存模式，
  缓存模式一般同时支持中断聚合和超时机制，也就是说在有数据时，当缓存满或者超时时间到时，都会触发读或写中断。
写的时候可以将要操作的数据先搬到缓存里，然后启动写操作，芯片会自动将一连串的数据写出，在读的时候类似，一次读到的是串口芯片缓存里的数据。
串口设备的缓存一般有限，一次能read到的最大字节数就是缓存的容量。所以串口芯片的缓存容量决定了你一次能收到的字节数。
本人用一个usb转232来充当串口接收时，发现一次可以接收8个bytes。
}

uart(头文件){

#include     <stdio.h>      /*标准输入输出定义*/
#include     <stdlib.h>     /*标准函数库定义*/
#include     <unistd.h>     /*Unix 标准函数定义*/
#include     <sys/types.h> 
#include     <sys/stat.h>  
#include     <fcntl.h>      /*文件控制定义*/
#include     <termios.h>    /*POSIX 终端控制定义*/
#include     <errno.h>      /*错误号定义*/
#include   <string.h>       /*字符串功能函数*/
}
uart(打开串口){
打开串口设备文件的操作与普通文件的操作类似，都采用标准的I/O操作函数open()。
       fd = open("/dev/ttyS0",O_RDWR|O_NDELAY|O_NOCTTY);
    open()函数有两个参数，
    第一个参数是要打开的文件名（此处为串口设备文件/dev/ttyS0，有时设备名称为/dev/ttyPCS0);
    第二个参数设置打开的方式，O_RDWR表示打开的文件可读/写，O_NDELAY表示以非阻塞方式打开，O_NOCTTY表示若打开的文件为终端设备，则不会将终端作为进程控制终端。

函数说明    参数pathname 指向欲打开的文件路径字符串。下列是参数flags 所能使用的旗标:
O_RDONLY    以只读方式打开文件
O_WRONLY    以只写方式打开文件
O_RDWR      以可读写方式打开文件。上述三种旗标是互斥的，也就是不可同时使用，但可与下列的旗标利用OR(|)运算符组合。
O_CREAT     若欲打开的文件不存在则自动建立该文件。
O_EXCL      如果O_CREAT也被设置，此指令会去检查文件是否存在。文件若不存在则建立该文件，否则将导致打开文件错误。此外，若O_CREAT与O_EXCL同时设置，并且欲打开的文件为符号连接，则会打开文件失败。
O_NOCTTY    如果欲打开的文件为终端机设备时，则不会将该终端机当成进程控制终端机。
O_TRUNC     若文件存在并且以可写的方式打开时，此旗标会令文件长度清为0，而原来存于该文件的资料也会消失。
O_APPEND    当读写文件时会从文件尾开始移动，也就是所写入的数据会以附加的方式加入到文件后面。
O_NONBLOCK  以不可阻断的方式打开文件，也就是无论有无数据读取或等待，都会立即返回进程之中。
O_NDELAY    同O_NONBLOCK。
O_SYNC      以同步的方式打开文件。
O_NOFOLLOW  如果参数pathname 所指的文件为一符号连接，则会令打开文件失败。
O_DIRECTORY 如果参数pathname 所指的文件并非为一目录，则会令打开文件失败。

除了使用O_RDWR标志之外，通常还会使用O_NOCTTY和O_NDELAY这两个标志。
O_NOCTTY：告诉Unix这个程序不想成为"控制终端"控制的程序，不说明这个标志的话，任何输入都会影响你的程序。
O_NDELAY：告诉Unix这个程序不关心DCD信号线状态，即其他端口是否运行，不说明这个标志的话，该程序就会在DCD信号线为低电平时停止。
}

uart(termios){
termios 函数族提供了一个常规的终端接口，用于控制非同步通信端口。
struct termios
{
   tcflag_t  c_iflag;   # 输入模式标志
   tcflag_t  c_oflag;   # 输出模式标志
   tcflag_t  c_cflag;   # 控制模式标志
   tcflag_t  c_lflag;   # 本地模式标志
   cc_t   c_line;       # 线控制 
   cc_t   c_cc[NCC];    #  控制字符
}

}

uart(设置数据位、停止位和校验位){
4.设置数据位、停止位和校验位
以下是几个数据位、停止位和校验位的设置方法：（以下均为1位停止位）

8 位数据位、无校验位：
opt.c_cflag &= ~PARENB;
opt.c_cflag &= ~CSTOPB;
opt.c_cflag &= ~CSIZE;
opt.c_cflag |= CS8;

7 位数据位、奇校验：
Opt.c_cflag |= PARENB;
Opt.c_cflag |= PARODD;
Opt.c_cflag &= ~CSTOPB;
Opt.c_cflag &= ~CSIZE;
Opt.c_cflag |= CS7;

7 位数据位、偶校验：
Opt.c_cflag |= PARENB;
Opt.c_cflag &= ~PARODD;
Opt.c_cflag &= ~CSTOPB;
Opt.c_cflag &= ~CSIZE;
Opt.c_cflag |= CS7;

7 位数据位、Space校验：
Opt.c_cflag &= ~PARENB;
Opt.c_cflag &= ~CSTOPB;
Opt.c_cflag &= ~CSIZE;
Opt.c_cflag |= CS7;
}

uart(校验){
1. 无校验 （no parity）
    options.c_cflag &= ~PARENB
    options.c_cflag &= ~CSTOPB
    options.c_cflag &= ~CSIZE;
    options.c_cflag |= CS8;
2. 奇校验 （odd parity）：如果字符数据位中"1"的数目是偶数，校验位为"1"，如果"1"的数目是奇数，校验位应为"0"。（校验位调整个数）
    options.c_cflag |= PARENB
    options.c_cflag |= PARODD
    options.c_cflag &= ~CSTOPB
    options.c_cflag &= ~CSIZE;
    options.c_cflag |= CS7;
3. 偶校验 （even parity）：如果字符数据位中"1"的数目是偶数，则校验位应为"0"，如果是奇数则为"1"。（校验位调整个数）
    options.c_cflag |= PARENB
    options.c_cflag &= ~PARODD
    options.c_cflag &= ~CSTOPB
    options.c_cflag &= ~CSIZE;
    options.c_cflag |= CS7; 
4. mark parity：校验位始终为1  # options.c_cflag |= PARENB | CS8 | CMSPAR |PARODD;

5. space parity：校验位始终为0 # options.c_cflag |= PARENB | CS8 | CMSPAR;
    options.c_cflag &= ~PARENB
    options.c_cflag &= ~CSTOPB
    options.c_cflag &= ~CSIZE;
    options.c_cflag |= CS8;
    
#define CMSPAR 010000000000
}
uart(奇偶校验){
奇偶校验:在数据传输前附加一位奇校验位
        用来表示传输的数据中"1"的个数是奇数还是偶数，为奇数时，校验位置为"0"，否则置为"1"，用以保持数据的奇偶性不变。
        每个设备必须决定是否它将被用为偶校验，奇校验
        
奇校验：就是让原有数据序列中（包括你要加上的一位）1的个数为奇数
1000110（0）你必须添0这样原来有3个1已经是奇数了所以你添上0之后1的个数还是奇数个。
偶校验：就是让原有数据序列中（包括你要加上的一位）1的个数为偶数
1000110（1）你就必须加1了这样原来有3个1要想1的个数为偶数就只能添1了。
}
uart(或非校验){
发送设备添加1s在每个它发送的每条串上或决定这个数是偶数或奇数。然后，它添加一个额外的位，叫做校验位，到这个串上。如果偶校验在使用，
校验位将这些位置为偶数；如果奇校验在使用，校验位将这些位置为奇数。
}
uart(某些设置项){
在第四步中我们看到一些比较特殊的设置，下面简述一下他们的作用。
c_cc数组的VSTART和VSTOP元素被设定成DC1和DC3，代表ASCII标准的XON和XOFF字符，如果在传输这两个字符的时候就传不过去，需要把软件流控制屏蔽，即：
opt.c_iflag &= ~ (IXON | IXOFF | IXANY);
有时候，在用write发送数据时没有键入回车，信息就发送不出去，这主要是因为我们在输入输出时是按照规范模式接收到回车或换行才发送，而更多情况下我们是不必键入回车或换行的。此时应转换到行方式输入，不经处理直接发送，设置如下：
opt.c_lflag &= ~ (ICANON | ECHO | ECHOE | ISIG);
还存在这样的情况：发送字符0X0d的时候，往往接收端得到的字符是0X0a，原因是因为在串口设置中c_iflag和c_oflag中存在从NL-CR和CR-NL的映射，即串口能把回车和换行当成同一个字符，可以进行如下设置屏蔽之：
opt.c_iflag &= ~ (INLCR | ICRNL | IGNCR);
opt.c_oflag &= ~(ONLCR | OCRNL);
}

uart(屏蔽位){
所有列出的选择标志(除屏蔽标志外)都用一或多位表示，而屏蔽标志则定义多位。
屏蔽标志有一个定义名，每个值也有一个名字。
例如，为了设置字符长度，首先用字符长度屏蔽标志CSIZE将表示字符长度的位清0，然后设置下列值之一：CS5、CS6、CS7或CS8。
由SVR4支持的6个延迟值也有屏蔽标志：BSDLY、CRDLY、FFDLY、NLDLY、TABDLY和VTDLY。
}
uart(c_cflag){  控制标志影响到RS-232串行线
c_cflag用于设置控制参数，除了波特率外还包含以下内容：
EXTA EXTB: Unix V7 以及很多后来的系统有一个波特率的列表，在十四个值 B0, ..., B9600 之后可以看到两个常数 EXTA, EXTB
           很多系统将这个列表扩展为更高的波特率。(外部时钟率)
CBAUD    (不属于 POSIX) 波特率掩码 (4+1 位)。(波特率的位掩码)
CBAUDEX  (不属于 POSIX) 扩展的波特率掩码 (1 位)，包含在 CBAUD 中。
         (POSIX 规定波特率存储在 termios 结构中，并未精确指定它的位置，而是提供了函数 cfgetispeed() 和 cfsetispeed() 来存取它。一些系统使用 c_cflag 中 CBAUD 选择的位，其他系统使用单独的变量，例如 sg_ispeed 和 sg_ospeed 。)
CSIZE    字符长度掩码。取值为 CS5, CS6, CS7, 或 CS8。(数据位的位掩码)
    CS5 5个数据位
    CS6 6个数据位
    CS7 7个数据位
    CS8 8个数据位
CSTOPB  设置两个停止位，而不是一个。(2个停止位 -- 不设置则是一个)
CREAD   接收使能。 启用接收装置
PARENB  允许输出产生奇偶信息以及输入的奇偶校验(进行奇偶校)。 # 允许校验位
PARODD  输入和输出是奇校验(奇校，否则为偶校)  # 使用奇校验（清除该标志表示使用偶校验）
HUPCL   在最后一个进程关闭设备后，降低 modem 控制线 (挂断)。(最后关闭时挂线(放弃DTR))
CLOCAL  忽略 modem 控制线(忽略解制解调器状态行)。
LOBLK   (不属于 POSIX) 从非当前 shell 层阻塞输出(用于 shl )。(?)
CIBAUD  (不属于 POSIX) 输入速度的掩码。CIBAUD 各位的值与 CBAUD 各位相同，左移了 IBSHIFT 位。
CRTSCTS (不属于 POSIX) 启用 RTS/CTS (硬件) 流控制。

c_cflag标志可以定义CLOCAL和CREAD，这将确保该程序不被其他端口控制和信号干扰，同时串口驱动将读取进入的数据。CLOCAL和CREAD通常总是被是能的。
}

uart(c_lflag){   本地标志影响驱动程序和用户之间的接口
c_lflag用于设置本地模式，决定串口驱动如何处理输入字符，设置内容如下：
ISIG    当接受到字符 INTR, QUIT, SUSP, 或 DSUSP 时，产生相应的信号(若收到信号字符(INTR,QUIT等)则会产生相应的信号)。
ICANON  启用标准模式 (canonical mode)。允许使用特殊字符 EOF, EOL, EOL2, ERASE, KILL, LNEXT, REPRINT, STATUS, 和 WERASE，以及按行的缓冲。
XCASE   (规范大/小写表示) 如果同时设置了 ICANON，终端只有大写。输入被转换为小写，除了以 / 前缀的字符。输出时，大写字符被前缀 /，小写字符被转换成大写。
ECHO    启动本地回显功能。
ECHOE   如果同时设置了 ICANON，字符 ERASE 擦除前一个输入字符，WERASE 擦除前一个词。(若设置ICANON则允许退格操作)
ECHOK   如果同时设置了 ICANON，字符 KILL 删除当前行。(若设置ICANON，则KILL字符会删除当前行)
ECHONL  如果同时设置了 ICANON，回显字符 NL，即使没有设置 ECHO。(若设置ICANON，则允许回显换行符)
ECHOCTL (不属于 POSIX) 如果同时设置了 ECHO，除了 TAB, NL, START, 和 STOP 之外的 ASCII 控制信号被回显为 ^X, 这里 X 是比控制信号大 0x40 的 ASCII 码。例如，字符 0x08 (BS) 被回显为 ^H。
ECHOPRT (不属于 POSIX) 如果同时设置了 ICANON 和 IECHO，字符在删除的同时被打印。(若设置ICANON和IECHO，则删除字符和被删除的字符都会被显示)
ECHOKE  (不属于 POSIX) 如果同时设置了 ICANON，回显 KILL 时将删除一行中的每个字符，如同指定了 ECHOE 和ECHOPRT 一样。
        (若设置ICANON,则允许回显在ECHOE和ECHOPRT中设定的KILL字符)
DEFECHO (不属于 POSIX) 只在一个进程读的时候回显。
FLUSHO (不属于 POSIX; Linux 下不被支持) 输出被刷新。这个标志可以通过键入字符 DISCARD 来开关。
NOFLSH  禁止在产生 SIGINT, SIGQUIT 和 SIGSUSP 信号时刷新输入和输出队列。
       (在通常情况下，当接收到INTR，QUIT，SUSP控制字符时，会清空输入和输出队列。如果设置改标志，则所有的队列不会被清空)
TOSTOP  向试图写控制终端的后台进程组发送 SIGTTOU 信号。
PENDIN (不属于 POSIX; Linux 下不被支持) 在读入下一个字符时，输入队列中所有字符被重新输出。(bash 用它来处理 typeahead)
IEXTEN 启用实现自定义的输入处理。这个标志必须与 ICANON 同时使用，才能解释特殊字符 EOL2，LNEXT，REPRINT 和 WERASE，IUCLC 标志才有效。
       (启动输入处理功能)
}

uart(c_iflag){  输入标志由终端设备驱动程序用来控制字符的输入
c_iflag用于设置: 如何处理串口上接收到的数据，包含如下内容：
IGNBRK  忽略输入中的 BREAK 状态(忽略输入终止条件)。
BRKINT  如果设置了 IGNBRK，将忽略 BREAK。(当检测到输入终止条件时发送SIGINT信号)
        如果没有设置，但是设置了 BRKINT，那么 BREAK 将使得输入和输出队列被刷新，
        如果终端是一个前台进程组的控制终端，这个进程组中所有进程将收到 SIGINT 信号。
        如果既未设置IGNBRK 也未设置 BRKINT，BREAK 将视为与 NUL 字符同义，
            除非设置了 PARMRK，这种情况下它被视为序列 /377/0/0。
IGNPAR  忽略桢错误和奇偶校验错(忽略奇偶校验错误)。
PARMRK  如果没有设置 IGNPAR，在有奇偶校验错或桢错误的字符前插入 /377/0。
        如果既没有设置 IGNPAR 也没有设置PARMRK，将有奇偶校验错或桢错误的字符视为/0。
        (奇偶校验错误掩码)
INPCK   启用输入奇偶检测(奇偶校验使能)。 # Enable parity check
ISTRIP  去掉第八位(裁剪掉第8比特)。 # Strip parity bits
INLCR   将输入中的 NL 翻译为 CR。                     # Map NL to CR  当收到NL（换行符）转换CR（回车符）
IGNCR   忽略输入中的回车。                            # Ignore CR     忽略收到的CR
ICRNL   将输入中的回车翻译为新行 (除非设置了 IGNCR)。 # Map CR to NL  当收到CR转换为NL
IUCLC   (不属于 POSIX) 将输入中的大写字母映射为小写字母。 # 将接收到的大写字符映射为小写字符
IXON    启用输出的 XON/XOFF 流控制(启动输出软件控制流)。
IXANY   (不属于 POSIX.1；XSI) 允许任何字符来重新开始输出。(输入任意字符可以重新启动输入（默：起始字符）)
IXOFF   启用输入的 XON/XOFF 流控制(启动输入软件控制流)。
IMAXBEL (不属于 POSIX) 当输入队列满时响零(当输入队列满时响铃)。
        Linux 没有实现这一位，总是将它视为已设置。
}

XON_XOFF(){
  XON/XOFF 是一种流控制协议（通信速率匹配协议），用于数据传输速率大于等于1200b/s时进行速率匹配，
方法是控制发送方的发速率以匹配双方的速率。
  XON/XOFF（继续/停止）是异步串行连接的计算机和其他元件之间的数据流控制协议。
  
  例如，计算机向打印机发送数据的速度通常快于打印机打印的速度，打印机包含一个缓冲器，用来存储数据，
使打印机能够赶上计算机。如果在打印机赶上之前缓冲器变满了，打印机的小微处理器便发回一个XOFF信号来
停止数据传送，打印完相当多的数据，缓冲存储器变空时，打印机发送XON信号，让计算机继续发送数据。X表示发送器，
X/ON和X/OFF为开启和关闭发送器的信号。
  X/ON的实际信号为ASCII的Ctrl+Q键盘组合的位组合，X/OFF信号为Ctrl+S字符。
  其中XON采用ASCII字符集中的控制字符DC1，XOFF采用ASCII字符集中的控制字符DC3。
  在为计算机操作系统定义调制解调器时，可能需要用XON/XOFF或CTS/RTS来指定流控制的使用。
在发送二进制数据时，XON/XOFF可能不能识别，因为它被译成了字符。
  
XMODEM是一种低速文件传输协议。
KERMIT是异步通信环境中使用的一种文件传输协议。
  KERMIT与XMODEM的主要区别是：KERMIT一次可传送多个文件，而XMODEM一次只能传送一个文件；
  KERMIT在接收方以完整的信息包应答，而XMODEM以单字节应答；
  KERMIT提供多种错误校验技术，而XMODEM只提供一种错误校验技术。
}

uart(c_oflag){  输出标志则控制驱动程序的输出
c_oflag用于设置如何处理输出数据，包含如下内容：
OPOST    执行输出处理(启动输出处理功能，如果不设置，其他位忽略)。
OLCUC    (不属于 POSIX) 将输出中的小写字母映射为大写字母(将输出的小写字符转换为大写字符)。
ONLCR    (XSI) 将输出中的新行符映射为回车-换行(将NL转换为CR-NL)。
OCRNL    将输出中的回车映射为新行符(将输出中的回车符转换成换行)
ONOCR    在0列不输出CR (如果当前列号为0，则不输出回车字符)。
ONOEOT   在输出中删除EOT字符
ONLRET   不输出回车(NL执行CR功能)。
OFILL    发送填充字符作为延时，而不是使用定时来延时(发送填充字符以提供延时)。
OFDEL    (不属于 POSIX) 填充字符是 ASCII DEL (0177)。如果不设置，填充字符则是 ASCII NUL。(如果设置该标志，则表示填充字符为DEL字符，否则为NUL)
OXTABS   将制表符扩充为空格(仅4.3+BSD)；
NLDLY    新行延时掩码。取值为 NL0 和 NL1。(换行延时掩码)
    NL0 : No delay for NLs 
    NL1 : Delay further output after newline for 100 milliseconds
CRDLY    回车延时掩码。取值为 CR0, CR1, CR2, 或 CR3。(回车延时掩码)
    CR0 : No delay for CRs 
    CR1 : Delay after CRs depending on current column position 
    CR2 : Delay 100 milliseconds after sending CRs 
    CR3 : Delay 150 milliseconds after sending CRs
TABDLY   水平跳格延时掩码。取值为 TAB0, TAB1, TAB2, TAB3 (或 XTABS)。取值为 TAB3，即 XTABS，将扩展跳格为空格 (每个跳格符填充 8 个空格)。
         (制表符延时掩码)
    TAB0 : No delay for TABs 
    TAB1 : Delay after TABs depending on current column position 
    TAB2 : Delay 100 milliseconds after sending TABs 
    TAB3 : Expand TAB characters to spaces
BSDLY    回退延时掩码。取值为 BS0 或 BS1。(水平退格符延时掩码)
    BS0 : No delay for BSs 
    BS1 : Delay 50 milliseconds after sending BSs
VTDLY    竖直跳格延时掩码。取值为 VT0 或 VT1。(垂直退格符延时掩码)
    VT0 : No delay for VTs 
    VT1 : Delay 2 seconds after sending VTs
FFDLY    进表延时掩码。取值为 FF0 或 FF1。(换页符延时掩码)
    FF0 : No delay for FFs 
    FF1 : Delay 2 seconds after sending FFs
}

uart(c_cc){
c_cc定义了控制字符，包含以下内容：
VINTR   (003, ETX, Ctrl-C, or also 0177, DEL, rubout) 中断字符。发出 SIGINT 信号。当设置 ISIG 时可被识别，不再作为输入传递。
         中断控制字符，对应的键位ctrl+c
VQUIT   (034, FS, Ctrl-/) 退出字符。发出 SIGQUIT 信号。当设置 ISIG 时可被识别，不再作为输入传递。
        退出操作符，对应的键为ctrl+z
VERASE  (0177, DEL, rubout, or 010, BS, Ctrl-H, or also #) 删除字符。删除上一个还没有删掉的字符，但不删除上一个 EOF 或行首。当设置 ICANON 时可被识别，不再作为输入传递。
        删除操作符，对应Backspace
VKILL   (025, NAK, Ctrl-U, or Ctrl-X, or also @) 终止字符。删除自上一个 EOF 或行首以来的输入。当设置 ICANON 时可被识别，不再作为输入传递。
        删除行符，对应的键为ctrl+u
VEOF    (004, EOT, Ctrl-D) 文件尾字符。更精确地说，这个字符使得 tty 缓冲中的内容被送到等待输入的用户程序中，而不必等到 EOL。如果它是一行的第一个字符，那么用户程序的 read() 将返回 0，指示读到了 EOF。当设置 ICANON 时可被识别，不再作为输入传递。
        文件结尾符，对应的键为ctrl+d
VMIN   非 canonical 模式读的最小字符数。
VEOL   (0, NUL) 附加的行尾字符。当设置 ICANON 时可被识别。
        附加行结尾符，对应的键为carriage return
VTIME  非 canonical 模式读时的延时，以十分之一秒为单位。
VEOL2  (not in POSIX; 0, NUL) 另一个行尾字符。当设置 ICANON 时可被识别
       第二行结尾符，对应的键为line feed
VSWTCH (not in POSIX; not supported under Linux; 0, NUL) 开关字符。(只为 shl 所用。)
VSTART (021, DC1, Ctrl-Q) 开始字符。重新开始被 Stop 字符中止的输出。当设置 IXON 时可被识别，不再作为输入传递。
VSTOP  (023, DC3, Ctrl-S) 停止字符。停止输出，直到键入 Start 字符。当设置 IXON 时可被识别，不再作为输入传递。
VSUSP (032, SUB, Ctrl-Z) 挂起字符。发送 SIGTSTP 信号。当设置 ISIG 时可被识别，不再作为输入传递。
VDSUSP (not in POSIX; not supported under Linux; 031, EM, Ctrl-Y) 延时挂起信号。当用户程序读到这个字符时，发送 SIGTSTP 信号。当设置 IEXTEN 和 ISIG，并且系统支持作业管理时可被识别，不再作为输入传递。
VLNEXT (not in POSIX; 026, SYN, Ctrl-V) 字面上的下一个。引用下一个输入字符，取消它的任何特殊含义。当设置 IEXTEN 时可被识别，不再作为输入传递。
VWERASE (not in POSIX; 027, ETB, Ctrl-W) 删除词。当设置 ICANON 和 IEXTEN 时可被识别，不再作为输入传递。
VREPRINT (not in POSIX; 022, DC2, Ctrl-R) 重新输出未读的字符。当设置 ICANON 和 IEXTEN 时可被识别，不再作为输入传递。
VDISCARD (not in POSIX; not supported under Linux; 017, SI, Ctrl-O) 开关：开始/结束丢弃未完成的输出。当设置 IEXTEN 时可被识别，不再作为输入传递。
VSTATUS (not in POSIX; not supported under Linux; status request: 024, DC4, Ctrl-T).
|------------------------------------------------|
|  ^c    Value |  ^c      Value |   ^c    Value  |
|------|-------|-------|--------|--------|-------|
|a, A  | <SOH> |  l, L |  <FF>  |  w, W  | <ETB> |
|b, B  | <STX> |  m, M |  <CR>  |  x, X  | <CAN> |
|c, C  | <ETX> |  n, N |  <SO>  |  y, Y  | <EM>  |
|d, D  | <EOT> |  o, O |  <SI>  |  z, Z  | <SUB> |
|e, E  | <ENQ> |  p, P |  <DLE> |  [     | <ESC> |
|f, F  | <ACK> |  q, Q |  <DC1> |  \     | <FS>  |
|g, G  | <BEL> |  r, R |  <DC2> |  ]     | <GS>  |
|h, H  | <BS>  |  s, S |  <DC3> |  ^     | <RS>  |
|i, I  | <HT>  |  t, T |  <DC4> |--------| <US>  |
|j, J  | <LF>  |  u, U |  <NAK> |  ?     | <DEL> |
|k, K  | <VT>  |  v, V |  <SYN> |        |       |
|------|-------|-------|--------|--------|-------|

|------|--------|------|
|      |  0x00  | 0x10 |
|------|--------|------|
|0x00  |  NUL   |  DLE |
|0x01  |  SOH   |  DC1 |
|0x02  |  STX   |  DC2 |
|0x03  |  ETX   |  DC3 |
|0x04  |  EOT   |  DC4 |
|0x05  |  ENQ   |  NAK |
|0x06  |  ACK   |  SYN |
|0x07  |  BEL   |  ETB |
|0x08  |  BS    |  CAN |
|0x09  |  TAB   |  EM  |
|0x0A  |  LF    |  SUB |
|0x0B  |  VT    |  ESC |
|0x0C  |  FF    |  FS  |
|0x0D  |  CR    |  GS  |
|0x0E  |  SO    |  RS  |
|0x0F  |  SI    |  US  |
|0x7F  |  DEL   |      |
|------|--------|------|


stty -a -F /dev/ttyS*
}

_PC_VDISABLE(){
pathconf和fpathconf的选项及name参数
选项名字            说明                                  name参数
_POSIX_VDISABLE     若定义，可以用此值禁用终端特殊字符   _PC_VDISABLE
_PC_VDISABLE引用的文件必须是一个终端文件。
}
termios(POSIX终端函数){
tcgetattr           取属性(termios结构)；   # 获取和设置属性
tcsetattr           设置属性(termios结构)； # 获取和设置属性
cfgetispeed         得到输入速度；          # 速度控制
cfgetospeed         得到输出速度；          # 速度控制
cfsetispeed         设置输入速度；          # 速度控制
cfsetospeed         设置输出速度；          # 速度控制
tcdrain             等待所有输出都被传输；  # 行控制
tcflow              挂起传输或接收；        # 行控制
tcflush             刷清未决输入和/或输出； # 行控制
tcsendbreak         送BREAK字符；           # 行控制
tcgetpgrp           得到前台进程组ID；
tcsetpgrp           设置前台进程组ID；
}
cfmakeraw(将终端设置为原始模式){
cfmakeraw 设置终端属性如下： # 原始模式 不用于串口协议数据通信
termios_p->c_iflag &= ~(IGNBRK|BRKINT|PARMRK|ISTRIP
                |INLCR|IGNCR|ICRNL|IXON);
termios_p->c_oflag &= ~OPOST;
termios_p->c_lflag &= ~(ECHO|ECHONL|ICANON|ISIG|IEXTEN);
termios_p->c_cflag &= ~(CSIZE|PARENB);
termios_p->c_cflag |= CS8;
}

tcdrain(行控制:若成功则返回0,出错则返回-1){
tcdrain(等待所有输出都被发送) 等待直到所有写入 fd 引用的对象的输出都被传输。
}

tcflush(行控制:若成功则返回0,出错则返回-1){
tcflush(刷清输入缓冲区或输出缓冲区) 
丢弃要写入引用的对象，但是尚未传输的数据，或者收到但是尚未读取的数据，取决于 queue_selector 的值：
TCIFLUSH    刷新收到的数据但是不读
TCOFLUSH    刷新写入的数据但是不传送
TCIOFLUSH   同时刷新收到的数据但是不读，并且刷新写入的数据但是不传送
}

tcflow(行控制:若成功则返回0,出错则返回-1){
tcflow(对输入和输出流控制进行控制) 挂起 fd 引用的对象上的数据传输或接收，取决于 action 的值：
TCOOFF  挂起输出
TCOON   重新开始被挂起的输出
TCIOFF  发送一个 STOP 字符，停止终端设备向系统传送数据
TCION   发送一个 START 字符，使终端设备向系统传输数据
打开一个终端设备时的默认设置是输入和输出都没有挂起。
}
tcsendbreak(行控制:若成功则返回0,出错则返回-1){
tcsendbreak函数在一个指定的时间区间内发送连续的0位流。若duration参数为0，则此种发送延续0.25至0.5秒之间。
}

tcsetattr(获取和设置终端属性){
其中成员c_line在POSIX系统中不使用。对于支持POSIX终端接口的系统中，对于端口属性的设置和获取要用到两个重要的函数是：
1.int tcsetattr(int fd，int opt_DE，*ptr)
该函数用来设置终端控制属性，其参数说明如下：
  fd：待操作的文件描述符
  opt_DE：选项值，有三个选项以供选择：
    TCSANOW：  不等数据传输完毕就立即改变属性
    TCSADRAIN：等待所有数据传输结束才改变属性
    TCSAFLUSH：清空输入输出缓冲区才改变属性
  *ptr：指向termios结构的指针
函数返回值：成功返回0，失败返回-1

2.int tcgetattr(int fd，*ptr)
该函数用来获取终端控制属性，它把串口的默认设置赋给了termios数据数据结构，其参数说明如下：
  fd：待操作的文件描述符
  *ptr：指向termios结构的指针
函数返回值：成功返回0，失败返回-1。
}
cfsetispeed(获取和设置波特率  cfsetispeed|cfsetospeed|cfgetispeed|cfgetospeed){
1. 波特率的设置定义在<asm/termbits.h>，其包含在头文件<termios.h>里
2. socat -hh |grep ' b[1-9]' 波特率

struct termios opt；        /*定义指向termios 结构类型的指针opt*/
cfsetispeed(&opt，B9600 )； /*指定输入波特率，9600bps*/
cfsetospeed(&opt，B9600)；  /*指定输出波特率，9600bps*/
}

char(终端特殊输入字符){
| --------|-----------------------|-----------|---------------------|--------|----------|--------|-------|
| 字符    |    说明               | c_cc下标  |  起作用，由：       |典型值  | POSIX.1  | SVR4   |4.3+BSD|
|         |                       |           |  字段     标志      |        |          | 扩充   |       |
| --------|-----------------------|-----------|----------|----------|--------|----------|--------|-------|
| CR      |    回车               | 不能更改  |  c_lflag |ICANON    | /r     |  YES     |        |       |
| DISCARD |    擦除输出           | VDISCARD  |  c_lflag |IEXTEN    | ^O     |          | YES    | YES   |
| DSUSP   |    延迟挂起(SIGTSTP)  | VDUSP     |  c_lflag |ISIG      | ^Y     |          | YES    | YES   |
| EOF     |    文件结束           | VEOF      |  c_lflag |ICANON    | ^D     |  YES     |        |       |
| EOL     |    行结束             | VEOL      |  c_lflag |ICANON    |        |  YES     |        |       |
| EOL2    |    替换的行结束       | VEOL2     |  c_lflag |ICANON    |        |          | YES    | YES   |
| ERASE   |    擦除字符           | VERASE    |  c_lflag |ICANON    | ^H     |  YES     |        |       |
| INTR    |    中断信号(SIGINT)   | VINTR     |  c_lflag |ISIG      | ^?, ^C |  YES     |        |       |
| KILL    |    擦行               | VKILL     |  c_lflag |ICANON    | ^U     |  YES     |        |       |
| LNEXT   |    下一个字列字符     | VLNEXT    |  c_lflag |IEXTEN    | ^V     |          | YES    | YES   |
| NL      |    新行               | 不能更改  |  c_lflag |ICANON    | /n     |  YES     |        |       |
| QUIT    |    退出信号(SIGQUIT)  | VQUIT     |  c_lflag |ISIG      | ^/     |  YES     |        |       |
| REPRINT |    再打印全部输入     | VREPRINT  |  c_lflag |ICANON    | ^R     |          | YES    | YES   |
| START   |    恢复输出           | VSTART    |  c_lflag |IXON/IXOFF| ^Q     |  YES     |        |       |
| STATUS  |    状态要求           | VSTATUS   |  c_lflag |ICANON    | ^T     |          |        | YES   |
| STOP    |    停止输出           | VSTOP     |  c_lflag |IXON/IXOFF| ^S     |  YES     |        |       |
| SUSP    |    挂起信号(SIGTSTP)  | VSUSP     |  c_lflag |ISIG      | ^Z     |  YES     |        |       |
| WERASE  |    擦除字             | VWERASE   |  c_lflag |ICANON    | ^W     |          | YES    | YES   |
| --------|-----------------------|-----------|----------|----------|--------|----------|--------|-------|
}                                                                            

stty(设置、复位和报告工作站操作参数){
stty [ -a ] [ -g ] [ Options ]
    -a  将所有选项设置的当前状态写到标准输出中。
    -g  将选项设置写到标准输出中，其格式可以由另一个 stty 命令使用。
1. stty 命令对当前为标准输入的设备设置某些 I/O 选项。该命令将输出写到当前为标准输出的设备中。

输入以下命令时，可以将 tty 设备的标准输入重定向：
 stty -a </dev/ttyx
stty 命令（POSIX）将挂起并等待该 tty 的 open()，直到确定 RS-232 载波检测信号。如果设置了 clocal 或 forcedcd（仅对 128 端口）选项，这个规则将不适用。

stty        # 工作站配置的简短列表
stty  -a    # 工作站配置的完整列表
stty ixon ixany # 启用停止列表滚动出屏幕的按键顺序
    这将设置 ixon 模式，从而可以通过按下 Ctrl-S 按键顺序来停止列表的滚动。ixany 标志允许按任意键来恢复列表的滚动。
正常的工作站配置包含 ixon 和 ixany 标志，使您可以用 Ctrl-S 按键顺序停止列表的滚动，而只有 Ctrl-Q 按键顺序才能使
列表重新滚动。
Ctrl-J stty  sane Ctrl-J # 要重新设置搞乱的配置

要保存和恢复终端的配置
OLDCONFIG=$(stty -g)          # save configuration
stty -echo                   # do not display password
echo "Enter password: \c"
read PASSWD                  # get the password
stty $OLDCONFIG              # restore configuration
该命令保存工作站的配置、关闭回送信号、读取密码并恢复原始配置。
}

stty(控制模式){
clocal 	假定一行没有调制解调器控制。
-clocal 	假定一行带有调制解调器控制。
cread 	启用接收器。
-cread 	禁用接收器。
cstopb 	每个字符选择两个停止位。
-cstopb 	每个字符选择一个停止位。
cs5, cs6, cs7, cs8 	选择字符大小。
hup, hupcl 	最后关闭时挂起拨号连接。
-hup, -hupcl 	最后关闭时不挂起拨号连接。
parenb 	启用奇偶性校验的生成和检测。
-parenb 	禁用奇偶性校验的生成和检测。
parodd 	选择奇校验。
-parodd 	选择偶校验。
0 	立即挂起电话线路。
speed 	将工作站输入和输出速度设置为指定的 speed 数（以位/秒为单位）。并不是所有的硬件接口都支持所有的速度。speed 的可能值有：50、75、110、134、200、300、600、1200、1800、2400、4800、9600、19200、19.2、38400、38.4、exta 和  extb。
注:
exta、19200 和 19.2 是同义词；extb、38400 和 38.4 是同义词。
ispeed speed 	将工作站输入速度设置为指定的 speed 数（以位/秒为单位）。并不是所有的硬件接口都支持所有的速度，而且并不是所有的硬件接口都支持该选项。 speed 的可能值与 speed 选项相同。
ospeed speed 	将工作站输出速度设置为指定的 speed 数（以位/秒为单位）。并不是所有的硬件接口都支持所有的速度，而且并不是所有的硬件接口都支持该选项。 speed 的可能值与 speed 选项相同。
}

stty(输入模式){
brkint 	中断时发出 INTR 信号。
-brkint 	中断时不发出 INTR 信号。
icrnl 	输入时将 CR 映射为 NL。
-icrnl 	输入时不将 CR 映射为 NL。
ignbrk 	输入时忽略 BREAK。
-ignbrk 	输入时不忽略 BREAK。
igncr 	输入时忽略 CR。
-igncr 	输入时不忽略 CR。
ignpar 	忽略奇偶错误。
-ignpar 	不忽略奇偶错误。
inlcr 	输入时将 NL 映射为 CR。
-inlcr 	输入时不将 NL 映射为 CR。
inpck 	启用奇偶校验。
-inpck 	禁用奇偶校验。
istrip 	将输入字符剥离到 7 位。
-istrip 	不将输入字符剥离到 7 位。
iuclc 	将大写字母字符映射为小写。
-iuclc 	不将大写字母字符映射为小写。
ixany 	允许任何字符重新启动输出。
-ixany 	只允许 START（Ctrl-Q 按键顺序）重新启动输出。
ixoff 	当输入队列接近空或满时，发送 START/STOP 字符。
-ixoff 	不发送 START/STOP 字符。
ixon 	启用 START/STOP 输出控制。一旦启用 START/STOP 输出控制，您可以按下 Ctrl-S 按键顺序暂停向工作站的输出，也可按下 Ctrl-Q 按键顺序恢复输出。
-ixon 	禁用 START/STOP 输出控制。
imaxbel 	当输入溢出时，回送 BEL 字符并且废弃最后的输入字符。
-imaxbel 	当输入溢出时，废弃所有输入。
parmrk 	标记奇偶错误。
-parmrk 	不标记奇偶错误。
}
stty(输出方式){
bs0, bs1 	为退格符选择延迟样式（bs0 表示没有延迟）。
cr0,  cr1, cr2, cr3 	为 CR 字符选择延迟样式（cr0 表示没有延迟）。
ff0, ff1 	为换页选择延迟样式（ff0 表示没有延迟）。
nl0, nl1 	为 NL 字符选择延迟样式（nl0 表示没有延迟）。
ofill 	使用延迟填充字符。
-ofill 	使用延迟定时。
ocrnl 	将 CR 字符映射为 NL 字符。
-ocrnl 	不将 CR 字符映射为 NL 字符。
olcuc 	输出时将小写字母字符映射为大写。
-olcuc 	输出时不将小写字母字符映射为大写。
onlcr 	将 NL 字符映射为 CR-NL 字符。
-onlcr 	不将 NL 字符映射为 CR-NL 字符。
onlret 	在终端 NL 执行 CR 功能。
-onlret 	在终端 NL 不执行 CR 功能。
onocr 	不在零列输出 CR 字符。
-onocr 	在零列输出 CR 字符。
opost 	处理输出。
-opost 	不处理输出；即忽略所有其它输出选项。
ofdel 	使用 DEL 字符作为填充字符。
-ofdel 	使用 NUL 字符作为填充字符。
tab0, tab1, tab2 	为水平制表符选择延迟样式（tab0 表示没有延迟）。
tab3 	扩展制表符至多个空格。
vt0, vt1 	为垂直制表符选择延迟样式（vt0 表示没有延迟）。
}
stty(本地模式){
echo 	回送每个输入的字符。
-echo 	不回送字符。
echoctl 	以 ^X（Ctrl-X）回送控制字符，X 是将 100 八进制加到控制字符代码中给出的字符。
-echoctl 	不以 ^X（Ctrl-X）回送控制字符。
echoe 	以“backspace space backspace”字符串回送 ERASE 字符。
注:
该模式不保持对列位置的跟踪，因此您可能在擦除制表符和转义序列等符号时得到意外的结果。
-echoe 	不回送 ERASE 字符，只回送退格符。
echok 	在 KILL 字符后回送 NL 字符。
-echok 	在 KILL 字符后不回送 NL 字符。
echoke 	通过擦除输出行上的每个字符，回送 KILL 字符。
-echoke 	只回送 KILL 字符。
echonl 	回送 NL 字符。
-echonl 	不回送 NL 字符。
echoprt 	以 /（斜杠）和 \ (反斜杠) 向后回送擦除的字符。
-echoprt 	不以 /（斜杠）和 \ (反斜杠) 向后回送擦除的字符。
icanon 	启用规范输入（规范输入允许使用 ERASE 和 KILL 字符进行输入行的编辑）。 请参阅 AIX 5L Version 5.2 Communications Programming Concepts 中的 Line Discipline Module (ldterm) 中关于 canonical mode input 的讨论。
-icanon 	禁用规范输入。
iexten 	指定从输入数据中识别实现性定义的功能。 要识别以下控制字符，需要设置 iexten：eol2、dsusp、reprint、discard、werase、lnext。与这些模式关联的功能也需要设置 iexten：imaxbel、echoke、echoprt、echoctl。
-iexten 	指定从输入数据中识别实现性定义的功能。
isig 	启用对特殊控制字符（INTR、SUSP 和 QUIT）的字符检查。
-isig 	禁用对特殊控制字符（INTR、SUSP 和 QUIT）的字符检查。
noflsh 	不清除 INTR、SUSP 或 QUIT 控制字符之后的缓冲区。
-noflsh 	清除 INTR、SUSP 或 QUIT 控制字符之后的缓冲区。
pending 	下次读操作暂挂或输入到达时，要重新输入从原始模式转换为规范模式后被暂挂的输入。暂挂是一个内部状态位。
-pending 	没有文本暂挂。
tostop 	为背景输出发出 SIGTOU 信号。
-tostop 	不为背景输出发出 SIGTOU 信号。
xcase 	在输入中回送大写字符，并在输出显示的大写字符之前加上 \ (反斜杠)。
-xcase 	不在输入时回送大写字符。
}
stty(硬件流量控制模式){
cdxon 	输出时启用 CD 硬件流量控制模式。
-cdxon 	输出时禁用 CD 硬件流量控制模式。
ctsxon 	输出时启用 CTS 硬件流量控制模式。
-ctsxon 	输出时禁用 CTS 硬件流量控制模式。
dtrxoff 	输入时启用 DTR 硬件流量控制模式。
-dtrxoff 	输入时禁用 DTR 硬件流量控制模式。
rtsxoff 	输入时启用 RTS 硬件流量控制模式。
-rtsxoff 	输入时禁用 RTS 硬件流量控制模式。
}
stty(控制指定){
要将一个控制字符指定到某字符串中，请输入：
stty Control String

其中，Control 参数 可以是 INTR、QUIT、ERASE、KILL、EOF、EOL、EOL2、START、STOP、SUSP、DSUSP、
REPRINT、DISCARD、WERASE、LNEXT、MIN 或 TIME 参数。（使用字符 MIN 和 TIME 时，请加上 -icanon 选项。）
注:
MIN 和 TIME 的值解释为整数值，而不是字符值。

String 参数可以是任何单一的字符，比如 c。以下内容为控制赋值的示例：
stty STOP c
另一种指定控制字符的方法可以是：输入一个字符序列，它是由一个  \^ (反斜杠，插入记号) 后面跟着一个单一字符组成的。 如果跟在 ^ （插入记号）后的单一字符是下表的 ^c（插入记号 c）栏中列出的字符之一，将设置相应的控制字符值。 例如，要使用 ?（问号）字符指定 DEL 控制字符，请输入字符串 \^?（反斜杠，插入记号，问号），如下：
stty ERASE \^?

}
stty(组合模式){
cooked 	请参阅 -raw 选项。
ek 	分别将 ERASE 和 KILL 字符设置为 Ctrl-H 和 Ctrl-U 按键顺序。
evenp 	启用 parenb 和 cs7。
-evenp 	禁用 parenb 并设置 cs8。
lcase, LCASE 	设置 xcase，iuclc 和 olcuc。在工作站只以大写字符使用。
-lcase, -LCASE 	设置 -xcase、-iuclc 和 -olcuc。
nl 	设置 -icrnl 和 -onlcr。
-nl 	设置 icrnl、 onlcr、-inlcr、-igncr、-ocrnl 和 -onlret。
oddp 	启用 parenb、 cs7 和 parodd。
-oddp 	禁用 parenb 并设置 cs8。
parity 	请参阅 evenp 选项。
-parity 	请参阅 -evenp 选项。
sane 	将参数重新设置为合理的值。
raw 	允许原始模式输入（不包括输入处理，例如 erase、kill 或 interrupt）；传回奇偶（校验）位。
-raw 	允许规范输入方式。
tabs 	保留制表符。
-tabs, tab3 	打印时将制表符替换为空格。
窗口大小 	 
cols n, columns n 	将终端（窗口）大小记录为有 n 列。
rows n 	将终端（窗口）大小记录为有 n 行。
size 	将终端（窗口）大小打印到标准输出（先是行，再是列）中。
}
toybox(){
  tcgetattr(fd, &terminal);
  terminal.c_cc[VINTR] = 3;    //ctrl-c
  terminal.c_cc[VQUIT] = 28;   /*ctrl-\*/
  terminal.c_cc[VERASE] = 127; //ctrl-?
  terminal.c_cc[VKILL] = 21;   //ctrl-u
  terminal.c_cc[VEOF] = 4;     //ctrl-d
  terminal.c_cc[VSTART] = 17;  //ctrl-q
  terminal.c_cc[VSTOP] = 19;   //ctrl-s
  terminal.c_cc[VSUSP] = 26;   //ctrl-z

  terminal.c_line = 0;
  terminal.c_cflag &= CRTSCTS|PARODD|PARENB|CSTOPB|CSIZE|CBAUDEX|CBAUD;
  terminal.c_cflag |= CLOCAL|HUPCL|CREAD;

  //enable start/stop input and output control + map CR to NL on input
  terminal.c_iflag = IXON|IXOFF|ICRNL;

  //Map NL to CR-NL on output
  terminal.c_oflag = ONLCR|OPOST;
  terminal.c_lflag = IEXTEN|ECHOKE|ECHOCTL|ECHOK|ECHOE|ECHO|ICANON|ISIG;
  tcsetattr(fd, TCSANOW, &terminal);
}