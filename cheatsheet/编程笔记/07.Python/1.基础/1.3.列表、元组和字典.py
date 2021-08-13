
数据结构
    可以处理一些 数据 的 结构 。或者说, 它们是用来存储一组相关数据的。
    在Python中有三种内建的数据结构——列表、元组和字典。
    任何在括号中的多行语句都视为一行。括号包括圆括号()，中括号[]，大括号{}。也可以用反斜线\转义换行符来跨多行
    
解析表达式
    python3.0中可用的4种解析表达式形式：列表解析，生成器表达式，集合解析以及字典解析
    列表解析
    [x*x for x in range(10)]
    生成器表达式
    (x*x for x in range(10))
    集合解析
    {x*x for x in range(10)}    # python 2.7后支持
    字典解析
    {x:x*x for x in range(10)}  # python 2.7后支持
    
    扩展的列表解析表达式： [ x+y for x in 'abc' if x!='a' for y in 'lmn' if y!='l']
    其通用结构为：
    [ expression for target1 in iterable1 [if condition1]
            for target2 in iterable2 [if condition2]
            ....]

    
列表(list, 有的语言称为:数组)
    是处理一组有序项目的数据结构, 即你可以在一个列表中存储一个 序列 的项目。
    列表中的项目应该包括在方括号中, 每个项目之间用逗号分割。
    可以添加、删除或是搜索列表中的项目。列表是 可变的 数据类型。
    列表对象定义的所有方法可以通过 help(list) 获得完整的知识。我比较习惯称它为“数组”。
    
    在列表中，可以通过None提前分配一个N项的列表，这样以后通过索引赋值就不会出现索引不存在的情况了，例如：
    L=[None]*100
    在这种情况下列表L就会有一个初始大小，可以向0～99的索引赋值了
    
    使用pop()方法删除末尾元素，使用pop(index)删除指定位置元素 #.pop(index)方法：删除指定位置元素并返回该元素，原地修改
    del list1[0]函数：删除指定位置处元素，原地修改 # 与.pop()的区别在于del()函数并不返回该元素
    del list1[index1:index2]函数：删除指定片断处元素， 原地修改
    .remove(val)：通过值删除元素，若有多个值，则只删除第一个遇到的值原地修改
    
    使用remove(value)移除指定值元素 
    使用append(value)在表尾添加一个元素，
    使用insert(index)在指定位置添加元素，使用index(i)返回i值的索引，若没有会报一个值错误。
    sort(key=None, reverse=False)方法：对列表进行排序， 原地修改
        key为一个排序方法
        reverse为是否逆序
    当一个复合对象包含指向自身的引用时（如L.append(L)），称为循环对象。当Python在对象中检测到循环时，会打印成[...]而不会陷入无限循环。
    
    list元素范围获取通过 list[begin:end]这种方式获取. 注意:
        begin包含, 但end不包含
        正数索引从头开始, 负数索引从尾开始
        不管begin,end索引是正数还是负数, 范围计算都是从begin到end的范围.
        [:]代表截取整个list
    
    例:
    shoplist = ['apple', 'mango', 'carrot', 'banana']
    #查看长度
    print('I have', len(shoplist),'items to purchase.')

    #遍历
    print 'These items are:', # 注意这行的结尾,打印时可以不换行,python 3.x应该写： print('These items are:', end=' ')
    for item in shoplist:
        print item, # 打印后不换行, python 3.x 此行应该写：“print(item, end=' ')”

    #带索引的 序列 迭代(很实用的获取索引的写法) enumerate: 列举
    for index, item in enumerate(shoplist):
        print index, item  # 打印如:0 apple

    #添加
    print('\nI also have to buy rice.')
    shoplist.append('rice')
    #shoplist += ['rice'] # 跟上句一样的效果,添加一个值到列表里面。
    #shoplist[:] = shoplist + ['rice'] # 这样写跟上句也一样效果。注意,“ shoplist = shoplist + ['rice'] ”这写法会改变引用地址
    print('My shopping list is now:', shoplist) # 打印:["apple", "mango", "carrot", "banana", "rice"]

    #排序
    print('I will sort my list now')
    shoplist.sort() # .sort(key=None, reverse=False)方法：对列表进行排序，原地修改
    print('Sorted shopping list is:', shoplist) # 打印:['apple', 'banana', 'carrot', 'mango', 'rice']

    #删除,以及使用下标
    print('The first item I will buy is:', shoplist[0])
    olditem = shoplist[0]
    #shoplist.remove(olditem) # 按值删除,当这值不存在列表时会报错 ; 
    # .remove通过值删除元素，若有多个值，则只删除第一个遇到的值 原地修改
    del shoplist[0] # del list1[index1:index2]函数：删除指定片断处元素， 原地修改
    print('I bought the', olditem)
    print('My shopping list is now:', shoplist) # 打印:['banana', 'carrot', 'mango', 'rice']

    #多维列表时,保存的对象只是引用
    newlist = ['waa','dd']
    shoplist.append(newlist)
    print('My shopping list is now:', shoplist) # 打印:['banana', 'carrot', 'mango', 'rice', ['waa', 'dd']]
    del newlist[0]
    print('My shopping list is now', shoplist) # 打印:['banana', 'carrot', 'mango', 'rice', ['dd']]

    # 删除重复, 用 set (对元组也可以这样写)
    L = [1,1,1,2,2]
    print(list(set(L))) # 打印：[1, 2]
    l = [(1, 2), (1, 2), 3, 5, 4, 3, 4, (1, 2), 0, 5]
    l = list(set(l))
    print(l) # 打印: [(1, 2), 0, 3, 4, 5]
    # 列表去重的快速方法，比用set要快
    l = dict.fromkeys(L).keys()
    print(l) # 打印: [1, 2]

    # 复制列表(浅拷贝)
    c = shoplist[:]
    c = shoplist.copy() # 效果跟上一句一样
    # 复制(深拷贝)
    import copy
    c = copy.deepcopy(shoplist)

    # 合并两列表
    type_list = [1,2]
    print(type_list) # 打印: [1, 2]
    type_list.extend([3,4]) # 合并两个列表
    print(type_list)# 打印: [1, 2, 3, 4]


    # 列表 合并成字符串
    li = ['1', '2', 'a', 'b']
    s = '|'.join(li)
    print(s) # 打印: 1|2|a|b

    # 字符串 分拆成 列表(跟上面相反)
    a = 'a b c'
    print(a.split(' ')) # 打印:['a', 'b', 'c']


    # 获取两个list 的交集
    # 方法一:
    a=[2,3,4,5]
    b=[2,5,8]
    print( [value for value in a if value in b] )  #打印: [2, 5]
    # 方法二:
    print( list(set(a).intersection(set(b))) )

    # 获取两个list 的并集
    # 方法一:
    print( list(set(a + b)) )
    # 方法二:
    print( list(set(a).union(set(b))) ) # 打印: [2, 3, 4, 5, 8]

    # 获取两个list 的差集
    # 方法一:
    print( [value for value in a if value not in b] )  # a 中有而 b 中没有,打印: [3, 4]
    print( [value for value in b if value not in a] )  # b 中有而 a 中没有,打印: [8]
    # 方法二:
    print( list(set(a).difference(set(b))) ) # a 中有而 b 中没有,打印: [3, 4]
    print( list(set(b).difference(set(a))) ) # b 中有而 a 中没有,打印: [8]

    列表相关的内置函数：
        sorted(list1,key=None,reverse=False)：排序列表并返回新列表， 非原地修改
        reversed(list1)：返回迭代器，该迭代器迭代结果就是列表的逆序
        
    假设L=[1,2]，注意下面的用法的区别：
        X=L*2：列表乘以整数，生成新列表[1,2,1,2]
        Y=[L]*2：也是列表乘以整数，但是被乘列表是[[1,2],]， 生成的新列表是[[1,2],[1,2],]
    
    L = [1,2,3]
    L.append(L)
    print L # [1, 2, 3, [...]]
