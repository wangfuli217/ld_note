sed_intro(){
    https://github.com/learnbyexample/Command-line-text-processing/blob/master/gnu_sed.md #  stackoverflow
    https://www.gnu.org/software/sed/manual/sed.html  # GNU SED
    模式和操作内容使用单引号，是为了防止shell扩展 
    sed BRE ; sed -E -r ERE
输入和输出: 1. 管道，2. 文件(可以一次处理多个文件，行号地址为文件间的累计地址值)
等价:
    sed 's/hello/world/' input.txt > output.txt
    sed 's/hello/world/' < input.txt > output.txt
    cat input.txt | sed 's/hello/world/' - > output.txt
修改 file.txt 而没有任何输出
    sed -i 's/hello/world/p' file.txt  # 不输出任何内容
    sed -n 's/hello/world/p' file.txt  # 只输出匹配替换成功内容
模式匹配规则: 等价
    sed 's/hello/world/' input.txt > output.txt
    sed -e 's/hello/world/' input.txt > output.txt
    sed --expression='s/hello/world/' input.txt > output.txt

    echo 's/hello/world/' > myscript.sed
    sed -f myscript.sed input.txt > output.txt
    sed --file=myscript.sed input.txt > output.txt
返回值: q42 返回值等于42
    0: 执行成功
    1: 无效命令、无效模式、无效语法
    2: 一个或多个指定文件不存在
    4: IO错误或者严重的执行错误
多编辑命令 # a, c, i,这三个命令不能使用';'作为分隔符。只能使用换行或者多-e选项，多脚本方式
    sed '/^foo/d ; s/hello/world/' input.txt > output.txt

    sed -e '/^foo/d' -e 's/hello/world/' input.txt > output.txt

    echo '/^foo/d' > script.sed
    echo 's/hello/world/' >> script.sed
    sed -f script.sed input.txt > output.txt

    echo 's/hello/world/' > script2.sed
    sed -e '/^foo/d' -f script2.sed input.txt > output.txt
    
多编辑命令 # a, c, i
    seq 2 | sed -e 1aHello -e 2d
    seq 2 | sed '1a\ 
    Hello 
    2d'
    seq 3 | sed '# this is a comment ; 2d'
    seq 3 | sed '# this is a comment
    2d'
替换
    echo 'a-b-' | sed 's/\(b\?\)-/x\u\1/g'  # axxB
    echo 'a-b-' | sed 's/\(b\?\)-/x\u\1/'   # axb-
    echo 'a-b-' | sed 's/\(b\?\)-/x\1/'     # axb-
    echo 'a-b-' | sed 's/\(b\?\)-/x\1/g'    # axxb
Combining multiple REGEXP
1.1 命令行
    sed -n -e '/blue/p' -e '/you/p' poem.txt
    sed -n '/blue/p; /you/p' poem.txt
    sed -n ' 
/blue/p 
/you/p ' 
poem.txt
1.2 {}
    sed -n '/are/ {/And/p}' poem.txt
    sed -n '/are/ {/so/!p}' poem.txt
    sed -n '/red/!{/blue/!p}' poem.txt
    sed -n '/blue/p; /t/p' poem.txt
    sed -nE '/blue|t/p;' poem.txt
    sed -nE '/red|blue/!p' poem.txt
    sed -n '/so/b; /are/p' poem.txt
}
sed_idea(){
工作原理:
    1. 读入一行；
    2. 用n个'编辑命令'依次处理该行，前者输出为后者输入
    3. 将处理后的结果输出到屏幕
sed做的 和 我们要做的
    1. sed自动的循环读入每一行
    2. 每一行的处理是由sed顺序执行编辑命令
    1. 我们要做的就是设计'编辑命令'
    http://blog.chinaunix.net/uid-20106293-id-142126.html
    sed 缺省的把标准输入复制到标准输出，在把每行写到输出之前可能在其上进行一个或多个编辑命令。每个命令的输入都是所有前面命令的输出。
这种行为可以通过命令行选项来更改。 -n 告诉 sed 不复制所有的行，只复制 p 函数或在 s 函数后 p 标志所指定的行。
    编译命令应用的缺省的线性次序可以通过控制流命令 t 和 b 来变更，即使在应用次序被这些命令改变的时候，
给任何命令的输入仍是任何此前应用的命令的输出。
    sed [-n] '模式1{操作a;操作b}; 模式2{操作c;操作d}' 文件
    sed [-n] -e '编辑命令1' -e '编辑命令2' -e ... 文件名
    sed [-n] -e '编辑命令1;编辑命令2,...' 文件名
    sed [-n] -e '编辑命令1
    编辑命令2
    ...' 文件名
    sed [-n] -f 编辑命令文件  文件名
    
    [地址1,地址2][函数][参数] # [address-range] function[modifiers]
    1. 一个或两个地址是可以省略的；
    2. 可以用任何数目的空白或 tab 把地址和函数分隔开。
    3. 函数必须出现；
    4. 依据给出的是哪个函数，参数可能是必需的或是可选的；
    5. 忽略在这些行开始处的 tab 字符和空格。
    6. 通过用花括号('{ }')组合(group)命令，可以用一个地址(或地址对)来控制一组命令的应用
    地址: number, $, first~step.
    1. 行号地址: 计数器在多个输入文件上累计运行，在打开一个新文件的时候它不被复零。字符 $ 匹配输入文件的最后一行。
    2. 上下文地址是包围在斜杠中('/')的模式('正则表达式') 将 pattern(sed)
      2.1) 字符'\n'匹配内嵌的换行字符，而不是在模式空间结束处的换行。
      2.2) 点'.'匹配除了模式空间的终止换行之外的任何字符。
      2.3) 在顺序的'\('和'\)'之间的正则表达式，在效果上等同于没有它修饰的正则表达式，但它有个副作用，
      2.4) 表达式'\d'意味着与在同一个表达式中先前的'\('和'\)'中包围的表达式所匹配的那些字符同样的字符串。
    3. 地址的数目: 命令可能有 0, 1 或 2 个地址
      3.1) 如果命令没有地址，它应用于输入中每个行。
      3.2) 如果命令有一个地址，它应用于匹配这个地址的所有行。
      3.3) 如果命令有两个地址，它应用于匹配第一个地址的第一行，和直到(并包括)匹配第二个地址的第一个后续行的所有后续行。
           接着在后续的行上再次尝试匹配第一个地址，并重复这个处理。
     sed '144s/hello/world/' input.txt > output.txt      # 特定地址
     sed 's/hello/world/' input.txt > output.txt         # 不指定地址
     sed '/apple/s/hello/world/' input.txt > output.txt  # 模式地址
     sed '4,17s/hello/world/' input.txt > output.txt     # 范围地址
     sed '/apple/!s/hello/world/' input.txt > output.txt # 模式地址:取反
     sed '4,17!s/hello/world/' input.txt > output.txt    # 范围地址:取反
    http://www.kuqin.com/docs/sed.html
    sed是一种在线编辑器，它一次处理一行内容。处理时，把当前处理的行存储在临时缓冲区中，称为"模式空间"(pattern space)，
接着用sed命令处理缓冲区中的内容，处理完成后，把缓冲区的内容送往屏幕。接着处理下一行，这样不断重复，直到文件末尾。
文件内容并没有改变，除非你使用重定向存储输出。sed主要用来自动编辑一个或多个文件；简化对文件的反复操作；编写转换程序等。
1. 空间: 保存空间，模式空间和文件下一行。
   1.1 保持空间的内容则保持不变，不会在循环中被删除。
   1.2 保存空间可用来缓存模式空间内的行数据，可以缓存多行模式空间行数据。
   1.3 默认情况下，默认存放一个空行\n
   
   2.1 存放当前处理的行，将处理结果输出；若当前行不符合处理条件则原样输出；处理完当前行再读入下一行来处理.
       一般而言，模式空间是输入文本中某一行，但是可以通过使用 N 命令把多于一行读入模式空间
   3.1 文件下一行，可以通过n命令 或者 N命令 获取。
