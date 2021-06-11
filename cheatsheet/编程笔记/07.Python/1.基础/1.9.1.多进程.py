1. fork - wait - exit
    #! /usr/bin/python
    # -*- coding: utf-8 -*-
    
    import os
    import sys
    
    import time
    
    def child_process():
        '''child process'''
    
        time.sleep(5)
        print 'child process is running'
        sys.exit(0)
    
    def parent_process():
        '''parent process'''
        print 'parent process is running'
        print 'waiting for child process'
        exit_stat = os.wait()
        print "waited child process's PID = %d"  % (exit_stat[0])
        sys.exit(0)
    
    def main():
        '''main function'''
        try:
        pid = os.fork()
        if pid > 0:
            '''parent process'''
            parent_process()
        else:
            child_process()
        except OSError, e:
        print os.strerror(e.errno)
    
    if __name__ == '__main__':
        main()
        
os.abort()
    向调用该函数的进程发送一个SIGABRT信号，在Unix系统上默认的行为是产生一个core文件。
os._exit(n)
    退出进程，并且返回退出状态n，在退出的时候不会执行清理工作，直接退出。
    注意：正常的退出应该使用sys.exit(n)，而_exit()函数一般只用在fork之后的子进程中调用以退出。
    可用的退出状态(并不适用所有的Unix平台都可用):
    os.EX_OK - 正常退出
    os.EX_USAGE - 命令执行不正确，如命令参数错误
    os.EX_DATAERR - 输入数据有误
    os.EX_NOINPUT - 输入文件不存在或者不可读
    os.EX_NOUSER - 指定的用户不存在
    os.EX_NOHOST - 指定的主机id不存在
    os.EX_UNAVAILABLE - 请求的服务不可用
    os.EX_SOFTWARE - 内部软件错误
    os.EX_OSERR - 操作系统错误
    os.EX_OSFILE - 系统文件不存在
    os.EX_CANTCREAT - 无法创建指定的输出文件
    os.EX_IOERR - 在进行I/O操作时出错
    os.EX_PROTOCOL - 协议切换操作非法，或者协议切换不可用
    os.EX_NOPERM - 没有权限执行该操作
    os.EX_CONFIG - 配置错误
os.fork()
    fork出一个子进程，在子进程中返回0，在父进程中返回子进程ID，如果发生错误，则抛出OSError异常
    注意：在一些平台下如FreeBSD，Cygwin和OS/2 EMX系统中使用该函数会有问题。
os.kill(pid, sig)
    发送一个信号sig给进程id为pid的进程
os.nice(increment)
    增加increment到进程的nice值，返回一个新的nice值。
os.system(command)
    在一个shell中执行command命令，这是一个对C函数system()的python实现，具有相同的限制条件。在Unix系统中，返回值是命令执行后的退出状态值。由于POSIX没有为C函数system()的返回值指定明确的含义，所以os.system()的返回值依赖具体的系统。
os.times()
    返回一个由浮点数组成的5元组，指定进程的累积运行时间，单位为秒(s)。时间包括：user time，system time，子进程的user time，子进程的system time 以及一个经过的墙上钟表时间。
os.wait()
    等待任何一个子进程结束，返回一个tuple，包括子进程的进程ID和退出状态信息：一个16位的数字，低8位是杀死该子进程的信号编号，而高8位是退出状态(如果信号编号是0)，其中低8位的最高位如果被置位，则表示产生了一个core文件。
os.waitpid(pid, options)
    等待进程id为pid的进程结束，返回一个tuple，包括进程的进程ID和退出信息(和os.wait()一样)，参数options会影响该函数的行为。在默认情况下，options的值为0。
    如果pid是一个正数，waitpid()请求获取一个pid指定的进程的退出信息，如果pid为0，则等待并获取当前进程组中的任何子进程的值。如果pid为-1，则等待当前进程的任何子进程，如果pid小于-1，则获取进程组id为pid的绝对值的任何一个进程。当系统调用返回-1时，抛出一个OSError异常。
os.wait3(options)
    和waitpid()函数类似，区别是不需要指定pid，函数返回一个3元组，包括结束的子进程的进程id，退出状态以及资源的使用信息。关于资源使用可以使用resource.getusage()来获取详细的信息。
os.wait4(pid, options)
    和waitpid()函数类似，但是函数返回一个3元组外，这点和wait3()函数类似。
