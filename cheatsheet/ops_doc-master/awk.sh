awk_script(){
操作对象  是预定义变量和自定义变量
变量类型  字符串 数组和数值
操作手段  除了类似sed中的内置函数外，采用了C语言编程模式，支持关系和算术运算，还有字段操作，对字符串处理功能丰富
操作效果  变量被改变 或 求出统计结果
工作模式 
控制流程  处理一行 if while for break continue 
          AWK行循环 next exit getline

预定义变量的值，是可以改变的；包括 $0 $1 和 FS OFS FNR 和 NR
自定义变量接受三种类型的值，且可以随时改变类型；在算术运算中，非数值的字符串被认为是0值。
> >= < <= == != 可应用于字符串和数值
+ - * / % ^ 只能用于数值; 数值计算更多依赖操作数；字符串处理更多依赖函数；复杂的数值计算也提供了些函数。
~ !~ 表示模式相等，只能用于字符串；
in 可用于if判断和for循环的控制语句中。
模式: 组合模式(&& || !)和范围模式(,)
1. 字符串 : 模式匹配，组合模式，范围模式，字符串处理函数；> == < != 判断, 赋值
2. 数值   : + - * / % ^ 数值处理函数；> >= == < <= != ; 预定义变量的值，赋值
3. 数组   : 赋值，遍历和包含 删除
4. 流处理 : print printf sprintf getline > >> 重定向
5. index是普通匹配，match是模式匹配，另外有RSTART和RLENGTH预定义内置变量和返回匹配数字a可选参数
   substr是基于位置的字符串截取，而sub和gsub是模式替换
}

https://github.com/learnbyexample/Command-line-text-processing/blob/master/gnu_awk.md  # stackoverflow
http://www.math.utah.edu/docs/info/gawk_toc.html

awk 'BEGIN {awk-commands} /pattern/ {awk-commands} END {awk-commands}'
awk_row_column(){
    awk 的设计深受 Unix 系统中的文本检索工具 grep 与文本编辑工具 sed 的启发，其语法借鉴了 C 语言。
awk 要比grep和awk强大，使得简单的grep和sed命令使用较复杂的awk命令实现。
    认识了awk, 发现awk功能上可以替代grep,sed. 当然，相同的功能需要多写一点点代码。
    awk 可以取代cat                      # awk 1
                                        # awk '"a"'
    awk 支持正则表达式，所以可以取代grep # awk '{if ($0 ~ /pattern/) print $0}' # 只有动作没有模式。没模式时，动作应用于所有行
                                        # awk '$0 ~ /pattern/ {print $0}'      # 有模式有动作。$0 表示当前行数据
                                        # awk '/pattern/ {print $0}'           # 有模式有动作。不指定记录时，模式匹配当前行
                                        # awk '/pattern/ {print}'              # 有模式有动作。函数不指定记录时，默认参数为当前行
                                        # awk '/pattern/'                      # 有模式无动作。没动作时，动作就是输出当前行。
    awk 内嵌sub,gsub函数，所以可以取代sed # awk '{sub(/pattern/,"foobar")}1' - sed 's/pattern/foobar/'   # sub对应s/pattern/replace/
                                        # awk '{gsub(/pattern/,"foobar")}1' - sed 's/pattern/foobar/g' # gsub对应s/pattern/replace/g
    grep /regular/  支持--color, -w, -v 等选项
    awk '/regular/{print}', match(s,r,[,a]) 与之抗衡。
    
    sed 's///' 一招定天下
    awk  sub(r,s,[,t]) gsub(r,s,[,t]) gensub(r,s,h,[,t]) 灵活替换。
    
  在指名的一组文件上，或标准输入上、如果没有指定文件的话，执行字符串 program 中的 awk 命令。
  pattern { action statement; action statement; etc. } or
  pattern {
      action statement
      action statement
}
}

awk_syntax(){
模式与动作: 模式或动作二者都可以但不能同时省略。
    如果一个模式没有动作，简单的把匹配的行复制到输出。(所以匹配多个模式的行可能被打印多次)。
    如果一个动作没有模式，则这个动作在所有输入上进行。不匹配模式的行被忽略。
    因为模式和动作都是可选的，动作必须被包围在花括号中来区别于模式。
    1) awk 'pattern' filename           如awk '/Mary/' employees
    2) awk '{action}' filename          如awk '{print $1}' employees
    3) awk 'pattern {action}' filename  如awk '/Mary/ {print $1}' employees
        # 默认是执行打印全部 print $0
        # 1为真 打印$0
        # 0为假 不打印
    @操作符@
   Syntax                Name                      Type of Result   Associativity
   ( expr )              Grouping                  Type of expr     N/A
   $expr                 Field reference           String           N/A
   ++ lvalue             Pre-increment             Numeric          N/A
   -- lvalue             Pre-decrement             Numeric          N/A
   lvalue ++             Post-increment            Numeric          N/A
   lvalue --             Post-decrement            Numeric          N/A
   expr ^ expr           Exponentiation            Numeric          Right       pow(expr1, expr2)
   ! expr                Logical not               Numeric          N/A
   + expr                Unary plus                Numeric          N/A
   - expr                Unary minus               Numeric          N/A
   expr * expr           Multiplication            Numeric          Left
   expr / expr           Division                  Numeric          Left
   expr % expr           Modulus                   Numeric          Left        fmod(expr1, expr2)
   expr + expr           Addition                  Numeric          Left
   expr - expr           Subtraction               Numeric          Left
   expr expr             String concatenation      String           Left
   expr < expr           Less than                 Numeric          None
   expr <= expr          Less than or equal to     Numeric          None
   expr != expr          Not equal to              Numeric          None
   expr == expr          Equal to                  Numeric          None
   expr > expr           Greater than              Numeric          None
   expr >= expr          Greater than or equal to  Numeric          None
   expr ~ expr           ERE match                 Numeric          None
   expr !~ expr          ERE non-match             Numeric          None
   expr in array         Array membership          Numeric          Left
   ( index ) in array    Multi-dimension array     Numeric          Left
                         membership
   expr && expr          Logical AND               Numeric          Left
   expr || expr          Logical OR                Numeric          Left
   expr1 ? expr2 : expr3 Conditional expression    Type of selected Right
                                                   expr2 or expr3
   lvalue ^= expr        Exponentiation assignment Numeric          Right       lvalue = pow(lvalue, expr)
   lvalue %= expr        Modulus assignment        Numeric          Right       lvalue = fmod(lvalue, expr)
   lvalue *= expr        Multiplication assignment Numeric          Right
   lvalue /= expr        Division assignment       Numeric          Right
   lvalue += expr        Addition assignment       Numeric          Right
   lvalue -= expr        Subtraction assignment    Numeric          Right
   lvalue = expr         Assignment                Type of expr     Right       lvalue = expression 表达式决定了变量类型
    @ 格式化说明符 @ 参见printf命令
       %c:    单个ASCII字符.
       %d:    十进制数字.
       %e:    科学记数法表示的数字.
       %f:    浮点数.
       %o:    八进制数字.
       %s:    打印字符串.
       %x:    十六进制数字.
       -:    表示左对齐,如%-15d, 在十进制数字的后面会有一些空格,同时该数字是左对齐的. %+15d或%15d表示右对齐,当数字不足15位的时候.
       #:    如%#o或%#x, 会在八进制的数字前面加入0,十六进制前加0x.
    @ 转义码 @
        \b   # 退格
        \f   # 换页
        \n   # 换行
        \r   # 回车
        \t   # 制表符Tab
        \c   # 代表任一其他字符
    @ 模式匹配 @ 
        -F"[ ]+|[%]+"  # 多个空格或多个%为分隔符
        [a-z]+         # 多个小写字母
        [a-Z]          # 代表所有大小写字母(aAbB...zZ)
        [a-z]          # 代表所有大小写字母(ab...z)
        [:alnum:]      # 字母数字字符
        [:alpha:]      # 字母字符
        [:cntrl:]      # 控制字符
        [:digit:]      # 数字字符
        [:graph:]      # 非空白字符(非空格、控制字符等)
        [:lower:]      # 小写字母
        [:print:]      # 与[:graph:]相似，但是包含空格字符
        [:punct:]      # 标点字符
        [:space:]      # 所有的空白字符(换行符、空格、制表符)
        [:upper:]      # 大写字母
        [:xdigit:]     # 十六进制的数字(0-9a-fA-F)
        [[:digit:][:lower:]]    # 数字和小写字母(占一个字符)
}

awk_command(){
-F fs or --field-separator fs
    指定输入文件折分隔符，fs是一个字符串或者是一个正则表达式，如-F:
-f scripfile or --file scriptfile
    从脚本文件中读取awk命令。
-v var=value or --asign var=value
    赋值一个用户定义变量。
}

awk_out_variable(){
1. awk的程序与shell的交互
awk提供了与shell命令交互的能力，从而可以使得用户在awk程序中使用系统资源。awk主要通过2种机制来实现这种交互功能，分别为管道和sytem函数。
1.1 通过管道实现与shell的交换
    用户可以很容易地在awk程序中使用操作系统资源，包括在程序中调用Shell命令处理程序中的数据；
或者在awk程序中获取Shell命令的执行结果。awk提供了管道来实现这种数据的双向交互。awk的管道
与UNIX或者Linux中的管道非常相似，但是特性有些不同。
#! /bin/awk -f
BEGIN {
    while("who" | getline) n++
    printf("There %d online users.\n",n)
}

1.2 通过system函数实现与shell的交互
awk提供另一个调用shell命令的方法, 即使用awk函数，其语法如下：
system(command)
    其中参数command表示要执行的Shell命令。与管道相比，system函数有许多据局限，例如不能在awk程序中直接获取Shell命令的执行结果，
另外，也不能直接将awk程序中的数据传递给Shell命令来处理。要实现这种数据传递，必须借助其他的的一些手段。
#! /bin/awk -f
BEGIN {
    system("ls > filelist")
    
    while(getline < "filelist" > 0)
    {
        print $1
    }
}
}

