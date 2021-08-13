http://www.tiejiang.org/13945.html
# EXAMPLE说明更清楚

chmod u+x /etc/init.d/vsftpd 
chkconfig --add vsftpd 
chkconfig vsftpd on

ftp(rpm){
/etc/logrotate.d/vsftpd     # 日志轮转备份配置文件
/etc/pam.d/vsftpd           # PAM认证文件（此文件中file=/etc/vsftpd/ftpusers字段，指明阻止访问的用户来自/etc/vsftpd/ftpusers文件中的用户）
/etc/init.d/vsftpd          #
/etc/vsftpd/ftpusers        # 默认的vsftpd黑名单
/etc/vsftpd/user_list       # 可以通过主配置文件设置该文件为黑名单或白名单
# 禁止或允许使用vsftpd的用户列表文件。这个文件中指定的用户缺省情况（即在/etc/vsftpd/vsftpd.conf中设置
# userlist_deny=YES）下也不能访问FTP服务器，在设置了userlist_deny=NO时,仅允许user_list中指定的用户访问FTP服务器。
/etc/vsftpd/vsftpd.conf     # vsftpd主配置文件
/usr/sbin/vsftpd            # vsftpd主程序
/usr/share/doc/vsftpd-2.2.2 # vsftpd文档资料路径
/var/ftp                    # 默认vsftpd共享目录
# 匿名用户主目录；本地用户主目录为：/home/用户主目录，即登录后进入自己家目录
/var/ftp/pub                #匿名用户的下载目录，此目录需赋权根chmod 1777 pub（1为特殊权限，使上载后无法删除）

/etc/rc.d/init.d/vsftpd   # 初始化脚本
/etc/pam.d/vsftpd         # PAM认证配置
/etc/vsftpd/vsftpd.conf   # vsftpd的配置文件
/etc/vsftpd/ftpusers/     # 不允许登录vsftpd的用户列表
/etc/vsftpd/user_list     # 根据/etc/vsftpd/vsftpd.conf中的 userlist_deny 配置YES或NO，来设定允许或阻止登录的用户列表
/var/ftp/ 分享的文件，    # /var/ftp/pub/目录提供给匿名用户
}        

