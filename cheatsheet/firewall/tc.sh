1.什么是流量控制? -> 队列、优先级、策略
    流量控制就是在路由器上通过一系列队列，为不同类型的网络数据包标记不同的优先级，从而对数据包进行排序
    以控制它们的发送顺序，并通过一系列策略控制收到的和发送的数据包是否应该被丢弃，同时还要对数据包的
    发送速率进行控制。

2.TC是干什么的呢: -> 通道 优先级 速率
    TC就是建立数据通道的, 建立的通道有数据包管理方式, 通道的优先级, 通道的速率(这就是限速)

3.iptables又是干什么的呢? -> 选择通道 (MARK -> 类别)
    是决定哪个ip 或者 mac 或者某个应用, 走哪个通道的.
    这就是QOS+限速的原理, 大伙明白了吧?

流量的处理由三种对象控制，它们是：qdisc(排队规则)、class(类别)和filter(过滤器)。
    流量控制的基本步骤：
        为网卡配置一个队列;
        在该队列上建立分类;
        根据需要建立子队列和子分类;
        为每个分类建立过滤器。

在哪进行流量控制
    在Linux操作系统中流量控制器(TC)主要是在输出端口处建立一个队列进行流量控制.
    例如：eth1是内网接口、eth0是外网接口，你要限制内网下载带宽应该在eth1接口，限制内网上传带宽应该在eth0接口。

流量控制的流程
    1.报文流入网卡
    2.使用iptables在mange表，根据IP、Port等打上不同MARK标记。
    3.然后过滤器(Filter)根据数据包的MARK值来把报文分组分成不同的类别(Class)。
    4.然后将不同类别报文分组添加到该流出网卡所配置的队列(qdisc)中， 由该队列决定报文分组的发送顺序。
    
基本格式
    tc qdisc [ add | change | replace | link | delete ] dev DEV [ parent qdisc-id | root ] [ handle qdisc-id ] qdisc [ qdisc specific parameters ] 
    tc class [ add | change | replace | delete ] dev DEV parent qdisc-id [ classid class-id ] qdisc [ qdisc specific parameters ] 
    tc filter [ add | change | replace | delete ] dev DEV [ parent qdisc-id | root ] protocol protocol prio priority filtertype [ filtertype specific parameters ] flowid flow-id 
    tc [ FORMAT ] qdisc show [ dev DEV ] 
    tc [ FORMAT ] class show dev DEV 
    tc filter show dev DEV 
    tc [ -force ] [ -OK ] -b[atch] [ filename ] 
        FORMAT := { -s[tatistics] | -d[etails] | -r[aw] | -p[retty] | -i[ec] }

队列：Qdisc 队列是"排队规则"的简称，这是基本的流量控制。每当内核需要一个数据包发送到一个接口，它被排入到配置该接口的队列规定。
    add qdisc add 添加一个队列规则。这里的动词也可以是 del
    dev eth1 指定一个设备，队列规则将会与这个设备相关联
    root 指定根队列的流量控制结构
    handle 10: 指定队列的句柄为，格式是 <主编号:子编号>。队列规则的子编号必须是零（0）。主编号可以简写为 “ 10:”的形式，这时子编号默认设为0
    htb 这是要关联的排队规则，在这里，排队规则的类型是 HTB 分层的令牌桶队列
    default 20 是htb特有的队列参数，意思是所有未分类的流量都将分配给类别10:20
    sfq 要关联的队列规则为FSQ随机公平队列
    perturb 表示多少秒后重新配置一次散列算法。默认为10

类别：Class 一些qdiscs可含有类，其中包含另外的qdiscs - 流量然后可以在任何的内qdiscs，它们是类中的被排队。当内核试图出列从这样一个有类队列规定一个数据包，可以来自任何类。 一个队列规定可以例如通过尝试从某些类在别人面前出列优先某些类型的流量。
    tc class add 添加一个分类，这里的动词也可以是del
    parent 10: 指定父类的 handle，我们添加的分类将会成为这个父类的子类
    classid 10:1 这是一个唯一的 handle，格式是 <主编号:子编号>。子编号必须是非零值
    htb 所有的classful qdiscs都要求其子类拥有和qdisc相同的类型。也就是说，这里的HTB队列规则包含的子类必须是 HTB 的
    rate 200kbps 表示系统将为该类别确保带宽200kbps
    ceil 300kbps 表示该类别的最高可占用带宽为300kbps
    prio 1 指定过滤器的优先级，对于不同优先级的过滤器， 系统将按照从小到大的优先级,数值越大,优先权越小

