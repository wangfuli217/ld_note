import subprocess as sub
import multiprocessing as mul

# 多进程multiprocessing 
    创建进程的类：Process(group=None, target=None, name=None, args=(), kwargs={})
    target表示调用对象，
    args表示调用对象的位置参数元组。
    kwargs表示调用对象的字典。
    name为别名。
    group实质上不使用。

# 方法：
    is_alive()、
    join([timeout])、
    run()、
    start()、
    terminate()。
    其中，Process以start()启动某个进程。
# 属性：authkey、daemon（要通过start()设置）、exitcode(进程在运行时为None、如果为–N，表示被信号N结束）、name、pid。
# 其中daemon是父进程终止后自动终止，且自己不能产生新进程，必须在start()之前设置。

from multiprocessing import Process
import os

def info(title):
    print(title)
    print('module name:', __name__)
    print('parent process:', os.getppid())
    print('process id:', os.getpid())
    print("\n\n")


def f(name):
    info('\033[31;1mfunction f\033[0m')
    print('hello', name)


if __name__ == '__main__':
    info('\033[32;1mmain process line\033[0m')
    p = Process(target=f, args=('bob',))
    p.start()
    p.join()

# 将进程定义为类
import multiprocessing
import time

class ClockProcess(multiprocessing.Process):
    def __init__(self, interval):
        multiprocessing.Process.__init__(self)
        self.interval = interval

    def run(self):
        n = 5
        while n > 0:
            print("the time is {0}".format(time.ctime()))
            time.sleep(self.interval)
            n -= 1

if __name__ == '__main__':
    p = ClockProcess(3)
    p.start()

# 不加daemon属性
import multiprocessing
import time

def worker(interval):
    print("work start:{0}".format(time.ctime()));
    time.sleep(interval)
    print("work end:{0}".format(time.ctime()));

if __name__ == "__main__":
    p = multiprocessing.Process(target = worker, args = (3,))
    p.start()
    print "end!"

# 加上daemon属性
import multiprocessing
import time

def worker(interval):
    print("work start:{0}".format(time.ctime()));
    time.sleep(interval)
    print("work end:{0}".format(time.ctime()));

if __name__ == "__main__":
    p = multiprocessing.Process(target = worker, args = (3,))
    p.daemon = True
    p.start()
    print "end!"
注：因子进程设置了daemon属性，主进程结束，它们就随着结束了。

# 设置daemon执行完结束的方法
import multiprocessing
import time

def worker(interval):
    print("work start:{0}".format(time.ctime()));
    time.sleep(interval)
    print("work end:{0}".format(time.ctime()));

if __name__ == "__main__":
    p = multiprocessing.Process(target = worker, args = (3,))
    p.daemon = True
    p.start()
    p.join()
    print "end!"
    
    
# multiprocessing.Lock() 当多个进程需要访问共享资源的时候，Lock可以用来避免访问的冲突。
import multiprocessing
import sys

def worker_with(lock, f):
    with lock:
        fs = open(f, 'a+')
        n = 10
        while n > 1:
            fs.write("Lockd acquired via with\n")
            n -= 1
        fs.close()
        
def worker_no_with(lock, f):
    lock.acquire()
    try:
        fs = open(f, 'a+')
        n = 10
        while n > 1:
            fs.write("Lock acquired directly\n")
            n -= 1
        fs.close()
    finally:
        lock.release()
    
if __name__ == "__main__":
    lock = multiprocessing.Lock()
    f = "file.txt"
    w = multiprocessing.Process(target = worker_with, args=(lock, f))
    nw = multiprocessing.Process(target = worker_no_with, args=(lock, f))
    w.start()
    nw.start()
    print "end"

# multiprocessing.Semaphore 用来控制对共享资源的访问数量，例如池的最大连接数。Semaphore(value=1)
import multiprocessing
import time

def worker(s, i):
    s.acquire()
    print(multiprocessing.current_process().name + "acquire");
    time.sleep(i)
    print(multiprocessing.current_process().name + "release\n");
    s.release()

if __name__ == "__main__":
    s = multiprocessing.Semaphore(2)
    for i in range(5):
        p = multiprocessing.Process(target = worker, args=(s, i*2))
        p.start()

# multiprocessing.Event 用来实现进程间同步通信。   Event()    
import multiprocessing
import time

def wait_for_event(e):
    print("wait_for_event: starting")
    e.wait()
    print("wairt_for_event: e.is_set()->" + str(e.is_set()))

def wait_for_event_timeout(e, t):
    print("wait_for_event_timeout:starting")
    e.wait(t)
    print("wait_for_event_timeout:e.is_set->" + str(e.is_set()))

if __name__ == "__main__":
    e = multiprocessing.Event()
    w1 = multiprocessing.Process(name = "block",
            target = wait_for_event,
            args = (e,))

    w2 = multiprocessing.Process(name = "non-block",
            target = wait_for_event_timeout,
            args = (e, 2))
    w1.start()
    w2.start()

    time.sleep(3)

    e.set()
    print("main: event is set")
    
