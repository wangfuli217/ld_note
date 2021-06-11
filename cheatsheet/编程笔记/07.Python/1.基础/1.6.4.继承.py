

继承
    多态现象:一个子类型在任何需要父类型的场合可以被替换成父类型, 即对象可以被视作是父类的实例。
    被继承的类被称为“基本类”或“超类”、“父类”。继承的类被称为“导出类”或“子类”。

    例:
    # 父类
    class Member(object):
        def __init__(self, name, age):
            self.name = name
            self.age = age
            print('(Initialized Member: %s)' % self.name)

        def tell(self):
            print('Member Name:"%s" Age:"%s"' % (self.name, self.age))

        def tell2(self):
            print('Member haha...')

    # 子类
    class Student(Member): # 继承的父类写括号里面;多继承则写多个,这括号的称为继承元组;多继承时,优先继承出现在继承元组前面的父类的属性及方法
        def __init__(self, name, age, marks):
            Member.__init__(self, name, age) # 父类的初始化,需手动写；自定义constructor后,Python不会自动调用父类的constructor； 不定义constructor的话就会自动调用父类的
            #super(Student, self).__init__(name, age) # 这一句跟上面一句效果一样,前提是父类 Member 必须继承 object,如果父类 Member 不继承 object 则报错,如: “class Member:”
            self.marks = marks
            print('(Initialized Student: %s)' % self.name)

        def tell(self):
            Member.tell(self) # 调用父类的方法,注意:方法调用之前要加上父类名称前缀, 然后把self变量及其他参数传递给它。
            print('Marks: "%d"' % self.marks)

    s = Student('Swaroop', 22, 75)
    s.tell() # 会调用子类的方法
    s.tell2() # 子类没有的, 则使用父类的；如果多继承,且父类都有这个方法,则使用继承元组中排前面的


多继承
    概念虽然容易，但是困难的工作是如果子类调用一个自身没有定义的属性，它是按照何种顺序去到父类寻找呢，尤其是众多父类中有多个都包含该同名属性。

    py 2.x 经典类(旧式类)：

        class P1:
           def foo(self):print('p1-foo')

        class P2:
           def foo(self):print('p2-foo')
           def bar(self):print('p2-bar')

        class C1(P1,P2):
           pass

        class C2(P1,P2):
           def bar(self):print('c2-bar')

        class D(C1,C2):
           pass


        d=D()
        d.foo() # 输出 p1-foo
        d.bar() # 输出 p2-bar

        #实例d调用foo()时，搜索顺序是 D => C1 => P1
        #实例d调用bar()时，搜索顺序是 D => C1 => P1 => P2
        #换句话说，经典类的搜索方式是按照“从左至右，深度优先”的方式去查找属性。


    新式类:
        class P1(object):
           def foo(self):print('p1-foo')

        class P2(object):
           def foo(self):print('p2-foo')
           def bar(self):print('p2-bar')

        class C1 (P1,P2):
           pass

        class C2 (P1,P2):
           def bar(self):print('c2-bar')

        class D(C1,C2):
           pass


        d=D()
        d.foo() # 输出 p1-foo
        d.bar() # 输出 c2-bar

        #实例d调用foo()时，搜索顺序是 D => C1 => C2 => P1
        #实例d调用bar()时，搜索顺序是 D => C1 => C2
        #可以看出，新式类的搜索方式是采用“广度优先”的方式去查找属性。

        #Python的多继承类是通过mro的方式来保证各个父类的函数被逐一调用(仅新式类有)
        print(P1.__mro__) # 打印：(<class '__main__.P1'>, <type 'object'>)
        print(P1.mro())   # 打印：[<class '__main__.P1'>, <type 'object'>]
        print(C1.__mro__) # 打印：(<class '__main__.C1'>, <class '__main__.P1'>, <class '__main__.P2'>, <type 'object'>)
        print(D.__mro__)  # 打印：(<class '__main__.D'>, <class '__main__.C1'>, <class '__main__.C2'>, <class '__main__.P1'>, <class '__main__.P2'>, <type 'object'>)


经典类(旧式类) 与 新式类
    py2.x 定义类时继承 object 的类称为新式类。没有继承 object 的为旧式类。
    py3.x 默认就是新式类。


MRO
    即 method resolution order，用于判断子类调用的属性来自于哪个父类。
    在Python2.3之前，MRO是基于深度优先算法的(旧式类)，自2.3开始使用C3算法(广度优先，新式类)。

    C3算法最早被提出是用于Lisp的，应用在Python中是为了解决原来基于深度优先搜索算法不满足本地优先级，和单调性的问题。

    本地优先级：指声明时父类的顺序，比如C(A,B)，如果访问C类对象属性时，应该根据声明顺序，优先查找A类，然后再查找B类。
    单调性：如果在C的解析顺序中，A排在B的前面，那么在C的所有子类里，也必须满足这个顺序。


super
    从 mro 就能知道， super 指的是 MRO 中的下一个类，而不是父类。

    super 所做的事如下面代码所示：

        def super(cls, inst):
            mro = inst.__class__.mro()
            return mro[mro.index(cls) + 1]

    对于在子类中调用父类方法，要么直接使用父类名来调用方法，要么在子类中用 super ，保持一致，最好不要混用。