ftp(模式){
主动模式/PORT
    客户端发起请求，链接服务端port 21，客户端port N为大于1024的随机端口
    服务端port 21响应客户端
    服务端打开port 20链接客户端port N+1
    客户端响应，开始传输数据

被动模式/PASV
    客户端发起请求，链接服务端port 21，客户端port N为大于1024的随机端口
    服务端port 21响应客户端
    服务端打开大于1024的随机端口，客户端使用port N+1链接服务端打开的端口
    服务端响应，开始传输数据
}
https://github.com/jiobxn/one/wiki/00029_vsftpd%E4%BB%8B%E7%BB%8D
ftp(vsftpd.conf [全局设置]){
listen=YES             # 是否监听端口，独立运行守护进程，(独立模式即不通过xinetd启动vsftpd，vsftpd监听接口和接收连接)
listen_address=x.x.x.x # 监听其他ip (独立模式下，vsftpd监听的IP地址，以数字方式提供)
listen_port=21         # 监听入站FTP请求的端口号 (独立模式下，vsftpd监听的端口)

# [权限]
write_enable=YES       # 是否允许写入操作命令(是否支持STOR, DELE, RNFR, RNTO, MKD, RMD, APPE and SITE)
download_enable=YES    # NO，则拒绝所有的下载请求
dirlist_enable=YES     #如果设置为NO，所有目录列表命令会给权限被拒绝

# [欢迎]
1. 进入新目录显示
dirmessage_enable=YES #如果启用，在用户登录时将显示其宿主目录下的.message文件内容 
message_file=.message #进入一个新的目录时,显示该目录下.message文件内容
2. 登录显示
ftpd_banner=Welcome to blah FTP service. # 登录FTP服务器时显示的欢迎信息
                                         # 如有需要，可在更改目录欢迎信息的目录下创建名为.message的文件，并写入欢迎信息保存后
banner_file=/etc/vsftpd/hello.txt        #登录显示内容,如果两者冲突，banner_file生效

# [日志]
syslog_enable          # 是否将原本输出到/var/log/vsftpd.log中的日志，输出到系统日志
dual_log_enable        # YES生成两个日志文件 ( /var/log/xferlog | /var/log/vsftpd.log)
# xferlog.log
xferlog_enable=YES     # 让系统自动维护上传和下载的日志文件， 日志文件通过xferlog_file配置
xferlog_file=/var/log/vsftpd.log #设定系统维护记录FTP服务器上传和下载情况的日志文件
                       # /var/log/vsftpd.log是默认的，也可以另设其它
xferlog_std_format=YES # Xferlog日志文件格式；是否以标准xferlog的格式书写传输日志文件
log_ftp_protocol=YES   # xferlog_std_format没有使能的条件下，记录所有请求和应答日志 (用于debug)
# vsftpd.log
vsftpd_log_file=/var/log/vsftpd.log #这个选项是给我们写的vsftpd风格日志，前提xferlog_enable启用，xferlog_std_format禁用 dual_log_enable使能
log_ftp_protocol=NO #当启用时，所有的FTP请求和响应记录，前提xferlog_std_format没有启用

# [连接设置]
# PORT
port_enable=YES #允许主动模式连接（PORT指定数据传输接口） 
connect_from_port_20=YES #是否允许服务器主动模式从20端口建立数据连接 
ftp_data_port=20 #指定主动模式的端口号 
connect_timeout=60 #连接超时，远程客户端的响应主动（PORT）方式的数据连接 
port_promiscuous=YES #使用安全的port模式 

pasv_promiscuous=YES #使用安全的pasv模式 
accept_timeout=60 #连接超时，远程客户端以被动（PASV）方式数据连接建立连接 

data_connection_timeout=300 #数据连接后、数据连接等待的时间 超时剔除 
delete_failed_uploads=NO #如果启用，任何失败，上传文件将被删除 
trans_chunk_size=0 #智能限速 
async_abor_enable=YES #设定支持异步传输功能
connect_from_port_20=YES #使用主动模式连接，启用20端口 # 是否设定FTP服务器将启用FTP数据端口的连接请求;ftp-data数据传输，21为连接控制端口
pasv_enable=YES        # 是否启用被动模式连接，默认为被动模式
pasv_max_port=24600    # 被动模式连接的最大端口号
pasv_min_port=24500    # 被动模式连接的最小端口号
max_clients=2000       # 最大允许同时2000客户端连接，0代表无限制
max_per_ip=0           # 每个客户端最大连接限制，0代表无限制
tcp_wrappers=YES       # 是否启用tcp_wrappers
guest_enable=YES       # 如果为YES，则所有的非匿名登录都映射为guest_username指定的账户
guest_username=ftp     # 设定来宾账户
user_config_dir=/etc/vsftp/conf #指定目录，在该目录下可以为用户设置独立的配置文件与选项
anonymous_enable=YES   # 是否开启匿名访问功能，默认设置为YES允许，默认是/var/ftp
                       # 用户可使用用户名ftp或anonymous进行ftp登录，口令为用户的E-mail地址。
idle_session_timeout=600 # 即当数据传输结束后，用户连接FTP服务器的时间不应超过600秒。可以根据实际情况对该值进行修改
data_connection_timeout=120 # 设置数据连接超时时间，该语句表示数据连接超时时间为120秒，可根据实际情况对其个修改
nopriv_user=ftpsecure  # 运行vsftpd需要的非特权系统用户，缺省是nobody
ascii_upload_enable=YES     #启用ASCII方式上传数据
ascii_download_enable=YES   #启用ASCII方式下载数据


ls_recurse_enable=YES     # 是否允许递归查询。默认为关闭，以防止远程用户造成过量的I/O
                          # 当启用时，此设置将允许使用的“ls -R” 指令
pasv_addr_resolve=YES     # 如果你想使用一个主机名（而不是IP地址） 
pasv_address=example.com  # 提供一个主机名 ,DNS能解析到
use_localtime=YES         #如果启用，vsftpd将显示目录列表，在当地时区的时间。默认是显示GMT
cmds_allowed=无           #此选项指定一个逗号分隔的列表允许FTP命令 
cmds_denied=无            #此选项指定一个逗号分隔的列表拒绝FTP命令 
deny_file=无              #此选项可以用来设置文件名模式（和目录名等），不应该以任何方式访问，支持正则表达式
}
ftp(vsftpd.conf [匿名账户]){
anonymous_enable=YES        #是否允许匿名登录
anon_root=/var/ftp          # 匿名访问FTP的根路径，默认是/var/ftp
anon_upload_enable=YES      # 是否允许匿名用户上传文件，须将全局的write_enable=YES。默认为YES
anon_mkdir_write_enable=YES # 是否允许匿名用户创建新文件夹
anon_other_write_enable=YES # 匿名用户将被允许上传和创建目录，删除和重命名等其他执行写操作
anon_world_readable_only=YES #当启用时，将只允许匿名用户下载文件
anon_max_rate=0             # 限制匿名用户的最大传输速率（0为无限制），单位为字节
anon_umask=077              # 设置匿名用户所上传文件的默认权限掩码值（允许下载）
ftp_username=ftp            #匿名FTP的用户名，此用户的主目录是匿名FTP区域的根 
chown_uploads=NO            #如果启用，所有匿名上传的文件将改为在设置中指定的用户所有权 
chown_username=root         #指定的用户 
nopriv_user=nobody          #一个完全没有特权的用户名称，用于匿名用户映射
}
ftp(vsftpd.conf[本地账户]){

local_enable=YES           # 是否启用本机账户FTP功能
                           # 本地用户登录后会进入用户主目录，而匿名用户登录后进入匿名用户的下载目录/var/ftp/pub
                           # 若只允许匿名用户访问，前面加上#注释掉即可阻止本地用户访问FTP服务器
local_max_rate=0           # 本地账户数据传输速度
local_umask=077            # 本地账户权限掩码; 掩码，本地用户默认掩码为077
chroot_local_user=YES      # 是否禁锢本地账户根目录
local_root=/ftp/common     # 本地账户访问FTP根路径

dirmessage_enable=YES      # 是否激活目录欢迎信息功能
                           # 当用户用CMD模式首次访问服务器上某个目录时，FTP服务器将显示欢迎信息
                           # 默认情况下，欢迎信息是通过该目录下的.message文件获得的
                           # 此文件保存自定义的欢迎信息，由用户自己建立
chown_uploads=YES          # 设定是否允许改变上传文件的属主，与下面一个设定项配合使用
                           # 注意，不推荐使用root用户上传文件
chown_username=whoever     # 设置想要改变的上传文件的属主，如果需要，则输入一个系统用户名
                           # 可以把上传的文件都改成root属主。whoever：任何人
                           
max_login_fails=5 #多次登录失败后，将被禁止 
local_root=无 #设置本地用户的FTP根目录 
deny_email_enable=NO #如果启用，将拒绝用户用邮箱登陆 
banned_email_file=/etc/vsftpd/banned_emails #指定邮箱登陆的用户 
chmod_enable=YES #是否允许本地用户改变ftp服务器上文件的权限 
check_shell=YES #如果禁用，vsftpd将不会检查/etc/shells中的本地登录的有效的用户shell 
chroot_local_user=NO #禁锢本地用户在主目录 
chroot_list_enable=NO #禁锢chroot_list列表的用户；NO则不禁用 
chroot_list_file=/etc/vsftpd/chroot_list #指定chroot_list文件 
# 上面两条禁锢策略，如果同设置为YES或NO而且该本地用户又在chroot_list列表，则不禁锢 
userlist_enable=YES  #允许user_list用户列表文件 
userlist_deny=YES #禁止user_list列表文件中的用户帐号，等于NO 仅允user_list用户许登录，如果两者同时存在，则拒绝优先 
userlist_file=/etc/vsftpd/file #指定user_list文件 
pam_service_name=vsftpd #启用pam认证，禁止/etc/vsftpd/ftpusers中的用户登录 
#禁止/etc/vsftpd/ftpgroup组用户登录：vim /etc/pam.d/vsftpd # …… 
item=group …… file=/etc/vsftpd/ftpgroup ……
}
ftp(vsftpd.conf[SSL加密]){
ssl_enable=NO               #如果启用，vsftpd将支持通过SSL安全连接，总开关；这适用于控制连接（包括登录）和数据连接。你需要一个支持SSL的客户端
allow_anon_ssl=NO           #如果设置为YES，匿名用户将被允许使用安全的SSL连接
ssl_sslv2=NO                #如果启用，将允许SSL V2协议的连接。TLS V1连接是首选
ssl_sslv3=NO                #如果启用，将允许SSL V3协议的连接，TLS V1连接是首选
ssl_tlsv1=YES               #默认TLS V1连接是首选
strict_ssl_read_eof=NO          #如果启用，SSL数据上传需要通过SSL
strict_ssl_write_shutdown=NO    #如果启用SSL数据，下载需要通过SSL
force_anon_logins_ssl=NO        #如果启用，所有匿名用户被迫使用安全的SSL连接，以发送密码
force_anon_data_ssl=NO          #如果启用，所有匿名用户被迫使用安全的SSL连接，以发送和接收数据连接上的数据
force_local_data_ssl=NO         #如果启动，所有的非匿名登录被强制使用安全SSL连接，以发送和接收数据连接上的数据
force_local_logins_ssl=NO       #如果启动，所有的非匿名登录被强制使用安全SSL连接，以发送密码
dsa_cert_file=无         #这个选项指定了DSA证书的位置，使用SSL加密连接
dsa_private_key_file=无          #这个选项指定使用SSL加密连接的DSA私钥的位置。如果未设置此选项，私钥预计将在相同的文件证书
rsa_cert_file=/usr/share/ssl/certs/vsftpd.pem       #此选项指定的RSA证书使用SSL加密连接的位置
rsa_private_key_file=无                #此选项指定使用SSL加密连接的RSA私钥的位置。如果未设置此选项，私钥预计将在相同的文件证书
ssl_ciphers=DES-CBC3-SHA               #此选项可用于选择vsftpd的SSL加密允许加密的SSL连接
require_ssl_reuse=NO                   #如果设置为yes，所有SSL数据连接需要表现出SSL会话重用（这证明他们知道控制通道相同的主密钥）
debug_ssl=NO                           #如果启用，OpenSSL的连接诊断转储到vsftpd的日志文件
}                   

