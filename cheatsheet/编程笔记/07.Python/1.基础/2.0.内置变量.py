内置常量
    False
    
bool类型值：假
    True
    
bool类型值：真
    None
types.NoneType的唯一值；None常用来表示缺少的值，如默认参数没有传递给函数的时候

NotImplemented
    可以由特殊的‘rich comparison’方法（eq(),ly()以及类似的方法）返回，表示另一种类型没有实现这种比较操作

debug
    如果Python没有义-O选项启动，则该常量为真

    
真值测试
任何对象都可以测试真值，下面所列的值会被视为假：
    None
    False
    任何数值类型的0（0、0L、0.0、0j）
    任何空序列（''、 ()、 []）
    任何空映射（{}）
    对于用户定义的类的实例，如果该类定义一个__nonzero__()或__len__()的方法，则返回False或0时视为假
所有其他值都被视为真

__all__
    这是一个字符串列表,定义在一个模块出口时使用 from <module> import * 将可以引用到什么变量,但对 import <module> 没有影响。
    没有定义此语句，则 import * 默认的行为是导入所有的符号不以下划线开始的对象。

    例如：
    a1.py 的内容如下:
    __all__=['b','c']
    a='aaa'
    b='bbb'
    c='ccc'

    b1.py 的内容如下:
    import a1
    from a1 import *
    print a1.a # 正常打印
    print b # 正常打印
    print a # 报错了,变量未定义


__call__
    类的调用
    只要定义类的时候，实现 __call__ 函数，这个类型就成为可调用的。
    换句话说，我们可以把这个类型的对象当作函数来使用，相当于 重载了括号运算符。


__del__
    del 类名 # 调用对象的 __del__ 方法


__doc__
    docstring

    例：
    print(Person.__doc__) # 打印类的docstring
    print(Person.func_name.__doc__) # 打印类的方法的docstring


__file__
    当前代码所在的Python模块的文件名。

    例：
    import os, sys
    print( os.path.dirname(os.path.realpath(__file__)) ) # 获取当前目录
    print( os.path.dirname(os.path.dirname(os.path.realpath(__file__))) ) # 获取上一层目录
    print( os.path.dirname(os.path.abspath(sys.argv[0])) ) # 获取当前目录, sys.argv[0] 与 __file__ 一样显示当前文件名
    print( os.getcwd() ) # 获取当前目录
    print( os.path.abspath(os.curdir) ) # 获取当前目录
    print( os.path.abspath( '. ') ) # 获取当前目录, 打印会加上点号，如： /home/holemar/project/ppf_web/.


__init__
    类的构造方法

    例：
    class Human(object):
        def __init__(self, name):
            print(name)

    class Person(Human): # Person 类继承 Human 类
        def __init__(self, name):
            self.name = name # 对象的变量,每个对象独立的
            super(Person, self).__init__(name)  # 调用父类的 __init__ 方法,但这样的调用要求父类必须继承 object 类,或者继承其它的类
            Human.__init__(self, "province") # 这样调用父类的 __init__ 方法也可以


__name__
    每个Python模块都有它的__name__，如果它是'__main__'，这说明这个模块被用户单独运行，我们可以进行相应的恰当操作。

    例:
    if __name__ == '__main__':
        print('This program is being run by itself')
    else:
        print('I am being imported from another module')


__version__
    版本信息

    例如:
    __version__ = '2.6.26'
    print( tuple(int(i) for i in __version__.split('.')) ) # 打印: (2, 6, 26)
    print( float(__version__) ) # 报错


