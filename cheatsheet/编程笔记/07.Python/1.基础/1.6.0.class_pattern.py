1.Python不会执行同名函数的重载，而只会用新对象覆盖旧对象
class A:
    def func(self,x):
        pass
    def func(self,x,y):
        pass
由于class、def均为可执行代码，因此func变量名这里被重新赋值了。

class A:
    def func(self,x):
        print("in func first")
    def func(self,x,y=0):
        print("in func second")
>>> a = A()   # 创建实例
>>> a.func(1) # 调用第二个函数

2.委托设计：在Python中委托通常以拦截.__getattr__(self,'name')来实现。该方法会拦截对不存在属性的读取
    代理类实例对象可以利用.__getattr__(self,'name')将任意的属性读取转发给被包装的对象
    代理类可以有被包装对象的借口，且自己还可以有其他接口
    
class Delegate:
    def __init__(self,data):
        self.data = data
    def __getattr__(self,key):
        print("in Delegate __getattr__")
        return getattr(self.data, key)

>>> a = Delegate('abcdef') # 创建实例
>>> a.__iter__()           # 拦截属性获取
in Delegate __getattr__
<str_iterator object at 0x124a350>
>>> a.__str__()
in Delegate __getattr__
'abcdef'

3.Python支持变量名压缩的概念：class语句内以__（两个下划线）开头但是结尾没有__（两个下划线）的变量名（如__x)会自动扩张为包含所在类的名称（如_classname__x）
    变量名压缩只发生在class语句内，且仅仅针对__x这种以__开头的变量名
    该做法常用于避免实例中潜在的变量名冲突
>>> class A:
...     __num = 0
...     def func():
...             pass
... 
>>> class B:
...     __num = 0
...     def func():
...             pass
>>> A.__num, B.__num
Traceback (most recent call last):
  File "<stdin>", line 1, in <module>
AttributeError: type object 'A' has no attribute '__num
>>> A._A__num,B._B__num,
(0,0)
    
5.多重继承：子类可以继承一个以上的超类。超类在class语句首行括号内列出，以逗号分隔
    子类与其实例继承了列出的所有超类的命名空间
    搜索属性时，Python会从左到右搜索class首行中的超类，直到找到匹配的名字
    
>>> class A0:
...     a0=0
... 
>>> class B0:
...     b0='b0'
... 
>>> class A1(A0):
...     a1= 1
... 
>>> class B1(B0):
...     b1='b1'
...     a0='ao in B1'
... 
>>> class C(A1,B1):
...     pass
... 
>>> c = C() # 创建实例
>>> c.a1    # 从A1继承
1           # 
>>> c.b1    # 从B0继承
'b1'        # 
>>> c.b0    # 从B1继承
'b0'        # 
>>> c.a0    # 从A0继承(先搜索A1,再搜索B1)
0           # 

6.工厂函数：通过传入类对象和初始化参数来产生新的实例对象：
  def factory(classname,*args,**kwargs):
	return classname(*args,**kwargs)
    
>>> class A:
...     def __init__(self,n):
...             self.n = n
>>> def factory(classname, *args, **kwargs):
        return classname(*args, **kwargs)

>>> a = factory(A, 10)
>>> a

7.抽象超类：类的部分行为未定义，必须由其子类提供
    若子类也未定义预期的方法，则Python会引发未定义变量名的异常
    类的编写者也可以用assert语句或者raise异常来显式提示这是一个抽象类

    class A:
        def func(self):
            self.act() #该方法未实现
        def act(self):
            assert False, 'act must be defined!'
    class ChildA(A):
        def act(self):
            print('in ChildA act')

     a = A()
     a.func() # 异常
     c = ChildA()
     c.func() # OK
     
这里的核心在于：超类中self.act()调用时，self指向的有可能是真实的实例对象（子类对象）