Unicode VS UTF-8
    Unicode符号范围(十六进制)       UTF-8编码方式(二进制)
    0000 0000 0000 007F             0xxxxxxx
    0000 0080 0000 07FF             110xxxxx 10xxxxxxx
    0000 0800 0000 FFFF             1110xxxx 10xxxxxxx 10xxxxxxx
    0001 0800 0010 FFFF             11110xxx 10xxxxxxx 10xxxxxxx 10xxxxxxx

        中文        好
    unicode         0101   100101   111101
    编码规则     1110xxxx 10xxxxxx 10xxxxxx
                --------------------------
    utf-8       11100101 10100101 10111101
                --------------------------
    16进制utf-8     e   5    a   5    b   d

    "好"对应的Unicode是597D，对应的区间是0000 0800–0000 FFFF，因此它用UTF-8表示时需要用3个字节来存储，
    597D用二进制表示是： 0101100101111101，填充到1110xxxx 10xxxxxx 10xxxxxx得到11100101 10100101 10111101，
    转换成16进制：e5a5bd，因此"好"的Unicode"597D"对应的UTF-8编码是"E5A5BD"

Python encoding
    >>> import sys
    >>> sys.getdefaultencoding()
    'ascii'
    所以在Python源代码文件中如果不显示地指定编码的话，将出现语法错误
    #test.py
    print "你好"

    # coding=utf-8
    或者
    #!/usr/bin/python
    # -*- coding: utf-8 -*-


    在python中和字符串相关的数据类型,分别是str、unicode两种，他们都是basestring的子类，可见str与unicode是
    两种不同类型的字符串对象。
        basestring
        /   \
       /     \
    str    unicode
    对于同一个汉字“好”，用str表示时，它对应的就是utf-8编码的’xe5xa5xbd’，而用unicode表示时，他对应的符号就是
    u’u597d’，与u"好"是等同的。需要补充一点的是，str类型的字符其具体的编码格式是UTF-8还是GBK，还是其他格式，
    根据操作系统相关。比如在Windows系统中，cmd命令行中显示的：

    # windows终端
    >>> a = '好'
    >>> type(a)
    <type 'str'>
    >>> a
    '\xba\xc3'
    
    而在Linux系统的命令行中显示的是：
    # linux终端
    >>> a='好'
    >>> type(a)
    <type 'str'>
    >>> a
    '\xe5\xa5\xbd'

    >>> b=u'好'
    >>> type(b)
    <type 'unicode'>
    >>> b
    u'\u597d'

    不论是Python3x、Java还是其他编程语言，Unicode编码都成为语言的默认编码格式，而数据最后保存到介质中的时候，
    不同的介质可有用不同的方式，有些人喜欢用UTF-8，有些人喜欢用GBK，这都无所谓，只要平台统一的编码规范，
    具体怎么实现并不关心。

str与unicode的转换
    那么在Python中str和unicode之间是如何转换的呢？这两种类型的字符串类型之间的转换就是靠这两个方法decode和encode。
    #从str类型转换到unicode
    s.decode(encoding)   =====>  <type 'str'> to <type 'unicode'>
    #从unicode转换到str
    u.encode(encoding)   =====>  <type 'unicode'> to <type 'str'>

    >>> c = b.encode('utf-8')
    >>> type(c)
    <type 'str'>
    >>> c
    '\xe5\xa5\xbd'
    
    >>> d = c.decode('utf-8')
    >>> type(d)
    <type 'unicode'>
    >>> d
    u'\u597d'
    这个’xe5xa5xbd’就是unicode u’好’通过函数encode编码得到的UTF-8编码的str类型的字符串。反之亦然，
    str类型的c通过函数decode解码成unicode字符串d。


