简介
    re.search(pattern,string)：用于搜索整个字符串，直到发现符合的子字符串
    re.match(pattern,string)：也用于搜索，从头开始检查string是否符合pattern，必须从第一个字符就相符
    re.sub(pattern,replacement,string)：在string中，用pattern进行搜索，如果匹配，就用replacement进行替换，返回替换后的字符串
    re.split(pattern,string)：根据pattern分割string，返回一个list，包含所有分割后的子字符串
    re.findall(pattern,string)：根据pattern搜索string，返回一个list，包含所有符合的子字符串
    re.compile(pattern)：
    作用：将pattern编译成一个模式对象，加快速度，并且重复使用
    原理：在直接使用字符串的pattern进行search、match和findall操作时，Python会将字符串转换为模式对象；
          而使用compile完成一次转换后，在每次使用的时候就不用重复转换
    不同的调用：re.compile()后，re.search(pattern,string)的调用改成pattern.search(string)

正则表达式
    正则表达式有强大并且标准化的方法来处理字符串查找、替换以及用复杂模式来解析文本。
    正则表达式的语法比程序代码更紧凑，格式更严格，比用组合调用字符串处理函数的方法更具有可读性。
    还可以在正则表达式中嵌入注释信息，这样就可以使它有自文档化的功能。
1. 搜索searching：在字符串任意部分中搜索匹配的模式；
2. 匹配matching:  判断一个字符串能否从起始处全部或者部分地匹配某个模式。

