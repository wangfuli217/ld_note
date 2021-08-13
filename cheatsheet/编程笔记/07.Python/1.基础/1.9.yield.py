yield
    发音: 英 [jiːld]  美 [jild]

概论
    1.for-in 语句在底层都是对一个 Iterator(迭代器) 对象进行操作的
    2.使用了 yield 关键字的函数就是一个 Generator(生成器) 函数，被调用的时候生成一个可以控制自己运行的迭代器
    3.调用使用了 yield 关键字的函数,最好用 for-in 语句
    4. for循环、列表解析、in成员关系测试、map()内置函数、sorted()内置函数、zip()内置函数等都是用迭代协议来完成工作

    map(func,iterable)：它将函数func应用于传入的迭代器的每个迭代返回元素，返回一个新的迭代器，函数执行结果作为新迭代器的迭代值
    map()可以用于多个可迭代对象：map(func,[1,2,3],[2,3,4])，其中func(first,second) 的两个参数分别从两个可迭代对象中获取，函数结果作为新迭代器的迭代值
    zip(iterable1,iterable2,...)：它组合可迭代对象iterable1、iterable2、...中的各项，返回一个新的迭代器。新迭代器长度由iterable1、iterable2、...最短的那个决定。
    enumerate(iterable,start)：返回一个迭代器对象，它迭代结果是每次迭代返回一个(index,value)元组
    filter(func,iterable)：返回一个迭代器对象，它的迭代结果得到iterable中部分元素，其中这些元素使得func()函数返回为真
    reduce(func,iterable,initial)：对iterable中每一项成对地运行func，返回最终值
    sorted(iterable,key=None,reverse=False)：排序并返回排好的新列表
    sum(iterable,start)：返回可迭代对象中的累加值
    any(iterable)：只要可迭代对象iterable迭代返回的某个元素为真则返回True
    all(iterable)：只有可迭代对象iterable迭代返回的所有元素为真则返回True
    max(iterable,key=func)：返回最大元素。若指定func，则返回是func(num)最大的那个元素
    min(iterable,key=func)：返回最小元素。若指定func，则返回是func(num)最小的那个元素
    
    Python3中，range对象不支持.__next__()，因此它本身不是迭代器，而map、zip、filter对象都是迭代器。
    
Iterator(迭代器)
  迭代器是一个对象，它实现了迭代器协议，一般需要实现如下两个方法
    1. next 方法
        返回容器的下一个元素
    2. __iter__ 方法
        返回迭代器自身
    3. 在一系列迭代之后到达迭代器尾部，若再次调用.__next__()方法，则会触发StopIteration异常

    #这段 for-in 代码在运行的时候其实是调用了l的 __iter__() 函数，返回了一个实现了 __next__() 或 next() 的迭代器对象，每循环一次就会通过 next 取下一个元素
    l=[0,1,2,3,4,5,6]
    for i in l:
        print i

    l=[0,1,2,3]
    liter = iter(l)   # Python3 内置了一个next函数
    liter.__next()__  # next(liter)
    liter.__next()__  # next(liter)
    liter.__next()__  # next(liter)
    liter.__next()__  # next(liter)
    
1. 对任何迭代器对象iterator，调用iter(iterator)返回它本身
2. 文件对象本身是一个迭代器对象。即文件对象实现了迭代协议，因此打开多个文件会返回同一个文件对象
    l=[0,1,2,3]
    liter = iter(l) 
    lliter = iter(liter) 
    lliter is liter # 对迭代器调用iter返回自身
    
    file = open('F://test.txt',r)
    file_iter = iter(file)
    file_iter is file # 二者引用同一对象
3. 文件迭代器：文件对象本身是一个迭代器（这里文件对象要是读打开）。它的.__next__()方法每次调用时，返回文件中的下一行。当到达文件末尾时，.__next__()方法会引发StopIteration异常。
    file = open('F://test.txt',r)
    file.__next()__ 
    file.__next()__ 
4. 字典的视图：键视图、值视图、字典视图都没有.__next__()方法，因此他们都不是迭代器
    d = {'a':2, 'b':3}
    dir(d.keys())
    dir(d.values())
    dir(d.items())
5. for循环（及其它迭代环境）通过重复调用.__next__()方法直到捕获一个异常。若一个不支持迭代协议的对象想用工作在这种环境中，for循环会尝试使用索引协议迭代。

