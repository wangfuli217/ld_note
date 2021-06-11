注:本笔记基于python2.6而编辑,尽量的兼顾3.x的语法

版本问题
   python2与python3是目前主要的两个版本。
   python3.0版本较之前的有很大变动，而且不向下兼容。
   Python 2.6作为一个过渡版本，基本使用了Python 2.x的语法和库，同时考虑了向Python 3.0的迁移。即2.6版本兼容2.x和3.0的语法
       Python 2.6保持了对之前版本的全兼容，而且还包含了Python 3.0的新玩意(一些新特性需要通过“from __future__ import”来启用)。
       如，在Python2.6要使用3.0的打印,得写上“ from __future__ import print_function”
   基于早期Python版本而能正常运行于Python 2.6并无警告的程序可以通过一个2 to 3的转换工具无缝迁移到Python 3.0。

   部分函数和语句的改变
      最引人注意的改变是print语句没有了，取而代之的是print函数
      同样的还有exec语句，已经改为exec()函数。去除了<>，全部改用!=。
        在python2.x版本中
          #!/usr/bin/env python
          # 或者上句写: #!/usr/bin/python
          print "Hello, world!"
          或者：
          import sys
          sys.stdout.write("Hello, world\n")

        在python3.x中
          print('Hello world!')
          
        print([object,...][,sep=' '][,end='\n'][,file=sys.stdout])
        print(x,y,z,sep='...',end='\n',file=open('data.txt','w'))
            object表示要打印的内容，
            sep表示打印内容间的分隔字符串，
            end表示打印结束后在文本末尾添加的一个字符串，
            file指定文本将要发送到的文件
            file关键字指定的对象可以是文件对象，也可以是拥有.write()方法的其他对象
            
    打印print类似于文件.write()方法，它将默认地把对象打印到stdout流中。它会自动添加一些自动化的格式。
    和文件的.write()方法不同的是，print不需要将对象转换为字符串
    你也可以用sys.stdout.write(str(x)+' '+str(y)+'\n')代替print(x,y)
    
    file关键字指定的对象可以是文件对象，也可以是拥有.write()方法的其他对象
 
   用迭代器来替代列表
      一些知名的API将不再返回列表。
      而字典的dict.iterkeys()、dict.itervalues()和dict.iteritems()方法将会移除，而你可以使用.keys()、.values()和.items()，它们会返回更轻量级的、类似于集合的容器对象，而不是返回一个列表来复制键值。
      这样做的优点是，可以直接在键和条目上进行集合操作，而不需要再复制一次。
   整型数
      移除了含糊的除法符号('/')，而只返回浮点数。
      在以前的版本中，如果参数是int或者是long的话，就会返回相除后结果的向下取整(floor)，而如果参数是float或者是complex的话，那么就会返回相除后结果的一个恰当的近似。
      在2.6版本中可以通过from __future__ import division来启用这项特性。

      Python使用=来进行赋值. 使用del关键字来删除生成的变量

python2 to python3 问题
    1.print 语句
           2.x                        3.x                           说明
       ① print                      print()                      # 输出一个空白行
       ② print 1                    print(1)                     # 输出一个单独的值
       ③ print 1, 2                 print(1, 2)                  # 输出多个值，以空格分割
       ④ print 1, 2,                print(1, 2, end=' ')         # 输出时取消在末尾输出回车符。
       ⑤ print >>sys.stderr, 1, 2   print(1, 2, file=sys.stderr) # 把输出重定向到一个管道
       
