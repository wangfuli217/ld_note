nf_conntrack模块在kernel 2.6.15 被引入，支持ipv4和ipv6，取代只支持ipv4的ip_connktrack
用于跟踪连接的状态，供其他模块使用
最常见的使用场景是 iptables 的 nat 和 state 模块
    nat 根据转发规则修改源/目标地址，靠nf_conntrack的连接记录才能让返回的包能路由到发请求的机器
    state 直接用 nf_conntrack 记录的连接状态（NEW/ESTABLISHED/RELATED/INVALID）来匹配过滤规则
    
nf_conntrack用1个哈希表记录已建立的连接，包括其他机器到本机、本机到其他机器、本机到本机（例如 ping 127.0.0.1 也会被跟踪）
如果连接进来比释放的快，把哈希表塞满了，新连接的数据包会被丢掉，此时netfilter变成了一个黑洞，导致拒绝服务
这发生在3层（网络层），应用程序毫无办法
    
# 列出所有 nf_conntrack 相关的内核参数 
sysctl -a | grep conntrack 
# 只看超时相关参数 
sysctl -a | grep conntrack | grep timeout 
# /proc/sys/net/netfilter/ 下能看到一堆跟nf_conntrack参数同名的文件，值也一样

# nf_conntrack_buckets 使用情况 
grep conntrack /proc/slabinfo | column -t # 前4个数字分别为： 
# 当前活动对象数、可用对象总数、每个对象的大小（字节）、包含至少1个活动对象的分页数

# 查看跟踪的每个连接的详情 
cat /proc/net/nf_conntrack 
# 统计里面的TCP连接的各状态和条数
cat /proc/net/nf_conntrack | awk '/^.*tcp.*$/ {sum[$6]++} END {for(status in sum) print status, sum[status]}' # 记录数最多的10个ip 
cat /proc/net/nf_conntrack | awk '{print $7}' | cut -d "=" -f 2 | sort | uniq -c | sort -nr | head -n 10 
# 记录格式： # 网络层协议名、网络层协议编号、传输层协议名、传输层协议编号、记录失效前剩余秒数、连接状态（不是所有协议都有） 
# 之后都是key=value或flag格式，1行里最多2个同名key（如 src 和 dst），第1次出现的来自请求，第2次出现的来自响应 
# flag： 
# [ASSURED]  请求和响应都有流量 
# [UNREPLIED]  没收到响应，哈希表满的时候这些连接先扔掉



# 哈希表大小，默认 16384
net.netfilter.nf_conntrack_buckets
# 这参数在模块加载时设置，直接修改没用，要这样：
echo <新值> > /sys/module/nf_conntrack/parameters/hashsize
# netfilter使用不可交换的内核空间内存，哈希表不是随便改多大都行

# 连接跟踪表大小，默认 nf_conntrack_buckets * 4 （65536）
net.netfilter.nf_conntrack_max
net.nf_conntrack_max
# 默认值实在太小，稍微忙点的服务器里起码跟踪100～200k个连接
# 如果改了这个，按比例改 nf_conntrack_buckets

# 哈希表里的每个元素（bucket）都是链表，每条conntrack记录是链表上的1个节点  
# 当conntrack数达到 conntrack_max 时，每个链表有 conntrack_max / conntrack_buckets 条记录（默认为4）

# 哈希表里的实时连接跟踪数（只读）
# 值来自 /proc/net/nf_conntrack 的条数
net.netfilter.nf_conntrack_count
# 有说法是这数字持续超过 nf_conntrack_max 的20%就该考虑调高上限了

# TCP每个状态都有超时设置项，可按需设置
# 这里的超时是指超过指定时间不再跟踪连接

# 默认 120 秒
net.netfilter.nf_conntrack_tcp_timeout_time_wait
# 我们的nf_conntrack文件里 30k+记录几乎全是 time_wait ，只有几百条 established ，其他忽略不计
# 等着释放的连接通常没必要继续跟踪这么久，可以调小点

# 默认 432000 秒（5天）
netfilter.ip_conntrack_tcp_timeout_established
# 应用程序有正确设置超时的话，这参数其实影响不大
# 服务端主动把连接关了就不再是 established 状态了

