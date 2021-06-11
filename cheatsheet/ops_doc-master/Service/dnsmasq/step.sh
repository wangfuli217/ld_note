txt(){
dig @192.168.111.1 txt chaos servers.bind
                             version.bind
                             authors.bind
                             copyright.bind
                             cachesize.bind
                             insertions.bind
                             evictions.bind
                             misses.bind
                             hits.bind
                             auth.bind
}

dnsmasq(SIGHUP){
1. 删除缓存信息
2. 重新加载以下文件内容
 /etc/hosts and /etc/ethers 
--dhcp-hostsfile,  --dhcp-optsfile or --addn-hosts
DHCP lease对应的script脚本会被执行。

如果指定--no-poll选项也重新加载/etc/resolv.conf
注意：dnsmasq不重新加载dnsmasq.conf配置文件
}
dnsmasq(SIGUSR1){
将统计信息通过日志输出。
cachesize， 多少个域名在未老化前，由于达到cachesize而需要删除掉。
对特定服务器发送了多少个请求报文，对特定服务器返回多少个错误报文
输出当前缓冲dns记录信息
}
dnsmasq(SIGUSR2){ 将日志写入文件，先close在reopen，用于循环日志记录
}
dnsmasq(resolv){
dnsmasq通过/etc/resolv.conf获得域名服务器IP，在未设定--no-poll的时候，dnsmasq检测/etc/resolv.conf的变化。
即使设定文件当前不存在也没关系。

也可以指定/etc/ppp/resolv.conf 和 /etc/dhcpc/resolv.conf；

上行服务器可以通过命令行和配置文件来设置。
上行服务器也可以和特定域名绑定，使得查询指定域名使用指定的上行服务器

本地使用dnsmasq缓存，可以设定/etc/resolv.conf为"127.0.0.1"，可以设定dns服务器地址使用--server或者配置文件
-r /etc/resolv.dnsmasq # 该文件可以有dhcp或者ppp自动生成
}

dnsmasq(tag){
dhcp-range: 地址池
dhcp-host : dhcp-host=11:22:33:44:55:66,192.168.0.60 静态地址配置
bootp     : bootp协议

dhcp-option : --dhcp=option=tag:!purple,3,1.2.3.4

 dhcp-range=set:interface1,......   
 dhcp-host=set:myhost,.....   
 dhcp-option=tag:interface1,option:nis-domain,"domain1"
 dhcp-option=tag:myhost,option:nis-domain,"domain2" 
 
 dhcp-range both tag:<tag> and set:<tag>都是允许的。
 
 
}
dnsmasq(pxe){
PXE(Preboot eXecution Environment)预启动执行环境提供了一种使用网络接口启动计算机的引导方式。
这种机制让计算机的启动可以不依赖本地数据存储设备或本地已安装的操作系统。PXE server服务通过
dhcp和tftp两个服务提供—DHCP Server来取得IP位址，通过TFTP来获得kernel image等文件。而PXE client
通过PXE protocol和NBP来完成通过网络的引导。
a).PXE Client 向 UDP 67端口 广播 DHCPDDISCOVER 消息.
b).DHCP SERVER 或者 DHCP Proxy 收到广播消息后,发送DHCPOFFER(包含ip地址)消息 到 PXE Client的 68 端口.
c).PXE Client 发送 DHCPREQUEST 消息到 DHCP SERVER ,获取启动文件(boot file name).
d).DHCP SERVER 发送DHCPACK(包含Network Bootstrap Program file name)消息 到PXE Client.
e).PXE Client 向 Boot Server 获取 NBP(Network Bootstrap Program) 文件.
f).PXE Client 从TFTP SERVER 下载 NBP,然后在客户端执行NBP文件
注意: 在NBP执行初始化后，NBP会按照自己默认的方式从TFTP SERVER中下载其他所需的配置文件.
}
dnsmasq(dns forwarder){ TCP and UDP port 53 

}

dnsmasq(DHCP server){  UDP ports 67 and 68
1. static 
2. dynamic 
3. BOOTP 
}