2. p | P 输出模式空间内数据，p输出所有数据，P输出首行数据。p或者P只输出数据，不修改模式空间内数据。
   函数处理完之后，模式空间内所有数据输出到缓冲区显示，模式空间处理下一行数据之间，清空模式空间内数据。
    http://blog.chinaunix.net/uid-20106293-id-142126.html
    非交互式上下文编辑器
    1) 编辑那些对舒适的交互式编辑而言太大的文件。
    2) 在编辑命令太复杂而难于在交互模式下键入的时候编辑任何大小的文件。
    3) 要在对输入的一趟扫描中有效的进行多个'全局'(global)编辑函数。
sed 缺省的把标准输入复制到标准输出，在把每行写到输出之前可能在其上进行一个或多个编辑命令。这种行为可以通过命令行上的标志来更改；
编辑命令的一般格式为:
    [地址1,地址2][函数][参数]
1. 一个或两个地址是可以省略的
2. 可以用任何数目的空白或 tab 把地址和函数分隔开。函数必须出现；
3. 依据给出的是哪个函数，参数可能是必需的或是可选的；
按 命令 出现的次序编译这些命令；一般而言这也是在执行时尝试应用它们的次序。这些命令一次应用一个；给每个命令的输入都是所有前面命令的输出。
编译命令应用的缺省的线性次序可以通过控制流命令 t 和 b 来变更。即使在应用次序被这些命令改变的时候，给任何命令的输入仍是任何此前应用的命令的输出。
}
    https://github.com/learnbyexample/Command-line-text-processing/blob/master/gnu_sed.md
sed_man(){
    http://sed.sourceforge.net/#tools
    1. sed以行为处理单位，默认输入输出均为系统标准输入输出(因此除非重定向，否则它并不真正修改文件)，
    2.1 它首先判断要处理的行是否在要处理的范围之内(SELECTION),如果是则读入pattern space中，这是sed进行字符串处理工作的一个区域。
    2.2 脚本中的sed命令逐条执行来编辑pattern space里面的字符串，执行完毕后将该pattern space中处理过的字符串进行输出，随之pattern space被清空
    2.3 接着，再重复执行刚才的动作，文件中的新的一行被读入，判断是否在SELECTION中，编辑、输出，直到文件处理完毕
    3. 除了 pattern space 外，sed还有一个 hold space，用处是暂存文字字符串的地方，hold space中的字符串只是用于临时处理的中间结果，是不会被输出的
    4.  sed [options] 'SELECTION edit-instructions'  file(s) # sed可以一次处理多个文本
    4.1 sed [options] 'SELECTIONx\                           # 而x则为:i 表示插入选中行前;a 表示追加在选中行之后;c 表示将选中行修改为text
text'  file(s)
    4.2 sed [options] 'SELECTIONd'  file(s)                  # 清除pattern space中的所有内容
    4.3 sed [options] 'SELECTION s/old string/new string/'   # 替换所选区域中第一次出现的old string
    4.4 sed [options] 'SELECTION s/old string/new string/g'  # 替换所选区域中所有的old string
    4.5 sed [options] 'SELECTION y/string1/string2/'         # 对所选区域中的string1所含字符对应替换为string2中同位置的字符，与tr命令相同。
    4.6 sed [options] 'SELECTION command/w filename'         # 写文件操作
    4.7 sed [options] 'SELECTION command/r filename'         # 读文件操作
    4.8 sed -f scriptfile  filename
        'SELECTION1 operation1
        ...   ...
        SELECTIONn operationn' # 其实就是把多个命令用回车连起来
    4.9 sed 's/Martin/Mary/
s/Terrell/Tearrey/' phonelist                                      # 等价 换行分割
        sed 's/Martin/Mary/;s/Terrell/Tearrey/' phonelist          # 等价 分号分割
        sed -e 's/Martin/Mary/' -e 's/Terrell/Tearrey/' phonelist  # 等价 -e分割
    4.10 sed '/QMPath/{s/QM/PM/                                    
s/=/:/
}' config.ini                                                      # 对于同一个区域，还可以使用{}进行处理
        
        # 调试工具sedsed (参数 -d)   http://aurelio.net/sedsed/sedsed-1.0

        -n   # 告诉 sed 不复制所有的行，只复制 p 函数或在 s 函数后 p 标志所指定的行
        -i   # 直接对文件操作
        -e   # 告诉 sed 把下一个参数接受为编辑命令。 
             # 用于连续执行多个命令,形式:sed -e [command1] -e [commaned2]... [inputfile]
             # 这里有一个花括号的等价形式:sed {command1;command2;... [inputfile]}
        -r   # 正则可不转移特殊字符
        -f   # 告诉 sed 把下一个参数接受为文件名；这个文件应当包含一行一个的编辑命令。
        
        b    # 跳过匹配的行
        y    # 'SELECTION y/string1/string2/' 对所选区域中的string1所含字符对应替换为string2中同位置的字符，与tr命令相同。
        l    # 打印不可见字符 l能打印处不可见得字符,如制表符/t 结束符$等
        q    # 退出
        =    # 在输出行内容前打印该行行号
            [/pattern/]= 
            [address1[,address2]]=
        &    # 用于存储匹配模式的内容，通常与替换命令s一起使用。
            
        *    # 任意多个 前驱字符(前导符)
        ?    # 0或1个 最小匹配 没加-r参数需转义 \?
        $    # 最后一行
        .*   # 匹配任意多个字符
        \(a\)   # 保存a作为标签1(\1)

#   .---------.-----------.-----------------------------------------.
#   |         |           |           Modifications to:             |
#   |         |  Address  '---------.---------.---------.-----------'
#   | Command | or Range  | Input   | Output  | Pattern |   Hold    |
#   |         |           | Stream  | Stream  | Space   |   Buffer  |
#   '---------+-----------+---------+---------+---------+-----------'
#   |    =    |     -     |    -    |    +    |    -    |     -     |
#   |    a    |     1     |    -    |    +    |    -    |     -     |
#   |    b    |     2     |    -    |    -    |    -    |     -     |
#   |    c    |     2     |    -    |    +    |    -    |     -     |
#   |    d    |     2     |    +    |    -    |    +    |     -     |
#   |    D    |     2     |    +    |    -    |    +    |     -     |
#   |    g    |     2     |    -    |    -    |    +    |     -     |
#   |    G    |     2     |    -    |    -    |    +    |     -     |
#   |    h    |     2     |    -    |    -    |    -    |     +     |
#   |    H    |     2     |    -    |    -    |    -    |     +     |
#   |    i    |     1     |    -    |    +    |    -    |     -     |
#   |    l    |     1     |    -    |    +    |    -    |     -     |
#   |    n    |     2     |    +    |    *    |    -    |     -     |
#   |    N    |     2     |    +    |    -    |    +    |     -     |
#   |    p    |     2     |    -    |    +    |    -    |     -     |
#   |    P    |     2     |    -    |    +    |    -    |     -     |
#   |    q    |     1     |    -    |    -    |    -    |     -     |
#   |    r    |     1     |    -    |    +    |    -    |     -     |
#   |    s    |     2     |    -    |    -    |    +    |     -     |
#   |    t    |     2     |    -    |    -    |    -    |     -     |
#   |    w    |     2     |    -    |    +    |    -    |     -     |
#   |    x    |     2     |    -    |    -    |    +    |     +     |
#   |    y    |     2     |    -    |    -    |    +    |     -     |
#   '---------'-----------'---------'---------'---------'-----------'
    Modifications to:
    1    Command takes single address or pattern.
    2    Command takes pair of addresses.
    -    Command does not modify the buffer.
    +    Command modifies the buffer.
    *    The "n" command may or may not generate output depending
         on the "-n" command option.
        
