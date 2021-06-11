DNS服务器

    DNS(Domain Name System 域名系统)，是用于主机名与各自的IP地址相关联的分布式数据库系统。对于用户来说，这具有使他们能够通过名称，通常是更容易记住，比起计算机上的网络地址的网络数值更具优势。对于系统管理员来说，使用的DNS服务器，也称为域名服务器，使能更改IP的主机地址，而没有影响到基于名称的查询。使用的DNS数据库，不仅是为解决IP地址，域名和它们的使用变得更广泛和更广泛的DNSSEC部署。

DNS简介

    DNS是使用一个或多个集中式服务器具有权威性的某些领域通常实现的。当一个客户端主机的域名服务器请求信息时，它通常连接到端口53的域名服务器，然后尝试解析请求的名称。如果域名服务器被配置为一个递归域名服务器，它并没有一个权威的答案，或者还没有从刚才的查询答案的缓存，它会查询其他名称服务器，称为根域名服务器，以确定哪些域名服务器是名称问题的权威，然后查询他们获得所要求的名称。配置为纯粹的权威，递归域名服务器关闭，将无法代表客户做查询。

域名服务器Zones

    在DNS服务器，所有的信息都存储在称为资源记录的基本数据元素 (RR)。资源记录在RFC1034中定义的域名被组织成一个树状结构。层次结构的每个级别由一段分 (.)。例如：在根域，记为 . ， 是DNS的树根，这是在零级。域名COM，简称为顶级域（TLD）是根域(.)的子级所以它是层次结构的第一级。域名example.com是在层次结构的第二级。

DNS查询方式

    递归查询：大多数客户机向DNS服务器解析域名的方式
    迭代查询：大多数DNS服务器向其他DNS服务器解析域名的方式

域名服务器类型

    权威
    权威域名服务器回答的资源记录是只有自己带的一部分。类别包括：主要(master)和辅助(slave)名称服务器。

    递归
    递归域名服务器提供解析服务，但它们不是权威的任何区域。回答所有决议都缓存在内存中的一段固定的时间，这是由资源的检索记录中指定。类别包括：转发名称服务器（Forwarding）

尽管名称服务器既可以是权威和递归的同时，建议不要结合的结构类型。为了能够完成自己的工作，授权服务器应该提供给所有客户端的所有时间。在另一方面，由于递归查找需要更多的时间比权威的答复，递归服务器应该只提供给客户的数量有限，否则很容易分布式拒绝服务（DDoS）攻击。
BIND域名服务器

        BIND（Berkeley Internet Name Domain 伯克利互联网域名）
        官方站点：https://www.isc.org/

默认监听端口
UDP 53端口一般对所有客户机开放，以提供解析服务
TCP 53端口一般只对特定辅助域名服务器开放，提高解析记录传输通道
TCP 953端口默认只对本机（127.0.0.1）开放，用于为rndc远程管理工具提供控制通道

指定的服务配置文件
/etc/named.conf：主配置文件
/etc/named/：对配置文件的辅助目录所包含的主要配置文件中
/etc/named.rfc1912.zones：区域配置文件
/var/named/named.localhost：区域数据文件
/usr/share/doc/bind*/sample/：范例文件
安装BIND

安装BIND在chroot环境中运行，发出以下命令以root身份：

yum -y install bind-chroot

要启用named-chroot服务，首先检查是否指定的服务通过发出以下命令运行：

systemctl status named

如果正在运行，它必须被禁止。
要禁用named，发出以下命令以root身份：

systemctl stop named
systemctl disable named

第一次启动服务时生产密钥需要时间。
要启用named-chroot服务，发出以下命令以root身份：

systemctl start named-chroot
systemctl enable named-chroot

要检查named-chroot服务的状态，发出以下命令以root身份：

systemctl status named-chroot

区域配置文件

下面的语句类型常用于/etc/named.conf中：
acl
ACL（访问控制列表）语句允许你定义主机组，让他们可以允许或拒绝访问的域名服务器。它采用以下形式：

acl acl-name {
  match-element;
  ...
};

访问控制列表名称说明名称是访问控制列表的名称，并匹配元素的选择通常是一个单独的IP地址（如10.0.1.1、localhost）或无类别域间路由（CIDR）网络符号（例如，10.0.1.0/24）,或者匹配的所有的IP地址(any)。

例 1 结合选项使用访问控制列表

acl black-hats {
  10.0.2.0/24;
  192.168.0.0/24;
  1234:5678::9abc/24;
};
acl red-hats {
  10.0.1.0/24;
};
options {
  blackhole { black-hats; };
  allow-query { red-hats; };
  allow-query-cache { red-hats; };
};

include
include语句允许你包含在/etc/named.conf中的文件，从而使潜在的敏感数据可以被放置在具有有限权限的单独的文件。它采用以下形式：