dnsmasq(/etc/config/dhcp){
和/etc/dnsmasq.conf文件一起生效

1. 相关文件/etc/ethers # readethers | SIGHUP
静态租期配置项
lan_dhcp_num=0

2. 相关文件/etc/hosts 
dns域名解析静态配置项
如：[IP_address] host_name host_name_short

3. 根据网络接口配置地址池
}
dnsmasq(dhcp option){

-O, --dhcp-option=[tag:<tag>,[tag:<tag>,]][encap:<opt>,][vi-encap:<enterprise>,][vendor:[<vendor-
       class>],][<opt>|option:<opt-name>],[<value>[,<value>]]  # 问了就回答
dnsmasq --help dhcp
--dhcp-option=3,192.168.4.4  or  --dhcp-option=option:router, 192.168.4.4
--dhcp-option = 42,192.168.0.4 or --dhcp-option = option:ntp-server, 192.168.0.4

-M, --dhcp-boot=[tag:<tag>,]<filename>,[<servername>[,<server address>|<tftp_servername>]] #  与上面类似

--dhcp-option-force=[tag:<tag>,[tag:<tag>,]][encap:<opt>,][vi-encap:<enterprise>,][vendor:[<vendor-
       class>],]<opt>,[<value>[,<value>]] # 不问也回答
       
-U, --dhcp-vendorclass=set:<tag>,<vendor-class>    # <vendor-class> -> <tag> 设定映射关系
dhcp-vendorclass=set:printers,Hewlett-Packard JetDirect # 将Hewlett-Packard JetDirect映射为printers
--dhcp-option=tag:printers,3,192.168.4.4                # 将printers的tag返回，3,192.168.4.4

 -j, --dhcp-userclass=set:<tag>,<user-class>       # <user-class> -> <tag> 设定映射关系
 -4, --dhcp-mac=set:<tag>,<MAC address>            # <MAC address> -> <tag> 设定映射关系
 --dhcp-mac=set:3com,01:34:23:*:*:*                # 01:34:23:*:*:* -> 3com
 --dhcp-match=set:<tag>,<option number>|option:<option name>|vi-encap:<enterprise>[,<value>] # 
 --dhcp-match=set:efi-ia32,option:client-arch,6    # option 93中包含6，则设置tag等于efi-ia32
 --tag-if=set:<tag>[,set:<tag>[,tag:<tag>[,tag:<tag>]]] # 
 -J, --dhcp-ignore=tag:<tag>[,tag:<tag>] # 当所有的tag都存在于--tag-if中，则忽略这个主机，不给他分配租期地址
 --dhcp-ignore-names[=tag:<tag>[,tag:<tag>]] # 如--dhcp-ignore功能类似。符合此条件的主机将不把 name-ip 放到dnsmasq缓存
 --dhcp-generate-names=tag:<tag>[,tag:<tag>] # 使用MAC地址生成一个<主机名>-IP。
 --dhcp-broadcast[=tag:<tag>[,tag:<tag>]]    # 多播通信，在dhcp获取地址的过程中
 
 
--dhcp-subscrid=set:<tag>,<subscriber-id>                                      # for dhcp relay
--dhcp-circuitid=set:<tag>,<circuit-id>, --dhcp-remoteid=set:<tag>,<remote-id> # for dhcp relay
--dhcp-proxy[=<ip addr>]......                                                 # for dhcp relay
}
dnsmasq(dnsmasq.conf){

1. 本地域
# allow /etc/hosts and dhcp lookups via *.lan  本地域  -- /etc/hosts
local=/lan/
domain=lan

expand-hosts 本地域也可以在dnsmasq.conf配置文件的该选项中设置 -- dnsmasq.conf
实现如下：
router, router.lan, ubuntu-desktop, ubuntu-desktop.lan

2. dns服务器
nameserver 212.68.193.110      -- /etc/resolv.conf
nameserver 212.68.193.196

server=8.8.8.8                 -- dnsmasq.conf
server=8.8.4.4

list server '8.8.8.8'          -- /etc/config/dhcp
list server '8.8.4.4'

不同lan接口使用不同的dns server
dhcp-range=lan,192.168.1.101,192.168.1.104,255.255.255.0,24h
dhcp-range=wlan,10.75.9.111,10.75.9.119,255.255.255.0,2h

#set the default route for dhcp clients on the wlan side to 10.10.6.33
dhcp-option=wlan,3,10.10.6.33
#set the dns server for the dhcp clients on the wlan side to 10.10.6.33
dhcp-option=wlan,6,10.10.6.33
#set the default route for dhcp clients on the lan side to 10.10.6.1
dhcp-option=lan,3,10.10.6.1
#set the dns server for the dhcp clients on the lan side to 10.10.6.1
dhcp-option=lan,6,10.10.6.1

3. WINS server information
dhcp-option=44,192.168.1.2

4. External DNS server 
dhcp-option=6,ipaddress1,ipaddress2               -- dnsmasq.conf

config 'dhcp' 'lan'
	list 'dhcp_option' '6,ipaddress1,ipaddress2'  -- /etc/config/dhcp
    
5. SIP-Phones and dnsmasq
  在没有正常应答dns请求的情况下，最新版本的Windows周期性的进行dns请求，
  此选项会过滤SOA SRV类型的请求，同时降低ANY类型的请求优先级
option 'filterwin2k' '0'  # filterwin2k使能阻塞SRV类型dns请求

6. log continuously filled with DHCPINFORM / DHCPACK
dhcp-option=252,"\n"

7. -V, --alias=[<old-ip>]|[<start-ip>-<end-ip>],<new-ip>[,<mask>]
--alias=1.2.3.0,6.7.8.0,255.255.255.0 # 如果地址查询是1.2.3.56 映射为 6.7.8.56；如果是1.2.3.57 映射为 6.7.8.57

8. --all-servers # 默认情况下，dnsmasq上行可以有多个dns服务器，dnsmasq每次仅发送一个dns请求。
设置该标识后，dnsmasq将一次发送到所有dns服务器。dnsmasq将第一个返回的作为响应报文发送给lan侧请求端。


9. SRV 记录
#srv-host=<_service>.<_prot>.[<domain>],[<target>[,<port>[,<priority>[,<weight>]]]]
srv-host=_ldap._tcp.example.com,ldapserver.example.com,389
或
domain=example.com
srv-host=_ldap._tcp,ldapserver.example.com,389
或
srv-host=_ldap._tcp.example.com,ldapserver.example.com,389,1
srv-host=_ldap._tcp.example.com,ldapserver.example.com,389,2
或
srv-host=_ldap._tcp.example.com # 说明没有LDAP功能

10. A, AAAA 和 PTR 记录 
#host-record=<name>[,<name>....],[<IPv4-address>],[<IPv6-address>][,<TTL>]

11. TXT 记录
#txt-record=<name>[[,<text>],<text>]
txt-record=example.com,"v=spf1 a -all"                  # spf
txt-record=_http._tcp.example.com,name=value,paper=A4   # zeroconf

12. PTR 记录 
#ptr-record=<name>[,<target>]
#naptr-record=<name>,<order>,<preference>,<flags>,<service>,<regexp>[,<replacement>]
ptr-record=_http._tcp.dns-sd-services,"New Employee Page._http._tcp.dns-sd-services"


13. CNAME 别名记录
#cname=<cname>,<target>www.yigouyule2.cn[,<TTL>]
cname=bertand,bert # bert的别名为bertand

14. MX
mx-host=maildomain.com,servermachine.com,50
mx-target=servermachine.com
localmx
selfmx

15. conntrack
读取请求DNS的conntrack，将对应的conntrack设置到转发请求的DNS请求报文上。
--query-port 不能与这个一起使用

16. --dhcp-sequential-ip # 设定dhcp下发给客户端地址方式，依赖于客户端MAC地址

17. --bridge-interface=<interface>,<alias>[,<alias>] # 指定桥接口， 在BSD上的特殊处理

}