重定向
    temp=sys.stdout #保存旧值 
    sys.stdout=open('test.txt','a') #重新对stdout赋值，该文件对象必须写打开 
    print(obj1,obj2) 
    sys.stdout.close() 
    #此句可以不要，此时文件对象自动回收，文件自动关闭 
    sys.stdout=temp #恢复旧值
       
    2.被重命名或者重新组织的模块
      1)http
        在Python 3里，几个相关的HTTP模块被组合成一个单独的包，即http。
             2.x                     3.x
        ①  import httplib          import http.client     # http.client 模块实现了一个底层的库，可以用来请求HTTP资源，解析HTTP响应。
        ②  import Cookie           import http.cookies    # http.cookies 模块提供一个蟒样的(Pythonic)接口来获取通过HTTP头部(HTTP header)Set-Cookie发送的cookies
        ③  import cookielib        import http.cookiejar  # 常用的流行的浏览器会把cookies以文件形式存放在磁盘上，http.cookiejar 模块可以操作这些文件。
        ④  import BaseHTTPServer   import http.server     # http.server 模块实现了一个基本的HTTP服务器
            import SimpleHTTPServer
            import CGIHttpServer

      2)urllib
        Python 2有一些用来分析，编码和获取URL的模块，但是这些模块就像老鼠窝一样相互重叠。在Python 3里，这些模块被重构、组合成了一个单独的包，即urllib。
             2.x                                 3.x
        ①  import urllib                       import urllib.request, urllib.parse, urllib.error
        ②  import urllib2                      import urllib.request, urllib.error
        ③  import urlparse                     import urllib.parse
        ④  import robotparser                  import urllib.robotparser
        ⑤  from urllib import FancyURLopener   from urllib.request import FancyURLopener
            from urllib import urlencode        from urllib.parse import urlencode
        ⑥  from urllib2 import Request         from urllib.request import Request
            from urllib2 import HTTPError       from urllib.error import HTTPError

        以前，Python 2里的 urllib 模块有各种各样的函数，包括用来获取数据的 urlopen()，还有用来将URL分割成其组成部分的 splittype(), splithost()和 splituser()函数。
        在python3的 urllib 包里，这些函数被组织得更有逻辑性。2to3将会修改这些函数的调用以适应新的命名方案。
        在Python 3里，以前的 urllib2 模块被并入了 urllib 包。同时，以 urllib2 里各种你最喜爱的东西将会一个不缺地出现在Python 3的 urllib 模块里，比如 build_opener()方法, Request 对象， HTTPBasicAuthHandler 和 friends 。
        Python 3里的 urllib.parse 模块包含了原来Python 2里 urlparse 模块所有的解析函数。
        urllib.robotparse 模块解析 robots.txt 文件。
        处理HTTP重定向和其他状态码的 FancyURLopener 类在Python 3里的 urllib.request 模块里依然有效。 urlencode()函数已经被转移到了 urllib.parse 里。
        Request 对象在 urllib.request 里依然有效，但是像HTTPError这样的常量已经被转移到了 urllib.error 里。

      3)dbm
        所有的DBM克隆(DBM clone)现在在单独的一个包里，即dbm。如果你需要其中某个特定的变体，比如GNU DBM，你可以导入dbm包中合适的模块。
              2.x                3.x
         ①  import dbm         import dbm.ndbm
         ②  import gdbm        import dbm.gnu
         ③  import dbhash      import dbm.bsd
         ④  import dumbdbm     import dbm.dumb
         ⑤  import anydbm      import dbm
             import whichdb

      4)xmlrpc
        XML-RPC是一个通过HTTP协议执行远程RPC调用的轻重级方法。一些XML-RPC客户端和XML-RPC服务端的实现库现在被组合到了独立的包，即xmlrpc。
              2.x                        3.x
         ①  import xmlrpclib           import xmlrpc.client
         ②  import DocXMLRPCServer     import xmlrpc.server
             import SimpleXMLRPCServer

      5)其他模块
             2.x                               3.x
        ①  try:                              import io
                import cStringIO as StringIO  # 在Python 2里，你通常会这样做，首先尝试把cStringIO导入作为StringIO的替代，如果失败了，再导入StringIO。
            except ImportError:               # 不要在Python 3里这样做；io模块会帮你处理好这件事情。它会找出可用的最快实现方法，然后自动使用它。
                import StringIO
        ②  try:                              import pickle
                import cPickle as pickle      # 在Python 2里，导入最快的pickle实现也与上边 io 相似。在Python 3里，pickle模块会自动为你处理，所以不要再这样做。
            except ImportError:
                import pickle
        ③  import __builtin__                import builtins
        ④  import copy_reg                   import copyreg # copyreg模块为用C语言定义的用户自定义类型添加了pickle模块的支持。
        ⑤  import Queue                      import queue   # queue模块实现一个生产者消费者队列(multi-producer, multi-consumer queue)。
        ⑥  import SocketServer               import socketserver # socketserver模块为实现各种socket server提供了通用基础类。
        ⑦  import ConfigParser               import configparser # configparser模块用来解析INI-style配置文件。
        ⑧  import repr                       import reprlib # reprlib 模块重新实现了内置函数 repr()，并添加了对字符串表示被截断前长度的控制。
        ⑨  import commands                   import subprocess # subprocess 模块允许你创建子进程，连接到他们的管道，然后获取他们的返回值。

        builtins模块包含了在整个Python语言里都会使用的全局函数，类和常量。重新定义builtins模块里的某个函数意味着在每处都重定义了这个全局函数。这听起来很强大，但是同时也是很可怕的。


关键字
    and    assert    break 	    class    continue    def    elif    else    except    exec
    eval    finally    for    from    global    if    import    in    is    lambda    not
    nonlocal    or    pass    print    raise    return    try    with   while   yield

    False   None    True


注释
    无论是行注释还是段注释，均以“#”来注释。
    段注释，经常采用多行字符串的写法，即三个单引号或者三个双引号括起来。
    如果需要在代码中使用中文注释，必须在python文件的最前面加上如下注释说明：
        # -* - coding: UTF-8 -* -
    如下注释用于指定解释器(必须在python文件的最前面加上)
        #! /usr/bin/python
  
