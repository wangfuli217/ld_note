yum install samba samba-client samba-common
samba-common --- 主要提供samba服务器的设置文件与设置文件语法检验程序testparm  
samba-client  --- 客户端软件，主要提供linux主机作为客户端时，所需要的工具指令集  
samba  --- 服务器端软件，主要提供samba服务器的守护程序，共享文档，日志的轮替，开机默认选项  
samba-swat  --- 基于https协议的samba服务器web配置界面 （此处没有安装）

官方文档：https://wiki.samba.org/index.php/User_Documentation
smb.conf：https://www.samba.org/samba/docs/man/manpages-3/smb.conf.5.html

1. smbd和nmbd为samba的两个后台服务程序
2. samba的配置文件 /etc/samba/smb.conf 和 testparm命令, 以及 [global] username map = /etc/samba/smbusers # 用户别名
3. 用户管理 useradd pdbedit 或 smbpasswd # 给 samba 添加用户并创建密码(登陆 samba 用的)，其中的用户必须是linux已存在的用户
4. samba客户端 smbclient 和 mount -t cifs //192.168.1.2/nas /mnt -o username=pi,password=raspberry
5. 文件系统管理 setenforce && chmod && chown 还有与之相应的/etc/samba/smb.conf 配置文件节
6. 网络接口管理 iptables (手动添加命令和/etc/sysconfig/iptables)
7. 系统配置文件 /etc/init.d/smbd && /etc/init.d/nmbd 服务 以及 chkconfig smb on && chkconfig nmb on
   系统配置文件 systemctl start smb && systemctl start nmb 服务 以及 systemctl enable smb && systemctl enable nmb
   
samba(smbd 服务){
SMB是核心服务 # smbd: 提供对服务器中文件、打印资源的共享访问 端口139 445
  主要负责建立 Linux Samba服务器与Samba客户机之间的对话，验证用户身份并提供对文件和打印系统的访问，
只有SMB服务启动，才能实现文件的共享，监听139 TCP端口；
iptables -I INPUT -m state --state NEW -m tcp -p tcp --dport 139 -j ACCEPT
iptables -I INPUT -m state --state NEW -m tcp -p tcp --dport 445 -j ACCEPT
}
samba(nmbd 服务){
NMB是负责解析用的 # nmbd: 通过基于NetBIOS主机名称的解析 端口137 138
  类似与DNS实现的功能，NMB可以把Linux系统共享的工作组名称与其IP对应起来，
如果NMB服务没有启动，就只能通过IP来访问共享文件，监听137和138 UDP端口。
iptables -I INPUT -m udp -p udp --dport 137 -j ACCEPT
iptables -I INPUT -m udp -p udp --dport 138 -j ACCEPT
}
samba(smbstatus 服务){
smbstatus -u smbuser1 # 列出当前所有的samba连接状态
-b ：指定只输出简短的内容。
-d ：指定以详细方式输出内容。
-L ：让 smbstatus 只列出 /var 目录中的被锁定项。
-p ：用这个参数来列出 smbd进程的列表然后退出。对脚本编程很有用。
-S ：让 smbstatus 只列出共享资源项。
-s configurationfile ：用这个参数指定一个配置文件。当然在编译时已做好了默认的配置文件。
                       文件中包含了服务需要的详细配置信息。参见 smb.conf(5)获得更多信息。
-u username ：用这个参数来查看只与username 用户对应的信息。

smbstatus -u smbuser1
smbstatus -d <1-10>  # 可以查看用户配置信息 
}
samba(net 工具){ Tool for administration of Samba and remote CIFS servers.
}
samba(pdbedit 工具){
-a username：新建Samba账户。
-x username：删除Samba账户。
-L：列出Samba用户列表，读取passdb.tdb数据库文件。
-Lv：列出Samba用户列表的详细信息。
pdbedit -L -w # 密码显示
-c “[D]” –u username：暂停该Samba用户的账号。
-c “[]” –u username：恢复该Samba用户的账号。
-f|--fullname fullname # -f "Simo Sorce"
-h|--homedir homedir   # -h "\\\\BERSERKER\\sorce"
-D|--drive drive       # -D "H:"
}
samba(profiles 工具){ windows NT 版本专用
}
samba(smbcontrol 工具){ send messages to smbd, nmbd or winbindd processes
smbcontrol [-i] [-s]
smbcontrol [destination] [message-type] [parameter]
}
samba(smbcquotas 工具){
Set or get QUOTAs of NTFS 5 shares
}

