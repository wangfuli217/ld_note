变量名称
Shell变量名称，只能包括字母、数字和下划线，并且只能以字母和下划线开头。通常情况下，Shell变量名称为大写的形式。
http://www.tutorialspoint.com/unix/unix-using-variables.htm

http://codingstandards.iteye.com/blog/1162455

exec 3>&-
exec 4>&-


string(变量声明及初始化,引用){

### 声明变量并赋值 ### 
在Bash中，变量并不区分类型，因此也不需要给变量指定类型。 declare -a|-A|-i
在Bash中声明变量不需要显式进行，给变量赋值即可。
    格式           声明变量并赋值
VAR=STRING         STR=hello\ world     STR=hello
VAR="STRING"       STR="hello world"
VAR='STRING'       STR='hello world'
VAR为变量名，STRING为字符串
要注意的是，等号(=)两侧不能有空白。如果字符串中间有空白或特殊字符，则需要用单引号或双引号引起来。

### 引用变量（访问变量） ###
# 如果要得到VAR变量的值，就需要引用变量，有如下两种格式：
    格式           echo输出变量内容
$STR               echo $STR
${STR}             echo ${STR}
要注意的是，在给变量赋值时，变量名不能加上$。

### 使用declare命令来声明变量 ###
    格式           echo输出变量内容
declare STR=dummy  echo $STR

### 声明变量但不设置初始值 ###
    格式                        #说明
VAR=                            #等号右侧不写任何字符，即设置变量VAR为空。
              # 不存在VAR的声明方式，因为这样bash就把VAR看做一个命令来执行。
declare VAR                     #使用declare声明变量，如果变量原来声明过，则其值不变，即没有复位变量的功能。
declare VAR=                    #等同于VAR=

### 判断变量是否声明？###
格式：declare -p VAR
# 显示VAR变量是否声明过了，如果没有打印 not found，否则显示它的属性和值。

格式：${!VAR*} #这个参数扩展格式可以找出所有以VAR开头的变量来，但不能确切的知道是否有VAR这个变量，比如有可能还有VAR1。
echo ${!D*}    #DIRSTACK DISPLAY
echo ${!P*}    #PATH PIPESTATUS PPID PROMPT_COMMAND PS1 PS2 PS4 PWD

### 将变量声明为只读 ### 不能修改，不能删除，不能重新声明，只能引用
格式：readonly VAR=STRING
格式：declare -r VAR=STRING

### 取消变量、删除变量 ###
格式：unset VAR

### 全局变量、局部变量 ###
# 在默认情况下，变量都是全局变量。在前面加上local或者declare之后就变成了局部变量。
# 格式：local VAR
# 格式：local VAR=STRING
# 格式：declare VAR
# 格式：declare VAR=STRING
}

myfunc(){
GGG=Global
local STR=Hello
declare VAR=World
}
# GGG=YesGlobal
# STR=NotHello
# VAR=NotWorld
# myfunc
# echo $GGG $STR $VAR
Global NotHello NotWorld