元组(tuple)
    元组和列表十分类似, 只不过元组和字符串一样是 不可变的 即你不能修改元组。
    元组通过圆括号中用逗号分割的项目定义。
    元组通常用在使语句或用户定义的函数能够安全地采用一组值的时候, 即被使用的元组的值不会改变。
    如果你想要知道元组对象定义的所有方法, 可以通过 help(tuple) 获得完整的知识。

    例:
    #一维元组
    zoo = ('wolf', 'elephant', 'penguin')
    print('Number of animals in the zoo is %s' % len(zoo))  # 打印: 3

    newlist = ['waa','dd']
    #多维元组
    new_zoo = ('monkey', 'dolphin', zoo, newlist)
    print('Number of animals in the new zoo is %s' % len(new_zoo))  # 打印: 3
    print('All animals in new zoo are %s' % str(new_zoo))  # 打印: ('monkey','dolphin',('wolf','elephant','penguin'),['waa','dd'])
    print('Animals brought from old zoo are %s' % str(new_zoo[2]))  # 打印: ('wolf', 'elephant', 'penguin')
    print('Last animal brought from old zoo is %s' % new_zoo[2][2]) # 打印: penguin

    #多维元组时,保存的对象只是引用
    del newlist[0]
    print('new_zoo is now:' + str(new_zoo) )  # 打印: ('monkey','dolphin',('wolf','elephant','penguin'),['dd'])

    tuple(iter_obj)函数从一个可迭代对象生成元组
    tuple.index(val)方法：在元组中搜索val值所在位置
    tuple.count(val)方法：在元组中累计val值出现的次数
    
    在不会引起语法冲突的情况下，Python支持忽略元组中的圆括号。如x=10,20等价于x=(10,20)

    注意:含有0个或1个项目的元组
    一个空的元组(含有0个项目)由一对空的圆括号组成, 如myempty = ()。
    含有单个元素的元组必须在第一个(唯一一个)项目后跟一个逗号。如: singleton = (2 , )。
    如果小括号里面只有唯一一个项目,而这个项目后面又没有跟一个逗号的话,Python会认为它是一个表达式。


