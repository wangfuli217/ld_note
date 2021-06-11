函数参数传递(py)：
    关键字传递：关键字传递是根据每个参数的名字传递参数。
    参数默认值：可以给参数赋予默认值。如果该参数最终没有被传递值，将使用该默认值。
    包裹传递：参数数量未知时，包裹位置参数，或者包裹关键字参数，在相应元组或字典前加 * 或 * *。
    解包裹：解包裹，就是在传递元组时，让元组的每一个元素对应一个位置参数。
    基本原则：先位置，再关键字，再包裹位置，再包裹关键字。

lambda表达式创建一个函数对象并返回它，但是它并没有绑定一个名字即它是匿名的没有函数名
return语句将一个结果对象发送给调用者
yield语句使得函数成为一个生成函数

7种可被callable()的函数
    用户定义函数: 包括lambda函数
    Build-in函数: 比如len() 或time.strftime()
    Build-in方法: 比如dict.get()
    方法: 定义在类中的函数
    类(class): 通过__new()__构建类实例, 通过__init()__初始化
    实例(instance): 如果类定义了__call()__方法.
    生成器函数(generator)

Python函数是对象，自身存储在内存块中，它可以自由地传递与引用。
    函数对象支持一个特殊操作：有括号()以及参数列表执行调用行为
    我们可以通用地检查函数对象的某些属性：如.__name__属性、.__code__属性
    可以向函数对象附加任意的用户自定义属性，如func.count=0。这样的属性可以用来直接将状态信息附加到函数对象上
    Python3中，可以给函数对象附加注解。注解不作任何事情，而且注解是可选的，它被附加在函数对象的.__annotaions__属性中。注解的格式为：
        def func(a:'a',b:(1,10),c:float) -> int:
            return a+b+c  
            注解分两种：参数注解紧随形参名字的冒号:之后；返回值注解紧随参数列表的->之后
            当出现注解时，Python将它们收集到字典中并附加到.__annotations__属性中
            注解可以与默认值同时出现，此时形参形式为c:float=4.0
            注解只有在def中有效，在lambda表达式中无效

定义函数
    函数通过 def 关键字定义。
    def 关键字后跟一个函数的 标识符 名称，然后跟一对圆括号。圆括号之中可以包括一些变量名，该行以冒号结尾。
    接下来是一块语句，它们是函数体。
    def语句可以出现在任何语句可以出现的地方，甚至是嵌套在其他语句中。
    例:
    def sayHello():
        print('Hello World!') # block belonging to the function

    sayHello() # call the function
    
    函数仅仅是对象类型，函数名也仅仅是变量名，它们没有任何特殊之处。
        函数对象有函数调用方法operator ()
        函数对象允许任意的属性添加func.attr=value
    def func(arg):
        return 0
     func
     func(-1)
     func.N=0
     print func.N
     函数主体内的代码直到函数被调用时才运行。函数内的变量名在函数实际执行之前都不会解析。
        
函数形参
    函数中的参数名称为 形参 而你提供给函数调用的值称为 实参 。
    默认情况下，参数匹配是通过其位置进行匹配的，从左到右一一匹配。必须精确传递和函数签名中参数名一样多的实参。

局部变量
    当你在函数定义内声明变量的时候，它们与函数外具有相同名称的其他变量没有任何关系，即变量名称对于函数来说是 局部 的。
    这称为变量的 作用域 。所有变量的作用域是它们被定义的块，从它们的名称被定义的那点开始。

    例:
    x = 50
    def func(x):
        print('x is', x)
        x = 2
        print('Changed local x to', x) # 打印: 2
    func(x)
    print('x is still', x) # 打印: 50, 值没有变