# 通用超时设置，作用于4层（传输层）未知或不支持的协议
# 默认 600 秒（10分钟）
net.netfilter.nf_conntrack_generic_timeout
# 在我们的场景里，缩到 60 秒也没看出效果


handle(A. 关闭防火墙){
对不直接暴露在公网、没有用到NAT转发的服务器来说，关闭Linux防火墙是最简单也是最佳的办法
# CentOS 7.x
service firewalld stop
# CentOS 6.x
service iptables stop
# 网上有些文章说关了iptables之后，用 iptables -L -n 之类查看规则也会导致nf_conntrack重新加载，实测并不会
防火墙一关，sysctl -a里就没有netfilter相关的参数了
}

handle(B. 设置不跟踪连接的规则){
对需要防火墙／NAT的机器，可以在iptables设置NOTRACK规则，减少要跟踪的连接数

# 查看所有规则
iptables-save

# 这个必须插在第1条，凡是不跟踪的肯定是你想放行的
iptables -I INPUT 1 -m state --state UNTRACKED -j ACCEPT
# 设置成不跟踪的连接无法拿到状态，包含状态（-m state --state）的规则统统失效
# iptables处理规则的顺序是从上到下，如果这条加的位置不对，可能导致请求无法通过防火墙

# 不跟踪 127.0.0.1【推荐】
iptables -t raw -A PREROUTING -i lo -j NOTRACK
iptables -t raw -A OUTPUT -o lo -j NOTRACK

# 假如nginx和应用部署在同一台机子上，增加这规则的收益极为明显
# nginx连各种upstream使得连接数起码翻了倍，不跟踪本地连接一下干掉一大半

# 其他条件不变，修改前后 nf_conntrack_count：30k+ -> 2.9k+ ，下降 90%！

说明：

-t raw 会加载 iptable_raw 模块（kernel 2.6+ 都有）

raw表基本就干一件事，通过-j NOTRACK给不需要被连接跟踪的包打标记（UNTRACKED状态），告诉nf_conntrack不要跟踪连接

raw 的优先级大于 filter，mangle，nat，包含 PREROUTING（针对进入本机的包） 和 OUTPUT（针对从本机出去的包） 链

如果还要更进一步：

# 不跟踪特定访问量大的端口
iptables -t raw -A PREROUTING -p tcp -m multiport --dports 80:82,443 -j NOTRACK
iptables -t raw -A OUTPUT -p tcp -m multiport --sports 80:82,443 -j NOTRACK

# 其他条件不变，修改前后 nf_conntrack_count：30k+ -> 28k+ ，下降 7%
# lo跟这个结合，基本就是业务相关的连接全部不跟踪：30k+ -> 90+ ，下降 100%
缺点：不好维护，服务器对外端口较多或有变化时，容易改出问题

}

handle(C. 修改netfilter相关参数){
调大nf_conntrack_max和nf_conntrack_buckets，调小超时时间，能暂时缓解问题

（关于 nf_conntrack_max 和 nf_conntrack_buckets 的值，网上所有出现公式的文章无一例外都指向08年的 Conntrack_tuning 这篇wiki

权威性相当可疑，但网上没有更详细的解释了，照样摘录

文章里有些东西明显过时了，即使确实出自当时的netfilter团队，剩下没法验证的部分也有很大几率同样过时，不能盲目照搬）

# 按文章说法，默认值是这么来的：（现在并不是……）

CONNTRACK_MAX = RAMSIZE (in bytes) / 16384 / (ARCH / 32)
# 文章说1g以上内存都固定为 65536
# 按这算法，8g内存64位的低配机器可以有： 8204222464 / 16384 / (64 / 32) = 250373

HASHSIZE = CONNTRACK_MAX / 8  # 现在是 / 4
    = RAMSIZE (in bytes) / 131072 / (ARCH / 32)
# 文章说1g以上内存都固定为 8192（现在实际上是 16384）
# 按这算法，8g内存64位的低配机器可以有： 8204222464 / 131072 / (64 / 32) = 31296

# 关于内存占用，文章给的公式是：
size_of_mem_used_by_conntrack (in bytes) = CONNTRACK_MAX * sizeof(struct ip_conntrack) + HASHSIZE * sizeof(struct list_head)
# 文章给的kernel 2.6.5，32位机器的例子是：CONNTRACK_MAX * 300 + HASHSIZE * 8 (bytes)

# 文章真正有价值的是最后的例子，才512m内存（还嫌内存贵！）的机器
# 都敢把 nf_conntrack_max 和 nf_conntrack_buckets 设成 1048576（加起来占用内存 308m）

# 可以看出65536、16384的默认值对今天的机器来说低得离谱
# 按上面公式（不管还对不对）算出的结果也比较保守

# 我直接在默认值后加个0，测试没什么问题

超时设置跟具体业务有关，基本思路是先看nf_conntrack文件，哪种协议哪种状态的连接最多，改小对应的超时参数 ，在不影响业务的前提下让nf_conntrack_count降得快一点

# 我们是TCP的 TIME_WAIT 最多，占了 99%
# 因此修改 net.netfilter.nf_conntrack_tcp_timeout_time_wait 收益最大

# 其他条件不变，改成 30 秒，修改前后 nf_conntrack_count：30k+ -> 14k+ ，下降 50%
# 不跟踪lo跟这个结合：2.9k+ -> 2k+ ，下降 50%

内核参数修改方法：

# 先记下默认值，临时修改看看效果
# 最好一次只改一处，效果不明显或更差就还原
sysctl -w <参数>=<值>

# 观察几天没问题就持久化
echo "<参数>=<值>" >> /etc/sysctl.conf
sysctl -p

缺点：增加哈希表大小和记录请求数会加大内存消耗。对于确实不需要做状态跟踪的场景，记录请求完全是浪费

在不适合关防火墙的场合，修改参数（max、bucket、timeout） + 设置NOTRACK不跟踪lo是比较简单有效的方式
}


