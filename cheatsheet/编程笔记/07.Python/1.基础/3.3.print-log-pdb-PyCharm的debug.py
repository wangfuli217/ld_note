print

# 1.print
用print调试代码是最简单的一种方法，也很常用，大部分人都掌握这种技巧。
在代码中合适的地方插入语句，可以是输出提示语句或者输出某些变量。

优点：
比较直观，使用简单
缺点：
需要入侵代码，也就是要修改代码

# 2. logging
就是利用logging模块，在代码合适的地方插入输出log语句，把合适的信息输出到log文件中，通过查看log文件分析代码的执行情况。

优点：
    logging模块可以指定输出格式和内容（可以输出时间，代码的行号，当前运行程序的名称、当前运行的函数名称、进程ID等等），
因此能获得更精确的调试信息，应用场景更广泛，可以应用于生产环境。
缺点：
需要入侵代码，也就是要修改代码；使用更复杂。

# 3.pdb
pdb 是 python 自带的一个包，为 python 程序提供了一种交互的源代码调试功能，主要特性包括设置断点、单步调试、进入函数调试、查看当前代码、查看栈片段、动态改变变量的值等。

优点：
功能强大，使用简单
缺点：
需要入侵代码，也就是要修改代码；使用更复杂。

# 4.PyCharm提供的debug功能
PyCharm提供了单步调试代码的功能。
优点：
提供图形化界面，很直观；功能强大；不需要修改代码
缺点：