匿名函数：lambda表达式
    lambda表达式创建了一个函数对象，它返回该函数对象而不是将其赋值给一个变量名。
    创建lambda表达式的语法为：
    lambda arg1,arg2,...argN: expression using args
    lambda表达式是个表达式而不是语句，它能出现在不允许def出现的某些地方，比如参数中
    lambda表达式返回一个值（一个新的函数对象），可以将它手动赋值给一个变量名
        def总是将一个新的函数对象自动赋值给一个变量名（函数名）
    lambda的主体是一个单一的表达式，而不是一个代码块。因此lambda通常比def功能简单
        lambda内部甚至不能使用if语句
    lambda主体中表达式的值就是调用时的返回值，不需要显式return
    lambda表达式也能使用默认实参
    lambda表达式主体中遵循def内一样的名字作用域查找法则
    
    lambda表达式应用于map()、filter()、reduce()等函数中较多

global 语句
    如果要为一个定义在函数外的变量赋值，那么你就得告诉Python这个变量名不是局部的，而是 全局 的。使用 global 语句完成这一功能。
    没有 global 语句，是不可能为定义在函数外的变量赋值的。
    你可以使用定义在函数外的变量的值(假设在函数内没有同名的变量)。然而，应避免这样做，因为这降低程序的可读性,不清楚变量在哪里定义的。
    使用global语句可以清楚地表明变量是在外面的块定义的。
    注:可以使用同一个 global 语句指定多个全局变量。例如 global x, y, z。

    例:
    def func():
        global x
        print('x is', x)
        x = 2
        print('Changed local x to', x)  # 打印: 2

    x = 50
    func()
    print('Value of x is', x)  # 打印: 2, 值被改变了


    # 错误示例
    # 局部函数里要改变全局变量,将会报错:UnboundLocalError: local variable 'CONSTANT' referenced before assignment
    CONSTANT = 0

    def modifyConstant():
        CONSTANT += 1  # 函数内部可以直接访问全局变量,但直接改变则会报错
        print CONSTANT

    modifyConstant()

    # 上面示例 的正确写法
    CONSTANT = 0

    def modifyConstant():
        global CONSTANT # 使用 global, 则函数内部可以直接改变全局变量了
        CONSTANT += 1
        print CONSTANT

    modifyConstant()


默认参数值
    如果希望一些参数是 可选 的，这些参数可使用默认值。
    可以在函数定义的形参名后加上赋值运算符(=)和默认值，从而给形参指定默认参数值。
    注意，默认参数值应该是一个参数。

    例:
    def say(message, times = 2):
        print(message * times)

    say('Hello ')     # 打印:Hello Hello
    say('World ', 5)  # 打印:World World World World World

    重要:
    只有在形参表末尾的那些参数可以有默认参数值，即不能在声明函数形参的时候，先声明有默认值的形参而后声明没有默认值的形参。
    这是因为赋给形参的值是根据位置而赋值的。例如，def func(a, b=5)是有效的，但是def func(a=5, b)是 无效 的。


关键参数
    如果某个函数有许多参数，而你只想指定其中的一部分，那么可以通过命名来为这些参数赋值
    ——这被称作 关键参数 ——使用名字(关键字)而不是位置来给函数指定实参。
    这样做有两个优势:
      一、由于我们不必担心参数的顺序，使用函数变得更加简单了。
      二、假设其他参数都有默认值，我们可以只给我们想要的那些参数赋值。
    
    例:
    def func(a, b=5, c=10):
        print('a is', a, 'and b is', b, 'and c is', c)

    func(3, 7)        # 参数a得到值3，参数b得到值7，而参数c使用默认值10。
    func(25, c=24)    # 根据实参的位置,变量a得到值25。根据命名，即关键参数，参数c得到值24。变量b根据默认值，为5。
    func(c=50, a=100) # 使用关键参数来完全指定参数值。a得到值100,c得到值50。变量b根据默认值，为5。
