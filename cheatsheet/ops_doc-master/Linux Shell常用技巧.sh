第0章 Bash One line 
    !$：上一条命令的最后一个单词
    # 双引号引用中除了 $ 、 ` 、 \ 、 ! , 其他特殊字符的意义都被屏蔽  
    shell内置变量:
    1. IFS read命令也是用它来分割单词
    2. LANG LANG=C sort
    3. PATH 可执行文件的搜索路径
    # http://www.catonmat.net/blog/bash-one-liners-explained-part-one/
  1. 输出用echo和printf，输入用read和$()；
  > 覆盖输出到文件                     >>追加输出到文件
  < 从文件读取                         cmd_read< <(cmd_output) 命令输出关联到命令输入 == 管道输出输入
  产生标准输出的进程 <(group command)  吸纳标准输入的命令 >(group command)
    1.1 输入重定向 [n]<单词
    read line < file              # 输入重定向操作符< file打开并读取文件file，然后将它作为read命令的标准输入。
    > file                        # 如果文件不存在则先创建；如果文件存在则将其大小截取为0。
1. Create specified file if it does not exist. 
2.Truncate (remove files content) 
3. Write to file

    1.2 输出重定向 [n] > [1]单词
    echo "some string" > file     # 如果文件不存在创建一个包含指定内容的文件；如果文件存在替换文件为指定内容，
    echo "foo bar baz" >> file    # 如果文件不存在则先创建它，然后将其追加到文件内容之后，结尾紧跟着换行符。
    echo -n "foo bar baz" >> file # 不追加换行符
Append >>
1. Create speciﬁed ﬁle if it does not exist. 1.
2. Append ﬁle (writing at end of ﬁle).

    1.3 read -[ers] [-a 数组名称] [-d 分隔符] [-i 文本] [-n 字符数] [-p 提示符] [-t 超时时间] [文件...]
    read -r line < file           # 读取文件的首行并赋值给变量
    # -r选项保证读入的内容是原始的内容，意味着反斜杠转义的行为不会发生。
    # < file 打开文件file作为read命令的标准输入
    
    # read命令会删除包含在IFS变量中出现的所有字符，Bash 根据IFS中定义的字符来分隔单词。IFS(Internal Field Separator)
    # 默认情况下，IFS包含空格，制表符和回车，这意味着开头和结尾的空格和制表符都会被删除。如果你想保留这些符号，可以通过设置IFS为空来完成
    IFS= read -r line < file
    line=$(head -1 file) # line=`head -1 file` 优先使用$(...) 此方式更清晰和容易嵌套
    1.4 while 只要测试命令返回零就执行命令块。其返回值是命令块中最后一个被执行的命令的返回值。如果命令块没有被执行则返回零。
    # 依次读入文件每一行
    # 如果指定该选项，则反斜杠就不是转义字符，而是文本的一部分。特别的，一对反斜杠和换行符不是续行符。
    # read返回失败: 1. 读取到文件结尾，2，读超时， 3. 无效的文件描述符，
    while read -r line; do  # while IFS= read -r line ; done 相比保留行头和行尾空格和制表符空白
      # do something with $line 
    done < file
    cat file | while IFS= read -r line; do # 如果你不想将< file放在最后，可以通过管道将文件的内容输入到 while 循环中
      # do something with $line 
    done
    管道和输入流重定向具有相似功能。
    1.5 <输入重定向 <( 进程替换  $() 命令替换
    # 随机读取一行并赋值给变量   <(...)-替换过程：创建一个匿名管道，连接到程序的标准输出，
    read -r random_line < <(shuf file)
    read -r random_line < <(sort -R file) # -R选项可以随机排序文件
    random_line=$(sort -R file | head -1) # -R选项可以随机排序文件
    
  2. 输出 管道 read 与 进程代替 
    echo 'foo' | read 
    echo $REPLY
    # REPLY的内容总是空的，因为read命令是在子shell中执行的，并且当子shell终止的时候，REPLY的拷贝也遭到了破坏。
    # 产生标准输出的进程 <(list) 
    # 吸纳标准输入的命令 >(list)
    read < <(echo "foo") 
    echo $REPLY
    # 通过使用echo查看扩展结果，可以看到文件/dev/fd/63正为子shell提供输出。
    echo <(echo "foo") # /dev/fd/63
    2.1 throwaway 剩下部分
    # 读取文件首行前三个字段并赋值给变量; 根据IFS环境变量分割单词； 第一个单词放到第一个变量，第二个单词放到第二个变量，
    # 剩余所有内容放到最后一个变量。
    while read -r field1 field2 field3 throwaway; do  # throwaway变量，否则的话，当文件的一行大于三个字段时，第三个变量的内容会包含所有剩余的字段。
      # do something with $field1, $field2, and $field3 
    done < file
    2.2 _ 占位符
    # 为了书写方便，可以简单地用_来替换throwaway变量
    while read -r field1 field2 field3 _; do 
      # do something with $field1, $field2, and $field3 
    done < file
  3. 进程代替+read 和 [n]<<< word # word-字符串支持{} ~ 参数和变量扩展，命令替换，算术扩展和引用消除
    3.1 把进程输出结果赋值给变量的方式: <(通过read赋值给变量，单行，能分字段) 和 $(多行，不分字段) 
    read lines words chars _ < <(wc file-with-5-lines) # 保存lines words chars
    # COMMAND <<< $WORD ： WORD作为COMMAND命令的标准输入，被bash解析 -> http://www.tldp.org/LDP/abs/html/x17837.html
    info="20 packets in 10 seconds"
    packets=$(echo $info | awk '{ print $1 }')  # 10
    time=$(echo $info | awk '{ print $4 }')     # 20
    3.2 <<< here-string，将字符串作为流输出，即 从字符串到流。
    read packets _ _ time _ <<< "$info"         # packets=10 time=20
    
    wc -c < file # wc -c file 第一个只返回长度{67434}，第二个返回长度和文件名{67434 file}
    size=$(wc -c < file) # 保存文件的大小到变量
    3.3 ${##%%//:::-:+:?} 参数扩展
    filename=${path##*/}  # 从文件路径中获取文件名  ${var##pattern}
    dirname=${path%/*}    # 从文件路径中获取目录名  ${var%pattern}

---- Here document, here string, 进程替换 ----
STRING="hello"
string="world"
cat <<<${STRING} <<<${string}  # world
cat <<<${STRING} <<<${string} <<<${STRING} # hello
cat <<<${STRING} <<-EOF
beijing
EOF
# beijing
dc <<< '4k 4 3 / p' # 1.3333
dc << EOF
1 1 +
3 *
p
EOF
# 6

string="vlan.txt"
ls <<<"$string"      # 打印当前目录所有内容
echo "$string" | ls  # 打印当前目录所有内容
wc <<<"$string"      #      1       1       9
echo "$string" | wc  # 1 1 9

ls -l <(true) # /dev/fd/63 -> pipe:[131400]
---- Here document, here string, 进程替换 ----

  4. {} 扩展 -- 用来生成字符串的; 如果括号中间是".."，则生成连续字符
    4.1 大括号扩展 {..} 枚举序列
    cp /path/to/file{,_copy} # cp /path/to/file /path/to/file_copy 
    mv /path/to/file{,_old}  # mv /path/to/file /path/to/file_old
    4.2 大括号扩展 {..} 连续序列
    echo {a..z}              # 生成从 a 到 z 的字母表
    printf "%c" {a..z}       # 生成从 a 到 z 的字母表，字母之间不包含空格，无换行
    4.3 printf命令之后指定一个列表，最终它会循环依次打印每个元素，直到完成为止。
    printf "%c" {a..z} $'\n' # 生成从 a 到 z 的字母表，字母之间不包含空格，有换行
    echo $(printf "%c" {a..z}) # ... 有换行
    printf -v alphabet "%c" {a..z} # 将格式化的字符串赋值给alphabet变量
    printf "%c\n" {a..z}     # 每一行仅输出一个字母，在字符后面增加一个换行符
    4.4 连续序列和seq
    echo {1..100}            # seq 1 100
    printf "%02d " {0..9}    # echo {00..09}  seq -w 1 10
    echo {w,t,}h{e{n{,ce{,forth}},re{,in,fore,with{,al}}},ither,at} # 生成 30 个英文单词， 不推荐使用
    echo {a,b,c}{1,2,3} # a1 a2 a3 b1 b2 b3 c1 c2 c3
    4.5 最后
    echo foo{,,,,,,,,,,} # 重复输出 10 次字符串 printf -v dup "%s" foo{,,,,,,,,,,}
  5. 字符串拼接
    5.1 concatenates
    echo "$x$y"           # 拼接字符串 不省略""     "$x$y" 拼接字符串
    var=$x$y              # 拼接字符串 可以省略""   $x$y   命令选项拼接
    var=abc 
    echo $var # abc 
    var+=xxx 
    echo $var # abcxxx    # 拼接字符串 var+=xxx
    5.2 根据分隔符分割
    IFS=- read -r x y z <<< "$str" # str="foo-bar-baz"
    IFS=- read -ra parts <<< "foo-bar-baz" # -a 选项告诉read命令将分割后的元素保存到数组parts中
    
    awk '{print $2}' <<< "hello world - how are you?"
    awk '{print $1}' <<< "hello how 
    are you"
    
    while IFS=" " read -r word1 word2 rest
    do
    echo "$word1"
    done <<< "hello how are you - i am fine"
    
    # -n1让read命令依次读入一个字符，类似地，-n2说明每次读入两个字符。
    5.3 按照字符处理字符串 read -n 字节数
    while IFS= read -rn1 c; do 
      # do something with $c 
    done <<< "$str"
    5.4 替换
    echo ${str/foo/bar} # 将字符串中的 foo 替换成 bar
  6. bash 通配符
    6.1 bash 模式匹配
    if [[ "$file" = *.zip ]]; then  # 检查字符串是否匹配模式
      # do something 
    fi
    # 通配符包括* ? [...]。其中，
    # * 匹配任何字符串，包括空字符串 
    # ? 只能匹配单个字符，
    # [...]能够匹配任意出现在中括号里面的字符或者一类字符集。
    # [abc] [a-c] [^a-c]or[!a-c]  [[:digit:]]
    
    if [[ $answer = [Yy]* ]]; then 
      # do something 
    fi
    
    for file in /proc/[0-9]* ; do echo "$file" ; done # {}扩展
    for i in {1..5}                                   # {}扩展
    for i in {0..10..2}                               # {}扩展
    for filename in "$@"; do ; do echo "$file" ; done # 数组序列
    for i in 1 2 3 4 5                                # 枚举
    for i in $(seq 1 2 20)                            # 执行命令
    for arg [in words] ; do command ; done
    # 为列表中的每个成员执行命令。
    # for循环为列表中的每个成员执行一系列的命令。如果没有`in WORDS ...;'则假定使用 in "$@"。
    # 扩展words或者执行命令一次。如果没有[in words]则认为位置变量。
    
    for (( c=1; c<=5; c++ ))  # 数值计算
    for (( ; ; ))             # 数值计算
    
    if [[ "$answer" = [Yy]* ]]; then 
      # do something 
    fi
    6.2 正则表达式匹配
    if [[ "$str" =~ [0-9]+\.[0-9]+ ]]; then  # 检查字符串是否匹配某个正则表达式  man 3 regex
      # do something 
    fi
    BASH_REMATCH 是匹配结果数组，所有匹配内容被放置到数组中。
    # bash 4以下使用。tr命令就可以
    declare -u var  # var="foo bar" -> FOO BAR 转换成小写; -u使变量拥有转换引用内容为全部大写的属性 Uppercase a string
    declare -l var  # var="FOO BAR" -> foo bar 转换成大写; -l使变量拥有转换引用内容为全部小写的属性 Lowercase a string
  7. exec和重定向 -- &指示不要把1当作普通文件,而是fd=1即标准输出来处理
    # man 3 exec
    7.1 创建，关闭，写入，读出，复制，重定向
    command >file   # command 1>file
    command 2> file # 重定向命令的 stderr 到文件
    command &>file  # 重定向命令的 stdout 和 stder 到同一个文件中；   简化方式；等同 command >&file
    command >file 2>&1 # 重定向命令的 stdout 和 stder 到同一个文件中  通用方式；2>&1,将stderr复制一份给stdout
    command > /dev/null # 丢弃命令的 stdout 输出
    command >/dev/null 2>&1 # 丢弃命令的 stdout stderr 输出
    command &>/dev/null     # 丢弃命令的 stdout stderr 输出
    command <file # 重定向文件到命令的 stdin
    
    7.2 < file 相当于给read传递一个输入流描述符
    read -r line < file
    7.3 重定向
    exec 2>file # 将bash的错误输出，重定向到file文件中
    7.4 创建读
    exec 3<file # 打开3作为文件描述符，bash将有一个文件描述符3
    7.5 使用，-u 选项 和 <&3 作为管道
    read -u 3 line # 从文件描述符3中读取数据
    grep "foo" <&3 # 查找文件描述符3中的匹配项
    7.6 关闭
    exec 3>&-      # 关闭文件描述符3
    7.7 创建写
    exec 4>file
    7.8 写入
    echo "foo" >&4
    7.9 关闭
    exec 4>&-
    7.10 创建读写
    exec 3<>file
    exec 4>&3 # 赋值
    exec 4>&3- # 赋值给4，关闭3
    
<<[-]单词
即插即用文本
单词
1. 单词不会进行参数扩展，命令替换，算术扩展，或文件名扩展。
2. 如果单词中任一字符被引用，则结束符是单词进行引用去除后的结果，这时不会对即插即用文本进行扩展。
3. 如果单词没有被引用，则即插即用文本中的所有行都会进行参数扩展、命令替换、和算术扩展；
4. 如果重定向运算符是"<<-"，则输入行和结束符所在行中所有的在行开头的制表符都会被删除。
    # <<MARKER here-document
    command <<EOL # 重定向一堆字符串到命令的 stdin
you
here
EOL
    command <<-EOL # <<-EOL可以抑制输出时前边的tab(不是空格). 这可以增加一个脚本的可读性.
    your
    here
EOL
    command <<'EOL' # 关闭参数替换
$you
$here
EOL
    command <<\EOL # 关闭参数替换
$you
$here
EOL
# 创建文件
cat << EOF > foo.sh 
printf "%s was here" "$name" 
EOF
cat >> foo.sh <<EOF 
printf "%s was here" "$name"
EOF
    command <<< "foo bar baz"     # 重定向一行文本到命令的 stdin
    
OUTFILE=$(ls -l | grep -v total)
while read line
do
    all="$all $line"
    echo $line
done <<EOF
$OUTFILE
EOF

ssh -p 21 example@example.com <<EOF
  echo 'printing pwd'
  echo "\$(pwd)"
  ls -a
  find '*.txt'
EOF

ssh -p 21 example@example.com <<'EOF'
  echo 'printing pwd'
  echo "$(pwd)"
  ls -a
  find '*.txt'
EOF

cat <<- EOF
    This is some content indented with tabs `\t`.
    You cannot indent with spaces you __have__ to use tabs.
    Bash will remove empty space before these lines.
    __Note__: Be sure to replace spaces with tabs when copying this example.
EOF

sudo -s <<EOF
  a='var'
  echo 'Running serveral commands with sudo'
  mktemp -d
  echo "\$a"
EOF

sudo -s <<'EOF'
  a='var'
  echo 'Running serveral commands with sudo'
  mktemp -d
  echo "$a"
EOF
    echo "foo bar baz" | command  # 重定向一行文本到命令的 stdin
    exec 2>file                   # 重定向所有命令的 stderr 到文件中
    exec 3<file                   # 打开文件并通过特定文件描述符读
    read -u 3 line                # -u fd ：从文件描述符 FD 中读取，而不是标准输入
    grep "foo" <&3                # 相当当
    exec 3>&-                     # 关闭该文件
    exec 4>file                   # 打开文件并通过特定文件描述符写
    echo "foo" >&4                # 
    exec 4>&-                     # 关闭该文件
    exec 3<>file                  # 打开文件并通过特定文件描述符读写
  8. 组命令 子shell和父shell之间可以用过fifo进行通信
    (command1; command2) >file    # 重定向一组命令的 stdout 到文件中
   { ... ... } > $LOGFILE 2>&1
  9. mkfifo 和 tcp|udp 
    # 在 Shell 中通过文件中转执行的命令
    # 打开两个 shell，在第一个中执行以下命令：
    mkfifo fifo # mkfifo -m 0644 fifo 或者 mknod fifo p -- 1. 创建
    exec < fifo
    # 而在第二个中，执行：
    exec 3> fifo;
    echo 'echo test' >&3
# 命名管道可以被多个进程打开同时读写，当多个进程通过 FIFO 交换数据时，
# 内核并没有写到文件系统中，而是自己私下里传递了这些数据。
    ls -l fifo # 2. 查看
    rm fifo    # 3. 删除
    cat fifo   # 
    echo hello world > /tmp/pipe  # 4. 写入
    cat /tmp/piple                # 5. 读取
    
    # 通过 Bash 访问 Web 站点
    exec 3<>/dev/tcp/www.google.com/80  # Bash 将/dev/tcp/host/port当作一种特殊的文件，它并不需要实际存在于系统中，这种类型的特殊文件是给 Bash 建立 tcp 连接用的。
    echo -e "GET / HTTP/1.1\n\n" >&3    # 写入GET / HTTP/1.1\n\n
    cat <&3                             # 
    9.2 noclobber 对覆盖文件的告警
    set -o noclobber   # 重定向输出时防止覆盖已有的文件
    program > file 
    bash: file: cannot overwrite existing file
    program >| file    # 如果你100%确定你要覆盖一个文件，可以使用>|重定向操作符
    
    9.3 管道和重定向
    command1 | command2      # 把command1的输出通过管道连接到command2的输入
    command1 |& command2     # 重定向进程的标准输出和标准错误到另外一个进程的标准输入
    command1 2>&1 | command2 # 重定向进程的标准输出和标准错误到另外一个进程的标准输入
    9.4 将command的标准输出传递个stdout_cmd，将command的错误输出传递给stderr_cmd
    command >>(stdout_cmd) 2>>(stderr_cmd) # 重定向标准输出和标注错误输出给不同的进程
    9.5 PIPESTATUS 管道命令执行错误列表
    echo 'pants are cool' | grep 'moo' | sed 's/o/x/' | awk '{ print $1 }'  # 获得管道流中的退出码
    echo ${PIPESTATUS[@]} 
    0 1 0 0
    9.6 交换标准出错和标准输出
    command 3>&1 1>&2 2>&3
    rm ~/.bash_history # 删除所有历史命令
    unset HISTFILE     # HISTFILE=/dev/null 停止记录历史命令
    HISTFILE=~/docs/shell_history.txt # 重定向历史命令到shell_history.txt
    
10 . {} ()
  (cd $path, do something) 可以让不切换当前目录而在其它目录干点别的事儿 # ( COMMAND [; ...] ) 把输出末尾的所有换行符都吃掉，
  () 数组的赋值：  比如a=(1 3 5)，那么${a[0]}=1;${a[1]}=3;${a[2]}=5，需要注意的是，下标是从0开始的。
  (( 表达式 )) 估值算术表达式：表达式按照算术法则进行估值。等价于 "let 表达式". #估值为0则返回 1；否则返回0。 $?状态值，用于判断
  <() 和 >() 进程替换，可以把命令的执行结果当成文件一样读入
    comm <(sort 1.lst) <(sort 2.lst)
    paste <(cut -t2 file1) <(cut -t1 file1)
  $(()) 表达式扩展 # 标准输出数值，用于计算
    和(())很相似，但是这个是有点不同，$(())不能直接$((b++))，例如：b=1;echo $((++b))
  $[] 是 $(()) 的过去形式，现在已经不建议使用。
  
第0章 test   http://mywiki.wooledge.org/CategoryShell
    case [string] in [glob pattern]) [command list];; [glob pattern]) [command list];; esac
    [[ [string] = "[string]" ]]             # matches 表达式按照 `test' 内嵌的相同条件组成
    [[ [string] = [glob pattern] ]]         # GLOB 
        [[ "abc def .d,x--" == a[abc]*\ ?d* ]]; echo $? # 0
        [[ "abc def c" == a[abc]*\ ?d* ]]; echo $?      # 1
        [[ "abc def d,x" == a[abc]*\ ?d* ]]; echo $?    # 1
        [[ "abc def d,x" == a[abc]*\ ?d* || (( 3 > 2 )) ]]; echo $? # 0
        [[ "abc def d,x" == a[abc]*\ ?d* || 3 -gt 2 ]]; echo $?     # 0
        [[ "abc def d,x" == a[abc]*\ ?d* || 3 > 2 ]]; echo $?       # 0
        [[ "abc def d,x" == a[abc]*\ ?d* || a > 2 ]]; echo $?       # 0
    [[ [string] =~ [regular expression] ]]  # REGEX 
    [ and test 命令                         # 不推荐  除了模式匹配和正则表达式匹配时需要使用[[]]，其余时候建议使用[ ]。
    [[ ]]                                   # 不支持命令执行{if}和数字判断{((数字判断))} 支持"&&"、"||"、"!"和"()"
    1. 像(( ))一样复合命令[[ ]]允许你使用更自然的语法对文件或字符串进行测试。你也可以通过括号和逻辑操作符连接多个测试。
    [[ ( -d "$HOME" ) && ( -w "$HOME" ) ]] && echo "home is a writable directory"
   (( [arithmetic expression] )):          # 数值计算和数字判断
    1. 复合命令(( ))计算一个算术表达式的值，并且当运算结果为０时，设置返回的状态为１，运算结果为非０的值时则设置返回状态为０。
    2. 同时你也不必转义((和))之间的操作符号。支持整数的四则运算。被０除会导致错误，但是不会溢出。
    3. 你也可以在其中运行 usual C 形式的算术表达式、逻辑和移位操作。
    4. let 命令也可以运行一个或多个算术表达式。它常常用来给算术变量赋值。
    let x=2 y=2**3 z=y*3; echo $? $x $y $z               # 0 2 8 24
    (( w=(y/x) + ( (~ ++x) & 0x0f ) )); echo $? $x $y $w # 0 3 8 16
    (( w=(y/x) + ( (~ ++x) & 0x0f ) )); echo $? $x $y $w # 0 4 8 13

    if [command list]; then [command list]; elif [command list]; then [command list]; else [command list]; fi
    while [command list], and until [command list]
    
    [command] "$( [command list] )", [command] "` [command list] `" # 命令扩展 
    [command] <([command list]) # Process substitution
    [command] >([command list]) # Process substitution
    
    [ ]，test expr和[ expr ] # 是内嵌命令 "test" 的同义词，但是最后一个参数必须是字符 `]'，以匹配起始的 `['。
        [ "abc" \< "def" ];echo $? # 0 
        [ "abc" \> "def" ];echo $? # 1 
        [ "abc" \< "abc" ];echo $? # 1 
        [ "abc" \> "abc" ];echo $? # 1
    [] 只送一个参数进去的话是判断字符串长度是否为零
    <和>这两个符号同时也是用来做 shell 重定向，所以你必须通过\<和\>对其转义。
第0章 bash之花括号展开 set +B | set -B
  http://blog.csdn.net/astrotycoon/article/details/50886676
  Brace Expansion                      # 花括号扩展 
  brace值得就是"{ }"。该扩展是用来生成字符串的; 如果括号中间是".."，则生成连续字符
    可以让bash生成任意字符串的一种扩展功能。"路径扩展"非常相似，不同的是生成的字符串可以是不存在的路径或者文件名。
    1. 诸多扩展中的优先级最高
    echo {a,b}$PATH的语句在完成花括号扩展之后的结果应该为a$PATH b$PATH，而对PATH环境变量的扩展需要到后续的"参数和变量扩展"阶段才开始
    2. 第一类格式为：
          preamble+{string1,string2,...,stringN}+postscript
      2.1 左右的花括号是必须的，中间的字符串列表分别由逗号隔开，注意逗号前后不能有空格，如果string中有空格，则需要用单引号或者双引号括起来。
      bash在实际扩展时，会将preamble和花括号种的所有字符串（按照从左到右的顺序）相连，最后分别加上postscript。
      2.2 花括号中间至少有一个逗号，否则bash不会认为这是括号扩展
      echo {money}           # {money}
      echo {money,}          # money
      echo sp{el,il,al}l     # spell spill spall
      echo sp{el,il, al}l    # sp{el,il, al}l
      echo sp{el,il," al"}l  # spell spill sp all
      echo sp{el,il,' al'}l  # spell spill sp all
      echo sp{el,il," "al}l  # spell spill sp all
      echo sp{el,il,' 'al}l  # spell spill sp all
    3. 第二类格式为：
        preamble+{<START>..<END>[..<INCR>]}+postscript
        3.1 <START>..<END>组合而成的表达式术语叫做序列表达式（sequence expression），表示一个特定的范围
        3.2 当<START>和<END>是数字时，代表的是数字范围
        3.3 当<START>和<END>是单个字母时，代表的是字符范围（默认LC_ALL字符排序）
        <START>和<END>必须同为数字或者字母，否则bash不认为是花括号扩展，而是原样输出。
        echo {0..12} # 0 1 2 3 4 5 6 7 8 9 10 11 12
        echo {3..-2} # 3 2 1 0 -1 -2
        echo {a..g}  # a b c d e f g
        echo {g..a}  # g f e d c b a
        <INCR>是可选的，代表的是区间范围的递增数，它必须是数字
        echo {0..10..2} # 0 2 4 6 8 10
        从0开始，每递增2个数字就取出相应数字。
        如果不指定<INCR>，那么默认是1或者是-1，具体是1还是-1，
        
        当x和y为整数时，整数的前面可添加一个0，用以限定整数的宽度，高位不足时用0补齐，
        最终扩展为包括x和y的从较小值到较大值之间的一系列值。
        echo a{01..10..2}z; # a01z a03z a05z a07z a09zz
    4. 组合使用花括号扩展
        echo {a..z}{0..9}
    5. 可以嵌套使用花括号扩展
        echo {{A..Z},{a..z}}
    我们可以通过使用set +B来关闭花括号扩展功能，相反的，用set -B使能该功能。
  Tilde Expansion                      # 波浪号扩展 
  一个单词以未被引用的波浪号"~"开头
    tilde值得就是"~"    "$HOME" # ~/foo 扩展为"$HOME/foo"
                 "~+"   "$PWD"
                 "~-"   "$OLDPWD"
    cd ~root   # 当它后跟用户名时，代表是该用户的家目录，当它后跟以"/"开头的路径时，代表是当前用户的家目录
    echo ~svn  # 存在svn用户则，输出/home/svn 否则输出 ~svn 
    
    还可以使用整数进行目录栈（对应的内建命令为pushd、popd、dirs）扩展
    ~N 命令"dirs +N"显示的字符串 
    ~+N 命令"dirs +N"显示的字符串 
    ~-N 命令"dirs -N"显示的字符串

  Parameter and and Variable Expansion # 参数和变量扩展
    ${expression} # 参数扩展使用美元符号"$"进行引导，参数一般放在一对未被引用的大括号内
    当出现以下情况时候'}'不会被检查来匹配：
    1. 在转义字符\之后，如\{；
    2. 在引号里面，如'}'；
    3. 在算术表达式，命令替换或者变量扩展里面的，如${value}
    ${parameter:-word}
    ${parameter:=word}
    ${parameter:?word}
    ${parameter:+word}
    ${parameter:offset}
    ${parameter:offset:length}
    ${!prefix*} # 扩展成以prefix为开头的变量名称，同时会使用IFS的第一个变量把他们分隔开
    ${!prefix@} # 扩展成以prefix为开头的变量名称，同时会使用IFS的第一个变量把他们分隔开
    ${!name[@]} # 查询数组下标
    ${!name[*]} # 查询数组下标
    ${#parameter} # 打印parameter的长度，
    ${parameter#word}  #
    ${parameter##word} #
    ${parameter%word}  # 
    ${parameter%%word} # 
    ${parameter/pattern/string}  # 
    pattern匹配的最长部分用字符串取代。
    ${parameter//pattern/string} # 如果pattern以/开头，则所有与之匹配的部分都用字符串取代。
    ${parameter/#pattern/string} # 如果pattern以#开头，则只能与参数扩展后的开头部分匹配。
    ${parameter/%pattern/string} # 如果pattern以%开头，则只能与参数扩展后的结尾部分匹配。
   ${parameter^pattern} ${parameter^}     # 字符^意思是将第一个字符转换成大写字母
   ${parameter^^pattern}  ${parameter^^}  # ^^的意思是将所有的字符转换成大写字母
   ${parameter,pattern}  ${parameter,}    # 字符,意思是将第一个字符转换成小写字母
   ${parameter,,pattern}  ${parameter,,}  # ,,的意思是将所有的字符转换成小写字母
   如果缺省了模式，则pattern当成?，这就是和每个字符都匹配。
   如果参数是带有下标*和@的数组名，则模式删除操作就对数组元素依次进行，扩展的结果就是所得到的数组元素列表。
    1. 间接扩展 
      wang=Wang
      firstname=wang
      echo ${!firstname}jiankun # Wangjiankun
      echo ${firstname}jiankun  # wangjiankun
  Command Substitution                 # 命令置换 
    bash将$()中的单词看做是命令，先将其执行，将执行后的输出原封不动的放在原地，任由bash处理。
    $(command)和`command`
    echo $(($1+val+2+$(date +%m)))
  Arithmetic Expansion                 # 算数扩展 
    在双小括号中可以进行参数扩展、命令替换、以及引号的移除。
    $((expression))
    echo "011==$((011))"     # 011==9
    echo "0x1a==$((0x1a))"   # 0x1a==26
    echo "36#z==$((36#z))"   # 36#Z==35
    echo "36#Z==$((36#Z))"   # 36#Z==35
    echo "37#a==$((37#a))"   # 37#A==10
    echo "37#A==$((37#A))"   # 37#A==36
  Process Substitution
    表面的现象是：重定向是一口入，一口出；而process substitution可以多口入
    ls -l <(true) # /dev/fd/63 -> pipe:[131400]
    ls -l <(true) >(true)
    # /dev/fd/62 -> pipe:[131644]
    # /dev/fd/63 -> pipe:[131642]
    process substitution的<(LIST)和>(LIST)就是一个用文件描述符表示的文件
  Word Splitting                       # 单词分割 
    单词拆分发生在shell扩展中，相关的系统变量为IFS默认值为<space><tab><newline>，
    这些分隔符出现在shell扩展结果的行首或行尾将被忽略，其它地方则作为分隔符把单词分隔开来。
  Pathname Expansion                   # 路径扩展
    noglob -d  禁止用路径名扩展。即关闭通配符。（用set –o可以看到，后面的用shopt可以看到）
    dotglob    bash在文件名扩展的结果中包括以点（.）开头的文件名
    extglob    打开扩展的模式匹配特征: 主要用于Pathname Expansion 路径名扩展
        ?(pattern-list) 匹配0个或者1个pattern-list
        *(pattern-list) 匹配0个或者多个pattern-list
        +(pattern-list) 匹配1个或者多个pattern-list
        @(pattern-list) 匹配1个pattern-list
        !(pattern-list) 匹配不符合pattern-list模式
    nocaseglob 如果设置，当执行文件名扩展时，bash在不区分大小写的方式下匹配文件名
    nullglob   如果设置，bash允许没有匹配任何文件的文件名模式扩展成一个空串，而不是它们本身 # 遍历空目录有差异
        shopt nullglob #  nullglob        off
        mkdir tmp
        cd tmp
        for i in *; do echo "file: $i"; done # file: * 这里把通配符*作为字符输出了
        shopt -s nullglob
        shopt nullglob # nullglob        on
        for i in *; do echo "file: $i"; done # null string，没有结果输出
    failglob   如果pattern没有匹配到任意一个结果，则提示出错。
        shopt failglob # failglob        off
        for i in *; do echo "file: $i"; done #  file: *
        echo $? # 0
        shopt -s failglob
        for i in *; do echo "file: $i"; done #  -bash: no match: * 
        echo $? # 1
    globstar **递归的匹配了所有文件和目录， 如果**后面跟着/(即是**/)，则只匹配目录。
             默认情况下，globstar是关闭的，也就是**与*是一样的
             
  1. 优先级顺序为：brace expansion, tilde expansion, parameter, variable expansion, arithmetic expansion, command substitution , word splitting, pathname expansion
  2. 上述扩展如果没有双引号扩起来, 扩展完后, shell将会对结果用IFS进行单词分割
     str="a         b          c"
     echo $str # a b c
     echo "$str" # a         b          c
     没加双引号时, shell会对扩展结果进行单词分割,
  3. >大括号扩展，单词扩展以及文件名扩展在扩展时能够改变单词的数目，
     >其它的扩展都是单个单词扩展成单个单词，
     >唯一例外的是对"$@"和"${array[@]}"的扩展，所有扩展完成后再进行引用去除。
第0章 bash之通配符  shopt -s extglob 
  http://blog.csdn.net/astrotycoon/article/details/50814031
  文件名扩展中的模式匹配知识点。
  bash发现参数部分有这些特殊字符时，会扩展这些符号，生成相应的已存在的文件名或者目录名，最后经过排序后传递给命令。
    ?、*和[set]是最常见的特殊模式字符，在几乎所有的shell中都支持
    1. 关于特殊模式字符*，bash有个选项globstar来控制连续两个星号的行为，即出现**的情况：
        shopt -u globstar
    但是一旦enable（shopt -s globstar），那么**就会递归匹配所有的文件和目录，而**/仅会递归匹配所有的目录。
    ls +(ab|def)*.+(jpeg|gif) # 列出当前目录下以"ab"或者"def"打头的JPEG或者GIF文件
    ls ab+(2|3).jpg           # 列出当前目录下匹配与正则表达式ab(2|3)+\.jpg相同匹配结果的所有文件
    rm -rf *!(.jpeg|.gif)     # rm -rf !(*.jpeg|*.gif)
第0章 bash之参数扩展 
  # http://blog.csdn.net/astrotycoon/article/details/78109827
  参数:变量 variables 位置参数 Positional Parameters  特殊参数 Special Parameters
    ${parameter:offset}
    ${parameter:offset:length}
    子串扩展的意思是从offset位置开始截取长度为length的子串，如果没有提供length，则是从offset开始到结尾。需要注意的几点是：
    如果offset是个负值，开始位置是从字符串末尾开始算起，然后取长度为length的子串。例如，-1代表是从最后一个字符开始。
    如果length是个负值，那么length的含义不再代表字符串长度，而是代表另一个offset，位置从字符串末尾开始，扩展的结果是offset ~ length之间的子串。
    如果parameter是@，也就是所有的位置参数时，offset必须从1开始。
    MYSTRING="Be liberal in what you accept, and conservative in what you send"
    echo ${MYSTRING:34}      # conservative in what you send
    echo ${MYSTRING:34:13}   # conservative
    echo ${MYSTRING: -10:5}  # t you
    echo ${MYSTRING:(-10):5} # t you
    echo ${MYSTRING:11:-17}  # in what you accept, and conservative
第0章 step by step
    比较常见:
    echo abcdee | grep -q abcd 
    if [ $? -eq 0 ]; then 
      echo "Found" 
    else 
      echo "Not found" 
    fi
    简洁的写法：
    if echo abcdee | grep -q abc; then
      echo "Found"
    else
      echo "Not found"
    fi
    可读性比较差:
    echo abcdee | grep -q abc && echo "Found" || echo "Not found"

  比较常见：
  grep "abc" test.txt 1>/dev/null 2>&1
  常见的错误写法：
  grep "abc" test.txt 2>&1 1>/dev/null
  简洁的写法：
  grep "abc" test.txt &> /dev/null

    常见的写法：
    sudo xm li | grep vm_name | awk '{print $2}'
    简洁的写法：
    sudo xm li | awk '/vm_name/{print $2}'

  sed ':a;$!N;s/\n/,/;ta' /tmp/test.txt # 将一个文本的所有行用逗号连接起来
  paste -sd, /tmp/test.txt              # 将一个文本的所有行用逗号连接起来
  
    grep '10.0.0.1\>' /tmp/ip.list        # grep查找单词
    grep -w '10.0.0.1' /tmp/ip.list       # grep查找单词

  常见的写法是：
  arg=$1
  if [ -z "$arg" ]; then
   arg=0
  fi
  简洁的写法是这样的:
  arg=${1:-0}

    echo 'abc-i' | grep "\-i"  # bash中--后面的参数不会被当作选项解析
    echo 'abc-i' | grep -- -i  # bash中--后面的参数不会被当作选项解析

  var=$(printf '%%%02x' 111) #将printf格式化的结果赋值给变量
  printf -v var '%%%02x' 111 #将printf格式化的结果赋值给变量

ls -l /usr/bin/python | awk -F'->' '{print $2}' | tr -d ' ' # 获取软连接指定的真实文件名
readlink /usr/bin/python                                    # 获取软连接指定的真实文件名

echo "${str#?}"   # 删除字符串中的第一个字符
echo "${str%?}"   # 删除字符串中的最后一个字符
echo "${str:1:-1}" # 删除字符串中的第一个或者最后一个字符

# 用双引号比不用更加安全
echo $(ls -l)
echo "$(ls -l)"

sed -n 's/\/home\/kodango\/good/\/home\/kodango\/bye/p' /tmp/test.txt # sed可以更改分隔符，例如使用
sed -n 's#/home/kodango/good#/home/kodango/bad#p' /tmp/test.txt       # 
sed -n '\#/home/kodango/#p' /tmp/test.txt # 如果是在地址对中使用，首个分隔符前面要加反斜杠

第0章 prinf    
  printf ( "format-expression", args )                  # parens optional
  printf ("Total: %d bytes (%d files)\n", n1, n2)       # awk example
  Each %specifier in "quoted part" must have a corresponding parameter in
  the arg list. Most common %specifiers are %s(tring) and %d(ecimal).

SPECIFIERS:                                    FLAGS, WIDTH, & PRECISION
==================                             =========================
 c   ASCII character                           %[flag][width][.precis]specif
 d   decimal integer (converts to integer!)
 i   decimal integer (same; POSIX addition)    FLAGS....
 e   floating point ([-]d.precisione[+-]dd)     nil  |    print flush right|
 E   floating point ([-]d.precisionE[+-]dd)      -   |print flush left     |
 f   floating point ([-]6digit.precision)        SP  prefix %d with SPACE
 g   e or f, shortest, trailing 0's removed      +   prefix nums with + or -
 G   E or f, shortest, trailing 0's removed      0   prefix nums with zeroes
 o   unsigned octal value
 s   string                                    WIDTH: width of total field
 x   unsigned hex num, uses a-f for 10-15
 X   unsigned hex num, uses A-F for 10-15      PRECIS: num of decimal places
 %   literal percent sign                      if %f; num of digits if %d,%i

In the following examples, let %S be length(%s) and %D be length(%d or %i)

If WIDTH   > (%S|%D), the output will be padded with spaces.
If WIDTH  <= (%S|%D), the output will be printed in full (not truncated).
If PRECIS => (%S|%D), the output will be printed in full (not truncated).

If PRECIS  < %S, the string will be truncated on the right.
If PRECIS  < %D, the digits will NOT be truncated

Ex:  printf("[%-7s] [%8.3f] [%+8.3i]", "foo", "12.9", "12.9") ==
     [foo    ] [  12.900] [    +012] ==> %f(loating pt), %i(nteger truncated)
         ^^^^   ^^         ^^^^

Ex:  printf("[%8.3s] [%8.6s]", "abcde", "fghij") ==
     [     abc] [   fghij] ==> WIDTH provides padding, PREC limits chars
      ^^^^^      ^^^
Ex:  printf("[%8.3i] [%8.6i]", "12345.67", "123456789") =
     [   12345] [123456789] ==> integers printed in full, decimals truncated
      ^^^

Ex:  printf("%+*.*f", var1, var2, $3)
     Using the * inserts the value of var1 and var2 for width and precision.
--
Summary by pemente@northpark.edu
    
    
第1章 find  # http://www.cnblogs.com/stephen-liu74/category/326653.html
find(){}
    find pathname -options [-print -exec -ok]
    让我们来看看该命令的参数：
    pathname find命令所查找的目录路径。例如用.来表示当前目录，用/来表示系统根目录。
    -print find命令将匹配的文件输出到标准输出。
    -exec find命令对匹配的文件执行该参数所给出的shell命令。相应命令的形式为'command' {} \;，注意{}和\；之间的空格，同时两个{}之间没有空格,
    注意一定有分号结尾。
    0) -ok 和-exec的作用相同，只不过以一种更为安全的模式来执行该参数所给出的shell命令，在执行每一个命令之前，都会给出提示，让用户来确定是否执行
    find . -name "datafile" -ctime -1 -exec ls -l {} \; 找到文件名为datafile*, 同时创建实际为1天之内的文件, 然后显示他们的明细.
    find . -name "datafile" -ctime -1 -exec rm -f {} \; 找到文件名为datafile*, 同时创建实际为1天之内的文件, 然后删除他们.
    
    find . -name "datafile" -ctime -1 -ok ls -l {} \; 这两个例子和上面的唯一区别就是-ok会在每个文件被执行命令时提示用户, 更加安全.
    find . -name "datafile" -ctime -1 -ok rm -f {} \;
    
    1) find . -name   基于文件名查找,但是文件名的大小写敏感.   
    find . -name "datafile*"
    
    2) find . -iname  基于文件名查找,但是文件名的大小写不敏感.
    find . -iname "datafile*"
    
    3) find . -maxdepth 2 -name fred 找出文件名为fred,其中find搜索的目录深度为2(距当前目录), 其中当前目录被视为第一层.
    
    4) find . -perm 644 -maxdepth 3 -name "datafile*"  (表示权限为644的, 搜索的目录深度为3, 名字为datafile*的文件)
    
    5) find . -path "./rw" -prune -o -name "datafile*" 列出所有不在./rw及其子目录下文件名为datafile*的文件。
    find . -path "./dir*" 列出所有符合dir*的目录及其目录的文件.
    find . \( -path "./d1" -o -path "./d2" \) -prune -o -name "datafile*" 列出所有不在./d1和d2及其子目录下文件名为datafile*的文件。
    
    6) find . -user ydev 找出所有属主用户为ydev的文件。
    find . ! -user ydev 找出所有属主用户不为ydev的文件， 注意!和-user之间的空格。
    
    7) find . -nouser    找出所有没有属主用户的文件，换句话就是，主用户可能已经被删除。
    
    8) find . -group ydev 找出所有属主用户组为ydev的文件。
    
    9) find . -nogroup    找出所有没有属主用户组的文件，换句话就是，主用户组可能已经被删除。
    
    10) find . -mtime -3[+3] 找出修改数据时间在3日之内[之外]的文件。
    find . -mmin  -3[+3] 找出修改数据时间在3分钟之内[之外]的文件。
    find . -atime -3[+3] 找出访问时间在3日之内[之外]的文件。
    find . -amin  -3[+3] 找出访问时间在3分钟之内[之外]的文件。
    find . -ctime -3[+3] 找出修改状态时间在3日之内[之外]的文件。
    find . -cmin  -3[+3] 找出修改状态时间在3分钟之内[之外]的文件。
    
    11) find . -newer eldest_file ! -newer newest_file 找出文件的更改时间 between eldest_file and newest_file。
    find . -newer file     找出所有比file的更改时间更新的文件
    find . ! -newer file 找出所有比file的更改时间更老的文件
    
    12) find . -type d    找出文件类型为目录的文件。
    find . ! -type d  找出文件类型为非目录的文件。
        b - 块设备文件。
        d - 目录。
        c - 字符设备文件。
        p - 管道文件。
        l - 符号链接文件。
        f - 普通文件。
    
    13) find . -size [+/-]100[c/k/M/G] 表示文件的长度为等于[大于/小于]100块[字节/k/M/G]的文件。
    14) find . -empty 查找所有的空文件或者空目录.
    15) find . -type f | xargs grep "ABC"
    使用xargs和-exec的区别是, -exec可能会为每个搜索出的file,启动一个新的进程执行-exec的操作, 而xargs都是在一个进程内完成, 效率更高.
