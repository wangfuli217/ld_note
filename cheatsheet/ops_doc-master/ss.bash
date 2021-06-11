cat - <<'EOL'
    ss 具有扩展功能，计时器信息(-o)，sock详细信息(-e), 内存信息(-m)，进程信息(-p) tcp内部状态(-i) 上下文信息(-z|-Z)
    ss 具有基本过滤功能: -t, --tcp; -u, --udp; -S, --sctp; -d, --dccp; -0, --packet; -x, --unix. 
    ss 具有扩展过滤功能: 1. 基于 收发方向，主机名(网段)和端口(端口段)名进行过滤。
                         2. 基于 tcp 状态进行的过滤  -o state established... [ss_t_state]
                         3. 具有基本的操作符判断和与或操作 le ge eq ne gt lt 和 and or not
    ss 是在扩展 和 过滤之间的折中。扩展功能使得ss可以查看socket外部关联，过滤功能使ss精确定位指定协议和指定连接。
依赖:tcp_diag

1. 扩展功能: 定时器，socket，收发队列和关联进程信息; -> ss更强大
timer:(keepalive,103min,0)                              -o：显示计时器信息           [ss_t_timer]
timer:(on,233ms,0)                                      -o：显示计时器信息
ino:236508 sk:ffff9479b5b44000                          -e：扩展信息
skmem:(r0,rb495264,t0,tb87040,f0,w0,o0,bl0,d0)          -m：显示套接字的内存使用情况 [ss_t_memory]
users:(("sshd",pid=28959,fd=3),("sshd",pid=28957,fd=3)) -p：显示使用套接字的进程信息 [ss_t_process]
                                                        -i：显示内部的TCP信息        [ss_t_information]
cubic wscale:8,7 rto:234 rtt:34/12.75 ato:40 mss:1460 cwnd:10 send 3.4Mbps lastsnd:2 lastrcv:6 lastack:6 unacked:1 rcv_space:14600

2. 扩展过滤功能: 方向地址和端口 [ss_t_filter_host_port]
dst prefix:port 
src prefix:port
src unix:STRING
src link:protocol:ifindex
src nl:channel:pid

3. 扩展过滤功能: 连接状态过滤 [ss_t_filter_state] [ss_t_state]
ss -o state established '(dport  =: smtp  or  sport  = : smtp)'
ss -o state established state time-wait
ss -o state fin-wait-1 \( sport = :http or sport = :https \) dst 193.233.7/24
ss state fin-wait-1 \( sport neq :http and sport neq :https \) or not dst 193.233.7/24

4. 扩展过滤功能: 操作符判断和异或非 [ss_t_filter_operator]
<OP>:               逻辑操作符(OP) 有
<=  or  le          and
>=  or  ge          or
==  or  eq          not
!=  or  ne
<   or  gt
>   or  lt
5. 支持协议
  -f FAMILY, --family=FAMILY           all, tcp, udp, raw, unix, inet, inet6, link, netlink.packet, unix_dgram
  -A QUERY, --query=QUERY, --socket=QUERY 
     QUERY := {all|inet|tcp|udp|raw|unix|unix_dgram|unix_stream|unix_seqpacket|packet|netlink}[,QUERY]
https://www.cyberciti.biz/files/ss.html
ss -tmpie # 性能跟踪
EOL
ss_h_idea(){ cat - <<'EOL'
ss 用于转储套接字统计信息。它能够展示类似于netstat的信息。还可以查看比其他工具更多的TCP和状态信息。

显示PACKET sockets, TCP sockets, UDP sockets, DCCP sockets, RAW sockets, Unix domain sockets等等统计
实用、快速、有效的跟踪IP连接和sockets的新工具
    ss -o state established '( dport = :ssh or sport = :ssh )' -t  
    
ss 显示处于活动状态的套按字信息,比netstat快速高效
  -h：显示帮助信息；                   --help
  -V：显示指令版本信息；               --version
  -H: 不显示标题头                     --no-header
1. IP地址和端口反解析                  
  -n：不解析服务名称，以数字方式显示； --numeric
  -r: 尽力解析数字的IP地址和端口名     --resolve
2. listen 和 non-listen                
  -a：显示所有的套接字；               --all         同时显示侦听和非侦听(对于TCP, 这意味着建立连接)套接字。
  -l：显示处于监听状态的套接字；       --listening
3. 扩展信息                            
  -e：展示uid,ino,skb                  --extended            ss_t_extended
  -o：显示计时器信息；                 --options             ss_t_timer
  -m：显示套接字的内存使用情况；       --memory              ss_t_memory
  -p：显示使用套接字的进程信息；       --processes           ss_t_processes
  -i：显示内部的TCP信息；              --info                ss_t_information
  -z: 进程安全上下文                   --context (SELinux)   ss_t_context
  -Z:
  -K, 关闭的套接字。仅支持IPv4和IPv6。 --kill        尝试强制关闭套接字。显示成功关闭的套接字, 静默跳过内核不支持
  -b, 显示套接字BPF过滤器              --bpf         (仅管理员能够获取这些信息)
    
4. 协议选择                            
  -4：只显示ipv4的套接字；             --ipv4        -f inet
  -6：只显示ipv6的套接字；             --ipv6        -f inet6
  -0：packet sockets                   --packet      -f link
  -t：只显示tcp套接字；                
  -u：只显示udp套接字；                
  -d：只显示DCCP套接字；               
  -w：仅显示RAW套接字；                
  -x：仅显示UNIX域套接字。             
  -s: 显示socket摘要信息               --summary     当套接字的数量过于庞大以至于解析/proc/net/tcp很困难时, 这是很有用的。
  -N NSNAME, 指定网络名空间            --net=NSNAME 
  -f FAMILY, --family=FAMILY           显示制定类型FAMILY的套接字
                                       all, tcp, udp, raw, unix, inet, inet6, link, netlink.packet, unix_dgram
  -A QUERY, --query=QUERY, --socket=QUERY  待转储的套接字列表, 以逗号分隔
     QUERY := {all|inet|tcp|udp|raw|unix|unix_dgram|unix_stream|unix_seqpacket|packet|netlink}[,QUERY]
  -D FILE, --diag=FILE
    不显示任何信息, 在应用过滤器后, 仅将TCP套接字的原始信息转储至FILE。如果FILE是"-", 则是指使用标准输出(stdout)。
  -F FILE, --filter=FILE
    从FILE中读取过滤器信息。FILE中的每一行都被解释为单个命令行选项。如果FILE是"-", 则是指使用标准输入(stdin)。
  
  FILTER := [ state STATE-FILTER] [ EXPRESSION ] 有关过滤器的详细信息, 请查看官方文档。
5. 过滤
ss -4 state FILTER-NAME-HERE 
ss -6 state FILTER-NAME-HERE 
说明： FILTER-NAME-HERE 可以代表以下任何一个：
FILTER := [ state STATE-FILTER ] [ EXPRESSION ]
tcp-state:      established, 
                syn-sent, 
                syn-recv,  
                fin-wait-1,  
                fin-wait-2,  
                time-wait,  
                closed,  
                close-wait, 
                last-ack, 
                listen and closing.
all             所有以上状态
connected       除了listen and closed的所有状态
synchronized    所有已连接的状态除了syn-sent
bucket          显示状态为maintained as minisockets,如：time-wait和syn-recv.
big : 和bucket相反.
6. 重定向
   -D, --diag=FILE     Dump raw information about TCP sockets to FILE 
EOL
}

