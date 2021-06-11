# https://github.com/MaxKellermann/ferm/blob/ffaf332b7e80aeb8c60294da5e732e1eb1f1d6af/doc/ferm.pod # iptables封装

# conntrack -L
# iptstate -t


# https://www.netfilter.org/documentation/HOWTO/



# 20210423
# http://arthurchiao.art/blog/conntrack-design-and-implementation-zh/    Chinese
# http://arthurchiao.art/blog/conntrack-design-and-implementation/       English
conntrack_i_intro(){ cat - <<'conntrack_i_intro'
1. conntrack - command line interface for netfilter connection tracking  # https://manpages.debian.org/unstable/conntrack/conntrack.8.en.html
2. conntrackd - netfilter connection tracking user-space daemon          # https://manpages.debian.org/unstable/conntrackd/conntrackd.8.en.html
conntrack: command line interface, it is a replacement of /proc/net/nf_conntrack                   # http://dune.lsi.us.es/~pablo/conntrack­tools.html 替代proc
conntrackd: daemon to handle state synchronization (to enable highly available stateful firewalls) # http://dune.lsi.us.es/~pablo/conntrack­tools.html 高可用
    – a simple flow­based statistics collector. 
    – state table synchronizer: it propagates asynchronously the state­changes between stateful firewall replicas to achieve high availability.
    - Asynchronous replication based on multicast
        NOTRACK: like pfsync, a best effort protocol, no sequence tracking at all.
        ALARM: Every N seconds a state message is sent (spamming but resolve well unconsistencies between nodes).
        FT­FW: Reliable protocol (with sequence tracking). Still experimental but a lot of progress on the way.

root@mdm9650-perf:/proc/1004/net# cat ip_conntrack
icmp     1 29 src=192.168.225.33 dst=192.168.225.1 type=8 code=0 id=20296 src=192.168.225.1 dst=192.168.225.33 type=0 code=0 id=20296 mark=0 use=2
unknown  2 531 src=0.0.0.0 dst=224.0.0.1 [UNREPLIED] src=224.0.0.1 dst=0.0.0.0 mark=0 use=2
icmp     1 29 src=192.168.225.33 dst=192.168.225.1 type=8 code=0 id=19466 src=192.168.225.1 dst=192.168.225.33 type=0 code=0 id=19466 mark=0 use=2
icmp     1 29 src=192.168.225.33 dst=192.168.225.1 type=8 code=0 id=20260 src=192.168.225.1 dst=192.168.225.33 type=0 code=0 id=20260 mark=0 use=2


root@mdm9650-perf:/proc/1004/net# cat stat/ip_conntrack 
entries  searched found new invalid ignore delete delete_list insert insert_failed drop early_drop icmp_error  expect_new expect_create expect_delete search_restart
00000004  00000000 000416b9 0000001f 00000000 0000007e 0000001b 0000001b 0000001f 00000000 00000000 00000000 00000000  00000000 00000000 00000000 00000000

IPTables 和连接跟踪
    连接跟踪系统使得 iptables 基于连接上下文而不是单个包来做出规则判断，给 iptables 提供了有状态操作的功能。
    连接跟踪在包进入协议栈之后很快就开始工作了。在给包分配连接之前所做的工作非常少，只有检查 raw table 和一些基本的完整性检查。
    跟踪系统将包和已有的连接进行比较，如果包所属的连接已经存在就更新连接状态，否则就 创建一个新连接。如果 raw table 的某个 chain 对包标记为目标是 NOTRACK，
那这个包会跳过连接跟踪系统。

连接的状态
连接跟踪系统中的连接状态有：
    NEW：        如果到达的包关连不到任何已有的连接，但包是合法的，就为这个包创建一个新连接。对 面向连接的的协议例如 TCP 以及非面向连接的的协议例如 UDP 都适用
    ESTABLISHED：当一个连接收到应答方向的合法包时，状态从 NEW 变成 ESTABLISHED。对 TCP 这个合法包其实就是 SYN/ACK 包；对 UDP 和 ICMP 是源和目 的 IP 与原包相反的包
    RELATED：    包不属于已有的连接，但是和已有的连接有一定关系。这可能是辅助连接(helper connection)，例如 FTP 数据传输连接，或者是其他协议试图建立连接时的 ICMP 应答包
    INVALID：    包不属于已有连接，并且因为某些原因不能用来创建一个新连接，例如无法识别、无法路由等等
    UNTRACKED：  如果在 raw table 中标记为目标是 UNTRACKED，这个包将不会进入连 接跟踪系统
    SNAT：       包的源地址被 NAT 修改之后会进入的虚拟状态。连接跟踪系统据此在收到 反向包时对地址做反向转换
    DNAT：       包的目的地址被 NAT 修改之后会进入的虚拟状态。连接跟踪系统据此在收到 反向包时对地址做反向转换
这些状态可以定位到连接生命周期内部，管理员可以编写出更加细粒度、适用范围更大、更 安全的规则。


https://people.netfilter.org/pablo/docs/login.pdf
https://wiki.aalto.fi/download/attachments/69901948/netfilter-paper.pdf
http://conntrack-tools.netfilter.org/support.html -> http://conntrack-tools.netfilter.org/files/conntrackd-nfws.pdf
https://www.frozentux.net/iptables-tutorial/iptables-tutorial.html#STATEMACHINE
conntrack_i_intro
}

iptables_p_graph(){ cat - <<'iptables_p_graph'
                               [PREROUTING]                                     NO     [INPUT]
Incoming Packet -> raw|connection(state) tracking|mangle|nat -> For this host? ----> mangle|filter --> Local Process -> Local Generated packeted -> Routing Decision
                                                                     |   Yes           [FORWARD]       [POSTROUTING]                                      |
                                                                     |-------------> mangle|filter --> mangle|nat --> OutGoing Packet                     |
                                                                                                   /|\                                                    |
                                                                                   |----------------|                                                     |
                                                                                filter <- Routing Decision <- raw|connection(state) tracking|mangle|nat <-|
                                                                                                            [OUTPUT]  
iptables_p_graph
}


cat - <<'EOF'
nftables主要使用与传统iptables相同的Netfilter基础设施。
    钩子基础设施、         hook infrastructure
    连接跟踪系统、         Connection Tracking System  (conntrack | ct) # https://wiki.nftables.org/wiki-nftables/index.php/Connection_Tracking_System
                                                                        # https://en.wikipedia.org/wiki/Stateful_firewall
    NAT引擎、              NAT engine (依赖conntrack功能)
    日志基础设施和         logging infrastructure
    用户空间队列           userspace queueing 
保持不变。
只有数据包分类框架是新的。 he packet classification framework


iptables 是一个全面的过滤和矫正系统(a comprehensive filtering and mangling system)
iptables : IPV4      nftables nft工具  /proc/sys/net/bridge/bridge-nf-call-iptables
ip6tables: IPV6      nftables nft工具  /proc/sys/net/bridge/bridge-nf-call-ip6tables
arptables: ARP过滤   nftables nft工具  /proc/sys/net/bridge/bridge-nf-call-arptables
etables  : 桥过滤    nftables nft工具
                                       /proc/sys/net/bridge/bridge-nf-filter-vlan-tagged
                                       /proc/sys/net/bridge/bridge-nf-filter-pppoe-tagged
https://wiki.openwrt.org/doc/howto/netfilter#log  # openwrt防火墙
nmap -sT 222.41.217.210

bash/init.d/iptables    # iptables -- 大局观
cheatsheet/iptables实例 # iptables -- 清晰分类

/proc/net/ip_tables_matches
/proc/net/ip_tables_names
/proc/net/ip_tables_targets
/proc/net/nf_conntrack
/proc/net/netfilter/

http://www.faqs.org/docs/iptables/
https://www.frozentux.net/iptables-tutorial/cn/
https://github.com/frznlogic
man iptables
man iptables-extensions
firewall/scripts/rc.test-iptables.txt  # iptables_i_netfilter_
https://github.com/DamienRobert/Documentation -> logiciels
https://doc.lagout.org/network/
@ 设计哲学: 规则就是决定如何处理一个包的语句；
@ 设计哲学: 修订packet(IP层，tcp|udp|icmp层)和修订packet间关系
EOF

# https://www.digitalocean.com/community/tutorials/how-to-choose-an-effective-firewall-policy-to-secure-your-servers # 继续
# https://www.digitalocean.com/community/tutorials/a-deep-dive-into-iptables-and-netfilter-architecture # English
# http://arthurchiao.art/blog/deep-dive-into-iptables-and-netfilter-arch-zh/                            # Chinese
iptables_i_intro(){ cat - <<'iptables_i_intro'
@ -> 说明: 1. netfilter和iptables 之间的关系，
           2. 构成filter和mangle,nat功能的 关联部分 
           3. iptables 是 table 和 chain 构成的功能；table抽象业务(最高视角)，chain分解业务(次高视角) rule定制业务(最低视角)。openwrt 通过设计chain 来规范业务(wan|lan)
iptables 是一个全面的   过滤和修订 数据包           的系统(a comprehensive filtering and mangling system) 
iptables 是一个与内核的 netfilter数据包过滤框架对接 的广泛使用的防火墙工具 # 1. iptables依赖netfilter框架(hook系统) 2. netfilter(hook系统)依赖网络协议栈
         是重要的防火墙工具      @保护服务和硬件设施，
         是广泛使用的防火墙工具  @基于netfilter的包过滤功能
         难点 1. 具有挑战性的语法；2. netfilter框架由相互关联的几部分构成
netfilter是由内核网络协议栈中的hooks构成的，# 网络协议栈中的hooks构成了 netfilter 系统；允许在hook点注册程序，允许程序处理经过hook点的数据包，程序确保根据iptables配置的规则管理流量。

[hook 数据包 注册处理函数 规则] # hook类型: 决定处理函数如何处理数据包(策略注册点)； 注册处理函数: 决定包可以被如何处理(机制)？配置的规则: 决定处理函数如何处理包(策略)？  
                                # 注册处理函数提供机制，配置的规则提供策略。包是处理函数要操作的对象，hook是处理函数链表节点的链表头。
                                # HOOK既受目的地址(路由)规定(目的地址决定经过那个hook)，又可以修改目的地址(hook修改目的地址或源地址内容)
                                # 数据包输入，输出方向，数据包目的地址，数据包是否会被前面hook点drop|reject -> 决定数据包能否经过特定hook.
    每个进入网络系统的数据包(接收或发送)在经过协议栈时都会触发这些 hook，程序可以通过注册 hook 函数的方式在一些关键路径上处理网络流量。
iptables 相关的内核模块在这些 hook 点注册了处理函数，因此可以通过配置 iptables 规则来使得网络流量符合防火墙规则。

[Netfilter Hooks]  hook_head; hook_cbs(packets) 通过数据包驱动注册在hook上的回调函数按顺序执行。
    netfilter 提供了 5 个 hook 点。包经过协议栈时会触发内核模块注册在这里的处理函数。触发哪个 hook 取决于包的方向(是发送还是接收)、
包的目的地址、以及包在上一个 hook 点是被丢弃还是拒绝等等。
    NF_IP_PRE_ROUTING:  接收到的包进入协议栈后立即触发此 hook，在进行任何路由判断(将包发往哪里)之前
    NF_IP_LOCAL_IN:     接收到的包经过路由判断，如果目的是本机，将触发此 hook
    NF_IP_FORWARD:      接收到的包经过路由判断，如果目的是其他机器，将触发此 hook
    NF_IP_LOCAL_OUT:    本机产生的准备发送的包，在进入协议栈后立即触发此 hook
    NF_IP_POST_ROUTING: 本机产生的准备发送的包或者转发的包，在经过路由判断之后，将触发此 hook

注册处理函数时必须提供优先级，以便 hook 触发时能按照 优先级高低调用处理函数。
这使得多个模块(或者同一内核模块的多个实例)可以在同一 hook 点注册，并且有确定的处理顺序。
内核模块会依次被调用，每次返回一个结果给 netfilter 框架，提示该对这个包做什么操作。


[IPTables 表和链] chain 和 hook 之间的关系； table是用来管理rule -> 体现功能。chain是用来设计符合特定功能的rule。
iptables 使用 table 来组织规则，根据用来做什么类型的判断标准，将规则分为不同 table。
例如，如果规则是处理 网络地址转换的，那会放到 nat table；
      如果是判断是否允许包继续向前，那可能会放到 filter table。
在每个iptables表中，rule 被进一步组织在单独的"chain"中。虽然表是由它们所持有的规则的一般目标来定义的，但内置链代表了触发它们的netfilter滤钩。链基本上决定了规则何时会被执行。

内置 chain 的名称对应了 它们所关联的 netfilter hooks 的名称
    PREROUTING:  由 NF_IP_PRE_ROUTING hook 触发
    INPUT:       由 NF_IP_LOCAL_IN hook 触发
    FORWARD:     由 NF_IP_FORWARD hook 触发
    OUTPUT:      由 NF_IP_LOCAL_OUT hook 触发
    POSTROUTING: 由 NF_IP_POST_ROUTING hook 触发
    chain 允许管理员控制在数据包的传递路径中，规则将被 执行 的位置。因为每个 table 有多个 chain，因此一个 table 可以在处理过程中的多个地方施加影响。
特定类型的规则只在协议栈的特定点有意义，因此并不是每个 table 都 会在内核的每个 hook 注册 chain。

[table 种类]
4.1 Filter Table
    filter table 是最常用的 table 之一，是让一个数据包继续向其预定目的地发送，还是拒绝其请求。
    在防火墙领域，这通常称作"过滤"包("filtering" packets)。这个 table 提供了防火墙 的一些常见功能。
    
4.2 NAT Table
    nat table 用于实现网络地址转换规则。
    当包进入协议栈的时候，这些规则决定是否以及如何修改包的源/目的地址，以改变包被 路由时的行为。nat table 通常用于将包路由到无法直接访问的网络。

4.3 Mangle Table
    mangle （修正）table 用于修改包的 IP 头。
    例如，可以修改包的 TTL，增加或减少包可以经过的跳数。
    这个 table 还可以对包打只在内核内有效的"标记"(internal kernel "mark")，后续的 table 或工具处理的时候可以用到这些标记。标记不会修改包本身，只是在包的内核表示上做标记。

4.4 Raw Table -> tcp连接，会话管理
    iptables 防火墙是有状态的：对每个包进行判断的时候是依赖已经判断过的包。
    建立在 netfilter 之上的连接跟踪(connection tracking)特性使得 iptables 将包看作已有的连接或会话的一部分，
而不是一个由独立、不相关的包组成的流。连接跟踪逻 辑在包到达网络接口之后很快就应用了。
    raw table 定义的功能非常有限，其唯一目的就是提供一个让包绕过连接跟踪的框架。

4.5 Security Table
    security table 的作用是给包打上 SELinux 标记，以此影响 SELinux 或其他可以解读 SELinux 安全上下文的系统处理包的行为。这些标记可以基于单个包，也可以基于连接。

[每种 table 实现的 chain] -> 当一个包触发 netfilter hook 时，处理过程将沿着列从上向下执行。 
Tables/Chains   PREROUTING  INPUT   FORWARD	OUTPUT  POSTROUTING
(路由判断)         |          |        |     | Y       |          (routing decision)
raw                | Y        |        |     | Y       |          raw
(连接跟踪）        | Y        |        |     | Y       |          (connection tracking enabled)
mangle             | Y        | Y      | Y   | Y       | Y        mangle
nat (DNAT)         | Y        |        |     | Y       |          nat (DNAT)
(路由判断)         | Y        |        |     | Y       |          (routing decision)
filter             |          | Y      | Y   | Y       |          filter
security           |          | Y      | Y   | Y       |          security
nat (SNAT)         |          | Y      |     | Y       | Y        nat (SNAT)

当一个包触发 netfilter hook 时，处理过程将沿着列从上向下执行。 触发哪个 hook(列)和包的方向(ingress/egress)、路由判断、过滤条件等相关。
特定事件会导致 table 的 chain 被跳过。例如，只有每个连接的第一个包会去匹配 NAT 规则，对这个包的动作会应用于此连接后面的所有包。到这个连接的应答包会被自动应用反方向的 NAT 规则。

[Targets]
1. Terminating targets      终止目标执行一个动作，终止链内的评估并将控制权返回给netfilter钩子。根据所提供的返回值，hook可能会放弃数据包或允许数据包继续进入下一阶段的处理。
2. Non-terminating targets  非终止目标执行一个动作并在链内继续评价。尽管每条链最终都必须传回一个最终的终止决定，但任何数量的非终止目标都可以在之前被执行
[Jumping to User-Defined Chains]
iptables 支持管理员创建他们自己的用于管理目的的 chain。
向用户自定义 chain 添加规则和向内置的 chain 添加规则的方式是相同的。不同的地方在于，用户定义的 chain 只能通过从另一个规则跳转(jump)到它，因为它们没有注册到 netfilter hook。
用户定义的 chain 可以看作是对调用它的 chain 的扩展。例如，用户定义的 chain 在结 束的时候，可以返回 netfilter hook，也可以继续跳转到其他自定义 chain。
iptables_i_intro
}


iptables_p_tables_chain(){ cat - <<'EOF'
iptables [-t table] command [match] [target/jump]
          -t [nat|mangle|filter]    table与target之间关系? table与chain之间关系? table与command之间关系?

1.table与chain之间关系? 
1.1 关系的构建
command -A, --append
        -D, --delete
        -R, --replace
        -I, --insert
1.2 关系的修订
        -L, --list
        -F, --flush
        -Z, --zero
        
2.默认chain与自定义chain之间关系?  
command -N, --new-chain
        -X, --delete-chain
        -P, --policy
        -E, --rename-chain
3. 选项: --list, --append, --insert, --delete, --replace
--list                          |   -x, --exact（精确的）
--list                          |   -n, --numeric（数值）
--list                          |   --line-numbers
--insert, --append, --replace   |   -c, --set-counters

match: 协议 -p tcp|udp|icmp; -m state|ctstate; 
第一类是generic matches（通用的匹配)，适用于所有的规则；
第二类是TCP matches，顾名思 义，这只能用于TCP包；
第三类是UDP matches， 当然它只能用在UDP包上了；
第四类是ICMP matches ，针对ICMP包的；
第五类比较特殊，针对的是状态(state)，所有者(owner)和访问的频率限制(limit)等

jump:  处理 -j ACCEPT | REJECT 
EOF
}
iptables_i_tables_chain(){ cat - <<'EOF'
raw:PREROUTING,OUTPUT    # 关闭nat表上启用的连接追踪机制；要求: ip_conntrack 内核驱动支持
连接跟踪机制: NEW，ESTABLISHED，RELATED和INVALID # iptables -m state  -h -> 谁或什么能发起新的会话
除了本地产生的包由OUTPUT链处理外，所有连接跟踪都是在PREROUTING链里进行处理的，
意思就是， iptables会在PREROUTING链里从新计算所有的状态。
如果我们发送一个流的初始化包，状态就会在OUTPUT链 里被设置为NEW，当我们收到回应的包时，状态就会在PREROUTING链里被设置为ESTABLISHED。
如果第一个包不是本地产生的，那就会在PREROUTING链里被设置为NEW状态。
综上，所有状态的改变和计算都是在nat表中的PREROUTING链和OUTPUT链里完成的。

filter:INPUT,OUTPUT,FORWARD
几乎所有的target都可以在这儿使用。

nat:PREROUTING,POSTROUTING,OUTPUT # 也就是转换包的源或目标地址
DNAT:你有一个合法的IP地址，要把对防火墙的访问 重定向到其他的机子上(比如DMZ)。也就是说，我们改变的是目的地址，以使包能重路由到某台主机。 
SNAT:改变包的源地址，这在极大程度上可以隐藏你的本地网络或者DMZ等。有了这个操作，防火墙就 能自动地对包做SNAT和De-SNAT(就是反向的SNAT),以使LAN能连接到Internet。
MASQUERADE的作用和SNAT完全一样，只是计算机的负荷稍微多一点。因为对每个匹配的包，MASQUERADE都要查找可用的IP地址，而不象SNAT用的IP地址是配置好的。

mangle:PREROUTING,POSTROUTING,INPUT,OUTPUT,FORWARD
以下是mangle表中仅有的几种操作：
TOS: TOS操作用来设置或改变数据包的服务类型域。这常用来设置网络上的数据包如何被路由等策略。注意这个操作并不完善，有时得不所愿
TTL: TTL操作用来改变数据包的生存时间域
MARK:MARK用来给包设置特殊的标记。iproute2能识别这些标记，并根据不同的标记(或没有标记)决定不同的路由。用这些标记我们可以做带宽限制和基于请求的分类。
    
报文流向：
  流入本机：  PREROUTING --> INPUT
  由本机流出：OUTPUT --> POSTROUTING
  转发：      PREROUTING --> FORWARD --> POSTROUTING
EOF
}

iptables_p_conntrack(){ cat - <<'EOF'
1. [conntrack与链]
连接跟踪机制: NEW，ESTABLISHED，RELATED和INVALID -> 谁或什么能发起新的会话
除了本地产生的包由OUTPUT链处理外，所有连接跟踪都是在PREROUTING链里进行处理的，
意思就是， iptables会在PREROUTING链里从新计算所有的状态。
如果我们发送一个流的初始化包，状态就会在OUTPUT链 里被设置为NEW，当我们收到回应的包时，状态就会在PREROUTING链里被设置为ESTABLISHED。
如果第一个包不是本地产生的，那就会在PREROUTING链里被设置为NEW状态。
综上，所有状态的改变和计算都是在nat表中的PREROUTING链和OUTPUT链里完成的。

2. [conntrack记录含义]
/proc/net/ip_conntrack
tcp  6   117 SYN_SENT src=192.168.1.6 dst=192.168.1.9 sport=32775  dport=22 [UNREPLIED] src=192.168.1.9 dst=192.168.1.6 sport=22 dport=32775 use=2
6:       协议
117:     这条conntrack记录的生存时间，它会有规律地被消耗，直到收到这个连接的更多的包
SYN_SENT:接下来的是这个连接在当前时间点的状态。 SYN_SENT说明我们正在观 察的这个连接只在一个方向发送了一TCP SYN包。
src=192.168.1.6 dst=192.168.1.9 sport=32775  dport=22
UNREPLIED:这个连接还没有收到任何回应。最后，是希望接收的应答包的信息，他们 的地址和端口和前面是相反的。

连接跟踪记录的信息依据IP所包含的协议不同而不同，所有相应的值都是在头文件linux/include/netfilter-ipv4/ip_conntrack*.h中定义的。
IP、TCP、UDP、ICMP协议的缺省值是在linux/include/netfilter-ipv4/ip_conntrack.h里定义的。

/proc/sys/net/ipv4/netfilter
/proc/sys/net/ipv4/ip_conntrack_max里查看、设置。

3. [数据包在用户空间的状态]
NEW:        NEW说明这个包是我们看到的第一个 包。意思就是，这是conntrack模块看到的某个连接第一个包，它即将被匹配了。
ESTABLISHED:ESTABLISHED已经注意到两个方向上 的数据传输，而且会继续匹配这个连接的包。
            一个连接要从NEW变 为ESTABLISHED，只需要接到应答包即可，不管这个包是发往防火墙的，还是要由防 火墙转发的。
            ICMP的错误和重定向等信息包也被看作是ESTABLISHED，只要它们是我 们所发出的信息的应答。
RELATED:    当一个连接和某个已处于ESTABLISHED状态的连接有关系时，就被认为是RELATED的了
            这个新的连接就是RELATED的了，当然前提是conntrack模块要能理解RELATED。
            通过IRC的DCC连接。有了这个状态，ICMP应 答、FTP传输、DCC等才能穿过防火墙正常工作。
INVALID     数据包不能被识别属于 哪个连接或没有任何状态。有几个原因可以产生这种情况，比如，内存溢出，收到不知属于哪个连接的ICMP错误信息。一般地，我们DROP这个状态的任何东西。

4. [TCP连接]
[SYN_SENT]: SYN_SENT状态被设置了，这说明连接已经发出一个SYN包，但应答还没发送过 来，这可从[UNREPLIED]标志看出
tcp      6 117 SYN_SENT src=192.168.1.5 dst=192.168.1.35 sport=1031 dport=23 [UNREPLIED] src=192.168.1.35 dst=192.168.1.5 sport=23  dport=1031 use=1
[SYN_RECV]: 已经收到了相应的SYN/ACK包，状态也变为SYN_RECV，这说明最初发出的SYN包已正确传输，并且SYN/ACK包也到达了防火墙。接的两方都有数据传输
tcp      6 57 SYN_RECV src=192.168.1.5 dst=192.168.1.35 sport=1031 dport=23 src=192.168.1.35 dst=192.168.1.5 sport=23 dport=1031 use=1
[ESTABLISHED] 发出了三步握手的最后一个包，即ACK包，连接也就进入ESTABLISHED状态了。再传输几个数据 包，连接就是[ASSURED]
tcp      6 431999 ESTABLISHED src=192.168.1.5 dst=192.168.1.35 sport=1031 dport=23 src=192.168.1.35 dst=192.168.1.5 sport=23 dport=1031 use=1

5. [内部状态]
State 	        Timeout value
NONE 	        30 minutes
ESTABLISHED 	5 days
SYN_SENT 	    2 minutes
SYN_RECV 	    60 seconds
FIN_WAIT 	    2 minutes
TIME_WAIT 	    2 minutes
CLOSE 	        10 seconds
CLOSE_WAIT 	    12 hours
LAST_ACK 	    30 seconds
LISTEN> 	    2 minutes
/proc/sys/net/ipv4/netfilter/ip_ct_tcp_* # 单位是jiffies(百分之一秒)，所以3000就代表30秒
modprobe ip_conntrack_*

iptables -m state  -h
This module, when combined with connection tracking, allows access to the connection tracking state for this packet.
iptables -m conntrack -h
This module, when combined with connection tracking, allows access to the connection tracking state for this packet/connection.
EOF
}