第2章 crontab
crontab(){}
    文件格式如下(每个列之间是使用空格分开的):
    第1列分钟1～59
    第2列小时1～23（0表示子夜）
    第3列日1～31
    第4列月1～12
    第5列星期0～6（0表示星期天）
    第6列要运行的命令
    
    分 时 日 月 星期 要运行的命令
    
    30 21* * * /apps/bin/cleanup.sh
    上面的例子表示每晚的21:30运行/apps/bin目录下的cleanup.sh。
    45 4 1,10,22 * * /apps/bin/backup.sh
    上面的例子表示每月1、10、22日的4:45运行/apps/bin目录下的backup.sh。
    10 1 * * 6,0 /bin/find -name "core" -exec rm {} \;
    上面的例子表示每周六、周日的1:10运行一个find命令。
    0,30 18-23 * * * /apps/bin/dbcheck.sh
    上面的例子表示在每天18:00至23:00之间每隔30分钟运行/apps/bin目录下的dbcheck.sh。
    0 23 * * 6 /apps/bin/qtrend.sh
    上面的例子表示每星期六的11:00pm运行/apps/bin目录下的qtrend.sh。
    
    -u 用户名。
    -e 编辑crontab文件。
    -l 列出crontab文件中的内容。
    -r 删除crontab文件。
    系统将在/var/spool/cron/目录下自动保存名为<username>的cron执行脚本.
    cron是定时完成的任务, 在任务启动时,一般来讲都是重新启动一个新的SHELL, 因此当需要使用登录配置文件的信息,特别是环境变量时,是非常麻烦的.
    一般这种问题的使用方法如下:
    0 2 * * * ( su - USERNAME -c "export LANG=en_US; /home/oracle/yb2.5.1/apps/admin/1.sh"; ) > /tmp/1.log 2>&1
    如果打算执行多条语句, 他们之间应使用分号进行分割. 注: 以上语句必须在root的帐户下执行.
第3章 nohup
nohup(){}
    nohup command &
    如果你正在运行一个进程，而且你觉得在退出帐户时该进程还不会结束，那么可以使用nohup命令。该命令可以在你退出帐户之后继续运行相应的进程。
    Nohup就是不挂起的意思(no hang up)。
第4章 cut
cut(){}
    1) cut一般格式为：cut [options] file1 file2 # cut只擅长处理“以一个字符间隔”的文本内容
    -c list 指定剪切字符数。
    -f field 指定剪切域数。
    -d 指定与空格和tab键不同的域分隔符。
    -c 用来指定剪切范围，如下所示：
    -c1,5-7 剪切第1个字符，然后是第5到第7个字符。
    -c2- 剪切第2个到最后一个字符
    -c-5 剪切最开始的到第5个字符
    -c1-50 剪切前50个字符。
    -f 格式与-c相同。
    -f1,5 剪切第1域，第5域。
    -f1,10-12 剪切第1域，第10域到第12域。
    2) 使用方式：
    cut -d: -f3 cut_test.txt (基于":"作为分隔符，同时返回field 3中的数据) *field从0开始计算。
    cut -d: -f1,3 cut_test.txt (基于":"作为分隔符，同时返回field 1和3中的数据)
    cut -d: -c1,5-10 cut_test.txt(返回第1个和第5-10个字符)
第5章 sort
sort(){}
    1) 对文件内容进行排序，缺省分割符为空格，如果自定义需要使用-t选择，如-t:
    2) 使用分隔符分割后，第一个field为0，awk中为1
    3) 具体用法如下：
    sort -t: sort_test.txt(缺省基于第一个field进行排序，field之间的分隔符为":")
    sort -t: -r sort_test.txt(缺省基于第一个field进行倒序排序，field之间的分隔符为":")
    sort -t: +1 sort_test.txt(基于第二个field进行排序，field之间的分隔符为":")
    sort +3n sort_test.txt(基于第三个field进行排序，其中n选项提示是进行"数值型"排序)
    sort -u  sort_test.txt(去除文件中重复的行，同时基于整行进行排序)
    sort -o output_file -t: +1.2[n] sort_text.txt(基于第二个field,同时从该field的第二个字符开始，这里n的作用也是"数值型"排序,并将结果输出到output_file中)
    sort -t: -m +0 filename1 filename2(合并两个文件之后在基于第一个field排序)
    sort命令行选项：
    -t  字段之间的分隔符
    -f  基于字符排序时忽略大小写
    -k  定义排序的域字段，或者是基于域字段的部分数据进行排序
    -m  将已排序的输入文件，合并为一个排序后的输出数据流
    -n  以整数类型比较字段
    -o outfile  将输出写到指定的文件
    -r  倒置排序的顺序为由大到小，正常排序为由小到大
    -u  只有唯一的记录，丢弃所有具有相同键值的记录
    -b  忽略前面的空格
    
    -t定义了冒号为域字段之间的分隔符，-k 2指定基于第二个字段正向排序(字段顺序从1开始)。
    sed -n '1,5p' /etc/passwd | sort -t: -k 1
    
    还是以冒号为分隔符，这次是基于第三个域字段进行倒置排序。
    sed -n '1,5p' /etc/passwd | sort -t: -k 3r
    
    先以第六个域的第2个字符到第4个字符进行正向排序，在基于第一个域进行反向排序。
    sort -t':' -k 6.2,6.4 -k 1r
    
    先以第六个域的第2个字符到第4个字符进行正向排序，在基于第一个域进行正向排序。和上一个例子比，第4和第5行交换了位置。
    sort -t':' -k 6.2,6.4 -k 1
    
    基于第一个域的第2个字符排序
    sort -t':' -k 1.2,1.2
    
    基于第六个域的第2个字符到第4个字符进行正向排序，-u命令要求在排序时删除 键值 重复的行。
    sort -t':' -k 6.2,6.4 -u users


第6章 pgrep pkill
pgrep(){}
pkill(){}
    查找和杀死指定的进程, 他们的选项和参数完全相同, 这里只是介绍pgrep
    /> sleep 100&
    1000
    /> sleep 100&
    1001
    
    /> pgrep sleep
    1000
    1001
    /> pgrep -d: sleep    # -d定义多个进程之间的分隔符, 如果不定义则使用newline
    1000:1001
    /> pgrep -n sleep    # -n表示如果该程序有多个进程,查找最新的.
    1001
    /> pgrep -o  sleep    # -o表示如果该程序有多个进程,查找最老的.
    1000   
    /> pgrep -G root,oracle sleep # -G 表示进程的group id在-G后面的组列表中的进程会被考虑
    1000
    1001
    /> pgrep -u root,oracle sleep # -u 表示进程的effetive user id在-u后面的组列表中的进程会被考虑
    1000
    1001
    /> pgrep -U root,oracle sleep # -U 表示进程的real user id在-u后面的组列表中的进程会被考虑
    1000
    1001
    /> pgrep -x sleep # -x 表示进程的名字必须完全匹配, 以上的例子均可以部分匹配
    1000
    1001
    /> pgrep -x sle
    
    /> pgrep -l sleep # -l 将不仅打印pid,也打印进程名
    1000 sleep
    1001 sleep
    /> pgrep -lf sleep # -f 一般与-l合用, 将打印进程的参数
    1000 sleep 100
    1001 sleep 100
    
    /> pgrep -f sleep -d, | xargs ps -fp
    UID        PID  PPID  C STIME TTY          TIME CMD
    root      1000  2138  0 06:11 pts/5    00:00:00 sleep 1000
    root      1001  2138  0 06:11 pts/5    00:00:00 sleep 1000
第7章 fuser
fuser(){}
    fuser -m /dev    # 列出所有和/dev设备有染的进程pid.
    fuser testfile    # 列出和testfile有染的进程pid
    fuser -u testfile # 列出和testfile有染的进程pid和userid
    fuser -k testfile # 杀死和testfile有染的进程pid
第8章 fuser
mount(){}
    如何在unix下面mount一个windows下面的共享目录
    mount -t smbfs -o username=USERNAME,password=PASSWORD //windowsIp/pub_directory  /mountpoint  
    /> mkdir -p /mnt/win32
    /> mount -o username=administrator,password=1234 //10.1.4.103/Mine /mnt/win32
    /> umount /mnt/win32        # 卸载该mount.
第9章 netstat  
netstat(){}
　　 -a 表示显示所有的状态
　　 -l 则只是显示listen状态的，缺省只是显示connected
　　 -p 显示应用程序的名字
　　 -n 显示ip、port和user等信息
　　 -t 只显示TCP的连接
　　 /> netstat -apnt
　　 /> netstat -lpnt      #如果只是显示监听端口的状态，可以使用该命令
第10章 tune2fs
tune2fs(){}
　　 调整ext2/ext3文件系统特性的工具

　　 -l 查看文件系统信息
　　 /> tune2fs -l /dev/sda1  #将会列出所有和该磁盘分区相关的数据信息，如Inode等。
　　 /> tune2fs -l /dev/sda1 | grep -i "block size"      #查看当前文件系统的块儿尺寸
　　 /> tune2fs -l /dev/sdb1 | grep -i "mount count"   #查看 mount count 挂载次数
第11章 iptables
iptables(){}
11.  开启或关闭Linux(iptables)防火墙
    重启后永久性生效：
    /> chkconfig iptables on         #开启
    /> chkconfig iptables off         #关闭
    
    即时生效，重启后还原:
    /> service iptables start        #开启
    /> service iptables stop         #关闭  
第12章 tar
tar(){}
12.  tar 分卷压缩和合并
    以每卷500M为例
    />tar cvzpf - somedir | split -d -b 500m    #tar分卷压缩
    />cat x* > mytarfile.tar.gz                      #tar多卷合并
第13章 man
man(){}
13.  把man或info的信息存为文本文件
    /> man tcsh | col -b > tcsh.txt
    /> info tcsh -o tcsh.txt -s
第14章 ps
ps(){}
14.  查看正在执行进程的线程数
    />ps -eo "args nlwp pid pcpu" 

第15章 md5sum
md5sum(){}
15.  使用md5sum计算文件的md5
    /> md5sum test.c
    07af691360175a6808567e2b08a11724  test.c
    
    /> md5sum test.c > hashfile
    /> md5sum –c hashfile     # 验证hashfile中包含的md5值和对应的文件,在执行该命令时是否仍然匹配, 如果此时test.c被修改了,该命令将返回不匹配的警告.
第16章 ps
ps(){}
16.  在ps命令中显示进程的完整的命令行参数
    />ps auwwx
