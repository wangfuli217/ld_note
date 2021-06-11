pcap(获取网络接口){
首先我们需要获取监听的网络接口：
我们可以手动指定或让libpcap自动选择，先介绍如何让libpcap自动选择：
char * pcap_lookupdev(char * errbuf)
上面这个函数返回第一个合适的网络接口的字符串指针，如果出错，则errbuf存放出错信息字符串，errbuf至少应该是PCAP_ERRBUF_SIZE个字节长度的。注意，很多libpcap函数都有这个参数。
pcap_lookupdev()一般可以在跨平台的，且各个平台上的网络接口名称都不相同的情况下使用。
如果我们手动指定要监听的网络接口，则这一步跳过，我们在第二步中将要监听的网络接口字符串硬编码在pcap_open_live里。
}

pcap(释放网络接口){
在操作为网络接口后，我们应该要释放它：
void pcap_close(pcap_t * p)
该函数用于关闭pcap_open_live()获取的pcap_t的网络接口对象并释放相关资源。
}

pcap(打开网络接口){
获取网络接口后，我们需要打开它：
pcap_t * pcap_open_live(const char * device, int snaplen, int promisc, int to_ms, char * errbuf)
上面这个函数会返回指定接口的pcap_t类型指针，后面的所有操作都要使用这个指针。
第一个参数是第一步获取的网络接口字符串，可以直接使用硬编码。
第二个参数是对于每个数据包，从开头要抓多少个字节，我们可以设置这个值来只抓每个数据包的头部，而不关心具体的内容。典型的以太网帧长度是1518字节，但其他的某些协议的数据包会更长一点，但任何一个协议的一个数据包长度都必然小于65535个字节。
第三个参数指定是否打开混杂模式(Promiscuous Mode)，0表示非混杂模式，任何其他值表示混合模式。如果要打开混杂模式，那么网卡必须也要打开混杂模式，可以使用如下的命令打开eth0混杂模式：
ifconfig eth0 promisc
第四个参数指定需要等待的毫秒数，超过这个数值后，第3步获取数据包的这几个函数就会立即返回。0表示一直等待直到有数据包到来。
第五个参数是存放出错信息的数组。
}

pcap_pkthdr(){
struct timeval ts;    /* time stamp */  
bpf_u_int32 caplen;   /* length of portion present */  
bpf_u_int32 len;      /* length this packet (off wire) */
}
pcap(获取数据包:pcap_next){
u_char * pcap_next(pcap_t * p, struct pcap_pkthdr * h)
如果返回值为NULL，表示没有抓到包
第一个参数是第2步返回的pcap_t类型的指针
第二个参数是保存收到的第一个数据包的pcap_pkthdr类型的指针
}
pcap(获取数据包:pcap_loop){
int pcap_loop(pcap_t * p, int cnt, pcap_handler callback, u_char * user)
第一个参数是第2步返回的pcap_t类型的指针
第二个参数是需要抓的数据包的个数，一旦抓到了cnt个数据包，pcap_loop立即返回。负数的cnt表示pcap_loop永远循环抓包，直到出现错误。
第三个参数是一个回调函数指针，它必须是如下的形式：
void callback(u_char * userarg, const struct pcap_pkthdr * pkthdr, const u_char * packet)

第一个参数是pcap_loop的最后一个参数，当收到足够数量的包后pcap_loop会调用callback回调函数，同时将pcap_loop()的user参数传递给它
第二个参数是收到的数据包的pcap_pkthdr类型的指针
第三个参数是收到的数据包数据
}

pcap(获取数据包:pcap_dispatch){
int pcap_dispatch(pcap_t * p, int cnt, pcap_handler callback, u_char * user)
这个函数和pcap_loop()非常类似，只是在超过to_ms毫秒后就会返回(to_ms是pcap_open_live()的第4个参数)
}

pcap(分析数据包){
我们既然已经抓到数据包了，那么我们要开始分析了，这部分留给读者自己完成，具体内容可以参考相关的网络协议说明。在本文的最后，我会示范性的写一个分析arp协议的sniffer，仅供参考。要特别注意一点，网络上的数据是网络字节顺序的，因此分析前需要转换为主机字节顺序(ntohs()函数)。
}

pcap(过滤数据包){
几乎所有的操作系统(BSD, AIX, Mac OS, Linux等)都会在内核中提供过滤数据包的方法，主要都是基于BSD Packet Filter(BPF)结构的。libpcap利用BPF来过滤数据包。
过滤数据包需要完成3件事：
a) 构造一个过滤表达式
b) 编译这个表达式
c) 应用这个过滤器


a)
BPF使用一种类似于汇编语言的语法书写过滤表达式，不过libpcap和tcpdump都把它封装成更高级且更容易的语法了，具体可以man tcpdump，以下是一些例子：
src host 192.168.1.177
只接收源ip地址是192.168.1.177的数据包

dst port 80
只接收tcp/udp的目的端口是80的数据包

not tcp
只接收不使用tcp协议的数据包

tcp[13] == 0x02 and (dst port 22 or dst port 23)
只接收SYN标志位置位且目标端口是22或23的数据包（tcp首部开始的第13个字节）

icmp[icmptype] == icmp-echoreply or icmp[icmptype] == icmp-echo
只接收icmp的ping请求和ping响应的数据包

ehter dst 00:e0:09:c1:0e:82
只接收以太网mac地址是00:e0:09:c1:0e:82的数据包