waitpid()函数的options选项：
os.WNOHANG - 如果没有子进程退出，则不阻塞waitpid()调用
os.WCONTINUED - 如果子进程从stop状态变为继续执行，则返回进程自前一次报告以来的信息。
os.WUNTRACED - 如果子进程被停止过而且其状态信息还没有报告过，则报告子进程的信息。
如下的函数用于处理那些自system()，wait()和waitpid()返回的状态信息，并将这些状态信息作为如下函数的参数传递。

os.WCOREDUMP(status)
    如果一个core文件被创建，则返回True，否则返回False。
os.WIFCONTINUED(status)
    如果一个进程被停止过，并且继续执行，则返回True，否则返回False。
os.WIFSTOPPED(status)
    如果子进程被停止过，则返回True，否则返回False。
os.WIFSIGNALED(status)
    如果进程由于信号而退出，则返回True，否则返回False。
os.WIFEXITED(status)
    如果进程是以exit()方式退出的，则返回True，否则返回False。
os.WEXITSTATUS(status)
    如果WIFEXITED(status)返回True，则返回一个整数，该整数是exit()调用的参数。否则返回值是未定义的。
os.WSTOPSIG(status)
    返回导致进程停止的信号
os.WTERMSIG(status)
    返回导致进程退出的信号

2. os.popen
    os.popen()函数可执行命令，并获得命令的stdout流。函数要取得两个参数，一个是要执行的命令，另一个是调用
    函数所用的模式。如“r"只读模式。
    os.popen2()函数执行命令，并获得命令的stdout流和stdin流。函数返回一个元组，其中包含有两个文件对象，
    一个对象对应stdin流，一个对象对应stdout流。

3. subprocess的目的就是启动一个新的进程并且与之通信。
3.1 subprocess.Popen 主程序不会自动等待子进程完成。我们必须调用对象的wait()方法，父进程才会等待 (也就是阻塞block)

subprocess模块中只定义了一个类: Popen。可以使用Popen来创建进程，并与进程进行复杂的交互。它的构造函数如下：
subprocess.Popen(args, bufsize=0, executable=None,stdin=None, stdout=None, stderr=None, preexec_fn=None, close_fds=False,shell=False, cwd=None, env=None, universal_newlines=False, startupinfo=None, creationflags=0)

参数args可以是字符串或者序列类型（如：list，元组），用于指定进程的可执行文件及其参数。如果是序列类型，第一个元素通常是可执行文件的路径。我们也可以显式的使用executeable参数来指定可执行文件的路径。
参数stdin,stdout,stderr分别表示程序的标准输入、输出、错误句柄。他们可以是PIPE，文件描述符或文件对象，也可以设置为None，表示从父进程继承。

如果参数shell设为true，程序将通过shell来执行。
参数env是字典类型，用于指定子进程的环境变量。如果env = None，子进程的环境变量将从父进程中继承。
subprocess.PIPE
　　在创建Popen对象时，subprocess.PIPE可以初始化stdin, stdout或stderr参数。表示与子进程通信的标准流。
subprocess.STDOUT
　　创建Popen对象时，用于初始化stderr参数，表示将错误通过标准输出流输出。 

>>> import subprocess
>>> child1 = subprocess.Popen(["cat","/etc/passwd"], stdout=subprocess.PIPE)
>>> child2 = subprocess.Popen(["grep","0:0"],stdin=child1.stdout, stdout=subprocess.PIPE)
>>> out = child2.communicate()
subprocess.PIPE实际上为文本流提供一个缓存区。child1的stdout将文本输出到缓存区，随后child2的stdin从该PIPE中将文本读取走。child2的输出文本也被存放在PIPE中，直到communicate()方法从PIPE中读取出PIPE中的文本。
注意：communicate()是Popen对象的一个方法，该方法会阻塞父进程，直到子进程完成

Popen的方法：
    Popen.poll()
    　　用于检查子进程是否已经结束。设置并返回returncode属性。
    Popen.wait()
    　　等待子进程结束。设置并返回returncode属性。
    Popen.communicate(input=None)
    　　与子进程进行交互。向stdin发送数据，或从stdout和stderr中读取数据。可选参数input指定发送到子进程的参数。Communicate()返回一个元组：(stdoutdata, stderrdata)。注意：如果希望通过进程的stdin向其发送数据，在创建Popen对象的时候，参数stdin必须被设置为PIPE。同样，如果希望从stdout和stderr获取数据，必须将stdout和stderr设置为PIPE。
    Popen.send_signal(signal)
    　　向子进程发送信号。
    Popen.terminate()
    　　停止(stop)子进程。在windows平台下，该方法将调用Windows API TerminateProcess()来结束子进程。
    Popen.kill()
    　　杀死子进程。
    Popen.pid
    　　获取子进程的进程ID。
    Popen.returncode
    　　获取进程的返回值。如果进程还没有结束，返回None。
