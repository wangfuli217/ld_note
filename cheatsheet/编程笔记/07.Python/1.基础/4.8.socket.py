socket(socket_family , socket_type, protocol =0)  
tcpSock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
udpSock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM) 

# 服务器套接字方法 
s.bind()          将地址（主机名、端口号对）绑定到套接字上 
s.listen()        设置并启动 TCP 监听器 
s.accept()        被动接受 TCP 客户端连接，一直等待直到连接到达（阻塞） 
# 客户端套接字方法 
s.connect()       主动发起 TCP 服务器连接 
s.connect_ex()    connect() 的扩展版本，此时会以错误码的形式返回问题，而不是抛出一个异常 
# 普通的套接字方法 
s.recv()          接收TCP 消息 
s.recv_into()     接收TCP 消息到指定的缓冲区
s.send()          发送TCP 消息 
s.sendall()       完整地发送 TCP 消息 
s.recvfrom()      接收UDP 消息 
s.recvfrom_into() 接收UDP 消息到指定的缓冲区 
s.sendto()        发送UDP 消息 
s.getpeername()   连接到套接字（TCP）的远程地址 
s.getsockname()   当前套接字的地址 
s.getsockopt()    返回给定套接字选项的值 
s.setsockopt()    设置给定套接字选项的值 
s.shutdown()      关闭连接 
s.close()         关闭套接字 
s.detach()        在未关闭文件描述符的情况下关闭套接字，返回文件描述符 
s.ioctl()         控制套接字的模式（仅支持 Windows） 
# 面向阻塞的套接字方法 
s.setblocking()     设置套接字的阻塞或非阻塞模式 
s.settimeout()      设置阻塞套接字操作的超时时间 
s.gettimeout()      获取阻塞套接字操作的超时时间 
# 面向文件的套接字方法 
s.fileno()          套接字的文件描述符 
s.makefile()        创建与套接字关联的文件对象 
数据属性   
s.family            套接字家族 
s.type              套接字类型 
s.proto             套接字协议

# TCP服务器模式
ss = socket()               #  创建服务器套接字     socket(AF_INET, SOCK_STREAM)
ss.bind()                   #  套接字与地址绑定     tcpSerSock.bind(ADDR) ADDR->(HOST = '', PORT = 21567)
ss.listen()                 #  监听连接             tcpSerSock.listen(5)
inf_loop :                  #  服务器无限循环 
    cs = ss.accept()        #  接受客户端连接       tcpCliSock, addr = tcpSerSock.accept()
    comm_loop:              #  通信循环 
        cs.recv()/cs.send() #  对话（接收/发送）    tcpCliSock.recv(BUFSIZ) | tcpCliSock.send('[%s] %s' % (ctime(), data))
    cs.close()              #  关闭客户端套接字 
ss.close()                  #  关闭服务器套接字

# TCP客户机模式
cs = socket()               # 创建客户端套接字      socket(AF_INET, SOCK_STREAM)
cs.connect()                # 尝试连接服务器        tcpCliSock.connect(ADDR) ADDR->(HOST = '127.0.0.1', PORT = 21567)
comm_loop:                  # 通信循环 
    cs.send()/cs.recv()     # 对话（发送/接收）     tcpCliSock.send(data) | tcpCliSock.recv(BUFSIZ)
cs.close()                  # 关闭客户端套接字 

             在开发中，创建这种“友好的”退出方式的一种方法就是，将服务器的while循环放
在一个 try-except 语句中的 except 子句中，并监控 EOFError 或KeyboardInterrupt异常，这
样你就可以在 except 或finally 字句中关闭服务器的套接字。在生产环境中，你将想要能够
以一种更加自动化的方式启动和关闭服务器。在这些情况下，需要通过使用一个线程或创
建一个特殊文件或数据库条目来设置一个标记以关闭服务。
# UDP服务器模式
ss = socket()                        # 创建服务器套接字   udpSerSock = socket(AF_INET, SOCK_DGRAM)
ss.bind()                            # 绑定服务器套接字   udpSerSock.bind(ADDR)  ADDR->(HOST = '', PORT = 21567)
inf _loop:                           # 服务器无限循环 
    cs = ss.recvfrom()/ss.sendto()   #  关闭（接收/发送）  data, addr = udpSerSock.recvfrom(BUFSIZ) |  udpSerSock.sendto('[%s] %s' % (ctime(), data), addr)
