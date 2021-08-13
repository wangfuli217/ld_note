
Greenlet 状态
=============================
就像任何其他成段代码，Greenlet 也可能以不同的方式运行失败。 Greenlet 可能未能成功抛出异常，不能停止运行，或消耗了太多的系统资源。
一个 greenlet 的状态通常是一个依赖于时间的参数。在 greenlet 中有一些标志， 让你可以监视它的线程内部状态：

    started -- Boolean, 指示此 Greenlet 是否已经启动
    ready() -- Boolean, 指示此 Greenlet 是否已经停止
    successful() -- Boolean, 指示此 Greenlet 是否已经停止而且没抛异常
    value -- 任意值, 此 Greenlet 代码返回的值
    exception -- 异常, 此 Greenlet 内抛出的未捕获异常


# 示例
    import gevent

    def win():
        return 'You win!'

    def fail():
        raise Exception('You fail at failing.')

    winner = gevent.spawn(win)
    loser = gevent.spawn(fail)

    print(winner.started) # True
    print(loser.started)  # True

    # Exceptions raised in the Greenlet, stay inside the Greenlet.
    # Greenlet 执行时遇到的异常，只会停留在 Greenlet 内部，抛不出来。
    try:
        gevent.joinall([winner, loser])
    except Exception as e:
        print('This will never be reached')

    print(winner.value) # 'You win!'
    print(loser.value)  # None

    print(winner.ready()) # True
    print(loser.ready())  # True

    print(winner.successful()) # True
    print(loser.successful())  # False

    # The exception raised in fail, will not propogate outside the greenlet.
    # A stack trace will be printed to stdout but it will not unwind the stack of the parent.
    # 在 fail 函数里面抛出的异常，不会传递到 greenlet 的外层。可以获取里面执行时抛出的异常信息，但他不会打断父线程的执行。
    print(loser.exception) # You fail at failing.

    # It is possible though to raise the exception again outside
    # raise loser.exception
    # or with
    # loser.get()

