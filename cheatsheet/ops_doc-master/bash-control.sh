第1章 if语句格式如下：
    #if语句的后面是Shell命令，如果该命令执行成功返回0，则执行then后面的命令。
    if command        
    then
        command
        command
    fi
    #用test命令测试其后面expression的结果，如果为真，则执行then后面的命令。
    if test expression
    then
        command
    fi
    #下面的格式和test expression等同  #这里的$answer变量必须要用双引号扩住，否则判断将失败。
    if [ string/numeric expression ]  if [ "$answer" = y -o "$answer" = Y ] 
    then                              then
        command                           echo "这里的$answer变量必须要用双引号扩住，否则判断将失败."
    fi                                fi
    
    if [ "$name" = "" ]                #双引号就表示空字符串。
    then
        echo "name is null."
    fi
    
    #下面的两种格式也可以用于判断语句的条件表达式，而且它们也是目前比较常用的两种。
    if [[ string expression ]]        if [[ $answer == [yY]* || $answer = Maybe ]] 
    then                              then 
        command                           echo "[[ ]]复合命令操作符允许其中的表达式包含元字符，这里输入以y或Y开头的任意单词，或Maybe都执行then后面的echo."
    fi                                fi

    if (( numeric expression )) if (( $# != 2 ))  #等同于 [ $# -ne 2 ]          
    then                        then
        #let表达式                  echo "Usage: $0 arg1 arg2" 1>&2
    fi                              exit 1 #exit退出值为0-255之间，只有0表示成功。
                                fi
    if (( $1 < 0 || $1 > 30 ))  #等同于 [ $1 -lt 0 -o $1 -gt 30 ]
    then
        echo "arg1 is out of range."
        exit 2
    fi
    if (( $2 <= 20 ))           #等同于 [ $2 -le 20 ]
    then
        echo "arg2 is out of range."
    fi
第2章  if/elif/else
if/elif/else语句的使用方式和if语句极为相似，相信有编程经验的人都不会陌生，这里就不在赘述了，其格式如下：
    if command
    then
        command
    elif command
    then
        command
    else
        command
    fi
    
    if [ $age -lt 0 -o $age -gt 120 ]                #等同于 (( age < 0 || age > 120 ))
    then
        echo "You are so old."
    elif [ $age -ge 0 -a $age -le 12 ]               #等同于 (( age >= 0 && age <= 12 ))
    then
        echo "You are child."
    elif [ $age -ge 13 -a $age -le 19 ]             #等同于 (( age >= 13 && age <= 19 ))
    then
        echo "You are 13--19 years old."
    elif [ $age -ge 20 -a $age -le 29 ]             #等同于 (( age >= 20 && age <= 29 ))
    then
        echo "You are 20--29 years old."
    elif [ $age -ge 30 -a $age -le 39 ]             #等同于 (( age >= 30 && age <= 39 ))
    then
        echo "You are 30--39 years old."
    else
        echo "You are above 40."
    fi

第3章 case语句格式如下：
    case variable in
    value1)
        command
        ;;            #相同于C语言中case语句内的break。
    value2)
        command
        ;;
    *)                #相同于C语言中switch语句内的default
       command
        ;;
    esac
    
    case "$color" in
    [Bb]l??)
        echo "you select blue color."
        ;;
    [Gg]ree*)
        echo "you select green color."
        ;;
    red|orange)
        echo "you select red or orange."
        ;;
    *)
        echo "you select other color."
        ;;
    esac
    echo "Out of case command."
    
第4章 for、while和until
Bash Shell中主要提供了三种循环方式：for、while和until。
    for循环声明格式：
    for variable in word_list
    do
        command
    done
    
    for score in math english physics chemist   #for将循环读取in后面的单词列表，类似于Java的for-each。
    do
        echo "score = $score"
    done
    
    for person in $(cat mylist)                 #for将循环读取cat mylist命令的执行结果。
    do
        echo "person = $person"
    done
    
    for file in test[1-8].sh                        #for将读取test1-test8，后缀为.sh的文件
    do
        if [ -f $file ]                              #判断文件在当前目录是否存在。
        then
            echo "$file exists."
        fi
    done
    
    for name in $*                                  #读取脚本的命令行参数数组，还可以写成for name的简化形式。
    do
        echo "Hi, $name"
    done
    