sed_address(){
1. 地址: 选择要编辑的行
2. 地址可以是行号或者是上下文地址。
通过用花括号('{ }')组合(group)命令，可以用一个地址(或地址对)来控制一组命令的应用
2.1. 行号地址
作为特殊情况，字符 $ 匹配输入文件的最后一行。
2.2 上下文地址
上下文地址是包围在斜杠中('/')的模式('正则表达式')。
    1) 普通字符(不是下面讨论的某个字符)是一个正则表达式，并且匹配这个字符。
    2) 在正则表达式开始处的'^'符号匹配在行开始处的空(null)字符。
    3) 在正则表达式结束处的美元符号'$'匹配在行结束处的空字符。
    4) 字符'\n'匹配内嵌的换行字符，而不是在模式空间结束处的换行。
    5) 点'.'匹配除了模式空间的终止换行之外的任何字符。
    6) 跟随着星号'*'的正则表达式，匹配它所跟丛的正则表达式的任何数目(包括 0)的毗连出现。
    7) 在方括号'[ ]'内的字符串，匹配在字符串内的任何字符，而非其他。但是如果这个字符串的第一个字符是'^'符号，正则表达式匹配除了在这个字符串内的字符和模式空间的终止换行之外的任何字符。
    8) 正则表达式的串联是正则表达式，它匹配这个正则表达式的成员所匹配的字符串的串联。
    9) 在顺序的'\('和'\)'之间的正则表达式，在效果上等同于没有它修饰的正则表达式，但它有个副作用，将在下面的 s 命令和紧后面的规定 10 中描述。
    10) 表达式'\d'意味着与在同一个表达式中先前的'\('和'\)'中包围的表达式所匹配的那些字符同样的字符串。这里的 d 是一个单一的数字；指定的字符串是'\('的从左至右的第 d 个出现所起始的字符串。例如，表达式'^\(.*\)\1'匹配开始于同一个字符串的两次重复出现的行。
    11) 孤立的空正则表达式(就是'//')等价于编译的最后一个正则表达式。
要使用特殊字符(^ $ . * [ ] \ /)中的某一个字符作为文字(去匹配输入中它们自身的出现)，要对这个特殊字符前导一个反斜杠'\'。
上下文地址'匹配'输入要求地址内的整个模式匹配模式空间的某个部分。

echo "foo\nBEGIN\n1234\n6789\nEND\nbar\nBEGIN\na\nb\nc\nEND\nbaz" > range.txt
sed -n '/BEGIN/,/END/p' range.txt # both starting and ending REGEXP part of output
sed -n '/BEGIN/,/END/{//!p}' range.txt # both starting and ending REGEXP not part of ouput
key.# remember that empty REGEXP section will reuse previously matched REGEXP
sed -n '/BEGIN/,/END/{/END/!p}' range.txt # only starting REGEXP part of output 
sed -n '/BEGIN/,/END/{/BEGIN/!p}' range.txt # only ending REGEXP part of output
sed '/BEGIN/,/END/d' range.txt # both starting and ending REGEXP not part of output
sed '/BEGIN/,/END/{//!d}' range.txt #  both starting and ending REGEXP part of output
sed '/BEGIN/,/END/{/BEGIN/!d}' range.txt # only starting REGEXP part of output
sed '/BEGIN/,/END/{/END/!d}' range.txt # only ending REGEXP part of output
sed -n '/BEGIN/,/END/{p;/END/q}' range.txt # Getting first block is very simple by using q command
}

