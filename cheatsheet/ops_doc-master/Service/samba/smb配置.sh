1.安装samba
    yum -y install samba samba-client cifs-utils

2.添加samba用户
    adduser admin
    smbpasswd -a admin
    ~]# smbpasswd --help  
    -h：显示smbpasswd命令的帮助信息  
    -a：添加指定的Samba用户帐号  
    -d：禁用指定的用户帐号  
    -e：启用指定的用户帐号  
    -x：删除指定的用户帐号  
    不使选项时则是修改Samba用户的密码

启动samba
    systemctl enable smb.service
    systemctl restart smb.service

防火墙设置
    iptables -I INPUT -m state --state NEW -m tcp -p tcp --dport 139 -j ACCEPT
    iptables -I INPUT -m state --state NEW -m tcp -p tcp --dport 445 -j ACCEPT

SELinux设置
    setsebool -P samba_enable_home_dirs on
    setsebool -P samba_export_all_rw on

访问samba共享目录
    使用Windows客户端访问文件共享服务
        UNC路径:  \\server\sharename
    使用Linux客户端访问文件共享服务
        smbclient -L 192.168.101.250
        smbclient //192.168.101.250/admin -U admin%passwd 
        mount.cifs //192.168.101.250/admin /mnt/ -o user=admin,pass=passwd
        echo "//192.168.101.250/admin  /mnt  cifs  credentials=/root/credentials  0 0" >>/etc/fstab
        echo -e "user=admin\npass=passwd" >/root/credentials

查看samba配置
    testparm

查看samba用户
    pdbedit -L

查看客户端连接
    smbstatus

在windows端断开连接
    net use * /del /y

目录权限和samba权限共同决定用户的操作
smb.conf主配置文件详解
    有三个特殊的段：
    [global]：  全局设置
    [homes]：   用户目录共享设置
    [printers]：打印机共享设置
    [myshare]： 自定义名称的共享目录设置

~]# grep -v ^# /etc/samba/smb.conf 

[global]
	workgroup = MYGROUP                                             #工作组名称，windows下是WORKGROUP
	server string = Samba Server Version %v                         #主机描述，%v 显示samba版本信息
;	netbios name = MYSERVER                                         #Netbios 名称
;	interfaces = lo eth0 192.168.12.2/24 192.168.13.2/24            #监听接口和地址
;	hosts allow = 127. 192.168.12. 192.168.13.                      #允许访问的客户端IP
;	server max protocol = SMB3                                      #服务器支持的最高级别的协议


	# log files split per-machine:
	log file = /var/log/samba/log.%m                                #日志文件位置，%m 变量表示客户机地址
	# maximum size of 50KB per log file, then rotate:
	max log size = 50                                               #日志轮询大小，单位KB


	security = user                                                 #安全认证，基于用户
	passdb backend = tdbsam                                         #samba用户数据库

;	username map = /etc/samba/users.map                             #用户名映射，echo "root = administrator admin" >/etc/samba/users.map
;	config file = /etc/samba/smb.%U.conf                            #子配置文件，%U 基于用户，%G 基于用户组

#…………

[homes]
	comment = Home Directories                                      #共享描述
	browseable = no                                                 #其他人不可见
	writable = yes
;	valid users = %S
;	valid users = MYDOMAIN\%S

[printers]
	comment = All Printers
	path = /var/spool/samba
	browseable = no
	guest ok = no
	writable = no
	printable = yes                                                #是打印机

;	[public]
;	comment = Public Stuff
;	path = /home/samba
;	public = yes
;	writable = yes
;	printable = no
;	write list = +staff

##其他一些选项
;	browseable = yes                               #是否公开可见，等同于browsable
;	guest ok = no                                  #是否允许来宾用户访问，等同于public
;	guest only = no                                #均以来宾用户身份访问，等同于only guest

;	read list = mary, @students                    #可读列表
;	write list = admin, root, @staff               #可写列表
;	write ok = yes                                 #可写，等同于read only
;	read only = yes                                #只读，反义可写
;	writeable = yes                                #可写，等同于writable，反义只读
;	valid users = greg, @pcusers                   #有效用户和组
;	invalid users = root fred admin @wheel         #非法用户和组

;	create mask = 0775                             #创建掩码，等同于create mode
;	directory mask = 0775                          #目录掩码，等同于directory mode
;	force user = auser                             #强制属主用户
;	force group = auser                            #强制属组用户组，等同于group

;	hide dot files = yes                           #隐藏点文件
;	hide files = path                              #隐藏文件
;	hide special files = no                        #隐藏特殊文件
;	hide unreadable = no                           #隐藏不可读文件
;	hide unwriteable files = no                    #隐藏不可写文件
;	hosts allow = 150.203.5.                       #主机允许，等同于allow hosts
;	hosts deny = 150.203.4.                        #主机拒绝，等同于deny hosts
;	keepalive = 300                                #保持活动时间