数字类型
   共4种: 整数(int)、长整数(long)、浮点数(float)和复数(complex)。
   1.整数,如:1234,-1234,0
   2.长整数,如:22L  # 长整数不过是大一些的整数。Python 3已经取消这种类型,被int取代了。
   3.浮点数,如:3.23 和 52.3E-4  # E标记表示10的幂。在这里，52.3E-4表示52.3 * 10-4。
   4.复数,如:(-5+4j) 和 (2.3-4.6j) # complex(num_real,num_imag)创建一个复数，实部为数字num_real，虚部为数字num_imag

   在Python 2和Python 3的变化:
   1.八进制(octal)数: 0755 十六进制(hex)数:0x9ff 二进制数:0b101010
     Python 2: x = 0755   # 0开头
     Python 3: x = 0o755  # 0o开头
   2.long 类型
     Python 2有为非浮点数准备的 int 和 long 类型。 int 类型的最大值不能超过 sys.maxint,而且这个最大值是平台相关的。
       整数可以通过在数字的末尾附上一个L或l来定义长整型，显然，它比 int 类型表示的数字范围更大。
     Python 3里，只有一种整数类型 int,大多数情况下，它很像Python 2里的长整型。
       由于已经不存在两种类型的整数，所以就没有必要使用特殊的语法去区别他们。

     由于 long 类型在Python 3的取消,引起以下改变
          Python 2              Python 3            说明
      ① x = 1000000000000L    x = 1000000000000   # 十进制的普通整数
      ② x = 0xFFFFFFFFFFFFL   x = 0xFFFFFFFFFFFF  # 十六进制的普通整数
      ③ long(x)               int(x)              # long()函数没有了。可以使用int()函数强制转换一个变量到整型。
      ④ type(x) is long       type(x) is int      # 检查一个变量是否是整型
      ⑤ isinstance(x, long)   isinstance(x, int)  # 也可以使用 isinstance()函数来检查数据类型
   3.sys.maxint(sys.maxsize)
     由于长整型和整型被整合在一起了, sys.maxint常量不再精确。
     因为这个值对于检测特定平台的能力还是有用处的，所以它被Python 3保留，并且重命名为 sys.maxsize。
         Python 2                Python 3
     ① from sys import maxint  from sys import maxsize  # maxint变成了maxsize。
     ② a_function(sys.maxint)  a_function(sys.maxsize)  # 所有的sys.maxint都变成了sys.maxsize。

  int 是 types.IntType 的代名词
    print(id(int)) # 打印如：505210872
    import types;print(id(types.IntType)) # 打印如：505210872
    
    4.转换函数
        hex(intx)、oct(intx)、bin(intx)、str(intx)将整数intx转换成十六/八/二/十进制表示的字符串
        int(strx,base)将字符串strx根据指定的base进制转换成整数。base默认为10；int(strx,16) int(strx,8)，int(strx,2)
        float(strx)将字符串strx转换成浮点数 
        float('inf'), float('-inf'), float('nan')    # 无穷大, 无穷小, 非数
        [hex(100), oct(100), bin(100), str(100)]
        [int('0x64',16), int('0144',8), int('0b1100100',2), int('100',10)]
        将字符串转为整数除了用int()函数外，也可以通过eval()函数将字符串转为整数；
        eval('0x64')
        整数转字符串除了用str()/hex()等函数外，也可以用格式化字符串。
        '%x'%0x64   '%o'%0x64   '%d'%0x64 
    混合类型表达式中，Python先将被操作对象转换成其中最复杂的操作对象的类型。
        整数与浮点数混合操作时，将整数自动转换成浮点数
        浮点数与复数混合操作时，将浮点数自动转换成复数
    也可以通过int()，float()，以及complex()执行手动转换
    Python支持将整数当作二进制位串对待的位操作。
        bin(32^0x10101011)  # 0b10000000100000001000000110001
        bin(32^0b10101011)  # 0b10001011
   5. Python支持许多对数字处理的内置函数与内置模块：
   内置函数位于一个隐性的命名空间内，对应于builtins模块（python2.7叫做 __builtins__模块）
       math模块：如math.pi，math.e，math.sqrt....
       内置函数，如pow()，abs()，...
       random模块提供的工具可以生成0～1之间的随机浮点数、两个数字之间的任意整数、 序列中的任意一项。
       import math
       math.pi
       import random
       random.random()
       random.randint(1,10)
       random.choice([1, 2, 3, 4, 5, 6, 7, 8, 9, 10])
       hypot() 返回欧几里德范数 sqrt(x*x + y*y)。
       
  6. 高精度的数值类型
    设置全局的精度和舍入模式：decimal.getcontext().prec=5，# 将全局精度设置为小数点后5位
    可用整数、浮点数、字符串初始化Decimal对象
    float 精度不够高，有时候需要更高精度的类型 decimal
    python 支持的是:
        from decimal import Decimal
        a = Decimal('5555555555551111111.11100002225555')
        b = Decimal('-1.01') # Decimal 构造时,只能用字符串、int、long,不能用 float 类型
        print a + 55
        print a + b # Decimal 类型运算时,只能跟 Decimal、int、long 类型,不能跟 float 类型一起运算
    
   7. 分数数据类型
    Python中的分数类型是Fraction对象，来自于fractions模块。
    Fraction对象以一个分子，一个分母初始化：Fraction(1,4)； 也可以从浮点数或者浮点数的字符串初始化：Fraction('0.25')，Fraction(0.25)
    Fraction对象能保证精确性，且能自动简化结果
    从浮点数产生分数有两个方法：
        调用Fraction的构造函数：Fraction(0.25)
        用Fraction.from_float()函数：Fraction.from_float(0.25)
    从浮点产生分数时，可以通过.limit_denominator()限制分母的最大值。
    import fractions
    fractions.Fraction(1, 4)  # 以整数分子1，整数分母4
    fractions.Fraction(0.25)  # 以小数
    fractions.Fraction('0.25')# 以字符串
    fractions.Fraction(1.212) # 不限制分母大小
    fractions.Fraction(1.212).limit_denominator(100) # 限制分母的大小
    浮点数有个as_integer_ratio()方法，能生成(分子，分母)的元祖。
    0.5.as_integer_ratio()
    
    整数、浮点数、Fraction、Decimal 可以混合运算；# Fraction与Decimal不可以混合运算。
        graph LR 
        id1(整数)-->|提升|id2(浮点数); 
        id2(浮点数)-->|提升|id3(Fraction); 
        id2(浮点数)-->|提升|id4(Decimal);
    
    math.ceil(num) # 对num向上取整
    math.floor(num) # 对num向下取整
    math.pow(x,y) # 指数运算，x的y次方
    math.log(num,base=log) # 对数运算，默认基底为e。可以使用base参数来改变对数的基底
    math.sqrt(num) # 平方根运算
   内建number操作函数有: abs, divmod, cmp, coerce, float, hex, int, long, max, min, oct,pow, round
    