string(array){
declare或typeset内建命令(它们是完全相同的)可以用来限定变量的属性.这是在某些编程语言中使用的定义类型不严格的方式。
###  -r 只读 ### 
declare -r var1         #declare -r var1与readonly var1作用相同
###  -i 整数 ### 
declare -i number       #脚本余下的部分会把"number"当作整数看待.
number=3
echo "Number = $number" # Number = 3 
number=three 
echo "Number = $number" # Number = 0 脚本尝试把字符串"three"作为整数来求值(译者注：当然会失败，所以出现值为0).
###  -a 数组 ### 初始化支持序列赋值、指定位置赋值、赋空值；数组支持指定位置赋值。
# 可以获取指定位置元素，指定子序列元素，整个数组元素和数组长度，数组索引序列。
declare -a names 
names=("Jack" "Bone")
names[0]=Jack 
names[1]=Bone
echo ${names[*]}
echo ${#names[*]}
echo ${names[@]}
echo ${#names[@]}

declare -A assArray
assArray=([lucy]=beijing [yoona]=shanghai)
echo ${assArray[lucy]}

assArray[lily]=shandong
assArray[sunny]=xian
echo ${assArray[sunny]}
xian
echo ${assArray[lily]}
shandong

### 列出数组索引 ###
echo ${!assArray[*]}
echo ${!assArray[@]}

###  -x export ### 
declare -x glb           #这样将声明一个变量作为脚本的环境变量而被导出。
}
string(字符串的表示方式){

### 字符串的用途 ###
在Bash中无处不是字符串，它可以
(1) 作为命令；
(2) 作为命令行参数；
(3) 作为变量的值；
(4) 作为重定向的文件名称；
(5) 作为输入字符串（here string, here document）；
(6) 作为命令行的输出。

### 字符串表示方式概述 ###
在Bash中，字符串常量有多种表示方式
(1) 不使用任何引号，比如 hello                     STR=hello\ world
(2) 使用一对单引号括起来，比如 'hello'             echo '$'
(3) 使用一对双引号括起来，比如 "hello"             echo "*"   echo "#"
(4) 使用美元符加上一对单引号括起来，比如 $'hello'  echo $'hello'


关于字符串表示的问题
在进一步对字符串的表示方式了解之前，请先回答下面的问题：
问题1：字符串中包含空格，应该怎么表示？
问题2：字符串中包含制表符，应该怎么表示？
问题3：字符串中包含单引号，应该怎么表示？
问题4：字符串中包含双引号，应该怎么表示？
问题5：字符串中包含$，应该怎么表示？
问题6：字符串中包含#，应该怎么表示？
问题7：字符串中包含换行，即有多行，应该怎么表示？
问题8：字符串中包含反斜杠，应该怎么表示？
问题9：字符串中包含感叹号，应该怎么表示？

###  无引号  ### 
1. 在没有用引号括起来时，所有的特殊字符都会产生特殊的作用，如果想让它们失去特殊作用，就需要用转义符(\)进行转义。
2. 空格是用来分隔命令与参数、参数与参数、变量赋值和命令的，所以如果字符串中有空格时，需要对空格进行转义。
3. 换行符是命令行之间的分隔符的一种（另外一种是分号），如果字符串比较长，就可以对换行符进行转义，变成续行。
4. 在没有任何引号括起来时，\跟上字符，那么所跟的字符将失去特殊含义。比如 管道线(|)。
###  单引号  ### 
1. 在单引号中，所有的特殊字符都将失去其特殊含义。这样也就导致在单引号中无法表示单引号字符本身。
###  双引号  ### 
1. 在双引号中，大部分特殊字符失去了其特殊含义，比如 注释(#)、命令分隔符(;)、管道线(|)、通配符(?*)等。
2. #在双引号中，特殊字符包括：美元符($)、反引号(`)、转义符(\)、感叹号(!)，其他的特殊字符就不用管了。（为啥在此处写上"感叹号(!)"呢，请看后文分解）'
3. 在双引号中，美元符($)可以引用变量，将被替换为变量的值，
"$VAR"     被替换为变量VAR的值，但"$VAR123"将被替换为变量VAR123的值，所以最好用大括号把变量括起来，避免意想不到的错误出现；
"${VAR}"   被替换为变量VAR的值，"${VAR}123"将被替换为变量VAR的值再跟上123；
"${VAR:-DEFAULT}"  当变量VAR没有定义或者为空时，替换为DEFAULT，否则替换为变量VAR的值；
"$(command line)"  相当于 "`command line`"，将被替换为命令行执行的标准输出信息
4. 在双引号中，转义符(\)是为了方便创建包含特殊字符的字符串，特殊字符的前面需要加上\进行转义
5. 在双引号中，感叹号(!)的含义根据使用的场合有所不同，在命令行环境，它将被解释为一个历史命令，而在脚本中，则不会有特殊含义。
   在命令行环境，感叹号(!)称之为"历史扩展字符（the  history  expansion character）"。
###  $' ... '  ###    
1. 加上$之后，就可以使用\进行转义了，\的转义含义与C语言中的相同。
}

string($' ... '){
叮当一声。
[root@jfht ~]# echo $'\a'

叮当三声。
[root@jfht ~]# echo $'\a\a\a'

单引号。
[root@jfht ~]# echo $'\''

八进制表示的ASCII字符。
[root@jfht ~]# echo $'\101\102\103\010'
}

string(给-字符串-变量赋值){

### 赋值为字符串常量 ###
不包含任何特殊字符的情形  包含空格的情形      包含单引号的情形        包含双引号的情形
S1=Literal                S2=Hello\ World     S3=Yes,\ I\'m\ Basher   S4=It\ is\ very\ \"Stupid\".
S1='Literal'              S2='Hello World'    无法纯粹用单引号来做到  S4='It is very "Stupid".'
S1="Literal"              S2="Hello World"    S3="Yes, I'm Basher"    S4="It is very \"Stupid\"."
S1=$'Literal'             S2=$'Hello World'   S3=$'Yes, I\'m Basher'  S4=$'It is very "Stupid".'

### 多行文本的情形 ###
示例：S5='Hello
World'

示例：S5="Hello
World"

示例：S5=$'Hello
World'

### 赋值为另一个变量的值 ###
普通变量           位置参数
示例：S2=$S1       示例：S3=$1
示例：S2=${S1}     示例：S3=${1}

### 赋值为命令行执行输出(命令替换) ###
格式：S2=`commandline`         格式：S2="`commandline`"
格式：S2=$(commandline)        格式：S2="$(commandline)"

free=`free_memory`             # 函数可以通过反斜杠执行
committed=`committed_memory`   # 函数可以通过反斜杠执行
### 赋值为更复杂的字符串替换结果 ###
示例：S1="Your account is ${ACCOUNT}"
示例：S2="Current Working Directory is $(pwd)"

### 赋值为空串 ###
示例：S=

### 赋值为文件内容 ###
格式：CONTENT=$(cat filename)
注意：如果filename指定的文件是二进制数据文件，那么CONTENT实际的内容可能实际的不一致。
      即使是文本文件，其长度也是不一致的，但字符串内容是一致的。
}

string(赋值为整数){
由于Shell中的变量是无类型的，所有直接将整数赋值给变量即可，无需任何转换手段。
格式：STR=SOME_INTEGER             STR=1234
但如果将一个算式赋值给变量，不会自动计算，可以采用如下几种方式：

格式1：STR=$[EXPR]                 STR=$[1234+4321]    echo $[$var/$val]   # echo $[var/val]   都可以
格式2：((STR=EXPR))                ((STR=1234+4321))   echo $(($var/$val)) # echo $((var/val)) 都可以
格式3：let STR=EXPR                let STR=1234+4321   let STR=$var+$val   # let STR=var+val   都可以
格式4：declare -i STR=EXPR         declare -i STR=1234+4321  declare -i STR1=$var+$val # declare -i STR1=var+val   都可以
格式5：STR=`expr EXPR`             STR=`expr 1234 + 4321`      # expr 命令的四则运算操作符两边必须有空格 只能STR1=`expr $var + $val`
格式6：STR=$(expr EXPR)            STR=$(expr 1234 + 4321)     # expr 命令的四则运算操作符两边必须有空格 只能STR=$(expr $var + $val)

[root@jfht ~]# STR=1234+4321
[root@jfht ~]# echo $STR    
1234+4321
直接将算式赋值给变量，还是算式本身，不会是计算结果。
}

string(字符串输出){

### 输出字符串常量 ###
示例：echo Hello
示例：echo "Hello"

### 输出变量 ###
格式1：echo $VAR      # 压缩空格、跳格和换行
格式2：echo ${VAR}    # 压缩空格、跳格和换行
上面的格式，如果变量VAR保存的字符串中包含空格、换行，那么这些空格、跳格、换行将会被压缩掉。
格式3：echo "$VAR"    # 不压缩空格、跳格和换行
格式4：echo "${VAR}"  # 不压缩空格、跳格和换行
       "$(abs_dirname "$0")" # abs_dirname为函数，"$0"
注意，不能用单引号来引用。使用引号后，空格、换行、跳格将不会被压缩掉。

注意：echo在输出信息的时候会自动加上换行，
如果不需要换行，加上-n参数即可

echo -e 命令参数中的转义字符  #help echo

### 输出命令执行结果 ###
格式1：command line
就是直接执行命令，当然可以
格式2：echo `command line`  # 压缩空格、跳格和换行
格式3：echo $(command line) # 压缩空格、跳格和换行
这两种格式的执行效果是一样的，都会把命令输出的前后空格去掉、中间的空格换行压缩为一个空格。
格式2：echo "$(command line)"  # 不压缩空格、跳格和换行
格式3：echo "`command line`"   # 不压缩空格、跳格和换行

ls: info ls
如果标准输出是终端，那么是显示为多列形式的；否则就是一行一列。而对于$(ls)和`ls`，
实际上标准输出已经不是终端了。

### 输出到文件（标准输出重定向） ###
覆盖原来的文件
格式：echo "$S" >output.txt

追加到文件
格式：echo "$S" >>output.txt

### 输出到标准错误设备 ###
比如用来打印程序的出错信息
echo "$S" >&2
>&2表示把标准输出重定向到文件描述符2，而这正是标准错误输出的文件描述符。

### 输出到别的进程 ###
管道线(|)
示例：echo "$S" | wc -c

Here Document方式 # 在此处也可以引用变量
示例：wc -c <<EOF

$S

EOF

格式化输出（printf） # 格式化输出
printf "%8s" "$S"
类似C语言的格式化输出，此处不深入探讨。
}

string(字符串输入-读取字符串){

### 从标准输入读取 ###
1. 使用read命令读取字符串到变量中。但是，如果有反斜杠，将起到转义的作用。
   \\表示一个\号，\<newline>表示续行，\<char>代表<char>本身。
格式：read VAR
格式：read -p <prompt> VAR

2. 读取一行文本，但是取消反斜杠的转义作用。
格式：read -r VAR
格式：read -p <prompt> -r VAR

3. 读取密码(输入的字符不回显)
格式：read -s PASSWORD
格式：read -p <prompt> -s PASSWORD

4. 读取指定数量字符
格式：read -n <nchars> VAR
格式：read -p <prompt> -n <nchars> VAR

5. 在指定时间内读取
格式：read -t <seconds> VAR
格式：read -p <prompt> -t <seconds> VAR

6. 从文件中读取
格式：read VAR <file.txt
对于read命令，可以指定-r参数，避免\转义。
格式：read -r VAR <file.txt
{ read -r LINE1; read -r LINE2; read -r LINE3; } <input.txt
}

string(判断是否空串-或者未定义){

### 判断是否空串（或者未定义） ###
格式1：test -z "$STR"                                 if test -z "$STR"; then echo "STR is null or empty"; fi 
格式2：[ -z "$STR" ]                                  if [ -z "$STR" ]; then echo "STR is null or empty"; fi  
注：test是[]的同义词。注意加上引号，否则有可能报错。
格式3：test "$STR" == ""                              if test "$STR" == ""; then echo "STR is null or empty"; fi    
格式4：[ "$STR" == "" ]                               if [ "$STR" == "" ]; then echo "STR is null or empty"; fi   
格式5：test "$STR" = ""                               if test "$STR" = ""; then echo "STR is null or empty"; fi   
格式6：[ "$STR" = "" ]                                if [ "$STR" = "" ]; then echo "STR is null or empty"; fi   
注：==等同于=。
格式7：[[ "$STR" = "" ]]                              if [[ "$STR" = "" ]]; then echo "STR is null or empty"; fi
格式8：[[ $STR = "" ]]                                if [[ $STR = "" ]]; then echo "STR is null or empty"; fi  
格式9：[[ "$STR" == "" ]]
格式10：[[ $STR == "" ]]
格式11：[[ ! $STR ]]                                  if [[ ! $STR ]]; then echo "STR is null or empty"; fi
注：[[是Bash关键字，其中的变量引用不需要加双引号。


###　判断是否非空串　###
格式1：test "$STR"
格式2：[ "$STR" ]
格式3：test -n "$STR"
格式4：[ -n "$STR" ]
格式5：test ! -z "$STR"
格式6：[ ! -z "$STR" ]
格式7：test "$STR" != ""
格式8：[ "$STR" != "" ]
格式9：[[ "$STR" ]]
格式10：[[ $STR ]]


### 判断变量是否已定义（声明） ###
格式1：if declare -p VAR; then do_something; fi
格式2：declare -p VAR && do_something
在Bash中typeset命令等同于declare命令。
格式3：if [ "${VAR+YES}" ]; then do_something; fi
格式4：[ "${VAR+YES}" ] && do_something
${VAR+YES}表示如果VAR没有定义则返回YES，否则返回空

### 判断变量没有定义（声明） ###
格式1：if [ ! "${VAR+YES}" ]; then do_something; fi
格式2：[ ! "${VAR+YES}" ] && do_something

}

string(字符串与默认值){

Use Default Values: ${parameter-default}, ${parameter:-default}
${parameter-default} -- 如果变量parameter没被声明, 那么就使用默认值.
${parameter:-default} -- 如果变量parameter没被设置, 那么就使用默认值.
注："(没)被声明"与"(没)被设置"在是否有 ":" 号的句式差别中仅仅是触发点的不同而已。
"被声明"的触发点显然要比"被设置"的要低，
"被设置"是在"被声明"的基础上而且不能赋值(设置)为空(没有赋值/设置为空)。 

Assign Default Values: ${parameter=default}, ${parameter:=default}
${parameter=default} -- 如果变量parameter没被声明, 那么就把它的值设为default.
${parameter:=default} -- 如果变量parameter没被设置, 那么就把它的值设为default.


: ${parameter:=default}
注意前面加上了冒号(:)，即空命令，等同于下面的写法：
if [ -z "$parameter" ]; then parameter=default; fi
[ -z "$parameter" ] && parameter=default


Use Alternate Value: ${parameter+alt_value}, ${parameter:+alt_value}
${parameter+alt_value} -- 如果变量parameter被声明了, 那么就使用alt_value, 否则就使用null字符串.
${parameter:+alt_value} -- 如果变量parameter被设置了, 那么就使用alt_value, 否则就使用null字符串.


Display Error if Null or Unset: ${parameter?err_msg}, ${parameter:?err_msg}
${parameter?err_msg} -- 如果parameter被声明了, 那么就使用设置的值, 否则打印err_msg错误消息.
${parameter:?err_msg} -- 如果parameter被设置了, 那么就使用设置的值, 否则打印err_msg错误消息.


用途1：判断环境变量是否设置了
: ${HOME?}
用途2：判断某些变量是否设置了
: ${VAR?}
用途3：判断位置参数是否设置了
: ${1?}
}

string(取变量STR的长度){

### 取变量STR的长度（推荐方式） ### 
格式：${#STR}

###  使用expr length命令取字符串长度 ### 
用expr命令，也可以取到字符串长度，但都没有上面的高效，因为上面的方式是Bash内置的方式，而expr命令是外部命令。
格式：expr length "$STR" # 只能 expr length "$STR"

使用expr match命令取字符串长度
格式1：expr "$STR" : ".*"      # 两个功能一样；都是返回配置的结束位置，有点像{##} 贪婪匹配
格式2：expr match "$STR" ".*"  # 两个功能一样；都是返回配置的结束位置，有点像{##} 贪婪匹配


###  用wc命令取字符串长度 ### 
使用wc命令也可以实现字符串长度计算。
格式1：wc -c <<<"$STR"
比实际的字节数多1，会多输出一个换行，等同于 echo "$STR" | wc -c 而不是下面这个
格式2：echo -n "$STR" | wc -c
上面是计算字节数，如果是中文的话，每个中文为2个字节(当LANG=zh_CN.GB18030)。
格式3：wc -m <<<"$STR"
比实际的字符数多1，会多输出一个换行，等同于 echo "$STR" | wc -m 而不是下面这个
格式4：echo -n "$STR" | wc -m
}

string(获取字符串指定位置的字符、遍历字符串中的字符){

###  取指定索引位置的字符 ### 
${STR:INDEX:1}
取字符串STR的INDEX位置的字符，INDEX从0开始计数

###  遍历字符串中的每个字符 ###  
for ((i = 0; i < ${#STR}; ++i))
do
    CH=${STR:i:1}
    # do something
done
}

string(判断字符串相等){

### 判断字符串相等 ###
格式1：test "$S1" = "$S2"      test "$S1" = "$S2"  && echo "equals"
格式2：[ "$S1" = "$S2" ]       [ "$S1" = "$S2" ]  && echo "equals"  
格式3：test "$S1" == "$S2"     test "$S1" == "$S2"  && echo "equals"
格式4：[ "$S1" == "$S2" ]      [ "$S1" == "$S2" ]  && echo "equals"  
格式5：[[ $S1 = $S2 ]]         [[ "$S1" = "$S2" ]]  && echo "equals" 
格式6：[[ $S1 == $S2 ]]        [[ "$S1" == "$S2" ]]  && echo "equals"


###  判断字符串不相等 ### 
格式1：test "$S1" != "$S2"     test "$S1" != "$S2" && echo "not equals"
格式2：[ "$S1" != "$S2" ]      [ "$S1" != "$S2" ] && echo "not equals"  
格式3：[[ $S1 != $S2 ]]        [[ $S1 != $S2 ]] && echo "not equals"   

S1=Hello
[[ $S1 == [Hh][Ee][Ll][Ll][Oo] ]] && echo "equals ignore case"    
# equals ignore case
S1=HeLlo
[[ $S1 == [Hh][Ee][Ll][Ll][Oo] ]] && echo "equals ignore case"
# equals ignore case
}

string(比较两个字符串大小 - 字典顺序、数值比较){

t="abc123" # 正则表达式匹配和完整匹配
[[ "$t" == abc* ]]         # true (globbing比较)
[[ "$t" == "abc*" ]]       # false (字面比较)
[[ "$t" =~ [abc]+[123]+ ]] # true (正则表达式比较)
[[ "$t" =~ "abc*" ]]       # false (字面比较)

### 判断是否大于 (字典顺序) ### 
格式1：[ "$S1" \> "$S2" ]                 if [ "$S1" \> "$S2" ]; then echo ">"; fi
判断S1是否大于S2，注意转义字符\的使用，否则bash会认为是标准输出重定向。
下面两种写法也是可以的：                  
格式2：[ "$S1" '>' "$S2" ]                [ "$S1" '>' "$S2" ] && echo '>'
格式3：[ "$S1" ">" "$S2" ]                [ "$S1" ">" "$S2" ] && echo '>'
使用bash关键字[[来判断，不再需要对变量加双引号，也不需要对>进行转义。
格式4：[[ $S1 > $S2 ]]                    [[ $S1 > $S2 ]] && echo '>' 


### 判断是否小于（字典顺序） ### 
格式1：[ "$S1" \< "$S2" ]                 if [ "$S1" \< "$S2" ]; then echo "<"; fi
判断S1是否小于S2，注意转义字符\的使用，否则bash会认为是标准输入重定向。
下面两种写法也是可以的：
格式2：[ "$S1" '<' "$S2" ]                [ "$S1" '<' "$S2" ] && echo '<'
格式3：[ "$S1" "<" "$S2" ]                [ "$S1" "<" "$S2" ] && echo '<'  
使用bash关键字[[来判断，不再需要对变量加双引号，也不需要对>进行转义。
格式4：[[ $S1 < $S2 ]]                    [[ $S1 < $S2 ]] && echo '<'

### 判断是否大于等于（不小于）（字典顺序）### 
格式1：test "$S1" \> "$S2" -o "$S1" = "$S2"
格式2：[ "$S1" \> "$S2" -o "$S1" = "$S2" ]
格式3：[[ $S1 > $S2 || $S1 = $S2 ]]
格式4：[[ ! $S1 < $S2 ]]

### 判断是否小于等于（不大于）（字典顺序）### 
在bash中实现 <= 的判断，也必须采用判断 < 或者 = 来进行。
格式1：test "$S1" \< "$S2" -o "$S1" = "$S2"
格式2：[ "$S1" \< "$S2" -o "$S1" = "$S2" ]
格式3：[[ $S1 < $S2 || $S1 = $S2 ]]
格式4：[[ ! $S1 > $S2 ]]


###  数值比较 ### 
注意：每种比较运算都可以写成好几种格式：
test格式：比较运算符为"-字母缩写"形式（见后面详细说明）。
[]格式：等价于test。
[[]]格式：其中的变量引用不需要加双引号，比较运算符与test同。
(())格式：其中的变量不需要加$符号，比较运算符的写法与Java同。

等于：eq uals
大于等于（不小于）：g reater e qual
大于：g reater t han
小于等于（不大于）：l ess e qual
小于：l ess t han
不等于：n ot e quals
}

string(字符串连接){
S="$S1$S2"
S="${S1}${S2}"
}

string(字符串数组连接){

将数组中的字符串合并。
数组的定义方式如下：
ARR=(S1 S2 S3)

### 以空格分隔 ### 
格式1：STR=${ARR[*]}
格式2：STR=${ARR[@]}
格式3：STR="${ARR[*]}"
格式4：STR="${ARR[@]}"

### 不分隔 ### 
str_join() {
    local dst
    for s in "$@"
    do
        dst=${dst}${s}
    done
    echo "$dst"
}

}

string(判断是否包含另外的字符串){

### 是否包含子串（推荐方式） ### 
[[ $STR == *$SUB* ]]
[[ $STR == *$SUB* ]]
注意：*不能引起来，否则不灵。

### 特殊情况：以某子串开头。 ### 
[[ $STR == $SUB* ]]
特殊情况：以某子串结尾。
[[ $STR == *$SUB ]]

### 使用正则表达式匹配方式确定是否包含子串 ### 
[[ $STR =~ .*$SUB.* ]]
注：.*是不必要的，可写成
[[ $STR =~ $SUB ]]

### 使用case语句来确定是否包含子串 ### 
case "$STR" in *$SUB*) echo contains; ;; esac

### 使用字符串替换来实现是否包含子串 ### 
if [ "$STR" != "${STR/$SUB/}" ]; then echo contains; fi

### 使用grep来实现是否包含子串 ### 
if echo "$STR" | grep -q "$SUB"; then echo contains; fi
if grep -q "$SUB" <<<"$STR"; then echo contains; fi


### 使用expr match来实现是否包含子串 ### 
if [ "$(expr match "$STR" ".*$SUB.*")" != "0" ]; then echo contains; fi
}

string(格式化字符串){printf}
string(计算子串出现的次数){grep -o "$SUB" <<<"$STR" | wc -l
grep -c -o "$SUB" <<<"$STR"    注：开始以为这个可以，经过检验之后不行，因为-c参数只会打印匹配的的行数。
}

string(判断是否以另外的字符串开头){

### 使用[[ ]] 模式匹配来判断是否以别的字符串开头（推荐方式）### 
格式：[[ $STR == $PREFIX* ]]
### 使用[[ ]] 正则表达式匹配来判断是否以别的字符串开头 ###
格式：[[ $STR =~ ^$PREFIX ]]
### 用case语句来判断是否以别的字符串开头 ### 
正确：case "$STR" in "$PREFIX"*) echo "starts"; esac
错误：case "$STR" in "$PREFIX*") echo "starts"; esac
### 用掐头法判断是否以别的字符串开头 ### 
格式：[ "${STR#$PREFIX}" != "$STR" ]
}

string(判断是否以另外的字符串结尾){

### 使用[[ ]] 模式匹配来判断是否以别的字符串结尾（推荐方式）### 
格式：[[ $STR == *$SUFFIX ]]
### 使用[[ ]] 正则表达式匹配来判断是否以别的字符串结尾 ###
格式：[[ $STR =~ $SUFFIX$ ]]
### 用case语句来判断是否以别的字符串结尾 ### 
正确：case "$STR" in *"$SUFFIX") echo "ends"; esac
错误：case "$STR" in "*$SUFFIX") echo "ends"; esac
### 用去尾法判断是否以别的字符串结尾 ### 
格式：[ "${STR%$SUFFIX}" != "$STR" ]
}

string(查找子串的位置){
使用遍历字符串的方法来查找子串的位置
函数：strstr <str> <sub>
如果找到，打印位置，从0开始计数，退出码为0；否则，打印-1，退出码为1

使用awk index来查找子串的位置
索引位置从1开始计数，0表示没有找到。
格式：awk -v "STR=$STR" -v "SUB=$SUB" '{print index(STR,SUB)}' <<<""
格式：echo | awk -v "STR=$STR" -v "SUB=$SUB" '{print index(STR,SUB)}'


使用expr match来查找子串的最后出现位置
注意：expr index不能用来查找子串的位置。
格式1：expr "$STR" : ".*$SUB" - length "$SUB"
格式2：expr match "$STR" ".*$SUB" - length "$SUB"
}

string(查找字符的位置){
使用遍历字符的方式来查找字符的位置
函数：strchr <str> <ch>
如果找到，打印字符的位置，从0开始计数，退出码为0；否则打印-1，退出码为1

用expr index来查找字符的位置
格式：expr index "$STR" "$CHARS"
在STR中查找CHARS中的任何字符（而不是子串），打印第一个位置。

用awk index来查找字符出现的位置
格式1：awk -v "STR=$STR" -v "CH=$CH" '{print index(STR,CH)}' <<<""
格式2：echo | awk -v "STR=$STR" -v "CH=$CH" '{print index(STR,CH)}'

}

string(判断字符串是否数字串){

方法：[[ $STR != *[!0-9]* ]]
解读：$STR != *[!0-9]* 表示不匹配非数字串，反过来讲就是只匹配数字串。
方法：[[ ! $STR == *[!0-9]* ]]
解读：$STR == *[!0-9]* 表示只要包含非数字字符就为真，前面加上!操作符，表示相反，也就是说只有当全部是数字字符时才为真。


### 使用sed -n /re/p 来判断字符串是否数字串 ### 
格式：[ "$(sed -n "/^[0-9]\+$/p" <<< "$STR")" ]
格式：[ "$(echo "$STR" | sed -n "/^[0-9]\+$/p")" ]

### 使用 grep/egrep 来判断字符串是否数字串 ### 
格式：grep -q "^[0-9]\+$" <<< "$STR"
格式：egrep -q "^[0-9]+$" <<< "$STR"
}

string(字符串替换、子串删除、子串截取){
STR="Hello World"
${STR/$OLD/$NEW}         echo ${STR/o/O}
替换第一个。
${STR//$OLD/$NEW}        echo ${STR//o/O}
替换所有。
注意：不能使用正则表达式，只能使用?*的Shell扩展。只能用shell通配符如 * ?  [list] [!list] [a-z]。
${STR/#$OLD/$NEW}        echo ${STR/#He/he}
替换开头。如果STR以OLD串开头，则替换。
${STR/%$OLD/$NEW}        echo ${STR/%He/he}   echo ${STR/%ld/lD}
替换结尾。如果STR以OLD串结尾，则替换。

###如果被替换串包含/字符，那么要转义，写成\/。 ###
filename="/root/admin/monitoring/process.sh"
echo ${filename/#\/root/\/tmp}

echo -e ${PATH//:/'\n'}

### 基于Pattern Matching的子串删除 ###
STR="Hello World"
子串删除是一种特殊的替换
${STR/$SUB}                  
将STR中第一个SUB子串删除
${STR//$SUB}
将STR中所有SUB子串删除
${STR#$PREFIX}                  echo ${STR#He}    echo ${STR#He*o}
去头，从开头去除最短匹配前缀
${STR##$PREFIX}                 echo ${STR##He*o}
去头，从开头去除最长匹配前缀
${STR%$SUFFIX}
去尾，从结尾去除最短匹配后缀
${STR%%$SUFFIX}
去尾，从结尾去除最长匹配后缀
注意：经常会记错#和%的含义，有一个帮助记忆的方法
看一下键盘，#在$之前，%在$之后，就知道#去头，%去尾。
注意：不能使用正则表达式，只能使用?*的Shell扩展。


### 使用sed命令实现正则表达式替换 ### 
使用sed命令可以进行正则表达式的替换。
echo "$STR" | sed "s/$OLD/$NEW/"
将STR中的OLD子串替换成NEW。

### 使用tr命令实现字符集合的替换 ### 
使用tr命令可以实现字符的替换，并且可以是从一批字符到另一批字符的替换。比如小写字母变成大写字母，或者反过来。


路径字符串的处理
dirname ${FULLPATH}
取目录部分。
basename ${FULLPATH}
取文件名部分。
basename ${FULLPATH} ${EXT}
取文件名部分，并且去掉指定的扩展名。
}

string(根据位置和长度截取子串){

### Bash内置的取子串功能 ###
取指定位置开始到串尾的子串，INDEX从0开始算。
${STR:$INDEX}
取指定位置开始、指定长度的子串
${STR:$INDEX:$LENGTH}
与Java不同的是，LENGTH可以大于串的长度。

### 使用expr substr取子串###
另外也有用expr来取子串的，但效率不如上面。
expr substr "$STR" "$POS" "$LENGTH"
注意：POS从1开始。

### 用cut命令截取子串 ### 
用cut命令也可以进行字符串截取。
echo "$STR" | cut -c$START-$END
截取STR串中从START开始到END结束的子串，位置从1开始计数。
echo "$STR" | cut -c$START-
截取STR串中从START开始到末尾的子串。
echo "$STR" | cut -c-$END
截取STR串中从头开始到END的子串。


### 用awk substr截取子串 ### 
用awk命令来进行字符串截取，网上很多例子有错。
echo "$STR" | awk '{print substr($0,'$POS','$LEN')}'
echo | awk '{print substr("'"$STR"'",'$POS','$LEN')}'
截取STR的POS开始长度LEN的子串，POS从1开始算。

### 使用dd命令截取子串 ###
用dd命令来进行字符串截取。
echo "$STR" | dd bs=1 skip=$POS count=$LEN 2>/dev/null
截取STR的POS开始长度LEN的子串，POS从0开始算。
}

使用echo命令去除串中的空白
echo $STR

使用外部命令rev来实现字符串翻转
格式：echo "$STR" | rev
格式：rev <<< "$STR"
注意：rev命令是把每行文本进行翻转。


使用rev和tac命令实现字符串翻转
格式：echo "$STR" | tac | rev
格式：echo "$STR" | rev | tac

使用awk命令实现字符串翻转
格式：echo "$STR" | awk -F "" '{for(i=NF;i>0;i--)print $i}'
格式：awk -F "" '{for(i=NF;i>0;i--)print $i}' <<<"$STR"

case(){
大写 => 小写
echo "$STR" | tr A-Z a-z
echo "$STR" | tr 'A-Z' 'a-z'
echo "$STR" | tr "A-Z" "a-z"
echo "$STR" | tr [:upper:] [:lower:]
echo "$STR" | tr "[A-Z]" "[a-z]"

小写 => 大写
echo "$STR" | tr a-z A-Z
echo "$STR" | tr 'a-z' 'A-Z'
echo "$STR" | tr "a-z" "A-Z"
echo "$STR" | tr [:lower:] [:upper:]
echo "$STR" | tr "[a-z]" "[A-Z]"

使用sed命令来转换大小写
大写 => 小写
正确：echo "$STR" | sed y/ABCDEFGHIJKLMNOPQRSTUVWXYZ/abcdefghijklmnopqrstuvwxyz/

小写 => 大写
正确：echo "$STR" | sed y/abcdefghijklmnopqrstuvwxyz/ABCDEFGHIJKLMNOPQRSTUVWXYZ/


使用awk命令来转换大小写
大写 => 小写
echo "$STR" | awk '{print tolower($0)}'

小写 => 大写
echo "$STR" | awk '{print toupper($0)}'


使用perl命令转换大小写
大写 => 小写
echo "$STR" | perl -e 'print lc <>;'

小写 => 大写
echo "$STR" | perl -e 'print uc <>;'
}


rev(){
使用rev和tac命令实现字符串翻转
格式：echo "$STR" | tac | rev
格式：echo "$STR" | rev | tac

使用awk命令实现字符串翻转
格式：echo "$STR" | awk -F "" '{for(i=NF;i>0;i--)print $i}'
格式：awk -F "" '{for(i=NF;i>0;i--)print $i}' <<<"$STR"

}