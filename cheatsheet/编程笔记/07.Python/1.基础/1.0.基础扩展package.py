解释器options:
1.1 –d   提供调试输出
1.2 –O   生成优化的字节码(生成.pyo文件)
1.3 –S   不导入site模块以在启动时查找python路径
1.4 –v   冗余输出(导入语句详细追踪)
1.5 –m mod 将一个模块以脚本形式运行
1.6 –Q opt 除法选项(参阅文档)
1.7 –c cmd 运行以命令行字符串心事提交的python脚本
1.8 file   以给定的文件运行python脚本

2 下划线: 作为变量前缀和后缀指定特殊变量
2.1 _xxx: 不用’from module import*’导入
2.2 __xxx__: 系统定义名字
2.3 _xxx: 类中的私有变量名

3 python对象有三个特征: 身份和类型是只读的, 如果对象支持不支持更新操作, 那么值也就是只读的.
3.1 身份: 唯一的身份标识, 可以使用内建函数id()得到, 可以看作是对象的内存地址…
3.2 类型: 对象的类型决定该对象保存什么类型的值, 可以进行什么操作, 遵循什么规则., 可以使用内建函数type()查看python对象的类型.
3.3 值: 对象表示的数据项

4 类型工厂函数: int(), long(), float(), complex(), str(), Unicode(), basestring(), list(), tuple(), 
type(), dict(), bool(), set(), frozenset(), object(), classmethod(), staticmethod(), super(), 
property(), file()

5 数字科学计算的包
5.1 高级的Third package: Numeric(NumPy)
5.2 python自带的数字类型相关模块
5.2.1 decimal  十进制浮点运算类Decimal
5.2.2 array  高效数值数组(字符, 整数, 浮点数)
5.2.3 match/cmatch  标准c库数学运算函数. 常规数学运算在match, 复数运算在cmatch
5.2.4 operator  数字运算符的函数实现
5.2.5 random  伪随机数生成器
        random() 随机生成一个 [0, 1) 的浮点数
        randint(start, end)随机生成start, end之间的一个整数
        uniform(start, end)随机生成范围内的一个浮点数
        randrange([start ,]stop[, step])随机生成start, stop内按step步增数字范围的一个整数
        choice(sequence)随机返回给定的序列中的一个元素
        sample(population, k) population为可迭代对象, 从中抽取k项, 0 <= k <= len(population)
        shuffle(x) 在不改变内存中位置的情况下打乱x
        
6 与字符串类型有关的模块:
6.1 string: 字符串相关操作函数和工具, 比如Template类
6.2 re:  正则表达式
6.3 struct: 字符串和二进制之间的转换
6.4 c/StringIO  字符串缓冲对象, 操作方法类似于file对象
6.5 base64  Base16, 32, 64数据编解码
6.6 codecs   解码器注册和基类
6.7 crypt  进行单方面加密
6.8 difflib   找出序列间的不同
6.9 hashlib   多种不同安全哈希算法和信息摘要算法的API
6.10 hma    HMAC信息鉴权算法的python实现
6.11 md5  RSA的MD5信息摘要鉴权
6.12 rotor   提供多平台的加解密服务
6.13 sha    NIAT的安全哈希算法SHA
6.14 stringprep   提供用于IP协议的Unicode字符串
6.15 textwrap   文本打包和填充
6.16 unicodedata    Unicode数据库

7 与list相关模块:
7.1 数组array   受限的可变序列类型, 要求所有元素都是相同的类型
7.2 operator   包含函数调用形式的序列操作符, operator.concat(m, n)相当于m+n
7.3 re  perl风格的正则查找
7.4 StringIO / cStringIO  长字符串作为文件来操作, 比如read(),  seek()函数……c版本的速度更快一些
7.5 Textwrap  包裹/填充文本的函数
7.6 types   包含python支持的所有类型
7.7 collections  高性能容器数据类型
7.8 UserList  包含了list对象的完全的类实现, 允许用户获得类似list的类, 用以派生新的类和功能

8 与file相关模块:
8.1 base64  二进制字符串和文本字符串之间的编码/解码操作
8.2 binascii  二进制和ascii编码的二进制字符串间的编码/解码操作
8.3 bz2  访问BZ2格式的压缩文件
8.4 csv  访问csv文件(逗号分割文件)
8.5 filecmp   用于比较目录和文件
8.6 fileinput  提供多个文本文件的行迭代器
8.7 getopt/optparse  提供了命令行参数的解析/处理
8.8 glob/fnmatch  提供Unix样式的通配符匹配功能
8.9 gzip/zlib   读写GNU zip(gzip)文件(压缩需要zlib模块)
8.10 shutil  提供高级文件访问能力
8.11 c/StringIO   对字符串对象提供类文件接口
8.12 tarfile  读写TAR归档文件, 支持压缩文件
8.13 tempfile   创建一个临时文件(名)
8.14 uu  格式的编码和解码
8.15 zipfile  用于读取ZIP归档文件的工具