sed_space(){
1. 面向整行的函数 # i\ a\ c\ n d
1.1 i\   # 行前插入  i用于在指定行前面插入其他文本,使用方法: sed [options] '[range]i [string]' [filename]
i\
TEXT
    i\ 函数表现得等同于 a\ 函数，除了<文本>在匹配行之前写入输出之外。关于 a\ 函数的所有其他注释同样适用于 i\ 函数。
1.2 a\   # 行后插入  a用于在指定行后面追加其他文本,使用方法: sed [options] '[range]a [string]' [filename]
a\
TEXT
    a\ 函数导致在匹配它的地址的行之后把参数<文本>写入输出。a\ 命令是天生多行的；a\ 必须出现在一行的结束处，而<文本>可以包含任意数目的行。
    为了保持一行一个命令的构想，内部的换行必须用给换行立即前导上反斜杠字符('\')的方式来隐藏。<文本>参数终止于第一个未隐藏的换行.
    一旦 a\ 函数成功的执行了，<文本>将被写入输出，而不管后来的命令对触发它的行会做些什么。
    触发的行可以被完全删除掉；而<文本>仍会被写入输出。<文本>不被地址匹配所扫描，不尝试对它做编辑命令。它不引起行号计数器的任何变化。
1.3 c\   # 修改      c用于对指定行进行修改,使用方法: sed [options] '[range]c [string]' [filename]
c\
TEXT
    c\ 函数删除它的地址所选择的那些行，并把它们替代为在<文本>中的行。
    象 a\ 和 i\ 一样，c 必须跟随着被反斜杠隐藏了的换行；并且在<文本>中的内部的换行必须用反斜杠隐藏。
    c\ 命令可以有两个地址，所以可选择一定范围内的行。如果找到，在这个范围内的所有行都被删除，只把<文本>的一个复本写入输出，而不是对每个删除的行都写一个复本。
    在一行已经被 c\ 函数删除之后，在这个已删除的行上将不再尝试进一步的命令。
    如果 a\ 或 r\ 函数在某一行之后添加了文本，而这一行随后被 c 函数变更了，则 c 函数所插入的文本将会放置在 a 或 r 函数的文本之前。
    seq 10 | sed '2,9c hello'
1.4 n   # 下一行
    n 函数从输入读取下一行，替代当前行。当前行被写入输出，如果输入还有数据的话。继续执行编辑命令列表在 n 命令之后的部分。
    如果输入没有数据的话，直接退出，不再执行后续命令。
    seq 6 | sed 'n;n;s/./x/'
1.5 d   # 删除行  d 函数从文件中删除(不写入输出)匹配它的地址的所有行。
    d还有一个副作用，在这个已删除的行上将不再尝试进一步的命令；在执行了 d 之后，马上就从输入读取一个新行，在新行上从头重新启动编辑命令列表。
    seq 3 | sed 2d
注意: 在这些函数放入输出的文本内，前导的空白和 tab 都会消失，象 sed 的编辑命令一样。要把前导的空白和 tab 放入输出中，
      需要在想要的第一个空白或 tab 之前前导反斜杠；这个反斜杠不会出现在输出中。
1.6 y/SOURCE-CHARS/DEST-CHARS/

2.  替换函数 s  # 改变在一行之内通过上下文查找而选择出的这一行的某部分。
    s    # s<模式><替代><标志>   ->替换<模式>为<替代>
    2.1 模式
    <模式>参数包含一个模式，它完全等同于地址中的模式；在<模式>和上下文地址之间的唯一区别是上下文地址必须用斜杠字符('/')来界定；
    <模式>可以用不是空格或换行的任何其他字符来界定。
    缺省的，只替换匹配<模式>的第一个字符串，参见后面的 g 标志。
    2.2 替代
    <替代>不是模式，在模式中有特殊意义的字符在<替代>中没有特殊意义。反而有特殊意义的字符是:
        & 被替代为匹配<模式>的字符串。
        \d (这里的 d 是一个单一的数字)被替代为同<模式>中第 d 个包围在'\('和'\)'内的部分相匹配的子串。
如果在<模式>中出现嵌套的子串，第 d 个通过计数开分界符 ('\(')来界定。同在模式中一样，特殊字符可以通过前导反斜杠('\')来变为文字。
   # 标志g: 替换默认只对每行的第一处匹配进行,而加上g之后,将对每行所有匹配的字符串进行替换
   # 标志[n]: 数字标志,匹配到的第n次才进行替换
   # 标志p: 打印此行，
            如果做了成功替换的话。p 标志导致把输入行写入输出，当且仅当这个 s 函数实际上做了替换。
            注意如果有多个 s 函数，每个函数都跟随着 p 标志，它们都在同一个输入行上成功的做了替换，会把这一行的多个复本写到输出: 
            每个成功的替换都写一个复本。
            sed -n 's/sed/wangfl/p; s/wangfl/awk/p' test.sh 
   # 标志w: 把此行写入一个文件，如果做了成功的替换的话。w 标志导致实际上被 s 函数替代了那些行被写到<文件名>所指名的文件中。
            如果<文件名>在 sed 运行前就存在，则覆盖它。否则，就建立它。
            同 p 一样有着写入一个输入行的多个略有不同的复本的可能性。
   # 标志i: 忽略大小写标志,加上i标志之后"origin_string"匹配时不去分大小写字母
   # 标志e: 把替换后的行作为shell命令执行
   # 替换命令的标志使可以组合使用的,例如:sed -n 's/hello/hi/gpw output.txt' test.txt
   # 分割标志/可以用任意字符替换,sed根据s后边紧跟的第一个字符判断你用了什么做分隔符
   # 匹配或者替换字符串出现分割标志的时候要用''进行转义zhuanyi
g  # 配合s全部替换
在<模式>和上下文地址之间的唯一区别是上下文地址必须用斜杠字符('/')来界定；<模式>可以用不是空格或换行的任何其他字符来界定。
<替代>参数紧接着<模式>的第二个分界字符之后开始，并且它必须立即跟随着分界字符的另一个实例。

2.3 delimiter
echo '/home/learnbyexample/reports' | sed 's/\/home\/learnbyexample\//~\//'
echo '/home/learnbyexample/reports' | sed 's#/home/learnbyexample/#~/#'
printf '/foo/bar/1\n/foo/baz/1\n' | sed -n '\;/foo/bar/;p'

3. 输入输出函数
3.1 p 打印函数把寻址到的行写到标准输出文件。在遇到 p 函数的时候就写入它们，而不管后续的编辑命令对这些行会做些什么。
    p 常和命令行选项 -n 一起使用。
    行处理完之后，模式空间内所有数据输出到缓冲区显示，模式空间处理下一行数据之间，清空模式空间内数据。
    seq 3 | sed -n 2p
3.2 w <文件名>
    w 写函数把寻址到的行写到<文件名>指名的文件中。
    如果这个文件以前就存在，则覆盖它；否则，就建立它。
    每行都按遇到写函数时现存的样子写入，而不管后续的编辑命令对这些行会做些什么。
    必须用精确的一个空格分隔 w 和<文件名>。在 s 函数的 w 标志之后和写函数中可以提及的不同的文件名字合起来的最大数目为 10 个。
3.3 r <文件名> # 读
    读函数读入<文件名>的内容，并把它们添加到匹配这个地址的行的后面。
    如果 r 和 a 函数在同一行上执行，来自 a 函数和 r 函数的文本按照这些函数执行的次序写入输出。
    必须用精确的一个空格分隔 r 和<文件名>。
    如果 r 函数提及的文件不能打开，它被当作一个空文件，而不是一个错误，所以不给出诊断信息。
注意: 因为对可以同时打开的文件数目是有所限制的，要小心在 w 命令或标志中不要提及多于 10 个(不同的)文件；
      如果有任何 r 函数出现，这个数目还会再减少一个。
    
4.  多输入行函数
有三个用大写字母拼写的函数特殊处理包含内嵌换行的模式空间；它们主要意图提供跨越输入中的行的模式匹配。
4.1 N:读入下一行，追加到模式空间行后面，此时模式空间中有两行。^匹配模式空间的最开始，而$是匹配模式空间的最后位置。
    在模式空间中把下一行添加到当前行之后；两个输入行用一个内嵌的换行分隔。模式匹配可以延伸跨越这个内嵌换行。
    N: 下一行没有数据是不执行任何操作。
4.2 D: 删除模式空间的第一行，不读下一行到模式空间。注意，当模式空间仍有内容时，不读入新的输入行，类似形成一个循环。
删除当前模式空间中直到并包括第一个换行字符的所有字符。
如果这个模式空间变成了空的(唯一的换行是终止换行)，则从输入读取另一行。
在任何情况下，都再次从编辑命令列表的起始处开始执行。
4.3 P 打印模式空间中的直到并包括第一个换行的所有字符。
注: P 和 D 函数等价于它们对应的小写函数，如果在模式空间中没有内嵌换行的话。
    seq 6 | sed -n 'N;l;D'
    seq 6 | sed -n 'N;p;D'
5. 保存和取回函数
5.1 g:将保持空间的内容拷贝到模式空间中，会将模式空间原来的值覆盖掉。
把保存区域的内容复制到模式空间(销毁模式空间以前的内容)。
5.2 G:将保持空间的内容追加到模式空间中。
G 函数把保存区域的内容添加到模式空间的内容之后；以前和新的内容用换行分隔。
sed G
sed 'G;G'
5.3 h:将模式空间的值拷贝到保持空间，会将保持空间原来的值覆盖掉。
把模式空间的内容复制到保存区域(销毁保存区域以前的内容)。
5.4  H:将模式空间的值追加到保持空间中。
把模式空间的内容添加到保存区域的内容之后；以前和新的内容用换行分隔。
5.5。x:交换模式空间和保持空间的内容。
对换命令交换模式空间和保存区域的内容。

6. 控制流函数
6.1 ! :对其前面的要匹配的范围取反
非命令导致(写在同一行上的)下一个命令，应用到所有的且只能是未被地址部分选择到那些输入行上。
awk '/are/' poem.txt
awk '!/are/' poem.txt
awk '/are/ && !/so/' poem.txt
6.2 { -- Grouping
    { cmd ; cmd ... }
组合命令'{'导致下一组命令作为一个块而被应用(或不应用)到组合命令的地址所选择的输入行上。在组合控制下的的命令中的
第一个命令可以出现在与'{'相同的一行或下一行上。组合的命令由自己独立在一行之上的相匹配的'}'终止。
seq 3 | sed -n '2{s/2/X/ ; p}'
6.3 :label -- place a label 
    : LABEL
标号函数在编辑命令列表中标记一个位置，它将来可以被 b 和 t 函数所引用。<标号>可以是八个或更少的字符的任何序列；
如果两个不同的冒号函数有相同的标号，就会生成编译时间诊断信息，而不做执行尝试。
6.4 b<标号> -- branch to label
    b LABEL # 如果不指定label，则开始下一个循环
分支函数导致应用于当前输入行上的编辑命令序列，被立即重新启动到有相同的<标号>的冒号函数的所在位置之后。
如果在所有编辑命令都已经被编译了之后仍没有找到有相同的标号的冒号函数，就会生成一个编译时间诊断信息，而不做执行尝试。
不带有<标号>的 b 函数被当作到编辑命令列表结束处的分支；对当前输入行做应做的无论怎样的处理，并读入其他输入行；编辑命令的列表在这个新行上从头重新启动。
6.5  )t<标号> -- test substitutions
      t LABEL # 如果不指定label，则开始下一个循环
    t 函数测试在当前输入行上是否已经做了任何成功的替换；如果有，它分支到<标号>；否则，它什么都不做。指示已经执行了成功的替换的标志通过如下方式复零:
        1) 读取一个新输入行，或
        2) 执行 a 和 t 函数。
echo 'foo::bar::baz' | sed 's/::/:0:/g'     # foo:0:bar:0:baz
echo 'foo:::bar::baz' | sed 's/::/:0:/g'    # foo:0::bar:0:baz
echo 'foo::bar::baz' | sed ':a s/::/:0:/; ta'   # foo:0:bar:0:baz
echo 'foo:::bar::baz' | sed ':a s/::/:0:/; ta'  # foo:0:0:bar:0:baz

7. 杂类函数 : ! 不匹配才执行； q退出sed; {} 组合命令; = 打印行号; 
7.1 = -- equals
    = 函数向标准输出写入匹配它的地址的行的行号。
    printf '%s\n' aaa bbb ccc | sed =
    sed -n '/blue/=' poem.txt
    sed -n '/are/=' poem.txt
    sed -n '/blue/{=;p}' poem.txt
    sed -n '/blue/{p;=}' poem.txt
    
7.2 q -- quit
    q [EXIT-CODE]
    q 函数导致把当前行写到标准输出(如果应该的话)，任何添加的或读入的文本也被写出，而且执行会被终止。
    seq 3 | sed 2q
    
7.3 + Relative addressing
sed -n '/is/,+2p' addr_range.txt
sed -n '/do/,+2p' addr_range.txt
sed -n '3,+4p' addr_range.txt
7.4 ~ step
seq 10 | sed -n '1~2p'
seq 10 | sed -n '2~4p'
seq 10 | sed -n '2,~4p'
seq 10 | sed -n '5,~4p'
sed -n '/Just/,~5p' addr_range.txt
        }