ftp(限制最大连接数和传输速率){
max_client设置项 用于设置FTP服务器所允许的最大客户端连接数，值为0时表示不限制。例如max_client=100表示FTP服务器的所有客户端最大连接数不超过100个。
max_per_ip设置项 用于设置对于同一IP地址允许的最大客户端连接数，值为0时表示不限制。例如max_per_ip=5表示同一IP地址的FTP客户机与FTP服务器建立的最大连接数不超过5个。
local_max_rate设置项 用于设置本地用户的最大传输速率，单位为B/s，值为0时表示不限制。例如local_max_rate=500000表示FTP服务器的本地用户最大传输速率设置为500KB/s.
anon_max_rate设置项 用于设置匿名用户的最大传输速率，单位为B/s,值为0表示不限制。例如ano_max_rate=200000，表示FTP服务器的匿名用户最大传输速率设置为200KB/s.
}

ftp(指定用户的权限设置){
vsftpd.user_list文件需要与vsftpd.conf文件中的配置项结合来实现对于vsftpd.user_list文件中指定用户账号的访问控制：
（1）设置禁止登录的用户账号
当vsftpd.conf配置文件中包括以下设置时，vsftpd.user_list文件中的用户账号被禁止进行FTP登录：
    userlist_enable=YES
    userlist_deny=YES
userlist_enable设置项设置使用vsftpd.user_list文件，userlist_deny设置为YES表示vsftpd.user_list文件用于
设置禁止的用户账号。

（2）设置只允许登录的用户账号
当vsftpd.conf配置文件中包括以下设置时，只有vsftpd.user_list文件中的用户账号能够进行FTP登录：
    userlist_enable=YES
    userlist_deny=NO 
userlist_enable设置项设置使用vsftpd.user_list文件，userlist _deny设置为NO表示vsftpd.usre_list文件用于设置
只允许登录的用户账号，文件中未包括的用户账号被禁止FTP登录。

userlist_enable=YES 	ftpusers中用户允许访问
                        user_list中用户允许访问
userlist_enable=NO 	    ftpusers中用户禁止访问
                        user_list中用户允许访问
userlist_deny=YES 	    ftpusers中用户禁止访问（登录时可以看到密码输入提示，但仍无法访问）
                        user_list 中用户禁止访问
userlist_deny=NO 	    ftpusers中用户禁止访问
                        user_list中用户允许访问 

userlist_enable=YES 并且userlist_deny=YES 	ftpusers中用户禁止访问
                                            user_list中用户禁止访问（登录时不会出现密码提示，直接被服务器拒绝）
userlist_enable=YES 并且userlist_deny=NO 	ftpusers中用户禁止访问
                                            user_list中用户允许访问
}