root:0:root
109(){
[global]
        workgroup = MYGROUP
        server string = Samba Server Version %v
        log file = /var/log/samba/log.%m
        max log size = 50
        cups options = raw

[homes]
        comment = Home Directories
        read only = No
        browseable = No

[printers]
        comment = All Printers
        path = /var/spool/samba
        printable = Yes
        browseable = No

[public]
        comment = Public Stuff
        path = /home/samba
        write list = +staff
        read only = No
        guest ok = Yes
}

nobody:65534:nobody
root:0:root
ubuntu:1000:ubuntu
190(){
[global]
        server string = %h server (Samba, Ubuntu)
        map to guest = Bad User
        obey pam restrictions = Yes
        pam password change = Yes
        passwd program = /usr/bin/passwd %u
        passwd chat = *Enter\snew\s*\spassword:* %n\n *Retype\snew\s*\spassword:* %n\n *password\supdated\ssuccessfully* .
        unix password sync = Yes
        syslog = 0
        log file = /var/log/samba/log.%m
        max log size = 1000
        dns proxy = No
        usershare allow guests = Yes
        panic action = /usr/share/samba/panic-action %d
        idmap config * : backend = tdb

[homes]
        comment = Home Directories
        path = /home/ubuntu
        read only = No
        create mask = 0700
        guest ok = Yes

[printers]
        comment = All Printers
        path = /var/spool/samba
        create mask = 0700
        printable = Yes
        print ok = Yes
        browseable = No

[print$]
        comment = Printer Drivers
        path = /var/lib/samba/printers

[common]
        comment = Common share
        path = /home/ubuntu
        write list = root, ubuntu, @staff
        read only = No
        create mask = 0700
        directory mask = 0700
        guest ok = Yes
}

Samba服务程序中的参数以及作用
[global]                    #全局参数。
    workgroup = MYGROUP     #工作组名称
    server string = Samba Server Version %v     #服务器介绍信息，参数%v为显示SMB版本号
    log file = /var/log/samba/log.%m    #定义日志文件的存放位置与名称，参数%m为来访的主机名
    max log size = 50   #定义日志文件的最大容量为50KB
    security = user     #安全验证的方式，总共有4种
    #share：来访主机无需验证口令；比较方便，但安全性很差
    #user：需验证来访主机提供的口令后才可以访问；提升了安全性
    #server：使用独立的远程主机验证来访主机提供的口令（集中管理账户）
    #domain：使用域控制器进行身份验证
    passdb backend = tdbsam     #定义用户后台的类型，共有3种
    #smbpasswd：使用smbpasswd命令为系统用户设置Samba服务程序的密码
    #tdbsam：创建数据库文件并使用pdbedit命令建立Samba服务程序的用户
    #ldapsam：基于LDAP服务进行账户验证
    load printers = yes     #设置在Samba服务启动时是否共享打印机设备
    cups options = raw  #打印机的选项
[homes]                 #共享参数
    comment = Home Directories  #描述信息
    browseable = no     #指定共享信息是否在“网上邻居”中可见
    writable = yes  #定义是否可以执行写入操作，与“read only”相反
[printers]          #打印机共享参数
    comment = All Printers  
    path = /var/spool/samba     #共享文件的实际路径(重要)。
    browseable = no     
    guest ok = no   #是否所有人可见，等同于"public"参数。
    writable = no   
    printable = yes
    
resource(配置共享资源){
# 用于设置Samba服务程序的参数以及作用
参数                                                    作用
[database]                                              共享名称为database
comment = Do not arbitrarily modify the database file   警告用户不要随意修改数据库
path = /home/database                                   共享目录为/home/database
public = no                                             关闭“所有人可见”
writable = yes                                          允许写入操作

1. 创建用于访问共享资源的账户信息。
pdbedit
-a 用户名   建立Samba用户
-x 用户名   删除Samba用户
-L          列出用户列表
-Lv         列出用户详细信息的列表
pdbedit -a -u linuxprobe

2. 创建用于共享资源的文件目录。
mkdir /home/database 
chown -Rf linuxprobe:linuxprobe /home/database 
semanage fcontext -a -t samba_share_t /home/database 
restorecon -Rv /home/database

4. 设置SELinux服务与策略，
getsebool -a | grep samba
setsebool -P samba_enable_home_dirs on

5. 在Samba服务程序的主配置文件中，
[homes]参数为来访用户的家目录共享信息，[printers]参数为共享的打印机设备。
这两项如果在今后的工作中不需要，可以像刘遄老师一样手动删除，这没有任何问题。
[root@linuxprobe ~]# vim /etc/samba/smb.conf 
[global]
 workgroup = MYGROUP
 server string = Samba Server Version %v
 log file = /var/log/samba/log.%m
 max log size = 50
 security = user
 passdb backend = tdbsam
 load printers = yes
 cups options = raw
[database]
 comment = Do not arbitrarily modify the database file
 path = /home/database
 public = no
 writable = yes

6. 重启smb服务
[root@linuxprobe ~]# systemctl restart smb
[root@linuxprobe ~]# systemctl enable smb
[root@linuxprobe ~]# iptables -F 
[root@linuxprobe ~]# service iptables save

}