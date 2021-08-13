try:
    pass     #主要代码块
except:
    pass     #异常处理代码
else:
    pass     #没有异常的时候执行的代码
finally:
    pass     #无论是否发生异常都会执行的代码

try/except语句
    通过执行try代码块来触发异常，此时python会自动跳至处理器，在except分句执行后会回到代码中继续向下执行

def catcher():
    try:
        fetcher(x,4)
    except IndexError:
        print('got exception')
    print('continue')
catcher()
运行结果为
got exception
continuing

一个try语句块可以抛出多个异常
    try:
        x = input('Enter the first number: ')
        y = input('Enter the second number: ')
        print x/y
    except ZeroDivisionError:
        print "The second number can't be zero!"
    except TypeError:
        print "That wasn't a number, was it?"

一个except语句可以捕获多个异常
    try:
        x = input('Enter the first number: ')
        y = input('Enter the second number: ')
        print x/y
    except (ZeroDivisionError, TypeError, NameError):  #此时except语句后面需要加上小括号
        print 'Your numbers were bogus...'

访问捕捉到的异常对象并将异常信息打印输出
    try:
        x = input('Enter the first number: ')
        y = input('Enter the second number: ')
        print x/y
    except (ZeroDivisionError, TypeError), e:
        print e

捕捉全部异常，防止漏掉无法预测的异常情况
    try:
        x = input('Enter the first number: ')
        y = input('Enter the second number: ')
        print x/y
    except :
        print 'Someting wrong happened...'
     

try/except/else语句
除了使用except子句，还可以使用else子句，如果try块中没有引发异常，else子句就会被执行
while 1:
     try:
         x = input('Enter the first number: ')
         y = input('Enter the second number: ')
         value = x/y
         print 'x/y is', value
     except:
         print 'Invalid input. Please try again.'
     else:
         break
         
try/finally语句
    不论try子句中是否发生异常情况，finally子句肯定会被执行，也可以和else子句一起使用。
    finally子句常用在程序的最后关闭文件或网络套接字。
    try:
        1/0
    except:
        print 'Unknow variable'
    else:
        print 'That went well'
    finally:
        print 'Cleaning up'

raise语句
    使用raise语句来手动抛出一个异常，raise后面跟上Exception异常类或者Exception的子类，
    还可以在Exception的括号中加入异常的信息。
    filename = raw_input('please input file name:')
    if filename=='hello':
        raise NameError('input file name error !')
    
    Exception类是所有异常类的基类，我们还可以根据该类创建自己定义的异常类
    class SomeCustomException(Exception): pass

assert语句
    assert语句相当于条件式的raise语句，其基本形式为
    assert <test>, <data>
    执行起来就像如下的代码
    if __debug__:
        if not <test>:
            raise AseertionError(<data>)
    即如果test计算为假，Python就会引发异常，data项则是异常的额外数据

多重异常的处理
    可以在try语句中嵌套另一个try语句，一旦发生异常，python匹配最近的except语句；
    若是内部except能够处理该异常，则外围try语句不会捕获异常；若是不能，或者忽略，外围try处理
    
    def action2():
        print(1+[])
    def action1():
        try:
            action2()
        except TypeError:
            print('inner try')
    try:
        action1()
    except TypeError:
        print('outer try')
    

try ... except (处理异常)
    使用 try ... except 语句来处理异常。
    except 从句可以专门处理单一的错误或异常，或者一组包括在圆括号内的错误/异常。没有给出错误或异常的名称，则处理所有的错误和异常。
    如果某个错误或异常没有被处理，默认的Python处理器就会被调用。它会终止程序的运行，并且打印一个消息。
    还可以关联上一个 else 从句,当没有异常发生的时候执行。

    常见异常(可避免的):
        使用不存在的字典关键字 将引发 KeyError 异常。
        搜索列表中不存在的值 将引发 ValueError 异常。
        调用不存在的方法 将引发 AttributeError 异常。
        引用不存在的变量 将引发 NameError 异常。
        未强制转换就混用数据类型 将引发 TypeError 异常。
        导入一个并不存在的模块将引发一个 ImportError 异常。