ss.close()                           # 关闭服务器套接字
# UDP客户端模式
cs = socket()                        # 创建客户端套接字    udpCliSock = socket(AF_INET, SOCK_DGRAM)
comm_loop:                           # 通信循环 
    cs.sendto()/cs.recvfrom()        # 对话（发送/接收）   udpCliSock.sendto(data, ADDR) | data, ADDR = udpCliSock.recvfrom(BUFSIZ)
cs.close()                           # 关闭客户端套接字


socket 模块属性 
属性名称        描述 
数据属性 
AF_UNIX、AF_INET、AF_INET6、AF_NETLINK、AF_TIPC    Python 中支持的套接字地址家族 
SO_STREAM 、SO_DGRAM                               套接字类型（TCP=流，UDP=数据报） 
has_ipv6                                           指示是否支持 IPv6 的布尔标记
异常 
error                                              套接字相关错误 
herror                                             主机和地址相关错误 
gaierror                                           地址相关错误 
timeout                                            超时时间 
函数 
socket()              以给定的地址家族、套接字类型和协议类型（可选）创建一个套接字对象 
socketpair()          以给定的地址家族、套接字类型和协议类型（可选）创建一对套接字对象 
create_connection()   常规函数，它接收一个地址（主机名，端口号）对，返回套接字对象 
fromfd()              以一个打开的文件描述符创建一个套接字对象 
ssl()                 通过套接字启动一个安全套接字层连接；不执行证书验证 
getaddrinfo()         获取一个五元组序列形式的地址信息 
getnameinfo()         给定一个套接字地址，返回（主机名，端口号）二元组 
getfqdn()             返回完整的域名 
gethostname()         返回当前主机名 
gethostbyname()       将一个主机名映射到它的 IP 地址 
gethostbyname_ex()    gethostbyname() 的扩展版本，它返回主机名、别名主机集合和 IP 地址列表 
gethostbyaddr()       将一个 IP 地址映射到 DNS 信息；返回与 gethostbyname_ex()相同的 3 元组 
getprotobyname()      将一个协议名（如‘tcp’）映射到一个数字 
getservbyname()/getservbyport()  将一个服务名映射到一个端口号，或者反过来；对于任何一个函数来说，协议名都是可选的 
ntohl()/ntohs()   将来自网络的整数转换为主机字节顺序 
htonl()/htons()   将来自主机的整数转换为网络字节顺序 
inet_aton()/inet_ntoa()   将IP 地址八进制字符串转换成 32 位的包格式，或者反过来（仅用于 IPv4 地址） 
inet_pton()/inet_ntop()   将IP 地址字符串转换成打包的二进制格式，或者反过来（同时适用于IPv4 和IPv6 地址） 
getdefaulttimeout()/setdefaulttimeout()  以秒（浮点数）为单位返回默认套接字超时时间；以秒（浮点数）为单位设置默认套接
字超时时间 


SocketServer模块类 
类                   描     述 
BaseServer           包含核心服务器功能和 mix-in 类的钩子；仅用于推导，这样不会创建这个类的实例；可以用 TCPServer 或UDPServer 创建类的实例 
TCPServer/UDPServer  基础的网络同步 TCP/UDP服务器 
UnixStreamServer/UnixDatagramServer    基于文件的基础同步 TCP/UDP服务器 
ForkingMixIn/ThreadingMixIn            核心派出或线程功能；只用作mix-in 类与一个服务器类配合实现一些异步性；不能直接实例化这个类 
ForkingTCPServer/ForkingUDPServer      ForkingMixIn 和TCPServer/UDPServer的组合 
ThreadingTCPServer/ThreadingUDPServer  ThreadingMixIn 和TCPServer/UDPServer的组合 
BaseRequestHandler                     包含处理服务请求的核心功能；仅仅用于推导，这样无法创建这个类的实例；可以使用 StreamRequestHandler或DatagramRequestHandler创建类的实例 
StreamRequestHandler/DatagramRequestHandler   实现TCP/UDP服务器的服务处理器

