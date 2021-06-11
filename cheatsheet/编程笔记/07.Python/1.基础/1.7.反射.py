
反射(自省)
    dir([obj])  # 调用这个方法将返回包含obj大多数属性名的列表（会有一些特殊的属性不包含在内，连父类的属性也包含在内）。obj的默认值是当前的模块对象。
    vars([obj]) # 这个方法将返回obj当前属性及其值的字典(不包含父类的属性及静态属性)。 obj默认值是当前模块对象,即没有参数是返回 local()。
    type(obj) # 返回对象的类型。返回值是一个类型对象。

    hasattr(obj, attr) # 这个方法用于检查obj是否有一个名为attr的值的属性，返回一个布尔值。
    getattr(obj, attr[, default]) # 调用这个方法将返回obj中名为attr的属性对象，或者名为attr的函数, 例如如果attr为'bar'，则返回obj.bar。
    setattr(obj, attr, val) # 调用这个方法将给obj的名为attr的值的属性赋值为val。例如如果attr为'bar'，则相当于obj.bar = val。
    callable(obj) # 如果传入的参数是可以调用的对象或函数，则返回 True, 否则返回 False 。

    例：
        # 测试类
        class Cat(object):
            def __init__(self, name='kitty'):
                self.name = name
            def sayHi(self): #  实例方法，sayHi指向这个方法对象，使用类或实例.sayHi访问
                print(self.name + 'says Hi!') # 访问名为name的字段，使用实例.name访问


        cat = Cat('kitty2')
        print(dir(cat)) # 获取实例的属性名，以列表形式返回
        if hasattr(cat, 'name'): # 检查实例是否有这个属性
            setattr(cat, 'name', 'tiger') # 相当于: cat.name = 'tiger'
        print(getattr(cat, 'name')) # 相当于: print(cat.name)

        getattr(cat, 'sayHi')() # 相当于: cat.sayHi()


        # 下面这段代码列出对象的所有函数或可调用的对象：
        methodList = [method for method in dir(cat) if callable(getattr(cat, method))]

        # globals() 返回一个map，这个map的key是全局范围内对象的名字，value是该对象的实例。
        globals().get('Cat')()  # 相当于执行: Cat();   注意，这用法需要导入相应的类，如果不导入，则会抛出异常。

        # 解决不能直接导入的问题，使用动态导入
        module = __import__('test_lib') # 导入模组, 多重的导入照样使用点运算符, 如: module = __import__('test_lib.test')
        parser = getattr(module, 'test_fun')  # 获取模组里面的对象,可以是函数或者属性或者类
        test_attr = getattr(module, 'test_attr')
        parser()  # 获取模组里面的对象如果是函数或者类，可直接调用
        print(test_attr) # 调用模组里面的属性
        print(dir(module)) # 列表模组里面的所有内容


    http://www.cnblogs.com/huxi/archive/2011/01/02/1924317.html
    http://blog.csdn.net/lokibalder/article/details/3459722


callable 函数的用法:
    可以检查一个对象是否是可调用的 (无论是直接调用或是通过 apply). 对于函数, 方法, lambda 函式, 类, 以及实现了 __call__ 方法的类实例, 它都返回 True.

    范例
        def dump(function):
            if callable(function):
                print function, "is callable"
            else:
                print function, "is *not* callable"

        class A:
            def method(self, value):
                return value

        class B(A):
            def __call__(self, value):
                return value

        a = A()
        b = B()

        dump(0) # simple objects, 打印: 0 is *not* callable
        dump("string") # 打印: string is *not* callable
        dump(callable) # function, 打印: <built-in function callable> is callable
        dump(dump) # 打印: <function dump at 0x00685B70> is callable

        dump(A) # classes, 打印: __main__.A is callable
        dump(B) # 打印: __main__.B is callable
        dump(B.method) # 打印: <unbound method B.method> is callable

        # A,B 两个类的区别
        # 类对象 (A 和 B) 都是可调用的; 如果调用它们, 就产生新的对象(类实例). 但是 A 类的实例不可调用, 因为它的类没有实现 __call__ 方法.
        dump(a) # instances, 打印: <__main__.A instance at 0x01C2F0D0> is *not* callable
        dump(a.method) # 打印: <bound method A.method of <__main__.A instance at 0x0095F0D0>> is callable
        dump(b) # 打印: <__main__.B instance at 0x01C2F0F8> is callable
        dump(b.method) # 打印: <bound method B.method of <__main__.B instance at 0x01C2F0F8>> is callable