str(s)与unicode(s)
    str(s)和unicode(s)是两个工厂方法，分别返回str字符串对象和unicode字符串对象，str(s)是s.encode(‘ascii’)的简写。
    实验：

    >>> s3 = u"你好"
    >>> s3
    u'\u4f60\u597d'
    >>> str(s3)
    Traceback (most recent call last):
    File "<stdin>", line 1, in <module>
    UnicodeEncodeError: 'ascii' codec can't encode characters in position 0-1: ordinal not in range(128)

    上面s3是unicode类型的字符串，str(s3)相当于是执行s3.encode(‘ascii’)因为“你好”两个汉字不能用ascii码来表示，
    所以就报错了，指定正确的编码：
    s3.encode(‘gbk’)或者s3.encode(“utf-8”)就不会出现这个问题了。类似的unicode有同样的错误：
   
    >>> s4 = "你好"
    >>> unicode(s4)
    Traceback (most recent call last):
    File "<stdin>", line 1, in <module>
    UnicodeDecodeError: 'ascii' codec can't decode byte 0xc4 in position 0: ordinal not in range(128)
    >>>

    unicode(s4)等效于s4.decode(‘ascii’)，因此要正确的转换就要正确指定其编码s4.decode(‘gbk’)或者s4.decode(“utf-8”)。


乱码
    所有出现乱码的原因都可以归结为字符经过不同编码解码在编码的过程中使用的编码格式不一致，比如：
    # encoding: utf-8
    
    >>> a='好'
    >>> a
    '\xe5\xa5\xbd'
    >>> b=a.decode("utf-8")
    >>> b
    u'u597d'
    >>> c=b.encode("gbk")
    >>> c
    '\xba\xc3'
    >>> print c
    ��
    utf-8编码的字符‘好’占用3个字节，解码成Unicode后，如果再用gbk来解码后，只有2个字节的长度了，
    最后出现了乱码的问题，因此防止乱码的最好方式就是始终坚持使用同一种编码格式对字符进行编码和解码操作。

其他技巧
    对于如unicode形式的字符串（str类型)：
    s = 'id\u003d215903184\u0026index\u003d0\u0026st\u003d52\u0026sid’
    转换成真正的unicode需要使用：
    s.decode('unicode-escape')
    >>> s = 'id\u003d215903184\u0026index\u003d0\u0026st\u003d52\u0026sid\u003d95000\u0026i'
    >>> print(type(s))
    <type 'str'>
    >>> s = s.decode('unicode-escape')
    >>> s
    u'id=215903184&index=0&st=52&sid=95000&i'
    >>> print(type(s))
    <type 'unicode'>
    >>>
    以上代码和概念都是基于Python2.x。
    
    
unicode 正规化(Normalization)
    >>> s1 = 'café'
    >>> s2 = 'cafe\u0301'
    >>> s1, s2
    ('café', 'café')
    >>> len(s1), len(s2)
    (4, 5)
    >>> s1 == s2
    False

s1和s2代表的是相同的字符串, 但长度不一致, 也不相同. Python中的unicodedata.normalize()方法可将unicode正规化. 
此方法的第一个参数有是个可选值: 'NFC', 'NFD','NFKC' 和 'NFKD'.NFC表示压缩到最短, NFD表示解压缩.

    >>> from unicodedata import normalize
    >>> s1 = 'café' # composed "e" with acute accent
    >>> s2 = 'cafe\u0301' # decomposed "e" and acute accent
    >>> len(s1), len(s2)
    (4, 5)
    >>> len(normalize('NFC', s1)), len(normalize('NFC', s2))
    (4, 4)
    >>> len(normalize('NFD', s1)), len(normalize('NFD', s2))
    (5, 5)
    >>> normalize('NFC', s1) == normalize('NFC', s2)
    True
    >>> normalize('NFD', s1) == normalize('NFD', s2)
    True

有一些字符经过NFC正规化会变成另外的字符, 比如电阻符号Ω和希腊字母Ω

    >>> from unicodedata import normalize, name
    >>> ohm = '\u2126'
    >>> name(ohm)
    'OHM SIGN'
    >>> ohm_c = normalize('NFC', ohm)
    >>> name(ohm_c)
    'GREEK CAPITAL LETTER OMEGA'
    >>> ohm == ohm_c
    False
    >>> normalize('NFC', ohm) == normalize('NFC', ohm_c)
    True

    在正则匹配中, 使用byte匹配和str匹配时不一样的. byte正则只能匹配到ASCII字符, 而str正则可以匹配unicode字符.

    要处理文件或路径中的byte和str序列, 可使用
        os.fsencode(filename): 如果文件名为str, 则使用sys.getfilesystemencoding()进行编码; 否则, 文件名不变
        os.fsdecode(filename): 如果文件名为byte, 则使用sys.getfilesystemencoding()进行解码; 否则, 文件名不变