无序集合(set) # 本质上set通过元素值的哈希值来判断唯一性
    1.Python的set类型是集合内元素值唯一、元素值不可变的无序集。 set类型并不要求其集合内各个元素都是相同类型。
    唯一：set类型的集合内元素的值唯一。
        如果有两个变量指向同一个对象，则在set集合内只会出现一次
        如果有两个对象值相等，则在set集合内也只会出现一次
    不可变：一旦创建完毕，则set集合内的各个元素值不能修改。 
    2.Python3中，set常量可以用大括号创建：{1,2,3,4}等价于set([1,2,3,4])。
        空set必须由set([])创建，{}为空字典而不是空set
        Python3中，set的字符串表示为{...}形式，而不是set([...])形式
        # 创建set对象的方法为调用x=set(iter)，其中iter为任何序列或可迭代对象
        # set只能包含不可变的对象，因此列表对象、字典对象、set对象均不能作为set的元素。
    python的 set 和其他语言类似, 是一个无序不重复元素集, 基本功能包括关系测试和消除重复元素.
    集合对象还支持 union(联合), intersection(交), difference(差)和 sysmmetric difference(对称差集) 等数学运算.
    set 支持 x in set, len(set),和 for x in set。
    作为一个无序的集合, set 不记录元素位置或者插入点。
    因此, sets不支持 indexing, slicing, 或其它类序列(sequence-like)的操作。
    
    set元素不能重复, set一定是可以hashable的, 但set本身不是hashable的(frozenset是hashable的).
    创建一个空的set, 一定要写成 set(), 而不是 {}(这个表示空的dict)
    
    例:
    # 普通 set
    x = set('spamm') # 字符串会被分拆成按 list 处理,注意重复的字母会自动去除
    y = set(['h','a','m'])
    s = set([1,2,3])
    print x, y # 打印: set(['a', 'p', 's', 'm']) set(['a', 'h', 'm'])


    # 基本操作
    x.add('x')  # 添加一项,现在的 x 变成: set(['a', 'p', 's', 'm', 'x'])
    x.remove('x') # 删除一项(删除没有的值会报异常,KeyError),现在的 x 变成: set(['a', 'p', 's', 'm'])
    x.discard('x') # 删除一项(删除没有的值也照常运行,不报异常),现在的 x 变成: set(['a', 'p', 's', 'm'])
    x.pop() # 删除并且返回 set 中的一个不确定的元素, 如果为空则引发 KeyError
    y.update([10,37,42])  # 添加多项,现在的 y 变成: set(['a', 37, 'h', 10, 'm', 42])
    y |= set([10,37,42]) # 返回增加了 set “[10,37,42]”中元素后的 set “y”,等价于上面的 update 函数
    s.clear() # 删除 set “s”中的所有元素
    print len(x)  # 获取 set 的长度,打印: 4
    # 测试是否 set 的成员
    print 'x' in x # 打印: False
    print 'a' in x # 打印: True
    print 'a' not in x # 打印: False
    print set('a') in x # in 和 not in 只能判断 set 里面的某个值,不能判断子集, 打印: False
    # 测试是否一个 set 中的每一个元素都在另一个 set/其它序列 中(issubset:前者 <= 后者时返回 True)
    print x.issubset(y) # 打印: False
    print x.issubset('spam1') # 打印: True
    print x<=set('spam1') # 结果跟 issubset 函数一样,只是参数要求两个都必须为 set, 打印: True
    print x<set('spam1') # 大于、小于号在判断子集时也可以用,非子集不适用,打印: True
    print x<set('spam') # 结果为相等,用小于号肯定为 False, 打印: False
    print set('am').issubset(y) # 打印: True
    print set('am')<=set(y) # 打印: True
    # 测试是否一个 set/其它序列 中的每一个元素都在另一个 set 中(issuperset:前者 >= 后者时返回 True)
    print x.issuperset(y) # 打印: False
    print y.issuperset(set('am')) # 打印: True
    print y.issuperset('am') # 打印: True
    print y>=set('am') # 结果跟 issuperset 函数一样,只是参数要求两个都必须为 set, 打印: True
    print set('spam')>set('am') # 大于、小于号在判断子集时也可以用,非子集不适用,打印: True

    子 set 和相等比较并不产生完整的排序功能。sets 不提供 __cmp__ 方法。
    因为 sets 只定义了部分排序功能（subset 关系），list.sort() 方法的输出对于 sets 的列表没有定义。

    # 例如：任意两个互不相等的 set，同时他们也不互为 subset 时,则以下的运算都会返回 False:a<b, a<=b, a==b, a>b, a>=b。
    s = set('123')
    t = set(['h','a','m','c'])
    print s>t # 打印: False
    print s<t # 打印: False
    print s==t # 打印: False

    # 交集
    print x & y # set(['a', 'm'])
    print x.intersection(y) # set(['a', 'm'])
    # 并集
    print x | y # set(['a', 'p', 's', 'h', 'm'])
    print x.union(y) # set(['a', 'p', 's', 'h', 'm'])
    # 差集
    print x - y # set(['p', 's'])
    print x.difference(y) # set(['p', 's'])
    # 对称差集(项在x或y中,但不会同时出现在二者中,即并集 减去 交集)
    print x ^ y # set(['h', 's', 'p'])
    print x.symmetric_difference(y) # set(['h', 's', 'p'])
    # 请注意：union(), intersection(), difference() 和 symmetric_difference() 允许会接受任何 iterable 作为参数。从 2.3.1 版本做的更改：以前所有参数都必须是 set。
    # 但它们的运算符版本(operator based counterparts)要求参数必须是 set 类型。
    # 如：set('abc') & 'cbs' 会报异常, 而 set('abc').intersection('cbs') 正常运行

    # 交、并、差 集合的运算(上面的 交、并、差集 不改变集合 x 的内容,但下面的会改变)
    s.intersection_update(t) # 运行返回 None,但集合
    s &= t
    返回只保留含有 set “t”中元素的 set “s”

    s.difference_update(t)
    s -= t
    返回删除了 set “t”中含有的元素后的 set “s”

    s.symmetric_difference_update(t)
    s ^= t
    返回含有 set “t”或者 set “s”中有而不是两者都有的元素的 set “s”

    # 浅拷贝(浅复制)
    print x.copy() # set(['a', 'p', 's', 'm'])

    # 去除海量 列表 里重复元素，用 dict 来解决也行，只不过在性能上不高，用 set 解决还是很不错的, 示例如下：
    a = [11,22,33,44,11,22]
    b = list(set(a)) # 这样去除列表里的重复,简单又高效
    print b # 打印: [33, 11, 44, 22]

    另外，Set 和 ImmutableSet 两者都支持 set 与 set 之间的比较。
    两个 set 在也只有在这种情况下是相等的：每一个 set 中的元素都是另一个中的元素（二者互为subset）。
    一个 set 比另一个 set 小，只有在第一个 set 是第二个 set 的 subset 时（是一个 subset，但是并不相等）。
    一个 set 比另一个 set 大，只有在第一个 set 是第二个 set 的 superset 时（是一个 superset，但是并不相等）。

    请注意：非运算符版本的 update(), intersection_update(), difference_update() 和 symmetric_difference_update()将会接受任意 iterable 作为参数。从 2.3.1 版本做的更改：以前所有参数都必须是 sets。
    还请注意：这个模块还包含一个 union_update() 方法，它是 update() 方法的一个别名。包含这个方法是为了向后兼容。程序员们应该多使用 update() 方法，因为这个方法也被内置的 set() 和 frozenset() 类型支持。

冻结集合(frozenset)
    所谓冻结就是这个集合不能再添加或删除任何集合里的元素。
    因此与集合 set 的区别，就是 set 是可以添加或删除元素，而 frozenset 不行。
    frozenset 的主要作用就是速度快，它是使用 hash 算法实现。
    frozenset([iterable]) 参数 iterable 是表示可迭代的对象，比如列表、字典、元组等等。
    1. frozenset是set的子类型，它与set的唯一区别是： frozenset对象可以作为set的元素。
    >>> {1, 2, frozenset({3.4})} # set([1, frozenset([3.4]), 2])

