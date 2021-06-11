在python世界，拥有一个永恒的道，那就是“type”，请记在脑海中，type就是道。如此广袤无垠的python生态圈，都是由type产生出来的。

道生一，一生二，二生三，三生万物。
    道 即是 type
    一 即是 metaclass(元类，或者叫类生成器)
    二 即是 class(类，或者叫实例生成器)
    三 即是 instance(实例)
    万物 即是 实例的各种属性与方法，我们平常使用python时，调用的就是它们。

道和一，是我们今天讨论的命题，而二、三、和万物，则是我们常常使用的类、实例、属性和方法，用hello world来举例：
    # 创建一个Hello类，拥有属性say_hello ----二的起源
    class Hello():
        def say_hello(self, name='world'):
            print('Hello, %s.' % name)
    
    
    # 从Hello类创建一个实例hello ----二生三
    hello = Hello()
    
    # 使用hello调用方法say_hello ----三生万物
    hello.say_hello()
    
    输出效果：
    Hello, world.
    
    这就是一个标准的“二生三，三生万物”过程。 从类到我们可以调用的方法，用了这两步。
    那我们不由自主要问，类从何而来呢？回到代码的第一行。
    class Hello其实是一个函数的“语义化简称”，只为了让代码更浅显易懂，它的另一个写法是：
    def fn(self, name='world'): # 假如我们有一个函数叫fn
        print('Hello, %s.' % name)
    
    Hello = type('Hello', (object,), dict(say_hello=fn)) # 通过type创建Hello class ---- 神秘的“道”，可以点化一切，这次我们直接从“道”生出了“二”
    
    这样的写法，就和之前的Class Hello写法作用完全相同，你可以试试创建实例并调用
    # 从Hello类创建一个实例hello ----二生三，完全一样
    hello = Hello()
    
    # 使用hello调用方法say_hello ----三生万物，完全一样
    hello.say_hello()
    
    输出效果：
    Hello, world. ----调用结果完全一样。
    
我们回头看一眼最精彩的地方，道直接生出了二：
    Hello = type('Hello', (object,), dict(say_hello=fn))
    这就是“道”，python世界的起源，你可以为此而惊叹。
    注意它的三个参数！暗合人类的三大永恒命题：我是谁，我从哪里来，我要到哪里去。
        第一个参数：我是谁。 在这里，我需要一个区分于其它一切的命名，以上的实例将我命名为“Hello”
        第二个参数：我从哪里来
            在这里，我需要知道从哪里来，也就是我的“父类”，以上实例中我的父类是“object”——python中一种非常初级的类。
        第三个参数：我要到哪里去
            在这里，我们将需要调用的方法和属性包含到一个字典里，再作为参数传入。以上实例中，我们有一个say_hello方法包装进了字典中。
    值得注意的是，三大永恒命题，是一切类，一切实例，甚至一切实例属性与方法都具有的。理所应当，
        它们的“创造者”，道和一，即type和元类，也具有这三个参数。但平常，类的三大永恒命题并不作为参数传入，而是以如下方式传入
    class Hello(object){
    # class 后声明“我是谁”
    # 小括号内声明“我来自哪里”
    # 中括号内声明“我要到哪里去”
        def say_hello(){
            
        }
    }
    造物主，可以直接创造单个的人，但这是一件苦役。造物主会先创造“人”这一物种，再批量创造具体的个人。并将三大永恒命题，一直传递下去。
    “道”可以直接生出“二”，但它会先生出“一”，再批量地制造“二”。
    type可以直接生成类（class），但也可以先生成元类（metaclass），再使用元类批量定制类（class）。
    