运算符,如大于、小于、等于、加减乘除, 等等
    class Field(object):
        def __init__(self, value):
            self.value = value

        # 小于:  x < y, y > x
        def __lt__(self, value):
            print('__lt__ 被调用啦...')
            return self.value < value
        # 小于等于:  x <= y, y >= x
        def __le__(self, value):
            return self.value <= value
        # x > y, y < x
        def __gt__(self, value):
            return self.value > value
        # x >= y, y <= x
        def __ge__(self, value):
            return self.value >= value

        # 等于: x == y
        def __eq__(self, value):
            return self.value == value
        # 不等于:  x != y, x <> y
        def __ne__(self, value):
            return self.value != value

        # 加:  x + y
        def __add__(self, value):
            return str(self.value) + ' + ' + str(value)
        # y + x
        def __radd__(self, value):
            return str(value) + ' + ' + str(self.value)

        # 减: x - y
        def __sub__(self, value):
            return str(self.value) + ' - ' + str(value)
        # y - x
        def __rsub__(self, value):
            return str(value) + ' - ' + str(self.value)

        # 乘: x * y
        def __mul__(self, value):
            return str(self.value) + ' × ' + str(value)
        # y * x
        def __rmul__(self, value):
            return str(value) + ' × ' + str(self.value)

        # 除: x / y
        def __div__(self, value):
            return str(self.value) + ' ÷ ' + str(value)
        # y / x
        def __rdiv__(self, value):
            return str(value) + ' ÷ ' + str(self.value)
        # 整除: x // y
        def __floordiv__(self, value):
            return str(self.value) + ' // ' + str(value)
        # y // x
        def __rfloordiv__(self, value):
            return str(value) + ' // ' + str(self.value)
        # python2里面不知道怎么调用这个函数,但python3没有了 __div__,除的时候直接调用此函数
        def __truediv__(self, value):
            return str(self.value) + ' / ' + str(value)
        def __rtruediv__(self, value):
            return str(value) + ' / ' + str(self.value)

        # 单元运算符
        # ~x
        def __invert__(self):
            return '~' + str(self.value)
        # -x
        def __neg__(self):
            return '-' + str(self.value)
        # +x
        def __pos__(self):
            return '+' + str(self.value)

        # x[y]
        def __getitem__(self, value):
            return 'this[' + str(value) + ']'
        # x[y] = z
        def __setitem__(self, key, value)
            self[key] = value
        # del x[y]
        def __delitem__(self, value):
            del self[value]
        # x[y:z]
        def __index__(self, y, z):
            return self[y:z]
        # 遍历
        def __iter__(self):
            pass
        # y in x
        def __contains__(self, value): # in 判断,只能返回 True / False
            return False

        # x.name
        #def __getattribute__(self, value): # 覆盖此方法后,调用 self.value 会引起死循环
        #    return 'this.' + str(value)


        # 被特定函数调用时
        # len(x) ,返回值必须大于或等于0
        def __len__(self):
            return 1
        # str(x) ,返回值必须是字符串
        def __str__(self):
            return str(self.value)
        # unicode(x)
        def __unicode__(self):
            return unicode(self.value)

        # abs(x)
        def __abs__(self):
            return abs(self.value)
        # hash(x)
        def __hash__(self):
            return hash(self.value)
        # hex(x)
        def __hex__(self):
            return hex(self.value)

        # int(x)
        def __int__(self):
            return int(self.value)
        # long(x)
        def __long__(self):
            return long(self.value)
        # float(x)
        def __float__(self):
            return float(self.value)

        # oct(x)
        def __oct__(self):
            return oct(self.value)
        # cmp(x, y)
        def __cmp__(self, value):
            return cmp(self.value, value)
        # coerce(x, y)
        def __coerce__(self, value):
            return coerce(self.value, value)
        # divmod(x, y)
        def __divmod__(self, value):
            return divmod(self.value, value)
        # divmod(y, x)
        def __rdivmod__(self, value):
            return divmod(self.value, value)

        # pow(x, y[, z])
        def __pow__(self, value):
            return pow(self.value, value[, z])
        # pow(y, x[, z])
        def __rpow__(self, value):
            return pow(self.value, value[, z])
        # repr(x])
        def __repr__(self, value):
            return repr(self.value)
        # size of S in memory, in bytes
        def __sizeof__(self, value):
            return 1


    a = Field(32)
    print(a < 12)  # 调用 a 的 __lt__
    print(12 > a)  # 调用 a 的 __lt__
    print(a >= 17)
    print(a != 15)
    print(a == 32)
    print(a + 8)   # 调用 a 的 __add__
    print(8 + a)   # 调用 a 的 __radd__
    print(a * 8)   # 调用 a 的 __mul__
    print(8 * a)   # 调用 a 的 __rmul__
    print(a / 8)   # python2时, 调用 a 的 __div__； python3时调用 __truediv__

    print(~a)
    print(-a)
    print(+a)
    #print(a.name2)
    print(a['name3'])
    print('name' in a)

    print(len(a))  # 调用 a 的 __len__
    print(str(a))  # 调用 a 的 __str__


    运算符表：
     二元运算符   特殊方法
        +       __add__,__radd__
        -       __sub__,__rsub__
        *       __mul__,__rmul__
        /       __div__,__rdiv__,__truediv__,__rtruediv__
        //      __floordiv__,__rfloordiv__
        %       __mod__,__rmod__
        **      __pow__,__rpow__
        <<      _lshift__,__rlshift__
        >>      __rshift__,__rrshift__
        &       __and__,__rand__
        ^       __xor__,__rxor__
        |       __or__,__ror__
        +=      __iaddr__
        -=      __isub__
        *=      __imul__
        /=      __idiv__,__itruediv__
        //=     __ifloordiv__
        %=      __imod__
        **= 	__ipow__
        <<= 	__ilshift__
        >>= 	__irshift__
        &=      __iand__
        ^=      __ixor__
        |=      __ior__
        ==      __eq__
        !=,<> 	__ne__
        >       __gt__
        <       __lt__
        >=      __ge__
        <=      __le__

