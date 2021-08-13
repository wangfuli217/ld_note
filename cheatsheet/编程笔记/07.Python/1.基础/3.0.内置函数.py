
__import__(name[, globals[, locals[, fromlist[, level]]]])
    被 import 语句调用的函数。它的存在主要是为了你可以用另外一个有兼容接口的函数 来改变 import 语句的语义.

abs(x)
    返回一个数的绝对值。参数也许是一个普通或长整型，或者一个浮点数。如果参数是一个复数，返回它的模。

all(iterable)
    如果迭代的所有元素都是真就返回真。版本2.5中新增.

any(iterable)
    如果迭代中有一个元素为真就返回真。版本2.5中新增.

basestring()
    这个抽象类型是 str 和 unicode 的父类。它不能被调用或初始化，但是它可以使用来测试一个对象是否是 str 或 unicode 的实例。
    isinstance(obj, basestring)等价于 isinstance(obj, (str, unicode)) 版本2.3中新增.

bool([x])
    将一个值转换为 Boolean,使用标准的真测试程序。如果x是假或忽略了，将返回 False;否则将返回 True.bool也是一个 class，它是 int 的一个子类，bool类不能进一步子类化。它仅有 False 和 True 两个实例。

callable(object)
    如果 object 参数是可以调用的函数或者类就返回 True,否则返回 False 。返回 True,仍可能调用失败，但返回 False,就不可能调用成功。
    可调用对象包括函数、方法、代码对象、类和已经定义了“ __call__()”方法的类实例。
    如： a="123"; callable(a) 返回0;  callable(chr) 返回1

chr(i)
    返回一个ascii码是整数i的字符的字符串。例如: chr(97)返回'a'.这和 ord()刚好相反。这参数在[0..255]之间,全部包含。如果超出这个范围，就抛出 ValueError

classmethod(function)
    返回函数的一个类方法。一个类方法接收类作为它的第一个潜在参数，就像一个实例方法接收一个实例。
    类方法不同于C++或Java的静态方法。如果你想这样做，使用 staticmethod()。

cmp(x, y)
    根据比较两介对象x和y的结果，返回一个整数。如果x<y,返回-1,如果x==y,返回0，如果 x > y,根据比较结果返回一个正数.

coerce(number1, number2)
    (可以看成一个数值类型转换函数)有两个参数，都是数字，返回这两个数字的一个列表，将这两个数字的数据类型统一。python3去掉这函数。
    如: coerce(1,2j)，返回(1+0j,2j)

compile(string, filename, kind[, flags[, dont_inherit]])
    编译 string 为一个代码对象。代码对象能够通过 exec 语句执行或者通过调用 eval()计算。
    这filename参数指定代码从哪个文件读取。如果不从文件中读取，就须传递一些可识别的值(通常使用'<string>',"<script>")。
    kind参数指定哪种代码被编译;如果是包含一系列语句组成的子符串可以'exec',如果是由一个表达式组成，就'eval',如果由一个交互语句组成就'singlw'(在后面的例子，表达式语句计算的结果不是 None 将打印出来)。
    当编译一个多行语句时，应用两个警告：必须以' '作为行结束符，同时输入必须至少以一个' '作为结束。如果是以' '作为行结束，使用 string 的 repalce() 方法将其改为' '.
    可先的参数flags和dont_inherit控制影响 string 编译的 future 语句。更详细的请参考英文文档。

complex([real[, imag]])
    可把字符串或数字转换为复数。
    创建一个复数real + imag*j或者将一个 string 或者 number 转化为一个复数.
    如果第一个参数是一个字符串,它将作为复数解释，函数将被调用，而忽略第二个参数。第二个参数不可能是一个字符串。每一个参数都可能是一个数字类型包括复数.如果imag省略了, 它默认为0，函数将当作一个数字转换函数像 int(), long() and float().如果参数都省略了，将返回0j.

delattr(object, name)
    与 setattr()相对的，参数是一个对象和一个 string. string 必须是对象的一个属性。函数删除object这个名为 string 的属性。例如: delattr(x, 'foobar')等价于 del x.foobar