sed_script(){
11. 全局变量: '模式空间' 和 '保存空间'
1. n N读入下一行，且n会输出， N不会
打印奇数行 sed '{n;d}' file.txt
2. h H g G x 交换两个变量
行连接 sed '1{h}; 1{s/:.*//}; 1{x}; {G}; {s/\n/:/}' file.txt 
3 D P 删除和打印
打印奇数行 sed 'N;P;d' file.txt

22. 分支和循环: 靠跳转实现，类似jmp法
:tag 标签
b 条件跳转
死循环 sed -e ':tag;b tag' file.txt
d 删除本行进入下一轮
t s命令成功则跳转

33. sed程序设计
操作对象  是两个变量  模式空间和保存空间
变量类型  字符串 从一种模式的字符串到另一种模式
操作手段  采用固定的内置函数d,a,i,c,s和n,N,d,D,h,H,g,G,x
操作效果  变量('字符串')被改变，无关系、算术运算
工作模式  sed自动的循环读入每一行，对每一行的处理是由sed顺序执行编辑命令，在执行编辑命令时，
          允许跳转，以形成分支和循环，也许打破sed循环，提前读入下n行。
        }
sed_demo(){
        sed -i 's/\r//g' somefile.txt # Remove \r (carriage return) in a file
        sed 's/\(.*\)1/\12/g'         # 将任何以1结尾的字符串替换为以2结尾的字符串
        sed 's/[ \t]*$//'             # 删除每行后的空白
        sed 's/\([\\`\\"$\\\\]\)/\\\1/g' # 将所有转义字符之前加上\
        -e 和 分号
        sed -e 's/Martin/Mary/' -e 's/Terrell/Tearrey/' phonelist
        sed 's/Martin/Mary/;s/Terrell/Tearrey/' phonelist
        $为取最后一行
            # ,:  表示范围.
       1) sed -n '/west/,/east/p' datafile # 表示打印所有从包含west开始到包含east的行,如果直到文件的结尾都没有包含east的行,将打印west后面的所有行.
       2) sed -n '5,/^northeast/p' datafile # 表示从第五行开始打印,直到遇到以northeast开始的行结束打印.
       3) sed '/test/,/check/s/$/sed test/' example # 对于模板test和west之间的行，每行的末尾用字符串sed test替换。
            
            # !:  表示对匹配结果取反. # 除去所匹配行外的范围：如/Llew/! 表示除了匹配Llew的行外其余的文本行
       1) sed '/north/!d' datafile 将删除所有不包含north的行.
            # a: 追加命令.
       1) sed '/^north/a first line \  # \可以很好把命令和命名参数分开,注意下行前空格
           second line \
           third line' datafile 将会在所有包含north行的后面追加first line \r second line \n third line. 其中\表示下一行还有内容的连词. 如果是c-shell:
          sed '/^north/a first line \\
           second line \\
           third line' datafile 其中多出来的\是转义符.
       2) sed '/Martin, Marty/a\
Jonney, Wang 923-3322' phonelist
          等同于 sed '/Martin, Marty/a     Jonney, Wang 923-3322' phonelist # a 命令后的空格会被忽略掉
       3) sed '/^test/a\\--->this is a example' example # '--->this is a example'被追加到以test开头的行后面，sed要求命令a后面有一个反斜杠
          # i: 插入命令：
       1) sed '2i Jonney, Wang 923-3322' phonelist
          # c: 行替代命令
       1) sed '/Llewellyn/c         BANNED' phonelist # 所有包含Llewellyn的行，行内容被替换为BANNED
       2) sed 's/Llewellyn/BANNED/g' phonelist        # 所有包含Llewellyn的行，Llewellyn被替换为BANNED
          d: 表示删除.
       1) sed '/north/d' datafile # 将删除所有包含north的行.
       2) sed '3d' datafile       # 将删除第三行.
       3) sed '3,$d' datafile     # 将删除第三行到文件的结尾行.
       4) sed 'd' datafile        # 将删除所有行.
       5) sed '$d' datafile       # 将删除文件的结尾行.
       sed '/^ *#/d; /^ *$/d'     # 删除注释和空白行
          e: 表示多点编辑.
       1) sed -e '1,3d' -e 's/Hemenway/Jones/' datafile  # 一个sed语句执行多条编辑命令, 因此命令的顺序会影响其最终结果.
       2) sed -e 's/Hemenway/Jones/' -e 's/Jones/Max/'   # datafile 先用Jones替换Hemenway, 再用Max替换Jones.
       3) sed -e '1,5d' -e 's/test/check/' example       # 第一条命令删除1至5行，第二条命令用check替换test。命令的执行顺序对结果有影响。
                                                         # 如果两个命令都是替换命令，那么第一个替换命令将影响第二个替换命令的结果。
          # h和g/G: 保持和获取命令.
       1) sed -e '/northeast/h' -e '$G' datafile sed将把所有包含northeast的行轮流缓存到其内部缓冲区, 最后将只是保留最后一个匹配的行,
           $G是将缓冲区的行输出到$G匹配行的后面, 该例表示将最后一个包含northeast的行追加到文件的末尾.
       2) sed -e '/WE/{h; d;}' -e '/CT/{G;}' datafile 表示将包含WE的行保存到缓冲区, 然后删除该行,最后将缓冲区中保存的那份输出到CT行的后面.
       3) sed -e '/northeast/h' -e '$g' datafile 表示将包含northeast的行保存到缓冲区, 再将缓冲区中保存的那份替换文件的最后一行并输出.
           再与h合用时, g表示替换, G表示追加到匹配行后面.
       4) sed -e '/WE/{h; d;}' -e '/CT/{g;}' datafile 保留包含WE的行到缓冲区, 如果有新的匹配行出现将会替换上一个存在缓冲区中的行, 如果此时发现有
           包含CT的行出现, 就用缓冲区中的当前行替换这个匹配CT的行, 之后如果有新的WE出现, 将会用该新行替换缓冲区中数据, 当前再次遇到CT的时候,将用最
           新的缓冲区数据替换该CT行.
           sed ':a; /\\$/N; s/\\\n//; ta' # 连接结尾有\的行和其下一行
          # i: 表示插入.
       1) sed '/north/i first line \
           second line \
           third line' datafile  #  其规则和a命令基本相同, 只是a是将额外的信息输出到匹配行的后面, i是将额外信息输出到匹配行的前面.
          # p: 表示打印.
       1) sed '/north/p' datafile # 将打印所有包含north的行.
       2) sed '3p' datafile       # 将打印第三行.
       3) sed '3,$p' datafile     # 将打印第三行到文件的结尾行.
       4) sed 'p' datafile        # 将打印所有行.
       5) sed -n 's/Hemenway/Jones/gp' testfile  #所有的Hemenway被替换为Jones。-n选项加p命令则表示只打印匹配行。
       注: 使用p的时候sed将会输出指定打印的行和所有行, 当其与-n选项组合时候,将只是打印输出匹配的行.
          # n: 下一行命令.
       1) sed '/north/ {n; s/Chin/Joseph/}'    # datafile 将先定位包含north的行, 然后取其下一行作为目标行, 再在该目标行上执行s/Chin/Joseph/的替换操作.
       2) sed '/north/ {n; n; s/Chin/Joseph/}' # datafile 将取north包含行的后两行作为目标行.
       注: {}作为嵌入的脚本执行.
          # q: 退出命令.
       1) sed '5q' datafile                           # 到第五行退出(输出第五行).
       2) sed '/north/q' datafile                     # 输出到包含north的行退出(输出包含north的行).
       3) sed '/Lewis/ {s/Lewis/Joseph/; q}' datafile # 将先定位包含Lewis的行, 然后用Joseph替换Lewis,最后退出sed操作.
          # r: 文件读入.
       1) sed '/Suan/r newfile' datafile       # 在输出时,将newfile的文件内容跟随在datafile中包含Suan的行后面输出,如果多行都包含Suan,则文件被多次输出.
          seq 3 | sed '2r/etc/hostname'
          r 从文件读入 插入方式同a函数
          # s: 表示替换.
       1) sed 's/west/north/g' datafile       # 将所有west替换为north, g表示如果一行之内多次出现west,将全部替换, 如果没有g命令,将只是替换该行的第一个匹配.
       2) sed -n 's/^west/north/p' datafile   # 将所有以west开头的行替换为north, 同时只是输出替换匹配的行.
       3) sed -n '1,5 s/\(Mar\)got/\1ianne/p' datafile # 将从第一行到第五行中所有的Margot替换为Marianne, \1是\(Mar\)的变量替代符.
       4) echo "this is a text about the usage of sed" | sed -r 's/[a-z]/\u&/g'     # \u是把下一个元字符转换成大写，而&指的是之前所匹配到的字符
       5) echo "this is a text about the usage of sed" | sed -r 's/\b[a-z]/\u&/g'   # 这里的\b是指边界符
       6) echo "this is a text about the usage of sed" | sed -r 's/\b[a-z]/\u&/2g'  # /g表示匹配全部，/Ng表示匹配替换从第N处开始
       7) sed 's/^192.168.0.1/&localhost/' example # &符号表示替换换字符串中被找到的部份。所有以192.168.0.1开头的行都会被替换成它自已加localhost，变成192.168.0.1localhost。
       8) sed -n 's/\(love\)able/\1rs/p' example # love被标记为1，所有loveable会被替换成lovers，而且替换的行会被打印出来。
       9) sed 's#10#100#g' example # 不论什么字符，紧跟着s命令的都被认为是新的分隔符，所以，"#"在这里是分隔符，代替了默认的"/"分隔符。表示把所有10替换成100。
       
       sed '/echo/{s/1000/2000/}' file.txt
       sed '/echo/{s/1000/2000/g}' file.txt
       sed -n '/echo/{s/1000/2000/p}' file.txt
       sed '/echo/{s/1000/2000/w result.txt}' file.txt
       sed '/echo/{s/1000/9&9/}' file.txt
       sed '/echo/{s/(10)00/\1/}' file.txt
       
       # w: 文件写入.
       1) sed -n '/north/w newfile2' datafile     # 将datafile中所有包含north的行都写入到newfile2中.
       2) sed 's/Rob/Robbin/gw result' phonelist  # 将所有Rob 改为Robbin，并将结果写到一个叫做result 的文件中
       3) sed -n '/test/w file' example # 在example中所有包含test的行都被写入file里。
          # x: 互换命令.
       1) sed -e '/pat/h' -e '/Margot/x' datafile x命令表示当定位到包含Margot行,互换缓冲区和该匹配Margot行的数据, 即缓冲区中的数据替换该匹配行显示,
           该匹配行进入缓冲区, 如果在交换时缓冲区是空, 则该匹配行被换入缓冲区, 空行将替换该行显示, 后面依此类推. 如果交换后, 再次出现匹配pat的行, 该
           行将仍然会按照h命令的规则替换(不是交换, 交换只是发生在发现匹配Margot的时候)缓冲区中的数据.
          # y: 变形命令.
       1) sed '1,3y/abcd/ABCD/' datafile 将1到3行中的小写abcd对应者替换为ABCD,注意abcd和ABCD是一一对应的. 如果他们的长度不匹配,sed将报错.
       2) sed 'y/abcdefghijklmnopqrstuvwxyz/ABCDEFGHIJKLMNOPQRSTUVWXYZ/' datafile 将datafile中所有的小写字符替换为大写字母.
            倒置phonelist
       1) sed '1!G;h;$!d' phonelist # sed -e '1{h;d}' -e '2,8{G;h;d}' -e '${G;h}' phonelist 
        除了第一行和最后一行处理不一样以外(第一行只执行h，而最后一行只执行G)
        其余行都是用G、d和h(使用d 的原因是不把中间结果输出)
          # & : 代表SELECTION中匹配的部分，常用于某个子字符串前后添加字符的操作
          # \num : num代表匹配子字符串的序号，从1开始，\num表示匹配的子字符串(正则表达式中称为分组)，其中子字符串的匹配模式是由圆括号及其转义字符构成
          "Terrell, Terry 617-7989"
        1) sed '/[0-9]\{3\}-[0-9]\{4\}/s//Tel: &/g' phonelist       # 将每个电话号码前加上Tel:
        2) sed 's/\([0-9]\{3\}\)-\([0-9]\{4\}\)/\1-6\2/g' phonelist # 电话号码升级，从原来的四位数统一升级为五位数，6开头
        3) sed 's/.*usr.*/#&/' paths         # 假设paths文件用#进行注释，则注释掉含有usr的行
        4) sed '/usr/s/^/#/' paths
        5) echo "<Amount>10kg</Amount>" | sed 's#\(<Amount>\)[0-9,a-z]*\(</Amount>\)#\1'100kg'\2#g'<Amount>100kg</Amount>
        6) sed -n 's/\(Mar\)got/\1lianne/p' testfile
           sed -i 's/\b[0-9]\{3\}\b/NUMBER/g' file.txt \b表示文件边界
        
        man -k pthread | awk '{ print $1 }' | sed 's/$/",/g' | sed 's/^/"/g' | uniq 
        ## :label和b label 
        1) 下面的例子中模拟了一个if操作存在符合pattern则跳过command2直接执行command3
            command1
            /pattern/b goto
            command2
            :goto
            command3
       2) 而下边的例子则模拟了一个if else操作，符合pattern时执行command3，不符合时执行command2
            command1
            /pattern/b dosomething
            command2
            b
            :dosomething
            command3
        [:alnum:]：表示所有的字母和数字
        [:digit:]: 表示所有数字
        [:upper:]: 表示所有的大写字母
        [:lower:] ：表示所有的小写字母
        1) sed 's/[[:digit:]]//g' config.ini # 去掉config.ini中的数字，使得config.ini变为一个配置文件模板
        
        }
        
        sed -n -e '/main[[:space:]]*(/,/^}/p' sourcefile.c | more # 打印 C 源文件中的 main() 函数