第17章 chkconfig
chkconfig(){}
17. chkconfig：
    1). 编辑chkconfig操作的Shell文件头。
    #!/bin/bash
    #
    # chkconfig: 2345 20 80
    # description: Starts and stops the Redis Server
    这个注释头非常重要，否则chkconfig命令无法识别。其中2345表示init启动的级别，即在2、3、4、5这四个级别中均启动该服务。20表示该脚本启动的优先级，80表示停止的优先级。这些可以在chkconfig的manpage中找到更为详细的说明。
    
    2). 编译Shell文件的内容：
    case "$1" in
    start)
        #TODO: 执行服务程序的启动逻辑。
        ;;
    stop)
        #TODO: 执行服务程序的停止逻辑。
        ;;
    restart)
        ;;
    reload)
        ;;
    condrestart)
        ;;
    status)
        ;;
    上面列出的case条件必不可少，如果确实没有就当做占位符放在那里即可，如上例。
    
    3). 添加和删除服务程序：
    #--add选项表示添加新的服务程序。
    /> chkconfig --add redis_6379
    #查看是否删除或添加成功
    /> chkconfig | grep redis_6379
    redis_6379      0:off   1:off   2:on    3:on    4:on    5:on    6:off
    #--del选项表示删除已有的服务程序。
    /> chkconfig --del redis_6379
第18章 特殊文件: /dev/null和/dev/tty
block(特殊文件: /dev/null和/dev/tty){}
    Linux系统提供了两个对Shell编程非常有用的特殊文件，/dev/null和/dev/tty。其中/dev/null将会丢掉所有写入它的数据，换句换说，当程序将数据写入到此文件时，会认为它已经成功完成写入数据的操作，但实际上什么事都没有做。如果你需要的是命令的退出状态，而非它的输出，此功能会非常有用，见如下Shell代码：
    /> vi test_dev_null.sh
    
    #!/bin/bash
    if grep hello TestFile > /dev/null
    then
        echo "Found"
    else
        echo "NOT Found"
    fi
    在vi中保存并退出后执行以下命令：
    /> chmod +x test_dev_null.sh  #使该文件成为可执行文件
    /> cat > TestFile
    hello my friend
    CTRL + D                             #退出命令行文件编辑状态
    /> ./test_dev_null.sh
    Found                                 #这里并没有输出grep命令的执行结果。
    将以上Shell脚本做如下修改：
    /> vi test_dev_null.sh
    
    #!/bin/bash
    if grep hello TestFile
    then
        echo "Found"
    else
        echo "NOT Found"
    fi
    在vi中保存退出后，再次执行该脚本：
    /> ./test_dev_null.sh
    hello my friend                      #grep命令的执行结果被输出了。
    Found
    
    下面我们再来看/dev/tty的用途。当程序打开此文件是，Linux会自动将它重定向到一个终端窗口，因此该文件对于读取人工输入时特别有用。见如下Shell代码：
    /> vi test_dev_tty.sh
    
    #!/bin/bash
    printf "Enter new password: "    #提示输入
    stty -echo                               #关闭自动打印输入字符的功能
    read password < /dev/tty         #读取密码
    printf "\nEnter again: "             #换行后提示再输入一次
    read password2 < /dev/tty       #再读取一次以确认
    printf "\n"                               #换行
    stty echo                                #记着打开自动打印输入字符的功能
    echo "Password = " $password #输出读入变量
    echo "Password2 = " $password2
    echo "All Done"
    
    在vi中保存并退出后执行以下命令：
    /> chmod +x test_dev_tty.sh #使该文件成为可执行文件
    /> ./test_dev_tty
    Enter new password:             #这里密码的输入被读入到脚本中的password变量
    Enter again:                          #这里密码的输入被读入到脚本中的password2变量
    Password = hello
    Password2 = hello
    All Done
第19章 简单的命令跟踪
block(简单的命令跟踪){}
二.    简单的命令跟踪:
    Linux Shell提供了两种方式来跟踪Shell脚本中的命令，以帮助我们准确的定位程序中存在的问题。下面的代码为第一种方式，该方式会将Shell脚本中所有被执行的命令打印到终端，并在命令前加"+"：加号的后面还跟着一个空格。
    /> cat > trace_all_command.sh
    who | wc -l                          #这两条Shell命令将输出当前Linux服务器登录的用户数量
    CTRL + D                            #退出命令行文件编辑状态
    /> chmod +x trace_all_command.sh
    /> sh -x ./trace_all_command.sh #Shell执行器的-x选项将打开脚本的执行跟踪功能。
    + wc -l                               #被跟踪的两条Shell命令
    + who
    2                                       #实际输出结果。
    Linux Shell提供的另一种方式可以只打印部分被执行的Shell命令，该方法在调试较为复杂的脚本时，显得尤为有用。
    /> cat > trace_patial_command.sh
    #! /bin/bash
    set -x                                #从该命令之后打开跟踪功能
    echo 1st echo                     #将被打印输出的Shell命令
    set +x                               #该Shell命令也将被打印输出，然而在该命令被执行之后，所有的命令将不再打印输出
    echo 2nd echo                    #该Shell命令将不再被打印输出。
    CTRL + D                           #退出命令行文件编辑状态
    /> chmod +x trace_patial_command.sh
    /> ./trace_patial_command.sh
    + echo 1st echo
    1st echo
    + set +x
    2nd echo
第20章 正则表达式基本语法描述
block(正则表达式基本语法描述){}
三.    正则表达式基本语法描述:
    Linux Shell环境下提供了两种正则表达式规则，一个是基本正则表达式(BRE)，另一个是扩展正则表达式(ERE)。
    下面是这两种表达式的语法列表，需要注意的是，如果没有明确指出的Meta字符，其将可同时用于BRE和ERE，否则将尽适用于指定的模式。
BRE 和 ERE 中的元字符
---------------------|----------------|----------------------------
BRE                  |  ERE           |  正则表达式的描述
---------------------|----------------|----------------------------
\ . [ ] ^ $ *        |  \ . [ ] ^ $ * |  通用的元字符
\+ \? \( \) \{ \} \| |                |  BRE 独有的“\”转义元字符
                     |  + ? ( ) { } | |  ERE 独有的不需要“\”转义的元字符
c                    |  c             |  匹配非元字符 “c”
\c                   |  \c            |  匹配一个字面意义上的字符 “c”，即使 “c” 本身是元字符
.                    |  .             |  匹配任意字符，包括换行符
^                    |  ^             |  字符串的开始位置
$                    |  $             |  字符串的结束位置
\<                   |  \<            |  单词的开始位置
\>                   |  \>            |  单词的结束位置
[abc…]               |  [abc…]        |  匹配在 “abc...” 中的任意字符
[^abc…]              |  [^abc…]       |  匹配除了 “abc...” 中的任意字符
r*                   |  r*            |  匹配零个或多个 “r”
r\+                  |  r+            |  匹配一个或多个 “r”
r\?                  |  r?            |  匹配零个或一个 “r”
r1\|r2               |  r1|r2         |  匹配一个 “r1” 或 “r2”
\(r1\|r2\)           |  (r1|r2)       |  匹配一个 “r1” 或 “r2“ ，并作为括号内的正则表达式
---------------------|----------------|----------------------------
    [:alpha:] 	匹配字母字符。 	                                [[:alpha:]!]ab$匹配cab、dab和!ab。
    [:alnum:] 	匹配字母和数字字符。 	                        [[:alnum:]]ab$匹配1ab、aab。
    [:blank:] 	匹配空格(space)和Tab字符。 	                    [[:alnum:]]ab$匹配1ab、aab。
    [:cntrl:] 	匹配控制字符。 	 
    [:digit:] 	匹配数字字符。 	 
    [:graph:] 	匹配非空格字符。 	 
    [:lower:] 	匹配小写字母字符。 	 
    [:upper:] 	匹配大写字母字符。 	 
    [:punct:] 	匹配标点字符。 	 
    [:space:] 	匹配空白(whitespace)字符。 	 
    [:xdigit:] 	匹配十六进制数字。 	 
    \w 	        匹配任何字母和数字组成的字符，等同于[[:alnum:]_] 	 
    \W 	        匹配任何非字母和数字组成的字符，等同于[^[:alnum:]_] 	 
    \<\> 	    匹配单词的起始和结尾。 	\<read匹配readme，me\>匹配readme。
    

    下面的列表给出了Linux Shell中常用的工具或命令分别支持的正则表达式的类型。
            grep 	sed 	vi 	egrep 	awk
    BRE 	* 	    * 	    * 	  	 
    ERE 	  	  	  	         * 	    *
    
    ##正则表达式
    匹配中文字符的正则表达式：[u4e00-u9fa5]
    评注：匹配中文还真是个头疼的事，有了这个表达式就好办了
    
    匹配双字节字符(包括汉字在内)：[^x00-xff]
    评注：可以用来计算字符串的长度（一个双字节字符长度计2，ASCII字符计1）
    
    匹配空白行的正则表达式：^ *$
    评注：可以用来删除空白行
    
    匹配HTML标记的正则表达式：<(S*?)[^>]*>.*?</1>|<.*? />
    评注：网上流传的版本太糟糕，上面这个也仅仅能匹配部分，对于复杂的嵌套标记依旧无能为力
    
    匹配首尾空白字符的正则表达式：^s*|s*$
    评注：可以用来删除行首行尾的空白字符(包括空格、制表符、换页符等等)，非常有用的表达式
    
    匹配Email地址的正则表达式：w+([-+.]w+)*@w+([-.]w+)*.w+([-.]w+)*
    评注：表单验证时很实用
    
    匹配网址URL的正则表达式：[a-zA-z]+://[^s]*
    评注：网上流传的版本功能很有限，上面这个基本可以满足需求
    
    匹配帐号是否合法(字母开头，允许5-16字节，允许字母数字下划线)：^[a-zA-Z][a-zA-Z0-9_]{4,15}$
    评注：表单验证时很实用
    
    匹配国内电话号码：d{3}-d{8}|d{4}-d{7}
    评注：匹配形式如0511-4405222或021-87888822
    
    匹配腾讯QQ号：[1-9][0-9]{4,}
    评注：腾讯QQ号从10000开始
    
    匹配中国邮政编码：[1-9]d{5}(?!d)
    评注：中国邮政编码为6位数字
    
    匹配身份证：d{15}|d{18}
    评注：中国的身份证为15位或18位
    
    匹配ip地址：d+.d+.d+.d+
    评注：提取ip地址时有用
    
一、校验数字的表达式
# 数字：^[0-9]*$
# n位的数字：^\d{n}$
# 至少n位的数字：^\d{n,}$
# m-n位的数字：^\d{m,n}$
# 零和非零开头的数字：^(0|[1-9][0-9]*)$
# 非零开头的最多带两位小数的数字：^([1-9][0-9]*)+(.[0-9]{1,2})?$
# 带1-2位小数的正数或负数：^(\-)?\d+(\.\d{1,2})?$
# 正数、负数、和小数：^(\-|\+)?\d+(\.\d+)?$
# 有两位小数的正实数：^[0-9]+(.[0-9]{2})?$
# 有1~3位小数的正实数：^[0-9]+(.[0-9]{1,3})?$
# 非零的正整数：^[1-9]\d*$ 或 ^([1-9][0-9]*){1,3}$ 或 ^\+?[1-9][0-9]*$
# 非零的负整数：^\-[1-9][]0-9″*$ 或 ^-[1-9]\d*$
# 非负整数：^\d+$ 或 ^[1-9]\d*|0$
# 非正整数：^-[1-9]\d*|0$ 或 ^((-\d+)|(0+))$
# 非负浮点数：^\d+(\.\d+)?$ 或 ^[1-9]\d*\.\d*|0\.\d*[1-9]\d*|0?\.0+|0$
# 非正浮点数：^((-\d+(\.\d+)?)|(0+(\.0+)?))$ 或 ^(-([1-9]\d*\.\d*|0\.\d*[1-9]\d*))|0?\.0+|0$
# 正浮点数：^[1-9]\d*\.\d*|0\.\d*[1-9]\d*$ 或 ^(([0-9]+\.[0-9]*[1-9][0-9]*)|([0-9]*[1-9][0-9]*\.[0-9]+)|([0-9]*[1-9][0-9]*))$
# 负浮点数：^-([1-9]\d*\.\d*|0\.\d*[1-9]\d*)$ 或 ^(-(([0-9]+\.[0-9]*[1-9][0-9]*)|([0-9]*[1-9][0-9]*\.[0-9]+)|([0-9]*[1-9][0-9]*)))$
# 浮点数：^(-?\d+)(\.\d+)?$ 或 ^-?([1-9]\d*\.\d*|0\.\d*[1-9]\d*|0?\.0+|0)$

    匹配特定数字：
    ^[1-9]d*$　　   # 匹配正整数
    ^-[1-9]d*$　    # 匹配负整数
    ^-?[1-9]d*$　　 # 匹配整数
    ^[1-9]d*|0$　   # 匹配非负整数（正整数+ 0）
    ^-[1-9]d*|0$    # 匹配非正整数（负整数+ 0）
    ^[1-9]d*.d*|0.d*[1-9]d*$               # 匹配正浮点数
    ^-([1-9]d*.d*|0.d*[1-9]d*)$　          # 匹配负浮点数
    ^-?([1-9]d*.d*|0.d*[1-9]d*|0?.0+|0)$　 # 匹配浮点数
    ^[1-9]d*.d*|0.d*[1-9]d*|0?.0+|0$　　   # 匹配非负浮点数（正浮点数+ 0）
    ^(-([1-9]d*.d*|0.d*[1-9]d*))|0?.0+|0$  # 匹配非正浮点数（负浮点数+ 0）
    评注：处理大量数据时有用，具体应用时注意修正
    
    匹配特定字符串：
    ^[A-Za-z]+$     # 匹配由26个英文字母组成的字符串
    ^[A-Z]+$        # 匹配由26个英文字母的大写组成的字符串
    ^[a-z]+$        # 匹配由26个英文字母的小写组成的字符串
    ^[A-Za-z0-9]+$  # 匹配由数字和26个英文字母组成的字符串
    ^w+$　　        # 匹配由数字、26个英文字母或者下划线组成的字符串
二、校验字符的表达式
# 汉字：^[\u4e00-\u9fa5]{0,}$
# 英文和数字：^[A-Za-z0-9]+$ 或 ^[A-Za-z0-9]{4,40}$
# 长度为3-20的所有字符：^.{3,20}$
# 由26个英文字母组成的字符串：^[A-Za-z]+$
# 由26个大写英文字母组成的字符串：^[A-Z]+$
# 由26个小写英文字母组成的字符串：^[a-z]+$
# 由数字和26个英文字母组成的字符串：^[A-Za-z0-9]+$
# 由数字、26个英文字母或者下划线组成的字符串：^\w+$ 或 ^\w{3,20}$
# 中文、英文、数字包括下划线：^[\u4E00-\u9FA5A-Za-z0-9_]+$
# 中文、英文、数字但不包括下划线等符号：^[\u4E00-\u9FA5A-Za-z0-9]+$ 或 ^[\u4E00-\u9FA5A-Za-z0-9]{2,20}$
# 可以输入含有^%&’,;=?$\”等字符：[^%&',;=?$\x22]+
# 禁止输入含有~的字符：[^~\x22]+
    
第21章 使用cut命令选定字段
block(使用cut命令选定字段){}
四.    使用cut命令选定字段:
    cut命令是用来剪下文本文件里的数据，文本文件可以是字段类型或是字符类型。下面给出应用实例：
    /> cat /etc/passwd
    root:x:0:0:root:/root:/bin/bash
    bin:x:1:1:bin:/bin:/sbin/nologin
    daemon:x:2:2:daemon:/sbin:/sbin/nologin
    adm:x:3:4:adm:/var/adm:/sbin/nologin
    ... ...
    /> cut -d : -f 1,5 /etc/passwd     #-d后面的冒号表示字段之间的分隔符，-f表示取分割后的哪些字段
    root:root                                 #这里取出的是第一个和第五个字段。
    bin:bin
    daemon:daemon
    adm:adm
    ... ...
    /> cut -d: -f 3- /etc/passwd       #从第三个字段开始显示，直到最后一个字段。
    0:0:root:/root:/bin/bash
    1:1:bin:/bin:/sbin/nologin
    2:2:daemon:/sbin:/sbin/nologin
    3:4:adm:/var/adm:/sbin/nologin
    4:7:lp:/var/spool/lpd:/sbin/nologin
    ... ...    
    这里需要进一步说明的是，使用cut命令还可以剪切以字符数量为标量的部分字符，该功能通过-c选项实现，其不能与-d选项共存。
    /> cut -c 1-4 /etc/passwd          #取每行的前1-4个字符。
    /> cut -c-4 /etc/passwd            #取每行的前4个字符。
    root
    bin:
    daem
    adm:
    ... ...
    /> cut -c4- /etc/passwd            #取每行的第4个到最后字符。
    t:x:0:0:root:/root:/bin/bash
    :x:1:1:bin:/bin:/sbin/nologin
    mon:x:2:2:daemon:/sbin:/sbin/nologin
    :x:3:4:adm:/var/adm:/sbin/nologin
    ... ...
    /> cut -c1,4 /etc/passwd           #取每行的第一个和第四个字符。
    rt
    b:
    dm
    a:
    ... ...
    /> cut -c1-4,5 /etc/passwd        #取每行的1-4和第5个字符。
    root:
    bin:x
    daemo
    adm:x
第22章 计算行数、字数以及字符数
block(计算行数、字数以及字符数){}
五.    计算行数、字数以及字符数:
    Linux提供了一个简单的工具wc用于完成该功能，见如下用例：
    /> echo This is a test of the emergency broadcast system | wc
    1    9    49                              #1行，9个单词，49个字符
    /> echo Testing one two three | wc -c
    22                                         #22个字符
    /> echo Testing one two three | wc -l
    1                                           #1行
    /> echo Testing one two three | wc -w
    4                                           #4个单词
    /> wc /etc/passwd /etc/group    #计算两个文件里的数据。
    39   71  1933  /etc/passwd
    62   62  906    /etc/group
    101 133 2839  总用量
第23章 提取开头或结尾数行
block(提取开头或结尾数行){}
六.    提取开头或结尾数行:
    有时，你会需要从文本文件里把几行字，多半是靠近开头或结尾的几行提取出来。如查看工作日志等操作。Linux Shell提供head和tail两个命令来完成此项工作。见如下用例：
    /> head -n 5 /etc/passwd           #显示输入文件的前五行。
    root:x:0:0:root:/root:/bin/bash
    bin:x:1:1:bin:/bin:/sbin/nologin
    daemon:x:2:2:daemon:/sbin:/sbin/nologin
    adm:x:3:4:adm:/var/adm:/sbin/nologin
    lp:x:4:7:lp:/var/spool/lpd:/sbin/nologin
    
    /> tail -n 5 /etc/passwd             #显示输入文件的最后五行。
    sshd:x:74:74:Privilege-separated SSH:/var/empty/sshd:/sbin/nologin
    mysql:x:27:27:MySQL Server:/var/lib/mysql:/bin/bash
    pulse:x:496:494:PulseAudio System Daemon:/var/run/pulse:/sbin/nologin
    gdm:x:42:42::/var/lib/gdm:/sbin/nologin
    stephen:x:500:500:stephen:/home/stephen:/bin/bash
    如果使用者想查看不间断增长的日志(如服务程序输出的)，可以使用tail的-f选项，这样可以让tail命令不会自动退出，必须通过CTRL+C命令强制退出，因此该选项不适合用于Shell脚本中，见如下用例：
    /> tail -f -n 5 my_server_log
    ... ...
    ^C                                         #CTRL+C退出到命令行提示符状态。
第24章 grep家族
block(grep家族){}
七.　grep家族:
    1.  grep退出状态：
    0: 表示成功；
    1: 表示在所提供的文件无法找到匹配的pattern；
    2: 表示参数中提供的文件不存在。
    
    grep时应该把正则放到引号中(单引号优于双引号)，否则shell将它们作为文件名来解释
    grep的可选项(以下只能3选1)
      -G默认动作，搜索模式作为基本正则来解释
      -E搜索模式作为扩展正则来解释
      -F搜索模式作为简单字符串来解释
    
    fgrep == grep -F
    egrep == grep -E
    使用egrep不需要来转义花括号，加号等
    gerp '[1-9]\{1,2\}' file
    ==
    egrep '[1-9]{1,2}' file

    见如下示例：
    /> grep 'root' /etc/passwd
    root:x:0:0:root:/root:/bin/bash
    operator:x:11:0:operator:/root:/sbin/nologin
    /> echo $?
    0
    
    /> grep 'root1' /etc/passwd  #用户root1并不存在
    /> echo $?
    1
    
    /> grep 'root' /etc/passwd1  #这里的/etc/passwd1文件并不存在
    grep: /etc/passwd1: No such file or directory
    /> echo $?
    2

    2.  grep中应用正则表达式的实例：
    需要说明的是下面所涉及的正则表达式在上一篇中已经给出了详细的说明，因此在看下面例子的时候，可以与前一篇的正则说明部分结合着看。
    /> cat testfile
    northwest        NW      Charles Main           3.0     .98     3       34
    western           WE       Sharon Gray          5.3     .97     5       23
    southwest       SW       Lewis Dalsass         2.7     .8       2       18
    southern         SO       Suan Chin               5.1     .95     4       15
    southeast       SE        Patricia Hemenway    4.0     .7       4       17
    eastern           EA        TB Savage              4.4     .84     5       20
    northeast        NE        AM Main Jr.              5.1     .94     3       13
    north              NO       Margot Weber          4.5     .89     5       9
    central            CT        Ann Stephens          5.7     .94     5       13
    
    
    /> grep NW testfile     #打印出testfile中所有包含NW的行。
    northwest       NW      Charles Main        3.0     .98     3       34
    
    /> grep '^n' testfile   #打印出以n开头的行。
    northwest       NW      Charles Main        3.0     .98     3       34
    northeast        NE       AM Main Jr.          5.1     .94     3       13
    north              NO      Margot Weber      4.5     .89     5       9
    
    /> grep '4$' testfile   #打印出以4结尾的行。
    northwest       NW      Charles Main        3.0     .98     3       34
    
    /> grep '5\..' testfile #打印出第一个字符是5，后面跟着一个.字符，在后面是任意字符的行。
    western         WE      Sharon Gray         5.3     .97     5       23
    southern        SO      Suan Chin             5.1     .95     4       15
    northeast       NE      AM Main Jr.            5.1     .94     3       13
    central           CT      Ann Stephens        5.7     .94     5       13
    
    /> grep '\.5' testfile  #打印出所有包含.5的行。
    north           NO      Margot Weber        4.5     .89     5       9
    
    /> grep '^[we]' testfile #打印出所有以w或e开头的行。
    western         WE      Sharon Gray         5.3     .97     5       23
    eastern          EA      TB Savage            4.4     .84     5       20
    
    /> grep '[^0-9]' testfile #打印出所有不是以0-9开头的行。
    northwest       NW     Charles Main             3.0     .98      3       34
    western          WE      Sharon Gray             5.3     .97     5       23
    southwest       SW     Lewis Dalsass           2.7     .8       2       18
    southern         SO      Suan Chin                5.1     .95     4       15
    southeast        SE      Patricia Hemenway     4.0     .7      4       17
    eastern           EA      TB Savage                4.4     .84     5       20
    northeast        NE      AM Main Jr.                5.1     .94     3       13
    north              NO      Margot Weber           4.5     .89     5       9
    central            CT      Ann Stephens            5.7     .94     5       13
    
    /> grep '[A-Z][A-Z] [A-Z]' testfile #打印出所有包含前两个字符是大写字符，后面紧跟一个空格及一个大写字母的行。
    eastern          EA      TB Savage       4.4     .84     5       20
    northeast       NE      AM Main Jr.      5.1     .94     3       13
    注：在执行以上命令时，如果不能得到预期的结果，即grep忽略了大小写，导致这一问题的原因很可能是当前环境的本地化的设置问题。对于以上命令，如果我将当前语言设置为en_US的时候，它会打印出所有的行，当我将其修改为中文环境时，就能得到我现在的输出了。
    /> export LANG=zh_CN  #设置当前的语言环境为中文。
    /> export LANG=en_US  #设置当前的语言环境为美国。
    /> export LANG=en_Br  #设置当前的语言环境为英国。
    
    /> grep '[a-z]\{9\}' testfile #打印所有包含每个字符串至少有9个连续小写字符的字符串的行。
    northwest        NW      Charles Main          3.0     .98     3       34
    southwest       SW      Lewis Dalsass         2.7     .8       2       18
    southeast        SE      Patricia Hemenway   4.0     .7       4       17
    northeast        NE      AM Main Jr.              5.1     .94     3       13
    
    #第一个字符是3，紧跟着一个句点，然后是任意一个数字，然后是任意个任意字符，然后又是一个3，然后是制表符，然后又是一个3，需要说明的是，下面正则中的\1表示\(3\)。
    /> grep '\(3\)\.[0-9].*\1    *\1' testfile
    northwest       NW      Charles Main        3.0     .98     3       34
    
    /> grep '\<north' testfile    #打印所有以north开头的单词的行。
    northwest       NW      Charles Main          3.0     .98     3       34
    northeast        NE       AM Main Jr.            5.1     .94     3       13
    north              NO      Margot Weber        4.5     .89     5       9
    
    /> grep '\<north\>' testfile  #打印所有包含单词north的行。
    north           NO      Margot Weber        4.5     .89     5       9
    
    /> grep '^n\w*' testfile      #第一个字符是n，后面是任意字母或者数字。
    northwest       NW     Charles Main          3.0     .98     3       34
    northeast        NE      AM Main Jr.            5.1     .94     3       13
    north             NO      Margot Weber        4.5     .89     5       9
    
    3.  扩展grep(grep -E 或者 egrep)：
    使用扩展grep的主要好处是增加了额外的正则表达式元字符集。下面我们还是继续使用实例来演示扩展grep。
    /> egrep 'NW|EA' testfile     #打印所有包含NW或EA的行。如果不是使用egrep，而是grep，将不会有结果查出。
    northwest       NW      Charles Main        3.0     .98     3       34
    eastern         EA      TB Savage           4.4     .84     5       20
    
    /> grep 'NW\|EA' testfile     #对于标准grep，如果在扩展元字符前面加\，grep会自动启用扩展选项-E。
    northwest       NW      Charles Main        3.0     .98     3       34
    eastern           EA       TB Savage           4.4     .84     5       20
    
    /> egrep '3+' testfile
    /> grep -E '3+' testfile
    /> grep '3\+' testfile        #这3条命令将会打印出相同的结果，即所有包含一个或多个3的行。
    northwest       NW      Charles Main         3.0     .98     3       34
    western          WE      Sharon Gray         5.3     .97     5       23
    northeast        NE       AM Main Jr.           5.1     .94     3       13
    central            CT       Ann Stephens       5.7     .94     5       13
    
    /> egrep '2\.?[0-9]' testfile
    /> grep -E '2\.?[0-9]' testfile
    /> grep '2\.\?[0-9]' testfile #首先含有2字符，其后紧跟着0个或1个点，后面再是0和9之间的数字。
    western         WE       Sharon Gray          5.3     .97     5       23
    southwest      SW      Lewis Dalsass         2.7     .8      2       18
    eastern          EA       TB Savage             4.4     .84     5       20
    
    /> egrep '(no)+' testfile
    /> grep -E '(no)+' testfile
    /> grep '\(no\)\+' testfile   #3个命令返回相同结果，即打印一个或者多个连续的no的行。
    northwest       NW      Charles Main        3.0     .98     3       34
    northeast        NE       AM Main Jr.          5.1     .94     3       13
    north              NO      Margot Weber      4.5     .89     5       9
    
    /> grep -E '\w+\W+[ABC]' testfile #首先是一个或者多个字母，紧跟着一个或者多个非字母数字，最后一个是ABC中的一个。
    northwest       NW     Charles Main       3.0     .98     3       34
    southern        SO      Suan Chin           5.1     .95     4       15
    northeast       NE      AM Main Jr.          5.1     .94     3       13
    central           CT      Ann Stephens      5.7     .94     5       13
    
    /> egrep '[Ss](h|u)' testfile
    /> grep -E '[Ss](h|u)' testfile
    /> grep '[Ss]\(h\|u\)' testfile   #3个命令返回相同结果，即以S或s开头，紧跟着h或者u的行。
    western         WE      Sharon Gray       5.3     .97     5       23
    southern        SO      Suan Chin          5.1     .95     4       15
    
    /> egrep 'w(es)t.*\1' testfile    #west开头，其中es为\1的值，后面紧跟着任意数量的任意字符，最后还有一个es出现在该行。
    northwest       NW      Charles Main        3.0     .98     3       34
   