标识符的命名
    变量是标识符的例子。 标识符 是用来标识 某样东西 的名字。在命名标识符的时候，你要遵循这些规则：
    1.标识符的第一个字符必须是字母表中的字母(大写或小写)或者一个下划线(‘_’)。
    2.标识符名称的其他部分可以由字母(大写或小写)、下划线(‘_’)或数字(0-9)组成。
    3.标识符名称是对大小写敏感的。例如，myname和myName不是一个标识符。
    有效 标识符名称的例子有i、__my_name、name_23和a1b2_c3。
    无效 标识符名称的例子有2things、this is spaced out和my-name。

逻辑行与物理行
  物理行是在编写程序时文本的一行。逻辑行是程序的一个语句。
  Python假定每个 物理行 对应一个 逻辑行 。 他希望每行都只使用一个语句，这样使得代码更加易读。
  1. 如果你想要在一个物理行中使用多于一个逻辑行，那么你需要使用分号(;)来特别地标明这种用法。
     分号表示一个逻辑行/语句的结束。
     如: i = 5; print i; # 强烈建议你坚持在每个物理行只写一句逻辑行。 让程序见不到分号，而更容易阅读。
  2. 明确的行连接
     在多个物理行中写一个逻辑行,行结尾用反斜杠标明
     如: s = 'This is a string. \
         This continues the string.'
         # 上面这两行是一个逻辑行,打印是: This is a string. This continues the string.
         print \
         i
         # 上面这两行也是一个逻辑行, 等同于: print i
  3. 暗示的行连接
     在多个物理行中写一个逻辑行,行结尾不需要使用反斜杠标明。
     这种情况出现在逻辑行中使用了圆括号、方括号或花括号的时候。
  4. 缩进
     行首的空白是重要的。在逻辑行首的空白(空格和tab符)用来决定逻辑行的缩进层次，从而用来决定语句的分组。
     同一层次的语句必须有相同的缩进。每一组这样的语句称为一个块。
     不要混合使用tab符和空格来缩进，因为这在跨越不同的平台的时候，无法正常工作。强烈建议只使用一种风格来缩进。


语法规则
   1.缩进规则
     一个模块的界限，完全是由每行的首字符在这一行的位置来决定的(而不是花括号{})。这一点曾经引起过争议。
     不过不可否认的是，通过强制程序员们缩进，Python确实使得程序更加清晰和美观。
     在逻辑行首的空白(空格和tab)用来决定逻辑行的缩进层次，从而用来决定语句的分组。错误的缩进会引发错误。
     注意: 强制缩进的问题,最常见的情况是tab符和空格的混用会导致错误，而这是用肉眼无法分别的。
   2.变量没有类型
     使用变量时只需要给它们赋值。 不需要声明或定义数据类型。
   3.单语句块
     如果你的语句块只包含一句语句，那么你可以在条件语句或循环语句的同一行指明它。如: if 1!=2: print('Yes')
     强烈建议不要使用这种缩略方法。这会破坏Python清晰美观的代码风格,违背设计者的初衷。
     如果是在Python解释器输入,它的把提示符会改变为...以表示语句还没有结束。这时按回车键用来确认语句已经完整了。然后，Python完成整个语句的执行，并且返回原来的提示符来等待下一句输入。


变量
    1.python中的变量不需要声明，变量的赋值操作即使变量声明和定义的过程。
    2.python中一次新的赋值，将创建一个新的变量。即使变量的名称相同，变量的标识并不相同。
      用id()函数可以获取变量标识： # 变量的名称 != 变量的标识
        x = 1
        print id(x)
        x = 2
        print id(x)
        
      变量的标识指示了变量的存储位置；变量的名称是对变量标识的一次指针引用。
        2.1 在Python内部，变量实际上是指向对象内存空间的一个指针
        2.2 每个表达式生成的结果，python都创建了一个新的对象去表示这个值
        2.3 给一个变量赋新值，并不是替换原始的对象，而是让这个变量去引用完全不同的一个对象。
    3 如果变量没有赋值，则python认为该变量不存在
    4 在函数之外定义的变量都可以称为全局变量。全局变量可以被文件内部的任何函数和外部文件访问。
    5 全局变量建议在文件的开头定义。
    6 也可以把全局变量放到一个专门的文件中，然后通过 import 来引用
    
    变量的类型.查看对象的类型用type()函数，如
    >>> type(0)  
    <type 'int'>
    >>> type('a')
    <type 'str'>
    >>> type('getrefcount')
    <type 'str'>
    >>> type(list)         
    <type 'type'>
    >>> type([1,2,3])
    <type 'list'>
    >>> type(True)   
    <type 'bool'>
    None对象是一个特殊的Python对象，它总是False，一般用于占位。它有一块内存，是一个真正的对象。它不代表未定义，事实上它有定义。
    >>> type(None)
    <type 'NoneType'>
    
