itertools 模块提供的迭代器函数有以下几种类型：
    1. 无限迭代器：生成一个无限序列，比如自然数序列 1, 2, 3, 4, ...；
    2. 有限迭代器：接收一个或多个序列（sequence）作为参数，进行组合、分组和过滤等；
    3. 组合生成器：序列的排列、组合，求序列的笛卡儿积等；
    
# 1 无限迭代器
itertools 模块提供了三个函数（事实上，它们是类）用于生成一个无限序列迭代器：
    1.1 count(firstval=0, step=1)创建一个从 firstval (默认值为 0) 开始，以 step (默认值为 1) 为步长的的无限整数迭代器
    1.2 cycle(iterable)对 iterable 中的元素反复执行循环，返回迭代器
    1.3 repeat(object [,times]反复生成 object，如果给定 times，则重复次数为 times，否则为无限
1.1 count() 接收两个参数，第一个参数指定开始值，默认为 0，第二个参数指定步长，默认为 1
>>> import itertools
>>>
>>> nums = itertools.count()
>>> for i in nums:
...     if i > 6:
...         break
...     print i

>>> nums = itertools.count(10, 2)    # 指定开始值和步长
>>> for i in nums:
...     if i > 20:
...         break
...     print i

1.2 cycle() 用于对 iterable 中的元素反复执行循环:
>>> import itertools
>>>
>>> cycle_strings = itertools.cycle('ABC')
>>> i = 1
>>> for string in cycle_strings:
...     if i == 10:
...         break
...     print i, string
...     i += 1
1.3 repeat() 用于反复生成一个 object
>>> for item in itertools.repeat('hello world', 3):
...     print item
>>> for item in itertools.repeat([1, 2, 3, 4], 3):
...     print item

# 有限迭代器
itertools 模块提供了多个函数（类），接收一个或多个迭代对象作为参数，对它们进行组合、分组和过滤等：
    chain()          chain(iterable1, iterable2, iterable3, ...)
    compress()       compress(data, selectors)
    dropwhile()      dropwhile(predicate, iterable)
    groupby()        groupby(iterable[, keyfunc])
    ifilter()        
    ifilterfalse()   
    islice()         
    imap()           
    starmap()        
    tee()            
    takewhile()      
    izip()           
    izip_longest()   
2.1 chain 接收多个可迭代对象作为参数，将它们『连接』起来，作为一个新的迭代器返回。
>>> for item in chain([1, 2, 3], ['a', 'b', 'c']):
...     print item

chain 还有一个常见的用法：
chain.from_iterable(iterable)

接收一个可迭代对象作为参数，返回一个迭代器：

>>> from itertools import chain
>>> string = chain.from_iterable('ABCD')
>>> string.next()

>>> from itertools import chain
>>> string = chain.from_iterable('ABCD')
>>> string.next()

2.2 compress 可用于对数据进行筛选，当 selectors 的某个元素为 true 时，则保留 data 对应位置的元素，否则去除：
>>> from itertools import compress
>>> list(compress('ABCDEF', [1, 1, 0, 1, 0, 1]))
>>> list(compress('ABCDEF', [1, 1, 0, 1]))
>>> list(compress('ABCDEF', [True, False, True]))
2.3 dropwhile(predicate, iterable)
其中，predicate 是函数，iterable 是可迭代对象。对于 iterable 中的元素，如果 predicate(item) 为 true，则丢弃该元素，否则返回该项及所有后续项。
list(dropwhile(lambda x: x < 5, [1, 3, 6, 2, 1]))
list(dropwhile(lambda x: x > 3, [2, 1, 6, 5, 4]))
2.4 groupby(iterable[, keyfunc])
其中，iterable 是一个可迭代对象，keyfunc 是分组函数，用于对 iterable 的连续项进行分组，如果不指定，则默认对 iterable 中的连续相同项进行分组，返回一个 (key, sub-iterator) 的迭代器
>>> from itertools import groupby
>>>
>>> for key, value_iter in groupby('aaabbbaaccd'):
...     print key, ':', list(value_iter)
>>> data = ['a', 'bb', 'ccc', 'dd', 'eee', 'f']
>>> for key, value_iter in groupby(data, len):    # 使用 len 函数作为分组函数
...     print key, ':', list(value_iter)
>>> data = ['a', 'bb', 'cc', 'ddd', 'eee', 'f']
>>> for key, value_iter in groupby(data, len):
...     print key, ':', list(value_iter)
2.5 ifilter(function or None, sequence)
将 iterable 中 function(item) 为 True 的元素组成一个迭代器返回，如果 function 是 None，则返回 iterable 中所有计算为 True 的项。
>>> from itertools import ifilter
>>> list(ifilter(lambda x: x < 6, range(10)))
>>> list(ifilter(None, [0, 1, 2, 0, 3, 4]))
2.6 ifilterfalse(function or None, sequence)
from itertools import ifilterfalse
list(ifilterfalse(lambda x: x < 6, range(10)))
list(ifilter(None, [0, 1, 2, 0, 3, 4]))
2.7 islice(iterable, [start,] stop [, step])
其中，iterable 是可迭代对象，start 是开始索引，stop 是结束索引，step 是步长，start 和 step 可选。
from itertools import count, islice
list(islice([10, 6, 2, 8, 1, 3, 9], 5))
list(islice(count(), 6))
list(islice(count(), 3, 10))
list(islice(count(), 3, 10 ,2))
2.8 imap 类似 map 操作，它的使用形式如下：
imap(func, iter1, iter2, iter3, ...)
imap 返回一个迭代器，元素为 func(i1, i2, i3, ...)，i1，i2 等分别来源于 iter, iter2。
>>> from itertools import imap
>>> list(imap(str, [1, 2, 3, 4]))
>>> list(imap(pow, [2, 3, 10], [4, 2, 3]))
2.9 tee 的使用形式如下：
tee(iterable [,n])
tee 用于从 iterable 创建 n 个独立的迭代器，以元组的形式返回，n 的默认值是 2。
>>> from itertools import tee
>>> iter1, iter2 = tee('abcde')
>>> list(iter1)
>>> list(iter2)
2.10 takewhile 的使用形式如下：
takewhile(predicate, iterable)
其中，predicate 是函数，iterable 是可迭代对象。对于 iterable 中的元素，如果 predicate(item) 为 true，则保留该元素，只要 predicate(item) 为 false，则立即停止迭代。
>>> from itertools import takewhile
>>> list(takewhile(lambda x: x < 5, [1, 3, 6, 2, 1]))
>>> list(takewhile(lambda x: x > 3, [2, 1, 6, 5, 4]))

# 组合生成器
itertools 模块还提供了多个组合生成器函数，用于求序列的排列、组合等：
    product
    permutations
    combinations
    combinations_with_replacement
3.1 product 用于求多个可迭代对象的笛卡尔积，它跟嵌套的 for 循环等价。它的一般使用形式如下：
product(iter1, iter2, ... iterN, [repeat=1])
其中，repeat 是一个关键字参数，用于指定重复生成序列的次数，
from itertools import product
for item in product('ABCD', 'xy'):
    print item
>>> list(product('ab', range(3)))
>>> list(product((0,1), (0,1), (0,1)))
>>> list(product('ABC', repeat=2))
3.2 permutations
permutations 用于生成一个排列，它的一般使用形式如下：
permutations(iterable[, r])
其中，r 指定生成排列的元素的长度，如果不指定，则默认为可迭代对象的元素长度。
from itertools import permutations
list(permutations('ABC', 2))
list(permutations('ABC'))
3.3 combinations 用于求序列的组合，它的使用形式如下：
combinations(iterable, r)
其中，r 指定生成组合的元素的长度。
>>> from itertools import combinations
>>> list(combinations('ABC', 2))
