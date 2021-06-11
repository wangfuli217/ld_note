http://www.linuxprobe.com/chapter-15.html#151

电子邮件系统基于邮件协议来完成电子邮件的传输，常见的邮件协议有下面这些。
        简单邮件传输协议（Simple Mail Transfer Protocol，SMTP）：用于发送和中转发出的电子邮件，
    占用服务器的25/TCP端口。
        邮局协议版本3（Post Office Protocol 3）：用于将电子邮件存储到本地主机，占用服务器的
    110/TCP端口。
        Internet消息访问协议版本4（Internet Message Access Protocol 4）：用于在本地主机上访问
    邮件，占用服务器的143/TCP端口。
    
    在电子邮件系统中，为用户收发邮件的服务器名为邮件用户代理（Mail User Agent，MUA）。另外，既然电子邮件系统能够让
用户在离线的情况下依然可以完成数据的接收，肯定得有一个用于保存用户邮件的“信箱”服务器，这个服务器的名字为邮件投递
代理（Mail Delivery Agent，MDA），其工作职责是把来自于邮件传输代理（Mail Transfer Agent，MTA）的邮件保存到本地的
收件箱中。其中，这个MTA的工作职责是转发处理不同电子邮件服务供应商之间的邮件，把来自于MUA的邮件转发到合适的MTA服务器。

MUA(发送人) -SMTP--> MTA(新浪电子邮局) -SMTP--> MTA(谷歌电子邮局) -POP3|IMAP4--> MUA(收信人)

大家在生产环境中部署企业级的电子邮件系统时，有4个注意事项请留意。
    添加反垃圾与反病毒模块：它能够很有效地阻止垃圾邮件或病毒邮件对企业信箱的干扰。
    对邮件加密：可有效保护邮件内容不被黑客盗取和篡改。
    添加邮件监控审核模块：可有效地监控企业全体员工的邮件中是否有敏感词、是否有透露企业资料等违规行为。
    保障稳定性：电子邮件系统的稳定性至关重要，运维人员应做到保证电子邮件系统的稳定运行，并及时做好防范分布式拒绝服务（Distributed Denial of Service，DDoS）攻击的准备。
    
    一个最基础的电子邮件系统肯定要能提供发件服务和收件服务，为此需要使用基于SMTP协议的Postfix服务程序提供发件服务
功能，并使用基于POP3协议的Dovecot服务程序提供收件服务功能。这样一来，用户就可以使用Outlook Express或Foxmail等
客户端服务程序正常收发邮件了。
    
第1步：配置服务器主机名称，需要保证服务器主机名称与发信域名保持一致：
[root@linuxprobe ~]# vim /etc/hostname
mail.linuxprobe.com
[root@linuxprobe ~]# hostname
mail.linuxprobe.com

第2步：清空iptables防火墙默认策略，并保存策略状态，避免因防火墙中默认存在的策略阻止了客户端DNS解析域名及收发邮件：
[root@localhost ~]# iptables -F
[root@localhost ~]# service iptables save
iptables: Saving firewall rules to /etc/sysconfig/iptables:[  OK  ]

第3步：为电子邮件系统提供域名解析。由于第13章已经讲解了bind-chroot服务程序的配置方法，因此这里只提供主配置文件、区域配置文件和域名数据文件的配置内容，其余配置步骤请大家自行完成。
 [root@linuxprobe ~]# cat /etc/named.conf
cat /var/named/linuxprobe.com.zone
$TTL 1D 				
@ 	IN SOA 	linuxprobe.com. 	root.linuxprobe.com. 	(
				0;serial
				1D;refresh
				1H;retry
				1W;expire
				3H;minimum
	NS 	ns.linuxprobe.com. 	
ns 	IN A 	192.168.10.10 	
@ 	IN MX 10 	mail.linuxprobe.com. 	
mail 	IN A 	192.168.10.10

[root@linuxprobe ~]# systemctl restart named 
[root@linuxprobe ~]# systemctl enable named ln -s '/usr/lib/systemd/system/named.service'


安装Postfix服务程序。
yum install postfix


第2步：配置Postfix服务程序。
Postfix服务程序主配置文件中的重要参数
参数      作用
myhostname          邮局系统的主机名
mydomain            邮局系统的域名
myorigin            从本机发出邮件的域名名称
inet_interfaces     监听的网卡接口
mydestination       可接收邮件的主机名或域名
mynetworks          设置可转发哪些主机的邮件
relay_domains       设置可转发哪些网域的邮件

vim /etc/postfix/main.cf
myhostname = mail.linuxprobe.com
mydomain = linuxprobe.com
myorigin = $mydomain
inet_interfaces = all
mydestination = $myhostname , $mydomain


[root@linuxprobe ~]# useradd boss 
[root@linuxprobe ~]# echo "linuxprobe" | passwd --stdin boss 
Changing password for user boss. passwd: all authentication tokens updated successfully. 
[root@linuxprobe ~]# systemctl restart postfix 
[root@linuxprobe ~]# systemctl enable postfix ln -s '/usr/lib/systemd/system/postfix.service' '/etc/systemd/system/multi-user.target.wants/postfix.service'



配置Dovecot服务程序
Dovecot是一款能够为Linux系统提供IMAP和POP3电子邮件服务的开源服务程序，安全性极高，配置简单，执行速度快，
而且占用的服务器硬件资源也较少，因此是一款值得推荐的收件服务程序。
第1步：安装Dovecot服务程序软件包。
yum install dovecot

第2步：配置部署Dovecot服务程序。
vim /etc/dovecot/dovecot.conf
………………省略部分输出信息………………
# Protocols we want to be serving.
protocols = imap pop3 lmtp
disable_plaintext_auth = no
login_trusted_networks = 192.168.10.0/24

第3步：配置邮件格式与存储路径。
vim /etc/dovecot/conf.d/10-mail.conf
mail_location = mbox:~/mail:INBOX=/var/mail/%u

然后切换到配置Postfix服务程序时创建的boss账户，并在家目录中建立用于保存邮件的目录。
记得要重启Dovecot服务并将其添加到开机启动项中。至此，对Dovecot服务程序的配置部署步骤全部结束。
[root@linuxprobe ~]# su - boss
Last login: Sat Aug 15 16:15:58 CST 2017 on pts/1
[boss@mail ~]$ mkdir -p mail/.imap/INBOX
[boss@mail ~]$ exit
[root@linuxprobe ~]# systemctl restart dovecot 
[root@linuxprobe ~]# systemctl enable dovecot