字典(dict, 有的语言称为:json)
    字典把键(名字)和值(详细情况)联系在一起。
    注意, 键必须是唯一的, 且只能使用不可变的对象(比如字符串)来作为字典的键, 但字典的值没有此限制。应该说只能使用简单的对象作为键。
    键值对在字典中以这样的方式标记：d = {key1 : value1, key2 : value2 }。
    键值对用冒号分割, 而各个对用逗号分割, 所有这些都包括在花括号中。
    记住字典中的键/值对是没有顺序的。如果要一个特定的顺序, 那么应该在使用前自己对它们排序。
    字典是dict类的实例/对象, 可以用 help(dict) 来查看其属性和函数。

    dict()函数可以从关键字参数生成字典：dict(a=3,b=4)生成字典{'a':3,'b':4}
    你可以通过zip()函数生成关键字参数：dict(zip(['a','b'],[3,4])) 生成字典{'a':3,'b':4}
    你也可以用字典的.fromkeys()类方法生成字典：
        dict.fromkeys(['a','b']) 生成字典{'a':None,'b':None}
        dict.fromkeys(['a','b'],3) 生成字典{'a':3,'b':3}
        
        >>> a = dict(one=1, two=2, three=3)                  # key=value 构造函数
        >>> b = {'one': 1, 'two': 2, 'three': 3}             # 直接赋值
        >>> c = dict(zip(['one', 'two', 'three'], [1, 2, 3]))# 双序列zip
        >>> d = dict([('two', 2), ('one', 1), ('three', 3)]) # 单元组序列
        >>> e = dict({'three': 3, 'one': 1, 'two': 2})       # dict -> dict 构造函数
        
    d1.update(d2)：合并两个字典，原地修改d1字典
    d.pop(key)： 从字典中删除key并返回该元素的值
    del d[key]：从字典中删除key但是不返回该元素的值
    d[key]=value：原地的添加/修改字典。当向不存在的键赋值时，相当于添加新元素

    例:
    ab = { 'Swaroop': 'swar',
           'Larry'  : 'larry',
           'Spammer': 'spammer'
         }
    print(ab) # 打印: {'Swaroop':'swar', 'Larry':'larry', 'Spammer':'spammer'}
    print("Swaroop's address is %s" % ab['Swaroop'])  # 打印: swar

    # 添加值,或者设值
    ab['Guido'] = 'guido'

    # 删除值
    del ab['Spammer']
    # ab.pop('Spammer') # 也可以用 pop 来删除, 但建议后面的这种写法, 避免没有这个键时会报错： ab.pop('Spammer', None)
    # 说明：要删除的key数量较多(超过一半)的话，建议重新生成dict；如果数量较少，在pop和del都可以的情况下，del稍快一些

    print('\nThere are %d contacts in the address-book\n' % len(ab)) # 打印: 3
    # 遍历(这写法得留意)  返回一个dict_items对象，它是一个可迭代对象， 迭代时返回元组(键，值)的序列
    for name, address in ab.items():
        print('Contact %s at %s' % (name, address))
    # 直接写的遍历(效果同上)
    for key in ab:
        print('Contact %s at %s' % (key, ab[key]))


    # 包含key
    if 'Guido' in ab: # 或者写： if ab.has_key('Guido'):
        print("\nGuido's address is %s" % ab['Guido'])

    # 原字典上创建新字典
    print(ab) # 打印: {'Swaroop':'swar', 'Larry':'larry', 'Guido':'guido'}
    dd = dict(ab, slug_field='slug', test=5) # 创建新字典,字典作为参数的只能放第一个, 其余不能再是字典；字典参数可省略
    print(dd) # 打印: {'Swaroop':'swar', 'test':5, 'slug_field':'slug', 'Larry':'larry', 'Guido':'guido'}

    # 建议的取值方法
    print( ab['test'] )  # 这样取值, 当字典里面没有对应的key时会报错:“KeyError”
    print( ab.get('test', 'default_value') )  # get取值, 当字典里面没有对应的key时可取后面的预设值,预设值是可选的(默认是 None)
    # get 取值, 相当于 try/except 的如下写法
    try:
       value = ab['test']
    except KeyError:
       value = 'default_value'

    # 所有的键和值
    print(ab.keys())   # 所有的键；返回一个dict_keys对象，它是一个可迭代对象，迭代时返回键序列
    print(ab.values()) # 所有的值；返回一个dict_values对象，它是一个可迭代对象，迭代时返回值序列

    # 复制(浅拷贝)
    print(ab.copy())
    # 复制(深拷贝)
    import copy
    c = copy.deepcopy(ab)

    # 合并两个字典
    a = {'a':555, 'b':3333}
    b = {'b':4444, 'c':'erer'}
    b.update(a) # 将a字典的内容全部合并到b里面, 重复的key则用a的覆盖b的
    print(b) # 打印：{'a': 555, 'c': 'erer', 'b': 3333}

    # key 的约定:
    # key 只能是不能改变的值,如 str、 unicode、 int、 long、 double 等类型, 但 tuple、time、datetime 类型可以作 key, 而 list、 set、 dict 不行。
    a = {'str': 1, u'unicode':2, 11:3, 574L:556, 5.2014:4} # 正常运行
    import time, datetime
    b = {(1,2,3): 1, time.localtime():2, datetime.datetime.now():3} # 正常运行
    b[[1,2,3]] = 4 # 抛异常, TypeError: unhashable type: 'list'
    b[set([1,2,3])] = 4 # 抛异常, TypeError: unhashable type: 'set'
    b[{}] = 4 # 抛异常, TypeError: unhashable type: 'dict'

    items vs iteritems:
      items() 和 iteritems() 方法都普遍用于 for 循环的迭代中，
      不同的是 items() 返回的是列表对象，而 iteritems() 返回的是迭代器对象。
      两者的用法差不多，但 iteritems()的性能更快。

    ### 设置默认值 ###
    # 1.这样能设置所有key的默认值为[]，包括新添的key
        from collections import defaultdict
        context = defaultdict(list)
        print(context.get('a')) # 打印: None  (注意：直接用 get 获取不到默认值，但下面的索引获取可以)
        print(context['a'])     # 打印: []
        print(context.get('a')) # 打印: []    (由于上面的索引获取时赋了默认值，所以再次 get 可以获取到默认值了)

    # 2.setdefault 一次只能设置一个值，但好处是能使用链式语法，但 defaultdict 更快一些
        context = {}
        context.setdefault('name_list', []).append('Fiona')
        print(context) # 打印: {'name_list': ['Fiona']}

    # 3.用fromkeys，用法dict.fromkeys(seq[, value]))，value默认是国际惯例的None
        name_list = ['kevin', 'robin']
        context = {}.fromkeys(name_list, 9)
        print(context) # 打印: {'kevin': 9, 'robin': 9}
        context = dict.fromkeys([1, 2], True)
        print(context) # 打印: {1: True, 2: True}
        
    # 4. 
    import collections 
    s = [('yellow', 1), ('blue', 2), ('yellow', 3), ('blue', 4), ('red', 1)] 
    d = collections.defaultdict(list) 
    for k, v in s: 
        d[k].append(v)
    list(d.items())
    注意: function_factory只针对__getitem()__特殊方法触发是调用. 因此, dd[k]当k不存在时, 
    会调用function_factory创建默认值, 而dd.get(k)不会调用, 仍然返回None
    
    