cat >>/etc/sysctl.conf<<EOF
net.ipv4.tcp_fin_timeout = 2
net.ipv4.tcp_tw_reuse = 1
net.ipv4.tcp_tw_recycle = 1
net.ipv4.tcp_syncookies = 1
net.ipv4.tcp_keepalive_time = 600
net.ipv4.ip_local_port_range = 4000 65000
net.ipv4.tcp_max_syn_backlog = 16384
net.ipv4.tcp_max_tw_buckets = 36000
net.ipv4.route.gc_timeout = 100
net.ipv4.tcp_syn_retries = 1
net.ipv4.tcp_synack_retries = 1
net.core.somaxconn = 16384
net.core.netdev_max_backlog = 16384
net.ipv4.tcp_max_orphans = 16384
net.netfilter.nf_conntrack_max = 25000000
net.netfilter.nf_conntrack_tcp_timeout_established = 180
net.netfilter.nf_conntrack_tcp_timeout_time_wait = 120
net.netfilter.nf_conntrack_tcp_timeout_close_wait = 60
net.netfilter.nf_conntrack_tcp_timeout_fin_wait = 120
EOF
fi
\cp /etc/rc.local /etc/rc.local.$(date +%F)
modprobe nf_conntrack
echo "modprobe nf_conntrack">> /etc/rc.local
modprobe bridge
echo "modprobe bridge">> /etc/rc.local
sysctl -p
action "内核调优完成" /bin/true
echo "================================================="
echo ""
sleep 2
}


net.ipv4.tcp_syn_retries = 1
net.ipv4.tcp_synack_retries = 1
net.ipv4.tcp_keepalive_time = 600
net.ipv4.tcp_keepalive_probes = 3
net.ipv4.tcp_keepalive_intvl =15
net.ipv4.tcp_retries2 = 5
net.ipv4.tcp_fin_timeout = 2
net.ipv4.tcp_max_tw_buckets = 36000
net.ipv4.tcp_tw_recycle = 1
net.ipv4.tcp_tw_reuse = 1
net.ipv4.tcp_max_orphans = 32768
net.ipv4.tcp_syncookies = 1
net.ipv4.tcp_max_syn_backlog = 16384
net.ipv4.tcp_wmem = 8192 131072 16777216
net.ipv4.tcp_rmem = 32768 131072 16777216
net.ipv4.tcp_mem = 786432 1048576 1572864
net.ipv4.ip_local_port_range = 1024 65000
net.ipv4.ip_conntrack_max = 65536
net.ipv4.netfilter.ip_conntrack_max=65536
net.ipv4.netfilter.ip_conntrack_tcp_timeout_established=180
net.core.somaxconn = 16384
net.core.netdev_max_backlog = 16384