# Queue(maxsize=0)
# Queue是多进程安全的队列，可以使用Queue实现多进程之间的数据传递。
# put方法用以插入数据到队列中，put方法还有两个可选参数：blocked和timeout。
  1. 如果blocked为True（默认值），并且timeout为正值，该方法会阻塞timeout指定的时间，直到该队列有剩余的空间。
  2. 如果超时，会抛出Queue.Full异常。
  3. 如果blocked为False，但该Queue已满，会立即抛出Queue.Full异常。
# get方法可以从队列读取并且删除一个元素。同样，get方法有两个可选参数：blocked和timeout。
  1. 如果blocked为True（默认值），并且timeout为正值，那么在等待时间内没有取到任何元素，会抛出Queue.Empty异常。
  2. 如果blocked为False，有两种情况存在，
     如果Queue有一个值可用，则立即返回该值，否则，
     如果队列为空，则立即抛出Queue.Empty异常。
## Queues(队列)
import multiprocessing

def writer_proc(q):      
    try:         
        q.put(1, block = False) 
    except:         
        pass   

def reader_proc(q):      
    try:         
        print q.get(block = False) 
    except:         
        pass

if __name__ == "__main__":
    q = multiprocessing.Queue()
    writer = multiprocessing.Process(target=writer_proc, args=(q,))  
    writer.start()   

    reader = multiprocessing.Process(target=reader_proc, args=(q,))  
    reader.start()  

    reader.join()  
    writer.join()

## Pipe(duplex=True)
# Pipe方法返回(conn1, conn2)代表一个管道的两个端。Pipe方法有duplex参数，
# 如果duplex参数为True(默认值)，那么这个管道是全双工模式，也就是说conn1和conn2均可收发。duplex为False，conn1只负责接受消息，conn2只负责发送消息。
# send和recv方法分别是发送和接受消息的方法。
# 例如，在全双工模式下，可以调用conn1.send发送消息，conn1.recv接收消息。
    1. 如果没有消息可接收，recv方法会一直阻塞。
    2. 如果管道已经被关闭，那么recv方法会抛出EOFError

# 进程池 Pool(processes=None, initializer=None, initargs=(), maxtasksperchild=None)
# apply_async(func[, args[, kwds[, callback]]]) 它是非阻塞，apply(func[, args[, kwds]])是阻塞的
# close()        关闭pool，使其不在接受新的任务。
# terminate()    结束工作进程，不在处理未完成的任务。
# join()         主进程阻塞，等待子进程的退出， join方法要在close或terminate之后使用。
import multiprocessing
import os, time, random

def Lee():
    print "\nRun task Lee-%s" %(os.getpid()) #os.getpid()获取当前的进程的ID
    start = time.time()
    time.sleep(random.random() * 10) #random.random()随机生成0-1之间的小数
    end = time.time()
    print 'Task Lee, runs %0.2f seconds.' %(end - start)

def Marlon():
    print "\nRun task Marlon-%s" %(os.getpid())
    start = time.time()
    time.sleep(random.random() * 40)
    end=time.time()
    print 'Task Marlon runs %0.2f seconds.' %(end - start)

def Allen():
    print "\nRun task Allen-%s" %(os.getpid())
    start = time.time()
    time.sleep(random.random() * 30)
    end = time.time()
    print 'Task Allen runs %0.2f seconds.' %(end - start)

def Frank():
    print "\nRun task Frank-%s" %(os.getpid())
    start = time.time()
    time.sleep(random.random() * 20)
    end = time.time()
    print 'Task Frank runs %0.2f seconds.' %(end - start)
        
if __name__=='__main__':
    function_list=  [Lee, Marlon, Allen, Frank] 
    print "parent process %s" %(os.getpid())

    pool=multiprocessing.Pool(4)
    for func in function_list:
        pool.apply_async(func)     #Pool执行函数，apply执行函数,当有一个进程执行完毕后，会添加一个新的进程到pool中

    print 'Waiting for all subprocesses done...'
    pool.close()
    pool.join()    #调用join之前，一定要先调用close() 函数，否则会出错, close()执行后不会有新的进程加入到pool,join函数等待素有子进程结束
    print 'All subprocesses done.'

# apply
# 主进程会阻塞于函数。主进程的执行流程同单进程一致
# apply_async
# 非阻塞的且支持结果返回后进行回调


# queue队列
class queue.Queue(maxsize=0) #先入先出
class queue.LifoQueue(maxsize=0) #后入先出
class queue.PriorityQueue(maxsize=0) #存储数据时可设置优先级的队列

queue.PriorityQueue 优先级案例一（使用数值进行优先级排序，数值越小优先级越高）

import Queue