set 元组 字典 list和string
    序列: string定长数据类型(数组)  
          list变长数据类型(单向链表) 
          dqueue变长数据类型(双向链表)
          tuple定长数据类型(数组)
          namedtuple定长数据类型(数组)
    dict：dict变长数据类型(hash表)
          set变长数据类型(hash表)
          frozenset定长数据类型(hash表)

    set不是序列，它是可变对象，但是元素只能是不可变类型。
    字典也不是序列，它是可变对象，其元素的值是不限类型，但是键必须是不可变类型。
    
    字符串：不可变对象，元素只能是字符
    列表：可变对象，元素类型不限； # 序列内的元素可以为元组;序列内的元素可以为序列;
    元组：不可变对象，元素类型不限 # 元组内的元素可以为序列;元组内的元素可以为元组;
    
    list通过tuple()内置函数可转换为tuple. tuple也可通过list()内置函数转换为List

    x=[] 
    y={} 
    x[0]='hello' #error: 不允许对不存在的元素赋值 
    y[0]='hello' #ok:dict现在有个一个元素
    
    列表解析表达式：[c*4 for c in 'abcd']生成一个新列表对象， 结果为：['aaaa','bbbb','cccc','dddd']
    set解析表达式：{c*4 for c in 'abcd'}生成一个新set对象， 结果为：{'aaaa','bbbb','cccc','dddd'}（打印顺序不确定）
    字典解析表达式：{c:c*4 for c in 'abcd'}生成一个新列表对象， 结果为：{'a':'aaaa','b':'bbbb','c':'cccc','d':'dddd'} （打印顺序不确定）
    注意：并没有元组解析表达式。(c*4 for c in 'abcd')返回的是一个生成器对象。
    
    Python数据类型：哈希类型、不可哈希类型
        # 哈希类型，即在原地不能改变的变量类型，不可变类型。可利用hash函数查看其hash值，也可以作为字典的key
        "数字类型：int, float, decimal.Decimal, fractions.Fraction, complex"
        "字符串类型：str, bytes"
        "元组：tuple"
        "冻结集合：frozenset"
        "布尔类型：True, False"
        "None"
        # 不可hash类型：原地可变类型：list、dict和set。它们不可以作为字典的key。
    
    Python的内建序列, 如果按类型分,可分为:
        容器型序列(Container Sequence): list, tuple 和 collections.deque. 元素可以是不同类型
        扁平序列(Flat Sequence): str, bytes, bytearray, memoryview 和 array.array, 只能存储基本类型
    
    如果按是否可变, 可分为:
        可变序列: list, bytearray, array.array, collections.deque 和 memoryview
        不可变序列:tuple, str 和 bytes
        
    List Comprehension和Generator 表达式
        generator 表达式更能减少内存使用, 因为其使用的是iterator协议, 一个一个产生输出. 
        generator表达式和comprehension表达式一致, 除了使用()而不是[]
        
    tuple: 不仅仅是不可变list
        tuple中的元素是按照顺序存储的. tuple可以pack和unpack. 当使用tuple unpack给多个变量赋值时, 
        不需要的变量可使用 _ 表示(dummy var)
        在函数定义中, 还可以使用 * 代表tuple对象
        
    += 和 *= 运算符
        +=对应的是 __iadd()__ 特殊方法, 如果没有实现的话, 会调用 __add()__ 方法.
    
    什么是hashable呢?
        map中的key一定要是hashable的, hashable对象在其生命周期类有一个不可变的hash值(对应__hash()__), 并
        且可以和其他对象进行比较(对应__eq()__). 如果两个对象相同, 则其hash值一定相同.

