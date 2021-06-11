装饰器
关于装饰器,请记住:
    装饰器函数能增加或替换被装饰函数
    装饰器函数在模块加载时, 被装饰函数定义的时候就开始执行了
    在定义装饰器函数时, 如果忘了添加functools.wraps装饰器, 它会将被装饰函数的元信息拷贝过来
    
    registry = []  # <1>
    
    def register(func):  # <2>
        print('running register(%s)' % func)  # <3>
        registry.append(func)  # <4>
        return func  # <5>
    
    @register  # <6>
    def f1():
        print('running f1()')
    
    @register
    def f2():
        print('running f2()')
    
    def f3():  # <7>
        print('running f3()')
    
    def main():  # <8>
        print('running main()')
        print('registry ->', registry)
        f1()
        f2()
        f3()
        
    if __name__=='__main__': 
        main() # <9>

1.装饰器是用于包装其他可调用对象的一个可调用对象，它是一个可调用对象，其调用参数为另一个可调用对象<，它返回一个可调用对象
    一个函数对象是可调用对象。
    一个类对象是可调用对象，对它调用的结果就是返回类的实例
    实现了.__call__()方法的类，其实例对象是可调用对象，对它调用的结果就是调用.__call__()方法
    def func():
        print("this is callable")
    
    class A:
        def __init__(self):
            print("class is callable")
        def __call__(self):
            print("I am a callable instance")
>>> print func       
<function func at 0x10915f0>
>>> func()
this is callable
>>> print A
__main__.A
>>> print A()
class is callable
<__main__.A instance at 0x108dcf8>
a = A()
class is callable
a()
I am a callable instance

    装饰器有两种使用形式：
        函数的装饰器：在函数对象定义的时候使用装饰器，用于管理该函数对象
        类的装饰器：在类定义的时候使用该装饰器，用于管理该类以及类的实例
    装饰器是装饰器模式的一个实现
    
2.函数的装饰器：用于管理函数。函数的装饰器声明为：
@decorator
def func(*pargs,**kwargs):
	pass

即在正常的函数定义之前冠以@decorator说明符（即装饰器声明）。它等价于：
def func(*pargs,**kwargs):
	pass
func=decorator(func)

类中的@staticmethod、@classmethod、@property均为装饰器
执行了装饰器的def之后，函数名指向的不再是原来的函数对象，而是：
    一个可调用对象， 当decorator是个函数时由decorator(func)函数返回的
    decorator类的实例，当decorator是个类时，由decorator(func)构造方法返回
    
    def decorator1(func): # 通过函数实现装饰器
        print("This is decorator1", {'func':func})
        return func
    class decorator2: # 通过类实现装饰器
        def __init__(self, func):
            self.func = func # 需要保存函数对象
            print("This is decorator2:", {'func':func})
        def __call__(self, *args, **kwargs):
            print("in decorator2 __call__:", args, kwargs)
            return self.func(*args, **kwargs) # 这里使用原来的函数对象
    @decorator1
    def func(*args, **kwargs): # 函数的装饰器
        print("In func:", args, kwargs)
    # ('This is decorator1', {'func': <function func at 0x25db668>})
    func(1,2,3,sum=0)
    # ('This is decorator1', {'func': <function func at 0xd73668>})
    # ('In func:', (1, 2, 3), {'sum': 0})
    @decorator2
    def func2(*args, **kwargs):
        print("In func2:", args, kwargs)
    # ('This is decorator2:', {'func': <function func2 at 0x25db7d0>})
    func2(1,2,3,sum=0)
    # ('This is decorator2:', {'func': <function func2 at 0x1a38668>})
    # ('in decorator2 __call__:', (1, 2, 3), {'sum': 0})
    # ('In func2:', (1, 2, 3), {'sum': 0})
    
    
3.类的装饰器：用于管理类。类的装饰器声明为：
@decorator
class A:
	pass

即在正常的类定义之前冠以@decorator说明符（即装饰器声明）。它等价于：
class A:
	pass
A=decorator(A)

    类的装饰器并不是拦截创建实例的函数调用，而是返回一个不同的可调用对象
    执行了装饰器的class之后，类名指向的不再是原来的类对象，而是：
        一个可调用对象， 当decorator是个函数时由decorator(func)函数返回的
        decorator类的实例，当decorator是个类时，由decorator(func)构造方法返回
    def decorator1(func): # 通过函数实现装饰器
        print("This is decorator1", {'func':func})
        return func
    class decorator2: # 通过类实现装饰器
        def __init__(self, func):
            self.func = func # 需要保存函数对象
            print("This is decorator2:", {'func':func})
        def __call__(self, *args, **kwargs):
            print("in decorator2 __call__:", args, kwargs)
            return self.func(*args, **kwargs) # 这里使用原来的函数对象
        
    @decorator1
    class A:
        def __init__(self, *args, **kwargs):
            print("A.__init__", args, kwargs)
    # ('This is decorator1', {'func': <class __main__.A at 0xab00b8>})
    @decorator2
    class B:
        def __init__(self, *args, **kwargs):
            print("B.__init__", args, kwargs)
    # ('This is decorator2:', {'func': <class __main__.B at 0xab0120>})