过滤器：Filter 过滤器所使用的有类队列规定来确定哪一类报文将被排队。每当流量到达一个类的子类，就需要进行分类。
    tc filter add 增加一个过滤器。这里的动词也可以是del
    parent 1:0 指定一个对象的编号，过滤器将会与这个对象相关联
    protocol ip 表示该过滤器应该检查IP的协议字段
    handle 2 fw 置计数器，iptables用mangle链来mark数据包,告诉了内核，数据包会有一个特定的FWMARK标记值(hanlde x fw)

**流量单位：**一个字节等于8比特.
Bits per second
kbit Kilobits per second
mbit Megabits per second
gbit Gigabits per second
tbit Terabits per second
bps Bytes per second
kbps Kilobytes per second
mbps Megabytes per second
gbps Gigabytes per second
tbps Terabytes per second


基本使用
    #**测试环境**  
        #eth0	10.1.2.139	WAN	Up  
        #eth1	10.1.1.223	LAN	Down
    
    ### TC限速例1
        将来自内网的10.1.1.0/25用TC限制下载速度为300KB/s，上传速度为400KB/s。  
        将来自内网的10.1.1.128/25用TC限制下载速度为400KB/s，上传速度为300KB/s。

##下载限制
#1.清除原有配置
tc qdisc del dev eth1 root

#2.为网卡eth1添加创建一个HTB根队列
tc qdisc add dev eth1 root handle 10: htb

#3.在该队列上建立分类
tc class add dev eth1 parent 10:0 classid 10:10 htb rate 300kbps ceil 300kbps prio 1
tc class add dev eth1 parent 10:0 classid 10:20 htb rate 400kbps ceil 400kbps prio 1

#4.为每个分类建立过滤器
tc filter add dev eth1 parent 10:0 protocol ip prio 10 handle 1 fw classid 10:10
tc filter add dev eth1 parent 10:0 protocol ip prio 10 handle 2 fw classid 10:20

#5.为每个分类建立随机公平队列
tc qdisc add dev eth1 parent 10:10 handle 101: sfq perturb 10
tc qdisc add dev eth1 parent 10:20 handle 102: sfq perturb 10

#6.通过iptables标记目标地址
iptables -t mangle -F POSTROUTING
iptables -t mangle -A POSTROUTING -d 10.1.1.0/25 -j MARK --set-mark 1
iptables -t mangle -A POSTROUTING -d 10.1.1.0/25 -j RETURN
iptables -t mangle -A POSTROUTING -d 10.1.1.128/25 -j MARK --set-mark 2
iptables -t mangle -A POSTROUTING -d 10.1.1.128/25 -j RETURN

##上传限制
#1.清除原有配置
tc qdisc del dev eth0 root

#2.为网卡eth0添加创建一个HTB根队列
tc qdisc add dev eth0 root handle 20: htb

#3.在该队列上建立分类
tc class add dev eth0 parent 20:0 classid 20:10 htb rate 300kbps ceil 300kbps prio 1
tc class add dev eth0 parent 20:0 classid 20:20 htb rate 400kbps ceil 400kbps prio 1

#4.为每个分类建立过滤器
tc filter add dev eth0 parent 20:0 protocol ip prio 10 handle 3 fw classid 20:10
tc filter add dev eth0 parent 20:0 protocol ip prio 10 handle 4 fw classid 20:20

#5.为每个分类建立随机公平队列
tc qdisc add dev eth0 parent 20:10 handle 103: sfq perturb 10
tc qdisc add dev eth0 parent 20:20 handle 104: sfq perturb 10

#6.通过iptables标记目标地址
iptables -t mangle -F PREROUTING
iptables -t mangle -A PREROUTING -s 10.1.1.0/25 -j MARK --set-mark 4
iptables -t mangle -A PREROUTING -s 10.1.1.0/25 -j RETURN
iptables -t mangle -A PREROUTING -s 10.1.1.128/25 -j MARK --set-mark 3
iptables -t mangle -A PREROUTING -s 10.1.1.128/25 -j RETURN

高级使用

#**测试环境**  
    #网卡-----网络类型----动作-----iptables表\链-------------------iptables匹配条件
    #eth0	WAN	Up	mangle\POSTROUTING/FORWARD	源地址/目标端口
    #eth1	LAN	Down	mangle\PREROUTING/FORWARD	目标地址/源端口
    
    ### TC限速例2-合理的分配下行带宽
    #**规划**
    
    #分类1.1 优先级1 400KB MARK1
    #分类1.2 优先级2 900KB
    #    分类1.21 优先级3 500KB MARK2
    #    分类1.22 优先级4 400KB MARK3 （默认和没有标记的）

#1.清除原有配置
tc qdisc del dev eth1 root

