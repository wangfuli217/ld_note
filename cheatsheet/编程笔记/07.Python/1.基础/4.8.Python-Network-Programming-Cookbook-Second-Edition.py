hostName=socket.gethostname()               #该函数没有参数，返回所在主机或本地主机的名字  string
IpAddress=socket.gethostbyname(hostName)    #该函数接受一个参数hostname，返回对应的IP地址  string

try:
    print("IP address is %s " %socket.gethostbyname(remoteHost))
except socket.error as err_msg:
    print("%s:%s" %(remoteHost,err_msg))
#1. 如果执行函数gethostbyname()的过程中出现了错误，这个错误将有try-except块处理
#2. 该调用会阻塞执行过程，
#3. 该调用只返回一个IPAddress，有时候一个域名可能对应多个IP地址

socket.gethostbyname(remoteHost) # (name, aliaslist, addresslist) 真名，别名序列，地址序列

packedIPAddr=socket.inet_aton(IPAddr)        # IPAddr = '192.168.0.1'   32-bit packed binary format string
unpackedIPAddr=socket.inet_ntoa(packedIPAddr)#　packedIPAddr -> IPAddr  string

socket.getservbyport(port,protocolname)      # 53 udp | 53 tcp

儒家宪政与中国未来
孔子消失国 家才能复兴
https://github.com/cdpinfo
https://github.com/5fan/5fan

红太阳是如何升起的
革命年代