#当然我们完全没有必要先把所有的元素都算出来放到一个 list 里或者其他容器类里进行循环，这样比较浪费空间。我们可以直接创建自己的一个迭代器。
class Fib:
    '''''一个可以生成Fibonacci 数列的迭代器'''

    def __init__(self, max):
        self.max = max

    def __iter__(self):
        self.a = 0
        self.b = 1
        return self

    def next(self):
        fib = self.a
        if fib > self.max:
            raise StopIteration
        self.a, self.b = self.b, self.a + self.b
        return fib

for n in Fib(1000):
    print n

#当调用Fib(1000)的时候，将生成一个迭代器对象，每一次循环都将调用一次 next 取到下一个值。
#所以我们可以看出迭代器有一个很核心的东西就是在循环中，迭代器可以记住之前的状态。

Generator(生成器)
    生成器是调用一个生成器函数(generator function)返回的对象，多用于集合对象的迭代。
    将一个函数转化成 Iterator 对象的方法。
    使用它只需要在函数中需要返回值的时候调用 yield 语句。
    它是生成 Iterator 对象的简单方法，只适用于函数。
    任何使用了 yield 关键字的函数都不再是普通的函数了。

    def fib(max):
        a, b = 0, 1
        while a < max:
            yield a
            a, b = b, a + b

    #fib函数使用了 yield 所以它是一个生成器函数，当我们调用fib(1000)的时候它其实是返回了一个迭代器，且这个迭代器可以控制生成器函数的运行。
    #我们通过这个返回的迭代器的动作控制fib这个生成器函数的运行。
    #每当调用一次迭代器的 next 函数，生成器函数运行到 yield 之处，返回 yield 后面的值且在这个地方暂停，所有的状态都会被保持住，直到下次 next 函数被调用，或者碰到异常循环退出。

生成器函数：编写为常规的def语句，但是用yield语句一次返回一个结果。每次使用生成器函数时会继续上一轮的状态。
    生成器函数会保存上次执行的状态
定义生成器函数的语法为：
    def genFunc(num):
        for i in range(num):
            yield i**2
生成器函数执行时，得到一个生成器对象，它yield一个值，而不是返回一个值。
    生成器对象自动实现迭代协议，它有一个.__next__()方法
    对生成器对象调用.__next__()方法会继续生成器函数的运行到下一个yield 结果或引发一个StopIteration异常
yield语句会挂起生成器函数并向调用者发送一个值。当下一轮继续时，函数会在上一个yield表达式返回后继续执行，其本地变量根据上一轮保持的状态继续使用
生成器函数运行代码随时间产生一系列的值，而不是一次性计算它们。这会节约内存并允许计算时间分散。

1.假如你看到某个函数包含了 yield, 这意味着这个函数已经是一个 Generator, 它的执行会和其他普通的函数有很多不同。
    比如下面的简单的函数：
    def h():
        print 'To be brave'
        yield 5

    h()

    可以看到，调用h()之后, print 语句并没有执行！这就是 yield, 那么，如何让 print 语句执行呢？这就是后面要讨论的问题，通过后面的讨论和学习，就会明白 yield 的工作原理了


2.yield 是个表达式
    Python2.5以前, yield 是一个语句，但现在2.5中, yield 是一个表达式(Expression)，比如： m = yield 5
    表达式(yield 5)的返回值将赋值给m，所以，认为 m = 5 是错误的。那么如何获取(yield 5)的返回值呢？需要用到后面要介绍的 send(msg) 方法。

3. 透过 next() 语句看原理现在，我们来揭晓 yield 的工作原理。
    我们知道，我们上面的h()被调用后并没有执行，因为它有 yield 表达式，因此，我们通过 next() 语句让它执行。
    next()语句将恢复 Generator 执行，并直到下一个 yield 表达式处。
    比如：

    def h():
        print 'Wen Chuan'
        yield 5
        print 'Fighting!'

    c = h()
    print c.next()
    print c.next()

    调用后，h()开始执行，直到遇到
    yield 5结束，因此输出结果：???


