1.从实际角度，模块对应Python程序文件（或者用外部语言如C|C#编写的扩展）。从逻辑上看，模块是最高级别的程序组织单元
    每个Python程序文件都是一个模块
    模块导入另一个模块后，可以直接使用被导模块定义的全局变量名
    
2.Python程序是作为一个主体的、顶层文件来构造，配合零个或者多个支持的模块文件

3.Python自带了很多模块，称为标准链接库。他们提供了很多常用功能

4.导入模块用import。其通用格式为import modname。其中modname为模块名，它没有文件后缀名.py，也没有文件路径名。
导入并非是C语言的#include。导入其实是运行时的运算。程序首次导入一个模块时，执行三个步骤：
    找到模块文件
    编译成字节码（即.pyc文件）。如果字节码文件不存在或者字节码文件比源代码文件旧， 则执行该步骤。否则跳过该步骤直接加载字节码
    执行模块代码来创建其定义的对象
在这之后导入相同模块时，会跳过这三步而只是提取内存中已经加载的模块对象。

    从内部看，Python将加载的模块存储到一个名为sys.modules的字典中，键就是模块名字符串。在每次导入模块开始时都检查这个字典，若模块不存在则执行上述三步。
    print sys.modules
    
5. 当文件import时，会进行编译产生字节码文件.pyc，因此只有被导入文件才会在机器上留下.pyc文件。顶层文件的字节码在内部使用后就丢弃了，并未保留下来。
    顶层文件通常设计成直接执行，而不是被导入的
    
6. Python模块文件搜索路径：
    程序主目录
    环境变量PYTHONPATH指定的目录
    标准链接库目录（这个一般不动它）
    任何.pth文件的内容，其中.path文件在前三者中查找到的。
        Python会将每个.pth文件的每行目录从头到尾添加到sys.path列表的最后 （在此期间Python会过滤.pth文件中目录列表中重复的和不存在的目录)
以上四者优先级从高到低。这四部分组合起来就是sys.path列表的内容

7.sys.path列表就是模块的搜索路径。Python在程序启动时配置它，自动将顶级文件的主目录（或代表当前工作目录的一个空字符串）、环境变量PYTHONPATH指定的目录、标准库目录以及已创建的任何.pth文件的内容合并
    模块搜索时，从左到右搜索sys.path，直到第一次找到要import的文件
    
8.import模块时，省略文件后缀名因为模块可能是.py文件、.pyc文件，或者扩展的C模块等。

9.创建模块：任何保存为.py文件的文件均被自动认为是Python模块。所有该模块顶层指定的变量均为模块属性。
    可执行但不会被导入的顶层文件不必保存为.py文件
    因为模块名在Python中会变成变量名，因此模块名必须遵守普通变量名的命名规则

10.import和from语句：
    import使得一个变量名引用整个模块对象：import module1
    from将一个变量名赋值给另一个模块中同名的对象：from module1 import printer。在本模块内printer名字引用了module1.printer对象
    from *语句将多个变量名赋值给了另一个模块中同名的对象：from module1 import *。在本模块内，所有module1.name对象赋值给了name变量名
    
    有几点需要注意：
    from语句首先与import一样导入模块文件。但它多了一步：定义一个或多个变量名指向被导入模块中的同名对象
    from与import都是隐性赋值语句
    from与import对本模块的命名空间影响不同：
        from会在命名空间中引入from import的变量名而不会引入模块名， 
        import会在命名空间中引入模块名
        
11.要修改被导入的全局变量，必须用import，然后用模块名的属性修改它；不能用以from隐式创建的变量名来修改。

12.用from时，被导入模块对象并没有赋值给变量名：
    import module1              module1既是模块名，也是一个变量名（引用被导入模块对象）
    from module1 import func    module1仅仅是模块名，而不是变量名
    import test1
    from test2 import a
    test1 # test1既是模块名又是变量名
    test2 # test2是模块名，不是变量名

