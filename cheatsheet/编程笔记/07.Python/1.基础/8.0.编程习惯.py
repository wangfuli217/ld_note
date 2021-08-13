python代码中加入:

 if __name__ == "__main__":
     import doctest
     doctest.testmod()
     
python -m doctest [-v]


空格 1 Whitespace 1

    4 spaces per indentation level
    4个空格组成一个缩进
    No hard tabs
    没有制表符
    Never mix tabs and spaces
    绝不允许制表符和空格符混用
    One blank line between functions
    函数之间以一个空行分割
    类之间以二个空行分割


空格 2 Whitespace 2

    Add a space after “,” in dicts, lists, tuples, argument lists, and after “:” in dicts, but not before
    在”,”, lists, tuples, 参数列表，dict中的”:”后面加一个空格
    Put spaces around assignments, comparisons (except in argument lists)
    在赋值和比较周围加入空格
    No spaces just inside parentheses or just before argument lists
    不要在小括号或者是参数列表之前加空格
    No spaces just inside docstrings
    不要在docstrings中加入空格

        def make_squares(key, value=0):
            """Return a dictionary and a list..."""
            d = {key: value}
            l = {key: value}
            return d, l


命名 Naming

    joined_lower for functions, methods, attributes
    对函数，方法，属性统一使用小写加下划线
    joined_lower or ALL_CAPS for contrants
    对常数使用小写加下划线或者全大写
    StudlyCaps for classes
    对于类使用StudlyCaps
    camelCase only to conform to pre-existing conventions
    对于已经存在的转换：camelCase
    Attributes: interface, _internal, __private


长整行及换行 Long Lines & Continuations

    Keep lines below 80 characters in length
    保持每一行小于80个字符
    Use implied line continuation inside parentheses/brackets/braces:
    在小括号，中括号，大括号中隐式换行

        def __init__(self, first, second, third,
                     fourth, fifth, sixth):
            output = (first + second + third
                      + fourth + fifth + sixth)

    Use backslashes as a last resort:
    实在不行，用反斜杠

        VeryLong.left_hand_side \
            = even_longer.right_hand_side()

    Backslashes are fragile; the must end the line they’re on.
    反斜杠很脆弱，它们必须作为每行的最后一个字符
    If you add a space after the backslash, it won’t work any more.
    如果你在反斜杠后面加入一个空格，它就不能正常工作了。
    Also, they’re ugly.
    另外，它们丑爆了


长字符串 Long Strings

    Adjacent literal strings are concatenated by the parser:
    邻接的字母会被编译器连接在一起组成字符串

        >>> print 'o' 'n' 'e'
        one

    The spaces between literals are not required, but help with readability. Any type of quoting can be used:
    字母之间的空格并不是必须的，但是可以提高可读性，单引号和双引号可以混用

        >>> print 't' r'\/\/' """o"""
        t\/\/o

    The string prefixed with an “r” is a “raw” string. Backslashes are not evaluated as escape in raw strings.
    以”r”打头的字符串都是”raw”字符串。反斜线在raw字符串中不会被作为转义字符。
    They’re usefual for regular expressions and Windows file system path.
    这一点在正则表达式和Windows文件系统目录中很有用。

    Note named string objects are not concatenated.
    注意命名的字符串不能直接组成字符串。

        >>> a = 'three'
        >>> b = 'two'
        >>> a b
        File "<stdin>", line 1
        a b
          ^
        SyntaxError: invalid syntax

    That is because the automatic concatenation is a feature of the Python parser/compiler,
    那是因为自动连接是Python编译器的功能，
    not the interpreter. You must use the “+” to concatenate strings at run time.
    而不是解释器的功能。在运行时，你必须使用”+”来连接字符串。

    The parentheses allow implicit line continuation.
    圆括号中允许隐式行连接。

        text = ('Long strings can be made up '
        'of several shorter strings.')

    Multiline strings use triple quotes:
    多行字符串可以使用三个引号

        """Triple
        double
        quotes"""

        '''\
        Triple
        single
        quotes\
        '''

    In the last example above (triple single quotes), note how the backslashes are used to
    在上面的最后一个例子中(三个单引号), 注意反斜线是如何使用来转义行尾的。
    escape newlines. This eliminates extra newlines, while keeping the text and quotes nicely
    这样继减少了新的空行，又使得文字保持了漂亮的左对齐。
    left-justified. The backslashes must be at the end of their lines.
    反斜线必须用在每一行的最后。

    Compound statements
    复合表达式
    Good:

        if foo == 'blah':
            do_something()
        do_one()
        do_two()
        do_three()

    Bad:

        if foo == 'blah': do_something()
        do_one(); do_two(); do_three()

    Whitespace & indentations are useful visual indicators of the program flow. The indentation
    空格和缩进对代码的流程有直观的指示作用。
    of the second “Good” line above shows the reader that something’s going on, whereas the lack
    在”Good”中第二行的缩进向读者显示了有的事情还在继续，
    of indentation in “Bad” line hides the “if” statement.
    而在”Bad”中没有缩进则隐藏了”if”表达式。

    Docstrings & Comments
    文档说明和注释
    Docstrings = How to use code
    文档说明 = 如何使用代码
    Comments = Why (rationale) & how code works
    注释 = 代码为什么要这样写，如何工作

    Docstrings explain how to use code, and are for the users of your code.
    文档说明用来解释代码是如何工作的，是写给读代码的人看的。
    Uses of docstrings:
    文档说明的作用：
    - Explain the purpose of the fuction even if it seems obvious to you, because it might not be
    - 解释函数的功能，即使它看起来对你显而易见，但它对后来看你的代码的人来说未必显而易见。
    - obvious to someone else later on.
    - Describe the parameters expected, the return values, and any exceptions raised.
    - 描述期望的参数，返回值和任何可能出现的异常
    - If the method is tightly coupled with a single caller, make some mention of the caller.
    - 如果这个方法与调用者紧密相关，有必要提一下调用者
    - (Though be careful that the caller might be changed later)
    - 但要注意调用者后面可能会改变
    - Comments explain why, and are for the maintainers of your code. Examples include notes to yourself, like:
    - 注释是为了维护代码而写的，它解释了为什么要这样做。例如写一些note来提醒一下自己。

    # !!! BUG: ...
    # !!! FIX: This is a hack
    # ??? Why is this here?

    Both of these groups include you, so write good docstrings and comments!
    所有的这些都与你相关，所以写好文档说明和注释
    Docstrings are useful in interactive use (help()) and for auto-documentation systems.
    文档说明在使用交互式help命令时有用，也可以用来自动生成文档。

    False comments & docstrings are worse than none at all.
    不正确的注释和文档说明比没有还要糟糕。
    So keep them up to date!
    所以要让它们保持最新
    When you make changes, make sure the comments & docstrings are consisitent with the code,
    当你改代码的时候，把注释和文档说明也要一起更新
    and don’t contradict it.
    不能让它们自相矛盾。



