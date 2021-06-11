设置全局变量
    >>> a
    Traceback (most recent call last):
    File "<stdin>", line 1, in <module>
    NameError: name 'a' is not defined
    >>> d = {'a': 1, 'b':2}
    >>> # 粗暴的写法
    >>> for k, v in d.iteritems():
    ...     exec "{}={}".format(k, v)
    ...
    >>> # 文艺的写法
    >>> globals().update(d)
    >>> a, b
    (1, 2)
    >>> 'a', 'b'
    ('a', 'b')
    >>> globals()['a'] = 'b'
    >>> a
    'b'
    
字符串格式化
    >>> "{key}={value}".format(key="a", value=10) # 使⽤命名参数
    'a=10'
    >>> "[{0:<10}], [{0:^10}], [{0:*>10}]".format("a") # 左中右对⻬
    '[a         ], [    a     ], [*********a]'
    >>> "{0.platform}".format(sys) # 成员
    'darwin'
    >>> "{0[a]}".format(dict(a=10, b=20)) # 字典
    '10'
    >>> "{0[5]}".format(range(10)) # 列表
    '5'
    >>> "My name is {0} :-{{}}".format('Fred') # 真得想显示{},需要双{}
    'My name is Fred :-{}'
    >>> "{0!r:20}".format("Hello")
    "'Hello'             "
    >>> "{0!s:20}".format("Hello")
    'Hello               '
    >>> "Today is: {0:%a %b %d %H:%M:%S %Y}".format(datetime.now())
    'Today is: Mon Mar 31 23:59:34 2014'
    
列表去重
    >>> l = [1, 2, 2, 3, 3, 3]
    >>> {}.fromkeys(l).keys()
    [1, 2, 3] # 列表去重(1)
    >>> list(set(l)) # 列表去重(2)
    [1, 2, 3]
    In [2]: %timeit list(set(l))
    1000000 loops, best of 3: 956 ns per loop
    In [3]: %timeit {}.fromkeys(l).keys()
    1000000 loops, best of 3: 1.1 µs per loop
    In [4]: l = [random.randint(1, 50) for i in range(10000)]
    In [5]: %timeit list(set(l))
    1000 loops, best of 3: 271 µs per loop
    In [6]: %timeit {}.fromkeys(l).keys()
    1000 loops, best of 3: 310 µs per loop 
    PS: 在字典较大的情况下, 列表去重(1)略慢了
    
操作字典
    >>> dict((["a", 1], ["b", 2])) # ⽤两个序列类型构造字典
    {'a': 1, 'b': 2}
    >>> dict(zip("ab", range(2)))
    {'a': 0, 'b': 1}
    >>> dict(map(None, "abc", range(2)))
    {'a': 0, 'c': None, 'b': 1}
    >>> dict.fromkeys("abc", 1) # ⽤序列做 key,并提供默认 value
    {'a': 1, 'c': 1, 'b': 1}
    >>> {k:v for k, v in zip("abc", range(3))} # 字典解析
    {'a': 0, 'c': 2, 'b': 1}
    >>> d = {"a":1, "b":2}
    >>> d.setdefault("a", 100) # key 存在,直接返回 value
    1
    >>> d.setdefault("c", 200) # key 不存在,先设置,后返回
    200
    >>> d
    {'a': 1, 'c': 200, 'b': 2}

字典视图
    >>> d1 = dict(a = 1, b = 2)
    >>> d2 = dict(b = 2, c = 3)
    >>> d1 & d2 # 字典不⽀支持该操作
    Traceback (most recent call last):
    File "<stdin>", line 1, in <module>
    TypeError: unsupported operand type(s) for &: 'dict' and 'dict'
    >>> v1 = d1.viewitems()
    >>> v2 = d2.viewitems()
    >>> v1 & v2 # 交集
    set([('b', 2)])
    >>> dict(v1 & v2) # 可以转化为字典
    {'b': 2}
    >>> v1 | v2 # 并集
    set([('a', 1), ('b', 2), ('c', 3)])
    >>> v1 - v2 #差集(仅v1有,v2没有的)
    set([('a', 1)])
    >>> v1 ^ v2 # 对称差集 (不会同时出现在 v1 和 v2 中)
    set([('a', 1), ('c', 3)])
    >>> ('a', 1) in v1 #判断
    True
    
