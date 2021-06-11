Python 标准库提供了 thread 和 threading 两个模块来对多线程进行支持。
    thread 模块以低级、原始的方式来处理和控制线程。一般不建议使用。
    threading 对thread进行了封装，将一些线程的操作对象化，提供下列类：
            Thread 线程类
            Timer与Thread类似，但要等待一段时间后才开始运行
            Lock 锁原语
            RLock 可重入锁。使单线程可以再次获得已经获得的锁
            Condition 条件变量，能让一个线程停下来，等待其他线程满足某个"条件"
            Event 通用的条件变量。多个线程可以等待某个事件发生，在事件发生后，所有的线程都被激活
            Semaphore为等待锁的线程提供一个类似"等候室"的结构
            BoundedSemaphore 与semaphore类似，但不允许超过初始值
        Queue：实现了多生产者（Producer）、多消费者（Consumer）的队列，支持锁原语，能够在多个线程之间提供很好的同步支持。提供的类：
            Queue队列 #FIFO（先入先出)队列Queue
            LifoQueue后入先出（LIFO）队列 # LIFO（后入先出）队列LifoQueue
            PriorityQueue 优先队列 # 优先级队列PriorityQueue

多线程
  1、函数式：调用thread模块中的start_new_thread()函数来产生新线程。如：
    import time
    import thread

    def timer(no, interval):
        cnt = 0
        while cnt<10:
            print 'Thread:(%d) Time:%s\n'%(no, time.ctime())
            #time.sleep(interval)
            cnt += 1
        # 线程的结束可以等待线程自然结束，也可以在线程函数中调用 thread.exit() 或 thread.exit_thread() 方法。
        thread.exit_thread()

    def test():
        # 用 thread.start_new_thread() 来创建两个线程
        # thread.start_new_thread(function, args[, kwargs]) 的第一个参数是线程函数；第二个参数是传递给线程函数的参数，它必须是tuple类型；kwargs是可选参数
        thread1 = thread.start_new_thread(timer, (1,1))
        thread2 = thread.start_new(timer, (2,2)) # start_new 是 start_new_thread 的另一个名称, 不过这名称已过时
        print '开始运行\n'
        time.sleep(1) # 此处如果不睡的话会报错,因为主进程结束而子线程没结束
        print '运行结束'

    if __name__=='__main__':
        test()


  2、创建 threading.Thread 的子类来包装一个线程对象，如下例：
    import threading
    import time

    class timer(threading.Thread): #The timer class is derived from the class threading.Thread
        def __init__(self, num, interval):
            threading.Thread.__init__(self)
            self.thread_num = num
            self.interval = interval
            self.thread_stop = False

        def run(self): #Overwrite run() method, put what you want the thread do here
            while not self.thread_stop:
                print 'Thread Object(%d), Time:%s\n' %(self.thread_num, time.time())
                time.sleep(self.interval)

        def stop(self):
            self.thread_stop = True


    def test():
        thread1 = timer(1, 1)
        thread2 = timer(2, 2)
        thread1.start()
        thread2.start()
        time.sleep(10)
        thread1.stop()
        thread2.stop()
        return

    if __name__ == '__main__':
        test()


    threading.Thread类的使用：
    1. 在自己的线程类的 __init__ 里调用 threading.Thread.__init__(self, name = threadname) # threadname 为线程的名字
    2. run()，通常需要重写，编写代码实现做需要的功能。
    3. getName()，获得线程对象名称
    4. setName()，设置线程对象名称
    5. start()，启动线程
    6. join(timeout=None)，等待另一线程结束后再运行。如果给出timeout，则最多阻塞timeout秒
    7. setDaemon(bool)，设置子线程是否随主线程一起结束，必须在start()之前调用。默认为 False 。
    8. isDaemon()，判断线程是否随主线程一起结束。
    9. isAlive()，检查线程是否在运行中。
       此外threading模块本身也提供了很多方法和其他的类，可以帮助我们更好的使用和管理线程。可以参看http://www.python.org/doc/2.5.2/lib/module-threading.html。

  3、使用 threading.Thread 启动线程对象，如下例：
    import threading

    def worker(a_tid,a_account):
        print a_tid,a_account

    # 参数 target 是要执行的函数, args 里面的是参数列表,kwargs是字典式的参数列表
    th = threading.Thread(target=worker,args=(), kwargs={'a_tid':'a', 'a_account':2} )

    # 启动这个线程
    th.start()

    # 等待线程返回
    th.join()
    # 或者 threading.Thread.join(th)


    # 创建锁
    g_mutex = threading.Lock()
    # .... code ...

    # 使用锁
    # 锁定，从下一句代码到释放前互斥访问
    g_mutex.acquire()
    # .... code ...
    # 释放锁
    g_mutex.release()


http://www.cnblogs.com/tqsummer/archive/2011/01/25/1944771.html
http://blog.sina.com.cn/s/blog_4b5039210100esc1.html
http://sm4llb0y.blog.163.com/blog/static/18912397200981594357140/