对象
    Python 将 "一切皆对象" 贯彻得非常彻底，不区分什么 "值类型" 和 "引用类型"。所谓变量，实质就是一个通用类型指针 (PyObject*)，它仅仅负责指路，至于目标是谁，一概不管。
    Python Object 对象的自身结构了。任何对象，就算一个最简单的整数，它的头部都会拥有 2 个特殊的附加信息，分别是："引用计数" 和 "类型 (type) 指针" 。前者指示 GC 何时回收，而后者标明了对象的身份，如此我们就可以在运行期动态执行对象成员调用。

    连同附加头，一个 "普通" 的整数起码得 12 字节：
    a = 8; import sys; print(sys.getsizeof(a)) # 打印： 12  (python3.2中，打印的是14)
    print(sys.getsizeof(None)) # 打印： 8

    Python中，任何东西都是对象类型（见第10条），类型本身也是对象类型：
    type(x)返回变量x指向对象的类型
    isinstance(x,typename)用于测试x所指对象是否是typename类型
    
    基本上在代码中进行类型检查是错误的，着破坏了代码的灵活性，限制了代码的类型。Python代码不关心特定的数据类型，只关心接口，这就是Python的多态设计
        一个操作的意义取决于被操作对象的类型。同样的操作对不同的对象来说意义可能不同，前提是该对象支持该操作
        若对象不支持某种操作，则Python会在运行时检测到错误并自动抛出一个异常

动态类型简介
    """
    变量名通过引用，指向对象。
    Python中的“类型”属于对象，而不是变量，每个对象都包含有头部信息，比如"类型标示符" "引用计数器"等
    """
    #共享引用及在原处修改：对于可变对象，要注意尽量不要共享引用！
    #共享引用和相等测试：
        L = [1], M = [1], L is M            # 返回False
        L = M = [1, 2, 3], L is M           # 返回True，共享引用
    #增强赋值和共享引用：普通+号会生成新的对象，而增强赋值+=会在原处修改
        L = M = [1, 2]
        L = L + [3, 4]                      # L = [1, 2, 3, 4], M = [1, 2]
        L += [3, 4]                         # L = [1, 2, 3, 4], M = [1, 2, 3, 4]
        
        
==和is 
    ==比较为True, 不一定is比较为True; 同样, is为True, 不一定==为True
        
