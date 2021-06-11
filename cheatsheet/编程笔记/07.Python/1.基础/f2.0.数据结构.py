序列：迭代，切片，排序和拼接

Python的内建序列, 如果按类型分,可分为:
    容器型序列(Container Sequence): list, tuple 和 collections.deque. 元素可以是不同类型
    扁平序列(Flat Sequence): str, bytes, bytearray, memoryview 和 array.array, 只能存储基本类型
    容器型序列存放的是它们所包含的任意类型的对象的引用。
    扁平序列里面存放的是值而不是引用。一段连续的内存空间，更加紧凑。
    
如果按是否可变, 可分为:
    可变序列: list, bytearray, array.array, collections.deque 和 memoryview
    不可变序列:tuple, str 和 bytes

listcomp_speed.py # for 和 列表推导的速度
    timeit.repeat(cmd, setup=SETUP, number=TIMES) # cmd 执行的命令; SETUP初始化代码或构建环境的导入语句; TIMES每一次测量中语句被执行的次数, repeat重复测量的次数
    for: 计算总和，平均数，挑出特定的元素，新建一个序列
    列表推导：只用列表推导来创建新的列表，并且尽量保持简洁。如果列表推导超过两个行，考虑使用for循环。
    map和filter：可读性大打折扣。map和filter结合不一定比推导性能好。

1. python 会忽略代码里[], {}和()中的换行。因此如果在你的代码里有多行的列表，列表推导、生成器表达式和字典这一类，可以省略'\'.
2. python3:列表推导不会再有变量泄露的问题。
3. 虽然可以用列表推导来初始化元组，数组或其他序列类型，但是生成器表达式是更好的选择。
   generator 表达式更能减少内存使用, 因为其使用的是iterator协议, 一个一个产生输出. 
   generator表达式和comprehension表达式一致, 除了使用()而不是[]
   
生成器表达式
    生成器表达式的语法跟列表推导差不多，只不过把方括号换成圆括号而已。
    symbols = '$¢£¥€¤'
    [ord(s) for s in symbols if ord(s) > 127]  #列表推导
    
    tuple(ord(symbol) for symbol in symbols)   #生成器表达式
    import array
    array.array('I', (ord(symbol) for symbol in symbols)) #生成器表达式
    
    colors = ['black', 'white']
    sizes = ['S', 'M', 'L']
    tshirts = [(color, size) for color in colors for size in sizes] #列表推导
    
    for tshirt in ('%s %s'%(c, s) for c in colors for s in sizes): #生成器表达式
        print(tshirt)
    
元组是记录
4. 元组其实是对数据的记录：元组中的每个元素都存放了记录中一个字段的数据，外加这个字段的位置。正是这个位置信息给数据赋予了意义。
    >>> lax_coordinates = (33.9425, -118.408056)
    >>> city, year, pop, chg, area = ('Tokyo', 2003, 32450, 0.66, 8014) 
    >>> traveler_ids = [('USA', '31195855'), ('BRA', 'CE342567'),
    ...     ('ESP', 'XDA205856')]
    >>> for passport in sorted(traveler_ids):
    ...     print('%s/%s' % passport)
    ...
    BRA/CE342567
    ESP/XDA205856
    USA/31195855
    >>> for country, _ in traveler_ids:    # (6)
    ...     print(country)
    ...
    USA
    BRA
    ESP
可迭代元素拆包
    1. 平行负值 city, year, pop, chg, area = ('Tokyo', 2003, 32450, 0.66, 8014) 
       可以用*运算符把一个可迭代对象拆开作为函数的参数。
       t = (20 ,8)
       divmod(*t)
       让一个函数可以用元组的形式返回多个值，然后调用函数的代码就能轻松地接收这些返回值。
       import os
       _, filename = os.path.split('/home/luciano/.ssh/idrsa.pub')
       用*来处理剩下的元素。a, b, *rest = range(5)
                            a, *body, c, d = range(5)
                            *head, b, c, d = range(5)
     metro_lat_long.py 嵌套元组拆包 # print('{:15} | {:^9} | {:^9}'.format('', 'lat.', 'long.'))
                                    # fmt = '{:15} | {:9.4f} | {:9.4f}'
                                    # print(fmt.format(name, latitude, longitude))