>>> a = A(1,2,3,4, sum=4)
('This is decorator1', {'func': <class __main__.A at 0x27d60b8>})
('A.__init__', (1, 2, 3, 4), {'sum': 4})

>>> b = B(1,2,3,4, sum=4)
('This is decorator2:', {'func': <class __main__.B at 0x23a20b8>})
('in decorator2 __call__:', (1, 2, 3, 4), {'sum': 4})
('B.__init__', (1, 2, 3, 4), {'sum': 4})


3.装饰器只是一个返回可调用对象的可调用对象，它没有什么特殊的地方。
    可以用函数实现装饰器：
def decorator(func): #定义了一个叫decorator的装饰器
	#某些处理
	return func #返回可调用对象

    也可以用类来实现装饰器：
class decorator:
	def __init__(self,func):
		self.func=func
	def __call__(self,*args,**kwargs):
		return self.func

    通常用嵌套类来实现装饰器：
def decorator(func): #定义了一个叫decorator的装饰器
	def wrapper(*args):
		#使用func或其他的一些工作
	return wrapper #返回可调用对象
    
    
    def decorator1(func): # 通过函数实现装饰器
        print("This is decorator1", {'func':func})
        return func
    class decorator2: # 通过类实现装饰器
        def __init__(self, func):
            self.func = func # 需要保存函数对象
            print("This is decorator2:", {'func':func})
        def __call__(self, *args, **kwargs):
            print("in decorator2 __call__:", args, kwargs)
            return self.func(*args, **kwargs) # 这里使用原来的函数对象
    def decorator3(func): #通过嵌套函数实现装饰器
        print("This is decorator3:", {'func':func})
        def wrapper(*args, **kwargs):
            print("this is in decorator3:wrapper:", args, kwargs)
            func(args, kwargs)
        return wrapper
         
    @decorator1
    def func1(*args, **kwargs):
        print("In func1:",args,kwargs)
    # ('This is decorator1', {'func': <function func1 at 0x27337d0>})
    @decorator2
    def func2(*args, **kwargs):
        print("In func2:",args,kwargs)
    # ('This is decorator2:', {'func': <function func2 at 0x2733848>})
    @decorator3
    def func3(*args, **kwargs):
        print("In func3:",args,kwargs)
    # ('This is decorator3:', {'func': <function func3 at 0x27338c0>})

    func1()
    # ('In func1:', (), {})
    func2()
    # ('in decorator2 __call__:', (), {})
    # ('In func2:', (), {})
    func3()
    # ('this is in decorator3:wrapper:', (), {})
    # ('In func3:', ((), {}), {})
    
4.装饰器的嵌套：
    函数的装饰器的嵌套：
@decoratorA
@decoratorB
@decoratorC
def func():
	pass
等价于
def f():
	pass
f=A(B(C(f)))


    类的装饰器的嵌套：
@decoratorA
@decoratorB
@decoratorC
class M:
	pass

等价于

class M:
	pass
M=A(B(C(M)))
    每个装饰器处理前一个装饰器返回的结果，并返回一个可调用对象
    
    
5.装饰器可以携带参数。
    函数定义的装饰器带参数：它其实是一个嵌套函数。
        外层函数的参数为装饰器参数，返回一个函数（内层函数）
        内层函数的参数为func，返回一个可调用参数，内层函数才是真正的装饰器

def decorator(*args,**kwargs): 
	print("this is decorator1:",args,kwargs)
	def actualDecorator(func): # 这才是真实的装饰器
		...
		return func
	return actualDecorator
    
    def decorator1(*args, **kwargs):
        print("this is decorator1:", args, kwargs)
        def actualDecorator(func):
            print("this is actualDecorator", {'func':func})
            return func
        return actualDecorator
        
     @decorator1(99,100,d=0)
     def func1(*args, **kwargs):
        print("In func1", args, kwargs)
    # ('this is decorator1:', (99, 100), {'d': 0})
    # ('this is actualDecorator', {'func': <function func1 at 0xb396e0>})
    
    func1(1,2,3,4,sum=0)
    # ('In func1', (1, 2, 3, 4), {'sum': 0})
    
    