序列
    列表、元组和字符串都是序列, 序列的两个主要特点是“索引”操作符和“切片”操作符。
    索引操作符让我们可以从序列中抓取一个特定项目。(即使用下标)
    切片操作符让我们能够获取序列的一个切片, 即一部分序列。(即在下标的中括号里面使用冒号)
        未给出上界时，该分片默认上界为len(S)
        未给出下界时，该分片默认下界为 0
        如果是S[:]，则返回字符串S的一个全新拷贝

    例:
    shoplist = ['apple', 'mango', 'carrot', 'banana']

    # 序列[index]
    print('Item 0 is %s' % shoplist[0])
    print('Item 3 is %s' % shoplist[3])
    print('Item -1 is %s' % shoplist[-1])   # 打印:banana   即倒数第一个
    print('Item -2 is %s' % shoplist[-2])   # 打印:carrot   即倒数第二个

    # 序列[start:stop]
    print('Item 1 to 3 is %s' % shoplist[1:3])      # 打印:['mango', 'carrot']   即下标[1]到[3],包括开始但不包括结束
    print('Item 2 to end is %s' % shoplist[2:])     # 打印:['carrot', 'banana']  即下标[2]到结束,包括最后一个
    print('Item 1 to -1 is %s' % shoplist[1:-1])    # 打印:['mango', 'carrot']   即下标[1]到[-1],包括开始但不包括结束
    print('Item start to end is %s' % shoplist[:])  # 打印整个列表,跟直接写“shoplist”效果一样, 即是复制这个列表

    # string[start:stop] (string 与 list, tuple 有同样的操作)
    name = 'swaroop'
    print('characters 1 to 3 is %s' % name[1:3])     # 打印:wa       取第几到第几个
    print('characters start to 3 is %s' % name[:3])  # 打印:swa      前面空着, 表示从下标0开始(取前几个)
    print('characters 2 to end is %s' % name[2:])    # 打印:aroop    后面空着, 表示直到结束(从第几个取到最后)
    print('characters 1 to -1 is %s' % name[1:-1])   # 打印:waroo    负数表示倒数第几个(从第几个取到倒数第几个)
    print('characters -2 to end is %s' % name[-2:])  # 打印:op       后面空着, 表示直到结束, 负数表示倒数第几个(取最后几个)
    print('characters start to end is %s' % name[:]) # 打印:swaroop  跟直接写这个字符串一样, 即是复制这个字符串

    如果增加步进参数，则语法为S[m:n:k]，它返回从m开始到n（不包含n）且每隔k个元素选取一次的一个全新字符串，默认k为 1。
    若k为正数则从左到右步进；若k为负数，则从右向左步进
    S[::-1]返回S的翻转字符串
    负步进时，默认的上下界极限有所不同。
        上界极限可以为空或者为len(S)或者为len(S)-1
        下界极限必须为空，否则 0 号元素会被排除掉
    # string[start:stop:step] (string 与 list, tuple 有同样的操作)
    s = 'ABCDEFG'
    print(s[1:7:2])  # 'BDF'      step表示隔多少个, 默认值是1
    print(s[7:1:-1]) # 'GFEDC'    当 step 为负数, 表示反序。
    print(s[::-1])   # 'GFEDCBA'  反序复制
    print(s[::2])    # 'ACEG'     获取 奇数项
    print(s[1::2])   # 'BDF'      获取 偶数项


    # 序列 也可以直接用“+”拼接成新序列
    nfc = ["Packers", "49ers"]
    afc = ["Ravens", "Patriots"]
    all = nfc + afc
    print(all) # 打印:['Packers', '49ers', 'Ravens', 'Patriots']

    # 序列 拼接为字符串
    teams = ["Packers", "49ers", "Ravens", "Patriots"]
    S = ", ".join(teams) ; print S # 打印:Packers, 49ers, Ravens, Patriots
    teams = S.split(',')
    
    # 序列 的乘法
    items = [0]*3
    print(items) # 打印:[0, 0, 0]

    # 带索引的遍历 序列(很实用的获取索引的写法)
    teams = ["Packers", "49ers", "Ravens", "Patriots"]
    for index, team in enumerate(teams):
        print(index, team) # 打印如:0 Packers
        
   列表解析： [item*4 for item in teams]
              [item*4 for item in S]
        
比较操作
比较操作时，Python能够自动遍历嵌套的对象，从左到右递归比较，要多深有多深。过程中首次发现的差异将决定比较的结果。
    数字通过相对大小比较
    字符串从左到右每个字符按照字符的字典序比较
    列表和元组从左到右每部分内容都比较
    字典通过排序后的(键，值)列表比较
    [[0,['a','b'],1],2,3] < [[0,['a','c'],1],2,3] # True
    [[0,['a','b'],1],2,3] > [[0,['a','c'],1],2,3] # False
    
参考(引用)
    当你创建一个对象并给它赋一个变量的时候, 这个变量仅仅 参考 那个对象, 而不是表示这个对象本身！
    也就是说, 变量名指向你计算机中存储那个对象的内存。
    这被称作名称到对象的绑定。

    例:
    shoplist = ['apple', 'mango', 'carrot', 'banana']
    mylist = shoplist # mylist 只是对象的另一个名称,他们指向相同的内存空间

    del shoplist[0]

    # 他们此时打印相同的内容,都少了'apple'
    print('shoplist is', shoplist) # 打印：shoplist is ['mango', 'carrot', 'banana']
    print('mylist   is', mylist)   # 打印：mylist   is ['mango', 'carrot', 'banana']

    # 深拷贝,复制成另一个对象(得记住用切片操作符来取得拷贝)
    mylist = shoplist[:] # make a copy by doing a full slice
    del mylist[0] # remove first item

    # 注意, 现在他们打印出不同的内容
    print('shoplist is', shoplist) # 打印：shoplist is ['mango', 'carrot', 'banana']
    print('mylist is', mylist)     # 打印：mylist is ['carrot', 'banana']


    # 另外，还可以修改列表内部的各值
    print(id(mylist)) # 比较列表的内存地址，打印： 39374664
    mylist[:] = [i * 2 for i in mylist] # 列表[:] 表示修改整个列表内部各个值。可以理解为整个列表指向新的列表内容，而且列表的内存地址没变。
    print(mylist) # 打印：['carrotcarrot', 'bananabanana']
    print(id(mylist)) # 列表的内存地址没变，打印： 39374664

    # 下例让偶数的值变负值
    alist = range(1, 20)
    print(alist) # 打印：[1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19]
    # 传统写法
    result = []
    for (i, v) in enumerate(alist):
        # faster than i % 2
        if i & 1 == 0:
            result.append(v)
        else:
            result.append(-v)
    alist[:] = result
    print(alist) # 打印：[1, -2, 3, -4, 5, -6, 7, -8, 9, -10, 11, -12, 13, -14, 15, -16, 17, -18, 19]
    # 使用参考的写法
    alist = range(1, 20)
    alist[1::2] = [-el for el in alist[1::2]]
    print(alist) # 打印：[1, -2, 3, -4, 5, -6, 7, -8, 9, -10, 11, -12, 13, -14, 15, -16, 17, -18, 19]