awk_in_variable(){
            $n                 # 当前记录的第 n 个字段，字段间由 FS 分隔(不包括分隔符) # Field
                {print $3, $2} # 打印一个表格的第三和第二列。
                $2 ~ /A|B|C/   # 打印在第二列是 A、B 或 C 的所有输入行
                $1 != prev { print; prev = $1 } # 打印第一个字段不同于前面的第一个字段的所有的行。
            $0                 # 完整的输入记录 (包括换行符)                 # Field
            echo 'foo:123:bar:789' | awk -F: -v OFS='-' '{print $0}'         # foo:123:bar:789
            echo 'foo:123:bar:789' | awk -F: -v OFS='-' '{$1=$1; print $0}'  # foo-123-bar-789
            echo 'foo:123:bar:789' | awk -F: -v OFS='\t' '{print $1, $3}'    # foo     bar
            分隔符可以为数字
            echo 'Sample123string54with908numbers' | awk -F'[0-9]+' '{$1=$1; print $0}' # Sample string with numbers
# 每个输入记录被当作分解成了'字段'。字段通常用空白也就是空格或 tab 来分隔，字段被引用为 $1、$2.
# $1 是第一个字段，而 $0 是整个输入记录自身。字段可以被赋值。
# 在当前记录中字段的数目可以在命名为 NF 的变量中得到。
# 在BEGIN模式中，NF未定义，除非调用个getline函数且未指定var值。在END模式中，为最后一行中字段个数。
            NF            # 总共字段个数                             # Field
                用于判断
                awk '{ total = total + NF } END { print total }' # 包含单词个数
                awk 'NF >= 6'
                awk 'NF'    # 打印非空行
                awk 'NF--'  # 不打印最后一行
                echo -e "One Two\nOne Two Three\nOne Two Three Four" | awk 'NF > 2'  # One Two Three
                                                                                     # One Two Three Four
                echo 'foo:123:bar:789' | awk -F: '{print $NF}'       # 789
                echo 'foo:123:bar:789' | awk -F: '{print $1, $NF}'   # foo 789
                echo 'foo:123:bar:789' | awk -F: '{print $(NF-1)}'   # bar
                用于输出
                awk '{print $0,NF}' employees # 变量NF(Number of Field)，记录当前记录有多少域,
                echo '{foo}   bar=baz' | awk -F'[{}= ]+' -v OFS=" " '{$1=$1; print $0}' # 空白 foo bar baz
                echo '{foo}   bar=baz' | awk -F'[{}= ]+' '{print $1}' # 空白
                echo '{foo}   bar=baz' | awk -F'[{}= ]+' '{print $2}' # foo
                echo '{foo}   bar=baz' | awk -F'[{}= ]+' '{print $3}' # bar
                echo '{foo}   bar=baz' | awk -F'[{}= ]+' '{print $4}' # baz
                FS为空时，NF为字符串结尾
                3. note the use of command line option -v to set FS
                echo 'apple' | awk -v FS= '{print $1}'  # a
                echo 'apple' | awk -v FS= '{print $2}'  # p
                echo 'apple' | awk -v FS= '{print $NF}' # e
# 变量 FS 和 RS 分别指定输入字段和记录分隔符；
# 它们可以在任何时候被改变为任何的单一字符。 例如: 可以使用可选的命令行参数 −Fc 来设置 FS 为字符 c。
# 如果记录分隔符为空，把空输入行作为记录分隔符，并把空格、tab 和换行作为字段分隔符处理。
            FS            # 字段分隔符 ( 默认是任何空格 )  # separator 支持模式匹配
                awk 'BEGIN {print "FS = " FS}' | cat -vte       # FS = $   默认FS数值集合
                awk -F , 'BEGIN {print "FS = " FS}' | cat -vte  # FS = ,$  设置后FS数值集合
                echo 'Sample123string54with908numbers' | awk -F'[0-9]+' '{print $2}' # string
                # first field will be empty as there is nothing before '{'
                echo '{foo}   bar=baz' | awk -F'[{}= ]+' '{print $1}' # 
                echo '{foo}   bar=baz' | awk -F'[{}= ]+' '{print $2}' # foo
                echo '{foo}   bar=baz' | awk -F'[{}= ]+' '{print $3}' # bar
                # for anything else, leading/trailing whitespaces will be considered
                printf ' a    ate b\tc   \n' | awk -F'[ \t]+' '{print $2}'  # a
                printf ' a    ate b\tc   \n' | awk -F'[ \t]+' '{print NF}'  # 6
                echo 'apple' | awk -v FS= '{print $1}'  # a
                echo 'apple' | awk -v FS= '{print $2}'  # p
                echo 'apple' | awk -v FS= '{print $NF}' # e
            -F            # 字段分隔符 ( 默认是任何空格 )            # separator  支持模式匹配
                awk -F: '/Tom Jones/{print $1,$2}' employees2
            ARGC          # ARGV数组的数目
                awk 'BEGIN {print "Arguments =", ARGC}' One Two Three Four # Arguments = 5
            ARGIND        # 命令行中当前文件的位置(从0开始算)。
            awk '{ print "ARGIND = ", ARGIND; print "Filename = ", ARGV[ARGIND] }' junk1 junk2 junk3
                # ARGIND   =  1
                # Filename =  junk1
                # ARGIND   =  2
                # Filename =  junk2
                # ARGIND   =  3
                # Filename =  junk3
            ARGV          # 包含命令行参数的数组，不包括选项和program参数
              ARGV可以被修改和追加。ARGC可以被修改。ARGV是一个null结尾的数组，ARGC-1标识ARGV数组最后一个元素。
              isdigit=$(awk 'BEGIN { if (match(ARGV[1],"^[0-9]+$") != 0) print "true"; else print "false" }' $1)
              awk 'BEGIN { for (i = 0; i < ARGC - 1; ++i) { printf "ARGV[%d] = %s\n", i, ARGV[i] } }' one two three four
              # ARGV[0] = awk 
              # ARGV[1] = one
              # ARGV[2] = two 
              # ARGV[3] = three
            CONVFMT       # 数字转换格式 ( 默认值为 %.6g)
                awk 'BEGIN { print "Conversion Format =", CONVFMT }' # Conversion Format = %.6g
            ENVIRON       # 环境变量关联数组
                awk 'BEGIN { print ENVIRON["USER"] }' # root
            ERRORNO # 一个代表了getline跳转失败或者是close调用失败的错误的字符串。
                awk 'BEGIN { ret = getline < "junk.txt"; if (ret == -1) print "Error:", ERRNO }'
            ERRNO         # 最后一个系统错误的描述
            FIELDWIDTHS   # 字段宽度列表 ( 用空格键分隔 )
            FILENAME      # 当前输入文件的名字， 在BEGIN模式中没有定义，在END模式中为最后一个文件。
                awk 'END {print FILENAME}' marks.txt # marks.txt
            FNR           # 同 NR, 在当前文件累计处理行数，在BEGIN模式中为0，在END模式中为累计处理行数。
                awk 'NR==FNR { # some actions; next} # other condition {# other actions}' file1 file2
                # NR多个文件叠加的行数，FNR当前文件累加的行数。
                awk 'NR==FNR{a[$0];next} $0 in a' file1 file2 # 打印既在file1又在file2的行
                awk 'NR==FNR{a[$1]=$2;next} {$3=a[$3]}1' mapfile datafile # 
                awk 'NR==FNR{if($0>max) max=$0;next} {$0=max-$0}1' file file # 
            IGNORECASE    # 如果为真(即非 0 值)，则进行忽略大小写的匹配
                awk 'BEGIN{IGNORECASE = 1} /amit/' marks.txt 
                awk -v IGNORECASE=1 '/rose/' poem.txt
                awk '/[rR]ose/' poem.txt
                awk 'tolower($0) ~ /rose/' poem.txt
# 输入被分解成了终止于记录分隔符的"记录"。缺省的记录分隔符是换行，所以缺省的 awk 一次处理它的输入中的一行。
# 当前记录的数可在命名为 NR 的变量中得到。
            NR            # 在所有文件累计处理行数；在BEGIN模式中为0，在END模式中为累计处理行数。
                awk '{print NR, $0}' employees # 变量NR(Number of Record)，记录每条记录的编号
                awk 'NR % 6' # 打印所有NR%6倍数的行
                awk 'NR > 5' # tail -n +6
                awk '$0 = NR" "$0' # 打印行号及对应内容   $0 = NR" "$0 表示连接之后的赋值操作
                awk '{ printf("%02d %s\n", NR, $0) }' regular.txt
                echo -e "One Two\nOne Two Three\nOne Two Three Four" | awk 'NR < 3'
                awk 'NR==2' poem.txt
                awk 'NR==2 || NR==4' poem.txt
                awk 'END{print}' poem.txt # 最后一行
                awk 'NR==4{print $2}' fruits.txt
            OFMT          # 数字的输出格式 ( 默认值是 %.6g) printf 和 sprintf
                awk 'BEGIN {print "OFMT = " OFMT}' # OFMT = %.6g
            OFS           # 输出字段分隔符 ( 默认值是一个空格 )
                awk -F: '{OFS = "?"};  /Tom/{print $1,$2 }' employees2
                # $1=$1 is an idiomatic way to re-build when there is nothing else to change
                awk 'BEGIN {print "OFS = " OFS}' | cat -vte # OFS =  $
                echo 'foo:123:bar:789' | awk 'BEGIN{FS=OFS=":"} {print $1, $NF}'  # foo:789
                echo 'foo:123:bar:789' | awk -F: -v OFS=':' '{print $1, $NF}'     # foo:789
                echo 'foo:123:bar:789' | awk -F: -v OFS='-' '{print $0}'          # foo:123:bar:789
                echo 'foo:123:bar:789' | awk -F: -v OFS='-' '{$1=$1; print $0}'   # foo-123-bar-789
                echo 'foo:123:bar:789' | awk -F: -v OFS='\t' '{print $1, $3}'               # foo    bar
                echo 'Sample123string54with908numbers' | awk -F'[0-9]+' '{$1=$1; print $0}' # Sample string with numbers
            ORS           # 输出记录分隔符 ( 默认值是一个换行符 )
                awk 'BEGIN {print "ORS = " ORS}' | cat -vte # ORS = $
                seq 3 | awk -v ORS='\n\n' '{print $0}'
                seq 6 | awk '{ORS = NR%2 ? " " : "\n"} 1'
                seq 6 | awk '{ORS = NR%3 ? "-" : "\n"} 1'
            RLENGTH       # 代表了 match 函数匹配的字符串长度。
                awk 'BEGIN { if (match("One Two Three", "re")) { print RLENGTH } }'
            RS            # 记录分隔符 ( 默认是一个换行符 )
                LC_ALL=C gawk -v RS='FOO[0-9]*\n' -v ORS= '{print > "out"NR}' file
                awk 'BEGIN {print "RS = " RS}' | cat -vte # RS = $
                s='this is a sample string'
                printf "$s" | awk -v RS=' ' '{print NR, $0}' 
                printf "$s" | awk -v RS=' ' '/a/'
            RSTART        # match函数匹配的第一次出现位置
                awk 'BEGIN { if (match("One Two Three", "Thre")) { print RSTART } }'
            SUBSEP        # 数组子脚本的分隔符，默认为**\034**
                awk 'BEGIN { print "SUBSEP = " SUBSEP }' | cat -vte
        }
        awk '/Mary/' employees      #打印所有包含模板Mary的行。                                             行
        awk '{print $1}' employees  #打印文件中的第一个字段，这个域在每一行的开始，缺省由空格或其它分隔符。 列

