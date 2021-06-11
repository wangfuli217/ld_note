#!/bin/bash

SAMBA_DATA_HOME="/samba_data"
SAMBA_USERS=(admin1 admin2 test)
DEFAULT_PASS="123456"

set -ex

setenforce 0
sed -i 's/^SELINUX=.*/SELINUX=disabled/g' /etc/sysconfig/selinux

yum -y install samba samba-client

#数据
mkdir -p ${SAMBA_DATA_HOME}/{Public,Develop}
chown nobody:nobody ${SAMBA_DATA_HOME}/Public
chmod -R a+w ${SAMBA_DATA_HOME}/Public

#配置
mv /etc/samba/smb.conf /etc/samba/smb.conf.default
cat > /etc/samba/smb.conf <<EOF
[global]
        workgroup = WORKGROUP
        server string = Samba Server %v
        netbios name = Samba
        security = user                         # share|user|server|domain
        map to guest = Bad User
        ;passdb backend = tdbsam                # 目前有3种用户后台：smbpasswd、tdbsam、ldapsam
        smb passwd file = /etc/samba/smbpasswd	# 定义samba用户密码文件，若不存在则手工创建
        encrypt passwords = yes
        guest account = nobody
        interfaces = lo eth0 0.0.0.0/0 EXCEPT 192.168.1.1
        hosts allow = 0.0.0.0/0.0.0.0
        hosts deny = All
        log file = /var/log/samba/log.%m        # 日志记录（%m：主机名，对每台访问的机器都单独记录一个日志）
        max log size = 50                       # max 50KB per log file, then rotate
        max connections = 0			# Samba Server的最大连接数目，0不限制
        deadtime = 0                            # 断掉一个没有打开任何文件的连接的时间，单位分钟，0代表不自动切断
        
[Public]
        comment = share some files
        available = yes
        path = ${SAMBA_DATA_HOME}/Public
        public = yes
        guest ok = yes
        browseable = yes
        writeable = yes
        create mask = 0644
        directory mask = 0755

[Develop]
        comment = project development directory
        available = yes
        path = ${SAMBA_DATA_HOME}/Develop
        public = no
        valid users = admin1,admin2,@root
        ;invalid users =
        readonly = no
        printable = no
        create mask = 0644
        directory mask = 0755
        ;writeable = no
        ;write list =  admin1,admin2,@root

EOF

groupadd samba 2> /dev/null

for user in ${SAMBA_USERS[@]}
{
    if ! id $user &> /dev/null ;then
        useradd  $user -G samba -M -s /sbin/nologin
    fi
    echo -e "${DEFAULT_PASS}\n${DEFAULT_PASS}" | smbpasswd -s -a $user
    [[ "$?" == "0" ]] && echo "create samba user: $user"
}

systemctl start smb
systemctl enable smb

function firewall_set() {
    firewall-cmd --permanent --add-port=139/tcp
    firewall-cmd --permanent --add-port=445/tcp
    systemctl restart firewalld
}

firewall_set &> /dev/null

# smbpasswd 删除：-x，禁用/启用：-e <username>
# smbstatus 查看连接

# smbpasswd使用smb自己的工具smbpasswd为系统用户设置Samba账号&密码，文件默认在/etc/samba
# tdbsam使用库文件建立用户：passdb.tdb，默认/etc/samba。passdb.tdb
# 用户数据库可使用smbpasswd –a建立，要建立的用户必须先是系统用户
# 挂载： mount -t cifs //192.168.174.138/share  /mnt -o username=**,password=**
# 列出某个IP地址所提供的共享文件夹： smbclient -L 198.168.0.1 -U username%password

exit 0

