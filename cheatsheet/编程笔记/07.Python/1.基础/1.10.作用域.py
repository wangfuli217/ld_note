
作用域(scope)

Python 是静态作用域语言, 尽管它自身是一个动态语言。也就是说, 在Python中变量的作用域是由它在源代码中被赋值的位置决定的。

在 python 中, 只有模块, 类(class)以及函数(def, lambda)才会引入新的作用域, 其它的代码块是不会引入新的作用域的。
比如 if/elif/else, try/except/finally, for/while 等语句就没有作用域, 并不能涉及变量作用域的更改, 也就是说他们的代码块中的变量, 在外部也是可以访问的。

因此下面的代码是可以正常运行的:
    for i in range(0,10):
        pass
    print(i)

变量可以在3个不同的地方定义，对应三种不同的作用域：
    1. def内赋值定义的变量：作用域为本函数
        这里的赋值包括显式=赋值和隐式赋值。隐式赋值包括
            import语句隐式赋值
            def函数定义来隐式赋值（函数名这个变量）
            形参匹配来隐式赋值
    2. 嵌套的def中赋值定义的变量：对于父函数来说，该变量不是本地的
    3. def之外赋值，作用域为整个文件全局的
    global_val = 10 # 文件全局作用域
    def func(arg):
        func_var = 0 # 函数内作用域，同时arg也是隐式赋值的
        def inner_func():
            inner_var = 1 # 内层函数作用域

作用域法则
    每个模块文件就是一个全局作用域。从外面看，模块的全局变量就成为该模块对象的属性；从内部看，模块的全局变量就是普通的、作用域为全局的变量
    全局作用域的范围仅限于变量所在的单个文件
    每次调用函数，都创建一个新的局部作用域
    默认情况下，所有函数定义内部的变量都是局部变量
        global语句声明会将变量名作用域提升至全局
        nonlocal语句声明会将变量名作用域提升至外层的def
    Python预定义的_builtin_模块提供了一些预定义的内置变量
    gVar='gVar'
    def func(arg):
        fVar = 'localVar'
        global gVar
        gVar='gVar in func'
        

四种作用域(scope)介绍:
    local: 比如函数中的变量所在的作用域就是 local 的。简称L
    enclosing: 接着查找上一层def或lambda的本地作用域。简称E
    global: 当前模块中的全局作用域。简称G
    built-in: python内置作用域.简称B
    对某个变量搜索的顺序是: local > enclosing > global > built-in。也就是LEGB

    a=1
    b=2
    def func():
        global a,b,c
        a=2
        b=0
        c=1 # 虽然c没有在def外定义，但这里的global和c=1会在全局作用域内定义c
    print a,b,c
    
    x='global_x'          #全局作用域
    def f1():             
    x='f1_x'            #f1的局部作用域
    z='f1_z'            #f1的局部作用域
    def f2():
        global y      #全局作用域
        y='f2_y'
        print('in f2',x) #LGBE法则，找到的是f1局部作用域中的x
        nonlocal z    #f2的nonlocal作用域，是f1的局部作用域
        z='f2_z'
        t='f2_t'      #f2的本地作用域
    f2()
    
  python 发展史中的作用域变化:
    在Python 2.0及之前的版本中, 只支持3种作用域, 即局部作用域(local), 全局作用域(global), 内置作用域(built-in)；
    在Python 2.2中, Python正式引入了一种新的作用域 --- 嵌套作用域(enclosing)；
    在Python 2.1中, 嵌套作用域可以作为一个选项被开启；嵌套作用域的引入, 本质上为Python实现了对闭包的支持。
    相应地, 变量查找顺序由之前的LGB变成LEGB(L: Local, E: Enclosing, G: Global, B: Built-in)。