ss_i_idea(){ cat - <<'EOL'
ss的优势在于它能够显示更多更详细的有关TCP和连接状态的信息，而且比netstat更快速更高效。
1）当服务器的socket连接数量变得非常大时，无论是使用netstat命令还是直接cat /proc/net/tcp，执行速度都会很慢。
可能你不会有切身的感受，但请相信我，当服务器维持的连接达到上万个的时候，使用netstat等于浪费 生命，而用ss才是节省时间。
2）而ss快的秘诀在于它利用到了TCP协议栈中tcp_diag。tcp_diag是一个用于分析统计的模块，可以获得Linux内核中第一手的信息，
这就确保了ss的快捷高效。当然，如果你的系统中没有tcp_diag，ss也可以正常运行，只是效率会变得稍慢(但仍然比 netstat要快)。

yum install iproute iproute-doc 
cat /proc/net/nf_conntrack
conntrack -L
EOL
}

ss_i_netstat(){ cat - <<'EOL'
time netstat -ant | grep EST | wc -l   性能比较
time ss -o state established | wc -l   性能比较
netstat是遍历/proc下面每个PID目录，ss直接读/proc/net下面的统计信息。所以ss执行的时候消耗资源以及消耗的时间都比netstat少很多

netstat - Print network connections, routing tables, interface statistics, masquerade connections, and multicast memberships
1. Print network connections@(ss) # -e或--extend 显示网络其他相关信息
netstat [address_family_options] [--tcp|-t] [--udp|-u] [--udplite|-U] [--sctp|-S] [--raw|-w] [--l2cap|-2] [--rfcomm|-f] [--listening|-l] [--all|-a] [--numeric|-n]
       [--numeric-hosts] [--numeric-ports] [--numeric-users] [--symbolic|-N] [--extend|-e[--extend|-e]]  [--timers|-o]  [--program|-p]  [--verbose|-v]  [--continuous|-c]
       [--wide|-W]
2. routing tables           @(ip route)     netstat -r # -C或--cache 显示路由器配置的快取信息, -F或--fib 显示FIB
netstat  {--route|-r}  [address_family_options]  [--extend|-e[--extend|-e]]  [--verbose|-v]  [--numeric|-n]  [--numeric-hosts] [--numeric-ports] [--numeric-users]
    [--continuous|-c]
3. interface statistics     @(ip -s link)   netstat -i #  -i或--interfaces 显示网络界面信息表单
netstat {--interfaces|-i} [--all|-a] [--extend|-e[--extend|-e]] [--verbose|-v] [--program|-p] [--numeric|-n] [--numeric-hosts] [--numeric-ports] [--numeric-users]
       [--continuous|-c]
netstat {--statistics|-s} [--tcp|-t] [--udp|-u] [--udplite|-U] [--sctp|-S] [--raw|-w]
4. multicast memberships    @(ip maddr)     netstat -g # -g或--groups 显示多重广播功能群组组员名单
netstat {--groups|-g} [--numeric|-n] [--numeric-hosts] [--numeric-ports] [--numeric-users] [--continuous|-c]
# -M或--masquerade 显示伪装的网络连线
netstat {--masquerade|-M} [--extend|-e] [--numeric|-n] [--numeric-hosts] [--numeric-ports] [--numeric-users] [--continuous|-c]


usage: netstat [-veenNcCF] [<Af>] -r         netstat {-V|--version|-h|--help}
       netstat [-vnNcaeol] [<Socket> ...]
       netstat { [-veenNac] -I[<Iface>] | [-veenNac] -i | [-cnNe] -M | -s } [delay]
       
object:   -r 路由表 -i|-I 接口表 -g 组播关系表 -s 统计信息  -M masqueraded连接表
显示内容: resolve地址和端口解析， -e扩展信息 -p进程信息 -c不间断现实
扩展内容: 监听与主动连接，定时器，fib, cache 

netstat -nte
EOL
}
ss_i_netstat_compact_ss(){  cat - <<'EOL' 
[tcp]
    Proto 套接字使用的协议（tcp，udp，raw）。
    Recv-Q 连接到此套接字的用户程序未复制(未处理)的字节数。
    Send-Q 远程主机未确认的字节数。
    Local Address 套接字本地端的地址和端口号。(默认会解析地址和端口)
    Foreign Address 套接字远端的地址和端口号。类似于“本地地址”。
    State 套接字的状态。由于在raw模式下没有状态，并且通常UDP中没有使用状态，因此该列可以留空。可以是以下几个值之一：
        ESTABLISHED 套接字已建立连接。
        SYN_SENT 套接字正在主动尝试建立连接.
        SYN_RECV 已从网络接收连接请求。
        FIN_WAIT1 套接字已关闭，连接正在半关闭（shutdown）。
        FIN_WAIT2 连接已关闭，套接字正在等待远端半关闭（shutdown）。
        TIME_WAIT 套接字在关闭后等待以处理仍在网络中的数据包。
        CLOSE 套接字没有被使用
        CLOSE_WAIT 远端已半关闭，等待套接字关闭。
        LAST_ACK 远端已半关闭，并且套接字已关闭。等待ack。
        LISTEN 套接字正在侦听传入连接。除非指定-l或-a选项，否则此类套接字不包含在输出中。
        CLOSING 两个套接字都半关闭了，但我们仍然没有发送所有数据。
        UNKNOWN 套接字的状态未知。
    User 套接字所有者的用户名或用户ID（UID）.
    PID/Program name 斜杠分隔的进程ID（PID）和拥有套接字的进程的进程名称。--program导致包含此列。 您还需要超级用户权限 查看您不拥有的套接字的此信息。 此标识信息尚不可用于IPX套接字。

[UNIX]
    Proto 套接字使用的协议（通常是unix）。
    RefCnt 引用计数（即通过此套接字附加的进程）。
    Flags 显示的标志是SO_ACCEPTON（显示为ACC）, SO_WAITDATA (W) 或 SO_NOSPACE (N)。
    如果相应的进程正在等待连接请求，则SO_ACCECPTON用于未连接的套接字。其他标志正常情况下不感兴趣。
    Type 有几种类型的套接字访问：
        SOCK_DGRAM 套接字用于数据报（无连接）模式。
        SOCK_STREAM 这是一个流（连接）套接字.
        SOCK_RAW 套接字用作原始套接字。
        SOCK_RDM 这个提供可靠传递的消息。
        SOCK_SEQPACKET 这是一个顺序数据包套接字。
        SOCK_PACKET 原始接口访问套接字。
        UNKNOWN 谁知道未来会给我们带来什么
    State 该字段将包含以下关键字之一：
        FREE 套接字未分配
        LISTENING 套接字正在侦听连接请求。只有指定-l或-a选项，此类套接字才包含在输出中。
        CONNECTING 套接字即将建立连接。
        CONNECTED 套接字已连接。
        DISCONNECTING 套接字正在断开连接。
        (empty) 套接字未连接到另一个套接字。
        UNKNOWN 这种状态永远不会发生。
    PID/Program name 进程ID（PID）和打开套接字的进程的进程名称。
    Path 这是附加到套接字的相应进程的路径名。
EOL
}
ss_t_netstat_compact_ss(){  cat - <<'EOL' 
[端口过滤]
netstat -a|grep 6379
[进程过滤]
netstat -ap|grep 6379
[协议过滤]
netstat -at
netstat -au
[客户都vs服务器方式过滤]
netstat -l
[tcp连接状态过滤]
netstat -anp |grep ESTAB
[不解析主机，端口]
netstat -anp
[持续输出连接信息]
netstat -npc
[inode]
netstat -ent
[连接相关的定时器]
netstat -nto
keepalive (18.69/0/0)  keepalive的时间计时
on (19.97/7/0)         on 重发的时间计时
keepalive (34.76/0/0)  keepalive的时间计时
timewait (6.70/0/0)    timewait 等待时间计时
off (0.00/0/0)         off 没有时间计时
[统计信息]
netstat -s(statistics)

netstat -lepunt
EOL
}