awk_printf_print_sprintf(){
1. print [ ExpressionList ] [ Redirection ] [ Expression ]
    print 语句将 ExpressionList 参数指定的每个表达式的值写至标准输出。每个表达式由 OFS 特殊变量的当前值隔开，
且每个记录由 ORS 特殊变量的当前值终止。
    可以使用 Redirection 参数重定向输出，此参数可指定用 >、>>和 | 进行的三种输出重定向。Redirection 参数指定如何重定向输出，
而 Expression 参数是文件的路径名称。(当 Redirection 参数是 > 或 >> 时)或命令的名称(当 Redirection 参数是 | 时)。

在 print 语句中用逗号分隔的项，在输出的时候会用当前输出字段分隔符分隔开。没有用逗号分隔的项会串联起来，# 逗号起视作字段分隔符
print $2, $1
print $2  $1
可以使用变量 OFS 和 ORS 来改变当前输出字段分隔符和输出记录分隔符。
       转码    含义
        \n     换行
        \r     回车
        \t     制表符
        date | awk '{print "Month: " $2 "\nYear: ", $6}'
        awk '/Sally/{print "\t\tHave a nice day, " $1,$2 "!"}' employees
        awk 'BEGIN { OFMT="%.2f"; print 1.2456789, 12E-2}'
        
        awk { print $1 >"foo1"; print $2 >"foo2" } # 输出可以被转向到多个文件中
        print $1 >>"foo"                           # 添加输出到文件 foo
        print $1 >$2  # 文件名可以是一个变量或字段，同常量一样；
        print | "mail bwk" # 输出可以用管道导入到(只在 UNIX 上的)其他进程；
  
print 和 printf 之间差异，
1. OFS和ORS在print中有效，在printf中无效。即 print $0会自动追加换行; print $1,$2在 $1,$2之间会嵌入空格
2. , 在print中具有ORS分隔功能，无 , 表示字符串之间连接。 , 在printf按照原样输出。
3. printf("%s\n\n", $0) 格式类似函数， print $0 格式类似命令
  printf Format [ , ExpressionList ] [ Redirection ] [ Expression ]
2. printf : # 除了 c 转换规范（%c）不同外，printf 语句和 printf 命令起完全相同的作用。
对于 c 转换规范：如果自变量具有一个数字值，则编码是该值的字符将输出。
                 如果值是零或不是字符集中的任何字符的编码，则行为未定义。
                 如果自变量不具有数字值，则输出字符串值的第一个字符；
                 如果字符串不包含任何字符，则行为未定义。
格式化说明符 功能                   示例                                            结果
%c           打印单个ASCII字符。    printf("The character is %c.\n",x)              The character is A.
%d           打印十进制数。         printf("The boy is %d years old.\n",y)          The boy is 15 years old.
%e           打印用科学记数法表示的数printf("z is %e.\n",z)                         z is 2.3e+01.
%f           打印浮点数。           printf("z is %f.\n",z)                          z is 2.300000
%o           打印八进制数。         printf("y is %o.\n",y)                          y is 17.
%s           打印字符串。           printf("The name of the culprit is %s.\n",$1);  The name of the culprit is Bob Smith.
%x           打印十六进制数。       printf("y is %x.\n",y)                          y is f.
       echo "Linux" | awk '{printf "|%-15s|\n", $1}'  # %-15s表示保留15个字符的空间，同时左对齐
       echo "Linux" | awk '{printf "|%15s|\n", $1}'   # %-15s表示保留15个字符的空间，同时右对齐
       awk '{printf "The name is %-15s ID is %8d\n", $1,$3}' employees #%8d表示数字右对齐，保留8个字符的空间 
       printf "%8.2f %10ld\n", $1, $2 # 打印 $1 为 8 位宽的小数点后有两位的浮点数，打印 $2 为 10 位长的长十进制数，并跟随着一个换行。
       
       函数 sprintf(f, e1, e2, ...) 在 f 指定的 printf 格式中生成表达式 e1、e2 等的值。所以例子
    x = sprintf("%8.2f %10ld", $1, $2) # 设置 x 为格式化 $1 和 $2 的值所生成的字符串。
       }
       
awk_pattern(){
    在动作之前的模式充当决定一个动作是否执行的选择者。有多种多样的表达式可以被用做模式: 
正则表达式，算术关系表达式，字符串值的表达式，和它们的任意的布尔组合
    特殊模式 BEGIN 匹配输入的开始，在第一个记录被读取之前。
    模式 END 匹配输入的结束，在最后一个记录已经被处理之后。
    BEGIN 和 END 从而提供了在处理之前和之后获得控制的方式，用来做初始化和总结。
    如果 BEGIN 出现，它必须是第一模式；END 必须是最后一个模式，如果用到了的话。
    
    模式摘要
1. BEGIN { 语句 }
在读取任何输入前执行一次 语句
2. END { 语句 }
读取所有输入之后执行一次 语句
3. 表达式 { 语句 }
对于 表达式 为真(即，非零或非空)的行，执行 语句
4. /正则表达式/ { 语句 }
如果输入行包含字符串与 正则表达式 相匹配，则执行 语句
5. 组合模式 { 语句 }
一个 组合模式 通过与(&&)，或(||)，非(!)，以及括弧来组合多个表达式；对于组合模式为真的每个输入行，执行 语句
6. 模式1，模式2 { 语句 }
范围模式(range pattern)匹配从与 模式1 相匹配的行到与 模式2 相匹配的行(包含该行)之间的所有行，对于这些输入行，执行 语句 。

BEGIN和END不与其他模式组合。范围模式不可以是任何其他模式的一部分。BEGIN和END是仅有的必须搭配动作的模式。

    awk '/are/' poem.txt
    awk '!/are/' poem.txt
    awk '/are/ && !/so/' poem.txt
    awk '/^[ab]/' fruits.txt
    awk '/are/{print $NF}' poem.txt
    awk '$0 !~ "are"' poem.txt
    awk '$0 ~ "^[ab]"' fruits.txt
    
    awk '$1 ~ /a/' fruits.txt
    awk '$1 ~ /a/ && $2 > 20' fruits.txt
    awk '$1 !~ /a/' fruits.txt
     }
       
awk_test(){ 
模式可以是涉及常用的关系算符 <、<=、==、!=、>=、> 的关系表达式
运算符  含义        例子
<       小于         x < y
<=      小于等于    x <= y
==      等于        x == y
!=      不等于      x != y
>=      大于等于    x >= y
>       大于        x > y
~       匹配        x ~ /y/
!~      不匹配      x !~ /y/
awk '$3 == 5346' employees       #打印第三个域等于5346的行。
awk '$3 > 5000 {print $1}' employees  #打印第三个域大于5000的行的第一个域字段。
awk '$2 ~ /Adam/' employess      #打印第二个域匹配Adam的行。
# 关系操作符
awk 'BEGIN { a = 10; b = 10; if (a == b) print "a == b" }' # a == b
awk 'BEGIN { a = 10; b = 20; if (a != b) print "a != b" }' # a != b
awk 'BEGIN { a = 10; b = 20; if (a < b) print "a  < b" }' # a  < b
awk 'BEGIN { a = 10; b = 10; if (a <= b) print "a <= b" }' # a <= b
awk 'BEGIN { a = 10; b = 20; if (b > a ) print "b > a" }' # b > a
# 三元操作符
awk 'BEGIN { a = 10; b = 20; (a > b) ? max = a : max = b; print "Max =", max}'

如果操作数(operand)都不是数值，则做字符串比较；否则做数值比较。
$1 >= "s" # 选择开始于 s、t、u 等字符的行。

在缺乏任何其他信息的情况下，字段被当作字符串
$1 > $2 # 将进行字符串比较。
       }
       
awk_operator(){
       条件表达式使用两个符号--问号和冒号给表达式赋值： conditional expression1 ? expression2 : expressional3
       awk 'NR <= 3 {print ($7 > 4 ? "high "$7 : "low "$7) }' testfile
       
conditional expression1 expression2: expression3，
例如：$ awk '{max = {$1 > $3} $1: $3: print max}' test。如果第一个域大于第三个域，$1就赋值给max，否则$3就赋值给max。
$ awk '$1 + $2 < 100' test。如果第一和第二个域相加大于100，则打印这些行。
$ awk '$1 > 5 && $2 < 10' test,如果第一个域大于5，并且第二个域小于10，则打印这些行。
       
       }
       
awk_math(){
运算符  含义     例子
+       加       x + y
-       减       x - y
*       乘       x * y
/       除       x / y
%       取余     x % y
^       乘方     x ^ y
    awk '/southern/{print $5 + 10}' testfile  #如果记录包含正则表达式southern，第五个域就加10并打印。
    awk '/southern/{print $8 /2 }' testfile   #如果记录包含正则表达式southern，第八个域除以2并打印。
    1. 算术操作符
    awk 'BEGIN { a = 50; b = 20; print "(a + b) = ", (a + b) }' # (a + b) =  70
    awk 'BEGIN { a = 50; b = 20; print "(a - b) = ", (a - b) }' # (a - b) =  30
    awk 'BEGIN { a = 50; b = 20; print "(a * b) = ", (a * b) }' # (a * b) =  1000
    awk 'BEGIN { a = 50; b = 20; print "(a / b) = ", (a / b) }' # (a / b) =  2.5
    awk 'BEGIN { a = 50; b = 20; print "(a % b) = ", (a % b) }' # (a % b) =  10
    2. 自增自减与C语言一致。
    awk 'BEGIN { a = 10; b = ++a; printf "a = %d, b = %d\n", a, b }' # a = 11, b = 11
    awk 'BEGIN { a = 10; b = --a; printf "a = %d, b = %d\n", a, b }' # a = 9, b = 9
    awk 'BEGIN { a = 10; b = a++; printf "a = %d, b = %d\n", a, b }' # a = 11, b = 10
    awk 'BEGIN { a = 10; b = a--; printf "a = %d, b = %d\n", a, b }' # a = 9, b = 10
    3.  赋值操作符
    awk 'BEGIN { name = "Jerry"; print "My name is", name }' # My name is Jerry
    awk 'BEGIN { cnt = 10; cnt += 10; print "Counter =", cnt }' # Counter = 20
    awk 'BEGIN { cnt = 100; cnt -= 10; print "Counter =", cnt }' # Counter = 90
    awk 'BEGIN { cnt = 10; cnt *= 10; print "Counter =", cnt }' # Counter = 100
    awk 'BEGIN { cnt = 100; cnt /= 5; print "Counter =", cnt }' # Counter = 20
    awk 'BEGIN { cnt = 100; cnt %= 8; print "Counter =", cnt }' # Counter = 4
    awk 'BEGIN { cnt = 2; cnt ^= 4; print "Counter =", cnt }' # Counter = 16
    awk 'BEGIN { cnt = 2; cnt **= 4; print "Counter =", cnt }' # Counter = 16
    4. 一元操作符
    awk 'BEGIN { a = -10; a = +a; print "a =", a }' # a = -10
    awk 'BEGIN { a = -10; a = -a; print "a =", a }' # a = 10
    5. 指数操作符
    awk 'BEGIN { a = 10; a = a ^ 2; print "a =", a }' # a = 100
    awk 'BEGIN { a = 10; a ^= 2; print "a =", a }'    # a = 100
       }
       
