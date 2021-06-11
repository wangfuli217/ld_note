dhcpd服务程序配置文件中使用的常见参数以及作用
参数                                       作用
ddns-update-style 类型                     定义DNS服务动态更新的类型，类型包括：
                                           none（不支持动态更新）、interim（互动更新模式）与ad-hoc（特殊更新模式）
allow/ignore client-updates                允许/忽略客户端更新DNS记录
default-lease-time 21600                   默认超时时间
max-lease-time 43200                       最大超时时间
option domain-name-servers 8.8.8.8         定义DNS服务器地址
option domain-name "domain.org"            定义DNS域名
range                                     定义用于分配的IP地址池
option subnet-mask                        定义客户端的子网掩码
option routers                            定义客户端的网关地址
broadcase-address  广播地址               定义客户端的广播地址
ntp-server IP地址                         定义客户端的网络时间服务器（NTP）
nis-servers IP地址                        定义客户端的NIS域服务器的地址
hardware 硬件类型 MAC地址                 指定网卡接口的类型与MAC地址
server-name 主机名                        向DHCP客户端通知DHCP服务器的主机名
fixed-address IP地址                      将某个固定的IP地址分配给指定主机
time-offset 偏移差                        指定客户端与格林尼治时间的偏移差