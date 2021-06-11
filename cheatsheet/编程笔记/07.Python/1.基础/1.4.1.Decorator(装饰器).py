
Decorator(装饰器)
@符号修饰函数(有的语言称为:注释)
    python 2.4以后，增加了 @符号修饰函数 对函数进行修饰, python3.0/2.6又增加了对类的修饰。
    修饰符必须出现在函数定义前一行，不允许和函数定义在同一行。也就是说 @A def f(): 是非法的。

    简单的来说就是用一个新的对象来替换掉原有的对象，新的对象包含原有的对象，并且会处理它的执行结果和输入参数。
    python另外一个很有意思的属性：可以在函数中定义函数。
    其实总体说起来，装饰器其实也就是一个函数，一个用来包装函数的函数，返回一个修改之后的函数对象，将其重新赋值原来的标识符，并永久丧失对原始函数对象的访问。

    官方的说明:
    http://www.python.org/dev/peps/pep-0318/


代码上解释 Decorator(装饰器) 就是这样：
    @decomaker
    def func(arg1, arg2, ...):
        pass

    # 上面相当于这样写：
    result = decomaker(func)(arg1, arg2, ...)


范例(普通函数的用法,查看函数运行时间)：
    import time
    def timeit(func):
        def wrapper(*args, **kwargs):
            start = time.time()
            func(*args, **kwargs)
            end =time.time()
            print( 'used:' + str(end - start) )
        return wrapper

    @timeit # 相当于: timeit(foo)()
    def foo():
        print( 'in foo()' )

    # 调用被修饰过的函数,跟普通函数没啥区别
    foo() # 打印: in foo()


    # 下面用一个不写“@”装饰的函数测试调用方法
    def foo2():
        print( 'in foo2()' )

    # 不被装饰的函数,真实的修饰这样写:
    timeit(foo2)() # 打印: in foo2()


范例(多个修饰函数,原函数带参数)：
    def bold(fn):
        def wrapped(arg):
            return "<b>" + fn(arg) + "</b>"
        return wrapped

    def italic(fn):
        def wrapped(arg):
            return "<i>" + fn(arg) + "</i>"
        return wrapped

    @bold   # 相当于: bold(italic(hello))(arg)
    @italic # 相当于: italic(hello)(arg)
    def hello(s):
        return "hello " + s

    # 调用被修饰过的函数,跟普通函数没啥区别
    print( hello('holemar') ) # 打印: <b><i>hello holemar</i></b>


    # 下面用一个不写“@”装饰的函数测试调用方法
    def hello2(s):
        return "hello " + s

    # 不被装饰的函数,真实的修饰这样写:
    print( italic(hello2)('world') ) # 打印: <i>hello world</i>
    print( bold(hello2)('world') ) # 打印: <b>hello world</b>
    print( bold(italic(hello2))('world') ) # 打印: <b><i>hello world</i></b>


范例(装饰器带参数的用法,通用的处理输入和输出结果,这写法仅适用于py2.x)：
    # 如果装饰器需要带参数,则里面需要嵌套两层函数(不带参数的只需嵌套一层),看下面的“相当于”就会明白
    def accepts(*types):
        def check_accepts(f):
            assert len(types) == f.func_code.co_argcount
            def new_f(*args, **kwds):
                for (a, t) in zip(args, types):
                    assert isinstance(a, t), "arg %r does not match %s" % (a,t)
                return f(*args, **kwds)
            new_f.func_name = f.func_name
            return new_f
        return check_accepts

    def returns(rtype):
        def check_returns(f):
            def new_f(*args, **kwds):
                result = f(*args, **kwds)
                assert isinstance(result, rtype), "return value %r does not match %s" % (result,rtype)
                return result
            new_f.func_name = f.func_name
            return new_f
        return check_returns

    # 注意这两个装饰器的顺序，如果倒过来会出错，因为 @accepts 先过滤了 func 函数，而 @returns 又过滤 @accepts 函数的结果
    @returns((int,float))  # 相当于: returns((int,float)) (accepts(int, (int,float))(func2)) (arg1, arg2)
    @accepts(int, (int,float)) # 相当于: accepts(int, (int,float)) (func2) (arg1, arg2)
    def func(arg1, arg2):
        return arg1 * arg2

    # 测试一下运行结果
    print( func(2, 3) )

    # 下面用一个不写“@”装饰的函数测试调用方法
    def func2(arg1, arg2):
        return arg1 * arg2

    # 下面的调用,要注意理解各个圆括号, 尤其最后一行嵌套的写法
    print( returns((int,float))(func2)(2, 5) )
    print( accepts(int, (int,float))(func2)(2, 5) )
    print( returns((int,float)) (accepts(int, (int,float))(func2)) (2, 5) )


内置的装饰器
    有三个，分别是 staticmethod, classmethod 和 property
    作用分别是把类中定义的实例方法变成静态方法、类方法和类属性。
    由于模块里可以定义函数，所以静态方法和类方法的用处并不是太多，除非你想要完全的面向对象编程。
    而属性也不是不可或缺的，Java没有属性也一样活得很滋润。使用频率较少,了解即可。