awk_and_or(){ 
模式可以是模式的使用算符 ||(或)、&&(与)和 !(非)的任意布尔组合。
运算符  含义    例子
&&      逻辑与  a && b
||      逻辑或  a || b
!       逻辑非  !a
    && 和 || 保证它们的操作数会被从左至右的求值；在确定了真或假之后求值立即停止。
    awk '$8 > 10 && $8 < 17' testfile   #打印出第八个域的值大于10小于17的记录。
    awk '$2 == "NW" || $1 ~ /south/ {print $1,$2}' testfile
    awk '!($8 > 13) {print $8}' testfile  #打印第八个域字段不大于13的行的第八个域。
    awk '/foo/ && /bar/'
    awk '/foo/ && !/bar/'
    awk '/foo/ || /bar/'
       }
       
awk_scope(){  
选择一个动作的"模式"还可以由用逗号分隔的两个模式组成
    pat1,{ ... } pat2
    在这种情况下，这个动作在 pat1 的一个出现和 pat2 的下一个出现之间(包含它们)的每个行上进行。
       awk '/^western/,/^eastern/ {print $1}' testfile #打印以western开头到eastern开头的记录的第一个域。
       echo -e "foo \n bar" | awk '/foo/,/bar/' # foo bar
       awk '/beginpat/,/endpat/{if (!/beginpat/&&!/endpat/)print}' # prints lines from /beginpat/ to /endpat/, not inclusive
       awk '/beginpat/,/endpat/{if (!/beginpat/)print}'            # prints lines from /beginpat/ to /endpat/, not including /beginpat/
       awk '/endpat/{p=0};p;/beginpat/{p=1}'  # prints lines from /beginpat/ to /endpat/, not inclusive
       awk '/endpat/{p=0} /beginpat/{p=1} p'  # prints lines from /beginpat/ to /endpat/, excluding /endpat/
       awk 'p; /endpat/{p=0} /beginpat/{p=1}' # prints lines from /beginpat/ to /endpat/, excluding /beginpat/
}

awk_assign(){
    awk 变量依据上下文而被接纳为数值(浮点数)或字符串值。
    x = 1 # x 明显的是个数
    x = "smith" # 明显的是个字符串
    在上下文需要的时候，把字符串转换为数或反之。例如
    x = "3" + "4" # 把 7 赋值给 x。
    缺省的，(不是内置的)变量被初始化为空字符串，它有为零的数值；这消除了大多数对 BEGIN 段落的需要。
    awk '$3 == "Ann" { $3 = "Christian"; print}' testfile
    awk '/Ann/{$8 += 12; print $8}' testfile #找到包含Ann的记录，并将该条记录的第八个域的值+=12，最后再打印输出。
}
    
awk_variable(){
    在awk中变量无须定义即可使用，变量在赋值时即已经完成了定义。变量的类型可以是数字、字符串。
根据使用的不同，未初始化变量的值为0或空白字符串" "，这主要取决于变量应用的上下文。下面为变量的赋值负号列表：
符号    含义       等价形式
=       a = 5      a = 5
+=      a = a + 5  a += 5
-=      a = a - 5  a -= 5
*=      a = a * 5  a *= 5
/=      a = a / 5  a /= 5
%=      a = a % 5  a %= 5
^=      a = a ^ 5  a ^= 5
awk '$1 ~ /Tom/ {Wage = $2 * $3; print Wage}' filename
awk ' {$5 = 1000 * $3 / $2; print}' filename
awk -F: -f awkscript month=4 year=2011 filename

一个字段被认为是数值还是字符串依赖于上下文；
awk 中的字段在本质上享有变量的所有性质 — 他们可以用在算术或字符串运算/操作中，并可以被赋值
{ $1 = NR; print } # 把第一个字段替代为一个序号
{ $1 = $2 + $3; print $0 } # 累计前两个字段到第三个字段中
{ if ($3 > 1000)
$3 = "too big"
print
} # 把一个字符串赋值到一个字段:

1. 字符串可以被串接
length($1 $2 $3) # 返回前三个字段的长度
print $1 " is " $2 # 打印用" is "分隔的两个字段。变量和数值表达式也可以在连接中出现。
       }
       
awk_class_demo(){
            1) BEGIN: 其后紧跟着动作块, 该块将会在任何输入文件被读入之前执行, 如一些初始化工作, 或者打印一些输出标题.
       awk 'BEGIN{FS=":"; OFS="\t";ORS="\n\n"} {print $1,$2,$3}' file
       awk 'BEGIN { while (a++<513) s=s "x"; print s }' # 打印513个x字符
       即使输入文件不存在, BEGIN块动作仍然会被执行.
            2) END: 其后也紧随动作块, 该动作模块将在整个输入文件处理完毕之后被处理, 但是END需要有文件名的输入.
       awk 'END {print "The end\n"}' filename.
            3) 输入输出重新定向:
       awk 'BEGIN {print "Hello" > "newfile"}'  # datafile 文件名一定要用双引号扩起来, > 如果文件存在,则清空后重写新文件.
       awk 'BEGIN {print "Hello" >> "newfile"}' # datafile 文件名一定要用双引号扩起来, > 如果文件存在, 则在文件末尾追加写入.
       awk 'BEGIN {getline name < "/dev/tty"; print name}' getline是awk的内置函数, 就像c语言的gets, 将输入赋值给name变量.
            4) system函数可以执行shell中的命令,这些命令必须用双引号扩起.
       awk 'END { system("clear"); system ("cat " FILENAME)}' filename
            5) 条件语句:
       if (expr) { stat; } else { stat; }
       if (expr) { stat; } else if { stat; } else { stat; }
       awk '{ if ($7 <= 2) { print "less than 2", $7 } else if ($7 <= 4) { print "less than 4", $7 } else { print "the others", $7 } }' datafile
            6) 循环语句:
       while (expr) { stat; }
       for (i = 1; i <= NF; i++) { stat; }
       break;
       continue;
       exit(exitcode);    awk 将退出. 退出后的$?将会是这里的exitcode.
       next; 读取下一条记录. awk '{ if ($7 == 3) { next } else { print $0 }}' datafile 将不会输出$7等于3的记录.
            7) 数组:
       awk的数组和pl/sql中数组有些类似, 都是通过哈希表来实现的,其下标可以是数字, 也可以是字符串.
       awk '{name[x++]=$3};END{for(i = 0; i < NR; i++) { print i, name[i]}}' employees
       awk '{id[NR]=$3};END{for (x = 1; x <= NR; x++) { print id[x]} }' employees
       awk '/^Tom/{name[NR]=$1}; END{for (i in name) { print name[i]}}' employees # 特殊的for语句
       awk '/Tom/{count["tom"]++}; /Mary/{count["mary"]++}; END{print "count[tom] = ",count["tom"]; print "count[mary] = ", count["mary"]}' employees
       awk '{count[$2]++};END{for (name in count) {print name,count[name]}}' datafile 域变量也可以作为数组的下标.
            8) 匹配操作符: " ~ " 用来在记录或者域内匹配正则表达式
       awk '$1 ~ /[Bb]ill/' employees      #显示所有第一个域匹配Bill或bill的行。
       awk '$1 !~ /[Bb]ill/' employees     #显示所有第一个域不匹配Bill或bill的行，其中!~表示不匹配的意思。
        }
        
        r: regex ; s,t: strings ; n,p: integers
        
