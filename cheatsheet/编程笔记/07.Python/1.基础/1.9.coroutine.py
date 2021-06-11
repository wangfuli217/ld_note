https://github.com/18965050/fluent-python/wiki/Fluent-Python%E8%AF%BB%E4%B9%A6%E7%AC%94%E8%AE%B0(%E5%8D%81%E4%B8%80)

协程
    协程和generator很像. 基本格式为:
        var = yield [expression]
    coroutine是generator的进一步发展:同调用者协同工作,从调用者接受数据并产生结果给调用者
    协程和.send(),.throw(),.close()方法配合使用.

    >>> def simple_coroutine(): #
    ... print('-> coroutine started')
    ... x = yield #
    ... print('-> coroutine received:', x)
    ...
    >>> my_coro = simple_coroutine()
    >>> my_coro #
    <generator object simple_coroutine at 0x100c2be10>
    >>> next(my_coro) #
    -> coroutine started
    >>> my_coro.send(42) #
    -> coroutine received: 42
    Traceback (most recent call last): #
    ...
    StopIteration

协程状态
    协程有四个状态, 可通过inspect.getgeneratorstate()方法查看:
        GEN_CREATED: 等待执行. 对应上述例子的my_coro = simple_coroutine()
        GEN_RUNNING: 运行中. 对应上述例子的next(my_coro)
        GEN_SUSPENDED: 被yield表达式挂起. 对应上述例子中的x = yield
        GEN_CLOSED: 执行完成
    如果一个协程创建后, 立刻通过.send()传输一个不为None的值, 会抛出异常
        >>> my_coro = simple_coroutine()
        >>> my_coro.send(1729)
        Traceback (most recent call last):
        File "<stdin>", line 1, in <module>
        TypeError: can't send non-None value to a just-started generator
    但如果通过.send(None)调用则不会.
    >>> def simple_coro2(a):
    ... print('-> Started: a =', a)
    ... b = yield a
    ... print('-> Received: b =', b)
    ... c = yield a + b
    ... print('-> Received: c =', c)
    ...
    >>> my_coro2 = simple_coro2(14)
    >>> from inspect import getgeneratorstate
    >>> getgeneratorstate(my_coro2)
    'GEN_CREATED'
    >>> next(my_coro2)
    -> Started: a = 14
    14
    >>> getgeneratorstate(my_coro2)
    'GEN_SUSPENDED'
    >>> my_coro2.send(28)
    -> Received: b = 28
    42
    >>> my_coro2.send(99)
    -> Received: c = 99
    Traceback (most recent call last):
    File "<stdin>", line 1, in <module>
    StopIteration
    >>> getgeneratorstate(my_coro2) 
    'GEN_CLOSED'
    
使用装饰器来装饰协程
    使用协程的一般步骤为:
        创建协程
        调用next()方法
        调用.send()方法
        如果要停止, 调用.close()方法; 如果要抛出异常, 调用.throw()方法

    上述的步骤有点繁琐, 如果不记得先要调用next()而直接调用.send()方法, 则会抛出异常. 
    我们可以使用装饰器来简化此问题.

    from functools import wraps
    def coroutine(func):
        """Decorator: primes `func` by advancing to first `yield`"""
        @wraps(func)
        def primer(*args,**kwargs):
            gen = func(*args,**kwargs)
            next(gen)
            return gen
        return primer   
        
        
generator.throw和generator.close
    """
    Coroutine closing demonstration::
    
    # BEGIN DEMO_CORO_EXC_1
        >>> exc_coro = demo_exc_handling()
        >>> next(exc_coro)
        -> coroutine started
        >>> exc_coro.send(11)
        -> coroutine received: 11
        >>> exc_coro.send(22)
        -> coroutine received: 22
        >>> exc_coro.close()
        >>> from inspect import getgeneratorstate
        >>> getgeneratorstate(exc_coro)
        'GEN_CLOSED'
    
    # END DEMO_CORO_EXC_1
    
    Coroutine handling exception::
    
    # BEGIN DEMO_CORO_EXC_2
        >>> exc_coro = demo_exc_handling()
        >>> next(exc_coro)
        -> coroutine started
        >>> exc_coro.send(11)
        -> coroutine received: 11
        >>> exc_coro.throw(DemoException)
        *** DemoException handled. Continuing...
        >>> getgeneratorstate(exc_coro)
        'GEN_SUSPENDED'
    
    # END DEMO_CORO_EXC_2
    
    Coroutine not handling exception::
    
    # BEGIN DEMO_CORO_EXC_3
        >>> exc_coro = demo_exc_handling()
        >>> next(exc_coro)
        -> coroutine started
        >>> exc_coro.send(11)
        -> coroutine received: 11
        >>> exc_coro.throw(ZeroDivisionError)
        Traceback (most recent call last):
        ...
        ZeroDivisionError
        >>> getgeneratorstate(exc_coro)
        'GEN_CLOSED'
    
    # END DEMO_CORO_EXC_3
    """
    
    # BEGIN EX_CORO_EXC
    class DemoException(Exception):
        """An exception type for the demonstration."""
    
    def demo_exc_handling():
        print('-> coroutine started')
        while True:
            try:
                x = yield
            except DemoException:  # <1>
                print('*** DemoException handled. Continuing...')
            else:  # <2>
                print('-> coroutine received: {!r}'.format(x))
        raise RuntimeError('This line should never run.')  # <3>
    # END EX_CORO_EXC

从协程中返回值
    """
    A coroutine to compute a running average.
    
    Testing ``averager`` by itself::
    
    # BEGIN RETURNING_AVERAGER_DEMO1
    
        >>> coro_avg = averager()
        >>> next(coro_avg)
        >>> coro_avg.send(10)  # <1>
        >>> coro_avg.send(30)
        >>> coro_avg.send(6.5)
        >>> coro_avg.send(None)  # <2>
        Traceback (most recent call last):
        ...
        StopIteration: Result(count=3, average=15.5)
    
    # END RETURNING_AVERAGER_DEMO1
    
    Catching `StopIteration` to extract the value returned by
    the coroutine::
    
    # BEGIN RETURNING_AVERAGER_DEMO2
    
        >>> coro_avg = averager()
        >>> next(coro_avg)
        >>> coro_avg.send(10)
        >>> coro_avg.send(30)
        >>> coro_avg.send(6.5)
        >>> try:
        ...     coro_avg.send(None)
        ... except StopIteration as exc:
        ...     result = exc.value
        ...
        >>> result
        Result(count=3, average=15.5)
    
    # END RETURNING_AVERAGER_DEMO2
    
    
    """
    
    # BEGIN RETURNING_AVERAGER
    from collections import namedtuple
    
    Result = namedtuple('Result', 'count average')
    
    
    def averager():
        total = 0.0
        count = 0
        average = None
        while True:
            term = yield
            if term is None:
                break  # <1>
            total += term
            count += 1
            average = total/count
        return Result(count, average)  # <2>
    # END RETURNING_AVERAGER