vars
    >>> vars() is locals()
    True
    >>> vars(sys) is sys.__dict__
    True
    
from __future__ import unicode_literals
    >>> s = '美的'
    >>> s
    '\xe7\xbe\x8e\xe7\x9a\x84'
    >>> from __future__ import unicode_literals
    >>> s = '美的'
    >>> s
    u'\u7f8e\u7684'
    >>> s.encode('utf-8')
    '\xe7\xbe\x8e\xe7\x9a\x84'
    >>> s = b'美的'
    >>> s
    '\xe7\xbe\x8e\xe7\x9a\x84'
    >>> type(s)
    <type 'str'>
    
    
一个关于编码的问题
    $cat encoding_example.py 
    # encoding: utf-8
    name = 'helló wörld from example'
    $cat encoding.py 
    # encoding: utf-8
    from __future__ import unicode_literals
    import encoding_example as a
    b = 'helló wörld from this'
    print b + a.name
    $python encoding.py 
    Traceback (most recent call last):
    File "encoding.py", line 6, in <module>
        print b + a.name
    UnicodeDecodeError: 'ascii' codec can't decode byte 0xc3 in position 4: ordinal not in range(128)
    
    原因是: encoding_example里面没有对文字自动转化为unicode,默认是ascii编码
    $cat encoding.py 
    # encoding: utf-8
    
    >>> from __future__ import unicode_literals
    >>> import encoding_example as a
    >>> b = 'helló wörld from this'
    >>> print b + a.name.decode('utf-8')
    helló wörld from thishelló wörld from example
    >>> # 或者这样用:
    >>> print b.encode('utf-8') + a.name
    helló wörld from thishelló wörld from example

super 当子类调用父类属性时一般的做法是这样
    >>> class LoggingDict(dict): 
    ...     def __setitem__(self, key, value):
    ...         print('Setting {0} to {1}'.format(key, value))
    ...         dict.__setitem__(self, key, value)
    
    问题是假如你继承的不是dict而是其他,那么就要修改2处,其实可以这样
    
    >>> class LoggingDict(dict):
    ...     def __setitem__(self, key, value):
    ...         print('Setting {0} to {1}'.format(key, value))
    ...         super(LoggingDict, self).__setitem__(key, value)
    
    PS: 感觉super自动找到了LoggingDict的父类(dict)，然后把self转化为其实例
    
手写一个迭代器
    >>> class Data(object):
    ...     def __init__(self):
    ...         self._data = []
    ...     def add(self, x):
    ...         self._data.append(x)
    ...     def data(self):
    ...         return iter(self._data)
    ...
    >>> d = Data()
    >>> d.add(1)
    >>> d.add(2)
    >>> d.add(3)
    >>> for x in d.data():
    ...     print(x)

标准迭代器
    >>> class Data(object):
    ...     def __init__(self, *args):
    ...         self._data = list(args)
    ...         self._index = 0
    ...     def __iter__(self):
    ...         return self
    ...     # 兼容python3
    ...     def __next__(self):
    ...         return self.next()
    ...     def next(self):
    ...         if self._index >= len(self._data):
    ...             raise StopIteration()
    ...         d = self._data[self._index]
    ...         self._index += 1
    ...         return d
    ...
    >>> d = Data(1, 2, 3)
    >>> for x in d:
    ...     print(x)