awk_in_func(){
        字符串连接操作符
        awk 'BEGIN { str1 = "Hello, "; str2 = "World"; str3 = str1 str2; print str3 }' # Hello, World
            1) sub/gsub(regexp, substitution string, [target string]); gsub和sub的差别是sub只是替换每条记录中第一个匹配正则的, gsub则替换该记录中所有匹配
       正则的, 就是vi中s/src/dest/ 和s/src/dest/g的区别, 如果[target string]没有输入, 其缺省值是$0.
            gsub(r,s)  gsub(r,s,t)
            sub(r,s)   sub(r,s,t)
       awk '{sub(/Tom/,"Thomas"); print}' employees    # 在整个记录中匹配，替换只发生在第一次匹配发生的时候。如要在整个文件中进行匹配需要用到gsub
       awk '{sub(/Tom/,"Thomas",$1); print}' employees # 在整个记录的第一个域中进行匹配，替换只发生在第一次匹配发生的时候。
       awk 'BEGIN{info="this is a test in 2013-01-04"; sub(/[0-9]+/, "!", info); print info}'  # this is a test in !-01-04
       
       awk '{gsub(/Tom/,"Thomas"); print}' employees    # 在整个文档中匹配test，匹配的都被替换成mytest。
       awk '{gsub(/Tom/,"Thomas",$1); print}' employees # 在整个文档的第一个域中匹配，所有匹配的都被替换成mytest。
       awk 'BEGIN{info="this is a test in 2013-01-04"; gsub(/[0-9]+/, "!", info); print info}'  # this is a test in !-!-!
            2) index(string ,substring) 返回子字符串第一次被匹配的位置(1开始)没有定位返回0
            index(s,t)
            index(s1, s2) 返回字符串 s2 在 s1 出现的位置，如果未出现则为零。
       awk '{ print index("test", "mytest") }' testfile # 结果应该是3
       awk 'BEGIN{print index("hollow", "low") }'       # 结果应该是4
       awk 'BEGIN{info="this is a test in 2013-01-04"; print index(info, "test") ? "found" : "no found";}'  # 匹配test，打印found； 不匹配， 打印not found
       
            3) length(s) 返回字符串的长度. length(s)
            length 自身是个"伪变量"，它生成当前记录的长度；
            某个内置函数的名字，不带有参数或圆括号，表示这些函数在整个记录上的值
            {print length, $0}  等价于 {print length($0), $0}
       awk 'BEGIN{print length("hello")}'
       awk '{ print length( "test" ) }' # test字符串的长度。
       awk '{ print length }' testfile  # testfile文件中第条记录的字符数。
       awk 'length < 64' # 行长度小于64
       
            4) substr(string, starting position, [length])
               substr(s,p) substr(s,p,n)
            substr(s, m, n) 生成 s 的开始于位置 m(起始于 1)的最多 n 个字符长的子串。如果省略了 n，子串到达 s 的结束处。
       awk 'BEGIN{print substr("Santa Claus",7,6)}'
       awk 'BEGIN{print substr("Santa Claus",7)}'
       awk 'BEGIN{info="this is a test in 2013-01-04"; print substr(info, 4, 10);}'     
       
            5) match(string, regexp) 返回正则表示在string中的位置, 没有定位返回0
               match(s,r)
            match函数返回在字符串中正则表达式位置的索引，如果找不到指定的正则表达式则返回0。
            match函数会设置内建变量RSTART为字符串中子字符串的开始位置，RLENGTH为到子字符串末尾的字符个数。substr可利于这些变量来截取字符串。
       awk '{start=match("this is a test",/[a-z]+$/); print start}'                   # 打印以连续小写字符结尾的开始位置，这里是11。
       awk '{start=match("this is a test",/[a-z]+$/); print start, RSTART, RLENGTH }' # 还打印RSTART和RLENGTH变量，这里是11(start)，11(RSTART)，4(RLENGTH)。
       awk 'BEGIN{print match("Good ole USA",/[A-Z]+$/)}'
       isdigit=$(awk 'BEGIN { if (match(ARGV[1],"^[0-9]+$") != 0) print "true"; else print "false" }' $1) # 判断参数是否为数字：
       awk 'BEGIN{info="this is a test in 2013-01-04"; print match(info, /[0-9]+/) ? "found" : "no found";}' # 匹配数字 ，打印 found；不匹配，打印 not found
            6) toupper(string)和tolower(string) 仅仅gawk有效.
               tolower(s), toupper(s)
       awk 'BEGIN{print toupper("linux"), tolower("BASH")}'

            7) split(string, array, [field seperator]) 如果不输入field seperator, FS内置变量作为其缺省值.
               split(s,a)  split(s,a,fs)
               按给定的分隔符把字符串分割为一个数组。如果分隔符没提供，则按当前FS值进行分割。
       awk 'BEGIN{split("12/24/99",date,"/"); for (i in date) {print date[i]} }'
       awk 'BEGIN{info="this is a test in 2013-01-04"; split(info, tA, " "); print "len : " length(tA); for(k in tA) {print k, tA[k];}}' 
       把字符串 s 分解到 array[1], ..., array[n]。返回找到的元素数目。如果提供了 sep 参数，则把它用做字段分隔符；否则使用 FS 作为分隔符。
       n = split(s, array, sep)
       
            8) variable = sprintf(format, ...) 和printf的最大区别就是他返回格式化后的字符串.
                          sprintf(fmt,expr-list)
       awk '{line = sprintf("%-15s %6.2f ",$5,$6); print line}' datafile
       awk(printf)
       awk 'BEGIN{n1=124.113; n2=-1.224; n3=1.2345; printf("n1 = %.2f, n2 = %.2u, n3 = %.2g, n1 = %X, n1 = %o\n", n1, n2, n3, n1, n1);}'
       
            9) systime() 返回1970/1/1到当前时间的整秒数.
            awk 'BEGIN{tstamp1=mktime("2013 01 04 12 12 12"); tstamp2=systime(); print tstamp2-tstamp1;}'
            10) variable = strftime(format, [timestamp]) # C库中的strftime函数格式化时间。
            mktime( YYYY MM DD HH MM SS[ DST])
            awk 'BEGIN{tstamp=mktime("2013 01 04 12 12 12"); print strftime("%c", tstamp);}'
            awk 'BEGIN{tstamp1=mktime("2013 01 04 12 12 12"); tstamp2=mktime("2013 02 01 0 0 0"); print tstamp2-tstamp1;}'
            
            strftime([format [, timestamp]])
            awk '{ now=strftime("%m/%d/%y"); print now }'
            awk '{ now=strftime( "%D", systime() ); print now }'
            
            11) 数学函数: atan2(x,y), cos(x), exp(x)[求幂], int(x)[求整数], log(x), rand()[随机数], sin(x), sqrt(x), srand(x)
            名称        返回值
            atan2(x,y)  y,x范围内的余切
            cos(x)      余弦函数
            exp(x)      求幂
            int(x)      取整
            log(x)      自然对数
            rand()      随机数
            srand(x)    x是rand()函数的种子
            rand()
            awk  '{ $1 = log($1); print }' # 把每行的第一个字段替代为它的对数
            sin(x)      正弦函数
            sqrt(x)     平方根
            awk 'BEGIN{print 31/3}'
            awk 'BEGIN{print int(31/3)}'
            awk 'BEGIN{OFMT="%.3f"; fs=sin(3.14/2); fe=exp(1); fl=log(exp(2)); fi=int(3.1415); fq=sqrt(100); print fs, fe, fl, fi, fq;}' 
            awk 'BEGIN{srand(); fr=int(100*rand()); print fr;}'
            12) 自定义函数：
            自定义函数可以放在awk脚本的任何可以放置模板和动作的地方。
            function name(parameter1,parameter2,...) {
                statements
                return expression
            }
}

awk_system(){
awk 'BEGIN{b=system("ls -al"); print b;}'
awk 'BEGIN{system("clear")}'
}

# close 用法
可以在awk中打开一个管道，且同一时刻只能有一个管道存在。通过close()可关闭管道。
如：$ awk '{print $1, $2 | "sort" }  END { close("sort"); } ' cbtc.sh 
awk把print语句的输出通过管道作为linux命令sort的输入,END块执行关闭管道操作。

awk 'BEGIN{while("cat /etc/passwd" | getline) {print $0;}; close("/etc/passwd");}' | head -n10

# close(expr) 关闭管道文件
close( Expression ) 
    用同一个带字符串值的 Expression 参数来关闭由 print 或 printf 语句打开的或调用 getline 函数打开的文件或管道。
如果文件或管道成功关闭，则返回 0；其它情况下返回非零值。如果打算写一个文件，并稍后在同一个程序中读取文件，则 close 语句是必需的。

请看下面这段代码
awk 'BEGIN {
     cmd = "tr [a-z] [A-Z]"
     print "hello, world !!!" |& cmd
     
     close(cmd, "to")
     cmd |& getline out
     print out;
     
     close(cmd);
  }'
  HELLO, WORLD !!!
是不是感觉很难懂？让我来解释一下
    第一个语句cmd = "tr [a-z] [A-Z]"是我们在AWK中要用来建立双向连接的命令。
    第二个语句print提供了tr命令的输入，使用 &| 表名建立双向连接。
    第三个语句close(cmd, "to")用于执行完成后关闭to进程
    第四个语句cmd |& getline out使用getline函数存储输出到out变量
    接下来打印变量out的内容，然后关闭cmd
}
https://www.gnu.org/software/gawk/manual/html_node/Getline.html#Getline
awk_getline(){
Variant                      | Effect                       | awk / gawk
getline                      | Sets $0, NF, FNR, NR, and RT | AWK, NAWK, GAWK # 从当前文件中读取下条记录给$0, 修改了NF,NR和FNR的值。
getline <file                | Sets $0, NF, and RT          | NAWK, GAWK      # 从指定名称文件file中读取下条记录，$0和NF被设置。
getline variable             | Sets var, FNR, NR, and RT    | NAWK, GAWK      # 将从当前文件中读取的下条记录给variable, 修改了FNR和NR的值
getline variable <file       | Sets var and RT              | NAWK, GAWK      # 从指定名称文件file中读取下条记录，variable被设置，
"command" | getline          | Sets $0, NF, and RT          | NAWK, GAWK      # 从管道中读取"command"的输出中下条记录，如果管道不存在则创建管道，一旦创建管道后续则读取管道内剩余数据
"command" | getline variable | Sets var and RT              | NAWK, GAWK      # 如果variable忽略，则$0和NF被设置。否则variable被设置。
command |& getline           | Sets $0, NF, and RT          | gawk
command |& getline var       | Sets var and RT              | gawk

1. Expression | getline [ Variable ] 
    从来自 Expression 参数指定的命令的输出中通过管道传送的流中读取一个输入记录，并将该记录的值指定给 Variable 参数指定的变量。
如果当前未打开将 Expression 参数的值作为其命令名称的流，则创建流。创建的流等同于调用 popen 子例程，此时 Command 参数取 Expression 
参数的值且 Mode 参数设置为一个是 r 的值。只要流保留打开且 Expression 参数求得同一个字符串，则对 getline 函数的每次后续调用读取
另一个记录。如果未指定 Variable 参数，则 $0 记录变量和 NF 特殊变量设置为从流读取的记录。
2. getline [ Variable ] < Expression 
    从 Expression 参数指定的文件读取输入的下一个记录，并将 Variable 参数指定的变量设置为该记录的值。只要流保留打开且 Expression 
参数对同一个字符串求值，则对 getline 函数的每次后续调用读取另一个记录。如果未指定 Variable 参数，则 $0 记录变量和 NF 特殊变量设置
为从流读取的记录。
3. getline [ Variable ] 
    将 Variable 参数指定的变量设置为从当前输入文件读取的下一个输入记录。如果未指定 Variable 参数，则 $0 记录变量设置为该记录的值，
还将设置 NF、NR 和 FNR 特殊变量。

    输出重定向需用到getline函数。getline从标准输入、管道或者当前正在处理的文件之外的其他输入文件获得输入。
getline负责从输入获得下一行的内容，并给NF,NR和FNR等内建变量赋值。如果得到一条记录，getline函数返回1，
如果到达文件的末尾就返回0，如果出现错误，例如打开文件失败，就返回-1。如：
awk 'BEGIN{ "date" | getline d; print d}' test。 
# 执行linux的date命令，并通过管道输出给getline，然后再把输出赋值给自定义变量d，并打印它。
awk 'BEGIN{"date" | getline d; split(d,mon); print mon[2]}' test。 
# 执行shell的date命令，并通过管道输出给getline，然后getline从管道中读取并将输入赋值给d，split函数把变量d转化成数组mon，然后打印数组mon的第二个元素。
awk 'BEGIN{while( "ls" | getline) print}'
# 命令ls的输出传递给geline作为输入，循环使getline从ls的输出中读取一行，并把它打印到屏幕。这里没有输入文件，因为BEGIN块在打开输入文件前执行，所以可以忽略输入文件。
awk ' BEGIN { printf "What is your name "; getline name < "/dev/tty" } $1 ~name {print "Found" name on line } END{print "See you," name  } ' cbtc.sh
# 在屏幕上打印"What is your name ",并等待用户应答。当一行输入完毕后，getline函数从终端接收该行输入，并把它储存在自定义变量name中。
# 如果第一个域匹配变量name的值，print函数就被执行，END块打印See you和name的值。
awk 'BEGIN{while (getline < "/etc/passwd" > 0) lc++; print lc}'
# awk将逐行读取文件/etc/passwd的内容，在到达文件末尾前，计数器lc一直增加，当到末尾时，打印lc的值。
awk 'BEGIN{while(getline < "/etc/passwd"){print $0;}; close("/etc/passwd");}' | head -n10
awk 'BEGIN{print "Enter your name:"; getline name; print name;}'
}

