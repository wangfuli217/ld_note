https://wiki.shileizcc.com/confluence/display/firewall/Firewall <Linux防火墙> 书网页版

策略：
1. 允许哪些Internet服务访问你的机器，
2. 通过你的计算机向外提供哪些服务，
3. 哪些服务只为特定的远程用户或站点提供，
4. 哪些服务和程序你只希望在本地运行以便仅提供你私人使用。

lastb # show listing of last logged in users
/var/log/messages /var/log/kern.log
/proc/sys/net/ipv4/ip_forward


定义防火墙规则的一个最重要的因素是定义规则的顺序。

# 回放          -S(输出内核添加的规则链)
# 规则管理      -A(追加) -D(指定规则或规则序号) -I(插入) -R(替换)    -F(清空规则，-D操作的一步到位) -L(查看) -Z(统计归零)
# 规则链管理    -N(--new-chain) -X(--delete-chain ) -E(--rename-chain)
# 默认规则链    -P( --policy chain target)
iptables <option> <chain> <matching criteria> <target>

无状态防火墙(不维护状态的防火墙 stateless firewall)仅仅在IP层中执行一些数据报过滤，尽管有时这种类型的防火墙会涉及高层的协议
状态防火墙会对看到的一个会话中之前的数据包进行跟踪，并基于此连接中已经看到的内容对数据报应用访问策略。
状态防火墙隐含着它也拥有无状态防火墙所拥有的基础数据包过滤功能。

NAT和私有IP有效减轻了即将出现的IPv4地址短缺。


table_chain(){
PREROUTING 链: 可进行 DNAT。
FORWARD 链: 一般用于处理转发到其他机器 或 network namespace 的数据包。
INPUT 链: 一般用于处理输入本地进程的数据包。
OUTPUT 链: 一般用于处理本地进程输出的数据包。
POSTROUTING 链: 可进行 SNAT

filter 表: 用于控制到达某条链上的数据包是继续放行(accept)、直接丢弃(drop)或拒绝(reject)。
nat 表: 用于修改数据包的源和目的地址。
mangle 表: 用于修改数据包的 IP 头信息。
raw 表: iptables 是有状态的，即 iptables 对数据包有连接追踪 (connection tracking) 机制，而 raw 是用来去除这种追踪机制的。
security: 最不常用的表（通常，说 iptables 只有 4 张表，security 表是新加入的特性），用于在数据包上应用 SELinux。
        PREROUTING  POSTROUTING  FORWARD  INPUT  OUTPUT
raw         Y           N          N       N       Y
mangle      Y           Y          Y       Y       Y
nat(SNAT)   N           Y          N       Y       N
nat(DNAT)   Y           N          N       N       Y
filter      N           N          Y       Y       Y
security    N           N          Y       Y       Y

}


IP(){
LOOPBACK="127.0.0.0/8"               # reserved loopback address range
CLASS_A="10.0.0.0/8"                 # Class A private networks
CLASS_B="172.16.0.0/12"              # Class B private networks
CLASS_C="192.168.0.0/16"             # Class C private networks
CLASS_D_MULTICAST="224.0.0.0/4"      # Class D multicast addresses
CLASS_E_RESERVED_NET="240.0.0.0/5"   # Class E reserved addresses
BROADCAST_SRC="0.0.0.0"              # broadcast source address
BROADCAST_DEST="255.255.255.255"     # broadcast destination address

PRIVPORTS="0:1023"                   # well-known, privileged port range
UNPRIVPORTS="1024:65535"             # unprivileged port range

----- -m addrtype -----iptables -m addrtype -h 
UNSPEC      未指明的地址
UNICAST     单播地址
LOCAL       本地地址
BROADCAST   广播地址
ANYCAST     任播地址
MULTICAST   多播地址
BLACKHOLE   黑洞地址
UNREACHABLE 不可达地址
PROHIBIT    禁止地址
MULTICAST   组播地址
THROW       
NAT         
XRESOLVE    
--src-type <type> 用类型<type>匹配源地址
--dst-type <type> 用类型<type>匹配目的地址
}
单播地址，组播地址和广播地址(受限广播地址和直接广播地址)
单播地址相当于互联网上的一个网络接口；组播地址代表被包括在那个组里的多台主机；广播地址通常由要向某个特定子网中中的每个主机发送数据的主机使用。

A类、B类、C类地址才真正被互联网使用。
D类用于组播
E类地址是实验性的、未分配的地址范围。

