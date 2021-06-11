    functools提供了一些非常有用的高阶函数。# 函数操作工具
高阶函数就是说一个可以接受函数作为参数或者以函数作为返回值的函数，因为Python中函数也是对象，
因此很容易支持这样的函数式特性.
 
1. partial
>>> from functools import partial
>>> basetwo = partial(int, base=2)
>>> basetwo('10010')
18
basetwo('10010')实际上等价于调用int('10010', base=2)，当函数的参数个数太多的时候，可以通过使用
functools.partial来创建一个新的函数来简化逻辑从而增强代码的可读性，而partial内部实际上就是通过一个简单的闭包来实现的。

# functools模块的主要类是partial,它可以使用默认参数包装一个callable对象.
    import functools
    def myfunc(a, b=2):
        "Docstring for myfunc()."
        print('  called myfunc with:', (a, b))
    
    
    def show_details(name, f, is_partial=False):
        "Show details of a callable object."
        print('%s:'%(name))
        print('  object:', f)
        if not is_partial:
            print('  __name__:', f.__name__)
        if is_partial:
            print('  func:', f.func)
            print('  args:', f.args)
            print('  keywords:', f.keywords)
        return
    
    
    show_details('myfunc', myfunc)
    myfunc('a', 3)
    print
    
    # Set a different default value for 'b', but require
    # the caller to provide 'a'.
    p1 = functools.partial(myfunc, b=4)
    show_details('partial with named default', p1, True)
    p1('passing a')
    p1('override b', b=5)
    print
    
    # Set default values for both 'a' and 'b'.
    p2 = functools.partial(myfunc, 'default a', b=99)
    show_details('partial with defaults', p2, True)
    p2()
    p2(b='override b')
    print

# partial对象默认没有__name__或__doc__属性,这可以使用update_wrapper()方法来从原始函数中拷贝过来
    def myfunc(a, b=2):
        "Docstring for myfunc()."
        print('  called myfunc with:', (a, b))
    
    p1 = functools.partial(myfunc, b=4)
    functools.update_wrapper(p1, myfunc)

获取装饰器的函数属性：这个应该比较熟悉, 即@functools.wrap, 其内部使用上面说明的update_wrapper()

# partial不仅仅用于函数, 还可以用在callable对象上. partialmethod()用于和不和对象绑定的方法上,并返回一个callable对象.
    import functools

    def standalone(self, a=1, b=2):
        "Standalone function"
        print('  called standalone with:', (self, a, b))
        if self is not None:
            print('  self.attr =', self.attr)
    
    
    class MyClass:
        "Demonstration class for functools"
    
        def __init__(self):
            self.attr = 'instance attribute'
    
        method1 = functools.partialmethod(standalone)
        method2 = functools.partial(standalone)
    
    
    o = MyClass()
    
    print('standalone')
    standalone(None)
    print()
    
    print('method1 as partialmethod')
    o.method1()
    print()
    
    print('method2 as partial')
    try:
        o.method2()
    except TypeError as err:
        print('ERROR: {}'.format(err))
    
2. wraps
装饰器会遗失被装饰函数的__name__和__doc__等属性，可以使用@wraps来恢复。
from functools import wraps
def my_decorator(f):
    @wraps(f)
    def wrapper():
        """wrapper_doc"""
        print('Calling decorated function')
        return f()
    return wrapper
    
@my_decorator
def example():
    """example_doc"""
    print('Called example function')

 >>> example.__name__
'example'
>>> example.__doc__
'example_doc'
# 尝试去掉@wraps(f)来看一下运行结果，example自身的__name__和__doc__都已经丧失了
>>> example.__name__
'wrapper'
>>> example.__doc__
'wrapper_doc'

3. total_ordering
Python2中可以通过自定义__cmp__的返回值0/-1/1来比较对象的大小，在Python3中废弃了__cmp__，但是我们可以通过totalordering然后修改 _lt__() , __le__() , __gt__(), __ge__(), __eq__(), __ne__() 等魔术方法来自定义类的比较规则。
p.s: 如果使用必须在类里面定义 __lt__() , __le__() , __gt__(), __ge__()中的一个，以及给类添加一个__eq__() 方法。
import functools
@functools.total_ordering
class MyObject:
    def __init__(self, val):
        self.val = val
    def __eq__(self, other):
        print('  testing __eq__({}, {})'.format(
            self.val, other.val))
        return self.val == other.val
    def __gt__(self, other):
        print('  testing __gt__({}, {})'.format(
            self.val, other.val))
        return self.val > other.val
a = MyObject(1)
b = MyObject(2)
for expr in ['a < b', 'a <= b', 'a == b', 'a >= b', 'a > b']:
    print('\n{:<6}:'.format(expr))
    result = eval(expr)
    print('  result of {}: {}'.format(expr, result))

4. reduce：reduce()方法用于进行数据集的reduce操作
import functools
def do_reduce(a, b):
    print('do_reduce({}, {})'.format(a, b))
    return a + b


data = range(1, 5)
print(data)
result = functools.reduce(do_reduce, data)
print('result: {}'.format(result))

# 输出
range(1, 5)
do_reduce(1, 2)
do_reduce(3, 3)
do_reduce(6, 4)
result: 10

reduce()方法还有个初始化参数

result = functools.reduce(do_reduce, data, 99)

5. caching
    lru_cache()提供了一个LRU(最近最少使用)的缓存策略.
import functools


@functools.lru_cache()
def expensive(a, b):
    print('expensive({}, {})'.format(a, b))
    return a * b


MAX = 2

print('First set of calls:')
for i in range(MAX):
    for j in range(MAX):
        expensive(i, j)
print(expensive.cache_info())

print('\nSecond set of calls:')
for i in range(MAX + 1):
    for j in range(MAX + 1):
        expensive(i, j)
print(expensive.cache_info())

print('\nClearing cache:')
expensive.cache_clear()
print(expensive.cache_info())

print('\nThird set of calls:')
for i in range(MAX):
    for j in range(MAX):
        expensive(i, j)
print(expensive.cache_info())

# 输出
First set of calls:
expensive(0, 0)
expensive(0, 1)
expensive(1, 0)
expensive(1, 1)
CacheInfo(hits=0, misses=4, maxsize=128, currsize=4)

Second set of calls:
expensive(0, 2)
expensive(1, 2)
expensive(2, 0)
expensive(2, 1)
expensive(2, 2)
CacheInfo(hits=4, misses=9, maxsize=128, currsize=9)

Clearing cache:
CacheInfo(hits=0, misses=0, maxsize=128, currsize=0)

Third set of calls:
expensive(0, 0)
expensive(0, 1)
expensive(1, 0)
expensive(1, 1)
CacheInfo(hits=0, misses=4, maxsize=128, currsize=4)

lru_cache装饰器还有一个maxsize kv参数.用于设定缓存的最大容量