在Python中, 名字绑定在所属作用域中引入新的变量, 同时绑定到一个对象。名字绑定发生在以下几种情况之下:
    1.参数声明: 参数声明在函数的局部作用域中引入新的变量；
    2.赋值操作: 对一个变量进行初次赋值会在当前作用域中引入新的变量, 后续赋值操作则会重新绑定该变量；
    3.类和函数定义: 类和函数定义将类名和函数名作为变量引入当前作用域, 类体和函数体将形成另外一个作用域；
    4.import 语句: import 语句在当前作用域中引入新的变量, 一般是在全局作用域；
    5.for 语句: for 语句在当前作用域中引入新的变量(循环变量),但循环体内没有生成新的作用域；
    6.except 语句: except 语句在当前作用域中引入新的变量(异常对象),但异常代码块内不生成新的作用域。

    在Python中, 类定义所引入的作用域对于成员函数是不可见的, 这与C++或者Java是很不同的, 因此在Python中, 成员函数想要引用类体定义的变量, 必须通过 self 或者类名来引用它。
    嵌套作用域(闭包)的加入, 会导致一些代码编译不过或者得到不同的运行结果, 在这里Python解释器会帮助你识别这些可能引起问题的地方, 给出警告。
    locals 函数返回所有的局部变量, 但是不会返回嵌套作用域中的变量, 实际上没有函数会返回嵌套作用域中的变量。

    
嵌套的函数返回后也是有效的。
    def f1():
        x=99
        def f2():
            print(x)
        return f2   # f2是个局部变量，仅在f1执行期间因为新建了局部作用域所以才存在。
    action=f1()     # f2指向的函数对象，由于action引用它，因此不会被收回。
    #但是f2这个位于局部作用域中的变量名被销毁了
    action() #此时f1执行结束，但是f2记住了在f1嵌套作用域中的x。这种行为叫闭包
    类比闭包在语义上更明确，因为类可以明确定义自己的状态
    
在函数内部调用一个未定义的函数是可行的，只要在函数调用是，该未定义函数已定义即可。
    def func1():
        func2()
    func1() # NameError
    def func2()
        print('hello')
    func1() # hello

嵌套作用域中的变量在嵌套的函数调用时才进行查找，而不是定义时。 、
    def func():
        acts=[]
        for i in range(5):
            acts.append(lambda x:i**x) #添加匿名函数对象
        return acts
    acts=func()
    acts[0](2) #调用时才开始查找i,此时i最后被记住的值是4

    
列表(list) 与 元组(tuple) 的作用域
    1.列表(list)
       在 Python2 列表内部没有引入新的作用域,但 python3 却会引入新作用域,如:

        [a for a in range(3)]
        print(a) # 在 python2 下运行时打印 2, 而在 python3 下运行时抛异常: NameError: name 'a' is not defined

    2.元组(tuple)
       不管 Python2 还是 Python3,元组内部都会引入新的作用域,如:

        (a for a in range(3))
        print(a) # 不管 Python2 还是 Python3, 运行都会抛异常: NameError: name 'a' is not defined


global 和 nonlocal 关键字
    如果想内层的变量域中的代码想修改 global 中的变量值, 使用 global 关键字。
    如果内层的变量域中的代码想修改 enclosing 中的变量值, 使用 nonlocal 关键字。
    如果没有使用这两个关键字, 那么在对其进行修改(也就是对其再次赋值的时候)会生成局部变量进行赋值, 并且在本作用域使用的时候会覆盖高层作用域的值, 但不影响高层作用域中的值。

local: 指函数内部的变量作用域
nonlocal: 指闭包作用域
global: 全局作用域

Python 对象查找规则是: local(nonlocal)-->global-->builtins.
local namespace对应当前的模块, 函数,对象等等
global namespace对应其他模块, 交互的session等等
builtin namespace对应 __builtin__.py 模块, 里面有(len, min, max, int,float, long, list, tuple, cmp, range str)等内建的对象

