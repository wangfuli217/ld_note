
超时
=============================
超时是一种对一块代码或一个Greenlet的运行时间的约束。

# 示例
    import gevent
    from gevent import Timeout

    seconds = 10

    timeout = Timeout(seconds)
    timeout.start()

    def wait():
        gevent.sleep(10)

    try:
        gevent.spawn(wait).join()
    except Timeout:
        print('Could not complete')


超时类也可以用在上下文管理器(context manager)中, 也就是with语句内。

# 示例
    import gevent
    from gevent import Timeout

    time_to_wait = 5 # seconds

    class TooLong(Exception):
        pass

    with Timeout(time_to_wait, TooLong):
        gevent.sleep(10)


另外，对各种Greenlet和数据结构相关的调用，gevent也提供了超时参数。 例如：

# 示例
    import gevent
    from gevent import Timeout

    def wait():
        gevent.sleep(2)

    timer = Timeout(1).start()
    thread1 = gevent.spawn(wait)

    try:
        thread1.join(timeout=timer)
    except Timeout:
        print('Thread 1 timed out')

    # --

    timer = Timeout.start_new(1)
    thread2 = gevent.spawn(wait)

    try:
        thread2.get(timeout=timer)
    except Timeout:
        print('Thread 2 timed out')

    # --

    try:
        gevent.with_timeout(1, wait)
    except Timeout:
        print('Thread 3 timed out')


    # 运行结果：
    Thread 1 timed out
    Thread 2 timed out
    Thread 3 timed out