ss_t_netstat_compact_link(){  cat - <<'EOL'
netstat -i
ip -s link 

netstat --interfaces=eth0
ip -s link show dev eth0
EOL
}


ss_t_netstat_compact_route(){  cat - <<'EOL'
netstat -r
ip r
route
EOL
}

ss_t_netstat_network(){ cat - <<'EOL' 
@ ss
查看所有tcp监听端口：               netstat -tnlp
查看所有udp|tcp监听端口：           netstat -tunlp
查看所有已经建立的连接：            netstat -antp
查看连接某服务端口最多的的IP地址：  netstat -nat | grep ':80' | awk '{print $5}' | awk -F: '{print $1}' | sort | uniq -c | sort -nr | head -20
网络连接数目：                      netstat -an | grep -E "^(tcp)" | cut -c 68- | sort | uniq -c | sort -n
按状态查看连接连接数量：            netstat -an |awk '/^tcp/{++S[$NF]}END{for(a in S) print a,S[a]}'或netstat -nat|awk '{print $6}'|sort|uniq -c|sort -rn
按IP查看连接数量：                  netstat -ntu | awk '{print $5}' | cut -d: -f1 | sort | uniq -c | sort -n或netstat -antu | awk '$5 ~ /[0-9]:/{split($5, a, ":"); ips[a[1]]++} END {for (ip in ips) print ips[ip], ip | "sort -k1 -nr"}'
查看80端口的连接，并排序：          netstat -an -t | grep ':80' | grep ESTABLISHED | awk '{printf "%s %s\n",$5,$6}' | sort
查看当前的memcache连接：            netstat -n | grep :11211
查看占用端口8080的进程：            netstat -tnlp | grep 8080或lsof -i:8080
查看所有php进程：                   netstat -anp | grep php | grep ^tcp
查看所有nginx进程：                 netstat -anp | grep nginx | grep ^tcp
查看80端口连接数最多的20个IP：      netstat -anlp|grep 80|grep tcp|awk '{print $5}'|awk -F: '{print $1}'|sort|uniq -c|sort -nr|head -n20
查找较多time_wait连接：             netstat -n| grep TIME_WAIT|awk '{print $5}'|sort|uniq -c|sort -rn|head -n20
找查较多的SYN连接：                 netstat -an | grep SYN | awk '{print $5}' | awk -F: '{print $1}' | sort | uniq -c | sort -nr | more
输出正在占用UDP和TCP端口的所有程序连带计时器信息：netstat -putona：
查看指定IP的连接：                  netstat -nat | grep "192.168.1.222"：
EOL
}