实用性高于纯粹性 Practicality Beats Purity

    There are always exceptions. From PEP 8:
    事情总有例外，从PEP 8:

    But most importantly: know when to be inconsistent - sometimes the style guide just doesn’t apply.
    最重要的是：知道什么时候不再保持一致性 – 有时候规范指导并不有效。
    When in doubt, use your best judgement. Look at other examples and decide what looks best.
    当你有所怀疑的时候，尝试做尽可能好的决定。参考其它的例子来决定怎么做最好。
    And don’t hesitate to ask!
    有问题不要犹豫
    Two good reasons to break a particular rule:
    两个打破特殊规则的理由：
    1. When applying the rule would make the code less readable,
    当使用该规则会让代码变得难以理解，
    even for someone who is used to reading code that follows the rules.
    即使是对于那些熟知规则的人来说也是这样。
    2. To be consisitent with surrouding code that also breaks it (maybe for historic reasons)
    （也许是历史原因）与周围的代码一致也不符合规则
    – although this is also an opportunity to clean up someone else’s mess.
    尽管这是一个清理他人烂摊子的好机会。
    … But practicality shouldn’t beat purity to a pulp!
    但也不能因为实用就把代码变成一坨屎.


Swap Values (值互换)

    In other languages: 在其它编程语言里：

        temp = a
        a = b
        b = temp

    In python: 如果用Python

        b, a = a, b

    Perhaps you’ve seen this before. But do you know how it works?
    也许你曾经看到过这种用法。但你知道它的原理么？
    - The comma is the tuple constructor syntax.
    - 逗号是tuple的构造语法
    - A tuple is created on the right (tuple packing)
    - 在等号的右边，一个tuple被创建了
    - A tuple is the target on the left (tuple unpacking)
    - 左边也会生成一个tuple
    The right-hand side is unpacked into the names in the tuple on the left-hand side.
    右边的tuple会被分解到以左边名字命名的tuple中。

    Further examples of unpacking:

        >>> l = ['David', 'Pythonista', '+1-514-555-1234']
        >>> name, title, phone = l
        >>> name
        'David'
        >>> title
        'Pythonista'
        >>> phone
        '+1-514-555-1234'

    Useful in loops over structured data:
    l above is the list we just made (David’s info). So people is a list containing two items,
    l是我们上面刚建好的列表。people是一个包含两个成员的列表，每个成员又是一个3个成员的列表。
    each a 3-item list.

        >>> people = [l, ['guido, 'BDFL', 'unlisted']]
        >>> for (name, title, phone) in people:
        ...     print name, phone
        ...
        'David', '+1-514-555-1234'
        'Guido', 'unlisted'

    Each item in people is being unpacked into the (name, title, phone) tuple.
    每一个people中的成员都会被分解到(name, title, phone)的tuple中。
    Arbitrarily nestable (just be sure to match the structure on the left & right!):
    支持嵌套

        >>> david, (gname, gtitle, gphone) = people
        >>> gname
        'Guido'
        >>> gtitle
        'BDFL'
        >>> gphone
        'unlisted'
        >>> david
        ['David', 'Pythonista', '+1-514-555-1234']


关于Tuple， More About Tuples

    We saw that the comma is the tuple constructor, not the parentheses. Example:
    逗号是tuple的构造器，而不是括号。例如：

        >>> 1,
        (1,)

    The Python interpreter shows the parentheses for clarity, and I recommend you use parentheses too:
    为了清晰地显示，python解释器会显示括号，所以我也推荐你使用括号

        >>> (1, )
        (1,)

    Don’t forget the comma!
    但不要忘了逗号！

        >>> (1)
        1

    In a one-tuple, the trailing comma is required; in 2+-tuples, the trailing comma is optional.
    在只有一个成员的tuple中，末尾的逗号是必须的，在含两个以上成员的tuple中，末尾的逗号是可选的。
    In 0-tuples, or empty tuples, a pair of parentheses is the shortcut syntax:
    在空的tuple中，括号是最简单的表达方式。

        >>> ()
        ()
        >>> tuple()
        ()

    A common typo is to leave a comma even though you don’t want a tuple. It can be easy to miss in your code.
    常见的错误是在你不想要tuple的地方留下了一个逗号。这样的情况在代码中很容易发生

        >>> value = 1,
        >>> value
        (1,)

    So if you see a tuple where you don’t expect one, look for a comma!
    所以如果你在一个意想不到的地方看到了tuple, 那就查一下是不是有不该有的逗号吧！


用在交互窗口使用的”” Interactive “”

    This is a really useful feature that surprisingly few people know.
    这是一个非常有用但又很少人知道的功能
    In the interactive interpreter, whenever you evaluate an expression or call a function,
    在交互式命令行中，无论你是执行一条语句还是调用一个函数，
    the result is bound to a temporary name, _(underscore).
    返回的结果都有一个临时的名字, ‘_’(下划线)

        >>> 1 + 1
        2
        >>> _
        2

    _ stores the last printed expression.
    _ 保存了上一次被打印的表达式的值。
    When a result is None, nothing is printed, so _ doesn’t change. That’s convinenient!
    当结果是 None 时，没有值被打印，所以_也不会变，这非常地方便。
    This only works in the interactive interpreter, not within a modoule.
    这个只有在交互式命令行中有效，在模块中无效。
    It is especially useful when you’re working out a problem interactively,
    这个在命令行中求解问题时，当你刚算出一个结果
    and you want to store the result for a later step.
    又想要在下一步中使用这个结果时很有用。

        >>> import math
        >>> math.pi / 3
        1.0471975511965976
        >>> angle = _
        >>> math.cos(angle)
        0.50000000000000011
        >>> _
        0.50000000000000011


用子串构建字符串 Building Strings from Substrings

    Start with a list of strings:
    让我们从一个字符串队列开始：

        colors = ['red', 'blue', 'green', 'yellow']

    We want to join all the strings together into one large string.
    我们想要把所有的字符串连接起来组成一个大的字符串
    Especially when the number of substrings is large…
    尤其是在列表很大的时候：
    Don’t do this:
    不要这样做

        result = ''
        for s in colors:
            result += s

    This is very inefficient.
    这非常得不高效
    It has terrible memory usage and performance patterns. The ‘summation” will compute,
    这样做会占用很大的内存和运算资源。对其做加法需要运算，保存和销毁很多中间的变量。
    store, and then throw away each intermediate step.

    Instead, do this:
    而应该这样做：

        result = ''.join(colors)

    When you are only dealing with a few dozen or hundred strings, it won’t make much difference.
    当你只是处理几十个或者是几百个字符串的时候，这并没有太大的区别。
    But get in the habit of building strings efficiently, because with thousands or with loops, it will make a difference.
    但是要养成高效的习惯，因为当有成千上万的字符串的时候，差别就显现出来了。


构建字符串 Building Strings, Variations 1

    Here are some techniques to use the join() string method.
    下面是一些使用join()字符串方法的技巧
    If you want spaces between your substrings:
    如果你想要用空格来连接子字符串

        result = ' '.join(colors)

    Or commas and spaces:
    或者是逗号加空格

        result = ', '.join(colors)

    Here’s a common case:
    这里是一个常见的例子。

        colors = ['red', 'blue', 'green', 'yellow']
        print 'Choose', ', '.join(colors[:-1]), \
        'or', colors[-1]

    To make a nicely grammatical sentence, we want commas between all but the last pair of values,
    为了生成一个符合语法的句子，我们想要在除了最后一组单词之间插入空格
    where we want the word ‘or’. The slice syntax does the job.
    在最后一组单词中放入’or’关键词。使用分割语法可以做到这一点。
    The “slice until -1”([:-1]) gives all but the last value, which we join with comma-space.
    “slice until -1” ([:-1]) 可以帮助你在用逗号和空格连接时提供除了最后一组外的所有单词。

    Of course, this code wouldn’t work with corner cases, lists of length 0 or 1.
    当然，上面的代码无法应对一些特殊情况，如列表的长度为0或者为1的时候。

    Output:

        Choose red, blue, green or yellow


构建字符串 Building Strings, Variations 2

    If you need to apply a function to generate the substrings:
    如查你想要先通过函数来生成子字符串：

        result = ''.join(fn(i) for i in items)

    This involves a generator expression, which we’ll cover later.
    这个涉及到生成器表达式，我们在后面会讨论这个。

    If you need to compute the substrings incrementally, accumulate them in a list first:
    如果你想要处理的子字符串在动态地增加，那么先把它们增加到一个列表里面

        items = []
        ...
        items.append(item) # many times
        ...
        # items is now complete
        result = ''.join(fn(i) for i in items)

    We accumulate the parts in a list so that we can apply the join string method, for efficiency.
    只有把它们放到列表里面，我们才能使用join方法来提高效率。


尽可能的用关键字 “in” Use in where possible (1)

    Good:

        for key in d:
            print key

    in is generally faster
    in 通常会更快
    This pattern also works for items in arbitrary containers(such as lists, tuples, and sets)
    这个模式对于其它的一些容器也适用，如lists, tuples, sets
    in is also an operator (as we’ll see)
    in 也是一个操作符
    Bad:

        for key in d.keys():
            print key

    This is limited to objects with a keys() method.
    这样写就只能用于带keys()方法的对象


尽可能的用”in”(2) Use in where possible （2）

    But .keys() is necessary when mutating the dictionary:
    但是当试图改变字典时，.keys()还是必要的

        for key in d.keys():
            d[str(key)] = d[key]

    d.keys() creates a static list of the dictionary keys. Otherwise, you’ll get an expression
    d.keys() 会创建一个由所有keys组成的静态的列表。否则，你会得到以下错误：
    “RuntimeError: dictionary changed size during iteration”.
    “运行时错误，字典的大小在遍历时发生变化”

    For consistency, use key in dict, not dict.has_key():
    为了一致性，使用key in dict, 而不是dict.has_key（）：

        # do this
        if key in d:
            do something with d[key]

        # not this
        if d.has_key(key):
            do something with d[key]


字典的get方法 Dictionary get Method

    We often has to initialize dictionary entries before use:
    我们在使用字典之前通常都要初始化一下
    This is a naive way to do it:
    以下是很弱智的做法：

        navs = {}
        for (portfolio, equity, position) in data:
            if portfolio not in navs:
                navs[portfolio] = 0
            navs[portfolio] += position * prices[equity]

    dict.get(key, default) removes the need for the test:
    dict.get(key, default) 可以省掉这样的测试语句。

        navs = {}
        for (portfolio, equity, position) in data:
            navs[portfolio] = (navs.get(portfolio, 0)
                                + position * prices[equity]

    Much more direct。
    这样更直接


字典中的”setdefault”方法（1） Dictionary setdefault Method (1)

    Here we have to initialize mutable dictionary values. Each dictionary value will be a list.
    在这里我们要对一个字典初始化为不同成员，每个成员都是一个列表。
    Initializing mutable dictionary values:

        equities = {}
        for (portfolio, equity) in data:
            if portfolio in equities:
                equities[portfolio].append(equity)
            else:
                equities[portfolio] = [equity]

    dict.setdefault(key, default) does the job much more efficiently
    dict.setdefault(key, default) 可以更高效地实现这一点

        equities = {}
        for (portfolio, equity) in data:
            equities.setdefault(portfolio, []).append(equity)

    dict.setdefault() is equivalent to “get, or set & get”. Or “set if necessary, then get”.
    dict.setdefault() 相当于 “get, or set & get”. 或者 “set if necessary, then get”.
    It’s especially efficient if your dictionary key is expensive to compute or long to type.
    它在你的字典key很难算出来或者是很长不好拼写的时候很高效。
    The only problem with dict.setdefault() is that the default value is always evaluated, whether needed or not.
    dict.setdefault()唯一的问题就是永运会计算默认值，不管需不需要。
    That only matters if the default value is expensive to compute.
    这只有在计算默认值开销很大的时候才值得担心。
    If the default value is expensive to compute, you may want to use the defaultdict class, which we’ll cover shortly.
    如果默认值的计算开销真的很大，你可以考虑defaultdict类，这我们很快会讲到。


字典中的“setdefault”方法（2） Dictionary setdefault Method (2)

    Here we see that the setdefault dictionary method can also be used as a stand-alone statement:
    在这里我们可以看到setdefault字典方法可以被作为一个标准的表达式出现。

        navs = {}
        for (portfolio, equity, position) in data:
            navs.setdefault(portfolio, 0)
            navs[portfolio] += position * prices[equity]

    The setdefault dictionary method returns the default value, but we ignore it here.
    setdefault方法返回了默认值，但我们却忽略了它。
    We’re taking advantage of setdefault’s side effect,
    我们利用了setdefault的副作用，
    that it sets the dictionary value only if there is no value already.
    那就是只有在字典中没有这个key的时候它才会去赋值。


defaultdict

    New in Python 2.5
    Python 2.5中的新功能
    defaultdict is new in Python 2.5, part of the collections module.
    defaultdict作为collections模块的一部门，是Python 2.5中的新功能。
    defaultdict is identical to regular dictionaries, except for two things:
    defaultdict 在除了以下两点之外与通常的字典相同
    - it takes an extra first argument: a default factory function; and
    - 它多接收一个参数：一个默认值工厂函数
    - when a dictionary key is encountered for the first time, the default factory function is called and the result used to initialize the dictionary value.
    - 当字典中的key第一次出现的时候，默认值工厂函数会被调用来给这个key赋值。
    There are two ways to get defaultdict:
    有两种方式来获取defaultdict
    - import the collections modoule and reference it via the module

        import collections
        d = collections.defaultdict(...)

    or import the defaultdict name directly
        from collections import defaultdict
        d = defaultdict(...)

    Here’s the example from earlier, where each dictionary value must be initialized to an empty list, rewritten as with defaultdict:
    下面是一个早期的例子，用defaultdict重写对每一个字典成员的初始化为空列表

        from collections import defaultdict
        equities = defaultdict(list)
        for (portfolio, equity) in data:
            equities[portfolio].append(equity)

    There’s no fumbling around at all now. In this case, the default factory function is list,
    这样就没有什么瞎摸乱撞了, 默认的工厂函数是列表
    which returns an empty list.
    这样就会返回一个空的列表

    This is how to get a dictionary with default values of 0: use int as a default factory function:
    以下是如何将字典的默认值设成0：用int作为默认的工厂函数

        navs = defaultdict(int)
        for (portfolio, equity, position) in data:
            navs[portfolio] += position * prices[equity]

    You should be careful with defaultdict though.
    但是在使用defaultdict的时候也要小心
    You cannot get KeyError exceptions from properly initialized defaultdict instances.
    被正常初始化的defaultdict实例不再会抛出异常
    You have to use a “key in dict” conditional if you need to check for the existence of a special key.
    你必须使用”key in dict”的条件判断来检查关键字是否合法


构建和拆分字典 Building & Splitting Dictionaries

    Here is a useful technique to build a dictionary from two lists(or sequences):
    以下是一种使用两个列表来生成字典的有用的方法
    one list of keys, another list of values
    一个列表作为关键字，另一个作为值。

        given = ['John', 'Eric', 'Terry', 'Michael']
        family = ['Cleese', 'Idle', 'Gilliam', 'Palin']
        pythons = dict(zip(given, family))
        >>> pprint.pprint(pythons)
        {'John': 'Cleese',
        'Michael': 'Palin',
        'Eric': 'Idle',
        'Terry': 'Gilliam'}

    The reverse, of course, is trival:

        >>> pythons.keys()
        ['John', 'Michael', 'Eric', 'Terry']
        >> pythons.values()
        ['Cleese', 'Palin', 'Idle', 'Gilliam']

    Note that the order of the results of keys() and values() is different from the order of items
    请注意keys()和vaules()返回值的顺序有可能和刚开始构造字典的顺序不同。
    when constructing the dictionary. The order going in is different from the order coming out.
    进去的顺序和出来的顺序是不一致的。
    This is because a dictionary is inherently unordered. However, the order is guaranteed to be consisitent
    这是因为字典本来是无序的，然而，只要字典在被使用的过程不被更改，字典中的成员的顺序是不会变的。
    (in other words, the order of keys will correspond to the order of values),
    as long as the dictionary isn’t changed between calls.


检查真值 Testing for Truth Values

        # do this:      # not this:
            if x:           if x == True:
                pass            pass

    It is elegant and efficient to take advantage of the intrinsic truth values
    使用内建的真值来判断更加高效和优雅
    (or Boolean values) of Python objects.
    Testing a list:
    测试列表是否为空

        # do this                   # not this:
            if items:                   if len(items) != 0:
                pass                        pass
                                    # and definitely not this:
                                        if items != []:
                                            pass


真值 Truth Values

    The True and False names are build-in instances of type bool， Boolean values.
    True和False是内建的bool实例
    Like None, there is only one instance of each.
    就如同None一样，它们都是单例
    |False |True |
    |False(==0) |True(==1) |
    |”“(empty string) |any string but “” (” “, “anything”) |
    |0, 0.0 |any number but 0 (1, 0.1, -1, 3.14) |
    |[], (), {}, set() |any none empty container |
    |None |almost any object taht’s not explicitly False |

    Example of an object’s truth value:
    对象为真值的示例：

        >>> class C:
        ...     pass
        ...
        >>> o = C()
        >>> bool(o)
        True
        >>> bool(C)
        True

    To control the truth value of instances of a user-defined class,
    对于用户自定义的类的实例，为了控制其真值
    use the nonezero or len special methods, Use len if your container which has a length.
    可以使用nonezero或者是len这个的特殊方法， 如果你的容器有长度，那就用len吧。

        class MyContainer(object):
            def __init__(self, data):
                self.data = data

            def __len__(self):
                ''' Return my length '''
                return len(self.data)

    If your class is not a container, use nonezero:
    如查你的类不是一个容器，那就用nonezero

        class MyClass(object):
            def __init__(self, value):
                self.value = value

            def __nonezero__(self):
                ```Return my truth value (True or False)```
                return bool(self.value)

    In Python 3.0, nonezero has been renamed to bool for consistency with the bool built-in type.
    在python 3.0中，为了保持与内建类型bool的一致性, nonezero会被重名命为bool
    For compatibility, add this to the class definition:
    为了兼容性，把下面的定义加入到类的定义中：

        __bool__ = __nonezero__


索引和成员（1） Index & Item (1)

    Here’s a cute way to save some typing if you need a list of words:
    在你想生成一个由单词组成的列表中的时候，如果你想要少打一点字， 下面是一种办法：

        >>> items = 'zero one two three'.split()
        >>> print items
        ['zero', 'one', 'two', 'three']

    Say we want to interate over the items, and we need both the item’s index and the item itself:
    如果我们想要遍历所有的成员，并且得到下标和对象本身，可以使用下面的方法：

        i = 0
        for item in items:      for i in range(len(items)):
            print i, item           print i, items[i]
            i += 1

    We need to use a list wrapper to print the result because enumerate is a lazy function:
    我们需要使用一个list关键字来将enumerate的结果转化为列表，因为这是一个比较懒的函数。
    it generates one item, a pair, at a time, only when required.
    它只在必要的时候一次只生成一个成员或者是一对成员
    A for loop is one place that requires one result at a time. enumerate is an example of a generator,
    for循环是一个一次只要一个结果的地方，enumerate是一个生成器的例子,
    which we’ll cover in greater detail later.
    我们会在后面详细讨论
    print does not take one result at a time –
    print并非一次只取一个结果
    we want the entire result, so we have to explicitly convert the generator into a list when we print it.
    我们想要所有的结果，所以我们要将生成器转化成列表，这样才能一次打出。

    Our loop becomes much simpler:

        for (index, item) in enumerate(items):
            print index, item

        # compare                       # compare
        index = 0                       for i in range(len(items)):
        for item in items:                  print i, items[i]
            print index, item
            index += 1

    The enumerate version is much shorter and simpler than the version on the left,
    enumerate版本的代码比起左边的代码来要更简单易读，且容易理解
    and much easier to read and understand than earlier.

    An example showing how the enumerate function actually returns an iterator (a generator is a kind of iterator):
    下面的例子可以看出enumerate函数实际返回的是一个迭代器

        >>> enumerate(items)
        <enumerate object at 0x011EA1C0>
        >>> e = enumerate(items)
        >>> e.next()
        (0, 'zero')
        >>> e.next()
        (1, 'one')
        >>> e.next()
        (2, 'two')
        >>> e.next()
        (3, 'three')
        >>> e.next()
        Traceback (most recent call last):
        File "<stdin>", line 1, in ?
        StopIteration


Other language have “variables”

    In many other languages, assigning to a variable puts a value into a box.
    在许多其它的语言中，向一个变量赋值就像把一个值放入一个盒子中。

        int a = 1;

    Box “a” now contains an integer 1.
    盒子”a”中现在有一个整数1.

    Assigning another value to the same variable replaces the contents of the box:
    向同样的对像中赋另外一个值将会替换盒子中原来的内容

        int a = 2;

    Now box “a” contains an integer 2.
    现在盒子”a”中放的是整数2.

    Assigning one variable to another makes a copy of the value and puts it in the new box:
    将一个变量赋值给另一个，会将其值做一个拷贝然后再放入新的盒子中

        int b = a;

    “b” is a second box, with a copy of integer 2. Box “a” has a separate copy.
    “b”就是第2个盒子，它拥有整数2的一个拷贝，与盒子”a”中的是不同的一份。

    Python中的名字 Python has “names”

    In Python, a “name” or “identifier” is like a parcel tag (or nametag) attached to an object.
    在python中，一个名字或者是标识符更像是系在一个对象上面的标签。

        a = 1

    Here, an integer 1 object has a tag labelled “a”.
    在这里，整数1对象有一个叫”a”的标签
    If we reassign to “a”, we just move the tag to another object:
    如果我们对”a”重新赋值，我们只是把”a”这个标签换到了另一个对象上面

        a = 2

    Now the name “a” is attached to an integer 2 object.
    现在整数2有了一个名叫”a”的标签
    The original integer 1 object no longer has a tag “a”. It may live on,
    原来的整数1不再有”a”的标签，它可以继续存在，但我们不能再用标签”a”来访问它。
    but we can’t get to it through the name “a”.

    If we assign one name to another, we’re just attaching another nametag to an existing object:
    如果我们把一个变量赋值给另一个，那就会有两个标签同时指向一个对象

        b = a

    The name “b” is just a second tag bound to the same object as “a”.
    “b”和”a”都指向了同一个对象，只是名字不同而已

    Although we commonly refer to “variables” evne in Python (because it’s common terminology),
    虽然我们经常在python里面称变量，因为这是一个通用的名词
    we really means “names” or “identifiers”. In Python, “variables” are nametags for values, not labelled boxes
    但其实我们指的是”名字”和”标示符”。在Python里面，变量只是数值的标签，而不是带标志的容器

    默认参数值 Default Parameter Values

    This is a common mistake that beginners often make.
    这是一个初学者常犯的错误
    Even more advanced programmers make this mistake if they don’t understand Python names.
    如果不理解Python变量的真正含义，即使是有经验的程序员也会范这样的错误

        def bad_append(new_item, a_list=[]):
            a_list.append(new_item)
            return a_list

    The problem here is the default value of a_list, an empty list, is evaluated at function definition time.
    这个问题在于，a_list的默认值，一个空的list, 是在函数定义的时候被定义的时候赋值的
    So every time you call the function, you get the same default value. Try it several times:
    所以，每次调用这个函数，你都会得到同样的默认值。

        >>> print bad_append('one')
        ['one']
        >>> print bad_append('two')
        ['one', 'two']

    Lists are a mutable objects; you can change their contents. The correct way to get a default list
    列表是可变的对象，你可以修改其中的内容，正确的获取默认列表的做法是
    (or dictionary, or set) is to create it at run time instead, inside the function:
    在函数的内部，运行时去创建它

        def good_append(new_item, a_list=None):
            if a_list is None:
                a_list = []
            a_list.append(new_item)
            return a_list


“%”字符串格式化 % String Formatting

    Python’s % operator works like C’s sprintf function
    Python的 % 操作符和C语言的sprintf函数一样
    Although if you don’t know C, that’s not very helpful.
    如果你不了解C也没有关系
    Basically, you provide a template or format and interpolation values.
    简单来说，你提供了一个模版或者说是格式并且为其提供对应的值
    In this example, the template contains two conversion specifications: “%s” means
    以下面的例子中，模版包含了两个转换规则：”%s”
    “insert a string here”, and “%i” means “convert an integer to a string and insert here”.
    是指”在这里插入字符串”, “%i”是将整数转换成字符串然后再插入
    “%s” is particularly useful because it uses Python’s build-in str() function to convert any object to a stirng.
    “%s”尤其有用，因为它使用了Python的内建str()函数来将任意的对象转换成字符串

    The interpolation values must match the template; we have two values here, a tuple.
    填写的数值要和模版保持一致, 在这里我们有两个值

        name = 'David'
        message = 3
        text = ('Hello %s, you have %i message'
            % (name, message))
        print text

    Output:

        Hello David, you have 3 messages


高级”%”字符串格式化 Advanced % String Formatting

    What many people don’t realize is that there are other, more flexible ways to do string formatting:
    很多人没有意识到的是，其实有更多更灵活的方式来对字符串进行初始化
    By name with a dictionary:
    通过字典中的名字

        values = {'name':name, 'messages':messages}
        print ('Hello %(name)s, you have %(messages)i messages' % values)

    Here we specify the names of interpolation values, which are looked up in the supplied dictionary.
    这里我们列出了要插入值的名字，它们可通过所提供的字典查到。

    Note: Class attributes are in the class dict. Namespace lookups are actually chained dictionary lookups.
    注意，类的属性在类dict中，命名空间的访问实际上是链式字典访问。


列表推导 List Comprehensions

    List comprehensions (“listcomps” for short) are syntax shortcuts for this general pattern:
    列表推导是一种通过的模式
    The traditional way, with for and if statements:
    传统的方法是使用for和if表达式

        new_list = []
        for item in a_list:
            if condition(item):
                new_list.append(fn(item))

    As a list comprehension:
    列表推导

    new_list = [fn(item) for item in a_list if condition(item)]

    Listcomps are clear & concise, up to a point.
    在一定程度上，列表推导更清晰简洁
    You can have multiple for-loops and if-conditions in a listcomp, but beyond two or three total,
    在列表推导中，你可以有多个for循环和if条件，但如果总数超过了两到三个，
    or if the conditions are complex, I suggest that regular for loops should be used.
    或者说条件判断太复杂，我建议你使用常规的for循环
    Applying the Zen of Python, choose the more readable way.
    引用Python之禅，可读性更重要

    For example, a list of the squares of 0-9:
    例如，0-9的平方所组成的列表

        >>> [n ** 2 for n in range(10)]

    A list of the squares of odd 0-9:
    0-9中奇数的平方所组成的列表

        >>> [n ** 2 for n in range(10) if n % 2]


生成器表达式（1） Generator Expressions(1)

    Let’s sum the squares of the numbers up to 100:
    让我们来计算加到100的和
    As a loop:
    作为一个循环：

        total = 0
        for num in range(1, 101):
            total += num * num

    We can use sum function to quickly do the work for us, by building the appropriate sequence.
    我们可以用sum函数来快速地做这个事，通过构造合适的序列
    As a list comprehension
    使用列表推导

        total = sum([num * num for num in range(1, 101)])

    As a generator expression:
    使用生成器表达式

        total = sum(num * num for num in xrange(1, 101))

    Generator expressions(“genexps”) are just like list comprehensions, except that where listcomps are greedy,
    生成器表达式比较像列表推导，除了一点，那就是列表推导是贪婪的
    generator expressions are lazy. Listcomps compute the entire result list all at once, as a list.
    生成器表达式则是懒惰的。列表推导一次性地算出所有值，作为一个列表。
    Generator expressions compute one value at a time, when needed, as individual values.
    生成器表达式仅当需要的时候，一次算出一个值。
    This is especially useful for long sequences where the computed list is just an intermediate step and not the final result.
    这个在长序列作为临时参数而不是最终计算结果时特别有用。
    In the case, we’re only interested in the sum; we don’t need the intermediate list of squares.
    在这个例子中，我们只关心最终的运算结果，并不想要临时的平方数列表。
    We use xrange for the same reason: it lazily produces values, one at a time.
    我们使用xrange作为同样的原因，它很懒，一次只产生一个值


生成器表达式（2） Generator Expressions(2)

    For example, if we were summing the squares of several billion integers,
    例如，我们上十亿个整数的平方和
    we’d run out of memory with list comprehensions, but generator expressions have no problem.
    如果使用列表推导，我们将耗尽内存，但如果使用生成器表达式则没有这样的问题
    This does take time, though!
    但这也同样需要很长的时间

        total = sum(num * num for num in xrange(1, 1000000000))

    The difference in syntax is that listcomps have square brackets, but generator expressions don’t.
    这里有一个区别，列表推导有中括号，而生成器表达式则没有
    Generator expressions sometimes do require enclosing parentheses though, so you should always use them.
    生成器表达式有时必须要括号，所以你应该一直使用它们

    Rules of thumb:
    经验法则：
    - Use a list comprehension when a computed list is the desired end result
    - 如果运算出来的列表是最终结果，那么请使用列表推导
    - Use a generator expression when the computed list is just an intermediate step.
    - 如果运算出来的列表只是中间步骤，那么请使用生成器表达器

    We needed a dictionary mapping month numbers(both as string and as integers) to month codes for futures contracts.
    The way this works is as follows:
    - The dict() built-in takes a list fo key/value pairs(2-tuples).
    - We have a list of month codes (each month code is a single letter, and a string is also just a list of letters).
    We enumerate over this list to get both the month code and the index
    - The month numbers start at 1, but Python starts indexing at 0, so the month number is one more than the index.
    - We want to look up months both as strings and as integers. We can use int() and str() functions to do this for us,
    and loop over them.

    Recent example:

        month_codes = dict((fn(i+1), code)
                        for i, code in enumerate('FGHJKMNQUVXZ')
                        for fn in (int, str))

    month_codes result:

        { 1: 'F', 2: 'G', 3: 'H', 4: 'J', ...
        '1': 'F', '2': 'G', '3': 'H', '4': 'J', ...}


排序 Sorting

    It’s easy to sort a list in Python
    在Python中对列表进行排序很容易

        a_list.sort()

    (Note that the list is sorted in-place: the original list is sorted,
    注意列表是就地排序的，也就是说sort方法不会返回或者生成一个列表的拷贝，
    and the sort method does not return the list or a copy.
    直接对原来的列表进行排序

    But what if you have a list of data that you need to sort, but it doesn’t sort naturally?
    但万一你有许多数据要非正常的方式排序？
    (i.e., sort on the first column, then the second column, etc.)
    比如说先按第一列排，再按第二列排
    You man need to sort on the second column first, then the fourth column.
    你也许需要先对第二列排序，然后是第四列
    We can use list’s built-in sort method with a custom function.
    我们可以对列表的内建sort函数传入一个自定义比较函数。

        def custom_cmp(item1, item2):
            return cmp((item1[1], item1[3]),
                       (item2[1], item2[3]))
        a_list.sort(custom_cmp)

    This works, but it’s extremely slow for large lists.
    这个做是可以工作的，但在列表很大的时候非常慢


Sorting with DSU *

    DSU = Decorate-Sort-Undecorate
    * Note: DSU is often on longer necessary. See the next section, Sorting With Keys for the new approach.

    Instead of creating a custom comparison function, we create an auxiliary list that will sort naturally:
    为了不用自定义的比较函数，我们创造一个按正常方式排序的辅助列表

        # Decorate
        to_sort = [(item[1], item[3], item)
                    for item in a_list]
        # Sort
        to_sort.sort()

        # Undecorate
        a_list = [item[-1] for item in to_sort]

    The first line creates a list containing tuples: copies of the sort terms in priority order,
    第一行创建了一个由元组组成的列表，按优先级顺序放置了要排序的元素，
    followed by the complete data record.
    后面跟着的是完整的数据。
    The second line does a native Python sort, which is very fast and efficient.
    第二行使用了Python原始的排序，非常快捷高效
    The third line retrieves the last value from the sorted list.
    最后一行遍历已排序列表的最后一个元素。
    Remember, this last value is the complete data record.
    记住，最后的值是完整的数据记录
    We’re throwing away the sort terms, which ahve done their job and are no longer needed.
    我们在扔掉一些排序的元素，这些元素已经完成使命，不需要再用
    This is a tradeoff of space and complexity against time.
    这是一个空间换时间的交易
    Much simpler and faster, but we do need to duplicate the original list.
    更简单和快捷，但我们需要复制原来的列表


值排序 Sorting With Keys

    Python 2.4 introduced an optional argument to the sort list method,
    Python 2.4 为sort方法引入一个可选参数 “key”
    “key”, which specifies a function of one argument that is used to compute a comparison key from each list element.
    它可以用来针对每一个列表成员定义专门的比较函数

        def my_key(item):
            return (item[1], item[3])

        to_sort.sort(key=my_key)

    The function my_key will be called once for each item in the to_sort list.
    函数my_key会在获取每一个列表元素进行排序的时候被调用到

    You can make your own key function, or use any existing one-argument function if applicable.
    你可以生成你自己的key函数，或者是使用已有的单个参数函数
    - str.lower to sort alphabetically regardless of case
    - 忽略大小写排序， str.lower
    - len to sort on the length of the items (strings or containers)
    - 按长度排序，len
    - int or float to sort numerically, as with numeric strings like “2”, “123”, “35”
    - 按数值的大小排序，int, float


生成器 Generators

    We’ve already seen generator expressions.
    我们已经见过生成器表达式了
    We can devise our own arbitrarily complex generators, as functions:
    我们可以写出任意复杂的生成器作为函数

        def my_range_generator(stop):
            value = 0
            while value < stop:
                yield value
                value += 1

        for i in my_range_generator(10):
            do_something(i)

    The yield keyword turns a function into a generator. When you call a generator function,
    yield关键字把一个函数转换成一个生成器。当你调用一个生成器函数的时候，
    instead of running the code immediately Python returns a generator object;
    Python把它变成了一个生成器对象而不是立即去执行
    it has next method. for loops just call the next method on the iterator, until a StopIteration exception is raised.
    这个对象有next方法。for循环就是直接调用next方法来完成迭代，直到StopIteration的异常发生
    You can raise StopIteration explicitly, or implicitly by falling off the end of the generator code as above.
    你可以显式的触发StopIteration异常，也可以隐式地等到它自己触发。
    Generators can simplify sequence/iterator handling, because we don’t need to build concrete lists;
    生成器能够简化迭代处理，因为我们不需要建立实际的列表
    just compute one value at a time. The generator function maintains state.
    只用一次计算一个值就行。生成器函数会负责维护状态

    This is how a for loop really works. Python looks at the sequence supplied after the in keyword.
    这应该是for循环工作的真正原理。Python会查看在关键字in后面的序列
    If it’s a simple container (such as a list, tuple, dictionary, set, or user-defined container) Python converts it into an iterator.
    如果只是一个简单的容器，Python会把它变成一个迭代器
    If it’s already an iterator, Python does nothing.
    如果已经是一个迭代器，Python就什么也不用做了

    The python repeatedly calls the iterator’s next method, assigns the return value to the loop counter(i in this case),
    Python不停地调用迭代器的next方法，把返回值赋值给循环计数器(在这个例子中是i)
    and executes the intended code.
    然后执行循环里面的代码
    This is repeated over and over, until StopIteration is raised, or a break statement is executed in the code.
    这个过程会一直重复直到StopIteration异常发生，或者是有执行到break语句。

    A for loop can have an else clause, whose code is executed after the iterator runs dry,
    for循环可以有一个else子句，用于当迭代器一直执行到溢出时执行
    but not after a break statement is executed.
    但如果是由break语句出循环则不算
    This distinction allows for some elegant uses. else clauses are not always or often used on for loops,
    这一点可以用来美化代码。else子句并不经常用在for循环中
    but they can come in handy.
    但是他们能派上用场。
    Somtimes the else clause perfectly expresses the logic you need.
    有些时候，一个else子句可完美地解释你想要的逻辑。

    For example, if we need to check that a condition holds on some item, any item, in a sequence:
    例如，我们想要检查在一个序列中是否包含满足某些条件的成员

        for item in sequence:
            if condition(item):
                break
        else:
            raise Exception('Condition not satisfied.')


生成器例子 Example Generator

    Filter out blank rows from a CSV reader (or items from a list):
    过滤掉CSV文件中的空行

        def filter_rows(row_iterator):
            for row in row_iterator:
                if row:
                    yield row

        data_file = open(path, 'rb')
        irows = filter_rows(csv.reader(data_file))


逐行读取文本文件 Reading Lines From Text/Data Files

        datafile = open('datafile')
        for line in datafile:
            do_something(line)

    This is possible because files support a next method, as do other iterators: lists, tuples,
    这样做可行的原因是文件支持next方法，一些其它的迭代器也一样：列表，元组，字典的key, 生成器
    dictionaries(for their keys), generators.


EAFP vs. LBYL

    EAFP: It’s easier to ask forgiveness than permission.
    获得宽恕要比求得允许来得容易
    LBYL: Loop before your leap
    三思而后行
    Generally EAFP if preferred, but not always.
    EAFP通常更容易，但并不总是这样
    - Duck typing
    If it walks like a duck, and talks like a duck, and looks like a duck: it’s a duck.
    如果它走起来像duck, 说话像duck， 看起来像duck, 那么它就是一只duck.
    - Exceptions
    Use coercion if a object must be a particular type. If x must be a string for your code to work, why not call
    当一个对象必须为一种特殊类型的时候，请使用强制类型转换。如果x必须要是字符串才能工作，请这样做：

        str(x)

    instead of trying something like
    而不是这样

        isinstance(x, str)


EAFP try/except example

    You can wrap except-prone code in try/except block to catch the errors,
    你可以将容易发生异常的代码放在try/except的块中来捕捉错误，
    and you will probably end up with a solution that’s much more general than if you had tried to anticipate every possibility.
    相比你去猜测所有的可能，这样做可能会是一种更通用的方法

        try:
            return str(x)
        except TypeError:
            ...

    Note: Always specify the error to catch. Never use bare except clause.
    注意：一定要指明要捕捉的错误类型，不要使用空的except语句。
    Bare except clause will catch unexpected exceptions, making your code exceedingly difficut to debug.
    空的except条件会捕捉到一些不想要的异常，使你的代码非常难于调试。


导入 Importing

        from module import *

    You have probably seen this ‘wild card’ form of the import statement.
    你也许已经看到过这种import用法
    You may even like it. Don’t use it.
    甚至你也喜欢这样用，但请你千万不要用它。
    To paraphase a well-known exchange:
    LUKE: Is from module import * better than explicit imports?
    YODA: No, not better. Quicker, easier, more seductive.
    LUKE: But how will I know why explicit imports are better than wild-card form?
    YODA: Know you will when your code you try to read six months fron now.
    Wild-card imports are from the dark side of Python.
    Wild-card imports来自Python的黑暗面。
    The from module import * wild-card style leads to namespace pollution.
    这种wild-card方式会造成命名空间污染。
    You may see imported names obscuring module-defined local names.
    你也许会看到引入的名字使用本地模块定义的名字混乱。
    You won’t be able to figure out where certain names come from.
    你将不能找到它些名字是从哪里来的
    Although a convinenient shortcut, this should not be in production code.
    尽管这样做比较方便，但它不应该出现在产品代码里面。
    Moral: Don’t wild-card imports!

    It’s much better to:
    最好是这样做：
    - reference names through their module (fully qualified identifier)
    - 通过模块来引用名字
    - import a long module using a shorter name (alias, recommend）
    - 把它import成更简短的名字，别名
    - or explicitly import just the names your need.
    - 或者直接只import你要用的名字

    Reference names through their module (fully qualified identifier)
    通过模块来引用名字

        import module
        module.name

    Or import a long module using a shorter name (alias)
    或者是给一个有长名字的模块一个短的别名

        import long_module_name as mod
        mod.name

    Or explicitly import just the names you need:
    或者直接从模块中import你想要的名字

        from module import name
        name

    Note that this form doesn’t lend itself to use in the interactive interpreter, where you may want to edit and “reload()” a module.
    在交互式解释器中，你可能不能直接这样写，你要先’reload()’，如果你想要修改一个模块。


模块与脚本 Modules & Scripts

    To make a simutaneously importable module and executable script:
    为了使用脚本继能被import又可以同时执行

        if __name__ == '__main__':
            # script code here

    When imported, the module’s __name__ attribute is set to the module’s file name, without ‘.py’.
    当被import的时候，模块的名字属性就会被设成模块文件的名字，只是没有’.py’后缀。
    So the code guarded by the if statement will not run when imported. When executed as a script though,
    所以当被import的时候，if语句所保护的代码不会执行。当作为脚本运行的时候，
    the name attribute is set to “main“, and the script code will run.
    名字属性会被设成”main“, 然后脚本代码就会执行。


模块结构 Module Structure

    """module docstring"""
    # imports
    # constants
    # exception classes
    # interface functions
    # classes
    # internal functions & classes

    def main(...):
        ...

    if __name__ == '__main__':
        status = main()
        sys.exit(status)


命令行处理 Command-Line Processing

    #!/usr/bin/env python
    """
    Module docstring.
    """

    import sys
    import optparse

    def process_command_line(argv):
        """
        Return a 2-tuple: (settings object, args list).
        `argv` is a list of arguments, or `None` for ``sys.argv[1:]``.
        """
        if argv is None:
        argv = sys.argv[1:]

        # initialize the parser object:
        parser = optparse.OptionParser(
            formatter=optparse.TitledHelpFormatter(width=78),
            add_help_option=None)

        # define options here:
        parser.add_option( # customized description; put --help last
            '-h', '--help', action='help',
            help='Show this help message and exit.')

        settings, args = parser.parse_args(argv)

        # check number of arguments, verify values, etc.:
        if args:
            parser.error('program takes no command-line arguments; '
                         '"%s" ignored.' % (args,))

        # further process settings & args if necessary

        return settings, args

    def main(argv=None):
        settings, args = process_command_line(argv)
        # application code here, like:
        # run(settings, args)
        return 0 # success

    if __name__ == '__main__':
        status = main()
        sys.exit(status)


包 Packages

        package/
            __init__.py
            module1.py
            subpackage/
                __init__.py
                module2.py

    Used to organize your project
    用于组织项目
    Reduces entries in load-path
    减少load-path入口
    Reduces import name conflicts
    减少命名冲突
    Example:

        import package.module1
        from packages.subpackage import module2
        from packages.subpackage.module2 import name
        from __future__ import absolute_import

    I haven’t delved into these myself yet, so we’ll conveniently cut this discussion short.
    我自己也没有怎么深入的用过，所以我们在这里只是简单的讨论


简单好于复杂 Simple is better than complex

    Debugging is twice hard as writing the code in the first place.
    调试代码的难度是新写代码难度的两倍
    Therefore, if you write your code as clearly as possible,
    因此，如果你把的你的代码写得足够清晰，
    you are, by definition, not smart enough to debug it.
    从理论上讲，你又可以不用太聪明来调试它。
    In other words, keep your programs simple.
    换句话讲，让你的代码保持简单


不要重新发明轮子 Don’t reinent the wheel

    Before writing your code
    在你写代码之前
    - Check Python’s standard library
    - 查看标准库中有没有你想要的库
    - Check the Python Package Index (http://cheeseshop.python.org/pypi)
    - 检查Python包的索引
    - Search the web. Google is your friend.
    - 在网络上搜索，Google是你的朋友


参考 Reference

    “Python Objects”, Fredrik Lundh, http://www.effbot.org/zone/python-objects.htm
    “How to think like a Pythonista”, Mark Hammond, http://python.net/crew/mwh/hacks/objectthink.html
    “Python main() functions”, Guido van Rossum, http://www.artima.com/weblogs/viewpost.jsp?thread=4829
    “Python Idioms and Efficiency”, http://jaynes.colorado.edu/PythonIdioms.html
    “Python track: python idioms”, http://www.cs.caltech.edu/courses/cs11/material/python/misc/python_idioms.html
    “Be Pythonic”, Shalabh Chaturvedi, http://shalabh.infogami.com/Be_Pythonic2
    “Python Is Not Java”, Phillip J. Eby, http://dirtsimple.org/2004/12/python-is-not-java.html
    “What is Pythonic?”, Martijn Faassen, http://faassen.n–tree.net/blog/view/weblog/2005/08/06/0
    “Sorting Mini-HOWTO”, Andrew Dalke, http://wiki.python.org/moin/HowTo/Sorting
    “Python Idioms”, http://www.gungfu.de/facts/wiki/
    “Python FAQs”, http://www.python.org/doc/faq/
