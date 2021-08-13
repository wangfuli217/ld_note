# rsync服务器的配置文件rsyncd.conf
rsync的主要有以下三个配置文件:
rsyncd.conf(主配置文件)
rsyncd.secrets(密码文件)
rsyncd.motd(rysnc服务器信息)
服务器配置文件(/etc/rsyncd/rsyncd.conf)，该文件默认不存在，请创建：
mkdir /etc/rsyncd && touch /etc/rsyncd/rsyncd.conf && touch /etc/rsyncd/rsyncd.secrets && touch /etc/rsyncd/rsyncd.motd

# vi /etc/rsyncd.conf 

uid = root
gid = root
use chroot = no
max connections = 10
strict modes =yes
port = 873
pid file = /var/run/rsyncd.pid
lock file = /var/run/rsync.lock
log file = /var/log/rsyncd.log

[user]
path = /data/DATA/smc/interface/logs/user_visit_daily/
comment = This is a test
ignore errors
read only = yes
hosts allow = 10.13.81.125
[dc]
path = /data/DATA/smc/interface/logs/dc/
comment = This is a test
ignore errors
read only = no
hosts allow = 10.13.81.47
#hosts allow = 10.10.70.155

rsync -azv --update yd125@10.13.81.130::user /opt/smc/activeuser/ > /dev/null 2>&1

--------------------------------------------------------------------------------
!!! 删除全文注释
######### 全局配置参数 ##########
port=873    # 指定rsync端口。默认873
uid = rsync # rsync服务的运行用户，默认是nobody，文件传输成功后属主将是这个uid
gid = rsync # rsync服务的运行组，默认是nobody，文件传输成功后属组将是这个gid
use chroot = no # rsync daemon在传输前是否切换到指定的path目录下，并将其监禁在内
max connections = 200 # 指定最大连接数量，0表示没有限制
timeout = 300         # 确保rsync服务器不会永远等待一个崩溃的客户端，0表示永远等待
motd file = /var/rsyncd/rsync.motd   # 客户端连接过来显示的消息
pid file = /var/run/rsyncd.pid       # 指定rsync daemon的pid文件
lock file = /var/run/rsync.lock      # 指定锁文件
log file = /var/log/rsyncd.log       # 指定rsync的日志文件，而不把日志发送给syslog
dont compress = *.gz *.tgz *.zip *.z *.Z *.rpm *.deb *.bz2  # 指定哪些文件不用进行压缩传输
# address 10.1.4.44 # 指定服务器IP地址
# log format = %t %a %m %f %b
###########下面指定模块，并设定模块配置参数，可以创建多个模块###########
[longshuai]        # 模块ID
path = /longshuai/ # 指定该模块的路径，该参数必须指定。启动rsync服务前该目录必须存在。rsync请求访问模块本质就是访问该路径。
ignore errors      # 忽略某些IO错误信息
read only = false  # 指定该模块是否可读写，即能否上传文件，false表示可读写，true表示可读不可写。所有模块默认不可上传
write only = false # 指定该模式是否支持下载，设置为true表示客户端不能下载。所有模块默认可下载
list = false       # 客户端请求显示模块列表时，该模块是否显示出来，设置为false则该模块为隐藏模块。默认true
hosts allow = 192.168.10.0/24 # 指定允许连接到该模块的机器，多个ip用空格隔开或者设置区间
hosts deny = 0.0.0.0/32   # 指定不允许连接到该模块的机器
auth users = rsync_backup # 指定连接到该模块的用户列表，只有列表里的用户才能连接到模块，用户名和对应密码保存在secrts file中，
                          # 这里使用的不是系统用户，而是虚拟用户。不设置时，默认所有用户都能连接，但使用的是匿名连接
secrets file = /etc/rsyncd.passwd # 保存auth users用户列表的用户名和密码，每行包含一个username:passwd。由于"strict modes"
                                  # 默认为true，所以此文件要求非rsync daemon用户不可读写。只有启用了auth users该选项才有效。
[xiaofang]    # 以下定义的是第二个模块
path=/xiaofang/
read only = false
ignore errors
comment = anyone can access

--------------------------------------------------------------------------------
useradd -r -s /sbin/nologin rsync
mkdir /{longshuai,xiaofang}
chown -R rsync.rsync /{longshuai,xiaofang}

echo "rsync_backup:123456" >> /etc/rsyncd.passwd
chmod 600 /etc/rsyncd.passwd 

rsync --daemon


echo "123456" > /tmp/rsync_passwd
rsync --list-only --port 888 rsync_backup@192.168.10.107::longshuai/a/b --password-file=/tmp/rsync_passwd
或者
rsync --list-only rsync://rsync_backup@192.168.10.107:888/longshuai/a/b --password-file=/tmp/rsync_passwd

# 周期性同步
crontab -e:
# m h  dom mon dow   command
  0 3   *   *   *    /usr/local/bin/rsync_backup.sh --verbose

