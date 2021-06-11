Python单例模式的实现方法

这里先对类里面的两个方法解释：
    __new__ ：被调用的 class 作为其第一个参数，该函数的功能任务是返回类的一个新实例。
    __init__ ：被调用的实例作为其第一个参数，它不返回任何东西;其职责是初始化实例。
    __call__ ：是模拟类的调用，相当于重载了括号运算符。


### 方法1 ###
  #方法1,共享属性
    #所谓单例就是所有引用(实例、对象)拥有相同的状态(属性)和行为(方法)。但类判断时并不相同。
    #同一个类的所有实例天然拥有相同的行为(方法),
    #只需要保证同一个类的所有实例具有相同的状态(属性)即可
    #所有实例共享属性的最简单最直接的方法就是__dict__属性指向(引用)同一个字典(dict)
    class Borg(object):
        _state = {}
        def __new__(cls, *args, **kw):
            ob = super(Borg, cls).__new__(cls, *args, **kw)
            ob.__dict__ = cls._state
            return ob

    class MyClass2(Borg):
        a = 1

    one = MyClass2()
    two = MyClass2()

    #one和two是两个不同的对象,id, ==, is对比结果可看出
    two.a = 3
    print( one.a ) # 3
    print( id(one) ) # 28873680
    print( id(two) ) # 28873712
    print( one == two ) # False
    print( one is two ) # False
    #但是one和two具有相同的（同一个__dict__属性）,见:
    print( id(one.__dict__) ) # 30104000
    print( id(two.__dict__) ) # 30104000

    '''
    结论：
    如果并不关心生成的实例是否具有同一id，而只关心其状态(属性)和行为方式(方法)时，可以用这方法。
    坑： 类实例不是同一个，类判断时并不相同。严格的来讲，这并非单例。
    '''


### 方法2 ###
  #方法2:使用装饰器(decorator)。
    #单例类本身根本不知道自己是单例的,因为他本身(自己的代码)并不是单例的
    def singleton(cls, *args, **kw):
        instances = {}
        def _singleton():
            if cls not in instances:
                instances[cls] = cls(*args, **kw)
            return instances[cls]
        return _singleton

    @singleton
    class MyClass(object):
        a = 1
        def __init__(self, x=0):
            self.x = x

    one = MyClass()
    two = MyClass()

    two.a = 3
    print( one.a ) # 3
    print( id(one) ) # 29660784
    print( id(two) ) # 29660784
    print( one == two ) # True
    print( one is two ) # True
    one.x = 1
    print( one.x ) # 1
    print( two.x ) # 1

    '''
    结论：
    从原理上来说，就是把一个类的进行定义偷换，换为一个函数：
        该函数接收调用者传入的初始化的参数，并检查缓存中是否已经有了该类的对象，
        如果没有该类的实例，则创建一个放入缓存并返回实例，（有关并发安全问题不在此分析）。
        看上去满足我们的要求，只需将该类的声明之上放上一个装饰器即可。
    坑： 类不能再次被继承。

    原因分析：类被装饰过之后，就会返回一个函数，而不是类本身，故在之后被继承的时候用做父类会报异常，因为这单例类本质上来说是一个method而非类。
    该缺陷使得类不能再次被继承，在代码书写上有很大的局限性，不爽！
    '''