sed_pattern(){
1. 标准正则表达式
.  匹配单个字符(除行尾) # echo -e "cat\nbat\nrat\nmat\nbatting\nrats\nmats" | sed -n '/^..t$/p'
[] 匹配字符集           # echo -e "Call\nTall\nBall" | sed -n '/[CT]all/ p'
[^]排除字符集           # echo -e "Call\nTall\nBall" | sed -n '/[^CT]all/ p'
[-]字符范围。           # echo -e "Call\nTall\nBall" | sed -n '/[C-Z]all/ p'
? ，\+ ，* 分别对应0次到1次，一次到多次，0次到多次匹配。
{n} ，{n,} ，{m, n} 精确匹配N次，至少匹配N次，匹配M-N次
| 或操作                # echo -e "str1\nstr2\nstr3\nstr4" | sed -n '/str\(1\|3\)/ p'
2. 元字符
\s       匹配单个空白内容    # echo -e "Line\t1\nLine2" | sed -n '/Line\s/ p'   # Line 1 
\S       匹配单个非空白内容。
\w ， \W 单个单词、非单词。
3. POSIX兼容的正则
主要包含[:alnum:]，[:alpha:]，[:blank:]，[:digit:]，[:lower:]，[:upper:]，[:punct:]，[:space:]
}