awk_pattern(){
正则表达式操作符使用 ~ 和 !~ 分别代表匹配和不匹配。
awk '$0 ~ 9' marks.txt
awk '$0 !~ 9' marks.txt
tail -n 40 /var/log/nginx/access.log | awk '$0 ~ /ip\[127\.0\.0\.1\]/'

echo -e "cat\nbat\nfun\nfin\nfan" | awk '/f.n/'
echo -e "This\nThat\nThere\nTheir\nthese" | awk '/^The/'
echo -e "knife\nknow\nfun\nfin\nfan\nnine" | awk '/n$/'
echo -e "Call\nTall\nBall" | awk '/[CT]all/'
echo -e "Call\nTall\nBall" | awk '/[^CT]all/'
echo -e "Call\nTall\nBall\nSmall\nShall" | awk '/Call|Ball/'
echo -e "Colour\nColor" | awk '/Colou?r/'
echo -e "ca\ncat\ncatt" | awk '/cat*/'
echo -e "111\n22\n123\n234\n456\n222" | awk '/2+/'
echo -e "Apple Juice\nApple Pie\nApple Tart\nApple Cake" | awk '/Apple (Juice|Cake)/'
}

awk_condition(){

#     awk 命令编程语言中的大部分条件语句和 C 编程语言中的条件语句具有相同的语法和功能。
# 所有条件语句允许使用{ } (花括号) 将语句组合在一起。可以在条件语句的表达式部分和语句
# 部分之间使用可选的换行字符，且换行字符或 ;（分号）用于隔离 { } (花括号) 中的多个语句。
C 语言中的六种条件语句是：
if 	需要以下语法：
if ( Expression ) { Statement } [ else Action ]

while       需要以下语法：
while ( Expression ) { Statement }

for         需要以下语法：
for ( Expression ; Expression ; Expression ) { Statement }

break       当 break 语句用于 while 或 for 语句时，导致退出程序循环。
continue    当 continue 语句用于 while 或 for 语句时，使程序循环移动到下一个迭代。

awk 命令编程语言中的五种不遵循 C 语言规则的条件语句是：
for...in    需要以下语法：
for ( Variable in Array ) { Statement }
for...in 语句将 Variable 参数设置为 Array 变量的每个索引值，一次一个索引且没有特定的顺序，
并用每个迭代来执行 Statement 参数指定的操作。请参阅 delete 语句以获得 for...in 语句的示例。

if...in     需要以下语法：
if ( Variable in Array ) { Statement }
if...in 语句搜索是否存在的 Array 元素。如果找到 Array 元素，就执行该语句。

delete      需要以下语法：
delete Array [ Expression ]
delete 语句删除 Array 参数指定的数组元素和 Expression 参数指定的索引。例如，语句：

for (i in g)
   delete g[i];
将删除 g[] 数组的每个元素。

exit        需要以下语法：
exit [Expression]
exit 语句首先调用所有 END 操作（以它们发生的顺序），然后以 Expression 参数指定的退出状态终止 awk 命令。
如果 exit 语句在 END 操作中出现，则不调用后续 END 操作。

#           需要以下语法：
# Comment
# 语句放置注释。注释应始终以换行字符结束，但可以在一行上的任何地方开始。
next 停止对当前输入记录的处理，从下一个输入记录继续。
}

awk_if(){
            awk '{print ($1>$2)?"第一排"$1:"第二排"$2}'      # 条件判断 括号代表if语句判断 "?"代表then ":"代表else
            awk '{max=($1>$2)? $1 : $2; print max}'          # 条件判断 如果$1大于$2,max值为为$1,否则为$2
            awk '{if ( $6 > 50) print $1 " Too high" ;\
            else print "Range is OK"}' file
            awk '{if ( $6 > 50) { count++;print $3 } \
            else { x+5; print $2 } }' file
{if (expression){ statement; statement; ... } }
{if (expression){ statement; statement; ... } else{ statement; statement; ... } }
{if (expression){ statement; statement; ... } else if (expression){ statement; statement; ... } else if (expression){ statement; statement; ... } else { statement; statement; ... } }
if...in 需要以下语法： if ( Variable in Array ) { Statement }
if...in 语句搜索是否存在的 Array 元素。如果找到 Array 元素，就执行该语句。

# 流程控制语句与大多数语言一样，基本格式如下
if (condition)
   action
   
if (condition) {
   action-1
   action-1
   .
   .
   action-n
}

if (condition)
   action-1
else if (condition2)
   action-2
else
   action-3
   
awk 'BEGIN { num = 11; if (num % 2 == 0) printf "%d is even number.\n", num; else printf "%d is odd number.\n", num }'
awk 'BEGIN {
   a = 30;
   
   if (a==10)
   print "a = 10";
   else if (a == 20)
   print "a = 20";
   else if (a == 30)
   print "a = 30";
}'
}

awk_loop(){
1. while 循环
while (condition)
  action
  
awk '{i = 1; while ( i <= NF ) { print NF, $i ; i++ } }' file
awk 'BEGIN {i = 1; while (i < 6) { print i; ++i } }'

2. do-while 循环
do
   action
while (condition)

awk 'i=2; do {print i, " to the second power is ", i*i; i = i + 1 } while (i < 10)' file
awk 'BEGIN {i = 1; do { print i; ++i } while (i < 6) }'

3. for循环方式1
for (initialisation; condition; increment/decrement)
   action
awk '{ for ( i = 1; i <= NF; i++ ) print NF,$i }' file
awk 'BEGIN { for (i = 1; i <= 5; ++i) print i }'
awk 'BEGIN { sum = 0; for (i = 0; i < 20; ++i) { sum += i; if (sum > 50) break; else print "Sum =", sum } }' 
awk 'BEGIN { for (i = 1; i <= 20; ++i) { if (i % 2 == 0) print i ; else continue } }' 
awk 'BEGIN { sum = 0; for (i = 0; i < 20; ++i) { sum += i; if (sum > 50) exit(10); else print "Sum =", sum } }'

4. for循环方式2
    for 语句还有一种可选的形式，它适合于访问关联数组的元素:
    {for (item in arrayname){ print arrayname[item] } }
    用字符串作为下标。如：count["test"]
delete函数用于删除数组元素。如：$ awk '{line[x++]=$1} END{for(x in line) delete(line[x])}' test。
分配给数组line的是第一个域的值，所有记录处理完成后，special for循环将删除每一个元素。
        
    break 语句导致从围绕它 while 或 for 中立即退出，
    continue 语句导致开始下一次重复。
    next 语句导致立即跳转到下一个记录并从头开始扫描模式。
    exit 语句导致程序表现得如同已经到达了输入的结束。

# shell_awk_colours.txt
name       color  amount
apple      red    4
banana     yellow 6
raspberry  red    99
strawberry red    3
grape      purple 10
apple      green  8
plum       purple 2
kiwi       brown  4
potato     brown  9
pineapple  yellow 5

awk  'NR != 1 { a[$2]++ } END { for (key in a) { print a[key] " " key } }' shell_awk_colours.txt
awk  'BEGIN { FS=" "; OFS="\t"; print("color\tsum"); } NR != 1 { a[$2]+=$3; } END { for (b in a) { print b, a[b] } }' shell_awk_colours.txt
}
awk_cmd_option(){
-v 变量赋值选项              # awk -v name=Jerry 'BEGIN{printf "Name = %s\n", name
--dump-variables[=file] 选项 输出排好序的全局变量列表和它们最终的值到文件中，默认的文件是 awkvars.out # awk --dump-variables ''
--help 选项                  打印帮助信息。
--lint[=fatal] 选项          检查程序的不兼容性或者模棱两可的代码，当提供参数 fatal的时候，它会对待Warning消息作为Error。
--profile[=file]选项         输出一份格式化之后的程序到文件中，默认文件是 awkprof.out 
 # awk --profile 'BEGIN{printf"---|Header|--\n"} {print} END{printf"---|Footer|---\n"}' marks.txt > /dev/null
--traditional 选项           禁止所有的gawk规范的扩展
        }
        awk -v val=$x '{print $1, $2, $3, $4+val, $5+ENVIRON["y"]}' OFS="\t" score.txt #val参数传递
        # IPv4 Address [192.168.1.1]
        awk -F '[.]' 'function ok(n) { return (n ~ /^([01]?[0-9]?[0-9]|2[0-4][0-9]|25[0-5])$/) } {exit (ok($1) && ok($2) && ok($3) && ok($4))}'
        awk -F '[.]' 'function ok(n){return (n>=0 && n<=255)} {exit (ok($1) && ok($2) && ok($3) && ok($4))}'
        awk '/Tom/' file               # 打印匹配到得行
        awk '/^Tom/{print $1}'         # 匹配Tom开头的行 打印第一个字段
        awk '$1 !~ /ly$/'              # 显示所有第一个字段不是以ly结尾的行
        awk '$3 <40'                   # 如果第三个字段值小于40才打印
        awk '$4==90{print $5}'         # 取出第四列等于90的第五列
        awk '/^(no|so)/' test          # 打印所有以模式no或so开头的行
        awk '$3 * $4 > 500'            # 算术运算(第三个字段和第四个字段乘积大于500则显示)
        awk '{print NR" "$0}'          # 加行号
        awk '/tom/,/suz/'              # 打印tom到suz之间的行
        awk '{a+=$1}END{print a}'      # 列求和
        awk 'sum+=$1{print sum}'       # 将$1的值叠加后赋给sum
        awk '{a+=$1}END{print a/NR}'   # 列求平均值
        awk '!s[$1 $3]++' file         # 根据第一列和第三列过滤重复行
        awk -F'[ :\t]' '{print $1,$2}'           # 以空格、:、制表符Tab为分隔符
        echo 'Sample123string54with908numbers' | awk -F'[0-9]+' '{print $2}' # 模式匹配
        echo '{foo}   bar=baz' | awk -F'[{}= ]+' '{print $1}'                # 模式匹配
        echo '{foo}   bar=baz' | awk -F'[{}= ]+' '{print $2}'                # 模式匹配  foo
        echo '{foo}   bar=baz' | awk -F'[{}= ]+' '{print $3}'                # 模式匹配  bar
        echo 'apple' | awk -v FS= '{print $1}'                               # 命令行 -v
        echo 'apple' | awk -v FS= '{print $1}'                               # 命令行 -v
        echo 'apple' | awk -v FS= '{print $1}'                               # 命令行 -v
        awk -F'[ ]+|[ ][ ]+' '/^$/{print $8}'             # 提取时间,空格不固定
        echo aada:abaa|awk -F: '$1~/d/||$2~/b/{print}'         # 关键列匹配两内容之一
        awk -F '' '{ for(i=1;i<NF+1;i++)a+=$i  ;print a}'      # 多位数算出其每位数的总和.比如 1234， 得到 10
        awk '{print "'"$a"'","'"$b"'"}'          # 引用外部变量
        awk '{if(NR==52){print;exit}}'           # 显示第52行
        awk '/关键字/{a=NR+2}a==NR {print}'      # 取关键字下第几行
        awk 'gsub(/liu/,"aaaa",$1){print $0}'    # 只打印匹配替换后的行
        awk '{$1="";$2="";$3="";print}'                        # 去掉前三列
        echo aada:aba|awk '/d/||/b/{print}'                    # 匹配两内容之一
        
        echo Ma asdas|awk '$1~/^[a-Z][a-Z]$/{print }'          # 第一个域匹配正则
        echo aada:aaba|awk '/d/&&/b/{print}'                   # 同时匹配两条件
        awk 'length($1)=="4"{print $1}'                        # 字符串位数
        awk '{if($2>3){system ("touch "$1)}}'                  # 执行系统命令
        awk '{sub(/Mac/,"Macintosh",$0);print}'                # 用Macintosh替换Mac
        awk '{gsub(/Mac/,"MacIntosh",$1); print}'              # 第一个域内用Macintosh替换Mac
        awk '{ i=$1%10;if ( i == 0 ) {print i}}'               # 判断$1是否整除(awk中定义变量引用时不能带 $ )
        awk 'BEGIN{a=0}{if ($1>a) a=$1 fi}END{print a}'        # 列求最大值  设定一个变量开始为0，遇到比该数大的值，就赋值给该变量，直到结束
        awk 'BEGIN{a=11111}{if ($1<a) a=$1 fi}END{print a}'    # 求最小值
        awk '{if(A)print;A=0}/regexp/{A=1}'                    # 查找字符串并将匹配行的下一行显示出来，但并不显示匹配行
        awk '/regexp/{print A}{A=$0}'                          # 查找字符串并将匹配行的上一行显示出来，但并不显示匹配行
        awk '{if(!/mysql/)gsub(/1/,"a");print $0}'             # 将1替换成a，并且只在行中未出现字串mysql的情况下替换
        awk 'BEGIN{srand();fr=int(100*rand());print fr;}'      # 获取随机数
        awk '{if(NR==3)F=1}{if(F){i++;if(i%7==1)print}}'       # 从第3行开始，每7行显示一次
        awk '{if(NF<1){print i;i=0} else {i++;print $0}}'      # 显示空行分割各段的行数
        echo +null:null  |awk -F: '$1!~"^+"&&$2!="null"{print $0}'       # 关键列同时匹配
        awk -v RS=@ 'NF{for(i=1;i<=NF;i++)if($i) printf $i;print ""}'    # 指定记录分隔符
        awk '{b[$1]=b[$1]$2}END{for(i in b){print i,b[i]}}'              # 列叠加
        awk '{ i=($1%100);if ( $i >= 0 ) {print $0,$i}}'                 # 求余数
        awk '{b=a;a=$1; if(NR>1){print a-b}}'                            # 当前行减上一行
        awk '{a[NR]=$1}END{for (i=1;i<=NR;i++){print a[i]-a[i-1]}}'      # 当前行减上一行
        awk -F: '{name[x++]=$1};END{for(i=0;i<NR;i++)print i,name[i]}'   # END只打印最后的结果,END块里面处理数组内容
        awk '{sum2+=$2;count=count+1}END{print sum2,sum2/count}'         # $2的总和  $2总和除个数(平均值)
        awk -v a=0 -F 'B' '{for (i=1;i<NF;i++){ a=a+length($i)+1;print a  }}'     # 打印所以B的所在位置
        awk 'BEGIN{ "date" | getline d; split(d,mon) ; print mon[2]}' file        # 将date值赋给d，并将d设置为数组mon，打印mon数组中第2个元素
        awk 'BEGIN{info="this is a test2010test!";print substr(info,4,10);}'      # 截取字符串(substr使用)
        awk 'BEGIN{info="this is a test2010test!";print index(info,"test")?"ok":"no found";}'      # 匹配字符串(index使用)
        awk 'BEGIN{info="this is a test2010test!";print match(info,/[0-9]+/)?"ok":"no found";}'    # 正则表达式匹配查找(match使用)
        awk '{for(i=1;i<=4;i++)printf $i""FS; for(y=10;y<=13;y++)  printf $y""FS;print ""}'        # 打印前4列和后4列
        awk 'BEGIN{for(n=0;n++<9;){for(i=0;i++<n;)printf i"x"n"="i*n" ";print ""}}'                # 乘法口诀
        awk 'BEGIN{info="this is a test";split(info,tA," ");print length(tA);for(k in tA){print k,tA[k];}}'             # 字符串分割(split使用)
        awk '{if (system ("grep "$2" tmp/* > /dev/null 2>&1") == 0 ) {print $1,"Y"} else {print $1,"N"} }' a            # 执行系统命令判断返回状态
        awk  '{for(i=1;i<=NF;i++) a[i,NR]=$i}END{for(i=1;i<=NF;i++) {for(j=1;j<=NR;j++) printf a[i,j] " ";print ""}}'   # 将多行转多列
        netstat -an|awk -v A=$IP -v B=$PORT 'BEGIN{print "Clients\tGuest_ip"}$4~A":"B{split($5,ip,":");a[ip[1]]++}END{for(i in a)print a[i]"\t"i|"sort -nr"}'    # 统计IP连接个数
        cat 1.txt|awk -F" # " '{print "insert into user (user,password,email)values(""'\''"$1"'\'\,'""'\''"$2"'\'\,'""'\''"$3"'\'\)\;'"}' >>insert_1.txt     # 处理sql语句
        awk 'BEGIN{printf "what is your name?";getline name < "/dev/tty" } $1 ~name {print "FOUND" name " on line ", NR "."} END{print "see you," name "."}' file  # 两文件匹配

        
        awk `1` input-file # awk打印文件的每一行
        # 对每一个'/pattern/{action}'，如果省略{action}，则{action}等价于{print}，没有参数的print会打印整个行。
        # 1相当于永远为true。因此会打印文件的每一行。
        
