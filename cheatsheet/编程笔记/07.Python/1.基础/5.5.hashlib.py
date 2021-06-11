    hashlib模块封装了md5和sha模块, 形成一致的API. 想使用特定的哈希算法, 可以使用合适的构造函数来创建一个哈希对象. 
不管具体使用了什么样的哈希算法, 都可以使用相同的API来操作.
hashlib是基于OpenSSL的, 库中提供的所有算法应该是可用的, 包括:
    md5()
    sha1()
    sha224()
    sha256()
    sha384()
    sha512()
    
MD5例子
    计算一块数据(这里是一个ASCII字符串)的MD5摘要, 创建哈希, 增加数据, 然后计算摘要.
    import hashlib
    
    from hashlib_data import lorem
    
    h = hashlib.md5()
    h.update(lorem)
    print h.hexdigest()
    这个例子使用了hexdigest()方法而不是digest()方法, 这样可让输出结果可打印出来. 如果想获得二进制的摘要值, 你可以使用digest().
    
SHA1例子
    对刚才相同的数据产生一个SHA1摘要, 其计算过程是类似的:
    import hashlib
    from hashlib_data import lorem
    
    h = hashlib.sha1()
    h.update(lorem)
    print h.hexdigest()
    
new()
    有时候, 通过一个字符串形式的名字来引用算法, 而不是直接使用构造函数, 这可能在使用时更加方便. 例如, 
可以在一个配置文件中存储哈希类型. 在这些情况下, 我们可以直接使用new()函数来创建一个新的哈希计算器.
    import hashlib
    import sys
    
    try:
        hash_name = sys.argv[1]
    except IndexError:
        print 'Specify the hash name as the first argument.'
    else:
        try:
            data = sys.argv[2]
        except IndexError:
            from hashlib_data import lorem as data
    
        h = hashlib.new(hash_name)
        h.update(data)
        print h.hexdigest()
        
        
$ python hashlib_new.py sha1 
ac2a96a4237886637d5352d606d7a7b6d7ad2f29 
$ python hashlib_new.py sha256 
88b7404fc192fcdb9bb1dba1ad118aa1ccd580e9faa110d12b4d63988cf20332 
$ python hashlib_new.py sha512 
f58c6935ef9d5a94d296207ee4a7d9bba411539d8677482b7e9d60e4b7137f68d25f9747cab62fe752ec5ed1e5b2fa4cdbc8c9203267f995a5d17e4408dccdb4 
$ python hashlib_new.py md5 
c3abe541f361b1bfbbcfecbf53aad1fb