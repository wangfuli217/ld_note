可能有3种情况从Running进入Blocked：
    同步：线程中获取同步锁，但是资源已经被其他线程锁定时，进入Locked状态，直到该资源可获取
        （获取的顺序由Lock队列控制）
    睡眠：线程运行sleep()或join()方法后，线程进入Sleeping状态。区别在于sleep等待固定的时间，
          而join是等待子线程执行完。当然join也可以指定一个“超时时间”。从语义上来说，如果两个
          线程a,b, 在a中调用b.join()，相当于合并(join)成一个线程。最常见的情况是在主线程中join所有的子线程。
    等待：线程中执行wait()方法后，线程进入Waiting状态，等待其他线程的通知(notify）。
    
线程的类型
    主线程：当一个程序启动时，就有一个进程被操作系统（OS）创建，与此同时一个线程也立刻运行，该线程通常叫做程序的主线程（Main Thread）。每个进程至少都有一个主线程，主线程通常最后关闭。
    子线程：在程序中创建的其他线程，相对于主线程来说就是这个主线程的子线程。
    守护线程：daemon thread，对线程的一种标识。守护线程为其他线程提供服务，如JVM的垃圾回收线程。当剩下的全是守护线程时，进程退出。
    前台线程：相对于守护线程的其他线程称为前台线程。
    
Python虚拟机使用GIL（Global Interpreter Lock，全局解释器锁）来互斥线程对共享资源的访问，暂时无法利用多处理器的优势。
    
如果你特别在意性能，还可以考虑一些“微线程”的实现：
    Stackless Python：Python的一个增强版本，提供了对微线程的支持。微线程是轻量级的线程，在多个
                      线程间切换所需的时间更多，占用资源也更少。
    greenlet：是 Stackless 的副产品，其将微线程称为tasklet 。tasklet运行在伪并发中，使用channel
              进行同步数据交换。而greenlet是更加原始的微线程的概念，没有调度。你可以自己构造
              微线程的调度器，也可以使用greenlet实现高级的控制流。
              
互斥锁同步
    数据共享。当多个线程都修改某一个共享数据的时候，需要进行同步控制。
    #创建锁
    mutex = threading.Lock()
    #锁定 
    mutex.acquire([timeout])
    #释放
    mutex.release()
    
    其中，锁定方法acquire可以有一个超时时间的可选参数timeout。如果设定了timeout，则在超时后通过返回值可以判断是否得到了锁，从而可以进行一些其他的处理。

同步阻塞
    当一个线程调用锁的acquire()方法获得锁时，锁就进入"locked"状态。每次只有一个线程可以获得锁。
    如果此时另一个线程试图获得这个锁，该线程就会变为"blocked"状态，称为"同步阻塞"。
    
死锁
    交错死锁
        A.Lock B.Lock {doing} B.unLock A.unLock   # 线程1
        B.Lock A.Lock {doing} A.unLock B.unLock   # 线程2
    递归死锁
        A.Lock  A.Lock  A.unLock  A.unLock        # 线程1
    
    threading.RLock 用以解决递归死锁引起的问题。
    
条件变量同步 Producer -> Consumer
    threading.Condition()
    除了提供与Lock类似的acquire和release方法外，还提供了wait和notify方法。
    线程首先acquire一个条件变量，然后判断一些条件。如果条件不满足则wait；
                                                   如果条件满足，进行一些处理改变条件后，通过notify方法通知其他线程，
                                                   其他处于wait状态的线程接到通知后会重新判断条件。
    不断的重复这一过程，从而解决复杂的同步问题。
    import threading
    import time
    
    class Producer(threading.Thread):
        def run(self):
            global count
            while True:
                if con.acquire():
                    if count > 1000:
                        con.wait()
                    else:
                        count = count+100
                        msg = self.name+' produce 100, count=' + str(count)
                        print msg
                        con.notify()
                    con.release()
                    time.sleep(1)
    
    class Consumer(threading.Thread):
        def run(self):
            global count
            while True:
                if con.acquire():
                    if count < 100:
                        con.wait()
                    else:
                        count = count-3
                        msg = self.name+' consume 3, count='+str(count)
                        print msg
                        con.notify()
                    con.release()
                    time.sleep(1)
    
    count = 500
    con = threading.Condition()
    
    def test():
        for i in range(2):
            p = Producer()
            p.start()
        for i in range(5):
            c = Consumer()
            c.start()
    if __name__ == '__main__':
        test()

Queue Producer -> Consumer
    Python的Queue模块中提供了同步的、线程安全的队列类，包括
        FIFO（先入先出)队列Queue，
        LIFO（后入先出）队列LifoQueue，和
        优先级队列PriorityQueue。
    这些队列都实现了锁原语，能够在多线程中直接使用。
    
