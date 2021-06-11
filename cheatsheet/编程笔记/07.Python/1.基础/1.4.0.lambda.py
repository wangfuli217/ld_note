在编程语言中,函数的应用:
1. 代码块重复，这时候必须考虑用到函数，降低程序的冗余度
2. 代码块复杂，这时候可以考虑用到函数，降低程序的可读性
在Python,有两种函数，一种是def定义，一种是lambda函数
#假如要求两个数之和，用普通函数或匿名函数如下:
1. def func(x,y):return x+y
2. lambda x,y: x+y

lambda argument1,argument2... : expression using argument

解构上面的例子
x 为lambda函数的一个参数
： 分割符
x>3 则是返回值,在lambda函数中不能有return，其实:后面就是返回值

为什么要用匿名函数?
1. 程序一次行使用，所以不需要定义函数名，节省内存中变量定义空间
2. 如果想让程序更加简洁时。

匿名函数几个规则:
1. 一般也就一行表达式，必须有返回值
2. 不能有return
3. 可以没有参数，可以有一个或多个参数


无参匿名函数:
    ------
    >>> t = lambda : True #分号前无任何参数
    >>> t()
    True
    
    等价于下面的def定义的函数
    >>> def func(): return True
    >>> func()
    True
    
    >>> s = "this is\na\ttest" #建此字符串按照正常情形输出
    >>> s
    'this is\na\ttest'
    >>> print s.split() #split函数默认分割:空格，换行符，TAB
    ['this', 'is', 'a', 'test']
    >>> ' '.join(s.split()) #用join函数转一个列表为字符串
    'this is a test'
    
    等价于
    >>> (lambda s:' '.join(s.split()))("this is\na\ttest")
    
    
带参数匿名函数
    >>> lambda x: x**3 #一个参数
    >>> lambda x,y,z:x+y+z #多个参数
    >>> lambda x,y=3: x*y #允许参数存在默认值
    
匿名函数调用
    #直接赋值给一个变量,然后再像一般函数调用
    >>> c = lambda x,y,z: x*y*z
    >>> c(2,3,4)
    
    >>> c = lambda x,y=2: x+y #使用了默认值
    >>> c(10) #不输的话，使用默认值2

    >>> a = lambda *z:z #*z返回的是一个元祖
    >>> a('Testing1','Testing2')
    ('Testing1', 'Testing2')

    >>> c = lambda **Arg: Arg #arg返回的是一个字典
    >>> c()
    {}
    
    #直接后面传递实参
    >>> (lambda x,y: x if x> y else y)(101,102)

    >>> (lambda x:x**2)(3)

    #lambda返回的值，结合map,filter,reduce使用
    >>> filter(lambda x:x%3==0,[1,2,3,4,5,6])
    [3, 6]
    
    等价于下面的列表推导式
    >>> l = [x for x in [1,2,3,4,5,6] if x%3==0]
    >>> l
    [3, 6]
    
嵌套使用
    #lambda嵌套到普通函数中,lambda函数本身做为return的值
    >>> def increment(n):
    ... return lambda x: x+n
    ...
    >>> f=increment(4)
    >>> f(2)
    
    >>> def say():
    ... title = 'Sir,'
    ... action= lambda x: title + x
    ... return action
    ...
    >>> act = say()
    >>> act('Smith!')
    'Sir,Smith!'
    
实例
    >>> import commands
    >>> mount = commands.getoutput('mount -v')
    >>> lines = mount.splitlines()
    >>> point = map(lambda line:line.split()[2],lines)
    >>> print point
    ['/', '/proc', '/sys', '/dev/pts', '/tmp', '/var']
    
    写成一行:
    >>> print map(lambda x:x.split()[2],commands.getoutput('mount -v').splitlines())