ss_t_netstat_route(){ cat - <<'EOL'
@ ip route # netstat -r

EOL
}

ss_t_netstat_interface(){ cat - <<'EOL'
@ ip -s link # netstat -i
查看网接口统计                      netstat -i

EOL
}

ss_t_netstat_statistics(){ cat - <<'EOL'
查看网络统计信息                    netstat -s

EOL
}

ss_t_netstat_multicast(){ cat - <<'EOL'
@ netstat -g # ip maddr

EOL
}

ss_t_state(){ cat - <<'EOL'
tcp 11种状态
netstat -n | awk '/^tcp/ {++S[$NF]} END {for(a in S) print a, S[a]}'
CLOSED         初始(无连接)状态。
LISTEN         侦听状态，等待远程机器的连接请求。
SYN_SEND       在TCP三次握手期间，主动连接端发送了SYN包后，进入SYN_SEND状态，等待对方的ACK包。
SYN_RECV       在TCP三次握手期间，主动连接端收到SYN包后，进入SYN_RECV状态。
ESTABLISHED    完成TCP三次握手后，主动连接端进入ESTABLISHED状态。此时，TCP连接已经建立，可以进行通信。
FIN_WAIT_1     在TCP四次挥手时，主动关闭端发送FIN包后，进入FIN_WAIT_1状态。
FIN_WAIT_2     在TCP四次挥手时，主动关闭端收到ACK包后，进入FIN_WAIT_2状态。
TIME_WAIT      在TCP四次挥手时，主动关闭端发送了ACK包之后，进入TIME_WAIT状态，等待最多MSL时间，让被动关闭端收到ACK包。
CLOSING        在TCP四次挥手期间，主动关闭端发送了FIN包后，没有收到对应的ACK包，却收到对方的FIN包，此时，进入CLOSING状态。
CLOSE_WAIT     在TCP四次挥手期间，被动关闭端收到FIN包后，进入CLOSE_WAIT状态。
LAST_ACK       在TCP四次挥手时，被动关闭端发送FIN包后，进入LAST_ACK状态，等待对方的ACK包。
 
主动连接端可能的状态有：    CLOSED        SYN_SEND        ESTABLISHED
主动关闭端可能的状态有：    FIN_WAIT_1    FIN_WAIT_2      TIME_WAIT
被动连接端可能的状态有：    LISTEN        SYN_RECV        ESTABLISHED
被动关闭端可能的状态有：    CLOSE_WAIT    LAST_ACK        CLOSED

在Linux下，如果连接数比较大，可以使用效率更高的ss来替代netstat。
查看tomcat的并发数：netstat -an|grep 10050|awk '{count[$6]++} END{for (i in count) print(i,count[i])}'

FILTER := [ state STATE-FILTER ] [ EXPRESSION ]
       STATE-FILTER := {all|connected|synchronized|bucket|big|TCP-STATES}
         TCP-STATES := {established|syn-sent|syn-recv|fin-wait-{1,2}|time-wait|closed|close-wait|last-ack|listening|closing}
          connected := {established|syn-sent|syn-recv|fin-wait-{1,2}|time-wait|close-wait|last-ack|closing}
       synchronized := {established|syn-recv|fin-wait-{1,2}|time-wait|close-wait|last-ack|closing}
             bucket := {syn-recv|time-wait}
                big := {established|syn-sent|fin-wait-{1,2}|closed|close-wait|last-ack|listening|closing}
                

all 所有类型
connected 除 closed 和 listen 状态以外已连接的状态
synchronized 除了syn-sent 外的状态


ss -t state LISTENING
EOL
}

ss_t_listen_all(){ cat - <<'EOL'
2. listen 和 non-listen                
  -a：显示所有的套接字；               --all
  -l：显示处于监听状态的套接字；       --listening
  
@ -a 想查看这台服务器上所有的socket连接 
如果只想查看TCP sockets，  那么使用 -ta 选项；
如果只想查看UDP sockets，  那么使用 -ua 选项；
如果只想查看RAW sockets，  那么使用 -wa 选项；
如果只想查看UNIX sockets， 那么使用 -xa 选项。

没有-a选项: SYN-RECV和TIME-WAIT 就被忽略。
ss -a          # 查看机器的socket连接数
ss -t -a       # 展示所有的监听的和未监听的 tcp 套接字
ss -t -a -Z    # -Z 是 SELinux 相关
ss -ant        # 显示所有TCP socket
ss -u -a       # 显示所有UDP Socekt

@ -l 查看所有打开的网络端口
ss -l          # 查看机器的端口情况
ss -l          # 显示本地打开的所有端口
ss -lp         # 显示进程使用的socket
ss -lp | grep 3306 # 找出打开套接字/端口应用程序
ss -tnlp       # 显示每个进程具体打开的socket
EOL
}

ss_t_summary(){ cat - <<'EOL'
@ 查看当前服务器的网络连接统计
ss -s          # 显示 Sockets 摘要(列出当前已经连接，关闭，等待的tcp连接)
EOL
}

