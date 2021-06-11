用户管理
    Linux用户信息保存在/etc/passwd,
    用户密码信息保存在/etc/shadow,
    用户组信息保存在/etc/group,
    用户组密码信息保存在/etc/gshadow中.

下面我们以手工创建一个用户为例,了解上述各文件的结构.

ug(手工新建用户){

    手工新建用户流程 :
        新建所需要的用户组 (vim /etc/group)
        将/etc/group与/etc/gshadow同步 (grpconv)
        新建用户信息 (vim /etc/passwd)
        将/etc/passwd与/etc/shadow同步 (pwconv)
        新建用户密码 (passwd username)
        新建用户主文件夹 (cp -a /etc/skel /home/username)
        更改用户主文件夹属性 (chown -R username:groupname /home/username)
        检查设置 (pwck)
    
具体步骤:

1.新建所需的用户组  (vim /etc/group)
在最后一行加入一条用户组信息(其由4个字段组成, 组名:用户组密码(通常在/etc/gshadow设置,不设置以x表示)
:GID(通常500以下保留给系统,新建的用户组用现有最大GID+1):用户组成员)
比如加入一条用户组信息
normal:x:1001:

2.将/etc/group与/etc/gshadow同步 (grpconv)
我们使用grpconv将在/etc/group加入的用户组信息同步到/etc/gshadow中.
/etc/gshadow的结构也由4个字段组成,组名:密码列(开头以!表示不合法密码):用户组管理员:组员
比如加入一条用户组密码信息(grpconv会同步创建)
normal:*::

3.新建用户信息 (vim /etc/passwd)
同样我们在最后一行加入一条用户信息,(由7个字段组成,用户名:用户密码(也由/etc/shadow中代替)
:UID(通常500以下为系统账号,100以下为系统默认创建,root=0):GID(初始用户组):备注:用户主目录:shell)
比如加入一条用户信息
myuser:x:1000:1002::/home/myuser:/bin/bash

4.将/etc/passwd与/etc/shadow同步 (pwconv)
pwconv将/etc/passwd的用户信息同步到/etc/shadow中,/etc/shadow由9个字段组成,用户名:用户密码(通常由MD5加密后):
最近密码修改的时间(以天数为单位,后面的字段也是):密码可再次修改的最短时间:
密码需要重新修改的时间:密码需重新修改的提醒时间(以上个字段为基准):
密码过期后的宽限时间:账号失效时间(过了这个时间,账号就失效):保留

比如下面这条用户密码信息(pwconv会帮我们创建,其会去参考/etc/default/useradd与/etc/login.defs)
myuser:$6$4EZkAqYO$ghF87vQWxWAB17Z05OFQrCNfPrkWpceUhSzmxXHQ57hvH/U4PvVPs7r
tzRAt17VNMYcUD2yhdGgZirNGqX6Il.:17000:0:99999:7::::

5.新建用户密码 (passwd username)
新建密码我们使用工具passwd来信息

6.新建用户主文件夹 (cp -a /etc/skel /home/username)
当然我们可以直接新建/home/username,但是我们有些默认的文件想在用户创建时就给予用户,
通常会将/etc/skel文件给用户,系统创建时也是将/etc/skel的文件给与用户
(同样,这个操作系统参考/etc/default/useradd的配置),所以我们可以将文件加到/etc/skel中

7.更改用户主文件夹属性及权限 (chown -R username:groupname /home/username 与chmod)
将用户主文件夹及子文件都改成用户所属


8.检查设置 (pwck)
pwck会报出设置错误信息

}


ug(用户管理工具){
1.2.1 新建用户 : useradd

useradd会参考/etc/default/useradd与/etc/login.defs文件来新建用户,其会去修改上述的/etc/passwd等4个文件

/etc/default/useradd的默认配置(各系统可能不一样)

 GROUP=100    # 默认的初始用户组
 HOME=/home  # 用户主文件夹所在目录
 INACTIVE=-1   # 密码过期宽限时间(-1 表示密码过期后永远不失效)
 EXPIRE=          # 账号失效时间
 SKEL=/etc/skel # 用户主文件夹参考目录
 CREATE_MAIL_SPOOL=no # 不创建用户邮件邮箱
 SHELL=/bin/sh   #默认的shell

/etc/login.defs的默认配置(各系统可能不一样)

PASS_MAX_DAYS   99999  #密码需要重新修改的时间
PASS_MIN_DAYS  0  # 密码可再次修改的最短时间
PASS_MIN_LEN  5  # 密码最短长度,已失效,被PAM模块代替(PAM是Linux下应用程序需要鉴定功能的调用的API)
PASS_WARN_AGE 7 #密码需重新修改的提醒时间

UID_MIN   500  # 一般用户最小的UID,小于500被系统保留
UID_MAX  60000 # 一般用户最大的UID
GID_MIN 500  # 用户组最小GID,小于500被系统保留
GID_MAX 60000 # 用户组最大的GID

UMASK 077  # 用户主文件夹的默认权限

useradd的基本格式是: useradd [参数] 用户名
常用参数:

    m 强制创建用户主目录
    M 强制不创建用户主目录
    r 创建系统账号
    G 次要用户组,如果要添加用户组,也可以在这里指定 - aG
    s 指定shell
    d 指定用户主目录

1.2.2 修改用户 : usermod

usermod与useradd的参数类似, 这里列一些
参数:

    l 修改用户名,后接新的用户名
    L 冻结用户密码,使其无法登录(其实就是在/etc/shadow中的密码字段最前面加了!!)
    U 解冻用户

1.2.3 删除用户 : userdel

userdel -r 会删除用户相关数据,删除了/etc/passwd,/etc/shadow,/etc/group,/etc/gshadow相关数据与/home/username,/var/spool/mail/username
}