dhcp(Common Options){
该节配置影响所有接口 
1. local和domain实现：一旦dhcp客户机名称接收到，将为该主机名提供dns服务器 # nohosts
option local 	 '/lan/'
option domain	 'lan' # -s, --domain=<domain>[,<address range>[,local]] 为dhcp server设定domain选项；<domain>名字时必须的
# domain有两个作用; 首先dhcpserver会把该域名下发给所有的客户端；其次；这是dhcp-configured hosts的权利
# 有了domain选项：hostname.domain 将作为一种形式可以被dnsmasq解析 eg: --domain=thekelleys.org.uk  则 laptop 和laptop.thekelleys.org.uk都可以被解析
# 如果--domain=# 则会查找/etc/resolv.conf中的search选下作为domain
# 地址范围：<ip address>,<ip address> 或者 <ip address>/<netmask> 或者 <ip address>
# --domain=thekelleys.org.uk,192.168.0.0/24,local                                                         同义
# --domain=thekelleys.org.uk,192.168.0.0/24 --local=/thekelleys.org.uk/ --local=/0.168.192.in-addr.arpa/  同义
# netmask必须是8,16,24

2. 本地主机名不能被上行dns服务器获得
option domainneeded	 1 # 不解析不带"."的字符串：即不解析普通文本域名。如果在hosts和租期文件不存在此文本，直接返回"not found"
option boguspriv	 1
option localise_queries	 1
option expandhosts	 1 # --expand-hosts 在A|AAAA类型查询的时候，将本机域名追加到/etc/hosts和dhcp租期文件的域名后面，
                       # 使得dns请求支持 <主机名>.<域名> 类型请求

3. authoritative标明本网段只有仅此一个dhcp服务器 # -K, --dhcp-authoritative
   dhcp客户端获取一个IP地址时候，不需要等待一个乏味的超时时间；
   dhcpserver可以在客户端不重新请求的情况下，重建已丢失的租期信息
option authoritative	 1

4. 已下发租期配置文件
option leasefile	 '/tmp/dhcp.leases' # -l, --dhcp-leasefile=<path>

5. 使用此文件作为上行dns服务器IP地址，该文件可能被ppp和dhcp client创建  
option resolvfile	 '/tmp/resolv.conf.auto' 
#  -r, --resolv-file=<file>  dnsmasq 会从这个文件中寻找上游dns服务器；不是通过/etc/resolv.conf文件中。
# 该选项可以配置多个，第一个文件覆盖默认的，后续的追加到nameserver链表后面。
# dnsmasq实时监测这些文件，永远使用最新的配置文件。

-n, --no-poll: dnsmasq不实时监测/etc/resolv.conf文件。

noresolv : dnsmasq不使用/etc/resolv.conf作为域名服务器的获取文件；而是使用指定文件或指定域名服务器地址
# -R, --no-resolv

--clear-on-reload : 当域名服务器发生变化的时候，清除dns缓存信息

serversfile : --servers-file # 与-r, --resolv-file=<file>  同

6. 配置tftp服务的使能和根路径
enable_tftp # --enable-tftp 使能tftp server功能；被限制用于通过网络启动一个客户机；tftp只允许读取不允许写入
tftp_root   # --tftp-root=<directory>[,<interface>]
tftp_no_fail # --tftp-no-fail 不再支持

7. 缓冲大小
cachesize : -c, --cache-size=<cachesize>; 默认值是150，当设置为0的时候，不进行缓存

8. dnsforwardmax
-0, --dns-forward-max=<queries> ; 并发dns转发请求；默认值是150。

9. port # dnsmasq的数据转发既支持UDP协议也支持TCP协议
--port=<port> dns转发监听端口，默认是53，当设置为0的时候表示不支持dns转发，只支持dhcp协议和tftp协议

10. ednspacket_max
-P, --edns-packet-max=<size> # dns转发UDP数据包最大大小，默认值是4096，这个也是RFC5625推荐的

11. queryport
-Q, --query-port=<query_port> # 用于指定dns转发请求报文的源端口，指定端口以后将不再使用随机端口策略
当值设置为0的时候，dnsmasq使用OS提供的端口进行绑定发送。
该策略降低了安全性，提高了数据包发送效率和降低了资源使用量。

12. --min-port=<port> # 用于设定dns转发请求报文的源端口最小值；指定端口以后将限制随机端口策略；
使得发送数据报文的源端口都大于指定端口。

13. dhcpleasemax
-X, --dhcp-lease-max=<number> # 设定最大租期个数；默认值是1000，可用来阻止客户端的DDOS攻击

14. dhcp-alternate-port # 修改服务IP和客户端IP；可以从67,68修改为1067,1068.也可以指定一个端口
--dhcp-alternate-port[=<server port>[,<client port>]]

15. -3, --bootp-dynamic[=<network-id>[,<network-id>]] # 运行使用bootp协议获取IP地址

16. -5, --no-ping # 默认情况下，分配一个IP地址前会发送ping报文，设置该标识后将不再进行重复地址检查

17. --log-dhcp # 设置下发给客户端的所有option内容

18. -l, --dhcp-leasefile=<path> # 设置租期文件位置


}
common(add_local_domain){
本地域名请求使用resolv.conf中服务器地址
}
common(add_local_hostname){
自动为本地域名添加A类型 和 PTR类型 记录
}
common(addnhosts -H){ 多实例；如果指定为目录，则将该目录下所有文件作为hosts文件
-H 附加多个/etc/hosts   # 附加文件格式：/etc/hosts
}
common(nohosts -h){
-h 不读取 /etc/hosts 文件
}
common(expand-hosts -E){
-E 在A|AAAA类型查询的时候，将本机域名追加到/etc/hosts和dhcp租期文件的域名后面；不包括CNAME；PTR，TXT类型记录
}
common(nonegcache){ 
不存储negative类型缓存
}
common(bogusnxdomain -B, --bogus-nxdomain=<ipaddr>){ 假的, 伪造的
NXDOMAIN类型请求， # 当dns响应数据报文中包含"No such domain"的时候，dnsmasq返回一个推送广告的网址，告诉
客户端当前查询的域名不存在。而不是标准的NXDOMAIN响应。
}
common(boguspriv){
--bogus-priv: 通过IP地址查询域名的方向查询中:如果被请求的IP地址是私网IP地址(192.168.x.x|10.x.x.x); 返回"no such domain"
仅在/etc/hosts和dhcp server租期内查询，不将该请求转发给上行服务器
}
common(cachelocal){
设置为0时，使用/etc/resolv.conf中地址在每个接口上进行dns请求
正常情况下，请求服务器地址是回环地址时才走dnsmasq
}
common(dhcp_boot){
--dhcp-boot 正常情况下指定一个文件名
也可以使用: "file name, tftp server name, tftp ip address"
}
common(dhcphostsfile){
--dhcp-hostsfile
使用外部文件指定dhcp选项
}
common(dhcpleasemax){
最大租期数：DHCP leases
-X
}
common(dnsforwardmax){
最大DNS请求并发数：	-0 (zero)
}
common(dnssec){
--dnssec
验证dns响应；缓存DNSSEC数据
}
common(dnsseccheckunsigned){
--dnssec-check-unsigned
forging unsigned replies for signed DNS zones
}
common(ednspacket_max){
-P
最大为 EDNS.0 UDP 的数据报文
}
common(strictorder -o, --strict-order){
默认情况下，dnsmasq会根据dns server是否有效产生的偏好进行域名解析。
设置strictorder选项后，dnsmasq严格按照/etc/resolv.conf设置的dns域名服务器顺序进行dns请求
}
common(fqdn){
--dhcp-fqdn
通常情况下，dhcp服务器将客户端的fqdn名字插入DNS缓存中，
即使两个相同的fqdn在不同的域名下面也是不行的，fqdn必须是唯一的。
如果一个和dhcp server内缓存fqdn名字相同的第二个客户端存在，该名字和IP地址对应关系转移到了第二个客户端上。
--dhcp-fqdn 存在的时候，上述 过程会发生变化：
DHCPServer两个相同的fqdn都会被保存，它们被设定为不同domain。--domain 选项需要被提供
}
common(interface --interface --except-interface --listen-address){  notinterface nonwildcard
interface：   仅仅指定接口上监听；当指定监听接口时，dnsmasq自动将loopback接口添加到监听接口链表中。
当未指定--interface和--listen-address的时候，dnsmasq监听所有接口，除非指定--except-interface选项。
eth1:0 # 不能指定--interface和--except-interface，只能指定--listen-address

-I, --except-interface=<interface name> 不监听指定接口；选项之间优先级：
--listen-address --interface --except-interface.即--except-interface会覆盖前面设置的选项

-2, --no-dhcp-interface=<interface name> 在指定接口上不提供dhcp和tftp服务，仅仅提供dns服务

-a, --listen-address=<ipaddr> 绑定监听IP地址。如果--interface没有提供，--listen-address指定提供，
则dnsmasq不监听loopback接口。如果必要，则需要设置--listen-address=127.0.0.1
       
nonwildcard：--bind-interfaces # 绑定IP地址支持通配符，
           # 即便当接口状态发生变化，接口IP地址发生变化的时候很有用。
           # 该选项可以使得一个设备上运行多个dnsmasq进程，不同的进程监听不同接口，同时给接口下发不同IP地址
}
common(localise_queries){ 本地化请求
-y : 绑定多个lan接口的时候，根据接口子网掩码返回对应的IP地址。
根据接收报文所在的接口地址范围返回请求，dns响应报文内容来至/etc/hosts配置文件；
如果/etc/hosts文件内一个域名具有多个IP地址，最少有一个地址和dns请求所在接口的地址在同一子网掩码的时候，
dnsmasq仅仅返回与接口地址处于同一子网掩码内的IP地址。
当前功能仅限于IPv4地址
}
common(logqueries -q, --log-queries){
-q： # 日志记录dnsmasq请求的响应结果。
# dnsmasq接收到SIGUSR1信号的时候，同时输出dns记录缓存信息

-8, --log-facility=<facility> # 设置输出的设备。当设置为debug模式时，默认是DAEMON和LOCAL0。
如果指定设备包含'/'则说明dnsmasq输出到一个文件中
如果设置设备为'-'则说明dnsmasq输出标准错误输出中
当输出到一个文件的时候，接收到SIGUSR2的时候，关闭然后重新打开指定文件；即允许dnsmasq在循环记录日志

--log-async[=<lines>] # 异步记录日志，当记录日志信息慢的时候，设定缓冲记录行个数的缓存。用来防止syslog日志阻塞网络处理
}
common(readethers){
--read-ethers： 读取/etc/ethers信息给dhcp server使用。
/etc/ethers 格式是：(MAC <hostname|IP Address>)
该功能和--dhcp-host 选项具有相同的功能。
当接收到SIGHUP会重新加载此文件。
}
common(localservice){
--local-service：-S, --local, --server=[/[<domain>]/[domain/]][<ipaddr>[#<port>][@<source-ip>|<interface>[#<port>]]
指定上行服务器IP地址；该选项不会影响对/etc/resolv.conf文件的读取，设置-R选项的时候，不在读取/etc/resolv.conf文件
如果指定一个或多个domain的时候，该服务器仅用于处理与指定域名后缀相同的域名请求。
-S /internal.thekelleys.org.uk/192.168.1.1 # 将所有"xxx.internal.thekelleys.org.uk"发送给192.168.1.1这个域名服务器，其他域名请求走/etc/resolv.conf
-S // # 表示没有"."的域名请求
#<port> 用来指定一个非标准的dns 服务器端口
# --server=/google.com/1.2.3.4 --server=/www.google.com/2.3.4.5  # *.google.com 发送给1.2.3.4 ; *www.google.com发送给2.3.4.5
# --server=/google.com/1.2.3.4 --server=/www.google.com/# # *.google.com发送给1.2.3.4; *www.google.com 被正常转发
# --server=/www.google.com/ # 说明是本地/etc/hosts或者通过dhcpserver的租期文件中
}
common(--address){ 与--local-service类似
 -A, --address=/<domain>/[domain/]<ipaddr> # 包含domain域名请求，都返回给定ipaddr
# /etc/hosts和租期的名字会覆盖这个配置
#  /#/ 匹配所有域名；
# --address=/#/1.2.3.4 对所有域名请求都返回1.2.3.4
}
common(dhcpscript){
-6 --dhcp-script=<path>: 当一个新的租期创建或者一个老的租期删除的时候，该脚本会被执行：
path必须是绝对路径名，不会在PATH环境变量下查找。 脚本参数：<add|old|del> MAC地址 IP地址和主机名
脚本不会并发执行；
当dnsmasq启动时候，脚本会从租期文件中获取信息，过期的会被调用del；其他的会被执行old
当dnsmasq接收到SIGHUP的时候，脚本会执行old类型请求

old：发生在dnsmasq启动时刻和 MAC地址，主机名对应客户端租期发生变化的时候。
DNSMASQ_CLIENT_ID：client-id
DNSMASQ_DOMAIN   ：本机的fqdn
DNSMASQ_VENDOR_CLASS      : vendor-class
DNSMASQ_SUPPLIED_HOSTNAME : hostname
DNSMASQ_USER_CLASS0       :  user-class
DNSMASQ_USER_CLASSn       : 
DNSMASQ_OLD_HOSTNAME      : hostname发生变化的时候
DNSMASQ_INTERFACE         : 接收到请求的接口名
DNSMASQ_RELAY_ADDRESS
DNSMASQ_TAGS              : 空格分隔的多个TAG
HAVE_BROKEN_RTC编译时候有该选项则存在下面环境变量：
DNSMASQ_LEASE_LENGTH
DNSMASQ_LEASE_EXPIRES
DNSMASQ_TIME_REMAINING

--dhcp-scriptuser # 设置运行script脚本的用户名
-9, --leasefile-ro # 执行script脚本不修改lease database file
}

common(ttl  -T, --local-ttl; --neg-ttl; --max-ttl){
缓存时间设置，一般不需要设置
本地 hosts 文件的缓存时间，通常不要求缓存本地，这样更改hosts文件后就即时生效。
 -T, --local-ttl=<time> # 默认情况下，dnsmasq用/etc/hosts和dhcp租期文件中的记录响应客户端请求的时候，会将ttl设置为0.
# 这样客户端就就不会缓存dns记录，该选项可以用来设定响应记录中的ttl(老化时间)
 --neg-ttl=<time>       # 在来自上行的SOA类型的记录的否定响应中，正常情况会包含一个ttl(老化时间)，dnsmasq用来对否定响应进行老化；
 # 如果否定响应中没有包含ttl(老化时间)，dnsmasq会直接将否定响应舍弃掉；该选项设定用来设定否定响应中不包含ttl时，ttl的默认老化时间
 --max-ttl=<time>       # 设置给客户端的相应数据包的最大ttl(老化时间)，如果设置的最大老化时间比较小，就将该老化时间设置给当前响应报文。
}
common(dbus){
--enable-dbus: 运行dnsmasq的可以接收DBus请求，用于上行dnsserver服务器发生变化时候通知：
更新dns server和删除缓存。
}
-M, --dhcp-boot=[tag:<tag>,]<filename>,[<servername>[,<server address>|<tftp_servername>]]

--dhcp-hostsfile=<path> # 从指定文件读取DHCP主机信息；如果path为目录，则读取目录下所有文件内容。一行一个主机的信息，
# 有利于dnsmasq不需要重启的时候，在接收到SIGHUP的时候重启加载此文件内容
--dhcp-optsfile=<path>  # 从指定文件读取DHCP TAG信息；如果path为目录，则读取目录下所有文件内容。接收到SIGHUP的时候重启加载此文件内容
# 也可以在 --dhcp-boot设置dhcp option(bootfile-name, server-ip-address and tftp-server);这些选项也可在此选项中设置

--stop-dns-rebind     # 拒绝将私有IP地址作为域名对应的解析地址；
--rebind-localhost-ok # 拒绝将127.0.0.1/8作为域名对应的解析地址；
--rebind-domain-ok=[<domain>]|[[/<domain>/[<domain>/] # --rebind-domain-ok=/domain1/domain2/domain3/
# 对特定的域名后缀，域名返回的解析地址可以为私有IP地址。
dhcp(DHCP Pools){
dhcp_option     list of strings
dynamicdhcp     boolean
force           boolean
ignore          boolean
dhcpv6          string
ra              string
ndp             string
master          boolean
interface       logical interface name
leasetime       string
limit           integer
networkid       string
start           integer
}
pool(dhcp_option --dhcp-range){ 地址池
list 'dhcp_option' '3,192.168.1.2'                 # Gateway
list dhcp_option "6,80.67.188.188,6,80.67.169.12"  # Domain Name Server
list dhcp_option "1,255.255.255.0"                 # 1   4    Subnet Mask.

-F,  --dhcp-range=  #--dhcp-range可以重复出现
[interface:<interface>,]   # 废弃
[tag:<tag>[,tag:<tag>],]   # 没有实例
[set:<tag>,]               # 没有实例
<start-addr>,<end-addr>    # 起始地址，结束地址
[,<netmask>[,<broadcast>]] # netmask可选；默认依赖绑定接口的配置(dhcp relay时刻必须设置)。
                           # broadcast可选；允许在一个网段内设置多个地址池
[,<lease time>] # 租期默认单位为秒；支持分钟45m,支持小时1h,也支持infinite; 默认值为1h，最小为2分钟。
dhcp-range=192.168.0.50,192.168.0.150,12h
dhcp-range=192.168.0.50,192.168.0.150,255.255.255.0,12h
dhcp-range=red,192.168.0.50,192.168.0.150

dhcp-range=lan,192.168.111.100,static,255.255.255.0,12h

1. 同一物理链路，一个接口上多地址池，总是优先在第一个地址池上分配IP地址；
2. 同一物理链路，多个接口上多地址池，总是优先在第一个接口上的第一个地址池上分配IP地址；
3. 不同物理链路，支持根据接口地址分配对应接口地址池内的IP地址；
4. 接口地址池可以和
}
dhcp(static lease){
config host
        option ip       '192.168.1.3'
        option mac      '11:22:33:44:55:66 aa:bb:cc:dd:ee:ff'  # 11:22:33:44:55:66 有线网口 aa:bb:cc:dd:ee:ff 无线网口
        option name     'mylaptop'
IPv4静态DHCP租期配置表
-----------------------------------        
ip          string      yes (none)
mac         string      no  (none)
name        string      no  (none)
tag         string      no  (none)
dns         boolean     no  0
broadcast   boolean     no  0
leasetime   string      no  (none)

-G, --dhcp-host=    # 同一个硬件地址拥有相同的hostname IP地址和租期
[<hwaddr>]          # 作为静态地址配置的关键字；对应下发hostname IP地址和租期
                    # --dhcp-host=06-00:20:e0:3b:13:af,1.2.3.4  MAC地址段
                    #  --dhcp-host=11:22:33:44:55:66,12:34:56:78:90:12,192.168.0.2 多个MAC地址
[,id:<client_id>|*] # --dhcp-host=id:01:02:03:04,.... 是以客户端id;--dhcp-host=id:clientidastext,.....; id:* 表示只是有MAC，不是client-id
[,set:<tag>]        # 忽略
[,<ipaddr>]         # 静态地址
[,<hostname>]       # 作为hostname下发给客户端，覆盖客户端自己的hostname；hostname也可以作为静态地址配置的关键字
[,<lease_time>]     # 不设定的时候，和地址池内租期相同
[,ignore]           # --dhcp-host=00:20:e0:3b:13:af,ignore 当同一网段存在多个静态地址配置的时候，不配置租期


--dhcp-host=00:20:e0:3b:13:af,wap,infinite # MAC为00:20:e0:3b:13:af则，hostname为wap,租期无限长
--dhcp-host=lap,192.168.0.199              # 主机名为lap则，地址为192.168.0.199
--dhcp-host=11:22:33:44:55:66,12:34:56:78:90:12,192.168.0.2 # 两个MAC地址指向同一个IP地址
--dhcp-host=06-00:20:e0:3b:13:af,1.2.3.4   # 06-00 这个MAC地址范围指向同一个IP地址

--dhcp-hostsfile=<path> # 与--dhcp-host功能相同，1. 通过文件方式实现配置； 2. 在接收到SIGHUP的时候，或重新读取此文件
}

dnsmasq(1.测试配置){
dnsmasq --no-daemon --log-queries # 不用守护进程运行它，同时显示指令的输出并保留运行日志
在默认情况下，Dnsmasq 没有自己的日志文件，所以日志会被记录到 /var/log 目录下的多个地方.
你可以使用经典的 grep 来找到 Dnsmasq 的日志文件。下面这条指令会递归式地搜索 /var/log
grep -ir --exclude-dir=dist-upgrade dnsmasq /var/log/ # 忽略 /var/log/dist-upgrade

dnsmasq --no-daemon --log-queries --log-facility=/var/log/dnsmasq.log # 让 Dnsmasq 使用你指定的文件作为它专属的日志文件
或者在配置文件中设置：log-facility=/var/log/dnsmasq.log
}

dnsmasq --test # 语法检查器
dnsmasq(2.配置文件){ -- 每当你对配置文件进行了修改，你都必须重启 Dnsmasq
Dnsmasq 的配置文件位于 /etc/dnsmasq.conf
Linux 发行版也可能会使用 /etc/default/dnsmasq、/etc/dnsmasq.d/，或者 /etc/dnsmasq.d-available/

/etc/dnsmasq.conf 是德高望重的老大。Dnsmasq 在启动时会最先读取它。/etc/dnsmasq.conf 可以使用 
conf-file= 选项来调用其他的配置文件，例如 conf-file=/etc/dnsmasqextrastuff.conf，或使用 
conf-dir= 选项来调用目录下的所有文件，例如 conf-dir=/etc/dnsmasq.d

conf-dir=/etc/dnsmasq.d/, *.conf, *.foo    # 星号表示包含
conf-dir=/etc/dnsmasq.d, .old, .bak, .tmp  # 不加星号表示排除

你可以用 --addn-hosts= 选项来把你的主机配置分布在多个文件中 # 在这个目里面添加记录
}
dnsmasq(3.实用配置){
domain-needed   # 格式出错的域名的数据包离开你的网络
bogus-priv      # 私有 IP 地址的数据包离开你的网络
no-resolv       # 名字服务只使用 Dnsmasq，而不去使用 /etc/resolv.conf 或任何其他的名字服务文件
# 使用其他的域名服务器
server=/fooxample.com/192.168.0.1
server=208.67.222.222
server=208.67.220.220
# 将某些域名限制为只能本地解析，但不影响其他域名。这些被限制的域名只能从 /etc/hosts 或 DHCP 解析
local=/mehxample.com/
local=/fooxample.com/
# 限制 Dnsmasq 监听的网络接口
interface=eth0
interface=wlan1
# 可以在 /etc/hosts 文件中只写主机名，然后用 Dnsmasq 来添加域名
expand-hosts
domain=mehxample.com
}
dnsmasq(4. DNS 泛域名){

假设你的 Kubernetes 域名是 mehxample.com，那么下面这行配置可以让 Dnsmasq 解析所有对 mehxample.com
address=/mehxample.com/192.168.0.5 
}

dnsmasq(整体功能说明){
Dnsmasq原理：
1. dnsmasq是一个轻量级的dns，dhcp，tftp服务器。用来给设备Lan侧提供dns和dhcp服务。
2. dnsmasq接收dns请求，通过dns本地缓存或者将Lan侧请求转发请求给一个真实的，递归请求的dns服务器。
3. dhcp服务器支持静态地址配置和多个网段地址池配置。dhcp支持一个默认的dhcp选项，也可以设置一个自己需要的dhcp选项。
   包括vendor-encapsulated选项。
4. tftp支持net/PXE以及BOOTP两种方式；
5. DNS和TFTP支持IPv6协议，DHCP不支持IPv6协议。

?本机APP访问主机的/etc/resolv.conf获取DNSServer，该文件指向的DNSServer为Dnsmasq。
?本地局域网中的主机可以直接访问Dnsmasq，即在这些主机中/etc/resolv.conf指向了Dnsmasq。
?Dnsmasq需要通过上游DNS来进行域名解析，上游DNS可以配置在/etc/resolv.dnsmasq.conf中，该文件需要在Dnsmasq的配置文件/etc/dnsmasq.conf中指定。

DNS子系统为网络提供本地DNS服务器，将所有查询类型转发到上游递归DNS服务器并缓存常用记录类型（A，AAAA，CNAME和PTR，以及启用DNSSEC时的DNSKEY和DS）。

本地DNS名称可通过读取/ etc / hosts，通过从DHCP子系统导入名称或配置各种有用的记录类型来定义。
上游服务器可以用各种方便的方式进行配置，包括动态配置，这些配置会随着移动上游网络而发生变化。
权威DNS模式允许本地DNS名称可以导出到全球DNS中的区域。Dnsmasq充当此区域的权威服务器，并且还根据需要为该区域的辅助区域提供区域传输。
可以对来自上游名称服务器的DNS答复执行DNSSEC验证，从而提供针对欺骗和缓存中毒的安全性。
指定的子域可以定向到它们自己的上游DNS服务器，从而使VPN配置变得容易。
支持国际化域名。
DHCP子系统支持DHCPv4，DHCPv6，BOOTP和PXE。

支持静态和动态DHCP租约，以及DHCPv6中的无状态模式。
PXE系统是一个完整的PXE服务器，支持网络引导菜单和多种体系结构支持。它包括代理模式，PXE系统与另一台DHCP服务器协同工作。
有一个内置的只读TFTP服务器来支持网络启动。
通过DHCP配置的计算机的名称会自动包含在DNS中，并且名称可以由每台计算机指定，或者通过在dnsmasq配置文件中将名称与MAC地址或UID关联来集中进行。
路由器通告子系统为IPv6主机提供基本的自动配置。它可以单独使用或与DHCPv6结合使用。

M和O位是可配置的，以控制主机使用DHCPv6。
路由器通告可以包含RDNSS选项。
有一种方式使用来自DHCPv4配置的名称信息来为自动配置的IPv6地址提供DNS条目，否则这些地址将是匿名的。
}
dnsmasq(TFTP){
--enable-tftp[=<interface>]         Enable integrated read-only TFTP server.
--tftp-root=<dir>[,<iface>]         Export files by TFTP only from the specified subtree.
--tftp-unique-root                  Add client IP address to tftp-root.
--tftp-secure                       Allow access only to files owned by the user running dnsmasq.
--tftp-max=<connections>            Maximum number of conncurrent TFTP transfers (defaults to 50).
--tftp-no-blocksize                 Disable the TFTP blocksize extension.
--tftp-port-range=<start>,<end>     Ephemeral port range for use by TFTP transfers.


# 对于绝大多数的配置，仅需指定 enable-tftp 和 tftp-root 选项即可。
# 是否启用内置的 tftp 服务器，可以指定多个逗号分隔的网络接口
#enable-tftp[=<interface>[,<interface>]]
#enable-tftp
#enable-tftp=enp3s0,lo
# 指定 tftp 的根目录，也就是寻找传输文件时使用的相对路径，可以附加接口，
#tftp-root=<directory>[,<interface>]
#tftp-root=/var/lib/tftpboot/
# 如果取消注释，那么即使指定的 tftp-root 无法访问，仍然启动 tftp 服务。
#tftp-no-fail
# 附加客户端的 IP 地址作为文件路径。此选项仅在正确设置了 tftp-root 的情况下可用，
# 示例：如果 tftp-root=/tftp，客户端为 192.168.1.15 请求 myfile.txt 文件时，
# 将优先请求 /tftp/192.168.1.15/myfile.txt 文件， 其次是 /tftp/myfile.txt 文件。
# 感觉没什么用。
#tftp-unique-root
# 启用安全模式，启用此选项，仅允许 tftp 进程访问属主为自己的文件。
# 不启用此选项，允许访问所有 tftp 进程属主可读取的文件。
# 如果 dnsmasq 是以 root 用户运行，tftp-secure 选项将允许访问全局可读的文件。
# 一般情况下不推荐以 root 用户运行 dnsmasq。
# 在指定了 tftp-root 的情况下并不是很重要。
#tftp-secure
# 将所有文件请求转换为小写。对于 Windows 客户端来说非常有用，建议开启此项。
# 注意：dnsmasq 的 TFTP 服务器总是将文件路径中的"\"转换为"/"。
#tftp-lowercase
# 允许最大的连接数，默认为 50 。
# 如果将连接数设置的很大，需注意每个进程的最大文件描述符限制，详见文档手册。
#tftp-max=<connections>
#tftp-max=50
# 设置传输时的 MTU 值，建议不设置或按需设置。
# 如果设定的值大于网络接口的 MTU 值，将按照网络接口的 MTU 值自动分片传输（不推荐）。
#tftp-mtu=<mtu size>
# 停止 tftp 服务器与客户端协商 "blocksize" 选项。启用后，防止一些古怪的客户端出问题。
#tftp-no-blocksize
# 指定 tftp 的连接端口的范围，方便防火墙部署。
# tftp 侦听在 69/udp ，连接端口默认是由系统自动分配的，
# 非 root 用户运行时指定的连接端口号需大于 1025 最大 65535。
#tftp-port-range=<start>,<end>
}

dnsmasq(exit code){
0 - 成功执行
1 - 配置文件不合法.
2 - 地址已经被使用，或者端口已经被使用
3 - 文件系统不存在或者权限不足
4 - 内存不足.
5 - 其余错误
11 - 启动脚本错误
}