# 进程、线程和协程的区别
# 
# 进程拥有自己独立的堆和栈，既不共享堆，亦不共享栈，进程由操作系统调度。
# 线程拥有自己独立的栈和共享的堆，共享堆，不共享栈，线程亦由操作系统调度(标准线程是的)。
# 协程和线程一样共享堆，不共享栈，协程由程序员在协程的代码里显示调度。
# 
# 协程和线程的区别是：协程避免了无意义的调度，由此可以提高性能，但也因此，程序员必须自己承担调度的责任，
# 同时，协程也失去了标准线程使用多CPU的能力。

## Greenlet模块

#!/usr/bin/env python
# -*- coding:utf-8 -*-
  
from greenlet import greenlet

def test1():
    print 12
    gr2.switch()
    print 34
    gr2.switch()
  
  
def test2():
    print 56
    gr1.switch()
    print 78
  
gr1 = greenlet(test1)
gr2 = greenlet(test2)
gr1.switch()

# 每一个greenlet其实就是一个函数,以及保存这个函数执行时的上下文.对于函数来说上下文也就是其stack。
# greenlet需要你自己来处理线程切换， 就是说，你需要自己指定现在执行哪个greenlet再执行哪个greenlet。

## Gevent（第三方库）

import gevent
 
def foo():
    print('Running in foo')
    gevent.sleep(0)
    print('Explicit context switch to foo again')
 
def bar():
    print('Explicit context to bar')
    gevent.sleep(0)
    print('Implicit context switch back to bar')
 
gevent.joinall([
    gevent.spawn(foo),
    gevent.spawn(bar),
])

# gevent是第三方库，通过greenlet实现协程，其基本思想是：
# 　　当一个greenlet遇到IO操作时，比如访问网络，就自动切换到其他的greenlet，等到IO操作完成，再在适当的时候
# 切换回来继续执行。由于IO操作非常耗时，经常使程序处于等待状态，有了gevent为我们自动切换协程，就保证总有
# greenlet在运行，而不是等待IO。 gevent.sleep()来互相切换，实际上gevent是可以自动切换的。

## 遇到IO自动切换任务

from gevent import monkey; monkey.patch_all()
import gevent
from  urllib.request import urlopen
 
def f(url):
    print('GET: %s' % url)
    resp = urlopen(url)
    data = resp.read()
    print('%d bytes received from %s.' % (len(data), url))
 
gevent.joinall([
        gevent.spawn(f, 'https://www.python.org/'),
        gevent.spawn(f, 'https://www.yahoo.com/'),
        gevent.spawn(f, 'https://github.com/'),
])

## 通过gevent实现单线程下的多socket并发

### 服务端

import sys
import socket
import time
import gevent
 
from gevent import socket,monkey
monkey.patch_all()
 
 
def server(port):
    s = socket.socket()
    s.bind(('0.0.0.0', port))
    s.listen(500)
    while True:
        cli, addr = s.accept()
        gevent.spawn(handle_request, cli)
 
 
 
def handle_request(conn):
    try:
        while True:
            data = conn.recv(1024)
            print("recv:", data)
            conn.send(data)
            if not data:
                conn.shutdown(socket.SHUT_WR)
 
    except Exception as  ex:
        print(ex)
    finally:
        conn.close()
if __name__ == '__main__':
    server(8001)

### 客户端

import socket
 
HOST = 'localhost'    # The remote host
PORT = 8001           # The same port as used by the server
s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
s.connect((HOST, PORT))
while True:
    msg = bytes(input(">>:"),encoding="utf8")
    s.sendall(msg)
    data = s.recv(1024)
    #print(data)
 
    print('Received', repr(data))
s.close()