第5章 while循环声明
while循环声明格式：
    while command  #如果command命令的执行结果为0，或条件判断为真时，执行循环体内的命令。
    do
        command
    done
    
    num=0
    while (( num < 10 ))               #等同于 [ $num -lt 10 ]
    do
        echo -n "$num "
        let num+=1
    done
    
    while [[ -n $go ]]                     #等同于[ -n "$go" ]，如使用该风格，$go需要被双引号括起。
    do
        echo -n How are you.
        read word
        if [[ $word == [Qq] ]]      #等同于[ "$word" = Q -o "$word" = q ]
        then
            echo Bye.
            go=                        #将go变量的值置空。
        fi
    done
    
第6章 until循环声明
until循环声明格式:
    until command                         #其判断条件和while正好相反，即command返回非0，或条件为假时执行循环体内的命令。
    do
        command
    done
    
    until who | grep stephen           #循环体内的命令将被执行，直到stephen登录，即grep命令的返回值为0时才退出循环。
    do
        sleep 1
        echo "Stephen still doesn't login."
    done

    
第7章 shift命令声明格式:shift [n]
    shift命令用来把脚本的位置参数列表向左移动指定的位数(n)，如果shift没有参数，
    则将参数列表向左移动一位。一旦移位发生，被移出列表的参数就被永远删除了。
    通常在while循环中，shift用来读取列表中的参数变量。
    
第8章 break命令声明格式：break [n]
    和C语言不同的是，Shell中break命令携带一个参数，即可以指定退出循环的层数。
    如果没有指定，其行为和C语言一样，即退出最内层循环。如果指定循环的层数，则退出指定层数的循环体。
    如果有3层嵌套循环，其中最外层的为1，中间的为2，最里面的是3。
    
第9章 continue命令声明格式：continue [n]
    和C语言不同的是，Shell中continue命令携带一个参数，即可以跳转到指定层级的循环顶部。如果没有指定，其行为和C语言一样，即跳转到最内层循环的顶部。如果指定循环的层数，则跳转到指定层级循环的顶部。如果有3层嵌套循环，其中最外层的为3，中间的为2，最里面的是1。
    
第10章 I/O重新定向和子Shell：
    文件中的输入可以通过管道重新定向给一个循环，输出也可以通过管道重新定向给一个文件。
    Shell启动一个子Shell来处理I/O重新定向和管道。在循环终止时，循环内部定义的任何变量
    对于脚本的其他部分来说都是不看见的。
    
第11章 IFS和循环：
    Shell的内部域分隔符可以是空格、制表符和换行符。它可以作为命令的分隔符用在例如read、set和for等命令中。
    如果在列表中使用不同的分隔符，用户可以自己定义这个符号。在修改之前将IFS原始符号的值保存在另外一个
    变量中，这样在需要的时候还可以还原。
    
第12章 函数：
    Shell中函数的职能以及优势和C语言或其它开发语言基本相同，只是语法格式上的一些差异。下面是Shell中使用函数的一些基本规则：
    1) 函数在使用前必须定义。
    2) 函数在当前环境下运行，它和调用它的脚本共享变量，并通过位置参量传递参数。而该位置参量将仅限于该函数，不会影响到脚本的其它地方。
    3) 通过local函数可以在函数内建立本地变量，该变量在出了函数的作用域之后将不在有效。
    4) 函数中调用exit，也将退出整个脚本。
    5) 函数中的return命令返回函数中最后一个命令的退出状态或给定的参数值，该参数值的范围是0-256之间。如果没有return命令，函数将返回最后一个Shell的退出值。
    6) 如果函数保存在其它文件中，就必须通过source或dot命令把它们装入当前脚本。
    7) 函数可以递归。
    8) 将函数从Shell中清空需要执行：unset -f function_name。
    9) 将函数输出到子Shell需要执行：export -f function_name。
    10) 可以像捕捉Shell命令的返回值一样获取函数的返回值，如$(function_name)。
    Shell中函数的声明格式如下：
    function_name () { commands; commands; }
    function function_name { commands; commands; }
    function function_name () { commands; commands; }
    
    function increment() {              #定义函数increment。
        local sum                       #定义本地变量sum。
        let "sum=$1+1"    
        return $sum                     #返回值是sum的值。
    }
    echo -n "The num is "
    increment 5                         #increment函数调用。
    echo $?                             #输出increment函数的返回值。
    
