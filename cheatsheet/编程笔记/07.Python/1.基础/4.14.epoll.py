import socket, logging
import select, errno

logger = logging.getLogger("network-server")

def InitLog():
    logger.setLevel(logging.DEBUG)

    fh = logging.FileHandler("network-server.log")
    fh.setLevel(logging.DEBUG)
    ch = logging.StreamHandler()
    ch.setLevel(logging.ERROR)
   
    formatter = logging.Formatter("%(asctime)s - %(name)s - %(levelname)s - %(message)s")
    ch.setFormatter(formatter)
    fh.setFormatter(formatter)
   
    logger.addHandler(fh)
    logger.addHandler(ch)


if __name__ == "__main__":
    InitLog()
   
    try:
        listen_fd = socket.socket(socket.AF_INET, socket.SOCK_STREAM, 0)
    except socket.error, msg:
        logger.error("create a socket failed")
   
    try:
        listen_fd.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
    except socket.error, msg:
        logger.error("setsocketopt error")
   
    try:
        listen_fd.bind(('', 2003))
    except socket.error, msg:
        logger.error("listen file id bind ip error")
   
    try:
        listen_fd.listen(10)
    except socket.error, msg:
        logger.error(msg)
   
    try:
        epoll_fd = select.epoll()
        epoll_fd.register(listen_fd.fileno(), select.EPOLLIN)
    except select.error, msg:
        logger.error(msg)
       
    connections = {}
    addresses = {}
    datalist = {}
    while True:
        epoll_list = epoll_fd.poll()
        for fd, events in epoll_list:
            if fd == listen_fd.fileno():
                conn, addr = listen_fd.accept()
                logger.debug("accept connection from %s, %d, fd = %d" % (addr[0], addr[1], conn.fileno()))
                conn.setblocking(0)
                epoll_fd.register(conn.fileno(), select.EPOLLIN | select.EPOLLET)
                connections[conn.fileno()] = conn
                addresses[conn.fileno()] = addr
            elif select.EPOLLIN & events:
                datas = ''
                while True:
                    try:
                        data = connections[fd].recv(10)
                        if not data and not datas:
                            epoll_fd.unregister(fd)
                            connections[fd].close()
                            logger.debug("%s, %d closed" % (addresses[fd][0], addresses[fd][1]))
                            break
                        else:
                            datas += data
                    except socket.error, msg:
                        if msg.errno == errno.EAGAIN:
                            logger.debug("%s receive %s" % (fd, datas))
                            datalist[fd] = datas
                            epoll_fd.modify(fd, select.EPOLLET | select.EPOLLOUT)
                            break
                        else:
                            epoll_fd.unregister(fd)
                            connections[fd].close()
                            logger.error(msg)
                            break       
            elif select.EPOLLHUP & events:
                epoll_fd.unregister(fd)
                connections[fd].close()
                logger.debug("%s, %d closed" % (addresses[fd][0], addresses[fd][1]))
            elif select.EPOLLOUT & events:
                sendLen = 0            
                while True:
                    sendLen += connections[fd].send(datalist[fd][sendLen:])
                    if sendLen == len(datalist[fd]):
                        break
                epoll_fd.modify(fd, select.EPOLLIN | select.EPOLLET)                
            else:
                continue
                
# -----------------------------------------------------------------------------
客户端程序,Python代码:
import socket
import time
import logging

logger = logging.getLogger("network-client")
logger.setLevel(logging.DEBUG)

fh = logging.FileHandler("network-client.log")
fh.setLevel(logging.DEBUG)
ch = logging.StreamHandler()
ch.setLevel(logging.ERROR)

formatter = logging.Formatter("%(asctime)s - %(name)s - %(levelname)s - %(message)s")
ch.setFormatter(formatter)
fh.setFormatter(formatter)

logger.addHandler(fh)
logger.addHandler(ch)

if __name__ == "__main__":
    try:
        connFd = socket.socket(socket.AF_INET, socket.SOCK_STREAM, 0)
    except socket.error, msg:
        logger.error(msg)
   
    try:
        connFd.connect(("192.168.31.226", 2003))
        logger.debug("connect to network server success")
    except socket.error,msg:
        logger.error(msg)
   
    for i in range(1, 11):
        data = "The Number is %d" % i
        if connFd.send(data) != len(data):
            logger.error("send data to network server failed")
            break
        readData = connFd.recv(1024)
        print readData
        time.sleep(1)
   
    connFd.close()
    
# http://scotdoyle.com/python-epoll-howto.html