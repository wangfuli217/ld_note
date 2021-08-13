collections.abc模块中有Mapping和MutableMapping这两个抽象基类，它们的作用是为dict和其他类似的类型定义形式接口。
>>> my_dict = {}
>>> isinstance(my_dict, collections.Mapping)
>>> True
1. 可散列的数据：__hash__()和__eq__()方法。 原子不变数据类型str bytes 数值类型 frozenset可散列。
   元组的话：只有当一个元组包含的所有元素都是可散列类型的情况下，它才是可散列的。
   tt = (1,2,(30,40)); hash(tt)  # 8027212646858338501
   tl  = (1,2,[30, 40]);  hash(tl)  # TypeError
   tz = (1 ,2, frozenset([30, 40])); hash(tz)  # -4118419923444501110
2. 元组本身是不可变序列，它里面的元素可能是其他可变的类型的引用。
3. 一般来讲用户自定义的类型的对象都是可散列的，散列值就是它们的id()函数的返回值。

dict初始化
    a = dict(one=1, two=2, three=3)
    b = {'one': 1, 'two': 2, 'three': 3}
    c = dict(zip(['one', 'two', 'three'], [1, 2, 3]))
    d = dict([('two', 2), ('one', 1), ('three', 3)])
    e = dict({'three': 3, 'one': 1, 'two': 2})

dict推导
    DIAL_CODE = [
        (86, 'China'),
        (91, 'India'),
        (7, 'Russia'),
        (81, 'Japan'),
    ]
    country_code = {country:code for code, country in DIAL_CODE}
    country_code = {country.upper:code for code, country in DIAL_CODE}

d.update(m, [**kargs]) 鸭子类型
    函数首先检查m是否有keys方法，如果有，那么update函数就把它当做映射对象来处理。
    否则，函数会退一步，转而把m当做包含了键值对(key,value)元素的迭代器。
    
    Python中有多此逻辑：你既可以用一个映射对象来新建一个映射对象，也可以用包含(key, value)元素
    的可迭代对象来初始化一个映射对象。
4. Python 信奉"快速失败"哲学
5. Python的特点是'简单而正确'
用sedefault处理找不到的键
    index0.py # 查找文件中单词的出现位置
              # 从索引中获取单词出现的频率信息，并把它们写进对应的列表里。
    从 get (index0.py)
    occurrences = index.get(word, [])  # <1>
    occurrences.append(location)       # <2>
    index[word] = occurrences          # <3>
    到 setdefault (index.py)
    index.setdefault(word, []).append(location)
    
defaultdict 处理找不到的键的一个选择 -> __missing__
    dd = defaultdict(list)
    如果键'net-key'在dd中还不存在的话，表达式dd['new-key']会按照以下步骤来行事。
    1. 调用list()来创建一个新列表
    2. 把这个新列表作为值，'new-key'作为它的键，放在dd中。
    3. 返回这个列表的引用
    而这个用来生成默认值的可调用对象存放在名为default_factory的实例属性里。
    index_default.py # 利用defaultdict实例而不是setdefault方法。
    如果在创建defaultdict的时候没有指定default_factory，查询不存在的键会触发KeyError。
        注意：只会在__getitem__()里被调用，dd.get(k)则会返回None。
特殊方法__missing__
    1. 调用__getitem__()找不到键值的时候会调用__missing__()，而不是直接抛出一个KeyError异常。
    2. __missing__()方法对get和__contains__()没有影响。
    Pingo.io (raspberrry Pi) GPIO引脚以board.pins为名。
    strkeydict0.py -> dict # 在查询的时候把非字符串的键转换为字符串。
    strkeydict.py -> collections.UserDict
    
字典的变种
    collections.OrderedDict # 在添加键的时候会保持顺序，印次键的迭代次序总是一致的。
    collections.ChainMap    # 可以容纳数个不同的映射对象，然后在进行键查找操作的时候，这些对象会被逐个查找
    collections.Counter     # 给键准备一个整数计数器
    collections.UserDict    # 这个类其实就是把标准dict用纯Python又实现了一遍。
不可变映射类型
    from types import MappingProxyType
    d = {1:'A'}
    d_proxy = MappingProxyType(d)
    d_proxy[1]='B' # TypeError: 'mappingproxy' object does not support item assignment
    
    d[2] = 'B'
    print(d_proxy) # mappingproxy({1: 'A', 2: 'B'})
    
    d_proxy 是动态的, 也就是说对 d 所做的任何改动都会反馈到它上面.
dict的实现及其导致的结果
    1. 键必须是可散列的；
        支持hash函数，并且通过__hash__()方法所得到的散列值是不变的。
        支持通过__eq__()方法来检测相等性
        如 a == b为真，则hash(a) == hash(b)也为真。
        所有用户自定义的对象默认都是可散列的，因为它们的散列值由id()来获取，而且它们都是不相等的。
    2. 字典在内存上的开销巨大
         用元组取代字典就能节省空间的原因有两个：
             避免了散列表所消耗的空间
             无需把记录中字段的名字在每个元素里都存一遍
    3. 键查询很快
    4. 键的次序取决于添加顺序
    5. 往字典里添加新键可能会改变已有键的顺序
    
集合set和frozenset
    集合里的元素必须是可散列的
    集合很消耗内存
    可以很高效地判断元素是否存在于某个集合
    元素的次序取决于被添加到集合里的次序
    往集合里添加元素，可能会改变集合里已有元素的次序