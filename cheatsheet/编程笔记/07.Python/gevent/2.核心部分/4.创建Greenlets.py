
创建Greenlets
=============================
gevent 对 Greenlet 初始化提供了一些封装，最常用的使用模板之一有

# 示例
    import gevent
    from gevent import Greenlet

    def foo(message, n):
        """
        Each thread will be passed the message, and n arguments in its initialization.
        每个线程初始化时都需要传递 message 和 n 参数
        """
        gevent.sleep(n)
        print(message)

    # Initialize a new Greenlet instance running the named function foo
    # 初始化一个新的 Greenlet 实例，用来运行名为 foo 的函数
    thread1 = Greenlet.spawn(foo, "Hello", 1)   ### 省去了线程的 start() 步骤 ###

    # Wrapper for creating and running a new Greenlet from the named function foo, with the passed arguments
    # 新建一个将要运行的 Greenlet 实例，它将名为 foo 的函数和这函数需要的参数封装起来
    thread2 = gevent.spawn(foo, "I live!", 2)   ### 注意 thread1 和 thread2 的不同点，这里是用 gevent.spawn， 而 thread1 是用 Greenlet.spawn ###

    # Lambda expressions
    # Lambda 表达式的封装
    thread3 = gevent.spawn(lambda x: (x+1), 2)

    threads = [thread1, thread2, thread3]

    # Block until all threads complete.
    # 阻塞，等待所有线程都运行完为止(其实是等待所有的协程运行完毕)
    gevent.joinall(threads)

    # 打印结果：
    Hello
    I live!



除使用基本的Greenlet类之外，你也可以子类化Greenlet类，重载它的_run方法。

# 示例
    import gevent
    from gevent import Greenlet

    class MyGreenlet(Greenlet):

        def __init__(self, message, n):
            Greenlet.__init__(self)
            self.message = message
            self.n = n

        def _run(self):
            print(self.message)
            gevent.sleep(self.n)

    g = MyGreenlet("Hi there!", 3)
    g.start()
    g.join()


    Hi there!