ip[8] == 5
只接收ip的ttl=5的数据包（ip首部开始的第8个字节）
}
pcap(过滤数据包:pcap_compile){
构造完过滤表达式后，我们需要编译它，使用如下函数：
int pcap_compile(pcap_t * p, struct bpf_program * fp, char * str, int optimize, bpf_u_int32 netmask)
fp：这是一个传出参数，存放编译后的bpf
str：过滤表达式
optimize：是否需要优化过滤表达式
metmask：简单设置为0即可
}
pcap(过滤数据包:pcap_setfilter){
最后我们需要应用这个过滤表达式：
int pcap_setfilter(pcap_t * p,  struct bpf_program * fp)
第二个参数fp就是前一步pcap_compile()的第二个参数

应用完过滤表达式之后我们便可以使用pcap_loop()或pcap_next()等抓包函数来抓包了。
}

BPF(Berkeley Packet Filter){
BPF 即为 tcpdump 抑或 wireshark 乃至网络监控(Network Monitoring)领域的基石。
1. 过滤(Filter): 根据外界输入的规则过滤报文；
2. 复制(Copy)：将符合条件的报文由内核空间复制到用户空间；
位于内核之中的 BPF 模块是整个流程之中最核心的一环：
1. 它一方面接受 tcpdump 经由 libpcap 转码而来的滤包条件(Pseudo Machine Language) ，
2. 另一方面也将符合条件的报文复制到用户空间最终经由 libpcap 发送给 tcpdump。
途经网卡驱动层的报文在上报给协议栈的同时会多出一路来传送给 BPF，再经后者过滤后最终拷贝给用户态的应用。
sudo tcpdump -d -i lo tcp and dst port 7070
(000) ldh [12]
(001) jeq #0x86dd jt 2 jf 6     #检测是否为 ipv6 报文，若为假(jf)则按照 ipv4 报文处理(L006)
(002) ldb [20]
(003) jeq #0x6 jt 4 jf 15       #检测是否为 tcp 报文
(004) ldh [56]
(005) jeq #0x1b9e jt 14 jf 15   #检测是否目标端口为 7070(0x1b9e)，若为真(jt)则跳转 L014
(006) jeq #0x800 jt 7 jf 15     #检测是否为 ipv4 报文
(007) ldb [23]
(008) jeq #0x6 jt 9 jf 15       #检测是否为 tcp 报文
(009) ldh [20]
(010) jset #0x1fff jt 15 jf 11  #检测是否为 ip 分片(IP fragmentation)报文
(011) ldxb 4*([14]&0xf)
(012) ldh [x + 16]              #找到 tcp 报文中 dest port 的所在位置
(013) jeq                       #0x1b9e jt 14 jf 15 #检测是否目标端口为 7070(0x1b9e)，若为真(jt)则跳转 L014
(014) ret                       #262144 #该报文符合要求
(015) ret                       #0 #该报文不符合要求
但是相较于-dd 和-ddd 反人类的输出，这确可以称得上是"一目了然"的代码了。

BPF 采用的报文过滤设计的全称是 CFG(Computation Flow Graph)，顾名思义是将过滤器构筑于一套基于 if-else 的控制流(flow graph)之上，
另一个角度来说，基于伪代码的设计却也增加了系统的复杂性：
一方面伪指令集已经足够让人眼花缭乱的了；
另一方面为了执行伪代码，内核中还需要专门实现一个虚拟机(pseudo-machine)，这也在一定程度上提高了开发和维护的门槛。
}
LSF(Linux Socket Filter){
LSF 和 BPF 除了名字上的差异以外，还是有些不同的，首当其冲的分歧就是接口：
传统的 BSD 开启 BPF 的方式主要是靠打开(open)/dev/bpfX 设备，之后利用 ioctl 来进行控制；
而 linux 则选择了利用套接字选项(sockopt)SO_ATTACH_FILTER/SO_DETACH_FILTER 来执行系统调用，


}
JIT(JIT For BPF){
在一些特定硬件平台上，BPF 开始有了用于提速的 JIT(Just-In-Time) Compiler。
各平台的 JIT 编译函数都实现于bpf_jit_compile()之中(3.16 之后，开始逐步改为bpf_int_jit_compile())，
如果 CONFIG_BPF_JIT 被打开，则传入的 BPF 伪代码就会被传入该函数加以编译，编译结果被拿来替换掉默认的处理函数 sk_run_filter()。

/proc/sys/net/core/bpf_jit_enable 写入 1
}
eBPF(){
有全面扩充既有 BPF 功能之意；而相对应的，为了后向兼容，传统的 BPF 仍被保留了下来，并被重命名为 classical BPF(cBPF)
}
BCC(BPF Compiler Collection){
于是就有人设计了 BPF Compiler Collection(BCC)，BCC 是一个 python 库，但是其中有很大一部分的实现是基于 C 和 C++的，python 只不过实现了对 BCC 应用层接口的封装而已。
使用 BCC 进行 BPF 的开发仍然需要开发者自行利用 C 来设计 BPF 程序——但也仅此而已，余下的工作，包括编译、解析 ELF、加载 BPF 代码块以及创建 map 等等基本可以由 BCC 一力承担，无需多劳开发者费心。
}
# https://www.ibm.com/developerworks/cn/linux/l-lo-eBPF-history/index.html