samba(smbpasswd 工具){ smbpasswd [option] [username]
smbpasswd 命令属于 samba ，能够实现添加或删除samba用户和为用户修改密码。
修改samba用户口令、增加samba用户。
-a：向smbpasswd文件中添加用户； 
-c：指定samba的配置文件； 
-x：从smbpasswd文件中删除用户； 
-d：在smbpasswd文件中禁用指定的用户； 
-e：在smbpasswd文件中激活指定的用户； 
-n：将指定的用户的密码置空。

然后添加 Samba 用户：
smbpasswd -a einverne
修改用户密码
smbpasswd einverne

/etc/samba/smbpasswd：
这个档案预设并不存在啦！他是 SAMBA 默认的用户密码对应表。
}

samba(testparm 工具){
用于检查配置文件中的参数设置是否正确
testparm -v  # 所有的配置
testparm     # 生效的配置
grep -v “^#” smb.conf | grep -v “^;” | grep -v “^$” > smb.conf # grep命令提取有效配置行
}

samba(smbclient 客户){ ftp命令行方式客户端
smbclient -L 服务器IP                                   # 查看服务器上的共享文件夹
smbclient -L 192.168.27.125                             # 查看服务器上的共享文件夹 
smbclient //IP地址/test                                 # 匿名访问，登录
smbclient //192.168.1.100/test                          # 匿名访问，登录
smbclient -U usertest //192.168.27.125/usertest         # 用户%密码登陆，提示密码输入
smbclient -U usertest%123456 //192.168.27.125/usertest  # 用户%密码登陆，选项指定输入密码

smbclient smbclient命令网络服务器 smbclient命令属于samba套件，它提供一种命令行使用交互式方式访问samba服务器的共享资源。

-B：传送广播数据包时所用的IP地址；
-d<排错层级>：指定记录文件所记载事件的详细程度；
-E：将信息送到标准错误输出设备；
-h：显示帮助；
-i<范围>：设置NetBIOS名称范围；
-I：指定服务器的IP地址；
-l <记录文件>：指定记录文件的名称；
-L：显示服务器端所分享出来的所有资源；
-M：可利用WinPopup协议，将信息送给选项中所指定的主机；
-n：指定用户端所要使用的NetBIOS名称；
-N：不用询问密码；
-O <连接槽选项>：设置用户端TCP连接槽的选项；
-p：指定服务器端TCP连接端口编号；
-R <名称解析顺序>：设置NetBIOS名称解析的顺序；
-s <目录>：指定smb.conf所在的目录；
-t <服务器字码>：设置用何种字符码来解析服务器端的文件名称；
-T：备份服务器端分享的全部文件，并打包成tar格式的文件；
-U <用户名称>：指定用户名称；
-w <工作群组>：指定工作群组名称。

?或help [command] -- 提供关于帮助或某个命令的帮助 
![shell] -- 执行所用的SHELL命令，或让用户进入 SHELL提示符 
cd [目录] -- 切换到服务器端的指定目录，如未指定，则 smbclient 返回当前本地目录 
lcd [目录] -- 切换到客户端指定的目录； 
dir 或ls -- 列出当前目录下的文件； 
exit 或quit -- 退出smbclient 
get file1 file2 -- 从服务器上下载file1，并以文件名file2存在本地机上；如果不想改名，可以把file2省略 
mget file1 file2 file3 filen -- 从服务器上下载多个文件； 
md或mkdir 目录 -- 在服务器上创建目录 
rd或rmdir 目录 -- 删除服务器上的目录 
put file1 [file2] -- 向服务器上传一个文件file1,传到服务器上改名为file2； 
mput file1 file2 filen -- 向服务器上传多个文件
}

samba(smbcacls 客户){ smbcacls - Set or get ACLs on an NT file or directory names
}

samba(nmblookup 客户){ NetBIOS over TCP/IP client used to lookup NetBIOS names
用于查询主机的NetBIOS名，并将其映射为IP地址
}

