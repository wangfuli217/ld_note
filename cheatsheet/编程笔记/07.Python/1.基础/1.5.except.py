1.Python中，异常会根据错误自动地被触发，也能由代码主动触发和截获
try      可能触发异常的执行语句；# 异常会引起执行语句跳转
except   异常执行语句
else     正常执行语句
finally  正常和异常都执行语句

except子句类型
except IndexError:                           捕获指定IndexError异常
except (ValueError, AssertionError) as err:  捕获指定ValueError和AssertionError异常，并生成异常实例
except:                                      捕获所有异常


2.捕捉异常的代码：
try:
	statements #该代码执行主要的工作，并有可能引起异常
except ExceptionType1: #except子句定义异常处理，这里捕捉特定的ExceptionType1类型的异常
	statements 
except (ExceptionType2,ExceptionType3): #except子句定义异常处理，
			   #这里捕捉任何列出的异常（即只要是ExceptionType2类型或者ExceptionType3类型）
	statements 
except ExceptionType4 as excp: #这里捕捉特定的ExceptionType4类型异常，但是用变量名excp引用异常对象
	statements #这里可以使用excp引用捕捉的异常对象
except: # 该子句捕获所有异常
	statements
else: #如果没有发生异常，这来到这里；当发生了异常则不执行else子句
	statements

    
当try子句执行时发生异常，则Python会执行第一个匹配该异常的except子句。当except子句执行完毕之后（除非该except子句 又引发了另一个异常），程序会跳转到整体语句之后执行。
    整体语句就是指上面的try..except..else
如果异常发生在try代码块内，且无匹配的except子句，则异常向上传递到本try块外层的try块中。如果已经传递到了顶层了异常还没有被捕捉，则Python会终止程序并且打印默认的出错消息
如果try代码块内语句未产生异常，则Python会执行else子句，然后程序会在整体语句之后继续执行

def test_except(e = None):
    try:
        if not e:
            print("no exception raise") # 传入None，不抛出异常
        else:
            raise e
    except IndexError:
        print("catch IndexError")
    except (ValueError, AssertionError) as err:
        print("catch error", err)
    except:
        print("catch an unknown error")
    else:
        print("no exception raise")
        
>>> test_except(None) # 不抛出异常，执行else语句
no exception raise
no exception raise
>>> test_except(IndexError())
catch IndexError
>>> test_except(ValueError())
('catch error', ValueError())
>>> test_except(AssertionError("an assert error"))
('catch error', AssertionError('an assert error',))
>>> test_except(AttributeError()) # 执行except语句
catch an unknown exception

3.try/finally语句：
try:
	statements
finally:
	statements

无论try代码块执行时是否发生了异常，finally子句一定会被执行
    若try子句无异常，则Python会接着执行finally子句，执行完之后程序会跳转到整体语句之后执行
    若try子句有异常，则Python会跳转到finally子句中，并接着把异常向上传递
    
def test_finally(e = None):
    try:
        if not e:
            print("no exception raise") # 传入None，不抛出异常
        else:
            print("raise an exception")
            raise e
    finally:
        print("this is finally")
        
>>> test_finally(None) # 无异常
no exception raise
this is finally
>>> test_finally(AssertionError('an assert error')) # 有异常
raise an exception
this is finally
Traceback (most recent call last):
  File "<stdin>", line 1, in <module>
  File "<stdin>", line 7, in test_finally # 有异常
AssertionError: an assert error

4.Python中的try|except|finally统一格式：
try:
	statements #该代码执行主要的工作，并有可能引起异常
except ExceptionType1: #except子句定义异常处理，这里捕捉特定的ExceptionType1类型的异常
	statements 
except (ExceptionType2,ExceptionType3): #except子句定义异常处理，
			#这里捕捉任何列出的异常（即只要是ExceptionType2类型或者ExceptionType3类型）
	statements 
