collections是Python内建的一个集合模块，提供了许多有用的集合类。
    1. namedtuple(): 生成可以使用名字来访问元素内容的tuple子类
    2. deque: 双端队列，可以快速的从另外一侧追加和推出对象
    3. Counter: 计数器，主要用来计数
    4. OrderedDict: 有序字典
    5. defaultdict: 带有默认值的字典

namedtuple: # collections.namedtuple是一个工厂方法, 用于创建有字段(field)的tuple
>>>from collections import namedtuple
>>>Point = namedtuple('Point', ['x', 'y'])
>>>p = Point(1, 2)
>>>p.x
>>>p.y
    namedtuple是一个函数，它用来创建一个自定义的tuple对象，并且规定了tuple元素的个数，并可以用属性而
不是索引来引用tuple的某个元素。
# 和tuple一样, namedtuple也是不可变对象,
# namedtuple中字段名称不能和python关键词相同, 也不能重复.
    collections.namedtuple('Person', 'name class age')
    collections.namedtuple('Person', 'name age age')

#namedtuple提供了一个bool型的参数rename, 当设置为True时, 针对上述无效的字段名称会自动进行重命名,而不是抛出异常.
    with_class = collections.namedtuple( 'Person', 'name class age', rename=True) 
    print(with_class._fields) 
    two_ages = collections.namedtuple( 'Person', 'name age age', rename=True) 
    print(two_ages._fields)
特殊属性
    namedtuple内部有一些以下划线(_)开头的属性或方法, 具有些特殊的用途.
        _fields: 保存字段名称
        _asdict(): 将namedtuple转换成OrderedDict
        _replace(): 替换字段的值

deque: # 高效实现插入和删除操作的双向列表，适合用于队列和栈
>>> from collections import deque
>>> q = deque(['a', 'b', 'c'])
>>> q.append('x')
>>> q.appendleft('y')
>>> q
deque(['y', 'a', 'b', 'c', 'x'])

# list对象的这两种用法的时间复杂度是 O(n)。而使用deque对象则是 O(1) 的复杂度，
append,appendleft,pop,popleft,rotate,extendleft,extend
# deque另一个常用的方法是rotate(), 其可以将其中的元素轮转 rotate(2) rotate(-2)
# 基于rotate函数的动画效果
    import sys
    import time
    import collections
    fancy_loading = collections.deque('>--------------------')
    while True:
        print '\r%s' % ''.join(fancy_loading)
        fancy_loading.rotate(1)
        sys.stdout.flush()
        time.sleep(0.08)
# deque是线程安全的, 因此可以在不同线程中同步操作
    import collections
    import threading
    import time
    
    candle = collections.deque(range(5))
    def burn(direction, nextSource):
        while True:
            try:
                next = nextSource()
            except IndexError:
                break
            else:
                print('{:>8}: {}'.format(direction, next))
                time.sleep(0.1)
        print('{:>8} done'.format(direction))
        return
    
    left = threading.Thread(target=burn,
                            args=('Left', candle.popleft))
    right = threading.Thread(target=burn,
                            args=('Right', candle.pop))
    
    left.start()
    right.start()

# 限制队列长度
# deque可配置队列的最大长度. 当超过队列最大长度时, 现有元素就会被丢弃.
    d1 = collections.deque(maxlen=3) 
    d2 = collections.deque(maxlen=3)

defaultdict: # 使用dict时，如果引用的Key不存在，就会抛出KeyError。如果希望key不存在时，返回一个默认值，就可以用defaultdict
>>> from collections import defaultdict 
>>> dd = defaultdict(lambda: 'N/A') 
>>> dd['key1'] = 'abc' 
>>> dd['key1'] # key1存在 'abc' 
>>> dd['key2'] # key2不存在，返回默认值 'N/A'

