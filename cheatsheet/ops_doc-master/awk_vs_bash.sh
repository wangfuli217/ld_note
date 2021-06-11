awk_ivs_bash(){ 
    从文件或者终端或者-c选项提供的参数中获取输入
    [bash vs awk]
    bash专注于任务调度(长于模块化编程)；awk专注于行列数据处理(长于模式匹配)。
       bash 是一种shell，shell是一种命令行解释器。
    1. shell 提供用户使用字符串文本与计算机(底层为字节)交互的方式：字符串输入+字符串输出
    2. shell 编程围绕 字符串输出和返回值 进行(内部命令等同外部命令)。通过数值变量、字符串变量和数组变量将 输出和返回值 弥合到控制语句中。
    3. shell 使用命令前要保证命令存在且可执行；使用变量前要保证变量存在且有效；使用目录时要保证目录存在，等等。
    [变量作用域] -- 使得bash比awk模块化容易
      1. bash有本地作用域local(help local|help declare);全局作用域;环境变量等3个层次。
         declare|typeset 设置变量的值和属性 readonly 
         unset 删除变量或者函数
         set   set 和 unset bash的选项和位置参数
         alias 变量别名
      2. awk 只有全局作用域，和引用外部shell变量，调用外部命令形式
    [行处理模式] -- 
      1. bash的read是以行为处理单元的。通过自定义变量引用行数据或IFS分解后的字段数据。支持超时、密码、提示和raw方式
      2. awk被设计成以行为处理单元。通过内置变量引用行数据和IFS分解后的字段数据。关联到$0,$1... FS,OFS,NF,FNR和RS,ORS
      3. read和awk都通过IFS分割字段。awk的IFS支持 [...] 多分隔符。
    [支持类型]
    bash都有字符串、数值和关联数组。变量的类型是由变量的值决定的，变量使用的操作数决定变量类型转换:也决定结果类型。
    bash数值计算 $[] 或者 (()) let STR=EXPR STR=`expr EXPR`. awk 直接 +-*/%^. 
      1. bash中，如果变量被声明为数值类型，那么，变量就为数值类型，非数值类型的赋值会被视为0值。
        1.1 利用let执行数学运算。使用let执行运算时，变量名之前不需要添加$。
        1.2 利用(())执行数学运算。使用(())执行算数运算时，变量名之前可以加$,也可不加$。
        1.3 利[ ]执行数学运算。使用[ ]执行算数运算时，变量名之前可以加$,也可不加$。
        1.4 使用expr执行数学运算。expr变量名之前必须加$，且变量名与运算符号之间必须留一个空格，不然不执行算数运算。
        1.5 使用bc进行浮点和平方运算以及进制转换
      2. awk中， 如果+-*/%^的操作数关联的操作对象包含字符串，则将字符串视为数值0.
      
    bash 字符串变量支持删除(help unset); awk字符串变量不支持删除。bash字符串有local特性，awk所有字符串都是全局特性。
      bash字符串处理依赖 ${##} ${%%} ${//} ${::}的方法，
        1. VAR= 和 VAR='' 设置空字符串；即存在但为空；还有不存在方式。-n和-z用来判断是否为空。不存在需要使用 ${VAR:-default}处理
        2. declare -p VAR  可以判断变量VAR是否存在。
        3. 字符串变量有readonly类型; readonly 声明或者 declare -r方式声明(help readonly 或 help declare)
        4. bash中，字符串可以作为命令，命令参数，变量的值，重定向的文件名称，输入字符串，命令行的输出。
        5. 字符串表示形式: 无引号; 单引号；双引号；$''方式
          5.1 空格是用来分隔命令与参数、参数与参数、变量赋值和命令的，所以如果字符串中有空格时，需要对空格进行转义。
          5.2 换行符是命令行之间的分隔符的一种(另外一种是分号)，如果字符串比较长，就可以对换行符进行转义，变成续行。
          5.3 在双引号中，大部分特殊字符失去了其特殊含义，比如 注释(#)、命令分隔符(;)、管道线(|)、通配符(?*)等。
              # 在双引号中，特殊字符包括：美元符($)、反引号(`)、转义符(\)、感叹号(!)，其他的特殊字符就不用管了。
          5.4 加上$之后，就可以使用\进行转义了，\的转义含义与C语言中的相同。
          5.5 echo $VAR  或 echo ${VAR}    # 压缩空格、跳格和换行
              echo "$VAR" 或 echo "${VAR}" # 不压缩空格、跳格和换行
              VAR=$(ls) echo $VAR 和 echo "${VAR}" 一个压缩空格、跳格和换行，一个不压缩空格、跳格和换行。
              S=$(cat file.txt) echo $S 和 echo "${S}" 一个压缩空格、跳格和换行，一个不压缩空格、跳格和换行。
              可以看看下面的解释：info ls
              如果标准输出是终端，那么是显示为多列形式的；否则就是一行一列。而对于$(ls)和`ls`，实际上标准输出已经不是终端了。
      
      awk依赖函数，且函数支持模式替换和数组split. 
        VAR="" 是字符串空；即存在但为空；还有不存在方式。判断空和不存在结果都是false.
      bash 通过${!array[*]}得到关联数组索引， awk通过for index in array得到索引。通过 if in判断存在。
      bash使用unset删除数组元素和数组；awk使用delete删除。bash能对数组初始化，awk没有对数组初始化的方法。
      bash 默认支持数组是顺序数组，除非明确声明为关联数组才为关联数组
      
      bash 中有很多对函数的操作: export readonly 
    [判断方法]
    bash的判断区分字符串和数字；
      bash字符串用 = != -n -z 数字用-lt -le -gt -ge -eq -ne. 
      awk不区分: == != > >= < <= 都用于字符串和数字，字符串仍支持 ~ !~模式匹配.
      bash 有很多文件相关特性，文件类型(普通、目录、块设备、字符设备、套接字、命名管道和连接文件)，存在与否
                 文件相关特性，可读、可写、可执行；UID、GID、是否为空和sbit特性
                 文件相关特性，新、旧、相等
      bash 判断条件基于返回值，awk 判断条件基于字符串空非空，数值0非0，数组包含和不包含，以及模式、模式组合和模式范围。
        bash 控制语句的判断条件是 test命令或者其他命令的 结果状态(0表示执行成功，非0表示执行失败，结果状态保存在$?中)；
          bash的内置命令，外部命令，函数都有返回值。即使declare,local,typeset,set,unset都有返回值。
        awk 控制语句的判断条件是表达式的执行结果(数值而言，0表示失败，非0表示成功；字符串而言，空表示失败，非空表示失败；数组而言，包含表示成功，不包含表示失败)
    [关系判断]
    bash和awk的关系判断不同
      bash 在 [] 中使用 -a -o 和 ! 进行命令关联; 在[[]] 中使用 && || 和 !进行命令关联; [[]] 支持正则表达式和通配符，[]不支持
        1.无论是[]还是[[]]，都建议对其内变量、字符串使用双引号包围。换句话说，能做字符串比较的时候，不要用数值比较。
        2.当变量可能为空的时候，强烈建议在变量的基础上加上其他辅助字符串。看过/etc/init.d下的脚本的人肯定都见过这种用法。
        3.使用bash关键字[[来判断，不再需要对变量加双引号，也不需要对>进行转义。
          ( EXPRESSION ), !( EXPRESSION ), EXPRESSION1 -a EXPRESSION2, EXPRESSION1 -o EXPRESSION2.
        4. test bash内部test命令支持 '<' '>'字符串比较，外部test不支持。
          文件类型: -[bcdfhLpSt] b块文件 c字符文件 d目录 f普通文件 hL 链接文件 p 命名管道 -S socket，-t termianl
          访问权限: -[gkruwxOG]  g(set-group-ID) k(sticky) r(read) u(set-user-ID) w(write) x(executable) O(owned EUID) G(owned GUID)
          文件特性: -e -s -nt -ot -ef : e:exit s(size>0) nt(newer than) ot(older than) ef(same file)
          字符串比较: -z -n = !=  z(zero ) n(nozero) =(equal) !=(not equal)
          数值比较: -eq -ne -lt -le -gt -ge 
          关系运算: ! -a -o 
      awk  使用 && || 和 ! 进行;
    bash和awk 都用printf函数，bash特殊在%b和%p， awk特殊在 %c.
    bash可以调用awk命令，给awk命令传递参数；awk可以调用bash命令，为bash提供数据输出。
    bash有很多扩展方式: 
    
    awk充分发挥C语言特性，数值不等于0和字符串不为空即认为条件为真；数值等于0和字符串为空即认为条件为假
}
awk_dvs_bash(){ 
    重定向被当前的bash初始化，而不是被当前执行的命令初始化。因此，重定向命令在命令执行前执行。
# Actual code
echo 'hello' &> /dev/null
echo 'hello' &> /dev/null 'goodbye'
# Desired behavior
echo 'hello' > /dev/null 2>&1
echo 'hello' 'goodbye' > /dev/null 2>&1
# Actual behavior
echo 'hello' &
echo 'hello' & goodbye > /dev/null
    
    bash中有四个重要且不易区分的概念；
      文件名(特殊字符串)，字符串，管道(流对象,表示已打开文件, 需要指定描述符名称)，重定向(包括打开文件的过程,需要指定文件名)。
    1. 文件名       sed awk cut tr wc等命令参数
    2. 字符串       $(command)
    3. 管道(流对象) <(命令列表) >(命令列表)mkfifo fifo 
    4. 重定向       > >> &> (流与流、流与文件、流与命令 之间关系) < <<[-]EOF <<<"$string" | &|
    <(命令列表) >(命令列表) 命令列表和外界通过命名管道进行通信。'进程替换'的执行结果是 /dev/fd/62和/dev/fd/63, 
因此，可以把执行结果看做是 命名管道文件。可以通过重定向输入或输出到bash设定流目的地。
#    <<< 将字符串的内容放到bash的输入缓冲区中，允许read命令，awk命令读取输入缓冲区，处理bash缓冲内字符串数据。
#    <<[-]EOF 将字符串内容重定向到cat ftp ssh sudo等命令的输入缓冲区中， 默认输入目的地 不是标准输入，不能应用到read
#    $(命令)  将命令的执行结果作为字符串.
    
    命令支持类型: 文件名; | 管道; < 输入描述符
    
    bash中的模式;
    1. bash中path的模式
      *  匹配任何字符串，包括空字符串。
      ?  匹配任意单个字符。
      [...]  匹配方括号中的任一字符。
      ?(模式列表) 与模式列表匹配零次或一次。
      *(模式列表) 与模式列表匹配零次或多次。
      +(模式列表) 与模式列表匹配一次或多次。
      @(模式列表) 与模式列表中的模式之一匹配。
      !(模式列表) 与模式列表中的任一模式之外的字符匹配。
    2. case中的模式: 会选择性的执行与单词所匹配的第一个模式对应的命令块。
       '|' 用来分隔多个模式，')' 用来结束模式列表。
           模式在匹配之前要经过波浪号扩展、参数扩展、命令替换、算术扩展以及引用去除，而每个模式也要经过波浪号扩展、
       参数扩展、命令替换、算术扩展等步骤。
       如果任何模式都不匹配，该命令的返回状态是零；否则，返回最后一个被执行的命令的返回值。
       [fF] | [nN] | [nN][oO] | [fF][aA][lL][sS][eE]
    3， [[ == ]] 和 [[ != ]]中的模式
        [[ =~ ]] 中的正在表达式
          BASH_REMATCH 在 [[ =~ ]] 之后使用，用于捕获模式匹配字符串    # man 3 regex
        一个数组变量，其中的元素由条件结构命令[[的双目运算符"=~"来赋值。
          BASH_REMATCH中下标为0的元素是字符串中与整个正则表达式匹配的部分。
          BASH_REMATCH中下标为n的元素是字符串中与第n个括号里面的子模式匹配的部分。
        if [[ "$line" =~ $pattern ]]; then
     
a='I am a simple string with digits 1234'
pat='(.*) ([0-9]+)'
[[ "$a" =~ $pat ]]
echo "${BASH_REMATCH[0]}"
echo "${BASH_REMATCH[1]}"
echo "${BASH_REMATCH[2]}"
     
date=20150624
[[ $date =~ ^[0-9]{8}$ ]] && echo "yes" || echo "no"
date=hello
[[ $date =~ ^[0-9]{8}$ ]] && echo "yes" || echo "no"
     
pat='[^0-9]+([0-9]+)'
s='I am a string with some digits 1024'
[[ $s =~ $pat ]] # $pat must be unquoted
echo "${BASH_REMATCH[0]}"
echo "${BASH_REMATCH[1]}"

     trap: DEBUG(语句) RETURN(函数或source) EXIT(shell退出) ERR 执行错误
     set -euo pipefail e(error) u(unset variable error) -o(pipefail) 
     通配符: 路径扩张；文件名扩展
     花括号扩展，波浪号扩展，参数和变量扩展，算术扩展，命令置换，单词分割，文件名扩展，进程替换
     
     : 在·Linux的帮助页中说它除了参数扩展和重定向之外不产生任何作用。
    格式：: your comment here
    格式：# your comment here
    写代码注释(单行注释)。

    格式：: 'comment line1
comment line2
more comments'
写多行注释。

    格式：: >file
    格式：>file
    清空文件file的内容。
    
    格式：: ${VAR:=DEFAULT}
    
    #遍历数组
for ELEM in "${ARRAY[@]}"  ; do
    echo $ELEM
done
    #遍历字符串
for ((i=0; i<${#1}; ++i)) ; do  
    if [ "${1:i:1}" == "$2" ]; then  
        echo $i  
        return 0  
    fi  
done
    #遍历文件
while read -r line ; do
    echo $line
done


awk '$2=="yellow"{print $1}' shell_awk_colours.txt  相等
awk '$2 ~ /p.+p/ {print $0}' shell_awk_colours.txt  正则相等
awk '$3>5 {print $1, $2}'    shell_awk_colours.txt  大于

awk '$3>5 {print $1, $2} shell_awk_colours.txt' > output.txt
awk '{print > $2".txt"}' colours.txt
}