具名元组
    >>> from collections import namedtuple
    >>> City = namedtuple('City', 'name country population coordinates')   # (1) 一个是类名，另一个是类的各个字段的名字
    >>> tokyo = City('Tokyo', 'JP', 36.933, (35.689722, 139.691667))   # (2) 存放在对应字段的数据要以一串参数的形式传入构造函数
    >>> tokyo
    City(name='Tokyo', country='JP', population=36.933, coordinates=(35.689722, 139.691667)) 
    >>> tokyo.population   # (3) 可以通过名称或者位置来获取一个字段的信息
    36.933
    >>> tokyo.coordinates
    (35.689722, 139.691667)
    >>> tokyo[1]
    >>> City._fields # (1) 包含这个类所有字段名称的元组
    >>> LatLong = namedtuple('LatLong', 'lat long')
    >>> delhi_data = ('Delhi NCR', 'IN', 21.935, LatLong(28.613889, 77.208889)) 
    >>> delhi = City._make(delhi_data)   # (2)接收一个可迭代对象来生成这类的一个实例
    >>> delhi._asdict()   # (3) 以collections.OrderDict的形式返回
    OrderedDict([('name', 'Delhi NCR'), ('country', 'IN'), ('population', 21.935), ('coordinates', LatLong(lat=28.613889, long=77.208889))])
    >>> for key, value in delhi._asdict().items():
    
切片
    对seq[start:stop:step]进行求职的时候，Python会调用seq.__getitem__(slice(start,stop,step))。
    1. 多为切片：     []运算符里还可以使用以逗号分开的多个索引或者是切片，外部库NumPy里就用到了这个特性。
    numpy.ndarray  a[i,j] a.__getitem__((i, j)) 或者a[m:n, i:j]
    2. ... 省略表示法：省略在Python解析器眼里是一个符号，而实际上它是Ellipsis对象的别名。Ellipsis对象又是ellipsis类的单一实例。
    f(a, ..., z) 或者a[i:...] ; 如果x是四维数组，那么x[i,...]就是x[i,:,:,:]的缩写。
    Assigning to slices
    >>> l = list(range(10))
    >>> l
    [0, 1, 2, 3, 4, 5, 6, 7, 8, 9] 
    >>> l[2:5] = [20, 30]
    >>> l
    [0, 1, 20, 30, 5, 6, 7, 8, 9]
    >>> del l[5:7]
    >>> l
    [0, 1, 20, 30, 5, 8, 9]
    >>> l[3::2] = [11, 22]
    >>> l
    [0, 1, 20, 11, 5, 22, 9]
    >>> l[2:5] = 100   # (1) 如果赋值的对象是一个切片，那么赋值语句的右侧必须是个可迭代对象。即便只有单独一个值。
    Traceback (most recent call last):
    File "<stdin>", line 1, in <module> 
    TypeError: can only assign an iterable 
    >>> l[2:5] = [100]
    >>> l
    [0, 1, 100, 22, 9]
+ 和* 
    2.py
    序列的append           和   序列的赋值
    a[0].append('hello')         board[1][2] = 'X'
序列的增加赋值 += *=
    += -> __iadd__ -> __add__
    a += b
        list, bytearray, array.array 而言 a.extend(b) 就地改动
        如果没有实现__iadd__， a + b生成一个新对象，然后赋值给a。
    *= -> __imul__ -> __mul__
    
    >>> L = [1, 2, 3] 
    >>> id(L) 
    4311953800   # (1) 刚开始时列表的ID
    >>> L *= 2
    >>> L
    [1, 2, 3, 1, 2, 3] 
    >>> id(L) 
    4311953800   # (2) 运用增量乘法后，列表的ID没变，新元素追加到列表上
    
    >>> t = (1, 2, 3) 
    >>> id(t) 
    4312681568   # (3) 元组开始的ID
    >>> t *= 2
    >>> t
    (1, 2, 3, 1, 2, 3)
    >>> id(t) 
    4301348296   # (4) 运用增量乘法后，新的元组被创建。