put: 向队列中添加一个项。
get: 从队列中删除并返回一个项。
task_done: 当某一项任务完成时调用。
join: 阻塞直到所有的项目都被处理完。
    
    
#encoding=utf-8
import threading
import time
from Queue import Queue

class Producer(threading.Thread):
    def run(self):
        global queue
        count = 0
        while True:
            for i in range(100):
                if queue.qsize() > 1000:
                     pass
                else:
                     count = count +1
                     msg = '生成产品'+str(count)
                     queue.put(msg)
                     print msg
            time.sleep(1)

class Consumer(threading.Thread):
    def run(self):
        global queue
        while True:
            for i in range(3):
                if queue.qsize() < 100:
                    pass
                else:
                    msg = self.name + '消费了 '+queue.get()
                    print msg
            time.sleep(1)

queue = Queue()


def test():
    for i in range(500):
        queue.put('初始产品'+str(i))
    for i in range(2):
        p = Producer()
        p.start()
    for i in range(5):
        c = Consumer()
        c.start()
if __name__ == '__main__':
    test()
    
    
Event
    很多时候，线程之间会有互相通信的需要。常见的情形是次要线程为主要线程执行特定的任务，在执行过程中需要不断报告执行的进度情况。
    threading.Event可以使一个线程等待其他线程的通知。
        其内置了一个标志，初始值为False。
        线程通过wait()方法进入等待状态，直到另一个线程调用set()方法将内置标志设置为True时，
        Event通知所有等待状态的线程恢复运行。还可以通过isSet()方法查询Envent对象内置状态的当前值。
import threading
import random
import time

class MyThread(threading.Thread):
    def __init__(self,threadName,event):
        threading.Thread.__init__(self,name=threadName)
        self.threadEvent = event

    def run(self):
        print "%s is ready" % self.name
        self.threadEvent.wait()
        print "%s run!" % self.name

sinal = threading.Event()
for i in range(10):
    t = MyThread(str(i),sinal)
    t.start()

sinal.set()

后台线程
    默认情况下，主线程在退出时会等待所有子线程的结束。
    如果希望主线程不等待子线程，而是在退出时自动结束所有的子线程，就需要设置子线程为后台线程(daemon)。
    方法是通过调用线程类的setDaemon()方法。
import threading
import random
import time

class MyThread(threading.Thread):

    def run(self):
        wait_time=random.randrange(1,10)
        print "%s will wait %d seconds" % (self.name, wait_time)
        time.sleep(wait_time)
        print "%s finished!" % self.name

if __name__=="__main__":
    print 'main thread is waitting for exit...'        

    for i in range(5):
        t = MyThread()
        t.setDaemon(True)
        t.start()
        
    print 'main thread finished!'
    
join()方法使得线程可以等待另一个线程的运行，而setDaemon()方法使得线程在结束时不等待子线程。join和setDaemon都可以改变线程之间的运行顺序。
    
多线程

In : from multiprocessing.pool import ThreadPool
In : pool = ThreadPool(5)
In : pool.map(lambda x: x**2, range(5))
Out: [0, 1, 4, 9, 16]
    
    
# coding=utf-8
import time
import threading
from random import random
from Queue import Queue
def double(n):
    return n * 2
class Worker(threading.Thread):
    def __init__(self, queue):
        super(Worker, self).__init__()
        self._q = queue
        self.daemon = True
        self.start()
    def run(self):
        while 1:
            f, args, kwargs = self._q.get()
            try:
                print 'USE: {}'.format(self.name)  # 线程名字
                print f(*args, **kwargs)
            except Exception as e:
                print e
            self._q.task_done()
class ThreadPool(object):
    def __init__(self, num_t=5):
        self._q = Queue(num_t)
        # Create Worker Thread
        for _ in range(num_t):
            Worker(self._q)
    def add_task(self, f, *args, **kwargs):
        self._q.put((f, args, kwargs))
    def wait_complete(self):
        self._q.join()
pool = ThreadPool()
for _ in range(8):
    wt = random()
    pool.add_task(double, wt)
    time.sleep(wt)
pool.wait_complete()

-> profile

# coding=utf-8
import time
import threading
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
def nothread():
    fib(35)
    fib(35)
@profile
def hasthread():
    for i in range(2):
        t = threading.Thread(target=fib, args=(35,))
        t.start()
    main_thread = threading.currentThread()
    for t in threading.enumerate():
        if t is main_thread:
            continue
        t.join()
nothread()
hasthread()