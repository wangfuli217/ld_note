异常对象

1.Python3中，内置异常与用户自定义异常都是类的实例对象

2.在try...except语句进行except ExceptionType子句匹配时，采用的是isinstance(exception_obj,ExceptionType)这种匹配规则。因此如果ExceptionType是exception_obj所属类的超类，则匹配也成功。

3.Python中的内置异常类继承树：

graph BT
id1(OverflowError) -->|继承|id2(ArithmeticError)
id2 -->|继承|id3(Exception)
id4(IndexError) -->|继承|id3
id3-->|继承|id5(BaseException)

    用户自定义异常类不要直接从BaseException继承。BaseException提供了默认的打印和状态保持行为
        在构造时传给异常类的所有参数都将作为一个元组存储在.args属性中
        在构造时传入的字符串作为.__str(self)__方法返回。如果传入的不是字符串， 则将先调用str()将该参数转换为字符串

    Exception是所有内置异常类的超类。用户自定义的异常类都继承自它
        系统退出事件SystemExit、KeyboardInterrupt、GeneratorExit不能继承自它
        
>>> list(BaseException.__dict__.keys())
['__setattr__', '__getslice__', '__getitem__', '__setstate__', '__reduce__', '__str__', 'args', 
'__getattribute__', '__unicode__', '__delattr__', '__repr__', '__dict__', 'message', '__doc__', '__init__', 
'__new__']
>>> a0 = BaseException(1,2,3,4)
>>> [a0.args, a0.__str__()]
[(1, 2, 3, 4), '(1, 2, 3, 4)']

>>> a1 = BaseException("abcd")  
>>> [a1.args, a1.__str__()]    
[('abcd',), 'abcd']

>>> a2 = BaseException(1,2,3,4,"abcd")
>>> [a2.args, a2.__str__()]           
[(1, 2, 3, 4, 'abcd'), "(1, 2, 3, 4, 'abcd')"]

4.自定义异常类：通常继承自Exception类
    若想自定义打印显示，则必须重写.__str__(self)方法
    如果想定制初始化方法，必须重写.__init__(self,args)方法。此时超类的.args属性同样也会起作用
>>> class A(Exception):
...     def __str__(self):
...             return "A is my exception"
...     def __init__(self, n, name):
                super(A, self).__init__(n, name)  
...             pass
... 
>>> a = A(10, 'name')
>>> str(a)
'A is my exception'
>>> a.args
(10, 'name')

5.Python在运行时会将try语句放入堆栈中。抛出异常时，Python跳转至最近的try块中，找到匹配该异常的异常处理器
（即except子句)，执行异常处理的except子句。一旦异常被捕获并且处理，则其生命周期结束
    
    异常的传递：向上返回到先前进入但是尚未离开的try

6.Python中所有的错误都是异常。但是并非所有的异常都是错误
    内置的input函数每次调用时，遇到文件末尾时引发内置的EOFError
    调用sys.exit()会触发SystemExit异常
    在键盘上按下Ctrl-C键时，会触发KeyboardInterrupt异常
>>> def test_Error(switch):
...     try:
...             if switch == 0:
...                     result=input("please input an EOF")
...             elif switch==1:
...                     import sys
...                     sys.exit(0)
...             elif switch == 2:
...                     result=input("please input a Ctrl+C")
...     except EOFError as e:
...             print("catch an EOFError:", e)
...     except SystemExit as e:
...             print("catch an SystemExit:",e)
...     except KeyboardInterrupt as e:
...             print("catch an KeyboardInterrupt:",e)
...     except:
...             print("catch an unknown error")
... 
>>> test_Error(0)
please input an EOF
catch an unknown error
>>> test_Error(1)
('catch an SystemExit:', SystemExit(0,))
>>> test_Error(2)
please input a Ctrl+C('catch an KeyboardInterrupt:', KeyboardInterrupt())
    
7.用户自定义的异常可以用于触发信号条件。这是利用异常来传递信息的方法
8.try...finally通常用于释放系统资源。虽然垃圾收集时资源会自动释放，但是垃圾收集的时机不可控，由算法自动调度
9.可以在顶层代码中使用try以及空的except来进行调试，从捕获程序有什么意外情况发生
10.sys.exc_info()函数返回最近引发的异常信息，它返回一个三元素的元组：(type,value,traceback)
    type：异常类型
    value：异常实例对象
    traceback：一个traceback对象，代表异常发生时所调用的堆栈   

11.为了拦截具体的异常，except应该具体化，避免拦截无关事件
    空的except子句拦截任何异常，包括内存错误、系统推出、键盘中断等等
    但是太具体化不利于扩展    