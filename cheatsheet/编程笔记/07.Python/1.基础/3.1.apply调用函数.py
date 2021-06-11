
使用 apply 函数,调用其它函数

    此函数在 3.x 中已经去掉, 只在 1.x 和 2.x 中有。
    其实真的未必有用。因为 python 允许直接调用函数。

    apply(func [, args [, kwargs ]]) 函数用于当函数参数已经存在于一个元组或字典中时，间接地调用函数。
        args 是一个包含将要提供给函数的按位置传递的参数的元组。如果省略了args，任何参数都不会被传递。
        kwargs 是一个包含关键字参数的字典。

    apply()的返回值就是 func()的返回值, apply()的元组参数是有序的，元素的顺序必须和func()形式参数的顺序一致。


    1.执行没有带参数的函数
        def say():
            print 'say in'

        # say()
        apply(say)  # 打印: say in


    2.函数只带元组的参数
        def say(a, b):
            print a, b

        # say("hello", "老王python")
        apply(say,("hello", "老王python")) # 打印: hello 老王python

    3.函数带关键字参数

        def say(a=1, b=2):
            print a,b

        # say()
        apply(say) # 使用默认值,打印: 1 2
        # say(a='a', b='b')
        apply(say,(),{'a' : 'a', 'b' : 'b'})  # 使用参数，打印: a b
        # say(3, b='b')
        apply(say,(3,),{'b' : 'b'})  # 使用参数，打印: 3 b


        def say2(a, b):
            print a,b

        # say2(1,  'b')
        apply(say2,(1,),{'b' : 'b'})  # 使用参数，打印: 1 b


    4.使用 apply 函数调用基类的构造函数，实现继承

        class Rectangle:
            def __init__(self, color="white", width=10, height=10):
                print "create a", color, self, "sized", width, "x", height

        class RoundedRectangle(Rectangle):
            def __init__(self, **kw):
                #Rectangle.__init__(self, **kw)
                apply(Rectangle.__init__, (self,), kw) # 父类的初始化,需手动写；Python不会自动调用父类的构造函数

        rect = Rectangle(color="green", height=100, width=100) # 打印: create a green <Rectangle instance at 8c8260> sized 100 x 100
        rect = RoundedRectangle(color="blue", height=20) # 打印: create a blue <RoundedRectangle instance at 8c84c0> sized 10 x 20


