1.通过在自定义类中嵌入内置类型，类似委托；这样自定义类就可以实现内置类型的接口。
这些接口在内部通过操作嵌入的内置类型来实现。
    这是一种扩展内置类型的方式

2.通过子类扩展内置类型：所有内置类型都可以直接创建子类，如list、str、dict、tuple、set等
    内置类型的子类实例可以用于内置类型对象能够出现的任何地方
    
3.在Python3中所有的类都是新式类。
    Python2.2之前的类不是新式类
    所有的类都是从object内置类派生而来
    type(obj)返回对象实例所属的类对象
        对于实例对象的type(obj)返回值也是obj.__class__
    type(classname)返回"type"，因为所有class对象都是type的实例
    由于所有class均直接或者间接地派生自object类，因此每个实例对象都是object类的实例
    object是type类的实例，但是同时type又派生自object
    
class A:
    pass
    
a = A()
type(a) # <class '__main__.A'>
type(A) # <class 'type'>
type(type)# <class 'type'>
issubclass(A,object) # True
issubclass(type,object)  # True
isinstance(a, A) # True
isinstance(A, object) # True
isinstance(type, object) # True

4.Python3中的类有一个.__slots__属性，它是一个字符串列表。这个列表限定了类的实例对象的合法属性名。如果给实例赋了一个.__slots__列表之外的属性名会引发异常
    虽然有了.__slots__列表，但是实例对象的属性还是必须先赋值才存在
    
    
当有.__slots__列表存在时，默认会删除.__dict__属性，而getattr()，setattr() 以及dir()等函数均使用.__slots__属性，因此仍旧可以正常工作
    可以在.__slots__列表中添加.__dict__字符串， 因此对于使用.__dict__的地方均能正常工作
    
    
5.Python3的property机制：
property是一个对象，通过它给类变量名赋值。
  class A:
	age=property(getMethod,setMethod,delMethod,docMethod)
	                                 # 或者直接指定docstring
	def getMethod(self):
		pass
	def setMethod(self,val):
		pass
	def delMethod(self):
		pass
	def docMethod(self):
		...
		# return a string

    property优点：代码简单，运行速度更快;
            缺点：当类编写时可能还无法确定property名字，因此无法提供动态的接口
    如果property的docstring或者docMethod为None，则Python使用getMethod的docstring。

一个添加了语法糖的方案为：
  class A:
    	def __init__(self):
        	self._x = None
    	@property #定义了一个property get函数，必选
    	def x(self): # property name 就是 get函数的函数名
        	"""I'm the 'x' property."""
        	return self._x
    	@x.setter #定义了一个property set函数，可选
    	def x(self, value):
        	self._x = value
    	@x.deleter #定义了一个property del函数，可选
    	def x(self):
        	del self._x
            
6.Python类中有两种特殊的方法：staticmethod方法和classmethod方法
    staticmethod方法：当以实例对象调用staticmethod方法时，Python并不会将实例对象传入作为参数；
而普通的实例方法，通过实例对象调用时，Python将实例对象作为第一个参数传入
        定义staticmethod方法：
         class A:
         	@staticmethod #定义一个staticmethod
         	def func(*args,**kwargs)
         		pass		
    classmethod方法：当以实例对象或者类对象调用classmethod方法时，
Python将类对象（如果是实例对象调用，则提取该实例所属的类对象）传入函数的第一个参数cls中
        定义classmethod方法：
         class A:
         	@classmethod #classmethod
         	def func(cls,*args,**kwargs)
         		pass		
总结一下，类中可以定义四种方法：
    普通方法：方法就是类对象的一个属性，执行常规函数调用语义classname.method(args)
    实例方法：传入一个实例作为方法的第一个实参。调用时可以：
        obj.method(args):通过实例调用
        classname.method(obj,args)：通过类调用
    staticmethod方法：* obj.method(args)通过实例调用时，执行的是classname.method(args)语义
    classmethod方法：* obj.method(args)执行的是classname.method(classname,args)语义
    
    class A:
        def func1():       # 常规函数
            print("func1")
        def func2(self):   # 实例函数
            print("func2")
        @staticmethod
        def func3(arg):    # staticmethod
            print("func3", arg)
        @classmethod
        def func4(cls, arg):  # classmethod
            print("func4", cls, arg) 
            
    a = A()
    a.func1,a.func2,a.func3,a.func4
    A.func1,A.func2,A.func3,A.func4
    a.func1() # Failure
    a.func2() # Sucess
    a.func3(10) # Sucess
    a.func4(10) # Sucess
    A.func1() # Sucess
    A.func2() # Failure
    A.func3(10) # Sucess
    A.func4(10) # Sucess