sed_label(){
  : lable # 建立命令标记，配合b，t函数使用跳转
  b lable # 分支到脚本中带有标记的地方，如果分支不存在则分支到脚本的末尾。
  t labe  # 判断分支，从最后一行开始，条件一旦满足或者T,t命令，将导致分支到带有标号的命令出，或者到脚本末尾。与b函数不同在于t在执行跳转前会先检查其前一个替换命令是否成功，如成功，则执行跳转。
  
  sed -e '{:p1;/A/s/A/AA/;/B/s/B/BB/;/[AB]\{10\}/b;b p1;}'     # 文件内容第一行A第二行B:建立标签p1;两个替换函数(A替换成AA,B替换成BB)当A或者B达到10个以后调用b,返回
  echo 'sd  f   f   [a    b      c    cddd    eee]' | sed ':n;s#\(\[[^ ]*\)  *#\1#;tn'  # 标签函数t使用方法,替换[]里的空格
  echo "198723124.03"|sed -r ':a;s/([0-9]+)([0-9]{3})/\1,\2/;ta'  # 每三个字符加一个逗号
}

sed_out_variable(){
            sed -n ""$a",10p" test.sh
            sed -n ''"$a"',10p' test.sh 
            echo|sed "s/^/$RANDOM.rmvb_/g"
            echo|sed 's/^/'"$RANDOM"'.rmvb_/g'
            # 其实使用#或%或;作为分隔符也是可以的，只要不会与替换中有相同的而且不是元字符的特殊符号都是可以的；使用时可以根据情况灵活选择。
            find . -type f | sed -n "s%\.%$PWD%p"
            find . -type f | sed -n "s#\.#$PWD#p"
            
            echo|sed 's/^/'`echo $RANDOM`'.rmvb_/g'
            echo|sed 's/^/'$(echo $RANDOM)'.rmvb_/g'
            echo|sed 's/^/'$(date +"%Y%m%d")'.rmvb_/g'
            echo|sed "s/^/$(date +"%Y%m%d").rmvb_/g"
            echo|sed "s/^/`echo $RANDOM`.rmvb_/g"
            
            printf 'user\nhome\n' | sed '/user/ s/$/: $USER/'
            user: $USER
            home
            printf 'user\nhome\n' | sed '/user/ s/$/: '"$USER"'/'
            user: root
            home
            
            printf 'user\nhome\n' | sed '/home/ s/$/: '"$HOME"'/'
            printf 'user\nhome\n' | sed '/home/ s#$#: '"$HOME"'#'
            user
            home: /root
            
            sed '1a'"$(seq 2)" 5.txt
            seq 2 | sed '1r /dev/stdin' 5.txt
            
        }
        
        行号匹配的几种形式: 
            m,n 表示从m行到n行; 
            m,+n 表示从m行到m+n行; 
            m~n 表示从m行开始每n行匹配依次(如1~2表示只匹配奇数行,2~2表示只匹配偶数行)
        $表示最后一行;
        0表示第一行前,也就是最开始;
        匹配后加!表示不匹配以上条件的行
        
        sed /pattern/s/pattern1/pattern2/g：查找符合pattern的行,将该行所有匹配pattern1的字符串替换为pattern2
    
        sed 10q                                       # 显示文件中的前10行 (模拟"head")
        sed -n '$='                                   # 计算行数(模拟 "wc -l")
        sed -n '5,/^no/p'                             # 打印从第5行到以no开头行之间的所有行
        sed -i "/^$f/d"       　　                    # 删除匹配行
        sed -i '/aaa/,$d'                             # 删除匹配行到末尾
        sed -i "s/=/:/"                               # 直接对文本替换
        sed -i "/^pearls/s/$/j/"                      # 找到pearls开头在行尾加j
        sed '/1/,/3/p' file                           # 打印1和3之间的行
        sed -n '1p' 文件                              # 取出指定行
        sed '5i\aaa' file                             # 在第5行之前插入行
        sed '5a\aaa' file                             # 在第5行之后抽入行
        echo a|sed -e '/a/i\b'                        # 在匹配行前插入一行
        echo a|sed -e '/a/a\b'                        # 在匹配行后插入一行
        echo a|sed 's/a/&\nb/g'                       # 在匹配行后插入一行
        seq 10| sed -e{1,3}'s/./a/'                   # 匹配1和3行替换
        sed -n '/regexp/!p'                           # 只显示不匹配正则表达式的行
        sed '/regexp/d'                               # 只显示不匹配正则表达式的行
        sed '$!N;s/\n//'                              # 将每两行连接成一行
        sed '/baz/s/foo/bar/g'                        # 只在行中出现字串"baz"的情况下将"foo"替换成"bar"
        sed '/baz/!s/foo/bar/g'                       # 将"foo"替换成"bar"，并且只在行中未出现字串"baz"的情况下替换
        echo a|sed -e 's/a/#&/g'                      # 在a前面加#号
        sed 's/foo/bar/4'                             # 只替换每一行中的第四个字串
        sed 's/\(.*\)foo/\1bar/'                      # 替换每行最后一个字符串
        sed 's/\(.*\)foo\(.*foo\)/\1bar\2/'           # 替换倒数第二个字符串
        sed 's/[0-9][0-9]$/&5'                        # 在以[0-9][0-9]结尾的行后加5
        sed -n ' /^eth\|em[01][^:]/{n;p;}'            # 匹配多个关键字
        sed -n -r ' /eth|em[01][^:]/{n;p;}'           # 匹配多个关键字
        echo -e "1\n2"|xargs -i -t sed 's/^/1/' {}    # 同时处理多个文件
        sed '/west/,/east/s/$/*VACA*/'                # 修改west和east之间的所有行，在结尾处加*VACA*
        sed  's/[^1-9]*\([0-9]\+\).*/\1/'             # 取出第一组数字，并且忽略掉开头的0
        sed -n '/regexp/{g;1!p;};h'                   # 查找字符串并将匹配行的上一行显示出来，但并不显示匹配行
        sed -n ' /regexp/{n;p;}'                      # 查找字符串并将匹配行的下一行显示出来，但并不显示匹配行
        sed -n 's/\(mar\)got/\1ianne/p'               # 保存\(mar\)作为标签1
        sed -n 's/\([0-9]\+\).*\(t\)/\2\1/p'          # 保存多个标签
        sed -i -e '1,3d' -e 's/1/2/'                  # 多重编辑(先删除1-3行，在将1替换成2)
        sed -e 's/@.*//g' -e '/^$/d'                  # 删除掉@后面所有字符，和空行
        sed -n -e "{s/文本(正则)/替换的内容/p}"       # 替换并打印出替换行
        sed -n -e "{s/^ *[0-9]*//p}"                  # 打印并删除正则表达式的那部分内容
        echo abcd|sed 'y/bd/BE/'                      # 匹配字符替换
        sed '/^#/b;y/y/P/' 2                          # 非#号开头的行替换字符
        sed '/suan/r 读入文件'                        # 找到含suan的行，在后面加上读入的文件内容
        sed -n '/no/w 写入文件'                       # 找到含no的行，写入到指定文件中
        sed '/regex/G'                                # 在匹配式样行之后插入一空行
        sed '/regex/{x;p;x;G;}'                       # 在匹配式样行之前和之后各插入一空行
        sed 'n;d'                                     # 删除所有偶数行
        sed 'G;G'                                     # 在每一行后面增加两空行
        sed '/^$/d;G'                                 # 在输出的文本中每一行后面将有且只有一空行
        sed  '/^$/d' kaka
        sed 'n;n;n;n;G;'                              # 在每5行后增加一空白行
        sed -n '5~5p'                                 # 只打印行号为5的倍数
        seq 1 30|sed  '5~5s/.*/a/'                    # 倍数行执行替换
        sed -n '3,${p;n;n;n;n;n;n;}'                  # 从第3行开始，每7行显示一次
        sed -n 'h;n;G;p'                              # 奇偶调换
        seq 1 10|sed '1!G;h;$!d'                      # 倒叙排列
        ls -l|sed -n '/^.rwx.*/p'                     # 查找属主权限为7的文件
        sed = filename | sed 'N;s/\n/\t/'             # 为文件中的每一行进行编号(简单的左对齐方式)
        sed 's/^[ \t]*//'                             # 将每一行前导的"空白字符"(空格，制表符)删除,使之左对齐
        sed 's/^[ \t]*//;s/[ \t]*$//'                 # 将每一行中的前导和拖尾的空白字符删除
        sed '/{abc,def\}\/\[111,222]/s/^/00000/'      # 匹配需要转行的字符: } / [
        echo abcd\\nabcde |sed 's/\\n/@/g' |tr '@' '\n'        # 将换行符转换为换行
        cat tmp|awk '{print $1}'|sort -n|sed -n '$p'           # 取一列最大值
        sed -n '{s/^[^\/]*//;s/\:.*//;p}' /etc/passwd          # 取用户家目录(匹配不为/的字符和匹配:到结尾的字符全部删除)
        sed = filename | sed 'N;s/^/      /; s/ *\(.\{6,\}\)\n/\1   /'   # 对文件中的所有行编号(行号在左，文字右端对齐)
        /sbin/ifconfig |sed 's/.*inet addr:\(.*\) Bca.*/\1/g' |sed -n '/eth/{n;p}'   # 取所有IP


