运算符重载 # https://github.com/huaxz1986/python_learning_notes/blob/master/chapter/26_python_operator.md

1.运算符重载只是意味着在类方法中拦截内置的操作
    运算符重载让类拦截常规的Python运算
    类可以重载所有的Python表达式运算符。当实例对象作为内置运算符的操作数时，这些方法会自动调用
    类也可以重载打印、函数调用、属性点号运算符等内置运算
    重载可以使得实例对象的行为更像内置类型
    重载运算符通常并不是必须的，也不是默认的行为
    
2.Python中所有可以被重载的方法名称前、后均有两个下划线字符，以便将它与其他类内定义的名字区分开来，如__add__
3.若使用未定义运算符重载方法，则它可能继承自超类。若超类中也没有则说明你的类不支持该运算，强势使用该运算符则抛出异常

class A:
    def __add__(self, n):
        print("A add", n)
class childA(A):
    pass
    
>>> a = childA()
>>> a + 'child' # A add child
>>> a - 'child' # TypeErr

4..__init__(self,args)方法：称为构造函数。当新的实例对象构造时，会调用.__init__(self,args)方法。它用于初始化实例的状态
class A:
    def __init__(self, n):
        self.n = n
>>> a = A(10)
>>> a.__dict__ # {'n':10}

5..__getitem__(self,index)和.__setitem(self,index,value)方法：
    对于实例对象的索引运算，会自动调用.__getitem__(self,index)方法，将实例对象作为第一个参数传递，方括号内的索引值传递给第二个参数
    
    对于分片表达式也调用.__getitem__(self,index)方法。实际上分片边界如[2:4]绑定到了一个slice分片对象上，该对象传递给了.__getitem__方法。
    对于带有一个.__getitem__方法的类，该方法必须既能针对基本索引（一个整数），又能针对分片调用（一个slice对象作为参数）

    .__setitem(self,index,value)方法类似地拦截索引赋值和分片赋值。第一个参数为实例对象，第二个参数为基本索引或者分片对象，第三个参数为值
    
    
6..__index__(self)方法：该方法将实例对象转换为整数值。即当要求整数值的地方出现了实例对象时自行调用。