staticmethod 和 classmethod 的用法与区别:
    对于 classmethod 的参数, 需要隐式地传递类名, 而 staticmethod 参数中则不需要传递类名, 其实这就是二者最大的区别。
    对于 staticmethod 就是为了要在类中定义而设置的，一般来说很少这样使用，可以使用模块级(module-level)的函数来替代它。既然要把它定义在类中，想必有作者的考虑。
    对于 classmethod, 可以通过子类来进行重定义。


范例(staticmethod 和 classmethod 的用法与区别)：
    class Person:
        def sayHi(self):  # self参数必须写，正常函数的写法
            print('Hello, how are you?')

        @staticmethod # 申明此方法是一个静态方法，外部可以直接调用
        def tt(a): # 静态方法，第一个参数不需要用 self
            print(a) # 第一个参数就是传过来的参数

        def ff(self):
            self.sayHi() # 正常方法的调用
            self.tt('dd') # 静态方法的调用

        @classmethod  # 申明此方法是一个类方法
        def class_method(class_name, arg1):
            c = class_name()
            c.sayHi() # 正常类方法的调用,用之前需要new这个类
            class_name.tt('cc') # 静态方法的调用
            print(arg1) # 第一个参数是类名,第二个参数开始才是传过来的参数

    p = Person()
    p.ff() # 正常方法的调用: self参数不需赋值, 必须先 new 出一个类才可以用

    Person.tt('tt') # 可以直接调用
    p.tt('tt') # 使用实例调用也行
    Person.class_method('cm') # 也可以直接调用


范例(利用 classmethod 实现单例模式)：
    class IOLoop(object):
        def __init__(self):
            print( 'IOLoop.__init__' )

        @classmethod
        def instance(cls):
            if not hasattr(cls, "_instance"):
                cls._instance = cls()
            return cls._instance

        @classmethod
        def initialized(cls):
            """Returns true if the singleton instance has been created."""
            return hasattr(cls, "_instance")

        def service(self):
          print 'Hello,World'

    # 下面调用一下,看看效果
    print( IOLoop.initialized() ) # 打印: False  表示还没有初始化这个类
    ioloop = IOLoop.instance()  # 打印: IOLoop.__init__  表示执行了这个类的 __init__ 构造函数
    ioloop.service() # 打印: Hello,World

    print( IOLoop.initialized() ) # 打印: True   表示已经初始化这个类了
    ioloop = IOLoop.instance() # 没有打印,因为 __init__ 不需要再次执行
    ioloop.service() # 打印: Hello,World


property 属性用法(原理可参考文档“1.6.3.属性”)
  1.现在介绍第一种使用属性的方法(不使用 @property 的写法)：
    在该类中定义三个函数，分别用作赋值、取值和删除变量(此处表达也许不很清晰，请看示例)

    # 假设定义了一个类:C, 该类必须继承自object类, 有一私有变量__x
    class C(object):
        def __init__(self):
            self.__x=None

        # 取值函数
        def getx(self):
            return self.__x

        # 赋值函数
        def setx(self,value):
            self.__x=value

        # 删除函数
        def delx(self):
            #del self.__x
            self.__x=None

        # 定变量名
        # property 函数原型为 property(fget=None, fset=None, fdel=None, doc=None), 所以根据自己需要定义相应的函数即可。
        x = property(getx, setx, delx, '属性x的doc')


    # 现在这个类中的x属性便已经定义好了，我们可以对它进行赋值、取值, 以及删除操作
    c=C() # new 一个实例
    c.x=100 # 赋值
    y=c.x # 取值
    print(y) # 打印: 100
    print(c.x) # 打印: 100

    del c.x # 删除变量
    print(c.x) # 打印: None
    print(C.x.__doc__) # 打印这属性的doc


  2.下面看第二种方法(在py2.6中新增, 使用 @property 修饰符的写法)
    注意同一属性的三个函数名要相同

    # 同样定义一个类:C, 该类也有一私有变量__x
    class C(object):
        def __init__(self):
            self.__x=None

        @property # 申明这是一个属性,同时也定义了取值函数、doc
        def x(self):
            '''属性x的doc
            '''
            return self.__x

        @x.setter # 赋值函数
        def x(self,value):
            self.__x=value

        @x.deleter # 删除函数
        def x(self):
            #del self.__x
            self.__x=None

    # 对属性进行赋值、取值, 以及删除的操作同上例, 不再写



functools 模块提供了两个装饰器。
    这个模块是Python 2.5后新增的，一般来说大家用的应该都高于这个版本。

    wraps(wrapped[, assigned][, updated]):
        函数是有几个特殊属性比如函数名，在被装饰后，上例中的函数名foo会变成包装函数的名字wrapper，这个装饰器可以解决这个问题，它能将装饰过的函数的特殊属性保留。

    total_ordering(cls):
        这个装饰器在特定的场合有一定用处，但是它是在Python 2.7后新增的。
        它的作用是为实现了至少 __lt__, __le__, __gt__, __ge__ 其中一个的类加上其他的比较方法，这是一个类装饰器。
        如果觉得不好理解，不妨仔细看看这个装饰器的源代码。

范例(functools.wraps 装饰器的用法与用途):
    import time
    import functools
    def timeit(func):
        @functools.wraps(func)
        def wrapper():
            start = time.clock()
            func()
            end =time.clock()
            print 'used:', end - start
        return wrapper

    @timeit
    def foo():
        print 'in foo()'

    foo()
    print(foo.__name__) # 打印: foo,  没有 @functools.wraps 装饰过的话,打印 wrapper