多进程 (从 2.6 起增加了子进程级别的并行开发支持 —— multiprocessing)
    #!/usr/bin/env python
    # -*- coding:utf-8 -*-

    import os, time
    from multiprocessing import current_process, Pool

    def test(x):
        print current_process().pid, x
        #time.sleep(1)

    if __name__ == "__main__":
        print "main:", os.getpid()
        p = Pool(5)
        p.map(test, range(13)) # 启动13个子进程
        time.sleep(1)

  1. Process
    我们先从最根本的 Process 入手，看看是如何启动子进程完成并行计算的。上面的 Pool 不过是创建多个 Process，然后将数据(args)提交给多个子进程完成而已。

    import os, time
    from multiprocessing import current_process, Process

    def test(x):
        print current_process().pid, x
        time.sleep(1)

    if __name__ == "__main__":
        print "main:", os.getpid()
        p = Process(target = test, args = [100])
        p.start()
        p.join()


程序退出时执行
    # 注册 atexit 函数来解决
    # 如果中途关闭运行窗口，无法调用结束事件
    import threading
    import time
    import atexit

    def clean():
        print "clean temp data..."

    def test():
        for i in range(10):
            name = threading.currentThread().name
            print name, i
            # time.sleep(1)

    if __name__ == "__main__":
        atexit.register(clean) # 注册程序结束时执行的函数
        threading.Thread(target = test).start()
        time.sleep(1)

        exit(4) # quit() 和 exit() 会等待所有前台线程退出，同时会调用退出函数。
        import sys; sys.exit(4) # 和 exit / quit 作用基本相同。等待前台线程退出，调用退出函数。
        import os; os._exit(4) # os._exit() 通过系统调用来终止进程的，所有线程和退出函数统统滚蛋。

        time.sleep(1)
        print "Ho ..."

    import subprocess


程序退出时执行
    # 通过 subprocess.Popen 函数来解决；但会发生问题，不知道内部是什么原因
    import subprocess
    proc = subprocess.Popen("python test.py")
    proc.wait()

    # 前面的程序结束后，才继续执行下面的代码
    test_file = open('test.txt', 'wb')
    test_file.write('hello') # 这里的写入偶尔会出问题，不知道原因
    test_file.close()


控制最大线程数(范例)
    '''范例 1, 限制最大线程数量'''
    NOTIFY_THREADS = 20 # 最大线程数
    urls = get_notify_urls() # 获取要处理的 url 列表(假设这里会返回 tuple|list 类型的数据)
    # 采用多线程发请求,可大大提高效率。
    threads = []
    # 下面用循环控制最大线程数,且保证将 参数 urls 平均分配到各线程,每个线程处理的参数数量大致一样(误差 1 个)
    for index in range(NOTIFY_THREADS):
        th = threading.Thread(target=send_urls, args=(urls[index::NOTIFY_THREADS],)) # 处理数据的函数名为 send_urls, 接收参数: {list} urls
        th.start() # 启动这个线程
        threads.append(th)
    # 等待各线程返回,避免定时器下次再来重复调用,也为了控制线程数量
    for th in threads:
        th.join()


    '''范例 2, 限制最大线程数量,且根据 uid 分配线程(同一个 uid 须保证在同一个线程内)'''
    SEND_PRODUCT_THREAD = 20 # 最大线程数
    products = query_products(500) # 获取产品列表(假设这里会返回 tuple<dict> 类型的数据,其中 dict 里面包含 uid 字段)
    if not products:
        return
    # 使用多线程,但需要保证顺序,同一个uid的发货需要保证在同一个线程中
    thread_products = {} # 先用一个 dict 来保存各线程需要处理的数据列表,然后逐个遍历这个 dict 来启动多线程
    for product_data in products:
        uid = product_data['uid']
        mo = str(uid % SEND_PRODUCT_THREAD) # 对uid取模
        product_list = thread_products.get(mo)
        if not product_list:
            product_list = []
            thread_products[mo] = product_list
        product_list.append(product_data)
    # 发启各线程处理数据
    thread_list = []
    for mo, product_list in thread_products.items():
        th = threading.Thread(target=send_product, args=(product_list,)) # 处理数据的函数名为 send_product, 接收参数: {list<{dict} product_data>} product_list
        th.start() # 启动这个线程
        thread_list.append(th) # 保存这个线程
    # 等待各线程返回
    for th in thread_list:
        th.join()


线程锁(线程安全)
    import time
    import threading

    # 线程安全锁
    mylock = threading.RLock()
    num = 1

    def http():
        global num
        mylock.acquire() # 开启线程安全锁
        num += 1
        print num
        time.sleep(0.1)
        print time.time()
        mylock.release() # 释放锁

    threading_list = []
    for i in range(10):
        th = threading.Thread(target = http)
        th.start()
        threading_list.append(th)

    for th in threading_list:
        th.join()


线程定时器
    调用threading提供的定时器。定时器在指定时间之后开始执行，在执行前还可以取消执行。

    import threading
    import time

    def delayed():
        print('worker running')
        return

    t1 = threading.Timer(3, delayed) # 指定 3 秒后运行 delayed 函数
    t1.setName('t1')

    print(time.localtime())
    print('starting timers')
    t1.start()

    time.sleep(2)
    print(time.localtime())
    #t1.cancel() # 在执行前可以取消执行
    print('done')
    # 会在打印 done 之后执行 delayed 函数,打印 'worker running'