iptables_s_firewalld(){ cat - <<'EOF'
-------------------------------------------------------------------------------- iptables 和 nftables
1. 禁用 firewalld
CentOS 7 上默认安装了 firewalld 作为防火墙，使用 iptables 建议关闭并禁用 firewalld。
systemctl stop firewalld
systemctl disable firewalld
2. 安装 iptables
yum install -y iptables-services
3. 服务管理
    查看服务状态：systemctl status iptables
    启用服务：systemctl enable iptables
    禁用服务：systemctl disable iptables
    启动服务：systemctl start iptables
    重启服务：systemctl restart iptables
    关闭服务: systemctl stop iptables
    
    # 回放          -S(输出内核添加的规则链)
    # 规则管理      -A(追加) -D(指定规则或规则序号) -I(插入) -R(替换)    -F(清空规则，-D操作的一步到位) -L(查看) -Z(统计归零)
    # 规则链管理    -N(--new-chain) -X(--delete-chain ) -E(--rename-chain) -P设置默认策略；
    # 默认规则链    -P( --policy chain target)
### iptables <option> <chain> <matching criteria> <target>
EOF
}
iptables_i_target_DNAT(){ cat - <<'EOF'
目的网络地址转换的，就是重写包的目的IP地址。
如果一个包被匹配了，那么和它属于同一个流的所有的包都会被自动转换，然后就可以被路由到正确的主机或网络。
目的地址也可以是一个范围，这样的话，DNAT会为每一个流随机分配一个地址。因此，我们可以用这个target做某种类型地负载平衡。

注意，DANT target只能用在nat表的PREROUTING和OUTPUT链中，或者是被这两条链调用的链里。但还要 注意的是，
包含DANT target的链不能被除此之外的其他链调用，如POSTROUTING。

iptables -t nat -A PREROUTING -p tcp -d 15.45.23.67 --dport 80 -j DNAT --to-destination 192.168.1.1-192.168.1.10
在这种情况下，每个流都会被随机分配一个要转发到的地址，但同一个流总是使用同一个地址。
iptables -t nat -A PREROUTING -p tcp -d 15.45.23.67 --dport 80 -j DNAT --to-destination 192.168.1.1:80-100
在地址后指定一个或一个范围的端口。 -> 要注意，只有先用--protocol指定了TCP或 UDP协议，才能使用端口。
iptables -t nat -A PREROUTING --dst $INET_IP -p tcp --dport 80 -j DNAT --to-destination $HTTP_IP

[外网访问HTTP_IP]
EXT_BOX --> INET_IP(PREROUTING)+DNAT    --> HTTP_IP
EXT_BOX <-- INET_IP(PREROUTING)+Un-DNAT <-- HTTP_IP
iptables -t nat -A PREROUTING --dst $INET_IP -p tcp --dport 80 -j DNAT --to-destination $HTTP_IP

[内网访问HTTP_IP] -> 简单办法+不是一个明智的选择; 能够访问
LAN_BOX --> INET_IP(POSTROUTING)+SNAT    --> HTTP_IP
LAN_BOX <-- INET_IP(POSTROUTING)+Un-DNAT <-- HTTP_IP
iptables -t nat -A POSTROUTING -p tcp --dst $HTTP_IP --dport 80 -j SNAT --to-source $LAN_IP

[防火墙自己要访问HTTP服务器时] 
iptables -t nat -A OUTPUT --dst $INET_IP -p tcp --dport 80 -j DNAT --to-destination $HTTP_IP
EOF
}

iptables_i_ipaddress_class(){ cat - <<'EOF'
10.0.0.0/8 -j (A)
172.16.0.0/12 (B)
192.168.0.0/16 (C)
224.0.0.0/4 (MULTICAST D)
240.0.0.0/5 (E)
127.0.0.0/8 (LOOPBACK)
EOF
}

# man iptables-extension

iptables_i_mod(){ cat - <<'EOF'
/sbin/insmod ipt_LOG
/sbin/insmod ipt_REJECT
/sbin/insmod ipt_MASQUERADE

# 详细说明
https://www.frozentux.net/iptables-tutorial/iptables-tutorial.html

# iptables -m socket [libxt_socket.so] -h          #模块-选项
# iptables -j CLUSTERIP [libipt_CLUSTERIP.so] -h   #处理

/lib64/libip4tc.so.0
/lib64/libip4tc.so.0.0.0
/lib64/libip6tc.so.0
/lib64/libip6tc.so.0.0.0
/lib64/libipq.so.0
/lib64/libipq.so.0.0.0
/lib64/libiptc.so.0
/lib64/libiptc.so.0.0.0
/lib64/libxtables.so.4
/lib64/libxtables.so.4.0.0
/lib64/xtables
/lib64/xtables/libipt_CLUSTERIP.so
/lib64/xtables/libipt_DNAT.so
/lib64/xtables/libipt_ECN.so
/lib64/xtables/libipt_LOG.so
/lib64/xtables/libipt_MASQUERADE.so
/lib64/xtables/libipt_MIRROR.so
/lib64/xtables/libipt_NETMAP.so
/lib64/xtables/libipt_REDIRECT.so
/lib64/xtables/libipt_REJECT.so
/lib64/xtables/libipt_SAME.so
/lib64/xtables/libipt_SET.so
/lib64/xtables/libipt_SNAT.so
/lib64/xtables/libipt_TTL.so  only mangle tables
/lib64/xtables/libipt_ULOG.so
/lib64/xtables/libipt_addrtype.so
/lib64/xtables/libipt_ah.so
/lib64/xtables/libipt_ecn.so
/lib64/xtables/libipt_icmp.so
/lib64/xtables/libipt_realm.so
/lib64/xtables/libipt_set.so
/lib64/xtables/libipt_ttl.so
/lib64/xtables/libipt_unclean.so
/lib64/xtables/libxt_AUDIT.so
/lib64/xtables/libxt_CHECKSUM.so
/lib64/xtables/libxt_CLASSIFY.so
/lib64/xtables/libxt_CONNMARK.so
/lib64/xtables/libxt_CONNSECMARK.so
/lib64/xtables/libxt_DSCP.so
/lib64/xtables/libxt_MARK.so
/lib64/xtables/libxt_NFLOG.so
/lib64/xtables/libxt_NFQUEUE.so
/lib64/xtables/libxt_NOTRACK.so
/lib64/xtables/libxt_RATEEST.so
/lib64/xtables/libxt_SECMARK.so
/lib64/xtables/libxt_TCPMSS.so
/lib64/xtables/libxt_TCPOPTSTRIP.so
/lib64/xtables/libxt_TOS.so
/lib64/xtables/libxt_TPROXY.so
/lib64/xtables/libxt_TRACE.so
#利用raw表实现iptables调试
假设需要对ipv4的ICMP包进行跟踪调试，抓取所有流经本机的ICMP包

# iptables -t raw -A OUTPUT -p icmp -j TRACE
# iptables -t raw -A PREROUTING -p icmp -j TRACE

加载对应内核模组
modprobe ipt_LOG
调试信息记录在/var/log/kern.log文件。

/lib64/xtables/libxt_cluster.so
/lib64/xtables/libxt_comment.so
/lib64/xtables/libxt_connbytes.so
/lib64/xtables/libxt_connlimit.so
/lib64/xtables/libxt_connmark.so
/lib64/xtables/libxt_conntrack.so
/lib64/xtables/libxt_dccp.so
/lib64/xtables/libxt_dscp.so
/lib64/xtables/libxt_esp.so
/lib64/xtables/libxt_hashlimit.so
/lib64/xtables/libxt_helper.so
/lib64/xtables/libxt_iprange.so
/lib64/xtables/libxt_length.so
/lib64/xtables/libxt_limit.so
/lib64/xtables/libxt_mac.so
/lib64/xtables/libxt_mark.so
/lib64/xtables/libxt_multiport.so
/lib64/xtables/libxt_osf.so
/lib64/xtables/libxt_owner.so
/lib64/xtables/libxt_physdev.so
/lib64/xtables/libxt_pkttype.so
/lib64/xtables/libxt_policy.so
/lib64/xtables/libxt_quota.so
/lib64/xtables/libxt_rateest.so
/lib64/xtables/libxt_recent.so
/lib64/xtables/libxt_sctp.so
/lib64/xtables/libxt_socket.so
/lib64/xtables/libxt_standard.so
/lib64/xtables/libxt_state.so
/lib64/xtables/libxt_statistic.so
/lib64/xtables/libxt_string.so
/lib64/xtables/libxt_tcp.so
/lib64/xtables/libxt_tcpmss.so
/lib64/xtables/libxt_time.so
/lib64/xtables/libxt_tos.so
/lib64/xtables/libxt_u32.so
/lib64/xtables/libxt_udp.so
EOF
}

iptables_i_ipset(){ cat - <<'EOF'
1. 命名(创建)一个新的ipset集合
ipset create SETNAME TYPENAME
TYPENAME := method:datatype[,datatype[,datatype]]
                     [bitmap, hash, list]:[ip, net, mac, port, iface]
# ipset create myset hash:net
推荐下面的方式
ipset create myset hash:net timeout 259200  #timeout 259200是集合内新增的IP有三天的寿命

ipset默认可以存储65536个元素，使用maxelem指定数量
ipset create blacklist hash:net maxelem 1000000    #黑名单
ipset create whitelist hash:net maxelem 1000000    #白名单

2. 把希望屏蔽的IP地址添加到集合中
ipset add SETNAME ENTRY
# ipset add myset 14.144.0.0/12
# ipset add myset 27.8.0.0/13
# ipset add myset 58.16.0.0/15
或者添加一个timeout时间
ipset add test 192.168.0.1 timeout 3600
或者修改现存的ip timeout时间
ipset -exist add test 192.168.0.1 timeout 259200

3.把新建的ipset集合丢到iptables里
# iptables -I INPUT -m set --match-set myset src -j DROP
上面的iptables命令用到了
  input链的知识
  -m 加模块的知识
  -m set --match-set myset(myset是你的ipset的名称)
  iptables的其他规则，如何src -j DROP

4. 查看已创建的ipset
ipset list
ipset list myset

5. 移除一个你的集合中的IP
删除集合中的某ip条目：ipset del SETNAME ENTRY
ipset del myset 1.2.3.4

5.1 删除ipset某集合的所有ip条目：flush [SETNAME]

6. ipset持久化
创建的 ipset 存在于内存中，重启后将会消失。要使ipset持久化，需要把他保存到一个文件中
例如
# ipset save > /etc/ipset.conf
# ipset save myset -f /etc/ipset_myset.txt

7. 导入 ipset规则
ipset restore -f /etc/ipset_myset.txt

8. 删除名为"myset"的集合。

删除ipset中的某个集合或者所有集合：ipset destroy [SETNAME]
ipset del SETNAME ENTRY
# ipset destroy myset
删除所有集合。
# ipset destroy

9. 检查目标ip是否在ipset集合中
ipset test SETNAME ENTRY

===============================================================================
1. timeout 超时时间/生效时间 (所有集合适用)
timeout设置超时时间，如果设置为0，表示永久生效，超时时间可以通过 -exist来进行修改
ipset create myset hash:net timeout 259200 

2. counters, packets, bytes (所有集合适用)
如果指定了该选项，则使用每个元素支持的包和字节计数器创建集合。当元素(重新)添加到集合中时，
除非包和字节选项显式指定包和字节计数器值，否则包和字节计数器将初始化为零。
ipset create myset hash:net counters
ipset create myset hash:net packets 11 bytes 22

3. comment 备注(所有集合适用)
ipset create myset hash:net comment "only ip bad"

4. skbinfo, skbmark, skbprio, skbqueue (所有集合适用)
这个扩展允许您存储每个条目的metainfo(防火墙标记、tc类和硬件队列)，并使用SET netfilter target和 --map- SET选项将其映射到包。
skbmark选项格式:MARK或MARK/MASK，其中MARK和MASK为32位十六进制数字，前缀为0x。如果只指定标记，则使用掩码0xffffffff。
skbprio选项有tc类格式:MAJOR:MINOR，其中MAJOR和MINOR号是十六进制，没有0x前缀。
skbqueue选项只是一个小数。

5. hashsize 集合的初始哈希大小(hsah集合适用)
它定义了集合的初始哈希大小，默认值为1024。哈希大小必须是2的幂，内核会自动舍入两个哈希大小的非幂到第一个正确的值。
ipset create myset hash:net hashsize 2048

6. maxelem 集合存储最大数量(hsah集合适用)
它定义了可以存储在集合中的元素的最大数量，默认值为65536
ipset create myset hash:net maxelem 65536

7. family { inet | inet6 } IPv4/IPv6 (适用hash集合(hash:mac除外))
这个参数对于除hash:mac之外的所有hash类型集的create命令都是有效的。它定义了要存储在集合中的IP地址的协议族

9. forceadd 集合满时，随机删除(所有集合适用)
当使用此选项创建的集合已满时，集合的下一个添加项可能成功并从集合中删除随机项。

===============================================================================
ipset和iptables：
在iptables中使用ipset，只要加上-m set --match-set即可。(这里只做简单的介绍)

目的ip使用ipset(ipset集合为bbb)
iptables -I INPUT -s 192.168.100.36  -m set --match-set bbb dst -j DROP

源ip使用ipset(ipset集合为aaa)
iptables -I INPUT -m set --match-set aaa src -d 192.168.100.36  -j DROP

源和目的都使用ipset(源ip集合为aaa，目的ip集合为bbb)
iptables -I INPUT -m set --match-set aaa src -m set --match-set bbb dst  -j DROP

EOF
}

iptables_t_ipset(){ cat - <<'EOF'
使用ipset提高iptables的控制效率
ipset create vader hash:ip                                # 创建一个集合; 这条命令创建了名为vader的集合，以hash方式存储，存储内容是IP地址。

iptables -I INPUT -m set --match-set vader src -j DROP    # vader 是作为黑名单的，如果要把某个集合作为白名单，添加一个 ‘!’ 符号就可以。
iptables -I INPUT -m set ! --match-set yoda src -j DROP 

# 找出"坏"IP
netstat -ntu | tail -n +3 | awk '{print $5}' | sort | uniq -c | sort -nr
awk '{print $1}' /var/log/nginx/access.log | sort | uniq -c | sort -nr

ipset add vader 4.5.6.7                                   #  往之前创建的集合里添加
ipset add vader 1.2.3.4                                   #  往之前创建的集合里添加
ipset add vader ...                                       #  往之前创建的集合里添加
ipset list vader # 查看 vader 集合的内容                  # 

    vader 这个集合是以 hash 方式存储 IP 地址，也就是以 IP 地址为 hash 的键。除了 IP 地址，还可以是网络段，
端口号(支持指定 TCP/UDP 协议)，mac 地址，网络接口名称，或者上述各种类型的组合。
hash:ip,port就是 IP 地址和端口号共同作为 hash 的键。查看 ipset 的帮助文档可以看到它支持的所有类型。
hash:net
    ipset create r2d2 hash:net        # hash:net 指定了可以往 r2d2 这个集合里添加 IP 段或 IP 地址。
    ipset add r2d2 1.2.3.0/24         # 
    ipset add r2d2 1.2.3.0/30 nomatch # 
    ipset add r2d2 6.7.8.9            # 
    ipset test r2d2 1.2.3.2           # 
    第三条命令里的 nomatch 的作用简单来说是把 1.2.3.0/30 从 1.2.3.0/24 这一范围相对更大的段里"剥离"了出来，
也就是说执行完 ipset add r2d2 1.2.3.0/24 只后1.2.3.0/24 这一段 IP 是属于 r2d2 集合的，执行了 
ipset add r2d2 1.2.3.0/30 nomatch 之后，1.2.3.0/24 里 1.2.3.0/30 这部分，就不属于 r2d2 集合了。
执行 ipset test r2d2 1.2.3.2 就会得到结果 1.2.3.2 is NOT in set r2d2.  

hash:ip,port
    ipset create c-3po hash:ip,port   # 
    ipset add c-3po 3.4.5.6,80        # 第二条命令添加的是 IP 地址为 3.4.5.6，端口号是 80 的项。没有注明协议，默认就是 TCP
    ipset add c-3po 5.6.7.8,udp:53    # UDP 的 53 端口
    ipset add c-3po 1.2.3.4,80-86     # 最后一条命令指明了一个 IP 地址和一个端口号范围，这也是合法的命令。
    
自动过期，解封
ipset 支持 timeout 参数，这就意味着，如果一个集合是作为黑名单使用，通过 timeout 参数，就可以到期自动从黑名单里删除内容。
    ipset create obiwan hash:ip timeout 300
    ipset add obiwan 1.2.3.4
    ipset add obiwan 6.6.6.6 timeout 60
    
ipset -exist add obiwan 1.2.3.4 timeout 100 #如果要重新为某个条目指定 timeout 参数，要使用 -exit 这一选项。

如果在创建集合是没有指定 timeout，那么之后添加条目也就不支持 timeout 参数，执行 add 会收到报错。想要默认条目
不会过期(自动删除)，又需要添加某些条目时加上 timeout 参数，可以在创建集合时指定 timeout 为 0。

更大！
hashsize, maxelem 这两个参数分别指定了创建集合时初始的 hash 大小，和最大存储的条目数量。
    ipset create yoda hash:ip,port hashsize 4096 maxelem 1000000
    ipset add yoda 3.4.5.6,3306
这样创建了名为 yoda 的集合，初始 hash 大小是 4096，如果满了，这个 hash 会自动扩容为之前的两倍。最大能存储的数量是 100000 个。
如果没有指定，hashsize 的默认值是 1024，maxelem 的默认值是 65536。


ipset del yoda x.x.x.x # 从 yoda 集合中删除内容
ipset list yoda # 查看 yoda 集合内容
ipset list # 查看所有集合的内容
ipset flush yoda # 清空 yoda 集合
ipset flush # 清空所有集合
ipset destroy yoda # 销毁 yoda 集合
ipset destroy # 销毁所有集合
ipset save yoda # 输出 yoda 集合内容到标准输出
ipset save # 输出所有集合内容到标准输出
ipset restore # 根据输入内容恢复集合内容

还有--
    如果创建集合是指定的存储内容包含 ip, 例如 hash:ip 或 hash:ip,port ，在添加条目时，可以填 IP 段，
但是仍然是以单独一个个 IP 的方式来存。
    上面所有的例子都是用 hash 的方式进行存储，实际上 ipset 还可以以 bitmap 或者 link 方式存储，用这
两种方式创建的集合大小，是固定的。
    通过 man ipset 和 ipset —help 可以查到更多的内容，包括各种选项，支持的类型等等。
EOF
}

iptables_i_filter(){ cat - <<'EOF'
ip_tables 模块提供
    filter表
    主要用于对数据包进行过滤，根据具体的规则决定是否放行该数据包(如DROP、ACCEPT、REJECT、LOG)。
filter 表对应的内核模块为iptable_filter，包含三个规则链：
        INPUT链：INPUT针对那些目的地是本地的包
        FORWARD链：FORWARD过滤所有不是本地产生的并且目的地不是本地(即本机只是负责转发)的包
        OUTPUT链：OUTPUT是用来过滤所有本地生成的包
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
  # IP包头的服务类型TOS字段(由mangle表设置)
  IP包头的TTL部分
  iptables mark字段(由mangle表设置)
  限制频率的数据报匹配。

iptables -t filter -j LOG -h
iptables -t filter -j REJECT -h
iptables -t filter -j ULOG -h


Filter table--首先是filter表，而且我们先要设置策略。
    Set policies--为所有系统内建的链设置策略。通常，我会设置 DROP，对于允许使用的服务或流会在后面明确地给以ACCEPT。这样，我们就可以方便地排除所有我们不想让 人们使用的端口。
    Create user specified chains--在这里创建所有以后会用到的自定 义链。如果没有事先建立好，后面是不能使用它们的，所以我们要尽早地建立这些链。
    Create content in user specified chains--建立自定义链里使用 的规则。其实你也可以在后面的某个地方写这些规则，之所以写在这儿，唯一的原因是这样做规则和链会离 得近些，便于我们查看。
    INPUT chain--创建INPUT链的规则。
    FORWARD chain--为FORWARD链创建规则。
    OUTPUT chain--为OUTPUT链创建规则。其实，在这里要建的规则很少。
EOF
}