ss_t_context(){ cat - <<'EOL'
-Z, --context
和-p选项相同, 但还显示进程安全上下文
    对于netlink(7)套接字,显示的初始化进程上下文如下所示:
    1. 如果pid有效, 显示进程上下文。
    2. 如果目地地址是内核(pid=0), 显示内核初始化上下文。
    3. 如果内核或netlink用户已分配唯一标识符, 显示内容为"unavailable"。
    这通常表示进程有多个netlink套接字处于活跃状态。
    
-z, --contexts
    和-Z选项相同但还显示套接字上下文。套接字上下文取自于相关联的inode,
    而不是内核持有的实际套接字上下文。套接字通常用创建过程中的上下文标
    记, 但是显示的上下文将反映应用的任何策略角色、类型和/或范围转换规则,
    因此是有用的参考。
EOL
}

ss_t_extended(){ cat - <<'EOL'
ss -tae

展示详细套接字信息。输出格式如下:
uid:<uid_number> ino:<inode_number> sk:<cookie>
<uid_number>
    套接字归属的用户ID
<inode_number>
    VFS中套接字的inode编号
<cookie>
    套接字的uuid
EOL
}


ss_t_information(){ cat - <<'EOL'
显示内部TCP信息. 可能有以下的字段:
ts                                  如果设置了timestamp选项, 显示字符串"ts"
sack                                如果设置了sack选项, 显示字符串"sack"
ecn                                 如果设置了显示拥塞通知选项, 显示字符串"ecn"
ecnseen                             如果接收的数据包中包含ecn标志, 显示字符串"ecnseen"
fastopen                            如果设置了fastopen选项, 显示字符串"fastopen"
cong_alg                            拥塞算法名, 默认拥塞算法是"cubic"
wscale:<snd_wscale>:<rcv_wscale>    如果设置了窗口扩大选项, 该字段显示发送扩大指数和接收扩大指数
rto:<icsk_rto>                      TCP重传超时时间, 单位是ms
backoff:<icsk_backoff>              用于指数退避重传, 实际的重传超时时间是 icsk_rto << icsk_backoff
rtt:<rtt>/<rttvar>                  rtt是平均往返时间, rttvar是rtt的平均偏差, 单位都是ms
ato:<ato>                           ack 超时时间, 单位是ms, 用于延迟ack模式
mss:<mss>                           最大报文段
cwnd:<cwnd>                         拥塞窗口大小
pmtu:<pmtu>                         路径MTU大小
ssthresh:<ssthresh>                 TCP拥塞窗口慢启动门限
bytes_acked:<bytes_acked>           确认字节数
bytes_recevied:<bytes_received>     接收字节数
lastsnd:<lastsnd>                   自从上次发送数据包以来的时间, 单位是ms
lastrcv:<lastrcv>                   自从上次接收数据包以来的时间, 单位是ms
lastack:<lastack>                   自从上次接收到确认以来的时间, 单位是ms
pacing_rate <pacing_rate>bps/<max_pacing_rate>bps
                                    Pacing Rate和最大Pacing Rate
rcv_space:<rcv_space>               TCP内部自动调整套接字接收缓存的辅助变量


https://github.com/gaddman/ss-pretty
如果想要查看连接更加详细信息呢？比如收到多少数据？上一个ACK是什么时候？mss是多大？拥塞窗口大小是多少？
$ ss -tmi "src 203.0.113.254:80"
State   Recv-Q  Send-Q      Local Address:Port  Peer Address:Port
ESTAB   0       2146808     203.0.113.254:80    198.51.100.1:35882
skmem:(r0,rb374400,t95744,tb9522176,f271616,w6454016,o0,bl0,d0) cubic wscale:10,10 rto:212 rtt:10.689/0.883 mss:1448 pmtu:1500 rcvmss:536 advmss:1448 cwnd:592 ssthresh:562 bytes_acked:258948616 segs_out:179298 segs_in:1090 data_segs_out:179298 send 641.6Mbps lastrcv:2824 pacing_rate 769.9Mbps delivery_rate 536.6Mbps busy:2768ms rwnd_limited:8ms(0.3%) unacked:456 retrans:0/6 rcv_space:28960 rcv_ssthresh:28960 notsent:1486520 minrtt:4.46

$ ss -tmi "src 203.0.113.254:80"
State   Recv-Q  Send-Q  Local Address:Port  Peer Address:Port
ESTAB   0       1592568 203.0.113.254:80    198.51.100.1:35882
skmem:(r0,rb374400,t121856,tb9522176,f1922048,w4787200,o0,bl0,d0) cubic wscale:10,10 rto:212 rtt:10.662/0.809 mss:1448 pmtu:1500 rcvmss:536 advmss:1448 cwnd:752 ssthresh:562 bytes_acked:575517448 segs_out:397951 segs_in:2372 data_segs_out:397951 send 817.0Mbps lastrcv:6744 lastack:4 pacing_rate 980.4Mbps delivery_rate 901.0Mbps busy:6688ms rwnd_limited:8ms(0.1%) unacked:484 retrans:0/6 rcv_space:28960 rcv_ssthresh:28960 notsent:891736 minrtt:4.356
         

$ prettySS.py -f "src 203.0.113.254:80" -u 0.5
timestamp       mss  rcvmss advmss rto  rtt             cwnd   ssthresh  bytes_acked  unacked retrans send       pacing_rate delivery_rate busy   rcv_space notsent
17:35:00.405289 1448 536    1448   208  10.198/5.099    10     581                                    11.4Mbps   22.7Mbps                         28960
17:35:00.922610 1448 536    1448   212  11.217/0.979    1042   581       41063832     619             1076.1Mbps 1291.3Mbps  925.5Mbps     456ms  28960     638256
17:35:01.441896 1448 536    1448   212  11.225/0.978    1042   581       99316872     810             1075.3Mbps 1290.3Mbps  877.6Mbps     976ms  28960     959976
17:35:01.961606 1448 536    1448   212  11.14/0.813     1096   581       158230200    738             1139.7Mbps 1367.6Mbps  813.0Mbps     1496ms 28960     1002232
17:35:02.480419 1448 536    1448   212  10.921/1.041    805    770       209615376    475     0/3     853.9Mbps  1024.6Mbps  804.7Mbps     2016ms 28960     1247032

SS -tan state time-wait | wc -l
ss --info  sport = :2112 dport = :4057
TIME-WAIT状态将提前终止: 它将根据RTT及其方差计算的重传超时（RTO）间隔后将其删除。您可以使用ss命令找到活动连接的适当值:
EOL
}

