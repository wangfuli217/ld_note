
同步和异步执行
=============================

并发的核心思想在于，大的任务可以分解成一系列的子任务，后者可以被调度成 同时执行或异步执行, 而不是一次一个地或者同步地执行。
两个子任务之间的 切换也就是上下文切换。

在 gevent 里面，上下文切换是通过 yielding 来完成的.
在下面的例子里， 我们有两个上下文，通过调用 gevent.sleep(0), 它们各自 yield 向对方。


    # 示例
    import gevent

    def foo():
        print('Running in foo')
        gevent.sleep(0) # 注意，不同于 time.sleep(2)
        print('Explicit context switch to foo again')

    def bar():
        print('Explicit context to bar')
        gevent.sleep(0)
        print('Implicit context switch back to bar')

    gevent.joinall([
        gevent.spawn(foo), # 如果被调用的函数需要传参，则写成： gevent.spawn(foo, 参数1, 参数2, ...)
        gevent.spawn(bar),
    ])

    # 输出结果
    Running in foo
    Explicit context to bar
    Explicit context switch to foo again
    Implicit context switch back to bar

    #上述示例的执行步骤(按行执行)：
    1. import gevent
    2. def foo():
    3. def bar():
    4. gevent.joinall([ gevent.spawn(foo), gevent.spawn(bar), ])
    5. print('Running in foo')
    6. gevent.sleep(0)
    7. print('Explicit context to bar')
    8. gevent.sleep(0)
    9. print('Explicit context switch to foo again')
    10.print('Implicit context switch back to bar')



当我们在受限于网络或IO的函数中使用gevent，这些函数会被协作式的调度， gevent的真正能力会得到发挥。
Gevent处理了所有的细节， 来保证你的网络库会在可能的时候，隐式交出greenlet上下文的执行权。
这样的一种用法是如何强大，怎么强调都不为过。下面举些例子来详述。

    #下面例子中的 select() 函数通常是一个在各种文件描述符上轮询的阻塞调用。

    # 示例
    import time
    import gevent
    from gevent.select import select

    start = time.time()
    tic = lambda: 'at %1.1f seconds' % (time.time() - start)

    def gr1():
        # Busy waits for a second, but we don't want to stick around...
        print('Started gr1 Polling: %s' % tic())
        select([], [], [], 2)
        print('Ended gr1 Polling: %s' % tic())

    def gr2():
        # Busy waits for a second, but we don't want to stick around...
        print('Started gr2 Polling: %s' % tic())
        select([], [], [], 2)
        print('Ended gr2 Polling: %s' % tic())

    def gr3():
        print("Hey lets do some stuff while the greenlets poll, %s" % tic())
        gevent.sleep(1)

    gevent.joinall([
        gevent.spawn(gr1),
        gevent.spawn(gr2),
        gevent.spawn(gr3),
    ])

    # 输出结果
    Started gr1 Polling: at 0.0 seconds
    Started gr2 Polling: at 0.0 seconds
    Hey lets do some stuff while the greenlets poll, at 0.0 seconds
    Ended gr1 Polling: at 2.0 seconds
    Ended gr2 Polling: at 2.0 seconds



下面是另外一个多少有点人造色彩的例子，定义一个 非确定性的(non-deterministic) 的 task 函数(给定相同输入的情况下，它的输出不保证相同)。
此例中执行这个函数的副作用就是，每次 task 在它的执行过程中都会随机地停某些秒。

    # 示例
    import gevent
    import random
    from datetime import datetime

    def task(pid):
        """
        Some non-deterministic task
        """
        gevent.sleep(random.randint(0,2)*0.01)
        print('Task %s done' % pid)

    def synchronous():
        for i in range(1,10):
            task(i)

    def asynchronous():
        # gevent.spawn 传参给要调用的函数, 参数从 gevent.spawn 的第二个参数开始就行了
        threads = [gevent.spawn(task, i) for i in xrange(10)]
        gevent.joinall(threads)

    syn_start = datetime.now()
    print('Synchronous:')
    synchronous()
    print('use:' + str((datetime.now() - syn_start).microseconds)) # 用于查看总消耗时间

    asyn_start = datetime.now()
    print('Asynchronous:')
    asynchronous()
    print('use:' + str((datetime.now() - asyn_start).microseconds)) # 用于查看总消耗时间

    # 输出结果
    Synchronous:
    Task 1 done
    Task 2 done
    Task 3 done
    Task 4 done
    Task 5 done
    Task 6 done
    Task 7 done
    Task 8 done
    Task 9 done
    use:90000
    Asynchronous:
    Task 1 done
    Task 2 done
    Task 8 done
    Task 6 done
    Task 4 done
    Task 9 done
    Task 7 done
    Task 0 done
    Task 5 done
    Task 3 done
    use:20000



上例中，在同步的部分，所有的 task 都同步的执行， 结果当每个task在执行时主流程被阻塞(主流程的执行暂时停住)。

程序的重要部分是将 task 函数封装到 Greenlet 内部线程的 gevent.spawn。
初始化的 greenlet 列表存放在数组 threads 中，此数组被传给 gevent.joinall 函数，后者阻塞当前流程，并执行所有给定的 greenlet。
执行流程只会在 所有greenlet执行完后才会继续向下走。

要重点留意的是，异步的部分本质上是随机的，而且异步部分的整体运行时间比同步 要大大减少。
事实上，同步部分的最大运行时间，即是每个 task 停 0.02 秒，结果整个 队列要停 0.2 秒。
而异步部分的最大运行时间大致为 0.02 秒，因为没有任何一个 task 会 阻塞其它 task 的执行。


一个更常见的应用场景, 如异步地向服务器取数据, 取数据操作的执行时间 依赖于发起取数据请求时远端服务器的负载, 各个请求的执行时间会有差别。

    # 示例
    import gevent.monkey
    gevent.monkey.patch_socket()

    import gevent
    import urllib2
    import simplejson as json

    def fetch(pid):
        response = urllib2.urlopen('http://json-time.appspot.com/time.json')
        result = response.read()
        json_result = json.loads(result)
        datetime = json_result['datetime']

        print('Process %s: %s' % (pid, datetime))
        return json_result['datetime']

    def synchronous():
        for i in range(1,10):
            fetch(i)

    def asynchronous():
        threads = []
        for i in range(1,10):
            threads.append(gevent.spawn(fetch, i))
        gevent.joinall(threads)

    print('Synchronous:')
    synchronous()

    print('Asynchronous:')
    asynchronous()