try ... finally
    假如希望在无论异常发生与否的情况下都执行一段代码,可以使用 finally 块来完成。
    注意，在一个 try 块下，你可以同时使用 except 从句和 finally 块。
    如果在 finally 前面的 try 或者 except, else 等里面有 return 语句,会先跳去执行 finally 再执行 return

raise 语句
    可以使用 raise 语句引发异常(抛出异常)。你还得指明错误/异常的名称和伴随异常触发的异常对象。
    可以引发 Error 或 Exception 类的直接或间接导出类。

    在Python 3里，抛出自定义异常的语法有细微的变化。
        Python 2                                        Python 3
    ① raise MyException                                MyException
    ② raise MyException, 'error message'               raise MyException('error message')
    ③ raise MyException, 'error message', a_traceback  raise MyException('error message').with_traceback(a_traceback)
    ④ raise 'error message'                            unsupported(不支持)
    说明:
    ① 抛出不带自定义错误信息的异常，这种最简单的形式下，语法没有改变。
    ② 抛出带自定义错误信息的异常时:Python 2用一个逗号来分隔异常类和错误信息；Python 3把错误信息作为参数传递给异常类。
    ③ 抛出一个带用户自定义回溯(stack trace,堆栈追踪)的异常。在Python 2和3里这语法完全不同。
    ④ 在Python 2里，可以仅仅抛出一个异常信息。在Python 3里，这种形式不再被支持。2to3将会警告你它不能自动修复这种语法。

    例：
    raise RuntimeError("有异常发生")
    raise # raise 语句不包括异常名称或额外资料时，会重新引发当前异常。如果希望捕获处理一个异常，而又不希望异常在程序代码中消失，可以通过raise重新引发该异常。


生成器的 throw 方法
    在Python 2里，生成器有一个 throw()方法。
    调用 a_generator.throw()会在生成器被暂停的时候抛出一个异常，然后返回由生成器函数获取的下一个值。

       Python 2                                         Python 3
    ① a_generator.throw(MyException)                   a_generator.throw(MyException) # 没有变化
    ② a_generator.throw(MyException, 'error message')  a_generator.throw(MyException('error message'))
    ③ a_generator.throw('error message')               unsupported(不支持)
    说明:
    ① 最简单的形式下，生成器抛出不带用户自定义错误信息的异常。这种情况下，从Python 2到Python 3语法上没有变化 。
    ② 如果生成器抛出一个带用户自定义错误信息的异常，你需要将这个错误信息字符串(error string)传递给异常类来以实例化它。
    ③ Python 2还支持抛出只有异常信息的异常。Python 3不支持这种语法，并且2to3会显示一个警告信息，告诉你需要手动地来修复这处代码。

    例(3.x)语法:
    # 定义一个异常类,继承 Exception
    class ShortInputException(Exception):
        '''A user-defined exception class.'''
        def __init__(self, length, atleast):
            Exception.__init__(self)
            self.length = length
            self.atleast = atleast

    try:
        s = input('Enter something --> ') # Python 2 的输入是 raw_input()
        if len(s) < 3:
            raise ShortInputException(len(s), 3) # 引发异常;Python 2可以写：raise ShortInputException,(len(s), 3)
    # 捕获 EOFError 异常
    except EOFError:
        print('\nWhy did you do an EOF on me?')
    # 捕获一组错误/异常,Python 2 时应该写: “except (RuntimeError, ImportError), e:”
    except (RuntimeError, ImportError) as e:
        pass
    # Python 2 时应该写: “except ShortInputException, x:”
    except ShortInputException as x:
        print('ShortInputException: The input was of length %d,\
              was expecting at least %d' % (x.length, x.atleast))
    # 捕获所有异常
    except:
        print('\nWhy did you do an Exception on me?')
    # 没有任何异常时执行
    else:
        print('No exception was raised.')
    # 不管是否有异常,都会执行
    finally:
        print('finally .....')