ss_t_process(){ cat - <<'EOL'
@ -p参数显示了这条连接的进程信息
users:(("chrome",pid=2578,fd=383)) 查看处于特定状态的socket
chrome      进程名称
pid=2578    进程pid
fd=383      连接关联fd

ss -lp | grep <port>
EOL
}

ss_t_memory(){ cat - <<'EOL'
@ 查看socket内存使用情况
skmem: (r<rmem_alloc>, rb<rcv_buf>, t<wmem_alloc>, tb<snd_buf>, f<fwd_alloc>, w<wmem_queued>, o<opt_mem>, bl<back_log>)
<rmem_alloc>  分配用于接收数据包的内存
<rcv_buf>     可分配用于接收数据包的总内存
<wmem_alloc>  用于发送数据包(已发送到网络层)的内存
<snd_buf>     可分配用于发送数据包的总内存
<fwd_alloc>   被套接字分配为缓存的内存, 但尚未用于接收/发送数据包。如果需要发送/接收数据包的内存, 将在分配额外内存之前, 先使用该缓存的内存。
<wmem_queued> 分配用于发送数据包(尚未发送到网络层)的内存
<opt_mem>     用于存储套接字选项的内存, 例如, TCP MD5签名密钥
<back_log>    用于sk backlog队列的内存。在一个进程的上下文, 如果进程正在接收数据包并且有一个新的数据包被接收, 就加入sk backlog队列, 这样这个数据包就可以立即被进程接收。

ss -tm  #只显示内存部分信息
ss -uam 
skmem:(r0,rb374400,t0,tb46080,f0,w0,o0,bl0)

由于信息较多，这里只显示内存部分，括号内从左到右分别代表：
r0          接收报文分配的内存
rb374400    接收报文可分配的内存
t0          发送报文分配的内存
tb46080     发送报文可分配的内存
f0          socket使用的缓存
w0          为将要发送的报文分配的内存
o0          保存socket选项使用的内存
bl0         连接队列使用的内存
EOL
}

ss_t_timer(){ cat - <<'EOL'
timer: (<timer_name>, <expire_time>, <retrans>)
<timer_name>
    计时器名称, 有五种计时器名称:
    on: 下列计时器其中之一, 分别为TCP重传计时器、TCP早期重传计时器和尾部丢失探测计时器
    keepalive: TCP 保活计时器
    timewait: TIMEWAIT 阶段计时器
    persist: 零窗口探测计时器
    unknown: 未知计时器
<expire_time>
    计时器到期时间
<retrans>
    重传次数
ss -to
keepalive定时器剩余时间：
timer:(keepalive,9.956ms,0)  保活定时器
timer:(on,220ms,         0)           还未进入: 保活定时器

ss -ant | awk '
    NR>1 {++s[$1]} END {for(k in s) print k,s[k]}
'
EOL
}

ss_i_tcp_timer(){ cat - <<'EOL'
1. 重传定时器使用于当希望收到另一端的确认  (Retransmission Timer，RTO)
    该定时器是用来决定超时和重传的。
    由于网络环境的易变性，该定时器时间长度肯定不是固定值；该定时器时间长度的设置依据是RTT(Round Trip Time)，根据网络环境的变化，
TCP会根据这些变化并相应地改变超时时间。
[重传机制]
重传时间 = 2 * RTT

2. 坚持定时器(persist)使窗口大小信息保持不断流动，即使另一端关闭了其接收窗口。
坚持定时器是使用在一方滑动窗口为0之后，另外一方停止传输数据，进入坚持定时器的轮询，直到滑动窗口不再为0了。

3. 保活定时器(keepalive)可检测到一个空闲连接的另一端何时崩溃或重启。
    建议实现心跳包而不是依赖保活定时器
[保活机制] ---- 应用层是心跳机制
服务器每收到一次客户端的数据，会复位保活定时器并重设，默认为2小时。
一定时间tcp_keepalive_time发送一次保持心跳包，默认为2小时
如果没有正常返回，则在指定次数内tcp_keepalive_probes(默认为9次)指定间隔时间tcp_keepalive_intval(默认17s)发送心跳包
    
4. 2MSL定时器测量一个连接处于TIME_WAIT状态的时间。
为什么存在2MSL的TIME_WAIT呢？主要是考虑到四次挥手的最后一个ACK包对方没有收到，对方会重发FIN包，一来一回就是2倍的MSL时长。
2MSL测量一个连接处于TIME_WAIT状态的时间，是为了让TCP有时间发送最后一个ACK，以防止该ACK丢失。
https://blog.huoding.com/2013/12/31/316

5. 建立连接定时器
建立连接定时器connection-establishment timer，是在建立连接的时候使用。
TCP建立连接需3次握手，建立连接的过程中，在发送"请求建立连接SYN包"时，会启动一个定时器，默认为3秒。若SYN包丢失，
3秒后会重新发送SYN包并启动一个新的定时器，并设置为6秒超时。

[建立连接定时器机制]
# 设置重发SYN包次数
$ cat /proc/sys/net/ipv4/tcp_syn_retries
EOL
}

ss_t_unix(){ cat - <<'EOL'
ss -x src /tmp/mysql.sock
ss -x src /dev/log


EOL
}