samba(findsmb 客户){
}
samba(rpcclient 客户){
}
samba(sharesec 客户){
}
samba(mount){ mount方式客户端
mount -t cifs -o username=用户名,password=密码 //服务器地址/共享名 本地目录
mount -tcifs //192.168.192.91/yysmb01 /mnt/nfs/ -o username=smbuser1,password=smbuser1
sudo mount -t cifs //192.168.1.2/nas /mnt -o username=pi,password=raspberry
#fstab
//192.168.10.109/root /mnt cifs username=root,password=123456 0 0
}

samba(iptables){ /etc/sysconfig/iptables
-A INPUT -m state --state NEW -m tcp -p tcp --dport 139 -j ACCEPT
-A INPUT -m state --state NEW -m tcp -p tcp --dport 445 -j ACCEPT
-A INPUT -m udp -p udp --dport 137 -j ACCEPT
-A INPUT -m udp -p udp --dport 138 -j ACCEPT
}
samba(filesystem){
setenforce 0              # 临时关闭selinux
# vi /etc/selinux/config  通过配置文件关闭selinux
SELINUX=disabled



# 所有用户共享目录
chmod -R 0777 /share        # 使共享目录具有0777权限

# 指定用户共享目录
useradd ted       # 创建系统用户
pdbedit -a ted    # 创建samba用户
mkdir /ted        # ted共享目录
chown -R ted:ted /ted  # 修改文件的拥有者
# vi /etc/samba/smb/conf
[share]
    comment = ted  hello world
    path = /ted
    allow hosts = 192.168.27.109/16
    user = ted
    writable = yes
    browseable = yes
}

samba(quota 限额){
1. 使文件系统支持quota
#fstab
/dev/mapper/vg_dbl-lv_root /  ext4    rw,usrquota,grpquota        1 1
#mount
/dev/mapper/vg_dbl-lv_root on / type ext4 (rw,usrquota,grpquota)

2. 安装quota
yum install quota

3. 配置过程  # 没有配置文件，配置在文件系统中写入
quotacheck -vug /mount_point : v：显示进度 u：新建用户日志 g：新建用户组日志
quotaon /mount_point         : 启动quota
限制值设置：edquota与setquota

# 以限制用户额度为例
# edquota -u user1 [-g groupname]  #其会打开一个关于此用户限值设置的文档
FileSystem Blocks  soft hard Inodes  soft  hard
/dev/sda9     80    0     0       10     0   0

FileSystem：针对的文件系统
Blocks：磁盘容量,单位KB                  当前已使用量
soft：blocks的soft 单位KB,0表示不限制
hard：block的hard
inodes： Inode数量，单位个数             当前已使用量
soft:Inode的soft
hard: Inode的hard
}

samba(smbusers 别名){
在/etc/smbusers中添加
zhangsan = zhang zhangs
在主配置文件的global区域添加
username map = /etc/samba/smbusers

smbclient -U zhangsan%123456 //192.168.27.125/usertest  # 使用linux系统用户名登陆
smbclient -U zhang%123456 //192.168.27.125/usertest     # 使用samba提供的别名登陆
smbclient -U zhangs%123456 //192.168.27.125/usertest     # 使用samba提供的别名登陆
}