##### python3 #####
    函数调用时，位置参数与关键字参数可以组合
        不能为同一个形参同时指定位置实参与关键字实参
        任何关键字实参必须位于任何位置实参之后
        
    函数定义时的参数类型顺序：
    def func(a,b,c='c',*d,e,f='f',**g):
        pass
    # a,b:为一般参数
    # c:指定了默认实参
    # d:为可变位置参数
    # e,f:为 keyword-only参数，其中f指定了默认参数
    # g:为可变关键字参数
    
    调用时必须先赋值形参c，才能进入d。无法跳过c去赋值d
        e,f,g调用时必须都是关键字实参
        
    函数调用时实参类型顺序：
    func('a','b',e='e',*seq,**dic)
    #seq是一个序列，它解包之后优先覆盖c，剩下的再收集成元组传给d
    #dic是一个字典，它解包之后优先考虑e,f，剩下的在收集成字典传递给g
    #e='e'这个关键字实参也可以位于'b'之后的任何位置
    #关键字实参必须位于位置实参之后
    >>> def func(a,b,c='c',*d,e,f='f',**g):
    ...     print(a,b,c,d,e,f,g)
    ... 
    >>> func('a','b',e='e',*[1,2,3],**{'x':0,'y':1})
    a b 1 (2, 3) e f {'y': 1, 'x': 0}
    通过位置分配位置参数
        通过匹配变量名在分配关键字参数
        额外的非关键字参数分配到 d引用的元组中
        额外的关键字参数分配到g引用的字典中
        默认值分配给剩下未赋值的参数
    
    Python最后检测确保每一个参数只传入了一个值

return 语句
    return 语句用来从一个函数 返回 即跳出函数。我们也可选从函数 返回一个值 。
    return语句是可选的。若无return，则默认自动返回None对象
    例:
    def maximum(x, y):
        if x > y:
            return x
        else:
            return y

    print(maximum(2, 3)) # 打印 3


函数属性 func_*
    在Python 2里，函数的里的代码可以访问到函数本身的特殊属性。在Python 3里，为了一致性，这些特殊属性被重新命名了。

    Python 2 与 Python 3 的比较
          Python 2                  Python 3                说明
      ① a_function.func_name      a_function.__name__     # 包含了函数的名字。
      ② a_function.func_doc       a_function.__doc__      # 包含了在函数源代码里定义的文档字符串(docstring)。
      ③ a_function.func_defaults  a_function.__defaults__ # 是一个保存参数默认值的元组。
      ④ a_function.func_dict      a_function.__dict__     # 一个支持任意函数属性的名字空间。
      ⑤ a_function.func_closure   a_function.__closure__  # 一个由cell对象组成的元组，包含了函数对自由变量(free variable)的绑定(闭包列表)。
      ⑥ a_function.func_globals   a_function.__globals__  # 一个对模块全局名字空间的引用，函数本身在这个名字空间里被定义。
      ⑦ a_function.func_code      a_function.__code__     # 一个代码对象，表示编译后的函数体。
      ⑧ a_function.func_module    a_function.__module__   # 所在 Module 的名称(func_module 其实无法调用)