OrderedDict: # 使用dict时，Key是无序的。在对dict做迭代时，我们无法确定Key的顺序。如果要保持Key的顺序，可以用OrderedDict
>>> from collections import OrderedDict
>>> d = dict([('a', 1), ('b', 2), ('c', 3)])
>>> d # dict的Key是无序的
{'a': 1, 'c': 3, 'b': 2}
>>> od = OrderedDict([('a', 1), ('b', 2), ('c', 3)])
>>> od # OrderedDict的Key是有序的
# 注意，OrderedDict的Key会按照插入的顺序排列，不是Key本身排序：
OrderedDict可以实现一个FIFO（先进先出）的dict，当容量超出限制时，先删除最早添加的Key：

# 等价性
    dict依据其元素及排序来确认两个dict的等价性, OrderedDict同样如此.
        import collections
        
        print('dict       :',)
        d1 = {}
        d1['a'] = 'A'
        d1['b'] = 'B'
        d1['c'] = 'C'
        
        d2 = {}
        d2['c'] = 'C'
        d2['b'] = 'B'
        d2['a'] = 'A'
        
        print(d1 == d2)
        
        print('OrderedDict:',)
        
        d1 = collections.OrderedDict()
        d1['a'] = 'A'
        d1['b'] = 'B'
        d1['c'] = 'C'
        
        d2 = collections.OrderedDict()
        d2['c'] = 'C'
        d2['b'] = 'B'
        d2['a'] = 'A'
        
        print(d1 == d2)		# 顺序不同, 因此不相等
        
        ## 输出
        dict       :
        True
        OrderedDict:
        False
        Counter: # Counter是一个简单的计数器，例如，统计字符出现的个数：
        
# 重排序
    OrderedDict提供了move_to_end()方法, 可用于移动元素位置
        import collections
        
        d = collections.OrderedDict(
            [('a', 'A'), ('b', 'B'), ('c', 'C')]
        )
        
        print('Before:')
        for k, v in d.items():
            print(k, v)
        
        d.move_to_end('b')
        
        print('\nmove_to_end():')
        for k, v in d.items():
            print(k, v)
        
        d.move_to_end('b', last=False)
        
        print('\nmove_to_end(last=False):')
        for k, v in d.items():
            print(k, v)
        
        # 输出
        Before:
        a A
        b B
        c C
        
        move_to_end():
        a A
        c C
        b B
        
        move_to_end(last=False):
        b B
        a A
        c C
        
>>> from collections import Counter
>>> c = Counter()
>>> for ch in 'programming':
...     c[ch] = c[ch] + 1
...
>>> c

collections.UserDict:　用于继承

# dict和set工作原理
    dict或set内部维护一致哈希表, 这是个稀疏矩阵, 由很多单元格组成. 每个单元格称之为bucket. 
    每个item对应一个bucket, bucket维护则对key的引用和对value的引用. 一般来说, Python要求
    哈希表中至少有1/3空闲的bucket, 如果太挤的话, 将会哈希表拷贝到更大的新空间中

    1. key一定是hashable对象, 满足如下要求:
        通过 __hash()__支持hash()函数调用, 且多次调用返回值相同(幂等)
        通过 __eq()__支持比较运算
        值相同的对象, 它们的哈希一定相同.
        用户定义的hashable对象, 当实现 __eq()__方法时, 一定要实现__hash()__方法
    2. dict会占用比较多的内存: 因为需要维护稀疏哈希表
    3. key查询很快速
    4. key顺序依赖插入顺序
    5. 往dict中添加item会变更现有key的排序
    
MappingProxyType # 不可变dict
python3.3中提供了一个新类: MappingProxyType, 是对原始dict的动态镜像: 当原始dict变更时, 能看到变更,但不能通过MappingProxyType修改原始dict

>>> from types import MappingProxyType
>>> d = {1: 'A'}
>>> d_proxy = MappingProxyType(d)
>>> d_proxy
mappingproxy({1: 'A'})
>>> d_proxy[1]
'A'
>>> d_proxy[2] = 'x'
Traceback (most recent call last):
File "<stdin>", line 1, in <module>
TypeError: 'mappingproxy' object does not support item assignment
>>> d[2] = 'B'
>>> d_proxy
mappingproxy({1: 'A', 2: 'B'})
>>> d_proxy[2]
'B'
>>>