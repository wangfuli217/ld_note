heapq - 堆排序算法
heap是一个类似于树状的数据结构,每个直接的都有个排序好的父节点.
max-heap保证父节点比其任何子节点大, min-heap则要求父节点比其任何子节点小. heapq实现了min-heap
# 创建
    heapq有两种方式创建:
        heapq.heappush
    
        import heapq
        from heapq_showtree import show_tree
        from heapq_heapdata import data
        
        heap = []
        print('random :', data)
        print()
        
        for n in data:
            print('add {:>3}:'.format(n))
            heapq.heappush(heap, n)
            show_tree(heap)
    
        heapq.heapify
    
        import heapq
        from heapq_showtree import show_tree
        from heapq_heapdata import data
        
        print('random    :', data)
        heapq.heapify(data)
        print('heapified :')
        show_tree(data)

# 访问元素
    heappop()方法用于删除最小的元素值
        import heapq
        from heapq_showtree import show_tree
        from heapq_heapdata import data
        
        print('random    :', data)
        heapq.heapify(data)
        print('heapified :')
        show_tree(data)
        print
        
        for i in range(2):
            smallest = heapq.heappop(data)
            print('pop    {:>3}:'.format(smallest))
            show_tree(data)
            
# heapreplace()方法用于替换最小的元素值
    import heapq
    from heapq_showtree import show_tree
    from heapq_heapdata import data
    
    heapq.heapify(data)
    print('start:')
    show_tree(data)
    
    for n in [0, 13]:
        smallest = heapq.heapreplace(data, n)
        print('replace {:>2} with {:>2}:'.format(smallest, n))
        show_tree(data)
    
    # 输出
    random    : [19, 9, 4, 10, 11]
    heapified :
    
# nlargest() 和 nsmallest()可用于检索heapq中最大或最小的n个元素
    import heapq
    from heapq_heapdata import data
    
    print('all       :', data)
    print('3 largest :', heapq.nlargest(3, data))
    print('from sort :', list(reversed(sorted(data)[-3:])))
    print('3 smallest:', heapq.nsmallest(3, data))
    print('from sort :', sorted(data)[:3])
    
    # 输出
    all       : [19, 9, 4, 10, 11]
    3 largest : [19, 11, 10]
    from sort : [19, 11, 10]
    3 smallest: [4, 9, 10]
    from sort : [4, 9, 10]