推导
    通过列表推导, 可以从一个已有的列表导出一个新的列表。

    写法：
    [返回值 for 元素 in 列表 if 条件]

    比如 [num for num in xrange(100) if num%2==0] 返回0～99之间的偶数列表


    # 例如, 你有一个数的列表, 而你想要得到一个对应的列表, 使其中所有大于2的数都是原来的2倍。对于这种应用, 列表综合是最理想的方法。
    listone = [2, 3, 4]
    listtwo = [2*i for i in listone if i > 2] # 为满足条件(if i > 2)的数指定了一个操作(2*i), 从而导出一个新的列表。
    print(listtwo) # 打印: [6, 8]
    # 上面的普通写法：
    list2 = []
    for i in listone:
        if i > 2:
            list2.append(i)


    ls=[1,3,5,7] # reduce 在python3去掉了, 作用是累计计算结果
    print(reduce(lambda x,y:x+y,ls)) # 计算过程就是 1+3=4 然后4+5得到结果9, 再加7, 以此类推, 最后返回最终计算的结果(总和)；打印：16


    # 多层嵌套的 list 推导
    ticket_types = [101,102]
    employees = ['aa', 'bb']
    data = [(em, ticket_type) for em in employees for ticket_type in ticket_types]
    print(data) # 打印: [('aa', 101), ('aa', 102), ('bb', 101), ('bb', 102)]


    # 将字典的key, value倒过来的写法：
    a_dict = {'a': 1, 'b': 2, 'c': 3}
    # python3 的写法:
    b_dict = {value:key for key, value in a_dict.items()}
    # python2 时的写法(python2.6及其以下还没有推导字典的写法,python2.7版本开始支持)：
    b_dict = {}
    for key, value in a_dict.iteritems():
        b_dict[value] = key
    print(b_dict) # key与value翻转, 打印: {1:'a', 2:'b', 3:'c'}

    说明:
    注意原来的列表并没有发生变化。
    在很多时候, 我们都是使用循环来处理列表中的每一个元素, 而使用列表综合可以用一种更加精确、简洁、清楚的方法完成相同的工作。

    小心 list 的 += 操作(python2时可以用, python3不可以再这样用)

集合
    Python3 开始有这写法,跟之前的差不多,只是用大括号括起来,如： a = {1, 'aa', 3, 5, 6}
    集合同样可以使用综合计算, 如： a = {x for x in range(10) if x % 2 == 0}

    注意这种集合会自动去重
    my_set = {1, 2, 1, 2, 3, 4}
    print(my_set) # 打印:{1, 2, 3, 4}
    # 相当于 set([1, 2, 3, 4])


成员测试 in, not in
    检查是否包含有此内容,返回 True 或者 False, 例如：

    # 1.对字符串
    if 'a' in 'Swaroop':
        print('Yes, it contains the string "a"')

    # 2.对集合(列表、元组和字典)
    if 'genre' in ('genre', 'jazz'):
        print('Yes, it contains the genre')
    print('genre' in ('genre', 'jazz')) # 元组,打印： True
    print('genre' in ['genre', 'jazz']) # 列表,打印： True
    print('genre' in {'genre':'sss', 'jazz':'dddd'}) # 字典,检查key, 打印： True
    print('sss' in {'genre':'sss', 'jazz':'dddd'}) # 字典,打印： False


排序
    1.sort方法
      Python语言内置了 sort 方法, 可以很方便地对某个List进行排序
      例如：
        L = [6, 5, 1, 3, 4, 2]
        L.sort()
        print(L) # 打印：[1, 2, 3, 4, 5, 6]
        li=[(2,'a'),(4,'b'),(1,'d')]
        li.sort() # 元组列表排序
        print(li) # 打印： [(1, 'd'), (2, 'a'), (4, 'b')]

      # list 的排序
        方法1.用List的内建函数 list.sort 进行排序
            list.sort(func=None, key=None, reverse=False)
            参数 reverse=True 则是倒序,否则从低到高排序

        方法2.用序列类型函数 sorted(list[, cmp[, key[, reverse]]]) 进行排序（从2.4开始）

            # 范例1
            l1 = [2,5,1]
            l2 = sorted(l1) # l2 是排序后的 l1,但 l1 不变
            print(l2) # 打印: [1,2,5]
            print(l1) # 打印: [2, 5, 1]
            l1.sort() # 使用 list 内建排序函数,会直接改变 l1,但没有返回值
            print(l1) # 打印: [1, 2, 5]

        sorted(list)返回一个对象，可以用作表达式。原来的 list 不变，生成一个新的排好序的 list 对象。
        list.sort() 不会返回对象，改变原有的 list 。


    2.list.sort() 排序(例如, 按关键词的权重排序, 按人的年龄排序, 等等)
      若List中每个元素都是2-tuple, tuple中第一个元素为String类型的keyword, 第二个元素为该字符串对应的权重(int类型), 希望按照权重排序(从高到低), 则可以这样：

        L = [('b', 1), ('a', 0), ('c', 2), ('d', 3)]
        # L.sort(lambda x, y: -cmp(x[1], y[1])) # cmp函数里面是需比较的两个值, 负号表示倒序。(python2 的写法)
        L.sort(key=lambda d:-d[1]) # Python3的写法, 由于去掉了cmp()函数,得传入key参数； python2也可以这样用；负号表示倒序
        print(L) # 打印：[('d', 3), ('c', 2), ('b', 1), ('a', 0)]

        效率比较:  key > cmp
        所以建议使用 key 的方式,且这方式 py2 和 py3 都适用

        # list 里面是 dict 的排序:
        L1 = [
            {'softname':'7','version':'1.2.2.2'},
            {'softname':'1','version':'1.2.2.2'},
            {'softname':'5','version':'1.2.2.2'},
        ]
        L1.sort(key=lambda obj:obj.get('softname'), reverse=False) # 按 dict 里面的某个值排序


    3.dict排序
      对字典的排序, 因为每一个项包括一个键值对, 所以要选择可比较的键或值进行排序
        sorted(iterable[, cmp[, key[, reverse]]])
        # cmp 和 key 一般使用 lambda
        如：

        d={"ok":1,"no":2}
        # 对字典按键排序, 用元组列表的形式返回
        print(sorted(d.items(), key=lambda a:a[0])) # 打印： [('no', 2), ('ok', 1)]
        print(sorted(d)) # 打印：['no', 'ok']
        print(d) # 原字典并未改变, 打印：{'ok':1, 'no':2}
        # 对字典按值排序, 用元组列表的形式返回
        print(sorted(d.items(), key=lambda d:d[1])) # 打印：[('ok', 1), ('no', 2)]

        # 排序后再转成字典, 就无法再保证排序了
        b = sorted(d.items(), key=lambda v:v[0])
        print(b) # 打印： [('no', 2), ('ok', 1)]
        print(dict(b)) # (排序又乱了)打印： {'ok': 1, 'no': 2}


    4.类的排序
        class test:
            def __init__(self,a,b):
                self.a = a
                self.b = b

        test1 = test(5,25)
        test2 = test(50,35)
        test3 = test(10,15)
        tests = [test1, test2, test3]

        # 以 cmp 来指定排序方式, python3不可以这样写(没有cmp参数及cmp函数)
        result = sorted(tests,cmp = lambda x,y: cmp(x.a, y.a))
        # 遍历排序结果, 结果是已排序的： a:5  a:10  a:50
        for item in result:
            print("a:%s" % item.a)

        # 以 key 来排序, 结果也是可以的
        result2 = sorted(tests,key = lambda d:d.a)
        for item in result2:
            print("a:%s" % item.a)

        # 遍历原资料, 原资料的顺序没有改变
        for item in tests:
            print("a:%s" % item.a)

    5.注意：
      python3 由于去掉了 cmp() 函数, 可以用“(a > b) - (a < b)”代替“ cmp(a, b) ”

    6.冒泡算法, 如下：
        num = [23,2,3,6,18,9,33,13,24,19]
        for i in range(len(num)-1):
            for j in range(len(num)-i-1):
                if (num[j] > num[j+1]):
                    num[j], num[j+1] = num[j+1], num[j] # 置换, 这样写比较简便, 不需再用临时变量
        print(num)