ftp(修改默认端口){
默认FTP服务器端口号是21，出于安全目的，有时需修改默认端口号，修改/etc/vsftpd/vsftpd.conf，添加语句(例)：
listen_port=4449
语句指定了修改后FTP服务器的端口号，应尽量大于4000。修改后访问
#ftp 192.168.57.2 4449
注意这里需加上正确的端口号了，否则不能正常连接。
}

ftp(设置用户组){
有关FTP用户和用户组的重要性，我们在之前介绍vsftpd的时候便已经提到过。这里主要是简单的说明用户组的技术实现，至于具体如何应用，还是具体需求具体对待。

    #mkdir -p /home/try 递归创建新目录
    #groupadd try 新建组
    #useradd -g try -d /home/try try1 新建用户try1并指定家目录和属组
    #useradd -g try -d /home/try try2 新建用户try2并指定家目录和属组
    #useradd -g try -d /home/try try3 新建用户try3并指定家目录和属组
    #passwd try1 为新用户设密码
    #passwd try2 为新用户设密码
    #passwd try3 为新用户设密码
    #chown try1 /home/try 设置目录属主为用户try1
    #chown .try /home/try 设置目录属组为组try
    #chmod 750 /home/try 设置目录访问权限try1为读，写，执行；try2，try3为读，执行

由于本地用户登录FTP服务器后进入自己主目录，而try1,try2 try3对主目录/home/try分配的权限不同，
所以通过FTP访问的权限也不同，try1访问权限为：上传，下载，建目录；try2，try3访问权限为下载，
浏览，不能建目录和上传。实现了群组中用户不同访问级别，加强了对FTP服务器的分级安全管理。
    Idle_session_timeout=300
配置空闲的数据连接的中断时间：如下配置将在数据空闲连接1分钟后被中断，同样也是为了释放服务器的资源
    Data_connection_timeout=60
配置客户端空闲时的自动中断和激活连接的时间：如下配置将使客户端空闲1分钟后自动中断连接，并在30秒后自动激活连接
    Accept_timeout=60
    Connect_timeout=30
接下来，我们将对vsftpd的日志进行介绍。
}