第25章 grep选项
    4.  grep选项：
    这里先列出grep常用的命令行选项：
    选项 	说明
    -c 	只显示有多少行匹配，而不具体显示匹配的行。
    -h 	不显示文件名。
    -i 	在字符串比较的时候忽略大小写。
    -l 	只显示包含匹配模板的行的文件名清单。
    -L 	只显示不包含匹配模板的行的文件名清单。
    -n 	在每一行前面打印改行在文件中的行数。
    -v 	反向检索，只显示不匹配的行。
    -w 	只显示完整单词的匹配。
    -x 	只显示完整行的匹配。
    -r/-R 	如果文件参数是目录，该选项将递归搜索该目录下的所有子目录和文件。

    /> grep -n '^south' testfile  #-n选项在每一个匹配行的前面打印行号。
    3:southwest     SW      Lewis Dalsass         2.7     .8      2       18
    4:southern       SO      Suan Chin               5.1     .95     4       15
    5:southeast      SE      Patricia Hemenway    4.0     .7      4       17

    /> grep -i 'pat' testfile     #-i选项关闭了大小写敏感。
    southeast       SE      Patricia Hemenway       4.0     .7      4       17

    /> grep -v 'Suan Chin' testfile #打印所有不包含Suan Chin的行。
    northwest       NW      Charles Main          3.0     .98     3       34
    western          WE      Sharon Gray           5.3     .97    5       23
    southwest       SW      Lewis Dalsass        2.7     .8      2       18
    southeast        SE      Patricia Hemenway   4.0     .7      4       17
    eastern           EA      TB Savage              4.4     .84     5       20
    northeast        NE      AM Main Jr.             5.1     .94     3       13
    north              NO      Margot Weber        4.5     .89     5       9
    central            CT      Ann Stephens         5.7     .94     5       13

    /> grep -l 'ss' testfile  #-l使得grep只打印匹配的文件名，而不打印匹配的行。
    testfile

    /> grep -c 'west' testfile #-c使得grep只打印有多少匹配模板的行。
    3

    /> grep -w 'north' testfile #-w只打印整个单词匹配的行。
    north           NO      Margot Weber    4.5     .89     5       9

    /> grep -C 2 Patricia testfile #打印匹配行及其上下各两行。
    southwest      SW     Lewis Dalsass         2.7     .8       2       18
    southern        SO      Suan Chin              5.1     .95     4       15
    southeast       SE      Patricia Hemenway   4.0     .7      4       17
    eastern          EA      TB Savage              4.4     .84     5       20
    northeast       NE      AM Main Jr.             5.1     .94     3       13

    /> grep -B 2 Patricia testfile #打印匹配行及其前两行。
    southwest      SW      Lewis Dalsass         2.7     .8      2       18
    southern        SO      Suan Chin               5.1     .95    4       15
    southeast       SE      Patricia Hemenway   4.0     .7      4       17

    /> grep -A 2 Patricia testfile #打印匹配行及其后两行。
    southeast       SE      Patricia Hemenway   4.0     .7      4       17
    eastern           EA      TB Savage              4.4     .84     5       20
    northeast       NE       AM Main Jr.             5.1     .94     3       13
第26章 流编辑器sed
block(流编辑器sed){}
八.　流编辑器sed:
    sed一次处理一行文件并把输出送往屏幕。sed把当前处理的行存储在临时缓冲区中，称为模式空间(pattern space)。一旦sed完成对模式空间中的行的处理，模式空间中的行就被送往屏幕。行被处理完成之后，就被移出模式空间，程序接着读入下一行，处理，显示，移出......文件输入的最后一行被处理完以后sed结束。通过存储每一行在临时缓冲区，然后在缓冲区中操作该行，保证了原始文件不会被破坏。
    
    1.  sed的命令和选项：
    命令 	功能描述
    a\ 	 在当前行的后面加入一行或者文本。
    c\ 	 用新的文本改变或者替代本行的文本。
    d 	 从pattern space位置删除行。
    i\ 	 在当前行的上面插入文本。
    h 	 拷贝pattern space的内容到holding buffer(特殊缓冲区)。
    H 	 追加pattern space的内容到holding buffer。
    g 	 获得holding buffer中的内容，并替代当前pattern space中的文本。
    G 	 获得holding buffer中的内容，并追加到当前pattern space的后面。
    n 	 读取下一个输入行，用下一个命令处理新的行而不是用第一个命令。
    p 	 打印pattern space中的行。
    P 	 打印pattern space中的第一行。
    q 	 退出sed。
    w file 	 写并追加pattern space到file的末尾。
    ! 	 表示后面的命令对所有没有被选定的行发生作用。
    s/re/string 	 用string替换正则表达式re。
    = 	 打印当前行号码。
    替换标记 	 
    g 	 行内全面替换，如果没有g，只替换第一个匹配。
    p 	 打印行。
    x 	 互换pattern space和holding buffer中的文本。
    y 	 把一个字符翻译为另一个字符(但是不能用于正则表达式)。
    选项 	 
    -e 	 允许多点编辑。
    -n 	 取消默认输出。

     需要说明的是，sed中的正则和grep的基本相同，完全可以参照本系列的第一篇中的详细说明。

   2.  sed实例：
    /> cat testfile
    northwest       NW     Charles Main           3.0      .98      3       34
    western          WE      Sharon Gray           5.3      .97     5       23
    southwest       SW     Lewis Dalsass          2.7      .8      2       18
    southern         SO      Suan Chin               5.1     .95     4       15
    southeast       SE       Patricia Hemenway   4.0      .7      4       17
    eastern           EA      TB Savage               4.4     .84     5       20
    northeast        NE      AM Main Jr.              5.1     .94     3       13
    north              NO      Margot Weber         4.5     .89     5       9
    central            CT      Ann Stephens          5.7     .94     5       13

    /> sed '/north/p' testfile #如果模板north被找到，sed除了打印所有行之外，还有打印匹配行。
    northwest       NW      Charles Main           3.0     .98     3       34
    northwest       NW      Charles Main           3.0     .98     3       34
    western          WE      Sharon Gray           5.3     .97     5       23
    southwest      SW      Lewis Dalsass          2.7     .8       2       18
    southern        SO       Suan Chin               5.1     .95     4       15
    southeast       SE       Patricia Hemenway   4.0     .7       4       17
    eastern           EA      TB Savage               4.4     .84     5       20
    northeast        NE      AM Main Jr.              5.1     .94     3       13
    northeast        NE      AM Main Jr.              5.1     .94     3       13
    north              NO      Margot Weber         4.5     .89     5       9
    north              NO      Margot Weber         4.5     .89     5       9
    central            CT      Ann Stephens          5.7     .94     5       13

    #-n选项取消了sed的默认行为。在没有-n的时候，包含模板的行被打印两次，但是在使用-n的时候将只打印包含模板的行。
    /> sed -n '/north/p' testfile
    northwest       NW      Charles Main    3.0     .98     3       34
    northeast        NE      AM Main Jr.       5.1     .94     3       13
    north              NO      Margot Weber  4.5     .89     5       9

    /> sed '3d' testfile  #第三行被删除，其他行默认输出到屏幕。
    northwest       NW     Charles Main            3.0     .98     3       34
    western          WE      Sharon Gray           5.3     .97     5       23
    southern         SO      Suan Chin               5.1     .95     4       15
    southeast       SE       Patricia Hemenway   4.0     .7       4       17
    eastern           EA      TB Savage               4.4     .84     5       20
    northeast       NE       AM Main Jr.              5.1     .94     3       13
    north             NO       Margot Weber         4.5     .89     5       9
    central           CT       Ann Stephens          5.7     .94     5       13

    /> sed '3,$d' testfile  #从第三行删除到最后一行，其他行被打印。$表示最后一行。
    northwest       NW      Charles Main    3.0     .98     3       34
    western          WE      Sharon Gray    5.3     .97     5       23

    /> sed '$d' testfile    #删除最后一行，其他行打印。
    northwest       NW     Charles Main           3.0     .98     3       34
    western          WE     Sharon Gray           5.3     .97     5       23
    southwest       SW    Lewis Dalsass          2.7     .8      2       18
    southern         SO     Suan Chin              5.1     .95     4       15
    southeast       SE      Patricia Hemenway   4.0     .7      4       17
    eastern           EA      TB Savage             4.4     .84     5       20
    northeast       NE      AM Main Jr.             5.1     .94     3       13
    north             NO      Margot Weber        4.5     .89     5       9

    /> sed '/north/d' testfile #删除所有包含north的行，其他行打印。
    western           WE      Sharon Gray           5.3     .97     5       23
    southwest       SW      Lewis Dalsass          2.7     .8      2       18
    southern          SO      Suan Chin               5.1     .95     4       15
    southeast         SE      Patricia Hemenway   4.0     .7       4       17
    eastern            EA      TB Savage               4.4     .84     5       20
    central             CT      Ann Stephens          5.7     .94     5       13

    #s表示替换，g表示命令作用于整个当前行。如果该行存在多个west，都将被替换为north，如果没有g，则只是替换第一个匹配。
    /> sed 's/west/north/g' testfile
    northnorth      NW     Charles Main           3.0     .98    3       34
    northern         WE      Sharon Gray          5.3     .97    5       23
    southnorth      SW     Lewis Dalsass         2.7     .8      2       18
    southern         SO      Suan Chin              5.1     .95    4       15
    southeast       SE      Patricia Hemenway   4.0     .7      4       17
    eastern           EA      TB Savage             4.4     .84     5       20
    northeast       NE      AM Main Jr.              5.1     .94    3       13
    north             NO      Margot Weber        4.5     .89     5       9
    central            CT      Ann Stephens        5.7     .94     5       13

    /> sed -n 's/^west/north/p' testfile #-n表示只打印匹配行，如果某一行的开头是west，则替换为north。
    northern        WE      Sharon Gray     5.3     .97     5       23

    #&符号表示替换字符串中被找到的部分。所有以两个数字结束的行，最后的数字都将被它们自己替换，同时追加.5。
    /> sed 's/[0-9][0-9]$/&.5/' testfile
    northwest       NW      Charles Main          3.0     .98     3       34.5
    western          WE      Sharon Gray           5.3     .97     5       23.5
    southwest       SW      Lewis Dalsass        2.7     .8       2       18.5
    southern         SO      Suan Chin              5.1     .95     4       15.5
    southeast       SE      Patricia Hemenway   4.0     .7       4       17.5
    eastern           EA      TB Savage              4.4     .84     5       20.5
    northeast        NE      AM Main Jr.             5.1     .94     3       13.5
    north              NO      Margot Weber        4.5     .89     5       9
    central            CT      Ann Stephens         5.7     .94     5       13.5

    /> sed -n 's/Hemenway/Jones/gp' testfile  #所有的Hemenway被替换为Jones。-n选项加p命令则表示只打印匹配行。
    southeast       SE      Patricia Jones  4.0     .7      4       17

    #模板Mar被包含在一对括号中，并在特殊的寄存器中保存为tag 1，它将在后面作为\1替换字符串，Margot被替换为Marlianne。
    /> sed -n 's/\(Mar\)got/\1lianne/p' testfile
    north           NO      Marlianne Weber 4.5     .89     5       9

    #s后面的字符一定是分隔搜索字符串和替换字符串的分隔符，默认为斜杠，但是在s命令使用的情况下可以改变。不论什么字符紧跟着s命令都认为是新的分隔符。这个技术在搜索含斜杠的模板时非常有用，例如搜索时间和路径的时候。
    /> sed 's#3#88#g' testfile
    northwest       NW      Charles Main            88.0    .98     88     884
    western          WE       Sharon Gray           5.88    .97     5       288
    southwest       SW      Lewis Dalsass          2.7     .8       2       18
    southern         SO       Suan Chin               5.1     .95     4       15
    southeast       SE        Patricia Hemenway   4.0     .7        4       17
    eastern           EA       TB Savage               4.4     .84      5      20
    northeast        NE       AM Main Jr.              5.1     .94      88     188
    north              NO       Margot Weber         4.5     .89      5       9
    central            CT       Ann Stephens          5.7     .94      5       188

    #所有在模板west和east所确定的范围内的行都被打印，如果west出现在esst后面的行中，从west开始到下一个east，无论这个east出现在哪里，二者之间的行都被打印，即使从west开始到文件的末尾还没有出现east，那么从west到末尾的所有行都将打印。
    /> sed -n '/west/,/east/p' testfile
    northwest       NW      Charles Main           3.0     .98      3      34
    western          WE      Sharon Gray            5.3     .97     5      23
    southwest       SW     Lewis Dalsass          2.7     .8       2      18
    southern         SO      Suan Chin               5.1     .95     4      15
    southeast        SE      Patricia Hemenway    4.0     .7       4      17

    /> sed -n '5,/^northeast/p' testfile  #打印从第五行开始到第一个以northeast开头的行之间的所有行。
    southeast       SE      Patricia Hemenway   4.0     .7       4       17
    eastern           EA      TB Savage              4.4     .84     5       20
    northeast        NE      AM Main Jr.             5.1     .94     3       13

    #-e选项表示多点编辑。第一个编辑命令是删除第一到第三行。第二个编辑命令是用Jones替换Hemenway。
    /> sed -e '1,3d' -e 's/Hemenway/Jones/' testfile
    southern        SO      Suan Chin          5.1     .95     4       15
    southeast       SE      Patricia Jones      4.0     .7      4       17
    eastern          EA      TB Savage          4.4     .84     5       20
    northeast       NE      AM Main Jr.         5.1     .94     3       13
    north             NO      Margot Weber    4.5     .89     5       9
    central           CT      Ann Stephens     5.7     .94     5       13

    /> sed -n '/north/w newfile' testfile #将所有匹配含有north的行写入newfile中。
    /> cat newfile
    northwest       NW      Charles Main     3.0     .98     3       34
    northeast       NE      AM Main Jr.         5.1     .94     3       13
    north             NO      Margot Weber    4.5     .89     5       9

    /> sed '/eastern/i\ NEW ENGLAND REGION' testfile #i是插入命令，在匹配模式行前插入文本。
    northwest       NW      Charles Main          3.0     .98      3       34
    western          WE      Sharon Gray           5.3     .97     5       23
    southwest       SW      Lewis Dalsass         2.7     .8      2       18
    southern         SO      Suan Chin              5.1     .95     4       15
    southeast        SE      Patricia Hemenway   4.0     .7      4       17
    NEW ENGLAND REGION
    eastern          EA      TB Savage              4.4     .84     5       20
    northeast       NE      AM Main Jr.             5.1     .94     3       13
    north             NO      Margot Weber        4.5     .89     5       9
    central           CT      Ann Stephens         5.7     .94     5       13

    #找到匹配模式eastern的行后，执行后面花括号中的一组命令，每个命令之间用逗号分隔，n表示定位到匹配行的下一行，s/AM/Archie/完成Archie到AM的替换，p和-n选项的合用，则只是打印作用到的行。
    /> sed -n '/eastern/{n;s/AM/Archie/;p}' testfile
    northeast       NE      Archie Main Jr. 5.1     .94     3       13

    #-e表示多点编辑，第一个编辑命令y将前三行中的所有小写字母替换为大写字母，-n表示不显示替换后的输出，第二个编辑命令将只是打印输出转换后的前三行。注意y不能用于正则。
    /> sed -n -e '1,3y/abcdefghijklmnopqrstuvwxyz/ABCDEFGHIJKLMNOPQRSTUVWXYZ/' -e '1,3p' testfile
    NORTHWEST       NW      CHARLES MAIN     3.0     .98     3       34
    WESTERN           WE      SHARON GRAY      5.3     .97     5       23
    SOUTHWEST       SW      LEWIS DALSASS   2.7     .8      2       18

    /> sed '2q' testfile  #打印完第二行后退出。
    northwest       NW      Charles Main    3.0     .98     3       34
    western          WE      Sharon Gray     5.3     .97     5       23

    #当模板Lewis在某一行被匹配，替换命令首先将Lewis替换为Joseph，然后再用q退出sed。
     /> sed '/Lewis/{s/Lewis/Joseph/;q;}' testfile
    northwest       NW      Charles Main      3.0     .98     3       34
    western          WE      Sharon Gray      5.3     .97     5       23
    southwest       SW      Joseph Dalsass  2.7     .8      2       18

    #在sed处理文件的时候，每一行都被保存在pattern space的临时缓冲区中。除非行被删除或者输出被取消，否则所有被处理过的行都将打印在屏幕上。接着pattern space被清空，并存入新的一行等待处理。在下面的例子中，包含模板的northeast行被找到，并被放入pattern space中，h命令将其复制并存入一个称为holding buffer的特殊缓冲区内。在第二个sed编辑命令中，当达到最后一行后，G命令告诉sed从holding buffer中取得该行，然后把它放回到pattern space中，且追加到现在已经存在于模式空间的行的末尾。
     /> sed -e '/northeast/h' -e '$G' testfile
    northwest       NW     Charles Main            3.0    .98     3       34
    western          WE     Sharon Gray            5.3    .97     5       23
    southwest       SW    Lewis Dalsass          2.7     .8       2       18
    southern         SO     Suan Chin               5.1     .95     4       15
    southeast       SE      Patricia Hemenway   4.0     .7       4       17
    eastern           EA      TB Savage              4.4     .84     5       20
    northeast       NE      AM Main Jr.              5.1     .94     3       13
    north             NO      Margot Weber         4.5     .89     5       9
    central           CT      Ann Stephens          5.7     .94     5       13
    northeast       NE      AM Main Jr.              5.1     .94     3       13

    #如果模板WE在某一行被匹配，h命令将使得该行从pattern space中复制到holding buffer中，d命令在将该行删除，因此WE匹配行没有在原来的位置被输出。第二个命令搜索CT，一旦被找到，G命令将从holding buffer中取回行，并追加到当前pattern space的行末尾。简单的说，WE所在的行被移动并追加到包含CT行的后面。
    /> sed -e '/WE/{h;d;}' -e '/CT/{G;}' testfile
    northwest       NW    Charles Main           3.0     .98     3       34
    southwest       SW    Lewis Dalsass         2.7     .8      2       18
    southern         SO     Suan Chin              5.1     .95     4       15
    southeast       SE      Patricia Hemenway   4.0     .7      4       17
    eastern           EA     TB Savage              4.4     .84     5       20
    northeast       NE      AM Main Jr.              5.1     .94     3       13
    north             NO      Margot Weber         4.5     .89     5       9
    central           CT      Ann Stephens          5.7     .94     5       13
    western         WE      Sharon Gray           5.3     .97     5       23

    #第一个命令将匹配northeast的行从pattern space复制到holding buffer，第二个命令在读取的文件的末尾时，g命令告诉sed从holding buffer中取得行，并把它放回到pattern space中，以替换已经存在于pattern space中的。简单说就是包含模板northeast的行被复制并覆盖了文件的末尾行。
    /> sed -e '/northeast/h' -e '$g' testfile
    northwest       NW     Charles Main          3.0     .98     3       34
    western          WE      Sharon Gray         5.3     .97      5       23
    southwest       SW     Lewis Dalsass        2.7     .8       2       18
    southern         SO      Suan Chin             5.1     .95     4       15
    southeast       SE      Patricia Hemenway   4.0     .7      4       17
    eastern           EA      TB Savage             4.4     .84     5       20
    northeast       NE      AM Main Jr.             5.1     .94     3       13
    north             NO      Margot Weber        4.5     .89     5       9
    northeast       NE      AM Main Jr.             5.1     .94     3       13

    #模板WE匹配的行被h命令复制到holding buffer，再被d命令删除。结果可以看出WE的原有位置没有输出。第二个编辑命令将找到匹配CT的行，g命令将取得holding buffer中的行，并覆盖当前pattern space中的行，即匹配CT的行。简单的说，任何包含模板northeast的行都将被复制，并覆盖包含CT的行。    
    /> sed -e '/WE/{h;d;}' -e '/CT/{g;}' testfile
    northwest       NW    Charles Main           3.0     .98      3      34
    southwest       SW    Lewis Dalsass         2.7     .8       2       18
    southern         SO     Suan Chin              5.1     .95      4      15
    southeast       SE      Patricia Hemenway   4.0     .7       4      17
    eastern          EA      TB Savage              4.4     .84      5      20
    northeast       NE      AM Main Jr.              5.1     .94     3      13
    north             NO      Margot Weber        4.5     .89      5      9
    western         WE      Sharon Gray           5.3     .97     5      23

    #第一个编辑中的h命令将匹配Patricia的行复制到holding buffer中，第二个编辑中的x命令，会将holding buffer中的文本考虑到pattern space中，而pattern space中的文本被复制到holding buffer中。因此在打印匹配Margot行的地方打印了holding buffer中的文本，即第一个命令中匹配Patricia的行文本，第三个编辑命令会将交互后的holding buffer中的文本在最后一行的后面打印出来。
     /> sed -e '/Patricia/h' -e '/Margot/x' -e '$G' testfile
    northwest       NW      Charles Main           3.0      .98      3       34
    western           WE      Sharon Gray           5.3     .97      5       23
    southwest       SW      Lewis Dalsass         2.7      .8       2       18
    southern         SO      Suan Chin               5.1      .95     4       15
    southeast       SE       Patricia Hemenway    4.0      .7       4       17
    eastern           EA      TB Savage               4.4      .84     5       20
    northeast       NE       AM Main Jr.               5.1     .94      3       13
    southeast       SE      Patricia Hemenway      4.0     .7       4       17
    central            CT      Ann Stephens            5.7     .94     5       13
    
    删除某行
     /> sed '1d' ab             #删除第一行
     /> sed '$d' ab             #删除最后一行
     /> sed '1,2d' ab           #删除第一行到第二行
     /> sed '2,$d' ab           #删除第二行到最后一行

显示某行
     /> sed -n '1p' ab          #显示第一行
     /> sed -n '$p' ab          #显示最后一行
     /> sed -n '1,2p' ab        #显示第一行到第二行
     /> sed -n '2,$p' ab        #显示第二行到最后一行
     /> sed -n '/zyx/,/zhou/p' /etc/passwd

使用模式进行查询
     /> sed -n '/ruby/p' ab     #查询包括关键字ruby所在所有行
     /> sed -n '/\$/p' ab       #查询包括关键字$所在所有行，使用反斜线\屏蔽特殊含义

增加一行或多行字符串
     /> sed '1a drink tea' ab   #第一行后增加字符串"drink tea"
     /> sed '1,3a drink tea' ab #第一行到第三行后增加字符串"drink tea"
     /> sed '1a drink tea\nor coffee' ab   #第一行后增加多行，使用换行符\n

代替一行或多行
     /> sed '1c Hi' ab          #第一行代替为Hi
     /> sed '1,2c Hi' ab        #第一行到第二行代替为Hi

就地插入
     /> sed -i '$a bye' ab         #在文件ab中最后一行直接输入"bye"

替换两个或多个空格为一个空格
     /> sed 's/[ ][ ]*/ /g' file_name

替换两个或多个空格为分隔符:
     /> sed 's/[ ][ ]*/:/g' file_name

如果空格与tab共存时用下面的命令进行替换
替换成空格
     /> sed 's/[[:space:]][[:space:]]*/ /g' filename

替换成分隔符:
     /> sed 's/[[:space:]][[:space:]]*/:/g' filename

替换单引号为空
     /> sed 's/'"'"'//g'
     /> sed 's/'\''//g'
     /> sed s/\'//g

快速一行命令:
    's//.$//g'         删除以句点结尾行
    '-e /abcd/d'       删除包含abcd的行
    's/[][][]*/[]/g'   删除一个以上空格,用一个空格代替
    's/^[][]*//g'      删除行首空格
    's//.[][]*/[]/g'   删除句号后跟两个或更多的空格,用一个空格代替
    '/^$/d'            删除空行
    's/^.//g'          删除第一个字符,区别  's//.//g'删除所有的句点
    's/COL/(.../)//g'  删除紧跟COL的后三个字母
    's/^////g'         删除路径中第一个