需注意的函数默认参数
    默认参数： 如果调用的时候没指定，那它会是函数定义时的引用；(只在加载时定义一次，以后都是调用同一个默认参数)
    因此，默认参数建议使用基本类型；如果不是基本类型，建议写 None,然后在函数里面设默认值

  ##### 范例1，默认参数如果是 []、{} ，将会影响全局 ########
    def t1(a, b = []):
        b.append(a)
        print('%s  %s' % (id(b), b))

    t1(1)       # 打印： 12523400  [1]
    t1(2)       # 打印： 12523400  [1, 2]
    t1(3, b=[]) # 打印： 12545000  [3]

    def t2(a, b = {}):
        b[len(b)] = a
        print('%s  %s' % (id(b), b))

    t2(1)       # 打印： 12540928  {0: 1}
    t2(2)       # 打印： 12540928  {0: 1, 1: 2}
    t2(3, b={}) # 打印： 11547392  {0: 3}


  ##### 范例2，如果默认的是其它的函数调用，同样原理，默认值只是函数定义时的引用，后面不再改变 ########
    import time
    def cc(a,b = time.time()):
        print('%s  %s' % (a,b))

    cc(1)      # 打印： 1 1306501851.48
    cc(1,b=2)  # 打印： 1 2
    cc(2)      # 打印： 2 1306501851.48


  ##### 范例3，只是为了更好的理解上述所讲 ########
    def aa():
        print('aa...')
        return []

    # 只在函数定义时，执行被调用的 aa(), 后面不再执行
    def bb(a,b = aa()):
        b.append(1)
        print('%s  %s' % (id(b), b))

    bb(1) # 打印： 12542840  [1]
    bb(2) # 打印： 12542840  [1, 1]

  ################################################
  # 范例4， 为避免上面的出错，正确的写法是这样的：
    def t1(a, b = None):
        b = b or []
        b.append(a)
        print('%s  %s' % (id(b), b))

    def t2(a, b = None):
        b = b or {}
        b[len(b)] = a
        print('%s  %s' % (id(b), b))

    import time
    def cc(a, b = None):
        b = b or time.time()
        print('%s  %s' % (a,b))

    def func(arg1, arg2, arg3):
        arg1 = []
        arg2.pop()
        return arg3
    s='abcdefg'
    l=[1,2,3,4]
    num = -1
    func(s,l,num)
    s # 'abcdefg' 不变
    l # [1,2,3]   变化
    num # -1      不变
    
条件参数列表
    在实际开发中，我们会遇到如下一种需求：
    1. 默认条件有 (a, b, c, d ...)，总之很多。
    2. 调用者可以传递 (b = False, c = False) 来提供 "非" 条件，其他默认为 True。
    3. 或者传递 (b = True, c = True)，其他默认为 False。
    4. 还可以用 (all = True, ...) 来明确指定默认值。

    def test(**on):
        # 全部条件列表
        accept_args = ("a", "b", "c", "d", "e")

        # 默认条件
        default = on.pop("all", None)

        # 如果没有显式指明默认条件，则检查参数列：
        #   1. 如果有任何一个 True 条件则默认值为 False。
        #   2. 如果全部为 False，则默认值为 True。
        if default is None: default = not(True in on.values())

        # 使用 setdefault 补全参数字典
        for k in accept_args: on.setdefault(k, default)

        return on


    print test(b = False, e = False)                # 显示：{'a': True, 'c': True, 'b': False, 'e': False, 'd': True}
    print test(c = True)                            # 显示：{'a': False, 'c': True, 'b': False, 'e': False, 'd': False}
    print test(a = True, e = False)                 # 显示：{'a': True, 'c': False, 'b': False, 'e': False, 'd': False}
    print test(all = True, c = False, e = True)     # 显示：{'a': True, 'c': False, 'b': True, 'e': True, 'd': True}
    print test(all = True, c = False, e = False)    # 显示：{'a': True, 'c': False, 'b': True, 'e': False, 'd': True}
    print test(all = False, c = True, e = True)     # 显示：{'a': False, 'c': True, 'b': False, 'e': True, 'd': False}


使用 * 和 ** 来传递参数
    Python 2.x 提供了另个方法来做相同的事. 你只需要使用一个传统的函数调用 , 使用 * 来标记元组, ** 来标记字典.

    下面两个语句是等价的:
    result = function(*args, **kwargs)
    result = apply(function, args, kwargs)
    1. 函数能用特定的参数（以*开头），收集任意多的额外位置参数，将收集到的位置相关的参数到一个新元组中。
        若出现了额外的关键字参数，则报错
    2. 函数能用特定的参数（以**开头），收集任意多的额外关键字参数，将收集关键字相关的参数到一个新字典中。
        若出现了额外的位置参数，则报错

    可变参数解包：# 这里的*和**均是在函数调用中出现，而不是在函数定义中出现
        调用者可以用*语法将实参（如元组、列表、set）打散，形成位置参数
        调用者可以用**语法将字典实参打散，形成关键字参数
     def func(a,b,c,d):
        print (a,b,c,d)
     func(*[1,2,3,4])
     func(**{'a':1,'b':2,'c':3,'d':4})
    
