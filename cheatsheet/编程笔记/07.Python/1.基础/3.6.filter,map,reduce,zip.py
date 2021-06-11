
Python 内建函数之 —— filter, map, reduce, zip

1、 filter(bool_func, seq):
    此函数的功能相当于过滤器。
    调用一个布尔函数 bool_func 来迭代遍历每个 seq 中的元素；返回一个使 bool_seq 返回值为 True 的元素的序列。

  例如：
    li = filter(lambda x : x%2 == 0, [1,2,3,4,5])
    print(li) # 打印: [2, 4]
    print(list(li)) # py3.x时需要这样打印

    l2 = filter(lambda x : x.isdigit(), '0ab12cd34')
    print(l2) # 打印: 01234

    l3 = filter(None, '0ab12cd34')
    print(l3) # 打印: 0ab12cd34


  filter 内建函数的 Python2.x 实现:
    # 注: py3.x 返回的是 filter 类, 不再是直接返回 list, 需要遍历才能获取到具体值
    def filter(bool_func, seq):
        if bool_func is None: return seq
        return [item for item in seq if bool_func(item)]


2、 map(func, seq1[, seq2...]):
    将函数 func 作用于给定序列的每个元素，并用一个列表来提供返回值；
    如果 func 为 None ，func 表现为身份函数，返回一个含有每个序列中元素集合的n个元组的列表。
    如果有其他可迭代的参数，函数 func 必须采取许多参数应用于来自所有iterables项。

  例如：

    l1 = map(lambda x : x * 2, [1,2,3,4])
    print(l1) # 打印: [2, 4, 6, 8]
    print(list(l1)) # py3.x时需要这样打印

    l2 = map(lambda x : x * 2, [1,2,3,4,[5,6,7]])
    print(l2) # 打印: [2, 4, 6, 8, [5, 6, 7, 5, 6, 7]]

    l3 = map(lambda x : None, [1,2,3,4])
    print(l3) # 打印: [None, None, None, None]

    l4 = map(None, [1,2,3,4])
    print(l4) # 打印: [1,2,3,4]

    l5 = map(lambda x : x * 2, '0ab12cd34')
    print(l5) # 打印: ['00', 'aa', 'bb', '11', '22', 'cc', 'dd', '33', '44']

    l6 = map(lambda x,y : (x,y), [1,2,3,4], [5,6,7])
    print(l6) # 打印: [(1, 5), (2, 6), (3, 7), (4, None)]

    l7 = map(lambda x,y : (x,y), [1,2,3,4], 'abcde')
    print(l7) # 打印: [(1, 'a'), (2, 'b'), (3, 'c'), (4, 'd'), (None, 'e')]


  map 内建函数的 python2.x 实现:
    # 注: py3.x 返回的是 map 类, 不再是直接返回 list, 需要遍历才能获取到具体值
    # 下面是简化版的实现，只有一个 seq 时的情况，多个 seq 的情况没考虑
    def map(func, seq):
        if func is None: return seq
        return [func(item) for item in seq]


3、 reduce(func, seq[, init]):
    func 为二元函数，将 func 作用于 seq 序列的元素，每次携带一对（先前的结果以及下一个序列的元素），连续的将现有的结果和下一个值作用在获得的随后的结果上，最后减少我们的序列为一个单一的返回值；
    如果初始值 init 给定，第一个比较会是 init 和第一个序列元素而不是序列的头两个元素。

  例如：
    res1 = reduce(lambda x,y : x + y, [1,2,3,4])
    print(res1) # 打印: 10

    res2 = reduce(lambda x,y : x + y, [1,2,3,4], 10)
    print(res2) # 打印: 20


  reduce 内建函数的 python2.x 实现:
    # 注: py3.x 没有 reduce 内建函数
    def reduce(bin_func, seq, initial=None):
        lseq = list(seq)
        if initial is None:
            res = lseq.pop(0)
        else:
            res = initial
        for eachItem in lseq:
            res = bin_func(res,eachItem)
        return res


4、 zip([iterable, ...])
    把两个或多个序列中的相应项合并在一起，并以元组的格式返回它们，在处理完最短序列中的所有项后就停止。
    如果参数是一个序列，则zip()会以一元组的格式返回每个项。
    不带参数，它返回一个空列表。

  例如：
    res1 = zip([1,2,3],[4,5],[7,8,9])
    print(res1) # 打印: [(1, 4, 7), (2, 5, 8)]
    print(list(res1)) # py3.x时需要这样打印

    res2 = zip([1,2,3,4,5])
    print(res2) # 打印: [(1,), (2,), (3,), (4,), (5,)]

    res3 = zip()
    print(res3) # 打印: []

  使用示例
    number=['0', '1', '2', '3', '4', '5', '6', '7', '8', '9','.']
    translate=['零', '壹', '贰', '叁', '肆', '伍', '陆', '柒', '捌', '玖','点']
    dict1 = dict(zip(number,translate))

    print( zip(number,translate) ) # 打印: [('0', '零'), ('1', '壹'), ('2', '贰'), ('3', '叁'), ('4', '肆'), ('5', '伍'), ('6', '陆'), ('7', '柒'), ('8', '捌'), ('9', '玖'), ('.', '点')]
    print( dict1 ) # 打印: {'.': '点', '1': '壹', '0': '零', '3': '叁', '2': '贰', '5': '伍', '4': '肆', '7': '柒', '6': '陆', '9': '玖', '8': '捌'}

    str_numnum='3.1415926'
    mi = ''
    for item in str_numnum:
        mi += dict1[item]

    print( mi ) # 打印: 叁点壹肆壹伍玖贰陆


  zip 内建函数的 python2.x 实现:
    # 注: py3.x 返回的是 zip 类, 不再是直接返回 list, 需要遍历才能获取到具体值
    def zip(*seq):
        if not seq: return list()
        res = []
        for i in range(len(seq[0])):
            try:
                value = tuple(t_seq[i] for t_seq in seq)
                res.append(value)
            except IndexError: # 捕获数组下标越界错误
                break
        return res