include "file-name"

该文件名 ​​的语句名是绝对路径的文件。

例 2 以/etc/named.conf中 include文件

include "/etc/named.rfc1912.zones";

options
选项​​语句允许你定义全局服务器配置选项，以及设置其他语句的默认值。它可以用来指定命名工作目录的位置，查询类型允许的，等等。它采用以下形式：

options {
  option;
  ...
};

为了防止分布式拒绝服务（DDoS）攻击，因此建议您使用allow-query-cache选项，只有客户的特定子集限制递归DNS服务。

例 3 使用选项声明

options {
  allow-query       { localhost; };
  listen-on port    53 { 127.0.0.1; };
  listen-on-v6 port 53 { ::1; };
  max-cache-size    256M;
  directory         "/var/named";
  statistics-file   "/var/named/data/named_stats.txt";

  recursion         yes;
  dnssec-enable     yes;
  dnssec-validation yes;

  pid-file          "/run/named/named.pid";
  session-keyfile   "/run/named/session.key";
};

zone
zone语句允许你定义一个区域，特征，如它的配置文件和区域特定的选项的位置，并可以用来覆盖全局选项语句。它采用以下形式：

zone zone-name [zone-class] {
  option;
  ...
};

例 4 一个Zone声明为一个主域名服务器

zone "example.com" IN {
  type master;
  file "example.com.zone";
  allow-transfer { 192.168.0.2; };
};

例如 5 一个Zone声明为辅助域名服务器

zone "example.com" {
  type slave;
  file "slaves/example.com.zone";
  masters { 192.168.0.1; };
};

例 6 一个Zone声明为反向主域名服务器

zone "1.0.10.in-addr.arpa" IN {
  type master;
  file "example.com.rr.zone";
  allow-update { none; };
};

区域数据文件

公共指令
$INCLUDE
$INCLUDE指令可以包括在它出现的地方另一个文件，使其他区域的设置可以存储在一个单独的区域文件。

例 7 使用$INCLUDE指令

$INCLUDE /var/named/penguin.example.com

$ORIGIN
$ORIGIN指令允许你添加域名为不合格的记录，比如那些只有主机名。

例 8 使用$ORIGIN指令

$ORIGIN example.com.

$TTL
$TTL指令允许您设置默认生存时间（TTL）值的区域，也就是多长时间是一个区域记录有效

例 9 使用$TTL指令

$TTL 1D

常见的资源记录
NS：域名服务器（Name Server）记录
MX：邮件交换（Mail Exchange）记录
A：地址（Address）记录，只用在正向解析的区域数据文件中
CNAME：别名（Canonical Name）记录
SRV：服务（Server）记录
AAAA：ipV6正解
PRT：用于反向名称解析
SOA：宣布关于命名空间的名称服务器重要的权威信息

一个简单的区域数据文件

$ORIGIN example.com.
$TTL 86400
@         IN  SOA  dns1.example.com.  hostmaster.example.com. (
              2001062501  ; serial
              21600       ; refresh after 6 hours
              3600        ; retry after 1 hour
              604800      ; expire after 1 week
              86400 )     ; minimum TTL of 1 day
;
;
          IN  NS     dns1.example.com.
          IN  NS     dns2.example.com.
dns1      IN  A      10.0.1.1
          IN  AAAA   aaaa:bbbb::1
dns2      IN  A      10.0.1.2
          IN  AAAA   aaaa:bbbb::2
;
;
@         IN  MX     10  mail.example.com.
          IN  MX     20  mail2.example.com.
mail      IN  A      10.0.1.5
          IN  AAAA   aaaa:bbbb::5
mail2     IN  A      10.0.1.6
          IN  AAAA   aaaa:bbbb::6
;
;
; This sample zone file illustrates sharing the same IP addresses
; for multiple services:
;
services  IN  A      10.0.1.10
          IN  AAAA   aaaa:bbbb::10
          IN  A      10.0.1.11
          IN  AAAA   aaaa:bbbb::11

ftp       IN  CNAME  services.example.com.
www       IN  CNAME  services.example.com.
;
;

一个反向名称解析区域数据文件

$ORIGIN 1.0.10.in-addr.arpa.
$TTL 86400
@  IN  SOA  dns1.example.com.  hostmaster.example.com. (
       2001062501  ; serial
       21600       ; refresh after 6 hours
       3600        ; retry after 1 hour
       604800      ; expire after 1 week
       86400 )     ; minimum TTL of 1 day
;
@  IN  NS   dns1.example.com.
;
1  IN  PTR  dns1.example.com.
2  IN  PTR  dns2.example.com.
;
5  IN  PTR  server1.example.com.
6  IN  PTR  server2.example.com.
;
3  IN  PTR  ftp.example.com.
4  IN  PTR  ftp.example.com.