第13章 陷阱信号(trap)：
    在Shell程序运行的时候，可能收到各种信号，有的来自于操作系统，有的来自于键盘，而该Shell在收到信号后就立刻终止运行。但是在有些时候，你可能并不希望在信号到达时，程序就立刻停止运行并退出。而是他能希望忽略这个信号而一直在运行，或者在退出前作一些清除操作。trap命令就允许你控制你的程序在收到信号以后的行为。
    其格式如下：
    trap 'command; command' signal-number
    trap 'command; command' signal-name
    trap signal-number  
    trap signal-name
    后面的两种形式主要用于信号复位，即恢复处理该信号的缺省行为。还需要说明的是，如果trap后面的命令是使用单引号括起来的，那么该命令只有在捕获到指定信号时才被执行。如果是双引号，则是在trap设置时就可以执行变量和命令替换了。
    下面是系统给出的信号数字和信号名称的对照表：
    1)SIGHUP 2)SIGINT 3)SIGQUIT 4)SIGILL 5)SIGTRAP 6)SIGABRT 7)SIGBUS 8)SIGFPE
    9)SIGKILL 10) SIGUSR1 11)SIGEGV 12)SIGUSR2 13)SIGPIPE 14)SIGALRM 15)SIGTERM 17)SIGCHLD
    18)SIGCONT 19)SIGSTOP ... ...
    
    trap 'rm tmp*;exit 1' 1 2 15  #该命令表示在收到信号1、2和15时，该脚本将先执行rm tmp*，然后exit 1退出脚本。
    trap 2                        #当收到信号2时，将恢复为以前的动作，即退出。
    trap " " 1 2                  #当收到信号1和2时，将忽略这两个信号。
    trap -                        #表示恢复所有信号处理的原始值。
    trap 'trap 2' 2               #在第一次收到信号2时，执行trap 2，这时将信号2的处理恢复为缺省模式。在收到信号2时，Shell程序退出。
    cat > test2.sh
    trap 'echo "Control+C will not terminate $0."' 2   #捕获信号2，即在键盘上按CTRL+C。
    trap 'echo "Control+\ will not terminate $0."' 3   #捕获信号3，即在键盘上按CTRL+\。
    echo "Enter stop to quit shell."
    while true                                                        #无限循环。
    do
        echo -n "Go Go...."
        read
        if [[ $REPLY == [Ss]top ]]                            #直到输入stop或Stop才退出循环和脚本。
       then
            break
        fi
    done
    
第14章 用getopts处理命令行选项：
    这里的getopts命令和C语言中的getopt几乎是一致的，因为脚本的位置参量在有些时候是失效的，如ls -lrt等。这时候-ltr都会被保存在$1中，而我们实际需要的则是三个展开的选项，即-l、-r和-t。见如下带有getopts的示例脚本：
    
    while getopts xyz: arguments 2>/dev/null #z选项后面的冒号用于提示getopts，z选项后面必须有一个参数。
    do
        case $arguments in
        x) echo "you entered -x as an option." ;;
        y) echo "you entered -y as an option." ;;
        z) echo "you entered -z as an option."  #z的后面会紧跟一个参数，该参数保存在内置变量OPTARG中。
            echo "\$OPTARG is $OPTARG.";
           ;;
        \?) echo "Usage opts4 [-xy] [-z argument]"
            exit 1 ;;
        esac
    done
    echo "The number of arguments passed was $(( $OPTIND - 1 ))" #OPTIND保存一下将被处理的选项的位置，他是永远比实际命令行参数多1的数。
    
第15章 eval命令与命令行解析：
    eval命令可以对命令行求值，做Shell替换，并执行命令行，通常在普通命令行解析不能满足要求时使用。
    /> set a b c d
    /> echo The last argument is \$$#
    The last argument is $4
    /> eval echo The last argument is \$$#    #eval命令先进行了变量替换，之后再执行echo命令。
    The last argument is d
    