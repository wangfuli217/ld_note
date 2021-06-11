#!/bin/bash
# 仅用于RPM或YUM安装的Vsftp服务
# 默认将随机产生的账号密码输出到脚本所在目录: Ftp_Users.txt

#账号（密码默认随机或修改循环中的"Password"）及FTP根路径
userlist=(shangftp wangftp)             
chroot_dir=/data

set -ex

yum -y install vsftpd psmisc net-tools systemd-devel libdb-devel perl-DBI

mkdir -p ${chroot_dir}

#身份检查
if [ $(id -u) != "0" ]
then
        echo -e "\033[1;40;31mError: You must be root to run this script \033[0m"
        exit 1
fi

#帐号和对应的随机密码
for username in ${userlist[@]}
do
        if id ${username} 2>&- ; then
                echo -e "\033[31m user ${username} already  exist...\033[0m" 
        else
                #统一密码需修改这里
                Password=${RANDOM}   
                useradd -d ${chroot_dir} -M ${username} -s /bin/nologin && echo $Password | passwd  ${username} --stdin 2>&-
                echo -e "$username   $Password" >> ./Ftp_Users.txt
                echo -e "\033[32m CREATE USER: ${username}\033[0m"
        fi
done

#查找配置文件路径
config_file=$(awk 'BEGIN{while("rpm -qc vsftpd"|getline)/vsftpd.conf/;print}')

#写入配置文件 (使用时需把注释去掉！否则报语法错误)
cat > ${config_file:-'/etc/vsftpd/vsftpd.conf'} <<eof
anon_world_readable_only=NO
anonymous_enable=NO
chroot_local_user=YES
guest_enable=NO
guest_username=ftp
hide_ids=YES
listen=YES
#listen_address=192.168.1.200
local_enable=YES
max_clients=500
max_per_ip=200
nopriv_user=ftp
pam_service_name=ftp
pasv_max_port=65535
pasv_min_port=64000
session_support=NO
use_localtime=YES
user_config_dir=/etc/vsftpd/users
userlist_enable=YES
userlist_file=/etc/vsftpd/denied_users
xferlog_enable=YES
anon_umask=0007
local_umask=0022
async_abor_enable=YES
connect_from_port_20=YES
dirlist_enable=NO
download_enable=NO
reverse_lookup_enable=NO
dual_log_enable=YES
vsftpd_log_file=/var/log/vsftpd.log
eof

#执行
[ -e /usr/bin/systemctl ] && {
        systemctl start vsftpd
        systemctl enable vsftpd
        systemctl status vsftpd
}

[ -e /usr/bin/systemctl ] || {
        chkconfig vsftpd --level 235 on
        service vsftpd start
}

exit 0

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# 注：
# 在文件/etc/vsftpd.ftpusers中的本地用户禁止登陆
# 当chroot_list_enable=YES，chroot_local_user=YES，在/etc/vsftpd.chroot_list文件中列出的用户，可以切换到其他目录
# 未在文件中列出的用户，不能切换到其他目录。

# 当chroot_list_enable=YES，chroot_local_user=NO，在/etc/vsftpd.chroot_list文件中列出的用户，不能切换到其他目录
# 未在文件中列出的用户，可以切换到其他目录。

# 当chroot_list_enable=NO，chroot_local_user=YES，所有的用户均不能切换到其他目录。
# 当chroot_list_enable=NO，chroot_local_user=NO，所有的用户均可以切换到其他目录。

# PORT：
# FTP客户端连接到FTP服务器的21端口，发送用户名和密码
# 登录成功后要list或读取数据时客户端随机开放一个端口（N>1024），发送 PORT命令到FTP服务器，告诉服务器客户端采用主动模式并开放端口
# 服务器收到PORT主动模式命令和端口号后，通过自身20端口和客户端开放的端口连接

# PASV：
# 中文成为被动模式，工作原理：FTP客户端连接到FTP服务器的21端口，发送用户名和密码
# 登录成功后要list或者读取数据时发送PASV命令到服务器， 服务器在本地随机开放一个端口（N>1024），然后把开放的端口告诉客户端
# 客户端再连接到服务器开放的端口进行传输