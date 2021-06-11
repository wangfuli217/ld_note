#!/bin/bash

cat<<EOF
This inscrip is to install samba service!
EOF

# 判断系统是否安装samba server
if ! rpm -qa | grep -q samba;then
    echo "Samba not installed!"
    yum -y install samba samba-client
else
    echo "Samba installed!"
fi

# 创建samba用户
smb_passwd() {
    useradd $1 -s /sbin/nologin
    cd /etc/samba/
    touch smbpasswd
    printf "$2\n$2\n" | smbpasswd -a $1
    echo "Samba user $1 has been created!"
}

# 配置文件

config_smb() {
    mkdir -p $1
    :>/etc/samba/smb.conf
    cat > /etc/samba/smb.conf <<-EOF
[global]
workgroup = WORkGROUP
server string = Samba Server Version %v
security = user
passdb backend = tdbsam
load printers = yes
cups options = raw
[smbshare]
comment = smbshare
path = $1
browseable = yes
writable = yes
public = no
EOF
}


read -p "请输入samba用户名：" smb_user
stty -echo
read -p "请输入该用户密码：" psd
stty echo
echo
read -p "请输入samba服务目录：" smbpath

smb_passwd $smb_user $psd
config_smb $smbpath

systemctl start smb nmb
systemctl enable smb nmb