网络/套接字编程相关模块 
模 块                   描 述 
socket                  正如本章讨论的，它是低级网络编程接口 
asyncore/asynchat       提供创建网络应用程序的基础设施，并异步地处理客户端 
select                  在一个单线程的网络服务器应用中管理多个套接字连接 
SocketServer            高级模块，提供网络应用程序的服务器类，包括 forking 或threading 簇

greenlet、generator、Concurrence
# python2

import socket

def server():
    # 1.第一步是创建socket对象。调用socket构造函数。
    # socket构造函数的第一个参数代表地址家族，可为AF_INET或AF_UNIX。AF_INET家族包括Internet地址，AF_UNIX家族用于同一台机器上的进程间通信。
    # 第二个参数代表套接字类型，可为SOCK_STREAM(流套接字)和SOCK_DGRAM(数据报套接字)。
    sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)

    # 2.第二步是将socket绑定到指定地址。
    # 由AF_INET所创建的套接字，参数必须是一个双元素元组，格式是(host,port)。host代表主机，port代表端口号。
    # 如果端口号正在使用、主机名不正确或端口已被保留，bind方法将引发socket.error异常。
    sock.bind(('localhost', 8001))

    # 3.第三步是使用socket套接字的listen方法接收连接请求。
    # 指定最多允许多少个客户连接到服务器。它的值至少为1。收到连接请求后，这些请求需要排队，如果队列满，就拒绝请求。
    sock.listen(5)

    while True:
        # 4.第四步是服务器套接字通过socket的accept方法等待客户请求一个连接。
        # 调用accept方法时，socket会时入“waiting”状态。客户请求连接时，方法建立连接并返回服务器。
        # accept方法返回一个含有两个元素的 元组(connection,address)。第一个元素connection是新的socket对象，服务器必须通过它与客户通信；第二个元素 address是客户的Internet地址。
        connection,address = sock.accept()

        try:
            # 设置成5秒就连接超时
            connection.settimeout(5)

            # 5.第五步是处理阶段，服务器和客户端通过send和recv方法通信(传输 数据)。
            # 服务器调用send，并采用字符串形式向客户发送信息。send方法返回已发送的字符个数。
            # 服务器使用recv方法从客户接收信息。调用 recv 时，服务器必须指定一个整数，它对应于可通过本次方法调用来接收的最大数据量。
            # recv方法在接收数据时会进入“blocked”状态，最后返回一个字符串，用它表示收到的数据。如果发送的数据量超过了recv所允许的，数据会被截短。
            # 多余的数据将缓冲于接收端。以后调用recv时，多余的数据会从缓冲区删除(以及自上次调用recv以来，客户可能发送的其它任何数据)。
            buf = connection.recv(1024)
            if buf == '1':
                connection.send('welcome to server!')
            else:
                connection.send('please go out!')

        except socket.timeout:
            print 'time out'

        # 6.传输结束，服务器调用socket的close方法关闭连接
        connection.close()


def client():
    # 1.创建一个socket以连接服务器
    sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)

    # 2.使用socket的connect方法连接服务器。
    # 对于AF_INET家族,连接格式如：socket.connect( (host,port) )
    # host代表服务器主机名或IP，port代表服务器进程所绑定的端口号。如连接成功，客户就可通过套接字与服务器通信，如果连接失败，会引发socket.error异常。
    sock.connect(('localhost', 8001))

    # 3.处理阶段，客户和服务器将通过send方法和recv方法通信。
    sock.send('1')
    print sock.recv(1024)

    # 4.传输结束，客户通过调用socket的close方法关闭连接。
    sock.close()



