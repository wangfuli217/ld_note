
在导入一个模块后，Python会按以下顺序进行搜索
1. 程序的主目录
2. PYTHONPATH目录
3. 标准链接库目录
4. 任何.pth文件的内容
    
import语句
    import会读取整个模块，因此必须进行定义后才能读取它的变量名
    import module1
    module1.printer('Hello World')

from语句
    from会把变量名复制到另一个作用域，因此可以直接在脚本中使用复制后的变量名而不需要通过模块
    from module1 import printer
    printer('Hello World')

from *语句
    当使用*时，会取得模块顶层所有赋了值的变量名的拷贝
    from module1 import *
    printer('Hello World')

reload()重载模块
     1.reload()的一般用法为：导入一个模块，在文本编辑器内修改其源代码，然后将其重载；当调用reload时，
             Python会重读模块文件的源代码并重新执行其顶层语句，因此被导入文件中的变量名都会换成新值。
     2.重载会影响所有使用import读取了模块的客户端，但不会影响重载之前使用from来读取属性的客户端，只会影响重载之后使用from的客户端

模块包
    1.包导入是把计算机上的目录变成另一个Python命名空间，而属性则对应于目录中所包含的子目录和模块文件。
        import dir1.dir2.mod
    上面的dir1.dir2.mod相当于路径dir0\dir1\dir2\mod.py，其中dir0目录需要添加在模块搜索路径中。
    2.如果选择使用包导入，则包导入语句的路径中的每个目录内都必须有__init__.py这个文件，其中容器目录
      dir0不需要这类文件。 例如上面的代码中dir1和dir2中都必须有一个__init__.py文件。


from ... import 语句
    如果你想要直接输入 argv 变量到你的程序中(避免在每次使用它时打sys.)，那么你可以使用 from sys import argv 语句。
    如果你想要输入所有 sys 模块使用的名字，那么你可以使用 from sys import *语句。
    这对于所有模块都适用。
    注意:
        1.使用 from package import item 方式导入包时，这个子项(item)既可以是包中的一个子模块(或一个子包)，也可以是包中定义的其它命名，像函数、类或变量。
          import 语句首先核对是否包中有这个子项，如果没有，它假定这是一个模块，并尝试加载它。如果没有找到它，会引发一个 ImportError 异常。
        2.使用像 import item.subitem.subsubitem 这样的语句时，这些子项必须是包，最后的子项可以是包或模块，但不能是前面子项中定义的类、函数或变量。
        3.应该避免使用 from...import 而使用 import 语句，因为这样可以使你的程序更加易读，也可以避免名称的冲突。

import ... as
    为 import 的模块起一个简称。如: import cPickle as p
    起简称后,下面的语句即可使用简称,如原本的 cPickle.dump() 可写成 p.dump()


__import__ 用法:
    __import__(name[, globals[, locals[, fromlist[, level]]]])
        被 import 语句调用的函数。它的存在主要是为了你可以用另外一个有兼容接口的函数 来改变 import 语句的语义.

    如果你写过较庞大的 Python 程序, 那么你就应该知道 import 语句是用来导入外部模块的 (当然也可以使用 from-import 版本).
    不过你可能不知道 import 其实是靠调用内建 函数 __import__ 来工作的.
    通过这个戏法你可以动态地调用函数. 当你只知道模块名称(字符串)的时候, 这将很方便.


1. 使用 __import__ 函数加载模块
    # 同目录下建一个 example-plugin.py 文件,里面内容为:
    def hello():
        print "example-plugin says hello"


    # 测试代码
    import os
    import glob

    modules = []

    for module_file in glob.glob("*-plugin.py"):
        try:
            # module_file 是一个包含文件后缀名的文件名，这里分隔出文件名和后缀
            module_name, ext = os.path.splitext(os.path.basename(module_file))
            module = __import__(module_name)
            modules.append(module)
        except ImportError:
            pass # ignore broken modules

    # 调用所有 modules 里面的 hello 函数
    for module in modules:
        module.hello()


    # 注意这个示例里面 plug-in 模块文件名中有个 "-" (hyphens). 这意味着你不能使用普通的 import 命令, 因为 Python 的辨识符不允许有 "-" .


2. 使用 __import__ 函数获得特定函数

    def getfunctionbyname(module_name, function_name):
        module = __import__(module_name)
        return getattr(module, function_name)

    op = getfunctionbyname("dumbdbm", "open") # 获取到此函数
    print repr(op) # 打印: <function open at 0x01B9B7F0>


    # 相当于这样写:
    import dumbdbm
    op = dumbdbm.open
    print repr(op)


3. 使用 __import__ 函数实现 延迟导入

    class LazyImport:
        def __init__(self, module_name):
            self.module_name = module_name
            self.module = None
        def __getattr__(self, name):
            if self.module is None:
                self.module = __import__(self.module_name)
            return getattr(self.module, name)

    s = LazyImport("string")
    print s.lowercase # 打印: abcdefghijklmnopqrstuvwxyz
    print s.uppercase # 打印: ABCDEFGHIJKLMNOPQRSTUVWXYZ



一个模块要执行其它模块主要有三种方法
    第一: import 模块或使用 __import__() 动态导入
    第二: 利用 os.system() 执行此模块文件
    第三: 利用 execfile 函数


    # 同目录下建一个 example-plugin.py 文件,里面内容为:
    def hello():
        print "example-plugin says hello"
    #被导入的模块就不要将执行的代码写在if __name__ == "__main__"下，不然执行不了。
    print '加载 example-plugin.py 成功。。。'


    #示例1:(使用 动态导入 __import__())
    module = __import__('example-plugin') # 打印: 加载 example-plugin.py 成功。。。
    module.hello() # 打印: example-plugin says hello
    #导入的模块，可以随意定义一个模块名称，然后按正常模块调用


    #示例2:(使用 os.system())
    import os
    module = os.system('python example-plugin.py' % (item.strip())) # 打印: 加载 example-plugin.py 成功。。。
    #没法调用模块里面的函数,因为 os.system 是执行系统命令,直接运行了此模块文件而不是导入它


    #示例3:(使用 execfile 函数)
    execfile('example-plugin.py') # 打印: 加载 example-plugin.py 成功。。。
    hello() # 打印: example-plugin says hello
    #调用模块里的函数可以直接按本模块的来用，没有新模块名称