ftp(vsftpd配置 - 构建可匿名上传的vsftpd服务器){ anonymous_enable=YES
1.设置目录权限
    chown  ftp.ftp  /var/ftp/pub
2.修改vsftpd.conf主配置文件,开放匿名用户访问及上传权限,禁止删除
    ~]# vim /etc/vsftpd/vsftpd.conf # 追加下面配置
    listen=YES
    listen_address=192.168.27.125
    listen_port=21
    write_enable=YES
    download_enable=YES
    dirmessage_enable=YES
    dirlist_enable=YES
    userlist_enable=YES
    userlist_deny=YES
# 匿名用户配置
    anonymous_enable=YES        # 允许匿名访问模式
    write_enable=YES            # 
    anon_umask=022              # 匿名用户上传文件的umask值
    anon_upload_enable=YES      # 允许匿名用户上传文件
    anon_mkdir_write_enable=YES # 允许匿名用户创建目录
    anon_other_write_enable=NO  # 允许匿名用户修改目录名称或删除目录
    anon_root=/var/ftp

3.防火墙与Selinux相关
    iptables -F
    getsebool -a |grep ftp
    chcon -t public_content_rw_t /var/ftp/pub
    setsebool -P allow_ftpd_anon_write 1
    systemctl restart vsftpd
    
    setsebool -P ftpd_full_access=on
    
    chown root:root /var/ftp       # 用于浏览的目录
    chmod -R 755 /var/ftp          # 用于浏览的目录
    chmod -R 0777 /var/ftp/pub     # 用于上传数据的目录

4.  Name (192.168.10.10:root): anonymous 
    331 Please specify the password. 
    Password:此处敲击回车即可

{ anonymous_enable #匿名总开关
allow_anon_ssl       # ssl_enable有效之后才有效
force_anon_data_ssl  # ssl_enable有效之后才有效
anon_mkdir_write_enable  # write_enable有效之后才有效(如果设置为YES，匿名用户将被允许在一定条件下创建新目录，匿名FTP用户必须具有对父目录的写权限)
anon_other_write_enable # (匿名用户将被允许上传和创建目录，删除和重命名等其他执行写操作)
anon_upload_enable      # (如果设置为YES，匿名用户将被允许在一定条件下上传文件)
anon_world_readable_only # (当启用时，将只允许匿名用户下载文件)
no_anon_password         # 匿名登录不要求密码
anon_max_rate           # 匿名最大速率
anon_umask              # 匿名umask
anon_root               # 设置匿名用户的FTP根目录（缺省为/var/ftp/）
ftp_username=ftp #匿名FTP的用户名，此用户的主目录是匿名FTP区域的根
}
}