#### 示例 ####

    #### local 与 global 作用域的查找顺序示例 ####
    def foo():
        print(x) # 在 local 作用域(foo 函数内)里面查找不到此变量,所以上溯查到 global 作用域(整个模块)的。 打印: 1

    def foo2():
        x = 2
        print(x) # 在 local 作用域(foo2 函数内)能查找到此变量,所以用 local 作用域(foo2 函数内)的。 打印: 2

    x = 1
    foo()
    foo2()


    #### local 与 enclosing, global 作用域的查找顺序示例 ####
    def foo():
        x = 2

        def bar():
            print(x) # 在 local 作用域(bar 函数内)里面查找不到此变量,所以上溯查到 enclosing 作用域(foo 函数内)的。 打印: 2
            # 由于 enclosing 比 global 更优先查找,所以这变量不需要查询到 global 。


        def bar2():
            x = 3
            print(x) # 在 local 作用域(bar2 函数内)能查找到此变量,所以用 local 作用域(bar2 函数内)的。 打印: 3

        bar()
        bar2()

    x = 1
    foo()


    #### global 关键字的使用示例 ####
    def foo():
        x = 2 # 这里赋值,只改变 local 作用域里面的 x 变量,不影响 global 作用域(整个模块)的 x 变量值。
        print(x)

    def foo2():
        global x # 申明 x 变量是个全局变量,影响 global 作用域的。
        x = 3 # 这里赋值,将会改变 global 作用域的 x 变量。
        print(x)

    x = 1
    foo() # 打印: 2
    print(x) # global 作用域的 x 变量没有被修改, 打印: 1
    foo2() # 打印: 3
    print(x) # global 作用域的 x 变量被修改了, 打印: 3


    #### nonlocal 关键字的使用示例(python 2.x 不支持此关键字) ####
    def foo():
        x = 2

        def bar():
            x = 3
            print('local, in bar, x:', x) # 这里只有 local 作用域,不影响任何外部变量。 打印: 3

        def bar2():
            nonlocal x
            x = 4
            print('enclosing, in bar2, x:', x) # 这里影响到 enclosing 作用域,修改了 foo 函数的变量。 打印: 4

        def bar3():
            global x
            x = 5
            print('global, in bar3, x:', x) # 这里影响到 global 作用域,修改了全局变量,但不影响 enclosing 作用域。 打印: 5

        print('local,in foo, befor run bar, x:',x) # 打印: 2
        bar()
        print('local,in foo, after run bar, x:',x) # bar 里面只影响 local 作用域,不影响 enclosing 作用域。打印: 2
        bar2()
        print('local,in foo, after run bar2, x:',x) # bar2 里面影响到 enclosing 作用域。打印: 4
        bar3()
        print('local,in foo, after run bar3, x:',x) # bar3 里面影响到 global 作用域,修改了全局变量,但不影响 enclosing 作用域。 打印: 4

    x = 1
    print('global,befor run foo, x:', x) # 打印: 1
    foo()
    print('global,after run foo, x:', x) # global 的变量 x 被修改过, 打印: 5