# http://www.faqs.org/docs/Linux-mini/TransparentProxy.html 透明代理
# http://arthurchiao.art/blog/nat-zh/
iptables_i_nat_intro(){ cat - <<'iptables_i_nat_intro'
    PRETOUTING chain 负责处理刚刚到达网络接口的数据包，这时还没有做路由判断，因此还不知道这个包是发往本机(local)，还是网络内的其他主机。
包经过 PRETOUTING chain 之后，将进行路由判断。如果目的是本机，那接下来的过程将不涉及 NAT；
如果目的是网络内的其他机器，那包将会被转发到那台机器，前提是这台机器配置了允许转发。
    在转发包离开本机之前，它会经过 POSTROUTING chain。对于本机生成的包，这里还有一 点不同：它会先经过 OUTPUT chain，然后再经过 POSTROUTING chain。

echo "1" > /proc/sys/net/ipv4/ip_forward # Disabled by default!
modprobe ip_tables                       # Load iptables module
modprobe ip_conntrack                    # activate connection tracking (connection's status are taken into account)
modprobe ip_conntrack_irc                # Special features for IRC:
modprobe ip_conntrack_ftp                # Special features for FTP:

iptables -t nat -A POSTROUTING -o eth1 -j MASQUERADE
iptables - 配置内核的工具
         -t nat - 指定对名为 nat 的 iptables table 配置 NAT 规则
                -A POSTROUTING - 追加（A: Append）规则到 iptables 的 POSTROUTING chain
                               -o eth1 - 指定只对从 eth1 发出的数据包做操作（o: output）
                                       -j MASQUERADE - 规则匹配成功后的动作是 masquerade （伪装）数据包，例如将 源地址修改为路由器地址
注意: 
    除了客户端过来的包，路由器自己的包也会涉及以上处理逻辑，因为它们也经过 POSTROUTING chain。然而，因为路由器为客户端做 socket (IP+Port) 转换的时候，
会从它的未使用端口中挑选，因此它自身的包所使用的 port 与做 NAT 的 port 肯定是不同的。因此，虽然它自身的包也会经过以上规则，但并不会被修改。


iptables -t nat -A chain [...]   # add a rule:
1. 匹配
iptables -t nat -A POSTROUTING -p tcp -s 192.168.1.2 [...]       # TCP packets from 192.168.1.2:
iptables -t nat -A POSTROUTING -p udp -d 192.168.1.2 [...]       # UDP packets to 192.168.1.2:
iptables -t nat -A PREROUTING -s 192.168.0.0/16 -i eth0 [...]    # all packets from 192.168.x.x arriving at eth0:
iptables -t nat -A PREROUTING -p ! tcp -s ! 192.168.1.2 [...]    # all packets except TCP packets and except packets from 192.168.1.2:
iptables -t nat -A POSTROUTING -o eth1 [...]                     # packets leaving at eth1:
iptables -t nat -A POSTROUTING -p tcp -s 192.168.1.2 --sport 12345:12356 -d 123.123.123.123 --dport 22 [...] # TCP packets from 192.168.1.2, port 12345 to 12356 to 123.123.123.123, Port 22
2. 动作
iptables [...] -j SNAT --to-source 123.123.123.123               # Source-NAT: Change sender to 123.123.123.123
iptables [...] -j MASQUERADE                                     # Mask: Change sender to outgoing network interface
iptables [...] -j DNAT --to-destination 123.123.123.123:22       # Destination-NAT: Change receipient to 123.123.123.123, port 22
iptables [...] -j REDIRECT --to-ports 8080                       # Redirect to local port 8080
SNAT -       修改源 IP 为固定新 IP(静态) # 选择 MASQUERADE 的原因在于：对于 SNAT，必须显式指定转换后的 IP; # SNAT 只对离开路由器的包有意义，因此它只用在 POSTROUTING chain 中。
MASQUERADE - 修改源 IP 为动态新 IP(动态获取网络接口 IP)                                                    # SNAT 一样，MASQUERADE 只对 POSTROUTING chain 有意义。但和 SNAT 不同， MASQUERADE 不支持更详细的配置项了。
DNAT       - 修改目的 IP                                         # 接收端修改必须在做路由决策之前，因此 DNAT 适用于 PRETOUTING 和 OUTPUT(本地生成的包)chain。
REDIRECT   - 将包重定向到本机另一个端口  # 透明代理的功能。      # 和DNAT 一样，REDIRECT 适用于 PRETOUTING 和 OUTPUT chain 。

iptables -t nat -L               # list rules:
iptables -t nat -D chain myindex # remove user-defined chain with index 'myindex':
iptables -t nat -F chain         # Remove all rules in chain 'chain':

1.  配置内网机器可以 SSH 到跳板机
iptables -t nat -A PREROUTING -p tcp --dport 5000 -j REDIRECT --to-ports 22
2. 通过跳板机从内网连接到公网举例：邮件服务器 POP3
iptables -t nat -A PREROUTING -p tcp --dport 5001 -j DNAT --to-destination 123.123.123.123:110 # redirect port 5001 to port 110 (POP3) at 123.123.123.123:
iptables -t nat -A POSTROUTING -p tcp --dport 110  -j MASQUERADE    # Change sender to redirecting machine:
3.  通过跳板机绕过 HTTP 监控
iptables -t nat -A OUTPUT -p tcp --dport 80  -j DNAT --to-destination 111.111.111.111:5002 # redirect http-Traffic going to Port 80 to 111.111.111.111:5002:
4. 通过 NAT 从外网访问内网服务
 iptables -t nat -A PREROUTING -p tcp -i eth1 --dport 80 -j DNAT --to 192.168.1.2 #  redirect http traffic to 192.168.1.2:

iptables_i_nat_intro
}

iptables_i_nat(){ cat - <<'iptables_i_nat'
    nat表
    主要用于修改数据包的IP地址、端口号等信息(网络地址转换，如SNAT、DNAT、MASQUERADE、REDIRECT)。
属于一个流的包(因为包 的大小限制导致数据可能会被分成多个数据包)只会经过这个表一次。如果第一个包
被允许做NAT或Masqueraded，那么余下的包都会自动地被做相同的操作，也就是说，余下的包不会再通过这个表。
表对应的内核模块为 iptable_nat，包含三个链：
        PREROUTING链：作用是在包刚刚到达防火墙时改变它的目的地址
        OUTPUT链：改变本地产生的包的目的地址
        POSTROUTING链：在包就要离开防火墙之前改变其源地址

nat表用于源地址和目的地址转换以及端口转换的目标扩展模块，
SNAT: 源NAT
DNAT: 目的NAT
MASQUERADE: 源NAT的一种特殊形式，用于被分配了临时的、可改变的、动态分配IP地址的连接。
REDIRECT:   目的NAT的一种特殊形式，重定向数据报到本机主机，而不考虑IP头部的目的地址域。

基本的NAT：仅转换地址
NAPT：       网络地址和端口转换
双向NAT：    双向的地址转换同时允许传入和传出连接。IPv4和IPv6进行双向地址映射
两次NAT：    双向的源和目的地址转换同时允许传入和传出连接。两次NAT能够在源和目的网络地址空间冲突时使用。
PREROUTING:  DNAT ipmasqadm 和均分负载
OUTPUT：     DNAT和REDIRECT
POSTROUTING：SNAT和MASQUERADE

Set policies--与filter一样，我们先来设置策略。一般说来，缺省 的策略，即ACCEPT，就很好。这个表不应该被用来做任何过滤，而且我们也不应该在这儿丢弃任何包，因为 对我们假设的网络情况来说，可能会发生一些难以应付的事情。我把策略设为ACCEPT，因为没有什么原因不 这样做。
Create user specified chains--在这儿创建nat表会用到的自定义链。一般情况下，我没有任何规则要在这儿建立，但我还是保留了这个小节，以防万一罢了。注意，在被系 统内建链调用之前一定要建好相应的自定义链。
Create content in user specified chains--建立自定义链的规 则。
PREROUTING chain--要对包做DNAT操作的话，就要用到此链了。大部 分脚本不会用到这条链，或者是把里面的规则注释掉了，因为我们不想在不了解它的情况下就在防火墙上撕 开一个大口子，这会对我们的局域网造成威胁。当然，也有一些脚本默认使用了这条链，因为那些脚本的目 的就是提供这样的服务。
POSTROUTING chain--如果使用SNAT操作，就要在此建立规则。你可 能有一个或多个局域网需要防火墙的保护，而我就是依据这样的情况来写此脚本的，所以这个脚本中使用的 POSTROUTING链是相当实用的。大部分情况下，我们会使用SNAT target，但有些情况，如PPPoE，我们不得不 使用MASQUERADE target。
OUTPUT chain--不管什么脚本都几乎不会用到这个链。迄今为止，我 还没有任何好的理由使用它，如果你有什么理由用它了的话，麻烦你把相应的规则也给我一份，我会把它加 到本指南里的。
iptables_i_nat
}

iptables_i_mangle(){ cat - <<'EOF'
    mangle表
    主要用于修改数据包的TOS(Type Of Service，服务类型)、TTL(Time To Live，生存周期)指以及为数据包设置Mark标记，
以实现Qos(Quality Of Service，服务质量)调整以及策略路由等应用，由于需要相应的路由设备支持，因此应用并不广泛。
包含五个规则链 -- PREROUTING，POSTROUTING，INPUT，OUTPUT，FORWARD。

    mangle表有两个目标扩展，MARK模块支持为iptables维护的数据报的mark域分配一个值。
TOS模块则支持设置IP包头中TOS字段的值。
EOF
}
iptables_i_raw(){ cat - <<'EOF'
    raw表
    是自1.2.9以后版本的iptables新增的表，主要用于决定数据包是否被状态跟踪机制处理。在匹配数据包时，
raw表的规则要优先于其他表。包含两条规则链——OUTPUT、PREROUTING
    
    iptables中数据包和4种被跟踪连接的4种不同状态：
        NEW：该包想要开始一个连接(重新连接或将连接重定向)
        RELATED：该包是属于某个已经建立的连接所建立的新连接。例如：FTP的数据传输连接就是控制连接所 RELATED出来的连接。--icmp-type 0 ( ping 应答) 就是--icmp-type 8 (ping 请求)所RELATED出来的。
        ESTABLISHED ：只要发送并接到应答，一个数据连接从NEW变为ESTABLISHED,而且该状态会继续匹配这个连接的后续数据包。
        INVALID：数据包不能被识别属于哪个连接或没有任何状态比如内存溢出，收到不知属于哪个连接的ICMP错误信息，一般应该DROP这个状态的任何数据。

        只允许状态为NEW和ESTABLISHED的进来，出去只允许ESTABLISHED的状态出去，这就可以将比较常见的反弹式木马有很好的控制机制。
        
        iptables -R INPUT 2 -s 172.16.0.0/16 -d 172.16.100.1 -p tcp -dport 22 -m state -state NEW,ESTABLISHED -j ACCEPT
        iptables -R OUTPUT 1 -m state -state ESTABLISHED -j ACCEPT
    此时如果想再放行一个80端口如何放行呢？
        iptables -A INPUT -d 172.16.100.1 -p tcp -dport 80 -m state -state NEW,ESTABLISHED -j ACCEPT
        iptables -R INPUT 1 -d 172.16.100.1 -p udp -dport 53 -j ACCEPT
EOF
}

iptables_i_security(){
:
}

iptables_i_chain_default(){ cat - <<'EOF'
在处理各种数据包时，根据防火墙规则的不同介入时机，iptables供涉及5种默认规则链，从应用时间点的角度理解这些链：
    INPUT链：当接收到防火墙本机地址的数据包(入站)时，应用此链中的规则。
    OUTPUT链：当防火墙本机向外发送数据包(出站)时，应用此链中的规则。
    FORWARD链：当接收到需要通过防火墙发送给其他地址的数据包(转发)时，应用此链中的规则。
    PREROUTING链：在对数据包作路由选择之前，应用此链中的规则，如DNAT。
    POSTROUTING链：在对数据包作路由选择之后，应用此链中的规则，如SNAT。
EOF
}

iptables_i_filter_reject(){ cat - <<'EOF'
    custom_chain：转向一个自定义的链

    ACCEPT：允许数据包通过
    DROP：直接丢弃数据包，不给任何回应信息

    REJECT：拒绝数据包通过，必要时会给数据发送端一个响应的信息。 # 其中缺省的是port-unreachable。
    --reject-with type
    Valid reject types:
        icmp-net-unreachable        ICMP network unreachable
        net-unreach                 alias
        icmp-host-unreachable       ICMP host unreachable
        host-unreach                alias
        icmp-proto-unreachable      ICMP protocol unreachable
        proto-unreach               alias
        icmp-port-unreachable       ICMP port unreachable (default)
        port-unreach                alias
        icmp-net-prohibited         ICMP network prohibited
        net-prohib                  alias
        icmp-host-prohibited        ICMP host prohibited
        host-prohib                 alias
        tcp-reset                   TCP RST packet
        tcp-rst                     alias
        icmp-admin-prohibited       ICMP administratively prohibited (*)
        admin-prohib                alias
    或者
    --reject-with tcp-reset
    
    SNAT：源地址转换。在进入路由层面的route之前，重新改写源地址，目标地址不变，并在本机建立NAT表项，当数据返回时，根据NAT表将目的地址数据改写为数据发送出去时候的源地址，并发送给主机。解决内网用户用同一个公网地址上网的问题。
    MASQUERADE，是SNAT的一种特殊形式，适用于像adsl这种临时会变的ip上
    DNAT:目标地址转换。和SNAT相反，IP包经过route之后、出本地的网络栈之前，重新修改目标地址，源地址不变，在本机建立NAT表项，当数据返回时，根据NAT表将源地址修改为数据发送过来时的目标地址，并发给远程主机。可以隐藏后端服务器的真实地址。
    
    REDIRECT：是DNAT的一种特殊形式，将网络包转发到本地host上(不管IP头部指定的目标地址是啥)，方便在本机做端口转发。
    LOG：在/var/log/messages文件中记录日志信息，然后将数据包传递给下一条规则
    除去最后一个LOG，前3条规则匹配数据包后，该数据包不会再往下继续匹配了，所以编写的规则顺序极其关键。
    
tcp-reset主要用来阻塞身份识别探针
# iptables -A FORWARD -p TCP --dport 22 -j REJECT --reject-with tcp-reset
EOF
}

iptables_i_chain_userdefined(){ cat - <<'EOF'
    -P :设置默认策略的(设定默认门是关着的还是开着的)
        默认策略一般只有两种
        iptables -P INPUT (DROP|ACCEPT)  默认是关的/默认是开的
        比如：
        iptables -P INPUT DROP 这就把默认规则给拒绝了。并且没有定义哪个动作，所以关于外界连接的所有规则包括Xshell连接之类的，远程连接都被拒绝了。
    -N:NEW 支持用户新建一个链
        iptables -N inbound_tcp_web 表示附在tcp表上用于检查web的。
    -X: 用于删除用户自定义的空链
        使用方法跟-N相同，但是在删除之前必须要将里面的链给清空昂了
    -E：用来Rename chain主要是用来给用户自定义的链重命名
        -E oldname newname
    -h| <some command> -h:列出iptables的命令和选项，如果-h后面跟着某个iptables命令，则列出此命令的语法和选项。
    --modprobe=<command> 在向规则链中增加或插入规则时使用<command>来加载必要的规则。
    
  iptables -nL --line-number
  显示每条规则链的编号
  
  iptables -D FORWARD 2
  删除FORWARD链的第2条规则，编号由上一条得知。如果删除的是nat表中的链，记得带上-t nat
  
  iptables -D INPUT -j REJECT --reject-with icmp-host-prohibited
  删除规则的第二种方法，所有选项要与要删除的规则都相同才能删除，否则提示iptables: No chain/target/match by that name.
  
  丢弃非法连接
  iptables -A INPUT -m state -state INVALID -j DROP
  iptables -A OUTPUT -m state -state INVALID -j DROP
  iptables-A FORWARD -m state -state INVALID -j DROP

bad_tcp_packets，allowed链，
icmp_packets、tcp_packets、udp_packets 和allowed
EOF
}

iptables_i_rule(){ cat - <<'EOF'
规则管理命令
  -A：追加，在当前链的最后新增一个规则
  -I|--insert <chain> <rule number> | <rule specification>
  -I num : 插入，把当前规则插入为第几条。
  -I 3 :插入为第三条
  -R|--replace <chain> <rule number> | <rule specification>
  -R num：Replays替换/修改第几条规则
  格式：iptables -R 3
  -D num：删除，明确指定删除第几条规则
  -D|--delte <chain> <rule number> | <rule specification>
  -C|--check <chain> <rule specification> 检查规则链中是否某条规则匹配<rule specification>
EOF
}