awk_build_function(){
Awk(action) =
    for each file
      for each input line
        for each pattern
          if pattern matches input line
            do action(fields)
# 即把awk程序看做一个函数，action作为awk的参数。对符合pattern的输入行，调用action处理这一行的每个field。
# 上面这段伪代码可以帮助我更好地理解awk。
        }
        
sed -n '/^[a-zA-Z0-9]/p' table.txt | awk '{lines[NR]=$0}  END{ for (i=1; i<=NR; i++){ printf("%s\t",lines[i]); if(i%3==0) printf("\n") } }'

awk_array(){
    数组元素不用声明；在被提及到的时候才导致它的存在。下标可以有任何非空的值，包括非数值的字符串。作为常规的数值下标的例子，
    x[NR] = $0 # 把当前输入记录赋值到数组 x 的第 NR 个元素。
    
    假设输入包含的字段带有象 apple、orange 等等这样的值。则程序
    /apple/ { x["apple"]++ }
    /orange/ { x["orange"]++ }
    END { print x["apple"], x["orange"] }
    增加指名的数组元素的计数，并在输入结束时打印它们。
    
1.awk中的数组是一维数组，使用时不用事先声明。第一次使用数组元素时，会自动生成数组元素的值，默认为空字符串""和数字0。
awk 'END {if (arr["A"] == "") print "Empty string"}'  # Empty string
awk 'END {if (arr["A"] == 0) print "Number 0"}'       # Number 0
2.awk中的数组是关联数组(associative array)，数组下标为字符串。
3.使用for循环可遍历数组下标：
其中访问数组下标的顺序与具体的实现相关。此外，如果在遍历时加入了新的元素，那么程序运行结果是不确定的。
4.使用subscript in array表达式来判断数组是否包含指定的数组下标。如果array[subscript]存在，表达式返回1，反正返回0。
注意：使用subscript in array不会创建array[subscript]，而if (array[subscript] != "")则会创建array[subscript](如果array[subscript]不存在的话)。
5.删除数组元素：delete array[subscript]。
6.split(string, array, fs)使用fs作为字段分隔符(field separator)，把字符串string拆分后，传到array数组中。
第一个字段保存在array["1"]，第二个字段保存在array["2"]…。如果没有指定fs，则使用内置变量FS作为分隔符。
7.多维数组。awk不直接支持多维数组，但可以通过一维数组来模拟。
8.数组元素不能再是数组。

1. 建立数组
array[index] = value ：数组名array，下标index以及相应的值value。
2. 读取数组值
{ for (item in array)  print array[item]} # 输出的顺序是随机的
{for(i=1;i<=len;i++)  print array[i]} # Len 是数组的长度
3. 删除数组或数组元素： 使用delete 函数
delete array                     #删除整个数组
delete array[item]           # 删除某个数组元素(item)
4. 排序：awk中的asort函数可以实现对数组的值进行排序，不过排序之后的数组下标改为从1到数组的长度。
echo 'aa
bb
aa
bb
cc' |\
awk '{a[$0]++}END{l=asorti(a);for(i=1;i<=l;i++)print a[i]}'
aa
bb
cc
echo 'aa
bb
aa
bb
cc' |\
awk '{a[$0]++}END{l=asorti(a,b);for(i=1;i<=l;i++)print b[i],a[b[i]]}'
aa 2
bb 2
cc 1
5.  计算总数(sum)，如：
awk  '{name[$0]+=$1};END{for(i in name) print  i, name[i]}'
再举个例子：
echo "aaa 1
aaa 1
ccc 1
aaa 1
bbb 1
ccc 1" |awk '{a[$1]+=$2}END{for(i in a) print i,a[i]}'
aaa 3
bbb 1
ccc 2
6.  合并file1和file2，除去重复项：
awk 'NR==FNR{a[$0]=1;print}   #读取file1，建立数组a，下标为$0，并赋值为1，然后打印
NR>FNR{                       #读取file2
if(!(a[$0])) {print }         #如果file2 的$0不存在于数组a中，即不存在于file1，则打印。
}' file1 file2
aaa
bbb
ccc
ddd
eee
fff
6. 提取文件1中有，但文件2中没有：
awk 'NR==FNR{a[$0]=1}           #读取file2，建立数组a，下标为$0，并赋值为1
NR>FNR{                         #读取file1
if(!(a[$0])) {print }           #如果file1 的$0不存在于数组a中，即不存在于file2，则打印。
}' file2 file1
bbb
ccc

解读下Tim大师的代码：

awk '
FNR==1{                       #FNR==1，即a和b文本的第一行，这个用的真的很巧妙。
        for(i=1;i<=NF;i++){ 
                b[i]=$i       #读取文本的每个元素存入数组b
                c[$i]++}      #另建立数组c，并统计每个元素的个数
                next          #可以理解为，读取FNR!=1的文本内容。
        }
{k++                          # 统计除去第一行的文本行数
for(i=1;i<=NF;i++)a[k","b[i]]=$i  #利用一个二维数组来保持每个数字的位置， k，b[i]可以理解为每个数字的坐标。
}
END{
        l=asorti(c)                #利用asorti函数对数组的下标进行排序，并获取数组长度，即输出文件的列数(NF值)
        for(i=1;i<=l;i++)printf c[i]" " # 先打印第一行，相当于headline。
        print ""
        for(i=1;i<=k;i++){
                for(j=1;j<=l;j++)printf a[i","c[j]]?a[i","c[j]]" ":"0 " # 打印二维数组的值。
                print ""}
        }' a.txt b.txt

}
        
    取本机IP{
        /sbin/ifconfig |awk -v RS="Bcast:" '{print $NF}'|awk -F: '/addr/{print $2}'
        /sbin/ifconfig |awk '/inet/&&$2!~"127.0.0.1"{split($2,a,":");print a[2]}'
        /sbin/ifconfig |awk -v RS='inet addr:' '$1!="eth0"&&$1!="127.0.0.1"{print $1}'|awk '{printf"%s|",$0}'
        /sbin/ifconfig |awk  '{printf("line %d,%s\n",NR,$0)}'         # 指定类型(%d数字,%s字符)
        
        过滤IP地址和广播地址：
        ifconfig eth0 | sed -n 's/^.*dr:\(.*\) B.*t:\(.*\)  Ma.*$/\1\2/gp'
        ifconfig eth0 | grep 'inet addr' | awk -F '[: ]+' '{print $4}'
        ifconfig eth0 |sed -n '2p'|awk -F '[: ]+' '{print $4}'
        ifconfig eth0 | awk -F '[: ]+' 'NR==2 {print $4}' //NR表示第几行
    }

    netstat{
    awk '{print $1, $4}' netstat.txt
    awk '{printf "%-8s %-8s %-8s %-18s %-22s %-15s\n",$1,$2,$3,$4,$5,$6}' netstat.txt
    awk '$3==0 && $6=="LISTEN" ' netstat.txt
    awk ' $3>0 {print $0}' netstat.txt
    awk '$3==0 && $6=="LISTEN" || NR==1 ' netstat.txt 
    awk '$3==0 && $6=="LISTEN" || NR==1 {printf "%-20s %-20s %s\n",$4,$5,$6}' netstat.txt
    awk '$3==0 && $6=="ESTABLISHED" || NR==1 {printf "%02s %s %-20s %-20s %s\n",NR, FNR, $4,$5,$6}' netstat.txt
    awk '$6 ~ /FIN/ || NR==1 {print NR,$4,$5,$6}' OFS="\t" netstat.txt
    awk '$6 ~ /WAIT/ || NR==1 {print NR,$4,$5,$6}' OFS="\t" netstat.txt
    awk '/LISTEN/' netstat.txt
    awk '$6 ~ /FIN|TIME/ || NR==1 {print NR,$4,$5,$6}' OFS="\t" netstat.txt
    awk '$6 !~ /WAIT/ || NR==1 {print NR,$4,$5,$6}' OFS="\t" netstat.txt #awk '!/WAIT/' netstat.txt
    
    awk 'NR!=1{print > $6}' netstat.txt
    awk 'NR!=1{print $4,$5 > $6}' netstat.txt
    
    ls -l  *.cpp *.c *.h | awk '{sum+=$5} END {print sum}' #计算所有的C文件，CPP文件和H文件的文件大小总和。
    
    ps aux | awk 'NR!=1{a[$1]+=$6;} END { for(i in a) print i ", " a[i]"KB";}' #统计每个用户的进程的占了多少内存
    
    awk  'BEGIN{FS=":"} {print $1,$3,$6}' /etc/passwd
    awk  -F: '{print $1,$3,$6}' /etc/passwd
    awk -F '[;:]' #如果你要指定多个分隔符，你可以这样来：
    awk  -F: '{print $1,$3,$6}' OFS="\t" /etc/passwd
    }
    查看磁盘空间{
        df -h|awk -F"[ ]+|%" '$5>14{print $5}'
        df -h|awk 'NR!=1{if ( NF == 6 ) {print $5} else if ( NF == 5) {print $4} }'
        df -h|awk 'NR!=1 && /%/{sub(/%/,"");print $(NF-1)}'
        df -h|sed '1d;/ /!N;s/\n//;s/ \+/ /;'    #将磁盘分区整理成一行   可直接用 df -P
    }

    排列打印{
        awk 'END{printf "%-10s%-10s\n%-10s%-10s\n%-10s%-10s\n","server","name","123","12345","234","1234"}' txt
        awk 'BEGIN{printf "|%-10s|%-10s|\n|%-10s|%-10s|\n|%-10s|%-10s|\n","server","name","123","12345","234","1234"}'
        awk 'BEGIN{
        print "   *** 开 始 ***   ";
        print "+-----------------+";
        printf "|%-5s|%-5s|%-5s|\n","id","name","ip";
        }
        $1!=1 && NF==4{printf "|%-5s|%-5s|%-5s|\n",$1,$2,$3" "$11}
        END{
        print "+-----------------+";
        print "   *** 结 束 ***   "
        }' txt
    }

    #从file文件中找出长度大于80的行
    awk 'length>80' file
     
    #按连接数查看客户端IP
    netstat -ntu | awk '{print $5}' | cut -d: -f1 | sort | uniq -c | sort -nr
     
    #打印99乘法表
    seq 9 | sed 'H;g' | awk -v RS='' '{for(i=1;i<=NF;i++)printf("%dx%d=%d%s", i, NR, i*NR, i==NR?"\n":"\t")}'
    
    老男孩awk经典题{
        分析图片服务日志，把日志(每个图片访问次数*图片大小的总和)排行，也就是计算每个url的总访问大小
        说明：本题生产环境应用：这个功能可以用于IDC网站流量带宽很高，然后通过分析服务器日志哪些元素占用流量过大，进而进行优化或裁剪该图片，压缩js等措施。
        本题需要输出三个指标： 【被访问次数】    【访问次数*单个被访问文件大小】   【文件名(带URL)】
        测试数据
        59.33.26.105 - - [08/Dec/2010:15:43:56 +0800] "GET /static/images/photos/2.jpg HTTP/1.1" 200 11299

        awk '{array_num[$7]++;array_size[$7]+=$10}END{for(i in array_num) {print array_num[i]" "array_size[i]" "i}}'
    }

    awk练习题{
        wang     4
        cui      3
        zhao     4
        liu      3
        liu      3
        chang    5
        li       2

        1 通过第一个域找出字符长度为4的
        2 当第二列值大于3时，创建空白文件，文件名为当前行第一个域$1 (touch $1)
        3 将文档中 liu 字符串替换为 hong
        4 求第二列的和
        5 求第二列的平均值
        6 求第二列中的最大值
        7 将第一列过滤重复后，列出每一项，每一项的出现次数，每一项的大小总和

        1、字符串长度
            awk 'length($1)=="4"{print $1}'
        2、执行系统命令
            awk '{if($2>3){system ("touch "$1)}}'
        3、gsub(/r/,"s",域) 在指定域(默认$0)中用s替代r  (sed 's///g')
            awk '{gsub(/liu/,"hong",$1);print $0}' a.txt
        4、列求和
            awk '{a+=$2}END{print a}'
        5、列求平均值
            awk '{a+=$2}END{print a/NR}'
            awk '{a+=$2;b++}END{print a,a/b}'
        6、列求最大值
            awk 'BEGIN{a=0}{if($2>a) a=$2 }END{print a}'
        7、将第一列过滤重复列出每一项，每一项的出现次数，每一项的大小总和
            awk '{a[$1]++;b[$1]+=$2}END{for(i in a){print i,a[i],b[i]}}'
    }

    awk处理复杂日志{
        6.19：
        DHB_014_号百总机服务业务日报：广州 到达数异常!
        DHB_023_号百漏话提醒日报：珠海 到达数异常!
        6.20：
        DHB_014_号百总机服务业务日报：广州 到达数异常!到

        awk -F '[_ ：]+' 'NF>2{print $4,$1"_"$2,b |"sort";next}{b=$1}'

        # 当前行NF小于等于2 只针对{print $4,$1"_"$2,b |"sort";next} 有效 即 6.19：行跳过此操作,  {b=$1} 仍然执行
        # 当前行NF大于2 执行到 next 强制跳过本行，即跳过后面的 {b=$1}
    }
    
