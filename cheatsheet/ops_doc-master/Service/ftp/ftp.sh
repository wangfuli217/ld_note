#!/bin/bash

yum install vsftpd -y
chkconfig --level 35 vsftpd on
useradd vsftpdadmin -s /sbin/nologin
useradd ftpuser -s /sbin/nologin

sed -i -e 's/^nonymous_enable.*/anonymous_enable=NO/g' \
       -e 's/^#chroot_list_enable.*/chroot_list_enable=YES/g' \
       -e 's/^#chroot_list_file.*/chroot_list_file=\/etc\/vsftpd\/chroot_list/g' \
       -e 's/^#async_abor_enable.*/async_abor_enable=YES/g' \
       -e 's/#ascii_upload_enable=YES/ascii_upload_enable=YES/g' \
       -e 's/#ascii_download_enable=YES/ascii_download_enable=YES/g' \
/etc/vsftpd/vsftpd.conf



echo  >> /etc/vsftpd/vsftpd.conf <<EOF
guest_enable=YES'
guest_username=ftpuser'
virtual_use_local_privs=YES'
user_config_dir=/etc/vsftpd/vconf
EOF

echo >> /etc/vsftpd/chroot_list <<EOF
$1
EOF



touch /var/log/vsftpd.log
chown vsftpdadmin.vsftpdadmin /var/log/vsftpd.log

mkdir /etc/vsftpd/vconf/
touch /etc/vsftpd/vconf/vir_user

echo > /etc/vsftpd/vconf/vir_user <<EOF
$1
$2
EOF

db_load -T -t hash -f /etc/vsftpd/vconf/vir_user /etc/vsftpd/vconf/vir_user.db
chmod 600 /etc/vsftpd/vconf/vir_user.db
chmod 600 /etc/vsftpd/vconf/vir_user
echo >> /etc/pam.d/vsftpd  <<EOF
auth    required    pam_userdb.so   db=/etc/vsftpd/vconf/vir_user
account required    pam_userdb.so   db=/etc/vsftpd/vconf/vir_user
EOF

touch /etc/vsftpd/vconf/$1
echo >/etc/vsftpd/vconf/$1 <<EOF
local_root=/home/$1
anonymous_enable=NO
write_enable=YES
local_umask=022
EOF

mkdir /home/$1
chown ftpuser.ftpuser /home/virtualuser
chmod 600 /home/virtualuser