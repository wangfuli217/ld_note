Stackoverflow(如何打印一个对象的所有属性和值的对){
    for property, value in vars(theObject).iteritems():
        print property, ": ", value
    
    这个做法其实就是 theObject.__dict__ , 也就是 vars(obj) 其实就是返回了 o.__dict__
    
    另一个做法: inspect.getmembers(object[, predicate])
    
    >>> import inspect
    >>> for attr, value in inspect.getmembers(obj):
    ...     print attr, value
    
    两者不同的是， inspect.getmembers 返回的是元组 (attrname, value) 的列表。而且是所有的属性, 
    包括 __class__ , __doc__ , __dict__ , __init__ 等特殊命名的属性和方法。而 vars() 只返回 __dict__. 
    对于一个空的对象来说， __dict__ 会是 {} , 而 inspect.getmembers 返回的不是空的。
}

Stackoverflow(类的__dict__无法更新?){
    >>> class O(object):pass 
    ... 
    >>> O.__dict__["a"] = 1 
    Traceback (most recent call last):
    
    答: 是的, class的 __dict__ 是只读的:
    
}
Stackoverflow(unbound method和bound method){
>>> class C(object):
...     def foo(self):
...         pass
...
>>> C.foo
<unbound method C.foo>
>>> C().foo
<bound method C.foo of <__main__.C object at 0xb76ddcac>>
>>>

为什么 C.foo 是一个 unbound method , C().foo 是一个 bound method ？ Python 为什么这样设计?
如果你明白python中描述器(descriptor)是怎么实现的, 方法(method) 是很容易理解的。
上例代码中可以看到，如果你用类 C 去访问 foo 方法，会得到 unbound 方法，然而在class的内部存储中它是个 function, 为什么? 原因就是 C 的类 (注意是类的类) 实现了一个 __getattribute__ 来解析描述器。听起来复杂，但并非如此。上例子中的 C.foo 等价于:

>>> C.__dict__['foo'].__get__(None, C)
<unbound method C.foo>

这是因为方法 foo 有个 __get__ 方法，也就是说, 方法是个描述器。如果你用实例来访问的话也是一模一样的:

>>> c = C()
>>> C.__dict__['foo'].__get__(c, C)
<bound method C.foo of <__main__.C object at 0xb76ddd8c>>

只是那个 None 换成了这个实例。
现在我们来讨论，为什么Python要这么设计?
其实，所谓 bound method ，就是方法对象的第一个函数参数绑定为了这个类的实例(所谓 bind )。这也是那个 self 的由来。
当你不想让类把一个函数作为一个方法，可以使用装饰器 staticmethod

>>> class C(object):
...     @staticmethod
...     def foo():
...         pass
...
>>> C.foo
<function foo at 0xb76d056c>
>>> C.__dict__['foo'].__get__(None, C)
<function foo at 0xb76d056c>

staticmethod 装饰器会让 foo 的 __get__ 返回一个函数，而不是一个方法。
}

stackover(function，bound method 和 unbound method 的区别是什么?){

一个函数(function)是由 def 语句或者 lambda 创建的。
当一个函数(function)定义在了class语句的块中（或者由 type 来创建的), 它会转成一个 unbound method , 当我们通过一个类的实例来 访问这个函数的时候，它就转成了 bound method , bound method 会自动把这个实例作为函数的地一个参数。
所以， bound method 就是绑定了一个实例的方法， 否则叫做 unbound method .它们都是方法(method), 是出现在 class 中的函数。
}

stackover(什么是metaclass){
https://stackoverflow.com/questions/100003/what-is-a-metaclass-in-python

}
stackoverflow(为什么Python没有unzip函数){
众所周知, zip 函数可以把多个序列打包到元组中:

>>> a, b = [1, 2, 3], [4, 5, 6]
>>> c = zip(a, b)
>>> c
[(1, 4), (2, 5), (3, 6)]

那么为什么没有这样的 unzip 函数来把 [(1, 4), (2, 5), (3, 6)] 还原呢?

答: Python中有个很神奇的操作符 * 来 unpack 参数列表:

>>> zip(*c)
[(1, 2, 3), (4, 5, 6)]
}

stackoverflow(迭代器Iterator与生成器Generator的区别){
迭代器是一个更抽象的概念，任何对象，如果它的类有next方法（next python3)和__iter__方法返回自己本身。

每个生成器都是一个迭代器，但是反过来不行。通常生成器是通过调用一个或多个yield表达式构成的函数s生成的。同时满足迭代器的定义。

当你需要一个类除了有生成器的特性之外还要有一些自定义的方法时，可以使用自定义的迭代器，一般来说生成器更方便，更简单。

def squares(start, stop):
    for i in xrange(start, stop):
        yield i*i

等同于生成器表达式：

（i*i for i in xrange(start, stop))

列表推倒式是：

[i*i for i in xrange(start, stop)]

如果是构建一个自定义的迭代器：

class Squares(object):
    def __init__(self, start, stop):
        self.start = start
        self.stop = stop
    def __iter__(self):
        return self
    def next(self):
        if self.start >= self.stop:
            raise StopIteration
        current = self.start * self.start
        self.start += 1
        return current

此时，你还可以定义自己的方法如：

def current(self):
    return self.start

两者的相同点：对象迭代完后就不能重写迭代了。
Iterables, Iterators, Genrators
热身一下

如果你是来自其它语言比如c，很自然想到的方式是创建一个计数器，然后以自增的方式迭代list。

my_list = [17  23  47  51  101  173  999  1001]

i = 0
while i < len(my_list):
    v = my_list[i]
    print v,
    i += 1

输出：

17 23 47 51 101 173 999 1001

也有可能会借用range，写一个类C语言的风格的for循环：

for i in range(len(my_list)):
    v = my_list[i]
    print v,

输出：

17 23 47 51 101 173 999 1001

上面两种方法都不是Pythonic方式，取而代之的是：

for v in my_list:
    print v,

输出：

17 23 47 51 101 173 999 1001

很多类型的对象都能通过这种方式来迭代，迭代字符串会生成单个字符：

for v in "Hello":
    print v,

输出：

H e l l o

迭代字典，生成字典的key（以无序的方式）：

d = {
    'a': 1,
    'b': 2,
    'c': 3,
    }

for v in d:
    print v,
# 注意这里是无序的

输出：

a c b

迭代文件对象，产生字符串行，包括换行符：

f = open("suzuki.txt")
for line in f:
    print ">", line

输出：

> On education

> "Education has failed in a very serious way to convey the most important lesson science can teach: skepticism."

> "An educational system isn't worth a great deal if it teaches young people how to make a living but doesn't teach them how to make a life."

以上可以看出列表、元祖、字符串、字典、文件都可以迭代，能被迭代的对象都称为可迭代对象（Iteratbles)，for循环不是唯一接收Iteratbles的东东，还有：

list构造器接收任何类型的Iteratbles，可以使用list()接收字典对象返回只有key的列表：

list(d)

输出：

['a', 'c', 'b']

还可以：

list("Hello")

输出：

['H', 'e', 'l', 'l', 'o']

还可以用在列表推倒式中：

ascii = [ord(x) for x in "Hello"]
ascii

输出：

[72, 101, 108, 108, 111]

sum()函数接收任何数字类型的可迭代对象:

sum(ascii)

输出：

500

str.join()方法接收任何字符类型的可迭代对象 （这里的说法不严谨，总之原则是迭代的元素必须是str类型的)：

"-".join(d)

输出：

‘a-c-b'
}