except ExceptionType4 as excp: #这里捕捉特定的ExceptionType4类型异常，但是用变量名excp引用异常对象
	statements #这里可以使用excp引用捕捉的异常对象
except:  # 该子句捕获所有异常
	statements
else:    # 如果没有发生异常，这来到这里；当发生了异常则不执行else子句
	statements
finally: # 一定会执行这个子句
	statements 

    else、finally子句可选；except子句可能有0个或者多个。但是如果有else子句，则至少有一个except
    finally执行时机：无论有没有异常抛出，在程序跳出整体语句之前的最后时刻一定会执行
        整体语句就是指上面的try..except..else...finally
        
def test_exception(e = None):
    try:
        if not e:
            print("no exception raise") # 传入None，不抛出异常
        else:
            raise e
    except IndexError:
        print("catch IndexError")
    except (ValueError, AssertionError) as err:
        print("catch error", err)
    except:
        print("catch an unknown error")
    else:
        print("no exception raise")
    finally:
        print("this is finally")
        
>>> test_exception(None) # 不抛出异常，执行else和finally
no exception raise
no exception raise
this is finally
>>> test_exception(IndexError()) # 抛出异常
catch IndexError
this is finally
>>> test_exception(ValueError('O is not int')) # 抛出异常
('catch err', ValueError('O is not int',))
this is finally
>>> test_exception(AssertionError('an assert error')) # 抛出异常
('catch err', AssertionError('an assert error',))
this is finally
>>> test_exception(AttributeError()) # 执行except
catch an unknown exception
this is finally
  
5.要显式触发异常，可以用raise语句。有三种形式的形式：
    raise exception_obj：抛出一个异常实例
    raise Exception_type：抛出一个指定异常类型的实例，调用Exception_type()获得
    raise <exceptionObj|Exception_type> from <exceptionObj2|Exception_type2>: 第二个异常实例会附加到第一个异常实例的.__cause__属性中并抛出第一个异常实例
    raise：转发当前作用域中激活的异常实例。若当前作用域中没有激活的异常实例，则抛出RuntimeError实例对象
    一旦异常在程序中由某个except子句捕获，则它就死掉了不会再传递
    raise抛出的必须是一个BaseException实例或者BaseException子类，否则抛出TypeError
        BaseException类是所有内建异常的父类。
        Exception类是所有内建异常、non-system-exiting异常的父类。用于自定义的异常类也应该从该类派生
        
def test_raise(switch):
    try:
        if switch==0:
            print("raise exception obj")
            raise IndexError("an excepton obj")
        if switch==1:
            print("raise exception type")
            raise IndexError
        if switch==2:
            print("raise from")
            raise ValueError("an value error") from IndexError("an index error") # python2不支持
        else:
            print("raise non print")
            raise "abcdf"
    except IndexError as e:
        print("catch IndexError", e, e.__cause__)  # python2不支持e.__cause__
    except ValueError as e:
        print("catch ValueError", e, e.__cause__)  # python2不支持e.__cause__
    except RuntimeError as e:
        print("catch RuntimeError", e, e.__cause__) # python2不支持e.__cause__
    except TypeError as e: 
        print("catch TypeError", e, e.__cause__) # python2不支持e.__cause__
    except:
        print("catch an unknown error")
# python3
>>> test_raise(0)        
raise exception obj
catch IndexError an excepton obj None
>>> test_raise(1)
raise exception type
catch IndexError  None
>>> test_raise(2)
raise from
catch ValueError an value error an index error
>>> test_raise(3)
raise non print
catch TypeError exceptions must derive from BaseException None

# python2
>>> test_raise(0) 
raise exception obj
('catch IndexError', IndexError('an excepton obj',))
>>> test_raise(1) 
raise exception type
('catch IndexError', IndexError())
>>> test_raise(2) 
raise non print
('catch TypeError', TypeError('exceptions must be old-style classes or derived from BaseException, not str',))
raise non print