7.类的实例方法中，用哪个实例调用的该方法，self就是指向那个实例对象
类的classmethod方法中，用哪个类调用该方法，cls就指向那个类对象
    class A:
        def func(self):   # 实例函数
            print("in A func",self)
        @classmethod
        def func_cm(cls):  # classmethod
            print("in A func_cm",cls) 
    class childA(A):
        pass
        
    a = A()
    child = childA()
    a.func()
    child.func()
    a.func_cm()
    child.func_cm()

8.类对象与实例对象都是可变对象，可以给类属性、实例属性进行赋值，这就是原地修改。这种行为会影响对它的多处引用
任何在类层次所作的修改都会反映到所有实例对象中
    class A:
        sum = 0
        def func(self,n):   # 实例函数
            self.n = n
    a = A(10)
    b = a
    a.n = 100
    b.n #  100
    cls = A
    A.sum = 'sum'
    cls.sum # 'sum'
    a.sum, b.sum # ('sum', 'sum')
    a.sum = 999
    b.sum # 999
    
9.若类的某个属性是可变对象（如列表、字典），则对它的修改会立即影响所有的实例对象
    class A:
        result = []
        
    a = A()
    b = A()
    a.result, b.result, A.result # ([],[],[])
    a.result.append(1)           # ([1],[1],[1])
    
10.多重继承中，超类在class语句首行内的顺序很重要。Python搜索继承树时总是根据超类的顺序，从左到右搜索超类。
    class A0:
        a = 0
    class B0:
        a= 'a'
    class Child1(A0,B0):
        pass
    class Child2(B0,A0):
        pass
    Child1.a # 0
    Child2.a # 'a'
11.类的.__mro__属性：类对象的.__mro__属性。它是一个tuple，里面存放的是类的实例方法名解析时需要查找的类。
    Python根据该元组中类的前后顺序进行查找。类对象的.__mro__列出了getattr()函数以及super()函数对实例方法
名字解析时的类查找顺序。
    class A:
        pass

    >>> class A:
...     pass
... 
>>> A.__mro__
(<class '__main__.A'>, <class 'object'>)
>>> class B(A):
...     pass
... 
>>> B.__mro__  
(<class '__main__.B'>, <class '__main__.A'>, <class 'object'>)

12.super()函数：super()返回一个super实例对象，它用于代理实例方法/类方法的执行
    super(class,an_object)：要求isinstance(an_object,class)为真。代理执行了实例方法调用
    super(class,class2)：要求 issubclass(class2,class)为真。代理执行了类方法调用
有两种特殊用法：
    super(class)：返回一个非绑定的super对象
    在类的实例方法中，直接调用super()，等价于super(classname,self)（这里self可能是classname子类实例）
    在类的类方法中，直接调用super()，等价于super(classname,cls)（这里cls可能是classname子类）

原理：super的原理类似于：
def super(cls,instance):
	mro=instance.__class__.__mro__ #通过 instance生成 mro
	return mro[mro.index(cls)+1] #查找cls在当前mro中的index,饭后返回cls的下一个元素

示例：

class Root:
	def method1(self):
		print("this is Root")
class B(Root):
	def method1(self):
		print("enter B")
		print(self)
		super(B,self).method1() #也可以简写为 super().method1()
		print("leave B")
class C(Root):
	def method1(self):
		print("enter C")
		print(self)
		super().method1()       #也可以写成super(C,self).method1()
		print("leave C")
class D(B,C):
	pass

    调用D().method1()--> D中没有method1
    B中找到（查找规则：D.__mro__) --> 执行B中的method1。此时self为D实例。D.__mro__中，B的下一个是C，因此super(B,self）.method1()从类C中查找method1。
    执行C的method1。此时self为D实例。D.__mro__中，C的下一个是Root，因此super(C,self）.method1()从类Root中查找method1。
    执行Root的method1。
    print(self)可以看到，这里的self全部为 D的实例

    类的classmethod依次类推

    类、实例的属性查找规则没有那么复杂。因为属性变量只是一个变量，它没办法调用super(...)函数。 只有实例方法和类方法有能力调用super(...)函数，才会导致这种规则诞生
# https://github.com/huaxz1986/python_learning_notes/blob/master/chapter/28_python_class_advanced.md