lambda 同样支持默认值和变参，使用方法完全一致。
    test = lambda a, b = 0, *args, **kwargs: (a, b, args, kwargs,)
    print test(1, *[2, 3, 4], **{"x": 5, "y": 6}) # 打印: (1, 2, (3, 4), {'y': 6, 'x': 5})


在函数中接收元组和列表(函数的参数数量可以变动,即可变长参数)
    当要使函数接收元组或字典形式的参数的时候, 有一种特殊的方法, 它分别使用*和**前缀。
    这种方法在函数需要获取可变数量的参数的时候特别有用。
    而且, 使用*和**前缀的参数还可以传递给其它函数。

    例:
    # 由于在args变量前有*前缀, 所有多余的函数参数都会作为一个元组存储在args中
    def sum(message, *args):
        '''Return the sum of each argument.'''
        total = 0
        # 除了用循环,也可以用下标来读取参数,如: args[0]
        for i in args:
            total += i
        print (str(type(args)) + '  ' + message + ":" + str(total))
        sum2(args) # 这样传过去的 args 是一个元组；打印如： ((3, 5.5),)
        sum2(*args) # 这样传过去的 *args 表示多个参数；打印如：(3, 5.5)

    def sum2(*args):
        print(args)

    sum('hight', 3, 5.5) # 打印: <type 'tuple'>  hight:8.5
    sum('weight', 10)    # 打印: <type 'tuple'>  weight:10


    # 函数参数接收字典用法。使用的是**前缀, 多余的参数则会被认为是一个字典的键/值对。
    def printDict(message, **args):
        print(str(type(args)) + '  ' + message + ':' + str(args))
        printDict2(args = args) # 可这样, 把 args 当做一个值(里面是字典), 传过去；打印如: {'args': {'a': 3, 'b': 'dd'}}
        printDict2(**args) # 也可这样, 把 **args 看做传过来的多个键/值对, 传过去；打印如：{'a': 3, 'b': 'dd'}

    def printDict2(**args):
        print(args)

    # 注意:参数为字典时,参数里面必须使用等号,否则运行出错
    printDict('hight', a=3, b='dd') # 打印: <type 'dict'>  hight:{'a': 3, 'b': 'dd'}


    # 可以混合使用*和**前缀的参数, 但是必须 *args 在前, **args 在后,否则编译不通过
    def printMul(message, *args1, **args2):
        print(message + '  args1:' + str(args1) + '  args2:' + str(args2))

    printMul('hello', 5, 4, a=2, b=3) # 打印： hello  args1:(5, 4)  args2:{'a': 2, 'b': 3}



闭包
    闭包是指：当函数离开创建环境后，依然持有其上下文状态。如下面的 a 和 b, 在离开 test 函数后，依然持有 test.x 对象

    def test():
        x = [1, 2]
        print hex(id(x))

        def a():
            print hex(id(x)), x
            x.append(3)

        def b():
            print hex(id(x)), x

        return a, b

    a, b = test() # 打印: 0x986260
    a() # 指向 test.x, 打印: 0x986260 [1, 2]
    b() # 打印: 0x986260 [1, 2, 3]

    print a.func_closure # 打印: (<cell at 0x00988210: list object at 0x00986260>,)
    print b.func_closure # 打印: (<cell at 0x00988210: list object at 0x00986260>,)

    #test 在创建 a 和 b 时，将它们所引用的外部对象 x 添加到 func_closure 列表中。因为 x 引用计数增加了，所以就算 test 堆栈帧没有了, x 对象也不会被回收。

    '''
    通过  func_code，可以获知闭包所引用的外部名字。
    •co_cellvars:  被内部函数引用的名字列表。
    •co_freevars:  当前函数引用外部的名字列表。
    '''
    print test.func_code.co_cellvars # 被内部函数 a  引用的名字。打印: ('x',)
    print a.func_code.co_freevars # a 引用外部函数 test  中的名字。打印: ('x',)