13.from语句陷阱：
    from语句可能破坏命名空间
    from后跟随reload时，from导入的变量名还是原始的对象
    
14.模块的命名空间可以通过属性.__dict__或者dir(modname)来获取
    在Python内部，模块命名空间是作为字典对象存储的
    我们在模块文件中赋值的变量名在Python内部称为命名空间字典的键
    sys.__dict__.keys() == dir(sys)

15.一个模块内无法使用其他模块内的变量，除非明确地进行了导入操作

16.重载函数reload()：它会强制已加载的模块代码重新载入并重新执行
    reload函数可以修改程序的一部分，而无需停止整个程序
    reload函数只能用于Python编写的模块，而无法用于其它语言编写的扩展模块
    
17.reload()与import和from的差异：
    reload是Python内置函数，返回值为模块对象，import与from是语句
    传递给reload是已经存在的模块对象，而不是一个变量名
    reload在Python3.0中位于imp标准库模块中，必须首先导入才可用。

18.reload工作细节：
    reload并不会删除并重建模块对象，它只是修改模块对象。即原来模块的每个属性对象内存空间还在，所有旧的引用指向他们，新的引用指向修改后的属性对象内存空间
    reload会在模块当前命名空间内执行模块文件的新代码
    reload会影响所有使用import读取了模块的用户，用户会发现模块的属性已变
    reload只会对以后使用from的代码造成影响，之前用from的代码并不受影响。之前的名字还可用，且引用的是旧对象
    
# 高级
1.Python模块会默认导出其模块文件顶层所赋值的所有变量名，不存在私有变量名。所有的私有数据更像是一个约定，而不是语法约束：
    下划线开始的变量名_x：from *导入该模块时，这类变量名不会被复制出去
    模块文件顶层的变量名列表__all__：它是一个变量名的字符串列表。from *语句只会把列在__all__列表中的这些变量名复制出来。
    
    Python会首先查找模块内的__all__列表；否该列表未定义，则from *会复制那些非 _开头的所有变量名
所有这些隐藏变量名的方法都可以通过模块的属性直接绕开

2.当文件是以顶层程序文件执行时，该模块的__name__属性会设为字符串"__main__"。若文件被导入，则__name__属性就成为文件名去掉后缀的名字
    模块可以检测自己的__name__属性，以确定它是在执行还是被导入
    使用__name__最常见的是用于自我测试代码：在文件末尾添加测试部分：
      if __name__=='__main__':
       	#pass

3.在程序中修改sys.path内置列表，会对修改点之后的所有导入产生影响。因为所有导入都使用同一个sys.path列表
4.import和from可以使用as扩展，通过这种方法解决变量名冲突：
  import modname as name1
  from modname import attr as name2
在使用as扩展之后，必须用name1、name2访问，而不能用modname或者attr，因为它们事实上被del掉了

5.在import与from时有个问题，即必须编写变量名，而无法通过字符串指定。有两种方法：
    使用exec:exec("import "+modname_string)
    使用内置的__import__函数：__import__(modname_string)，它返回一个模块对象
    
    exec("import "+"test") # 利用exec，通过字符串指定导入模块的名字
    __import__("test2")    # 利用__import__,通过字符串指定导入模块的名字

6.reload(modname)只会重载模块modname，而对于模块modname文件中import的模块，reload函数不会自动加载。
要想reload模块A以及A import的所有模块，可以手工递归扫描A模块的__dict__属性，并检查每一项的type以找到所有import的模块然后reload这些模块

7.可以通过下列几种办法获取模块的某个属性：
    modname.attr：直接通过模块对象访问
    modname.__dict__['attr']：通过模块对象的__dict__属性字典访问
    sys.modules['modname'].name：通过Python的sys.modules获取模块对象来访问
    getattr(modname,'attr')：通过模块对象的.getattr()方法来访问
    