第27章 awk实用功能
block(awk实用功能){}
九.  awk实用功能:
    和sed一样，awk也是逐行扫描文件的，从第一行到最后一行，寻找匹配特定模板的行，并在这些行上运行“选择”动作。如果一个模板没有指定动作，这些匹配的行就被显示在屏幕上。如果一个动作没有模板，所有被动作指定的行都被处理。
    
   1.  awk的基本格式：
    /> awk 'pattern' filename
    /> awk '{action}' filename
    /> awk 'pattern {action}' filename
    
    具体应用方式分别见如下三个用例：
    /> cat employees
    Tom Jones         4424    5/12/66         543354
    Mary Adams      5346    11/4/63         28765
    Sally Chang       1654    7/22/54         650000
    Billy Black         1683    9/23/44         336500

    /> awk '/Mary/' employees   #打印所有包含模板Mary的行。
    Mary Adams      5346    11/4/63         28765

    #打印文件中的第一个字段，这个域在每一行的开始，缺省由空格或其它分隔符。
    /> awk '{print $1}' employees
    Tom
    Mary
    Sally
    Billy
    
    /> awk '/Sally/{print $1, $2}' employees #打印包含模板Sally的行的第一、第二个域字段。
    Sally Chang
    
    2.  awk的格式输出：
    awk中同时提供了print和printf两种打印输出的函数，其中print函数的参数可以是变量、数值或者字符串。字符串必须用双引号引用，参数用逗号分隔。如果没有逗号，参数就串联在一起而无法区分。这里，逗号的作用与输出文件的分隔符的作用是一样的，只是后者是空格而已。下面给出基本的转码序列：
    转码 	含义
    \n 	换行
    \r 	回车
    \t 	制表符

    /> date | awk '{print "Month: " $2 "\nYear: ", $6}'
    Month: Oct
    Year:  2011

    /> awk '/Sally/{print "\t\tHave a nice day, " $1,$2 "\!"}' employees
                    Have a nice day, Sally Chang!

    在打印数字的时候你也许想控制数字的格式，我们通常用printf来完成这个功能。awk的特殊变量OFMT也可以在使用print函数的时候，控制数字的打印格式。它的默认值是"%.6g"----小数点后面6位将被打印。
    /> awk 'BEGIN { OFMT="%.2f"; print 1.2456789, 12E-2}'
    1.25  0.12

    现在我们介绍一下功能更为强大的printf函数，其用法和c语言中printf基本相似。下面我们给出awk中printf的格式化说明符列表：
    格式化说明符 功能 	示例 	结果
    %c 	        打印单个ASCII字符。printf("The character is %c.\n",x) 	The character is A.
    %d 	        打印十进制数。 	printf("The boy is %d years old.\n",y) 	The boy is 15 years old.
    %e 	        打印用科学记数法表示的数。 	printf("z is %e.\n",z) 	z is 2.3e+01.
    %f 	        打印浮点数。 	printf("z is %f.\n",z) 	z is 2.300000
    %o 	        打印八进制数。 	printf("y is %o.\n",y) 	y is 17.
    %s 	        打印字符串。 	printf("The name of the culprit is %s.\n",$1); 	The name of the culprit is Bob Smith.
    %x 	        打印十六进制数。 	printf("y is %x.\n",y) 	y is f.

    注：假设列表中的变脸值为x = A, y = 15, z = 2.3, $1 = "Bob Smith"

    /> echo "Linux" | awk '{printf "|%-15s|\n", $1}'  # %-15s表示保留15个字符的空间，同时左对齐。
    |Linux          |

    /> echo "Linux" | awk '{printf "|%15s|\n", $1}'   # %-15s表示保留15个字符的空间，同时右对齐。
    |          Linux|

    #%8d表示数字右对齐，保留8个字符的空间。
     /> awk '{printf "The name is %-15s ID is %8d\n", $1,$3}' employees
    The name is Tom             ID is     4424
    The name is Mary            ID is     5346
    The name is Sally            ID is     1654
    The name is Billy             ID is     1683

    3.  awk中的记录和域：
    awk中默认的记录分隔符是回车，保存在其内建变量ORS和RS中。$0变量是指整条记录。
    /> awk '{print $0}' employees #这等同于print的默认行为。
    Tom Jones        4424    5/12/66         543354
    Mary Adams      5346    11/4/63         28765
    Sally Chang       1654    7/22/54         650000
    Billy Black         1683    9/23/44         336500

    变量NR(Number of Record)，记录每条记录的编号。
    /> awk '{print NR, $0}' employees
    1 Tom Jones        4424    5/12/66         543354
    2 Mary Adams      5346    11/4/63         28765
    3 Sally Chang       1654    7/22/54         650000
    4 Billy Black         1683    9/23/44         336500

    变量NF(Number of Field)，记录当前记录有多少域。
    /> awk '{print $0,NF}' employees
    Tom Jones        4424    5/12/66          543354   5
    Mary Adams      5346    11/4/63         28765     5
    Sally Chang      1654    7/22/54          650000   5
    Billy Black        1683     9/23/44         336500    5

    #根据employees生成employees2。sed的用法可以参考上一篇blog。
    /> sed 's/[[:space:]]\+\([0-9]\)/:\1/g;w employees2' employees
    /> cat employees
    Tom Jones:4424:5/12/66:543354
    Mary Adams:5346:11/4/63:28765
    Sally Chang:1654:7/22/54:650000
    Billy Black:1683:9/23/44:336500

    /> awk -F: '/Tom Jones/{print $1,$2}' employees2  #这里-F选项后面的字符表示分隔符。
    Tom Jones 4424

    变量OFS(Output Field Seperator)表示输出字段间的分隔符，缺省是空格。
    />  awk -F: '{OFS = "?"};  /Tom/{print $1,$2 }' employees2 #在输出时，域字段间的分隔符已经是?(问号)了
    Tom Jones?4424

    对于awk而言，其模式部分将控制这动作部分的输入，只有符合模式条件的记录才可以交由动作部分基础处理，而模式部分不仅可以写成正则表达式(如上面的例子)，awk还支持条件表达式，如：
    /> awk '$3 < 4000 {print}' employees
    Sally Chang     1654    7/22/54         650000
    Billy Black       1683    9/23/44         336500

    在花括号内，用分号分隔的语句称为动作。如果模式在动作前面，模式将决定什么时候发出动作。动作可以是一个语句或是一组语句。语句之间用分号分隔，也可以用换行符，如：
    pattern { action statement; action statement; etc. } or
    pattern {
        action statement
        action statement
    }
    模式和动作一般是捆绑在一起的。需要注意的是，动作是花括号内的语句。模式控制的动作是从第一个左花括号开始到第一个右花括号结束，如下：
    /> awk '$3 < 4000 && /Sally/ {print}' employees
    Sally Chang     1654    7/22/54         650000

    4.  匹配操作符：
    " ~ " 用来在记录或者域内匹配正则表达式。
    /> awk '$1 ~ /[Bb]ill/' employees      #显示所有第一个域匹配Bill或bill的行。
    Billy Black     1683    9/23/44         336500

    /> awk '$1 !~ /[Bb]ill/' employees     #显示所有第一个域不匹配Bill或bill的行，其中!~表示不匹配的意思。
    Tom Jones        4424    5/12/66         543354
    Mary Adams      5346    11/4/63         28765
    Sally Chang       1654    7/22/54         650000

    5.  awk的基本应用实例：
    /> cat testfile
    northwest     NW        Charles Main            3.0        .98        3        34
    western        WE        Sharon Gray            5.3        .97        5        23
    southwest     SW        Lewis Dalsass          2.7        .8          2        18
    southern       SO        Suan Chin                5.1        .95        4        15
    southeast      SE        Patricia Hemenway    4.0        .7          4        17
    eastern         EA        TB Savage                4.4        .84        5        20
    northeast      NE        AM Main Jr.               5.1        .94        3        13
    north            NO        Margot Weber          4.5        .89        5        9
    central          CT        Ann Stephens           5.7        .94        5        13

    /> awk '/^north/' testfile            #打印所有以north开头的行。
    northwest      NW      Charles Main     3.0     .98     3       34
    northeast       NE      AM Main Jr.        5.1     .94     3       13
    north             NO      Margot Weber   4.5     .89     5       9

    /> awk '/^(no|so)/' testfile          #打印所有以so和no开头的行。
    northwest       NW      Charles Main                3.0     .98      3       34
    southwest       SW      Lewis Dalsass              2.7     .8       2       18
    southern         SO      Suan Chin                    5.1     .95     4       15
    southeast        SE      Patricia Hemenway        4.0     .7       4       17
    northeast        NE      AM Main Jr.                   5.1     .94     3       13
    north              NO      Margot Weber              4.5     .89     5       9

    /> awk '$5 ~ /\.[7-9]+/' testfile     #第五个域字段匹配包含.(点)，后面是7-9的数字。
    southwest       SW      Lewis Dalsass            2.7     .8      2       18
    central             CT      Ann Stephens            5.7     .94     5       13

    /> awk '$8 ~ /[0-9][0-9]$/{print $8}' testfile  #第八个域以两个数字结束的打印。
    34
    23
    18
    15
    17
    20
    13
第28章 awk表达式功能
block(awk表达式功能){}
十.  awk表达式功能:
    1.  比较表达式：
    比较表达式匹配那些只在条件为真时才运行的行。这些表达式利用关系运算符来比较数字和字符串。见如下awk支持的条件表达式列表：
    运算符 	含义 	    例子
    < 	    小于 	    x < y
    <= 	    小于等于 	x <= y
    == 	    等于 	    x == y
    != 	    不等于 	    x != y
    >= 	    大于等于 	x >= y
    > 	    大于 	    x > y
    ~ 	    匹配 	    x ~ /y/
    !~ 	    不匹配      x !~ /y/

    /> cat employees
    Tom Jones        4424    5/12/66         543354
    Mary Adams      5346    11/4/63         28765
    Sally Chang       1654    7/22/54         650000
    Billy Black         1683    9/23/44         336500

    /> awk '$3 == 5346' employees       #打印第三个域等于5346的行。
    Mary Adams      5346    11/4/63         28765

    /> awk '$3 > 5000 {print $1}' employees  #打印第三个域大于5000的行的第一个域字段。
    Mary

    /> awk '$2 ~ /Adam/' employess      #打印第二个域匹配Adam的行。
    Mary Adams      5346    11/4/63         28765

    2.  条件表达式：
    条件表达式使用两个符号--问号和冒号给表达式赋值： conditional expression1 ? expression2 : expressional3，其逻辑等同于C语言中的条件表达式。其对应的if/else语句如下：
    {
        if (expression1)
            expression2
        else
            expression3
    }
    /> cat testfile
    northwest     NW        Charles Main             3.0        .98        3        34
    western        WE        Sharon Gray             5.3        .97         5        23
    southwest     SW        Lewis Dalsass           2.7        .8          2        18
    southern       SO        Suan Chin                 5.1        .95        4        15
    southeast      SE        Patricia Hemenway     4.0        .7          4        17
    eastern         EA        TB Savage                 4.4        .84        5        20
    northeast      NE        AM Main Jr.                5.1       .94         3        13
    north            NO        Margot Weber           4.5       .89         5        9
    central          CT        Ann Stephens            5.7       .94         5        13

    /> awk 'NR <= 3 {print ($7 > 4 ? "high "$7 : "low "$7) }' testfile
    low 3
    high 5
    low 2

    3.  数学表达式：
    运算可以在模式内进行，其中awk将所有的运算都视为浮点运算，见如下列表：
    运算符 	含义 	例子
    + 	    加 	    x + y
    - 	    减 	    x - y
    * 	    乘 	    x * y
    / 	    除 	    x / y
    % 	    取余 	x % y
    ^ 	    乘方 	x ^ y

    /> awk '/southern/{print $5 + 10}' testfile  #如果记录包含正则表达式southern，第五个域就加10并打印。
    15.1

    /> awk '/southern/{print $8 /2 }' testfile   #如果记录包含正则表达式southern，第八个域除以2并打印。
    7.5

    4.  逻辑表达式：
    见如下列表：
    运算符 	含义 	例子
    && 	    逻辑与 	a && b
    || 	    逻辑或 	a || b
    ! 	    逻辑非 	!a

    /> awk '$8 > 10 && $8 < 17' testfile   #打印出第八个域的值大于10小于17的记录。
    southern        SO      Suan Chin               5.1     .95     4       15
    central            CT      Ann Stephens         5.7     .94     5       13

    #打印第二个域等于NW，或者第一个域匹配south的行的第一、第二个域。
    /> awk '$2 == "NW" || $1 ~ /south/ {print $1,$2}' testfile
    northwest  NW
    southwest  SW
    southern    SO
    southeast   SE

    /> awk '!($8 > 13) {print $8}' testfile  #打印第八个域字段不大于13的行的第八个域。
    3
    9
    13

    5.  范围模板：
    范围模板匹配从第一个模板的第一次出现到第二个模板的第一次出现，第一个模板的下一次出现到第一个模板的下一次出现等等。如果第一个模板匹配而第二个模板没有出现，awk就显示到文件末尾的所有行。
    /> awk '/^western/,/^eastern/ {print $1}' testfile #打印以western开头到eastern开头的记录的第一个域。
    western    WE
    southwest SW
    southern   SO
    southeast  SE
    eastern      EA    

    6.  赋值符号：
    #找到第三个域等于Ann的记录，然后给该域重新赋值为Christian，之后再打印输出该记录。
    /> awk '$3 == "Ann" { $3 = "Christian"; print}' testfile
    central CT Christian Stephens 5.7 .94 5 13

    /> awk '/Ann/{$8 += 12; print $8}' testfile #找到包含Ann的记录，并将该条记录的第八个域的值+=12，最后再打印输出。
    25
第28章 awk编程
block(awk编程){}
十一.  awk编程:
    1.  变量：
    在awk中变量无须定义即可使用，变量在赋值时即已经完成了定义。变量的类型可以是数字、字符串。根据使用的不同，未初始化变量的值为0或空白字符串" "，这主要取决于变量应用的上下文。下面为变量的赋值负号列表：
    符号 	含义 	    等价形式
    = 	    a = 5 	    a = 5
    += 	    a = a + 5 	a += 5
    -= 	    a = a - 5 	a -= 5
    *= 	    a = a * 5 	a *= 5
    /= 	    a = a / 5 	a /= 5
    %= 	    a = a % 5 	a %= 5
    ^= 	    a = a ^ 5 	a ^= 5

    /> awk '$1 ~ /Tom/ {Wage = $2 * $3; print Wage}' filename
    该命令将从文件中读取，并查找第一个域字段匹配Tom的记录，再将其第二和第三个字段的乘积赋值给自定义的Wage变量，最后通过print命令将该变量打印输出。

    /> awk ' {$5 = 1000 * $3 / $2; print}' filename
    在上面的命令中，如果$5不存在，awk将计算表达式1000 * $3 / $2的值，并将其赋值给$5。如果第五个域存在，则用表达式覆盖$5原来的值。

    我们同样也可以在命令行中定义自定义的变量，用法如下：
    /> awk -F: -f awkscript month=4 year=2011 filename
    这里的month和year都是自定义变量，且分别被赋值为4和2000，在awk的脚本中这些变量将可以被直接使用，他们和脚本中定义的变量在使用上没有任何区别。

    除此之外，awk还提供了一组内建变量(变量名全部大写)，见如下列表：
    变量名 	    变量内容
    ARGC 	    命令行参数的数量。
    ARGIND 	    命令行正在处理的当前文件的AGV的索引。
    ARGV 	    命令行参数数组。
    CONVFMT 	转换数字格式。
    ENVIRON 	从shell中传递来的包含当前环境变量的数组。
    ERRNO 	    当使用close函数或者通过getline函数读取的时候，发生的重新定向错误的描述信息就保存在这个变量中。
    FIELDWIDTHS 在对记录进行固定域宽的分割时，可以替代FS的分隔符的列表。
    FILENAME 	当前的输入文件名。
    FNR 	    当前文件的记录号。
    FS 	        输入分隔符，默认是空格。
    IGNORECASE 	在正则表达式和字符串操作中关闭大小写敏感。
    NF 	        当前文件域的数量。
    NR 	        当前文件记录数。
    OFMT 	    数字输出格式。
    OFS 	    输出域分隔符。
    ORS 	    输出记录分隔符。
    RLENGTH 	通过match函数匹配的字符串的长度。
    RS 	        输入记录分隔符。
    RSTART 	    通过match函数匹配的字符串的偏移量。
    SUBSEP 	    下标分隔符。

    /> cat employees2
    Tom Jones:4424:5/12/66:543354
    Mary Adams:5346:11/4/63:28765
    Sally Chang:1654:7/22/54:650000
    Mary Black:1683:9/23/44:336500

    /> awk -F: '{IGNORECASE = 1}; $1 == "mary adams" { print NR, $1, $2, $NF}' employees2
    2 Mary Adams 5346 28765
    /> awk -F: ' $1 == "mary adams" { print NR, $1, $2, $NF}' employees2
    没有输出结果。
    当IGNORECASE内置变量的值为非0时，表示在进行字符串操作和处理正则表达式时关闭大小写敏感。这里的"mary adams"将匹配文件中的"Mary Admams"记录。最后print打印出第一、第二和最后一个域。需要说明的是NF表示当前记录域的数量，因此$NF将表示最后一个域的值。

    awk在动作部分还提供了BEGIN块和END块。其中BEGIN动作块在awk处理任何输入文件行之前执行。事实上，BEGIN块可以在没有任何输入文件的条件下测试。因为在BEGIN块执行完毕以前awk将不读取任何输入文件。BEGIN块通常被用来改变内建变量的值，如OFS、RS或FS等。也可以用于初始化自定义变量值，或打印输出标题。
    /> awk 'BEGIN {FS = ":"; OFS = "\t"; ORS = "\n\n"} { print $1,$2,$3} ' filename
    上例中awk在处理文件之前，已经将域分隔符(FS)设置为冒号，输出文件域分隔符(OFS)设置为制表符，输出记录分隔符(ORS)被设置为两个换行符。BEGIN之后的动作模块中如果有多个语句，他们之间用分号分隔。
    和BEGIN恰恰相反，END模块中的动作是在整个文件处理完毕之后被执行的。
    /> awk 'END {print "The number of the records is " NR }' filename
    awk在处理输入文件之后，执行END模块中的动作，上例中NR的值是读入的最后一个记录的记录号。

    /> awk '/Mary/{count++} END{print "Mary was found " count " times." }' employees2
    Mary was found 2 times.

    /> awk '/Mary/{count++} END{print "Mary was found " count " times." }' employees2
    Mary was found 2 times.
    
    /> cat testfile
    northwest       NW      Charles Main                3.0     .98     3       34
    western          WE      Sharon Gray                5.3     .97     5       23
    southwest       SW      Lewis Dalsass              2.7     .8      2       18
    southern         SO      Suan Chin                   5.1     .95     4       15
    southeast        SE      Patricia Hemenway        4.0     .7      4       17
    eastern           EA      TB Savage                   4.4     .84     5       20
    northeast        NE      AM Main Jr.                  5.1     .94     3       13
    north             NO       Margot Weber             4.5     .89     5       9
    central           CT       Ann Stephens              5.7     .94     5       13

    /> awk '/^north/{count += 1; print count}' testfile     #如记录以正则north开头，则创建变量count同时增一，再输出其值。
    1
    2
    3
    
    #这里只是输出前三个字段，其中第七个域先被赋值给变量x，在自减一，最后再同时打印出他们。
    /> awk 'NR <= 3 {x = $7--; print "x = " x ", $7 = " $7}' testfile
    x = 3, $7 = 2
    x = 5, $7 = 4
    x = 2, $7 = 1    
    
    #打印NR(记录号)的值在2--5之间的记录。
    /> awk 'NR == 2,NR == 5 {print "The record number is " NR}' testfile
    The record number is 2
    The record number is 3
    The record number is 4
    The record number is 5

    #打印环境变量USER和HOME的值。环境变量的值由父进程shell传递给awk程序的。
    /> awk 'BEGIN { print ENVIRON["USER"],ENVIRON["HOME"]}'
    root /root
    
    #BEGIN块儿中对OFS内置变量重新赋值了，因此后面的输出域分隔符改为了\t。
    /> awk 'BEGIN { OFS = "\t"}; /^Sharon/{ print $1,$2,$7}' testfile
    western WE      5
    
    #从输入文件中找到以north开头的记录count就加一，最后在END块中输出该变量。
    /> awk '/^north/{count++}; END{print count}' testfile
    3

    2.  重新定向：
    在动作语句中使用shell通用的重定向输出符号">"就可以完成awk的重定向操作，当使用>的时候，原有文件将被清空，同时文件持续打开，直到文件被明确的关闭或者awk程序终止。来自后面的打印语句的输出会追加到前面内容的后面。符号">>"用来打开一个文件但是不清空原有文件的内容，重定向的输出只是被追加到这个文件的末尾。
    /> awk '$4 >= 70 {print $1,$2 > "passing_file"}' filename  #注意这里的文件名需要用双引号括起来。
    #通过两次cat的结果可以看出>和>>的区别。
    /> awk '/north/{print $1,$3,$4 > "districts" }' testfile
    /> cat districts
    northwest Joel Craig
    northeast TJ Nichols
    north Val Shultz
    /> awk '/south/{print $1,$3,$4 >> "districts" }' testfile
    /> cat districts
    northwest Joel Craig
    northeast TJ Nichols
    north Val Shultz
    southwest Chris Foster
    southern May Chin
    southeast Derek Jonhson

   
    awk中对于输入重定向是通过getline函数来完成的。getline函数的作用是从标准输入、管道或者当前正在处理的文件之外的其他输入文件获得输入。他负责从输入获得下一行的内容，并给NF、NR和FNR等内建变量赋值。如果得到一个记录，getline就返回1，如果达到文件末尾就返回0。如果出现错误，如打开文件失败，就返回-1。
    /> awk 'BEGIN { "date" | getline d; print d}'
    Tue Nov 15 15:31:42 CST 2011
    上例中的BEGIN动作模块中，先执行shell命令date，并通过管道输出给getline，然后再把输出赋值给自定义变量d并打印输出它。
    
    /> awk 'BEGIN { "date" | getline d; split(d,mon); print mon[2]}'
    Nov
    上例中date命令通过管道输出给getline并赋值给d变量，再通过内置函数split将d拆分为mon数组，最后print出mon数组的第二个元素。
    
    /> awk 'BEGIN { while("ls" | getline) print}'
    employees
    employees2
    testfile
    命令ls的输出传递给getline作为输入，循环的每个反复，getline都从ls的结果中读取一行输入，并把他打印到屏幕。
    
    /> awk 'BEGIN { printf "What is your name? "; \
        getline name < "/dev/tty"}\
        $1 ~ name {print "Found" name " on line ", NR "."}\
        END {print "See ya, " name "."}' employees2
    What is your name? Mary
    Found Mary on line  2.
    See ya, Mary.    
    上例先是打印出BEGIN块中的"What is your name? "，然后等待用户从/dev/tty输入，并将读入的数据赋值给name变量，之后再从输入文件中读取记录，并找到匹配输入变量的记录并打印出来，最后在END块中输出结尾信息。
    
    /> awk 'BEGIN { while(getline < "/etc/passwd" > 0) lc++; print lc}'
    32
    awk将逐行读取/etc/passwd文件中的内容，在达到文件末尾之前，计数器lc一直自增1，当到了末尾后打印lc的值。lc的值为/etc/passwd文件的行数。
    由于awk中同时打开的管道只有一个，那么在打开下一个管道之前必须关闭它，管道符号右边可以通过可以通过双引号关闭管道。如果不关闭，它将始终保持打开状态，直到awk退出。
    /> awk {print $1,$2,$3 | "sort -4 +1 -2 +0 -1"} END {close("sort -4 +1 -2 +0 -1") } filename
    上例中END模块中的close显示关闭了sort的管道，需要注意的是close中关闭的命令必须和当初打开时的完全匹配，否则END模块产生的输出会和以前的输出一起被sort分类。


    3.  条件语句：
    awk中的条件语句是从C语言中借鉴来的，见如下声明方式：
    if (expression) {
        statement;
        statement;
        ... ...
    }
    /> awk '{if ($6 > 50) print $1 "Too hign"}' filename
    /> awk '{if ($6 > 20 && $6 <= 50) { safe++; print "OK"}}' filename

    if (expression) {
        statement;
    } else {
        statement2;
    }
    /> awk '{if ($6 > 50) print $1 " Too high"; else print "Range is OK" }' filename
    /> awk '{if ($6 > 50) { count++; print $3 } else { x = 5; print $5 }' filename

    if (expression) {
        statement1;
    } else if (expression1) {
        statement2;
    } else {
        statement3;
    }
    /> awk '{if ($6 > 50) print "$6 > 50" else if ($6 > 30) print "$6 > 30" else print "other"}' filename

   4.  循环语句：
    awk中的循环语句同样借鉴于C语言，支持while、do/while、for、break、continue，这些关键字的语义和C语言中的语义完全相同。

    5.  流程控制语句：
    next语句是从文件中读取下一行，然后从头开始执行awk脚本。
    exit语句用于结束awk程序。它终止对记录的处理。但是不会略过END模块，如果exit()语句被赋值0--255之间的参数，如exit(1)，这个参数就被打印到命令行，以判断退出成功还是失败。

    6.  数组：
    因为awk中数组的下标可以是数字和字母，数组的下标通常被称为关键字(key)。值和关键字都存储在内部的一张针对key/value应用hash的表格里。由于hash不是顺序存储，因此在显示数组内容时会发现，它们并不是按照你预料的顺序显示出来的。数组和变量一样，都是在使用时自动创建的，awk也同样会自动判断其存储的是数字还是字符串。一般而言，awk中的数组用来从记录中收集信息，可以用于计算总和、统计单词以及跟踪模板被匹配的次数等等。
    /> cat employees
    Tom Jones       4424    5/12/66         543354
    Mary Adams      5346    11/4/63         28765
    Sally Chang     1654    7/22/54         650000
    Billy Black     1683    9/23/44         336500

    /> awk '{name[x++] = $2}; END{for (i = 0; i < NR; i++) print i, name[i]}' employees    
    0 Jones
    1 Adams
    2 Chang
    3 Black
    在上例中，数组name的下标是变量x。awk初始化该变量的值为0，在每次使用后自增1，读取文件中的第二个域的值被依次赋值给name数组的各个元素。在END模块中，for循环遍历数组的值。因为下标是关键字，所以它不一定从0开始，可以从任何值开始。

    #这里是用内置变量NR作为数组的下标了。
    /> awk '{id[NR] = $3}; END {for (x = 1; x <= NR; x++) print id[x]}' employees
    4424
    5346
    1654
    1683

    awk中还提供了一种special for的循环，见如下声明：
    for (item in arrayname) {
        print arrayname[item]
    }

    /> cat db
    Tom Jones
    Mary Adams
    Sally Chang
    Billy Black
    Tom Savage
    Tom Chung
    Reggie Steel
    Tommy Tucker

    /> awk '/^Tom/{name[NR]=$1}; END {for(i = 1;i <= NR; i++) print name[i]}' db
    Tom



    Tom
    Tom

    Tommy
    从输出结果可以看出，只有匹配正则表达式的记录的第一个域被赋值给数组name的指定下标元素。因为用NR作为下标，所以数组的下标不可能是连续的，因此在END模块中用传统的for循环打印时，不存在的元素就打印空字符串了。下面我们看看用special for的方式会有什么样的输出。
    /> awk '/^Tom/{name[NR]=$1};END{for(i in name) print name[i]}' db
    Tom
    Tom
    Tommy
    Tom

    下面我们看一下用字符串作为下标的例子：(如果下标是字符串文字常量，则需要用双引号括起来)    
    /> cat testfile2
    tom
    mary
    sean
    tom
    mary
    mary
    bob
    mary
    alex
    /> awk '/tom/{count["tom"]++}; /mary/{count["mary"]++}; END{print "There are " count["tom"] \
        " Toms and " count["mary"] " Marys in the file."}' testfile2
    There are 2 Toms and 4 Marys in the file.
    在上例中，count数组有两个元素，下标分别为tom和mary，每一个元素的初始值都是0，没有tom被匹配的时候，count["tom"]就会加一，count["mary"]在匹配mary的时候也同样如此。END模块中打印出存储在数组中的各个元素。

    /> awk '{count[$1]++}; END{for(name in count) printf "%-5s%d\n",name, count[name]}' testfile2
    mary 4
    tom  2
    alex 1
    bob  1
    sean 1
    在上例中，awk是以记录的域作为数组count的下标。

    /> awk '{count[$1]++; if (count[$1] > 1) name[$1]++}; END{print "The duplicates were "; for(i in name) print i}' testfile2
    The duplicates were
    mary
    tom
    在上例中，如count[$1]的元素值大于1的时候，也就是当名字出现多次的时候，一个新的数组name将被初始化，最后打印出那么数组中重复出现的名字下标。

    之前我们介绍的都是如何给数组添加新的元素，并赋予初值，现在我们需要介绍一下如何删除数组中已经存在的元素。要完成这一功能我们需要使用内置函数delete，见如下命令：
    /> awk '{count[$1]++}; \
        END{for(name in count) {\
                if (count[name] == 1)\
                    delete count[name];\
            } \
            for (name in count) \
                print name}' testfile2
    mary
    tom
    上例中的主要技巧来自END模块，先是变量count数组，如果数组中某个元素的值等于1，则删除该元素，这样等同于删除只出现一次的名字。最后用special for循环打印出数组中仍然存在的元素下标名称。

    最后我们来看一下如何使用命令行参数数组，见如下命令：
    /> awk 'BEGIN {for(i = 0; i < ARGC; i++) printf("argv[%d] is %s.\n",i,ARGV[i]); printf("The number of arguments, ARGC=%d\n",ARGC)}' testfile "Peter Pan" 12
    argv[0] is awk.
    argv[1] is testfile.
    argv[2] is Peter Pan.
    argv[3] is 12.
    The number of arguments, ARGC=4
    从输出结果可以看出，命令行参数数组ARGV是以0作为起始下标的，命令行的第一个参数为命令本身(awk)，这个使用方式和C语句main函数完全一致。

    /> awk 'BEGIN{name=ARGV[2]; print "ARGV[2] is " ARGV[2]}; $1 ~ name{print $0}' testfile2 "bob"    
    ARGV[2] is bob
    bob
    awk: (FILENAME=testfile2 FNR=9) fatal: cannot open file 'bob' for reading (No such file or directory)
    先解释一下以上命令的含义，name变量被赋值为命令行的第三个参数，即bob，之后再在输入文件中找到匹配该变量值的记录，并打印出该记录。
    在输出的第二行报出了awk的处理错误信息，这主要是因为awk将bob视为输入文件来处理了，然而事实上这个文件并不存在，下面我们需要做进一步的处理来修正这个问题。
    /> awk 'BEGIN{name=ARGV[2]; print "ARGV[2] is " ARGV[2]; delete ARGV[2]}; $1 ~ name{print $0}' testfile2 "bob"    
    ARGV[2] is bob
    bob
    从输出结果中我们可以看到我们得到了我们想要的结果。需要注意的是delete函数的调用必要要在BEGIN模块中完成，因为这时awk还没有开始读取命令行参数中指定的文件。

    7.  内建函数：
    字符串函数
    sub(regular expression,substitution string);
    sub(regular expression,substitution string,target string);

    /> awk '{sub("Tom","Tommy"); print}' employees   #这里使用Tommy替换了Tom。
    Tommy Jones       4424    5/12/66         543354

    #当正则表达式Tom在第一个域中第一次被匹配后，他将被字符串"Tommy"替换，如果将sub函数的第三个参数改为$2，将不会有替换发生。
    /> awk '{sub("Tom","Tommy",$1); print}' employees
    Tommy Jones       4424    5/12/66         543354

    gsub(regular expression,substitution string);
    gsub(regular expression,substitution string,target string);
    和sub不同的是，如果第一个参数中正则表达式在记录中出现多次，那么gsub将完成多次替换，而sub只是替换第一次出现的。

    index(string,substring)
    该函数将返回第二个参数在第一个参数中出现的位置，偏移量从1开始。
    /> awk 'BEGIN{print index("hello","el")}'
    2

    length(string)
    该函数返回字符串的长度。
    /> awk 'BEGIN{print length("hello")}'
    5

    substr(string,starting position)
    substr(string,starting position,length of string)
    该函数返回第一个参数的子字符串，其截取起始位置为第二个参数(偏移量为1)，截取长度为第三个参数，如果没有该参数，则从第二个参数指定的位置起，直到string的末尾。
    />  awk 'BEGIN{name = substr("Hello World",2,3); print name}'
    ell

    match(string,regular expression)
    该函数返回在字符串中正则表达式位置的索引，如果找不到指定的正则表达式就返回0.match函数设置内置变量RSTART为字符串中子字符串的开始位置，RLENGTH为到字字符串末尾的字符个数。
    /> awk 'BEGIN{start=match("Good ole CHINA", /[A-Z]+$/); print start}'
    10
    上例中的正则表达式[A-Z]+$表示在字符串的末尾搜索连续的大写字母。在字符串"Good ole CHINA"的第10个位置找到字符串"CHINA"。

    /> awk 'BEGIN{start=match("Good ole CHINA", /[A-Z]+$/); print RSTART, RLENGTH}'
    10 5
    RSTART表示匹配时的起始索引，RLENGTH表示匹配的长度。

    /> awk 'BEGIN{string="Good ole CHINA";start=match(string, /[A-Z]+$/); print substr(string,RSTART, RLENGTH)}'
    CHINA
    这里将match、RSTART、RLENGTH和substr巧妙的结合起来了。

    toupper(string)
    tolower(string)
    以上两个函数分别返回参数字符串的大写和小写的形式。
    /> awk 'BEGIN {print toupper("hello"); print tolower("WORLD")}'
    HELLO
    world

    split(string,array,field seperator)
    split(string,array)
    该函数使用作为第三个参数的域分隔符把字符串分隔为一个数组。如果第三个参数没有提供，则使用当前默认的FS值。
    /> awk 'BEGIN{split("11/20/2011",date,"/"); print date[2]}'
    20

    variable = sprintf("string with format specifiers ",expr1,expr2,...)
    该函数和printf的差别等同于C语言中printf和sprintf的差别。前者将格式化后的结果输出到输出流，而后者输出到函数的返回值中。
    /> awk 'BEGIN{line = sprintf("%-15s %6.2f ", "hello",4.2); print line}'
    hello             4.20

    时间函数：
    systime()
    该函数返回当前时间距离1970年1月1日之间相差的秒数。
    /> awk 'BEGIN{print systime()}'
    1321369554

    strftime()
    时间格式化函数，其格式化规则等同于C语言中的strftime函数提供的规则，见以下列表：
    数据格式 	含义
    %a 	Abbreviated weekday name
    %A 	Full weekday name
    %b 	Abbreviated month name
    %B 	Full month name
    %c 	Date and time representation appropriate for locale
    %d 	Day of month as decimal number (01 – 31)
    %H 	Hour in 24-hour format (00 – 23)
    %I 	Hour in 12-hour format (01 – 12)
    %j 	Day of year as decimal number (001 – 366)
    %m 	Month as decimal number (01 – 12)
    %M 	Minute as decimal number (00 – 59)
    %p 	Current locale s A.M./P.M. indicator for 12-hour clock
    %S 	Second as decimal number (00 – 59)
    %U 	Week of year as decimal number, with Sunday as first day of week (00 – 53)
    %w 	Weekday as decimal number (0 – 6; Sunday is 0)
    %W 	Week of year as decimal number, with Monday as first day of week (00 – 53)
    %x 	Date representation for current locale
    %X 	Time representation for current locale
    %y 	Year without century, as decimal number (00 – 99)
    %Y 	Year with century, as decimal number

    /> awk 'BEGIN{ print strftime("%D",systime())}'
    11/15/11
    /> awk 'BEGIN{ now = strftime("%T"); print now}'
    23:17:29

    内置数学函数：
    名称 	返回值
    atan2(x,y) 	y,x范围内的余切
    cos(x) 	余弦函数
    exp(x) 	求幂
    int(x) 	取整
    log(x) 	自然对数
    sin(x) 	正弦函数
    sqrt(x) 平方根

    /> awk 'BEGIN{print 31/3}'
    10.3333
    /> awk 'BEGIN{print int(31/3)}'
    10

    自定义函数：
    自定义函数可以放在awk脚本的任何可以放置模板和动作的地方。
    function name(parameter1,parameter2,...) {
        statements
        return expression
    }
    给函数中本地变量传递值。只使用变量的拷贝。数组通过地址或者指针传递，所以可以在函数内部直接改变数组元素的值。函数内部使用的任何没有作为参数传递的变量都被看做是全局变量，也就是这些变量对于整个程序都是可见的。如果变量在函数中发生了变化，那么就是在整个程序中发生了改变。唯一向函数提供本地变量的办法就是把他们放在参数列表中，这些参数通常被放在列表的最后。如果函数调用没有提供正式的参数，那么参数就初始化为空。return语句通常就返回程序控制并向调用者返回一个值。
    /> cat grades
    20 10
    30 20
    40 30

    /> cat add.sc
    function add(first,second) {
            return first + second
    }
    { print add($1,$2) }

    /> awk -f add.sc grades
    30
    50
    70
