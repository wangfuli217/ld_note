http://www.cnblogs.com/ginvip/p/6350252.html
https://github.com/ShiChao1996/myBlog/issues

http://packetlife.net/blog/2010/jun/7/understanding-tcp-sequence-acknowledgment-numbers/

控制字段
三次握手的数据传输方式，主要由 tcp header 里下列字段控制。

    0                   1                   2                   3   
    0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 
    ...
    +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    |                        Sequence Number                        |
    +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    |                    Acknowledgment Number                      |
    +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    |  Data |       |C|E|U|A|P|R|S|F|                               |
    | Offset|  Res. |W|C|R|C|S|S|Y|I|            Window             | 
    |       |       |R|E|G|K|H|T|N|N|                               |
    +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    ...

第一行 sequence number 代表该端已经发送的数据内容字节长度；

第二行 acknowledgement 代表下一次希望收到的 sequence number。

客户端和服务器各自保存自己的 sequence number 和 acknowledgement number，用来记住对方的状态。

第三行里面 CWR ECE URG ACK PSH RST SYN FIN 是 8 个 tcp flag，常用的是下面三个：

    SYN - Synchronize, Initiates a connection，代表发起 tcp 连接
    FIN - Final, Cleanly terminates a connection，代表关闭 tcp 连接
    ACK - Acknowledges received data，告诉对方已经收到的数据