6. 类定义的装饰器带参数：它其实是一个嵌套类。
        外层类的初始化函数的参数为装饰器参数，外层类的__call__函数的参数为func，返回值为一个类的实例（内部类实例）
        内层类的初始化函数参数为func；内层类的__call__函数使用func，内层类才是真正的装饰器

class decorator2:
	class ActualDecorator: #这才是真实的装饰器
		def __init__(self,func):
			...
			self.func=func#记住func
		def __call__(self,*args,**kwargs):
			...
			return self.func(*args,**kwargs) #使用func
	def __init__(self,*args,**kwargs):
		...
	def __call__(self,func):
		...
		return decorator2.ActualDecorator(func)
        
    class decorator1:
        class ActualDecorator: 
            def __init__(self,func):
                print("In ActualDecorator init", {'func':func})
                self.func=func 
            def __call__(self,*args,**kwargs):
                print("In ActualDecorator call", args, kwargs)
                return self.func(*args,**kwargs) 
        def __init__(self,*args,**kwargs):
            print("This is decorator2 init", args, kwargs)
        def __call__(self,func):
            print("This is decorator2 call", {'func':func})
            return decorator1.ActualDecorator(func)
            
    @decorator1(99,100,d=0)
    def func1(*args, **kwargs):
        print("In func1", args, kwargs)
    # ('This is decorator2 init', (99, 100), {'d': 0})
    # ('This is decorator2 call', {'func': <function func1 at 0x29a35f0>})
    # ('In ActualDecorator init', {'func': <function func1 at 0x29a35f0>})
    func1(1,2,3,4,sum=0)
    # ('In ActualDecorator call', (1, 2, 3), {'sum': 0})
    # ('In func1', (1, 2, 3), {'sum': 0})
    
 总结：
    不带参数的装饰器decorator装饰一个名字F（可能为函数名、也可能为类名）@decorator：则执行的是：F=decorator(F)，直接使用F
    带参数的装饰器decorator装饰一个名字F（可能为函数名、也可能为类名）@decorator(args)：则执行的是：F=decorator(args)(F)，间接使用F

6.利用装饰器可以实现单例模式：
def Singleton(cls):
	instance=None
	def onCall(*args,**kwargs):
		nonlocal instance
		if instance == None:
			instance=cls(*args,**kwargs)
		return instance
	return onCall
@Singleton
class A:
	pass
    
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

7.利用装饰器可以跟踪对象的调用接口，从而管理对实例的接口访问（如统计调用次数，打印调用日志）
def Tracer(cls):
	class  Wrapper:
		def __init__(self,*args,**kwargs):
			self.wrapped=cls(*args,**kwargs)
		def __getattr__(self,name):
			print('Trace:'+name)
			return getattr(self.wrapped,name)
	return Wrapper
@Tracer
class A:
	pass
    
>>> def Tracer(cls):
...     class Wrapper:
...             def __init__(self, *args, **kwargs):
...                     print("in Wrapper init")
...                     self.wrapped=cls(*args,**kwargs)
...             def __getattr__(self,name):
...                     print("Trace:"+name)
...                     return getattr(self.wrapped,name)
...     return Wrapper
... 
>>> @Tracer
... class A:
...     def __init__(self):
...             self.a=0
...             self.b=1
... 
>>> a=A()
in Wrapper init
>>> a
Trace:__repr__
<__main__.Wrapper instance at 0x7fb5954bdb48>
>>> a.a
Trace:a
0
>>> a.b
Trace:b
1
>>> a.n
Trace:n
Traceback (most recent call last):
  File "<stdin>", line 1, in <module>
  File "<stdin>", line 8, in __getattr__
AttributeError: A instance has no attribute 'n'

8.装饰器也可以直接管理函数和类，而不仅仅只是管理对他们的调用
    利用装饰器添加函数和类到注册表：

register_dict={}
def register(obj):
	register_dict[obj.__name__]=obj
	return obj
@register
def func():
	pass
    
register_dict={}
def register(obj):
    register_dict[obj.__name__]=obj
    return obj

@register
def func():
    pass

@register
class A:
    pass

>>> print register_dict['A']
__main__.A                         # 返回类对象
>>> print register_dict['func']
<function func at 0x7fb59545e410>  # 返回函数对象

9. 利用装饰器为函数和类添加属性
def register(obj):
	obj.label=0
	return obj
@register
def func():
	pass

def register(obj):
    obj.label = 0
    return obj

@register
def func():
    pass

func.label # 返回添加的属性