第28章 行的排序命令sort
block(行的排序命令sort){}
十二.   行的排序命令sort:

  1.  sort命令行选项：
    选项 	描述
    -t 	    字段之间的分隔符
    -f 	    基于字符排序时忽略大小写
    -k 	    定义排序的域字段，或者是基于域字段的部分数据进行排序
    -m 	    将已排序的输入文件，合并为一个排序后的输出数据流
    -n 	    以整数类型比较字段
    -o      outfile 	将输出写到指定的文件
    -r 	    倒置排序的顺序为由大到小，正常排序为由小到大
    -u 	    只有唯一的记录，丢弃所有具有相同键值的记录
    -b 	    忽略前面的空格


   2.  sort使用实例：
    提示：在下面的输出结果中红色标注的为第一排序字段，后面的依次为紫、绿。
    /> sed -n '1,5p' /etc/passwd > users
    /> cat users
    root:x:0:0:root:/root:/bin/bash
    bin:x:1:1:bin:/bin:/sbin/nologin
    daemon:x:2:2:daemon:/sbin:/sbin/nologin
    adm:x:3:4:adm:/var/adm:/sbin/nologin
    lp:x:4:7:lp:/var/spool/lpd:/sbin/nologin

    #-t定义了冒号为域字段之间的分隔符，-k 2指定基于第二个字段正向排序(字段顺序从1开始)。
    /> sort -t':' -k 1 users
    adm:x:3:4:adm:/var/adm:/sbin/nologin
    bin:x:1:1:bin:/bin:/sbin/nologin
    daemon:x:2:2:daemon:/sbin:/sbin/nologin
    lp:x:4:7:lp:/var/spool/lpd:/sbin/nologin
    root:x:0:0:root:/root:/bin/bash

    #还是以冒号为分隔符，这次是基于第三个域字段进行倒置排序。
    /> sort -t':' -k 3r users
    lp:x:4:7:lp:/var/spool/lpd:/sbin/nologin
    adm:x:3:4:adm:/var/adm:/sbin/nologin
    daemon:x:2:2:daemon:/sbin:/sbin/nologin
    bin:x:1:1:bin:/bin:/sbin/nologin
    root:x:0:0:root:/root:/bin/bash

    #先以第六个域的第2个字符到第4个字符进行正向排序，在基于第一个域进行反向排序。
    /> sort -t':' -k 6.2,6.4 -k 1r users
    bin:x:1:1:bin:/bin:/sbin/nologin
    root:x:0:0:root:/root:/bin/bash
    daemon:x:2:2:daemon:/sbin:/sbin/nologin
    lp:x:4:7:lp:/var/spool/lpd:/sbin/nologin
    adm:x:3:4:adm:/var/adm:/sbin/nologin

    #先以第六个域的第2个字符到第4个字符进行正向排序，在基于第一个域进行正向排序。和上一个例子比，第4和第5行交换了位置。
    /> sort -t':' -k 6.2,6.4 -k 1 users
    bin:x:1:1:bin:/bin:/sbin/nologin
    root:x:0:0:root:/root:/bin/bash
    daemon:x:2:2:daemon:/sbin:/sbin/nologin
    adm:x:3:4:adm:/var/adm:/sbin/nologin
    lp:x:4:7:lp:/var/spool/lpd:/sbin/nologin

    #基于第一个域的第2个字符排序
    /> sort -t':' -k 1.2,1.2 users    
    daemon:x:2:2:daemon:/sbin:/sbin/nologin
    adm:x:3:4:adm:/var/adm:/sbin/nologin
    bin:x:1:1:bin:/bin:/sbin/nologin
    root:x:0:0:root:/root:/bin/bash
    lp:x:4:7:lp:/var/spool/lpd:/sbin/nologin

    #基于第六个域的第2个字符到第4个字符进行正向排序，-u命令要求在排序时删除键值重复的行。
    /> sort -t':' -k 6.2,6.4 -u users
    bin:x:1:1:bin:/bin:/sbin/nologin
    root:x:0:0:root:/root:/bin/bash
    daemon:x:2:2:daemon:/sbin:/sbin/nologin
    adm:x:3:4:adm:/var/adm:/sbin/nologin

    /> cat /etc/passwd | wc -l  #计算该文件中文本的行数。
    39
    /> sed -n '35,$p' /etc/passwd > users2  #取最后5行并输出到users2中。
    /> cat users2
    sshd:x:74:74:Privilege-separated SSH:/var/empty/sshd:/sbin/nologin
    mysql:x:27:27:MySQL Server:/var/lib/mysql:/bin/bash
    pulse:x:496:494:PulseAudio System Daemon:/var/run/pulse:/sbin/nologin
    gdm:x:42:42::/var/lib/gdm:/sbin/nologin
    stephen:x:500:500:stephen:/home/stephen:/bin/bash

    #基于第3个域字段以文本的形式排序
    /> sort -t':' -k 3 users2
    mysql:x:27:27:MySQL Server:/var/lib/mysql:/bin/bash
    gdm:x:42:42::/var/lib/gdm:/sbin/nologin
    pulse:x:496:494:PulseAudio System Daemon:/var/run/pulse:/sbin/nologin
    stephen:x:500:500:stephen:/home/stephen:/bin/bash
    sshd:x:74:74:Privilege-separated SSH:/var/empty/sshd:/sbin/nologin

    #基于第3个域字段以数字的形式排序
    /> sort -t':' -k 3n users2
    mysql:x:27:27:MySQL Server:/var/lib/mysql:/bin/bash
    gdm:x:42:42::/var/lib/gdm:/sbin/nologin
    sshd:x:74:74:Privilege-separated SSH:/var/empty/sshd:/sbin/nologin
    pulse:x:496:494:PulseAudio System Daemon:/var/run/pulse:/sbin/nologin
    stephen:x:500:500:stephen:/home/stephen:/bin/bash

    #基于当前系统执行进程的owner名排序，并将排序的结果写入到result文件中
    /> ps -ef | sort -k 1 -o result
    
第28章 删除重复行的命令uniq
block(删除重复行的命令uniq){}
十三. 删除重复行的命令uniq:

    uniq有3个最为常用的选项，见如下列表：
    选项 	命令描述
    -c 	可在每个输出行之前加上该行重复的次数
    -d 	仅显示重复的行
    -u 	显示为重复的行

    /> cat testfile
    hello
    world
    friend
    hello
    world
    hello

    #直接删除未经排序的文件，将会发现没有任何行被删除
    /> uniq testfile  
    hello
    world
    friend
    hello
    world
    hello

    #排序之后删除了重复行，同时在行首位置输出该行重复的次数
    /> sort testfile | uniq -c  
    1 friend
    3 hello
    2 world

    #仅显示存在重复的行，并在行首显示该行重复的次数
    /> sort testfile | uniq -dc
    3 hello
    2 world

    #仅显示没有重复的行
    /> sort testfile | uniq -u
    friend  