匹配符：
    literal 匹配文本字符串的字面值  foo
    re1|re2 匹配正则表达式 re1 或者 re2
    ^       匹配字符串开始位置。在多行字符串模式匹配每一行的开头。同\A
    $       匹配字符串结束位置。在多行字符串模式匹配每一行的结尾。同\Z,如果匹配任何以$结尾的字符串，则用.*\$$
    .       匹配除了换行符外的任何字符，在 alternate 模式(re.DOTALL)下它甚至可以匹配换行。
    \A      匹配字符串开头
    \Z      匹配字符串结尾
    \b      匹配一个单词边界。即 \w 与 \W 之间。 the -> \bthe -> \bthe\b ~ \Bthe(任何包含但不以the作为起始的字符串)
    \B      匹配一个非单词边界；相当于类 [^\b]。
    \d      匹配一个数字。            data\d+.txt
    \D      匹配一个任意的非数字字符。
    \s      匹配任何空白字符；它相当于类  [ \t\n\r\f\v]。
    \S      匹配任何非空白字符；它相当于类 [^ \t\n\r\f\v]。
    \w      匹配任何字母数字字符；它相当于类 [a-zA-Z0-9_]。
    \W      匹配任何非字母数字字符；它相当于类 [^a-zA-Z0-9_]。
    x?      匹配可选的x字符。即是0个或者1个x字符。
    x*      匹配0个或更多的x。[A-Za-z0-9]*
    x+      匹配1个或者更多x。如[a-z]+\.com
    x{n,m}  匹配n到m个x，至少n个，不能超过m个。如[0-9]{3} 如[0-9]{5,9}
    (a|b|c) 匹配单独的任意一个a或者b或者c。
    […]     匹配来自字符集的任意单一字符；[..x−y..] 匹配 x ～ y 范围中的任意单一字符 [0-9], [A-Za-z]
    [^…]    不匹配此字符集中出现的任何一个字符，包括某一范围的字符（如果在此字符集中出现） [^aeiou], [^A-Za-z0-9]
    (x)     捕获组，小括号括起来即可，它会记忆它匹配到的字符串。
            可以用 re.search() 返回的匹配对象的 groups()函数来获取到匹配的值。
    \1      记忆组，它表示记住的第一个分组；如果有超过一个的记忆分组，可以使用 \2 和 \3 等等。
            记忆组的内容也要小括号括起来。
    (?iLmsux)          iLmsux的每个字符代表一种匹配模式 #在正则表达式中嵌入一个或者多个特殊标记(或者通过函数/方法)
        re.I(re.IGNORECASE): 忽略大小写(括号内是完整写法，下同)
        re.M(re.MULTILINE): 多行模式，改变'^'和'$'的行为(参见上图)
        re.S(re.DOTALL): 点任意匹配模式，改变'.'的行为
        re.L(re.LOCALE): 使预定字符类 \w \W \b \B \s \S 取决于当前区域设定
        re.U(re.UNICODE): 使预定字符类 \w \W \b \B \s \S \d \D 取决于unicode定义的字符属性
        re.X(re.VERBOSE): 松散正则表达式模式。这个模式下正则表达式可以是多行，忽略空白字符，并可以加入注释。
    (?:表达式)         无捕获组。与捕获组表现一样，只是没有内容。
    (?P<name>表达式)   命名组。与记忆组一样，只是多了个名称。# 像一个仅由name标识而不是数字ID标识的正则分组匹配
    (?P=name)          命名组的逆向引用。
    (?#...)            “#”后面的将会作为注释而忽略掉。例如：“ab(?#comment)cd”匹配“abcd”
    (?=...)            之后的字符串需要匹配表达式才能成功匹配。不消耗字符串内容。 例：“a(?=\d)”匹配“a12”中的“a”
    (?!...)            之后的字符串需要不匹配表达式才能成功匹配。不消耗字符串内容。 例：“a(?!\d)”匹配“abc”中的“a”
    (?<=...)           之前的字符串需要匹配表达式才能成功匹配。不消耗字符串内容。 例：“(?<=\d)a”匹配“2a”中的“a”
    (?<!...)           之前的字符串需要不匹配表达式才能成功匹配。不消耗字符串内容。 例：“(?<!\d)a”匹配“sa”中的“a”
                       注：上面4个表达式的里面匹配的内容只能是一个字符，多个则报错。
    (?(id/name)yes-pattern|no-pattern)  如果编号为 id 或者别名为 name 的组匹配到字符串，则需要匹配yes-pattern，否则需要匹配no-pattern。 “|no-pattern”可以省略。如：“(\d)ab(?(1)\d|c)”匹配到“1ab2”和“abc”

    (*|+|?|{})? 用于匹配上面频繁出现/重复出现符号的非贪婪版本（*、+、?、{}） .*?[a-z]
元字符:
    "[" 和 "]"
        它们常用来匹配一个字符集。字符可以单个列出，也可以用“-”号分隔的两个给定字符来表示一个字符区间。
            例如，[abc] 将匹配"a", "b", 或 "c"中的任意一个字符；也可以用区间[a-c]来表示同一字符集，和前者效果一致。
        元字符在类别里并不起作用。例如，[a$]将匹配字符"a" 或 "$" 中的任意一个；"$" 在这里恢复成普通字符。
        也可以用补集来匹配不在区间范围内的字符。其做法是把"^"作为类别的首个字符；其它地方的"^"只会简单匹配 "^"字符本身。
            例如，[^5] 将匹配除 "5" 之外的任意字符。
        特殊字符都可以包含在一个字符类中。如，[\s,.]字符类将匹配任何空白字符或","或"."。
    反斜杠 "\"。
        做为 Python 中的字符串字母，反斜杠后面可以加不同的字符以表示不同特殊意义。
        它也可以用于取消所有的元字符，这样你就可以在模式中匹配它们了。
            例如，需要匹配字符 "[" 或 "\"，可以在它们之前用反斜杠来取消它们的特殊意义： \[ 或 \\。

建议使用原始字符串:
    建议在处理正则表达式的时候总是使用原始字符串。如： r'\bROAD$', 而不要写成 '\\bROAD$'
    否则，会因为理解正则表达式而消耗大量时间(正则表达式本身就已经够让人困惑的了)。

无捕获组:
    有时你想用一个组去收集正则表达式的一部分，但又对组的内容不感兴趣。你可以用一个无捕获组“(?:...)”来实现这项功能。
    除了捕获匹配组的内容之外，无捕获组与捕获组表现完全一样；可以在其中放置任何字符、匹配符，可以在其他组(无捕获组与捕获组)中嵌套它。
    无捕获组对于修改已有组尤其有用，因为可以不用改变所有其他组号的情况下添加一个新组。
    捕获组和无捕获组在搜索效率方面也一样。

命名组:
    与用数字指定组不同的是，它可以用名字来指定。除了该组有个名字之外，命名组也同捕获组是相同的。
    (?P<name>...) 定义一个命名组，(?P=name) 则是对命名组的逆向引用。
    MatchObject 的方法处理捕获组时接受的要么是表示组号的整数，要么是包含组名的字符串。所以命名组可以通过数字或者名称两种方式来得到一个组的信息。

松散正则表达式:
    为了方便阅读和维护，可以使用松散正则表达式，它与普通紧凑的正则表达式有两点不同：
    1, 空白符被忽略。空格、制表符(tab)和回车会被忽略。如果需要匹配他们，可以在前面加一个“\”来转义。
    2, 注释被忽略。注释以“#”开头直到行尾，与python代码中的一样。
    使用松散正则表达式，需要传递一个叫 re.VERBOSE的 参数。详细见下面例子。

match() vs search()
    match() 函数只检查 RE 是否在字符串开始处匹配，而 search() 则是扫描整个字符串。记住这一区别是重要的。
    match() 只报告一次成功的匹配，它将从 0 处开始；如果匹配不是从 0 开始的， match() 将不会报告它。
    search() 将扫描整个字符串，并报告它找到的第一个匹配。
    例：
        print(re.match('super', 'superstition').span())  # 打印： (0, 5)
        print(re.match('super', 'insuperable'))          # 打印： None
        print(re.search('super', 'superstition').span()) # 打印： (0, 5)
        print(re.search('super', 'insuperable').span())  # 打印： (2, 7)

贪婪与非贪婪模式
  1.什么是正则表达式的贪婪与非贪婪匹配
　　如：
        import re
        s="abcaxc"
        print(re.match("ab.*c", s).group())   # 打印： abcaxc
        print(re.match("ab.*?c", s).group())  # 打印： abc

　　贪婪匹配:正则表达式一般趋向于最大长度匹配，也就是所谓的贪婪匹配。如上面使用模式p匹配字符串s，结果就是匹配到：abcaxc。
　　非贪婪匹配：就是匹配到结果就好，就少的匹配字符。如上面使用模式p匹配字符串s，结果就是匹配到：abc。

  2.编程中如何区分两种模式
　　默认是贪婪模式；在量词后面直接加上一个问号"?"就是非贪婪模式。

　　量词：{m,n}：m到n个
　　　　　*：任意多个
　　　　　+：一个到多个
　　　　　?：0或一个

re模块
    方法                                描述
    # 仅仅是re模块函数
    compile(pattern, flags=0)           对正则表达式模式pattern进行编译,返回一个正则表达式对象 
    # re 模块函数和正则表达式对象的方法 ：如果匹配成功，就返回匹配对象；如果失败，就返回 None
    match(pattern, string, flags=0)     尝试使用带有可选的标记的正则表达式的模式pattern来匹配字符串string。
    match # 函数试图从字符串的起始部分对模式进行匹配。如果匹配成功，就返回一个匹配对象；如果匹配失败，就返回None，
    search(pattern, string, flags=0)    使用可选标记搜索字符串string中第一次出现的正则表达式模式pattern。
    findall(pattern, string, [,flags])  查找字符串中所有（非重复）出现的正则表达式模式，并返回一个匹配列表 
    finditer(pattern, string, [,flags]) 和findall()相同，但返回的不是列表而是迭代器
    findall|finditer # findall()总是返回一个列表。如果findall()没有找到匹配的部分，就返回一个空列表，
                     # 但如果匹配成功，列表将包含所有成功的匹配部分（从左向右按出现顺序排列）
    split(pattern, string, max=0)       根据正则表达式pattern中的分隔符将字符string分割成一个列表，分隔最多操作max次
    # re 模块函数和正则表达式对象方法 
    sub(pattern, repl, string, max=0)   把字符串string中所有匹配正则表达式pattern的地方替换成字符串repl
    purge()                             清除隐式编译的正则表达式模式 
    # 常用的匹配对象方法（查看文档以获取更多信息）| 属性 endpos，lastgroup，lastindex，pos，re，regs，string
    group(num=0)                        返回整个匹配对象，或者编号为 num 的特定子组 
    group # 要么返回整个匹配对象，要么根据要求返回特定子组。group(0)匹配对象； group(1)第1分组，group(2)第2分组...
    groups()                            返回一个包含所有匹配子组的元组（如果没有成功匹配，则返回一个空元组）
    # group(num!=0) 返回特定子组 -- 字符串类型或者IndexError 
    # groups()      返回所有子组 -- 元组类型或者None
    groupdict(default =None)            返回一个包含所有匹配的命名子组的字典，所有的子组名称作为字典的键

正则表达式对象(regex object)
正则匹配对象  (regex match object)
匹配对象      匹配对象有两个主要的方法：group() 和groups()。

2. 示例
at|home      at、home 
r2d2|c3po    r2d2 、c3po
bat|bet|bit  bat、bet、bit 
f.o          匹配在字母“f”和“o”之间的任意一个字符；例如 fao、f9o、f#o 等
.end         匹配在字符串end之前的任意一个字符
^From        任何以 From作为起始的字符串 
/bin/tcsh$   任何以/bin/tcsh 作为结尾的字符串 
^Subject:hi$ 任何由单独的字符串 Subject: hi构成的字符串
the          任何包含 the 的字符串 
\bthe        任何以 the 开始的字符串 
\bthe\b      仅仅匹配单词 the 
\Bthe        任何包含但并不以 the 作为起始的字符串
b[aeiu]t     bat 、bet、bit、but
[cr][23][dp][o2]  一个包含四个字符的字符串，第一个字符是“c”或“r”，然后是“2 ”或“3”，后面是“d ”或“p”，最后要么是“o”要么是“2”。例如，c2do 、r3p2 、r2d2 、c3po 等 
[dn]ot?      字母d或者n，后面跟着一个o，然后是最多一个t，例如：do no dot not
z.[0-9]      字母“z”后面跟着任何一个字符，然后跟着一个数字 
[r-u][env-y][us]  字母“r”、“ s”、“ t”或者“u”后面跟着“e”、“ n”、“ v”、“ w”、“ x”或者“y”，然后跟着“u”或者“s” 
[^aeiou]     一个非元音字符（练习：为什么我们说“非元音”而不是“辅音”？） 
[^\t\n]      不匹配制表符或者\n 
["-a]        在一个 ASCII 系统中，所有字符都位于“”和“a”之间，即 34~97 之间
</?[^>]+>    匹配全部有效的（和无效的）HTML 标签
[0-9]{15,16} 匹配15 或者 16 个数字（例如信用卡号码）
\w+@\w+\.com 电子邮件地址
\d{3}-\d{3}-\d{4}  美国电话号码的格式，前面是区号前缀，例如 800-555-1212
(?:\w+\.)*   以句号作为结尾的字符串，例如google. twitter. facebook. 但是这些匹配不会被保存下来共后续的使用和数据检索
(?#comment)  此处不做匹配，只是作为注释
(?=.com)     如果一个字符串后面跟着.com才做匹配操作，并不使用任何目标字符串
(?!.net)     如果一个字符串后面不跟着.net才做匹配操作
(?<=800-)    如果字符串前面为800-才做匹配，假定为电话号码，同样，并使用任何输入字符串
(?<!192\.168\.) 如果一个字符串前不是192.168，才做匹配操作，假定用于过滤器一组C类IP地址
(?(1)y|x)    如果一个匹配组1存在，就与y匹配，否则就与x匹配

3.示例
    import re
    text='(content:"rcpt to root";pcre:"word";)'
    print(re.search('content:".+"', text).group())   # 贪婪模式,  打印： content:"rcpt to root";pcre:"word"
    print(re.search('content:".+?"', text).group())  # 非贪婪模式,打印： content:"rcpt to root"
4.示例
4.1 match
    m = re.match('foo', 'foo')     # 模式匹配字符串
    if m is not None:              # AttributeError
         m.group()
    print m                        # 确认返回的匹配对象
    m = re.match('foo', 'food on the table') # 匹配成功
    m.group()
    re.match('foo', 'food on the table').group()  # 如果匹配失败，将会抛出 AttributeError 异常
4.2 search
    m = re.search('foo', 'seafood')
    if m is not None: m.group() 
4.3 ? -> * # 重复、特殊字符以及分组
    patt = '\w+@(\w+\.)?\w+\.com'                patt = '\w+@(\w+\.)*\w+\.com' 
    re.match(patt, 'nobody@xxx.com').group()     re.match(patt, 'nobody@w ww.xxx.yyy.zzz.com').group()
    re.match(patt, 'nobody@www.xxx.com').group()
4.4 \w\w\w-\d\d\d
    m = re.match('\w\w\w-\d\d\d', 'abc-123')   m = re.match('\w\w\w-\d\d\d', 'abc-xyz') 
    if m is not None: m.group()                  if m is not None: m.group()
4.5 分组 # "()" 表示分组
    m = re.match('(\w\w\w)-(\d\d\d)', 'abc-123') 
    m.group()     # 'abc-123'
    m.group(1)    # 'abc'
    m.group(2)    # '123'  
    m.groups()    # ('abc', '123')
    # 无子组
    m = re.match('ab', 'ab')
    m.group()    # 'ab'
    m.groups()   # ()
    # 一个子组
    m = re.match('(ab)', 'ab')
    m.group()    # 'ab'
    m.group(1)   # 'ab'
    m.groups()   # ('ab',)
    # 二个子组
    m = re.match('(a)(b)', 'ab')
    m.group()    # 'ab'
    m.group(1)   # 'a'
    m.group(2)   # 'b'
    m.groups()   # ('a','b')
    # 二个子组
    m = re.match('(a(b))', 'ab')
    m.group()    # 'ab'
    m.group(1)   # 'ab'
    m.group(2)   # 'b'
    m.groups()   # ('ab','b') 
4.6 findall
    findall()查询字符串中某个正则表达式模式全部的非重复出现情况。这与 search()在执行
字符串搜索时类似，但与 match()和search()的不同之处在于，findall()总是返回一个列表。如
果findall()没有找到匹配的部分，就返回一个空列表，但如果匹配成功，列表将包含所有成
功的匹配部分（从左向右按出现顺序排列）。
    re.findall('car', 'car')    # ['car']
    re.findall('car', 'scary')  # ['car']
    re.findall('car', 'carry the barcardi to the car') # ['car', 'car', 'car']
    
    s = 'This and that.'
    re.findall(r'(th\w+) and (th\w+)', s, re.I)  # [('This', 'that')]  
    
    re.finditer(r'(th\w+) and (th\w+)', s, re.I).next().groups()  # ('This', 'that') 
    re.finditer(r'(th\w+) and (th\w+)', s, re.I).next().group(1)  # 'This' 
    re.finditer(r'(th\w+) and (th\w+)', s, re.I).next().group(2)  # 'that'
    [g.groups() for  g in re.finditer(r'(th\w+) and (th\w+)',s, re.I)] 
    
    re.findall(r'(th \w+)', s, re.I)  # ['This', 'that'] 
    it = re.finditer(r'(th\w+)', s, re.I) 
    g = it.next() 
    g.groups()   # ('This',) 
    g.group(1)   # 'This' 
    g = it.next() 
    g.groups()   # ('that',) 
    g.group(1)   #'that' 
    [g.group(1) for  g in re.finditer(r'(th\w+)', s, re.I)]   # ['This', 'that']
注意，使用 finditer() 函数完成的所有额外工作都旨在获取它的输出来匹配 findall()的输出。

4.7 sub && subn
    subn() 和sub()一样，但 subn()还返回一个表示替换的总数，替换后的字符串和表示替换总数的数字一起作为一个拥有两个
元素的元组返回。 
    re.sub('X', 'Mr. Smith', 'attn: X\n\ nDear X, \n') # 'attn: Mr. Sm ith \012 \012Dear Mr. Smith, \012' 
    re.subn('X', 'Mr. Smith', 'attn: X \n\ nDear X, \n') # ('attn: Mr. Smith\012 \012Dear Mr. Smith, \012', 2) 
4.8 split
    re.split(':', 'str1:str2:str3')  # ['str1', 'str2', 'str3']
    
   import re 
    DATA = ( 
        'Mountain View, CA 94040', 
        'Sunnyvale, CA', 
        'Los Altos, 94023', 
        'Cupertino 95014',  
        'Palo Alto CA',  
    )  
    for  datum in DATA:  
        print  re.split(', |(?= (?: \d{5}|[A-Z]{2})) ', datum) 
    # ['Mountain View', 'CA', '94040'] 
    # ['Sunnyvale', 'CA'] 
    # ['Los Altos', '94023'] 
    # ['Cupertino', '95014'] 
    # ['Palo Alto', 'CA']
4.9 扩展符号 (?iLmsux) 
    re.findall(r'(?i)yes', 'yes? Yes. YES!!') 
    re.findall(r'(?i)th\w+', 'The quickest way is through this  tunnel.') 
    
re.X/VERBOSE 标记非常有趣；该标记允许用户通过抑制在正则表达式中使用空白符（除
了在字符类中或者在反斜线转义中）来创建更易读的正则表达式。
re.search(r'''(?x) 
     \((\d{3}) \) # 区号 
      [ ]          # 空白符 
     (\d{3})       # 前缀 
     -           # 横线 
     (\d{4})       # 终点数字 
''', '(800) 555-1212').groups()  
('800', '555', '1212') 
######################### 示例 #################################

# 必须引入 re 标准库
    import re

# 字符串替换:  sub() 与 subn()
    s = '100 NORTH MAIN ROAD'
    # 将字符串结尾的单词“ROAD”替换成“RD.”；该 re.sub() 函数执行基于正则表达式的字符串替换。
    print(re.sub(r'\bROAD$', 'RD.', s)) # 打印： 100 NORTH MAIN RD.
    ## subn() 与 sub() 作用一样，但返回的是包含新字符串和替换执行次数的两元组。
    print(re.subn(r'\bROAD$', 'RD.', s)) # 打印： ('100 NORTH MAIN RD.', 1)

# 字符串分割, split()
    # 在正则表达式匹配的地方将字符串分片，将返回列表。只支持空白符和固定字符串。可指定最大分割次数，不指定将全部分割。
    print(re.split(r'\s+', 'this is a test')) # 打印： ['this', 'is', 'a', 'test']
    print(re.split(r'\W+', 'This is a test.', 2)) # 指定分割次数,打印：['this', 'is', 'a test']
    # 如果你不仅对定界符之间的文本感兴趣，也需要知道定界符是什么。在 RE 中使用捕获括号，就会同时传回他们的值。
    print(re.split(r'(\W+)', 'This is a test.', 2)) # 捕获定界符,打印：['this', ' ', 'is', ' ', 'a test']

## `MatchObject` 实例的几个方法
    r = re.search(r'\bR(OA)(D)\b', s)
    print(r.groups()) # 返回一个包含字符串的元组,可用下标取元组的内容，打印： ('OA', 'D')
    print(r.group())  # 返回正则表达式匹配的字符串，打印： ROAD
    print(r.group(2)) # 返回捕获组对应的内容(用数字指明第几个捕获组)，打印： D
    print(r.start())  # 返回匹配字符串开始的索引, 打印： 15
    print(r.end())    # 返回匹配字符串结束的索引，打印： 19
    print(r.span())   # 返回一个元组包含匹配字符串 (开始,结束) 的索引，打印： (15, 19)

# 匹配多个内容, findall() 返回一个匹配字符串行表
    p = re.compile('\d+')
    s0 = '12 drummers drumming, 11 pipers piping, 10 lords a-leaping'
    print(p.findall(s0)) # 打印： [12, 11, 10]
    print(re.findall(r'\d+', s0)) # 也可这样写，打印： [12, 11, 10]

# 匹配多个内容, finditer() 以迭代器返回
    iterator = p.finditer(s0)
    # iterator = re.finditer(r'\d+', s0) # 上句也可以这样写
    for match in iterator:
        print(match.group()) # 三次分别打印：12、 11、 10

# 记忆组
    print(re.sub('([^aeiou])y$', 'ies', 'vacancy'))    # 将匹配的最后两个字母替换掉，打印： vacanies
    print(re.sub('([^aeiou])y$', r'\1ies', 'vacancy')) # 将匹配的最后一个字母替换掉，记忆住前一个(小括号那部分)，打印： vacancies
    print(re.search('([^aeiou])y$', 'vacancy').group(1)) # 使用 group() 函数获取对应的记忆组内容，打印： c

# 记忆组(匹配重复字符串)
    p = re.compile(r'(?P<word>\b\w+)\s+\1') # 注意, re.match() 函数不能这样用，会返回 None
    p = p.search('Paris in the the spring')
    # p = re.search(r'(?P<word>\b\w+)\s+\1', 'Paris in the the spring') # 这一句可以替换上面两句
    print(p.group())  # 返回正则表达式匹配的所有内容，打印： the the
    print(p.groups()) # 返回一个包含字符串的元组，打印： ('the',)

# 捕获组
    r = re.search(r'\bR(OA)(D)\b', s) # 如过能匹配到，返回一个 SRE_Match 类(正则表达式匹配对象)；匹配不到则返回“None”
    # `MatchObject` 实例的几个方法
    if r: # 如果匹配不到，则 r 为 None,直接执行下面语句则会报错；这里先判断一下，避免这错误
        print(r.groups()) # 返回一个包含字符串的元组,可用下标取元组的内容，打印： ('OA', 'D')
        print(r.group())  # 返回正则表达式匹配的字符串，打印： ROAD
        print(r.group(2)) # 返回捕获组对应的内容(用数字指明第几个捕获组)，打印： D

# 无捕获组
    print(re.match("([abc])+", "abcdefab").groups())   # 正常捕获的结果： ('c',)
    print(re.match("(?:[abc])+", "abcdefab").groups()) # 无捕获组的结果： ()

# 命名组
    m = re.match(r'(?P<word>\b\w+\b) *(?P<word2>\b\w+\b)', 'Lots of punctuation')
    print(m.groups())       # 返回正则表达式匹配的所有内容，打印：('Lots', 'of')
    print(m.group(1))       # 通过数字得到对应组的信息，打印： Lots
    print(m.group('word2')) # 通过名称得到对应组的信息，打印： of

# 命名组 逆向引用
    p = re.compile(r'(?P<word>\b\w+)\s+(?P=word)') # 与记忆组一样用法, re.match() 函数同样不能这样用，会返回 None
    p = p.search('Paris in the the spring') #  r'(?P<word>\b\w+)\s+(?P=word)' 与 r'(?P<word>\b\w+)\s+\1' 效果一样
    print(p.group())  # 返回正则表达式匹配的所有内容，打印： the the
    print(p.groups()) # 返回一个包含字符串的元组，打印： ('the',)

# 使用松散正则表达式,以判断罗马数字为例
    pattern = '''
        ^                   # beginning of string
        (M{0,3})            # thousands - 0 to 3 Ms
        (CM|CD|D?C{0,3})    # hundreds - 900 (CM), 400 (CD), 0-300 (0 to 3 Cs),
                            #            or 500-800 (D, followed by 0 to 3 Cs)
        (XC|XL|L?X{0,3})    # tens - 90 (XC), 40 (XL), 0-30 (0 to 3 Xs),
                            #        or 50-80 (L, followed by 0 to 3 Xs)
        (IX|IV|V?I{0,3})    # ones - 9 (IX), 4 (IV), 0-3 (0 to 3 Is),
                            #        or 5-8 (V, followed by 0 to 3 Is)
        $                   # end of string
        '''
    print(re.search(pattern, 'M')) # 这个没有申明为松散正则表达式，按普通的来处理了，打印： None
    print(re.search(pattern, 'M', re.VERBOSE).groups()) # 打印： ('M', '', '', '')

# (?iLmsux) 用法
    # 以下这三句的写法都是一样的效果，表示忽略大小写，打印： ['aa', 'AA']
    print(re.findall(r'(?i)(aa)', 'aa kkAAK s'))
    print(re.findall(r'(aa)', 'aa kkAAK s', re.I))
    print(re.findall(r'(aa)', 'aa kkAAK s', re.IGNORECASE))
    # 可以多种模式同时生效
    print(re.findall(r'(?im)(aa)', 'aa kkAAK s'))  # 直接在正则表达式里面写
    print(re.findall(r'(aa)', 'aa kkAAK s', re.I | re.M)) # 在参数里面写
    print(re.findall(r'(aa)', 'aa kkAAK s', re.I or re.M))

# 预编译正则表达式解析的写法
    # romPattern = re.compile(pattern)  # 如果不是松散正则表达式,则这样写,即少写 re.VERBOSE 参数
    romPattern = re.compile(pattern, re.VERBOSE)
    print(romPattern.search('MCMLXXXIX').groups()) # 打印： ('M', 'CM', 'LXXX', 'IX')
    print(romPattern.search('MMMDCCCLXXXVIII').groups()) # 打印： ('MMM', 'DCCC', 'LXXX', 'VIII')
    # match()、search()、sub()、findall() 等等都可以这样用

# who > whodata.txt                           # !/usr/bin/env python                 | # !/usr/bin/env python
    import re                               | import re                              | import re 
    f = open('whodata.txt', 'r')            | import os                              | import os
    for  eachLine in f:                     | f = os.popen('who', 'r')               | with os.popen('who', 'r') as f:
        print  re.split(r'\s\s+', eachLine) | for  eachLine in f:                    |     for  eachLine in f:                    
    f.close()                               |     print  re.split(r'\s\s+', eachLine)|         print  re.split(r'\s\s+', eachLine)
                                              f.close()                              



                                              