def test_raise2(switch):
    try:
        try:
            if switch==0:
                print("raise exception obj")
                raise IndexError("Inner: an IndexError obj")
            if switch==1:
                print("raise exception type")
                raise ValueError("Inner: an ValueError obj")
        except IndexError as e:
            print("IndexError is caught", e, e.__cause__)
        except ValueError as e:
            print("ValueError will raise again", e, e.__cause__)
            raise 
    except ValueError as e:
        print("catch ValueError", e, e.__cause__)
    except BaseException as e:
        print("catch an unknown error", e)
    else:
        print("no error")
        
# python3       
>>> test_raise2(0)
raise exception obj
IndexError is caught Inner: an IndexError obj None
no error
>>> test_raise2(1)
raise exception type
ValueError will raise again Inner: an ValueError obj None
catch ValueError Inner: an ValueError obj None
# python2
>>> test_raise2(0)
raise exception obj
('IndexError is caught', IndexError('Inner: an IndexError obj',))
no error
>>> test_raise2(1)
raise exception type
('ValueError will raise again', ValueError('Inner: an ValueError obj',))
('catch ValueError', ValueError('Inner: an ValueError obj',))


6.在一个异常处理器内部raise一个异常时，前一个异常会附加到新异常的__context__属性
    如果在异常处理器内部raise被捕获的异常自己，则并不会添加到__context__属性
def test_exception_context(switch):
    try:
        try:
            if switch == 0 :
                raise IndexError("an IndexError")
            else:
                raise ValueError("an ValueError")
        except IndexError as e:
            raise AttributeError("an AttributeError") 
        except ValueError as e:
            raise 
    except BaseException as e:
        print("catch an exception", e, e.__class__,e.__context__)
    else:
        print("no error")


# python3
>>> test_exception_context(0)
catch an exception an AttributeError <class 'AttributeError'> an IndexError
>>> test_exception_context(1)
catch an exception an ValueError <class 'ValueError'> None

# python2
>>> test_exception_context(0)
('catch an exception', AttributeError('an AttributeError',), <type 'exceptions.AttributeError'>)
>>> test_exception_context(1)
('catch an exception', ValueError('an ValueError',), <type 'exceptions.ValueError'>)

在异常处理器内部raise与raise e效果相同
from sys import getrefcount
def test_exception_reraise(switch):
    try:
            try:
                    if switch==0:
                            raise IndexError("an IndexError")
                    else:
                            raise ValueError("an ValueError")
            except IndexError as e:
                    print("inner:catch an excetpion:",e,e.__class__)
                    raise
            except ValueError as e:
                    print("inner:catch an exception:",e,e.__class__)
                    raise e
    except BaseException as e:
            print("outer:catch an exception:",e,e.__class__,getrefcount(e))
    else:
            print("no error")

# python3
>>> test_exception_reraise(0)
inner:catch an excetpion: an IndexError <class 'IndexError'>
outer:catch an exception: an IndexError <class 'IndexError'> 4
>>> test_exception_reraise(1)
inner:catch an exception: an ValueError <class 'ValueError'>
outer:catch an exception: an ValueError <class 'ValueError'> 4

# python2
>>> test_exception_reraise(0)
('inner:catch an excetpion:', IndexError('an IndexError',), <type 'exceptions.IndexError'>)
('outer:catch an exception:', IndexError('an IndexError',), <type 'exceptions.IndexError'>, 5)
>>> test_exception_reraise(1)
('inner:catch an exception:', ValueError('an ValueError',), <type 'exceptions.ValueError'>)
('outer:catch an exception:', ValueError('an ValueError',), <type 'exceptions.ValueError'>, 5)