### 方法3 ###
  #方法3,实现__new__方法，改写创建类的过程(并非 new 一个类实例的过程)
    #并在将一个类的实例绑定到类变量_instance上,
    #如果cls._instance为None说明该类还没有实例化过,实例化该类,并返回
    #如果cls._instance不为None,直接返回cls._instance
    class Singleton(object):
        # __new__ 会先于 __init__ 执行， 且首参数 cls 是 MyClass类 而不是 MyClass类实例。
        # __new__ 是一个类方法，在创建对象时调用。而 __init__ 方法是在创建完对象后，调用时对当前对象的实例做一些初始化，无返回值。
        # 如果重写了 __new__ 而在 __new__ 里面没有调用 __init__ 或者没有返回实例,那么 __init__ 将不起作用。
        def __new__(cls, *args, **kw):
            if not hasattr(cls, '_instance'):
                orig = super(Singleton, cls)
                cls._instance = orig.__new__(cls, *args, **kw)
            return cls._instance

    # 只要继承 Singleton 就可以实现单例， Singleton 可以有多个不同的单例子类且互不干扰。
    class MyClass(Singleton):
        a = 1
        def __init__(self):
            print('------init ------') # 用来判断执行了多少次 init 函数

    class MyClass2(MyClass):
        pass

    one = MyClass2() # 打印了一次 init
    two = MyClass2() # 又打印了一次 init

    two.a = 3
    print( one.a ) # 3
    #one和two完全相同,可以用id(), ==, is检测
    print( id(one) ) # 29097904
    print( id(two) ) # 29097904
    print( one == two ) # True
    print( one is two ) # True

    '''
    结论：
    从上面的测试结果可以看出：
        1. 可以被多重继承。
        2. 没有多次实例化对象。

    似乎满足我们的要求，但是致命缺陷：
        __init__ 方法被多次调用，坑来了，虽然多次创建出来的都是一个对象，但是该对象在我们每一次实例化的过程中都会被调用一次，与我们想象的只被调用一次差别有点大啊，不过感觉这个思路应该是对的。

    坑： 实例重复调用__init__()，习惯上我们的初始化代码都是放在这个方法里面的。
    '''


### 方法4 ###
  #方法4:使用__metaclass__（元类）的高级python用法。 注意只有 py2.x 可行， py3.x 不行。
    #本质上是方法2的升级（或者说高级）版
    class Singleton(type):
        # __init__ 会先于 __call__ 执行， 且首参数 cls 是 MyClass类 而不是 MyClass类实例(因为这是元类)。只在定义 MyClass类 时执行一次，后续不再执行。
        def __init__(cls, name, bases, dct):
            super(Singleton, cls).__init__(name, bases, dct)
            cls._instance = None

        # 每次 new MyClass类 时都会执行， 且首参数 cls 是 MyClass类 而不是 MyClass类实例(因为这是元类)。
        def __call__(cls, *args, **kw):
            if cls._instance is None:
                cls._instance = super(Singleton, cls).__call__(*args, **kw)
            return cls._instance

    class MyClass(object):
        __metaclass__ = Singleton
        def __init__(self):
            print('------init ------') # 用来判断执行了多少次 init 函数

    class MyClass2(MyClass):
        pass

    one = MyClass2() # 打印了一次 init
    two = MyClass2() # 不再打印 init

    two.a = 3
    print( one.a ) # 3
    print( id(one) ) # 31495472
    print( id(two) ) # 31495472
    print( one == two ) # True
    print( one is two ) # True

    '''
    结论：
    从上面的测试结果可以看出：
        1. 可以被多重继承。
        2. 没有多次实例化对象。
        3. __init__ 函数也只是调用过一次。
    '''




下面是非常规方法

### 使用模块 ###
    # python中的 模块module 在程序中只被加载一次，本身就是单例的。
    # 可以直接写一个模块，将你需要的方法和属性，写在模块中当做函数和模块作用域的全局变量即可，根本不需要写类。
    # 而且还有一些综合模块和类的优点的方法：
    class _singleton(object):
        class ConstError(TypeError):
            pass
        def __setattr__(self,name,value):
            if name in self.__dict__: # 这里是多次赋值时抛异常， 实用中不可能这样用。
                raise self.ConstError
            self.__dict__[name]=value
        def __delattr__(self,name):
            if name in self.__dict__:
                raise self.ConstError
            raise NameError
    import sys
    sys.modules[__name__]=_singleton()

    # python 并不会对 sys.modules 进行检查以确保他们是模块对象，我们利用这一点将模块绑定向一个类对象，而且以后都会绑定向同一个对象了。
    # 将代码存放在single.py中：

    >>> import single
    >>> single.a=1
    >>> single.a=2
    ConstError
    >>> del single.a
    ConstError


### 覆盖类名 ###
    class singleton(object):
        pass
    singleton=singleton()
    # 将名字singleton绑定到实例上，singleton就是它自己类的唯一对象了。
    # 但是这样也就不能再 new 这个对象，而是直接当成变量调用，感觉上有点怪。