布尔类型为bool，它只有两个值True和False。
    True和False是预定义的内置变量名，其在表达式中的行为与整数1和0是一样的。实际上他们就是内置的int类型的子类。
    False + 1 # 1
    True + 1  # 2
    真和假是Python中每个对象的固有属性：每个对象不是真就是假。 该属性可以用于任何需要bool`值的地方。
        一个数如果不是0，则为真；如整数 0，浮点数 0.0 都是 假
        其他对象如果非空，则为真；如空字符串 ""为假，空字典{}为假， 空列表[]为假，None对象为假
    
    作为自定义类型的bool值: Python有bool值定义, True或False. 判断某个对象的bool表示, 是先看此对象
    是否定义 __bool()__ 特殊函数, 没定义的情况下根据 __len()__ 特殊函数判断.

    isinstance(False, int)       # bool类型属于整型，所以返回True
    True == 1; True is 1         # 输出(True, False)
    
控制台输入
    使用 raw_input()函数 或者 input()函数 能够很方便的控从制台读入数据，得到的是字符串。
    Python2.x时,raw_input()和 input()的区别:
        当输入为纯数字时:input()返回的是数值类型，如:int,float; raw_input()返回的是字符串类型
        input()会计算在字符串中的数字表达式，而 raw_input()不会。如输入“57+3”: input()得到整数60,raw_input()得到字符串'57+3'
    注:Python3.0将 raw_input()函数去除了,而用 input() 取代它的功能。另外,input()获取的字符串会包括结尾的换行符。
    例:(此处是Python2.6的写法，3.x时应该把 raw_input() 改成 input())
      1.输入字符串
        nID = raw_input("Input your id plz:\n"); print('your id is %s' % (nID))
      2.输入整数
        nAge = int(raw_input("input your age plz:\n")); print('your age is %d\n' % nAge)
      3.输入浮点型
        fWeight = float(raw_input("input your weight:\n")); print('your weight is %f' % fWeight)
      4.输入16进制数据
        nHex = int(raw_input('input hex value(like 0x20):\n'),16); print('nHex = %x,nOct = %d\n' %(nHex,nHex))
      5.输入8进制数据
        nOct = int(raw_input('input oct value(like 020):\n'),8); print('nOct = %o,nDec = %d\n' % (nOct,nOct))
    注:打印字符串时，“%”作为特殊符号，两个百分号才能打印出一个百分号

    Python 2 与 Python 3 的比较
       Python 2             Python 3
    ① raw_input()          input()          # 最简单的形式，raw_input()被替换成input()。
    ② raw_input('prompt')  input('prompt')  # 可以指定一个提示符作为参数
    ③ input()              eval(input())    # 如果想要请求用户输入一个Python表达式，计算结果


print
    1.print 会遇到重定向的问题
      需要把  print 换成 sys.stderr.write(...) 试试

    2. 符号“>>”用来重定向输出,可以输出到文件
        下面这个例子将输出重定向到标准错误输出：

        import sys
        print >> sys.stderr, 'Fatal error: invalid input!'

        下面是一个将输出重定向到日志文件的例子：

        logfile = open('/tmp/mylog.txt', 'a')
        print >> logfile, 'Fatal error: invalid input!'
        logfile.close()
 
控制流:
    任何非0数字或者非空对象为True，数字0、空对象（如空列表，空字典、空元组、空set、空字符串）、None对象为False
    比较、相等测试会递归地应用在嵌套的数据结构中，他们返回True或False
    布尔and和or运算符会返回真或假的操作对象，而不是True或Flase，并且它们是短路计算
        and：从左到右依次对操作对象求值，停在第一个为假的对象上并返回它，或者当前面所有操作对象为真时返回最后一个操作对象
        or：从左到右依次对操作对象求值，停在第一个为真的对象上并返回它，或者当前面所有操作对象为假时返回最后一个操作对象
        
    if not 0 : print(True)
    if 1 : print(True)
    if not [] : print(True)
    if not {} : print(True)
    
    所有Python的复合语句，都是以冒号:结尾，下一行缩进开始进入代码块。同一个级别代码块的缩进形式相同
    测试(if|while)中的一对圆括号()是可选的
    
if 语句
    写法: if ... elif ... else ...  # if后面不用圆括号
    注:在Python中没有switch语句。你可以使用 if..elif..else 语句来完成同样的工作(在某些场合，使用字典会更加快捷。)
    在C/C++里面可以使用 else if ,但这里不行，得写成: else :\n\t if,故此增加关键字 elif

    例:
    number = 23
    # int是一个类，不过这里它只是把一个字符串转换为一个整数(假设这个字符串含有一个有效的整数文本信息)。
    guess = int(raw_input('Enter an integer : '))

    if guess == number:
        print('Congratulations, you guessed it.')
    elif guess < number:
        print('No, it is a little higher than that') # Another block
    else:
        print('No, it is a little lower than that')


python本身没有 switch 语句


while 语句
    只要条件为真, while 语句允许你重复执行一块语句。
    注:while 语句有一个可选的 else 从句。
    else 块有点不好理解用法, 不过你把 while 想象成 if 就可以了, 当不能进入 while 代码块的时候就会进入 else 代码块。
    else可选。else子句在控制权离开循环且未碰到break语句时执行。即在正常离开循环时执行（break是非正常离开循环）
    
    例:
    number = 23
    running = True

    while running:
        guess = int(raw_input('Enter an integer : '))

        if guess == number:
            print('Congratulations, you guessed it.')
            running = False # this causes the while loop to stop
        elif guess < number:
            print('No, it is a little higher than that')
        else:
            print('No, it is a little lower than that')
    # 这个 else 在什么情况下执行? 你可以把这行看成是“if not running:”,也就是把上面的 while 看成 if 就行了
    else:
        # Do anything else you want to do here
        print('The while loop is over.')


for 循环
    for..in 是另外一个循环语句，它在一序列的对象上 递归 即逐一使用队列中的每个项目。
    else 部分是可选的。如果包含 else,它总是在 for 循环结束后执行一次，除非遇到 break 语句；进不去 for 的时候也会执行 else 。
    else子句在控制权离开循环且未碰到break语句时执行。即在正常离开循环时执行（break是非正常离开循环）

    例:
    for i in range(1, 5):
        print(i)
    # 这个 else 在什么情况下执行? 你可以把这行看成是“if i not in range(1, 5):”,也就是把上面的 for 看成 if 就行了
    else:
        print('The for loop is over')

    # 打印结果: 1 至 4 以及 else 的内容
    # range(1,5)给出序列[1, 2, 3, 4]。range默认步长为1,第三个参数是步长。如，range(1,5,2)给出[1,3]。
    # 记住，range包含第一个数,但不包含第二个数。

    注:
    Python的 for 循环从根本上不同于C/C++的 for 循环。类似 foreach 循环。
    在C/C++中，如果你想要写 for (int i = 0; i < 5; i++)，那么用Python，你写成 for i in range(0,5)。

    # 范例：九九乘法表
    # 由于Python2 与Python3的 print 语法不相同，改用string来打印，保证两个版本的输出结果相同。
    str = ''
    for i in range(1,10):
        for j in range(1, i+1):
            str += ('%d * %d = %d \t' % (j, i, i*j))
        str += '\n'
    print(str)

    target_var是赋值目标，iter_obj是任何可迭代对象。每一轮迭代时将迭代获得的值赋值给target_var，然后执行statement1
    任何赋值目标在语法上均有效，即使是嵌套的结构也能自动解包
    for ((a,b),c) in [((1,2),3),((4,5),6)]:#自动解包 
        print(a,b,c)
    当然你也可以手动解包：

    for both in [((1,2),3),((4,5),6)]:#手动解包
        ((a,b),c)=both
        print(a,b,c)
        
    for扫描文件时，直接使用文件对象迭代，每次迭代时读取一行，执行速度快，占用内存少：
    for line in open('test.txt'):
        print(line)

break 语句
    break 语句是用来 终止 循环语句的，即哪怕循环条件没有称为 False 或序列还没有被完全递归，也停止执行循环语句。
    一个重要的注释是，如果你从 for 或 while 循环中 终止 ，任何对应的循环 else 块将不执行。

continue 语句
    continue 语句被用来告诉Python跳过当前循环块中的剩余语句，然后 继续 进行下一轮循环。
    break 语句 和 continue 语句 对于 while 循环 和 for 循环 都有效。

    例(2.x写法):
    while True:
        s = raw_input('Enter something : ')
        if s == 'quit':
            break
        if len(s) < 3:
            print 'Input is not of sufficient length'
            continue
        # Do other kinds of processing here...
        print 'Length of the string is', len(s)

    例(3.x写法):
    while True:
        s = input('Enter something : ')  # 3.x用input()代替raw_input(),且会获取结尾输入的换行符
        s = s[:-1] # 去掉结尾的换行符
        if s == 'quit':
            break
        if len(s) < 3:
            print('Input is not of sufficient length')
            continue
        # Do other kinds of processing here...
        print('Length of the string is', len(s))


None
    None 是Python中表示没有任何东西的特殊类型(相当于java的 null)。例如，如果一个变量的值为None，可以表示它没有值。
    注意:函数没有返回值的,等价于最后返回return None。通过运行print someFunction()，你可以明白这一点。

    例:
    def someFunction():
        # pass语句在Python中表示一个空的语句块。它后面的代码会照常运行。
        pass

    print(someFunction())


DocStrings
    DocStrings:文档字符串。它是一个重要的工具，帮助你的程序文档更加简单易懂，应该尽量使用它。甚至可以在程序运行的时候，从函数恢复文档字符串！
    在函数的第一个逻辑行的字符串是这个函数的 文档字符串 。注意，DocStrings也适用于模块和类。
    文档字符串的惯例是一个多行字符串，它的首行以大写字母开始，句号结尾。第二行是空行，从第三行开始是详细的描述。 强烈建议遵循这个惯例。

    例:
    def printMax(x, y):
        '''Prints the maximum of two numbers.

        The two values must be integers.'''

        x = int(x) # convert to integers, if possible
        y = int(y)
        if x > y:
            print(x, 'is maximum')
        else:
            print(y, 'is maximum')

    printMax(3, 5)  # 打印: 5 is maximum
    print(printMax.__doc__)   # 打印: Prints the maximum ... must be integers.

    注:
    使用__doc__(注意是两个下划线)调用printMax函数的文档字符串属性。请记住Python把 每一样东西 都作为对象，包括这个函数。
    Python中help()函数即是使用DocStings的了,它只是抓取函数的__doc__属性，然后整洁地展示给你。可以对上面的函数尝试一下: help(printMax)。记住按q退出help。
    自动化工具也可以以同样的方式从你的程序中提取文档。因此强烈建议你对你所写的任何正式函数编写文档字符串。


模块:
    如果要在其他程序中重用很多函数，那么你该使用模块。
    模块基本上就是一个包含了所有你定义的函数和变量的文件。
    为了在其他程序中重用模块，模块的文件名必须以.py为扩展名。


模块的 __name__
    每个模块都有一个名称，在模块中可以通过语句来找出模块的名称。
    这在一个场合特别有用——就如前面所提到的，当一个模块被第一次输入的时候，这个模块的主块将被运行。
    假如我们只想在程序本身被使用的时候运行主块，而在它被别的模块输入的时候不运行主块，我们该怎么做呢？这可以通过模块的__name__属性完成。
    每个Python模块都有它的__name__，如果它是'__main__'，这说明这个模块被用户单独运行，我们可以进行相应的恰当操作。

    例:
    # Filename: using_name.py
    if __name__ == '__main__':
        print('This program is being run by itself')
    else:
        print('I am being imported from another module')

    输出:
    $ python using_name.py
    This program is being run by itself

    $ python
    >>> import using_name
    I am being imported from another module


自定义模块
    每个Python程序也是一个模块。

    模块,例:
    # Filename: mymodule.py

    def sayhi():
        print('Hi, this is mymodule speaking.')

    version = '0.1'

    # End of mymodule.py

   上面是一个 模块 的例子。你已经看到，它与我们普通的Python程序相比并没有什么特别之处。
   记住这个模块应该被放置在我们输入它的程序的同一个目录中，或者在 sys.path 所列目录之一。

    用例1:
    import mymodule
    mymodule.sayhi()
    print('Version', mymodule.version)

    注:函数和成员都以点号来使用。

    用例2:  使用from..import语法的版本。
    from mymodule import sayhi, version  # 或者写: from mymodule import *

    sayhi()
    print('Version', version)


包(Packages)
    包通常是使用用“圆点模块名”的结构化模块命名空间。例如， A.B 表示名为"A" 的包中含有名为"B"的子模块。
    使用圆点模块名保存不同类库的包可以避免模块之间的命名冲突。(如同用模块来保存不同的模块架构可以避免变量之间的命名冲突)
    包目录必须要有一个 __init__.py 文件的存在；这是为了防止命名冲突而无意中在随后的模块搜索路径中覆盖了正确的模块。
    最简单的情况下， __init__.py 可以只是一个空文件，不过它也可能包含了包的初始化代码，或者设置了 __all__ 变量。


lambda 形式
    lambda 语句被用来创建新的函数对象，并且在运行时返回它们。
    注意, lambda 形式中，只能使用表达式。

    例:
    def make_repeater(n):
        return lambda s: s*n    # 注意: lambda 返回的是函数,而不是表达式的值

    # 注意, twice 接收的是函数, 而不是表达式的值, 所以 twice 是一个函数,而不是值
    twice = make_repeater(2)
    print(twice('word '))       # 因为 twice 是一个函数,这里是调用这个函数,打印结果: word word

    print(make_repeater(3)(5))  # 这里的“make_repeater(3)”可以认为是匿名函数,打印结果: 15


    # 上面例子貌似太过复杂,下面是简单点的写法
    # 记住, twice2 是一个函数
    twice2 = lambda s: s*2

    print(twice2('word '))  # 打印: word word
    print(twice2(5))        # 打印: 10

    # 上面的 twice2 相当于正常的函数这样写(lambda 后面的是参数，而结果是返回冒号后面的表达式)：
    def twice3(s):
        return s*2

    print(twice3('word '))  # 打印: word word
    print(twice3(5))        # 打印: 10


    # 可认为 lambda 是一个匿名函数
    print((lambda s: s*2)('word '))  # 打印: word word

    # 而 def 是不能申明匿名函数的
    print((def (s): return s*2)(10)) # 这写法将会报错
    print((def twice3(s): return s*2)(10)) # 这写法也同样会报错


    # lambda 可以有多个参数
    twice4 = lambda x,y: x*y
    print(twice4('word ', 3))  # 打印: word word word
    print(twice4(5, 3))        # 打印: 15


exec 和 eval
    exec 用来执行储存在字符串或文件中的Python语句。
    eval 用来计算存储在字符串中的有效Python表达式。
    exec 跟 eval 是相似的，但是 exec 更加强大并更具有技巧性。
    eval 只能执行单独一条表达式；但是 exec 能够执行多条语句，导入(import)，函数声明
    实际上 exec 能执行整个Python程序的字符串。

    Python 2 与 Python 3 的比较
            Python 2                                              Python 3
        ① exec codeString                                       exec(codeString)
        ② exec codeString in global_namespace                   exec(codeString, global_namespace)
        ③ exec codeString in global_namespace, local_namespace  exec(codeString, global_namespace, local_namespace)
    说明:
        ① 就像 print 语句在Python 3里变成了一个函数一样, exec 语句在Python 3里也变成一个函数。
        ② exec 可以指定名字空间，代码将在这个由全局对象组成的私有空间里执行。
        ③ exec 还可以指定一个本地名字空间(比如一个函数里声明的变量)。

    例：
    exec('print("Hello World")')  # 执行打印语句
    print(eval('2*3'))  # 打印：6


execfile 语句
    Python 2里的 execfile 语句也可以像执行Python代码那样使用字符串。不同的是 exec 使用字符串，而 execfile 则使用文件。
    在Python 3里,execfile 语句已经被去掉了。如果你真的想要执行一个文件里的Python代码(但是你不想导入它)，你可以通过打开这个文件，读取它的内容，然后调用 compile()全局函数强制Python解释器编译代码，然后调用 exec() 函数。

    Python 2 写的： execfile('a_filename')
    Python 3 写的： exec(compile(open('a_filename', 'rb').read(), 'a_filename', 'exec'))


assert 语句
    assert 语句用来声明某个条件是真的。
    当 assert 语句失败的时候，会引发一个 AssertionError 错误。
    比较常用于检验错误。

    例:
    assert 2 >= 1  # 正常运行
    assert 0 >= 1  # 出现错误


with 关键字
    从Python 2.5开始有，需要 from __future__ import with_statement。自python 2.6开始，成为默认关键字。
    with 是一个控制流语句, 跟 if/for/while/try 之类的是一类的, with 可以用来简化 try finally 代码，看起来可以比 try finally 更清晰。
    with obj 语句在控制流程进入和离开其后的相关代码中，允许对象obj管理所发生的事情。
    执行 with obj 语句时，它执行 obj.__enter__() 方法来指示正在进入一个新的上下文。当控制流离开该上下文的时候，它就会执行 obj.__exit__(type, value, traceback)。

    "上下文管理协议"context management protocol: 实现方法是为一个类定义 __enter__ 和 __exit__ 两个函数。
    with expresion as variable的执行过程是，首先执行 __enter__ 函数，它的返回值会赋给 as 后面的 variable, 想让它返回什么就返回什么，如果不写 as variable，返回值会被忽略。
    然后，开始执行 with-block 中的语句，不论成功失败(比如发生异常、错误，设置sys.exit())，在with-block执行完成后，会执行__exit__函数。
    这样的过程其实等价于：
    try:
        执行 __enter__()
        执行 with_block.
    finally:
        执行 __exit__()

    只不过，现在把一部分代码封装成了__enter__函数，清理代码封装成__exit__函数。

    例：
        import sys

        class test:
            def __enter__(self):
                print("enter...")
                return 1

            def __exit__(self,*args):
                print("exit...")
                return True

        with test() as t:
            print("t is not the result of test(), it is __enter__ returned")
            print("t is 1, yes, it is {0}".format(t))
            raise NameError("Hi there")
            sys.exit()
            print("Never here")

    注意:
        1) t不是test()的值，test()返回的是"context manager object"，是给with用的。t获得的是__enter__函数的返回值，这是with拿到test()的对象执行之后的结果。t的值是1.
        2) __exit__函数的返回值用来指示with-block部分发生的异常是否要 re-raise ，如果返回 False,则会抛出 with-block 的异常，如果返回 True,则就像什么都没发生。

    在Python2.5中, file objec t拥有 __enter__ 和 __exit__ 方法，__enter__ 返回 object 自己，而 __exit__ 则关闭这个文件：
    要打开一个文件，处理它的内容，并且保证关闭它，你就可以简简单单地这样做：

        with open("x.txt") as f:
            data = f.read()
            do something with data

    补充：
        数据库的连接好像也可以和with一起使用，我在一本书上看到以下内容：
        conn = sqlite.connect("somedb")
        with conn:
            conn.execute("insert into sometable values (?,?)",("foo","bar"))
        在这个例子中，commit()是在所有with数据块中的语句执行完毕并且没有错误之后自动执行的，如果出现任何的异常，将执行rollback()
        操作，再次提示异常