dict([arg])
    返回一个字典。
    例如，下面所有返回都等价于{"one": 2, "two": 3}:
        dict({'one': 2, 'two': 3})
        dict({'one': 2, 'two': 3}.items())
        dict({'one': 2, 'two': 3}.iteritems())
        dict(zip(('one', 'two'), (2, 3)))
        dict([['two', 3], ['one', 2]])
        dict(one=2, two=3)
    版本2.2中新增.

dir([object])
    列出模块定义的标识符。标识符有函数、类和变量。
    当参数为一个模块名的时候，它返回模块定义的名称列表。如果不提供参数，它返回当前模块中定义的名称列表。
    注:因为 dir()主要在交互提示下方便使用，它尝试提供一给有意思的名字而不是尝试提供严格的或与定义一样的名字,在relrase中它的细节行为也许会改变。

divmod(a, b)
    函数完成除法运算，返回商和余数。
    如： divmod(10,3) 返回(3, 1); divmod(9,3) 返回(3, 0)

enumerate(iterable)
    返回 enumerate 对象. iterable 必须是一个序列, 一个迭代, 或者其它对象它支持迭代.
    enumerate()返回的 iterator 的 next()方法 返回一个元组包含一定的数目(从0开始)和从迭代中获取的对应的值。
    enumerate() 对于获取一个索引系列很有用: (0, seq[0]), (1, seq[1]), (2, seq[2]), .... 版本2.3中新增.

eval(expression[, globals[, locals]])
    该参数是一个字符串和可选的 globals 和 locals 。如果提供 globals,globals 必须是一个字典。如果提供 locals,locals 可以是任何映射对象。2.4版本修改：以前 locals 被要求是一个字典。
    expression参数是作为一个Python表达式被分析和评价(技术上来说，一个条件列表)使用 globals 以及 locals 字典作为 global 和 local 名字空间。
    如果提供了 globals 字典但没有'__builtins__'，当前 globals 在表达式被分析前被复制到 globals 中。这意味着表达式可以完全访问标准 __builtin__ 模块和受限的环境。如果 locals 字典省略则默认为 globals 字典。如果两个字典都被省略，表达式在调用 eval 的环境中执行。返回值是计算表达式的结果。语法错误报告为 exceptions 。
    此函数也可以用来执行任意代码的对象(如 compile()创建的)。在这种情况下，传入一个代码对象，而不是一个字符串。该代码对象必须已编译传给'eval'作为这种参数。
    提示： exec 语句支持是动态执行语句。 execfile()函数支持从一个文件中执行语句。 globals()和 locals()函数分别返回当前的 global 和 local 字典，这对使用 eval()或 execfile()很有帮助。

execfile(filename[, globals[, locals]])
    这个功能类似于 exec 语句，但分析一个文件，而不是一个字符串。这是不同之处在于它的 import 语句不使用模块管理 - 它无条件读取文件，并不会创建一个新的 module 。
    该参数是一个文件名和两个可选字典。该文件被作为Python语句序列(类似于一个模块)使用 globals 和 locals 作为 global and local 命名空间来分析和计算。如果提供 locals,locals 可以是任何映射对象。2.4版本修改：以前 locals 被要求是一个字典。如果 locals 字典省略则默认为全局字典。如果两个字典都被省略，表达式 execfile()被调用的环境中执行。返回值为 None 。

    警告：默认的locals为下面的locals()：不要尝试修改默认的本地词典。如果你需要看到在函数execfile()返回后locals代码的的影响，传递一个明确的locals字典。 execfile()不能用于依赖修改函数的locals。

file(filename[, mode[, bufsize]])
    文件类型的构造函数，`文件对象`。构造函数的参数与下面的内建的 open() 函数是一样的。
    当打开一个文件，它是最好使用的 open()，而不是直接调用此构造函数。文件更适合检验类型(例如，isinstance(f, file))。

filter(function, iterable)
    把一个函数应用于序列中的每个项，并返回该函数返回真值时的所有项，从而过滤掉返回假值的所有项。
    function 返回 True 时从iterable的元素中构造一个列表。迭代可以是一个序列，一个支持迭代的容器，或一个迭代器，如果Iterable的是一个字符串或一个元组，其结果也有这种类型的，否则它始终是一个列表。如果 function 是 None, 假定它是恒等函数，即，迭代是 False 其所有元素都被删除。
    请注意， filter(function,iterable)，如果函数不为 None 等价于[item for item in iterable if function(item)]，如果函数为 None 等价于[item for item in iterable if item]。

