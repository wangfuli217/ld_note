    对一个对象的弱引用。相对于通常的引用来说，如果一个对象有一个常规的引用，它是不会被垃圾收集器销毁的，
但是如果一个对象只剩下一个弱引用，那么它可能被垃圾收集器收回。
    并非所有的对象都支持weakref，例如list和dict就不支持，但是文档中介绍了可以通过继承dict来支持weakref。
    
    
weakref模块具有的方法
    1. class weakref.ref(object[, callback]) 
    创建一个弱引用对象，object是被引用的对象，callback是回调函数（当被引用对象被删除时的，会调用改函数）。
    
    2.weakref.proxy(object[, callback]) 
    创建一个用弱引用实现的代理对象，参数同上。
    
    3.weakref.getweakrefcount(object) 
    获取对象object关联的弱引用对象数
    
    4.weakref.getweakrefs(object)
    获取object关联的弱引用对象列表
    
    5.class weakref.WeakKeyDictionary([dict]) 
    创建key为弱引用对象的字典
    
    6.class weakref.WeakValueDictionary([dict]) 
    创建value为弱引用对象的字典
    
    7.class weakref.WeakSet([elements]) 
    创建成员为弱引用对象的集合对象


weakref模块具有的属性
    1.weakref.ReferenceType  -------- 被引用对象的类型
    2.weakref.ProxyType        --------- 被代理对象（不能被调用）的类型
    3.weakref.CallableProxyType -- 被代理对象（能被调用）的类型
    4.weakref.ProxyTypes      ---------- 所有被代理对象的类型序列
    5.exception weakref.ReferenceError
    
引用对象销毁时的回调函数
    是在建立弱引用的时候指定一个回调函数，一旦自己引用的对象被销毁，将会调用这个回调函数。
    # -*- coding: cp936 -*-
    import weakref

    class TestObj:
        pass
    
    def test_func(reference):
        print 'Hello from Callback function!'
        print reference, 'This weak reference is no longer valid'
    
    a = TestObj()
    #建立一个a的弱引用
    x = weakref.ref(a, test_func)
    del a
        
代理Proxy
    使用代理和使用普通weakref的区别就是不需要()，可以像原对象一样地使用proxy访问原对象的属性。
    # -*- coding: cp936 -*-
    import weakref
    
    class TestObj:
        def __init__(self):
            self.test_attr = 100
    
    def test_func(reference):
        print 'Hello from Callback function!'
    
    a = TestObj()
    #建立一个对a的代理(弱引用)
    x = weakref.proxy(a, test_func)
    print a.test_attr
    print x.test_attr
    del a
    
del和垃圾回收
    del命令删除的是变量名称, 而不是对象. Python中的垃圾回收采用的是引用计数的算法.
    弱引用不会添加对对象的引用计数. weakref模块
    
    >>> import weakref
    >>> s1 = {1, 2, 3}
    >>> s2 = s1
    >>> def bye():
    ... print('Gone with the wind...')
    ...
    >>> ender = weakref.finalize(s1, bye)
    >>> ender.alive
    True
    >>> del s1
    >>> ender.alive
    True
    >>> s2 = 'spam'
    Gone with the wind...
    >>> ender.alive
    False


