在python中, 函数是一等对象. 编程语言把 "一等对象" 定义为满足下列条件:
    在运行时创建
    能赋值给变量或数据结构中的元素
    能作为参数传给函数    # map、filter、reduce和apply
    能作为函数的返回结果
1. 函数对象本身是function类的实例。# 在python中, 整数, 字符串, 列表, 字典都是一等对象.
>>> def factorial(n):  
...     '''returns n!''' 
...     return 1 if n < 2 else n * factorial(n-1) 
type(factorial)  # python3 <class 'function'> 为类的实例；dir(factorial) 为类，存在__init__()
type(factorial)  # python2 function           为函数实例；dir(factorial) 为函数，func_dict和func_closure等等

2. 高阶函数：接受函数为参数，或者把函数作为结果返回的函数是高阶函数。
list(map(fact, range(6)))                               # [fact(n) for n in range(6)]
list(map(factorial, filter(lambda n: n % 2, range(6)))) # [factorial(n) for n in range(6) if n % 2]

all([]) 返回True  # True and 序列中元素的值
any([]) 返回False # False or 序列中元素的值

lambal
    lambda函数的定义体中不能赋值，也不能使用while 和try 等Python 语句
    除了作为参数传给高阶函数之外。
    
可调用对象
    除了用户定义的函数, 调用运算符即 () 还可以应用到其他对象上. 如果像判断对象能否被调用, 可以使用内置的 callable()
    函数进行判断. python的数据模型中有7种可是可以被调用的:
        用户定义的函数: 使用def语句或lambda表达式创建
        内置函数:如len 或time.strftime
        内置方法:如dict.get
        方法:在类定义体中的函数
        类：调用类时会运行类的__new__ 方法创建一个实例，然后运行__init__方法，初始化实例，最后把实例返回给调用方。
        类的实例: 如果类定义了 __call__ , 那么它的实例可以作为函数调用. 见bingocall.py 
        生成器函数: 使用 yield 关键字的函数或方法.

列出常规对象没有而函数有的属性
    >>> class C: pass  # 创建一个空的用户定义的类。     
    >>> obj = C()  # 创建一个实例。 
    >>> def func(): pass  # 创建一个空函数。 
    >>> sorted(set(dir(func)) - set(dir(obj))) # 计算差集，然后排序，得到类的实例没有而函数有的属性列表
    用户定义的函数的属性
        __annotations__     dict            参数和返回值的注解
        __call__            method-wrapper  实现()运算符；即可调用对象协议
        __closure__         tuple           函数闭包，即自由变量的绑定（通常是None）
        __code__            code            编译成字节码的函数元数据和函数定义体
        __defaults__        tuple           形式参数的默认值
        __get__             method-wrapper  实现只读描述符协议
        __globals__         dict            函数所在模块中的全局变量
        __kwdefaults__      dict            仅限关键字形式参数的默认值
        __name__            str             函数名称
        __qualname__        str             函数的限定名称
    从定位参数到仅限关键字参数
        def tag(name, *content, cls=None, **attrs):# python3支持这种参数顺序，python2不支持
            """生成一个或多个HTML标签"""           # def tag(name, cls=None, *content, **attrs):
            if cls is not None: 
                attrs['class'] = cls 
            if attrs: 
                attr_str = ''.join(' %s="%s"' % (attr, value) 
                                for attr, value 
                                in sorted(attrs.items())) 
            else: 
                attr_str = '' 
            if content: 
                return '\n'.join('<%s%s>%s</%s>' % 
                                (name, attr_str, c, name) for c in content) 
            else: 
                return '<%s%s />' % (name, attr_str)
                