生成器
    >>> class Data(object):
    ...     def __init__(self, *args):
    ...         self._data = list(args)
    ...     def __iter__(self):
    ...         for x in self._data:
    ...             yield x
    ...
    >>> d = Data(1, 2, 3)
    >>> for x in d:
    ...     print(x)
    ...
    1
    2
    3
    >>> (i for i in [1,2,3]) # 这是生成器表达式
    <generator object <genexpr> at 0x10657a640>
    
斐波那契数列
    >>> import itertools
    >>>
    >>> def fib():
    ...     a, b = 0, 1
    ...     while 1:
    ...         yield b
    ...         a, b = b, a + b
    ...
    >>>
    >>> print list(itertools.islice(fib(), 10))
    [1, 1, 2, 3, 5, 8, 13, 21, 34, 55]
    
    
其实yield和协程关系很密切
    >>> def coroutine():
    ...     print "coroutine start..."
    ...     result = None
    ...     while True:
    ...         s = yield result
    ...         result = 'result: {}'.format(s)
    ...
    >>> c = coroutine() # 函数返回协程对象
    >>> c.send(None) # 使用 send(None) 或 next() 启动协程
    coroutine start...
    >>> c.send("first") # 向协程发送消息,使其恢复执⾏
    'result: first'
    >>> c.send("second")
    'result: second'
    >>> c.close() # 关闭协程,使其退出。或⽤c.throw() 使其引发异常
    >>> c.send("never recv")
    Traceback (most recent call last):
    File "<stdin>", line 1, in <module>
    StopIteration
    
来个回调(阻塞的)
    >>> def framework(logic, callback):
    ...     s = logic()
    ...     print "[FX] logic: ", s
    ...     print "[FX] do something"
    ...     callback("async: " + s)
    ...
    >>> def logic():
    ...     s = "mylogic"
    ...     return s
    ...
    >>> def callback(s):
    ...     print s
    ...
    >>> framework(logic, callback)
    [FX] logic:  mylogic
    [FX] do something
    async: mylogic
    
来个回调(异步的)
    >>> def framework(logic):
    ...     try:
    ...         it = logic()
    ...         s = next(it)
    ...         print "[FX] logic: ", s
    ...         print "[FX] do something"
    ...         it.send("async: " + s)
    ...     except StopIteration:
    ...          pass
    ...
    >>> def logic():
    ...     s = "mylogic"
    ...     r = yield s
    ...     print r
    ...
    >>> framework(logic)
    [FX] logic:  mylogic
    [FX] do something
    async: mylogic
    
contextlib.contextmanager 
    @contextlib.contextmanager
    def some_generator(<arguments>):
        <setup>
        try:
            yield <value>
        finally:
            <cleanup>
    with some_generator(<arguments>) as <variable>:
        <body>
    
    也就是:
    
        <setup>
        try:
            <variable> = <value>
            <body>
        finally:
            <cleanup>
            
            
contextmanager例子(一)
    ... from contextlib import contextmanager
    >>> lock = threading.Lock()
    >>> @contextmanager
    ... def openlock():
    ...     print('Acquire')
    ...     lock.acquire()
    ...     yield
    ...     print('Releasing')
    ...     lock.release()
    ... 
    >>> with openlock():
    ...     print('Lock is locked: {}'.format(lock.locked()))
    ...     print 'Do some stuff'
    ... 
    Acquire
    Lock is locked: True
    Do some stuff
    Releasing
    
    contextmanager例子(二)

>>> @contextmanager
    ... from contextlib import contextmanager
    ... def openlock2():
    ...     print('Acquire')
    ...     with lock: # threading.Lock其实就是个with的上下文管理器.
    ...         # __enter__ = acquire
    ...         yield
    ...     print('Releasing')
    ... 
    >>> with openlock2():
    ...     print('Lock is locked: {}'.format(lock.locked()))
    ...     print 'Do some stuff'
    ... 
    Acquire
    Lock is locked: True
    Do some stuff
    Releasing
    
