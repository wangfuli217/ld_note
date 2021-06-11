https://github.com/alebcay/awesome-shell/blob/master/README_ZH-CN.md # 去发现

调试脚本
  bash -x script.sh 或 sh -x script.sh
  set -x和set +x(执行命令后会显示该指令及其参数);set -v当命令进行读取时显示输入，set +v进制打印输入 详细介绍
  将shebang从#!/bin/bash 改成 #!/bin/bash -xv 也可(./script.sh运行)
  自定义格式显示调试信息，新建如下脚本，然后命令行键入 [root@share codes]# _DEBUG=on sh debug.sh (:告诉shell不进行任何操作)
    
第1章 set
在bash的脚本中，
你可以使用 set -x 来debug输出。
使用 set -e 来当有错误发生的时候abort执行。
考虑使用 set -o pipefail 来限制错误。
execfail 如果一个交互式shell不能执行指定给exec内置命令作为参数的文件，它不会退出。如果exec失败，一个交互式shell不会退出

还可以使用trap来截获信号（如截获ctrl+c）。

set -n   读命令但并不执行
set -v   显示读取的所有行
set -x   显示所有命令及其参数

set -o nounset #引用未定义的变量(缺省值为"")
set -o errexit #执行失败的命令被忽略
local(函数内部变量)
readonly(只读变量)

对脚本进行语法检查：bash -n myscript.sh 
跟踪脚本里每个命令的执行：bash -v myscripts.sh 
跟踪脚本里每个命令的执行并附加扩充信息：bash -x myscript.sh
你可以在脚本头部使用set -o verbose和set -o xtrace来永久指定-v和-o。当在远程机器上执行脚本时，这样做非常有用，用它来输出远程信息。

1. 多进程执行
#!/bin/bash
PIDARRAY=()
for file in File1.iso File2.sio;
do
    md5sum $file &
    PIDARRAY+=("$!")
done
wait ${PIDARRAY[@]} # 或者 wait ${PIDARRAY[*]} 利用并行进程进行加速 $!最近一个后台程序的PID

第2章 redirect
如何将标准输出和错误输出同时重定向到同一位置?
2>&1
&>
第3章 math
bash中如何进行算术运算？
let i++
expr 1 + 2
$[ 2 + 3]
$(($num1 + $num2))

set -u  /  set -o nounset #对没有初始化的变量做替换时，报错退出。
set -e  /  set -o errexit #如果执行命令的退出码不是0时，脚本立即退出。这样可以避免某些程序片段没有做错误检查而导致不可预期的结果。
使用 "$VAR" 而不是 $VAR   #对于引用变量，最好写在双引号中，而不是让它裸奔
使用 "$@" 而不是 $@       #因为如果某个参数中包含空白时，不加引号的$@会有问题，含空格的参数将会分裂成多个
处理信号 signal

log4sh
http://sourceforge.net/projects/log4sh/, shell里的日志工具, 和log4系列的其他日志库配置基本差不多
shunit
http://shunit.sourceforge.net/, shell的单元测试工具
bashdb
http://bashdb.sourceforge.net/, shell的调试工具

strictmode(){

#!/bin/bash
set -euo pipefail
IFS=$'\n\t'
}
eval bash exec source &

