array - 固定类型数据的序列
array类似于list, 除了其元素类型必须是相同的基本类型.
# 初始化
    import array
    import binascii
    
    s = b'This is the array.'
    a = array.array('b', s)
    
    print('As byte string:', s)
    print('As array      :', a)
    print('As hex        :', binascii.hexlify(a))
    
    # 输出
    As byte string: b'This is the array.'
    As array      : array('b', [84, 104, 105, 115, 32, 105, 115, 32, 116, 104, 101, 32, 97, 114, 114, 97, 121, 46])
    As hex        : b'54686973206973207468652061727261792e'
    
    
# 操作
    import array
    import pprint
    
    a = array.array('i', range(3))
    print('Initial :', a)
    
    a.extend(range(3))
    print('Extended:', a)
    
    print('Slice   :', a[2:5])
    
    print('Iterator:')
    print(list(enumerate(a)))
    
    # 输出
    Initial : array('i', [0, 1, 2])
    Extended: array('i', [0, 1, 2, 0, 1, 2])
    Slice   : array('i', [2, 0, 1])
    Iterator:
    [(0, 0), (1, 1), (2, 2), (3, 0), (4, 1), (5, 2)]
    
    
# array提供了tobytes()和frombytes()方法用于byte和str(注意, 不是unicode str)之间的转换
    import array
    import binascii
    
    a = array.array('i', range(5))
    print('A1:', a)
    
    as_bytes = a.tobytes()
    print('Bytes:', binascii.hexlify(as_bytes))
    
    a2 = array.array('i')
    a2.frombytes(as_bytes)
    print('A2:', a2)
    
    # 输出
    A1: array('i', [0, 1, 2, 3, 4])
    Bytes: b'0000000001000000020000000300000004000000'
    A2: array('i', [0, 1, 2, 3, 4])