综合实例：
﻿    在Python中对列表, 元组, 字典等内置的数据结构的处理是很方便的事情, python借鉴了Lisp中的很多函数式计算的方法来处理列表, 可以极大的简化我们的代码。
    1. set():  将元组, 列表 转化成没有重复项的集合
    2. list(): 将集合, 元组转化成列表
    3. tuple(): 将集合, 列表转化成元组

    4. map(func,list):将list的每一个元素传递给func的函数, 这个函数有一个参数, 且返回一个值, map将每一次调用函数返回的值组成一个新列表返回
    5. filter(func,list):将list的每一个元素传递给func的函数, 这个函数有一个参数, 返回bool类型的值, filter将返回True的元素组成新列表返回
    6. reduce(func,list):将list的元素, 挨个取出来和下一个元素通过func计算后将结果和再下一个元素继续计算


    一、列表去重
        ls = [1,3,2,5,2,1,3,4,6]
        ls = list(set(ls)) # 最简单的列表去除重复

        L = [1, 8, 3, 4, 6, 2, 3, 4, 5]
        kk = [x for x in L if x not in locals()['_[1]']] # 保留原顺序的去除重复,只有 2.6 上可以, 2.7 以上版本不能这样写
        # '_[1]' 是个内部临时变量, 可查看:  [x for x, y in locals().items()]


    二、假如有列表：
        books = [
            {"name":"C#从入门到精通",  "price":23.7,  "store":"卓越"},
            {"name":"ASP.NET高级编程", "price":44.5,  "store":"卓越"},
            {"name":"C#从入门到精通",  "price":24.7,  "store":"当当"},
            {"name":"ASP.NET高级编程", "price":45.7,  "store":"当当"},
            {"name":"C#从入门到精通",  "price":26.7,  "store":"新华书店"},
            {"name":"ASP.NET高级编程", "price":55.7,  "store":"新华书店"},
        ]

        2.1 求《ASP.NET高级编程》价格最便宜的店：
        storename=min([b for b in books if b['name']=="ASP.NET高级编程"],key=lambda b:b['price'])["store"]
        过程：先用列表解析取出《ASP.NET高级编程》的列表, 通过min函数, 比较字典的price键获取price最小的项


        2.2 求在新华书店购买两本书一样一本要花的钱：
        price=sum([b['price'] for b in books if b['store']=="新华书店"])


        2.3 求列表中有那几本书：
        booknames=list(set([b['name'] for b in books]))


        2.4 列表里的书都打5折：
        books=map(lambda b:dict(name=b['name'],price=b['price']*0.5,store=b['store']),books)


        2.5 《C#从入门到精通》的平均价格：
        avg=(lambda ls:sum(ls)/len(ls))([b['price'] for b in books if b['name']=="C#从入门到精通"])


        2.6 求每本书的平均价格：
        book_avg=map(lambda bookname:dict(name=bookname,avg=(lambda ls:sum(ls)/len(ls))([b['price'] for b in books if b['name']==bookname])),list(set([b['name'] for b in books])))

        这段代码放在一行比较难看懂, 但是格式化一下就很好懂了, 构建的过程如下：

            step1: 要求每本书的平均价格, 首先要得到共有几本书, 方法见2.3, 得到去重的书名列表
            list(set([b['name'] for b in books])) #去重后的书名列表

            step2: 要求每一本书的均价, 需要将计算均价的函数映射到每一本书上, 于是
            map(
                #计算均价的函数,
                list(set([b['name'] for b in books])) #去重后的书名列表
            )

            step3: 加入计算单本书均价的函数, 参考2.5的方法, 由于只用一行, 所以用lambda来搞定：
            func=lambda bookname:(lambda ls:sum(ls)/len(ls))([b.price for b in books if b['name']==bookname])

            step4: 将计算单本均价的lambda函数加入map中, 得到最终结果：
            经过格式化后的结果, 前面的单行代码可以格式化为下面容易阅读的形式
            book_avg=map(
                lambda bookname:
                    dict(
                        name = bookname,
                        # 计算单本书均价的函数
                        avg  = (lambda ls:sum(ls)/len(ls)) ([b['price'] for b in books if b['name']==bookname])
                    ),
                #去重后的书名列表
                list(
                     set(
                         [b['name'] for b in books]
                     )
                )
            )


列表使用中途,修改列表长度问题
    ### list, set, dict 都会有此问题。 使用的中途不应该随意修改长度,否则极容易出问题。 ###

    # 示例1,列表使用中途,修改列表长度
    odd = lambda x : bool(x % 2)
    numbers = [n for n in range(10)]
    for i in range(len(numbers)):
        if odd(numbers[i]):
            del numbers[i]  # 这一行会运行到第5次时抛异常,下标越界


    # 示例2,正确写法,重新用一个列表保存
    odd = lambda x : bool(x % 2)
    numbers = [n for n in range(10)]
    numbers[:] = [n for n in numbers if not odd(n)]  # 完美地修改了列表,而且连引用地址都没变
    #numbers = [n for n in numbers if not odd(n)] # 这样写法虽然也可以接收,但这会变成另外一个引用地址, id(numbers) 的值变了
    print numbers # 打印:[0, 2, 4, 6, 8]