需要注意的是 SYN 和 FIN 包虽然没有数据内容，但是也会使 sequence number +1.
一次 TCP 连接的生命周期 {#一次 TCP 连接完整的生命周期}

    [三次握手]seq:0 ack:0 客户端发送 SYN 位为1的 tcp 包到服务器，因为发送了SYN包，下一次seq是1
    [三次握手]seq:0 ack:1 服务器返回 ACK 位为1，SYN 位为1的 tcp 包到客户端
    [三次握手]seq:1 ack:1 客户端发送 ACK 位为1 的包到服务器。三次握手完成，可以开始传输了。
    [数据传输]seq:1 ack:1 客户端向服务器发送了数据，譬如发送了 725 bytes 的请求头数据，下一次 seq 是 726 了
    [数据传输]seq:1 ack:726 服务器返回 ack 包，代表收到请求头了
    [数据传输]seq:1 ack:726 服务器向客户端发送返回数据，譬如发送了 1448 bytes 的数据
    [数据传输]seq:726 ack:1449 客户端向服务器返回 ack 包
    [数据传输]...服务器向客户端发送数据、客户端返回 ack 包，直到数据传输结束
    [结束连接]seq:726 ack:* 客户端向服务端发送 FIN:1,ACK:1 的包，意思是告诉服务端我要关闭链接了
    [结束连接]seq:* ack:727 服务端返回 FIN:1,ACK:1 的包，意思是告诉客户端关闭连接吧
    [结束连接]seq:727 ack:* 客户端向服务端发送 ACK 包

    * 部分的 seq/ack 号码代表跟实际传输的字符数相关。
    seq和ack的序号是相对序号
    服务端会另外储存他自己的 seq 和 ack

想使用 Wireshark 查看具体的 tcp 包，这篇教程的例子非常值得一看：

Understanding TCP Sequence and Acknowledgment Numbers - PacketLife.net




sk_stream_wait_memory(TCP内存不足){
  我们知道当协议栈缺少内存的时候会调用sk_stream_wait_memory等待其他进程释放出内存，
所以这个函数的等待时间就是我们的进程被阻塞的时间。
net.ipv4.tcp_wmem = 4096 16384 4194304
net.ipv4.tcp_rmem = 4096 87380 4194304
net.core.wmem_max = 131071
net.core.rmem_max = 131071

    sk_stream_wait_memory 并不是只是在协议栈缺少内存的时候才会调用。在单个socket没有发送缓冲区空间的时候
(或者说发送缓冲区满的时候)，也会最终调用该函数。
也就说说，来到sk_stream_wait_memory()调用的有以下三个情景：
1、发送缓冲区满了，又有新的要发送数据(此时send会阻塞在该函数中)
2、不能分配skb
3、不能分配page
其中1受到wmem_max限制；
2和3受到tcp_mem的限制
也，1和2、3没有必然的联系。
举个例子：在一个socket中，即使1没有满足条件(即发送缓冲区没有满，后续的send可以填充缓冲区)，那2、3同样可能在tcp连接相当多的时候发生。
}

tcp_timestamps(可以防范那些伪造的sequence序号){ 1 1
net.ipv4.tcp_timestamps = 1
说明：
该参数控制RFC 1323 时间戳与窗口缩放选项。默认情况下，启用时间戳与窗口缩放，但是可以使用标志位进行控制。0位控制窗口缩放，1 位控制时间戳。

值为0（禁用 RFC 1323选项）
值为1（仅启用窗口缩放）
值为2（仅启用时间戳）
值为3（两个选项均启用）

net.ipv4.tcp_timestamps=0
说明：
时间戳可以避免序列号的卷绕。一个1Gbps的链路肯定会遇到以前用过的序列号。时间戳能够让内核接受这种“异常”的数据包。这里需要将其关掉。
值为0（禁用时间戳）
值为1（启用时间戳）
只有客户端和服务端都开启时间戳的情况下，才会出现能ping通不能建立tcp三次握手的情况，所以做为提供服务的公司，不可能保证所有的用户都关闭时间戳，
这个功能，所以我们必须关闭时间戳，这样才能给所用用户提供正常的服务。
}

 
tcp_window_scaling(设置tcp/ip会话的滑动窗口大小是否可变){ 1 1
参数值为布尔值，为1时表示可变，为0时表示不可变。
tcp/ip通常使用的窗口最大可达到 65535 字节，
对于高速网络，该值可能太小，这时候如果启用了该功能，可以使tcp/ip滑动窗口大小增大数个数量级，从而提高数据传输的能力(RFC 1323)。
（对普通地百M网络而言，关闭会降低开销，所以如果不是高速网络，可以考虑设置为0）
}
tcp_sack(使用Selective ACK){ 1 1
net.ipv4.tcp_window_scaling = 1 
net.ipv4.tcp_sack = 1

使用 Selective ACK﹐它可以用来查找特定的遗失的数据报—因此有助于快速恢复状态。该文件表示是否启用有选择的应答（Selective Acknowledgment），这可以通过
有选择地应答乱序接收到的报文来提高性能（这样可以让发送者只发送丢失的报文段）。(对于广域网通信来说这个选项应该启用，但是这会增加对 CPU 的占用。)
}

tcp_fack(打开FACK拥塞避免和快速重传功能){1 1
net.ipv4.tcp_fack = 1
打开FACK(Forward ACK) 拥塞避免和 快速重传功能。(注意，当tcp_sack设置为0的时候，这个值即使设置为1也无效)
[这个是TCP连接靠谱的核心功能]
}

tcp_retrans_collapse(对于某些有bug的打印机提供针对其bug的兼容性){1 0
一般不需要这个支持,可以关闭它
}
tcp_syn_retries(新建连接SYN重试次数){5 1

net.ipv4.tcp_retrans_collapse = 1
net.ipv4.tcp_syn_retries = 5

对于一个新建连接，内核要发送多少个 SYN 连接请求才决定放弃。不应该大于255，默认值是5，对应于180秒左右时间。(对于大负载而物理
通信良好的网络而言,这个值偏高,可修改为2.这个值仅仅是针对对外的连接, 对进来的连接,是由tcp_retries1 决定的)
}


tcp_synack_retries(远端的连接请求SYN,内核重试发送 SYN+ACK次数){5 1
net.ipv4.tcp_synack_retries = 5
tcp_synack_retries显示或设定 Linux 核心在回应 SYN 要求时会尝试多少次重新发送初始 SYN,ACK 封包后才决定放弃。这是所谓的三段交握
 (threeway handshake) 的第二个步骤。即是说系统会尝试多少次去建立由远端启始的 TCP 连线。tcp_synack_retries 的值必须为正整数，
 并不能超过 255。因为每一次重新发送封包都会耗费约 30 至 40 秒去等待才决定尝试下一次重新发送或决定放弃。tcp_synack_retries 的
 缺省值为 5，即每一个连线要在约 180 秒 (3 分钟) 后才确定逾时.

}

tcp_max_orphans(系统所能处理不属于任何进程的TCP sockets最大数量){ 8192 32768
net.ipv4.tcp_max_orphans = 131072
系统所能处理不属于任何进程的TCP sockets最大数量。假如超过这个数量，那么不属于任何进程的连接会被立即reset，并同时显示警告信息。
之所以要设定这个限制﹐纯粹为了抵御那些简单的 DoS 攻击﹐千万不要依赖这个或是人为的降低这个限制，更应该增加这个值(如果增加了
内存之后)。每个孤儿套接字最多能够吃掉你64K不可交换的内存。
}
 

tcp_max_tw_buckets(系统在同时所处理的最大 timewait sockets 数目){ 180000 36000
net.ipv4.tcp_max_tw_buckets = 5000
表示系统同时保持TIME_WAIT套接字的最大数量，如果超过这个数字，TIME_WAIT套接字将立刻被清除并打印警告信息。
默认为180000。设为较小数值此项参数可以控制TIME_WAIT套接字的最大数量，避免服务器被大量的TIME_WAIT套接字拖死。

之所以要设定这个限制﹐纯粹为了抵御那些简单的 DoS 攻击﹐不过﹐如果网络条件需要比默认值更多﹐则可以提高它(或许还要增加内存)。(事实上做NAT的时候最好可以适当地增加该值)
}
 
tcp_keepalive_time(TCP发送keepalive探测消息的间隔时间){ 7200 600
用于确认TCP连接是否有效。
防止两边建立连接但不发送数据的攻击。}
tcp_keepalive_intvl(探测消息未获得响应时，重发该消息的间隔时间){ 75 15
默认值为75秒。 (对于普通应用来说,这个值有一些偏大,可以根据需要改小.特别是web类服务器需要改小该值,15是个比较合适的值)
}
tcp_keepalive_probes(TCP发送keepalive探测消息的重试次数){9 3
net.ipv4.tcp_keepalive_time = 7200
net.ipv4.tcp_keepalive_probes = 9
net.ipv4.tcp_keepalive_intvl = 75 
用实例进行说明上述三个参数：
如果某个TCP连接在idle 2个小时后,内核才发起probe(探查).
如果probe 9次(每次75秒既tcp_keepalive_intvl值)不成功,内核才彻底放弃,认为该连接已失效。
}

tcp_retries1(放弃回应一个TCP连接请求前﹐需要进行多少次重试){ 3 3
net.ipv4.tcp_retries1 = 3
放弃回应一个TCP 连接请求前﹐需要进行多少次重试。RFC 规定最低的数值是3﹐这也是默认值﹐根据RTO的值大约在3秒 - 8分钟之间。(注意:这个值
同时还决定进入的syn连接)
(第二种解释：它表示的是TCP传输失败时不检测路由表的最大的重试次数，当超过了这个值，我们就需要检测路由表了)
}

tcp_retries2(在丢弃激活的TCP连接之前﹐需要进行多少次重试){ 15 5
 net.ipv4.tcp_retries2 = 15
在丢弃激活(已建立通讯状况)的TCP连接之前﹐需要进行多少次重试。默认值为15，根据RTO的值来决定，相当于13-30分钟(RFC1122规定，必须大于100秒).
(这个值根据目前的网络设置,可以适当地改小,我的网络内修改为了5)

(第二种解释：表示重试最大次数，只不过这个值一般要比上面的值大。和上面那个不同的是，当重试次数超过这个值，我们就必须放弃重试了)
}

tcp_orphan_retries(在近端丢弃TCP连接之前﹐要进行多少次重试。){7 3
net.ipv4.tcp_orphan_retries
主要是针对孤立的socket(也就是已经从进程上下文中删除了，可是还有一些清理工作没有完成).
对于这种socket，我们重试的最大的次数就是它.
1. 默认值是7个﹐相当于 50秒 - 16分钟﹐视 RTO 而定。如果您的系统是负载很大的web服务器﹐那么也许需要降低该值﹐这类 sockets 可能会耗费大量的资源。另外参的考tcp_max_orphans。
}

tcp_fin_timeout(对于本端断开的socket连接，TCP保持在FIN-WAIT-2状态的时间){ 60 2
net.ipv4.tcp_fin_timeout = 30
表示如果套接字由本端要求关闭，这个参数决定了它保持在 FIN-WAIT-2状态的时间
}

tcp_tw_recycle(打开快速 TIME-WAIT sockets 回收){ 1 0
net.ipv4.tcp_tw_recycle = 1
表示开启TCP连接中TIME-WAITsockets的快速回收，默认为0，表示关闭
对方可能会断开连接或一直不结束连接或不可预料的进程死亡。默认值为 60 秒。
1. 除非得到技术专家的建议或要求﹐请不要随意修改这个值。(做NAT的时候，建议打开它)
}

tcp_stdurg(使用 TCP urg pointer 字段中的主机请求解释功能){0 0
大部份的主机都使用老旧的 BSD解释，因此如果您在Linux 打开它﹐或会导致不能和它们正确沟通。
}
tcp_max_syn_backlog(对于那些依然还未获得客户端确认的连接请求﹐需要保存在队列中最大数目){1024 16384
对于超过 128Mb 内存的系统﹐默认值是 1024 ﹐低于 128Mb 的则为 128。
如果服务器经常出现过载﹐可以尝试增加这个数字。
1. 警告﹗假如您将此值设为大于 1024﹐最好修改include/net/tcp.h里面的TCP_SYNQ_HSIZE﹐以保持TCP_SYNQ_HSIZE*16(SYN Flood攻击利用TCP协议散布握手的缺陷，伪造虚假源IP地址发送大量TCP-SYN半打开连接到目标系统，最终导致目标系统Socket队列资源耗尽而无法接受新的连接。
2. 为了应付这种攻击，现代Unix系统中普遍采用多连接队列处理的方式来缓冲(而不是解决)这种攻击，是用一个基本队列处理正常的完全连接应用(Connect()和Accept() )，是用另一个队列单独存放半打开连接。这种双队列处理方式和其他一些系统内核措施(例如Syn-Cookies/Caches)联合应用时，能够比较有效的缓解小规模的SYN Flood攻击(事实证明)
}
tcp_rfc1337(){
net.ipv4.tcp_stdurg = 0
net.ipv4.tcp_rfc1337 = 0
net.ipv4.tcp_max_syn_backlog = 8192
表示SYN队列的长度，默认为1024，加大队列长度为8192，可以容纳更多等待连接的网络连接数。
(第二种解释：端口最大backlog 内核限制。此参数限制服务端应用程序 可以设置的端口最大backlog 值 (对应于端口的 syn_backlog 和 backlog 队列
长度)。动机是在内存有限的服务器上限制/避免应用程序配置超大 backlog 值而耗尽内核内存。如果应用程序设置 backlog 大于此值，操作系统将自动
将之限制到此值。)

}

tcp_abort_on_overflow(当守护进程太忙而不能接受新的连接，就向对方发送reset消息){0 0
net.ipv4.tcp_abort_on_overflow = 0
       当 tcp 建立连接的 3 路握手完成后，将连接置入ESTABLISHED 状态并交付给应用程序的 backlog 队列时，会检查 backlog 队列是否已满。
       若已满，通常行为是将连接还原至 SYN_ACK状态，以造成 3 路握手最后的 ACK 包意外丢失假象 —— 这样在客户端等待超时后可重发 ACK —— 
       以再次尝试进入ESTABLISHED 状态 —— 作为一种修复/重试机制。如果启用tcp_abort_on_overflow 则在检查到 backlog 队列已满时，直接发 
       RST 包给客户端终止此连接 —— 此时客户端程序会收到 104Connection reset by peer 错误。
       
警告：启用此选项可能导致高峰期用户访问体验到 104:Connection reset by peer 或白屏错误(视浏览器而定)。在考虑启用此选项前应先设法优化提高服务端应用程序的性能，使之能更快接管、处理连接。
1. 对待已经满载的sendmail,apache这类服务的时候,这个可以很快让客户端终止连接,可以给予服务程序处理已有连接的缓冲机会,所以很多防火墙上推荐打开它
}

tcp_syncookies(当出现syn等候队列出现溢出时象对方发送syncookies){0 1
net.ipv4.tcp_syncookies = 1

         在 tcp 建立连接的 3 路握手过程中，当服务端收到最初的 SYN 请求时，会检查应用程序的 syn_backlog 队列是否已满。若已满，通常行为是丢弃此 SYN 包。若未满，会再检查应用程序的 backlog 队列是否已满。若已满并且系统根据历史记录判断该应用程序不会较快消耗连接时，则丢弃此 SYN 包。如果启用 tcp_syncookies 则在检查到 syn_backlog 队列已满时，不丢弃该 SYN 包，而改用 syncookie 技术进行 3 路握手。
警告：使用 syncookie 进行握手时，因为该技术挪用了 tcp_options 字段空间，会强制关闭 tcp 高级流控技术而退化成原始 tcp 模式。此模式会导致封包 丢失时 对端 要等待 MSL 时间来发现丢包事件并重试，以及关闭连接时 TIME_WAIT 状态保持 2MSL 时间。 该技术应该仅用于保护syn_flood 攻击。如果在正常服务器环境中服务器负载较重导致 syn_backlog 和 backlog 队列满时，应优化服务端应用程序的负载能力，加大应用程序 backlog 值。不过，所幸该参数是自动值，仅在 syn_backlog 队列满时才会触发 (在队列恢复可用时此行为关闭)。

1. 服务端应用程序设置端口backlog 值，内核理论上将允许该端口最大同时接收 2*backlog 个并发连接”请求”(不含已被应用程序接管的连接) ——分别存放在 syn_backlog 和 backlog 队列—— 每个队列的长度为backlog 值。syn_backlog 队列存储 SYN_ACK 状态的连接，backlog 则存储 ESTABLISHED 状态但尚未被应用程序接管的连接。
2. syn_backlog 队列实际上是个 hash 表，并且 hash 表大小为 2 的次方。所以实际 syn_backlog 的队列长度要略大于应用程序设置的 backlog 值—— 取对应 2 的次方值
3. 当 backlog 值较小，而高峰期并发连接请求超高时，tcp 建立连接的三路握手 网络时延将成为瓶颈 —— 并发连接超高时，syn_backlog 队列将被充满而导致 ` can’t connect` 错误。此时，再提高服务端应用程序的吞吐能力已不起作用，因为连接尚未建立，服务端应用程序并不能接管和处理这些连接—— 而是需要加大backlog 值 (syn_backlog 队列长度) 来缓解此问题。
4. 启用 syncookie 虽然也可以解决超高并发时的` can’t connect` 问题，但会导致 TIME_WAIT 状态 fallback 为保持 2MSL 时间，高峰期时会导致客户端无可复用连接而无法连接服务器 (tcp 连接复用是基于 四元组值必须不相同，就访问同一个目标服务器而言， 三元组值不变，所以此时可用的连接数限制为仅src_port 所允许数目，这里处于 TIME_WAIT 状态的相同 src_port 连接不可复用。Linux 系统甚至更严格，只使用了 三元组…)。故不建议依赖syncookie。

生作用。当出现syn等候队列出现溢出时象对方发送syncookies。目的是为了防止syn flood攻击。
}

tcp_orphan_retries(在近端丢弃TCP连接之前﹐要进行多少次重试){7 3
net.ipv4.tcp_orphan_retries = 0

本端试图关闭TCP连接之前重试多少次。缺省值是7，相当于50秒~16分钟(取决于RTO)。如果你的机器是一个重载的WEB服务器，你应该考虑减低这个值，
因为这样的套接字会消耗很多重要的资源。参见tcp_max_orphans
}
 
tcp_sack(){
net.ipv4.tcp_sack = 1
SACK(SelectiveAcknowledgment，选择性确认)技术，使TCP只重新发送交互过程中丢失的包，不用发送后续所有的包，而且提供相应机制使接收方能告诉发送方哪
些数据丢失，哪些数据重发了，哪些数据已经提前收到了。如此大大提高了客户端与服务器端数据交互的效率。

}

tcp_reordering(TCP流中重排序的数据报最大数量){3 6
一般有看到推荐把这个数值略微调整大一些,比如5
}
tcp_ecn(TCP的直接拥塞通告功能){0 0
}
tcp_dsack(允许TCP发送"两个完全相同"的SACK){1 1
net.ipv4.tcp_reordering = 3
net.ipv4.tcp_ecn = 2
net.ipv4.tcp_dsack = 1

允许TCP发送"两个完全相同"的SACK。
}

tcp_mem(){ 786432 1048576 1572864
net.ipv4.tcp_mem = 178368  237824  356736

同样有3个值,意思是: 
net.ipv4.tcp_mem[0]: 低于此值,TCP没有内存压力. 
net.ipv4.tcp_mem[1]: 在此值下,进入内存压力阶段. 
net.ipv4.tcp_mem[2]: 高于此值,TCP拒绝分配socket.

low：当TCP使用了低于该值的内存页面数时，TCP不会考虑释放内存。即低于此值没有内存压力。
     (理想情况下，这个值应与指定给 tcp_wmem 的第 2 个值相匹配 - 这第2个值表明，
      最大页面大小乘以最大并发请求数除以页大小 (tcp_wmem.default -> 131072 * 300 / 4096)。
pressure：当TCP使用了超过该值的内存页面数量时，TCP试图稳定其内存使用，进入pressure模式，当内存消耗低于low值时则退出pressure状态。
         (理想情况下这个值应该是 TCP 可以使用的总缓冲区大小的最大值 (tcp_wmem.max 204800 * 300 / 4096)。)
high：允许所有tcp sockets用于排队缓冲数据报的页面量。
      (如果超过这个值，TCP 连接将被拒绝，这就是为什么不要令其过于保守 (512000 * 300 / 4096) 的原因了。
      在这种情况下，提供的价值很大，它能处理很多连接，是所预期的 2.5 倍；或者使现有连接能够传输 2.5 倍的数据。 
      我的网络里为192000 300000 732000)
一般情况下这些值是在系统启动时根据系统内存数量计算得到的。
}

tcp_wmem(发送缓存设置){ 
net.ipv4.tcp_wmem = 4096   16384       4194304
TCP写buffer,可参考的优化值: 8192436600 873200
min：为TCP socket预留用于发送缓冲的内存最小值。每个tcp socket都可以在建议以后都可以使用它。默认值为4096(4K)。
default：为TCP socket预留用于发送缓冲的内存数量，默认情况下该值会影响其它协议使用的net.core.wmem_default 值，一般要低于net.core.wmem_default的值。默认值为16384(16K)。
max: 用于TCP socket发送缓冲的内存最大值。该值不会影响net.core.wmem_max，"静态"选择参数SO_SNDBUF则不受该值影响。默认值为131072(128K)。

对于服务器而言，增加这个参数的值对于发送数据很有帮助,在我的网络环境中,修改为了51200 131072 204800
}
 
tcp_rmem(接收缓存设置){32768 131072 16777216
net.ipv4.tcp_rmem = 4096     87380       4194304
TCP读buffer,可参考的优化值:32768  436600  873200
}
 
tcp_app_win(保留max数量的窗口由于应用缓冲){31 31
保留max(window/2^tcp_app_win, mss)数量的窗口由于应用缓冲。当为0时表示不需要缓冲。
}
tcp_adv_win_scale(计算缓冲开销){2 2
计算缓冲开销bytes/2^tcp_adv_win_scale(如果tcp_adv_win_scale > 0)
或者bytes-bytes/2^(-tcp_adv_win_scale)(如果tcp_adv_win_scale BOOLEAN>0)
}
tcp_tw_reuse(表示是否允许重新应用处于TIME-WAIT状态的socket用于新的TCP连接){0 1

net.ipv4.tcp_app_win = 31
net.ipv4.tcp_adv_win_scale = 2
net.ipv4.tcp_tw_reuse = 1
表示开启重用。允许将TIME-WAITsockets重新用于新的TCP连接，默认为0，表示关闭；
a. 这个对快速重启动某些服务,而启动后提示端口已经被使用的情形非常有帮助
}
 
tcp_frto(){
net.ipv4.tcp_frto_response = 0
         当F-RTO侦测到TCP超时是伪的时(例如，通过设置了更长的超时值避免了超时),TCP有几个选项决定接下来如何去做。可能的值是：
?  1 基于速率减半;平滑保守的响应，导致一个RTT之后拥塞窗口(cwnd)和慢启动阀值(ssthresh)减半。
?  2非常保守的响应;不推荐这样做，因为即时有效，它和TCP的其他部分交互不好;立即减半拥塞窗口(cwnd)和慢启动阀值(ssthresh)。
?  3侵占性的响应;废弃现在已知不必要的拥塞控制措施(或略一个将引起TCP更加谨慎保守的丢失的重传);cwnd and ssthresh恢复到超时之前的值。

}
tcp_slow_start_after_idle(){
net.ipv4.tcp_slow_start_after_idle = 1
         表示拥塞窗口在经过一段空闲时间后仍然有效而不必重新初始化。
}

tcp_low_latency(允许 TCP/IP 栈适应在高吞吐量情况下低延时的情况；这个选项一般情形是的禁用){0 0
net.ipv4.tcp_low_latency = 0
    允许 TCP/IP 协议栈适应在高吞吐量情况下低延时的情况；这个选项应该禁用。
但在构建Beowulf 集群的时候,打开它很有帮助
}
 
tcp_no_metrics_save(){
net.ipv4.tcp_no_metrics_save = 0
一个tcp连接关闭后,把这个连接曾经有的参数比如慢启动门限snd_sthresh,拥塞窗口snd_cwnd 还有srtt等信息保存到dst_entry中, 只要dst_entry 没有失效,
下次新建立相同连接的时候就可以使用保存的参数来初始化这个连接.tcp_no_metrics_save 设置为1就是不保持这些参数(经验值),每次建立连接后都重新摸索一次. 
我觉得没什么好处. 所以系统默认把它设为0。

}

tcp_moderate_rcvbuf(){

net.ipv4.tcp_moderate_rcvbuf = 1
         打开了TCP内存自动调整功能(1为打开、0为禁止)
}

tcp_tso_win_divisor(){
net.ipv4.tcp_tso_win_divisor = 3
         单个TSO段可消耗拥塞窗口的比例，默认值为3。
}
 
tcp_congestion_control(){}
tcp_available_congestion_control(){}
tcp_allowed_congestion_control(){
net.ipv4.tcp_congestion_control = cubic

net.ipv4.tcp_available_congestion_control = cubic reno

net.ipv4.tcp_allowed_congestion_control = cubic reno
丢包使得TCP传输速度大幅下降的主要原因是丢包重传机制，控制这一机制的就是TCP拥塞控制算法。   congestion(拥塞)
Linux内核中提供了若干套TCP拥塞控制算法，已加载进内核的可以通过内核参数net.ipv4.tcp_available_congestion_control看到：
没有加载进内核的一般是编译成了模块，可以用modprobe加载，这些算法各自适用于不同的环境。
?  reno是最基本的拥塞控制算法，也是TCP协议的实验原型。
?  bic适用于rtt较高但丢包极为罕见的情况，比如北美和欧洲之间的线路，这是2.6.8到2.6.18之间的Linux内核的默认算法。
?  cubic是修改版的bic，适用环境比bic广泛一点，它是2.6.19之后的linux内核的默认算法。
?  hybla适用于高延时、高丢包率的网络，比如卫星链路。
载入tcp_hybl模块 modprobe tcp_hybla
TCP拥塞控制         算法对TCP传输速率的影响可很大。
}


net.ipv4.tcp_abc = 0
net.ipv4.tcp_mtu_probing = 0
net.ipv4.tcp_fastopen
         GoogleTFO特性，kernel 3.6以上版本支持，具体实现方法参考本文档 Google TFO特性。

net.ipv4.tcp_base_mss= 512
分组层路径MTU发现(MTU探测)中使用的search_low的初始值。如果允许MTU探测，这个初始值就是连接使用的初始MSS值。

net.ipv4.route.min_adv_mss= 256
该文件表示最小的MSS（MaximumSegment Size）大小，取决于第一跳的路由器MTU。

net.ipv4.tcp_workaround_signed_windows = 0
net.ipv4.tcp_dma_copybreak= 4096

         下限.以字节为单位.socket 的大小将卸载到一个 dma 复制引擎.如果存在一个在系统和内核配置为使用 config_net_dma 选项。

net.ipv4.tcp_max_ssthresh= 0
慢启动阶段，就是当前拥塞窗口值比慢启动阈值(snd_ssthresh)小的时候，所处的阶段就叫做慢启动阶段。
当我们收到一个新的ACK时，则会调用tcp_slow_start()这个函数，并且为拥塞窗口增加1.(Linux中拥塞窗口的值代表数据包的个数，而不是实际的发送
字节数目。实际可以发送的字节数等于可以发送的数据包个数*MSS。)
直到慢启动阶段出现数据包的丢失。
而引入了tcp_max_ssthresh 这个参数后，则可以控制在慢启动阶段拥塞窗口增加的频度。
默认这个参数不打开，如果这个参数的值设置为1000，则当拥塞窗口值大于1000时，
则没收到一个ACK，并不再增加拥塞窗口一个单位了，而是约收到2个ACK才增加一个窗口单位。收到2ACK并不是决定值！！
需要根据当前的拥塞窗口值，tcp_max_ssthresh值进行判断。

net.ipv4.tcp_thin_linear_timeouts= 0
这个函数RTO超时的处理函数。如果是thin流，则不要新设RTO是原先的2倍。

net.ipv4.tcp_thin_dupack= 0
         与tcp_thin_linear_timeouts同为快速重传算法参数

net.core.netdev_max_backlog=300
进入包的最大设备队列.默认是300,对重负载服务器而言,该值太低,可调整到1000。

ip link set eth0 mtu 1500
         设置网卡mtu大小。

 TIME_WAIT()
 {
 Linux系统下，TCP/IP连接断开后，会以TIME_WAIT状态保留一定的时间，然后才会释放端口。当并发请求过多的时候，就会产生大量的TIME_WAIT状态的连接，无法及时断开的话，会占用大量的端口资源和服务器资源（因为关闭后进程才会退出）。这个时候我们可以考虑优化TCP/IP的内核参数，来及时将TIME_WAIT状态的端口清理掉。

本文介绍的方法只对拥有大量TIME_WAIT状态的连接导致系统资源消耗有效，不是这个原因的情况下，效果可能不明显。那么，到哪儿去查TIME_WAIT状态的连接呢？那就是使用netstat命令。我们可以输入一个复核命令，去查看当前TCP/IP连接的状态和对应的个数：

    #netstat -n | awk ‘/^tcp/ {++S[$NF]} END {for(a in S) print a, S[a]}’

这个命令会显示出类似下面的结果：

    LAST_ACK 14 
    SYN_RECV 348 
    ESTABLISHED 70 
    FIN_WAIT1 229 
    FIN_WAIT2 30 
    CLOSING 33 
    TIME_WAIT 18122

我们只用关心TIME_WAIT的个数，在这里可以看到，有18000多个TIME_WAIT，这样就占用了18000多个端口。要知道端口的数量只有65535个，占用一个少一个，会严重的影响到后继的新连接。这种情况下，我们就有必要调整下Linux的TCP/IP内核参数，让系统更快的释放TIME_WAIT连接。

我们用vim打开配置文件：

    #vim /etc/sysctl.conf

然后，在这个文件中，加入下面的几行内容：

    net.ipv4.tcp_syncookies = 1 
    net.ipv4.tcp_tw_reuse = 1 
    net.ipv4.tcp_tw_recycle = 1 
    net.ipv4.tcp_fin_timeout = 30

最后输入下面的命令，让内核参数生效：

    #/sbin/sysctl -p

简单的说明下，上面的参数的含义：

net.ipv4.tcp_syncookies = 1 表示开启SYN Cookies。当出现SYN等待队列溢出时，启用cookies来处理，可防范少量SYN攻击，默认为0，表示关闭； 
net.ipv4.tcp_tw_reuse = 1 表示开启重用。允许将TIME-WAIT sockets重新用于新的TCP连接，默认为0，表示关闭； 
net.ipv4.tcp_tw_recycle = 1 表示开启TCP连接中TIME-WAIT sockets的快速回收，默认为0，表示关闭； 
net.ipv4.tcp_fin_timeout 修改系統默认的 TIMEOUT 时间。

在经过这样的调整之后，除了会进一步提升服务器的负载能力之外，还能够防御一定程度的DDoS、CC和SYN攻击，是个一举两得的做法。

此外，如果你的连接数本身就很多，我们可以再优化一下TCP/IP的可使用端口范围，进一步提升服务器的并发能力。依然是往上面的参数文件中，加入下面这些配置：

    net.ipv4.tcp_keepalive_time = 1200 
    net.ipv4.ip_local_port_range = 10000 65000 
    net.ipv4.tcp_max_syn_backlog = 8192 
    net.ipv4.tcp_max_tw_buckets = 5000

这几个参数，建议只在流量非常大的服务器上开启，会有显著的效果。一般的流量小的服务器上，没有必要去设置这几个参数。这几个参数的含义如下：

net.ipv4.tcp_keepalive_time = 1200 表示当keepalive起用的时候，TCP发送keepalive消息的频度。缺省是2小时，改为20分钟。 
net.ipv4.ip_local_port_range = 10000 65000 表示用于向外连接的端口范围。缺省情况下很小：32768到61000，改为10000到65000。（注意：这里不要将最低值设的太低，否则可能会占用掉正常的端口！） 
net.ipv4.tcp_max_syn_backlog = 8192 表示SYN队列的长度，默认为1024，加大队列长度为8192，可以容纳更多等待连接的网络连接数。 
net.ipv4.tcp_max_tw_buckets = 5000 表示系统同时保持TIME_WAIT的最大数量，如果超过这个数字，TIME_WAIT将立刻被清除并打印警告信息。默 认为180000，改为5000。对于Apache、Nginx等服务器，上几行的参数可以很好地减少TIME_WAIT套接字数量，但是对于 Squid，效果却不大。此项参数可以控制TIME_WAIT的最大数量，避免Squid服务器被大量的TIME_WAIT拖死。

经过这样的配置之后，你的服务器的TCP/IP并发能力又会上一个新台阶。
 }
 
netfilter(){
所处目录/proc/sys/net/ipv4/netfilter/

文件需要打开防火墙才会存在
名称                                默认值 建议值 描述
ip_conntrack_max                    65536   65536
系统支持的最大ipv4连接数，默认65536（事实上这也是理论最大值），同时这个值和你的内存大小有关，如果内存128M，这个值最大8192，1G以上内存这个值都是默认65536,这个值受/proc/sys/net/ipv4/ip_conntrack_max限制
ip_conntrack_tcp_timeout_established 432000 180
已建立的tcp连接的超时时间，默认432000，也就是5天。影响：这个值过大将导致一些可能已经不用的连接常驻于内存中，占用大量链接资源，从而可能导致NAT ip_conntrack: table full的问题。建议：对于NAT负载相对本机的NAT表大小很紧张的时候，可能需要考虑缩小这个值，以尽早清除连接，保证有可用的连接资源；如果不紧张，不必修改
ip_conntrack_tcp_timeout_time_wait   120    120
time_wait状态超时时间，超过该时间就清除该连接
ip_conntrack_tcp_timeout_close_wait  60     60
close_wait状态超时时间，超过该时间就清除该连接
ip_conntrack_tcp_timeout_fin_wait    120    120
fin_wait状态超时时间，超过该时间就清除该连接
}

core(){
netdev_max_backlog      1024        16384
每个网络接口接收数据包的速率比内核处理这些包的速率快时，允许送到队列的数据包的最大数目，对重负载服务器而言，该值需要调高一点。
somaxconn               128         16384
用来限制监听(LISTEN)队列最大数据包的数量，超过这个数量就会导致链接超时或者触发重传机制。
web应用中listen函数的backlog默认会给我们内核参数的net.core.somaxconn限制到128，而nginx定义的NGX_LISTEN_BACKLOG默认为511，所以有必要调整这个值。对繁忙的服务器,增加该值有助于网络性能
wmem_default            129024      129024
默认的发送窗口大小（以字节为单位）
rmem_default            129024      129024
默认的接收窗口大小（以字节为单位）
rmem_max                129024      873200
最大的TCP数据接收缓冲
wmem_max                129024      873200
最大的TCP数据发送缓冲
}
IP(相关部份)
{
net.ipv4.ip_local_port_range = 1024 65000
表示用于向外连接的端口范围。缺省情况下很小：32768到61000，改为1024到65000。

net.ipv4.ip_conntrack_max = 655360
在内核内存中netfilter可以同时处理的"任务"（连接跟踪条目）another
系统支持的最大ipv4连接数，默认65536（事实上这也是理论最大值），同时这个值和你的内存大小有关，如果内存128M，这个值最大8192，1G以上内存这个值都是默认65536

# 避免放大攻击
net.ipv4.icmp_echo_ignore_broadcasts = 1

# 开启恶意icmp错误消息保护
net.ipv4.icmp_ignore_bogus_error_responses = 1


# 开启SYN洪水攻击保护
net.ipv4.tcp_syncookies = 1

# 开启并记录欺骗，源路由和重定向包
net.ipv4.conf.all.log_martians = 1
net.ipv4.conf.default.log_martians = 1

# 处理无源路由的包
net.ipv4.conf.all.accept_source_route = 0
net.ipv4.conf.default.accept_source_route = 0

 

# 开启反向路径过滤
net.ipv4.conf.all.rp_filter = 1
net.ipv4.conf.default.rp_filter = 1

 

# 确保无人能修改路由表
net.ipv4.conf.all.accept_redirects = 0
net.ipv4.conf.default.accept_redirects = 0
net.ipv4.conf.all.secure_redirects = 0
net.ipv4.conf.default.secure_redirects = 0

 

# 不充当路由器
net.ipv4.ip_forward = 0 # NAT必须开启IP转发支持，把该值写1
net.ipv4.conf.all.send_redirects = 0
net.ipv4.conf.default.send_redirects = 0

# 开启execshild
kernel.exec-shield = 1
kernel.randomize_va_space = 1
}


sys(网络相关部份)
{
网络相关部份(/sys)
sys/class/net/eth0/statistics.rx_packets:
收到的数据包数据
sys/class/net/eth0/statistics.tx_packets:
传输的数据包数量
sys/class/net/eth0/statistics.rx_bytes:
接收的字节数
sys/class/net/eth0/statistics.tx_bytes:
传输的字节数
sys/class/net/eth0/statistics.rx_dropped:
收包时丢弃的数据包
sys/class/net/eth0/statistics.tx_dropped:
发包时丢弃的数据包
}

rmem_max和rmem_default和wmem_max和wmem_default:
    rmem_default: 默认的socket的接收buffer的设置, 字节为单位.
    rmem_max: socket的最大接收buffer的设置, 字节为单位.
    wmem_default: 默认的socket的发送buffer的设置, 字节为单位.
    wmem_max: socket的最大发送buffer的设置, 字节为单位.

optmem_max # 每个socket的辅助buffer的最大size, 辅助buffer是一个带有appended data的struct cmsghdr的序列.
tcp(nf_conntrack){
# 设置socket的listen的backlog队列, 当调用listen时指定的backlog大于该值时使用该值.
    查看 tcp 的 established queue 大小： cat /proc/sys/net/core/somaxconn
    netdev_max_backlog # 当网卡接收速度大于cpu的处理速度时, 将package放入cpu的backlog队列, 参见net/dev.c.
    /proc/sys/net/core/dev_weight # 在一个NAPI中断中, kernel可以处理的packets的最大数量, 是一个Per-CPU变量, 默认为64.
    
    查看 tcp 的 syn recv queue 大小： cat /proc/sys/net/ipv4/tcp_max_syn_backlog
    暂时未知： ss -lt
    查看socket摘要： ss -s
    Display summary statistics for each protocol： netstat -s
系统收到 syn 请求，先放到 syn recv queue；收到client第二次 ack时，从 syn recv queue取出来，放入 established queue。
    查看服务器上各个socket连接数： cat /proc/net/sockstat
    查看服务器tcp各个状态连接数： ss -ant | awk 'NR>1 {++s[$1]} END {for(k in s) print k,s[k]}'
    查看服务器tcp的各个状态连接数： netstat -n | awk '/^tcp/ {++S[$NF]} END {for(a in S) print a, S[a]}'
    查看tcp的本机可用端口范围：cat /proc/sys/net/ipv4/ip_local_port_range
    查看 tcp udp 已占用的端口数：netstat -an | grep -e tcp -e udp | wc -l
    /proc/sys/net/ipv4/tcp_timestamps - 控制timestamp选项开启/关闭
    /proc/sys/net/ipv4/tcp_tw_recycle - 减少timewait socket释放的超时时间
    /proc/sys/net/ipv4/tcp_abort_on_overflow 当 accept queue 满时，是否立即返回 RST 包给client
    
    http://www.toptip.ca/2010/02/linux-eaddrnotavail-address-not.html
    
    linux上跟踪某个process的内部系统调用时间： strace -s128 -ttt -p process_id -c
    
    nf_conntrack: table full, dropping packet # https://testerhome.com/topics/7509
    
    
nf_conntrack是Linux内核连接跟踪的模块，常用在iptables中，比如
  -A INPUT -m state --state RELATED,ESTABLISHED -j RETURN 
  -A INPUT -m state --state INVALID -j DROP
可以通过cat /proc/net/nf_conntrack来查看当前跟踪的连接信息，这些信息以哈希形式（用链地址法处理冲突）存在内存中，
并且每条记录大约占300B空间。

与nf_conntrack相关的内核参数有三个：
    nf_conntrack_max：连接跟踪表的大小，建议根据内存计算该值CONNTRACK_MAX = RAMSIZE (in bytes) / 16384 / (x / 32)，并满足nf_conntrack_max=4*nf_conntrack_buckets，默认262144
    nf_conntrack_buckets：哈希表的大小，(nf_conntrack_max/nf_conntrack_buckets就是每条哈希记录链表的长度)，默认65536
    nf_conntrack_tcp_timeout_established：tcp会话的超时时间，默认是432000 (5天)
比如，对64G内存的机器，推荐配置：
    net.netfilter.nf_conntrack_max=4194304
    net.netfilter.nf_conntrack_tcp_timeout_established=300
    net.netfilter.nf_conntrack_buckets=1048576
}

nf_conntrack(kernel){
kernel: nf_conntrack: table full, dropping packet.

最近查看服务器日志，发现有报错

Nov 14 07:35:11 ftp2 kernel: nf_conntrack: table full, dropping packet.

修改内核文件

vi /etc/sysctl.conf
net.ipv4.netfilter.ip_conntrack_max = 655350
net.ipv4.netfilter.ip_conntrack_tcp_timeout_established = 1200
#默认超时时间为5天，作为一个主要提供HTTP服务的服务器来讲，完全可以设置得比较短
sysctl -p # 让刚刚修改过的设置生效

如果在执行sysctl -p 时提示错误 unknown key，那么表示内核版本比较高，报错信息如下

error: "net.ipv4.netfilter.ip_conntrack_max" is an unknown key
error: "net.ipv4.netfilter.ip_conntrack_tcp_timeout_established" is an unknown key

重新修改为:

net.netfilter.nf_conntrack_max = 655350
net.netfilter.nf_conntrack_tcp_timeout_established = 1200
}
tcp_overflow(kernel){
kernel: TCP: time wait bucket table overflow

查看 netstat -an | grep 21 |awk '{print $6}' |sort | uniq -c | sort -rn

  16606 TIME_WAIT
    313 ESTABLISHED
    149 LISTEN
     32 CONNECTED
     25 FIN_WAIT1
      4 STREAM
      2 SYN_RECV
      2 LAST_ACK
      2 
      1 FIN_WAIT2
      1 9210
      1 2862128444
      1 12162
}
common(kernel){
通过调整内核参数解决 vi /etc/sysctl.conf

编辑文件，加入以下内容：
net.ipv4.tcp_syncookies = 1
net.ipv4.tcp_tw_reuse = 1
net.ipv4.tcp_tw_recycle = 1
net.ipv4.tcp_fin_timeout = 30

然后执行/sbin/sysctl -p让参数生效。
net.ipv4.tcp_syncookies = 1表示开启SYN Cookies。当出现SYN等待队列溢出时，启用cookies来处理，可防范少量SYN攻击，默认为0，表示关闭；
net.ipv4.tcp_tw_reuse = 1表示开启重用。允许将TIME-WAIT sockets重新用于新的TCP连接，默认为0，表示关闭；
net.ipv4.tcp_tw_recycle = 1表示开启TCP连接中TIME-WAIT sockets的快速回收，默认为0，表示关闭。
net.ipv4.tcp_fin_timeout修改系統默认的TIMEOUT时间
修改之后，再用命令查看TIME_WAIT连接数 netstat -ae|grep "TIME_WAIT" |wc –l
发现大量的TIME_WAIT 已不存在，mysql进程的占用率很快就降下来的，网站访问正常。
}
rfc(){
793	TCP标准	最初的TCP标准定义，但不包括TCP相关操作细节
813	TCP窗口与确认策略	讨论窗口确认机制，以及描述了在使用该机制有时遇到的问题及解决方法
879	TCP最大分段大小及相关主题	讨论MSS参数在控制TCP分组大小的重要性，以及该参数与IP分段大小的关系等
896	IP/TCP网络互联拥塞控制	探讨拥塞问题与TCP如何控制拥塞
1122	网络主机要求——通讯层	讨论TCP如何在主机中实现的细节
1146	可选的TCP校验和选项	针对TCP设备使用可选校验和方法进行规范
1323	高性能下的TCP扩展	定义高速网络中TCP的扩展及新选项
2018	TCP选择确认	TCP基础功能的增强，讨论TCP设备如何选择性的制定特定字段来重传
2525	已知TCP的问题	描述当前已知的部分TCP问题
2581	TCP拥塞控制	描述用于拥塞控制的四种机制：慢启动、拥塞防御、快重传和快恢复
2988	TCP重传计时器计算	讨论与TCP重传计时器设置相关话题，重传计时器控制报文在重传前应等待多长时间
}