samba(user类型){
passdb backend = tdbsam
passdb backend (用户后台)，samba有三种用户后台：smbpasswd, tdbsam和ldapsam

smbpasswd：该方式是使用smb工具smbpasswd给系统用户(真实用户或者虚拟用户)设置一个Samba 密码，
           客户端就用此密码访问Samba资源. smbpasswd在/etc/samba中，有时需要手工创建该文件
tdbsam：   使用数据库文件创建用户数据库。数据库文件叫passdb.tdb，在/etc/samba中。
            passdb.tdb用户数据库可使用smbpasswd –a创建Samba用户，要创建的Samba用户必须先是系统用户。
            也可使用pdbedit创建Samba账户 pdbedit参数很多，列出几个主要的(必须用root权限)： 
            pdbedit -a username：新建Samba账户 
            pdbedit -x username：删除Samba账户 
            pdbedit -L：列出Samba用户列表，读取passdb.tdb数据库文件. 
            pdbedit -Lv：列出Samba用户列表详细信息 
            pdbedit -c “[D]” -u username：暂停该Samba用户账号 
            pdbedit -c “[]” -u username：恢复该Samba用户账号。
ldapsam：   基于LDAP账户管理方式验证用户。首先要建立LDAP服务，
            设置“passdb backend = ldapsam:ldap://LDAP Server” 
            load printers 和 cups options 两个参数用来设置打印机相关。

[share]
    valid users = admin1,admin2,@root # admin1和admin2系统用户，@root为系统用户组
[global]
    username map = /etc/samba/smbusers # 别名列表
}
samba(配置说明){
# 编辑配置文件 sudo vim /etc/samba/smb.conf , 做如下修改
#============================= Configuration start ============================
#============================== Global parameters =============================
# 配置Samba服务的运行方式，指定如何运行samba
# 1. 先设定好samba服务器全局的参数，对整个服务器有效
[global]
        # 与主机名称有关的设定信息
        workgroup     = WORKGROUP
# 语法：workgtoup = <工作组群>;
# 预设：workgroup = MYGROUP
# 说明：设定 Samba Server 的工作组
# samba服务是能够跨平台使用的，如果想要跨平台使用，让windows平台能够通过工作组看到samba上共享出来的目录的话，名称一定要是windows工作组的名称
# 例：workgroup = workgroup 和WIN2000S设为一个组，可在网上邻居可中看到共享。
        netbios name  = Samba
# 设置Samba服务器NetBIOS名称，默认使用该服务器的DNS名称的第一部分。
        server string = This is samba server share  # 当前samba服务在登录时的提示信息
# 语法：server string = <说明>;
# 预设：sarver string = Samba Server
# 说明：设定 Samba Server 的注释
# 其他：支持变量 t%-访问时间 I%-客户端IP m%-客户端主机名 M%-客户端域名 S%-客户端用户名
# 例：server string = this is a Samba Server 设定出现在Windows网上邻居的 Samba Server 注释为 this is a Samba Server

        # 与语系方面有关的设定项目喔，为何如此设定请参考前面的说明
        unix charset    = utf8
        display charset = utf8
        dos charset     = cp936
# display charset = 服务器的显示编码，一般与 unix charset 相同
# unix charset = linux服务器上面所用的编码
# dos charset = Windows 用户端的编码

        # 与登录档有关的设定项目，注意参数 (%m)
        log file = /var/log/samba/log.%m
# 语法：log file = <日志文件>;
# 预设：log file = /var/log/samba/%m.log
# 说明：设定 samba server 日志文件的储存位置和文件名(%m 为每个用户提供日志文件)
        max log size = 50  # 最大的日志文件大小，超过大小进行日志轮替
# 语法：max log size = <??KB>;
# 预设：max log size = 0
# 说明：设定日子文件的最大容量，单位KB 这里的预设值0代表不做限制。

        # 这裡才是与密码有关的设定项目哩！
        security = user
# 语法：security = <等级>;
# 预设：security = user
# 说明：设定访问 samba server 的安全级别共有四种：
# share---不需要提供用户名和密码。
# user----需要提供用户名和密码，而且身份验证由 samba server 负责。
        passdb backend = tdbsam
# 语法：passdb backend = <smbpasswd文件存储方式>  # 密码的加密方式
# 预设：passdb backend = tdbsam
# 说明：选项smbpasswd、tdbsam、ldapsam、mysql。一般不用修改，除非想使用其它方式
        host allow = 192.168. 127.
# 语法：hosts aoolw = <IP地址>; ...
# 预设：; host allow = 192.168.1. 192.168.2. 127.
# 说明：限制允许连接到 Samba Server 的机器，多个参数以空格隔开
# 例：hosts allow = 192.168.1. 192.168.0.1 表示允许 192.168.1 网段的机器网址为 192.168.0.1 的机器连接到自己的 samba server
        #guest account = guest
# 语法：guert account = <帐户名称>;
# 预设：guert account = pcguest
# 说明：设定访问 samba server 的来宾帐户(即访问时不用输入用户名和密码的帐户)，若设为pcguest的话则为默认为"nobody"用户。
# 例：guert account = andy 设定设定访问 samba server 的来宾帐户以andy用户登陆，则此登陆帐户享有andy用户的所有权限。
        #password level = 8
# 语法：password level = <位数>;
# username level = <位数>;
# 预设：password level = 8
        #username level = 8
# username level = 8
# 说明：设定用户名和密码的位数，预设为8位字符。
        #encrypt passwords = yes
# 语法：encrypt passwords = <yes/no>
# 预设：encrypt passwords = yse
# 说明：设定是否对samba的密码加密。
        #smb passwd file = /etc/samba/smbpasswd
# 语法：smb passwd file = <密码文件>;
# 预设：smb passwd file = /etc/samba/smbpasswd
# 说明：设定samba的密码文件。

        #1、修改一下印表机的载入方式，不要载入啦！
        # 加载打印机(如果本机连接有打印机，是否自动的去加载它)
        load printers   = no
        #2、得要修改 load printers 的设定，然后新增几个资料
        #load printers = yes
        # 可支援来自 Windows 用户的列印工作
        #cups options  = raw
        # 下面这两个在告知使用 CUPS 列印系统
        # 对打印机的操作是读写操作
        #printcap name = cups
# 语法：printcap name = <打印机配置文件>;
# 预设：printcap name = /etc/printcap
# 说明：设定 samba srever 打印机的配置文件
# 例：默认设定 samba srever 参考 /etc/printcap 档的打印机设定
        #printing      = cups
# 语法：printing = <打印机类型>;
# 预设：printing = lprng
# 说明：设定 samba server 打印机所使用的类型，为目前所支持的类型

#============================== Share Definitions =============================
# 2. 打印机方面设定：
# 印表机一定要写 printers 喔！
#[printers]
         # 注释说明
         #comment = All Printers
         # 预设把来自 samba 的列印工作暂时放置的伫列
         #path    = /var/spool/samba<==
         # 不被外人所浏览啦！有权限才可浏览
         #browseable = no
         # 与底下两个都不许访客来源与写入(非档桉系统)
         #guest ok   = no
         # 是否允许可写共享当与read only发生冲突时，无视read only
         #writable   = no
         # 是否允许打印
         #printable  = yes

# 3. 资源分享方面设定
[homes]
        comment        = Home Directories
        browseable     = yes       # 目录是否被网上邻居可见
# 如果=no，共享出来的文件夹是看不到的，但是这个共享文件是存在的，在访问是要使用\\ip地址\文件夹名才能访问，提高安全性
        writable       = yes      # 对共享目录的权限可写
        create mode    = 0664
        directory mode = 0775
        valid users    = %S
# 使用者本身的"家"目录，当使用者以samba使用者身份登入samba server 后，samba server 底下会看到自己的家目录，目录名称是使用者自己的帐号。
[public]
        comment    = smbuser public
        path       = /root/download
        browseable = yes
        writable   = yes
        write list = @users
[temp]
        comment    = Temporary file space
        path       = /tmp  # 共享目录路径
        writable   = yes # 允许所有用户以写入的方式进行访问
        browseable = yes # no 网上邻居不可见
        guest ok = yes  # 有访问权限才能有写入之类的权限


valid users = zhangsan[,lisi,@zhangsan] #  合法用户，只有声明的用户和组才能登录指定的共享目录，用户名不在valid后面的登录不了 @组名 指定组 
write list = 用户名[,@组名] #  合法用户中，那些用户拥有写权限
read only = yes #  所有用户只读访问
writable = yes #  允许所有用户可以写入 


# comment---------注释说明
# path------------分享资源的完整路径名称，除了路径要正确外，目录的权限也要设对
# browseable------是yes/否no在浏览资源中显示共享目录，若为否则必须指定共享路径才能存取
# printable-------是yes/否no允许打印
# hide dot ftles--是yes/否no隐藏隐藏文件
# public----------是yes/否no公开共享，若为否则进行身份验证(只有当security = share 时此项才起作用)
# guest ok--------是yes/否no公开共享，若为否则进行身份验证(只有当security = share 时此项才起作用)
# read only-------是yes/否no以只读方式共享当与writable发生冲突时也writable为准
# writable--------是yes/否no不以只读方式共享当与read only发生冲突时，无视read only
# vaild users-----设定只有此名单内的用户才能访问共享资源(拒绝优先)(用户名/@组名)
# invalid users---设定只有此名单内的用户不能访问共享资源(拒绝优先)(用户名/@组名)
# read list-------设定此名单内的成员为只读(用户名/@组名)
# write list------若设定为只读时，则只有此设定的名单内的成员才可作写入动作(用户名/@组名)
# create mask-----建立文件时所给的权限
# directory mask--建立目录时所给的权限
# force group-----指定存取资源时须以此设定的群组使用者进入才能存取(用户名/@组名)
# force user------指定存取资源时须以此设定的使用者进入才能存取(用户名/@组名)
# allow hosts-----设定只有此网段/IP的用户才能访问共享资源
# allwo hosts = 网段 except IP
# deny hosts------设定只有此网段/IP的用户不能访问共享资源
# allow hosts=本网段指定IP指定IP
# deny hosts=指定IP本网段指定IP
}