contextmanager例子(三)
    ... from contextlib import contextmanager
    >>> @contextmanager
    ... def operation(database, host='localhost', 
                    port=27017):
    ...     db = pymongo.MongoClient(host, port)[database]
    ...     yield db
    ...     db.connection.disconnect()
    ... 
    >>> import pymongo
    >>> with operation('test') as db:
    ...     print(db.test.find_one())
    
包导入
    >>> import imp
    >>> f, filename, description = imp.find_module('sys')
    >>> sys = imp.load_module('sys', f, filename, description)
    >>> sys
    <module 'sys' (built-in)>
    >>> os = __import__('os')
    >>> os.path
    <module 'posixpath' from '/System/Library/Frameworks/Python.framework/Versions/2.7/lib/python2.7/posixpath.pyc'>
    >>> filename = "t.py"
    >>> f = open("t.py")
    >>> description = ('.py', 'U', 1)
    >>> t = imp.load_module('some', f, filename, description)
    
包构建__all__
    因为 import 实际导的是标模块 globals 名字空间中的成员,
    那么就有个问题: 模块也会导其他模块,这些模块同样在标模块
    的名字空间中. "import *" 操作时,所有这些一并被带入到当前模
    块中,造成一定程度的污染
    
    __all__ = ["add", "x"]
    
包构建__path__
    某些时候,包内的文件太多,需要分类存放到多个目录中,但⼜不想拆分
    成新的包或⼦包。这么做是允许的, 只要在 __init__.py 中⽤
    __path__ 指定所有⼦目录的全路径即可 (⼦目录可放在包外)
    
    <dir>
    |_ __init__.py
    |
    |_ a <dir>
    .  |_ add.py
    |
    |_ b <dir>
    |_ sub.py
    
    from os.path import abspath, join
    subdirs = lambda *dirs: [abspath(
        join(__path__[0], sub)) for sub in dirs]
    __path__ = subdirs("a", "b")  

__slots__ 大量属性时减少内存占用
    >>> class User(object):
    ...     __slots__ = ("name", "age")
    ...     def __init__(self, name, age):
    ...         self.name = name
    ...         self.age = age
    ...
    >>> u = User("Dong", 28)
    >>> hasattr(u, "__dict__")
    False
    >>> u.title = "xxx"
    Traceback (most recent call last):
    File "<stdin>", line 1, in <module>
    AttributeError: 'User' object has no attribute 'title'
    
    
wheel(即将替代Eggs的二进制包格式)的优点
    1. 有官方的PEP427支持
    2. 打包后不包含pyc文件
    3. 一个wheel包可以提供多python版本标签甚至系统架构
    
@property
    >>> class C(object):
    ...     def __init__(self):
    ...         self._x = None
    ...     def getx(self):
    ...         print 'get x'
    ...         return self._x
    ...     def setx(self, value):
    ...         print 'set x'
    ...         self._x = value
    ...     def delx(self):
    ...         print 'del x'
    ...         del self._x
    ...     x = property(getx, setx, delx, "I'm the 'x' property.")
    ...
    >>> c = C()
    >>> c.x = 12
    set x
    >>> c.x
    get x
    12
    >>> del c.x

@property的另外使用方法
    >>> class Parrot(object):
    ...     def __init__(self):
    ...         self._voltage = 100000
    ...     @property
    ...     def voltage(self):
    ...         """Get the current voltage."""
    ...         return self._voltage
    ...     @voltage.setter
    ...     def voltage(self, value):
    ...         """Set to current voltage."""
    ...         self._voltage = value
    ...
    >>> c = Parrot()
    >>> c.voltage
    100000
    >>> c.voltage = 200
    >>> c.voltage
    200
    
    
描述符
    1. 当希望对某些类的属性进行特别的处理而不会对整体的其他属性有影响的话,可以使用描述符
    2. 只要一个类实现了__get__、__set__、__delete__方法就是描述符
    3. 描述符会"劫持"那些本对于self.__dict__的操作
    4. 把一个类的操作托付与另外一个类
    5. 静态方法, 类方法, property都是构建描述符的类
    