iptables_i_help(){ cat - <<'EOF'
查看管理命令 "-L"
附加子命令
-n：以数字的方式显示ip，它会将ip直接显示出来，如果不加-n，则会将ip反向解析成主机名。
-v：显示详细信息
-vv
-vvv :越多越详细
-x：在计数器上显示精确值，不做单位换算
-line-numbers : 显示规则的行号
-t nat：显示所有的关卡的信息

man iptables | col -b | grep iptables
$ man iptables
# iptables -h

### 协议层面帮助
显式扩展：必须使用-m选项指明要调用的扩展模块的扩展机制；
tcp, udp, udplite,  icmp,  esp, ah, sctp or all, # /etc/protocols
iptables -p tcp|udp|icmp -h

### 状态层面帮助
隐式扩展：在使用-p选项指明了特定的协议时，无需再同时使用-m选项指明扩展模块的扩展机制；
ah cluster addrtype comment connbytes connlimit connmark conntrack dccp dscp ecn esp hashlimit helper
icmp ipranger length limit mac mark multiport owner physdev pkttype policy quota rateest realm recent sctp scoket
state statistic string tcp tcpmss time tos ttl u32 udp unclean   
iptables -m addrtype  -h

### 跳转层面帮助
# libxt
AUDIT, CHECKSUM, CLASSIFY, CONNMARK, CONNSECMARK, DSCP, MARK
NFLOG, NFQUEUE, NOTRACK, RATEEST, SECMARK, TCPMSS, TCPOPTSTRIP
TOS, TPROXY, TRACE
# libipt
CLUSTERIP, DNAT, ECN, LOG, MASQUERADE
MIRROR, NETMAP, REDIRECT, REJECT, SAME
SET, SNAT, TTL, ULOG
iptables -j TRACE -h

state扩展：
内核模块装载：
    nf_conntrack
    nf_conntrack_ipv4
    手动装载：
        nf_conntrack_ftp 

追踪到的连接：
    /proc/net/nf_conntrack
调整可记录的连接数量最大值：
    /proc/sys/net/nf_conntrack_max
超时时长：
/proc/sys/net/netfilter/*timeout*
EOF
}

iptables_i_filter_generic(){ cat - <<'EOF'
-p, --protocol
1、名字，不分大小写，但必须是在/etc/protocols中定 义的。
2、可以使用它们相应的整数值。例如，ICMP的值是1，TCP是6，UDP是17。
3、缺省设置，ALL，相应数值是0，但要注意这只代表匹配TCP、UDP、ICMP，而不是/etc/protocols中定义的所有协议。
4、可以是协议列表，以英文逗号为分隔符，如：udp,tcp
5、可以在协议前加英文的感叹号表示取反，注意有空格，如: --protocol ! tcp 表示非tcp协议，也就是UDP和ICMP。可以看出这个取反的范围只是TCP、UDP和ICMP。

-s, --src, --source      -> ipset & iptables -m set -h
-d, --dst, --destination -> ipset & iptables -m set -h
1、单个地址，如192.168.1.1，也可写成 192.168.1.1/255.255.255.255或192.168.1.1/32
2、网络，如192.168.0.0/24，或 192.168.0.0/255.255.255.0
3、在地址前加英文感叹号表示取反，注意空格，如--source ! 192.168.0.0/24 表示除此地址外的所有地址
4、缺省是所有地址

-i, --in-interface
1、指定接口名称，如：eth0、ppp0等
2、使用通配符，即英文加号，它代表字符数字串。
   若直接用一个加号，即iptables -A INPUT -i +表示匹配所有的包，而不考虑使用哪个接口。
   通配符还 可以放在某一类接口的后面，如：eth+表示所有Ethernet接口，也就是说，匹配所有从Ethernet接口进入的 包。

-f, --fragment
用来匹配一个被分片的包的第二片或及以后的部分。
! -f 。取反时，表示只能匹配到没有分片的包或者是被分片的包的第一个碎片，其后的片都不行。
EOF
}

iptables_i_filter_tcp(){ cat - <<'EOF'
2.扩展匹配
----- tcp -----   iptables -p tcp -h
    -p tcp :TCP协议的扩展。一般有三种扩展
-dport | -sport -> iptables -m multiport -h
1、不指定此项，则暗示所有端口。
2、使用服务名或端口号，但名字必须是在/etc/services 中定义的，因为iptables从这个文件里查找相应的端口号。
3、可以使用连续的端口，如：--source-port 22:80这表示从22到80的所有端 口
4、可以省略第一个号，默认第一个是0，如：--source-port :80表示从0到80的 所有端口。
5、也可以省略第二个号，默认是65535，如：--source-port 22:表示从22到 65535的所有端口
6、在端口号前加英文感叹号表示取反，注意空格，如：--source-port ! 22表 示除22号之外的所有端口；--source-port ! 22:80表示从22到80（包括22和80）之 外的所有端口。
7、匹配操作不能识别不连续的端口列表，如：--source-port ! 22, 36, 80 这样的操作是由后面将要介绍的多端口匹配扩展来完成的。

-tcp-flags：TCP的标志位(SYN,ACK，FIN,PSH，RST,URG) ALL和NONE : ALL是指选定所有的标记，NONE是指未选定任何标记
有两个参数，它们都是列表，列表内 部用英文的逗号作分隔符，这两个列表之间用空格分开。
1.参数提供检查范围                  要检查的标记（作用就象掩码），
2.提供被设置的条件(就是哪些位置1)   在第一个列表中出现过的且必须被设为1(即状态是打开的)的

1、iptables -p tcp --tcp-flags SYN,FIN,ACK   # SYN表示匹配那些SYN标记被设 置而FIN和ACK标记没有设置的包，
2、--tcp-flags ALL NONE匹配所有标记都未置1的包
3、iptables -p tcp --tcp-flags ! SYN,FIN,ACK # SYN表示匹配那些FIN和ACK标记被设置而SYN标记没有设置的包

-tcpflags syn,ack,fin,rst syn   =   --syn # 匹配那些SYN标记被设置而 ACK和RST标记没有设置的包。
                                  ! --syn # 匹配那些RST或ACK被置位的包，换句话说，就是 状态为已建立的连接的包。
表示检查这4个位，这4个位中syn必须为1，其他的必须为0。所以这个意思就是用于检测三次握手的第一次包的。
对于这种专门匹配第一包的SYN为1的包，还有一种简写方式，叫做-syn

--tcp-option  # 查看选项的类型
TCP选项:
第一个8位组表示选项的类型，
第二个8位组表示选项的长度
第三部分当然就是选项的内容
EOF
}

iptables_i_filter_udp(){ cat - <<'EOF'
----- udp -----   iptables -p udp -h 
    -p udp：UDP协议的扩展
        -dport
        -sport
见: iptables_i_filter_tcp
EOF
}

iptables_i_filter_icmp(){ cat - <<'EOF'
----- icmp -----   iptables -p icmp -h 
    -p icmp：icmp数据报文的扩展
        -icmp-type：
echo-request(请求回显)，一般用8 来表示
所以 -icmp-type 8 匹配请求回显数据包
echo-reply (响应的数据包)一般用0来表示
EOF
}

iptables_i_filter_multiport(){ cat - <<'EOF'
多端口匹配扩展使我们能够在一条规则里指定不连续的多个端口，如果没有这个扩展，我们只能按端口来写规则了
----- -m multiport ----- iptables -m multiport -h
2.2显式扩展(-m)
-m multiport命令必须紧跟在-p <protocol>说明符后。
请注意：multiport模块的--destination-port参数不同于对-p tcp参数执行匹配的模块中的--destination-port或--dport参数。
      -m multiport：表示启用多端口扩展
      之后我们就可以启用比如 -dports 21,23,80
      -m | --match multiport
      --source-port <port>[,<port>]      # 源端口
      --destination-port <port>[,<port>] # 目的端口
      --port <port>[,<port>]             # 源端口和目的端口
源端口多端口匹配，最多可以指定15个端口，以英文逗号分隔，注意没有空格。使用时必须有-p tcp或-p udp为前提条件。
      
1. NETBIOS和SMB的UDP端口，常见的Mircrosoft Windows计算机的端口漏洞和蠕虫攻击的目标      
iptables -A INPUT -i eth0 -p udp -m multiport --destination-port 135,136,137,138,139 -j DROP
2. NFS, SOCKS, squid
iptables -A OUTPUT -o eth0 -p tcp -m multiport --destination-port 2049,1080,3128 --sync -j REJECT
3. 
iptables -A INPUT -i <interface> -p tcp -m multiport --source-port 80,443 !--sync -j ACCEPT # OK
iptables -A INPUT -i <interface> -p tcp !--sync -m multiport --source-port 80,443 -j ACCEPT # NO

iptables -A INPUT -i <interface> -p tcp -m multiport --source-port 80,443 !--sync \
-d $IPADDR --dport 1024:65536
-j ACCEPT # OK
iptables -A INPUT -i <interface> -p tcp -m multiport --source-port 80,443 \
-d $IPADDR !--sync --dport 1024:65536
-j ACCEPT # OK

iptables -A OUTPUT -o <interface> -p tcp -m multiport --destination-port 80,443 \
!--sync -d $IPADDR --dport 1024:65536
-j ACCEPT # OK
iptables -A OUTPUT -o <interface> -p tcp -m multiport --destination-port 80,443 \
--sync -d $IPADDR --dport 1024:65536
-j ACCEPT # OK
EOF
}

iptables_i_filter_limit(){ cat - <<'EOF'
    当涌来一大批需要日志记录的数据报时，将会产生许多的日志消息，限值比率的匹配对于抑制日志消息的数量很有用。
你可以事先设定一个限定值，当符合条件 的包的数量不超过它时，就记录；超过了，就不记录了。
减少DoS syn flood攻击的影响

----- -m limit -----iptables -m limit -h
--limit <rate>           # 在给定的时间内匹配数据包的最大值
--list-burst <number>    # 在应用限制前匹配的初始数据包的最大值
峰值定义了通过初始匹配的数据包的数量。默认值是5.当达到限制后，之后的匹配则会限制在频率处。
默认的限制频率是每小时3次匹配。可选的时间帧标识符包括/second /minute /hour /day

当在给定的1秒内接收到初始的5个echo请求后，对传入的ping消息的日志记录限制为每秒1个：
iptables -A INPUT -i eth0 -p icmp --icmp-type echo-request -m limit --limit 1/second -j LOG #将丢弃包情况记入日志
或
iptables -A INPUT -i eth0 -p icmp --icmp-type echo-request -m limit --limit 1/second -j ACCEPT
iptables -A INPUT -i eth0 -p icmp --icmp-type echo-request -j DROP

-m limit ! --limit 5/s表示在数量超过限定值后，所有的包都会被匹配。

    limit match的工作方式就像一个单位大门口的保安，当有人要 进入时，需要找他办理通行证。早上上班时，
保安手里有一定数量的通行证，来一个人，就签发一个，当通 行证用完后，再来人就进不去了，但他们不会等，
而是到别的地方去。但有个规定，每隔一段时 间保安就要签发一个新的通行证。这样，后面来的人如果恰巧赶上，
也就可以进去了。如果没有人来，那通 行证就保留下来，以备来的人用。如果一直没人来，可用的通行证的数量就增加了，
但不是无限增大的，最 多也就是刚开始时保安手里有的那个数量。也就是说，刚开始时，通行证的数量是有限的，
但每隔一段时间 就有新的通行证可用。limit match有两个参数就对应这种情况。
--limit-burst   指定刚开始时有多少通行证可用
                # 默认值是每小时3次(用户角度)，即3/hour ，也就是每20分钟一次(iptables角度)
--limit         指定要隔多长时间才能签发一个新的通行证

--limit 3/minute --limit-burst 5 # 开始时有5个通行证，用完之后每20秒增加一个
--limit 3/hour --limit-burst 5   # 开始时有5个通行证，用完之后每20分钟增加一个
[Limit- match.txt]
EOF
}

iptables_i_filter_state(){ cat - <<'EOF'
状态匹配扩展要有内核里的连接跟踪代码的协助，因为它是从连接跟踪机制中得到包的状态的。
针对每 个连接都有一个缺省的超时值，如果连接的时间超过了这个值，那么这个连接的记录就被会从连接跟踪的记录数据库中删除，也就是说连接就不再存在了。
----- -m state -----iptables -m state -h
 --state <state>[,<state>]
# [!] --state [INVALID|ESTABLISHED|NEW|RELATED|UNTRACKED][,...]  State(s) to match
利用连接状态绕过规则检查

iptables -A INPUT -m state --state RELATED,ESTABLISHED
EOF
}

iptables_i_filter_mac(){ cat - <<'EOF'
基于包的MAC源地址匹配包
----- -m mac -----iptables -m mac -h
--mac-source [!] <XX:XX:XX:XX:XX:XX> Match source MAC address
# [!] --mac-source XX:XX:XX:XX:XX:XX Match source MAC address
MAC addresses只用于Ethernet类型的网络，所以这个match只能用于Ethernet接口。
还只能在PREROUTING，FORWARD 和INPUT链里使用。
EOF
}

iptables_i_filter_owner(){ cat - <<'EOF'
基于包的生成者的ID来匹配包，owner可以是启动进程的用户的ID，或用户所在的组的ID，或进程的ID，或会话的ID
----- -m owner -----iptables -m owner -h 
# [!] --uid-owner userid[-userid]      Match local UID
# [!] --gid-owner groupid[-groupid]    Match local GID
# [!] --socket-exists                  Match if socket exists
--uid-owner <uid>   按创建者的UID进行创建
--gid-owner <gid>   按创建者的GID进行创建
--pid-owner <pid>   按创建者的PID进行创建
--sid-owner <sid>   按创建者的SID和PPID进行创建
--cmd-owner <name>  按命令名<name>匹配进程创建的数据包
仅在OUTPUT链上可用。
用户允许你从此账户登录Linux系统。多用于远程登录终端。

[pid-owner.txt]
[sid-owner.txt]
EOF
}

iptables_i_filter_mark(){ cat - <<'EOF'
----- -m mark -----iptables -m mark -h 
--mark <value>[/<mask>] 匹配带有Netfilter分配的mark值的数据包
mark值以及掩码均为无符号长整型数。如果指定了掩码，就将mark值和掩码值进行逻辑与操作。
iptables -A FORWARD -i eth0 -o eth1 -p tcp --sport 1024:65536 --dport 23 -m mark --mark 0x00010070 -j ACCEPT
在这里被测试的mark值在之前的某特数据报处理节点被设置。mark值是一个标识，指示此数据报的处理不同于其他数据报。

mark的格式是--mark value[/mask]
带掩码的例子如--mark 1/1。如果指定了掩码，就先把mark值和掩码取逻辑与，然后再和包 的mark值比较。
EOF
}

iptables_i_filter_tos(){ cat - <<'EOF'
根据TOS字段匹配包，必须使用-m tos才能装入。-> Type Of Service
----- -m tos -----iptables -m tos -h 
--tos <value> 对IP TOS设置进行匹配
[!] --tos value[/mask]    Match Type of Service/Priority field value
[!] --tos symbol          Match TOS field (IPv4 only) by symbol
                          Accepted symbolic names for value are:
                          (0x10) 16 Minimize-Delay
                          (0x08)  8 Maximize-Throughput
                          (0x04)  4 Maximize-Reliability
                          (0x02)  2 Minimize-Cost
                          (0x00)  0 Normal-Service
EOF
}

iptables_i_filter_addrtype(){ cat - <<'EOF'
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
EOF
}

iptables_i_filter_iprange(){ cat - <<'EOF'
----- -m iprange -----iptables -m iprange -h
[!] --src-range <ip[-ip]>    指定(或否定)将匹配的源IP地址范围
[!] --dst-range <ip[-ip]>    指定(或否定)将匹配的目的IP地址范围
EOF
}

iptables_i_filter_length(){ cat - <<'EOF'
----- -m length -----iptables -m length -h
[!] --length length[:length]  匹配长度<length>或在<length:length>范围内的数据包
length使用参数：
-m length --length num #匹配指定大小的数据
-m length ! --length num #匹配非指定大小数据
-m length --length num: #匹配大于或等于
-m length --length :92 #匹配小于或等于
-m length --length num:num #匹配指定区间

iptables -I INPUT -p icmp --icmp-type 8 -m length --length :60 -j ACCEPT 
#仅允许数据包小于或等于60字节的ping请求数据进入
EOF
}

iptables_i_filter_time(){ cat - <<'EOF'
----- -m time -----iptables -m time -h
    --datestart time     Start and stop time, to be given in ISO 8601
    --datestop time      (YYYY[-MM[-DD[Thh[:mm[:ss]]]]])
    --timestart time     Start and stop daytime (hh:mm[:ss])
    --timestop time      (between 00:00:00 and 23:59:59)
[!] --monthdays value    List of days on which to match, separated by comma
                         (Possible days: 1 to 31; defaults to all)
[!] --weekdays value     List of weekdays on which to match, sep. by comma
                         (Possible days: Mon,Tue,Wed,Thu,Fri,Sat,Sun or 1 to 7
                         Defaults to all weekdays.)
    --localtz/--utc      Time is interpreted as UTC/local time
-m time --timestart 8:00 --timestop 12:00  表示从哪个时间到哪个时间段
-m time --days    表示那天

----- -m string -----iptables -m string -h
--from                       Offset to start searching from
--to                         Offset to stop searching
--algo                       Algorithm
--icase                      Ignore case (default: 0)
[!] --string string          Match a string in a packet
[!] --hex-string string      Match a hex string in a packe
EOF
}

iptables_t_limit(){ cat - <<'EOF'
1、限制特定包传入速度
参数 -m limit --limit
范例 iptables -A INPUT -m limit --limit 3/hour
说明 用来比对某段时间内封包的平均流量，上面的例子是用来比对：每小时平均流量是否超过一次 3 个封包。 除了每小时平均
次外，也可以每秒钟、每分钟或每天平均一次，默认值为每小时平均一次，参数如后： /second、 /minute、/day。 除了进行封
数量的比对外，设定这个参数也会在条件达成时，暂停封包的比对动作，以避免因骇客使用洪水攻击法，导致服务被阻断。

2、限制特定包瞬间传入的峰值
参数 --limit-burst
范例 iptables -A INPUT -m limit --limit-burst 5
说明 用来比对瞬间大量封包的数量，上面的例子是用来比对一次同时涌入的封包是否超过 5 个(这是默认值)，超过此上限的封
将被直接丢弃。使用效果同上。

3、使用--limit限制ping的一个例子
限制同时响应的 ping (echo-request) 的连接数
限制每分只接受一個 icmp echo-request 封包
#iptables -A INPUT -p icmp --icmp-type echo-request -m limit --limit 1/m --limit-burst 1 -j ACCEPT
#iptables -A INPUT -p icmp --icmp-type echo-request -j DROP
--limit 1/s 表示每秒一次; 1/m 则为每分钟一次
--limit-burst 表示允许触发 limit 限制的最大次数 (预设 5)

iptables -A INPUT -p tcp --dport 80 -m limit --limit 25/minute --limit-burst 100 -j ACCEPT
    -m limit: 启用limit扩展
    -limit 25/minute: 允许最多每分钟25个连接
    -limit-burst 100: 当达到100个连接后，才启用上述25/minute限制

4、用户自定义使用链
上面例子的另一种实现方法：
iptables -N pinglimit
iptables -A pinglimit -m limit --limit 1/m --limit-burst 1 -j ACCEPT
iptables -A pinglimit -j DROP
iptables -A INPUT -p icmp --icmp-type echo-request -j pinglimit

5、防范 SYN-Flood 碎片攻击
iptables -N syn_flood
iptables -A syn_flood -m limit --limit 100/s --limit-burst 150 -j RETURN
iptables -A syn_flood -j DROP
iptables -t filter -A INPUT -p tcp -m tcp --tcp-flags FIN,SYN,RST,ACK SYN -j syn_flood

6. 记录丢弃的数据包
# 1.新建名为LOGGING的链
iptables -N LOGGING
# 2.将所有来自INPUT链中的数据包跳转到LOGGING链中
iptables -A INPUT -j LOGGING
# 3.指定自定义的日志前缀"IPTables Packet Dropped: "
iptables -A LOGGING -m limit --limit 2/min -j LOG --log-prefix "IPTables Packet Dropped: " --log-level 7
# 4.丢弃这些数据包
iptables -A LOGGING -j DROP

禁止ping服务器
/bin/echo "1" > /proc/sys/net/ipv4/icmp_echo_ignore_all
EOF
}

iptables_t_FORWARD(){ cat - <<'EOF'
允许路由
如果本地主机有两块网卡，一块连接内网(eth0)，一块连接外网(eth1)，那么可以使用下面的规则将eth0的数据路由到eth1：
iptables -A FORWARD -i eth0 -o eth1 -j ACCEPT
EOF
}

iptables_t_NAT(){ cat - <<'EOF'
SNAT nat表目标扩展(POSTROUTING) #在私有局域网与公共地址池之间转换时使用。
iptables -t nat -A POSTROUTING --out-interface <interface> ... \
 -j SNAT --to-source <address>[-<address>][:<port>-<port>]
 
iptables -t nat -A POSTROUTING -s 10.8.0.0/24 -o eth0 -j SNAT --to-source 192.168.5.3

指定源地址和端口，有以下几种方式：
1、单独的地址。
2、一段连续的地址，用连字符分隔，如194.236.50.155-194.236.50.160，这样可以实现负载平衡。每 个流会被随机分配一个IP，但对于同一个流使用的是同一个IP。
3、在指定-p tcp 或 -p udp的前提下，可以指定源端口的范围，如194.236.50.155:1024-32000，这样 包的源端口就被限制在1024-32000了。
iptables -t nat -A POSTROUTING -p tcp -o eth0 -j SNAT --to-source 194.236.50.155-194.236.50.160:1024-32000

伪装nat表目标扩展(POSTROUTING)
iptables -t nat -A POSTROUTING --out-interface <interface> ... \
 -j MASQUERATE [--to-port <port>[-<port>]]

iptables -t nat -A POSTROUTING -s 10.8.0.0/255.255.255.0 -o eth0 -j MASQUERADE


DNAT nat表目标规则(PREROUTING OUTPUT)
iptables -t nat -A PREROUTING --in-interface <interface> ... \
-j DNAT --to-destination <address>[-<address>][:<port>-<port>]
iptables -t nat -A OUTPUT --out-interface <interface> ... \
-j DNAT --to-destination <address>[-<address>][:<port>-<port>]

以下规则将会把来自422端口的流量转发到22端口。这意味着来自422端口的SSH连接请求与来自22端口的请求等效。
# 1.启用DNAT转发
iptables -t nat -A PREROUTING -p tcp -d 192.168.102.37 --dport 422 -j DNAT --to-destination 192.168.102.37:22

假设现在外网网关是xxx.xxx.xxx.xxx，那么如果我们希望把HTTP请求转发到内部的某一台计算机，应该怎么做呢？
iptables -t nat -A PREROUTING -p tcp -i eth0 -d xxx.xxx.xxx.xxx --dport 8888 -j DNAT --to 192.168.0.2:80
iptables -A FORWARD -p tcp -i eth0 -d 192.168.0.2 --dport 80 -j ACCEPT
当该数据包到达xxx.xxx.xxx.xxx后，需要将该数据包转发给192.168.0.2的80端口，事实上NAT所做的是修改该数据包的
目的地址和目的端口号。然后再将该数据包路由给对应的主机。

iptables -t nat -A PREROUTING -p tcp -d 15.45.23.67 --dport 80 -j DNAT --to-destination 192.168.1.1-192.168.1.10
指定要写入IP头的地址，这也是包要被转发到的地方。
上面的例子就是把所有发往地址15.45.23.67的包都转发到一段LAN使用的私有地址中，即192.168.1.1到 192.168.1.10。
在这种情况下，每个流都会被随机分配一个要转发到的地址，但同一个流总是使 用同一个地址。
我们也可以只指定一个IP地址作为参数，这样所有的包都被转发到同一台机子。我们还可以 在地址后指定一个或一个范围的端口。
比如：--to-destination 192.168.1.1:80或 --to-destination 192.168.1.1:80-100

REDIRECT nat目标扩展(PREROUTING OUTPUT) # 为DNAT的特例
iptables -t nat -A PREROUTING --in-interface <interface> ... \
-j REDIRECT [--to-port <port>[-<port>]]
iptables -t nat -A OUTPUT --out-interface <interface> ... \
-j REDIRECT [--to-port <port>[-<port>]]
EOF
}

iptables_t_centos_save(){  cat - <<'EOF'
控制规则的存放以及开启
    1.service iptables save 命令
它会保存在/etc/sysconfig/iptables这个文件中
    2.iptables-save 命令
iptables-save > /etc/sysconfig/iptables
 
    3.iptables-restore 命令
开机的时候，它会自动加载/etc/sysconfig/iptabels
如果开机不能加载或者没有加载，而你想让一个自己写的配置文件(假设为iptables.2)手动生效的话：
iptables-restore < /etc/sysconfig/iptables.2
则完成了将iptables中定义的规则手动生效
EOF
}

iptables_t_ssh_http_https(){ cat - <<'EOF'
iptables -A INPUT -i eth0 -p tcp --dport 22 -m state --state NEW,ESTABLISHED -j ACCEPT
#iptables -A INPUT -i eth0 -p tcp -s 192.168.200.0/24 --dport 22 -m state --state NEW,ESTABLISHED -j ACCEPT
iptables -A OUTPUT -o eth0 -p tcp --sport 22 -m state --state ESTABLISHED -j ACCEPT

iptables -A INPUT -i eth0 -p tcp --dport 80 -m state --state NEW,ESTABLISHED -j ACCEPT
iptables -A OUTPUT -o eth0 -p tcp --sport 80 -m state --state ESTABLISHED -j ACCEPT

iptables -A INPUT -i eth0 -p tcp -m multiport --dports 22,80,443 -m state --state NEW,ESTABLISHED -j ACCEPT
iptables -A OUTPUT -o eth0 -p tcp -m multiport --sports 22,80,443 -m state --state ESTABLISHED -j ACCEPT
EOF
}

iptables_t_balance(){ cat - <<'EOF'
iptables -A PREROUTING -i eth0 -p tcp --dport 443 -m state --state NEW -m nth --counter 0 --every 3 --packet 0 -j DNAT --to-destination 192.168.1.101:443
iptables -A PREROUTING -i eth0 -p tcp --dport 443 -m state --state NEW -m nth --counter 0 --every 3 --packet 1 -j DNAT --to-destination 192.168.1.102:443
iptables -A PREROUTING -i eth0 -p tcp --dport 443 -m state --state NEW -m nth --counter 0 --every 3 --packet 2 -j DNAT --to-destination 192.168.1.103:443
EOF
}

iptables_t_syn_flood(){ cat - <<'EOF'
防止DoS攻击
iptables -N syn-flood   (如果您的防火墙默认配置有" :syn-flood - [0:0] "则不许要该项，因为重复了)
iptables -A INPUT -p tcp --syn -j syn-flood   
iptables -I syn-flood -p tcp -m limit --limit 2/s --limit-burst 5 -j RETURN   
iptables -A syn-flood -j REJECT
# 防止DOS太多连接进来,可以允许外网网卡每个IP最多15个初始连接,超过的丢弃
# 需要iptables v1.4.19以上版本：iptables -V 
iptables -A INPUT -p tcp --syn -i eth0 --dport 80 -m connlimit --connlimit-above 20 --connlimit-mask 24 -j DROP   
#用Iptables抵御DDOS (参数与上相同)   
iptables -A INPUT -p tcp --syn -m limit --limit 5/s --limit-burst 10 -j ACCEPT  
iptables -A FORWARD -p tcp --syn -m limit --limit 1/s -j ACCEPT 
iptables -A FORWARD -p icmp -m limit --limit 2/s --limit-burst 10 -j ACCEPT
iptables -A INPUT -p icmp --icmp-type 0 -s ! 172.29.73.0/24 -j DROP
EOF
}

iptables_t_ssh_LOG(){ cat - <<'EOF'
为22端口的INPUT包增加日志功能，插在input的第1个规则前面，为避免日志信息塞满/var/log/message，用--limit限制：
iptables -R INPUT 1 -p tcp --dport 22 -m limit --limit 3/minute --limit-burst 8 -j LOG
vi /etc/rsyslog.conf 编辑日志配置文件，添加kern.=notice /var/log/iptables.log，可以将日志记录到自定义的文件中。
service rsyslog restart #重启日志服务
EOF
}

iptables_t_drop_LOG(){ cat - <<'EOF'
为丢弃的包做日志
iptables -N LOGGING
iptables -A INPUT -j LOGGING
iptables -A LOGGING -m limit --limit 2/min -j LOG --log-prefix "IPtables Packet Droppd：" --log-level 7
iptables -A LOGGING -j DROP
EOF
}

iptables_t_ssh_DNAT(){ cat - <<'EOF'
设置422端口转发到22端口
iptables -t nat -A PREROUTING -p tcp -d 192.168.102.37 --dport 422 -j DNAT --to 192.168.102.37:22
iptables -A INPUT -i eth0 -p tcp --dport 422 -m state --state NEW,ESTABLISHED -j ACCEPT
iptables -A OUTPUT -o eth0 -p tcp --sport 422 -m state --state ESTABLISHED -j ACCEPT
EOF
}


iptables_t_TIME_WAIT(){ cat - <<'EOF'
如果是客户端请求断开，那么服务端就是被动断开端，可能会保留大量的CLOSE-WAIT状态的连接，
如果是服务端主动请求断开，则可能会保留大量的TIME_WAIT状态的连接。
EOF
}
iptables_i_TCPOPTSTRIP(){ cat - <<'EOF'
删除TCP的选项
TCPOPTSTRIP
-j TCPOPTSTRIP -h
EOF
}

iptables_i_TEE(){ cat - <<'EOF'
克隆发送
--gateway ipaddr
-t mangle -A PREROUTING -i eth0 -j TEE --gateway 2001:db8::1  
EOF
}
iptables_i_TPROXY(){ cat - <<'EOF'
    你可能听说过TPROXY，它通常配合负载均衡软件HAPrxoy或者缓存软件Squid使用。
    在所有"Proxy"类型的应用中都一个共同的问题，就是后端的目标服务器上看到的连接的Source IP都不再是
用户原始的IP，而是前端的"Proxy"服务器的IP。
    拿HAProxy举例来说，假设你有3台后端Web服务器提供服务，前端使用HAProxy作为负载均衡设备。所有用户
的HTTP访问会先到达HAProxy，HAProxy作为代理，将这些请求按照指定的负载均衡规则分发到后边的3台Web服务器
上。这个操作本身没有任何问题，因为HAProxy就应该是这么工作的。但是对于某些对于用户的访问IP有限制的
敏感应用，问题来了: 后端服务器上的ACL无法限制哪些IP可以访问，因为在它看来，所有连接的SOURCE IP都是
HAProxy的IP。

    这就是为什么TPROXY产生的原因，最早TPROXY是作为Linux内核的一个patch，从2.6.28以后TPRXOY已经进入
官方内核。TPRXOY允许你"模仿"用户的访问IP，就像负载均衡设备不存在一样，当HTTP请求到达后端的Web服务器
时，在后端服务器上用netstat查看连接的时候，看到连接的SOURCE IP就是用户的真实IP，而不是haproxy的IP。
TPROXY名字中的T表示的就是transparent(透明)。
    TPROXY主要功能如下:
    1.重定向一部分经过路由选择的流量到本地路由进程(类似NAT中的REDIRECT)
    2.使用非本地IP作为SOURCE IP初始化连接
    3.无需iptables参与，在非本地IP上起监听

2、如何编译TPROXY
在2.6.28以后的内核中，TPROXY已经是官方内核的一部分了。可以查看当前内核是否支持TPROXY
# grep "TPROXY" config-`uname -r`
CONFIG_NETFILTER_TPROXY=m
CONFIG_NETFILTER_XT_TARGET_TPROXY=m
如果没有支持，则需要自己重新编译内核，但不需要再对内核打patch，只需要在编译内核时选择TPROXY即可。
    
3、如何使用TPROXY(配合haproxy)
首选，需要在HAProxy的GROUP配置中加入如下一行；
source 0.0.0.0 usrsrc clientip
这行配置告诉HAProxy使用用户的真实IP作为SOURCE IP访问这个GROUP。
整个的配置看起来会像下边这样:

listen  VIP_Name 192.168.2.87:80
        mode        http
        option        forwardfor
        source 0.0.0.0 usesrc clientip
        cookie        SERVERID insert nocache indirect
        server server1 10.0.0.60:80 weight 1 cookie server1 check
        server server2 10.0.0.61:80 weight 1 cookie server2 check
        server        backup 127.0.0.1:80 backup
        option redispatch

接下来，使用netfilter mangle表中一个名为"socket"的match识别出发往本地socket的数据包(通过做一次socket检查)。
然后我们需要配置iptables规则，给那些发往本地socket的数据包打上mark。
然后新增一条路由规则，告诉内核将这些带有mark的数据包直接发送到本地回环地址进行路由处理。

#!/bin/sh
/sbin/iptables -t mangle -N DIVERT
/sbin/iptables -t mangle -A PREROUTING -p tcp -m socket -j DIVERT
/sbin/iptables -t mangle -A DIVERT -j MARK --set-mark 1
/sbin/iptables -t mangle -A DIVERT -j ACCEPT
/sbin/ip rule add fwmark 1 lookup 100
/sbin/ip route add local 0.0.0.0/0 dev lo table 100 

4、部署TPROXY需要注意的点
    在部署TPROXY时，最常见的错误是遗忘将返回流量通过HAProxy。
    因为我们"伪装了"通过HAProxy的数据包的SOURCE IP，后端Web服务器看到的就是用户的IP，那么Web服务器使用
自己的IP返回响应数据包，使用用户真实IP作为DESTINATION IP。当返回的数据包到达用户端的时候，用户看到
返回的包的源IP不是自己请求的HAProxy的IP，则会认为这个包不是合法的回应而丢弃这个数据包。

    要解决这个问题，有两个办法：
    第一个办法是将HAProxy配置成网桥模式。
    第二个办法是将HAProxy和后端Web服务器放到同一子网中，后端服务器将自己的默认网关指向HAProxy，HAProxy同时需要承担NAT功能。
    在后端服务器上: ip route add default via haproxy's_lan_ip
    在haproxy上: /sbin/iptables -t nat -A POSTROUTING -s backend's_ip -o eht0 -j MASQUERADE


5、haproxy上需要配合修改的一些内核参数

# 允许ip转发
echo 1 > /proc/sys/net/ipv4/conf/all/forwarding

# 设置松散逆向路径过滤
echo 2 > /proc/sys/net/ipv4/conf/default/rp_filter
echo 2 > /proc/sys/net/ipv4/conf/all/rp_filter
echo 0 > /proc/sys/net/ipv4/conf/eth0/rp_filter

# 允许ICMP重定向
echo 1 > /proc/sys/net/ipv4/conf/all/send_redirects
echo 1 > /proc/sys/net/ipv4/conf/eth0/send_redirects

将上边的配置持久化，写入/etc/sysctl.conf
net.ipv4.ip_forward = 1
net.ipv4.conf.default.rp_filter = 2
net.ipv4.conf.all.rp_filter = 2
net.ipv4.conf.eth0.rp_filter = 0
net.ipv4.conf.all.send_redirects = 1
net.ipv4.conf.default.send_redirects = 1
EOF
}

iptables_i_chain_default_polocy(){ cat - <<'EOF'
  To drop all traffic:
  # iptables -P INPUT DROP
  # iptables -P OUTPUT DROP
  # iptables -P FORWARD DROP
  # iptables -L -v -n
  #### you will not able to connect anywhere as all traffic is dropped ###
  # ping cyberciti.biz
  # wget http://www.kernel.org/pub/linux/kernel/v3.0/testing/linux-3.2-rc5.tar.bz2
EOF
}

iptables_t_Limit_Connections_Per_Second(){ cat - <<'EOF'
iptables -A INPUT -p tcp --dport 80 -i eth0 -m state --state NEW -m recent --set
iptables -A INPUT -p tcp --dport 80 -i eth0 -m state --state NEW -m recent --update --seconds ${SECONDS} --hitcount ${BLOCKCOUNT} -j DROP

/sbin/iptables -A INPUT -p tcp --syn --dport $port -m connlimit --connlimit-above N -j REJECT --reject-with tcp-reset
EOF
}

iptables_t_Limit_SSH_Connections_Per_Host(){ cat - <<'EOF'
  Only allow 3 ssg connections per client host:
  /sbin/iptables  -A INPUT -p tcp --syn --dport 22 -m connlimit --connlimit-above 3 -j REJECT
  # save the changes see iptables-save man page, the following is redhat and friends specific command
  service iptables save
EOF
}

iptables_t_Range_of_Ports(){ cat - <<'EOF'
  iptables -A INPUT -m state --state NEW -m tcp -p tcp --dport 7000:7010 -j ACCEPT 
EOF
}

iptables_t_Range_of_IP_Addresses(){  cat - <<'EOF'
1.SNAT基于原地址的转换
    基于原地址的转换一般用在我们的许多内网用户通过一个外网的口上网的时候，这时我们将我们内网的地址转换为一个外网的IP，
我们就可以实现连接其他外网IP的功能。
    iptables -t nat -A POSTROUTING -s 192.168.10.0/24 -j SNAT -to-source 172.16.100.1
    iptables -t nat -A POSTROUTING -s 192.168.10.0/24 -j MASQUERADE
    
	## only accept connection to tcp port 80 (Apache) if ip is between 192.168.1.100 and 192.168.1.200 ##
	iptables -A INPUT -p tcp --destination-port 80 -m iprange --src-range 192.168.1.100-192.168.1.200 -j ACCEPT
	
	## nat example ##
	iptables -t nat -A POSTROUTING -j SNAT --to-source 192.168.1.20-192.168.1.25
EOF
}

iptables_t_Traffic_From_Mac_Address(){ cat - <<'EOF'
	iptables -A INPUT -m mac --mac-source 00:0F:EA:91:04:08 -j DROP
	# *only accept traffic for TCP port # 8080 from mac 00:0F:EA:91:04:07 * ##
	iptables -A INPUT -p tcp --destination-port 22 -m mac --mac-source 00:0F:EA:91:04:07 -j ACCEPT
EOF
}

iptables_t_Block_Facebook(){ cat - <<'EOF'
  First, find out all ip address of facebook.com, enter:
  # host -t a www.facebook.com
  Sample outputs:
  
  www.facebook.com has address 69.171.228.40
  
  Find CIDR for 69.171.228.40, enter:
  # whois 69.171.228.40 | grep CIDR
  Sample outputs:LOG
  
  CIDR:           69.171.224.0/19
  
  To prevent outgoing access to www.facebook.com, enter:
  iptables -A OUTPUT -p tcp -d 69.171.224.0/19 -j DROP
  You can also use domain name, enter:
  iptables -A OUTPUT -p tcp -d www.facebook.com -j DROP
  iptables -A OUTPUT -p tcp -d facebook.com -j DROP
EOF
}

iptables_t_Log_and_Drop_Packets(){ cat - <<'EOF'
  iptables -A INPUT -i eth1 -s 10.0.0.0/8 -j LOG --log-prefix "IP_SPOOF A: "
  iptables -A INPUT -i eth1 -s 10.0.0.0/8 -j DROP
  By default everything is logged to /var/log/messages file.
  tail -f /var/log/messages
  grep --color 'IP SPOOF' /var/log/messages

限制模块可以限制每次创建的日志条目数量。
这是为了防止日志文件被淹没。每5分钟记录和删除欺骗行为，最多7个条目。

The -m limit module can limit the number of log entries created per time. 
This is used to prevent flooding your log file. To log and drop spoofing per 5 minutes, in bursts of at most 7 entries .
	# iptables -A INPUT -i eth1 -s 10.0.0.0/8 -m limit --limit 5/m --limit-burst 7 -j LOG --log-prefix "IP_SPOOF A: "
	# iptables -A INPUT -i eth1 -s 10.0.0.0/8 -j DROP
EOF
}

iptables_t_Block_or_Allow_ICMP_Ping_Request(){  cat - <<'EOF'
  iptables -A INPUT -p icmp --icmp-type echo-request -j DROP
  iptables -A INPUT -i eth1 -p icmp --icmp-type echo-request -j DROP
  
  # Ping responses can also be limited to certain networks or hosts:
  iptables -A INPUT -s 192.168.1.0/24 -p icmp --icmp-type echo-request -j ACCEPT
  
  The following only accepts limited type of ICMP requests:
  ### ** assumed that default INPUT policy set to DROP ** #############
  iptables -A INPUT -p icmp --icmp-type echo-reply -j ACCEPT
  iptables -A INPUT -p icmp --icmp-type destination-unreachable -j ACCEPT
  iptables -A INPUT -p icmp --icmp-type time-exceeded -j ACCEPT
  ## ** all our server to respond to pings ** ##
  iptables -A INPUT -p icmp --icmp-type echo-request -j ACCEPT
EOF
}

iptables_t_Restrict_Number_of_Parallel_Connections_To_Server_Per_Client_IP(){ cat - <<'EOF'
iptables -m connlimit --help

# iptables -A INPUT -p tcp --syn --dport 22 -m connlimit --connlimit-above 3 -j REJECT

Set HTTP requests to 20:
# iptables -p tcp --syn --dport 80 -m connlimit --connlimit-above 20 --connlimit-mask 24 -j DROP
Where,
    --connlimit-above 3 : 如果现有连接数在3个以上，则匹配。
    --connlimit-mask 24 : 使用前缀长度对主机进行分组。对于IPv4来说，这必须是0到32之间的数字(包括)。
EOF
}

iptables_t_SNAT_not_take_effect_real_time(){ cat - <<'EOF'
SNAT不实时生效

最近一项目频繁创建多网卡接口SNAT，发现在部分在SNAT规则后并不实时生效，如果持续尝试连接指定连接会一直不生效，
停止后过段时间或测试其它连接就正常了，原因是：
Linux的NAT不能及时生效，因为它是基于ip_conntrack的，如果在NAT的iptables规则添加之前，
此流的数据包已经绑定了一个ip_conntrack，那么该NAT规则就不会生效，
直到此ip_conntrack过期，如果一直有数据在鲁莽地尝试传输，那么就会陷入僵持状态。
EOF
}

iptables_t_target_MARK(){ cat - <<'EOF'
MARK标记用于将特定的数据包打上标签，供Iptables配合TC做QOS流量限制或应用策略路由。

iptables -j MARK --help
--set-mark #标记数据包
iptables -t mangle -A PREROUTING -p tcp -j MARK --set-mark 1
#所有TCP数据标记1

iptables -m mark --help
--mark value #匹配数据包的MARK标记
iptables -t mangle -A PREROUTING -p tcp -m mark --mark 1 -j CONNMARK --save-mark
#匹配标记1的数据并保存数据包中的MARK到连接中

iptables -j CONNMARK --help
--set-mark     #标记连接
--save-mark    #保存数据包中的MARK到连接中
--restore-mark #将连接中的MARK设置到同一连接的其它数据包中
iptables -t mangle -A PREROUTING -p tcp -j CONNMARK --set-mark 1

iptables -m connmark --help
--mark value #匹配连接的MARK的标记
iptables -t mangle -A PREROUTING -p tcp -m connmark --mark 1 -j CONNMARK --restore-mark
#匹配连接标记1并将连接中的标记设置到数据包中

1)CONNMARK target的选项
选项        功能
--set-mark value[/mask]             给链接跟踪记录打标记。
--save-mark [--mask mask]           将数据包上的标记值记录到链接跟踪记录上。
--restore-mark [--mask mask]        重新设置数据包的nfmark值。
2)MARK target 的选项
选项        功能
--set-mark value        设置数据包的nfmark值。
--and-mark value        数据包的nfmark值和value进行按位与运算。
--or-mark  value        数据包的nfmark值和value进行按或与运算。
3)MARK match的选项
选项        功能
[!] --mark value[/mask]        数据包的nfmark值与value进行匹配，其中mask的值为可选的


现要求对内网进行策略路由，所有通过TCP协议访问80端口的数据包都从ChinaNet线路出去，而所有访问UDP协议53号端口的数据包都从Cernet线路出去
    iptables -t mangle -A PREROUTING -i eth0 -p tcp --dport 80 -j MARK --set-mark 1 
    iptables -t mangle -A PREROUTING -i eth0 -p udp --dprot 53 -j MARK --set-mark 2

    ip rule add from all fwmark 1 table 10
    ip rule add from all fwmark 2 table 20

    ip route add default via 10.10.1.1 dev eth1 table 10
    ip route add default via 10.10.2.1 dev eth2 table 20

    1.iptables -A POSTROUTING -t mangle -j CONNMARK --restore-mark
    2.iptables -A POSTROUTING -t mangle -m mark ! --mark 0 -j ACCEPT
    3.iptables -A POSTROUTING -m mark --mark 0 -p tcp --dport 21 -t mangle -j MARK --set-mark 1
    4.iptables -A POSTROUTING -m mark --mark 0 -p tcp --dport 80 -t mangle -j MARK --set-mark 2
    5.iptables -A POSTROUTING -m mark --mark 0 -t mangle -p tcp -j MARK --set-mark 3 
    6.iptables -A POSTROUTING -t mangle -j CONNMARK --save-mark

1)第1条规则就是完成了将链接跟踪上的标记记录到该连接上的每一个数据包中；
2)第2条规则判断数据包的标记，如果不为0，则直接ACCEPT。如果数据包上没有被打标记，则交由后面的规则进行匹配并打标记。这里为什么会出现经过了CONNMARK模块，数据包仍未被打标记呢？可以想到，如果一条链接的第1个数据包经过第1条规则处理之后，由于ct->mark为0，所以其数据包的标记skb->nfmark应该仍旧为0，就需要进行后面规则的匹配。
3)第3~5条规则，则按照匹配选项对符合规则的数据包打上不同的标记
4)第6条规则，则是把之前打的标记信息保存到ct里.

#tc fi add dev eth0 parent 1: pref 1000 protocol ip handle 13 fw flowid 1:1
#iptables -t mangle -A FORWARD -p tcp --tcp-flags SYN,ACK,FIN,RST ACK -m length --length  40:60 -j MARK --set-mark 13
EOF
}
iptables_t_TCPMSS_DHCP_PPPOE(){ cat - <<'EOF'
iptables -j TCPMSS --help   # 修订TCPMSS值

为达到最佳的传输效能TCP在建立连接时会协商MSS(最大分段长度，一般为1460字节)值，即MTU(最大传输单元，不超过1500字节)
减去IP数据包包头20字节和TCP数据包头20字节，取最小的MSS值为本次连接的最大MSS值，iptables下TCPMSS模块即用来调整TCP数据包
中MSS数值。

在ADSL拨号环境中由于PPP包头占用8字节，MTU为1492字节，MSS为1452字节，如不能正确设置会导致网络不正常，可以通过TCPMSS模块
调整MSS大小。

TCPMSS使用参数：
--set-mss value     #设置特定MSS值
--clamp-mss-to-pmtu #根据MTU自动调整MSS

应用示例：
iptables -t mangle -I POSTROUTING -o pppoe-wan -p tcp -m tcp --tcp-flags SYN,RST SYN -j TCPMSS --clamp-mss-to-pmtu
EOF
}

iptables_t_TTL_ttl(){ cat - <<'EOF'
有两种情况，一是传输期间生存时间为0，使用类型为11代码是0的ICMP报文；
            二是在数据报重组期间生存时间为0，使用类型为11代码是1的ICMP报文。
iptables -m ttl -h # 匹配ttl值
iptables -j TTL -h # 修订TTL值

禁止二级路由及禁止tracert被跟踪
TTL即Time To Live，用来描述数据包的生存时间，防止数据包在互联网上一直游荡，每过一个路由减1，TTL为1时丢弃数据包并返回不可达信息。
Iptables TTL模块可以修改收到、发送数据的TTL值，这模块很有趣，可以实现很多妙用。
TTL使用参数：
--ttl-set #设置TTL的值        	iptables -t mangle -A PREROUTING -i eth0 -j TTL --ttl-set 64
--ttl-dec #设置TTL减去的值      iptables -t mangle -A PREROUTING -i eth0 -j TTL --ttl-dec 1
--ttl-inc #设置TTL增加的值      iptables -t mangle -A PREROUTING -i eth0 -j TTL --ttl-inc 1

应用示例：
禁止被tracert跟踪到，traceroute跟踪时首先向目标发送TTL为1的IP数据，路由收到后丢弃数据包并返回不可达信息，以此递增直到目标主机为止。
iptables -A INPUT -m ttl --ttl-eq 1 -j DROP     #禁止TTL为1的数据包进入
iptables -A FORWARD -m ttl --ttl-eq 1 -j DROP   #禁止转发TTL为1的数据

禁止二级路由：
iptables -t mangle -A PREROUTING -i pppoe-wan -j TTL --ttl-set 2
#进入路由数据包TTL设置为2，二级路由可接收数据不转发。
EOF
}
iptables_t_tcp_flags(){ cat - <<'EOF'
iptables -p tcp -h  # 匹配tcp选项值 
[!] --tcp-flags mask comp       match when TCP flags & mask == comp (Flags: SYN ACK FIN RST URG PSH ALL NONE)
[!] --syn                       match when only SYN flag set (equivalent to --tcp-flags SYN,RST,ACK,FIN SYN)
[!] --source-port port[:port]
 --sport ...                    match source port(s)
[!] --destination-port port[:port]
 --dport ...                    match destination port(s)
[!] --tcp-option number         match if TCP option set

防止Xmas扫描：
iptables -A INPUT -p tcp --tcp-flags ALL FIN,URG,PSH -j DROP

防止TCP Null扫描：
iptables -A INPUT -p tcp --tcp-flags ALL NONE -j DROP

拒绝TCP标记为SYN/ACK但连接状态为NEW的数据包，防止ACK欺骗。
iptables -A INPUT -p tcp --tcp-flags SYN,ACK SYN,ACK -m state --state NEW -j DROP
EOF
}

iptables_i_RETURN(){ cat - <<'EOF'
    RETURN 结束在目前规则链中的过滤程序，返回主规则链继续过滤，如果把自订规则链看成是一个子程序，那么这个动作，
就相当提早结束子程序并返回到主程序中。

    具体地说，就是若包在子链 中遇到了RETURN，则返回父链的下一条规则继续进行条件的比较，若是在父链(或称主链，比如INPUT)中 
遇到了RETURN，就要被缺省的策略(一般是ACCEPT或DROP)操作了。
    假设一个包进入了INPUT链，匹配了某条target为--jump EXAMPLE_CHAIN规则，然后进入了子链EXAMPLE_CHAIN。在子链中又匹配了某条规则，
恰巧target是--jump RETURN，那包就返回INPUT链了。如果在INPUT链里又遇 到了--jump RETURN，那这个包就要交由缺省的策略来处理了
EOF
}

iptables_i_MIRROR(){ cat - <<'EOF'
    MIRROR 镜射封包，也就是将来源 IP 与目的地 IP 对调后，将封包送回，进行完此处理动作后，将会中断过滤程序。
EOF
}
iptables_t_CONNMARK(){ cat - <<'EOF'
iptables -j CONNMARK -h
CONNMARK target options:
--set-xmark value[/ctmask]                      clear掩码位和XOR ctmark的值
--save-mark [--ctmask mask] [--nfmask mask]     Copy ctmark to nfmark using masks
--restore-mark [--ctmask mask] [--nfmask mask]  Copy nfmark to ctmark using masks
--set-mark value[/mask]                         Set conntrack mark value
--save-mark [--mask mask]                       Save the packet nfmark in the connection
--restore-mark [--mask mask]                    Restore saved nfmark value
--and-mark value                                Binary AND the ctmark with bits
--or-mark value                                 Binary OR  the ctmark with bits
--xor-mark value                                Binary XOR the ctmark with bits
--left-shift-mark value                         Left shift the ctmark with bits
--right-shift-mark value                        Right shift the ctmark with bits

    CONNMARK是NF框架中一个很有用的特性。它实现了往链接跟踪记录上打标记的方法。一旦某个链接被打上一个
标记，则该标记同样会应用到该链接的RELATED连接上。因此，如果你给FTP的链接打上了标记，则该标记同样会被
记录在FTP的数据连接ftp-data上。
    所有Linux下的工具(比如Qos或路由)只能够在数据包上打标记。因此，更有用的是，CONNMARK能够将链接跟踪
上的标记记录在数据包上，反之亦然。因此，CONNMARK可以用在Qos或路由上已建链接的管理。

以下是iptables命令行配置的规则：
iptables -A POSTROUTING -t mangle -j CONNMARK --restore-mark
iptables -A POSTROUTING -t mangle -m mark ! --mark 0 -j ACCEPT
iptables -A POSTROUTING -p tcp --dport 21 -t mangle -j MARK --set-mark 1
iptables -A POSTROUTING -p tcp --dport 80 -t mangle -j MARK --set-mark 2
iptables -A POSTROUTING -t mangle -j CONNMARK --save-mark

这几条规则的处理流程如下:
    重新保存CONNMARK上的标记。实际上，该条规则只是简单的将链接跟踪上记录的CONNMARK值赋给数据包上的
MARK。 TC是从数据包的MARK读取标记。
    如果数据包上已经有了MARK，则直接接受该数据包，不需要匹配下面的规则了。
    我们给协议为TCP并且目的端口为21的数据包打上标记，标记值为1.
    我们给协议为TCP并且目的端口为80的数据包打上标记，标记值为2.
    我们将数据包上记录的标记值保存到该数据包对应的链接跟踪上，以后属于该链接的所有数据包都会使用该标记
值。随后属于该链接的数据包会经过第1条规则时，规则会将链接上记录的标记值重新保存到数据报上，这就是
--restore-mark的功能。

# https://github.com/ruopu89/ruopu89.github.io/blob/7fdcc85de97f13b88cd0788eacc2daaf14053037/source/_posts/iptables%E4%BD%BF%E7%94%A8%E6%96%B9%E6%B3%95.md 20210327
connmark模块匹配mark值（整条连接）
iptables -A INPUT -m connmark --mark 1 -j DROP 
#conntrack模块匹配数据包状态，是state模块的加强版
#[!]--ctstate:匹配数据包的状态，状态列表分别为NEW,ESTABLISHED,RELATED,INVALID,DNAT,SNAT
#[!]--ctproto:用于匹配OSI七层中第四层的通信层，其功能与用法就如同iptables中的-p参数，如-p tcp,-p udp,-p 47等。
#[!]--ctorigsrc匹配连接发起方向的来源端IP
#[!]--ctorigdst匹配连接发起方向的目的端IP
#[!]--ctreplsrc匹配数据包应答方向的来源端IP
#[!]--ctrepldst匹配数据包应答方向的目的端IP
#[!]--ctorigsrcport
#[!]--ctorigdstport
#[!]--ctreplsrcport
#[!]--ctrepldstport
#[!]--ctexpire连接在Netfilter Conntrack数据库(/porc/net/nf_conntrack)的存活时间，使用方法如下：
#匹配特定的存活时间--ctexpire time
#匹配特定区间的存活时间--ctexpire time:time
#--ctdir设置要匹配那个方向的数据包，使用方法如下：
#只匹配连接发起方向的数据包--ctdir ORIGINAL
#只匹配数据包应答方向的数据包--ctdir REPLY
#若没有设置这个参数，默认会匹配双向的所有数据包
EOF
}

iptables_t_CONNMARK_MARK_split_routing(){ cat - <<'EOF'
为了让一个服务的流量绕过默认路由表，我们可以创建一个替代路由表。
1. Marking Connections
1.1 Create New Routing Table
/etc/iproute2/rt_tables.d/redirect.conf
2 redirect
表号是任意的，但253-255和0是保留的。名称同样是任意的。

1.2 Create Routes in New Table
ip route show table main | \
  while read rule ; do
    ip route add $rule table redirect
  done
或者
ip route show table main | grep -v tun | grep -v tap | \
  while read rule ; do
    ip route add $rule table redirect
  done
1.3 Select Which Traffic Uses this Table
ip rule add fwmark 0x2 table redirect

1.4 Mark the appropriate traffic
iptables -A PREROUTING -j CONNMARK --restore-mark
iptables -A PREROUTING -m mark ! --mark 0x0 -j ACCEPT
iptables -A PREROUTING -p tcp -m tcp --dport 22 -j MARK --set-mark 0x2
iptables -A PREROUTING -j CONNMARK --save-mark
iptables -A OUTPUT -j CONNMARK --restore-mark
iptables -A OUTPUT -m mark ! --mark 0x0 -j ACCEPT
iptables -A OUTPUT -p tcp -m tcp --sport 22 -j MARK --set-mark 0x2
iptables -A OUTPUT -j CONNMARK --save-mark
CONNMARK行使用连接跟踪模块来让单个连接中的所有数据包(如nf_conntrack跟踪的)得到相同的标记。
--set-mark语句中的mark值应该与上面ip规则语句中使用的值相同。
OUTPUT规则是针对来自本地主机的数据包的。
PREROUTING规则是针对来自远程主机的数据包。
这样就初步建立了带有标记的连接跟踪。

1.5 Flush the Cache
ip route flush cache
EOF
}
iptables_i_CONNMARK_MARK(){ cat - <<'EOF'
iptables -m conntrack -h 
conntrack match options: # 该模块与连接跟踪结合后，可以访问该数据包/连接的连接跟踪状态。
[!] --ctstate {INVALID|ESTABLISHED|NEW|RELATED|UNTRACKED|SNAT|DNAT}[,...] State(s) to match
[!] --ctproto proto                      Protocol to match; by number or name, e.g. "tcp"
[!] --ctorigsrc address[/mask]
[!] --ctorigdst address[/mask]
[!] --ctreplsrc address[/mask]
[!] --ctrepldst address[/mask]
                                        Original/Reply source/destination address
[!] --ctorigsrcport port
[!] --ctorigdstport port
[!] --ctreplsrcport port
[!] --ctrepldstport port
                                        TCP/UDP/SCTP orig./reply source/destination port
[!] --ctstatus {NONE|EXPECTED|SEEN_REPLY|ASSURED|CONFIRMED}[,...] Status to match
[!] --ctexpire time[:time]     Match remaining lifetime in seconds against value or range of values (inclusive)
    --ctdir {ORIGINAL|REPLY}   Flow direction of packet
    
两者的区别在于，同样是打标记，但CONNMARK是针对连接的，而MARK是针对单一数据包的。
这两种机制一般都要和ip rule中的fwmark联用，实现对满足某一类条件的数据包的策略路由。所以问题的关键在于两点：
1. 对连接打了标记，只是标记了连接，没有标记连接中的每个数据包。标记单个数据包，也不会对整条连接的标记
   有影响。二者是相对独立的。

2. 路由判定(routing decision)是以单一数据包为单位的。或者说，在netfilter框架之外，并没有连接标记的概念。
   或者说，ip命令只知道MARK, 而不知道CONNMARK是什么。

所以写相关的iptables规则，关键在于：给所有要进行ip rule匹配的单一数据包打上标记。
方法一般有二：用MARK直接打，或者
              用CONNMARK -restore-mark把打在连接上的标记转移到数据包上。

# 第一个outgoing的包(tcp SYN)，打上标记
iptables -t mangle -A PREROUTING -p tcp --dport 443 -m conntrack --ctstate NEW -j MARK --set-mark 0x01
 
# routing decision时，会选择与0x01标记对应的那条路由。
# 然后，我们把这个包上的标记(0x01)转存到与之对应的连接上。--save-mark功能就在于此。
iptables -t mangle -A POSTROUTING -m conntrack --ctstate NEW -j CONNMARK --save-mark
 
# 这条连接后续的包，都用--restore-mark命令，把连接上的标记(上一条命令保存的)
# 再打到每个单一数据包上。
iptables -t mangle -A PREROUTING -i br-lan -m conntrack --ctstate ESTABLISHED,RELATED -j CONNMARK --restore-mark

# 至此，所有(目的端口为443的outgoing包)对应连接上的每一个数据包都打上了0x01标记，可以被正确地路由。
EOF
}

iptables_i_HMARK(){ cat - <<'EOF'
iptables -j HMARK -h
和MARK一样，即设置fwmark，但标记是由哈希包选择器选择计算的。您还必须指定标记范围，并可选择从哪个偏移开始。ICMP错误信息被检查并用于计算哈希。
iptables -t mangle -A PREROUTING -m conntrack --ctstate NEW
         -j HMARK --hmark-tuple ct,src,dst,proto --hmark-offset 10000 --hmark-mod 10 --hmark-rnd 0xfeedcafe

iptables -t mangle -A PREROUTING 
         -j HMARK --hmark-offset 10000 --hmark-tuple src,dst,proto --hmark-mod 10 --hmark-rnd 0xdeafbeef
EOF
}

# iptables-extensions -- list of extensions in the standard iptables distribution
iptables_i_LED(){ cat - <<'EOF'
iptables -j LED -h
这就创建了一个LED触发器，然后可以连接到系统指示灯上，当某些数据包通过系统时闪烁或点亮它们。
一个例子是，每当SSH连接到本地机器时，LED灯会亮几分钟。以下选项控制触发行为。
--led-trigger-id ssh 这是LED触发器的名称。触发器的实际名称将以 "netfilter-"为前缀。
--led-delay ms       这表示当一个数据包到达时，在再次关闭之前，LED应保持点亮多久(以毫秒为单位)。默认值是0(尽可能快地闪烁)，可以给特殊值inf，一旦激活，LED就永久亮着(在这种情况下，需要手动将触发器拆下并重新连接到LED设备上才能再次关闭。)
--led-always-blink   在数据包到达时总是让LED闪烁，即使LED已经打开。 这使得即使有较长的延迟值也能通知新的数据包(否则会导致延迟时间的无声延长)。

# 连接触发LED亮
Create an LED trigger for incoming SSH traffic:
    iptables -A INPUT -p tcp --dport 22 -j LED --led-trigger-id ssh 
Then attach the new trigger to an LED:
    echo netfilter-ssh > /sys/class/leds/ledname/trigger
EOF
}


# QUEUE中断过滤程序，将封包放入队列，交给其它程序处理。透过自行开发的处理程序，可以进行其它应用，例如：计算联机费 .......等。
iptables_i_NFQUEUE_nfqsed_netsed(){ cat - <<'EOF'
iptables -j NFQUEUE -h
这个目标使用nfnetlink_queue处理程序将数据包传到用户空间。 数据包被放入由其16位队列号标识的队列中。  
如果需要，用户空间可以检查和修改数据包。 然后，用户空间必须将数据包丢弃或重新注入内核。 
nfnetlink_queue在Linux 2.6.14中被加入。在Linux 2.6.31中加入了队列平衡选项，在2.6.39中加入了队列旁路。

QUEUE的意思是将数据包传到用户空间。 (用户空间进程如何接收数据包取决于特定的队列处理程序)。 
2.4.x和2.6.x内核到2.6.13都包含ip_queue队列处理程序。  Kernels 2.6.14及以后的版本还包括nfnetlink_queue队列处理程序。 
在这种情况下，目标为QUEUE的数据包将被发送到队列号'0'。也请参见本手册后面描述的NFQUEUE目标)

通过netlink来把报文直接送到用户空间进行处理，该TARGET和 QUEUE的区别就是可以指定netflter中实现的
netlink 队列号。用户空间的处理程序需要用户自己实现。
--queue-num value //队列号
--queue-balance value:value  //指定队列号的范围，netfilter会均匀的分给多个队列

https://github.com/rgerganov/nfqsed
nfqsed是一个命令行工具，它可以使用预定义的替换规则透明地修改网络流量。它运行在Linux上，使用netfilter_queue库。它与netsed类似，
但它也允许修改通过以太网桥的网络流量。这在源MAC地址需要保持不变的情况下特别有用。
nfqsed -s /val1/val2 [-s /val1/val2] [-f file] [-v] [-q num]
    -s val1/val2     - replaces occurences of val1 with val2 in the packet payload
    -f file          - read replacement rules from the specified file
    -q num           - bind to queue with number 'num' (default 0)
    -v               - be verbose

# iptables -A FORWARD -p tcp --destination-port 554 -j NFQUEUE --queue-num 0
# nfqsed -s /foo/bar -s /good/evil

sudo apt install netsed
netsed是一个小巧方便的工具，可以实时改变网络流或数据报连接中转发的数据包的内容。当调用一组替换规则时，
这些规则会被测试是否适用于每个进入任一方向的数据包。
netsed {proto} {lport} {rhost} {rport} {rule} [rule ...]
EOF
}

# 可以看到，iptables中nflog使用的难点在于接收程序的编写，但是通过libnetfilter_log库编写这个接收程序也不难。
# LOG 将封包相关讯息纪录在/var/log中，详细位置请查阅 /etc/syslog.conf组态档，进行完此处理动作后，将会继续比对其规则。
# 例如：iptables -A INPUT -p tcp -j LOG --log-prefix "INPUT packets"

iptables_i_target_LOG_NFLOG(){ cat - <<'EOF'
    iptables是linux下基于Netfilter框架实现的防火墙软件。通过iptables我们可以方便的对内核中流动的数据包进行一些处理。
iptables拥有强大的log(数据包记录)功能，可以把按特定规则匹配的ip数据包以log的形式传递到用户层供用户分析，这样我们
就可以非常方便的了解内核中都有哪些ip数据包在传递以及这些数据包的内容。
    iptables有三种log记录形式，分别是log、ulog、nflog。log用于将匹配的数据包记录到系统的syslog中去，用户也可以直接
通过dmesg命令查看。log命令只记录包头的一些。ulog通过netlink套接字将数据包多播到指定netlink多播组，这样任何感兴趣的
进程都可以通过建立netlink套接字来接受内核中的数据包信息。ulog可以将整个数据包拷贝并发送给应用程序，当然也可以指定
发送方数据包的字节数。nflog类似于ulog，但是功能更加强大。nflog不仅可以接受来自iptables的数据，还可以向iptables通过
netlink套接字发送控制数据。

ULOG: iptables -j ULOG -h (netlink socket被多播，一个或多个用户空间的进程就会接受它们)
                          (这个target可以是我们把信息记录到MySQL或其 他数据库中。这样，搜索特定的包或把记录分组就很方便了)
这是NFLOG目标的一个过时的只适用于ipv4的前身。 它提供匹配数据包的用户空间日志。 当这个目标被设置为一个规则时，
Linux内核将通过netlink套接字组播这个数据包。然后，一个或多个用户空间进程可以订阅各种组播组并接收数据包。 
和LOG一样，这是一个 "非终端目标"，即规则遍历在下一个规则处继续。
可以使用--ulog在某个链上添加ulog规则。
    例如：iptables -A INPUT -p TCP --dport 22 -j ULOG --ulog-nlgroup 2
    在input链上把所有目的端口号为22的数据包发送到netlink多播组2中。
    ulog还有以下几个选项：
# iptables -A INPUT -p TCP --dport 22 -j ULOG --ulog-nlgroup 2 
    --ulog-nlgroup：指定向哪个netlink组发送包，比如--ulog-nlgroup 5。一个有32个netlink组，它们被简单地编号位1-32。
                    默认值是1。
# iptables -A INPUT -p TCP --dport 22 -j ULOG --ulog-prefix "SSH connection attempt: "
    --ulog-prefix：指定记录信息的前缀，以便于区分不同的信息。使用方法和 LOG的prefix一样，只是长度可以达到32个字符。
# iptables -A INPUT -p TCP --dport 22 -j ULOG --ulog-cprange 100
    --ulog-cprange：指定每个包要向"ULOG在用户空间的代理"发送的字节数， 如--ulog-cprange 100，表示把整个包的前100个
                    字节拷贝到用户空间记录下来，其 中包含了这个包头，还有一些包的引导数据。默认值是0，表示拷贝整个包，不管它有多大。
# iptables -A INPUT -p TCP --dport 22 -j ULOG --ulog-qthreshold 10
    --ulog-qthreshold：告诉ULOG在向用户空间发送数据以供记录之前，要在内核里 收集的包的数量(译者注：就像集装箱)，
                       如--ulog-qthreshold 10。这表示先在 内核里积聚10个包，再把它们发送到用户空间里，它们会被看作同
                       一个netlink的信息，只是由好几部分组 成罢了。默认值是1，这是为了向后兼容，因为以前的版本不能处理
                       分段的信息。
   
NFLOG: iptables -j NFLOG -h
该目标提供匹配数据包的日志记录。当这个目标被设置为规则时，Linux内核将把数据包传递给加载的日志后端来记录数据包。
这个目标通常与nfnetlink_log结合使用，作为日志后端，它将通过netlink套接字把数据包组播到指定的组播组。一个或多个
用户空间进程可以订阅该组来接收数据包。和LOG一样，这是一个非终端目标，即规则遍历在下一个规则处继续。
--nflog-group NUM          标识消息写入哪个消息池，如果消息池不存在将不会写消息
--nflog-range NUM          消息中包含网络层数据最大长度，0表示将写入所有网络层数据
--nflog-threshold NUM    消息池消息个数等于大于NUM，刷新消息池。
--nflog-prefix STRING    本条消息的前缀

说明：消息池也有一个threshold属性，target中也有一个threshold属性，每次写入消息前，取两者最小的，然后判断是否刷新消息池。
注意：这里的group是选择消息池，nflog netlink消息是发送给创建这个消息池的进程，不是用广播包来发送，而ULOG是用广播包来发送消息。
iptables的默认属性： -j NFLOG -nflog-group 0 -nflog-threshold 1


LOG iptables -j LOG -h
    打开内核对匹配数据包的日志记录。 当为一个规则设置这个选项时，Linux 内核将通过内核日志打印所有匹配数据包的一些信息 
(就像大多数 IP/IPv6 头部字段一样)(可以用 dmesg(1) 读取或在 syslog 中读取)。
    这是一个 "非终端目标"，即规则遍历在下一个规则处继续。 所以，如果你想把拒绝的数据包LOG化，可以使用两个具有相同匹配
标准的独立规则，先使用目标LOG，再使用DROP(或REJECT)。
# iptables -A FORWARD -p tcp -j LOG --log-level debug
--log-level <syslog level>           日志等级是数值或符号性登录优先级(在/usr/include/sys/syslog.h中列出)。
在/etc/syslog.conf中也使用了同样的日志级别。等级包括emerg alert crit err warn notice info debug
# iptables -A INPUT -p tcp -j LOG --log-prefix "INPUT packets"
--log-prefix <"descriptive string">  前缀是被引用的字符串，他将被打印在日志消息的开头
# iptables -A FORWARD -p tcp -j LOG --log-ip-options
--log-ip-options                     所有IP报头选项
# iptables -A INPUT -p tcp -j LOG --log-tcp-sequence
--log-tcp-sequence                   TCP数据包的序列号
# iptables -A FORWARD -p tcp -j LOG --log-tcp-options
--log-tcp-option                     TCP报头选项
--log-uid                            生成数据包的用户ID


通常情况下，iptables的默认政策为DROP，不匹配的数据包将被直接丢弃。但在丢弃之前建议把信息记录下来，以使你了解哪些信息没有通过规则，有时可依此判断是否有人在尝试攻击你的服务器。
下面给出一个用来详细记录未匹配规则的数据包的iptables规则：

#记录下未符合规则的udp数据包，然后丢弃之。
iptables -A INPUT -i $IFACE -p udp -j LOG --log-prefix "IPTABLES UDP-IN: "
iptables -A INPUT -i $IFACE -p udp -j DROP
iptables -A OUTPUT -o $IFACE -p udp -j LOG --log-prefix "IPTABLES UDP-OUT: "
iptables -A OUTPUT -o $IFACE -p udp -j DROP

# 记录下未符合规则的icmp数据包，然后丢弃之。
iptables -A INPUT -i $IFACE -p icmp -j LOG --log-prefix "IPTABLES ICMP-IN: "
iptables -A INPUT -i $IFACE -p icmp -j DROP
iptables -A OUTPUT -o $IFACE -p icmp -j LOG --log-prefix "IPTABLES ICMP-OUT: "
iptables -A OUTPUT -o $IFACE -p icmp -j DROP

# 记录下未符合规则的tcp数据包，然后丢弃之。
iptables -A INPUT -i $IFACE -p tcp -j LOG --log-prefix "IPTABLES TCP-IN: "
iptables -A INPUT -i $IFACE -p tcp -j DROP
iptables -A OUTPUT -o $IFACE -p tcp -j LOG --log-prefix "IPTABLES TCP-OUT: "
iptables -A OUTPUT -o $IFACE -p tcp -j DROP

# 记录下其他未符合规则的数据包，然后丢弃之。
iptables -A INPUT -i $IFACE -j LOG --log-prefix "IPTABLES PROTOCOL-X-IN: "
iptables -A INPUT -i $IFACE -j DROP
iptables -A OUTPUT -o $IFACE -j LOG --log-prefix "IPTABLES PROTOCOL-X-OUT: "
iptables -A OUTPUT -o $IFACE -j DROP  

加上适当的记录日志前缀，可以方便对日志进行分析。 日志通常记录在/var/log/message文件中。如，可以使用
cat /var/log/message | grep "IPTABLES UDP-IN: "  查找出你需要的日志信息。 当然为了防止日志文件过大，
你也可以对日志文件记录进行限制，如可以在-j LOG 命令 前加上-m limit --limit 6/h --limit-burst 5
EOF
}


iptables_t_rule(){ cat - <<'EOF'
	iptables -L INPUT                            # 列出某规则链中的所有规则
	iptables -X allowed                          # 删除某个规则链 ,不加规则链，清除所有非内建的
	iptables -Z INPUT                            # 将封包计数器归零
	iptables -N allowed                          # 定义新的规则链
	iptables -P INPUT DROP                       # 定义过滤政策
	iptables -A INPUT -s 192.168.1.1             # 比对封包的来源IP   # ! 192.168.0.0/24  ! 反向对比
	iptables -A INPUT -d 192.168.1.1             # 比对封包的目的地IP
	iptables -A INPUT -i eth0                    # 比对封包是从哪片网卡进入
	iptables -A FORWARD -o eth0                  # 比对封包要从哪片网卡送出 eth+表示所有的网卡
	iptables -A INPUT -p tcp                     # -p ! tcp 排除tcp以外的udp、icmp。-p all所有类型
	iptables -D INPUT 8                          # 从某个规则链中删除一条规则
	iptables -D INPUT --dport 80 -j DROP         # 从某个规则链中删除一条规则
	iptables -R INPUT 8 -s 192.168.0.1 -j DROP   # 取代现行规则
	iptables -I INPUT 8 --dport 80 -j ACCEPT     # 插入一条规则
	iptables -A INPUT -i eth0 -j DROP            # 其它情况不允许
	iptables -A INPUT -p tcp -s IP -j DROP       # 禁止指定IP访问
	iptables -A INPUT -p tcp -s IP --dport port -j DROP                       # 禁止指定IP访问端口
	iptables -A INPUT -s IP -p tcp --dport port -j ACCEPT                     # 允许在IP访问指定端口
	iptables -A INPUT -p tcp --dport 22 -j DROP                               # 禁止使用某端口
	iptables -A INPUT -i eth0 -p icmp -m icmp --icmp-type 8 -j DROP           # 禁止icmp端口
	iptables -A INPUT -i eth0 -p icmp -j DROP                                 # 禁止icmp端口
	iptables -t filter -A INPUT -i eth0 -p tcp --syn -j DROP                  # 阻止所有没有经过你系统授权的TCP连接
	iptables -A INPUT -f -m limit --limit 100/s --limit-burst 100 -j ACCEPT   # IP包流量限制
	iptables -A INPUT -i eth0 -s 192.168.62.1/32 -p icmp -m icmp --icmp-type 8 -j ACCEPT  # 除192.168.62.1外，禁止其它人ping我的主机
	iptables -A INPUT -p tcp -m tcp --dport 80 -m state --state NEW -m recent --update --seconds 5 --hitcount 20 --rttl --name WEB --rsource -j DROP  # 可防御cc攻击(未测试)
EOF
}

iptables_t_Block_Open_Common_Ports(){ cat - <<'EOF'
  Replace ACCEPT with DROP to block port:
  ## open port ssh tcp port 22 ##
  iptables -A INPUT -m state --state NEW -m tcp -p tcp --dport 22 -j ACCEPT
  iptables -A INPUT -s 192.168.1.0/24 -m state --state NEW -p tcp --dport 22 -j ACCEPT
  
  ## open cups (printing service) udp/tcp port 631 for LAN users ##
  iptables -A INPUT -s 192.168.1.0/24 -p udp -m udp --dport 631 -j ACCEPT
  iptables -A INPUT -s 192.168.1.0/24 -p tcp -m tcp --dport 631 -j ACCEPT
  
  ## allow time sync via NTP for lan users (open udp port 123) ##
  iptables -A INPUT -s 192.168.1.0/24 -m state --state NEW -p udp --dport 123 -j ACCEPT
  
  ## open tcp port 25 (smtp) for all ##
  iptables -A INPUT -m state --state NEW -p tcp --dport 25 -j ACCEPT
  
  # open dns server ports for all ##
  iptables -A INPUT -m state --state NEW -p udp --dport 53 -j ACCEPT
  iptables -A INPUT -m state --state NEW -p tcp --dport 53 -j ACCEPT
  
  ## open http/https (Apache) server port to all ##
  iptables -A INPUT -m state --state NEW -p tcp --dport 80 -j ACCEPT
  iptables -A INPUT -m state --state NEW -p tcp --dport 443 -j ACCEPT
  
  ## open tcp port 110 (pop3) for all ##
  iptables -A INPUT -m state --state NEW -p tcp --dport 110 -j ACCEPT
  
  ## open tcp port 143 (imap) for all ##
  iptables -A INPUT -m state --state NEW -p tcp --dport 143 -j ACCEPT
  
  ## open access to Samba file server for lan users only ##
  iptables -A INPUT -s 192.168.1.0/24 -m state --state NEW -p tcp --dport 137 -j ACCEPT
  iptables -A INPUT -s 192.168.1.0/24 -m state --state NEW -p tcp --dport 138 -j ACCEPT
  iptables -A INPUT -s 192.168.1.0/24 -m state --state NEW -p tcp --dport 139 -j ACCEPT
  iptables -A INPUT -s 192.168.1.0/24 -m state --state NEW -p tcp --dport 445 -j ACCEPT
  
  ## open access to proxy server for lan users only ##
  iptables -A INPUT -s 192.168.1.0/24 -m state --state NEW -p tcp --dport 3128 -j ACCEPT
  
  ## open access to mysql server for lan users only ##
  iptables -I INPUT -p tcp --dport 3306 -j ACCEPT
  
  
  iptables -nL
  查看本机关于iptables的设置情况，默认查看的是-t filter，可以指定-t nat
  
  iptables-save > iptables.rule
  会保存当前的防火墙规则设置，命令行下通过iptables配置的规则在下次重启后会失效，当然这也是为了防止错误的配置防火墙。
  默认读取和保存的配置文件地址为/etc/sysconfig/iptables。
  
  iptables -I INPUT 1 -m state --state RELATED,ESTABLISHED -j ACCEPT
  把这条语句插在input链的最前面(第一条)，对状态为ESTABLISHED,RELATED的连接放行。
  这条规则在某种情况下甚至比下面开放ssh服务都重要：① 如果INPUT连默认为DROP，② INPUT链默认为INPUT，但存在这条规则-A INPUT -j REJECT --reject-with icmp-host-prohibited，上面两种情况下都必须添加--state RELATED,ESTABLISHED为第一条，否则22端口无法通行，把自己锁在防火墙外面了。
  有了这条规则，可保证只要当前ssh没有关闭，哪怕防火墙忘记开启22端口，也可以继续连接。
  
  iptables -A INPUT -m state --state NEW -m tcp -p tcp --dport 22 -j ACCEPT
  允许所有，不安全，默认。
  
  iptables -A INPUT -s 172.29.73.0/24 -p tcp -m state --state NEW -m tcp --dport 22 -j ACCEPT
  限制指定IP范围能SSH，可取
  
  iptables -A INPUT -s 10.30.0.0/16 -p tcp -m tcp -m multiport --dports 80,443 -j ACCEPT
  允许一个IP段访问多个端口
  
  iptables -A INPUT -s 10.30.26.0/24 -p tcp -m tcp --dport 80 -j DROP
  禁止某IP段访问80端口，将-j DROP改成 -j REJECT --reject-with icmp-host-prohibited作用相同。
    
EOF
}

iptables_t_ip_forward_DNAT(){ cat - <<'EOF'
	ip_forward(路由器模式){
		首先要开启端口转发器必须先修改内核运行参数ip_forward,打开转发:
		# echo 1 > /proc/sys/net/ipv4/ip_forward   //此方法临时生效
		或
		# vi /ect/sysctl.conf                      //此方法永久生效
		# sysctl -p
	}
	
    PREROUTING(本机端口转发){
    2.DNAT目标地址转换
    对于目标地址转换，数据流向是从外向内的，外面的是客户端，里面的是服务器端通过目标地址转换，我们可以让外面的
    ip通过我们对外的外网ip来访问我们服务器不同的服务器，而我们的服务却放在内网服务器的不同的服务器上。
    
    如何做目标地址转换呢？：
    iptables -t nat -A PREROUTING -d 192.168.10.18 -p tcp -dport 80 -j DNAT -todestination 172.16.100.2
    目标地址转换要做在到达网卡之前进行转换,所以要做在PREROUTING这个位置上
        
        iptables -t nat -A PREROUTING -p tcp -m tcp --dport 80 -j REDIRECT --to-ports 8080
        根据 iptables防火墙原理详解可知，实际上在数据包进入INPUT链之前，修改了目标地址(端口)，于是不难理解
        在开放端口时需要设置的是放行8080端口，无需考虑80：
        
        iptables -A INPUT -s 172.29.88.0/24 -p tcp -m state --state NEW -m tcp --dport 8080 -j ACCEPT
        此时外部访问http的80端口便可自动转到8080(浏览器地址栏不会变)，而且又具有很高的性能，但如果
        你通过服务器本地主机的curl或firfox浏览器访问http://localhost:80或http://doman.com:80都是不行(假如你有这样的奇葩需求)
        ，这是因为本地数据包产生的目标地址不对，你需要额外添加这条 OUTPUT 规则：
        iptables -t nat -A OUTPUT -p tcp --dport 80 -j REDIRECT --to-ports 8080
        
        iptables -t nat -A PREROUTING -p tcp -i eth0 -d $YOUR_HOST_IP --dport 80 -j DNAT --to $YOUR_HOST_IP:8080 
        iptables -t nat -A OUTPUT -p tcp -d $YOUR_HOST_IP --dport 80 -j DNAT --to 127.0.0.1:8080 
        iptables -t nat -A OUTPUT -p tcp -d 127.0.0.1 --dport 80 -j DNAT --to 127.0.0.1:8080
    }
    
    PREROUTING_POSTROUTING(异机端口转发){
        有些情况下企业内部网络隔离比较严格，但有一个跨网段访问的情况，此时只要转发用的中转服务器能够与另外的两个IP
        (服务器或PC)通讯就可以使用iptables实现转发。(端口转发的还有其他方法，请参考 linux服务器下各种端口转发技巧 )
        
        要实现的是所有访问 192.168.10.100:8000 的请求，转发到 172.29.88.56:80 上，在 192.168.10.100 是哪个添加规则:
        iptables -t nat -A PREROUTING -i eth0 -p tcp -d 192.168.10.100 --dport 8000 -j DNAT --to-destination 172.29.88.56:80
        iptables -t nat -A POSTROUTING -o eth0 -j SNAT --to-source 192.168.10.100
        或者
        iptables -t nat -A PREROUTING -d 192.168.10.100 -p tcp --dport 8000 -j DNAT --to 172.29.88.56:80
        iptables -t nat -A POSTROUTING -d 172.29.88.56 -p tcp --dport 80 -j SNAT --to-source 192.168.10.100
        
        需要注意的是，如果你的FORWARD链默认为DROP，上面所有端口转发都必须建立在FORWARD链允许通行的情况下：
        iptables -A FORWARD -d 172.29.88.56 -p tcp --dport 80 -j ACCEPT
        iptables -A FORWARD -s 172.29.88.56 -p tcp -j ACCEPT
    }
EOF
}
iptables_i_layer7(){  cat - <<'EOF'
2.下载相关软件
wget http://www.kernel.org/pub/linux/kernel/v2.6/linux-2.6.28.tar.bz2
wget http://netfilter.org/projects/iptables/files/iptables-1.4.7.tar.bz2
wget http://downloads.sourceforge.net/project/l7-filter/Protocol%20definitions/2009-05-28/l7-protocols-2009-05-28.tar.gz
wget http://downloads.sourceforge.net/project/l7-filter/l7-filter%20kernel%20version/2.22/netfilter-layer7-v2.22.tar.gz

wget  http://download.clearfoundation.com/l7-filter/netfilter-layer7-v2.23.tar.gz

cp /etc/init.d/iptables /root
cp /etc/sysconfig/iptables-config /root
rpm -qa | grep iptables

cd /usr/src/linux
patch -p1 < ../netfilter-layer7-v2.22/kernel-2.6.25-2.6.28-layer7-2.22.patch

5.编译内核
说明：(需要增加的编译模块)
Networking support → Networking Options → Network packet filtering framework → Core Netfilter Configuration 
<M>  Netfilter connection tracking support 
<M>  "layer7" match support 
<M>  "string" match support 
<M>  "time"  match support 
<M>  "iprange"  match support 
<M>  "connlimit"  match support 
<M>  "state"  match support 
<M>  "conntrack"  connection  match support 
<M>  "mac"  address  match support 
<M>  "multiport" Multiple port match support

Networking support → Networking Options →Network packet filtering framework → IP Netfilter Configuration 
<M> IPv4 connection tracking support (required for NAT)
<M> Full NA
<M> MASQUERADE target support
<M> NETMAP target support                            
<M> REDIRECT target support

查看支持的协议
[root@localhost ~]# ls /etc/l7-protocols/protocols/
100bao.pat                doom3.pat                 jabber.pat            radmin.pat        teamfortress2.pat
aim.pat                   edonkey.pat               kugoo.pat             rdp.pat           teamspeak.pat
aimwebcontent.pat         fasttrack.pat             live365.pat           replaytv-ivs.pat  telnet.pat
applejuice.pat            finger.pat                liveforspeed.pat      rlogin.pat        tesla.pat
ares.pat                  freenet.pat               lpd.pat               rtp.pat           tftp.pat
armagetron.pat            ftp.pat                   mohaa.pat             rtsp.pat          thecircle.pat
battlefield1942.pat       gkrellm.pat               msn-filetransfer.pat  runesofmagic.pat  tonghuashun.pat
battlefield2142.pat       gnucleuslan.pat           msnmessenger.pat      shoutcast.pat     tor.pat
battlefield2.pat          gnutella.pat              mute.pat              sip.pat           tsp.pat
bgp.pat                   goboogy.pat               napster.pat           skypeout.pat      unknown.pat
biff.pat                  gopher.pat                nbns.pat              skypetoskype.pat  unset.pat
bittorrent.pat            guildwars.pat             ncp.pat               smb.pat           uucp.pat
chikka.pat                h323.pat                  netbios.pat           smtp.pat          validcertssl.pat
cimd.pat                  halflife2-deathmatch.pat  nntp.pat              snmp.pat          ventrilo.pat
ciscovpn.pat              hddtemp.pat               ntp.pat               socks.pat         vnc.pat
citrix.pat                hotline.pat               openft.pat            soribada.pat      whois.pat
counterstrike-source.pat  http.pat                  pcanywhere.pat        soulseek.pat      worldofwarcraft.pat
cvs.pat                   http-rtsp.pat             poco.pat              ssdp.pat          x11.pat
dayofdefeat-source.pat    ident.pat                 pop3.pat              ssh.pat           xboxlive.pat
dazhihui.pat              imap.pat                  pplive.pat            ssl.pat           xunlei.pat
dhcp.pat                  imesh.pat                 qq.pat                stun.pat          yahoo.pat
directconnect.pat         ipp.pat                   quake1.pat            subspace.pat      zmaap.pat
dns.pat                   irc.pat                   quake-halflife.pat    subversion.pat
EOF
}

iptables_i_Xtables_Addons(){  cat - <<'EOF'
通常增加Iptables模块需重新编译内核及Iptables，通过Xtables-Addons安装其支持的模块可免编译安装。
Xtables-Addons支持模块：
build_ACCOUNT=m
build_CHAOS=m
build_CHECKSUM=
build_DELUDE=m
build_DHCPMAC=m
build_DNETMAP=m
build_ECHO=
build_IPMARK=m
build_LOGMARK=m
build_RAWNAT=m
build_STEAL=m
build_SYSRQ=m
build_TARPIT=m
build_TEE=
build_condition=m
build_fuzzy=m
build_geoip=m
build_gradm=m
build_iface=m
build_ipp2p=m
build_ipset4=m
build_ipset6=
build_ipv4options=m
build_length2=m
build_lscan=m
build_pknock=m
build_psd=m
build_quota2=m

Xtables-Addons安装要求：
iptables >= 1.4.3
kernel-source >= 2.6.29

CentOS安装支持组件：
rpm -ivh http://mirrors.ustc.edu.cn/fedora/epel/6/i386/epel-release-6-7.noarch.rpm
yum install gcc gcc-c++ make automake kernel-devel iptables-devel perl-Text-CSV_XS xz

安装Xtables-Addons：
wget http://sourceforge.net/projects/xtables-addons/files/Xtables-addons/1.42/xtables-addons-1.42.tar.xz
xz -d xtables-addons-1.42.tar.xz 
tar xvf xtables-addons-1.42.tar
cd xtables-addons-1.42
./configure
make
make install
#可修改mconfig选择要安装的模块

下载Geoip数据库：
cd geoip
./xt_geoip_dl
./xt_geoip_build GeoIPCountryWhois.csv
mkdir /usr/share/xt_geoip
cp -r {BE,LE}  /usr/share/xt_geoip/

应用举例：
iptables -I INPUT -m geoip --src-cc US-j DROP
#拒绝美国IP连接
EOF
}

iptables_i_keepalive_vrrp(){
iptables -I INPUT -d 224.0.0.0/8 -j ACCEPT
iptables -I INPUT -p vrrp -j ACCEPT
}

iptables_t_REJECT_country(){  cat - <<'EOF'
Iptables拒绝指定国家的IP访问
有些服务器需拒绝特定国家的IP访问，可使用Iptables配合ipdeny提供的各个国家IP段为源进行过滤操作，
由于数目较多会影响iptables性能，也可使用高效率Iptables geoip模块进行匹配操作。
应用示例，以拒绝美国IP为例：

#http://www.haiyun.me
#/bin/bash
wget -O /tmp/us.zone http://www.ipdeny.com/ipblocks/data/countries/us.zone
for ip in `cat /tmp/us.zone`
do
Blocking $ip
iptables -I INPUT -s $ip -j DROP
done
EOF
}

iptables_i_connlimit(){  cat - <<'EOF'
connlimit模块针对每个IP限制连接数
之前有介绍Iptables下limit模块，此模块应用限制是全局的，connlimit就灵活了许多，针对每个IP做限制。
应用示例，注意不同的默认规则要使用不同的方法。
1.默认规则为DROP的情况下限制每个IP连接不超过10个
iptables -P INPUT DROP
iptables -A INPUT -p tcp --dport 80 -m connlimit ! --connlimit-above 10 -j ACCEPT

2.默认规则为ACCEPT的情况下限制每个IP连接不超过10个
iptables -P INPUT ACCEPT
iptables -A INPUT -p tcp --dport 80 -m connlimit --connlimit-above 10 -j DROP
EOF
}

# https://blog.csdn.net/eydwyz/article/details/53352818
iptables_t_connlimit(){  cat - <<'iptables_t_connlimit'
现在来看看如何限制TCP和UDP的连接数吧,很NB的(不知道标准版本和简化版是否支持,一下语句不保证可用,因个人路由器环境而定):
iptables -I FORWARD -p tcp -m connlimit --connlimit-above 100 -j DROP           #看到了吧,在FORWARD转发链的时候,所有tcp连接大于100 的数据包就丢弃!是针对所有IP的限制
iptables -I FORWARD -p udp -m limit --limit 5/sec -j DROP                        #UDP是无法控制连接数的, 只能控制每秒多少个UDP包, 这里设置为每秒5个,5个已经不少了,10个就算很高了,这个是封杀P2P的利器,一般设置为每秒3~5个比较合理.
如何查看命令是否生效呢?:
执行  iptables -L FORWARD 就可以看到如下结果:
DROP       tcp  --  anywhere             anywhere            #conn/32 > 100 
DROP       udp  --  anywhere             anywhere            limit: avg 5/sec bu
如果出现了这2个结果,说明限制连接数的语句确实生效了, 如果没有这2个出现,则说明你的dd-wrt不支持connlimit限制连接数模块.


现在我想给自己开个后门,不受连接数的限制该怎么做呢?看下面的:
iptables -I FORWARD -s 192.168.1.23 -j RETURN          #意思是向iptables的FORWARD链的最头插入这个规则,这个规则现在成为第一个规则了,23是我的IP,就是说,只要是我的IP的就不在执行下面的连接数限制的规则语句了,利用了iptables链的执行顺序规则,我的IP被例外了.


告诉大家一个查看所有人的连接数的语句:
sed -n 's%.* src=192.168.[0−9.]∗.*%\1%p' /proc/net/ip_conntrack | sort | uniq -c    #执行这个就可以看到所有IP当前所占用的连接数
iptables_t_connlimit
}


iptables_i_conntrack(){ cat - <<'EOF'
iptables -m conntrack -h
[!] --ctstate {INVALID|ESTABLISHED|NEW|RELATED|UNTRACKED|SNAT|DNAT}[,...]     # 逗号分开的枚举值，
                               State(s) to match
# 等同于-A INPUT -s 192.168.10.0/24 -p udp -m state --state NEW -m udp --dport 111 -j ACCEPT
[!] --ctproto proto            Protocol to match; by number or name, e.g. "tcp" # 匹配的四层协议
[!] --ctorigsrc address[/mask]                                                  # 接收报文的源地址
[!] --ctorigdst address[/mask]                                                  # 接收报文的目的地址
[!] --ctreplsrc address[/mask]                                                  # 发送报文的源地址
[!] --ctrepldst address[/mask]                                                  # 发送报文的目的地址
                               Original/Reply source/destination address
[!] --ctorigsrcport port                                                        # 接收报文源端口
[!] --ctorigdstport port                                                        # 接收报文目的端口
[!] --ctreplsrcport port                                                        # 发送报文源端口
[!] --ctrepldstport port                                                        # 发送报文目的端口
                               TCP/UDP/SCTP orig./reply source/destination port
[!] --ctstatus {NONE|EXPECTED|SEEN_REPLY|ASSURED|CONFIRMED}[,...]
# 两个模块基本功能一致，state 简单一些，相比速度上有优势，conntrack功能更全面，或许考虑到将来的兼容性，用conntrack会更好一些。
                               Status(es) to match
[!] --ctexpire time[:time]     Match remaining lifetime in seconds against
                               value or range of values (inclusive)
    --ctdir {ORIGINAL|REPLY}   Flow direction of packet

http://lw1957625.blog.163.com/blog/static/536348852013112610234800/
# https://www.kernel.org/doc/Documentation/networking/ip-sysctl.txt
sysctl -a | grep conntrack
find -name "*conntrack*"
https://www.kernel.org/doc/Documentation/networking/nf_conntrack-sysctl.txt
https://www.kernel.org/doc/Documentation/networking/netfilter-sysctl.txt
antmeetspenguin.blogspot.com/2011/01/high-performance-linux-router.html
EOF
}

iptables_i_bridge_nf(){ cat - <<'iptables_i_bridge_nf'
bridge-nf使得netfilter可以对Linux网桥上的IPv4/ARP/IPv6包过滤。
比如，设置net.bridge.bridge-nf-call-iptables＝1后，二层的网桥在转发包时也会被iptables的FORWARD规则所过滤，这样有时会出现L3层的iptables rules去过滤L2的帧的问题

常用的选项包括
    net.bridge.bridge-nf-call-arptables：是否在arptables的FORWARD中过滤网桥的ARP包
    net.bridge.bridge-nf-call-ip6tables：是否在ip6tables链中过滤IPv6包
    net.bridge.bridge-nf-call-iptables：是否在iptables链中过滤IPv4包
    net.bridge.bridge-nf-filter-vlan-tagged：是否在iptables/arptables中过滤打了vlan标签的包
当然，也可以通过/sys/devices/virtual/net/<bridge-name>/bridge/nf_call_iptables来设置，但要注意内核是取两者中大的生效。
有时，可能只希望部分网桥禁止bridge-nf，而其他网桥都开启（比如CNI网络插件中一般要求bridge-nf-call-iptables选项开启，而有时又希望禁止某个网桥的bridge-nf），这时可以改用iptables的方法：
iptables -t raw -I PREROUTING -i <bridge-name> -j NOTRACK
iptables_i_bridge_nf
}

iptables_i_nf_conntrack(){ cat - <<'iptables_i_nf_conntrack'
nf_conntrack是Linux内核连接跟踪的模块，常用在iptables中，比如
    -A INPUT -m state --state RELATED,ESTABLISHED  -j RETURN
    -A INPUT -m state --state INVALID -j DROP
可以通过cat /proc/net/nf_conntrack来查看当前跟踪的连接信息，这些信息以哈希形式（用链地址法处理冲突）存在内存中，并且每条记录大约占300B空间。
与nf_conntrack相关的内核参数有三个：
    nf_conntrack_max：连接跟踪表的大小，建议根据内存计算该值CONNTRACK_MAX = RAMSIZE (in bytes) / 16384 / (x / 32)，并满足nf_conntrack_max=4*nf_conntrack_buckets，默认262144
    nf_conntrack_buckets：哈希表的大小，(nf_conntrack_max/nf_conntrack_buckets就是每条哈希记录链表的长度)，默认65536
    nf_conntrack_tcp_timeout_established：tcp会话的超时时间，默认是432000 (5天)
iptables_i_nf_conntrack
}

iptables_i_proc_conntrack(){ cat - <<'EOF'

./sys/net/netfilter/nf_conntrack_acct
./sys/net/netfilter/nf_conntrack_buckets
./sys/net/netfilter/nf_conntrack_checksum
./sys/net/netfilter/nf_conntrack_count
./sys/net/netfilter/nf_conntrack_events
./sys/net/netfilter/nf_conntrack_expect_max
./sys/net/netfilter/nf_conntrack_frag6_high_thresh
./sys/net/netfilter/nf_conntrack_frag6_low_thresh
./sys/net/netfilter/nf_conntrack_frag6_timeout
./sys/net/netfilter/nf_conntrack_generic_timeout
./sys/net/netfilter/nf_conntrack_helper
./sys/net/netfilter/nf_conntrack_icmp_timeout
./sys/net/netfilter/nf_conntrack_icmpv6_timeout
./sys/net/netfilter/nf_conntrack_log_invalid
./sys/net/netfilter/nf_conntrack_max
./sys/net/netfilter/nf_conntrack_tcp_be_liberal
./sys/net/netfilter/nf_conntrack_tcp_loose
./sys/net/netfilter/nf_conntrack_tcp_max_retrans
./sys/net/netfilter/nf_conntrack_tcp_no_window_check
./sys/net/netfilter/nf_conntrack_tcp_timeout_close
./sys/net/netfilter/nf_conntrack_tcp_timeout_close_wait
./sys/net/netfilter/nf_conntrack_tcp_timeout_established
./sys/net/netfilter/nf_conntrack_tcp_timeout_fin_wait
./sys/net/netfilter/nf_conntrack_tcp_timeout_last_ack
./sys/net/netfilter/nf_conntrack_tcp_timeout_max_retrans
./sys/net/netfilter/nf_conntrack_tcp_timeout_syn_recv
./sys/net/netfilter/nf_conntrack_tcp_timeout_syn_sent
./sys/net/netfilter/nf_conntrack_tcp_timeout_time_wait
./sys/net/netfilter/nf_conntrack_tcp_timeout_unacknowledged
./sys/net/netfilter/nf_conntrack_timestamp
./sys/net/netfilter/nf_conntrack_udp_timeout
./sys/net/netfilter/nf_conntrack_udp_timeout_stream
./sys/net/nf_conntrack_max
EOF
}

iptables_i_ip_conntrack(){ cat - <<'EOF'
conntrack连接跟踪模块
iptables是有状态机制的防火墙，通过conntrack模块跟踪记录每个连接的状态，通过它可制定严密的防火墙规则。
可用状态机制：
#http://www.haiyun.me
NEW #新连接数据包
ESTABLISHED #已连接数据包
RELATED     #和出有送的数据包
INVALID     #无效数据包

conntrack默认最大跟踪65536个连接，查看当前系统设置最大连接数：
cat /proc/sys/net/ipv4/ip_conntrack_max

查看当前跟踪连接数：
cat /proc/net/ip_conntrack|wc -l

当服务器连接多于最大连接数时会出现kernel: ip_conntrack: table full, dropping packet的错误。
解决方法，修改conntrack最大跟踪连接数：
vim /etc/sysctl.conf #添加以下内容
net.ipv4.ip_conntrack_max = 102400

立即生效：
sysctl -p

为防止重启Iptables后变为默认，还需修改模块参数：
vim /etc/modprobe.conf #添加以下内容
options ip_conntrack hashsize=12800 #值为102400/8

一劳永逸的方法，设置Iptables禁止对连接数较大的服务进行跟踪：
#http://www.haiyun.me
iptables -A INPUT -m state --state UNTRACKED,ESTABLISHED,RELATED -j ACCEPT
iptables -t raw -A PREROUTING -p tcp --dport 80 -j NOTRACK
iptables -t raw -A OUTPUT -p tcp --sport 80 -j NOTRACK
EOF
}

iptables_t_recent(){ cat - <<'EOF'

允许您动态地创建一个IP地址列表，然后以几种不同的方式与该列表进行匹配。
例如，你可以创建一个 "badguy "列表，将试图连接到防火墙上139端口的人排除在外，然后不加考虑地DROP所有来自他们的未来数据包。
 
recent这个模块很有趣，善加利用可充分保证您服务器安全。
设定常用参数：
#http://www.haiyun.me
--name      #设定列表名称，默认DEFAULT。
--rsource   #源地址，此为默认。
--rdest     #目的地址
--seconds   #指定时间内
--hitcount  #命中次数
--set       #将地址添加进列表，并更新信息，包含地址加入的时间戳。
--rcheck    #检查地址是否在列表，以第一个匹配开始计算时间。
--update    #和rcheck类似，以最后一个匹配计算时间。
--remove    #在列表里删除相应地址，后跟列表名称及地址。

示例：
1.限制80端口60秒内每个IP只能发起10个新连接，超过记录日记及丢失数据包，可防CC及非伪造IP的syn flood。
iptables -A INPUT -p tcp --dport 80 --syn -m recent --name webpool --rcheck --seconds 60 --hitcount 10 -j LOG --log-prefix 'DDOS:' --log-ip-options
iptables -A INPUT -p tcp --dport 80 --syn -m recent --name webpool --rcheck --seconds 60 --hitcount 10 -j DROP
iptables -A INPUT -p tcp --dport 80 --syn -m recent --name webpool --set -j ACCEPT

备忘：每个IP目标端口为80的新连接会记录在案，可在/proc/net/xt_recent/目录内查看，rcheck检查此IP是否在案及请求次数，如果超过规则就丢弃数据包，否则进入下条规则并更新列表信息。
2.发送特定指定执行相应操作，按上例如果自己IP被阻止了，可设置解锁哦。
#http://www.haiyun.me
iptables -A INPUT -p tcp --dport 5000 --syn -j LOG --log-prefix "WEBOPEN: "
#记录日志，前缀WEBOPEN:
iptables -A INPUT -p tcp --dport 5000 --syn -m recent --remove --name webpool --rsource -j REJECT --reject-with tcp-reset
#符合规则即删除webpool列表内的本IP记录

3.芝麻开门，默认封闭SSH端口，为您的SSH服务器设置开门暗语。
iptables -A INPUT -p tcp --dport 50001 --syn -j LOG --log-prefix "SSHOPEN: "
#记录日志，前缀SSHOPEN:
iptables -A INPUT -p tcp --dport 50001 --syn -m recent --set --name sshopen --rsource -j REJECT --reject-with tcp-reset
#目标端口tcp50001的新数据设定列表为sshopen返回TCP重置，并记录源地址。
iptables -A INPUT -p tcp --dport 22 --syn -m recent --rcheck --seconds 15 --name sshopen --rsource -j ACCEPT
#开启SSH端口，15秒内允许记录的源地址登录SSH。
nc host 50001  #开门钥匙
telnet host 50001
nmap -sS host 50001

指定端口容易被破解密钥，可以使用ping指定数据包大小为开门钥匙。
iptables -A INPUT -p icmp --icmp-type 8 -m length --length 78 -j LOG --log-prefix "SSHOPEN: "
#记录日志，前缀SSHOPEN:
iptables -A INPUT -p icmp --icmp-type 8 -m length --length 78 -m recent --set --name sshopen --rsource -j ACCEPT
#指定数据包78字节，包含IP头部20字节，ICMP头部8字节。
iptables -A INPUT -p tcp --dport 22 --syn -m recent --rcheck --seconds 15 --name sshopen --rsource -j ACCEPT
ping -s 50 host #Linux下解锁
ping -l 50 host #Windows下解锁
EOF
}

iptables_i_netfilter_PREROUTING_INPUT(){ cat - <<'EOF'
1.在线路上(例如internet)
2.到达了接口上(例如eth0)
3.raw表的PREROUTING链                      # 这个链在连接跟踪之前处理报文，它能够设置一条连接不被连接跟踪处理。
4.这儿是连接跟踪处理的点，是否状态匹配。   # conntrack内核模块
5.mangle表的PREROUTING链                   # 这个链主要用来修改报文，例如修改TOS等等。
6.nat表的PREROUTING链                      # 这个链主要用来处理DNAT，我们应该避免在这条链里面做过滤，因为可能有一些报文会漏掉。
7.路由决定，例如决定报文是上本机还是转发或者其他地方。
8.mangle表的INPUT链 # 到了这点，mangle表的INPUT链被使用，在把这个报文实际送给本机前，路由之后，我们需要再次修改报文。
9.filter表的INPUT链 # 在这儿我们对所有送往本级的报文进行过滤，要注意所有收到的并且目的地址为本机的报文都会经过这个链，而不管哪个接口进来的或者它往哪儿去。
10.本地进程或者应用程序，例如服务器或者客户端程序。
EOF
}

iptables_i_netfilter_OUTPUT_POSTROUTING(){ cat - <<'EOF'
1.本地进程或者应用程序(例如服务器或者客户端程序)
2.路由选择，用哪个源地址以及从哪个接口上出去，当然还有其他一些必要的信息。
3.raw表的OUTPUT链 # 这儿是你能够在连接跟踪生效前处理报文的点，这儿你可以标记某个连接不被连接跟踪处理。
4.这儿就是本地发出报文进行连接跟踪处理的地儿，是否状态匹配。 # conntrack内核模块
5.mangle表的OUTPUT链 # 这儿是我们修改报文的地方，在这儿做报文过滤是不被推荐的，因为它可能有副作用。
6.nat表的OUTPUT链 # 这儿对于本级发送的报文做目的NAT(DNAT)。
7.路由决定，因为前面的mangle和nat表可能修改了报文的路由信息。
8.filter表的OUTPUT链 # 这儿是对发送报文做过滤的地方。
9.mangle表的POSTROUTING链 # 这条链可能被两种报文遍历，一种是转发的报文，另外就是本级产生的报文。
10.nat表的POSTROUTING链 # 在这儿我们做源NAT(SNAT)，我们建议你不要在这儿做报文过滤，因为有副作用。即使你设置了默认策略，一些报文也有可能溜过去。
11.在接口上发出(例如eth0)
12.到了线路上(例如internet)
EOF
}

iptables_i_netfilter_PREROUTING_FORWARD_POSTROUTING(){ cat - <<'EOF'
1.在线路上(例如internet)
2.到了接口(例如eth0)
3.raw表的PREROUTING链 # 在这儿你可以设置不想被连接跟踪系统处理的连接。
4.这儿做的是非本地报文的连接跟踪系统处理，是否状态匹配。 # conntrack内核模块
5.mangle表的PREROUTING链 # 这条链主要用来修改报文，例如改变TOS等等。
6.nat表的PREROUTING链 # 这条链主要完成DNAT，SNAT后面处理。在这条链上面不要做报文过滤。
7.路由决定，例如转发报文还是上送本机。
8.mangle表的FORWARD链 # 包继续被发送至mangle表的FORWARD链，这是非常特殊的情况才会用到的。在这里，包被mangle(还记得mangle的意思吗)。这次mangle发生在最初的路由判断之后，在最后一次更改包的目的之前(译者注：就是下面的FORWARD链所做的，因其过滤功能，可能会改变一些包的目的地，如丢弃包)。--摘录自1.09版本的中文翻译。
9.filter表的FORWARD链 # 包被继续转发至filter表的FORWARD链，只有转发报文才会到这儿，因此这儿我们做所有报文的过滤。在你自己制定规则的时候，请考虑这一点。
10.mangle表的POSTROUTING链 # 这个链也是针对一些特殊类型的包(译者注：参考第6步，我们可以发现，在转发包时，mangle表的两个链都用在特殊的应用上)。这一步mangle是在所有更改包的目的地址的操作完成之后做的，但这时包还在本地上。--摘录自1.09版本的中文翻译。
11.nat表的POSTROUTING链 # 这个链只能作为SNAT作用，千万不要做报文过滤，伪装(Masquerading)也是在这儿工作的。
12.到了报文的出接口(例如eth1)
13.又一次到了线路上(例如本地网络)
EOF
}

iptables_p_command(){ cat - <<'EOF'
iptables服务 -->表 --->链 ----> 规则 ---> 处理动作
                  < Command  >      <target>   <match>
iptables -t filter -A INPUT         -j ACCEPT  -p tcp --dport  53 #------------------- accept all incoming packets on TCP port 53 (DNS)
iptables -t filter -A FORWARD       -j REJECT  -p udp --dport 135:139 #---------------- Block outgoing NetBIOS (Windows Share) 
iptables -t filter -A FORWARD       -p tcp --dport 22 -m physdev --physdev-in wlan0 --physdev-out eth0.3  -j LOG --log-prefix "22 on wlan" #---- log wlan-clients attempts on ssh
iptables -t    nat -A PREROUTING    -i $LAN -p tcp --dport 53 -j REDIRECT --to-port 53 #---------------- redirect DNS queries to self on TCP 
iptables -t    nat -A PREROUTING    -i $LAN -p udp --dport 53 -j REDIRECT --to-port 53 #---------------- redirect DNS queries to self on UDP
iptables -t    nat -A POSTROUTING   -o eth0.2  -d 169.254.1.0/24 -j SNAT --to-source 169.254.1.1 #------ Source-NAT packets with specified destination to specified IP address
iptables -t    nat -A POSTROUTING   -o $IF_DSL -j MASQUERADE #------------ Source-NAT all Packet leaving on Interface $IF_DSL to the IP address of the router on that Interface
iptables -t mangle -A POSTROUTING   -o $IF_DSL -s $IP_USER2 -j TC_USER2 #------------------------------- jump to custom user chain TC_USER2
iptables -t mangle -A TC_USER4      -j CLASSIFY --set-class 1:101 -p udp -m length --length :400
iptables -t mangle -A TC_USER1      -j CLASSIFY --set-class 1:103 -m tos --tos Maximize-Throughput
iptables -t mangle -A POSTROUTING   -o $IF_DSL ! -s 192.168.0.0/16 -j TEE --gateway 192.168.1.254 #----- forward a copy to gateway-IP
iptables -t mangle -A PREROUTING    -i $IF_DSL -d 192.168.0.0/16 -j TEE --gateway 192.168.1.254 #------- forward a copy to gateway-IP
iptables -t mangle -A PREROUTING    -m connbytes --connbytes 504857: --connbytes-dir both --connbytes-mode bytes -j CLASSIFY --set-class 1:303 #---- count the Bytes of one connection
iptables -t raw    -A INPUT         ! -i $IF_DSL  -j CT --notrack #-------------- don't track anything NOT incoming on interface in variable $IF_DSL
iptables -t raw    -A INPUT         -i $IF_LAN -s $NET_LAN -p tcp --dport 32777:32780 -j CT --notrack #------ don't track NFS

chains：
INPUT OUTPUT FORWARD PREROUTING POSTROUTING user_defined_CHAIN_1

TARGET: 
ACCEPT DROP QUEUE RETURN BALANCE CLASSIFY CLUSTERIP CONNMARK CONNSECMARK CONNTRACK DNAT 
DSCP ECN IPMARK IPV4OPSSTRIP LOG MARK MASQUERADE MIRROR NETMAP NFQUEUE CT REDIRECT REJECT 
ROUTE SAME SECMARK SET SNAT TARPIT TCPMSS TOS TRACE TTL ULOG XOR

-j MARK --set-mark 102
-j TEE reroute a copy of a packet
-j TARPIT
-j DELUDE does TCP handshake and the closes connection

match:   
  -i incoming interface, -o outgoing interface
  -s source ip address, -d destination ip address
  -p protocol, -dport destination port -sport source port
  -m match: various matches are in different iptables-mod-* packages!
    -m mac -mac-source xx:xx:xx:xx:xx:xx source MAC, note that MAC is layer2
    -m mark -mark abc match a packet marked with abc
    -m length -length :412 match all packets with a length of less then 412 Bytes
    -m ttl -ttl-eq 12 -j LOG -log-prefix "IPT TTL=12 "
    -m ttl -ttl-gt 12 -j LOG -log-prefix "IPT TTL>12 "
    -m ttl -ttl-lt 12 -j LOG -log-prefix "IPT TTL<12 "
    -m condition match a flag changeable from userspace
    -m geoip match on countries
    
EOF
}

iptables_i_FAQ_REDIRECT_DNAT(){ cat - <<'EOF'
环境：WAN(eth0), LAN(eth1)
iptables -t nat -A PREROUTING -i eth1 -p tcp --dport 80 -j REDIRECT --to 3128
iptables -t nat -A PREROUTING -i eth1 -p tcp --dport 80 -j DNAT --to 172.16.11.1:3128
iptables -t nat -A PREROUTING -i eth0 -p tcp --dport 3389 -j DNAT --to 172.16.11.250
结论：REDIRECT 是DNAT 的一个特例
DNAT 的功能更强大

iptables -t nat -A PREROUTING -p tcp --dport 80 -j REDIRECT --to-ports 8080
在指定TCP或UDP协议的前提下，定义目的端口，方式如下：
1、不使用这个选项，目的端口不会被改变。
2、指定一个端口，如--to-ports 8080
3、指定端口范围，如--to-ports 8080-8090

在防火墙所在的机子内部转发包或流到另一个端口.
注意，它只能用在nat表的PREROUTING、OUTPUT链和被它们调用的自定义链里。
EOF
}

iptables_i_FAQ_MASQUERADE_SNAT(){ cat - <<'EOF'
iptables -t nat -s 172.16.11.0/24 -o eth0 -j MASQUERADE
iptables -t nat -s 172.16.11.0/24 -o eth0 -j SNAT --to 123.123.123.123
iptables -t nat -s 172.16.11.0/24 -o eth0 -j SNAT --to 123.123.123.1-123.123.123.10
结论：MASQUERADE 自动根据路由选择出口
SNAT 适用于固定
IP 的环境，负载小
SNAT 可实现地址面积映射

MASQUERADE是被专门设计用于那些动态获取IP地址的连接的。
如果你有固定的IP地址，还是用SNAT target

在指定TCP或UDP的前提下，设置外出包能使用的端口，方式 是单个端口，如--to-ports 1025，或者是端口范围，
如--to-ports 1024-3000。注意，在指定范围时要使用连字号。这改变了SNAT中缺省的端口选择，
iptables -t nat -A POSTROUTING -p TCP -j MASQUERADE --to-ports 1024-31000
EOF
}

iptables_i_FAQ_handler_j_g(){ cat - <<'EOF'
iptables -N TESTA
iptables -N TESTB
iptables -A FORWARD -s 172.16.11.1  -j
 
TESTA
iptables -A FORWARD -s 172.16.11.2  -g
 
TESTB
iptables -A TESTA -j MARK --set-mark 1
iptables -A TESTB -j MARK --set-mark 2
iptables -A FORWARD -m mark --mark 1 -j DROP
iptables -A FORWARD -m mark --mark 2 -j DROP
结论：-j(jump)相当于调用，自定义链结束后返回
-g(goto)一去不复返
EOF
}
iptables_i_FAQ_raw(){ cat - <<'EOF'
iptables -t raw -vnL
iptables -t raw -A PREROUTING -i eth1 -s 172.16.11.250 -j DROP

结论：raw 表工作于最前端，在
conntrack 之前
可以明确对某些数据不进行连接追踪
raw 可提前
DROP 数据，有效降低负载
EOF
}
iptables_i_FAQ_table(){ cat - <<'EOF'
何为专表专用、专链专用？
filter： 专门用于过滤数据
nat：    用于地址转换(只匹配初始连接数据)
mangle： 用于修改数据包内容
raw：    用于在连接追踪前预处理数据
         状态跟踪表(生成到消亡,new生成状态,已连接状态,断开连接)

PREROUTING：用于匹配最先接触到的数据(raw,mangle,nat)
INPUT：用于匹配到达本机的数据(mangle,filter)
FORWARD：用于匹配穿越本机的数据(mangle,filter)
OUTPUT：用于匹配从本机发出的数据(raw,mangle,nat,filter)
POSTROUTING：用于匹配最后离开的数据(mangle,nat)
EOF
}

iptables_i_FAQ_nf_conntrack_max(){ cat - <<'EOF'
一个公网IP 的最大连接数？
可以最大有 nf_conntrack_max 个连接
EOF
}

iptables_i_FAQ_LOG(){ cat - <<'EOF'
数据包记录流程：
  获取数据包
  分析包信息(根据各协议计算各部分数据偏移量)
  打印内核信息(根据不同协议打印不同信息)
  syslog 捕获内核信息
  根据syslog 配置决定如何输出(文件/远程)
iptables -A FORWARD -m state --state NEW -p tcp ! --syn -j LOG -log-prefix "BAD TCP "
iptables -A FORWARD -m state --state NEW -p tcp ! --syn -j DROP
结论：LOG 需占用一定负载，尽量不写硬盘
如须记录，尽量少记，否则雪上加霜
EOF
}

iptables_i_FAQ_limit(){ cat - <<'EOF'
错误：
iptables -A FORWARD -p icmp -s 172.16.11.0/24 -m limit --limit 10/s -j DROP
正确：
iptables -A FORWARD -p icmp -s 172.16.11.0/24 -m limit --limit 10/s -j ACCEPT
iptables -A FORWARD -p icmp -s 172.16.11.0/24 -j DROP
结论：limit 仅按一定速率匹配数据
若限制，先放过一定速率数据，然后阻断
EOF
}

iptables_i_FAQ_synflood(){ cat - <<'EOF'
iptables -N syn_flood
iptables -A INPUT -p tcp --syn -j syn_flood
iptables -A syn_flood -m limit --limit 1/s -j RETURN
iptables -A syn_flood -j DROP

结论：限速方案是一把双刃剑，治标不治本
启用syncookie,减小synack_retries
增大tcp_max_syn_backlog，其它

Client syn=1 ack=0 Server --->
Client syn=1 ack=1 Server <---
Client syn=0 ack=1 Server --->
发送了大量syn=1 ack=0的数据包。

netstat -tnlpa | grep tcp | awk '{print $6}' | sort | uniq -c
      1 ESTABLISHED
      7 LISTEN
    256 SYN_RECV  # 大量处于SYN_RECV且源地址都是乱七八糟的，说明受到了syn洪水攻击。
EOF
}
iptables_i_FAQ_squid(){ cat - <<'EOF'
iptables -t nat -A PREROUTING -i eth1 -s 172.16.11.250 -j ACCEPT
iptables -t nat -A PREROUTING -i eth1 -d 123.123.123.123 -j ACCEPT
iptables -t nat -A PREROUTING -i eth1 -s 172.16.11.0/24 -j REDIRECT --to 3128
结论：让无需转向的数据提前脱离"魔掌"
EOF
}
iptables_i_FAQ_ssh_limit(){ cat - <<'EOF'
如何防止被探测 SSH  密码？
iptables -A INPUT -p tcp --dport 22 -m state --state NEW -m recent
 --set \
--name SSH --rsource -m recent \
--name SSH \
--update --seconds 10 --hitcount 4 \
--rsource -j DROP
结论：模块可以在同一个规则内反复使用
优点：合并使用可降低负载
EOF
}
iptables_i_FAQ_ip_bind_mac(){ cat - <<'EOF'
iptables -N MAC_CHECK
iptables -A FORWARD -i eth1 -o eth0 -j MAC_CHECK
iptables -A MAC_CHECK -s 172.16.11.101 -m mac \
--mac-source XX:XX:XX:XX:XX:XX -j RETURN
iptables -A MAC_CHECK -s 172.16.11.102 -m mac \
--mac-source YY:YY:YY:YY:YY:YY -j RETURN
iptables -A MAC_CHECK -s 172.16.11.103 -m mac \
--mac-source ZZ:ZZ:ZZ:ZZ:ZZ:ZZ -j RETURN
iptables -A MAC_CHECK -j DROP
EOF
}
iptables_i_FAQ_tracert(){ cat - <<'EOF'
ping ?= tracert
ping = ICMP
tracert = TTL 试探
iptables -A INPUT -m ttl --ttl-eq 1 -j DROP
iptables -A INPUT -m ttl --ttl-lt 4 -j DROP
iptables -A FORWARD -m ttl --ttl-lt 6 -j DROP
如何一跳直达？
EOF
}
iptables_i_FAQ_balance(){ cat - <<'EOF'
iptables -t nat -A PREROUTING -i eth0 -p tcp --dport 80 \
-m statistic --mode nth --every 3
 
-j DNAT --to 172.16.11.101
iptables -t nat -A PREROUTING -i eth0 -p tcp --dport 80 \
-m statistic --mode nth --every 2
 
-j DNAT --to 172.16.11.102
iptables -t nat -A PREROUTING -i eth0 -p tcp --dport 80 \
-j DNAT --to 172.16.11.103
statistic 的其它用途？
iptables -A FORWARD -i eth1 -o eth0 -s 172.16.11.250 -m \
statistic --mode random --probability 0.1 -j DROP
EOF
}
iptables_i_FAQ_DNS(){ cat - <<'EOF'
string 模块无法匹配？
DNS 数据包结构？
string 和
 
layer7 的实现：
iptables -A FORWARD -m string --algo bm --hex-string "|03|www|09|chinaunix|03|com" -j DROP
dns_CU
\x03www\x09chinaunix\x03net
iptables -A FORWARD -m layer7 --l7proto dns_CU -j DROP
EOF
}
iptables_i_FAQ_limit_download(){ cat - <<'EOF'
connlimit：限制每个用户的连接数
connbytes：限制长连接数据速率
quota：    设置每个用户流量配额
statistic：设置用户随机丢包量
EOF
}
iptables_i_FAQ_conntrack(){ cat - <<'EOF'
modprobe nf_conntrack hashsize=200000
modprobe nf_conntrack_ipv4
sysctl -w net.netfilter.nf_conn \
track_max=500000
注意：需要大内存，用空间换时间
EOF
}

iptables_i_FAQ_layer(){ cat - <<'EOF'
从链路层来判断是否处理
从网络层来判断是否处理
从传输层来判断是否处理
从应用层来判断是否处理
特殊的防火墙判断
    根据数据包内容判断
    根据关联状态判断
防火墙起作用的是Netfilter，而iptables只是管理控制netfilter的工具，可以使用该工具进行相关规则的制定以及其他的动作。
存放netfilter模块的目录有三个：
/lib/modules/$kernel_ver/net/{netfilter,ipv4/netfilter,ipv6/netfilter}。
$kernel_ver代表内核版本号。

INPUT链的作用是为了保护本机。
OUTPUT链的作用是为了管制本机。
FORWARD链的作用是保护"后端"的机器。
EOF
}