ss_t_filter_addr_port(){ cat - <<'EOL'
协议通过option选定，主机名和端口通过字符串描述。 -- 主机名和端口名形式上既可以是数值也可以是字符串
                                                 -- 主机名和端口名方向上既可以是发送也可以是接收的
                    <src|dst> + <[hostname][port]> 
协议选择有: 
            -4：只显示ipv4的套接字；             --ipv4
            -6：只显示ipv6的套接字；             --ipv6
            -0：packet sockets                   --packet
            -t：只显示tcp套接字；                
            -u：只显示udp套接字；                
            -d：只显示DCCP套接字；               
            -w：仅显示RAW套接字；                
            -x：仅显示UNIX域套接字。
            
dst prefix:port
src prefix:port
src unix:STRING
src link:protocol:ifindex
src nl:channel:pid
prefix:port可以缺失或者使用'*'。
dst 10.0.0.1        主机(相同)
dst 10.0.0.1:       主机(相同)
dst 10.0.0.1/32:    主机(相同)
dst 10.0.0.1:*      主机(相同)
dst 10.0.0.0/24:22  端口(所有来自指定网段的22)
    dst [::1]           ipv6地址
    10.0.0.1/:          
    dst [10.0.0.1]/.   
    

1. 端口过滤
源端口：    ss -nt 'src :2333'                  目的端口：ss -nt 'dst :ssh'
源端口：    ss -nt 'sport = :2333'              目的端口：ss -nt 'dport = :ssh'
地址和端口：ss -nt 'dst 101.68.62.5:6777'

匹配远端地址和端口：ss dst 192.168.1.5 
                    ss dst 192.168.119.113:http 
                    ss dst 192.168.119.113:smtp 
                    ss dst 192.168.119.113:443
匹配本地地址和端口：ss src 192.168.119.103 
                    ss src 192.168.119.103:http 
                    ss src 192.168.119.103:80 
                    ss src 192.168.119.103:smtp 
                    ss src 192.168.119.103:25
2. 地址过滤
ss src|dst 75.126.153.214 
ss src|dst 75.126.153.214:http 
ss src|dst 75.126.153.214:80 
EOL
}

ss_t_filter_operator(){ cat - <<'EOL'
比较操作符:
1. 端口过滤
显示目的端口号小于1000的套接字：                          ss -nt 'dport \< :1000'
显示源端口号大于1024的套接字：                            ss -nt 'sport gt :1024'

ss  sport = :http 
ss  dport = :http 
ss  dport \> :1024 
ss  sport \> :1024 
ss  sport \< :32000 
ss  sport eq :22 
ss  dport != :22 

ss dport <OP> PORT    # 远程端口和一个数比较: destination port
ss sport <OP> PORT    # 本地端口和一个数比较: source port
         <OP>:
           <=  or  le
           >=  or  ge
           ==  or  eq
           !=  or  ne
           <   or  gt
           >   or  lt
逻辑操作符(OP) 有
        and
        or
        not
关系操作符(RELOP) 有
        le
        ge
        eq
        ne
        gt
        lt

2. 与或
ss \( sport = :http or sport = :https \) 
ss -o state fin-wait-1 \( sport = :http or sport = :https \) dst 192.168.1/24
EOL
}

ss_t_filter_state(){ cat - <<'EOL'
ss -o state established `(dport  =: smtp  or  sport  = : smtp)`    # 显示所有状态为 established  的 SMTP 连接
ss -o state established `(dport = :http or sport = :http)`         # 显示所有状态为 Established 的 HTTP 连接
ss -o state fin-wait-1  `(sport= :http or sport = :https)` dst 192.168.1/24 # dst 193.233.7/24 列举出 FIN-WAIT-1状态的源 80或者 443，目标网路 193.233.7/24所有 tcp

watch -n 1 "ss -t4 state syn-sent"
ss -o state established '( dport = :http or sport = :http )'  

ss exclude SYN-RECV

STATE-FILTER 允许构造任意一组状态来进行匹配。语法是 state 关键字后加上一组state标识符序列。

用TCP 状态过滤 sockets
ss  -4 state <FILTER-NAME-HERE>
ss  -6 state <FILTER-NAME-HERE>
         其中<FILTER-NAME-HERE>: 所有的标准TCP状态: 
           established
           syn-sent
           syn-recv
           fin-wait-1
           fin-wait-2
           time-wait
           closed
           close-wait
           last-ack
           listen
           closing
    all             for all the states
    connected       not closed and not listening
    synchronized 　 connected and not SYN-SENT
    bucket　　      for TCP minisockets (TIME-WAIT|SYN-RECV)
    big　　         all except for minisockets
    
    If neither state nor exclude directives are present, state filter defaults to all with option -a or to all, 
excluding listening, syn-recv, time-wait and closed sockets.
EOL
}


