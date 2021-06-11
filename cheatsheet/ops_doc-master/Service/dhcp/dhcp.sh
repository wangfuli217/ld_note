配置DHCP服务器
    在DHCP包中包含的互联网系统联盟（ISC）DHCP服务器。安装该软件包以root身份：

yum -y install dhcp

    示例配置文件可以在/usr/share/doc/dhcp-/dhcpd.conf.example找到。你应该使用这个文件来帮助您配置的/etc/dhcp/dhcpd.conf，对此进行了详细说明。
\cp /usr/share/doc/dhcp-4.*/dhcpd.conf.example /etc/dhcp/dhcpd.conf

配置文件

    如果配置文件被更改，更改不会生效，直到DHCP守护进程重新启动的命令systemctl restart dhcpd。

例 1 子网声明

subnet 192.168.1.0 netmask 255.255.255.0 {
        option routers                  192.168.1.254;
        option subnet-mask              255.255.255.0;
        option domain-search              "example.com";
        option domain-name-servers       192.168.1.1;
        option time-offset              -18000;     # Eastern Standard Time
    range 192.168.1.10 192.168.1.100;
}

例 2 范围参数

#ddns-update-style none;  #禁用动态DNS更新
#authoritative;           #权威的DHCP服务器
#log-facility local7;     #DHCP日志消息发送到不同的日志文件

#PXE Server IP
next-server 192.168.1.100;
filename "pxelinux.0";

default-lease-time 600;   #默认租赁时间
max-lease-time 7200;      #最大租赁时间
option subnet-mask 255.255.255.0;        #子网掩码
option broadcast-address 192.168.1.255;  #网络地址
option routers 192.168.1.254;            #网关地址
option domain-search "example.com";      #域名
option domain-name-servers 192.168.1.1, 192.168.1.2;  #DNS地址
subnet 192.168.1.0 netmask 255.255.255.0 {
    range 192.168.1.10 192.168.1.100;
}

例 3 静态IP地址使用DHCP
host apex {
   option host-name "apex.example.com";
   hardware ethernet 00:A0:78:8E:9E:AA;
   fixed-address 192.168.1.4;
}

例 4 静态IP地址的多个接口使用DHCP
Host apex.0 {
    option host-name “apex.example.com”;
    hardware ethernet 00:A0:78:8E:9E:AA;
    option dhcp-client-identifier=ff:00:00:00:00:00:02:00:00:02:c9:00:00:02:c9:03:00:31:7b:11;
    fixed-address 172.31.0.50,172.31.2.50,172.31.1.50,172.31.3.50;
}

host apex.1 {
    option host-name “apex.example.com”;
    hardware ethernet 00:A0:78:8E:9E:AB;
    option dhcp-client-identifier=ff:00:00:00:00:00:02:00:00:02:c9:00:00:02:c9:03:00:31:7b:12;
    fixed-address 172.31.0.50,172.31.2.50,172.31.1.50,172.31.3.50;
}

例 5 共享网络声明
shared-network name {
    option domain-search            "test.redhat.com";
    option domain-name-servers      ns1.redhat.com, ns2.redhat.com;
    option routers                  192.168.0.254;
    #more parameters for EXAMPLE shared-network
    subnet 192.168.1.0 netmask 255.255.252.0 {
        #parameters for subnet
        range 192.168.1.1 192.168.1.254;
    }
    subnet 192.168.2.0 netmask 255.255.252.0 {
        #parameters for subnet
        range 192.168.2.1 192.168.2.254;
    }
}

例 6 集团声明
group {
   option routers                  192.168.1.254;
   option subnet-mask              255.255.255.0;
   option domain-search              "example.com";
   option domain-name-servers       192.168.1.1;
   option time-offset              -18000;     # Eastern Standard Time
   host apex {
      option host-name "apex.example.com";
      hardware ethernet 00:A0:78:8E:9E:AA;
      fixed-address 192.168.1.4;
   }
   host raleigh {
      option host-name "raleigh.example.com";
      hardware ethernet 00:A1:DD:74:C3:F2;
      fixed-address 192.168.1.6;
   }
}

租赁数据库
    在DHCP服务器上，文件/var/lib/dhcpd/dhcpd.leases存储的DHCP客户端的租约数据库。
启动和停止服务器
    默认情况下，DHCP服务无法启动时启动。
cp /usr/lib/systemd/system/dhcpd.service /etc/systemd/system/
vi /etc/systemd/system/dhcpd.service

    编辑第[Service]行：

ExecStart=/usr/sbin/dhcpd -f -cf /etc/dhcp/dhcpd.conf -user dhcpd -group dhcpd --no-pid

    然后，以root用户，重新启动服务：

systemctl --system daemon-reload
systemctl restart dhcpd
systemctl enable dhcpd
iptables -A INPUT -p udp -m state --state NEW -m udp --dport 67:68 -j ACCEPT

DHCP中继代理
    配置dhcrelay文件作为的DHCPv4和BOOTP中继代理
    要运行dhcrelay在的DHCPv4和BOOTP模式指明该请求应该转发给服务器。复制，然后编辑dhcrelay.service文件，以root用户：

cp /lib/systemd/system/dhcrelay.service /etc/systemd/system/
vi /etc/systemd/system/dhcrelay.service

    编辑下段ExecStart选项[Service]，并添加一个或多个服务器的IPv4地址到行的结尾，例如：

ExecStart=/usr/sbin/dhcrelay -d --no-pid 192.168.1.1

    如果你也想指定接口所在的DHCP中继代理侦听DHCP请求，将它们添加到ExecStart选项与-i参数，例如：

ExecStart=/usr/sbin/dhcrelay -d --no-pid 192.168.1.1 -i em1

    要激活所做的更改，以root用户，重新启动服务：

systemctl --system daemon-reload
systemctl restart dhcrelay

配置多宿主DHCP服务器
    主机配置
default-lease-time 600;
max-lease-time 7200;
subnet 10.0.0.0 netmask 255.255.255.0 {
    option subnet-mask 255.255.255.0;
    option routers 10.0.0.1;
    range 10.0.0.5 10.0.0.15;
}
subnet 172.16.0.0 netmask 255.255.255.0 {
    option subnet-mask 255.255.255.0;
    option routers 172.16.0.1;
    range 172.16.0.5 172.16.0.15;
}
host example0 {
    hardware ethernet 00:1A:6B:6A:2E:0B;
    fixed-address 10.0.0.20;
}
host example1 {
    hardware ethernet 00:1A:6B:6A:2E:0B;
    fixed-address 172.16.0.20;
}

一个基本示例
~]# cat  /etc/dhcp/dhcpd.conf 
option domain-name "example.com";
option domain-name-servers 192.168.80.2;
ddns-update-style none;	
authoritative;

default-lease-time 600;
max-lease-time 7200;
log-facility local7;

subnet 192.168.80.0 netmask 255.255.255.0 {
  range 192.168.80.128 192.168.80.250;
  option routers 192.168.80.2;
  option broadcast-address 192.168.80.255;
}

host local-pxe {
  hardware ethernet 00:50:56:2E:7E:9C;
  fixed-address 192.168.80.101;
  next-server 192.168.80.100;
  filename "pxelinux.0";
}