float( [x])
    将字符串或数字转换或一个浮点数。如果参数是一个字符串，它必须包含一个可能带符号的十进制或浮点数，可能嵌入空格。否则，参数可以是一个普通或长整数或浮点数，返回一个与之相同值的浮点数(在Python的浮点精度内)。如果没有给出参数，返回0.0。
    注意：当传递一个字符串，可能会返回 NaN 和 Infinity，这取决于底层C库。

float(x)
    把一个数字或字符串转换成浮点数。

frozenset([iterable])
    返回一个frozenset对象，其元素来自于Iterable。 Frozensets组没有更新的方法，但可以哈希和其他组成员或作为字典键使用。一个frozenset的元素必须是不可改变。内部sets也应是frozenset对象。如果迭代没有指定，返回一个新的空集，frozenset ([])。 版本2.4中新增
    冻结集合(frozenset对象)不能再添加或删除任何集合里的元素。因此与集合 set 的区别，就是 set 是可以添加或删除元素，而 frozenset 不行。

getattr(object, name[, default])
    返回object名为name属性的值。名称必须是一个字符串。如果该字符串是对象的其中属性名字，结果是该属性的值。例如，getattr(x, 'foobar')相当于x.foobar。如果指定的属性不存在，则返回默认提供的，否则抛出AttributeError。

globals()
    返回代表当前 global 符号表字典的字典。这始终是当前模块字典(在一个函数或方法内，是在它被定义的模块，而不是被调用的模块)。

hasattr(object, name)
    该参数是一个对象和一个字符串。如果字符串是对象的其中一个属性，结果为 True,如果没有返回 False 。 (这是通过调用的 getattr(对象名称)，看是否引发异常与否。)

hash(object)
    返回对象(如果有的话)的哈希值。哈希值是整数。它们被用来在词典查找时，作为一个快速比较字典keys键。具有相同的哈希值，数值相等(即使它们属于不同的类型，因为是1和1.0的情况)。

help([object])
    调用内置的帮助系统。(此功能是为交互使用。)如果没有给出参数，交互式帮助系统启动解释控制台。如果参数是一个字符串，然后是字符串被作为一个module，function，class，method，keyword或文档主题名称和帮助页面名字进行查找后在控制台上打印出来。如果参数是任何其他类型的对象，将产生该对象的一个帮助页面。 版本2.2中新增.

hex(x)
    转换一个(任意大小)整数为十六进制字符串。其结果是一个有效的Python表达式。在2.4版本变更：原只产生一个无符号的文字。

id(object)
    返回对象的内存地址。
    这是一个整数(或长整型)，这是保证是唯一的，与对象的生命周期一样长。两个非重叠的生命周期的对象可能有相同的 ID 值。

input([prompt])
    警告：此函数是不安全的，因为用户错误的输入！它期待一个有效的Python表达式作为输入，如果输入语法上是无效的，将抛出SyntaxError。如果地计算过程中有一个的错误，将抛出其他exceptions。 (另一方面，有时这是你为特殊使用需要写一个快速脚本。)
    如果readline模块被加载，input()将使用它来提供详细行编辑和历史特性。
    考虑使用 raw_input() 函数作为从用户进行一般输入。
    python3.x 开始有所变化

int([x[, radix]])
    转换为字符串或数字为纯整数。如果参数是一个字符串，它必须包含一个可能有符号的十进制数作为一个Python整数，可能嵌入空格。
    以radix参数给出的基数为基础进行转换(这是默认10)，可以是任何在[2，36]范围内的整数，或零。如果基数为零，根据字符串的内容猜测正确的基数。如果指定的基数x是不是一个字符串，引发TypeError异常。否则，参数可以是一个普通或长整数或浮点数。转换浮点数截断为整数(直到零)。如果参数是整数范围之外的，将返回一个long object。如果没有给出参数，返回0

