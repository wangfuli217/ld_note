
标准库 itertools 模块是不应该忽视的宝藏。


chain 连接多个迭代器。
    import itertools
    it = itertools.chain(range(3), "abc")
    print(it) # <itertools.chain object at 0x01BBF1D0>
    print(list(it)) # [0, 1, 2, 'a', 'b', 'c']


combinations 返回指定⻓度的元素顺序组合序列。
    import itertools
    it = itertools.combinations("abcd", 2)
    print(list(it)) # 打印: [('a', 'b'), ('a', 'c'), ('a', 'd'), ('b', 'c'), ('b', 'd'), ('c', 'd')]
    it = itertools.combinations(range(4), 2)
    print(list(it)) # 打印: [(0, 1), (0, 2), (0, 3), (1, 2), (1, 3), (2, 3)]

combinations_with_replacement 会额外返回同一元素的组合。(python 3.x 才有)
    import itertools
    it = itertools.combinations_with_replacement("abcd", 2)
    print(list(it)) # 打印: [('a', 'a'), ('a', 'b'), ('a', 'c'), ('a', 'd'), ('b', 'b'), ('b', 'c'), ('b', 'd'), ('c', 'c'), ('c', 'd'), ('d', 'd')]


compress 按条件表过滤迭代器元素。(python 3.x 才有)
    import itertools
    # 条件列表可以是任何布尔列表。
    it = itertools.compress("abcde", [1, 0, 1, 1, 0])
    print(list(it)) # 打印:['a', 'c', 'd']


count 从起点开始, "无限" 循环下去。
    import itertools
    #for x in itertools.count(10, step=2): # (python 3.x 才有 step 参数, 表示间隔, 将打印: 10, 12, 14, 16, 18)
    for x in itertools.count(10): # 打印: 10 ~ 18
        print(x)
        if x > 17: break


cycle 迭代结束，再从头来过。
    import itertools
    for i, x in enumerate(itertools.cycle("abc")):
        print(x)
        if i > 7: break
    # 打印: a b c a b c a b c


dropwhile 跳过头部符合条件的元素。
    import itertools
    it = itertools.dropwhile(lambda i: i < 4, [2, 1, 4, 1, 3])
    print(list(it)) # 打印: [4, 1, 3]

takewhile 则仅保留头部符合条件的元素。
    import itertools
    it = itertools.takewhile(lambda i: i < 4, [2, 1, 4, 1, 3])
    print(list(it)) # 打印: [2, 1]


groupby 将连续出现的相同元素进⾏分组。
    import itertools
    print([list(k) for k, g in itertools.groupby('AAAABBBCCDAABBCCDD')]) # 打印: [['A'], ['B'], ['C'], ['D'], ['A'], ['B'], ['C'], ['D']]
    print([list(g) for k, g in itertools.groupby('AAAABBBCCDAABBCCDD')]) # 打印: [['A', 'A', 'A', 'A'], ['B', 'B', 'B'], ['C', 'C'], ['D'], ['A', 'A'], ['B', 'B'], ['C', 'C'], ['D', 'D']]