4.send(msg)
    生成器对象有一个.send(arg)方法。该方法会将arg参数发送给生成器作为yield表达式的返回值，同时生成器会触发生成动作(相当于调用了一次.__next__()方法。
        要想启动生成器，可以直接使用next(generatorable)函数，也可以使用generatorable.send(None)方法，或者 generatorable.__next__()方法
        next(generatorable)函数相当于使用generatorable.send(None)方法
        generatorable.send(None)方法会在传递yield表达式的值（默认为None返回值），下一轮迭代从yield表达式返回开始

        生成器函数可以有return，它可以出现在函数内任何地方。生成器函数内遇到return则触发StopIteration异常，同时return的值作为异常说明
        可以调用生成器对象的.close()方法强制关闭它。这样再次给它send()任何信息，都会抛出StopIteration异常，表明没有什么可以生成的了
        
    每一轮挂起时，yield表达式 yield 一个数，但是并没有返回（挂起了该yield表达式）
    其实 next() 和 send() 在一定意义上作用是相似的，区别是 send() 可以传递 yield 表达式的值进去，而 next() 不能传递特定的值，只能传递None进去。
    因此，我们可以看做 c.next() 和 c.send(None) 作用是一样的。

    def h():
        print 'Wen Chuan',
        m = yield 5 # Fighting!
        print m
        d = yield 12
        print 'We are together!'

    c = h()
    c.next() #相当于c.send(None)
    c.send('Fighting!') #(yield 5)表达式被赋予了'Fighting!'

    输出的结果为：
    Wen Chuan Fighting!
    需要提醒的是，第一次调用时，请使用 next()语句或是 send(None), 不能使用 send 发送一个非 None 的值，否则会出错的，因为没有 yield 语句来接收这个值。


5.send(msg) 与 next()的返回值
    send(msg) 和 next()是有返回值的，它们的返回值很特殊，返回的是下一个yield表达式的参数。比如 yield 5, 则返回 5 。
    通过 for..in 遍历 Generator, 其实是每次都调用了 next(), 而每次 next() 的返回值正是 yield 的参数。


    def h():
        print 'Wen Chuan',
        m = yield 5 # Fighting!
        print m
        d = yield 12
        print 'We are together!'

    c = h()
    m = c.next() #m 获取了yield 5 的参数值 5
    d = c.send('Fighting!') #d 获取了yield 12 的参数值12
    print 'We will never forget the date', m, '.', d

    x = c.next() # yield 已经迭代完了，这里还调用就会报错


6. throw() 与 close() 中断 Generator
    中断 Generator 是一个非常灵活的技巧，可以通过 throw 抛出一个 GeneratorExit 异常来终止 Generator 。
    Close() 方法作用是一样的，其实内部它是调用了 throw(GeneratorExit) 的。我们看：

    def close(self):
        try:
            self.throw(GeneratorExit)
        except (GeneratorExit, StopIteration):
            pass
        else:
            raise RuntimeError("generator ignored GeneratorExit")  # Other exceptions are not caught

    因此，当我们调用了 close() 方法后，再调用 next() 或是 send(msg) 的话会抛出一个异常
    例:
        def gen():
            print 'enter'
            yield 1
            print 'next'
            yield 2
            print 'next end'

        c = gen()
        print(c.next()) # 调用第一个 yield
        c.close()
        print(c.next()) # 调用第二个 yield 出错了，抛出 StopIteration 的异常, 因为前面的 close 已经关闭它了



yield 用法
    1) 包含 yield 的函数是一个 Generator, 与平常的函数不同

    例：
        def gen():
            print 'enter'
            yield 1
            print 'next'
            yield 2
            print 'next end'

        print('begin...')
        gen() # 直接调用,发现打印没有执行(与平常的函数不同)
        # 从容器里拿到 iterator 的时候它还什么也不是，处在容器入口处，对于数组来说就是下标为-1的地方，对于函数来说就是函数入口嘛事没干，但是万事俱备就欠 next 。
        print('end...')

        print
        # 个人感觉，用 for-in 调用有 yield 的函数是最方便的了
        for i in gen():
            print('...%d...' % i)

        # 开始 for in , next 让 itreator 爬行到 yield 语句存在的地方并返回值,
        # 再次 next 就再爬到下一个 yield 语句存在的地方并返回值,依次这样直到函数返回(容器尽头)。

    上面代码的输出是：
        begin...
        end...

        enter
        ...1...
        next
        ...2...
        next end