# 采用sys模块回溯最后的异常
    import sys
    try:
        # ... code ...
    except:
        info = sys.exc_info()
        print(str(info[0].__name__) + ": " + str(info[1]))
    except Exception, e:
        print(str(e.__class__.__name__) + ": " + str(e)) # 打印结果跟上面的回溯一样


# 精确判断出错内容(根据 Errno 判断, Python 2.x写法)
    try:
        sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
        sock.settimeout(2)
        sock.bind(('', 18001))
        sock.connect(('127.0.0.1', 10080))
        return sock
    except socket.error, e:
        # e[0] 的值即是日志打印出来的 Errno
        if e[0] == 98: # 端口被占用
            pass
        logging.error('try_bind excpet, ip:%s, cb_port:%s, bind_port:%s' % (ip, config.NEW_CB_PORT, bind_port), exc_info=True)
        return False


#### 指定异常块的参数不正确(python 2.x) ####
    try:
        l = ["a", "b"]
        int(l[2])
    except ValueError, IndexError:  # 这样捕获两种异常,正确吗?
        pass

    # 执行上面代码时,会报出下列异常
    Traceback (most recent call last):
      File "<stdin>", line 3, in <module>
    IndexError: list index out of range

    #### 解说上述问题 ####
    在 python 2.x 中，用“ except Exception, e ”来表示被捕获的异常,所以里面的逗号会认为是命名符号,把异常实体赋值给 e 参数。
    所以上面代码“ ValueError, IndexError ”中间的逗号也起命名作用,后面的 IndexError 不再认为是一个异常类,而认为是前面 ValueError 的实体类。
    为了兼容 python 2.x 和 python 3.x, 建议改成这样的写法: “ except (ValueError, IndexError) as e: ”
    把上面代码，改成如下写法,可兼容 python 2.x 和 python 3.x

    try:
        l = ["a", "b"]
        int(l[2])
    except (ValueError, IndexError) as e:
        pass


获取详细的异常信息(跟日志打印的错误一样)

    import sys, traceback

    traceback_template = '''Traceback (most recent call last):
     File "%(filename)s", line %(lineno)s, in %(name)s
    %(type)s: %(message)s\n''' # Skipping the "actual line" item

    # Also note: we don't walk all the way through the frame stack in this example
    # see hg.python.org/cpython/file/8dffb76faacc/Lib/traceback.py#l280
    # (Imagine if the 1/0, below, were replaced by a call to test() which did 1/0.)

    try:
      1/0
    except:
      # http://docs.python.org/2/library/sys.html#sys.exc_info
      exc_type, exc_value, exc_traceback = sys.exc_info() # most recent (if any) by default

      '''
      Reason this _can_ be bad: If an (unhandled) exception happens AFTER this,
      or if we do not delete the labels on (not much) older versions of Py, the
      reference we created can linger.

      traceback.format_exc/print_exc do this very thing, BUT note this creates a
      temp scope within the function.
      '''

      traceback_details = {
                 'filename': exc_traceback.tb_frame.f_code.co_filename,
                 'lineno' : exc_traceback.tb_lineno,
                 'name'  : exc_traceback.tb_frame.f_code.co_name,
                 'type'  : exc_type.__name__,
                 'message' : exc_value.message, # or see traceback._some_str()
                }

      del(exc_type, exc_value, exc_traceback) # So we don't leave our local labels/objects dangling
      # This still isn't "completely safe", though!
      # "Best (recommended) practice: replace all exc_type, exc_value, exc_traceback
      # with sys.exc_info()[0], sys.exc_info()[1], sys.exc_info()[2]


      ## 修改这里就可以把traceback打到任意地方，或者存储到文件中了
      print traceback_template % traceback_details

