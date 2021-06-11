#!/bin/sh
### 编写一个用于添加新用户的脚本 ###

#1. 初始化和用户添加相关的变量。    
passwd_file="/etc/passwd"
shadow_file="/etc/shadow"
group_file="/etc/group"
home_root_dir="/home"
#2. 只有root用户可以执行该脚本。    
if [ "$(whoami)" != "root" ]; then
  echo "Error: You must be root to run this command." >&2
  exit 1
fi

echo "Add new user account to $(hostname)"
echo -n "login: "
read login
#3. 去唯一uid，即当前最大uid值加一。
uid=$(awk -F: '{ if (big < $3 && $3 < 5000) big = $3 } END {print big + 1}' $passwd_file)
#4. 设定新用户的主目录变量
home_dir="$home_root_dir/$login"
gid="$uid"
#5. 提示输入和创建新用户相关的信息，如用户全名和主Shell。
echo -n "full name: "
read fullname
echo -n "shell: "
read shell
#6. 将输入的信息填充到passwd、group和shadow三个关键文件中。
echo "Setting up account $login for $fullname..."
echo ${login}:x:${uid}:${gid}:${fullname}:${home_dir}:$shell >> $passwd_file
echo ${login}:*:11647:0:99999:7::: >> $shadow_file
echo "${login}:x:${gid}:$login" >> $group_file
#7. 创建主目录，同时将新用户的profile模板拷贝到新用户的主目录内。
#8. 设定该主目录的权限，再将其下所有文件的owner和group设置为新用户。
#9. 为新用户设定密码。
mkdir $home_dir
cp -R /etc/skel/.[a-zA-Z]* $home_dir
chmod 755 $home_dir
find $home_dir -print | xargs chown ${login}:${login}
passwd $login
exit 0

# /> ./test22.sh
# Add new user account to bogon
# login: stephen
# full name: Stephen Liu
# shell: /bin/shell
# Setting up account stephen for Stephen Liu...
# Changing password for user stephen.
# New password:
# Retype new password:
# passwd: all authentication tokens updated successfully.
      