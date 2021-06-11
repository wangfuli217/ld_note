#!/bin/bash

echo "安装必要的包！"; yum -y install vsftpd db4* pam*
echo "Configuring!"
echo "建立虚拟账号相关的系统账号"
useradd virftp -s /sbin/nologin
echo "建立虚拟账户相关的文件vsftpd_login"
cat > /etc/vsftpd/vsftpd_login <<-EOF
test1
123456
test2
123456
EOF
chmod 600 /etc/vsftpd/vsftpd_login

echo "生成对应的库文件："
db_load -T -t hash -f /etc/vsftpd/vsftpd_login /etc/vsftpd/vsftpd_login.db
echo "建立虚拟账号相关的目录和配置文件"
mkdir -p /etc/vsftpd/vsftpd_user_conf && cd /etc/vsftpd/vsftpd_user_conf 

echo "为test1用户配置权限"
cat > /etc/vsftpd/vsftpd_user_conf/test1.conf <<-EOF
local_root=/home/virftp/test1
anonymous_enable=NO
write_enable=YES
local_umask=022
anon_upload_enable=NO
anon_mkdir_write_enable=NO
idle_session_timeout=600
data_connection_timeout=120
max_clients=10
max_per_ip=5
local_max_rate=50000
EOF

mkdir -p /home/virftp/test1
touch /home/virftp/test1/hellotest1.txt
chown -R virftp.virftp /home/virftp

sed -ie '1s#^#auth sufficient /lib64/security/pam_userdb.so db=/etc/vsftpd/vsftpd_login\naccount sufficient /lib64/security/pam_userdb.so db=/etc/vsftpd/vsftpd_login\n#'  /etc/pam.d/vsftpd

>/etc/vsftpd/vsftpd.conf
cat > /etc/vsftpd/vsftpd.conf <<-EOF
anonymous_enable=NO
local_enable=YES
write_enable=YES
local_umask=022
anon_upload_enable=NO
anon_mkdir_write_enable=NO
dirmessage_enable=YES
xferlog_enable=YES
connect_from_port_20=YES
xferlog_file=/var/log/vsftpd.log
xferlog_std_format=YES
nopriv_user=virftp
async_abor_enable=YES
ascii_upload_enable=YES
ascii_download_enable=YES
ftpd_banner=Welcome to FTP service.
listen=YES
chroot_local_user=YES
pam_service_name=vsftpd
userlist_enable=YES
tcp_wrappers=YES
guest_enable=YES
guest_username=virftp
virtual_use_local_privs=YES
user_config_dir=/etc/vsftpd/vsftpd_user_conf
allow_writeable_chroot=YES
EOF

echo "开始启动ftp服务！"
systemctl start vsftpd && systemctl enable vsftpd

[ $? -eq 0 ] && echo "启动成功！"