#### 容易犯浑的作用域使用示例 ####

    x = 10
    def foo1():
        print(x)

    def foo2():
        print(x)
        x = 1

    foo1() # 正常打印: 10
    foo2() # 居然报这异常了,怎么回事: UnboundLocalError: local variable 'x' referenced before assignment

    ### 解说 ###
    出现上述错误的原因是, 当你在一个作用域内赋值给一个变量, 该变量自动被 Python 认为是本地的作用域(local), 且不受任何外部作用域的影响。
    许多人因此在预处理(previously working code)时意外地得到一个 UnboundLocalError, 它是由一个函数体中的一个赋值语句引起的。
    这种情况下使用列表特别容易绊倒开发者。

    The above error occurs because, when you make an assignment to a variable in a scope, that variable is automatically considered by Python to be local to that scope and shadows any similarly named variable in any outer scope.
    Many are thereby surprised to get an UnboundLocalError in previously working code when it is modified by adding an assignment statement somewhere in the body of a function. (You can read more about this here.)
    It is particularly common for this to trip up developers when using lists.


    ### 考虑下面的例子： ###
    lst = [1, 2, 3]
    def foo1():
        lst.append(5)   # This works ok...

    foo1()
    print(lst) # 打印: [1, 2, 3, 5]

    lst = [1, 2, 3]
    def foo2():
        lst += [5]      # but this bombs!

    foo2() # 报异常了,异常信息: UnboundLocalError: local variable 'lst' referenced before assignment

    ### 解说 ###
    foo1 里面使用了 lst, 但不是赋值(不改变 lst 的引用), 所以可以正常使用。
    foo2 的“ lst += [5] ”其实是“ lst = lst + [5] ”的缩写,所以也属于赋值给 lst 变量。同样的被Python认定为在局部作用域内, 因此报 UnboundLocalError 异常。

    The answer is the same as in the prior example problem, but is admittedly more subtle. foo1 is not making an assignment to lst, whereas foo2 is.
    Remembering that lst += [5] is really just shorthand for lst = lst + [5], we see that we are attempting to assign a value to lst (therefore presumed by Python to be in the local scope).
    However, the value we are looking to assign to lst is based on lst itself (again, now presumed to be in the local scope), which has not yet been defined. Boom.


class 类里面的作用域
    class 内的作用域不同于函数, class 内没有词法范围(lexical scope), python2 和 python3 都是这样。
    它有一个不构成作用域(scope)的本地命名空间(local namespace)。
    Classes don't have a lexical scope (actually, in either Python 2 or Python 3). Instead, they have a local namespace that does not constitute a scope.

    class 内的本地命名空间(local namespace)只有在不产生新的作用域时可以直接访问,一旦产生新的作用域将不再能直接访问到这命名空间。
    在新的作用域里面,只能通过类似访问类的方法那样来访问这些命名空间的变量。

    ### 例,简单的使用class内的静态变量 ###
        class C:
            a = 2
            b = a + 2    # b = 4

        print(C.b) # 打印:4
        ## 由于 b 的表达式里面不产生新的作用域,所以可以直接使用 class 内的本地命名空间的变量


    ### 例,class内的静态变量不能当成 enclosing 作用域来用 ###
        class C:
            a = 2
            def foo(self):
                return a    # NameError: name 'a' is not defined, use return self.__class__.a

        print(C().foo()) # 前面几行编译正常,运行到这行才会抛出 NameError 异常
        ## foo 里面已经是新的作用域了,不再在这 class 的本地命名空间内,所以不能直接访问到这 class 的本地命名空间内的变量


    ### 例,class内的静态变量不能当成 local 作用域来用 ###
        class C:
            a = 2
            b = [a + i for i in range(3)] # python2时正常,但Python3时抛出异常： NameError: global name 'a' is not defined
            #b = (lambda a=a: [a + i for i in range(3)])() # 这才是正确的写法

        print(C.b)
        ## Python2 的列表内部没有引入新的作用域,所以 b 的表达式依然处于这 class 的本地命名空间内,也就可以直接使用命名空间内的变量了。
        ## 但 python3 的列表内部却会引入新作用域,所以不再处于这 class 的本地命名空间了,也就不能直接访问这命名空间内的变量。
        ## 而定义 lambda 时,预加载的默认参数值没有新的作用域,即处于这命名空间内,可以直接访问到命名空间内的值。运行这 lambda 时,实际上是用默认参数值。


    ### 例,class内的静态变量不能当成 local 作用域来用 ###
        class C:
            a = 2
            b = list(a + i for i in range(3)) # 这一写法,不管Python2还是Python3,都抛出异常： NameError: global name 'a' is not defined
            #b = (lambda a=a: list(a + i for i in range(3)))() # 这才是正确的写法

        print(C.b)
        ## 这个范例跟前面一个基本相同,只是 list 函数括号内已经有了新的作用域,所以 Python2 也抛异常了。