echo -e "Line #1\n\n\nLine #2" | sed '/^$/d'       # 移除空行
echo -e "Line #1\n\n\nLine #2" | sed '/./,/^$/!d'  # 删除连续空行
echo -e "\nLine #1\n\nLine #2" | sed '/./,$!d'     # 删除开头的空行
echo -e "\nLine #1\nLine #2\n\n" | sed ':start /^\n*$/{$d; N; b start }' # 删除结尾的空行

 UNIX          |  SED
 --------------+----------------------------------------------------------------
 unix2dos      |  sed 's/$/\r/' new.txt > new2.txt
 dos2unix      |  sed 's/^M$//' test.txt > new.txt 或者 dos2unix() { sed -i 's/\r$//' "$@" ; }
 cat           |  sed ':'
 cat -s        |  sed '/./,/^$/!d'
 tac           |  sed '1!G;h;$!d'
 grep          |  sed '/patt/!d'
 grep -v       |  sed '/patt/d'
 head          |  sed '10q'
 head -1       |  sed 'q'
 tail          |  sed -e ':a' -e '$q;N;11,$D;ba'
 tail -1       |  sed '$!d'
 tail -f       |  sed -u '/./!d'
 cut -c 10     |  sed 's/\(.\)\{10\}.*/\1/'
 cut -d: -f4   |  sed 's/\(\([^:]*\):\)\{4\}.*/\2/'
 tr A-Z a-z    |  sed 'y/ABCDEFGHIJKLMNOPQRSTUVWXYZ/abcdefghijklmnopqrstuvwxyz/'
 tr a-z A-Z    |  sed 'y/abcdefghijklmnopqrstuvwxyz/ABCDEFGHIJKLMNOPQRSTUVWXYZ/'
 tr -s ' '     |  sed 's/ \+/ /g'
 tr -d '\012'  |  sed 'H;$!d;g;s/\n//g'
echo "ABC" | tr "ABC" "abc" # echo "ABC" | sed 'y/ABC/abc/'
 wc -l         |  sed -n '$='
 uniq          |  sed 'N;/^\(.*\)\n\1$/!P;D'
 rev           |  sed '/\n/!G;s/\(.\)\(.*\n\)/&\2\1/;//D;s/.//'
 basename      |  sed 's,.*/,,'
 dirname       |  sed 's,[^/]*$,,'
 xargs         |  sed -e ':a' -e '$!N;s/\n/ /;ta'
 paste -sd:    |  sed -e ':a' -e '$!N;s/\n/:/;ta'
 cat -n        |  sed '=' | sed '$!N;s/\n/ /'
 grep -n       |  sed -n '/patt/{=;p;}' | sed '$!N;s/\n/:/'
 cp orig new   |  sed 'w new' orig[/code:1:739eb4cef5]
 echo -e "Line #1\nLine #2" | tee test.txt   # sed -n 'p; w new.txt' test.txt
 expand test.txt > expand.txt   # sed 's/\t/ /g' test.txt > new.txt
 echo -e "Line #1\nLine #2" |nl # echo -e "Line #1\nLine #2" | sed = | sed 'N;s/\n/\t/'
 echo -e "Line #1\nLine #2" | cat -E # echo -e "Line #1\nLine #2" | sed 's|$|&$|'
 echo -e "Line #1\tLine #2" | cat -ET # echo -e "Line #1\tLine #2" | sed -n 'l' | sed 'y/\\t/^I/'
        
sed_keepalive_demo{
  修改keepalive配置剔除后端服务器
      sed -i '/real_server.*10.0.1.158.*8888/,+8 s/^/#/' keepalived.conf
      sed -i '/real_server.*10.0.1.158.*8888/,+8 s/^#//' keepalived.conf
}

sed_rev_demo{
  模仿rev功能
      echo 123 |sed '/\n/!G;s/\(.\)\(.*\n\)/&\2\1/;//D;s/.//;'
      /\n/!G;         　　　　　　# 没有\n换行符，要执行G,因为保留空间中为空，所以在模式空间追加一空行
      s/\(.\)\(.*\n\)/&\2\1/;     # 标签替换 &\n23\n1$ (关键在于& ,可以让后面//匹配到空行)
      //D;            　　　　　　# D 命令会引起循环删除模式空间中的第一部分，如果删除后，模式空间中还有剩余行，则返回 D 之前的命令，重新执行，如果 D 后，模式空间中没有任何内容，则将退出。  //D 匹配空行执行D,如果上句s没有匹配到,//也无法匹配到空行, "//D;"命令结束
      s/.//;          　　　　　　# D结束后,删除开头的 \n
  }
}