awk_usual(){
统计tomcat每秒的带宽(字节)，最大的排在最后面 
#cat localhost_access_log.txt | awk '{ bytes[$5] += $NF; }; END{for(time in bytes) print bytes[time] " " time}' | sort -n

统计某一秒的带宽 
#grep "18:07:34" localhost_access_log.txt |awk '{ bytes += $NF; } END{ print bytes }'

    awk 'BEGIN{a=1;b="213";print "output "a","b;}'  # output 1,213
    awk 'BEGIN{a=1;b="213";print "output",a,","b;}' # output 1 ,213
    awk 'BEGIN{a=1;b="213";printf("output %d,%s\n",a,b)}' # output 1,213
    
    echo "a:b c,d" |awk '{print $1; print $2; print NF}' # a:b c,d 2
    a:b
    c,d
    2
    echo "a:b c,d" |awk -F " |,|:" '{print $1; print $2; print NF}' 
    a
    b
    4
    
    abc.txt内容如下： 
    first lady 
    second boy 
    third child
    
    cat abc.txt |awk 'BEGIN {print "begin process"} {print "process 1 "$1} {print "process 2 "$2} END { print " the end"}'

    cat abc.txt |awk -F " " ' 
                'BEGIN {print "begin process"} #在开头的时候执行一次 
                {print "process 1 "$1} #每一行执行一次 
                {print "process 2 "$2} #每一行执行一次 
                END { print " the end"}' #最后的时候执行一次'
    #没有BEGIN，只有END的情况
    cat abc.txt |awk '{print "begin process"} {print "process 1 "$1} {print "process 2 "$2} END { print " the end"}'
    cat abc.txt |awk -F ":"
                '{print "begin process"}         #因为没有BEGIN  所以这个每一行都会执行
                {print "process 1 "$1}           #每一行都会执行
                {print "process 2 "$2}           #每一行都会执行
                END { print " the end"}'         #最后执行一次'
                
    awk 'BEGIN{array1["a"]=1;array1[2]="213";print array1["a"],array1[2]}'

   # year.txt中内容如下  
   2016:09 1    //表示2016年9月，有一个访问
   2016:06 1
   2016:06 1
   2016:01 1
   2015:01 1
   2014:01 1
   2015:01 1
   2016:02 1
   awk  '{bytes[$1]+=$2}  END { for(time in bytes) print bytes[time],time}' year.txt |sort -n
   
   awk '{bytes[$1]+=$2} 
         //bytes为数组，下标是时间，value是访问量 
         END { for(time in bytes) print bytes[time], time }' year.txt |sort -n

    awk的多维数组
    awk 'BEGIN{ for(i=1;i<=3;i++) {for(j=1;j<=3;j++) {tarr[i,j]=i*j;print i,"*",j,"=",tarr[i,j]}}}'

    展开后如下:
    awk 'BEGIN{
      for(i=1;i<=3;i++) {
          for(j=1;j<=3;j++) {
              tarr[i,j]=i*j;
              print i,"*",j,"=",tarr[i,j]
          }
        }
      }'
}