3.2 subprocess.call  父进程等待子进程完成

    #!/usr/bin/env python  
    from threading import Thread  
    import subprocess  
    from Queue import Queue  
    
    num_threads=3  
    ips=['127.0.0.1','116.56.148.187']  
    q=Queue()  
    def pingme(i,queue):  
        while True:  
            ip=queue.get()  
            print 'Thread %s pinging %s' %(i,ip)  
            ret=subprocess.call('ping -c 1 %s' % ip,shell=True,stdout=open('/dev/null','w'),stderr=subprocess.STDOUT)  
            if ret==0:  
                print '%s is alive!' %ip  
            elif ret==1:  
                print '%s is down...'%ip  
            queue.task_done()  
    
    #start num_threads threads  
    for i in range(num_threads):  
        t=Thread(target=pingme,args=(i,q))  
        t.setDaemon(True)  
        t.start()  
    
    for ip in ips:  
        q.put(ip)  
    print 'main thread waiting...'  
    q.join();print 'Done'
    
subprocess.call()
    父进程等待子进程完成
    返回退出信息(returncode，相当于Linux exit code)

subprocess.check_call()
    父进程等待子进程完成
    返回0
    检查退出信息，如果returncode不为0，则举出错误subprocess.CalledProcessError，该对象包含有returncode属性，可用try…except…来检查

subprocess.check_output()
    父进程等待子进程完成
    返回子进程向标准输出的输出结果
    检查退出信息，如果returncode不为0，则举出错误subprocess.CalledProcessError，该对象包含有returncode属性和output属性，output属性为标准输出的输出结果，可用try…except…来检查。
    
4. multiprocessing
multiprocessing 的 API 几乎是完复制了 threading 的API
from multiprocessing import Process, current_process
def func():
    time.sleep(1)
    proc = current_process()
    proc.name, proc.pid
sub_proc = Process(target=func, args=())
sub_proc.start()
sub_proc.join()
proc = current_process()
proc.name, proc.pid


4.1 进程同步
lock.acquire() lock.release()

4.2 Semaphore
Semaphore 相当于 N 把锁，获取其中一把就可以执行了。

4.3  Pipes
Pipe 是在两个进程之间通信的工具，Pipe Constructor 会返回两个端
conn1, conn2 = Pipe(True)

如果是全双工的(构造函数参数为True)，则双端口都可接收发送，否则前面的端口用于接收，后面的端口用于发送。
def proc1(pipe):
   for i in xrange(10000):
       pipe.send(i)
def proc2(pipe):
    while True:
        print "proc2 rev:", pipe.recv()
pipe = Pipe()
Process(target=proc1, args=(pipe[0],)).start()
Process(target=proc2, args=(pipe[1],)).start()
Pipe 的每个端口同时最多一个进程读写，否则数据会出各种问题

4.4  Queues
当 Queue 为 Queue.Full 状态时，再 put() 会堵塞，当状态为 Queue.Empty 时，再 get() 也是。当 put() 或 get() 设置了超时参数，而超时的时候，会抛出异常。

Queue 主要用于多个进程产生和消费，一般使用情况如下
def producer(q):
    for i in xrange(10):
        q.put(i)
def consumer(q):
    while True:
        print "consumer", q.get()
q = Queue(40)
for i in xrange(10):
    Process(target=producer, args=(q,)).start()
Process(target=consumer, args=(q,)).start()

十个生产者进程，一个消费者进程，共用同一个队列进行同步。
有一个简化版本的 multiprocessing.queues.SimpleQueue, 只支持3个方法 empty(), get(), put()。

也有一个强化版本的 JoinableQueue, 新增两个方法 task_done() 和 join()。 task_done() 是给消费者使用的，每完成队列中的一个任务，调用一次该方法。当所有的 tasks 都完成之后，交给调用 join() 的进程执行。

def consumer(q):
    while True:
        print "consumer", q.get()
        q.task_done()
jobs = JoinableQueue()
for i in xrange(10):
        jobs.put(i)