元类——道生一，一生二
    一般来说，元类均被命名后缀为Metalass。想象一下，我们需要一个可以自动打招呼的元类，它里面的类方法呢，有时需要say_Hello，有时需要say_Hi，有时又需要say_Sayolala，有时需要say_Nihao。
    如果每个内置的say_xxx都需要在类里面声明一次，那将是多么可怕的苦役！ 不如使用元类来解决问题。
    以下是创建一个专门“打招呼”用的元类代码：
    class SayMetaClass(type):
        def __new__(cls, name, bases, attrs):
            attrs['say_'+name] = lambda self,value,saying=name:sys.stdout.write(saying+','+value+'!')
            return type.__new__(cls, name, bases, attrs)
    记住两点：
    1、元类是由“type”衍生而出，所以父类需要传入type。【道生一，所以一必须包含道】
    2、元类的操作都在 __new__中完成，它的第一个参数是将创建的类，之后的参数即是三大永恒命题：我是谁，我从哪里来，我将到哪里去。 它返回的对象也是三大永恒命题，接下来，这三个参数将一直陪伴我们。
    在__new__中，我只进行了一个操作，就是
    attrs['say_'+name] = lambda self,value,saying=name: sys.stdout.write(saying+','+value+'!')
    
    它跟据类的名字，创建了一个类方法。比如我们由元类创建的类叫“Hello”，那创建时就自动有了一个叫“say_Hello”的类方法，然后又将类的名字“Hello”作为默认参数saying，传到了方法里面。然后把hello方法调用时的传参作为value传进去，最终打印出来。
    那么，一个元类是怎么从创建到调用的呢？
    来！一起根据道生一、一生二、二生三、三生万物的准则，走进元类的生命周期吧！
    
    # 道生一：传入type
    class SayMetaClass(type):
    
        # 传入三大永恒命题：类名称、父类、属性
        def __new__(cls, name, bases, attrs):
            # 创造“天赋”
            attrs['say_'+name] = lambda self,value,saying=name: print(saying+','+value+'!')
            # 传承三大永恒命题：类名称、父类、属性
            return type.__new__(cls, name, bases, attrs)
    
    # 一生二：创建类
    class Hello(object, metaclass=SayMetaClass):
        pass
    
    # 二生三：创建实列
    hello = Hello()
    
    # 三生万物：调用实例方法
    hello.say_Hello('world!')
    
    输出为
    Hello, world!
    
    注意：通过元类创建的类，第一个参数是父类，第二个参数是metaclass
    普通人出生都不会说话，但有的人出生就会打招呼说“Hello”，“你好”,“sayolala”，这就是天赋的力量。它会给我们面向对象的编程省下无数的麻烦。
    现在，保持元类不变，我们还可以继续创建Sayolala， Nihao类，如下：

    # 一生二：创建类
    class Sayolala(object, metaclass=SayMetaClass):
        pass
    
    # 二生三：创建实列
    s = Sayolala()
    
    # 三生万物：调用实例方法
    s.say_Sayolala('japan!')
    
    输出
    Sayolala, japan!
    
    也可以说中文
    # 一生二：创建类
    class Nihao(object, metaclass=SayMetaClass):
        pass
    
    # 二生三：创建实列
    n = Nihao()
    
    # 三生万物：调用实例方法
    n.say_Nihao('中华!')
    
    # 一生二：创建类
    class Nihao(object, metaclass=SayMetaClass):
        pass
    
    # 二生三：创建实列
    n = Nihao()
    
    # 三生万物：调用实例方法
    n.say_Nihao('中华!')
    
    输出
    Nihao, 中华!
    
    再来一个小例子：
    # 道生一
    class ListMetaclass(type):
        def __new__(cls, name, bases, attrs):
            # 天赋：通过add方法将值绑定
            attrs['add'] = lambda self, value: self.append(value)
            return type.__new__(cls, name, bases, attrs)
            
    # 一生二
    class MyList(list, metaclass=ListMetaclass):
        pass
        
    # 二生三
    L = MyList()
    
    # 三生万物
    L.add(1)
    
    现在我们打印一下L
    print(L)
    >>> [1]
    print(L)
    >>> [1]
    
    而普通的list没有add()方法
    L2 = list()
    L2.add(1)
    
    >>>AttributeError: 'list' object has no attribute 'add'
    L2 = list()
    L2.add(1)
    >>>AttributeError: 'list' object has no attribute 'add'
    
    太棒了！学到这里，你是不是已经体验到了造物主的乐趣？

# http://python.jobbole.com/88795/