7.assert语句可能会引起AssertionError。其用法为：assert <test>,<data>。这等价于：
if __debug__:
	if not <test>:	
	raise AssertionError(<data>)
    <test>表达式用于计算真假，<data>表达式用于作为异常的参数。若<test>计算为假，则抛出AssertionError
    若执行时用命令行 -0标志位，则关闭assert功能（默认是打开的）。
        __debug__是内置变量名。当有-0标志位时，它为0；否则为1
    通常assert用于给定约束条件，而不是用于捕捉程序的错误。

assert 1>0
assert 1<0

8.Python3中有一种新的异常相关语句：with/as语句。它是作为try/finally的替代方案。用法为：
with expression [as var]:
	statements
expression必须返回一个对象，该对象必须支持环境管理协议。其工作方式为：
    计算expression表达式的值，得到环境管理器对象。环境管理器对象必须有.__enter__(self)方法和.__exit__(self, exc_type, exc_value, traceback)方法
    调用环境管理器对象的.__enter__(self)方法。如果有as子句，.__enter__(self)方法返回值赋值给as子句中的变量var；如果没有as子句，则.__enter__(self)方法返回值直接丢弃。并不是将环境管理器对象赋值给var
    执行statements代码块
    如果statements代码块抛出异常，则.__exit__(self, exc_type, exc_value, traceback)方法自动被调用
        在内部这几个实参由sys.exc_info()返回(exc_type, exc_value, traceback)信息，
        若.__exit__()方法返回值为False，则重新抛出异常到with语句之外
        若.__exit__()方法返回值为True，则异常终止于此，并不会抛出with语句之外
    如果statements代码块未抛出异常，则.__exit__(self, exc_type, exc_value, traceback)方法自动被调用，调用参数为：.__exit__(self,None,None,None)
    
    class A:
        def __enter__(self):
            print("enter")
            return 'abcdef'
        def __exit__(self, exec_type, exec_val, traceback):
            print("exit",{'exec_type':exec_type, 'exec_val':exec_val, 'traceback':traceback})
            return True
     with A() as a:
        print(a)
        raise IndexError("IndexError in with")
# 输出
enter
abcdef
('exit', {'exec_val': IndexError('IndexError in with',), 'traceback': <traceback object at 0x1407cf8>, 'exec_type': <type 'exceptions.IndexError'>})
    
    class B:
        def __enter__(self):
            print("enter")
            return '123456'
        def __exit__(self, exec_type, exec_val, traceback):
            print("exit",{'exec_type':exec_type, 'exec_val':exec_val, 'traceback':traceback})
            return False
            
    with B() as b:
        print(b)
        raise IndexError("IndexError in with")
# 输出
enter
123456
exit {'exec_val': IndexError('IndexError in with',), 'traceback': <traceback object at 0x2033ab8>, 'exec_type': <class 'IndexError'>}
Traceback (most recent call last):
  File "t.py", line 11, in <module>
    raise IndexError("IndexError in with")
IndexError: IndexError in with

9.Python3.1之后，with语句可以指定多个环境管理器，以逗号分隔。根据定义的顺序这些环境管理器对象的.__enter__(self)方法顺序调用，.__exit__(self, exc_type, exc_value, traceback)方法逆序调用
    如果对象要支持环境管理协议，则必须实现.__enter__(self)方法和.__exit__(self, exc_type, exc_value, traceback)方法

    class A:
        def __enter__(self):
            print("enter")
            return 'abcdef'
        def __exit__(self, exec_type, exec_val, traceback):
            print("exit",{'exec_type':exec_type, 'exec_val':exec_val, 'traceback':traceback})
            return True
            
    class B:
        def __enter__(self):
            print("enter")
            return '123456'
        def __exit__(self, exec_type, exec_val, traceback):
            print("exit",{'exec_type':exec_type, 'exec_val':exec_val, 'traceback':traceback})
            return False
            
    with A() as a, B() as b:
        print(a,b)
# 输出
enter
enter
abcdef 123456
exit {'exec_val': None, 'traceback': None, 'exec_type': None}
exit {'exec_val': None, 'traceback': None, 'exec_type': None}