for i in xrange(10):
    p = Process(target=consumer, args=(jobs,))
    p.daemon = True
    p.start()
jobs.join()

这个 join 函数等待 JoinableQueue 为空的时候，等待就结束，外面的进程可以继续执行了，但是那10个进程干嘛去了呢，他们还在等待呀，上面是设置了 p.daemon = True, 子进程才随着主进程结束的，如果没有设置，它们还是会一直等待的呢。


5.1 共享内存
共享内存有两个结构，一个是 Value, 一个是 Array，这两个结构内部都实现了锁机制，因此是多进程安全的。
def func(n, a):
    n.value = 50
    for i in range(len(a)):
        a[i] += 10
num = Value('d', 0.0)
ints= Array('i', range(10))
p = Process(target=func, args=(num, ints))
p.start()
p.join()

Value 和 Array 都需要设置其中存放值的类型，d 是 double 类型，i 是 int 类型，具体的对应关系在Python 标准库的 sharedctypes 模块中查看。


5.2 服务进程 Manager
上面的共享内存支持两种结构 Value 和 Array, 这些值在主进程中管理，很分散。 Python 中还有一统天下，无所不能的 Server process，专门用来做数据共享。 其支持的类型非常多，比如list, dict, Namespace, Lock, RLock, Semaphore, BoundedSemaphore, Condition, Event, Queue, Value 和 Array 用法如下：
from multiprocessing import Process, Manager
def func(dct, lst):
    dct[88] = 88
    lst.reverse()
manager = Manager()
dct = manager.dict()
lst = manager.list(range(5,10))
p = Process(target=func, args=(dct, lst))
p.start()
p.join()
print dct, '|', lst
Out: {88: 88} | [9, 8, 7, 6, 5]

一个 Manager 对象是一个服务进程，推荐多进程程序中，数据共享就用一个 manager 管理。

6 进程管理
Pool 是进程池，进程池能够管理一定的进程，当有空闲进程时，则利用空闲进程完成任务，直到所有任务完成为止，用法如下
def func(x):
    return x*x
pool = Pool(processes=4)
print pool.map(func, range(8))

Pool 进程池创建4个进程，不管有没有任务，都一直在进程池中等候，等到有数据的时候就开始执行。

6.1 异步执行
apply_async 和 map_async 执行之后立即返回，然后异步返回结果。 使用方法如下

def func(x):
    return x*x
def callback(x):
    print x, 'in callback'
    
pool = Pool(processes=4)
result = pool.map_async(func, range(8), 8, callback)
print result.get(), 'in main'
Out:
[0, 1, 4, 9, 16, 25, 36, 49] in callback
[0, 1, 4, 9, 16, 25, 36, 49] in main

有两个值得提到的，一个是 callback，另外一个是 multiprocessing.pool.AsyncResult。 callback 是在结果返回之前，调用的一个函数，这个函数必须只有一个参数，它会首先接收到结果。callback 不能有耗时操作，因为它会阻塞主线程。

pool.apply(func,args, kwargs)  ===  pool.apply_async(func, args, kwargs).get()

7. 进程池
from multiprocessing import Pool
pool = Pool(2)
pool.map(fib, [35] * 2)

8. dummy
    我之前使用多线程/多进程都使用上面的方式，在好长一段时间里面对于多进程和多线程之前怎么选择都搞得不清楚，
    偶尔会出现要从多线程改成多进程或者多进程改成多线程的时候，痛苦。看了一些开源项目代码，我发现了好多人在
    用multiprocessing.dummy这个子模块，「dummy」这个词有「模仿」的意思，它虽然在多进程模块的代码中，但是
    接口和多线程的接口基本一样。
    from multiprocessing import Pool
    from multiprocessing.dummy import Pool


import time
import multiprocessing
def profile(func):
    def wrapper(*args, **kwargs):
        import time
        start = time.time()
        func(*args, **kwargs)
        end   = time.time()
        print 'COST: {}'.format(end - start)
    return wrapper
def fib(n):
    if n<= 2:
        return 1
    return fib(n-1) + fib(n-2)
@profile
def nomultiprocess():
    fib(35)
    fib(35)
@profile
def hasmultiprocess():
    jobs = []
    for i in range(2):
        p = multiprocessing.Process(target=fib, args=(35,))
        p.start()
        jobs.append(p)
    for p in jobs:
        p.join()
nomultiprocess()
hasmultiprocess()