itertools模块
    chain(iter1, iter2, ..., iterN)
        给出一组迭代器(iter1, iter2, ..., iterN)，此函数创建一个新迭代器来将所有的迭代器链接起来，
        返回的迭代器从iter1开始生成项，知道iter1被用完，然后从iter2生成项，这一过程会持续到iterN
        中所有的项都被用完。
    chain.from_iterable(iterables)
        一个备用链构造函数，其中的iterables是一个迭代变量，生成迭代序列，
    combinations(iterable, r)
        创建一个迭代器，返回iterable中所有长度为r的子序列，返回的子序列中的项按输入iterable中的顺序排序:
    count([n])
        创建一个迭代器，生成从n开始的连续整数，如果忽略n，则从0开始计算（注意：此迭代器不支持长整数），
        如果超出了sys.maxint，计数器将溢出并继续从-sys.maxint-1开始计算。
    cycle(iterable)
        创建一个迭代器，对iterable中的元素反复执行循环操作，内部会生成iterable中的元素的一个副本，
        此副本用于返回循环中的重复项。
    dropwhile(predicate, iterable)
        创建一个迭代器，只要函数predicate(item)为True，就丢弃iterable中的项，
        如果predicate返回False，就会生成iterable中的项和所有后续项。
    groupby(iterable[, key])
        创建一个迭代器，对iterable生成的连续项进行分组，在分组过程中会查找重复项。
    ifilter(predicate, iterable):
        创建一个迭代器，仅生成iterable中predicate(item)为True的项，如果predicate为None，
        将返回iterable中所有计算为True的项。
        ifilter(lambda x: x%2, range(10)) --> 1 3 5 7 9
    ifilterfalse(predicate, iterable)
        创建一个迭代器，仅生成iterable中predicate(item)为False的项，如果predicate为None，
        则返回iterable中所有计算为False的项。
        ifilterfalse(lambda x: x%2, range(10)) --> 0 2 4 6 8
    imap(function, iter1, iter2, iter3, ..., iterN)
        创建一个迭代器，生成项function(i1, i2, ..., iN)，其中i1，i2...iN分别来自迭代器iter1，iter2 ... iterN，
        如果function为None，则返回(i1, i2, ..., iN)形式的元组，只要提供的一个迭代器不再生成值，迭代就会停止。
    islice(iterable, [start, ]stop[, step])
        创建一个迭代器，生成项的方式类似于切片返回值： iterable[start : stop : step]，将跳过前start个项，
        迭代在stop所指定的位置停止，step指定用于跳过项的步幅。与切片不同，负值不会用于任何start，stop和step，
        如果省略了start，迭代将从0开始，如果省略了step，步幅将采用1.
    izip(iter1, iter2, ... iterN)
        创建一个迭代器，生成元组(i1, i2, ... iN)，其中i1，i2 ... iN 分别来自迭代器iter1，iter2 ... iterN，
        只要提供的某个迭代器不再生成值，迭代就会停止，此函数生成的值与内置的zip()函数相同。
    izip_longest(iter1, iter2, ... iterN, [fillvalue=None])
        与izip()相同，但是迭代过程会持续到所有输入迭代变量iter1,iter2等都耗尽为止，如果没有使用fillvalue
        关键字参数指定不同的值，则使用None来填充已经使用的迭代变量的值。
    permutations(iterable[, r])
        创建一个迭代器，返回iterable中所有长度为r的项目序列，如果省略了r，那么序列的长度与iterable中的项目
        数量相同：
    repeat(object[, times])
        创建一个迭代器，重复生成object，times（如果已提供）指定重复计数，如果未提供times，将无止尽返回该对象。
    starmap(func[, iterable])
        创建一个迭代器，生成值func(*item),其中item来自iterable，只有当iterable生成的项适用于这种调用函数的方式时，此函数才有效。
    takewhile(predicate[, iterable])
        创建一个迭代器，生成iterable中predicate(item)为True的项，只要predicate计算为False，迭代就会立即停止。
    tee(iterable[, n])
        从iterable创建n个独立的迭代器，创建的迭代器以n元组的形式返回，n的默认值为2，此函数适用于任何可迭代的
        对象，但是，为了克隆原始迭代器，生成的项会被缓存，并在所有新创建的迭代器中使用，一定要注意，不要在调用
        tee()之后使用原始迭代器iterable，否则缓存机制可能无法正确工作。
        
operator模块
    operator模块提供了一下有用的方法, 比如:
        各种运算和比较操作
        itemgetter: 获取序列元素
        attrgetter: 获取对象属性
        methodcaller: 根据方法名称返回方法对象
        
functools模块
    reduce: reduce操作
    partial: 用于减少函数参数.
        >>> from operator import mul
        >>> from functools import partial
        >>> triple = partial(mul, 3)
        >>> triple(7)
        21
        >>> list(map(triple, range(1, 10)))
        [3, 6, 9, 12, 15, 18, 21, 24, 27]

collections模块
    tuple(namedtuple)  d = p._asdict()从tuple到字段; Point(**d)从字典到tuple.
    list(deque)
    dict(defaultdict,OrderedDict,ChainMap)
    list[tuple](Counter)
    set(frozenset)

list不适用在哪些地方
    比如说, 如果list中都是float元素且非常多, 使用array会更有效些. 因为array存放的是基本类型(primitive type), 
    而不是包装类型; 或者需要经常对序列进行FIFO或LIFO操作, 则deque效率更高, 因此其是个双向队列.
    
    array.array
    只能存放同一元素的序列.
    
    memoryview
    memoryview是个共享内存的序列类型
    
    deque
    collections.deque内部有个双向指针. 非常适用在从头插入或删除元素的序列(不需要移动数据).
    
    除了deque为, Python核心库中的其他模块也实现了queue:
        queue: 用于线程间安全的数据通信
        multiprocessing: 用于进程间安全的数据通信
        asyncio: 用于管理异步通信的任务
        heapq: 提供了heappush()和heappop()方法.
    