堆栈帧
    Python 堆栈帧基本上就是对 x86 的模拟，用指针对应 BP、SP、IP 寄存器。
    堆栈帧成员包括函数执行所需的名字空间、调用堆栈链表、异常状态等。

    typedef struct _frame {
        PyObject_VAR_HEAD
        struct _frame *f_back; #  调用堆栈 (Call Stack) 链表
        PyCodeObject *f_code; # PyCodeObject
        PyObject *f_builtins; # builtins 名字空间
        PyObject *f_globals;  # globals  名字空间
        PyObject *f_locals;   # locals 名字空间
        PyObject **f_valuestack;  #  和 f_stacktop 共同维护运行帧空间，相当于 BP 寄存器。
        PyObject **f_stacktop; #  运行栈顶，相当于 SP 寄存器的作用。
        PyObject *f_trace;  # Trace function
        PyObject *f_exc_type, *f_exc_value, *f_exc_traceback; #  记录当前栈帧的异常信息
        PyThreadState *f_tstate;  #  所在线程状态
        int f_lasti;   #  上一条字节码指令在 f_code  中的偏移量，类似 IP 寄存器。
        int f_lineno;   #  与当前字节码指令对应的源码行号
        ... ...
        PyObject *f_localsplus[1];   #  动态申请的一段内存，用来模拟 x86 堆栈帧所在内存段。
    } PyFrameObject;


    可使用 sys._getframe(0) 或 inspect.currentframe() 获取当前堆栈帧。
    其中 _getframe() 深度参数为 0 表示当前函数, 1 表示调用堆栈的上个函数。
    除用于调试外，还可利用堆栈帧做些有意思的事情。


    # 范例1: 权限管理
    # 通过调用堆栈检查函数 Caller, 以实现权限管理。
        import sys
        def save():
            f = sys._getframe(1)
            if not f.f_code.co_name.endswith("_logic"): # 检查 Caller 名字，限制调用者身份。
                raise Exception("Error!") # 还可以检查更多信息。
            print "ok"
        def test(): save()
        def test_logic(): save()

        test() # Exception: Error!
        test_logic() # ok


    # 范例2: 上下文
    # 通过调用堆栈，我们可以隐式向整个执行流程传递上下文对象。
    # inspect.stack 比 frame.f_back 更方便一些。
        import inspect
        def get_context():
            for f in inspect.stack(): # 循环调用堆栈列表。
                context = f[0].f_locals.get("context") # 查看该堆栈帧名字空间中是否有目标。
                if context: return context # 找到了就返回，并终止查找循环。
        def controller():
            context = "ContextObject" # 将 context 添加到 locals  名字空间。
            model()
        def model():
            print get_context() # 通过调用堆栈查找 context 。
        controller() # 测试通过, 打印:ContextObject


包装
    用 functools.partial() 可以将函数包装成更简洁的版本。
        from functools import partial
        def test(a, b, c):
            print a, b, c
        f = partial(test, b = 2, c = 3) # 为后续参数提供命名默认值。
        f(1) # 打印: 1 2 3
        f2 = partial(test, 1, c = 3)   # 为前面的位置参数和后面的命名参数提供默认值。
        f2(5) # 打印: 1 5 3
        f2(2, c=4) # 打印: 1 2 4

        # partial  会按下面的规则合并参数。
        def partial(func, *d_args, **d_kwargs):
            def wrap(*args, **kwargs):
                new_args = d_args + args  # 合并位置参数，partial  提供的默认值优先。
                new_kwargs = d_kwargs.copy()   # 合并命名参数，partial  提供的会被覆盖。
                new_kwargs.update(kwargs)
                return func(*new_args, **new_kwargs)
            return wrap