isinstance(object, classinfo)
    测试对象类型。返回 True 如果该 object 参数是 classinfo 的一个实例，或其(直接或间接)子类的实例。也返回 True 如果 classinfo 是一种 type 对象(new-style class)和是该类型或其(直接或间接)子类的对象。如果 object 不是 class 一个的实例或者给定类型的对象，函数返回 False 。如果 classinfo 既不是一个类的对象也不是一个 type 的对象，它可能是一个包含类或类型的对象的 tuple, 也可能包含其他的递归元组(序列类型不接受)。如果 classinfo 不是一个类，类型或元组类，类型，或者这种元组，将抛出一个 TypeError 异常。
    自: type(obj) is classinfo 等效于 isinstance(object, classinfo)
    type(obj) in (int, long, float) 等效于 isinstance(object, (int, long, float)) 
    # 多种类型的判断
    if type(L) == type([]):
        print("L is list")
    if type(L) == list:
        print("L is list")
    if isinstance(L, list):
        print("L is list")
        
issubclass(class, classinfo)
    返回 True 如果 class 是 classinfo (直接或间接)的子类。一个类被认为是自己的子类。
    classinfo 可能是类对象元组，在这种情况下元组中的每个 classinfo 项将被进行测试。
    功能与 isinstance 函数类似, 但是 isinstance 可以接受任何对象作为参数, 而 issubclass 函数在接受非类对象参数时会引发 TypeError 异常.

iter(o[, sentinel])
    返回一个迭代器对象。第一个参数有不同的解释，视第二个参数的存在与否而定。如果没有第二个参数，o必须是一个对象的集合，支持迭代协议(__iter__()方法)，或者它必须支持序列协议(以整数0开始的参数__getitem__()方法)。如果它不支持这些协议，将抛出TypeError异常。如果第二个参数，sentinel，给出，然后o必须是可调用的对象。在这种情况下创造的每一个迭代器无参调用o它的 next()方法，如果返回值等于sentinel，将抛出StopIteration，否则将返回其它的值。

len(s)
    返回一个对象的长度。参数可以是一个序列(字符串，元组或列表)或映射(词典)。

list([iterable])
    返回一个列表的items与可迭代的项目相同的顺序且相同的items。
    iterable 可以是一个序列，一个容器，支持迭代，或一个迭代器对象。如果 iterable 已经是一个列表，将返回一个副本，类似的于iterable[:]。
    例如，list('abc')返回['a', 'b', 'c']和list( (1, 2, 3) ) 返回[1，2，3]。如果没有给出参数，返回一个新的空列表，[]。

locals()
    更新并返回一个代表当前local符号表的字典。警告：本词典的内容不应该被修改，更改可能不会影响由interpreter用作局部变量的值。

long([x[, radix]])
    转换字符串或数字为一个长整数。如果参数是一个字符串，它必须包含一个任意大小的可能有符号的数字，并有可能嵌入空格。radix参数解释和int()一样，而且只能当x是一个字符串时才需要它。否则，参数可以是一个普通或长整数或浮点数，返回与其相同值的长整数。转换浮点数到截断的整数(直到零)。如果没有给出参数，返回0L。

map(function, iterable, ...)
    应用function在iterable的每一个项上并返回一个列表。如果有其他可迭代的参数，函数必须采取许多参数应用于来自所有iterables项。如果一个迭代比另一个短，将以None进行扩展。如果function是None，将假设为identity function，如果有多个参数，map()返回一个列表包含所有iterables相应的项目的元组组成。可迭代的参数可能是一个序列或任何可迭代的对象，结果总是一个列表。

max(iterable[, args...][key])
    一个Iterable参数，返回其中一个最大的非空可迭代项，(如一个字符串，元组或列表)。如有多个参数，返回最大的参数。
    可选的key参数指定带一个参数的排序函数，用于list.sort()。key参数，如果有，必须在以keyword的形式(例如，"max(a,b,c,key=func)")。

min(iterable[, args...][key])
    一个Iterable参数，返回其中一个最小的非空可迭代项，(如一个字符串，元组或列表)。如有多个参数，返回最小的参数。
    可选的key参数指定带一个参数的排序函数，用于list.sort()。key参数，如果有，必须在以keyword的形式(例如，"max(a,b,c,key=func)")。

