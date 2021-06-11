
Python 中的属性管理
    需要先对 Python 中的 “name bind”(名字绑定) 和 “name rebind”(名字重绑定) 有个了解，不然，可能会无法理解本文中的某些语义。
    另外，最好也能理解Python中的底层对象的封装和上层变量对底层对象的引用以及有关装饰器(descriptor)的内容。

    参考: http://blog.163.com/xgfone@126/blog/static/3082305520128783622398/

Python 管理属性的方法一般有三种:
    1.操作符重载(即: __getattr__, __setattr__, __delattr__ 和 __getattribute__)
    2.property 内置函数(有时又称“特性”)
    3.描述符协议(descriptor)


1. 操作符重载
    在 Python中 ，重载 __getattr__, __setattr__, __delattr__ 和 __getattribute__ 方法可以用来管理一个自定义类中的属性访问。

    __getattr__ 方法将拦截所有未定义的属性获取(即，当要访问的属性已经定义时，该方法不会被调用，至于定义不定义，是由Python能否查找到该属性来决定的)

    __getattribute__ 方法将拦截所有属性的获取(不管该属性是否已经定义，只要获取它的值，该方法都会调用)
        当一个类中同时重载了 __getattr__ 和 __getattribute__ 方法，那么 __getattr__ 也会被调用(当获取的属性未定义时)，但是 __getattribute__ 先调用。
        另外， __getattribute__ 方法仅仅存在于 Python2.6 的新式类和 Python3 的所有类中；

    __setattr__ 方法将拦截所有的属性赋值

    __delattr__ 方法将拦截所有的属性删除

    说明: 在Python中，一个类或类实例中的属性是动态的(因为Python是动态的)，也就是说，你可以往一个类或类实例中添加或删除一个属性。
    《Python学习手册(第四版)》中把这些操作分成两类: 一类是 __getattr__, __setattr__ 和 __delattr__ ，另一类是 __getattribute__ 。
    笔者认为它们都是操作符重载，所以在这把它们归为一类。

    如果我们想使用这类方法(即重载操作符)来管理自定义类的属性，就需要我们在我们的自定义类中重新定义这些方法的实现。
    由于 __getattribute__, __setattr__, __delattr__ 方法对所有的属性进行拦截，所以，在重载它们时，不能再像往常的编码，要注意避免递归调用(如果出现递归，则会引起死循环)；然而对 __getattr__ 方法，则没有这么多的限制。


  1.1 重载 __setattr__ 方法:
    在重载 __setattr__ 方法时，不能使用 “ self.name = value ” 格式，否则，它将会导致递归调用而陷入死循环。
    正确的应该是:

        def __setattr__(self, name, value):
            # do-something ...
            object.__setattr__(self, name, value) # python 2.x 时需要此类继承 object 才行，否则报错。 python 3.x 已经默认继承 object
            #self.__dict__[name] = value # 这一句可以替换上面一句，但是需要调用 __getattribute__ 来获取 __dict__ (如果重载了 __getattribute__ 方法的话， python2.x 还需要继承 object 才会调 __getattribute__)
            # do-something ...

  1.2 重载 __delattr__ 方法:
    在重载 __delattr__ 方法时，不能使用 “ del self.name ” 格式，否则，它将会导致递归调用而陷入死循环。
    正确的应该是:

        def __delattr__(self, name):
            # do-something ...
            object.__delattr__(self, name)
            #del self.__dict__[name] # 这一句可以替换上面一句，但是需要调用 __getattribute__ 来获取 __dict__ (如果重载了 __getattribute__ 方法的话， python2.x 还需要继承 object 才会调 __getattribute__)
            # do-something ...

  1.3 重载 __getattribute__ 方法:

        def __getattribute__(self, name):
            # do-something ...
            return object.__getattribute__(self, name)
            # do-something ...

    注: 在 __getattribute__ 方法中不能把 “ return object.__getattribute__(self, name)”一句替换成“ return self.__dict__[name]”，因为它(即其中的 self.__dict__ )也会触发属性获取，进而还是会导致递归调用。
    另外， python 2.x 中，如果类不继承 object 则重载 __getattribute__ 失效，不会调用 __getattribute__ 。 python3.x 默认已经继承 object ，所以重载会生效。


  1.4 重载 __getattr__ 方法:
    由于 __getattr__ 方法是拦截未定义的属性，所以它没有其他三个操作符方法中那么多的限制，因此，你可以像正常的代码一样编写它。
    它的作用就是，当一段代码(用户写的，可能是故意，也可以是无意)获取了类或类实例中没有定义的属性时，程序将做出怎样的反应，而这个回应就在 __getattr__ 方法中，由你来定。


  1..5 说明:
    这里是一些关于这几个操作符重载的额外信息，以及一些其他的内容，比如: 属性存储位置。

    1.5.1 默认的属性访问拦截
        如果上述四个操作符方法中实现了任何一个，那么，当我们执行属性访问时，相应的操作符方法就会被调用。
        但是当我们没有实现某个时，那么相应的属性访问由默认实现来拦截。
        比如: 如果我们仅仅实现了 __setattr__ 和 __delattr__ 两个操作符方法，而没有实现 __getattribute__ 和 __getattr__ 操作符方法，那么我们对属性的引用获取将使用系统默认的方式，而对于所有的属性赋值则调用 __setattr__ 操作符方法，所有属性的删除操作则调用 __delattr__ 操作符方法。

    1.5.2 返回值
        __getattr__ 和 __getattribute__ 应该返回属性 name 的值，但 __setattr__ 和 __delattr__ 就返回 None
        (None 可以显示返回，也可以不显示返回；当不显示返回时，Python 中的函数或方法默认返回 None)。

    1.5.3 使用 object 类来避免循环调用
        可能有些读者会对 object.__getattribute__(self, name), object.__setattr__(self, name, value) 和 object.__delattr__(self, name) 有些疑惑。
        其实，只要明白了 Python 中的类型继承系统和类方法调用就会很容易明白了。(因为这属于Python的基本语法范畴)。
        另外，这里也与类实例中属性布局有点小小的关系，我们将在本章节的末尾讨论(这部分不了解也行，了解将对 Python 更加清楚)。

        关于 Python 中的类型继承系统，在 Python2.6 中的新式类中和 Python3 中的所有类中，所有的类(包括内置类型和我们的自定义类型)都是 object 的子类， object 是类型继承系统中最顶尖的类，所有的类都直接或间接地继承自它。
        但是在 Python2.x 中还是需要显式继承 object 才能写“ object.__xxx__ ”，否则报错，因为默认不继承。
        另外，补充一句，所有类型(包括内置类型和我们的自定义类型)的类型都是 type 类型，或者说它们这些类型都是由 type 类型创建的。这里有个例外，我们的自定义类型可以通过元类来修饰或改变我们的自定义类，这时我们的自定义类型的类型可能会改变(具体情况要看我们的元类的实现)。

        关于 Python 中的类成员方法的调用很特别，与其他传统的编程语言不同。
        当我们使用 Instance.Method( args …) 格式来调用类成员方法时，Python在底层会做一个转换: Python 先到Instance 所属的类中找 Method 方法，如果找到就调用它，如果没有找到，就到 Instance 所属的类的所有基类中依次去找，直到找到第一个为止。
        当找到一个 Method 方法时，这里我们假设 Method 方法所属的类是 Class ，那么 Python 就会把上述格式的方法调用转换成 Class.Method(Instance, args …) 形式，接着在底层完成相应的工作。也就是说， Python 在最终完成方法调用的是 Class.Method(Instance_object, Instance_args) 。
        那么，我们是不是可以说，可以直接使用这种形式呢？答案是。可以说，我们在进行方法调用时，可以使用这两种方式中的任何一种；但是，它们有一点区别: 当使用第一种时， Python 会向从类实例所属的类开始，沿着继承链向上(它的基类)搜索成员方法，直到找到第一个或找到达 object 类也没有找到才停止；然而，对于第二种，Python只在 Class 的名字空间(即 __dict__ 字典)中搜索成员方法，而不会搜索其他的类。

        由于所有的类都是 object 的子类，所以我们可以通过上面的方式，把属性的访问控制递交给 object 类，以此来避免递归调用。
        python 2.x 中的类没有默认继承 object ，所以需要手动加上这个继承才行。

    1.5.4 公有、私有控制
        由于 Python 是动态语言，也就是说，你可以动态的给已经定义好的类或类实例添加、删除某个属性；而在 C++、Java 等语言中，类一旦定义，其类属性或类实例属性就不能添加、删除。
        如果你想在Python中，像 C++、Java 那样对未定义属性的访问进行限制，也是可以的，你可以这样做: 凡是对未定义属性的获取、赋值、删除操作，在相应的访问控制方法(__getattr__, __getattribute__, __setattr__, __delattr__)中都抛出一个 AttributeError 异常(这个异常是 Python 内置的)。

        澄清一下，我们可以像 C++、Java 那样，在 Python 中控制未定义属性的访问，但是我们不能像 C++、Java 那样控制公有(public)、私有(private)、保护(protected)性的访问。
        在 Python 中，所有的属性都是公有的，你永远都可以访问(获取、赋值、删除)，我们没有办法把它们变成私有的。
        虽然 Python 中有一个“私有”成员的概念，但它并不是 C++、Java 中的那个“私有”，它十分的脆弱，你可以把它给忽略掉。

        笔者上面所述的“我们没有办法把它们变成私有的”并不十分准确，笔者在这样说时，是按照 Python 中默认的方式，也就是说，你没有蓄意地改变这种行为。
        换句话说，就是我们确实可以通过某种手段，潜在地来把 Python 中的某些类或类实例的“公有”属性变成一个“私有”的属性。
        在《Python学习手册(第四版)》中，作者Mark Lutz给出了一个解决方案——他写了一个装饰器，通过这个装饰器可以把任何一类的某些属性变成“私有”或“公有”的(这里所说的“公有”和“私有”相当于 C++、Java 中的公有和私有)，但是这种“公有”性也不是很强，有点脆弱，能够被恶意的代码所击穿(Mark Lutz也承认了这点)。
        除此之外，我们还可以通过原始的方法来实现“公有”和“私有”性。这种方法就是，把所有的属性分为两类: 公有集合和私有集合；把所有的公有属性名放在一个公有集合中，把所有的私有属性放到私有集合当中，当我们访问一个属性时，先判断它是否是存在于私有集合中，如果是，则不能直接访问，对于成员变量必须通过一个成员方法来间接访问(在C#中，比较严格，为了访问私有成员变量，必须要定义 get 和 set 方法)，对于成员方法则不能访问，否则就抛出一个异常(比如:  AttributeError 内置异常)或者什么都不做；如果它不在于私有集合当中，再判断它是否是存在于公有集合当中，如果是，则可以进行相应的操作，如果不是，则抛出一个异常(比如:  AttributeError 异常，表示没有该属性)。
        在 Python 中，我们很难甚至没办法来实现像 C++、Java 中的“保护”(protected)机制。

    1.5.5 Python 中类或类实例的属性的存储位置
        这里，笔者简述一下: 在类继承体系中，在不同类中声明的成员变量如何存储？

        在 Python 中，所有的东西都是对象，这些对象是由一个类型实例化而来；那么说，这些对象就有属性和方法，属性可以存储一些值。
        而从直观上来看，任何可以存储东西的事物，我们都可以说它有一个空间(只有有空间，才能存储东西嘛)，而在编程中，我们一般使用术语“名字空间”或“命名空间”(namespace)来称呼它。这样，我们就得出，每个对象都有一个名字空间。
        而在 Python 中，我们使用对象的 __dict__ 属性来保存该对象的名字空间中的东西， __dict__ 是一个字典(“键-值”对，一般“键”就是属性名或方法名，“值”就是属性的值或方法名所指向的真正的方法实体对象)。

        因此，我们看出，类有它自己的名字空间，它的名字空间中保存的是它的属性和方法；而类实例也有它自己的名字空间，它的名字空间中保存的是它自己的属性(不包含类的属性)。
        但是我们要知道， Python 在对类实例的属性查找时，可以向类中查找，也就是说，可能通过类实例来引用类的属性；反过来，却是不行。
        我们虽然能够通过类实例来引用类的属性，但是却不能通过类实例来给类的属性赋值或删除类的属性: 当我们通过类实例来给某个属性赋值或删除某个属性时， Python 只认为该属性是该类实例的，而不会到类的名字空间中查找它。
        当通过类实例给个属性赋值时，如果该类实例中已经有该属性，则 Python 将把它的值修改成新值；如果该类实例中没有该属性， Python 将会在该类实例的名字空间(即 __dict__)中创建该属性，并给它赋值成新值，这时，如果该类实例所属的类及其基类中也有同名的属性，那么这些同名属性在查找时将会被该类实例的属性所覆盖，也就是， Python 将找到该类实例中的属性，而不会找到它所属的类及其基类中的那些同名属性。

        那么，我们如何才能修改或删除类中类属性呢？其实很简单，我们不能通过类实例，而是要通过类本身(类本身也是一个对象)。
        比如: 类 A 中有一个类属性a，如果要想修改a的值，就可以使用“A.a = 123”。如果我们非要使用类实例来操作类属性的赋值和删除怎么办？其实也很简单，我们可以像在C++、Java中访问私有成员变量一样，定义一个成员方法，用这个成员方法来修改或删除该类的类属性，然后类实例去调用即可，而且这种方式的控制可以用于继承体系当中。

    1.5.6 最后一点事实的澄清
        前面我们已经陈述， __getattr__ 会拦截所有未定义的属性获取， __getattribute__ 会拦截所有的属性获取， __setattr__ 会拦截所有的属性赋值， __delattr__ 会拦截所有的属性删除。
        在这里，笔者承认自己“说了慌”，其实它们并没有这么大的能力。前面的陈述是有一个限制的: 它不适用于隐式地使用内置操作获取的方法名属性。
        这意味着操作符重载方法调用不能委托给被包装的对象，除非包装类自己重新定义这些方法(附: 这些方法非常适合用于基于委托的编码模式)。

    示例:

        class Test(object):
            _x = None

            def __getattr__(self, name):
                print('__getattr__', name)
                #if self._x is None:raise ValueError('unset!')
                return self._x

            def __setattr__(self, name, value):
                print('__setattr__', name)
                self.__dict__[name] = value
                #object.__setattr__(self, name, value)

            def __delattr__(self, name):
                print('__delattr__', name)
                del self.__dict__[name]
                #object.__delattr__(self, name)

            def __getattribute__(self, name):
                print('__getattribute__', name)
                return object.__getattribute__(self, name)


        t = Test()
        print('---- 赋值操作 ----')
        t.test = 555
        print('---- 赋值操作完成 ----\r\n')
        print('***** 取值操作 *****')
        print(t.test)
        print('***** 取值操作完成 *****\r\n')
        print('+++++ 删值操作 +++++')
        del t.test
        print('+++++ 删值操作完成 +++++\r\n')
        print('***** 取值操作 *****')
        print(t.test)
        print('***** 取值操作完成 *****\r\n')


2. 特性
    在 Python 中，除了重载操作符外来管理类实例属性的访问控制外，也可以使用特性(property)。

  2.1 property 类
    在没有讲解使用特性来管理类实例的属性访问控制时，我们先来探讨一下“什么是特性”。

    其实，在 Python 中，隐式的存在一种类型，它就是 property 类，可以把它看成是 int 类型，并可以使用它来定义变量(在面向对象里，一般称为“对象”，也就是类实例)。
    而用来管理类实例的属性访问控制的“特性”正是使用这个 property 类。该类可以管理自定义类的实例的属性访问控制。

    在 property 类中，有三个成员方法和三个装饰器函数。
    三个成员方法分别是:  fget 、 fset 、 fdel ，它们分别用来管理属性访问；
    三个装饰器函数分别是:  getter 、 setter 、 deleter ，它们分别用来把三个同名的类方法装饰成 property 。
    其中， fget 方法用来管理类实例属性的获取， fset 方法用来管理类实例属性的赋值， fdel 方法用来管理类实例属性的删除；
    getter 装饰器把一个自定义类方法装饰成 fget 操作， setter 装饰器把一个自定义类方法装饰成 fset 操作， deleter 装饰器把一个自定义类方法装饰成 fdel 操作。

    以上的说明，笔者有点把 fget 、 fset 、 fdel 的功能说死了，其它这三个函数中不仅仅可以分别管理自定义类实例属性的获取、赋值、删除，它们还可以做其它的任何事情，就像普通函数一样(普通函数能完成什么样的功能，它们也都可以)，甚至不做它们的本职工作也行(不过，我们一般都会完成自定义类实例属性的获取、赋值、删除等操作，有时，可能还会完成一些其它额外的工作)。
    其实，不管这三个函数完成什么的功能，只要在获取自定义类实例的属性时就会自动调用fget成员方法，给自定义类实例的属性赋值时就会自动调用fset成员方法，在删除自定义类实例的属性时就会自动调用fdel成员方法。

  2.2 property 类的使用
    根据 property 类中的成员类别，笔者把有关“特性”的使用分成两部分: 一般成员方法和装饰器方法。

    2.2.1 使用一般成员方法:
        我们上面提到“ property 类是隐式的”，所以，我们不能直接使用这个 property 类。那怎么办呢？
        没关系， Python 为我们提供了一个标准的内置函数 property ，该函数通过我们传递给它的参数自动帮我们创建一个 property 类实例，并将该类实例返回。
        所以，我要想创建 property 类实例，就需要调用标准的内置函数 property 。

    2.2.2 property 函数
        property 函数的原型: property(fget=None, fset=None, fdel=None, doc=None)

        其中，前三个参数分别是自定义类中的方法名， property 函数会根据这三个参数自动创建 property 类中的三个相应的方法。
        第四个参数文档(也就是字符串)，把它作为 property 类的说明文档；我们知道，在 Python 中，可以为一个类或函数添加一个文档说明；当doc参数为 None 时， property 函数会提取第一个参数fget的说明文档，如果fget参数的说明文档也为 None ，那么doc参数的值就为 None 。
        property 函数返回一个 property 类型的实例。

    2.2.3 property 的使用方法
        关于“特性”的使用方法，是在自定义类中通过定义一个类属性而完成的；虽然 property 类实例是自定义类的类属性，但对 property 类实例的操作将作用于自定义类的实例的属性上。
        其实，自定义类的实例的属性的信息仍然是存储于自定义类的实例中，而“特性”(即 property 类实例)只不过在管理如何对它进行访问(获取、赋值、删除)。

        由 property 创建的属性(也就是管理自定义类实例的“特性”)是属于自定义类的，而不是属于自定义类实例的；但是，它却是管理自定义类实例的属性的，而不管理自定义类的类属性。
        下面，我们具体地再把“特性”的执行流程阐述一下。

        最后，我们要注意两点:
            第一，一个“特性”只能控制自定义类的一个属性的访问控制，如果想控制多个，就必须定义多个“特性”；
            第二，在通过“特性”来控制自定义类实例的属性访问控制时，“特性”的名字不能和它所控制的自定义类实例的属性的名字相同。为什么不能一样呢？我们试想，当一样时，如果我们在“特性”的成员方法中再次访问了该属性，它就会触发属性的获取、赋值或删除操作，那么由于“特性”会拦截该访问控制，所以就会再次引发该成员方法的调用，这样，就会导致递归调用而进入死循环，直到内存耗尽。当然，如果你不会在“特性”的成员方法中再次访问该属性，就不会导致递归调用。

    2.2.4 例子

        class A(object): # python 2.x 时，这类必须继承 object ，否则 property 不能正常使用
            def __init__(self):
                print("init …")
                self._x = 0

            def getx(self):
                print("getx …")
                return self._x

            def setx(self, value):
                print("setx …")
                self._x = value

            def delx(self):
                print("delx …")
                del self._x

            x = property(getx, setx, delx)

        a = A()            # init ...
        print(a.x)         # getx ...   # 0
        a.x = 123          # setx ...
        print(a.x)         # getx ...   # 123
        print(a._x)        # 123
        a._x = 456         # 这个不会输出任何东西
        print('-'*10)      # 这个作为分隔符，让输出更容易看

        print(a.x)         # getx ...   # 456
        del a.x            # delx ...
        #del a._x           # 这句语句将抛出异常
        a.x = 789          # setx ...
        del a.x            # delx ...
        a._x = 100         # 这个不会输出任何东西
        print(a.x)         # getx ...   # 100


  2.3 property 装饰器
    我们可以使用装饰器来使自定义类的方法成为“特性”，装饰器的接口比较简洁。

    property 类有三个装饰器方法(getter、setter、deleter)，按照装饰器的一般使用方法，如果我们把一个方法成为 property 类的fget方法，就需要调用 property 的getter装饰器方法。
    但是，上面我们已经知道， property 类是隐式的，所以，我们不能直接使用getter装饰器(就是想使用也没有办法使用——因为我们不能直接获取到 property 类)，所以，我们还需要借助 property 内置函数。

    2.3.1 使用方法:
        property 不仅是可以作为内置函数来使用，而且还可以作为装饰器来使用。
        当我们把 property 内置函数当作装饰器来使用时，它将会隐式的创建一个 property 类实例，并调用该实例的 getter 装饰器，使得 property 装饰器所装饰的方法成为 property 类的fget成员方法。
        最终，由 property 将重新绑定它所装饰的方法，使它所装饰的方法名重新绑定到新创建的 property 类实例，而它所装饰的方法成为该 property 类实例的fget方法。

        假设 property 所装饰的方法的名字为 name ，那么，从此以后，我们可以使用 name.setter 和 name.deleter 来装饰其它的方法，使其成为fset和fdel成员方法，因为，此时的 name 被 property 装饰器重新绑定到新创建的 property 类实例，也就是说， name 是一个 property 类实例。
        注: 在用 name.setter 和 name.deleter 装饰其它方法时，其它方法必须是 name 。
        总之，用 setter 和 deleter 装饰器修饰的方法的名字必须和 property 装饰器修饰的方法的名字相同。

    2.3.2 例子:

        class Person(object): # python 2.x 时，这类必须继承 object ，否则 property 不能正常使用
            def __init__(self, a_name):
                print('init...')
                self._name = a_name

            @property
            def name(self):
                print('getter...')
                return self._name

            @name.setter
            def name(self, value):
                print('setter...')
                self._name = value

            @name.deleter
            def name(self):
                print('deleter...')
                del self._name

        person = Person("student")   # init...
        print(person.name)           # getter...    # student
        person.name = "teacher"      # setter...
        del person.name              # deleter...
        #person._name                 # 会抛出异常， AttributeError: 'Person' object has no attribute '_name'
        person._name = "123"         # 这句没有打印，不触发 name.getter
        del person._name             # 这句没有打印，不触发 name.deleter


      在类 Person 中， property 装饰器将隐式地创建一个 property 类实例，然后把它所装饰的方法(第一个 name 方法)重新绑定到该 property 类实例，并把第一个 name 方法变成该 property 类实例的fget方法。
      接着分别用 name.setter 和 name.deleter 装饰器分别第二个、第三个name方法变成name的fset和fdel方法。
      在类 Person 定义结束后，我们定义了一个变量person,然后对person对象中name属性的访问控制就分别调用相应的三个name方法。
      实际上，我们对name属性的操作，最终会转移到类Person实例的_name属性身上。

  2.4 小结:
    特性是在自定义类的成员中创建一个 property 类的实例(该 property 类实例是自定义类的属性，不是自定义类实例的属性)，然后通过该 property 类实例来管理自定义类实例中的某个特定的属性。
    该 property 类实例是自定义类中的一个属性(我们在这称之为“类属性”)，当通过自定义类对象访问它时，是直接访问该类属性；当通过自定义类实例访问它时，该类属性的三个相应的属性管理方法(fget，fset，fdel)将会自动调用。
    在这三个属性管理方法中，我们可以像其他普通函数或类方法一样做任何事情，不过，我们一般是把对该类属性的访问操作(获取、赋值、删除)转移到自定义类实例的属性身上。

    在访问通过特性创建的类的属性时，装饰特性的三个方法会自动调用。

    特性是在类的属性(注: 该类属性也是一个对象，因此也是可以有属性的)中创建一个属性，对该属性的所有操作(获取、赋值、删除)都将作用在类实例的属性身上。
    特性是用来管理类实例的属性访问的，而不是管理类本身的属性访问的(即，特性不会作用在类属性上，只会作用在类实例的属性上)。
    当然，我们也可以跳过特性而直接访问类实例的属性，此时，访问操作(获取、赋值、删除)与特性无关，只受 __getattr__ , __getattribute__, __setattr__, __delattr__ 四个重载操作符的影响。
    当使用特性时，其属性管理只受特性(的三个方法)所影响，不受那些重载操作符的影响(会先调用重装符，再调用特性的三个方法)。

    一旦一个自定义类使用了“特性”来管理自定义类实例某个属性，那么凡是通过“特性”来对该属性的所有访问(获取、赋值、删除)都有“特性”的三个成员方法(fget、fset、fdel)来控制。
    这里隐含着一个事实，前面没有说明，这里必须说明一下: 如果“特性”中的三个成员方法有任何一个没有被定义，那么，就不能通过“特性”来进行相应的操作；如果进行了这样的操作，那么将会引发 AttributeError 异常(Python找不到相应的方法来调用)。
    比如: 如果没有定义fset成员方法，那么就不能通过“特性”来对被该“特性”所管理的属性进行赋值操作；否则，将引发 AttributeError 异常。


3. 描述符(descriptor)
    特性只是创建一个特定类型的描述符的一种简化方式，即: 可以把特性看成是简化了的、受限的描述符；
    换句话，你可以这样理解，“特性”是 Python 内部已经实现好的一个描述符，但它被固定了，也就是说，它没有你自己定义的描述符的功能那么强大。

  3.1 理解
    描述符是一个类，类中定义了三个成员方法: __get__, __set__, __delete__ 。
    换句话说，只要一个类中定义了这三个方法中任何一个，那么，这个类就自动的成为一个描述符。

    我们已经知道，特性可以看成是一个简化的描述符。

    用于“特性”的 property 类就相当于一个描述符(类)，你就可以把它看成一个描述符；
    property 中的三个成员方法就相当于描述符的三个成员方法:  fget相当于 __get__, fset相当于 __set__, fdel相当于 __delete__ 。
    由于特性是一个简化了的描述符，所以，描述符的原理和特性的原理差不多，可以把特性的原理应用于描述符身上。

    虽然理解描述符可以用特性的原理，但描述符本身没有内置装饰器功能。
    正所谓“祸兮福之所倚”，描述符反而比特性有更多的自由——描述符可以使用所有的OOP功能，因为“特性”的 property 类是隐式的(你不能控制它)，而描述符类是显式的，可以由你来控制。
    因此，我们可以把描述符所管理的自定义类实例属性的值存储在描述符类实例中，而不是自定义类实例中(当然，也可以存储在自定义类实例中，甚至可以同时在两者中都存储)；而“特性”所管理的自定义类实例属性的值只能存储在自定义类实例中。

  3.2 例子

        class Name(object): # python 2.x 时，这类必须继承 object ，否则 描述符(descriptor) 不能正常使用
            value = None

            def __init__(self, name):
                print('Name init ...')
                self._name = name

            def __get__(self, instance, owner): # instance 是类实例，如下面的 person 。 而 owner 是类，如下面的 Person
                print('getter ...')
                return self.value

            def __set__(self, instance, value):
                print('setter ...')
                self.value = value

            def __delete__(self, instance):
                print('deleter ...')
                del self.value
                del self._name

        class Person(object): # python 2.x 时，这类必须继承 object ，否则 描述符 不能正常使用
            def __init__(self, name):
                print('Person init ...')
                self.name = name

            name = Name('name')      # Name init ...

        person = Person("student")   # Person init ...  # setter ...
        print(person.name)           # getter ...       # student
        person.name = "teacher"      # setter ...
        del person.name              # deleter ...
        #person._name                 # 会抛出异常， AttributeError: 'Person' object has no attribute '_name'
        person._name = "123"         # 这句没有打印，不触发 Name.getter
        del person._name             # 这句没有打印，不触发 Name.deleter

    说明: 同“特性”的限制一样， Person 类中的类属性 name 和 Person 类实例的属性 _name 不能同样，因为这将导致递归调用而进入死循环。
    但是，不像“特性”，描述符也可以把它所管理的属性放在自身身上，因此，在此例中，为了展现这一点，笔者把它所管理的属性同时存储在了它自身和Person类实例身上。

  3.3 小结
    总之，和特性一样，描述符类就相当于一个转接类，把对一个变量(自定义类的类属性)的访问控制转接(或嫁接)到另一个变量(自定义类的实例属性)身上。
    特性和描述符一次只能用来管理一个单个的、特定的属性，既一个特性或描述符对应一个属性；如果想要管理多个属性，就必须定义多个特性和描述符。


4. 三者之间的关系
  1.特性充当个特定角色，而描述符更为通用。
    特性定义特定属性的获取、设置和删除功能。描述符也提供了一个类，带有完成这些操作的方式，但是，它们提供了额外的灵活性以支持更多任意行为。
    实际上，特性真的的只是创建特定描述符的一种简单方法——即在属性访问上运行的一个描述符。
    编码上也有区别: 特性通过一个内置函数创建，而描述符用一个类来编码；同样，描述符可以利用类的所有常用OOP功能，例如: 继承。
    此外，除了实例的状态信息，描述符有它们自己的本地状态，因此，它们可以避免在实例中的名称冲突。

  2.__getattr__,__getattribute__,__setattr__ 和 __delattr__ 方法更为通用: 它们用来捕获任意多的属性。
    相反，每个特性或描述符只针对一个特定属性提供访问拦截——我们不能用一个单个的特性或描述符捕获每个属性获取。
    其实现也不同: __getattr__,__getattribute__,__setattr__ 和 __delattr__ 是操作符重载方法，而特性和描述符是手动赋给类属性的对象。