第4章 manul
manul(){
1. bats 有参数无配置，参数有长选项和短选项
2. /etc/init.d启动脚本，有参数无配置，参数为{start|stop|restart|force-reload|condrestart|try-restart|status|help}几个枚举参数
3. ksmtuned 脚本，无参数有配置，后台持续运行

log -> bash实例手册; bashful-master; functions; main.sh
optarg -> bats; bash/etc/init.d; bash/optargs
fun -> functions; bashful-master;
daemon -> daemon/ksmtuned
network -> init.d/network-functions
test -> bats; shuints

模块化和注释 -> 思路

# &解释器说明         #!/usr/bin/env bash 
# &脚本说明           简要说明；运行条件；配置文件
# &解释器配置         set -e  
# &版本函数           version
# &使用函数           usage
# &帮助函数           help
# &默认配置           
# &加载配置           source
# &函数               func
# &环境变量           BATS
# &命令行解析         option
# &全局变量           bats
# &调试环境变量       BATS_DEBUG
# &执行命令           exec eval source
# &执行命令结果说明   printf | echo 
}
第5章 color
color(pure-bash-bible){
文本颜色
----------------
序列                    它将做什么？                    值
\e[38;5;<NUM>m          设置文本前景色.                 0-255
\e[48;5;<NUM>m          设置文本背景颜色.               0-255
\e[38;2;<R>;<G>;<B>m    将文本前景色设置为RGB颜色.      R, G, B
\e[48;2;<R>;<G>;<B>m    将文本背景颜色设置为RGB颜色.    R, G, B

文本属性
----------------
序列     它将做什么？
\e[m     重置文本格式和颜色.
\e[1m    粗体.
\e[2m    微弱的文字.
\e[3m    斜体文字.
\e[4m    下划线文字.
\e[5m    慢速闪烁.
\e[7m    交换前景色和背景色.

移动光标
----------------
序列                    它将做什么？                    值
\e[<LINE>;<COLUMN>H     将光标移动到绝对位置.         line, column
\e[H                    将光标移动到原位 (0,0).     
\e[<NUM>A               将光标向上移动N行.            num
\e[<NUM>B               将光标向下移动N行.            num
\e[<NUM>C               将光标向右移动N列.            num
\e[<NUM>D               将光标向左移动N列.            num
\e[s                    保存光标位置.     
\e[u                    恢复光标位置.

删除文本
----------------
序列          它将做什么？
\e[K          从光标位置删除到行尾.
\e[1K         从光标位置删除到行首.
\e[2K         擦除整个当前行.
\e[J          从当前行删除到屏幕底部.
\e[1J         从当前行删除到屏幕顶部.
\e[2J         清除屏幕.
\e[2J\e[H     清除屏幕并将光标移动到 0,0.
}

color(linux shell下输出带颜色文字){
    echo -e "\e[1;31m This is red text \e[0m"
\e[1;31m将颜色设为红色(;前的数字表示背景颜色，;后的表示字体颜色)，\e[0m将颜色重新置回

 文本终端的颜色可以使用"ANSI非常规字符序列"来生成。举例：
echo -e "\\033[44;37;5m 361 \\033[0m way"

     以上命令设置作用如下：背景色为蓝色，前景色为白色，字体闪烁，输出字符"361"，然后重新设置屏幕到缺省设置，
输出字符 "way"。"e"是命令 echo 的一个可选项，它用于激活特殊字符的解析器。"33"引导非常规字符序列。"m"意味着
设置属性然后结束非常规字符序列，这个例子里真正有效的字符是 "44;37;5" 和"0"。修改"44;37;5"可以生成不同颜色的
组合，数值和编码的前后顺序没有关系。
可以选择的编码如下所示：

　　编码 颜色/动作
　　0    重新设置属性到缺省设置
　　1    设置粗体
　　2    设置一半亮度（模拟彩色显示器的颜色）
　　4    设置下划线（模拟彩色显示器的颜色）
　　5    设置闪烁
　　7    设置反向图象
　　22  设置一般密度
　　24  关闭下划线
　　25  关闭闪烁
　　27  关闭反向图象
　　30  设置黑色前景
　　31  设置红色前景
　　32  设置绿色前景
　　33  设置棕色前景
　　34  设置蓝色前景
　　35  设置紫色前景
　　36  设置青色前景
　　37  设置白色前景
　　38  在缺省的前景颜色上设置下划线
　　39  在缺省的前景颜色上关闭下划线
　　40  设置黑色背景
　　41  设置红色背景
　　42  设置绿色背景
　　43  设置棕色背景
　　44  设置蓝色背景
　　45  设置紫色背景
　　46  设置青色背景
　　47  设置白色背景
　　49  设置缺省黑色背景

echo可以控制字体颜色和背景颜色输出。
常见的字体颜色：重置=0，黑色=30，红色=31，绿色=32，黄色=33，蓝色=34，紫色=35，天蓝色=36，白色=37。
常见的背景颜色：重置=0，黑色=40，红色=41，绿色=42，黄色=43，蓝色=44，紫色=45，天蓝色=46，白色=47。
字体控制选项：1表示高亮，4表示下划线，5表示闪烁等。
因为需要使用特殊符号，所以需要配合-e选项来识别特殊符号。

颜色编码搭配使用
echo -e "\033[31m 红色字 \033[0m"
echo -e "\033[34m 黄色字 \033[0m"
echo -e "\033[41;33m 红底黄字 \033[0m"
echo -e "\033[41;37m 红底白字 \033[0m"

Linux 字体颜色30—–37
echo -e "\033[30m 黑色字 \033[0m"
echo -e "\033[31m 红色字 \033[0m" 
echo -e "\033[32m 绿色字 \033[0m" 
echo -e "\033[33m 黄色字 \033[0m" 
echo -e "\033[34m 蓝色字 \033[0m" 
echo -e "\033[35m 紫色字 \033[0m" 
echo -e "\033[36m 天蓝字 \033[0m" 
echo -e "\033[37m 白色字 \033[0m"


Linux 字体背景颜色40—–47
echo -e "\033[40;37m 黑底白字 \033[0m" 
echo -e "\033[41;37m 红底白字 \033[0m" 
echo -e "\033[42;37m 绿底白字 \033[0m" 
echo -e "\033[43;37m 黄底白字 \033[0m" 
echo -e "\033[44;37m 蓝底白字 \033[0m" 
echo -e "\033[45;37m 紫底白字 \033[0m" 
echo -e "\033[46;37m 天蓝底白字 \033[0m" 
echo -e "\033[47;30m 白底黑字 \033[0m"

颜色编码字体闪烁：
echo -e "\033[42;30;5m wwww \033[0m"
echo -e "\033[47;30;5m wwww \033[0m"

/bin/echo -e "\033[30m Black \033[0m"
/bin/echo -e "\033[31m Red \033[0m"
/bin/echo -e "\033[32m Green \033[0m"
/bin/echo -e "\033[33m Yellow \033[0m"
/bin/echo -e "\033[34m Blue \033[0m"
/bin/echo -e "\033[35m Purple \033[0m"
/bin/echo -e "\033[36m Light Blue \033[0m"
/bin/echo -e "\033[37m White \033[0m"
/bin/echo -e "\033[40;37m Black Background \033[0m"
/bin/echo -e "\033[41;37m Red Background \033[0m"
/bin/echo -e "\033[42;37m Green Background \033[0m"
/bin/echo -e "\033[43;37m Yellow Background \033[0m"
/bin/echo -e "\033[44;37m Blue Background \033[0m"
/bin/echo -e "\033[45;37m Purple Background \033[0m"
/bin/echo -e "\033[46;37m Light Blue Background \033[0m"
/bin/echo -e "\033[47;31m White Background \033[0m"
}
第6章 printf
bash(printf){
说明符  描述
%c      ASCII字符
%d,%i   十进制整数
%f      浮点格式
%o      不带正负号的八进制值
%s      字符串
%u      不带正负号的十进制值
%x      不带正负号的十六进制值，其中使用a-f表示10-15
%X      不带正负号的十六进制值，其中使用A-F表示10-15
%%      表示%本身
%b：表示解析字符串的特殊的字符，包括\n等等。例如printf "%s\n" 'hello\nworld'，显示hello\nworld，要将\n作为换行符，则需要用printf "%b\n" 'hello\nworld'。
%q：printf "%q\n" "greetings to the world"显示为greetings/ to/ the/ world，可以作为shell的输入。

printf "The number is %.2f.\n" 100
printf "%-20s%-15s%10.2f\n" "Stephen" "Liu" 35
printf "|%10s|\n" hello
printf "%x %#x\n" 15 15

(1)printf默认不在结尾加换行符，它不像echo一样，所以要手动加“\n”换号；
(2)printf只是格式化输出，不会改变任何结果，所以在格式化浮点数的输出时，浮点数结果是不变的，仅仅只是改变了显示的结果。

}
第7章 color
color(echo|printf){ man console_codes
CCOLOR="\033[34m"
LINKCOLOR="\033[34;1m"
SRCCOLOR="\033[33m"
BINCOLOR="\033[37;1m"
MAKECOLOR="\033[32;1m"
ENDCOLOR="\033[0m"
printf '    %b %b\n' $(CCCOLOR)CC$(ENDCOLOR) $(SRCCOLOR)$@$(ENDCOLOR)
printf '    %b %b\n' $(LINKCOLOR)LINK$(ENDCOLOR) $(BINCOLOR)$@$(ENDCOLOR)
printf '    %b %b\n' $(LINKCOLOR)INSTALL$(ENDCOLOR) $(BINCOLOR)$@$(ENDCOLOR)

MOVE_TO_COL="echo -en \\033[${RES_COL}G"
SETCOLOR_SUCCESS="echo -en \\033[1;32m"
SETCOLOR_FAILURE="echo -en \\033[1;31m"
SETCOLOR_WARNING="echo -en \\033[1;33m"
SETCOLOR_NORMAL="echo -en \\033[0;39m"

[ "$BOOTUP" = "color" ] && $MOVE_TO_COL
echo -n "["
[ "$BOOTUP" = "color" ] && $SETCOLOR_SUCCESS  #SETCOLOR_SUCCESS，SETCOLOR_FAILURE，SETCOLOR_WARNING
echo -n $"  OK  "
[ "$BOOTUP" = "color" ] && $SETCOLOR_NORMAL
echo -n "]"
echo -ne "\r"

}

echo_color(inst1){
    if [ "$1" == "green" ]
        echo -e "\033[32;40m$2\033[0m"
    elif [ "$1" == "red" ]
        echo -e "\033[32;40m$2\033[0m"
    fi
}

echo_color(inst2){
    case $1 in
    green )
        echo -e "\033[32;40m$2\033[0m"
        ;;
    red )
        echo -e "\033[32;40m$2\033[0m"
        ;;
    * )
        echo -e "\033[32;40m$2\033[0m"
}

第7章 Variadic functions
shell(Variadic functions){
variadic_func() {
	local arg1="$1"; shift
	local arg2="$1"; shift
	local rest="$@"

	# ...
}
}
第8章 Testing for exit code vs output
shell(Testing for exit code vs output){
# Test for exit code (-q mutes output)
if grep -q 'foo' somefile; then
  ...
fi

# Testshell(Testing for exit code vs output) for output (-m1 limits to one result)
if [[ "$(grep -m1 'foo' somefile)" ]]; then
  ...
fi
}
第9章 使用新写法
shell(使用新写法){
1. 尽量使用func(){}来定义函数，而不是func{}
2. 尽量使用[[]]来代替[]
3. 尽量使用$()将命令的结果赋给变量，而不是反引号
4. 在复杂的场景下尽量使用printf代替echo进行回显
-------------------------------------------------------------------------------
1. 路径尽量保持绝对路径，绝多路径不容易出错，如果非要用相对路径，最好用./修饰
2. 优先使用bash的变量替换代替awk sed，这样更加简短
3. 简单的if尽量使用&& ||，写成单行。比如[[ x > 2]] && echo x
3. 当export变量时，尽量加上子脚本的namespace，保证变量不冲突
4. 会使用trap捕获信号，并在接受到终止信号时执行一些收尾工作
5. 使用mktemp生成临时文件或文件夹
6. 利用/dev/null过滤不友好的输出信息
7. 会利用命令的返回值判断命令的执行情况
8. 使用文件前要判断文件是否存在，否则做好异常处理
9. 不要处理ls后的数据(比如ls -l | awk '{ print $8 }')，ls的结果非常不确定，并且平台有关
10. 读取文件时不要使用for loop而要使用while read
-------------------------------------------------------------------------------
1. logger --priority vs logger -p # 使用长选项，报文脚本可读性
2. set -o errexit (set -e)        # 设定命令执行错误退出
3. command || true                # 运行命令执行失败错误发生
4. set -o nounset (a.k.a. set -u) # 当脚本引用一个未经定义的变量时退出
5. set -o xtrace (a.k.a set -x)   # 跟踪整个脚本的执行过程             [[ "$TRACE" ]] && set -x
6. set -o pipefail                # 捕获管道执行错误
7. #!/usr/bin/env bash 比 #!/bin/bash 根据接口性
8. {}                             # 所有变量在{}中
9. if [ "${NAME}" = "Kevin" ]     # 不要使用这种方式判断字符串相等条件
10. if [ "${NAME:-}" = "Kevin" ] # if [ "${NAME:-noname}" = "Kevin" ]
11. .sh or .bash                 # 文件结尾的一般用于source
-------------------------------------------------------------------------------
set -o errexit
set -o pipefail
set -o nounset
# set -o xtrace

foo || true
command || { echo "command failed"; exit 1; } 
if ! command; then echo "command failed"; exit 1; fi 
command if [ "$?" -ne 0 ]; then echo "command failed"; exit 1; fi 

# Set magic variables for current file & dir
__dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
__file="${__dir}/$(basename "${BASH_SOURCE[0]}")"
__base="$(basename ${__file} .sh)"
__root="$(cd "$(dirname "${__dir}")" && pwd)" # <-- change this as it depends on your app

arg1="${1:-}"
}
第10章 wait
bash(wait){
wait命令等待直到一个用户子进程完成，可以在wait命令中指定进程ID号。如果并未指定，则等待直到所有子进程完成。
等待所有子进程运行完毕：
$ wait
}
第10章 grep
bash(grep){
格式: grep [option] patternfilename 注意: pattern如果是表达式或者超过两个单词的, 需要用引号引用. 可以是单引号也可双引号, 区别是单引号无法引用变量而双引号可以.
锚定行的开始 如：'^grep'匹配所有以grep开头的行。
$
锚定行的结束 如：'grep$'匹配所有以grep结尾的行。
.
匹配一个非换行符的字符如：'gr.p'匹配gr后接一个任意字符，然后是p。
*
匹配零个或多个先前字符如：'*grep'匹配所有一个或多个空格后紧跟grep的行。 .*一起用代表任意字符。
[]
匹配一个指定范围内的字符，如'[Gg]rep'匹配Grep和grep。
[^]
匹配一个不在指定范围内的字符，如：'[^A-FH-Z]rep'匹配不包含A-R和T-Z的一个字母开头，紧跟rep的行。
标记匹配字符，如' '，love被标记为1。
\<
锚定单词的开始，如:'\<grep'匹配包含以grep开头的单词的行。
\>
锚定单词的结束，如'grep\>'匹配包含以grep结尾的单词的行。
x\{m\}
重复字符x，m次，如：'0\{5\}'匹配包含5个o的行。
x\{m,\}
重复字符x,至少m次，如：'o\{5,\}'匹配至少有5个o的行。
x\{m,n\}
重复字符x，至少m次，不多于n次，如：'o\{5,10\}'匹配5--10个o的行。
\w
匹配文字和数字字符，也就是[A-Za-z0-9]，如：'G\w*p'匹配以G后跟零个或多个文字或数字字符，然后是p。
\W
\w的反置形式，匹配一个或多个非单词字符，如点号句号等。


egrep 可以使用基本的正则表达外, 还可以用扩展表达式
+
匹配一个或多个先前的字符。如：'[a-z]+able'，匹配一个或多个小写字母后跟able的串，如loveable,enable,disable等。
?
匹配零个或多个先前的字符。如：'gr?p'匹配gr后跟一个或没有字符，然后是p的行。
a|b|c
匹配a或b或c。如：grep|sed匹配grep或sed
()
分组符号，如：love(able|rs)ov+匹配loveable或lovers，匹配一个或多个ov。
x{m},x{m,},x{m,n}
作用同x\{m\},x\{m,\},x\{m,n\}
}
第10章 BASH 的调试手段--段数
bash(BASH 的调试手段--段数)
{

#### echo/print (普通技)  ####
_loglevel=2
 
DIE() {
    echo "Critical: $1" >&2
    exit 1
}
 
INFO() {
    [ $_loglevel -ge 2 ] && echo "INFO: $1" >&2
}
 
ERROR() {
    [ $_loglevel -ge 1 ] && echo "ERROR: $1" >&2
}

# add color
[ $_loglevel -ge 1 ] && echo -e "\033[31m ERROR:\033[0m $1" >&2
# redirect to file
[ $_loglevel -ge 1 ] && echo "ERROR: $1" > /var/log/xxx_log.$BASHPID

#### set -x (稀有技) ####
-x(xtrace) 选项会导致 BASH 在执行命令之前，先把要执行的命令打印出来。这个选项对调试一些命令错误很有帮助。
set -x
INFO "this is a info log"
ERROR "this is a error log"
set +x

#### trap/bashdb (史诗技)　####
    各个 signal 这里就不介绍了。EXIT 会在 shell 退出时执行指定的命令。若当前 shell 中有命令执行返回
非零值，则会执行与 ERR 相关联的命令。而 RETURN 是针对 source 和 . ，每次执行都会触发 RETURN 陷阱。
若绑定一个命令到 DEBUG，则会在每一个命令执行之前，都会先执行 DEBUG 这个 trap。这里要注意的是，
ERR 和 DEBUG 只在当前 shell 有效。若想函数和子 shell 自动继承这些 trap，则可以设置 -T(DEBUG/RETURN) 
和 -E(ERR)。

#### bashdb (专家级)　####
http://bashdb.sourceforge.net/
}
subshell(){
BASHPID
BASH_SUBSHELL
①.执行bash内置命令时。
    bash内置命令是非常特殊的，父进程不会创建子进程来执行这些命令，而是直接在当前bash环境中执行。
但如果将内置命令放在管道后，则此内置命令将和管道左边的进程同属于一个进程组，所以仍然会创建子shell。
    echo $BASHPID   # 当前BASHPID                                          # 65230
    let a=$BASHPID   # bash内置命令，不进入子shell                         # 
    echo $a                                                                # 65230
    echo $BASHPID                                                          # 65230
    cd | expr $BASHPID      # 管道使得任何命令都进入进程组，会进入子shell  # 65603
②.执行bash命令本身时。
新的bash是一个子进程。执行bash命令会加载各种环境配置项，为了父bash的环境得到保护而不被覆盖，所以应该让其以子shell的方式存在。
重新加载了环境配置项，所以子shell没有继承普通变量，更准确的说是覆盖了从父shell中继承的变量。
    echo "var=55" >>/etc/bashrc
    export var=66
    bash
    echo $var   # 55
    
    echo $BASHPID   # 65230
    bash
    echo $BASHPID   # 65534
③.执行shell脚本时。
脚本中第一行总是"#!/bin/bash"或者直接"bash xyz.sh"，执行bash进入子shell其实是一回事
它仅只继承父shell的某些环境变量，其余环境一概初始化。
cat <<END >b.sh 
#!/bin/bash
echo $BASHPID
END
echo $BASHPID # 65534
./b.sh        # 65570
④.执行shell函数时。
其实shell函数就是命令，它和bash内置命令的情况一样。直接执行时不会进入子shell，但放在管道后会进入子shell。
⑤.执行非bash内置命令时。
例如执行cp命令、grep命令等，它们直接fork一份bash进程，然后使用exec加载程序替代该子bash。此类子进程会继承所有父bash的环境。
⑥.命令替换。
当命令行中包含了命令替换部分时，将开启一个子shell先执行这部分内容，再将执行结果返回给当前命令。
因为这次的子shell不是通过bash命令进入的子shell，所以它会继承父shell的所有变量内容。
    "echo $(echo $$)"中"$$"的结果是当前bash的pid号，而不是子shell的pid号，
    但"echo $(echo $BASHPID)"却和父bash进程的pid不同，因为它不是使用bash命令进入的子shell。
⑦.使用括号()组合一系列命令。
例如(ls;date;echo haha)，独立的括号将会开启一个子shell来执行括号内的命令。
⑧.放入后台运行的任务。
它不仅是一个独立的子进程，还是在子shell环境中运行的。例如"echo hahha &"
⑨.进程替换。
既然是新进程了，当然进入子shell执行。例如"cat <(echo haha)"。
[root@xuexi ~]# echo $BASHPID
65230
[root@xuexi ~]# cat <(echo $BASHPID)    # 进程替换"<()"进入子shell
65616
再说明"$$"的继承问题。除了直接执行bash命令和shell脚本这两种子shell，其他进入子shell的情况都会继承父shell的值。
}
第11章 read
bash(read)
{
read [−ers] [−u fd] [−t timeout] [−a aname] [−p prompt] [−n nchars] [−d delim] [name ...]

从标准输入读入一行，或从 −u 选项的参数中给出的文件描述符fd中读取，
第一个词被赋予第一个name, 第二个词被赋予第二个name, 以此类推，
多余的词和其间的分隔符被赋予最后一个name. 如果从输入流读入的词数比名称数少，
剩余的名称被赋予空值。 IFS 中的字符被用 来将行拆分成词。
反斜杠字符 (\) 被用于删除读取的下一字符的特殊含义，以及续行。

−r  反斜杠不作为转义字符。反斜杠被认为行的一部分。特殊地 ，一对反斜杠-新行符不作为续行。

命令格式 	        描述
read answer 	    从标准输入读取输入并赋值给变量answer。
read first last 	从标准输入读取输入到第一个空格或者回车，将输入的第一个单词放到变量first中，并将该行其他的输入放在变量last中。
read 	            从标准输入读取一行并赋值给特定变量REPLY。
read -a arrayname 	把单词清单读入arrayname的数组里。
read -p prompt 	    打印提示，等待输入，并将输入存储在REPLY中。
read -r line 	    允许输入包含反斜杠。
}
bash(ulimit){
ulimit [-SHacdefilmnpqrstuvx] [限制]
    修改 shell 资源限制。
    
    在允许此类控制的系统上，提供对于 shell 及其创建的进程所可用的
    资源的控制。
    
    选项：
      -S        使用 soft（软）资源限制
      -H        使用 hard（硬）资源限制
      -a        所有当前限制都被报告
      -b        套接字缓存尺寸
      -c        创建的核文件的最大尺寸
      -d        一个进程的数据区的最大尺寸
      -e        最高的调度优先级（nice）
      -f        有 shell 及其子进程可以写的最大文件尺寸
      -i        最多的可以挂起的信号数
      -l        一个进程可以锁定的最大内存尺寸
      -m        最大的内存进驻尺寸
      -n        最多的打开的文件描述符个数
      -p        管道缓冲区尺寸
      -q        POSIX 信息队列的最大字节数
      -r        实时调度的最大优先级
      -s        最大栈尺寸
      -t        最大的CPU时间，以秒为单位
      -u        最大用户进程数
      -v        虚拟内存尺寸
      -x        最大的锁数量
    
    如果提供了 LIMIT 变量，则它为指定资源的新的值；特别的 LIMIT 值为
    soft、hard和unlimited，分别表示当前的软限制，硬限制和无限制。
    否则打印指定资源的当前限制值，不带选项则假定为 -f
    
    取值都是1024字节为单位，除了 -t 以秒为单位，-p 以512字节为单位，
    -u 以无范围的进程数量。
    
    退出状态：
    返回成功，除非使用了无效的选项或者错误发生。
}
第11章 test 单中括号[] 双中括号[[]] 的区别
sh(Shell test 单中括号[] 双中括号[[]] 的区别)
{

# type [ [[ test
[ is a shell builtin
[[ is a shell keyword
test is a shell builtin
[ 和test 是 Shell 的内部命令，而[[是Shell的关键字。

# test是Shell中提供的内置命令，主要用于状态的检验，如果结果为0，表示成功，否则表示失败。
# test -f settings.py && echo true
true
# [ -f settings.py ] && echo true
true
[ 和test 是相等的。


x=1
y=1
$[ $x == 1 && $y == 1 ] && echo true || echo false
-bash: [: missing ]
false
$[[ $x == 1 && $y == 1 ]] && echo true || echo false
true
$[ $x == 1 -a $y == 1 ] && echo true || echo false
true
在[[中使用&&和||表示逻辑与和逻辑或。[中使用-a 和-o 表示逻辑与和逻辑或。


$[[ 'abcd' == a*d ]] && echo true || echo false
true
$[ 'abcd' == a*d ] && echo true || echo false
false
[[支持字符串的模式匹配，使用=~操作符时甚至支持shell的正则表达式。字符串比较时可以把右边的作为一个模式，而不仅仅是一个字符串，比如[[ hello == hell? ]]，结果为真。[[ ]] 中匹配字符串或通配符，不需要引号。


使用[[ ... ]]条件判断结构，而不是[ ... ]，能够防止脚本中的许多逻辑错误。比如，&&、||、<和> 操作符能够正常存在于[[ ]]条件判断结构中，
但是如果出现在[ ]结构中的话，会报错。比如可以直接使用if [[ $a != 1 && $a != 2 ]]
如果不使用双括号, 则为if [ $a -ne 1] && [ $a != 2 ]或者if [ $a -ne 1 -a $a != 2 ]
bash把双中括号中的表达式看作一个单独的元素，并返回一个退出状态码。
}

第12章 test
sh(test){
判断操作符 	                判断为真的条件
1. 字符串判断 	    
[ stringA=stringB ] 	    stringA等于stringB
[ stringA==stringB ] 	    stringA等于stringB
[ stringA!=stringB ] 	    stringA不等于stringB
[ string ] 	                string不为空
[ -z string ] 	            string长度为0
[ -n string ] 	            string长度不为0
2. 逻辑判断 	 
[ stringA -a stringB ] 	    stringA和stringB都是真
[ stringA -o stringB ] 	    stringA或stringB是真
[ !string ] 	            string不为真
3. 逻辑判断(复合判断) 	 
[[ pattern1 && pattern2 ]] 	pattern1和pattern2都是真
[[ pattern1 || pattern2 ] 	pattern1或pattern2是真
[[ !pattern ]] 	            pattern不为真
4. 整数判断 	 
[ intA -eq intB ] 	        intA等于intB
[ intA -ne intB ] 	        intA不等于intB
[ intA -gt intB ] 	        intA大于intB
[ intA -ge intB ] 	        intA大于等于intB
[ intA -lt intB ] 	        intA小于intB
[ intA -le intB ] 	        intA小于等于intB
5. 文件判断中的二进制操作 	 
[ fileA -nt fileB ] 	    fileA比fileB新
[ fileA -ot fileB ] 	    fileA比fileB旧
[ fileA -ef fileB ] 	    fileA和fileB有相同的设备或者inode值
6. 文件检验 	 
[ -d $file ] or [[ -d $file ]] 	file为目录且存在时为真
[ -e $file ] or [[ -e $file ]] 	file为文件且存在时为真
[ -f $file ] or [[ -f $file ]] 	file为非目录普通文件存在时为真
[ -s $file ] or [[ -s $file ]] 	file文件存在, 且长度不为0时为真
[ -L $file ] or [[ -L $file ]] 	file为链接符且存在时为真
[ -r $file ] or [[ -r $file ]] 	file文件存在且可读时为真
[ -w $file ] or [[ -w $file ]] 	file文件存在且可写时为真
[ -x $file ] or [[ -x $file ]] 	file文件存在且可执行时为真
}
第13章 alias
bash(alias){
对于简单命令中的第一个单词，别名可以把它替换成一个字符串。
不管出于什么目的，都应该优先使用shell函数而不是别名。
alias   alias -p          # 显示当前设置的别名。
alias name='command line' # 设置别名。
alias name                # 显示指定的别名设置。
unalias name              # 取消指定的别名设置。
}
bash(unalias){
unalias [-a] 名称 [名称 ...]
    从别名定义列表中删除每一个“名字‘。
    选项：
      -a        删除所有的别名定义.
    返回成功，除非“名字“不是一个已存在的别名
}
第13章 exit
sh(exit){
exit命令用于退出当前shell，在shell脚本中可以终止当前脚本执行。
exit n # 退出。设置退出码为n。
exit   # 退出。退出码不变，即为最后一个命令的退出码。
$? # 上一个命令的退出码。
trap "commands" EXIT # EXIT陷阱是在Bash结束前执行的。
退出码（exit status，或exit code）的约定：
    0表示成功（Zero - Success）
    非0表示失败（Non-Zero  - Failure）
    2表示用法不当（Incorrect Usage）
    127表示命令没有找到（Command Not Found）
    126表示不是可执行的（Not an executable）
    >=128 信号产生
}
sh(times){
显示进程时间
    打印 shell 及其所有子进程的累计用户空间和
    系统空间执行时间。
退出状态
    总是成功。
}
sh(export){
export [-fn] [名称[=值] ...] 或 export -p # 为 shell 变量设定导出属性
标记每个 NAME 名称为自动导出到后续命令执行的环境。如果提供了 VALUE
    则导出前将 VALUE 作为赋值。
    选项：
      -f        指 shell 函数
      -n        删除每个 NAME 名称的导出属性
      -p        显示所有导出的变量和函数的列表
    '--' 的参数禁用进一步的选项处理。
    退出状态：
    返回成功，除非使用了无效的选项或者 NAME 名称
}
sh(getopts){
getopts OPTSTRING name[参数表] 
  Getopts 被 shell 过程用于解析可定位的参数作为选项。
  OPTSTRING 字符串包含待识别的选项字母；如果一个字母后面跟着分号，则该选项期待一个参数，而该参数应用空格与选项分开。
  每次启动时，getopts 会将下一个选项放到 shell 变量 $name中，如果 name 变量不存在则先将其初始化，而下一个待处
理的参数序号放入 shell 变量 OPTIND 中。OPTIND 变量在每次 shell 或者 shell 脚本启动时都被初始化为1。当一个选项要
求有一个参数时，getopts 将参数放入 shell 变量 OPTARG中。
  getopts 有两种报告错误的方法。
  如果 OPTSTRING 变量的第一个字符是冒号，getopts 使用沉默错误报告。在这种模式下，不会打印错误消息。
    如果看到了一个无效的选项，getopts 将找到的选项字符放至 OPTARG 变量中。
    如果一个必须的选项没有找到，getopts 放一个 ':' 到 NAME 变量中并且设置 OPTARG 变量为找到的选项字符。
  如果 getopts 不在沉默模式中，并且遇到了一个无效的选项，getopts 放置一个 '?' 到 NAME 变量中并且反设定 OPTARG变量。
    如果必须的选项没有找到，一个'?'会被放入 NAME变量中，OPTARG 将被反设定，并且会打印一个诊断信息。

退出状态：
    如果一个选项被找到则返回成功；如果遇到了选项的结尾或者
    有错误发生则返回失败。
}
sh(hash){
hash: hash [-lr] [-p 路径名] [-dt] [名称 ...]
    记住或显示程序位置。
    确定并记住每一个给定 NAME 名称的命令的完整路径。如果不提供参数，则显示已经记住的命令的信息。
      -d                忘记每一个已经记住的命令的位置
      -l                以可作为输入重用的格式显示
      -p pathname       使用 pathname 路径作为 NAME 命令的全路径
      -r                忘记所有记住的位置
      -t                打印记住的每一个 NAME 名称的位置，如果指定了多个
                NAME 名称，则每个位置前面会加上相应的 NAME 名称

      NAME              每个 NAME 名称会在 $PATH 路径变量中被搜索，并
                且添加到记住的命令的列表中。
                
    返回成功，除非 NAME 命令没有找到或者使用了无效的选项
    
hash        # 显示哈希表中命令使用频率
hash -l     # 显示哈希表
hash -t git # 显示命令的完整路径
hash -p /home/www/deployment/run run # 向哈希表中增加内容
# 命令等同于
PATH=$PATH:$HOME/www/deployment
hash -r # 删除哈希表内容
}
第13章 trap
bash_k_builtin_trap(){
0和EXIT：当shell退出时就会执行参数。
DEBUG  ：每次执行简单命令、for命令和case命令、select命令、算术for命令的每个算术表达式，以及shell函数的第一个命令之前，都会执行命令参数。
ERR    ：当一个简单命令因为下列原因返回非零的值时就执行命令参数。== errexit选项也服从同样的条件。
       如果失败的命令是紧跟在关键词until或while后的命令队列的一部分，
       或者是在关键词if或elif后的测试命令的一部分，
       或者是&&或||命令队列中所执行命令的一部分，
       或者该命令的返回状态经由! 反转，则不会执行ERR陷阱。
RETURN：当由内部命令. 或source执行的shell函数或脚本执行结束时，都会执行命令参数。

当 shell 收到信号 sigspec 时，命令 arg 将被读取并执行。
1. 如果没有给出arg或者给出的是 −, 所有指定的信号被设置为它们的初始值
2. 如果arg是空字符串， sigspec 指定的信号 被 shell 和它启动的命令忽略。
3. 如果arg不存在，并且给出了−p 那么与每个 sigspec 相关联的陷阱命令将被显示出来。
4. 如果没有给出任何参数，或只给出了−p， trap将打印出与每个信号编号相关的命令列表 。
5. 如果sigspec是 EXIT (0)，命令arg将在 shell 退出时执行。
6. 如果sigspec是 DEBUG, 命令arg将在每个简单命令(simple command，参见上面的 SHELL GRAMMAR) 之后执行。
7. 如果sigspec是 ERR, 命令 arg 将在任何命令以非零值退出时执行。
   如果失败的命令是until或while循环的一部分,if语句的一部分,&&或||序列的一部分,或者命令的返回值是通过!转化而来，ERR陷阱将不会执行。
EXIT shell从脚本中退出后发送该信号 
DEBUG shell执行完一条语句后发送该信号
第一种:
　trap 'commands' signal-list
当脚本收到signal-list清单内列出的信号时,trap命令执行双引号中的命令.

第二种:
　trap signal-list
trap不指定任何命令,接受信号的默认操作.默认操作是结束进程的运行.

第三种:
　trap ' ' signal-list
trap命令指定一个空命令串,允许忽视信号.
忽略信号signals，可以多个，比如 trap "" INT 表明忽略SIGINT信号，按Ctrl+C也不能使脚本退出。
                           又如 trap "" HUP 表明忽略SIGHUP信号，即网络断开时也不能使脚本退出。
trap -p
trap -p signal # 把当前的trap设置打印出来。

trap -l                # 把所有信号打印出来。
trap "commands" EXIT   # 脚本退出时执行commands指定的命令。
trap "commands" DEBUG  # 在脚本执行时打印调试信息，比如打印将要执行的命令及参数列表。
trap "commands" ERR    # 当命令出错，退出码非0，执行commands指定的命令。
trap "commands" RETURN # 当从shell函数返回、或者使用source命令执行另一个脚本文件时，执行commands指定的命令。


# 脚本退出时清除屏幕。
trap 'printf \\e[2J\\e[H\\e[m' EXIT

# 忽略终端中断（CTRL+C，SIGINT）
trap '' INT

# 在窗口调整大小时调用函数. 
trap 'code_here' SIGWINCH

# 在命令之前执行某些操作
trap 'code_here' DEBUG

# 在shell函数或源文件完成执行时执行某些操作
trap 'code_here' RETURN
}
sh(unset){
unset [-fv] [名称]
反设定 shell 变量和函数的值和属性。
    -f        将每个 NAME 名称当作函数对待
    -v        将每个 NAME 名称当作变量对待
不带选项时，unset 首先尝试反设定一个变量，如果失败，再尝试反设定一个函数。
}
第14章 trap
trap(){
#!/bin/sh  
  
#2007.05.06/07  
# 增加了杀掉LAST_PID功能  
# 增加了脚本退出时杀掉THIS_PID功能  
  
LAST_PID=$(ps -ef|grep 'java.*Zhenjiang'|grep -v grep|awk '{print $2}')  # 找出正在运行的符合指定特征的进程；
  
echo "LAST_PID=$LAST_PID"  
  
if [ -n "$LAST_PID" ] &&  [ "$LAST_PID" -gt 0 ]; then  #如果找到了这样的进程，就杀掉；
    echo "LAST PROCESS NOT EXIT, NOW KILL IT!"  
    kill $LAST_PID  
    sleep 1  
fi  
  
if ! cd ../opt/zhenjiang; then  
    echo "CHANGE DIRECTORY FAILED"  
    exit 1  
fi  
  
java -classpath .:./cpinterfaceapi.jar:./log4j-1.2.14.jar:./hyjc.jar:./smj.client.jar Zhenjiang & # 以后台方式启动java程序； 
  
THIS_PID=$!  # 得到刚启动的程序的pid；
  
echo "THIS_PID=$THIS_PID"  
  
trap "kill $THIS_PID" TERM  # 对SIGTERM信号设置处理方式：结束启动的java程序；
  
wait # 等待后台进程结束。
}
第15章 命令
shell(命令:简单命令)
{
简单命令是(可选的)一系列变量赋值, 紧接着是 blank(空格) 分隔的词和重定向, 
    然后以一个control operator 结束. 第一个词指明了要执行的命令, 它被作为第0 
    个参数. 其余词被作为这个命令的参数.
简单命令的返回值是它的退出状态,, 如果命令被 signal(信号) n结束的话，退出状态为128+n
}
shell(命令:管道){
管道里面的每个命令是在自己子shell里面执行，管道的退出状态是最后一个命令的退出状态。
pipefail打开则是：管道的退出状态是最后一个返回非零的那个命令的退出状态。
}
shell(命令:队列命令){
& && ||连接而成，最后可以由; & 或换行结束。"与"和"或"队列的返回值是其中最后一个被执行的命令的返回值。
}
shell(命令:复合命令){
复合命令是shell的编程结构体。每个结构体都是以保留字或者控制运算符开头，然后以与之对应的保留字或控制运算符结束。
1 循环结构 until while for 2 条件结构 if case select (()) [[]] 3 组合结构 () {} 4 协同进程
}
第15章 关键字
shell(关键字){
! [[ ]] {}
case do done elif else esac fi for function if in select then time until while
}
第15章 内建命令
shell(内建命令){
  enable -s # POSIX内建命令     sh
  enable -a # Bash所有内建命令  bash
}
第15章 返回值
sh(return){
退出状态
1. 返回状态总是介于0和255之间，
2. 对成功执行的命令，它的退出状态是零；
3. 非零的退出状态表示失败了
4. 如果命令接收到一个值为N的关键信号而退出，Bash就会把128+N作为它的退出状态。
5. 如果命令找到但却不是可执行的，就返回状态126。
6. 如果命令没有找到，用来执行它的子进程就会返回状态127
7. 如果使用不正确，所有的内部命令返回状态为2
}
第15章 eval
sh(eval){
eval [arg ...]
arg 被读取并连结为单一的命令。这个命令然后被 shell 读取并执行，
 它的退出状态被作为 eval 的值返回。如果没有 args，或仅仅包含空参数， eval返回0。
 
eval 命令将会首先扫描命令行进行所有的置换，然后再执行该命令。该命令适用于那些一次扫描无法实现其功能的变量，
该命令对变量进行两次扫描。这些需要进行两次扫描的变量有时被称为复杂变量。eval命令即可以用于回显简单变量，
也可以用于回显复杂变量。
}
第15章 sh source exec
sh     父进程会fork一个子进程，shell script在子进程中执行
source 在原进程中执行，不会fork子进程
exec   在原进程中执行，但是同时会终止原进程
sh(exec)
{
exec [−cl] [−a name] [command [arguments]]
如果指定了 command，它将替换 shell。 不会产生新的进程。 arguments成为command 的参数。
如果给出了−l 选项，shell 将在传递给command 的第 0 个参数前面加上一个连字符 (dash,'-')。
选项 −c 使得命令command在一个空环境中执行。 如果给出了−a， shell 会将 name 作为第0个参数传递给要执行的命令 。
}
sh(break|continue){
break|continue [n]: 返回状态是零，除非n不是大于或等于1。
}
sh(cd){
cd: -P physical物理路径 -L symlink 符号链接   如果改变目录成功，返回状态就是零；否则就是非零。
}
第16章 BASH_REMATCH,模式匹配
shell(BASH_REMATCH,模式匹配)
{
从 bash 3以上版本里，已经自带正则匹配的功能，很多情况下，可以不用awk/sed来做。
<List>
    <Job id="1" name="abc"/>
    <Job id="2" name="zyz"/>
    <Job id="3" name="beew"/>
</List>

    abc | 1
    zyz | 2
    beew | 3
    
#!/bin/bash
while read  line; do
  if [[ $line =~ id=\"([0-9]+).*name=\"([^\"]*) ]]; then
    echo "${BASH_REMATCH[2]} | ${BASH_REMATCH[1]}"
  fi
done < file

    双目运算符=~；它和==以及!=具有同样的优先级。如果使用了它，则其右边的字符串就被认为是一个扩展的
正则表达式来匹配。如果字符串和模式匹配，则返回值是0，否则返回1。如果这个正则表达式有语法错误，
则整个条件表达式的返回值是2。如果打开了shell的nocasematch 选项则匹配时不考虑字母的大小写。模式的
任何部分都可以被引用以强制把其当作字符串来匹配。由正则表达式中括号里面的子模式匹配的字符串被保存
在数组变量BASH_REMATCH 中。BASH_REMATCH 中下标为0的元素是字符串中与整个正则表达式匹配的部分。
BASH_REMATCH 中下标为n的元素是字符串中与第n 个括号里面的子模式匹配的部分。
}

第17章 使用read读取其它命令的输出，不产生新shell
shell(使用read读取其它命令的输出，不产生新shell){
由于管道会产生新的sub-shell，因此下列形式的命令中，read读取到的a、b、c变量的值在外面无法访问。
command | read a b c

1. heredoc
read a b c << HERE
$(command)
HERE

2. herestring
read a b c <<< "$(command)"

3. process substation
read a b c < <(command)
}
第17章 字符串转换为数组
shell(字符串转换为数组){
b="abc def ghi"
a=($b)
echo ${#a[*]}
echo ${a[*]}
echo ${a[0]} ${a[1]} ${a[2}

for i in $(seq 0 $((${#a[*]} - 1))); do
  echo "a[$i] = \"${a[$i]}\""
done
}
；
shell(把目录列表变为数组){
array=(`ls`)
}
第17章 间接引用赋值
shell(间接引用赋值){
ref=realvariable
read $ref <<< "contents"

ref=realvariable
printf -v $ref "contents"

aref=realarray
read -a $aref <<< "words go into array elements"
echo "${realarray[1]}"   # prints "go"
}
第17章 遍历数组
shell(遍历数组){
for name in "${names[@]}"
do
echo $name
# other stuff on $name
done
}
第17章 两个数组相减
shell(两个数组相减){
a=( a b c d e f g )
b=( a c e g z )
c=( $(comm -23 <( printf "%s\n" "${a[@]}" ) <( printf "%s\n" "${b[@]}") ) )
}
第18章 判断一个key是否在数组中（普通数组或关联数组均可
shell(判断一个key是否在数组中（普通数组或关联数组均可）){
if test "${myArray['key_or_index']+isset}"
then
    echo "yes"
else
    echo "no"
fi;

也可以用
if [ "${myArray['key_or_index']+isset}" ]
}
第19章 间接引用数组
shell(间接引用数组){
a=("a a" "b b" "c c")
b="a[@]"
for i in "${!b}"; do
  echo $i
done

单字符分隔符
function join_by { local IFS="$1"; shift; echo "$*"; }

多字符分隔符
function join_by { local d=$1; shift; echo -n "$1"; shift; printf "%s" "${@/#/$d}"; }
}
第19章 数组排序
shell(数组排序){
export PATH="$(/usr/sbin/sysctl -n user.cs_path)"

export IFS=$'\n'
#export IFS=$' \t\n'

ar1=('g h c' abc def 123)
ar2=('1 2 3' ABC ghc DEF)
ar3=('-x' '! & ?' $'a test\nsentence' $'another test\nsentence\n.' a64bitapp a32bitapp)

printf "%s\n" "${#ar1[@]}" "${#ar2[@]}" "${#ar3[@]}"


# ar3
for ((i=0; i < "${#ar3[@]}"; i++)); do echo "${ar3[$i]}"; done | sort | nl
for ((i=0; i < "${#ar3[@]}"; i++)); do echo ${ar3[$i]}; done | sort | nl
for ((i=0; i < "${#ar3[@]}"; i++)); do echo "${ar3[$i]}" | ruby -0777 -n -e 'p $_.to_s'; done | nl
for ((i=0; i < "${#ar3[@]}"; i++)); do printf -- "${ar3[$i]}\n" | ruby -0777 -n -e 'p $_.to_s'; done | nl


# sort a single array
ar3sorted=( $(for ((i=0; i < "${#ar3[@]}"; i++)); do echo ${ar3[$i]}; done | sort) )
for ((i=0; i < "${#ar3sorted[@]}"; i++)); do echo "${ar3sorted[$i]}" | ruby -0777 -n -e 'p $_.to_s'; done | nl
for ((i=0; i < "${#ar3sorted[@]}"; i++)); do printf "%s\n" "${ar3sorted[$i]}" | ruby -0777 -n -e 'p $_.to_s'; done | nl


# adding \000\n as array item delimiter
printf "%s\000\n" "${ar3[@]}"  | sed -n -e 'l'
printf "%s\000\n" "${ar3[@]}"  | ruby -n -e 'p $_.to_s'
printf "%s\000\n" "${ar3[@]}"  | ruby -0777 -n -e 'p $_.to_s'
printf "%s\000\n" "${ar3[@]}" | sed -e :a -e '$!N; s/\n/NEWLINE/g; ta' | ruby -n -e 'p $_.to_s'
printf "%s\000\n" "${ar3[@]}" | sed -e :a -e '$!N; s/\n/NEWLINE/g; ta' | tr '\000' '\n' | sed -e 's/^NEWLINE//' | ruby -n -e 'p $_.to_s'


ar3sorted=( $(printf "%s\000\n" "${ar3[@]}" | sed -e :a -e '$!N; s/\n/NEWLINE/g; ta' | tr '\000' '\n' | sed -e 's/^NEWLINE//' | sort) )
for ((i=0; i < "${#ar3sorted[@]}"; i++)); do printf -- "${ar3sorted[$i]//NEWLINE/\n}" | ruby -0777 -n -e 'p $_.to_s'; done | nl


# sort multiple arrays; convert embedded newline characters into single spaces
ar4=( $(printf "%s\n\000" "${ar1[@]}" "${ar2[@]}" "${ar3[@]}" | tr '\n' ' ' | tr '\000' '\n' | sort) )

# sort multiple arrays; preserve embedded newline characters as NEWLINE
ar4=( $(printf "%s\000\n" "${ar1[@]}" "${ar2[@]}" "${ar3[@]}" | sed -e :a -e '$!N; s/\n/NEWLINE/g; ta' | tr '\000' '\n' | sed -e 's/^NEWLINE//' | sort) )


printf "%s\n" "${#ar4[@]}"
printf "%s\n" "${ar4[@]}" | nl

for ((i=0; i < "${#ar4[@]}"; i++)); do echo ${ar4[$i]//NEWLINE/\\n}; done | nl
for ((i=0; i < "${#ar4[@]}"; i++)); do echo -e ${ar4[$i]//NEWLINE/\\n}; done | nl
for ((i=0; i < "${#ar4[@]}"; i++)); do printf -- ${ar4[$i]//NEWLINE/\\n}"\n"; done | nl
for ((i=0; i < "${#ar4[@]}"; i++)); do printf -- "${ar4[$i]//NEWLINE/\n}\n"; done | nl
for ((i=0; i < "${#ar4[@]}"; i++)); do printf "%s\n" ${ar4[$i]//NEWLINE/\\n}; done | nl
for ((i=0; i < "${#ar4[@]}"; i++)); do printf -- "${ar4[$i]//NEWLINE/\n}\n" | ruby -0777 -n -e 'p $_.to_s'; done | nl
for ((i=0; i < "${#ar4[@]}"; i++)); do printf "%s\n" "${ar4[$i]//NEWLINE/\n}" | ruby -0777 -n -e 'p $_.to_s'; done | nl

}
第19章 关联数组
shell(关联数组){
# 只能通过declear -A声明关联数组
declare -A a
a['abc']='ABC'
a['bcd']='BCD'

echo "${a[@]}"
echo "${a[abc]}"
echo "${a[bcd]}"

for key in ${!a[@]}; do
    echo "$key => ${a[$key]}"
done

Note
	for key in ${!a[@]} 得到的是关联数组的keys
Note
	for key in ${a[@]} 得到的是关联数组的values
}
第19章 数组
shell(数组)
{
    names[2]=alice; name[0]=hatter; names[1]=duchess
    names={[2]=alice [0]=hatter [1]=duchess}
    names={ hutter duchess alice}
    
    declare -a NAME : 申明一个索引数组
    declare -A NAME : 申明一个关联数组
    ${#ARRAY_NAME[*]}
    ${#ARRAY_NAME[@]}
    
    ${names}   #引用names的第i个元素, 用"@"和"*"引用所有的数组元素
    ${#names} #引用names的第i个元素的长度
    ${#names[@]} #数组的长度
}  
第20章 #
shell(\#){
注释符号(Hashmark[Comments])
1.在shell文件的行首，作为shebang标记，#!/bin/bash;
2. 其他地方作为注释使用，在一行中，#后面的内容并不会被执行，除非；
3. 但是用单/双引号包围时，#作为#号字符本身，不具有注释作用。

当我们直接使用./a.sh来执行这个脚本的时候，如果没有shebang，那么它就会默认用$SHELL指定的解释器，
否则就会用shebang指定的解释器。
}
第20章 ;
bash(;){
作为多语句的分隔符(Command separator [semicolon])。
多个语句要放在同一行的时候，可以使用分号分隔。注意，有时候分号需要转义。
}
第20章 ;;
shell(;;){
连续分号(Terminator [double semicolon])。
在使用case选项的时候，作为每个选项的终结符。在Bash version 4+ 的时候，还可以使用[;;&], [;&]
}
第20章 .
sh(.){
点号(dot command)。
# . 文件名 [参数]
如果提供了参数，它们就成为执行文件名时的位置参数；否则，位置参数不会被改变。
返回状态是最后一个被执行命令的退出状态；
如果没有命令被执行，则返回零。
如果文件名没有找到，或者不能读取，返回状态就是非零值。
1. 相当于bash内建命令source，如：
    #!/bin/bash
    . data-file
    #包含data-file;
2. 作为文件名的一部分，在文件名的开头，表示该文件为隐藏文件，ls一般不显示出来（ls -a 可以显示）；
3. 作为目录名，一个点代表当前目录，两个点号代表上层目录（当前目录的父目录）。注意，两个以上的点不出现，除非你用引号（单/双）包围作为点号字符本身；
4. 正则表达式中，点号表示任意一个字符。
}
第20章 ,
shell(,){
逗号(comma operator [comma])。
1. 用在连接一连串的数学表达式中，这串数学表达式均被求值，但只有最后一个求值结果被返回。如：
    #!/bin/bash
    let t1=((a=5+1, b=7+2))
    echo t1=$t1, a=$a, b=$b
    ## 这个$t1=$b；
2. 用于参数替代中，表示首字母小写，如果是两个逗号，则表示全部小写，注意，这个特性在bash version 4的时候被添加的。例子：
    a="ATest"
    echo ${a,}
    echo ${a,,}
    ## 前面输出aTest，后面输出的是atest。
}
第20章 :
sh(:){
冒号(null command)。
# :[参数]
空命令，这个命令什么都不做，但是有返回值，返回值为0（即：true）。
1. 可做while死循环的条件；
2. 在if分支中作为占位符（即某一分支什么都不做的时候）；
3. 放在必须要有两元操作的地方作为分隔符，如：: ${username=`whoami`}
4. 在参数替换中为字符串变量赋值，在重定向操作(>)中，把一个文件长度截断为0（:>>这样用的时候，目标存在则什么都不做），这个只能在普通文件中使用，不能在管道，符号链接和其他特殊文件中使用；
5. 甚至你可以用来注释（#后的内容不会被检查，但:后的内容会被检查，如果有语句如果出现语法错误，则会报错）；
6. 你也可以作为域分隔符，比如环境变量$PATH中，或者passwd中，都有冒号的作为域分隔符的存在；
7. 你也可以将冒号作为函数名，不过这个会将冒号的本来意义转变（如果你不小心作为函数名，你可以使用unset -f : 来取消function的定义）。
}
第20章 !
shell(!){
感叹号（reverse (or negate) [bang],[exclamation mark])。
取反一个测试结果或退出状态。
1. 表示反逻辑，比如后面的!=,这个是表示不等于；
2. 表示取反，如：ls a[!0-9] #表示a后面不是紧接一个数字的文件；
3. 在不同的环境里面，感叹号也可以出现在间接变量引用里面；
4. 在命令行中，可以用于历史命令机制的调用，你可以试试!$,!#，或者!-3看看，不过要注意，这点特性不能在脚本文件里面使用（被禁用）。
}
第20章 {}
shell({}){
花括号扩展(Brace Expansion)。
    在命令中可以用这种扩展来扩展参数列表，命令将会依照列表中的括号分隔开的模式进行匹配扩展。注意的一点是，这花括号扩展中
不能有空格存在，如果确实有必要空格，则必须被转义或者使用引号来引用。例子：echo {a,b,c}-{\ d," e",' f'}

    在Bash version 3时添加了这种花括号扩展的扩展，可以使用{A..Z}表示A-Z的所有字符列表，这种方式的扩展Mitchell测试了一下，
好像仅适用于A-Z，a-z，还有数字{最小..最大}的这种方式扩展。

代码块(curly brackets)。
    这个是匿名函数，但是又与函数不同，在代码块里面的变量在代码块后面仍能访问。注意：花括号内侧需要有空格与语句分隔。
另外，在xargs -i中的话，还可以作为文本的占位符，用以标记输出文本的位置。

{} \; 
    这个{}是表示路径名，这个并不是shell内建的，现在接触到的情况看，好像只用在find命令里。注意后面的分号，这个是结束find
命令中-exec选项的命令序列，在实际使用的时候，要转义一下以免被shell理解错误。
}
第20章 []
shell([]){
中括号（brackets）。
1. 测试的表示，Shell会测试在[]内的表达式，需要注意的是，[]是Shell内建的测试的一部分，而非使用外部命令/usr/bin/test的链接；
2. 在数组的上下文中，表示数组元素，方括号内填上数组元素的位置就能获得对应位置的内容，如：
    Array[1]=xxx
    echo ${Array[1]};
3. 表示字符集的范围，在正表达式中，方括号表示该位置可以匹配的字符集范围。
}
第20章 [[]]
shell([[]]){
双中括号(double brackets)。

    这个结构也是测试，测试[[]]之中的表达式(Shell的关键字)。这个比单中括号更能防止脚本里面的逻辑错误，比如：
&&,||,<,>操作符能在一个[[]]里面测试通过，但是在[]却不能通过。[[]]里面没有文件名扩展(filename expansion）
或是词分隔符(Word splitting)，但是可以用参数扩展(Parameter expansion)和命令替换(command substitution)。
不用文件名通配符和像空白这样的分隔符。注意，这里面如果出现了八进制，十六进制等，shell会自动执行转换比较。

t="abc123"
[[ "$t" == abc* ]]         # true (globbing比较)
[[ "$t" == "abc*" ]]       # false (字面比较)
[[ "$t" =~ [abc]+[123]+ ]] # true (正则表达式比较)
[[ "$t" =~ "abc*" ]]       # false (字面比较)
}
第20章 $[...]
shell($[...]){
词表达表示整数扩展(integer expansion)。
在方括号里面执行整数表达式。例：
    a=3
    b=7
    echo $[$a+$b]
    echo $[$a*$b]
    ##返回是10和21
}
第20章 (())
shell((())){
双括号(double parentheses):表达式计算

    表示整数扩展（integer expansion）。功能和上面的$[]差不多，但是需要注意的是，$[]是会返回里面表达式的值的，而(())
只是执行，并不会返回值。两者执行后如果变量值发生变化，都会影响到后继代码的运行。可对变量赋值，可以对变量进行
一目操作符操作，也可以是二目，三目操作符。
}
第20章 ~
shell(~)
{
~ 波浪号(Home directory[tilde])。
这个和内部变量$HOME是一样的。默认表示当前用户的家目录（主目录），这个和~/效果一致，如果波浪号后面跟用户名，表示是该用户的家目录。

}
第20章 ~+
shell(~+){
当前的工作目录(current working directory)。
这个和内置变量$PWD一样。
}
第20章 ~-
shell(~-){
前一个工作目录(previous working directory)。
这个和内部变量$OLDPWD一致，之前的[-]也一样。
}
第21章 模拟linux登录
bash(模拟linux登录){
#!/bin/bash

echo -n "login:"
read name
echo -n "password:"
read password

if [ $name = "chf" -a $password = "abc" ] ; then
    echo "the host and password is right!"
else
    echo "input is error!"
fi

}
第21章 比较两个数大小
bash(比较两个数大小)
{

#!/bin/bash
echo "please enter two number"
read a
read b
if  test $a -eq $b   
then
    echo "NO.1 == NO.2"
elif  test $a -gt $b 
then
    echo "NO.1 > NO.2"
else
    echo "NO.1 < NO.2"
fi
}
第22章 查找/root/目录下是否存在该文件
bash(查找/root/目录下是否存在该文件)
{

#!/bin/bash
echo "enter a file name:"
read a
if test -e "/root/$a" 
then 
    echo "the file is exist!"
else
    echo "the file is not exist!"
fi

}
第22章 for循环使用
bash(for循环使用)
{

#!/bin/bash
clear
for num in 1 2 3 4 5 6 7 8 9 10
do
    echo "$num"
done    
}
第22章 命令行输入
bash(命令行输入)
{

#!/bin/bash
echo "pleaset enter a user"
read a
b=$(whoami)
if test $a = $b
then
    echo "the user is running"
else
    echo "the user is not running"
fi
}
第22章 删除当前目录下大小为0的文件
bash(删除当前目录下大小为0的文件)
{

#!/bin/bash
for filename in `ls`
do
    if test -d $filename
    then
        b=0
    else
        a=$(ls -l $filename | awk '{print $5}')
            if test $a -eq 0
            then
                rm $filename
            fi
     fi
done     
}
第22章 测试IP地址
bash(测试IP地址)
{
#!/bin/bash
for i in $(seq 1 10)
do
    echo "the number of $i computer is"
    ping -c 1 192.168.10.$i
done
}

bash(如果test.log的大小大于0，那么将/opt目录下的.*.tar.gz文件)
{

#/bin/bash
a=2
while name="test.log"
do
    sleep 1
    b=$(ls -l $name | awk '{ print $5 }')
    if test $b -ge $a
    then
        cp /opt/*.tar.gz .
    exit 0
    fi
done
}

bash(打印读取的内容)
{

#!/bin/bash
while read name 
do
    echo $name
done    
}

bash(从0.sh中读取内容并打印)
{

#!/bin/bash
while read line
do
    echo $line
done < 0.sh
}

bash(读取a.c中的内容并作加1运算)
{

#!/bin/bash
test -e a.c

while read line
do
    a=$(($line+1))
done < a.c
echo $a
}

#普通无参数函数
#!/bin/bash

p()
{
 echo "hello"
}
p

#给函数传递参数
#!/bin/bash

p_num()
{
    num=$1
    echo $num
}

for n in $@
do
    p_num $n
done

bash(创建文件夹)
{

#!/bin/bash

while
do
    echo "please inut file's name"
    read a
    if test -e /root/$a
    then
        echo "the file is existing, please input new file name"
    else
        mkdir $a
        echo "you eye susses"
        break
    fi    
done
}

#获取本机IP地址
ifconfig | grep "inet addr" | awk '{ print $2 }' | sed 's/addr//g'

bash(查找最大文件)
{
#有问题，不正确

#!/bin/bash
a=0
for name in "."
do
    b=$(ls -l $name | awk '{ print $5 }')
    if test $b -ge $a
    then
        a=$b
        namemax=$name
    fi    
done
echo "the max file is $namemax"
}

bash(case语句练习)
{

#!/bin/bash

clear
echo "enter a number from 1 to 5"
read num
case $num in
    1) 
        echo "your enter 1"
        ;;
    2) 
        echo "your enter 2"
        ;;
    3) 
        echo "your enter 3"
        ;;
    4) 
        echo "your enter 4"
        ;;
    5) 
        echo "your enter 5"
        ;;
    *) 
        echo "error $num"
        ;;
esac


echo "Do you wish to continue? (y/n)"
read ans

case $ans in
    Y|y) ;;
    [Yy][Ee][Ss]) ;;
    N|n) exit ;;
    [Nn][Oo]) exit ;;
    *) echo "Invalid command"
esac
}

bash(yes/no返回不同的结构)
{

#!/bin/bash
clear
echo "enter [y/n]"
read a
case $a in
    y|Y|yes|YES)
        echo "you enter $a"
        ;;
    n|N|no|NO)
        echo "you enter $a"
        ;;  
    echo "error $num"
        ;;
esac
}

bash(内置命令的使用)
{

#!/bin/bash
clear

echo "Hello $USER"
echo 
echo "Today's date id `date`"

echo

echo "the user is"
who
echo 

echo "this is `uname -s`"
echo

echo "that's all folks"
}

bash(打印无密码用户)
{

#!/bin/bash
echo "No password User are:"
echo $(cat /etc/shadow | grep "\!\!" | awk 'BEGIN {FS=":"}{print $1}')
}


bash_a_builtin_caller(){
在shell中，内建(builtin)命令caller，格式如下：
caller [表达式]
  如果没有表达式，caller显示当前子程序调用的行号和源文件名。
  如果用非负整数作为表达式，caller就会显示行号、子程序名称、以及与当前调用堆栈位置相对应的源文件。这些额外信息可以用来打印堆栈跟踪信息。
  当前的帧是第0帧。
  返回值是0，除非shell并没有在执行子程序调用，或者表达式不对应调用堆栈中的有效位置。

下面以例子说明caller命令的用法：

$ cat -n test.sh 
     1  #!/bin/bash
     2  
     3  foo()
     4  {
     5      echo "foo called"
     6      caller 
     7  }
     8  
     9  bar()
    10  {
    11      echo "bar called"
    12      caller 0
    13  }
    14  
    15  test1()
    16  {
    17      echo "test1 called"
    18      caller
    19      caller 0
    20      caller 1
    21      caller 2
    22  }
    23  
    24  test2()
    25  {
    26      echo "test2 called"
    27      test1
    28  }
    29  
    30  test3()
    31  {
    32      echo "test3 called"
    33      test2
    34  }
    35  
    36  foo
    37  bar
    38  test3
$ bash test.sh 
foo called
36 test.sh
bar called
37 main test.sh
test3 called
test2 called
test1 called
27 test.sh
27 test2 test.sh
33 test3 test.sh
38 main test.sh
}

bash_a_builtin_builtin(){
在shell中，内建(builtin)命令builtin，格式如下：
builtin shell-builtin [arguments]
builtin命令用以执行shell的内建命令，既然是内建命令，为什么还要以这种方式执行呢？
因为shell命令执行时首先从函数开始，如果自定义了一个与内建命令同名的函数，那么就执行这个函数而非真正的内建命令。
下面以shell内建命令umask为例说明：

$ umask
0002
$ umask() { echo "umask function"; }
$ umask
umask function
$ builtin umask
0002
$ unset -f umask
$ umask
0002
}

bash_a_builtin_command(){
在shell中，内建(builtin)命令command，格式如下：
command [-pVv] command [arg ...]
command命令类似于builtin，也是为了避免调用同名的shell函数，命令包括shell内建命令和环境变量PATH中的命令。
选项"-p"指定在默认的环境变量PATH中查找命令路径。选项"-v"和"-V"用于显示命令的描述，后者显示的信息更详细。

下面以命令ps("/bin/ps")为例说明：

$ ps
  PID TTY          TIME CMD
 8726 pts/22   00:00:00 ps
10356 pts/22   00:00:00 bash
$ ps() { echo "function ps"; }
$ ps
function ps
$ command ps
  PID TTY          TIME CMD
 9259 pts/22   00:00:00 ps
10356 pts/22   00:00:00 bash
$ unset -f ps
$ ps
  PID TTY          TIME CMD
 9281 pts/22   00:00:00 ps
10356 pts/22   00:00:00 bash
}

bash(declare){
-a 每个名称都下表数组变量
-A 每个名称都是键值数组变量
-f 只使用函数名称
-i 把变量当成整数
-l 对变量名称赋值，把大写字母转化为小写。清除upper-case属性。助记词: Lowercase, 小写
-r 把名称设为只读。以后不可以用赋值语句对这些名称赋值或者把它们重置。助记词: Readonly, 只读
-t 给每个名称都设置trace属性。设置了trace属性函数继承调用它的shell的DEBUG和RETURN陷阱。trace属性对变量来说没有特殊意义。助记词: Trace, 跟踪
-u 对变量名称赋值，把小写字母转化为大写。清除lower-case属性。助记词: Uppercase, 大写
-x 通过环境把每个名称导出给后续命令。助记词: eXport, 导出
使用"+"而不是"-"会关闭属性；
}
第22章 set
bash(set){
在shell中，内建（builtin）命令set，格式如下：

set [--abefhkmnptuvxBCEHPT] [-o option-name] [arg ...]
set [+abefhkmnptuvxBCEHPT] [+o option-name] [arg ...]
set命令用以改变bash默认行为，不指定任何选项和参数时，显示所有shell变量的名称及值，包括shell函数，但在posix模式下只显示shell变量。
显示结果是根据当前语系进行排序的，输出形式是一种友好的可以直接用来设置变量的格式，只读变量不能进行重置。
当指定了某些选项时，就可以设置shell属性了，选项后面的所有参数arg当作位置参数进行处理。

下面是set命令各选项的含义。

"-a"：自动标记创建或修改的变量和函数，它们可以导出到后续命令的环境中。Alter
"-b"：启用了作业控制时这个命令才有效，即时报告后台作业终止时的状态，而不是等待下一个shell主提示符。Background
"-e"：管道、列表、组合命令的退出状态非0时立即退出，但这些命令为while或until后面的命令、if或elif后面的测试命令、
     最后一个"&&"或"||"前面的命令、管道中不是最后一个的命令或者是使用了"!"的命令时，则不会立即退出。
     忽略这个选项时，组合命令而非子shell返回false时不会退出shell。如果通过内建命令trap设置了"ERR"，
     它们在shell退出前执行。这个选项作用于当前shell及其子shell，那么，子shell在执行完所有命令前就可能提前退出了。
     需要注意的是，如果当前环境忽略了这个选项，即使设置了这个选项且返回false，组合命令或shell函数执行时也不受
     这个选项影响。 Exit
"-f"：禁止路径名扩展。 Filename
"-h"：查找命令执行时记住命令位置，默认状态是打开的。Hash
"-k"：把以赋值语句形式出现的所有参数都放置到命令环境中，而不仅仅是命令名前面的那部分内容。Keep
"-m"：监控模式，启用作业控制，支持交互式shell时才有效，所有进程都处于独立的进程组，后台作业结束时，shell打印出退出状态。 Monitor
"-n"：读取命令但不执行它们，可用于shell脚本语法检查，在交互式shell中忽略。No-execution
"-o allexport"：同"-a"。
"-o braceexpand"：同"-B"。 Brace
"-o emacs"：使用emacs风格的命令行编辑，对内建命令"read -e"有影响。交互式shell中默认使用这个选项，除非启动shell时使用了选项"–noediting"。
"-o errexit"：同"-e"。
"-o errtrace"：同"-E"。
"-o functrace"：同"-T"。
"-o hashall"：同"-h"。
"-o histexpand"：同"-H"。
"-o history"：启用历史命令，交互式shell中默认启用。
"-o ignoreeof"：同执行过的shell命令"IGNOREEOF=10"。
"-o keyword"：同"-k"。
"-o monitor"：同"-m"。
"-o noclobber"：同"-c"。
"-o noexec"：同"-n"。
"-o noglob"：同"-f"。
"-o nolog"：忽略。
"-o nofity"：同"-b"。
"-o nounset"：同"-u"。
"-o onecmd"：同"-t"。
"-o physical"：同"-p"。
"-o pipefail"：默认禁止，启用这个选项时命令返回值为最后一个失败的命令的退出状态，如果所有命令都执行成功则返回0。
"-o posix"：启用POSIX模式，会影响bash操作。
"-o previleged"：同"-p"。
"-o verbose"：同"-v"。
"-o vi"：使用vi风格的命令行编辑，对内建命令"read -e"有影响。
"-o xtrace"：同"-x"。
如果使用了选项"-o"却没有指定"option-name"，则打印当前所有选项的状态（on或off），如果使用了选项"+o"却没有指定"option-name"，则以set命令的语法格式打印当前所有的选项。
"-p"：打开特权privileged模式，在这种模式下，不处理"$ENV"和"$BASH_ENV"文件，不继承shell函数，
      忽略shell变量SHELLOPTS、BASHOPTS、CDPATH和GLOBIGNORE。如果启动shell时有效用户（组）不同于实际用户（组），
      且没有设置这个选项，特权模式下的操作会执行，还会设置有效用户为实际用户。如果在shell启动时设置了这个选项，
      有效用户则不会被重置。关闭这个选项，有效用户和组就会被重置为实际用户和组。Privileged
"-t"：读取命令执行后退出。exiT
"-u"：进行参数扩展时，参数（不包括特殊参数"@"和"*"）没有设置就报错，在交互式shell中打印出错信息，
     非交互式shell则退出并返回false。Unset
"-v"：打印读取的shell输入行。 Verbose
"-x"：在shell简单命令、for、case、select或算术for命令扩展后，显示"PS4"的扩展值，随后是命令及扩展后的参数。
"-B"：默认打开，扩展大括号。
"-C"：对于重定向运算符">"、"&>"和"<>"，不覆盖已存在的文件，使用">|"重定向时会覆盖。
"-E"：对于内建命令trap的"ERR"，可以被shell函数、命令替换和子shell中的命令继承，默认是不继承的。
"-H"：打开历史命令"!"，在交互式shell有效。
"-P"：不跟踪符号链接，使用物理地址。
"-T"：trap的"DEBUG"和"RETURN"可以被shell函数、命令替换和子shell中的命令继承，默认是不继承的。
"–"：如果这个选项后面没有其他参数，位置参数将被重置，否则，即使有以"-"开头的参数，位置参数也会被设置为参数arg。
"-"：表示选项结束，让后续参数arg赋值给位置参数，"-x"和"-v"被关闭，如果没有其他的参数arg，位置参数保持不变。
set命令的大部分选项默认是关闭的，减号"-"打开，加号"+"关闭，这些选项可以作为启动shell时的参数，启动参数保存在变量"$-"中。
查看启动参数：

$ echo $-
himBH

未定义变量进行参数扩展时报错：

$ unset foo
$ echo $foo

$ set -u
$ echo $foo
bash: foo: unbound variable
$ set +u
$ echo $foo

打印读取的shell输入行：

$ uname
Linux
$ set -v
$ uname
uname
Linux
$ set +v
set +v
$ uname
Linux

打开与关闭历史命令：

$ set -H
$ uname
Linux
$ !!
uname
Linux
$ set +H
$ uname
Linux
$ !!
!!: command not found

重置位置参数：

$ foo() { echo "foo:" $1 $2; }
hanjunjie@hanjunjie-HP:~$ foo a b
foo: a b
$ foo() { set --; echo "foo:" $1 $2; }
$ foo a b
foo:
}
第22章 shopt
从根本上说，似乎有一系列的bash（和其他shells）建立在sh之上，而添加shopt命令则为设置额外的shell选项提供了一种方式
bash(shopt){
shopt是另一个可以改变shell行为的内建(builtin)命令，格式如下
shopt [-pqsu] [-o] [optname ...]
"-s"：打开/设置optname。
"-u"：关闭/取消optname。
"-p"：以shopt命令的输入格式显示optname的状态。
"-q"：quiet模式，不输出optname及其状态，只是可以通过shopt命令的退出状态来查看某个optname是否打开或关闭。
"-o"：限制optname为内建命令set的选项"-o"支持的那些值。
autocd 如果打开，则使用目录名称作为命令就和把这个目录作为cd命令的参数一样。这个选项只在交互式的shell中使用。
cd_ablevars 如果打开，并且内部命令cd的参数不是个目录，就把这个参数当成值为目录的变量，并进入该目录。
cdspell 如果打开，则自动改正cd命令中对目录名轻微的拼写错误。这些错误包括颠倒的字符，缺少一个字符，或者多一个字符。如果改正了错误，则打印改正后的路径，并继续处理命令。这个选项只
在交互式的she;;中使用。
checkhash 如果打开，Bash会在执行命令前检查散列表中的命令是否存在。如果已经不存在，则进行正常搜索。
checkjobs 如果打开，Bash会在退出交互式的shell前列出所有正在运行或已经停止的作业状态。如果
         有作业正在运行，则延迟退出，直到使用干涉命令再次尝试退出。如果有已经停止的作业，Shell总会延迟退出。
checkwinsize 如果打开，Bash会在执行每个命令以后都检查夨终端天 窗口大小；如果必要，就更新LINES和COLUMNS的值。
cmdhist 如果打开，Bash会试图把多行的命令的所有行都保存在同样的历史文件中。这使得再次编辑多行命令变得容易。
compat31 如果打开，Bash会在处理条件命令的=~时，以第3.1版的方式处理引用。
dirspell 如果打开，Bash会在单词补全时遇到原本不存在的目录后试图改正目录名的拼写。

## http://www.cnblogs.com/f-ck-need-u/p/6995195.html
dotglob 如果打开，Bash会在文件名扩展的结果中包含以"."开头的文件名。
ls  .*  * # 默认情况下，想要匹配目录/path下所有隐藏文件和非隐藏文件，
shopt -s dotglob # 开启dotglob功能，"*"就可以匹配以"."开头的文件：
ls *

execfail 如果打开，则非交互式运行的shell在用内部命令exec不能执行指定的文件时不会退出。
exec失败时，交互式的shell都不会退出
extglob 如果打开，则使用扩展的模式匹配。
extquote 如果打开，则对于双引号之间的"${参数}"，还会处理参数里面的"$"字符串""和"$'字符串'"引用。这个选项默认就是打开的。
failglob 如果打开，则在文件名扩展中如果模式与文件名不匹配就会导致扩展错误。
force_fignore 如果打开，则在单词补全时会忽略shell变量FIGNORE指定的后缀，即使被忽略的单词是唯一可以补全的。这个选项默认就是打开的。

## http://www.cnblogs.com/f-ck-need-u/p/6995195.html
globstar 如果打开，则在文件名扩展中"*"字符会匹配文件以及零个或多个文件夹和子文件夹。如果这个模式后面有个"/"，则只匹配文件夹和子文件夹。
有时想要递归到目录内部，又想要匹配文件名，
ls /path/**/*.css  # 开启后，使用两个星号**就会匹配斜线

gnu_errfmt 如果打开，则用标准的GNU错误信息格式输出shell错误信息。
histappend 如果打开，则当shell退出时，把历史记录添加到HISTFILE变量指定的文件中，而不是覆盖这个文件。
histreedit 如果打开，并且使用了readline，则当历史替换失败时给用户提供重新编辑的机会。
histverify 如果打开，并且使用了readline，则历史替换的结果不会立即传给shell来解释，而是把结果的文本加载到readline的编辑缓存中以便进一步修改。
hostcomplete 如果打开，并且使用了readline，则当补全一个含有"@"的单词时，Bash会试图进行主机名补全。这个选项默认就是打开的。
huponexit 如果打开，则在交互式的登录shell退出时，Bash会向每个作业发送SIGHUP
interactive_comments 允许忽略以"#"开头的单词以及其所在行中所有剩余的单词。这个选项默认就是打开的。
lithist 如果打开，并且打开了cmdhist选项，则保存在历史中的多行命令就带有内部换行符，而不是在必要时使用分号分隔。
login_shell 如果作为登录女奨奥奬奬启动就打开它夨参见奸夶央失奛奂奡女奨的启动奝夬 奰夵夵天。这个选项不可以更改。
mailwarn 如果打开，并且Bash用来检查新邮件的文件在它上次检查过后已经被访问，则打印"邮箱文件已经被读取过"。
no_empty_cmd_completion 如果打开，并且使用了readline，则Bash不会为补全空行而试图搜索PATH。
nocaseglob 如果打开，则Bash在进行文件名扩展时对文件名的大小写不敏感。
nocasematch 如果打开，则Bash在执行case命令或[[条件命令并进行模式匹配时对模式的大小写不敏感。
nullglob 如果打开，则Bash允许不匹配任何文件的模式扩展为空字符串，而不是扩展成自身。
progcomp 如果打开，则启用可编程的补全功能。这个选项默认就是打开的。
promptvars 如果打开，则对提示符按下述方法扩展以后,还要进行参数扩展，命令替换，算术扩展和引用去除。这个选项默认就是打开的。
restricted_shell 如果shell以受限制的模式启动就打开它。这个选项不可以更改。在执行初始化文件时也不会重置它，这使得初始化文件可以检测一个shell是不是受限制的。
shift_verbose 如果打开，则当移动的数目超过位置参数的数目时，内部命令shift会打印一条错误信息。
sourcepath 如果打开，则内部命令source会用PATH会搜索参数中指定文件所在的目录。这个选项默认就是打开的。
xpgecho 如果打开，则内部命令echo默认会扩展转义字符序列。列出选项时，如果所有选项都打开了，则返回零，否则返回非零。设置或重置选项时返回零，除非遇到无效的shell选项。
}
第22章 bind
bash(bind){
在shell中，内建（builtin）命令bind，格式如下：

bind [-m keymap] [-lpsvPSVX]
bind [-m keymap] [-q function] [-u function] [-r keyseq]
bind [-m keymap] -f filename
bind [-m keymap] -x keyseq:shell-command
bind [-m keymap] keyseq:function-name
bind readline-command
bind命令用于显示当前"readline"中键和function的绑定，绑定键序列与function或宏，设置"readline"变量。每个非选项参数都是一个命令，好像来自特殊文件".inputrc"一样。所有的绑定和命令都必须作为一个单独的参数，例如’"\C-x\C-r": re-read-init-file’。

下面解释bind命令中各选项的作用。

"-m keymap"：用参数keymap作为后续绑定的键映射，参数可以是emacs、emacs-standard、emacs-meta、emacs-ctlx、vi、vi-move、vi-command、vi-insert，其中vi和vi-command相同，emacs和emacs-standard相同。
"-l"：列出所有的"readline"的function名称。
"-p"：以可以作为重新输入的格式显示"readline"的function名称和绑定。
"-P"：列出当前"readline"的function名称和绑定。
"-s"：以可以作为重新输入的格式显示"readline"绑定到宏的键序列和输出的字符串。
"-S"：显示"readline"绑定到宏的键序列和输出的字符串。
"-v"：以可以作为重新输入的格式显示"readline"变量名和值。
"-V"：显示当前"readline"变量名和值。
"-f filename"：从文件filename中读取键绑定。
"-q function"：查询与function绑定的键。
"-u function"：解除所有与function绑定的键。
"-r keyseq"：删除当前所有的与键序列keyseq的绑定。
"-x keyseq:shell-command"：每次获取键序列keyseq时都执行shell命令shell-command。执行shell命令时，变量READLINE_LINE保存"readline"缓冲的内容，变量READLINE_POINT保存当前插入点的位置，如果这两个变量被修改，新的变量值会在编辑状态中出现。
"-X"：以可以作为重新输入的格式显示所有的绑定到shell命令的键序列。
例如，对于shell命令uname，把它绑定到按键"u"上。

$ bind -x '"u": uname'
当在shell终端按下"u"键时就会直接执行uname命令。

bind '"\eh":"\C-b"'                # 绑定 ALT+h 为光标左移，同 CTRL+b / <Left>
bind '"\el":"\C-f"'                # 绑定 ALT+l 为光标右移，同 CTRL+f / <Right>
bind '"\ej":"\C-n"'                # 绑定 ALT+j 为下条历史，同 CTRL+n / <Down>
bind '"\ek":"\C-p"'                # 绑定 ALT+k 为上条历史，同 CTRL+p / <Up>
bind '"\eH":"\eb"'                 # 绑定 ALT+H 为光标左移一个单词，同 ALT-b 
bind '"\eL":"\ef"'                 # 绑定 ALT+L 为光标右移一个单词，同 ALT-f 
bind '"\eJ":"\C-a"'                # 绑定 ALT+J 为移动到行首，同 CTRL+a / <Home>
bind '"\eK":"\C-e"'                # 绑定 ALT+K 为移动到行末，同 CTRL+e / <End>
bind '"\e;":"ls -l\n"'             # 绑定 ALT+; 为执行 ls -l 命令 
}
第22章 enable
bash(enable){
在shell中，内建(builtin)命令enable，格式如下：
enable [-a] [-dnps] [-f filename] [name ...]
  enable命令用于启用或禁用shell内建命令。
  在执行shell命令时，先查找是否属于内建命令，然后才在环境变量PATH中查找，
  如果使用enable禁用了这个命令，那么PATH中的同名命令就会执行。
    选项"-n"用于禁用命令，不使用时则启用命令。 Not-enabled
    在支持动态加载的系统上，
    选项"-f"设置从动态库filename中加载新的内建命令，"-d"则用来删除加载的这些命令。 Filename VS Delete
    如果不指定命令name或者只是使用了选项"-p"时，则输出当前启用的内建命令。Print
    选项"-a"显示所有的内建命令，包括启用的和禁止的命令。
    选项"-s"仅输出POSIX内建命令。Special

先来看一下特殊的POSIX内建命令：
enable -s # POSIX内建命令
enable -a # Bash所有内建命令
}
bash(help){
help [-dms] [模式 ...]
    显示内嵌命令的相关信息。
选项：
  -d        输出每个主题的简短描述
  -m        以伪 man 手册的格式显示使用方法
  -s        为每一个匹配 PATTERN 模式的主题仅显示一个用法
}
bash(let){
let 表达式 [表达式]
如果最后一个表达式的值为0，则返回1，否则返回0.
}
bash(local){
local [option] 名称[=值] ..
创建一个以 NAME 为名称的变量，并且将 VALUE 赋值给它。OPTION 选项可以是任何能被 declare 接受的选项。
返回成功除非使用了无效的选项、发生了错误或者 shell 不在执行一个函数。
}
bash(logout){
logout [n]
退出当前的登录shell，向shell的父进程返回状n。
}
第22章 coproc
bash(coproc){
shell中的协作进程coprocess是指一个shell命令的前面添加了coproc关键字的情形，这个命令是在子shell中异步执行的，就好像在命令的末尾使用了后台命令控制符"&"一样，不同的是，协作进程与其父进程间有双向的管道，提供了一种便利的通信途径。
协作进程命令格式如下：

coproc [NAME] command [redirections]

上述命令用于创建一个名为NAME的协作进程，如果没有指定NAME，则使用默认名称COPROC；当命令command是一个简单的命令时，不能指定NAME，因为这个值可能被当作命令的一部分。当coproc命令执行时，shell在当前进程中创建一个名为NAME的数组变量，命令的标准输出同当前进程的文件描述符NAME[0]相连，标准输入同NAME[1]相连，这种管道是在命令中的任何重定向redirections之前就建立了，所以这些文件描述符可以在shell命令和重定向中通过标准的单词扩展而作参数使用，但在子shell中是无效的。协作进程的进程号保存在变量NAME_PID中，我们可以在当前进程使用shell内建命令"wait the_pid"等待协作进程的结束。

下面举例说明：

$ { coproc mycoproc { awk '{print "begin_"$0"_end"; fflush()}'; } >&3; } 3>&1
[1] 19898
$ echo $mycoproc_PID
19898
$ echo ${mycoproc[0]}
62
$ echo ${mycoproc[1]}
58
$ echo abc>& ${mycoproc[1]}
begin_abc_end

例子中，协作进程的名称为mycoproc，使用awk命令从标准输入即父进程的文件描述符mycoproc[1]中读取输入字段，在字段的前、后分别添加"begin_"、"_end"，并打印到标准输出。例子中的符号">&"表示重定向，重定向标准输出和错误输出。
}
第22章 FUNCNAME
# 当前函数. "${FUNCNAME[0]}" 
# 父函数. "${FUNCNAME[1]}" 
# 等等. "${FUNCNAME[2]}" "${FUNCNAME[3]}" 
# 包括父类的所有函数 "${FUNCNAME[@]}"

bash(FUNCNAME){
FUNCNAME要是一个数组呢？看看下面的例子，你就明白了。
#!/bin/bash

function test_func()
{
    echo "Current $FUNCNAME, \$FUNCNAME => (${FUNCNAME[@]})"
    another_func
    echo "Current $FUNCNAME, \$FUNCNAME => (${FUNCNAME[@]})"
}

function another_func()
{
    echo "Current $FUNCNAME, \$FUNCNAME => (${FUNCNAME[@]})"
}

echo "Out of function, \$FUNCNAME => (${FUNCNAME[@]})"
test_func
echo "Out of function, \$FUNCNAME => (${FUNCNAME[@]})"
执行后的结果为：
Out of function, $FUNCNAME => ()
Current test_func, $FUNCNAME => (test_func main)
Current another_func, $FUNCNAME => (another_func test_func main)
Current test_func, $FUNCNAME => (test_func main)
Out of function, $FUNCNAME => ()

    所以，更加准确地说，FUNCNAME是一个数组，但是bash中会将它维护成类似一个堆栈的形式。
与FUNCNAME相似的另外一个比较有用的常量是BASH_SOURCE，同样是一个数组，不过它的第一个元素是当前脚本的名称。
这在source的时候非常有用，因为在被source的脚本中，$0是父脚本的名称，而不是被source的脚本名称。而BASH_SOURCE就可以派上用场了。
# If the script is sourced by another script
if [ -n "$BASH_SOURCE" -a "$BASH_SOURCE" != "$0" ]
then
    do_something
else # Otherwise, run directly in the shell
    do_other
fi

BASH_SOURCE[0] BASH_SOURCE[0] 等价于 BASH_SOURCE， 取得当前执行的shell文件所在的路径及文件名。
}