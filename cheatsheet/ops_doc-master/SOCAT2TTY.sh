EXAMPLE FOR REMOTE TTY (TTY OVER TCP) USING SOCAT

You have a host with some serial device like a modem or a bluetooth interface
(modem server)
You want to make use of this device on a different host. (client)

1) on the modem server start a process that accepts network connections and
links them with the serial device /dev/tty0:

$ socat tcp-l:54321,reuseaddr,fork file:/dev/tty0,nonblock,waitlock=/var/run/tty0.lock

2) on the client start a process that creates a pseudo tty and links it with a
tcp connection to the modem server:

$ socat pty,link=$HOME/dev/vmodem0,waitslave tcp:modem-server:54321

NETWORK CONNECTION

There a some choices if a simple TCPv4 connection does not meet your
requirements:
TCPv6: simply replace the "tcp-l" and "tcp" keywords with "tcp6-l" and "tcp6"
Socks: if a socks server protects the connection, you can replace the
"tcp:modem-server:54321" clause with something like
"socks:socks-server:modem-server:54321" or 
"socks:socks-server:modem-server:54321,socksport=1081,socksuser=nobody"

SECURITY

SSL
If you want to protect your server from misuse or your data from sniffing and
manipulation, use a SSL connection with client and server authentication
(currently only over TCPv4 without socks or proxy). 
See <a href="socat-openssl.txt">socat-openssl.txt</a> for instructions.

IP Addresses
!!! bind=...
!!! range=...
!!! lowport (for root)
!!! sourceport
!!! tcpwrap=

FULL FEATURES
$ socat -d -d ssl-l:54321,reuseaddr,cert=server.pem,cafile=client.crt,fork file:/dev/tty0,nonblock,echo=0,raw,waitlock=/var/run/tty0.lock

TROUBLESHOOTING
-v -x



./socat tcp-l:54321,reuseaddr,fork file:/dev/ttyS0,nonblock,raw,echo=0,crnl,waitlock=/var/run/tty

while true; do ~/Develop/socat-1.4.3.0/socat pty,link=$HOME/dev/vmodem0,raw,echo=0,waitslave tcp:192.168.0.132:54321; done

socat -,icanon=0,echo=0,min=0,ignbrk=0,brkint,isig,crlf $HOME/dev/vmodem0


// server:
socat tcp-l:54321,reuseaddr,fork file:/dev/ttyS0,nonblock,raw,echo=0,waitlock=/var/run/tty

// clients:
while true; do socat pty,link=$HOME/dev/vmodem0,raw,echo=0,waitslave tcp:192.168.0.132:54321; done

// interactive test:
socat -,icanon=0,echo=0,min=0,isig,icrnl=0 $HOME/dev/vmodem0