#2.为网卡eth1添加创建一个HTB根队列
tc qdisc add dev eth1 root handle 1: htb default 22

#3.在该队列上建立分类
tc class add dev eth1 parent 1: classid 1:1 htb rate 400kbps ceil 400kbps prio 1
tc class add dev eth1 parent 1: classid 1:2 htb rate 900kbps ceil 900kbps prio 2

#4.根据需要建立子队列和子分类
tc class add dev eth1 parent 1:2 classid 1:21 htb rate 500kbps ceil 900kbps
tc class add dev eth1 parent 1:2 classid 1:22 htb rate 400kbps ceil 900kbps

#5.为每个分类建立随机公平队列
tc qdisc add dev eth1 parent 1:1 handle 111: sfq perturb 10
tc qdisc add dev eth1 parent 1:21 handle 112: sfq perturb 10
tc qdisc add dev eth1 parent 1:22 handle 113: sfq perturb 10

#6.为每个分类建立过滤器
tc filter add dev eth1 parent 1:0 protocol ip prio 3 handle 1 fw classid 1:1
tc filter add dev eth1 parent 1:0 protocol ip prio 6 handle 2 fw classid 1:21
tc filter add dev eth1 parent 1:0 protocol ip prio 9 handle 3 fw classid 1:22


### TC限速例2-合理的分配上行带宽
    #**规划**
    
    #分类2.1 优先级1 400KB MARK4
    #分类2.2 优先级2 900KB
    #    分类2.21 优先级3 500KB MARK5
    #    分类2.22 优先级4 400KB MARK6 （默认和没有标记的）

#1.清除原有配置
tc qdisc del dev eth0 root

#2.为网卡eth0添加创建一个HTB根队列
tc qdisc add dev eth0 root handle 2: htb default 22

#3.在该队列上建立分类
tc class add dev eth0 parent 2: classid 2:1 htb rate 400kbps ceil 400kbps prio 1
tc class add dev eth0 parent 2: classid 2:2 htb rate 900kbps ceil 900kbps prio 2

#4.根据需要建立子队列和子分类
tc class add dev eth0 parent 2:2 classid 2:21 htb rate 500kbps ceil 900kbps
tc class add dev eth0 parent 2:2 classid 2:22 htb rate 400kbps ceil 900kbps

#5.为每个分类建立随机公平队列
tc qdisc add dev eth0 parent 2:1 handle 121: sfq perturb 10
tc qdisc add dev eth0 parent 2:21 handle 122: sfq perturb 10
tc qdisc add dev eth0 parent 2:22 handle 123: sfq perturb 10

#6.为每个分类建立过滤器
tc filter add dev eth0 parent 2:0 protocol ip prio 3 handle 4 fw classid 2:1
tc filter add dev eth0 parent 2:0 protocol ip prio 6 handle 5 fw classid 2:21
tc filter add dev eth0 parent 2:0 protocol ip prio 9 handle 6 fw classid 2:22