ftp(vsftpd配置 - 构建本地用户验证的vsftpd服务器){  local_enable=YES
1.修改vsftpd.conf配置文件,启用本地用户访问,并可以结合user_list文件灵活控制用户访问

~]# vim /etc/vsftpd/vsftpd.conf # 追加到此文件
listen=YES
listen_address=192.168.27.125
listen_port=21
download_enable=YES
userlist_enable=YES
userlist_deny=YES
max_clients=0
max_per_ip=0
# 本地用户配置
local_enable=YES
local_umask=0022
write_enable=YES
local_max_rate=0
max_login_fails=5
chmod_enable=YES
check_shell=YES
chroot_local_user=YES  # 本地用户禁锢在宿主目录中
chroot_list_enable=YES # 是否将系统用户限止在自己的home目录下
chroot_list_file=/etc/vsftpd/chroot_list # 列出的是不chroot的用户的列表
# 上面两条禁锢策略，如果同设置为YES或NO而且该本地用户又在chroot_list列表，则不禁锢
userlist_enable=YES
userlist_deny=YES
#启用pam认证，禁止/etc/vsftpd/ftpusers中的用户登录 
pam_service_name=vsftpd

    2.创建测试用户并设置密码

useradd user1
password user1

    3.防火墙与Selinux相关：

iptables -F
setsebool -P allow_ftpd_full_access 1
setsebool -P ftp_home_dir 1
#本地用户的FTP根目录默认是自己的home
systemctl restart vsftpd

{ local_enable=YES
check_shell=YES #如果禁用，vsftpd将不会检查/etc/shells中的本地登录的有效的用户shell
chmod_enable    # 
chroot_local_user=NO #禁锢本地用户在主目录
chroot_list_enable # #禁锢chroot_list列表的用户；NO则不禁用
chroot_list_file=/etvsftpd.confc/vsftpd.chroot_list
local_root=无 #设置本地用户的FTP根目录
user_sub_token=无 #它是用来为每个虚拟用户的主目录
force_local_data_ssl    # sl_enable有效之后才有效
force_local_logins_ssl  # sl_enable有效之后才有效
local_max_rate
local_umask=077
}
}

ftp(vsftpd配置 - 构建基于虚拟用户的vsftpd服务器){ guest_enable=YES
1.建立虚拟用户；奇数行是用户名，偶数行是密码

cat > /etc/vsftpd/vuser.txt << END
vsftpd
password
admin
password
public
password
wordpress
password
END

2.生成数据库文件并设置权限
    db_load -T -t hash -f /etc/vsftpd/vuser.txt /etc/vsftpd/vuser.db
    chmod 600 /etc/vsftpd/vuser.*

3.创建FTP虚拟用户映射的系统用户
    useradd -d /usr/local/vsftpd -s /sbin/nologin vsftpd

4.编辑/etc/pam.d/vsftpd文件，建立支持虚拟用户的PAM认证文件 # 替换
    #%PAM-1.0
    auth sufficient /lib64/security/pam_userdb.so db=/etc/vsftpd/vuser
    account sufficient /lib64/security/pam_userdb.so db=/etc/vsftpd/vuser

    快捷修改

sed -i '2iauth sufficient /lib64/security/pam_userdb.so db=/etc/vsftpd/vuser' /etc/pam.d/vsftpd
sed -i '3iaccount sufficient /lib64/security/pam_userdb.so db=/etc/vsftpd/vuser' /etc/pam.d/vsftpd

    5.在vsftpd.conf文件中添加相关配置
cat >> /etc/vsftpd/vsftpd.conf << END
#pasv_enable=NO
guest_enable=YES
guest_username=vsftpd
pam_service_name=vsftpd
user_config_dir=/etc/vsftpd/conf
virtual_use_local_privs=NO
allow_writeable_chroot=YES
ftpd_banner=Serv-U FTP Server v16.0 ready…
use_localtime=YES
chroot_local_user=YES
delete_failed_uploads=YES
anon_root=/usr/local/vsftpd/admin/public/pub
anon_umask=022
pasv_min_port=25000
pasv_max_port=25100
END

6.为用户public、admin建立独立的配置目录及文件，配置文件名与用户名同名
    mkdir /etc/vsftpd/conf
    
    #可上传、下载、删除
    cat >> /etc/vsftpd/conf/vsftpd << END
write_enable=YES
anon_upload_enable=YES
anon_world_readable_only=NO
local_root=/usr/local/vsftpd
anon_mkdir_write_enable=YES
anon_other_write_enable=YES
END

    #可上传、下载、删除
    mkdir /usr/local/vsftpd/admin
    cat > /etc/vsftpd/conf/admin << END
write_enable=YES
anon_upload_enable=YES
anon_world_readable_only=NO
local_root=/usr/local/vsftpd/admin
anon_mkdir_write_enable=YES
anon_other_write_enable=YES
END

    #可上传、下载
    mkdir /usr/local/vsftpd/admin/public
    cat > /etc/vsftpd/conf/public << END
anon_world_readable_only=NO
anon_upload_enable=YES
local_root=/usr/local/vsftpd/admin/public
anon_mkdir_write_enable=YES
anon_other_write_enable=NO
END

    #可上传、下载、删除
    mkdir /usr/local/vsftpd/wordpress
    cat > /etc/vsftpd/conf/wordpress << END
write_enable=YES
anon_upload_enable=YES
anon_world_readable_only=NO
local_root=/usr/local/vsftpd/wordpress
anon_mkdir_write_enable=YES
anon_other_write_enable=YES
END

    #匿名用户只可下载
    mkdir /usr/local/vsftpd/admin/public/pub

7.目录权限与SELinux
    chown -R vsftpd.vsftpd /usr/local/vsftpd
    setsebool -P allow_ftpd_full_access 1
    setsebool -P ftpd_full_access=on
    setsebool -P ftp_home_dir 1

8.防火墙设置
    systemctl restart iptables
    iptables -I INPUT -m state --state NEW -m tcp -p tcp --dport 20 -j ACCEPT
    iptables -I INPUT -m state --state NEW -m tcp -p tcp --dport 21 -j ACCEPT
    iptables -I INPUT -m state --state NEW -m tcp -p tcp --dport 25000:25100 -j ACCEPT
    iptables-save > /etc/sysconfig/iptables
    
    cat >> /etc/sysconfig/iptables-config << END
IPTABLES_MODULES="ip_conntrack_ftp"
IPTABLES_MODULES="ip_nat_ftp"
END

9.重启服务
    systemctl restart iptables
    systemctl restart vsftpd
    systemctl enable vsftpd

10.最终效果：
    vsftpd：可读可写可删除  
    admin：可读可写可删除  
    public：可读可写  
    wordpress：可读可写可删除  
    匿名用户：可下载
    
{ guest_enable
guest_username=ftp
user_sub_token
}
}