特殊IP地址
-------------------------------------------------------------------------------- especial IP Address
1. 网络地址0：作为A类地址的一部分，网络地址0并不会作为IPv4可路由地址的一部分使用。它在IPv6中表示为::/0.
当作为源地址使用时，他唯一合法的使用时机就是在初始化期间，当主机尝试获得一个由服务器动态分配的IP地址的时候。
而当作为目的地址时，只有0.0.0.0才有意义，它只存在于本地计算机并代表他自己，或按惯例代表默认路由。
2. 回环网络地址127：作为A类地址的一部分，网络地址127并不会被用作可路由地址的一部分。IPv6回环地址是0:0:0:0:0:0:0:1，
缩写为::1。回环地址指向有操作系统提供支持的一个私有的网络接口。这个接口被用于本地基于网络的服务的地址。
换言之，本地网络客户端使用该地址来寻址到本地服务器。回环网络的流量一直存在于操作系统中，它不会被传递到物理网络接口。通常
127.0.0.1是IPv4使用的唯一回环地址，而::1是IPv6使用的唯一回环地址，它们都指向本地主机。
3. 广播地址：广播地址是应用网络中所有主机的特殊网络地址。广播地址主要有两种：受限广播地址和直接广播地址。受限广播
地址不会被路由，但会被传递到同一个物理网段中连接的所有主机。IP地址的网络部分和主机部分中的所有位都被值为1，即255.255.255.255
直接广播则会被路由，它将被传递到指定网络的所有主机。其IP地址中的网络部分指定一个网络，而主机部分通常被设置为全1，例如：
255.255.255.255:受限广播地址         有限广播
192.168.10.255：直接广播地址         网络直接广播 ：鉴于多种拒绝服务功能都能够利用网络直接广播，很多路由器可能已经禁止转发这些数据包了
192.168.10.0：  网络地址
子网直接广播：指定了网络ID和子网ID。地址的主机号部分被设置为全1.不知道子网掩码就无法确定一个地址是否是子网直接广播地址。
如果路由器知道子网掩码为255.255.255.0，就会将192.50.1.255作为子网直接广播报文；
如果路由器认为子网掩码为255.255.0.0，就不会将这个地址作为广播地址处理。

单播地址 组播地址 广播地址
-------------------------------------------------------------------------------- IP Address Type
它使用组播地址来实现面向一组主机的通信。
地址类别是由前导1比特的个数标识的。A类有零个前导1比特，B类有一个，C类有两个。
将地址空间划分为不同的类别是为了提高地址使用灵活性，不浪费地址。
设计者原先认为：网络数应该是以百计的，主机数应该是以千计的。

A            0.0.0.0~127.255.255.255      10.0.0.0/8 (255.0.0.0)
B            128.0.0.0~191.255.255.255    172.16.0.0/12 (255.240.0.0)    169.254.0.0/16
C            192.0.0.0~223.255.255.255    192.168.0.0/16 (255.255.0.0)  
D            224.0.0.0~239.255.255.255    
E和未分配    240.0.0.0~255.255.255.255    

在A类地址中，127.0.0.0到127.255.255.255是保留地址，用做循环测试用的。
在A类地址中，10.0.0.0到10.255.255.255是私有地址。

在B类地址中，169.254.0.0到169.254.255.255是保留地址。如果你的IP地址是自动获取IP地址，而你在网络上又没有找到可用的DHCP服务器，
这时你将会从169.254.0.1到169.254.255.254中临时获得一个IP地址。
在B类地址中，172.16.0.0到172.31.255.255是私有地址。

在C类地址中，192.168.0.0到192.168.255.255是私有地址。


分类网络(classful subnetting)A类，B类，C类
无分类子网划分(classless subnetting)-(Classless Inter Domain Routing，CIDR)无类别域间路由选择


    有时，IP数据报的大小比他将通过的物理介质所允许的最大大小要打，这个所允许的最大大小即使最大传输单元
(Maximum Transmission Unit,MTU). 如果IP数据报大小比介质的MTU更大，这个数据报则需要在传输前被分为更小的块。
对于以太网来说，MTU是1500字节。将IP数据报分隔成更小的片的过程被称为分片。

    组播则是发送数据到属于组播组的设备，它们有些被称为订阅者(subscriber) ----
单播地址数据报文会根据MAC地址匹配将IP数据报转发给上层，而广播和主播地址转发给上层不受MAC地址限制。
    直接广播 255.255.255.255 受限广播192.168.0.255 在那些试图通过DHCP BOOTP以及其他配置协议配置自身的设备中使用。
-------------------------------------------------------------------------------- ICMP

iptables -p icmp --help
[!] --icmp-type typename        match icmp type
[!] --icmp-type type[/code]     (or numeric type or type/code)
Valid ICMP Types:
any

