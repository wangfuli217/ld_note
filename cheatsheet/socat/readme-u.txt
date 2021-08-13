socat [OPTIONS] address1 address2

address = keyword;required parameters;address options:
address = keyword:param1:param2,option1,option2,...

# e.g. netcat, rinetd, rlwrap, socks/proxy clients, stunnel, ser2net

#####  netcat Replacement #####
# 1. CLIENT/SERVER MODEL
1. TCP client:
    nc 192.168.10.109 8003                   #TCP 1.stdin, 2. connect( address=192.168.10.109 port=8003 )
    socat - tcp-connect:192.168.10.109:8003  #TCP 1.stdin, 2. connect( address=192.168.10.109 port=8003 )
2. UDP client with source port:
    nc ­u ­p 500 192.168.10.109 500          #UDP 1.stdin, 2. bind(srcport=500) send( address=500 dstport=500 )
    socat ­ udp:192.168.10.109:500,sp=500    #UDP 1.stdin, 2. bind(srcport=500) send( address=500 dstport=500 )
3. TCP server:
    nc ­l 8003                               #TCP 1.stdout, 2. bind(srcport=8003)
    socat ­ tcp­l:8003,reuseaddr             #TCP 1.stdout, 2. bind(srcport=8003) setopt(reuseaddr)
4. UPD server:
    nc -u -l 192.168.10.109 500              #UDP 1.stdout, 2.  bind(srcport=500 address=192.168.10.109)
    socat - udp-l:500,bind=192.168.10.109    #UDP 1.stdout, 2.  bind(srcport=500 address=192.168.10.109)
# 2. DATA TRANSFER
5. Server & Client
    nc -l 1234 > filename.out               #TCP 1. bind( srcport=1234 ) 2. filename.out
    nc 192.168.10.109 1234 < filename.in    #TCP 1. connect( address=192.168.10.109 port=1234 ) 2. filename.in

    socat -u TCP4-LISTEN:1234,reuseaddr,fork OPEN:/tmp/in.log,creat,append #TCP 1.bind( srcport=1234 ) setopt(reuseaddr), fork 2.open(/tmp/in.log, creat|append)
    socat tcp4-connect:192.168.10.109:1234 open:/etc/hosts                 #TCP 1.connect( address=192.168.10.109 port=1234 ) 2. open(/etc/hosts)

# 3. TALKING TO SERVERS
    nc -l 8003 > filename.out                                  #TCP 1. bind( srcport=8003 ) 2. filename.out
    echo -n "GET / HTTP/1.0\r\n\r\n" | nc 192.168.10.109 8003  #TCP 1.connect( address=192.168.10.109 port=8003) 2. pipe
    nc 192.168.10.109 8003 << EOF                              #TCP 1.connect( address=192.168.10.109 port=8003) 2. 即插即用文本
           HELO host.example.com
           MAIL FROM: <user@host.example.com>
           RCPT TO: <user2@host.example.com>
           DATA
           Body of email.
           .
           QUIT
           EOF
# 4. PORT SCANNING
    nc -z 192.168.10.109 20-30                # 1.connect( address=192.168.10.109 port=20-30) 2. test
    echo "QUIT" | nc host.example.com 20-30   # 1.connect( address=192.168.10.109 port=20-30) 2. pipe("QUIT")

# 5. UNIX socket
    nc -lU /var/tmp/dsocket
    
5. TCP server with direct script:
    nc ­l ­p 7000 ­e /bin/cat
    socat tcp­l:7000,reuseaddr exec:"/bin/cat",nofork

#####  Address Types #####
1. existing file descriptors:
fd:3
2. open files, devices, named pipes:
open:hello.txt
open:/dev/tty
create:newfile
3. readline ('bash' line editor):
readline,history=$HOME/.http_history
4. run program in subshell:
system:'while read ...; do ...; done',pipes
5. proxy connect client: 
proxy:proxy.local:www.remote.com:443
6. socks4, socks4a client: 
socks:socks.local:www.remote:80
7. OpenSSL client, server:
ssl:www.local:443,verify=ssl­l:443,cert=./s

8. IP v4 and v6:
tcp6:www.harakiri.jp:80
udp:[::1]:123 # autodetects IP vers.
socks4:socks.local:www:80 # '4' is not IPv4!
ssl­l:443,pf=ip6,cert=...
9. UNIX domain stream client, server
unix­connect:/tmp/.X11­unix/X0
unix­listen:$HOME/dev/socket1,fork
10. UNIX domain datagram sender, receiver
unix­sendto:/dev/log
unix­recv:/dev/log
unix­recvfrom:$HOME/dev/askmewhat,fork
11. Abstract UNIX sockets: all above types, e.g.:
abstract­connect:/tmp/dbus­aL7CFhBj5I

12. “generic open” for file etc, or UNIX socket:
gopen:data.csv
gopen:/tmp/X11­unix/X0 /dev/log
13. UDP sender, receiver:
udp­sendto:host:123
udp4­recv:514
udp6­recvfrom:123,fork
udp­datagram:host:port
14. similar for raw IP protocols:
ip4­sendto:host:53
15. creates unnamed and named pipes:
pipe pipe:./named.pipe
16. creates ptys:
pty,link=$HOME/dev/pty0


#####  Address Variants #####
unidirectional mode (-u: left to right, -U: reverse):
socat ­u stdin stdout
combine two addresses to one dual address:
stdout%stdin   (socat V1: stdin!!stdout)
fork mode with most listening/receiving sockets:
tcp4­l:80,fork
udp6­recvfrom:123,fork
retry: don't exit on errors, but loop:
tcp4­l:8080,retry=10,intervall=7.5
some clients with fork or retry:
tcp:www.domain.com:80,fork,forever,intervall=60
ignoreeof: EOF does not trigger shutdown (tail -f):
open:/var/log/messages.log,ignoreeof

#####  Address Options #####
to each address, many options can be applied.
“option groups“ determine if an option can be used with an 
address
FD (FD type may be unknown) e.g. locks, uid
open flags (with open() call)
named (file system entry related), ext2/ext3/reiserfs attrs
process options (setuid, chroot)
readline (history file), termios
application level (EOL conv, readbytes)
socket, IP, TCP, DNS resolver options
socks, HTTP connect parameters (socksuser)
listen, range, child, fork, retry
OpenSSL

option examples:
perm=700
bind=192.168.0.1:54321
proxy­auth=hugo:s3cr3t
intervall=1.5
alias names vs. canonical names:
debug so­debug
async o­async
maxseg tcp­maxseg
canonical namespace related to C language:
C defines: O_ASYNC, ECHO, bind()
socat options: o­async, echo, bind
address and option keywords are case insensitive


##### openssl #####
server:
socat ssl­listen:8888,reuseaddr,fork,cert=server.pem,cafile=client.crt   <some­address1>
client:
socat <some­address2> ssl­connect:hostname:8888,cert=client.pem,cacert=client.crt