ftp(vsftpd配置 - 使用Openssl 加密){ ssl_enable=YES
1.查看是否支持openssl
ldd /usr/sbin/vsftpd |grep libssl
    libssl.so.10 => /usr/lib64/libssl.so.10 (0x00007f5b55805000)

    2.生成加密的pem文件
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/vsftpd/vsftpd.pem -out /etc/vsftpd/vsftpd.pem

#OR
cd /etc/pki/tls/certs
make vsftpd.pem && cp vsftpd.pem  /etc/vsftpd/

    3.设置支持FTPS
    编辑/etc/vsftpd/vsftpd.conf文件，添加

ssl_enable=YES
allow_anon_ssl=YES
force_local_logins_ssl=YES
force_local_data_ssl=YES
ssl_tlsv1=YES
rsa_cert_file=/etc/vsftpd/vsftpd.pem
ssl_ciphers=HIGH

    重启服务

systemctl restart vsftpd
}
ftp(常见的vsftpd日志解决方案){
在vsftpd.conf中有如下内容定义了日志的记录方式：
    # 表明FTP服务器记录上传下载的情况
    xferlog_enable=YES
    # 表明将记录的上传下载情况写在xferlog_file所指定的文件中，即xferlog_file选项指定的文件中
    xferlog_std_format=YES
    xferlog_file=/var/log/xferlog
    # 启用双份日志。在用xferlog文件记录服务器上传下载情况的同时，
    # vsftpd_log_file所指定的文件，即/var/log/vsftpd.log也将用来记录服务器的传输情况
    dual_log_enable=YES
    vsftpd_log_file=/var/log/vsftpd.log

    
vsftpd的两个日志文件分析如下：
/var/log/xferlog
记录内容举例
    Thu Sep 6 09:07:48 2007 7 192.168.57.1 4323279 /home/student/phpMyadmin-2.11.0-all-languages.tar.gz b -i r student ftp 0 * c 
/var/log/vsftpd.log
记录内容举例
    Tue Sep 11 14:59:03 2007 [pid 3460] CONNECT: Client "127.0.0.1"
    Tue Sep 11 14:59:24 2007 [pid 3459] [ftp] OK LOGIN;Client "127.0.0.1" ,anon password "?"  
    

FTP命令                         功能 	                        FTP命令 	                    功能
ls 	                            显示服务器上的目录 	            ls [remote-dir][local-file] 	显示远程目录remote-dir，并存入本地文件local-file
get remote-file [local-file] 	从服务器下载指定文件到客户端 	mget remote-files 	下载多个远程文件(mget命令允许用通配符下载多个文件)
put local-file [remote-file] 	从客户端上传指定文件到服务器 	mput local-file 	将多个文件上传至远程主机(mput命令允许用通配符上传多个文件)
open 	                        连接FTP服务器 	                mdelete [remote-file] 	删除远程主机文件
close 	                        中断与远程服务器的ftp会话（与open对应） 	mkdir dir-name 	在远程主机中创建目录
open host[port] 	            建立指定的ftp服务器连接，可指定连接端口 	newer file-name 	如果远程主机中file-name的修改时间比本地硬盘同名文件的时间更近，则重传该文件
cd directory 	                改变服务器的工作目录 	         rename [from][to] 	更改远程
lcd directory 	                在客户端上(本地)改变工作目录 	pwd 	显示远程主机的当前工作目录
bye 	                        退出FTP命令状态 	            quit 	同bye,退出ftp会话
ascii 	                        设置文件传输方式为ASCII模式 	reget remote-file [local-file] 	类似于get,但若local-file存在，则从上次传输中断处续传
binary 	                        设置文件传输方式为二进制模式 	rhelp [cmd-name] 	请求获得远程主机的帮助
![cmd [args]] 	                在本地主机中交互shell后退回到ftp环境，如:!ls *.zip 	rstatus [file-name] 	若未指定文件名，则显示远程主机的状态，否则显示文件状态
accout [password] 	            提供登录远程系统成功后访问系统资源所需的密码 	hash 	每传输1024字节，显示一个hash符号（#）
append local-file [remote-file] 将本地文件追加到远程系统主机，若未指定远程系统文件名，则使用本地文件名 	restart marker 	从指定的标志marker处，重新开始get或put，如restart 130
bye 	                        退出ftp会话过程 	rmdir dir-name 	删除远程主机目录
case 	                        在使用mget命令时，将远程主机文件名中的大写转为小写字母 	size file-name 	显示远程主机文件大小，如：
size idle 7200
cd remote-dir 	                进入远程主机目录 	status 	显示当前ftp状态
cdup 	                        进入远程主机目录的父目录 	system 	显示远程主机的操作系统
delete remote-file 	            删除远程主机文件 	user user-name [password][account] 	向远程主机表明自己的身份，需要密码时，必须输入密码，如:user anonymous my@email
dir [remote-dir][local-file] 	显示远程主机目录，并将结果存入本地文件 	help [cmd] 	显示ftp内部命令cmd的帮助信息，如help get
}