>>> tag('br')  # 传入单个定位参数，生成一个指定名称的空标签。tag('br')
'<br />' 
>>> tag('p', 'hello')  # 第一个参数后面的任意个参数会被*content捕获，存入一个元组。 tag('p', None, 'hello')
'<p>hello</p>' 
>>> print(tag('p', 'hello', 'world')) # print(tag('p', None, 'hello', 'world'))
<p>hello</p> 
<p>world</p> 
>>> tag('p', 'hello', id=33) # tag 函数签名中没有明确指定名称的关键字参数会被**attrs 捕获，存入一个字典。 
'<p id="33">hello</p>'       # tag('p', None, 'hello', id=33)
>>> print(tag('p', 'hello', 'world', cls='sidebar'))  # cls 参数只能作为关键字参数传入。
<p class="sidebar">hello</p>                          # tag('p', 'sidebar', 'hello', 'world')
<p class="sidebar">world</p> 
>>> tag(content='testing', name="img")  # 调用tag 函数时，即便第一个定位参数也能作为关键字参数传入。
'<img content="testing" />'             # tag("img", None, content='testing') 
>>> my_tag = {'name': 'img', 'title': 'Sunset Boulevard', 
...           'src': 'sunset.jpg', 'cls': 'framed'} 
>>> tag(**my_tag) # 在my_tag前面加上**，字典中的所有元素作为单个参数传入，同名键会绑定到对应的具名参数上，余下的则被**attrs 捕获。 
'<img class="framed" src="sunset.jpg" title="Sunset Boulevard" />'   

获取关于参数的信息 #Bobo
    __defaults__值是一个元组，里面保存着定位参数和关键字参数的默认值。
    关键字参数的默认值在__kwdefaults__属性中
    # 在指定长度附近截断字符串的函数
        def clip(text, max_len=80): 
            """在max_len前面或后面的第一个空格处截断文本 
            """ 
            end = None 
            if len(text) > max_len: 
                space_before = text.rfind(' ', 0, max_len) 
                if space_before >= 0: 
                    end = space_before 
                else:
                    space_after = text.rfind(' ', max_len) 
                    if space_after >= 0: 
                        end = space_after 
            if end is None:  # 没找到空格 
                end = len(text) 
            return text[:end].rstrip()
            
>>> from clip import clip 
>>> clip.__defaults__ 
(80,) 
>>> clip.__code__  # doctest: +ELLIPSIS 
<code object clip at 0x...> 
>>> clip.__code__.co_varnames 
('text', 'max_len', 'end', 'space_before', 'space_after') 
>>> clip.__code__.co_argcount 
2

函数注解
    注解不会做任何处理，只是存储在函数的__annotations__ 属性（一个字典）中：
    注解对Python 解释器没有任何意义。注解只是元数据，可以供IDE 、框架和装饰器等工具使用。
    
operator模块
    各种运算和比较操作
    itemgetter: 获取序列元素  # 序列型元组
    attrgetter: 获取对象属性  # 对象的属性
    methodcaller: 根据方法名称返回方法对象 # 对象的方法

functools模块
    reduce: reduce操作
    partial: 用于减少函数参数.
    部分应用是指，基于一个函数创建一个新的可调用对象，把原函数的某些参数固定。使用这个函数可以把接受一个或多个参数的函数改编成需要回调的API，这样参数更少。
    update_wrapper函数，它可以把被封装函数的name、module、doc和 dict都复制到封装函数去
    wraps函数，它将update_wrapper也封装了进来

lambda
f=lambda x,y,z: x+y+z; 
print(f(1,2,3)) #6 
g=lambda x,y=2,z=3:x+y+z #含有默认值参数 
print(g(1)) #6 
print(g(x=2,z=4,y=6)) #关键参数 #12 
#归根到底函数也是一种变量 
#所以lambda 和 普通函数都可以放到 list 中 
#lambda 也能调用其他函数 L=[lambda x : x**2,lambda x : x**3]

1.1 把函数视作对象
1.2 高阶函数 #接受函数为参数，或者把函数作为结果返回的函数是高阶函数。
1.3 匿名函数 #lambda关键字在python表达式内创建匿名函数
1.4 可调用对象 # Python中有各式各样可调用的类型，因此判断对象能否调用，最安全的方法是使用内置的callable()函数
1.5 用户定义的可调用类型 # 不仅python函数是真正的对象，任何python对象都可以表现得像函数，为此，只需实现实例方法_ call _。
1.6 函数内省 # 除了doc，函数对象还有很多属性。使用dir函数可以探知
1.7 从定位参数到仅限关键字参数
1.8 获取关于参数的信息
1.9 函数注解
1.10 支持函数式编程的包
Python的目标不是变成函数式编程语言，但是有益于operator和functools等包的支持，函数式编程风格也可以信手拈来。