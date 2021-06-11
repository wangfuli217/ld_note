不成熟的抽象和过早的优化一样，都会坏事。 -- 所有Python代码都应该利用特殊方法和元编程。
使用胜于纯粹； --- 为什么len不是普通方法。
REPL(Read eval print loop)
doctest:  python3 -m doctest example_script.py
          python3 -m doctest frenchdeck.doctest
在考虑如何实现一个功能之前，先严格地列出这个功能能做什么，这能帮助我们在编程时 把精力花在该花的地方。
# Josef Hartwig
# Guido van Rossum
# Alex Martelli 和 Anna Ravenscroft   https://stackoverflow.com/users/95810/alex-martelli

my_collection[key] -> my_collection.__getitem__(key)
特殊方法：
    迭代
    集合类
    属性访问
    运算符重载
    函数和方法的调用
    对象的创建和销毁
    字符串表示形式和格式化
    管理上下文(即with块)
    
frenchdeck.py # namedtuple的序列  --- 一副扑克牌
    collections.namedtuple用于构建只有少数属性但没有方法的的对象。
    FrenchDeck; 一副扑克牌；__getitem__和__len__ 1. 可以索引， 2. 可以随机选择，3. 可以切片 4. 可以遍历
    sorted方法可以对一副扑克牌进行排序。
    
1. 特殊方法的存在是为了被Python解释器调用的，自己不需要调用。
2. PyVarObject是表示内存中长度可变的内置对象的C语言结构体。直接读取这个值比调用一个方法要快很多。
3. 在Python2中，对object的继承需要显示地写为FrenchDeck(object);而在Python3中，这个继承关系是默认的。

vector2d.py # 模拟数值类型
    abs：如果输入是整数或者浮点数，它返回的输入值的绝对值；如果输入是一个复数，那么返回这个复数的模。
        __abs__ 内置函数
    repr: 把一个对象用字符串的形式表达出来以便辨认。交互式控制台和调试程序用repr函数来获取字符串表示形式。
        __repr__ 内置函数 %r和!r
        str()对终端用户更友好。
        如果一个对象没有__str__函数，Python又要调用它的时候，解释器会用__repr__作为替代。
        __str__ 和 __repr__ 在使用上比较推荐的是，前者是给终端用户看，而后者则更方便我们调试和记录日志.
    + 和 * ：__add__, __mul__
    bool:
        __bool__:
        默认情况下，我们自定义的类的实例总被认为是真的，除非这个类对__bool__或者__len__函数有自己的实现。
        如果不存在bool，会调用len函数。如返回0，则bool会返回False；否则返回True。
        
跟运算符无关的特殊方法
    字符串 / 字节序列表示形式      __repr__、__str__、__format__、__bytes__
    数值转换                       __abs__、__bool__、__complex__、__int__、__float__、__hash__、__index__
    集合模拟                       __len__、__getitem__、__setitem__、__delitem__、__contains__
    迭代枚举                       __iter__、__reversed__、__next__
    可调用模拟                     __call__
    上下文管理                     __enter__、__exit__
    实例创建和销毁                 __new__、__init__、__del__
    属性管理                       __getattr__、__getattribute__、__setattr__、__delattr__、__dir__
    属性描述符                     __get__、__set__、__delete__
    跟类相关的服务                 __prepare__、__instancecheck__、__subclasscheck__
    
跟运算符相关的特殊方法
    一元运算符                     __neg__ -、__pos__ +、__abs__ abs()
    众多比较运算符                 __lt__ <、__le__ <=、__eq__ ==、__ne__ !=、__gt__ >、__ge__ >=
    算术运算符                     __add__ +、__sub__ -、__mul__ *、__truediv__ /、__floordiv__ //、__mod__ %、__divmod__ divmod()、__pow__ ** 或pow()、__round__ round()
    反向算术运算符                 __radd__、__rsub__、__rmul__、__rtruediv__、__rfloordiv__、__rmod__、__rdivmod__、__rpow__
    增量赋值算术运算符             __iadd__、__isub__、__imul__、__itruediv__、__ifloordiv__、__imod__、__ipow__
    位运算符                       __invert__ ~、__lshift__ <<、__rshift__ >>、__and__ &、__or__ |、__xor__ ^
    反向位运算符                   __rlshift__、__rrshift__、__rand__、__rxor__、__ror__
    增量赋值位运算符               __ilshift__、__irshift__、__iand__、__ixor__、__ior__

数据模型还是对象模型
    Data Model https://docs.python.org/3/reference/datamodel.html
        《Python技术手册》
        《Python参考手册》
        《Python Cookbook》
    Python 文档里总是用"Python 数据模型"这种说法，而大多数作者提到这个概念的时候会说"Python 对象模型"。
    Python 文档里对这个词有偏爱，
元对象
    The Art of the Metaobject Protocal （AMOP）是我最喜欢的计算机图书的标题。
    客观来说，元对象协议这个词对我们学习Python 数据模型是有帮助的。元对象所指的是那些对建构语言本身来讲很重要的对象，以此为前提，协议也可以看作接口。
    也就是说，元对象协议是对象模型的同义词，它们的意思都是构建核心语言的 API。
    其实在 Python 这样的动态语言里，更容易实现面向方面编程。现在已经有几个 Python 框架在做这件事情了，
其中最重要的是 zope.interface（http://docs.zope.org/zope.interface/）。