ICMP(){
INTERNET="eth0"         # Internet-connected interface
IPADDR=""               # your IP address
CONNECTION_TRACKING="1"
MY_ISP=""               # ISP server & NOC address range 
    当网关接收到来自所接网络主机的Internet数据报时，网关可以发送重定向信息到一台主机。
网关检查路由表获得下一个网关的地址，第二个网关将数据报路由到目标网络。
    主机重定向和网络下一跳重定向: 接收到重定向报文的设备在内核中会添加一条路由。即发往主机的
主机路由或者发往下一条的网段路由。
    
# Disable ICMP Redirect Acceptance
for f in /proc/sys/net/ipv4/conf/*/accept_redirects; do
    echo 0 > $f
done

###############################################################
# ICMP Control and Status Messages

# Log and drop initial ICMP fragments
$IPT -A INPUT  -i $INTERNET --fragment -p icmp -j LOG \
         --log-prefix "Fragmented ICMP: "

$IPT -A INPUT  -i $INTERNET --fragment -p icmp -j DROP

$IPT -A INPUT  -i $INTERNET -p icmp \
         --icmp-type source-quench -d $IPADDR -j ACCEPT

$IPT -A OUTPUT -o $INTERNET -p icmp \
         -s $IPADDR --icmp-type source-quench -j ACCEPT

$IPT -A INPUT  -i $INTERNET -p icmp \
         --icmp-type parameter-problem -d $IPADDR -j ACCEPT

$IPT -A OUTPUT -o $INTERNET -p icmp \
         -s $IPADDR --icmp-type parameter-problem -j ACCEPT

$IPT -A INPUT  -i $INTERNET -p icmp \
         --icmp-type destination-unreachable -d $IPADDR -j ACCEPT

$IPT -A OUTPUT -o $INTERNET -p icmp \
         -s $IPADDR --icmp-type fragmentation-needed -j ACCEPT

# Don’t log dropped outgoing ICMP error messages
$IPT -A OUTPUT -o $INTERNET -p icmp \
         -s $IPADDR --icmp-type destination-unreachable -j DROP

# Intermediate traceroute responses
$IPT -A INPUT  -i $INTERNET -p icmp \
         --icmp-type time-exceeded -d $IPADDR -j ACCEPT

# allow outgoing pings to anywhere
if [ "$CONNECTION_TRACKING" = "1" ]; then
    $IPT -A OUTPUT -o $INTERNET -p icmp \
             -s $IPADDR --icmp-type echo-request \
             -m state --state NEW -j ACCEPT
fi

$IPT -A OUTPUT -o $INTERNET -p icmp \
         -s $IPADDR --icmp-type echo-request -j ACCEPT

$IPT -A INPUT  -i $INTERNET -p icmp \
         --icmp-type echo-reply -d $IPADDR -j ACCEPT

# allow incoming pings from trusted hosts
if [ "$CONNECTION_TRACKING" = "1" ]; then
    $IPT -A INPUT  -i $INTERNET -p icmp \
             -s $MY_ISP --icmp-type echo-request -d $IPADDR \
             -m state --state NEW -j ACCEPT
fi

$IPT -A INPUT  -i $INTERNET -p icmp \
         -s $MY_ISP --icmp-type echo-request -d $IPADDR -j ACCEPT

$IPT -A OUTPUT -o $INTERNET -p icmp \
         -s $IPADDR --icmp-type echo-reply -d $MY_ISP -j ACCEPT

###############################################################
# Logging Dropped Packets

# Don’t log dropped incoming echo-requests
$IPT -A INPUT -i $INTERNET -p icmp \
        ! --icmp-type 8 -d $IPADDR -j LOG

$IPT -A INPUT -i $INTERNET -p tcp \
         -d $IPADDR -j LOG

$IPT -A OUTPUT -o $INTERNET -j LOG
}
类型  代码  描述
0      0     echo响应                echo-reply (pong)
3            目标不可达              destination-unreachable
       0     网络不可达              network-unreachable
       1     主机不可达              host-unreachable
       2     协议不可达              protocol-unreachable
       3     端口不可达              port-unreachable
       4     要求分段并设置DF标志    fragmentation-needed
       5     源路由失败              source-route-failed
       6     目标网络未知            network-unknown
       7     目标主机未知            host-unknown
       8     源主机隔离              network-prohibited
       9     目标网络被管理性禁止    host-prohibited
       10    目标主机被管理性禁止    TOS-network-unreachable
       11    对特定Qos网络不可达     TOS-host-unreachable
       12    对特定Qos主机不可达     communication-prohibited
       13    通信被管理性禁止        host-precedence-violation
       14    主机越权                precedence-cutoff
       15    优先终止生效            
4            源端被关闭(已弃用)      source-quench
5            重定向                  redirect
       0     网络重定向              network-redirect
       1     主机重定向              host-redirect
       2     服务类型和网络重定向    TOS-network-redirect
       3     服务类型和主机重定向    TOS-host-redirect
8      0     echo请求                echo-request (ping)
9      0     路由器通告              router-advertisement
10           路由选择                router-solicitation
11           超时                    time-exceeded (ttl-exceeded)
       0     TTL超时                 ttl-zero-during-transit
       1     分片重组超时            ttl-zero-during-reassembly
12     0     参数问题                
13     0     时间戳请求              timestamp-request
14     0     时间戳应答              timestamp-reply
15     0     信息请求(已弃用)        
16     0     信息应答(已弃用)        
17     0     地址掩码请求(已弃用)    address-mask-request
18     0     地址掩码应答(已弃用)    address-mask-reply

-------------------------------------------------------------------------------- UDP
udp match options:
[!] --source-port port[:port]
 --sport ...
                                match source port(s)
[!] --destination-port port[:port]
 --dport ...
                                match destination port(s)
UDP(){

}

-------------------------------------------------------------------------------- TCP
16 比特的窗口域提供了滑动窗口机制
16 比特的紧急指针指明了紧急数据结束处的偏移量。 可以和PSH一起使用
tcp match options:
[!] --tcp-flags mask comp       match when TCP flags & mask == comp
                                (Flags: SYN ACK FIN RST URG PSH ALL NONE)
[!] --syn                       match when only SYN flag set
                                (equivalent to --tcp-flags SYN,RST,ACK,FIN SYN)
[!] --source-port port[:port]
 --sport ...
                                match source port(s)
[!] --destination-port port[:port]
 --dport ...
                                match destination port(s)
[!] --tcp-option number        match if TCP option set
TCP(){}
URG   标明应该检查报头中的紧急指针部分
ACK   标明应该检查报头中的确认序列号部分
PSH   表示接收者应该尽快将该数据向下层传递
RST   指明应该重置连接
SYN   初始化一个连接
NE    显示拥塞通知隐蔽性保护
CWR   拥塞窗口减少标志表示数据包的ECE标志被设置，而且拥塞控制已被应答
ECE  如果SYN标志设为1，这个标志表示TCP通信的一方支持ECN。如果SYN设置为0，这个标志表示接收到的IP报头中的拥塞通知被设置。 
FIN   指明发送者(可以是连接的另一方)已经将数据发送完毕

三次握手
SYN(SYN_SENT)           客户端发起连接
SYN_ACK(SYN_RCVD)       服务器端进行相应
SYN_ACK(ESTABLISDED)    客户端发送前，连接进入ESTABLISDED；服务器端接收后，连接进入ESTABLISDED.
四次挥手
FIN(FIN_WAIT_1)  客户端发送FIN,进入FIN_WAIT_1
ACK(CLOSE_WAIT)  服务器响应ACK，服务器进入CLOSE_WAIT
FIN_WAIT_2       客户端收到ACK进入FIN_WAIT_2。
-------- 半连接 --------
FIN(LAST_ACK)    服务器发送FIN，进入LAST_ACK
TIME_WAIT        客户端进入TIME_WAIT，
CLOSED           服务器收到ACK，进入CLOSED状态

-------------------------------------------------------------------------------- stateful
    状态防火墙会跟踪一个TCP三次握手的阶段，并且会拒绝那些看上去对于三次握手来说失序的数据报。
    状态防火墙会跟踪最近的UDP报文交换以确定已经收到的某个数据报与一个近期发出的数据报相关。
    应用层网管: FTP ALG 
    SOCKS是一个链路层代理；代理服务器会扮演连接中双发的终端点的角色(既作为客户端从真实服务器处
接收数据，又扮演服务器的发送数据到真实的客户端)。但服务器并没有任何应用相关的知识。
-------------------------------------------------------------------------------- 默认防火墙策略
默认拒绝所有的消息，明确地允许选定的数据报通过防火墙，  
默认接受所有的消息，明确地拒绝选定的数据报通过防火墙，   难度更大，且总是更不安全。
DROP: 静静地丢掉数据报文通常是更好的选择，
1. 发送一个错误回应增加网络流量。大多数被丢弃的数据报被丢失是因为他们是恶意的，并不是他们只是无辜尝试访问你恰巧不能提供的服务
2. 一个你响应了的数据报文可能被用于拒绝服务攻击 (Denial-of-Service Dos)
3. 任何响应，甚至是错误消息，都会给潜在的攻击者可能有用的消息。

-------------------------------------------------------------------------------- 伪装地址攻击预防
---- 过滤输入的数据包 ----
-- 远程源地址过滤 (伪装源地址攻击预防)
1.源地址欺骗和非法地址[不论任何情况下，你的外部接口中都应该拒绝它们]
1.1 你的IP地址? DROP
1.2 你的局域网地址?  DROP
1.3 ABC类地址中的私有IP地址 10.0.0.0/8 172.16.0.0/12 192.168.0.0/16 ? DROP
1.4 D类组播IP地址 224.0.0.0~239.255.255.255 ?    DROP
1.5 E类的保留IP地址 240.0.0.0~255.255.255.255 ?  DROP
1.6 回环接口地址127.0.0.0~127.255.255.255 ?      DROP
1.7 畸形的广播地址 ?                             DROP
1.8 A类网络的0地址0.0.0.0~0.255.255.255 ?        DROP
1.9 链路本地网络地址 169.254.0.0~169.254.255.255? DROP
1.10 运营商级NAT  100.64.0.0~100.127.255.255 ? DROP
1.11 测试网络地址 192.0.2.0~192.0.2.255 ? DROP

2. 阻止问题站点: 阻止不请自来的邮件；阻止某一个国家整个范围的IP地址。
3. 限制选中的远程主机的传入数据包
3.1 传入数据包是来自于响应你请求的远程服务器
3.2 传入数据包是来自于远程客户端，它们要访问你的站点提供的服务。

-- 本地目的地址过滤  0.0.0.0 目的地址和255.255.255.255直接广播地址? DROP
-- 远程源端口过滤    无
-- 本地目的端口过滤  无
-- 传入TCP的连接状态过滤  
1. 从远程客户端传入的TCP数据包会在接收到的第一个数据包中设置SYN标志，以作为三次握手的一部分。
第一次连接请求会设置SYN标志，但不会设置ACK标志
2. 从远端服务器传入的数据包总是会回应从你本地客户端程序发起的最初的连接请求。每个从远端服务器接收的
TCP数据包都已被设置ACK标志。你的本地客户端防火墙规则将要求所有从远程服务器传入的数据包设置ACK标志。
服务器通常不会尝试向客户端发起连接。
-------------------------------------------------------------------------------- 探测扫描
---- 探测扫描
1. 常规端口扫描 nmap -sS 192.168.10.117 -vv -dd
2. 定向端口扫描 nmap -O -sSU 192.168.10.117 -vv -dd
3. 常用服务端口目标: 保留端口0总是伪造的；TCP 0～5 是端口扫描工具的标志， ssh smtp dns pop-3 imap snmp是最受欢迎的目标端口
4. 隐形扫面 RST响应(UDP和TCP在内核中，接收到未监听的端口返回RST数据报文)

-------------------------------------------------------------------------------- 拒绝服务攻击
---- 拒绝服务攻击: 用数据报淹没你的系统，以打扰或严重地使你的互联网连接降级，捆绑本地服务器已导致合法请求不能被响应。
或更严重地，是你的系统一起崩溃。
1. TCP SYN泛洪(SYN Flood)  
  源地址过滤;  
  echo 1 > /proc/sys/net/ipv4/tcp_syncookies 队列被填满时，系统开始使用SYN cookies而非SYN-ACK来应答SYN请求。cookies超时时间很短。
  cookie是一个基于SYN中的原始序列号、源地址、目的地址、端口号、密值而产生的序列号。如果对此cookies的响应与哈希算法
  的结果匹配，服务器便可以合理地确信这个SYN是合法的。
2. ping 洪泛  (ping Flood)               ping数据报很多
   死亡之ping (发送非常大的ping数据包)   ping数据报内数据量很大
3. UDP 洪泛   (UDP Flood)
4. 分片炸弹   (fragmentation bombs)
5. 缓冲区溢出  (buffer overflow)
6. ICMP路由重定向炸弹 (ICMP routing redirect bomb) 重定向消息类型5会告知目标系统改变内存中的路由表以获得更短的路由。

-------------------------------------------------------------------------------- 过滤输出的数据包
---- 过滤输出的数据包 ----
1. 本地源地址过滤       限制传出数据报包含防火墙计算机源地址的行为是强制性的。很多情况是配置错误
2. 远程目的地址过滤     
3. 本地源端口过滤       
4. 远程目的端口过滤     
5. 传出TCP连接状态过滤  

iptables <option> <chain> <matching criteria> <target>
iptables -p tcp|udp|icmp -h   协议过滤条件
iptables -m addrtype  -h      有状态过滤条件
iptables -j TRACE -h          目标操作
-------------------------------------------------------------------------------- filter 表功能(ip_tabls 模块提供)
功能
1. 对三个内置规则链 INPUT OUTPUT FORWARD 和用户自定义规则链的操作
2. 帮助
3. 目标处置 (接收ACCEPT或丢弃DROP)
4. 对IP报文协议域，源地址和目的地址，输入和输出接口，以及分片处理的匹配操作
5. TCP、UDP、ICMP报头字段的匹配操作

有两种扩展功能
1. 目标扩展
目标扩展包括 REJECT 数据报处理 BALANCE MIRROR TEE IDLETIMER AUDIT CLASSIFY CLUSTERIP 目标; 以及CONNMARK TRACE LOG ULOG
2. 匹配扩展
当前的连接状态
端口列表(由多端口模块支持)
硬件以太网MAC源地址或网络设备
地址类型，链路层数据报类型和IP地址范围
IPSec数据报的各个部分或IPSec策略
ICMP类型
数据报的长度
数据报的达到时间
每第n个数据报或随机的数据报。
数据报发送者的用户、组、进程或进程组ID
IP包头的服务类型TOS字段(由mangle表设置)
IP包头的TTL部分
iptables mark字段(由mangle表设置)
限制频率的数据报匹配。

matching(){  iptables -m addrtype  -h
当前连接状态
端口列表(由多端口模块支持)
硬件以太网MAC源地址或物理设备
地址类型，链路层数据包类型或IP地址范围
IPsec数据包的各个部分或IPsec策略
ICMP类型
数据包长度
数据包的到达时间
每第n个数据包或随机的数据包数据包发送者的用户、组、进程或进程组
IP报头的服务类型字段
IP报头的TTL部分
iptables mark字段
限制频率的数据包匹配

匹配能够在IPSec报头的各个部分上进行，包括包头认证AH的安全参数指标SPIs和封装安全负载
Authentication Header AH
security paramter indices SPIs
Encapsulating Security Payload ESP

随机数据报匹配在iptables 特别有用，很适合于审计。通过这个匹配，可以捕捉每n个数据报并对其记录日志。

数据报的长度和数据达到的时间也是一个有效匹配。通过时间匹配，你能够配置防火墙"在营业时间外驳回特定的流量"
或"只在一天的特定时间里允许该流量"。
}

filter(){ iptables -j TRACE -h
DROP
ACCEPT
REJECT
BALANCE
MIRROR
TEE
IDLETIMER
AUDIT
CLASSIFY
CLUSTERIP
CONNMARK
TRACE
LOG
ULOG
}
-------------------------------------------------------------------------------- mangle 表功能
    mangle表有两个目标扩展，MARK模块支持为iptables维护的数据报的mark域分配一个值。
TOS模块则支持设置IP包头中TOS字段的值。
    mangle表允许对数据报进行标记marking或将由netfilter维护的值与数据报进行关联，以及在
发送数据包到目的地址前进行修改。

PREROUTING，POSTROUTING，INPUT，OUTPUT，FORWARD
-------------------------------------------------------------------------------- nat 表功能
nat(){
nat表用于源地址和目的地址转换以及端口转换的目标扩展模块，
SNAT: 源NAT
DNAT: 目的NAT
MASQUERADE: 源NAT的一种特殊形式，用于被分配了临时的、可改变的、动态分配IP地址的连接。
REDIRECT: 目的NAT的一种特殊形式，重定向数据报到本机主机，而不考虑IP头部的目的地址域。

基本的NAT：仅转换地址                                                          本地私有源地址到一批公网地址中某一地址映射
NAPT：     网络地址和端口转换                                                  本地私有源地址到单个公网地址的映射
双向NAT：  双向的地址转换同时允许传入和传出连接。                              IPv4和IPv6进行双向地址映射
两次NAT：  双向的源和目的地址转换同时允许传入和传出连接。两次NAT能够在源和目的网络地址空间冲突时使用。
PREROUTING:DNAT ipmasqadm 和均分负载。
           规则链在将数据报传递到路由功能前，修改传入数据报的目的地址DNAT，目的地址可以更改为本地主机(透明代理、端口重定向)
或用于主机转发的其他主机(Linux中ipmasqadm功能、端口转发)或均分负载。
OUTPUT：   DNAT和REDIRECT
           规则链在做出路由决定(DNAT REDIRECT)前本地产生的传出数据报指定目的地更改，
POSTROUTING：SNAT和MASQUERADE
}
PREROUTING:DNAT | REDIRECT
OUTPUT：   DNAT | REDIRECT
POSTROUTING：SNAT和MASQUERADE

-------------------------------------------------------------------------------- C5 -> 组织规则 state模块的使用和用户自定义规则链
## C5 -> 组织规则 state模块的使用和用户自定义规则链
1. 从阻止高位端口流量的规则开始
2. 使用状态模块进行 ESTABLISHED 和 RELATED 匹配: 本质上是将用于正在进行的交换的规则移动到规则链的前端。
3. 考虑传输层协议
3.1 TCP服务:绕过欺骗规则
3.2 UDP服务:将传入数据包规则放在欺骗规则之后
3.3 TCP服务与UDP服务: 将UDP规则放在TCP规则之后
3.4 ICMP服务: 将ICMp规则放在规则链的后端
# 外部链
tcp-state-flags:     包含检测非法TCP状态标识组合的规则
connection-tracking  包含检测状态相关(INVALID ESTABLISHED 和 RELATED) 匹配的规则
source-address-check 包含检测非法源地址的规则
destination-address-check 包哈检测非法目的地址的规则
EXT-input 包含用于INPUT规则链的特定接口的用户自定义规则链，在该例中，主机拥有一个连接到互联网的接口。
EXT-output 包含用于OUTPUT规则的特定接口的用户自定义的规则链，在该例中，主机拥有一个连接到互联网的接口
local-dns-server-query 包含检测从本地DNS服务器或本地客户端传出的查询的规则
remote-dns-server-response 包含检测到从远端DNS服务器传入的响应的规则
local-tcp-client-request  包含检测传出TCP连接请求和由本地产生发往远端服务器的客户端流量的规则
remote-tcp-server-response 包含检测从远端TCP服务器传入的响应的规则
remote-tcp-client-request 包含检测传入的TCP连接请求和远端发生的发往本地服务器的客户端流量的规则
local-tcp-server-response 包含检测发往远端客户端的传出响应的规则
local-udp-client-request 包含检测发往远程客户端的传出UDP客户端流量的规则
remote-udp-server-response 包含检测来自远程UDP服务器的传入响应的规则
local-dhcp-client-query      包含检测DHCP客户端的传出数据报的规则
remote-dhcp-server-response  包含检测来自主机的DHCP服务器的传入数据包的规则
EXT-icmp-out  包含检测传出ICMP数据包的规则
EXT-icmp-in   包含检测传入ICMP数据报的规则
EXT-log-in    包含在传入数据报被INPUT的默认策略丢弃之前，对其记录的规则
EXT-log-out   包含在传出数据包被OUTPUT的默认策略丢弃之前，对其记录的规则
log-tcp-state 包含在具有非法状态标志组合的TCP数据报被丢弃之前，对其记录的规则

# 安装规则链 -> 同一规则链可以从多个规则链进行引用
# 1. 检测非法TCP状态组合
$IPT -A INPUT  -p tcp -j tcp-state-flags
$IPT -A OUTPUT -p tcp -j tcp-state-flags

# 2. 状态模块
if [ "$CONNECTION_TRACKING" = "1" ]; then
    # By-pass the firewall filters for established exchanges
    $IPT -A INPUT  -j connection-tracking
    $IPT -A OUTPUT -j connection-tracking
fi

# 3. DHCP客户端
if [ "$DHCP_CLIENT" = "1" ]; then
    $IPT -A INPUT  -i $INTERNET -p udp \
             --sport 67 --dport 68 -j remote-dhcp-server-response
    $IPT -A OUTPUT -o $INTERNET -p udp \
             --sport 68 --dport 67 -j local-dhcp-client-query
fi

# 4. 非法源地址和目的地址
$IPT -A INPUT  ! -p tcp -j source-address-check
$IPT -A INPUT  -p tcp --syn -j source-address-check
$IPT -A INPUT  -j destination-address-check

$IPT -A OUTPUT -j destination-address-check

# 5. 任何未被EXT-input规则链匹配的传入数据包将返回这里被记录或丢弃
$IPT -A INPUT -i $INTERNET -d $IPADDR -j EXT-input

# 6. 组播地址丢弃 或 接收
$IPT -A INPUT  -i $INTERNET -p udp -d $CLASS_D_MULTICAST -j DROP 
$IPT -A OUTPUT -o $INTERNET -p udp -s $IPADDR -d $CLASS_D_MULTICAST -j DROP 
$IPT -A INPUT  -i $INTERNET -p udp -d $CLASS_D_MULTICAST -j ACCEPT 
$IPT -A OUTPUT -o $INTERNET -p udp -s $IPADDR -d $CLASS_D_MULTICAST -j ACCEPT 

# 7. 外出数据报链
$IPT -A OUTPUT -o $INTERNET -s $IPADDR -j EXT-output

# 8. 记录会在最后进行
$IPT -A INPUT  -j EXT-log-in
$IPT -A OUTPUT -j EXT-log-out

-------------------------------------------------------------------------------- DMZ
    DMZ 网络防御带另外的一个名字
    两个防火墙之间的网络防御带成为非军事化区域。DMZ的目的是要在其中建立一个保护区来运行
公网服务器(或服务)，并将这个区域同私有局域网的剩余部分相隔离。如果DMZ中的一个服务器被入侵了。
哪个服务器同局域网依然是相互分离的；运行于其他DMZ服务器的网管防火墙和堡垒防火墙提供对被入侵
服务器的保护。


# Common definitions
INTERNET="eth0"                         # Internet-connected interface
LAN_INTERFACE="eth1"                    # LAN-connected interface
EXTERNAL_INTERFACE="eth0"               # External interface
LAN_ADDRESSES="192.168.1.0/24"             # Private Network

# 转发策略 && 转发也需要INPUT 和 OUTPUT
# FORWARD rules
$IPT -A FORWARD -i $LAN_INTERFACE -o $EXTERNAL_INTERFACE \
        -p tcp -s $LAN_ADDRESSES --sport $UNPRIVPORTS \
        -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT

$IPT -A FORWARD -i $EXTERNAL_INTERFACE -o $LAN_INTERFACE \
        -p tcp -d $LAN_ADDRESSES --dport $UNPRIVPORTS \
        -m state --state ESTABLISHED,RELATED -j ACCEPT

$IPT -A LAN-input -p tcp -s $LAN_ADDRESSES --sport $UNPRIVPORTS \
        -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT

$IPT -A LAN-output -p tcp -d $LAN_ADDRESSES --dport $UNPRIVPORTS \
        -m state --state ESTABLISHED,RELATED -j ACCEPT

DMZ_INTERFACE="eth1"                    # LAN-connected interface
DMZ_ADDRESSES="192.168.3.0/24"          # Private Network
# FORWARD rules
$IPT -A FORWARD -i $EXTERNAL_INTERFACE -o $DMZ_INTERFACE \
        -d $DMZ_ADDRESSES \
        -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT

$IPT -A FORWARD -i $DMZ_INTERFACE -o $EXTERNAL_INTERFACE \
        -s $DMZ_ADDRESSES \
        -m state --state ESTABLISHED,RELATED -j ACCEPT

$IPT -A FORWARD -i $DMZ_INTERFACE -o $EXTERNAL_INTERFACE \
        -s $LAN_ADDRESSES \
        -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT

$IPT -A FORWARD -i $EXTERNAL_INTERFACE -o $DMZ_INTERFACE \
        -d $LAN_ADDRESSES \
-m state --state ESTABLISHED,RELATED -j ACCEPT

-------------------------------------------------------------------------------- NAT

-------------------------------------------------------------------------------- 虚拟专用网络
VPN: 1 点对点隧道协议 Poinit-to-Point Tunneling Protocol
     2 二层隧道协议   Layer 2 Tunneling Protocol
     3 IP安全协议 IP Security
1.1 GRE: 通用路由封装的方式封装非TCP/IP协议以通过互联网
2.1 PPTP和L2TP 
3.1 IPSec
鉴别首部AH
封装安全载荷ESP

Openswan/libreswan
OpenVPN
PPTP


chkrootkit
swatch

-------------------------------------------------------------------------------- 防火墙的分类
firewall(防火墙的分类){
(1).从特点上分类
第一种，软件防火墙,软件防火墙需要运行在特定的计算机上,而且需要计算机的操作系统的支持。
第二种，硬件防火墙,硬件防火墙其实就是一个普通pc机的架构,然后上面跑有专门的操作系统。
第三种，芯片级的防火墙,这种防火墙基于专门的硬件平台,没有操作系统,专有的ASIC芯片使它们比其他类的
        防火墙速度更快,处理能力极强,性能更高,但是价格却极其昂贵。
(2).从技术上分类
第一种，包过滤型防火墙,这类的防火墙主要是工作在网络层,根据事先设定好的规则进行检查,检查结果根据事先
        设定好的处理机制进行处理。
第二种，应用层防火墙,它是工作在TCP/IP模型中的最高层应用层,相比较来说速度要慢一点。
第三种，状态监视器,状态监视做为防火墙其安全性为最佳,但配置比较复杂,且网络速度较慢。
三、防火墙在企业中的部署
(1). 单宿主堡垒主机：是单台服务器有防火墙,只为单台服务器防护。
(2). 双宿主堡垒主机：双宿主堡垒主机是一台装有两块网卡的堡垒主机,一般这台堡垒主机应用在网关,防护局域网
     跟广域网之间通信等安全。
(3).三宿主堡垒主机：三宿主堡垒主机是一台装有三块网卡的堡垒主机,那么他将外网,内网,DMZ 三个区域隔离开来,
    同时保护内网已经DMZ区域的安全等。
(4).背靠背型，如下图：不用解释一看图就知道是怎么回事了,实际上前端防火墙是防护外网到DMZ区域以及到内网,
    后端防火墙是防护内网到DMZ区域的安全。好了说了这么多，下面我们说说iptables在linux中的应用！
}

iptables(main){
1.规则管理
iptables -A    添加一条新规则
iptables -I    插入一条新规则 -I 后面加一数字表示插入到哪行
iptables -D    删除一条新规则 -D 后面加一数字表示删除哪行
iptables -R    替换一条新规则 -R 后面加一数字表示替换哪行

2.链管理
iptables -F    清空链中的所有规则
iptables -N    新建一个链
iptables -X    删除一个自定义链,删除之前要保证次链是空的,而且没有被引用
iptables -E    重命名链
3.默认规则管理

iptables -P    设置默认规则
4.查看
iptables -L    查看规则 –L 还有几个子选项如下
iptables -L -n 以数字的方式显示
iptables -L -v 显示详细信息
iptables -L -x 显示精确信息
iptables -L --line-numbers 显示行号
}

conntrack(){
iptables模块关系：
1、modprobe ip_tables
当 iptables 对 filter、nat、mangle 任意一个表进行操作的时候，会自动加载 ip_tables 模块
另外，iptable_filter、iptable_nat、iptable_mangle 模块也会自动加载。

2、modprobe ip_conntrack
ip_conntrack 是状态检测机制，state 模块要用到
当 iptables -A INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT 时，ip_conntrack 自动加载。

3、modprobe ip_conntrack_ftp
ip_conntrack_ftp 是本机做 FTP 时用的。
ip_nat_ftp 是通过本机的 FTP 需要用到的(若你的系统不需要路由转发，没必要用这个)
当 modprobe ip_nat_ftp 时，系统自动会加载 ip_conntrack_ftp 模块。
}