ss_t_perf(){ cat - <<'EOL'
1. 影响Socket缓存的参数
首先，我们要先来列出Linux中可以影响Socket缓存的调整参数。在proc目录下，它们的路径和对应说明为：
/proc/sys/net/core/rmem_default
/proc/sys/net/core/rmem_max
/proc/sys/net/core/wmem_default
/proc/sys/net/core/wmem_max
这些文件用来设置所有socket的发送和接收缓存大小，所以既影响TCP，也影响UDP。

2. 针对UDP：
    这些参数实际的作用跟 SO_RCVBUF 和 SO_SNDBUF 的 socket option 相关。如果我们不用setsockopt去更改创建出来的 
socket buffer 长度的话，那么就使用 rmem_default 和 wmem_default 来作为默认的接收和发送的 socket buffer 长度。
如果修改这些socket option的话，那么他们可以修改的上限是由 rmem_max 和 wmem_max 来限定的。

3. 针对TCP：
除了以上四个文件的影响外，还包括如下文件：
/proc/sys/net/ipv4/tcp_rmem
/proc/sys/net/ipv4/tcp_wmem
    对于TCP来说，上面core目录下的四个文件的作用效果一样，只是默认值不再是 rmem_default 和 wmem_default ，
而是由 tcp_rmem 和 tcp_wmem 文件中所显示的第二个值决定。通过setsockopt可以调整的最大值依然由rmem_max和wmem_max限制。

4. 查看tcp_rmem和tcp_wmem的文件内容会发现，文件中包含三个值：
[root@localhost network_turning]# cat /proc/sys/net/ipv4/tcp_rmem
4096	131072	6291456
[root@localhost network_turning]# cat /proc/sys/net/ipv4/tcp_wmem
4096	16384	4194304
三个值依次表示：min default max
min：决定 tcp socket buffer 最小长度。
default：决定其默认长度。
max：决定其最大长度。在一个tcp链接中，对应的buffer长度将在min和max之间变化。
    导致变化的主要因素是当前内存压力。如果使用setsockopt设置了对应buffer长度的话，
这个值将被忽略。相当于关闭了tcp buffer的动态调整。


5. /proc/sys/net/ipv4/tcp_moderate_rcvbuf
这个文件是服务器是否支持缓存动态调整的开关，1为默认值打开，0为关闭。
另外要注意的是，使用 setsockopt 设置对应buffer长度的时候，实际生效的值将是设置值的2倍。
当然，这里面所有的rmem都是针对接收缓存的限制，而wmem都是针对发送缓存的限制。

我们目前的实验环境配置都采用默认值：
[root@localhost network_turning]# cat /proc/sys/net/core/rmem_default
212992
[root@localhost network_turning]# cat /proc/sys/net/core/rmem_max
212992
[root@localhost network_turning]# cat /proc/sys/net/core/wmem_default
212992
[root@localhost network_turning]# cat /proc/sys/net/core/wmem_max
212992

大延时网络提高TCP带宽利用率

6. 可以在下载过程中使用ss命令查看 rcv_space 和 rcv_ssthresh 的变化：
[root@localhost zorro]# ss -io state established '( dport = 80 or sport = 80 )'
Netid     Recv-Q     Send-Q           Local Address:Port              Peer Address:Port     Process
tcp       0          0              192.168.247.130:47864          192.168.247.129:http
	 ts sack cubic wscale:7,11 rto:603 rtt:200.748/75.374 ato:40 mss:1448 pmtu:1500 rcvmss:1448 advmss:1448 cwnd:10 bytes_sent:149 bytes_acked:150 bytes_received:448880 segs_out:107 segs_in:312 data_segs_out:1 data_segs_in:310 send 577.0Kbps lastsnd:1061 lastrcv:49 lastack:50 pacing_rate 1.2Mbps delivery_rate 57.8Kbps delivered:2 app_limited busy:201ms rcv_rtt:202.512 rcv_space:115840 rcv_ssthresh:963295 minrtt:200.474
[root@localhost zorro]# ss -io state established '( dport = 80 or sport = 80 )'
Netid     Recv-Q     Send-Q           Local Address:Port              Peer Address:Port     Process
tcp       0          0              192.168.247.130:47864          192.168.247.129:http
	 ts sack cubic wscale:7,11 rto:603 rtt:200.748/75.374 ato:40 mss:1448 pmtu:1500 rcvmss:1448 advmss:1448 cwnd:10 bytes_sent:149 bytes_acked:150 bytes_received:48189440 segs_out:1619 segs_in:33282 data_segs_out:1 data_segs_in:33280 send 577.0Kbps lastsnd:2623 lastrcv:1 lastack:3 pacing_rate 1.2Mbps delivery_rate 57.8Kbps delivered:2 app_limited busy:201ms rcv_rtt:294.552 rcv_space:16550640 rcv_ssthresh:52423872 minrtt:200.474
[root@localhost zorro]# ss -io state established '( dport = 80 or sport = 80 )'
Netid     Recv-Q     Send-Q           Local Address:Port              Peer Address:Port     Process
tcp       0          0              192.168.247.130:47864          192.168.247.129:http
	 ts sack cubic wscale:7,11 rto:603 rtt:200.748/75.374 ato:40 mss:1448 pmtu:1500 rcvmss:1448 advmss:1448 cwnd:10 bytes_sent:149 bytes_acked:150 bytes_received:104552840 segs_out:2804 segs_in:72207 data_segs_out:1 data_segs_in:72205 send 577.0Kbps lastsnd:3221 lastack:601 pacing_rate 1.2Mbps delivery_rate 57.8Kbps delivered:2 app_limited busy:201ms rcv_rtt:286.159 rcv_space:25868520 rcv_ssthresh:52427352 minrtt:200.474

7. 总结
从原理上看，一个延时大的网络不应该影响其带宽的利用。之所以大延时网络上的带宽利用率低，主要原因是延时变大之后，
发送方发的数据不能及时到达接收方。导致发送缓存满之后，不能再持续发送数据。接收方则因为TCP通告窗口受到接收方剩余缓存大小的影响。
接收缓存小的话，则会通告对方发送窗口变小。进而影响发送方不能以大窗口发送数据。
所以，这里的调优思路应该是，发送方调大tcp_wmem，接收方调大tcp_rmem。那么调成多大合适呢？
如果我们把大延时网络想象成一个缓存的话，那么缓存的大小应该是带宽延时(rtt)积。
假设带宽为1000Mbit/s，rtt时间为400ms，那么缓存应该调整为大约50Mbyte左右。
接收方tcp_rmem应该更大一些，以便在接受方不能及时处理数据的情况下，不至于产生剩余缓存变小而影响通告窗口导致发送变慢的问题，可以考虑调整为2倍的带宽延时积。

EOL
}