ug(用户密码管理工具){
1.3.1 修改用户密码 : passwd 与chpasswd

查看密码状态可以使用 passwd -S

其中如果想在shell script中输入用户密码可以
echo "Userpasswd" | passwd --stdin $username 或者 printf "Userpasswd\nUserpasswd\n" | passwd $username

chpasswd也是用来修改密码的,其格式一定要"username:password"这个形式,如下
echo "username:password" | chpasswd -m
-m 以MD5加密
1.3.2 修改用户密码时间 : chage

记住我们/etc/shadow中有关密码时间由很多字段吧,chage -l 可以更直观地列出这些字段的信息.
除外也可以用相关的参数去修改这些字段,如-d 修改最近一次改动密码的时间(如果我们想用户第一次登录系统后就要求其修改密码 可以 chage -d 0 username)
}

ug(用户组管理工具){
1.4.1 用户初始用户组与有效用户组

当用户创建会指定用户组(-g),那个用户就是初始用户组,也可以那么说,/etc/passwd中相关用户信息的那个用户组字段就是初始用户组

有效用户组就是当前用户作用的用户组,比如新建文件时的用户组信息等.

显示当前用户的用户组信息可以使用groups(第1个用户组为有效用户组)或者id

切换当前有效用户组 可以使用newgrp
1.4.2 新建用户组 : groupadd

-r 会修改系统用户组
1.4.3 修改用户组信息: groupmod

groupmod会去修改/etc/group相关字段
1.4.4 删除用户组:groupdel
1.4.5 用户组管理员:gpasswd

    添加用户组密码:gpasswd groupname
    删除用户组密码:gpasswd -r groupname
    添加用户组管理员(那么其可以执行gpasswd):gpasswd -A user1,user2.. groupname
    添加用户组成员:gpasswd -M user1,user2...groupname
    添加用户至用户组:gpasswd -a user1 groupname
    删除用户:gpasswd -d user1 groupname
}

ug(ACL权限){
ACL权限

ACL可以针对单一用户,单一用户组,单个文件进行rwx的权限设置.
2.1 启用ACL

查看你需要设置的文件对应的文件系统是否启用ACL功能.

首先查看文件系统的挂载情况:mount
比如我要设置的文件在/的文件系统下,其挂载至/dev/sda9,我们用dumpe2fs -h /dev/sda9的超级块的Default mount options情况.

如果没有acl功能,可以在/etc/fstab中options加入acl.这样开机就是启动acl.
2.2 设置ACL:setfacl

setfacl最常用的参数就是 -m,设置权限列表, 比如 -m u:user1:rx就是针对某目录设置user1可以rx权限
删除acl权限可以使用 -b

如果想某目录下所有文件都设置acl权限可以这样设置权限列表 -m d:u:user1:rx
2.3 查看ACL:getfacl

当我们文件设置setfacl后,ls查看的文件属性中权限字段会有个+,表示设置了acl权限.
如果要详细查看acl信息,使用getfacl
}

ug(用户身份切换工具){
切换用户:su

如果单纯使用su username来切换用户,系统会以non-login shell方式去读取用户相关环境变量(只会读取~/.bashrc),如果向使用login shell以完整的流程去读取用户相关的环境变量可以使用 su - username
3.2 以root身份去执行命令:sudo

一般用户想使用sudo,获取root身份去执行一次命令,需要此用户被选中为sudoer(要root在/etc/sudoers设置).
/etc/sudoers文件的格式

# Host alias specification

 # User alias specification
User_Alias ADMPW = kumho, jinhu  # 设置用户集合

 # Cmnd alias specification
Cmnd_Alias ADMPWCOM=!/usr/bin/passwd, !/usr/bin/passwd root, /usr/bin passwd [A-Za-z]*  # 设置命令集  命令一定要以绝对路径写

 # User privilege specification
 root    ALL=(ALL:ALL) ALL  # 用户   登录者的来源主机名=(可切换的身份:用户组) 命令
 ADMPW   ALL=(ALL:ALL) ADMPWCOM

 # Members of the admin group may gain root privileges
 %admin ALL=(ALL) ALL     #admin用户组成员都是sudoer
}
