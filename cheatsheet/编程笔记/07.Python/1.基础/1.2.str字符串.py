
字符串
   1.使用单引号“'”引起来: 'Quote me on this'

   2.使用双引号“"”引起来: "What's your name?"

   3.使用三引号('''或"""): 可以指示一个多行的字符串。你可以在三引号中自由的使用单引号和双引号。 /'''
     如:
     """This is a multi-line string. This is the first line.
     "What's your name?," I asked.
     He said "Bond, James Bond."
     """

   4.转义符“\”
     \\  指示反斜杠本身
     \'  指示单引号
     \"  指示双引号
     注意: 行末的单独一个反斜杠表示字符串在下一行继续，而不是开始一个新的行。
   4.1 字符串包含引号和空字符串
    如果希望字符串中包含引号，则有两种办法：
        最外围的引号和字符串中的引号使用不同的格式。如"who's name is Tex?"
        采用转义字符。如who\'s name is Tex?'
    空字符串是一对引号之间不包含内容：""
    
   5.自然字符串
     自然字符串通过给字符串加上前缀r或R来指定，取消转义符的功能。例如: r"Newlines are indicated by \n"。
     三引号的字符串也可以同样用法，如: R'''Newlines are indicated by \n'''

   6.unicode 字符串
     Python允许你处理 unicode 文本(超过拉丁文字范围的)——只需要在字符串前加上前缀u或U。
     例如，u"This is a Unicode string.哈哈.."。(Python3.x之后不需要这样了,可以直接写中文;而这样写会报错)
     Python 3.0开始对unicode全面支持，所有的文本(str)都是Unicode的；并引入了一个叫做bytes的新类型来处理字节序列。而编码过的Unicode会以二进制的数据来表示。
     因为在2.x的世界里，大量的bug都是因为已编码的文本和未编码的文本混杂在一起而产生的。

   7.按字面意义级连字符串
     如果你把两个字符串按字面意义相邻放着，他们会被Python自动级连。
     例如，"What's" ' your name?'会被自动转为"What's your name?"。
     即是说，两个字符串放在一起，会有字符拼接的效果。加号“+”也有字符拼接的效果。

   8.字符串拼接
     可以使用“str1.__add__(str2)”或者“str1 + str2”或者直接两个字符串放一起,来拼接字符串
     但字符串与其它类型拼接时，得先把其它类型转成字符串类型，否则会出错。如“str1 + 2”就会出错，需要“str1 + str(2)”

   9.字符串的乘法运算
    “*”:可以把字符串重复拼接若干次,如: 2 * 3得到6; 'la' * 3得到'lalala'。但乘以0或者负数时,结果将会是空字符串""。

   10.字符串序列(索引和切片)
     字符串可以使用下标来获取字符串中某个项目，以及截取字符串。
     #字符串的序列，即“索引”和“切片”，参考“1.3.列表、元组和字典.py.txt”的“序列”
     用法如: name = 'swaroop'; name[1]; name[1:3]; name[1:-1]

   11. S='abcdefg'
   S[0] # a
   S[len(S)-1] # g
   S[-1] # g
   S[-len(S)] # a
   12.str(anything)函数和 unicode(anything)函数
     Python 2有两个全局函数可以把对象强制转换成字符串:unicode()把对象转换成Unicode字符串，还有 str()把对象转换为非Unicode字符串。
     Python 3只有一种字符串类型，Unicode字符串，所以 str()函数即可完成所有的功能。(unicode()函数在Python 3里不再存在了。)

   13. 可以在单个字符与它对应的 ASCII 码值之间转换 ： # python3中可用，python2中不可用
        ord(char)：返回单个字符的 ASCII 值
        chr(ascii_int)： 返回 ASCII 值对应的字符
        
        Python大约支持上百中不同的编码。可以导入encodings模块，并运行help(encodings)显示很多编码名称。有一些编码是Python中实现的，一些是C中实现的。
        sys.getdefaultencoding()函数返回平台默认的编码方式。
        sys.getfilesystemencoding()返回系统文件的默认编码方式。
        
   14. Python3中有三种字符串相关类型：
    str类型表示Unicode文本（8位和更宽的位数），为不可变的字符序列，称为字符串
    bytes表示二进制数据，称为字节串。bytes对象其实是小整数的一个序列，每个整数的范围在0～255之间。
        索引一个bytes实例返回一个整数
        分片一个bytes实例返回一个新的bytes实例
        list(bytes_obj)返回一个整数列表而不是字符列表
        bytes类型几乎支持所有的str操作，但是不支持字符串格式化操作（没有字节串格式化操作）
    bytearray是一种可变的bytes类型，称为可变字节串。bytearray是bytes的一个变体， 它是可变的且支持原地修改。它支持str与bytes的常见操作，以及与列表相同的一些原地修改操作。
   
    Python3中，当一个文件以文本模式打开时，读取其数据会自动将其内容解码，并返回一个字符串；当一个文件以文本模式写打开时，写入一个字符串会在将该字符串写入文件之前自动编码它。
        编码和解码的类型是系统的平台默认编码类型，或者你手动设定的编码类型
        根据编码类型，Python自动处理文件起始处的字节标记序列（通常用于标记文件编码类型）
        Python自动对行尾换行符转换。在windows下，换行符\n在写入文件时转换为windows下的换行符\r\n。在读取文件时windows下的换行符\r\n转换为标准换行符\n
   
   在Python3中，'xxx'、 "xxx" 、'''xxx'''均创建一个字符串常量，而添加一个b或者B中创建一个bytes常量b'xxx'、 B"xxx" 、b'''xxx'''
        尽管bytes打印出来是字符串（若无对应的字符则输出内存表示），但它本质上是一个小整数序列
   
   另外:
     没有专门的char数据类型，确实没有需要有这个类型。
     单引号和双引号字符串是完全相同的——它们没有在任何方面有不同。
     正则表达式: 一定要用自然字符串处理正则表达式。否则会需要使用很多的反斜杠。
     使用 help(str) 可查看字符串对象定义的所有方法及属性。
     由于百分号有特殊作用，所以字符串里面要用百分号的话需要使用“%%”，如: "select * from my_table where name like '%%测试%%'"


字符串格式化控制: (未参考帮助文档，只是个人猜测)
   转义符 (Escape Sequence):
   \0       为\0x00（不是字符串结尾）
   \ddd     1到3位8进制数指定Unicode字符输出(如: “\127”显示“W”)
   \uxxxx   1到4位16进制数指定Unicode字符输出(Python3.x开始支持此写法,如: \u54C8 显示“哈”字)
   \xhh     16进制数指定Unicode字符输出(如: “\xe5\x93\x88”显示“哈”)
   \\       \
   \        \ (单独的一个斜杠也显示斜杠,即不后接有转移作用的字符时，作为斜杠使用)
   \'       '
   \"       "
   \a       字符: 0x07    响铃(ASCII控制字符)
   \b       字符: 0x08    退格(光标向左走一格)(ASCII控制字符)
   \f       字符: 0x0c    Formfeed(FF)(走纸转页,换页)(ASCII控制字符)
   \n       字符: 0x0a    换行(ASCII控制字符)
   \N{name} Unicode字符   只能针对Unicode
   \r       字符: 0x0d    回车
   \t       字符: 0x09    跳格(tab符号),水平制表符
   \v       字符: 0x0b    垂直制表符

   %%       %
   %d       输出10进制整数，只能是数字类型，输出字符串类型会出错；浮点类型的数字将被取整(直接删除小数部分)。
   %f,%F    以10进制输出浮点数，只能是数字类型，输出字符串类型会出错。
   %e,%E    以科学计数法输出10进制的浮点数，大小写的“e”反应在显示时科学计数法的“e/E”上，只能是数字类型。
   %a       Python3.0开始支持此写法，原样输出结果，字符串类型会加上单引号引起来。
   %o       (字母o)以8进制整数方式输出，只能是数字类型；浮点类型的数字将被取整(直接删除小数部分)。
   %x,%X    将数字以16进制方式输出，只能是数字类型；浮点类型的数字将被取整(直接删除小数部分)。
   %c       以字符方式输出，提供的类型必须是 char 或 int 。
   %s       直接输出字符串(可输出任何类型)
   %r       将字符串格式化输出(可输出任何类型,会自动用 repr 转换,输出；类似于 %s)
   注: 布尔类型的 True 或 False,用数字类型输出是 1或0,字符串输出是 True 或 False。

字符串 格式化
    格式化的符号用法参考上面的“字符串格式化控制表”

    1. %s 形式(简单占位符)
       使用“%控制符”可以格式化字符串,非常方便。
       如: str1 = "Swaroop's age is %d, weight is %f" % (5, 65.5)

    2. %(name)s 形式(名称传参) 
       “%(name)控制符”可按名称传参数(不写名称是按位置传参数)
       如: str = "%(row)d Rows is %(value)s" % { 'value': 'kkkk', 'row': 22 }
       
       %[(key_name)][flags][width][.precision]type
            key_name：用于从右边字典中取对应键的值（此时右边的是字典对象，而不是元组） 如："%(n)d %(x)s" %{"n":3,"x":"apples"}
            flags：如果为-则左对齐；如果为+则为正负号；如果为0：则补零
            width： 指定位宽（包括小数点在内），至少为width字符宽度
            precision：指定小数点后几位
        width和precision可以为*，表示它们从输入的下一项中取值 （即从元组中取得）
            type为类型，如d,r,f,e等

    3. %n.mf 形式(制定输出长度的数值,补空格)
       如： '%6.2f' % 1.235 # 结果为: '  1.24'
       在这种形式中，在f的前面出现了一个类似小数的6.2它表示的意思是，总共输出的长度为6个字符，其中小数2位。
       常用用法如(只保留多少位小数,如两位小数): u'%.2f元' % 567.123

    4. %0n.mf 形式(制定输出长度的数值,并指定占位符)
       如：'%06.2f' % 1.235 # 结果为: '001.24'
       在6的前面多了一个0,表示如果输出的位数不足6位就用0补足6位。
       这一行的输出为'001.24'，可以看到小数点也占用一位。
       类似于这里0这样的标记还有-、+。其中，-表示左对齐，+表示在正数前面也标上+号，默认是不加的。
       如：'%-6.2f' % 1.235 # 结果为: '1.24  '
       如：'%+6.2f' % 1.235 # 结果为: ' +1.24'

    5. %ns 形式(制定输出长度的字符串,补空格)
       %ns：如果字符串变量s不足n位的话,会先输出若干个空格后再输出str1
       如：'%8s:%6.1f' %('newsim', 9.51) # 结果为：'  newsim:   9.5'
       如：'%(name)8s:%(score)06.1f' %{'score':9.51, 'name':'newsim'} # 结果为：'  newsim:0009.5'

    6. %-ns 形式(制定输出长度的字符串,后面补空格)
       %-ns：与上述相反，先输出变量s，不足的然后用空格在后面补齐
       如：'%-8s:%-6.1f' %('newsim', 9.51) # 结果为：'newsim  :9.5   '
       如：'%(name)-8s:%(score)06.1f' %{'score':9.51, 'name':'newsim'} # 结果为：'newsim  :0009.5'

    7. %*.*f 形式
       有时候在%6.2f这种形式中，6和2也不能事先指定，会在程序运行过程中再产生，那怎么输入呢，当然不能用%%d.%df或%d.%d%f。
       可以用%*.*f的形式，当然在后面的“要输出的值组中”包含那两个*的值。
       比如：'%*.*f' % (6, 2, 2.345) 就相当于'%6.2f' % 2.345。
       不过如果记不住，或不想那么耐烦，完全可以全部用%s代替，或者用多个"+"来构造类似的输出字符串。
       如：'%*.*f' % (6, 2, 2.345) # 结果为：'  2.35'
       如：'%*s' % (6, 2.345) # 结果为： ' 2.345'
       如：'%*s,%*.*f' % (8, 'newsim', 6, 2, 2.345) # 结果为：'  newsim,  2.35'
       如：'%*s,%0*.*f' % (8, 'newsim', 6, 2, 2.345) # 结果为：'  newsim,002.35'
       如：'%-*s,%++*.*f' % (8, 'newsim', 6, 2, 2.345) # 结果为：'newsim  , +2.35'

    8. {number} 形式(按位占位符)
       {name} 形式(按名称传参)
       string.format()函数也可以格式化字符串，且有“按位”、“按名称”两种形式，还可以两种形式混用

       如: 'subtracting {0}, adding {1}'.format(1, 'haha') # 参数将对应到“{number}”的位置上,结果为：subtracting 1, adding haha
       如: "foo{1}{0}-{1}".format("bar", 6) # 结果为：foo6bar-6
       如：'Hi,{name},{message}'.format(name = 'Tom',message = 'How old are you?') # 参数不止数字，也可以是名称，结果为：Hi,Tom,How old are you?

       如："-{arg!r}-".format(arg='test') # 参数也以指定格式，相当于“"-%(arg)r-"%{'arg':'test'}”,结果为：-'test'-
       如："{{,}},-{0}-".format('test') # 两个“{”或者“}”表示大括号，结果为：{,},-test-
       如：'{0},I\'m {1},{message}'.format('Hello','Hongten',message = 'How are you!') # 混合使用'{0}','{name}'也可以,结果为：Hello,I'm Hongten,How are you!

    9. format()方法支持位置参数、关键字参数、以及二者的混合。
        位置参数： "{0},{1},{2}".format('abc','def','ghi')
        关键字参数："{k1},{k2},{k3}".format(k1='abc',k2='def',k3='ghi')
        混合使用："{0},{1},{k}".format('abc','def',k='ghi')
        
    10. 格式化字符串中可以指定对象的属性、字典键、序列的索引：
        指定字典的键："{0[a]}".format({'a':'value'})， 注意这里的键a并没有引号包围
        指定对象的属性："{0.platform}".format(sys)，也可以用关键字参数： "{obj.platform}".format(obj=sys)
        指定序列的索引："{0[2]}".format("abcd") ，这里只能进行正索引值，且不能分片
    11. 通用目标结构为： {fieldname!conversionflag:formatspec}
        fieldname为位置数字 0,1,2,... 或者为关键字，它后面可选地跟随
            .name：则指定对象的属性
            [index]：指定了索引
            [key]：指定了字典的键
        conversionflag为转换标记，可以为：
            r：在该值上调用一次repr()函数
            s：在该值上调用一次str()函数
            a：在该值上调用一次ascii()函数
        formatspec为格式，其结构为： [[fill] align] [sign] [#] [0] [width] [.precision] [type]
            fill一般与align为=时配合
            align为对齐：
                <：左对齐
                >：右对齐
                =：必须指定fill（单个字符），此时用这个字符填充
                ^：居中对齐
            sign：为正负号标记
            #：作用未知
            0：补0
            width：位宽
            .precision：精度
            type：为类型，如d,r,f,e等， 但与格式化字符串表达式相比，多了b（二进制格式输出）
        某些值可以从.format()的参数中获取，如"{0:+0{1}d}".format(128,8)， 其指定精度信息从format()的参数中取(参数8) # '+0000128'
         
        # 格式控制，数值
        import math
        print('PI is {0}.'.format(math.pi)) # PI is 3.14159265359.
        print('PI is {0!r}.'.format(math.pi)) # PI is 3.1415926535897931.
        print('PI is {0:.3f}.'.format(math.pi)) # PI is 3.142.
        print("PI is '{0:6.2f}'.".format(math.pi)) # PI is '  3.14'.
        print("PI is '{0:+6.2f}'.".format(math.pi)) # PI is ' +3.14'.
        print("PI is '{0:-6.2f}'.".format(math.pi)) # PI is '  3.14'.
        import datetime
        print("{0:now is: %Y-%m-%d %H:%M:%S}".format(datetime.datetime(2005, 2, 16, 23, 33,56))) # now is: 2005-02-16 23:33:56
        print("now is {0:%Y-%m-%d %H:%M:%S}".format(datetime.datetime(2005, 2, 16, 23, 33,56))) # now is 2005-02-16 23:33:56

       # 字典参数的输出
        table = {'Sjoerd': 4127, 'Jack': 4098, 'Dcab': 7678}
        print('Jack:{0[Jack]}; Sjoerd:{0[Sjoerd]:10d}; Dcab:{0[Dcab]!r}'.format(table)) # Jack:4098; Sjoerd:      4127; Dcab:7678
        for name, phone in table.items():
            print('"{0:10}" ==> "{1:10d}"'.format(name, phone))
            # "Dcab      " ==> "      7678"
            # "Jack      " ==> "      4098"
            # "Sjoerd    " ==> "      4127"

字符串转换成数字
    float(str)     转换成浮点数,如, float("1e-1") 结果: 0.1
    int(str)       转换成整数,如, int("12") 结果: 12
    int(str,base)  转换成base进制的整数,如, int("11",2) 转换成2进制的整数,结果: 3
    long(str)      转换成长整数,Python3取消此语法,如, long("12L") 结果: 12L
    long(str,base) 转换成base进制的长整数,Python3取消此语法,如, long("11L",2) 结果: 3L


字符串用例
    name = 'Swaroop' # This is a string object

    # 检查字符串的开头部分
    if name.startswith('Swa'):  # 类似函数如 endswith()
        print('Yes, the string starts with "Swa"')

    # 检查是否包含有此内容
    if 'a' in name:
        print('Yes, it contains the string "a"')

    # 找出给定字符串的位置,找不到则返回-1
    if name.find('war') != -1:
        print('Yes, it contains the string "war"', 's')

    # join()函数把列表拼接起来
    delimiter = '; '
    mylist = ['Brazil', 'Russia', 'India', 'China']
    print(delimiter.join(mylist)) # 打印: Brazil; Russia; India; China

    # 大小写转换
    print("THIS IS TEST".lower())    # 转换成小写,打印: this is test
    print("this is test".upper())    # 转换成大写,打印: THIS IS TEST
    print("This Is Test".swapcase()) # 大小写互换,打印: tHIS iS tEST

    print("  This Is Test  ".strip()) # 去掉前后空格,打印: This Is Test

    # 格式化时 %r 与 %s 的区别
    s = '''
     哈哈, /,ss
    '''
    print('%r' % s) # 打印:'\n \xe5\x93\x88\xe5\x93\x88, /,ss\n'
    print('%s' % s) # 原样打印,包括换行


常用 string 函数
    下面所有范例，使用 s = 'python String function'

  1.字符串长度获取: len(str)
    例: print '%s length=%d' % (s,len(s)) # 打印: python String function length=22

  2.字母处理
    全部大写: str.upper()
    全部小写: str.lower()
    大小写互换: str.swapcase()
    首字母大写，其余小写: str.capitalize()
    首字母大写(每个词都这样): str.title()

    print '%s lower=%s' % (s,s.lower()) # 打印: python String function lower=python string function
    print '%s upper=%s' % (s,s.upper()) # 打印: python String function upper=PYTHON STRING FUNCTION
    print '%s swapcase=%s' % (s,s.swapcase()) # 打印: python String function swapcase=PYTHON sTRING FUNCTION
    print '%s capitalize=%s' % (s,s.capitalize()) # 打印: python String function capitalize=Python string function
    print '%s title=%s' % (s,s.title()) # 打印: python String function title=Python String Function
    import string; print string.capitalize(s) # 打印: Python string function


  3.格式化相关
    获取固定长度，右对齐，左边不够用空格补齐: str.ljust(width)
    获取固定长度，左对齐，右边不够用空格补齐: str.ljust(width)
    获取固定长度，中间对齐，两边不够用空格补齐: str.ljust(width)
    获取固定长度，右对齐，左边不足用0补齐

    print '%s ljust="%s"' % (s,s.ljust(40)) # 打印: python String function ljust="python String function                  "
    print '%s rjust="%s"' % (s,s.rjust(40)) # 打印: python String function rjust="                  python String function"
    print '%s center="%s"' % (s,s.center(40)) # 打印: python String function center="         python String function         "
    print '%s zfill="%s"' % (s,s.zfill(40)) # 打印: python String function zfill="000000000000000000python String function"
    import string; print string.zfill(s, 40) # 打印: 000000000000000000python String function


  4.字符串搜索相关
    搜索指定字符串，没有返回-1: str.find('t')
    指定起始位置搜索: str.find('t',start)
    指定起始及结束位置搜索: str.find('t',start,end)
    从右边开始查找: str.rfind('t')
    搜索到多少个指定字符串: str.count('t')
    上面所有方法都可用 index 代替，不同的是使用 index 查找不到会抛异常，而 find 返回-1

    print '%s find nono=%d' % (s,s.find('nono')) # 打印: python String function find nono=-1
    print '%s find t=%d' % (s,s.find('t')) # 打印: python String function find t=2
    print '%s find t from %d=%d' % (s,3,s.find('t',3)) # 打印: python String function find t from 3=8
    print '%s find t from %d to %d=%d' % (s,1,2,s.find('t',1,2)) # 打印: python String function find t from 1 to 2=-1
    #print '%s index nono ' % (s,s.index('nono',1,2))
    print '%s rfind t=%d' % (s,s.rfind('t')) # 打印: python String function rfind t=18
    print '%s count t=%d' % (s,s.count('t')) # 打印: python String function count t=3
    print s.index('on') # 打印: 4
    import string; print string.find(s, 't') # 打印: 2


  5.字符串替换相关
    替换old为new: str.replace('old','new')
    替换指定次数的old为new: str.replace('old','new',maxReplaceTimes)
    另一种写法: import string; string.replace(str,"old","new")

    print '%s replace t to *=%s' % (s,s.replace('t', '*')) # 打印: python String function replace t to *=py*hon S*ring func*ion
    print '%s replace t to *=%s' % (s,s.replace('t', '*',1)) # 打印: python String function replace t to * once=py*hon String function
    import string; print '%s replace t to *=%s' % (s, string.replace(s,"t","*")) # 打印: python String function replace t to *=py*hon S*ring func*ion


  6.字符串去空格及去指定字符
    去两边空格: str.strip()
    去左空格: str.lstrip()
    去右空格: str.rstrip()
    去两边字符串: str.strip('d')，相应的也有 lstrip, rstrip

    s=' python String function '
    print '%s strip="%s"' % (s,s.strip()) # 打印: python String function  strip="python String function"
    print '%s strip="%s"' % (s,s.strip().strip('n')) # 打印: python String function  strip="python String functio"
    print '%s lstrip="%s"' % (s,s.lstrip()) # 打印: python String function  lstrip="python String function "
    print '%s lstrip="%s"' % (s,s.strip().lstrip('py')) # 打印: python String function  lstrip="thon String function"
    import string; print '%s strip="%s"' % (s, string.strip(s)) # 打印: python String function  strip="python String function"


  7.按指定字符分割字符串为数组:
    str.split(' ')
    split(string,sep=None,maxsplit=-1)   默认按空格分隔(sep=' ')

    s='a b-c de-f'
    print '"%s" split=%s' % (s,s.split()) # 打印: "a b-c de-f" split=['a', 'b-c', 'de-f']
    print '"%s" strip=%s' % (s,s.split('-')) # 打印: "a b-c de-f" strip=['a b', 'c de', 'f']
    import string; ip="192.168.3.3"; print(string.split(ip,'.')) # 打印:  ['192', '168', '3', '3']
    print("192.168.3.3".split('.',1)) # 部分分隔,打印:  ['192', '168.3.3']


  8.字符串判断相关
    是否以start开头: str.startswith('start')
    是否以end结尾: str.endswith('end')
    是否全为字母或数字: str.isalnum()
    是否全字母: str.isalpha()
    是否全数字: str.isdigit()
    是否全小写: str.islower()
    是否全大写: str.isupper()

    s='python String function'
    print '"%s" startwith t="%s"' % (s,s.startswith('t')) # 打印:"python String function" startwith t="False"
    print '"%s" startwith pyt="%s"' % (s,s.startswith('pyt')) # 打印:"python String function" startwith pyt="True"
    print '"%s" endwith d="%s"' % (s,s.endswith('d')) # 打印:"python String function" endwith d="False"
    print '"%s" endwith n="%s"' % (s,s.endswith('n')) # 打印:"python String function" endwith n="True"
    print '"%s" isalnum="%s"' % (s,s.isalnum()) # 打印:"python String function" isalnum="False"
    s='pythonStringfunction'
    print '"%s" isalnum="%s"' % (s,s.isalnum()) # 打印:"pythonStringfunction" isalnum="True"
    print '"%s" isalpha="%s"' % (s,s.isalpha()) # 打印:"pythonStringfunction" isalpha="True"
    print '"%s" isupper="%s"' % (s,s.isupper()) # 打印:"pythonStringfunction" isupper="False"
    print '"%s" islower="%s"' % (s,s.islower()) # 打印:"pythonStringfunction" islower="False"
    print '"%s" isdigit="%s"' % (s,s.isdigit()) # 打印:"pythonStringfunction" isdigit="False"
    s='3423'
    print '"%s" isdigit="%s"' % (s,s.isdigit()) # 打印:"3423" isdigit="True"



str, unicode 对象的 encode 和 decode 方法
    python2 中的 str 对象其实就是"8-bit string" ，字节字符串，本质上类似java中的 byte[]。
    而 python2 中的 unicode 对象应该才是等同于java中的 String 对象，或本质上是java的 char[]。

    str.decode 方法和 unicode.encode 方法是最常用的，
    简单说来就是，python内部表示字符串用 unicode(其实python内部的表示和真实的 unicode 是有点差别的，对我们几乎透明，可不考虑)，和人交互的时候用 str 对象。
    s.decode --------> 将 s 解码成 unicode, 参数指定的是 s 本来的编码方式。这个和 unicode(s,encodename) 是一样的。
    u.encode --------> 将 unicode 编码成 str 对象，参数指定使用的编码方式。


乱码/编码 问题

1、汉字编码 # http://www.cnblogs.com/rollenholt/archive/2011/08/01/2123889.html
    # coding=gbk
    s = "中文"
    s1 = u"中文"
    s2 = unicode(s, "gbk") #省略参数将用python默认的ASCII来解码
    s3 = s.decode("gbk") #把str转换成unicode是decode，unicode函数作用与之相同
    print len(s1)
    print len(s2)
    print len(s3)
    结果：
    2
    2
    2
    
1、文件编码 # http://www.cnblogs.com/rollenholt/archive/2011/08/01/2123889.html
建立一个文件test.txt，文件格式用ANSI，内容为:
    abc中文
    用python来读取
    # coding=gbk
    print open("Test.txt").read()
    结果：abc中文
    把文件格式改成UTF-8：
    结果：abc涓枃
    显然，这里需要解码：
    # coding=gbk
    import codecs
    print open("Test.txt").read().decode("utf-8")
    结果：abc中文
上面的test.txt我是用Editplus来编辑的，但当我用Windows自带的记事本编辑并存成UTF-8格式时，
运行时报错：
    # coding=gbk
    import codecs
    data = open("Test.txt").read()
    if data[:3] == codecs.BOM_UTF8:
    data = data[3:]
    print data.decode("utf-8")
    结果：abc中文


    1、写的代码模块需要指定编码
       如果代码没有指定 coding, python 就默认所有的字符为 ASCII 码,
       ASCII 码只支持256个字符,ASCII码不支持中文,所以就报错。
       所以要在代码前写上“#coding:utf-8” 或 “#coding:gbk” 或 “#-*- coding:cp936 -*-”
       但通用写上“#coding:utf-8”

    2、代码前也可以写#coding:gbk
       但要保证你的代码文件的保存格式为gbk.这个在windos下会出现这样的问题。

    3、python2 内部所有编码统一为 unicode 即可解决乱码问题
       unicode 可以处理世界上所有语言的字符。
       utf-8 为 unicode 的一种实现形式，所以需要在代码前写上 #coding:utf-8

    4、编码转换
       牢记 python2 内部编码为 unicode.
       其它的编码 decode() 为 unicode, 再编码 encode() 为你指定的编码,就不会出现乱码。
       如: s = s.decode('gbk').encode('utf-8') # utf-8 也可以写成 utf8

       不知道原本是什么编码，可以这样写：
       import sys; s = s.decode(sys.stdin.encoding).encode('utf8')
       推荐的写法: s = unicode(s).encode('utf8')

    5、网页采集时
       代码指定#coding:utf-8
       如果网页的编码为gbk
       需要这样处理：
       html = html.decode('gbk').encode('utf-8')

    6、字典等key或值的汉字问题
       #coding:utf-8
       dict1 ={1:'python周末培训班',2:'咨询'}

       print dict1
       # 这样输出的没有显示汉字，是显示汉字的其它编码

       dict2 ={1:'python视频培训班',2:'咨询'}
       for key in dict2:
           print dict2[key]

    7、unicode 的汉字编码写到文本文件中
       需要根据文本文件的编码进行转换
       可以 encode('utf-8') 或 encode('gbk')

    8、获取 unicode 编码
        print repr(u'中国') # 打印：u'\u4e2d\u56fd'

    总结：凡是报错信息中出现的错误包含“ASCII”，就是没有指定汉字编码的问题。