### 通过iptables标记源、目的端口（上行、下行流量类型）
iptables -t mangle -F

    #提高tcp初始连接(也就是带有SYN的数据包)的优先权是非常明智的：
        iptables -t mangle -A PREROUTING -p tcp -m tcp --tcp-flags SYN,RST,ACK SYN -j MARK --set-mark 4
        iptables -t mangle -A PREROUTING -p tcp -m tcp --tcp-flags SYN,RST,ACK SYN -j RETURN
        iptables -t mangle -A POSTROUTING -p tcp -m tcp --tcp-flags SYN,RST,ACK SYN -j MARK --set-mark 1
        iptables -t mangle -A POSTROUTING -p tcp -m tcp --tcp-flags SYN,RST,ACK SYN -j RETURN

    #icmp,想ping有良好的反应,放在第一类吧.
        iptables -t mangle -A PREROUTING -p icmp -j MARK --set-mark 4
        iptables -t mangle -A PREROUTING -p icmp -j RETURN
        iptables -t mangle -A POSTROUTING -p icmp -j MARK --set-mark 1
        iptables -t mangle -A POSTROUTING -p icmp -j RETURN

    #长度小于64的小包通常是需要快些的,一般是用来确认tcp的连接的.
        iptables -t mangle -A PREROUTING -p tcp -m length --length :64 -j MARK --set-mark 4
        iptables -t mangle -A PREROUTING -p tcp -m length --length :64 -j RETURN
        iptables -t mangle -A POSTROUTING -p tcp -m length --length :64 -j MARK --set-mark 1
        iptables -t mangle -A POSTROUTING -p tcp -m length --length :64 -j RETURN

    # DNS解析：放在第1类.
        iptables -t mangle -A PREROUTING -p udp -m udp --dport domain -j MARK --set-mark 4
        iptables -t mangle -A PREROUTING -p udp -m udp --dport domain -j RETURN
        iptables -t mangle -A POSTROUTING -p tcp -m udp --sport domain -j MARK --set-mark 1
        iptables -t mangle -A POSTROUTING -p tcp -m udp --sport domain -j RETURN

    # ssh：放在第1类,要知道ssh是交互式的和重要的,不容待慢哦
        iptables -t mangle -A PREROUTING -p tcp -m tcp --dport ssh -j MARK --set-mark 4
        iptables -t mangle -A PREROUTING -p tcp -m tcp --dport ssh -j RETURN
        iptables -t mangle -A POSTROUTING -p tcp -m tcp --sport ssh -j MARK --set-mark 1
        iptables -t mangle -A POSTROUTING -p tcp -m tcp --sport ssh -j RETURN

    # ms-wbt-server：放在第1类,要知道远程桌面是交互式的和重要的,不容待慢哦
        iptables -t mangle -A PREROUTING -p tcp -m tcp --dport ms-wbt-server -j MARK --set-mark 4
        iptables -t mangle -A PREROUTING -p tcp -m tcp --dport ms-wbt-server -j RETURN
        iptables -t mangle -A POSTROUTING -p tcp -m tcp --sport ms-wbt-server -j MARK --set-mark 1
        iptables -t mangle -A POSTROUTING -p tcp -m tcp --sport ms-wbt-server -j RETURN

    # http：放在第2类,是最常用的,最多人用的,
        iptables -t mangle -A PREROUTING -p tcp -m tcp --dport http -j MARK --set-mark 5
        iptables -t mangle -A PREROUTING -p tcp -m tcp --dport http -j RETURN
        iptables -t mangle -A POSTROUTING -p tcp -m tcp --sport http -j MARK --set-mark 2
        iptables -t mangle -A POSTROUTING -p tcp -m tcp --sport http -j RETURN

    # https：放在第2类
        iptables -t mangle -A PREROUTING -p tcp -m tcp --dport https -j MARK --set-mark 5
        iptables -t mangle -A PREROUTING -p tcp -m tcp --dport https -j RETURN
        iptables -t mangle -A POSTROUTING -p tcp -m tcp --sport https -j MARK --set-mark 2
        iptables -t mangle -A POSTROUTING -p tcp -m tcp --sport https -j RETURN

    # smtp邮件：放在第2类,因为有时有人发送很大的邮件,为避免它堵塞,让它跑2道吧
        iptables -t mangle -A PREROUTING -p tcp -m tcp --dport smtp -j MARK --set-mark 5
        iptables -t mangle -A PREROUTING -p tcp -m tcp --dport smtp -j RETURN
        iptables -t mangle -A PREROUTING -p tcp -m tcp --dport urd -j MARK --set-mark 5
        iptables -t mangle -A PREROUTING -p tcp -m tcp --dport urd -j RETURN

    # pop邮件：放在第2类
        iptables -t mangle -A POSTROUTING -p tcp -m tcp --sport pop3 -j MARK --set-mark 2
        iptables -t mangle -A POSTROUTING -p tcp -m tcp --sport pop3 -j RETURN
        iptables -t mangle -A POSTROUTING -p tcp -m tcp --sport pop3s -j MARK --set-mark 2
        iptables -t mangle -A POSTROUTING -p tcp -m tcp --sport pop3s -j RETURN

    # imap邮件：放在第2类
        iptables -t mangle -A POSTROUTING -p tcp -m tcp --dport imap -j MARK --set-mark 2
        iptables -t mangle -A POSTROUTING -p tcp -m tcp --dport imap -j RETURN
        iptables -t mangle -A POSTROUTING -p tcp -m tcp --sport imaps -j MARK --set-mark 2
        iptables -t mangle -A POSTROUTING -p tcp -m tcp --sport imaps -j RETURN

    #没有匹配到的走第3类
        iptables -t mangle -A POSTROUTING -d 10.1.1.0/24 -j MARK --set-mark 3
        iptables -t mangle -A POSTROUTING -d 10.1.1.0/24 -j RETURN
        iptables -t mangle -A PREROUTING -s 10.1.1.0/24 -j MARK --set-mark 6
        iptables -t mangle -A PREROUTING -s 10.1.1.0/24 -j RETURN
    #注意：重启网卡后配置会失效

查看队列的状况
    tc qdisc ls dev eth1
    tc -s qdisc ls dev eth1

查看分类的状况
    tc class ls dev eth1
    tc -s class ls dev eth1

查看过滤器的状况
    tc -s filter ls dev eth1