描述符的例子
    >>> class MyDescriptor(object):
    ...     _value = ''
    ...     def __get__(self, instance, klass):
    ...         return self._value
    ...     def __set__(self, instance, value):
    ...         self._value = value.swapcase()
    >>> class Swap(object):
    ...     swap = MyDescriptor()
    >>> instance = Swap()
    >>> instance.swap
    ''
    >>> # 对swap的属性访问被描述符类重载了
    >>> instance.swap = 'make it swap'
    >>> instance.swap
    'MAKE IT SWAP'
    >>> instance.__dict__ # 没有用到__dict__:被劫持了
    {}
    
深入描述符
    >>> def t(): # 随便定义个函数(或者lambda匿名函数)
    ...     pass
    ... 
    >>> dir(t)
    ['__call__', '__class__', '__closure__', '__code__',
    '__defaults__', '__delattr__', '__dict__', '__doc__',
    '__format__', '__get__', '__getattribute__', '__globals__',
    '__hash__', '__init__', '__module__', '__name__', '__new__',
    '__reduce__', '__reduce_ex__', '__repr__', '__setattr__',
    '__sizeof__', '__str__', '__subclasshook__', 'func_closure',
    'func_code', 'func_defaults', 'func_dict', 'func_doc',
    'func_globals', 'func_name']
    注意: **t有__get__方法.**
    总结: 所有 Python 函数都默认是一个描述符. 
    这个描述符的特性在"类"这一对象上下文之外没有任何意义，
    但只要到了类中:
    instance.swap变成了:
    Swap.__dict__['swap'].__get__(instance, Swap)
    
一个开源实现
    >>> class cached_property(object):
    ...     # from werkzeug.utils import cached_property
    ...     def __init__(self, func, name=None, doc=None):
    ...         self.__name__ = name or func.__name__
    ...         self.__module__ = func.__module__
    ...         self.__doc__ = doc or func.__doc__
    ...         self.func = func
    ...     def __get__(self, obj, type=None):
    ...         if obj is None:
    ...             return self
    ...         value = obj.__dict__.get(self.__name__, _missing)
    ...         if value is _missing:
    ...             value = self.func(obj)
    ...             obj.__dict__[self.__name__] = value
    ...         return value
    
用python实现静态方法和类方法
    >>> class myStaticMethod(object):
    ...     def __init__(self, method):
    ...         self.staticmethod = method
    ...     def __get__(self, object, type=None):
    ...         return self.staticmethod
    ... 
    >>> class myClassMethod(object):
    ...     def __init__(self, method):
    ...         self.classmethod = method
    ...     def __get__(self, object, klass=None):
    ...         if klass is None:
    ...             klass = type(object)
    ...         def newfunc(*args):
    ...             return self.classmethod(klass, *args)
    ...         return newfunc

模拟生成一个类
    >>> def __init__(self, func):
    ...     self.func = func
    >>> def hello(self):
    ...     print 'hello world'
    >>> attrs = {'__init__': __init__, 'hello': hello}
    >>> bases = (object,)
    >>> Hello = type('Hello', bases, attrs)
    >>> h = Hello(lambda a, b=3: a + b)
    >>> h.hello()
    hello world
    # 其实等于下面的类
    class Hello(object):
        def __init__(self, func):
            self.func = func
        def hello(self):
            print 'hello world'
            
元类: __metaclass__(实现前面的Hello类)
    class HelloMeta(type): # 注意继承至type
        def __new__(cls, name, bases, attrs):
            def __init__(cls, func):
                cls.func = func
            def hello(cls):
                print 'hello world'
            t = type.__new__(cls, name, bases, attrs)
            t.__init__ = __init__
            t.hello = hello
            return t # 要return创建的类哦
    
    class New_Hello(object):
        __metaclass__ = HelloMeta