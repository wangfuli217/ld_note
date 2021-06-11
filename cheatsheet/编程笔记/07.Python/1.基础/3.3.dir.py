dir(x)：查看x所指对象的属性
help(x.attr)：查看x所指对象的attr属性
help(x)：查看x所指对象的详细信息
vars(obj):显示对象属性的dict
globals() 和 locals()

dir([object])
    列出模块定义的标识符。标识符有函数、类和变量。
    当参数为一个模块名的时候，它返回模块定义的名称列表。
    如果不提供参数，它返回当前模块中定义的名称列表。
    注:因为 dir()主要在交互提示下方便使用，它尝试提供一给有意思的名字而不是尝试提供严格的或与定义一样的名字,在 relrase 中它的细节行为也许会改变。


dir()函数
    使用内建的 dir 函数来列出模块定义的标识符。标识符有函数、类和变量。
    返回由给定模块, 类, 实例, 或其他类型的所有成员组成的列表. 这可能在交互式 Python 解释器下很有用, 也可以用在其他地方.
    当你为 dir()提供一个模块名的时候，它返回模块定义的名称列表。如果不提供参数，它返回当前模块中定义的名称列表。


范例(控制台中使用 dir, 带参数与不带参数形式):
    >>> import sys
    >>> dir(sys) # get list of attributes for sys module
    ['__displayhook__', '__doc__', '__excepthook__', '__name__', '__stderr__', '__stdin__', '__stdout__', '_getframe', 'api_version', 'argv',...] # 忽略大部分内容
    >>> dir() # get list of attributes for current module
    ['__builtins__', '__doc__', '__name__', 'sys']
    >>>
    >>> a = 5 # create a new variable 'a'
    >>> dir()
    ['__builtins__', '__doc__', '__name__', 'a', 'sys']
    >>>
    >>> del a # delete/remove a name; 这个得留意
    >>>
    >>> dir()
    ['__builtins__', '__doc__', '__name__', 'sys']
    >>>


范例(简单查看各种类型):
    def dump(value):
        print( value, "=>", dir(value) )

    import sys

    dump(0)
    dump(1.0)
    dump(0.0j) # complex number
    dump([]) # list
    dump({}) # dictionary
    dump("string")
    dump(len) # function
    dump(sys) # module

    输出结果(Python26):  # 各行的中间部分忽略
    0 => ['__abs__', '__add__', '__and__', '__class__', ......, 'numerator', 'real']
    1.0 => ['__abs__', '__add__', '__class__', ......, 'is_integer', 'real']
    0j => ['__abs__', '__add__', '__class__', ......, 'conjugate', 'imag', 'real']
    [] => ['__add__', '__class__', '__contains__', ......,'remove', 'reverse', 'sort']
    {} => ['__class__', '__cmp__', '__contains__', ......, 'setdefault', 'update', 'values']
    string => ['__add__', '__class__', '__contains__',......, 'upper', 'zfill']
    <built-in function len> => ['__call__', '__class__', ......, '__subclasshook__']
    <module 'sys' (built-in)> => ['__displayhook__', '__doc__', ......, 'warnoptions', 'winver']

PyDoc
    标准PyDoc工具用Python代码编写，它提取文档字符串并自动格式化其信息，展示成排列友好的报表。
        Python在标准库中附带了PyDoc工具
        有两种最主要的PyDoc接口：
            内置的help()函数。可以对函数、方法、类型、对象使用help()函数。
            对较大的对象（如模块、类型），help()输出的内容会分成几段。 报表中的信息有些是文档字符串，有些是PyDoc自动查看对象内部而收集的结构化信息。
            PyDoc的 GUI|HTML 接口。启动 Tools/scripts 目录下的pydoc3.py 脚本： pydoc3.py -b

Python标准手册随Python发布。手册以HTML和其他格式实现。最重要的项目是：
    Library Reference：标准库文档，说明了内置类型、函数、异常等等
    Language Reference：官方给出的语言层次的细节