谜题
    >>> t = (1, 2, [30, 40])
    >>> t[2] += [50, 60]

    (1, 2, [30, 40, 50, 60]) 同时抛出 TypeError
    import dis
    dis.dis('t[2] += [50, 60]')
    
list.sort()和sorted()内建函数
    list.sort()不会返回新的对象, 而sorted()则会. list.sort()和sorted()都有两个可选的关键词参数:
        key:　用于key排序的方法
        reverse: bool型变量. 升序或降序. 默认为False
    >>> fruits = ['grape', 'raspberry', 'apple', 'banana']

    >>> sorted(fruits)
    ['apple', 'banana', 'grape', 'raspberry'] # 1
    >>> fruits
    ['grape', 'raspberry', 'apple', 'banana'] # 2
    >>> sorted(fruits, reverse=True)
    ['raspberry', 'grape', 'banana', 'apple'] # 3
    >>> sorted(fruits, key=len)
    ['grape', 'apple', 'banana', 'raspberry'] # 4
    >>> sorted(fruits, key=len, reverse=True)
    ['raspberry', 'banana', 'grape', 'apple'] # 5
    >>> fruits
    ['grape', 'raspberry', 'apple', 'banana'] # 6
    >>> fruits.sort()                         # 7
    >>> fruits
    ['apple', 'banana', 'grape', 'raspberry'] # 8
用bisect来搜索
    bisect模块提供了两个主要的函数:
        bisect: 用于对已经排序的序列进行二分搜索；bisect是bisect_right的别名；
        insort: 用于对已经排序的序列进行插入操作
    bisect(haystack, needle) 在haystack里搜索needle的位置，该位置满足的条件是，把needle插入这个位置之后，haystack还能保持升序。
    也就是说这个函数返回的位置的前面的值，都小于或等于needle的值。
    haystack必须是一个有序序列；
    先用bisect(haystack, needle)查找位置index，再用haystack.insert(index, needle)来插入新值。
    
    bisect_left(a, x[, lo[, hi]]) # lo默认值是0，hi的默认值是序列的长度
    def grade(score, breakpoints=[60,70,80,90], grades='FDCBA'):
        i = bisect.bisect(breakpoints, score)
        return grades[i]
     [grade(score) for score in [33, 99, 77, 77, 89, 90, 100]]
    bisect_demo.py
    bisect_insort.py
    
list不适用在哪些地方
    比如说, 如果list中都是float元素且非常多, 使用array会更有效些. 因为array存放的是基本类型(primitive type), 而不是包装类型; 或者需要经常对序列进行FIFO或LIFO操作, 则deque效率更高, 因此其是个双向队列.
    array.array 只能存放同一元素的序列.
    memoryview  是个共享内存的序列类型
    deque
    collections.deque内部有个双向指针. 非常适用在从头插入或删除元素的序列(不需要移动数据).
    除了deque为, Python核心库中的其他模块也实现了queue:
        queue: 用于线程间安全的数据通信 Queue, LifoQueue PriorityQueue
        multiprocessing: 用于进程间安全的数据通信 multiprocessing.Queue multiprocessing.JoinableQueue 
        asyncio: 用于管理异步通信的任务 Queue, LifoQueue PriorityQueue JoinableQueue
        heapq: 提供了heappush()和heappop()方法. 

        from array import array
        from random import random
        floats = array('d', (random() for i in range(10**7)))
        print floats[-1]
        fp = open('float.bin', 'wb')
        floats.tofile(fp)
        fp.close()
        floats2 = array('d')
        fp = open('float.bin', 'rb')
        floats2.fromfile(fp, 10**7)
        print floats2[-1]
        print floats2 == floats
        
     memoryview.cast 能用不同的方式读写同一块内存数据
        numbers = array.array('h', [-2, -1, 8, 1, 2])
        memv = memoryview(numbers)
        printlen(memv)
        mem_oct = memv.cast('B')
        mem_oct.tolist()
        mem_oct[5] = 4
        print numbers
        
NumPy和SciPy 提供的高阶数组和矩阵操作，
    NumPy实现了多维同质数组和矩阵。
    SciPy提供了很多跟科学计算有关的算法。诸位线性代数、数值积分和统计学而设计。
    sudo apt-get install python-numpy python-scipy
    Pandas
    Blaze
        