samba(Samba设定的变量)(
Samba配置文件中可以使用的变量
%S  当前服务名（如果存在）
%L  Samba服务器的NetBIOS名
%P  当前服务的根目录（如果存在）
%N  NIS服务器主机名
%u  当前服务的用户名（如果存在）
%p  NIS服务器家目录
%g  当前用户的初始组
%R  采用协议等级
%U  当前连接的用户名
%d  Samba服务的进程ID
%G  当前连接用户的初始组
%a  访问Samba服务器的客户端系统
%D  当前用户所属域或工作组名称
%I  访问Samba服务器的客户端IP地址
%H  当前服务用户的家目录
%M  访问Samba服务器的客户端主机名
%v  Samba服务器的版本
%m  访问Samba服务器的客户端NetBIOS名
%h  Samba服务器的主机名
%T  Samba服务器日期及时间
)

samba(/etc/samba/smb.conf){
    Linux上开放Samba共享目录时，可以通过/etc/samba/smb.conf配置文件的guest account、create mask和directory mask属性，来设置写入共享目录
中的文件或目录的用户权限。
[yysmb01]  
    comment = yynfs01  
    path = /mnt/yyfs/smbsrv01  
    valid users = smbuser1 nisuser1 nisuser2 nisuser3  
    write list = nisuser2 smbuser1  
    read only = No  
    create mask = 0666  
    directory mask = 0777

但是如下设置，smbuser1创建的文件，nisuser2却无法读写
更新如下配置即可：
[yysmb01]  
    comment = yynfs01  
    path = /mnt/yyfs/smbsrv01  
    valid users = smbuser1 nisuser1 nisuser2 nisuser3  
    write list = nisuser2 smbuser1  
    read only = No  
    create mask = 0666  
    force create mode = 0666  
    directory mask = 0777  
    force directory mode = 0777 
    
create mode             – 这个配置定义新创建文件的属性。Samba在新建文件时，会把dos文件的权限映射成对应的unix权限，在映射后所得的
                          权限，会与这个参数所定义的值进行与操作。然后再和下面的force create mode进行或操作，这样就得到最终linux下
                          的文件权限。
force create mode       – 见上面的描述。相当于此参数所设置的权限位一定会出现在文件属性中。
directory mode          – 这个配置与create mode参数类似，只是它是应用在新创建的目录上。Samba在新建目录时，会把dos–>linux映射后的
                          文件属性，与此参数所定义的值相与，再和force directory mode相或，然后按这个值去设置目录属性。
force directory mode    – 见上面的描述。相当于此参数中所设置的权限位一定会出现在目录的属性中。

}

Security(Security=User){
useradd -d /home/smbuser1 -msmbuser1
ls /home/
passwd smbuser1
smbpasswd -a smbuser1

smb.conf(){
[yysmb01]
    comment =yynfs01
    path =/mnt/hyyfs/nfs01
    createmask = 0664
    directorymask = 0775
    writeable= no
    validusers = nisuser01,nisuser02,nisuser03,smbuser1
    write list= nisuser02,smbuser1

[yysmb02]
    comment =yynfs02
    path =/mnt/hyyfs/nfs02
    writeable= yes
    public =yes
    guest ok =yes
}

检查配置参数
testparm -v

服务器端需要为smbuser1开放权限。在服务器端执行如下设置：
[root@node1 ~]# chown smbuser1:smbuser1 /mnt/hyyfs/nfs01/ -R

}