第28章 文件压缩解压命令tar
block(文件压缩解压命令tar){}
十四. 文件压缩解压命令tar:
   1.  tar命令行选项
    选项 	命令描述
    -c 	建立压缩档案
    -x 	解压
    --delete 	从压缩包中删除已有文件，如果该文件在包中出现多次，该操作其将全部删除。
    -t 	查看压缩包中的文件列表
    -r 	向压缩归档文件末尾追加文件
    -u 	更新原压缩包中的文件
    -z 	压缩为gzip格式，或以gzip格式解压
    -j 	压缩为bzip2格式，或以bzip2格式解压
    -v 	显示压缩或解压的过程，该选项一般不适于后台操作
    -f 	使用档案名字，这个参数是最后一个参数，后面只能接档案名。


    2.  tar使用实例：
    #将当前目录下所有文件压缩打包，需要说明的是很多人都习惯将tar工具压缩的文件的扩展名命名为.tar
    /> tar -cvf test.tar *
    -rw-r--r--. 1 root root   183 Nov 11 08:02 users
    -rw-r--r--. 1 root root   279 Nov 11 08:45 users2

    /> cp ../*.log .                  #从上一层目录新copy一个.log文件到当前目录。
    /> tar -rvf test.tar *.log     #将扩展名为.log的文件追加到test.tar包里。
    /> tar -tvf test.tar
    -rw-r--r-- root/root        183 2011-11-11 08:02 users
    -rw-r--r-- root/root        279 2011-11-11 08:45 users2
    -rw-r--r-- root/root     48217 2011-11-11 22:16 install.log

    /> touch install.log           #使原有的文件更新一下最新修改时间
    /> tar -uvf test.tar *.log    #重新将更新后的log文件更新到test.tar中
    /> tar -tvf test.tar             #从输出结果可以看出tar包中多出一个更新后install.log文件。
    -rw-r--r-- root/root         183 2011-11-11 08:02 users
    -rw-r--r-- root/root         279 2011-11-11 08:45 users2
    -rw-r--r-- root/root     48217 2011-11-11 22:16 install.log
    -rw-r--r-- root/root     48217 2011-11-11 22:20 install.log

    /> tar --delete install.log -f test.tar #基于上面的结果，从压缩包中删除install.log
    -rw-r--r-- root/root       183 2011-11-11 08:02 users
    -rw-r--r-- root/root       279 2011-11-11 08:45 users2

    /> rm -f users users2      #从当前目录将tar中的两个文件删除
    /> tar -xvf test.tar          #解压
    /> ls -l users*                 #仅列出users和users2的详细列表信息
    -rw-r--r--. 1 root root 183 Nov 11 08:02 users
    -rw-r--r--. 1 root root 279 Nov 11 08:45 users2

    #以gzip的格式压缩并打包，解压时也应该以同样的格式解压，需要说明的是以该格式压缩的包习惯在扩展名后加.gz
    /> tar -cvzf test.tar.gz *
    /> tar -tzvf test.tar.gz      #查看压缩包中文件列表时也要加z选项(gzip格式)
    -rw-r--r-- root/root     48217 2011-11-11 22:50 install.log
    -rw-r--r-- root/root         183 2011-11-11 08:02 users
    -rw-r--r-- root/root         279 2011-11-11 08:45 users2

    /> rm -f users users2 install.log
    /> tar -xzvf test.tar.gz     #以gzip的格式解压
    /> ls -l *.log users*
    -rw-r--r-- root/root     48217 2011-11-11 22:50 install.log
    -rw-r--r-- root/root         183 2011-11-11 08:02 users
    -rw-r--r-- root/root         279 2011-11-11 08:45 users2

    /> rm -f test.*                #删除当前目录下原有的压缩包文件
    #以bzip2的格式压缩并打包，解压时也应该以同样的格式解压，需要说明的是以该格式压缩的包习惯在扩展名后加.bz2
    /> tar -cvjf test.tar.bz2 *
    /> tar -tjvf test.tar.bz2    #查看压缩包中文件列表时也要加j选项(bzip2格式)
    -rw-r--r-- root/root     48217 2011-11-11 22:50 install.log
    -rw-r--r-- root/root         183 2011-11-11 08:02 users
    -rw-r--r-- root/root         279 2011-11-11 08:45 users2

    /> rm -f *.log user*
    /> tar -xjvf test.tar.bz2    #以bzip2的格式解压
    /> ls -l
    -rw-r--r--. 1 root root 48217 Nov 11 22:50 install.log
    -rw-r--r--. 1 root root 10530 Nov 11 23:08 test.tar.bz2
    -rw-r--r--. 1 root root     183 Nov 11 08:02 users
    -rw-r--r--. 1 root root     279 Nov 11 08:45 users2
第28章 大文件拆分命令split
block(大文件拆分命令split){}
十五. 大文件拆分命令split:

    下面的列表中给出了该命令最为常用的几个命令行选项：
    选项 	描述
    -l 	指定行数，每多少分隔成一个文件，缺省值为1000行。
    -b 	指定字节数，支持的单位为：k和m
    -C 	与-b参数类似，但切割时尽量维持每行的完整性
    -d 	生成文件的后缀为数字，如果不指定该选项，缺省为字母

    /> ls -l
    -rw-r--r--. 1 root root 10530 Nov 11 23:08 test.tar.bz2

    /> split -b 5k test.tar.bz2     #以每文件5k的大小切割test.tar.bz2
    /> ls -l                                #查看切割后的结果，缺省情况下拆分后的文件名为以下形式。
    -rw-r--r--. 1 root root 10530 Nov 11 23:08 test.tar.bz2
    -rw-r--r--. 1 root root   5120 Nov 11 23:34 xaa
    -rw-r--r--. 1 root root   5120 Nov 11 23:34 xab
    -rw-r--r--. 1 root root     290 Nov 11 23:34 xac

    /> rm -f x*                         #删除拆分后的小文件
    /> split -d -b 5k test.tar.bz2 #-d选项以后缀为数字的形式命名拆分后的小文件
    /> ls -l
    -rw-r--r--. 1 root root 10530 Nov 11 23:08 test.tar.bz2
    -rw-r--r--. 1 root root   5120 Nov 11 23:36 x00
    -rw-r--r--. 1 root root   5120 Nov 11 23:36 x01
    -rw-r--r--. 1 root root     290 Nov 11 23:36 x02

    /> wc install.log -l             #计算该文件的行数
    /> split -l 300 install.log     #每300行拆分成一个小文件
    /> ls -l x*
    -rw-r--r--. 1 root root 11184 Nov 11 23:42 xaa
    -rw-r--r--. 1 root root 10805 Nov 11 23:42 xab
    -rw-r--r--. 1 root root 12340 Nov 11 23:42 xac
    -rw-r--r--. 1 root root 11783 Nov 11 23:42 xad
    -rw-r--r--. 1 root root   2105 Nov 11 23:42 xae
第28章 文件查找命令find
block(文件查找命令find){}
十六. 文件查找命令find:

    下面给出find命令的主要应用示例：
    /> ls -l     #列出当前目录下所包含的测试文件
    -rw-r--r--. 1 root root 48217 Nov 12 00:57 install.log
    -rw-r--r--. 1 root root      37 Nov 12 00:56 testfile.dat
    -rw-r--r--. 1 root root 10530 Nov 11 23:08 test.tar.bz2
    -rw-r--r--. 1 root root     183 Nov 11 08:02 users
    -rw-r--r--. 1 root root     279 Nov 11 08:45 users2
    
    1. 按文件名查找：
    -name:  查找时文件名大小写敏感。
    -iname: 查找时文件名大小写不敏感。
    #该命令为find命令中最为常用的命令，即从当前目录中查找扩展名为.log的文件。需要说明的是，缺省情况下，find会从指定的目录搜索，并递归的搜索其子目录。
    /> find . -name "*.log"
     ./install.log
    /> find . -iname U*          #如果执行find . -name U*将不会找到匹配的文件
    users users2


    2. 按文件时间属性查找：
    -atime  -n[+n]: 找出文件访问时间在n日之内[之外]的文件。
    -ctime  -n[+n]: 找出文件更改时间在n日之内[之外]的文件。
    -mtime -n[+n]: 找出修改数据时间在n日之内[之外]的文件。
    -amin   -n[+n]: 找出文件访问时间在n分钟之内[之外]的文件。
    -cmin   -n[+n]: 找出文件更改时间在n分钟之内[之外]的文件。
    -mmin  -n[+n]: 找出修改数据时间在n分钟之内[之外]的文件。
    /> find -ctime -2        #找出距此时2天之内创建的文件
    .
    ./users2
    ./install.log
    ./testfile.dat
    ./users
    ./test.tar.bz2
    /> find -ctime +2        #找出距此时2天之前创建的文件
    没有找到                     #因为当前目录下所有文件都是2天之内创建的
    /> touch install.log     #手工更新install.log的最后访问时间，以便下面的find命令可以找出该文件
    /> find . -cmin  -3       #找出修改状态时间在3分钟之内的文件。
    install.log

    3. 基于找到的文件执行指定的操作：
    -exec: 对匹配的文件执行该参数所给出的shell命令。相应命令的形式为'command' {} \;，注意{}和\；之间的空格，同时两个{}之间没有空格
    -ok:   其主要功能和语法格式与-exec完全相同，唯一的差别是在于该选项更加安全，因为它会在每次执行shell命令之前均予以提示，只有在回答为y的时候，其后的shell命令才会被继续执行。需要说明的是，该选项不适用于自动化脚本，因为该提供可能会挂起整个自动化流程。
    #找出距此时2天之内创建的文件，同时基于find的结果，应用-exec之后的命令，即ls -l，从而可以直接显示出find找到文件的明显列表。
    /> find . -ctime -2 -exec ls -l {} \;
    -rw-r--r--. 1 root root      279 Nov 11 08:45 ./users2
    -rw-r--r--. 1 root root  48217 Nov 12 00:57 ./install.log
    -rw-r--r--. 1 root root        37 Nov 12 00:56 ./testfile.dat
    -rw-r--r--. 1 root root      183 Nov 11 08:02 ./users
    -rw-r--r--. 1 root root  10530 Nov 11 23:08 ./test.tar.bz2
    #找到文件名为*.log, 同时文件数据修改时间距此时为1天之内的文件。如果找到就删除他们。有的时候，这样的写法由于是在找到之后立刻删除，因此存在一定误删除的危险。
    /> ls
    install.log  testfile.dat  test.tar.bz2  users  users2
    /> find . -name "*.log" -mtime -1 -exec rm -f {} \;
    /> ls
    testfile.dat  test.tar.bz2  users  users2
    在控制台下，为了使上面的命令更加安全，我们可以使用-ok替换-exec，见如下示例：
    />  find . -name "*.dat" -mtime -1 -ok rm -f {} \;
    < rm ... ./testfile.dat > ? y    #对于该提示，如果回答y，找到的*.dat文件将被删除，这一点从下面的ls命令的结果可以看出。
    /> ls
    test.tar.bz2  users  users2

    4. 按文件所属的owner和group查找：
    -user:      查找owner属于-user选项后面指定用户的文件。
    ! -user:    查找owner不属于-user选项后面指定用户的文件。
    -group:   查找group属于-group选项后面指定组的文件。
    ! -group: 查找group不属于-group选项后面指定组的文件。
    /> ls -l                            #下面三个文件的owner均为root
    -rw-r--r--. 1 root root 10530 Nov 11 23:08 test.tar.bz2
    -rw-r--r--. 1 root root     183 Nov 11 08:02 users
    -rw-r--r--. 1 root root     279 Nov 11 08:45 users2
    /> chown stephen users   #将users文件的owner从root改为stephen。
    /> ls -l
    -rw-r--r--. 1 root       root 10530 Nov 11 23:08 test.tar.bz2
    -rw-r--r--. 1 stephen root    183 Nov 11 08:02 users
    -rw-r--r--. 1 root       root     279 Nov 11 08:45 users2
    /> find . -user root          #搜索owner是root的文件
    .
    ./users2
    ./test.tar.bz2
    /> find . ! -user root        #搜索owner不是root的文件，注意!和-user之间要有空格。
    ./users
    /> ls -l                            #下面三个文件的所属组均为root
    -rw-r--r--. 1 root      root 10530 Nov 11 23:08 test.tar.bz2
    -rw-r--r--. 1 stephen root    183 Nov 11 08:02 users
    -rw-r--r--. 1 root      root    279 Nov 11 08:45 users2
    /> chgrp stephen users    #将users文件的所属组从root改为stephen
    /> ls -l
    -rw-r--r--. 1 root           root    10530 Nov 11 23:08 test.tar.bz2
    -rw-r--r--. 1 stephen stephen      183 Nov 11 08:02 users
    -rw-r--r--. 1 root            root       279 Nov 11 08:45 users2
    /> find . -group root        #搜索所属组是root的文件
    .
    ./users2
    ./test.tar.bz2
    /> find . ! -group root      #搜索所属组不是root的文件，注意!和-user之间要有空格。    
    ./users

    5. 按指定目录深度查找：
    -maxdepth: 后面的参数表示距当前目录指定的深度，其中1表示当前目录，2表示一级子目录，以此类推。在指定该选项后，find只是在找到指定深度后就不在递归其子目录了。下例中的深度为1，表示只是在当前子目录中搜索。如果没有设置该选项，find将递归当前目录下的所有子目录。
    /> mkdir subdir               #创建一个子目录，并在该子目录内创建一个文件
    /> cd subdir
    /> touch testfile
    /> cd ..
    #maxdepth后面的参数表示距当前目录指定的深度，其中1表示当前目录，2表示一级子目录，以此类推。在指定该选项后，find只是在找到指定深度后就不在递归其子目录了。下例中的深度为1，表示只是在当前子目录中搜索。如果没有设置该选项，find将递归当前目录下的所有子目录。
    /> find . -maxdepth 1 -name "*"
    .
    ./users2
    ./subdir
    ./users
    ./test.tar.bz2
    #搜索深度为子一级子目录，这里可以看出子目录下刚刚创建的testfile已经被找到
    /> find . -maxdepth 2 -name "*"  
    .
    ./users2
    ./subdir
    ./subdir/testfile
    ./users
    ./test.tar.bz2
   
    6. 排除指定子目录查找：
    -path pathname -prune:   避开指定子目录pathname查找。
    -path expression -prune:  避开表达中指定的一组pathname查找。
    需要说明的是，如果同时使用-depth选项，那么-prune将被find命令忽略。
    #为后面的示例创建需要避开的和不需要避开的子目录，并在这些子目录内均创建符合查找规则的文件。
    /> mkdir DontSearchPath  
    /> cd DontSearchPath
    /> touch datafile1
    /> cd ..
    /> mkdir DoSearchPath
    /> cd DoSearchPath
    /> touch datafile2
    /> cd ..
    /> touch datafile3
    #当前目录下，避开DontSearchPath子目录，搜索所有文件名为datafile*的文件。
    /> find . -path "./DontSearchPath" -prune -o -name "datafile*" -print
    ./DoSearchPath/datafile2
    ./datafile3
    #当前目录下，同时避开DontSearchPath和DoSearchPath两个子目录，搜索所有文件名为datafile*的文件。
    /> find . \( -path "./DontSearchPath" -o -path "./DoSearchPath" \) -prune -o -name "datafile*" -print
    ./datafile3
       
    7. 按文件权限属性查找：
    -perm mode:   文件权限正好符合mode(mode为文件权限的八进制表示)。
    -perm +mode: 文件权限部分符合mode。如命令参数为644(-rw-r--r--)，那么只要文件权限属性中有任何权限和644重叠，这样的文件均可以被选出。
    -perm -mode:  文件权限完全符合mode。如命令参数为644(-rw-r--r--)，当644中指定的权限已经被当前文件完全拥有，同时该文件还拥有额外的权限属性，这样的文件可被选出。
    /> ls -l
    -rw-r--r--. 1 root            root           0 Nov 12 10:02 datafile3
    -rw-r--r--. 1 root            root    10530 Nov 11 23:08 test.tar.bz2
    -rw-r--r--. 1 stephen stephen        183 Nov 11 08:02 users
    -rw-r--r--. 1 root            root        279 Nov 11 08:45 users2
    /> find . -perm 644      #查找所有文件权限正好为644(-rw-r--r--)的文件。
    ./users2
    ./datafile3
    ./users
    ./test.tar.bz2
    /> find . -perm 444      #当前目录下没有文件的权限属于等于444(均为644)。    
    /> find . -perm -444     #644所包含的权限完全覆盖444所表示的权限。
    .
    ./users2
    ./datafile3
    ./users
    ./test.tar.bz2
    /> find . -perm +111    #查找所有可执行的文件，该命令没有找到任何文件。
    /> chmod u+x users     #改变users文件的权限，添加owner的可执行权限，以便于下面的命令可以将其找出。
    /> find . -perm +111    
    .
    ./users    
   
    8. 按文件类型查找：
    -type：后面指定文件的类型。
    b - 块设备文件。
    d - 目录。
    c - 字符设备文件。
    p - 管道文件。
    l  - 符号链接文件。
    f  - 普通文件。
    /> mkdir subdir
    /> find . -type d      #在当前目录下，找出文件类型为目录的文件。
    ./subdir
　 /> find . ! -type d    #在当前目录下，找出文件类型不为目录的文件。
    ./users2
    ./datafile3
    ./users
    ./test.tar.bz2
    /> find . -type f       #在当前目录下，找出文件类型为文件的文件
    ./users2
    ./datafile3
    ./users
    ./test.tar.bz2
   
    9. 按文件大小查找：
    -size [+/-]100[c/k/M/G]: 表示文件的长度为等于[大于/小于]100块[字节/k/M/G]的文件。
    -empty: 查找空文件。
    /> find . -size +4k -exec ls -l {} \;  #查找文件大小大于4k的文件，同时打印出找到文件的明细
    -rw-r--r--. 1 root root 10530 Nov 11 23:08 ./test.tar.bz2
    /> find . -size -4k -exec ls -l {} \;  #查找文件大小小于4k的文件。
    -rw-r--r--. 1 root            root 279 Nov 11 08:45 ./users2
    -rw-r--r--. 1 root             root    0 Nov 12 10:02 ./datafile3
    -rwxr--r--. 1 stephen stephen 183 Nov 11 08:02 ./users
    /> find . -size 183c -exec ls -l {} \; #查找文件大小等于183字节的文件。
    -rwxr--r--. 1 stephen stephen 183 Nov 11 08:02 ./users
    /> find . -empty  -type f -exec ls -l {} \;
    -rw-r--r--. 1 root root 0 Nov 12 10:02 ./datafile3
   
    10. 按更改时间比指定文件新或比文件旧的方式查找：
    -newer file1 ! file2： 查找文件的更改日期比file1新，但是比file2老的文件。
    /> ls -lrt   #以时间顺序(从早到晚)列出当前目录下所有文件的明细列表，以供后面的例子参考。
    -rwxr--r--. 1 stephen stephen   183 Nov 11 08:02 users1
    -rw-r--r--. 1 root           root    279 Nov 11 08:45 users2
    -rw-r--r--. 1 root           root 10530 Nov 11 23:08 test.tar.bz2
    -rw-r--r--. 1 root           root        0 Nov 12 10:02 datafile3
    /> find . -newer users1     #查找文件更改日期比users1新的文件，从上面结果可以看出，其余文件均符合要求。
    ./users2
    ./datafile3
    ./test.tar.bz2
    /> find . ! -newer users2   #查找文件更改日期不比users1新的文件。
    ./users2
    ./users
    #查找文件更改日期比users2新，但是不比test.tar.bz2新的文件。
    /> find . -newer users2 ! -newer test.tar.bz2
    ./test.tar.bz2
   
    细心的读者可能发现，关于find的说明，在我之前的Blog中已经给出，这里之所以拿出一个小节再次讲述该命令主要是因为以下三点原因：
    1. find命令在Linux Shell中扮演着极为重要的角色；
    2. 为了保证本系列的完整性；
    3. 之前的Blog是我多年之前留下的总结笔记，多少有些粗糙，这里给出了更为详细的举例。
第28章 xargs命令
block(xargs命令){}
十七. xargs命令:
    该命令的主要功能是从输入中构建和执行shell命令。       
    在使用find命令的-exec选项处理匹配到的文件时， find命令将所有匹配到的文件一起传递给exec执行。但有些系统对能够传递给exec的命令长度有限制，这样在find命令运行几分钟之后，就会出现溢出错误。错误信息通常是“参数列太长”或“参数列溢出”。这就是xargs命令的用处所在，特别是与find命令一起使用。  
    find命令把匹配到的文件传递给xargs命令，而xargs命令每次只获取一部分文件而不是全部，不像-exec选项那样。这样它可以先处理最先获取的一部分文件，然后是下一批，并如此继续下去。  
    在有些系统中，使用-exec选项会为处理每一个匹配到的文件而发起一个相应的进程，并非将匹配到的文件全部作为参数一次执行；这样在有些情况下就会出现进程过多，系统性能下降的问题，因而效率不高；  
    而使用xargs命令则只有一个进程。另外，在使用xargs命令时，究竟是一次获取所有的参数，还是分批取得参数，以及每一次获取参数的数目都会根据该命令的选项及系统内核中相应的可调参数来确定。
    /> ls -l
    -rw-r--r--. 1 root root        0 Nov 12 10:02 datafile3
    -rw-r--r--. 1 root root 10530 Nov 11 23:08 test.tar.bz2
    -rwxr--r--. 1 root root    183 Nov 11 08:02 users
    -rw-r--r--. 1 root root    279 Nov 11 08:45 users2
    #查找当前目录下的每一个普通文件，然后使用xargs命令来测试它们分别属于哪类文件。
    /> find . -type f -print | xargs file
    ./users2:        ASCII text
    ./datafile3:      empty
    ./users:          ASCII text
    ./test.tar.bz2: bzip2 compressed data, block size = 900k
    #回收当前目录下所有普通文件的执行权限。
    /> find . -type f -print | xargs chmod a-x
    /> ls -l
    -rw-r--r--. 1 root root     0 Nov 12 10:02 datafile3
    -rw-r--r--. 1 root root 10530 Nov 11 23:08 test.tar.bz2
    -rw-r--r--. 1 root root   183 Nov 11 08:02 users
    -rw-r--r--. 1 root root   279 Nov 11 08:45 users2
    #在当面目录下查找所有普通文件，并用grep命令在搜索到的文件中查找hostname这个词
    /> find . -type f -print | xargs grep "hostname"
    #在整个系统中查找内存信息转储文件(core dump) ，然后把结果保存到/tmp/core.log 文件中。
    /> find / -name "core" -print | xargs echo "" >/tmp/core.log 　

    /> pgrep mysql | xargs kill -9　　#直接杀掉mysql的进程
    [1]+  Killed                  mysql
    
    # 假如你有一个文件包含了很多你希望下载的URL, 你能够使用xargs 下载所有链接 
    cat url-list.txt | xargs wget –c
    
    #  拷贝所有的图片文件到一个外部的硬盘驱动 
    ls *.jpg | xargs -n1 -i cp {} /external-hard-drive/directory
    
第28章 和系统运行状况相关的Shell命令
block(和系统运行状况相关的Shell命令){}
十八.  和系统运行状况相关的Shell命令:
第1节 watch
    1.  Linux的实时监测命令(watch):
    watch 是一个非常实用的命令，可以帮你实时监测一个命令的运行结果，省得一遍又一遍的手动运行。该命令最为常用的两个选项是-d和-n，其中-n表示间隔多少秒执行一次"command"，-d表示高亮发生变化的位置。下面列举几个在watch中常用的实时监视命令：
    /> watch -d -n 1 'who'   #每隔一秒执行一次who命令，以监视服务器当前用户登录的状况
    Every 1.0s: who       Sat Nov 12 12:37:18 2011
    
    stephen  tty1           2011-11-11 17:38 (:0)
    stephen  pts/0         2011-11-11 17:39 (:0.0)
    root       pts/1         2011-11-12 10:01 (192.168.149.1)
    root       pts/2         2011-11-12 11:41 (192.168.149.1)
    root       pts/3         2011-11-12 12:11 (192.168.149.1)
    stephen  pts/4         2011-11-12 12:22 (:0.0)
    此时通过其他Linux客户端工具以root的身份登录当前Linux服务器，再观察watch命令的运行变化。
    Every 1.0s: who       Sat Nov 12 12:41:09 2011
    
    stephen  tty1          2011-11-11 17:38 (:0)
    stephen  pts/0        2011-11-11 17:39 (:0.0)
    root       pts/1        2011-11-12 10:01 (192.168.149.1)
    root       pts/2        2011-11-12 11:41 (192.168.149.1)
    root       pts/3        2011-11-12 12:40 (192.168.149.1)
    stephen  pts/4        2011-11-12 12:22 (:0.0)
    root       pts/5        2011-11-12 12:41 (192.168.149.1)
    最后一行中被高亮的用户为新登录的root用户。此时按CTRL + C可以退出正在执行的watch监控进程。
   
    #watch可以同时运行多个命令，命令间用分号分隔。
    #以下命令监控磁盘的使用状况，以及当前目录下文件的变化状况，包括文件的新增、删除和文件修改日期的更新等。
    /> watch -d -n 1 'df -h; ls -l'
    Every 1.0s: df -h; ls -l     Sat Nov 12 12:55:00 2011
    
    Filesystem            Size  Used Avail Use% Mounted on
    /dev/sda1             5.8G  3.3G  2.2G  61% /
    tmpfs                 504M  420K  504M   1% /dev/shm
    total 20
    -rw-r--r--. 1 root root 10530 Nov 11 23:08 test.tar.bz2
    -rw-r--r--. 1 root root   183 Nov 11 08:02 users
    -rw-r--r--. 1 root root   279 Nov 11 08:45 users2
    此时通过另一个Linux控制台窗口，在watch监视的目录下，如/home/stephen/test，执行下面的命令
    /> touch aa         #在执行该命令之后，另一个执行watch命令的控制台将有如下变化
    Every 1.0s: df -h; ls -l                                Sat Nov 12 12:57:08 2011
    
    Filesystem            Size  Used Avail Use% Mounted on
    /dev/sda1             5.8G  3.3G  2.2G  61% /
    tmpfs                 504M  420K  504M   1% /dev/shm
    total 20
    -rw-r--r--. 1 root root        0 Nov 12 12:56 aa
    -rw-r--r--. 1 root root        0 Nov 12 10:02 datafile3
    -rw-r--r--. 1 root root 10530 Nov 11 23:08 test.tar.bz2
    -rw-r--r--. 1 root root     183 Nov 11 08:02 users
    -rw-r--r--. 1 root root     279 Nov 11 08:45 users2
    其中黄色高亮的部分，为touch aa命令执行之后watch输出的高亮变化部分。

第1节 free
    2.  查看当前系统内存使用状况(free)：
    free命令有以下几个常用选项：
    选项 	说明
    -b 	以字节为单位显示数据。
    -k 	以千字节(KB)为单位显示数据(缺省值)。
    -m 	以兆(MB)为单位显示数据。
    -s delay 	该选项将使free持续不断的刷新，每次刷新之间的间隔为delay指定的秒数，如果含有小数点，将精确到毫秒，如0.5为500毫秒，1为一秒。

    free命令输出的表格中包含以下几列：
    列名 	说明
    total 	总计物理内存的大小。
    used 	已使用的内存数量。
    free 	可用的内存数量。
    Shared 	多个进程共享的内存总额。
    Buffers/cached 	磁盘缓存的大小。


    见以下具体示例和输出说明：
    /> free -k
                        total         used          free     shared    buffers     cached
    Mem:       1031320     671776     359544          0      88796     352564
    -/+ buffers/cache:      230416     800904
    Swap:        204792              0     204792
    对于free命令的输出，我们只需关注红色高亮的输出行和绿色高亮的输出行，见如下具体解释：
    红色输出行：该行使从操作系统的角度来看待输出数据的，used(671776)表示内核(Kernel)+Applications+buffers+cached。free(359544)表示系统还有多少内存可供使用。
    绿色输出行：该行则是从应用程序的角度来看输出数据的。其free = 操作系统used + buffers + cached，既：
    800904 = 359544 + 88796 + 352564
    /> free -m
                      total        used        free      shared    buffers     cached
    Mem:          1007         656        351            0         86            344
    -/+ buffers/cache:        225        782
    Swap:          199             0        199
    /> free -k -s 1.5  #以千字节(KB)为单位显示数据，同时每隔1.5刷新输出一次，直到按CTRL+C退出
                      total        used       free     shared    buffers     cached
    Mem:          1007         655        351          0           86        344
    -/+ buffers/cache:        224        782
    Swap:          199             0        199

                      total        used       free     shared    buffers     cached
    Mem:          1007         655        351          0           86        344
    -/+ buffers/cache:        224        782
    Swap:          199             0        199
第1节 mpstat
    3.  CPU的实时监控工具(mpstat)：
    该命令主要用于报告当前系统中所有CPU的实时运行状况。
    #该命令将每隔2秒输出一次CPU的当前运行状况信息，一共输出5次，如果没有第二个数字参数，mpstat将每隔两秒执行一次，直到按CTRL+C退出。
    /> mpstat 2 5  
    Linux 2.6.32-71.el6.i686 (Stephen-PC)   11/12/2011      _i686_  (1 CPU)

    04:03:00 PM  CPU    %usr   %nice    %sys %iowait    %irq   %soft  %steal  %guest   %idle
    04:03:02 PM  all    0.00    0.00    0.50    0.00    0.00    0.00    0.00    0.00   99.50
    04:03:04 PM  all    0.00    0.00    0.00    0.00    0.00    0.00    0.00    0.00  100.00
    04:03:06 PM  all    0.00    0.00    0.00    0.00    0.00    0.00    0.00    0.00  100.00
    04:03:08 PM  all    0.00    0.00    0.00    0.00    0.00    0.00    0.00    0.00  100.00
    04:03:10 PM  all    0.00    0.00    0.00    0.00    0.00    0.00    0.00    0.00  100.00
    Average:       all    0.00    0.00    0.10    0.00    0.00    0.00    0.00    0.00   99.90

    第一行的末尾给出了当前系统中CPU的数量。后面的表格中则输出了系统当前CPU的使用状况，以下为每列的含义：
    列名 	说明
    %user 	在internal时间段里，用户态的CPU时间(%)，不包含nice值为负进程  (usr/total)*100
    %nice 	在internal时间段里，nice值为负进程的CPU时间(%)   (nice/total)*100
    %sys 	在internal时间段里，内核时间(%)       (system/total)*100
    %iowait 在internal时间段里，硬盘IO等待时间(%) (iowait/total)*100
    %irq 	在internal时间段里，硬中断时间(%)     (irq/total)*100
    %soft 	在internal时间段里，软中断时间(%)     (softirq/total)*100
    %idle 	在internal时间段里，CPU除去等待磁盘IO操作外的因为任何原因而空闲的时间闲置时间(%) (idle/total)*100

    计算公式：
    total_cur=user+system+nice+idle+iowait+irq+softirq
    total_pre=pre_user+ pre_system+ pre_nice+ pre_idle+ pre_iowait+ pre_irq+ pre_softirq
    user=user_cur – user_pre
    total=total_cur-total_pre
    其中_cur 表示当前值，_pre表示interval时间前的值。上表中的所有值可取到两位小数点。    

    /> mpstat -P ALL 2 3  #-P ALL表示打印所有CPU的数据，这里也可以打印指定编号的CPU数据，如-P 0(CPU的编号是0开始的)
    Linux 2.6.32-71.el6.i686 (Stephen-PC)   11/12/2011      _i686_  (1 CPU)

    04:12:54 PM  CPU    %usr   %nice    %sys %iowait    %irq   %soft  %steal  %guest   %idle
    04:12:56 PM    all      0.00      0.00     0.50    0.00      0.00    0.00    0.00      0.00     99.50
    04:12:56 PM      0     0.00      0.00     0.50    0.00      0.00    0.00    0.00      0.00     99.50

    04:12:56 PM  CPU    %usr   %nice    %sys %iowait    %irq   %soft  %steal  %guest   %idle
    04:12:58 PM    all     0.00      0.00     0.00    0.00      0.00    0.00    0.00      0.00    100.00
    04:12:58 PM     0     0.00      0.00     0.00    0.00      0.00    0.00    0.00      0.00    100.00

    04:12:58 PM  CPU    %usr   %nice    %sys %iowait    %irq   %soft  %steal  %guest   %idle
    04:13:00 PM    all      0.00     0.00    0.00    0.00      0.00    0.00     0.00      0.00    100.00
    04:13:00 PM     0      0.00     0.00    0.00    0.00      0.00    0.00     0.00      0.00    100.00

    Average:       CPU    %usr   %nice    %sys %iowait    %irq   %soft  %steal  %guest   %idle
    Average:         all      0.00     0.00    0.17    0.00      0.00    0.00     0.00      0.00     99.83
    Average:          0      0.00     0.00    0.17    0.00      0.00    0.00     0.00      0.00     99.83
第1节 vmstat
    4.  虚拟内存的实时监控工具(vmstat)：
    vmstat命令用来获得UNIX系统有关进程、虚存、页面交换空间及CPU活动的信息。这些信息反映了系统的负载情况。vmstat首次运行时显示自系统启动开始的各项统计信息，之后运行vmstat将显示自上次运行该命令以后的统计信息。用户可以通过指定统计的次数和时间来获得所需的统计信息。
    /> vmstat 1 3    #这是vmstat最为常用的方式，其含义为每隔1秒输出一条，一共输出3条后程序退出。
    procs  -----------memory----------   ---swap-- -----io---- --system-- -----cpu-----
     r  b   swpd      free      buff   cache   si   so     bi    bo     in   cs  us  sy id  wa st
     0  0        0 531760  67284 231212  108  0     0  260   111  148  1   5 86   8  0
     0  0        0 531752  67284 231212    0    0     0     0     33   57   0   1 99   0  0
     0  0        0 531752  67284 231212    0    0     0     0     40   73   0   0 100 0  0

    /> vmstat 1       #其含义为每隔1秒输出一条，直到按CTRL+C后退出。

    下面将给出输出表格中每一列的含义说明：
    有关进程的信息有：(procs)
    r:  在就绪状态等待的进程数。
    b: 在等待状态等待的进程数。   
    有关内存的信息有：(memory)
    swpd:  正在使用的swap大小，单位为KB。
    free:    空闲的内存空间。
    buff:    已使用的buff大小，对块设备的读写进行缓冲。
    cache: 已使用的cache大小，文件系统的cache。
    有关页面交换空间的信息有：(swap)
    si:  交换内存使用，由磁盘调入内存。
    so: 交换内存使用，由内存调入磁盘。 
    有关IO块设备的信息有：(io)
    bi:  从块设备读入的数据总量(读磁盘) (KB/s)
    bo: 写入到块设备的数据总理(写磁盘) (KB/s)  
    有关故障的信息有：(system)
    in: 在指定时间内的每秒中断次数。
    sy: 在指定时间内每秒系统调用次数。
    cs: 在指定时间内每秒上下文切换的次数。  
    有关CPU的信息有：(cpu)
    us:  在指定时间间隔内CPU在用户态的利用率。
    sy:  在指定时间间隔内CPU在核心态的利用率。
    id:  在指定时间间隔内CPU空闲时间比。
    wa: 在指定时间间隔内CPU因为等待I/O而空闲的时间比。  
    vmstat 可以用来确定一个系统的工作是受限于CPU还是受限于内存：如果CPU的sy和us值相加的百分比接近100%，或者运行队列(r)中等待的进程数总是不等于0，且经常大于4，同时id也经常小于40，则该系统受限于CPU；如果bi、bo的值总是不等于0，则该系统受限于内存。
第1节 iostat
    5.  设备IO负载的实时监控工具(iostat)：
    iostat主要用于监控系统设备的IO负载情况，iostat首次运行时显示自系统启动开始的各项统计信息，之后运行iostat将显示自上次运行该命令以后的统计信息。用户可以通过指定统计的次数和时间来获得所需的统计信息。
    其中该命令中最为常用的使用方式如下：
    /> iostat -d 1 3    #仅显示设备的IO负载，其中每隔1秒刷新并输出结果一次，输出3次后iostat退出。
    Linux 2.6.32-71.el6.i686 (Stephen-PC)   11/16/2011      _i686_  (1 CPU)

    Device:            tps   Blk_read/s   Blk_wrtn/s   Blk_read   Blk_wrtn
    sda                 5.35       258.39        26.19     538210      54560

    Device:            tps   Blk_read/s   Blk_wrtn/s   Blk_read   Blk_wrtn
    sda                 0.00         0.00         0.00                  0          0

    Device:            tps   Blk_read/s   Blk_wrtn/s   Blk_read   Blk_wrtn
    sda                 0.00         0.00         0.00                  0          0

    Device:            tps   Blk_read/s   Blk_wrtn/s   Blk_read   Blk_wrtn
    sda                 0.00         0.00         0.00                  0          0
    /> iostat -d 1  #和上面的命令一样，也是每隔1秒刷新并输出一次，但是该命令将一直输出，直到按CTRL+C退出。
    下面将给出输出表格中每列的含义：
    列名 	说明
    Blk_read/s 	每秒块(扇区)读取的数量。
    Blk_wrtn/s 	每秒块(扇区)写入的数量。
    Blk_read 	总共块(扇区)读取的数量。
    Blk_wrtn 	总共块(扇区)写入的数量。

    iostat还有一个比较常用的选项-x，该选项将用于显示和io相关的扩展数据。
    /> iostat -dx 1 3
    Device:  rrqm/s wrqm/s  r/s   w/s  rsec/s wsec/s avgrq-sz avgqu-sz   await  svctm  %util
    sda            5.27   1.31 2.82 1.14 189.49  19.50    52.75     0.53     133.04  10.74   4.26

    Device:  rrqm/s wrqm/s  r/s   w/s  rsec/s wsec/s avgrq-sz avgqu-sz   await  svctm  %util
    sda            0.00   0.00 0.00 0.00   0.00   0.00        0.00     0.00         0.00   0.00   0.00

    Device:  rrqm/s wrqm/s  r/s   w/s  rsec/s wsec/s avgrq-sz avgqu-sz   await  svctm  %util
    sda            0.00   0.00 0.00 0.00   0.00   0.00        0.00     0.00         0.00   0.00   0.00
    还可以在命令行参数中指定要监控的设备名，如：
    /> iostat -dx sda 1 3   #指定监控的设备名称为sda，该命令的输出结果和上面命令完全相同。

    下面给出扩展选项输出的表格中每列的含义：
    列名 	    说明
    rrqm/s 	    队列中每秒钟合并的读请求数量
    wrqm/s 	    队列中每秒钟合并的写请求数量
    r/s 	    每秒钟完成的读请求数量
    w/s 	    每秒钟完成的写请求数量
    rsec/s 	    每秒钟读取的扇区数量
    wsec/s 	    每秒钟写入的扇区数量
    avgrq-sz 	平均请求扇区的大小
    avgqu-sz 	平均请求队列的长度
    await 	    平均每次请求的等待时间
    util 	    设备的利用率

    下面是关键列的解释：
    util是设备的利用率。如果它接近100%，通常说明设备能力趋于饱和。
    await是平均每次请求的等待时间。这个时间包括了队列时间和服务时间，也就是说，一般情况下，await大于svctm，它们的差值越小，则说明队列时间越短，反之差值越大，队列时间越长，说明系统出了问题。
    avgqu-sz是平均请求队列的长度。毫无疑问，队列长度越短越好。                 
第1节 pidstat
     6.  当前运行进程的实时监控工具(pidstat)：
     pidstat主要用于监控全部或指定进程占用系统资源的情况，如CPU，内存、设备IO、任务切换、线程等。pidstat首次运行时显示自系统启动开始的各项统计信息，之后运行pidstat将显示自上次运行该命令以后的统计信息。用户可以通过指定统计的次数和时间来获得所需的统计信息。
    在正常的使用，通常都是通过在命令行选项中指定待监控的pid，之后在通过其他具体的参数来监控与该pid相关系统资源信息。
    选项 	说明
    -l 	    显示该进程和CPU相关的信息(command列中可以显示命令的完整路径名和命令的参数)。
    -d 	    显示该进程和设备IO相关的信息。
    -r 	    显示该进程和内存相关的信息。
    -w 	    显示该进程和任务时间片切换相关的信息。
    -t 	    显示在该进程内正在运行的线程相关的信息。
    -p 	    后面紧跟着带监控的进程id或ALL(表示所有进程)，如不指定该选项，将监控当前系统正在运行的所有进程。

    #监控pid为1(init)的进程的CPU资源使用情况，其中每隔3秒刷新并输出一次，3次后程序退出。
    /> pidstat -p 1 2 3 -l
    07:18:58 AM       PID    %usr %system  %guest    %CPU   CPU  Command
    07:18:59 AM         1    0.00    0.00    0.00    0.00     0  /sbin/init
    07:19:00 AM         1    0.00    0.00    0.00    0.00     0  /sbin/init
    07:19:01 AM         1    0.00    0.00    0.00    0.00     0  /sbin/init
    Average:               1    0.00    0.00    0.00    0.00     -  /sbin/init
    %usr：       该进程在用户态的CPU使用率。
    %system：    该进程在内核态(系统级)的CPU使用率。
    %CPU：       该进程的总CPU使用率，如果在SMP环境下，该值将除以CPU的数量，以表示每CPU的数据。
    CPU:         该进程所依附的CPU编号(0表示第一个CPU)。

    #监控pid为1(init)的进程的设备IO资源负载情况，其中每隔2秒刷新并输出一次，3次后程序退出。
    /> pidstat -p 1 2 3 -d    
    07:24:49 AM       PID   kB_rd/s   kB_wr/s kB_ccwr/s  Command
    07:24:51 AM         1      0.00      0.00      0.00  init
    07:24:53 AM         1      0.00      0.00      0.00  init
    07:24:55 AM         1      0.00      0.00      0.00  init
    Average:               1      0.00      0.00      0.00  init
    kB_rd/s:   该进程每秒的字节读取数量(KB)。
    kB_wr/s:   该进程每秒的字节写出数量(KB)。
    kB_ccwr/s: 该进程每秒取消磁盘写入的数量(KB)。

    #监控pid为1(init)的进程的内存使用情况，其中每隔2秒刷新并输出一次，3次后程序退出。
    /> pidstat -p 1 2 3 -r
    07:29:56 AM       PID  minflt/s  majflt/s     VSZ    RSS   %MEM  Command
    07:29:58 AM         1      0.00      0.00    2828   1368   0.13  init
    07:30:00 AM         1      0.00      0.00    2828   1368   0.13  init
    07:30:02 AM         1      0.00      0.00    2828   1368   0.13  init
    Average:               1      0.00      0.00    2828   1368   0.13  init
    %MEM:  该进程的内存使用百分比。

    #监控pid为1(init)的进程任务切换情况，其中每隔2秒刷新并输出一次，3次后程序退出。
    /> pidstat -p 1 2 3 -w
    07:32:15 AM       PID   cswch/s nvcswch/s  Command
    07:32:17 AM         1      0.00      0.00  init
    07:32:19 AM         1      0.00      0.00  init
    07:32:21 AM         1      0.00      0.00  init
    Average:            1      0.00      0.00  init
    cswch/s:    每秒任务主动(自愿的)切换上下文的次数。主动切换是指当某一任务处于阻塞等待时，将主动让出自己的CPU资源。
    nvcswch/s:  每秒任务被动(不自愿的)切换上下文的次数。被动切换是指CPU分配给某一任务的时间片已经用完，因此将强迫该进程让出CPU的执行权。

    #监控pid为1(init)的进程及其内部线程的内存(r选项)使用情况，其中每隔2秒刷新并输出一次，3次后程序退出。需要说明的是，如果-t选项后面不加任何其他选项，缺省监控的为CPU资源。结果中黄色高亮的部分表示进程和其内部线程是树状结构的显示方式。
    /> pidstat -p 1 2 3 -tr
    Linux 2.6.32-71.el6.i686 (Stephen-PC)   11/16/2011      _i686_  (1 CPU)

    07:37:04 AM      TGID       TID  minflt/s  majflt/s     VSZ    RSS   %MEM  Command
    07:37:06 AM         1         -      0.00      0.00        2828   1368      0.13  init
    07:37:06 AM         -         1      0.00      0.00        2828   1368      0.13  |__init

    07:37:06 AM      TGID       TID  minflt/s  majflt/s     VSZ    RSS   %MEM  Command
    07:37:08 AM         1         -      0.00      0.00        2828   1368      0.13  init
    07:37:08 AM         -         1      0.00      0.00        2828   1368      0.13  |__init

    07:37:08 AM      TGID       TID  minflt/s  majflt/s     VSZ    RSS   %MEM  Command
    07:37:10 AM         1         -      0.00      0.00        2828   1368      0.13  init
    07:37:10 AM         -         1      0.00      0.00        2828   1368      0.13  |__init

    Average:         TGID       TID  minflt/s  majflt/s     VSZ    RSS   %MEM  Command
    Average:            1         -      0.00      0.00        2828   1368      0.13  init
    Average:            -         1      0.00      0.00        2828   1368      0.13  |__init
    TGID: 线程组ID。
    TID： 线程ID。  

    以上监控不同资源的选项可以同时存在，这样就将在一次输出中输出多种资源的使用情况，如：pidstat -p 1 -dr。
第1节 df
    7.  报告磁盘空间使用状况(df):
    该命令最为常用的选项就是-h，该选项将智能的输出数据单位，以便使输出的结果更具可读性。
    /> df -h
    Filesystem             Size  Used   Avail Use% Mounted on
    /dev/sda1             5.8G  3.3G  2.2G  61%   /
    tmpfs                  504M  260K  504M   1%  /dev/shm
第1节 du
    8.  评估磁盘的使用状况(du)：
    选项 	说明
    -a 	    包括了所有的文件，而不只是目录。
    -b 	    以字节为计算单位。
    -k 	    以千字节(KB)为计算单位。
    -m 	    以兆字节(MB)为计算单位。
    -h 	    是输出的信息更易于阅读。
    -s 	    只显示工作目录所占总空间。
    --exclude=PATTERN 	排除掉符合样式的文件,Pattern就是普通的Shell样式，？表示任何一个字符，*表示任意多个字符。
    --max-depth=N 	从当前目录算起，目录深度大于N的子目录将不被计算，该选项不能和s选项同时存在。

    #仅显示子一级目录的信息。
    /> du --max-depth=1 -h
    246M    ./stephen
    246M    .   
    /> du -sh ./*   #获取当前目录下所有子目录所占用的磁盘空间大小。
    352K    ./MemcachedTest
    132K    ./Test
    33M     ./thirdparty   
    #在当前目录下，排除目录名模式为Te*的子目录(./Test)，输出其他子目录占用的磁盘空间大小。
    /> du --exclude=Te* -sh ./*  
    352K    ./MemcachedTest
    33M     ./thirdparty
第28章 和系统运行进程相关的Shell命令
block(和系统运行进程相关的Shell命令){}
十九.  和系统运行进程相关的Shell命令:
第1节 ps
   1.  进程监控命令(ps):
    要对进程进行监测和控制，首先必须要了解当前进程的情况，也就是需要查看当前进程，而ps命令就是最基本同时也是非常强大的进程查看命令。使用该命令可以确定有哪些进程正在运行和运行的状态、进程是否结束、进程有没有僵死、哪些进程占用了过多的资源等等。总之大部分信息都是可以通过执行该命令得到的。
    ps命令存在很多的命令行选项和参数，然而我们最为常用只有两种形式，这里先给出与它们相关的选项和参数的含义：
选项 	说明
a 	显示终端上的所有进程，包括其他用户的进程。
u 	以用户为主的格式来显示程序状况。
x 	显示所有程序，不以终端来区分。
-e 	显示所有进程。
o 	其后指定要输出的列，如user，pid等，多个列之间用逗号分隔。
-p 	后面跟着一组pid的列表，用逗号分隔，该命令将只是输出这些pid的相关数据。

    /> ps aux

    root         1  0.0  0.1   2828  1400 ?        Ss   09:51   0:02 /sbin/init
    root         2  0.0  0.0      0          0 ?        S    09:51   0:00 [kthreadd]
    root         3  0.0  0.0      0          0 ?        S    09:51   0:00 [migration/0]
    ... ...  
    /> ps -eo user,pid,%cpu,%mem,start,time,command | head -n 4
    USER       PID %CPU %MEM  STARTED     TIME        COMMAND
    root         1         0.0    0.1   09:51:08     00:00:02  /sbin/init
    root         2         0.0    0.0   09:51:08     00:00:00  [kthreadd]
    root         3         0.0    0.0   09:51:08     00:00:00  [migration/0]
    这里需要说明的是，ps中存在很多和进程性能相关的参数，它们均以输出表格中的列的方式显示出来，在这里我们只是给出了非常常用的几个参数，至于更多参数，我们则需要根据自己应用的实际情况去看ps的man手册。
    #以完整的格式显示pid为1(init)的进程的相关数据
    /> ps -fp 1
    UID        PID  PPID  C STIME TTY          TIME   CMD
    root         1        0  0 05:16   ?        00:00:03 /sbin/init
第1节 nice renice
    2.  改变进程优先级的命令(nice和renice):
    该Shell命令最常用的使用方式为：nice [-n <优先等级>][执行指令]，其中优先等级的范围从-20-19，其中-20最高，19最低，只有系统管理者可以设置负数的等级。
    #后台执行sleep 100秒，同时在启动时将其nice值置为19
    /> nice -n 19 sleep 100 &
    [1] 4661
    #后台执行sleep 100秒，同时在启动时将其nice值置为-19
    /> nice -n -19 sleep 100 &
    [2] 4664
    #关注ps -l输出中用黄色高亮的两行，它们的NI值和我们执行是设置的值一致。
    /> ps -l
    F S   UID   PID  PPID  C PRI  NI  ADDR  SZ    WCHAN  TTY       TIME        CMD
    4 S     0  2833  2829  0  80   0     -      1739     -         pts/2    00:00:00  bash
    0 S     0  4661  2833  0  99  19    -      1066     -         pts/2    00:00:00  sleep
    4 S     0  4664  2833  0  61 -19    -      1066     -         pts/2    00:00:00  sleep
    4 R     0  4665  2833  1  80   0     -      1231     -         pts/2    00:00:00  ps
   
    renice命令主要用于为已经执行的进程重新设定nice值，该命令包含以下几个常用选项：
    选项 	说明
    -g 	使用程序群组名称，修改所有隶属于该程序群组的程序的优先权。
    -p 	改变该程序的优先权等级，此参数为预设值。
    -u 	指定用户名称，修改所有隶属于该用户的程序的优先权。

    #切换到stephen用户下执行一个后台进程，这里sleep进程将在后台睡眠1000秒。
    /> su stephen
    /> sleep 1000&  
    [1] 4812
    /> exit   #退回到切换前的root用户
    #查看已经启动的后台sleep进程，其ni值为0，宿主用户为stephen
    /> ps -eo user,pid,ni,command | grep stephen
    stephen   4812   0 sleep 1000
    root        4821    0 grep  stephen
    #以指定用户的方式修改该用户下所有进程的nice值
    /> renice -n 5 -u stephen
    500: old priority 0, new priority 5
    #从再次执行ps的输出结果可以看出，该sleep后台进程的nice值已经调成了5
    /> ps -eo user,pid,ni,command | grep stephen
    stephen   4812   5 sleep 1000
    root         4826   0 grep  stephen
    #以指定进程pid的方式修改该进程的nice值
    /> renice -n 10 -p 4812
    4812: old priority 5, new priority 10
    #再次执行ps，该sleep后台进程的nice值已经从5变成了10
    /> ps -eo user,pid,ni,command | grep stephen
    stephen   4812  10 sleep 1000
    root        4829   0 grep  stephen

第1节 lsof
    3.  列出当前系统打开文件的工具(lsof):
    lsof(list opened files)，其重要功能为列举系统中已经被打开的文件，如果没有指定任何选项或参数，lsof则列出所有活动进程打开的所有文件。众所周知，linux环境中任何事物都是文件，如设备、目录、sockets等。所以，用好lsof命令，对日常的linux管理非常有帮助。下面先给出该命令的常用选项：
    选项 	说明
    -a 	该选项会使后面选项选出的结果列表进行and操作。
    -c command_prefix 	显示以command_prefix开头的进程打开的文件。
    -p PID 	显示指定PID已打开文件的信息
    +d directory 	从文件夹directory来搜寻(不考虑子目录)，列出该目录下打开的文件信息。
    +D directory 	从文件夹directory来搜寻(考虑子目录)，列出该目录下打开的文件信息。
    -d num_of_fd 	以File Descriptor的信息进行匹配，可使用3-10，表示范围，3,10表示某些值。
    -u user 	显示某用户的已经打开的文件，其中user可以使用正则表达式。
    -i 	监听指定的协议、端口、主机等的网络信息，格式为：[proto][@host|addr][:svc_list|port_list]

    #查看打开/dev/null文件的进程。
    /> lsof /dev/null | head -n 5
    COMMAND    PID      USER   FD   TYPE DEVICE SIZE/OFF NODE NAME
    init         1      root    0u   CHR    1,3      0t0 3671 /dev/null
    init         1      root    1u   CHR    1,3      0t0 3671 /dev/null
    init         1      root    2u   CHR    1,3      0t0 3671 /dev/null
    udevd 397      root    0u   CHR    1,3      0t0 3671 /dev/null

    #查看打开22端口的进程
    /> lsof -i:22
    COMMAND  PID USER   FD   TYPE DEVICE SIZE/OFF NODE NAME
    sshd    1582 root    3u  IPv4  11989      0t0  TCP *:ssh (LISTEN)
    sshd    1582 root    4u  IPv6  11991      0t0  TCP *:ssh (LISTEN)
    sshd    2829 root    3r   IPv4  19635      0t0  TCP bogon:ssh->bogon:15264 (ESTABLISHED)

    #查看init进程打开的文件
    />  lsof -c init
    COMMAND PID USER   FD   TYPE     DEVICE   SIZE/OFF   NODE    NAME
    init               1 root  cwd      DIR        8,2     4096              2        /
    init               1 root  rtd       DIR        8,2     4096              2        /
    init               1 root  txt       REG       8,2   136068       148567     /sbin/init
    init               1 root  mem    REG        8,2    58536      137507     /lib/libnss_files-2.12.so
    init               1 root  mem    REG        8,2   122232     186675     /lib/libgcc_s-4.4.4-20100726.so.1
    init               1 root  mem    REG        8,2   141492     186436     /lib/ld-2.12.so
    init               1 root  mem    REG        8,2  1855584    186631     /lib/libc-2.12.so
    init               1 root  mem    REG        8,2   133136     186632     /lib/libpthread-2.12.so
    init               1 root  mem    REG        8,2    99020      180422     /lib/libnih.so.1.0.0
    init               1 root  mem    REG        8,2    37304      186773     /lib/libnih-dbus.so.1.0.0
    init               1 root  mem    REG        8,2    41728      186633     /lib/librt-2.12.so
    init               1 root  mem    REG        8,2   286380     186634     /lib/libdbus-1.so.3.4.0
    init               1 root    0u     CHR        1,3      0t0           3671      /dev/null
    init               1 root    1u     CHR        1,3      0t0           3671      /dev/null
    init               1 root    2u     CHR        1,3      0t0           3671      /dev/null
    init               1 root    3r      FIFO       0,8      0t0           7969      pipe
    init               1 root    4w     FIFO       0,8      0t0           7969      pipe
    init               1 root    5r      DIR        0,10        0             1         inotify
    init               1 root    6r      DIR        0,10        0             1         inotify
    init               1 root    7u     unix   0xf61e3840  0t0       7970      socket
    init               1 root    9u     unix   0xf3bab280  0t0      11211     socket
    在上面输出的FD列中，显示的是文件的File Descriptor number，或者如下的内容：
    cwd:  current working directory;
    mem:  memory-mapped file;
    mmap: memory-mapped device;
    pd:   parent directory;
    rtd:  root directory;
    txt:  program text (code and data);
    文件的File Descriptor number显示模式有:
    r for read access;
    w for write access;
    u for read and write access;

    在上面输出的TYPE列中，显示的是文件类型，如：
    DIR:  目录
    LINK: 链接文件
    REG:  普通文件


    #查看pid为1的进程(init)打开的文件，其输出结果等同于上面的命令，他们都是init。
    /> lsof -p 1
    #查看owner为root的进程打开的文件。
    /> lsof -u root
    #查看owner不为root的进程打开的文件。
    /> lsof -u ^root
    #查看打开协议为tcp，ip为192.168.220.134，端口为22的进程。
    /> lsof -i tcp@192.168.220.134:22
    COMMAND  PID USER   FD   TYPE DEVICE SIZE/OFF NODE NAME
    sshd        2829 root     3r    IPv4  19635      0t0      TCP    bogon:ssh->bogon:15264 (ESTABLISHED)   
    #查看打开/root文件夹，但不考虑目录搜寻
    /> lsof +d /root
    #查看打开/root文件夹以及其子目录搜寻
    /> lsof +D /root
    #查看打开FD(0-3)文件的所有进程
    /> lsof -d 0-3
    #-a选项会将+d选项和-c选项的选择结果进行and操作，并输出合并后的结果。
    /> lsof +d .
    COMMAND  PID USER   FD   TYPE DEVICE SIZE/OFF  NODE NAME
    bash       9707  root  cwd    DIR    8,1     4096         39887 .
    lsof         9791  root  cwd    DIR    8,1     4096         39887 .
    lsof         9792  root  cwd    DIR    8,1     4096         39887 .
    /> lsof -a -c bash +d .
    COMMAND  PID USER   FD   TYPE DEVICE SIZE/OFF  NODE NAME
    bash        9707 root  cwd    DIR    8,1     4096         39887 .
    最后需要额外说明的是，如果在文件名的末尾存在(delete)，则说明该文件已经被删除，只是还存留在cache中。

第1节 pgrep pkill
    4.  进程查找/杀掉命令(pgrep/pkill)：
    查找和杀死指定的进程, 他们的选项和参数完全相同, 这里只是介绍pgrep。下面是常用的命令行选项：
    选项 	说明
    -d 	    定义多个进程之间的分隔符, 如果不定义则使用换行符。
    -n 	    表示如果该程序有多个进程正在运行，则仅查找最新的，即最后启动的。
    -o 	    表示如果该程序有多个进程正在运行，则仅查找最老的，即最先启动的。
    -G 	    其后跟着一组group id，该命令在搜索时，仅考虑group列表中的进程。
    -u 	    其后跟着一组有效用户ID(effetive user id)，该命令在搜索时，仅考虑该effective user列表中的进程。
    -U 	    其后跟着一组实际用户ID(real user id)，该命令在搜索时，仅考虑该real user列表中的进程。
    -x 	    表示进程的名字必须完全匹配, 以上的选项均可以部分匹配。
    -l 	    将不仅打印pid,也打印进程名。
    -f 	    一般与-l合用, 将打印进程的参数。

    #手工创建两个后台进程
    /> sleep 1000&
    3456
    /> sleep 1000&
    3457

    #查找进程名为sleep的进程，同时输出所有找到的pid
    /> pgrep sleep
    3456
    3457
    #查找进程名为sleep的进程pid，如果存在多个，他们之间使用:分隔，而不是换行符分隔。
    /> pgrep -d: sleep
    3456:3457
    #查找进程名为sleep的进程pid，如果存在多个，这里只是输出最后启动的那一个。
    /> pgrep -n sleep
    3457
    #查找进程名为sleep的进程pid，如果存在多个，这里只是输出最先启动的那一个。
    /> pgrep -o  sleep
    3456
    #查找进程名为sleep，同时这个正在运行的进程的组为root和stephen。
    /> pgrep -G root,stephen sleep
    3456
    3457
    #查找有效用户ID为root和oracle，进程名为sleep的进程。
    /> pgrep -u root,oracle sleep
    3456
    3457
    #查找实际用户ID为root和oracle，进程名为sleep的进程。
    /> pgrep -U root,oracle sleep
    3456
    3457
    #查找进程名为sleep的进程，注意这里找到的进程名必须和参数中的完全匹配。
    /> pgrep -x sleep
    3456
    3457
    #-x不支持部分匹配，sleep进程将不会被查出，因此下面的命令没有结果。
    /> pgrep -x sle
    #查找进程名为sleep的进程，同时输出所有找到的pid和进程名。    
    /> pgrep -l sleep
    3456 sleep
    3457 sleep
    #查找进程名为sleep的进程，同时输出所有找到的pid、进程名和启动时的参数。
    /> pgrep -lf sleep
    3456 sleep 1000
    3457 sleep 1000
    #查找进程名为sleep的进程，同时以逗号为分隔符输出他们的pid，在将结果传给ps命令，-f表示显示完整格式，-p显示pid列表，ps将只是输出该列表内的进程数据。
    /> pgrep -f sleep -d, | xargs ps -fp
    UID        PID  PPID  C STIME TTY          TIME CMD
    root      3456  2138  0 06:11 pts/5    00:00:00 sleep 1000
    root      3457  2138  0 06:11 pts/5    00:00:00 sleep 1000
第28章 通过管道组合Shell命令获取系统运行数据
block(通过管道组合Shell命令获取系统运行数据){}
二十. 通过管道组合Shell命令获取系统运行数据:
    1.  输出当前系统中占用内存最多的5条命令:
    #1) 通过ps命令列出当前主机正在运行的所有进程。
    #2) 按照第五个字段基于数值的形式进行正常排序(由小到大)。
    #3) 仅显示最后5条输出。
    /> ps aux | sort -k 5n | tail -5
    stephen   1861  0.2  2.0  96972 21596  ?  S     Nov11   2:24 nautilus
    stephen   1892  0.0  0.4 102108  4508  ?  S<sl Nov11   0:00 /usr/bin/pulseaudio
    stephen   1874  0.0  0.9 107648 10124 ?  S     Nov11   0:00 gnome-volume
    stephen   1855  0.0  1.2 123776 13112 ?  Sl     Nov11   0:00 metacity
    stephen   1831  0.0  0.9 125432  9768  ?  Ssl   Nov11   0:05 /usr/libexec/gnome
    
    2.  找出cpu利用率高的20个进程:
    #1) 通过ps命令输出所有进程的数据，-o选项后面的字段列表列出了结果中需要包含的数据列。
    #2) 将ps输出的Title行去掉，grep -v PID表示不包含PID的行。
    #3) 基于第一个域字段排序，即pcpu。n表示以数值的形式排序。
    #4) 输出按cpu使用率排序后的最后20行，即占用率最高的20行。
    /> ps -e -o pcpu,pid,user,sgi_p,cmd | grep -v PID | sort -k 1n | tail -20

    3.  获取当前系统物理内存的总大小:
    #1) 以兆(MB)为单位输出系统当前的内存使用状况。
    #2) 通过grep定位到Mem行，该行是以操作系统为视角统计数据的。
    #3) 通过awk打印出该行的第二列，即total列。
    /> free -m | grep "Mem" | awk '{print $2, "MB"}'
    1007 MB
第28章 通过管道组合Shell命令进行系统管理
block(通过管道组合Shell命令进行系统管理){}
二十一. 通过管道组合Shell命令进行系统管理:
第1节 获取当前或指定目录下子目录所占用的磁盘空间
    1.  获取当前或指定目录下子目录所占用的磁盘空间，并将结果按照从大到小的顺序输出:
    #1) 输出/usr的子目录所占用的磁盘空间。
    #2) 以数值的方式倒排后输出。
    /> du -s /usr/* | sort -nr
    1443980 /usr/share
    793260   /usr/lib
    217584   /usr/bin
    128624   /usr/include
    60748    /usr/libexec
    45148    /usr/src
    21096    /usr/sbin
    6896      /usr/local
    4           /usr/games
    4           /usr/etc
    0           /usr/tmp
第1节 批量修改文件名
    2.  批量修改文件名:
    #1) find命令找到文件名扩展名为.output的文件。
    #2) sed命令中的-e选项表示流编辑动作有多次，第一次是将找到的文件名中相对路径前缀部分去掉，如./aa改为aa。
    #    流编辑的第二部分，是将20110311替换为mv & 20110310，其中&表示s命令的被替换部分，这里即源文件名。
    #    \1表示被替换部分中#的\(.*\)。
    #3) 此时的输出应为
    #    mv 20110311.output 20110310.output
    #    mv 20110311abc.output 20110310abc.output
    #    最后将上面的输出作为命令交给bash命令去执行，从而将所有20110311*.output改为20110311*.output
    /> find ./ -name "*.output" -print  | sed -e 's/.\///g' -e 's/20110311\(.*\)/mv & 20110310\1/g' | bash
第1节 统计当前目录下文件和目录的数量
    3.  统计当前目录下文件和目录的数量:
    #1) ls -l命令列出文件和目录的详细信息。
    #2) ls -l输出的详细列表中的第一个域字段是文件或目录的权限属性部分，如果权限属性部分的第一个字符为d，
    #    该文件为目录，如果是-，该文件为普通文件。
    #3) 通过wc计算grep过滤后的行数。
    /> ls -l * | grep "^-" | wc -l
    /> ls -l * | grep "^d" | wc -l
第1节 杀掉指定终端的所有进程
    4.  杀掉指定终端的所有进程:
    #1) 通过ps命令输出终端为pts/1的所有进程。
    #2) 将ps的输出传给grep，grep将过滤掉ps输出的Title部分，-v PID表示不包含PID的行。
    #3) awk打印输出grep查找结果的第一个字段，即pid字段。
    #4) 上面的三个组合命令是在反引号内被执行的，并将执行的结果赋值给数组变量${K}。
    #5) kill方法将杀掉数组${K}包含的pid。
    /> kill -9 ${K}=`ps -t pts/1 | grep -v PID | awk '{print $1}'`    
第1节 将查找到的文件打包并copy到指定目录
    5.  将查找到的文件打包并copy到指定目录:
    #1) 通过find找到当前目录下(包含所有子目录)的所有*.txt文件。
    #2) tar命令将find找到的结果压缩成test.tar压缩包文件。
    #3) 如果&&左侧括号内的命令正常完成，则可以执行&&右侧的shell命令了。
    #4) 将生成后的test.tar文件copy到/home/.目录下。
    /> (find . -name "*.txt" | xargs tar -cvf test.tar) && cp -f test.tar /home/.
   
    #1) cpio从find的结果中读取文件名，将其打包压缩后发送到./dest/dir(目标目录)。
    #2) cpio的选项介绍：
    #    -d：创建需要的目录。
    #    -a：重置源文件的访问时间。
    #    -m：保护新文件的修改时间。
    #    -p：将cpio设置为copy pass-through模式。
    /> find . -name "*" | cpio -dampv ./dest/dir