class PriorityQueue(Queue.Queue):
    def _put(self, item):
        data, priority = item
        self._insort_right((priority, data))

    def _get(self):
        return self.queue.pop(0)[1]

    def _insort_right(self, x):
        """Insert item x in list, and keep it sorted assuming a is sorted.

        If x is already in list, insert it to the right of the rightmost x.       
        """
        a = self.queue
        lo = 0        
        hi = len(a)

        while lo < hi:
            mid = (lo+hi)/2
            if x[0] < a[mid][0]: hi = mid
            else: lo = mid+1
        a.insert(lo, x)

def test():
    pq = PriorityQueue()

    pq.put(('b', 1))
    pq.put(('a', 1))
    pq.put(('c', 1))
    pq.put(('z', 0))
    pq.put(('d', 2))

    while not pq.empty():
        print pq.get(),   

test()

# 使用heapq实现优先级队列

# coding=utf-8
from heapq import heappush, heappop

class PriorityQueue:
    def __init__(self):
        self._queue = []

    def put(self, item, priority):
        heappush(self._queue, (-priority, item))
        print(self._queue)

    def get(self):
        # print(heappop(self._queue),"---")
        return heappop(self._queue)[-1] #返回堆里面最小的值


q = PriorityQueue()
q.put('world', 1)
q.put('hello', 2)
print(q.get())
print(q.get())

processing.Value(typecode_or_type, *args, **kwds)                     # multiprocessing.Value('d', 0.0)
processing.Array(typecode_or_type, size_or_initializer, **kwds)       # multiprocessing.Array('i', range(10))

import multiprocessing

def f(n, a):
    n.value   = 3.14
    a[0]      = 5

num   = multiprocessing.Value('d', 0.0)
arr   = multiprocessing.Array('i', range(10))

p = multiprocessing.Process(target=f, args=(num, arr))
p.start()
p.join()

print num.value
print arr[:]
# -----------------------------------------------------------------------------
queue的用法
Queue.qsize()
返回队列的近似大小。注意，qsize() > 0并不能保证接下来的get()方法不被阻塞；同样，qsize() < maxsize也不能保证put()将不被阻塞。

Queue.empty()
如果队列是空的，则返回True，否则False。如果empty()返回True，并不能保证接下来的put()调用将不被阻塞。类似的，empty()返回False也不能保证接下来的get()调用将不被阻塞。

Queue.full()
如果队列满则返回True，否则返回False。如果full()返回True，并不能保证接下来的get()调用将不被阻塞。类似的，full()返回False也不能保证接下来的put()调用将不被阻塞。

Queue.put(item, block=True, timeout=None)
放item到队列中。如果block是True，且timeout是None，该方法将一直等待直到有队列有空余空间。如果timeout是一个正整数，该方法则最多阻塞timeout秒并抛出Full异常。如果block是False并且队列满，则直接抛出Full异常（这时timeout将被忽略）。

Queue.put_nowait(item)
等价于put(item, False)。

Queue.get(block=True, timeout=None)
从队列中移除被返回一个条目。如果block是True并且timeout是None，该方法将阻塞直到队列中有条目可用。如果timeout是正整数，该方法将最多阻塞timeout秒并抛出Empty异常。如果block是False并且队列为空，则直接抛出Empty异常（这时timeout将被忽略）。

Queue.get_nowait()
等价于get(False)。

如果需要跟踪进入队列中的任务是否已经被精灵消费者线程处理完成，可以使用下面提供的两个方法：

Queue.task_done()
表示一个先前的队列中的任务完成了。被队列消费者线程使用。对于每个get()获取到的任务，接下来的task_done()的调用告诉队列该任务的处理已经完成。
如果join()调用正在阻塞，当队列中所有的条目被处理后它将恢复执行（意味着task_done()调用将被放入队列中的每个条目接收到）。
如果调用次数超过了队列中放置的条目数目，将抛出ValueError异常。

Queue.join()
阻塞直到队列中所有条目都被获取并处理。

# -----------------------------------------------------------------------------
Manager
    通过Manager可实现进程间数据的共享。Manager()返回的manager对象会通过一个服务进程，来使其他进程通过代理的方式
 操作python对象。manager对象支持 list, dict, Namespace, Lock, RLock, Semaphore, BoundedSemaphore, Condition, 
 Event, Barrier, Queue, Value ,Array
from multiprocessing import Process, Manager
 
def f(d, l):
    d[1] = '1'
    d['2'] = 2
    d[0.25] = None
    l.append(1)
    print(l)
 
if __name__ == '__main__':
    with Manager() as manager:
        d = manager.dict()
 
        l = manager.list(range(5))
        p_list = []
        for i in range(10):
            p = Process(target=f, args=(d, l))
            p.start()
            p_list.append(p)
        for res in p_list:
            res.join()
 
        print(d)
        print(l)
        
# http://www.cnblogs.com/whatisfantasy/p/6440585.html