匿名开放模式：是一种最不安全的认证模式，任何人都可以无需密码验证而直接登录到FTP服务器。
本地用户模式：是通过Linux系统本地的账户密码信息进行认证的模式，相较于匿名开放模式更安全，而且配置起来也很简单。但是如果被黑客破解了账户的信息，就可以畅通无阻地登录FTP服务器，从而完全控制整台服务器。
虚拟用户模式：是这三种模式中最安全的一种认证模式，它需要为FTP服务单独建立用户数据库文件，虚拟出用来进行口令验证的账户信息，而这些账户信息在服务器系统中实际上是不存在的，仅供FTP服务程序进行认证使用。这样，即使黑客破解了账户信息也无法登录服务器，从而有效降低了破坏范围和影响。


ftp(FTP数字代码的意义){
110 重新启动标记应答。
120 服务在多久时间内ready。
125 数据链路端口开启，准备传送。
150 文件状态正常，开启数据连接端口。
200 命令执行成功。
202 命令执行失败。
211 系统状态或是系统求助响应。
212 目录的状态。
213 文件的状态。
214 求助的讯息。
215 名称系统类型。
220 新的联机服务ready。
221 服务的控制连接端口关闭，可以注销。
225 数据连结开启，但无传输动作。
226 关闭数据连接端口，请求的文件操作成功。
227 进入passive mode。
230 使用者登入。
250 请求的文件操作完成。
257 显示目前的路径名称。
331 用户名称正确，需要密码。
332 登入时需要账号信息。
350 请求的操作需要进一部的命令。
421 无法提供服务，关闭控制连结。
425 无法开启数据链路。
426 关闭联机，终止传输。
450 请求的操作未执行。
451 命令终止:有本地的错误。
452 未执行命令:磁盘空间不足。
500 格式错误，无法识别命令。
501 参数语法错误。
502 命令执行失败。
503 命令顺序错误。
504 命令所接的参数不正确。
530 未登入。
532 储存文件需要账户登入。
550 未执行请求的操作。
551 请求的命令终止，类型未知。
552 请求的文件终止，储存位溢出。
553 未执行请求的的命令，名称不正确。
}