object()
    返回一个新特征的对象。object是所有new style class的基类。它的方法是新样式类的所有实例共有的。

oct(x)
    转换一(任意大小)整数到一个八进制字符串。其结果是一个有效的Python表达式。

open(filename[, mode[, bufsize]])
    打开一个文件，返回一个在3.9节中描述的文件类型的对象，`File Objects'。如果文件无法打开，IOError异常引发。当打开一个文件，最好调用open()，而不是直接用file构造。
    前两个参数与stdio的 fopen()函数一样：filename是要打开的文件名，mode是一个字符串，表示该文件是如何被打开。
    mode，最常用的值是'r'读，'w'写(文件如果已存在就截断)，和'a'追加(在一些Unix系统意味着所有写入追加到文件尾部，无论其现在的seek位置)。如果模式被省略，默认为'r'等。当打开一个二进制文件，你应该模式值加上'b'，打开二进制模式，从而提高可行性。 (在某些不区分二进制文件和文本文件的系统追加‘b’，，它将作为文档)。下面是mode的可能值：
    可选bufsize参数指定文件的所需缓冲区大小：0表示无缓冲，1表示行缓冲，任何其他的正数使用其大小(在约)的一个缓冲区。负数bufsize，使用系统默认，这tty设备通常使用行缓冲和其他文件的完全缓冲。如果省略，使用系统默认。
    模式'r+', 'w+'和'a+'打开文件进行更新(请注意，'w+'截断该文件)。附加'b'的模式在区分二进制和文本文件的系统上以二进制方式打开文件，系统上没有这个区别，加入了'b'没有效果。

ord(c)
    返回一个字符串参数的ASCII码或Unicode值。给定一个长度为1的字符串，返回一个整数，当参数是一个Unicode对象，代表字符的 Unicode 代码，或参数是一个8位字符串，代表其字节值。
    例如，ord('a')返回整数97，ord(u'\u2020')返回8224。这是8位串chr()和用于Unicode对象的unichr()的逆函数。如果给出Unicode参数和Python是UCS2 Unicode的，字符的代码点必须在范围[0 .. 65535]内，否则字符串的长度是2，抛出一个 TypeErro 。

pow(x, y[, z])
    返回x的Y次方，如果给出z，返回x的y次方，模Z(比pow(x, y) % z更有效)的。这两个参数的形式pow(x, y)，相当于：x ** y

property([fget[, fset[, fdel[, doc]]]])
    返回一个new-style类(从object派生的类)的属性。
    fget是一个获取属性值的function，同样fset是设置属性值的function，fdel为删除属性的函数。典型的用途是定义一个托管属性x：

range([start,] stop[, step])
    函数可按参数生成连续的有序整数列表。
    这是一个通用函数来创建包含算术级数的列表，这是经常使用于循环。该参数必须是普通整数。如果step参数被省略，默认为1。如果省略start参数，默认为0。完整形式是返回一个普通整数列表[start, start + step, start + 2 * step, ...]。step不能为零(否则引发ValueError)。
range()支持多个迭代器，zip(),map(),filter()只支持单个迭代器

raw_input([prompt])
    如果prompt参数存在，它被写入到标准输出，结尾没有换行。然后函数从输入行读取，将其转换为一个字符串(去掉换行)，后返回。当为EOF，抛出EOFError。例如：
    如果的ReadLine模块被加载，然后raw_input()将使用它来提供详细行编辑和历史特性。

reduce(function, iterable[, initializer])
    使用带两参数的函数从左到右计算iterable的项，reduce这iterable得到一个数字。(累计计算结果，直到计算完所有项)
    例如: reduce(lambda x, y: x+y, [1, 2, 3, 4, 5]) 就是计算 ((((1+2)+3)+4)+5)。
    左参数x，是累加值和右边的参数，y，是iterable中更新的值。如果可选的initializer存在，在计算中摆在可迭代的项的前面，当iterable为空时，作为默认。如果没有给出initializer，则只包含一项，返回第一项。

reload(module)
    重新导入先前导入的模块。该参数必须是一个模块对象，因此它之前必须已成功导入。
    如果您使用外部编辑器编辑源文件的模块，并想不离开Python解释器尝试新版本,这是有用的。返回值是模块对象(与module参数相同的值)。
    注意，当你重加载模块时, 它会被重新编译, 新的模块会代替模块字典里的老模块. 但是, 已经用原模块里的类建立的实例仍然使用的是老模块(不会被更新).
    同样地, 使用 from-import 直接创建的到模块内容的引用也是不会被更新的.

repr(object)
    返回一个字符串，其中包含一个对象的可打印形式。有时是对能够访问一个普通的函数的操作很有用。对于许多类型，该函数使得试图返回一个字符串，会产生一个对象与传递给 eval() 相同的值产生的对象一样。

reversed(seq)
    返回一个反向迭代器。seq必须是一个支持序列协议的对象(__len__()方法和__getitem__()以0开始的整数参数的方法) 版本2.4中新增

round(x[, n])
    返回浮点值x四舍五入到小数点后n位后数字。如果n被省略，默认为零。结果是一个浮点数。

set([iterable])
    返回其元素都是从iterable得到的set。元素必须是不可改变的。如果iterable没有指定，返回一个新的空集，设置([]). 版本2.4中新增

setattr(object, name, value)
    与getattr()相对应。该参数是一个对象，一个字符串和一个任意值。该字符串可以是现有属性名称或一个新的属性。函数分配给该属性值，只要该对象允许的话。例如，setattr(x, 'foobar', 123)，相当于x.foobar = 123。

slice([start,] stop[, step])
    返回一个切片对象，它表示的是range(start, stop, step)指定的范围。start和step参数默认为None。切片对象有只读数据属性start，stop和step，它只是返回参数值(或默认)。没有其他明确的功能，但它们的作为数值Python和其他第三方扩展使用。当使用扩展索引语法时也产生切片对象。例如：“a[start:stop:step]”或“a[start:stop, i]”。

sorted( iterable[, cmp[, key[, reverse]]])
    返回一个新的排序的列表，包含Iterable的项。
    可选参数cmp，key，reverse与list.sort()具相同涵义(详见第3.6.4)。
    cmp指定带两个参数(Iterable的元素)，返回自一个负数，零或正数的函数“cmp=lambda x,y: cmp(x.lower(), y.lower())“。
    key指定带一个参数的函数，用来从列表每个元素中提取一个比较key：“key=str.lower”
    reverse是一个布尔值。如果设置为True，则对列表中的元素进行排序，同时每一次比较都是逆向的。
    一般而言，key和reverse转换过程是远远快于指定一个相当于cmp的功能。这是因为cmp是为每个列表元素调用很多次，而key和reverse接触每个元素只有一次。
    版本2.4中新增

staticmethod( function)
    函数返回一个静态方法。静态方法没有接收一个隐含的第一个参数。要声明一个静态方法，如下：
    class C:
        @staticmethod
        def f(arg1, arg2, ...): ...

    @staticmethod 形式 是一个function decorator
    它即可以在类上如C.f()进行调用，也可以在实例上，如：C().f()。实例被忽略，除了类。
    在Python静态方法类似于Java或C++的。对于更先进的概念，见classmethod()。

str([object])
    返回对象的可打印字符串。对于字符串，这将返回字符串本身。
    与 repr(object)不同的是， str(object)并不总是试图返回一个 eval()可以接受的字符串，其目标是返回一个可打印字符串。如果没有给出参数，返回空字符串''。

sum(iterable[, start])
    求start和可迭代的从左至右的项和并返回总和。start默认为0。在可迭代的项，通常是数字，不能是字符串。快速，正确的连接的字符串序列的方法是通过调用''.join(sequence)。注意sum(range(n), m)相当于reduce(operator.add, range(n), m)。 版本2.3中新增.

super(type[, object-or-type])
    返回类型的超类。如果第二个参数被省略，返回的超级对象是未绑定。如果第二个参数是一个对象，isinstance(obj, type)必须是true。如果第二个参数是一个类型，issubclass(type2, type)必须是true。super() 只能用于新型类。
    请注意，super是作为显式的点属性绑定过程查找的一部分，例如“super(C, self).__getitem__(name)”。因此，super是未定义对于使用语句或操作进行隐式的查找，如“super(C, self)[name]”。 版本2.2中新增.

tuple([iterable])
    把序列对象转换成 tuple 。返回一个元组的items与可迭代的iterable是相同的且有相同的顺序。iterable可能是一个序列，容器支持迭代，或迭代器对象。如果iterable是元组，直接返回。
    例如，tuple('abc')返回('a', 'b', 'c') 和tuple([1, 2, 3])返回(1, 2, 3)。如果没有给出参数，返回一个新的空元组，()。

type(object)
    返回对象的类型。返回值是一个类型对象。

type(name, bases, dict)
    返回一个新的类型的对象。这基本上是类声明的动态形式。
    该name字符串是类名，成为 __name__ 的属性;
    bases元组详细列明了基类，并成为 __bases__ 的属性，以及 dict 字典是命名空间定义为类体，成为 __dict__ 属性。
    版本2.2中新增.

unichr(i)
    返回一个Unicode码为整数i的字符的Unicode字符串。例如，unichr(97)返回字符串u'a'。这是Unicode字符串的 ord()的逆函数。参数的有效范围取决于Python如何被配置 - 它可以是UCS2 [0 .. 0xFFFF的]或UCS4 [0 .. 0x10FFFF]。否则引发ValueError。 版本2.0中新增

unicode([object[, encoding [, errors]]])
    返回object的Unicode版本字符串，使用下列方式之一：
    如果给出encoding和/或errors，Unicode()将解码可以是一个8位字符串或使用encoding解码器字符缓冲区的对象。编encoding参数是一个编码名称的字符串;如果encoding不知道，抛出LookupError。错误处理是根据errors，errors指定字符是在输入编码无效时的处理方案。如果错误是'strict'(默认)，引发ValueError，而'ignore'将忽略错误，以及'replace'值的导致官方Unicode替换字符，U+FFFD，用来取代输入的不能解码的字符。另见编解码器模块。
    如果没有可选参数，Unicode()将模仿 str()，但它返回Unicode字符串，而不是8位字符串。更确切地说，如果对象是一个Unicode字符串或其子类将返回不带任何附加解码的Unicode字符串。
    对于对象提供 __unicode__()方法，它将不带参数调用这种方法来创建一个Unicode字符串。对于其他所有对象，8位字符串版本或请求representation，使用编码'strict'模式的默认编解码器转换为Unicode字符串。

vars([object])
    如果没有参数，根据现在的 local 符号表返回一个字典。
    如果是一个模块，类或类的实例对象作为参数(或其它任何有__dict__属性)，根据对象的符号表返回一个字典。
    返回的字典不应被被修改：在相应符号表上的影响是未定义的。
    如果参数是一个类,只返回当前类的内容,父类的不管。

xrange([start,] stop[, step])
    与 range()类似，但 xrnage()并不创建列表，而是返回一个xrange对象，它的行为与列表相似，但是只在需要时才计算列表值，当列表很大时，这个特性能为我们节省内存。
    这个功能非常类似于range()，但返回一个'xrange object'而不是一个列表。这是一个不透明的序列类型，包含相应的列表相同的值而实际上没有储存这些值。xrange的优势()比range()是很小的(xrange()还是要创造请求的值)，除非使用一个非常大的范围内存的机器或所有元素从来没有使用过(例如循环通常是被打破终止的)。
    注：xrange()是为了简单和快速而设计的。施加了一定的限制，以实现这一目标。 Python的C语言实现限制所有参数的为native C longs(“short”Python整数)，并要求在这些elements都与native C long兼容。

zip([iterable, ...])
    把两个或多个序列中的相应项合并在一起，并以元组的格式返回它们，在处理完最短序列中的所有项后就停止。
    例如： zip([1,2,3],[4,5],[7,8,9])  返回： [(1, 4, 7), (2, 5, 8)]
    如果参数是一个序列，则zip()会以一元组的格式返回每个项，如：
    zip([1,2,3,4,5])  返回： [(1,), (2,), (3,), (4,), (5,)]
    不带参数，它返回一个空列表。


