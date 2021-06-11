bash_l_link(){ cat - <<'EOF'
https://www.computerhope.com/unix.htm              # manual
https://wiki.bash-hackers.org/                     # Bash-hackers wiki
https://wiki.bash-hackers.org/syntax/shellvars     # Shell vars
https://learnxinyminutes.com/docs/bash/            # Learn X in Y minutes
http://mywiki.wooledge.org/BashGuide               # BashGuide
https://www.shellcheck.net/                        # ShellCheck
https://github.com/alebcay/awesome-shell/blob/master/README_ZH-CN.md # 去发现
http://mywiki.wooledge.org/CategoryShell
http://www.netkiller.cn/shell/bash/variable.html
https://github.com/truist/ubulk                    # trap and shunit2
EOF
}

cat - <<'EOF'
[语言特性] 只要有选择就有难度,也就存在哲学.
    bash_i_expand_word_splitting        单词拆分定义是什么? 如何使用? 怎样做到恰如其分的使用?    -- 实现string和多个word之间转换
    bash_i_expand_brace                 大括号扩展定义是什么? 如何使用? 怎样做到恰如其分的使用?  -- 使用形式描述,避免形式重复
    bash_i_expand_tilde                 节制使用
    bash_i_expand_parameter             返回值时使用grep -q; 字符串时使用 glob形式的 参数扩展.
    bash_i_expand_command_substitution  返回值时使用grep -q; 字符串时使用 var=$(command)
    bash_i_expand_process_substitution   < (command) 或 > (command) 是命令组的流管理模式
    bash_i_expand_pathname_expansion    路径名扩展
[shell命令]      
    bash_i_command                    选择合适的命令组织方式, 返回值 输入输出 同步异步是选择的关注点. -- 本质上脚本即命令的集合                          
    bash_i_command_simple             bash_t_command_simple    实例即说明
    bash_i_command_pipelines          bash_t_command_pipelines 实例即说明
    bash_i_command_lists              bash_t_command_lists     实例即说明
    bash_i_command_compound           bash_t_command_compound  实例即说明  
[内建命令] compgen -b 内建命令 compgen -k 关键字
    bash_k_builtin                    在数据处理级别上,内建命令已经足够. 在系统级别上/sys/ /proc提供了一定支持,更多的依赖外部命令支持
[字符串处理]
    bash_p_string_substitution
    bash_i_string                         bash_t_string  bash_t_string_substr
    bash_t_string_substr | substr2 | psubstr | psubstr2 | replace | replace2 | default
[数组处理]
    bash_t_array                          bash_p_array_from
    bash_t_array_create |  assign | index | length | reference | append | remove | loop
[重定向]
    bash_i_redirection                   为数据驱动编程提供资源,同时,既提供了数据输出也为管理数据输出造成了困难.
    bash_i_expand_redirect               bash_t_builtin_exec
    bash_i_redirection                   bash_t_builtin_redirect
    bash_ii_redirection                  bash_t_here_commend | document | string
    bash_t_redirection
[各种括号]
    bash_p_feature
    bash_p_brace
    bash_p_variable
    bash_p_operator
                                        # 通过抽象数据模型(表驱动测试)，达到简化数据处理过程。   shunit2;
关于如何写脚本，当前有几个模板可以借鉴: # 节制的使用语言特性，达到降低代码的复杂度
1. bats-master/libexec/bats  [bash template]
2. shunit2/test_runner       [sh template]
3. bash/bash-script-template-stable/script.sh | build.sh | source.sh | template.sh [bash template]
4. bash/bash-script-template-stable/gpio_array_test.sh | gpio_test.sh [self template]
5. bash/ubulk/ubulk-build 和 test(shunit2)
哲学: 学习语言就是学习语言特性, bash语言特性有 1.命令组合形式 2.返回值+输入输出重定向; 3.括号扩展 4.内建命令。bash_p_feature
  使用工具认知自己，构建工具认识世界，又使用工具认识自己，再构建工具认识世界。在使用和构建工具过程中提高认识。bash_p_tool
  规模编码的核心是控制复杂度，变量可读性是复杂度的核心组成部分，通过大小写下划线修饰变量可以提高变量可读性。  bash_p_code
  将代码控制逻辑转换成数据配置逻辑,以达到数据(表)驱动编程目的,从而使得代码容易理解和维护.                     bash_p_data_driven
EOF
bash_p_feature(){ cat - <<'EOF'
---- 学习语言就是学习语言特性 ---- 
1.bash_i_command       命令的输入输出和返回值推动bash一步一步的执行，函数封装命令，函数是命令特例      外在形式是命令,内在实现是数据
2.bash_p_string        未初始化,初始化为空,初始化为空白字符,和初始化为非空白字符；                     存在形式
                       "${string}" -- (参数展开、命令替换和算术展开) '${string}' $'string' 和 $string  输出形式
2.bash_i_variable_string 大括号扩展和模式匹配是其灵魂，极致的强调输入输出，也极致的贬低返回值
  bash_p_string_default  bash_p_string_condition提供多种条件字符串处理形式，但是default形式 -> 提倡使用
  bash_p_string_psubstr  用在路径处理，参数解析和字符串处理，bash_i_string_substr使用数值定位切割字符串 -> 避免使用
3.bash_t_array         from构建，create初始化，assign赋值，index索引，length长度，reference引用，append追加，remove删除 loop遍历。
4.bash_i_expand        扩展使语言复杂又强大，使语言有扩展前和扩展后两种形式。 扩展是在不使用 "${variable}" 时实现的。
5.bash_i_redirection   输出重定向是 sh 语言的一部分，不是命令的一部分，所以输出重定向可以在命令开头也可以在结尾。
                       设计脚本就是规范化输入输出和返回值。重定向是输入输出设计的提升。
6.bash_p_brace         在shell中括号是命令，也是命令组。深入理解达到恰当使用。
7.bash_p_variable_define bash和Makefile很强调执行环境的外部性，以致变量定义都存在复杂的逻辑。
---- 恰如其分的使用bash提供的语言特性 ----
什么时候应当避免单词拆分(如何避免单词拆分的功能); 什么时候进行单词拆分(如何使用单词拆分的功能)
什么时候避免使用大括号扩展(如何避免大括号扩展功能)，什么时候使用大括号扩展(如何使用大括号扩展功能); 
进一步, 波浪号扩展功能的避免和使用，
        shell参数扩展的避免和使用，
        命令替换的避免和使用,
        进程替换的避免和使用,
        文件名扩展的避免和使用。        
在使用这些特性前:    如何定义                           如何使用                            恰如其分的使用
什么是单词拆分?      bash_i_expand_word_splitting       bash_t_expand_word_splitting        bash_p_expand_word_splitting  
什么是大括号扩展?    bash_i_expand_brace                bash_t_expand_brace                 bash_p_expand_brace           
什么是波浪号扩展？   bash_i_expand_tilde                                                
什么是shell参数扩展? bash_i_expand_parameter            bash_t_expand_parameter             bash_p_expand_parameter           
什么是命令替换?      bash_i_expand_command_substitution bash_t_expand_command_substitution  bash_p_expand_command_substitution
什么是进程替换?      bash_i_expand_process_substitution bash_t_expand_process_substitution  
什么是文件名扩展?    bash_i_expand_pathname_expansion         
如何使用glob         bash_i_expand_glob                 # pattern matching, pattern expansion, filename expansion
---- bash边解释(特性扩展|替换)边执行(命令调用) ----
哲学: 爱使它们结合;恨使它们分离. bash 编程就是需要考虑: 如何用爱使它们结合，使得用恰如其份的结合方式实现恰如其份的功能
      bash各种扩展前是一种语言实现，bash各种扩展后是一种语言实现。 扩展前使用语言特性简化描述，扩展后体现语言特性的灵活性。
      语言特性使得bash更灵活，也使得bash更复杂，bash编程使用语言特性写于简单的程序。 

扩展功能可是视作bash提供的API。
  扩展前的世界是现实的世界，扩展后的世界是理想的世界。设计的目的是: 让现实的世界更可读，让理想的世界更高效。哲学就是两个世界的折中。
      一切皆是字符串；一切美学都源自字符串；被引号包围的字符串和不被引号包围的字符串使用起来是不一样的，
被单引号包围的字符串和被双引号包围起来的字符串也是不一样的。
EOF
}

bash_p_tool(){ cat - <<'EOF'
代码覆盖测试工具Kcov简介及使用
https://github.com/SimonKagstrom/kcov

shUnit2--shell脚本单元测试框架
# makeshunit2

shell脚本的格式化    shfmt
shell脚本的静态检查  shellcheck
shell脚本的单元测试  shunit2(sh) bats(bash)
shell脚本的编码能力  makebash

# shunit2(sh) bats(bash) bash_unit,ShellSpec, shpec
testing-in-bash-master 

bashdb example.sh                   # debug shell script 
bash -o noexec ~/.bash_history      # verify shell script syntax 
bash --noprofile --norc -o xtrace   # test trace shell

# Code coverage tool for Bash 
gem install bashcov
Usage: bashcov [options] [--] <command> [options]
Examples:
    bashcov ./script.sh
    bashcov --skip-uncovered ./script.sh
    bashcov -- ./script.sh --some --flags
    bashcov --skip-uncovered -- ./script.sh --some --flags
EOF
}

bash_p_background(){ cat - <<'EOF'
command &>/dev/null &
disown 

nohup command &>/dev/null &
EOF
}

bash_p_code(){ cat - <<'EOF'
bash -x hello.sh

https://github.com/kward/shunit2/wiki/Coding-standards
Type                             |  Sample
-------------------------------------------------------------
global public constant           |  SHUNIT_TRUE
global private constant          |  __SHUNIT_SHELL_FLAGS
global public variable           |  not used
global private variable          |  __shunit_someVariable
global macro                     |  _SHUNIT_SOME_MACRO_
public function                  |  assertEquals
public function, local variable  |  shunit_someVariable_
private function                 |  _shunit_someFunction
private function, local variable |  _shunit_someVariable_
EOF
}

bash_p_data_driven(){ cat - <<'EOF'
@ [shunit2]
1. shunit2 使用 << 和 <                 实现数据驱动测试
表驱动测试是 输入参数和输出参数 之间的映射关系,所以表驱动测试天然要求使用 while read方式实现数据驱动.

@ [bash_t_builtin_for] -> 使用for in 实现字符串拆分成单词, 视为数据(表)驱动编程的一种实现.
2. for in {1..20}; do cmd; done         大括号扩展配以for in循环
3. for in $@ ; do cmd; done             单词分拆        配以for in循环
   for testcase in ${TEST_CASES}; do    单词分拆        配以for in循环
4. for in ./* ; do cmd; done            本地路径匹配    配以for in循环
   for file in /proc/[0-9]* ; do echo ${file}; done 本地路径匹配    配以for in循环
   for f in "${stdoutF}" "${stderrF}"; do           选项枚举        配以for in循环

@ [bash_p_expand_word_splitting] -> 使用 read+IFS 实现字符串拆分成单词, 视为数据(表)驱动编程的另一种实现.
while read实现文件拆分成行,      配合以 < 输入重定向, << here document < <() 进程替换转输入
while read实现行数据拆分成单词,  配合以 < 输入重定向, << here document < <() 进程替换转输入  <<< here string
while read实现行单词拆分成字母,  配合以 < 输入重定向, << here document < <() 进程替换转输入  <<< here string

如果for的拆分是string到word级别的,那么read的拆分就是从line(string)到word级别的.
for和单词拆分,glob模式,大括号扩展,数组遍历具有关联关系; read和输入重定向, here document, 进程替换和单词分割具有关联关系.
# 不同的数据形式造成了for 和 read 处理数据之间的差别.


1. 单词拆分; 2, 大括号扩展 3. glob模式, 4. 数组取值  -> 数据驱动编程的基本方式
1. 输入重定向 2, here document -> 数据驱动编程的高级方式

@ [bash_t_command_pipelines]
管道是数据驱动编程的另一种表现形式; 以grep -q 和 && || 为形式的流过滤编程, 视为数据驱动编程的另一种实现.

@ [bash_t_command_lists]
命令列表也是数据驱动编程的另一种形式; 以 [] &&或|| 为形式的返回值编程, 视为数据驱动编程的另一种实现.
===============================================================================
防御性编程


EOF
}
bash_p_tune(){ cat - <<'EOF'
Global variables
    Avoid global vars
    Always UPPER_CASE naming
    Readonly declaration
    Globals that can be always use in any program :

readonly PROGNAME=$(basename $0)
readonly PROGDIR=$(readlink -m $(dirname $0))
readonly ARGS="$@"

Other variables
    All variables should be local (they can only be used in functions)
    Always lowercase naming
    Self documenting parameters
fn_example() {
    local explicit_name = $1 ;
    local expName = $1 ;
}

    Usually use i for loop, so it is very important to declare it as local
Main()
    Use always a main() function
    The only global command in the code is : main or main "$@"
    If script is also usable as library, call it using [[ "$0" == "$BASH_SOURCE" ]] && main "$@"

Everything is a function
    Only the main() function and global declarations are run globaly
    Short code portion can be functions
    Define functions as myfunc() { ... }, not function myfun {...}

Debugging
    Run with -x flag : bash -x prog.sh
    Debug just a small section of code using set -x and set +x
    Printing function name and its arguments echo $FUNCNAME $@

Each line of code does just one thing
    Break expression with back slash \
    Use symbols at the start of the indented line
print_dir_if_not_empty() {
    local dir=$1
    is_empty $dir \
        && echo "dir is empty" \
        || echo "dir=$dir"
}
EOF
}

bash_p_script(){ cat - <<'EOL'
bats: 有 version usage help, 当请求version usage help的时候，输出到标准输出+返回值0；否则，输出到错误输出+返回值1
version() {                                                                 # &版本帮助
  echo "Bats 0.4.0"
}

usage() {
  version
  echo "Usage: bats [-c] [-p | -t] <test> [<test> ...]"
}

help() {
  usage
  echo
  echo "  <test> is the path to a Bats test file, or the path to a directory"
  echo "  containing Bats test files."
  echo
  echo "  -c, --count    Count the number of test cases without running any tests"
  echo "  -h, --help     Display this help message"
  echo "  -p, --pretty   Show results in pretty format (default for terminals)"
  echo "  -t, --tap      Show results in TAP format"
  echo "  -v, --version  Display the version number"
  echo
  echo "  For more information, see https://github.com/sstephenson/bats"
  echo
}

test_runner: 有 usage，没有version help。当请求usage的时候，输出到标准输出+返回值0；否则，输出到标准输出+返回值1
runner_usage() {
  echo "usage: ${RUNNER_ARGV0} [-e key=val ...] [-s shell(s)] [-t test(s)]"
}

mksdcard.sh: 有 help，没有version usage。都输出到标准输出+返回值0
help() {

bn=`basename $0`
cat << EOF
usage $bn <option> device_node

options:
  -h				displays this help message
  -s				only get partition size
  -np 				not partition.
  -f 				flash android image.
EOF

}

bashunit.bash usage实现了help的功能，
usage() {
    echo "Usage: <testscript> [options...]"
    echo
    echo "Options:"
    echo "  -v, --verbose   Print expected and provided values"
    echo "  -s, --summary   Only print summary omitting individual test results"
    echo "  -q, --quiet     Do not print anything to standard output"
    echo "  -l, --lineshow  Show failing or skipped line after line number"
    echo "  -f, --failed    Print only individual failed test results"
    echo "  -h, --help      Show usage screen"
}

IFS=$'\n\t'
---- script ---- 
1. usage
2. debug
3. set -euo pipefail # http://redsymbol.net/articles/unofficial-bash-strict-mode/
4. signal(trap err)
# cd bash/bash-script-template-stable/
EOL
}

bash_p_debug(){ cat - <<'EOF'
===============================================================================
${BASH_SOURCE}
${LINENO}
${FUNCNAME[0]}

# flags
bash -n SCRIPT.sh     # don't run commands; check for syntax errors only
set -o noexec         # alternative option set inside script

bash -v SCRIPT.sh     # echo commands before running them
set -o verbose        # alternative option set inside script

bash -x SCRIPT.sh     # echo commands after command-line processing
set -o xtrace         # alternative option set inside script
===============================================================================
redirect xtrace to file
#!/usr/bin/env bash
exec 2>>debug.log
set -x

debugger
===============================================================================
echo "LINENO: $LINENO"
trap 'echo "VARIABLE-TRACE> \$variable = \"$variable\""' DEBUG  # prints value of $variable after every command
variable=29; line=$LINENO
echo "  Just initialized \$variable to $variable in line number $line."
let "variable *= 3"; line=$LINENO
echo "  Just multiplied \$variable by 3 in line number $line."
exit 0

EOF
}


bash_p_named(){ cat - <<'EOF'
#!/bin/bash -li
-l 以登录bash方式执行
-i 以交互bash方式执行

bash 兼容sh，使得sh脚本能使用bash执行，bash扩展了sh，使得bash脚本不能保证被sh执行。
bash 的设计规范是 'POSIX1003.1标准的Shell和工具部分'
bash 的表示方法，有些来自ksh，有些来自csh，还有些来自C语言。说明: 脚本语言的扩展来自借鉴其他语言表示方法。

bash 提供用户使用字符串文本与计算机(底层为字节)交互的方式：'字符串是输入也是输出'。还有返回状态码。
bash 是一个能执行各种命令的'宏处理器'。'宏处理器'是指扩展文本和符号以创建更大的表达式的能力。
bash 是'命令解释器'，提供了一个用户接口来执行各种各样的GNU工具命令。
bash 是'编程语言'，使得实用工具能够被组织起来。可创建包含若干命令的文件，而文件本身又可以作为命令。
bash 有'内部命令'：实现的外部工具不方便或者不可能完成的。cd break continue exec 不能通过外部命令实现。
     history getopts kill pwd内部命令，可以在外部命令实现，但作为内部命令更便于使用。
bash 为'交互式设计'的功能：作业控制，命令行编辑，命令行历史和别名
     为'非交互式'执行时，shell从一个文件中读取命令执行
bash 可以'同步或者异步'的方式执行GUN命令。
     如果是'同步'的方式，shell会等待命令返回才能接收新的输入；
     '异步'执行的命令可以和shell并行执行，shell可以同时接收新的命令。

退出状态
1. 返回状态总是介于0和255之间，
2. 对成功执行的命令，它的退出状态是零；
3. 非零的退出状态表示失败了
4. 如果命令接收到一个值为N的关键信号而退出，Bash就会把128+N作为它的退出状态。
5. 如果命令找到但却不是可执行的，就返回状态126。
6. 如果命令没有找到，用来执行它的子进程就会返回状态127
7. 如果使用不正确，所有的内部命令返回状态为2
EOF
}

bash_p_brace(){ cat - <<'EOF'
${}   {}        参数扩展   大括号扩展|命令组|函数
$[]   []        数值计算   test判断
$()   ()        命令替换   命令组 (cmd) | 用于初始化数组 array=(a,b,c)
$(()) (())      整数扩展   ((算术表达式))
      [[]]                  bash 支持 pattern 和 regular 匹配命令
>     >(list)   输出重定向  进程替换
<     <(list)   输入重定向  进程替换
      >{list}               命令组输入
      {list}>               命令组输出
      
      
<<<(here string)
<<(here document) 

命令队列: ;、&、&&、||

[[ $a == z* ]]   # True if $a starts with an "z" (pattern matching).
[[ $a == "z*" ]] # True if $a is equal to z* (literal matching).

[ $a == z* ]     # File globbing and word splitting take place.
[ "$a" == "z*" ] # True if $a is equal to z* (literal matching).

()                            # 命令组合表达式 (表达式)
=$()                          # 命令替换       $(命令)
=()                           # 数组赋值       ARRAY=(one two three four)
>(命令列表) <(命令列表)       # 进程替换       如果系统支持命名管道(fifo)或能够以"/dev/fd"方式来命名打开的文件，则也就支持进程替换。
    进程替换可以视为命名管道的一端，其必然需要bash或者cat等命令关联到另一端上，
实现数据在管道内流动。进程替换可以视为精简版的有关管道实现方式。
$(())                         # 计算扩展       $((表达式))
for (( exp1; exp2; exp3 ));   # for((表达式1;表达式2;表达式3));do命令块;done
func()                        # 函数定义       func(){ echo "hello world" }
}
keyword(大括号){
{}           # 命令组合表达式 {表达式}
a{d,c,b}e    # 大括号扩展 ade ace abe
{x..y[..增量]} # 大括号扩展 
}
EOF
}

bash_t_brace(){ cat - <<'EOF'
1. 单小括号 ()
1.1 命令组。括号中的命令将会新开一个子shell顺序执行，所以括号中的变量不能够被脚本余下的部分使用。
    括号中多个命令之间用分号隔开，最后一个命令可以没有分号，各命令和括号之间不必有空格。
1.2 命令替换。等同于cmd，shell扫描一遍命令行，发现了结构，便将(cmd)中的cmd执行一次，得到其标准输出，再将此输出放到原来命令。
1.3 用于初始化数组。如：array=(a b c d)
2. 双小括号 (( ))
2.1 整数扩展。这种扩展计算是整数型的计算，不支持浮点型。
((exp))结构扩展并计算一个算术表达式的值，如果表达式的结果为0，那么返回的退出状态码为1，或者 是"假"，而一个非零值的表达式所返回的退出状态码将为0，或者是"true"。
2.2 只要括号中的运算符、表达式符合C语言运算规则，都可用在((16#5f)) 结果为95 (16进位转十进制)
2.3 单纯用 (( )) 也可重定义变量值，比如 a=5; ((a++)) 可将 $a 重定义为6
2.4 常用于算术运算比较，双括号中的变量可以不使用符号前缀, for((i=0;i<5;i++)) ; if ((i<5))如果不使用双括号, 则为if [ $i -lt 5 ]。
3. 单中括号 []
3.1 bash 的内部命令，[和test是等同的。
3.2 Test和[]中可用的比较运算符只有==和!=，两者都是用于字符串比较的，不可用于整数比较，整数比较只能使用-eq，-gt这种形式。
3.3 字符范围。用作正则表达式的一部分，描述一个匹配的字符范围。作为test用途的中括号内不能使用正则。
3.4 在一个array 结构的上下文中，中括号用来引用数组中每个元素的编号。
4. 双中括号[[ ]]
4.1 [[是 bash 程序语言的关键字。并不是一个命令，[[ ]] 结构比[ ]结构更加通用。在[[和]]之间所有的字符都不会发生文件名扩展或者单词分割，但是会发生参数扩展和命令替换。
4.2 支持字符串的模式匹配，使用=~操作符时甚至支持shell的正则表达式。字符串比较时可以把右边的作为一个模式，而不仅仅是一个字符串，比如[[ hello == hell? ]]，结果为真。[[ ]] 中匹配字符串或通配符，不需要引号。
4.3 使用[[ ... ]]条件判断结构，而不是[ ... ]，能够防止脚本中的许多逻辑错误。比如，&&、||、<和> 操作符能够正常存在于[[ ]]条件判断结构中，但是如果出现在[ ]结构中的话，会报错。
4.4 bash把双中括号中的表达式看作一个单独的元素，并返回一个退出状态码。
5. 大括号、花括号 {}
5.1 大括号拓展。
5.2 代码块，又被称为内部组，这个结构事实上创建了一个匿名函数 。括号内的命令间用分号隔开，最后一个也必须有分号。
5.3 ${var:-string},${var:+string},${var:=string},${var:?string}
5.4 ${var%pattern},${var%%pattern},${var#pattern},${var##pattern}
5.5 ${var:num},${var:num1:num2},${var/pattern/pattern},${var//pattern/pattern}
6. 符号$后的括号
6.1 ${a} 变量a的值, 在不引起歧义的情况下可以省略大括号。
6.2 $(cmd) 命令替换，和`cmd`效果相同，结果为shell命令cmd的输，过某些Shell版本不支持$()形式的命令替换, 如tcsh。
6.3 $((expression)) 和`exprexpression`效果相同, 计算数学表达式exp的数值, 其中exp只要符合C语言的运算规则即可, 甚至三目运算符和逻辑表达式都可以计算。
7. 多条命令执行
7.1 单小括号，(cmd1;cmd2;cmd3) 新开一个子shell顺序执行命令cmd1,cmd2,cmd3, 各命令之间用分号隔开, 最后一个命令后可以没有分号。
7.2 单大括号，{ cmd1;cmd2;cmd3;} 在当前shell顺序执行命令cmd1,cmd2,cmd3, 各命令之间用分号隔开, 最后一个命令后必须有分号, 第一条命令和左括号之间必须用空格隔开。
EOF
}

bash_p_shortcuts(){ cat - <<'EOF'
Ctrl + a    move to the beginning of the line
Ctrl + e    move to the end of the line
Ctrl + k    Kill the text from the current cursor position to the end of the line.
Ctrl + u    Kill the text from the current cursor position to the beginning of the line
Ctrl + w    Kill the word behind the current cursor position
Alt + b     move backward one word
Alt + f     move forward one word
Ctrl + Alt + e shell expand line

Ctrl + r    search the history backwards
Ctrl + p    previous command in history
Ctrl + n    next command in history
Ctrl + g    quit history searching mode

Ctrl + c    Stop the current job
Ctrl + z    Suspend the current job (send a SIGTSTP signal)
EOF
}
bash_p_builtin_key(){ cat - <<'EOF'
compgen -b    # list built-ins
compgen -k    # list keywords

    built-in的行为其实就像外部命令一样：它们对应于一个正在执行的动作，其参数经过直接的变量扩展和分词以及globbing。
内建函数可以修改shell的内部状态！关键字是允许复杂行为的东西！它是shell语法的一部分。
# 关键字 key
string_with_spaces='some spaces here'
if [[ -n $string_with_spaces ]]; then echo "The string is non-empty" fi

# 内建命令 builtin
string_with_spaces='some spaces here'
if [ -n $string_with_spaces ]; then echo "The string is non-empty" fi
# bash: [: too many arguments
EOF
}

bash_k_shebang(){ cat - <<'EOF'
ELF 和 #! 是内核可以识别的两种可执行文件头。
#!/usr/bin/env bash
#!/bin/bash
EOF
}

bash_t_err_trap(){ cat - <<'EOF'
set -euo pipefail # Strict mode
trap "echo 'error: script failed: see failed command above'" ERR

trap 'echo Error at about $LINENO' ERR
或
traperr() {
  echo "ERROR: ${BASH_SOURCE[1]} at about ${BASH_LINENO[0]}"
}

set -o errtrace
trap traperr ERR

# Options
set -o noclobber  # Avoid overlay files (echo "hi" > foo)
set -o errexit    # Used to exit upon error, avoiding cascading errors
set -o pipefail   # Unveils hidden failures
set -o nounset    # Exposes unset variables

# Glob options
shopt -s nullglob    # Non-matching globs are removed  ('*.foo' => '')
shopt -s failglob    # Non-matching globs throw errors
shopt -s nocaseglob  # Case insensitive globs
shopt -s dotglob     # Wildcards match dotfiles ("*.sh" => ".foo.sh")
shopt -s globstar    # Allow ** for recursive matches ('lib/**/*.rb' => 'lib/a/b/c.rb')
EOF
}


bash_k_builtin(){ cat - <<'EOF'
---- 内建命令 ----> enable -a
参见: 内置命令: bash_k_builtin_enable 和 help 
内部命令    在shell内部而不是文件系统中由某个可执行文件实现的一些命令
0 enable [-a] [-dnps] [-f filename] [name ...] bash_builtin_enable help enable
1 :[参数]                              bash_builtin_null           help :
2 . 文件名 [参数]                      bash_builtin_source         help .
3  break [n]                           bash_builtin_break          help break
4 cd [-L|-P] [目录]                                                help cd
5 continue [n]                         bash_builtin_continue       help continue
6 eval [参数表]                        bash_builtin_eval           help eval
7 exec [-cl] [-a 名称] [命令[参数表]]  bash_builtin_exec           help exec
8 exit [n]                             bash_builtin_exit           help exit
9 export [-fn] [-p] [名称[=值]]        bash_t_export               help export
10 getopts 选项字符串 名称[参数表]     bash_builtin_getopts        help getopts
11 hash [-r] [-p文件名] [-dtl] [名称]  bash_builtin_hash           help hash
12 pwd [-LP]                           bash_builtin_pwd            help pwd
13 readonly [-aApf] [名称[=值]]        bash_builtin_readonly       help readonly
14 return [n]                          bash_builtin_return         help return
15 shift [n]                           bash_builtin_shift          help shift
16 test和[                             bash_builtin_test           help test 
17 times                               bash_builtin_times          help times
18 trap [-lp] [参数] [信号指示...]     bash_builtin_trap           help trap
19 umask [-p] [-S] [模式]              bash_builtin_umask          help umask
20 unset [-fv] [名称]                  bash_builtin_set            help set

disown [PID|JID]

---- 内建命令特性 ----
1. 内置命令都接受以-开始的选项并且以--表示选项的结束。
2. true false test内置命令不接受任何参数同时也不会对--特殊对待
3. exit、logout、break、continue、let和shift命令接收-开始的参数，但是不需要--来表示选项的结束。
4. : 的任何参数都会被忽略掉，同时直接返回 0 

---- 特殊内置命令 -----> enable -s
    因为历史的原因，POSIX标准将一些'内置命令'归类为'特殊内置命令'。
当Bash以POSIX模式运行时，'特殊内置命令'和其他的命令有以下三方面的不同：
1. 在进行命令搜索时，'特殊内置命令'先于shell函数
2. 如果一个特殊内置命令返回一个表示错误的状态码，则非交互式shell退出
3. 命令前的变量赋值语句所创建的变量在命令结束之后仍然有效
当Bash没有在POSIX模式运行时，这些内置命令的行为和其他内置命令一样
'POSIX特殊内置命令' 如下：
break :(冒号) .(点) continue eval exec exit export readonly return set shift trap unset
EOF
}

bash_pp_language(){ cat - <<'EOF'
---- 恰如其分的使用bash提供的内建特性 ----
如何使用 '[[]]' 的模式匹配和正则表达式匹配? 
如何使用 <<<(here string) 和<<(here document) 和 输入输出重定向功能；以及命名管道的功能；进程替换 ? 
区分 let 和 expr 两种表达方式。 let的参数是表达式，而expr的参数是表达式中的变量和操作符 ?
export local typeset declare alias的参数表达形式，每个赋值语句作为一个参数看待?

# Note that A && B || C is not if-then-else. C may run when A is true.
command1 && success || failure 根据前驱命令状态决定后继命令执行; 
                               将前驱命令返回状态，转换成成功和失败的信息输出。(将返回值状态转换成字符串输出)
[ $? = 0 ] && success || failure 程序的输出内容和程序的返回状态分离，程序的返回状态决定后续命令的执行。
                                 字符串分析和返回值双重分析。

字符串有: 未初始化,初始化为空,初始化为空白字符,和初始化为非空白字符四种状态。
字符串有: "${string}" -- (参数展开、命令替换和算术展开) '${string}' $'string' 和 $string 四种形式。
          常用"${string}" ${!var}间接引用和eval
IFS对单词拆分、read命令的影响。
变量和函数的动态作用域范围: 变量引用是以变量被解引用运行时所在作用域进行解引用，而不是以变量定义时所在作用域进行解引用。
通过printf "%s\n" * ; printf "%s\n" */ ; printf "%s\n" *.{gif,png,jpg} 

set -euo pipefail 以及 trap 信号捕获的使用。又何时 $(resolve_link "$name" || true) 通过true去除 -e 捕获; 当然此时没有pipefail
case *?[]构成的模式匹配和 [[]]和BASH_REMATCH sed awk egrep 实现的正在表达式匹配，用于处理符合特定格式"类型" 的匹配
命令行处理时 getopt while for shift OPTARG OPTINT ?
${string:offset:length} 在命令行参数、函数参数和字符串、数组各种形式下的差异 ? 

EOF
}

bash_k_builtin_shopt(){ cat - <<'EOF'
environment
shopt -p                # show all options
( set -o posix ; set ) | less   # set shows all shell variables (exported or not); -o posix => only variables

# set-and-unset-shell-options:
#   -s     set, enable
#   -u     unset, disable
#   -q     quite mode
#   -p     print
shopt -p    # print all options
shopt -p cdspell
#  shopt -u cdspell    # is unset -u
shopt -p promptvars
#  shopt -s promptvars  # is set -s
EOF
}

bash_k_builtin_fg(){ cat - <<'EOF'
fg           # brings a background job into the foreground
fg %+        # brings most recently invoked background job
fg %-        # brings second most recently invoked background job
fg %N        # brings job number N
fg %string   # brings job whose command begins with string
fg %?string  # brings job whose command contains string
EOF
}

bash_k_builtin_enable(){ cat - <<'EOF'
#启用或禁用内置命令
enable -a 显示bash所有的内置命令: 包括启用和禁用的内置命令
enable -n [name] 禁用内置命令name。或者显示所有已禁止的的内置命令
enable -p 显示所有已启用的内置命令
enable -s 显示所有特殊内置命令
          如果提供-f选项的同时使用-s选项则这些命令成为特殊内置命令

enable 启用或者禁用内置命令
  enable -s # POSIX内建命令     sh
  enable -a # Bash所有内建命令  bash
#help enable

enable -a # builtins 
enable -n # disabled builtins 
EOF
}
  
bash_k_builtin_null(){ cat - <<'EOF'
  : 的任何参数都会被忽略掉，同时直接返回 0 
EOF
}

bash_t_builtin_null(){ cat - <<'EOF'
  debug (){ # 函数DEBUG存在，则调用DEBUG函数输出内容，否则，忽略输出内容
    ${DEBUG:-:} "$@"
  }
  
  DEBUG() { 
    [ "$_DEBUG" == "on" ] && $@ || : 
  } 
  
  for i in {1..10} do 
    DEBUG echo "I is $i" 
  done
  
  _DEBUG=on ./script.sh
EOF
}

bash_k_builtin_source(){ cat - <<'EOF'
. 文件名 [参数] # 在当前shell环境中，从文件中读取并执行命令
  1. 如果文件名不包括斜杠，则使用PATH变量去搜索文件。
  2. 如果Bash不是在POSIX模式下运行，则在$PATH中找不到后就会在当前目录中搜索。
  3. 如果提供了参数，它们就成为执行文件名时的位置参数；否则的话当前shell的位置参数也是filename的位置参数。
  4. 返回状态是最后一个被执行命令的退出状态；
  5. 如果没有命令被执行，则返回零。
  6. 如果文件名没有找到，或者不能读取，返回状态就是非零值。
  filename: bash/bash-script-template-stable/source.sh
  
.   点号。 在当前的shell上下文中读取并执行filename脚本的内容
    1.相当于bash内建命令source，
    2.作为文件名的一部分，在文件名的开头，表示该文件为隐藏文件，
    3.作为目录名，一个点代表当前目录，两个点号代表上层目录
    4.正则表达式中，点号表示任意一个字符。
EOF
}

bash_k_builtin_break(){ cat - <<'EOF'
break|continue [n]: 返回状态是零，除非n不是大于或等于1。
  1. 如果提供n参数，则第n层的循环被跳出。
  2. n必须大于或者等于1。
  3. 只有在n小于1的情况下break才会返回非0值
break     从 for，while，until 或 select 循环中退出。
continue  继续执行外围的 for，while，until 或 select 的下一次循环
EOF
}

bash_t_builtin_break(){ cat - <<'EOF'
[break multiple loop]
arr=(a b c d e f)
for i in "${arr[@]}";do
  echo "$i"
  for j in "${arr[@]}";do
    echo "$j"
    break 2
  done
done


[break single loop]
arr=(a b c d e f)
for i in "${arr[@]}";do
  echo "$i"
  for j in "${arr[@]}";do
    echo "$j"
    break
  done
done

EOF
}

bash_k_builtin_exit(){ cat - <<'EOF'
exit [n] 如果n为空则表示上一个执行的命令的返回值。
         任何关于EXIT的trap在shell终止前被执行
EOF
}
bash_k_builtin_return(){ cat - <<'EOF'
return [n] 如果未提供n，则返回值是函数中上一个命令的退出状态
   return也可以用来终止使用. source内置命令执行的脚本，可以返回n或者脚本中的上一个命令的退出状态。
         任何和RETURN关联的trap都会在返回到调用脚本之前执行。
         如果n不为一个数字或者将return使用在其他的地方则return返回非0值.
EOF
}

bash_k_builtin_pwd(){ cat - <<'EOL'
  pwd: -P physical物理路径 -L symlink 符号链接   如果改变目录成功，返回状态就是零；否则就是非零。
EOL
}

bash_t_builtin_pwd(){ cat - <<'EOL'
$0         => relative path of script file
dirname $0 => relative path of script file directory
pwd        => absolute path from where it was invoked

$ pwd 
always the absolute path of location where script was invoked.

"$0" 
relative path of the file from the path from where it was invoked
** if invoked using the absolute path of script file the "$0" value will be the 
    absolute path to.
dirname $0

relative path of directory home of script from the path from where it was invoked
** if invoked using the absolute path of script file the "$0" value will be the 
    absolute path to.
EOL
}

bash_k_builtin_eval(){ cat - <<'EOF'
eval [参数表]：如果没有参数表，或者参数表为空，则退出状态为零 
               把参数表中的参数连在一起形成一个命令，然后读取并执行这个命令。命令退出状态就是eval的退出状态
              # [参数表] eval先进行大括号扩展、波浪号扩展、shell参数扩展和算术扩展，进程替换等等
# 见 a() 函数，eval在执行前，先执行'参数扩展', 然后将eval 'string' 作为全局语句执行。 openwrt/etc/function.sh 有更多
eval "export ${NO_EXPORT:+-n} -- \"$var=\${$var:+\${$var}\${value:+\$sep}}\$value\"" # 对eval引用的环境变量进行\$ 转义
EOF
}

bash_k_builtin_exec(){ cat - <<'EOF'
exec：  -l login; 
        -c选项在执行command之前会清空环境。;  
如果使用-a选项，则shell将name作为command的第0个参数。
EOF
}

bash_t_builtin_exec(){ cat - <<'EOF'
# Redirect all output to the file output.txt for the current shell process. 
exec > output.txt

# Open myinfile.txt for reading ("<") on file descriptor 3.
exec 3< myinfile.txt

# Close ("&-") the open read descriptor ("<") number 3.
exec 3<&-

# opens out.txt for writing (">") on file descriptor 4
exec 4> out.txt

# Open myappendfile.txt for appending (">>") as file descriptor 6.
exec 6>> myappendfile.txt

# Close the open write descriptor (">") number 4.
exec 4>&-

# Open myfile.txt for reading and writing ("<>") as file descriptor 5.
exec 5<> myfile.txt

# Close open read/write descriptor 5.
exec 5<>&-

#  "-u 3" tells read to get its data from file descriptor 3, which refers to myinfile.txt.
read -u 3 mydata 

echo Text >&myfd

( exec ${shell_bin} "./${t}" 2>&1; ) 运行外部的代码
EOF
}

bash_k_builtin_getopts(){ cat - <<'EOF'
getopts 选项字符串 名称 [参数表] # while getopts "k:cudyvtb:h?" flag; do
getopts: 处理完选项结束时，getopts会退出并返回一个大于零的状态；optind会指向第一个非选项参数的下标；而名称被设置'?'
         如果遇到了无效(非法)的选项，getopts就会在名称里面放入'?'.
         如果选项字符串第一个是':' 则忽略错误信息，
         # OPTIND=1 OPTION OPTARG 
getopts optstring name [arg] # OPTSTRING -> $name (OPTIND 和 OPTARG) OPTERR=0不打印错误，OPTERR=1打印错误(默认)
         getopts通常用来分析位置参数，但是如果提供了args参数，则getopts会分析args参数而不是位置参数
while getopts 'x:y' OPTION; do 
  case OPTION in
    x) argument=OPTARG;;
    y) option=yes
    ?) exception;
    *) default ;;
  esac
done


while getopts u:d:p:f: option; do
  case "${option}" in
    u)
      USER=${OPTARG}
      ;;
    d)
      DATE=${OPTARG}
      ;;
    p)
      PRODUCT=${OPTARG}
      ;;
    f)
      FORMAT=$OPTARG
      ;;
  esac
done

echo $USER
echo $DATE
echo $PRODUCT
echo $FORMAT

EOF
}

bash_t_builtin_getopts(){ cat - <<'EOF'
while getopts 'e:hs:t:' opt; do
  case ${opt} in
    e)  # set an environment variable
      key=`expr "${OPTARG}" : '\([^=]*\)='`
      val=`expr "${OPTARG}" : '[^=]*=\(.*\)'`
      # shellcheck disable=SC2166
      if [ -z "${key}" -o -z "${val}" ]; then
        runner_usage
        exit 1
      fi
      eval "${key}='${val}'"
      eval "export ${key}"
      env="${env:+${env} }${key}"
      ;;
    h) runner_usage; exit 0 ;;  # help output
    s) shells=${OPTARG} ;;  # list of shells to run
    t) tests=${OPTARG} ;;  # list of tests to run
    *) runner_usage; exit 1 ;;
  esac
done
shift "`expr ${OPTIND} - 1`"


getopts: getopts optstring name [arg]
OPTIND 每次在shell或的时候，OPTIND都会被初始化为1。
OPTARG 当一个选项需要一个参数时。getopts 将该参数放入 shell 变量 OPTARG 中。
getopts会以两种方式之一报告错误。 
如果第一个字符的OPTSTRING是冒号，getopts使用无声错误报告。 在该模式下，不会打印错误信息。
如果一个无效的选项是所见，getopts将找到的选项字符放入OPTARG中。

如果一个没有找到所需的参数，getopts会在NAME中放置一个':'，并在NAME中放置一个':'。将OPTARG设置为找到的选项字符。
如果没有找到所需的参数，则在 NAME 中放置一个 '?'在NAME中放置一个'?'，OPTARG将被取消设置，并且一个诊断信息是打印出来。

如果shell变量OPTERR的值为0，则getopts会禁用打印出错信息，即使是第一个字符OPTSTRING不是冒号。 OPTERR的默认值为1。
EOF
}

bash_t_anon_getopts(){ cat - <<'EOF'
# ./script.sh --deploy true --uglify false
deploy=false
uglify=false
while (( $# > 1 )); do case $1 in
--deploy) deploy="$2";;
--uglify) uglify="$2";;
*) break;
esac; shift 2
done
$deploy && echo "will deploy... deploy = $deploy"
$uglify && echo "will uglify... uglify = $uglify"
EOF
}

bash_t_case_getopt_while(){ cat - <<'EOF'
while [ "$1" != "${1##[-+]}" ]; do
  case $1 in
    '')    echo $"$0: Usage: daemon [+/-nicelevel] {program}"
           return 1;;
    --check)
       base=$2
       gotbase="yes"
       shift 2
       ;;
    --check=?*)
           base=${1#--check=}
       gotbase="yes"
       shift
       ;;
    --user)
       user=$2
       shift 2
       ;;
    --user=?*)
           user=${1#--user=}
       shift
       ;;
    --pidfile)
       pid_file=$2
       shift 2
       ;;
    --pidfile=?*)
       pid_file=${1#--pidfile=}
       shift
       ;;
    --force)
           force="force"
       shift
       ;;
    [-+][0-9]*)
           nice="nice -n $1"
           shift
       ;;
    *)     echo $"$0: Usage: daemon [+/-nicelevel] {program}"
           return 1;;
  
  esac
done
EOF
}

bash_t_case_getopt_while(){ cat - <<'EOF'
for i in "$@"; do
  case $i in
    -e=*|--extension=*)
      VERSION="${i#*=}"
      shift # past argument=value
      ;;
    -s=*|--searchpath=*)
      SEARCHPATH="${i#*=}"
      shift # past argument=value
      ;;
    -l=*|--lib=*)
      LIBPATH="${i#*=}"
      shift # past argument=value
      ;;
    --default)
      DEFAULT=YES
      shift # past argument with no value
      ;;
    *)
      # catch all
      ;;
  esac
done
EOF
}
bash_k_builtin_hash(){ cat - <<'EOF'
记住参数名称所指定的命令的完整路径，使得以后再启动这个命令时不需要再搜索它。
命令是通过搜索$PATH中列出的目录而找到的。
---- 管理命令执行位置索引表 ----
hash [-r] [-p文件名] [-dtl] [名称] # -r Redo -p Path -d Destination -t prinT -l List
hash        # 显示哈希表中命令使用频率
hash -l     # 显示哈希表
hash -t git # 显示命令的完整路径
hash -p /home/www/deployment/run run # 禁止路径搜索，并用文件名指定命令的位置。
hash -r # 删除哈希表内容
-d 使得bash忘记它已经记住的名称的每个位置。
EOF
}

bash_k_builtin_trap_signal(){  cat - <<'EOF'
当bash接收到信号指示中的信号时，就会读取和执行参数中指定的命令。

trap -l  把所有信号打印出来。
trap -p  把所有信号当前的trap设置打印出来
trap -p  signal 把指定信号当前的trap设置打印出来

(exit return trap set) 那些调用引起信号、如何关注信号、信号的继承关系
trap:
0和EXIT：当shell退出时就会执行参数。 exit [n]
DEBUG  ：每次执行简单命令、for命令和case命令、select命令、算术for命令的每个算术表达式，
         以及shell函数的第一个命令之前，都会执行命令参数。
extdebug: 如果用shopt 打开了shell的extdebug选项，则还会显示函数定义所在的源文件名和行号。
          1. 内部命令declare的'-F'选项会显示与每个参数所指定的函数名对应的源文件名和行号。
          2. 如果DEBUG陷阱运行的命令返回的值为非零，则忽略下一条命令的执行。
          3. 如果DEBUG陷阱运行的命令返回的值为2，并且女奨奥奬奬正在执行子程序，则模拟return函数调用
          4. 更新BASH_ARGC和BASH_ARGV变量
          5. 启用函数跟踪：通过"$(命令)"而执行的命令替换，shell函数和子shell都会继承DEBUG和RETURN陷阱。
          6. 启用函数跟踪：通过"$(命令)"而执行的命令替换，shell函数和子shell都会继承ERR陷阱。
ERR    ：当一个简单命令因为下列原因返回非零的值时就执行命令参数。== errexit选项也服从同样的条件。
       如果失败的命令是紧跟在关键词until或while后的命令队列的一部分，
       或者是在关键词if或elif后的测试命令的一部分，
       或者是&&或||命令队列中所执行命令的一部分，
       或者该命令的返回状态经由! 反转，则不会执行ERR陷阱。
RETURN：当由内部命令. 或source执行的shell函数或脚本执行结束时，都会执行命令参数。 return [n]

# <set>
functrace 等同于-T
-T 如果设置则DEBUG和RETURN上的trap会被shell函数，命令替换和子shell中的命令执行所继承
errtrace 等同于-E
-E 如果设置则ERR上的trap会被shell函数，命令替换和子shell中的命令执行所继承
xtrace 等同于-x
# <declare>
-t 给name分配trace属性。被trace的函数从调用的shell中继承DEBUG和RETURN traps。trace对变量无效

信号
SIGTERM：如果Bash是交互运行的，并且没有任何陷阱，会忽略SIGTERM
SIGQUIT：会忽略SIGQUIT
SIGTTIN：会忽略SIGTTIN
SIGTOUT：会忽略SIGTOUT
SIGTSTP：会忽略SIGTSTP
SIGHUP : 默认情况下，shell接收到SIGHUP后会退出，在退出之间，交互式运行的shell回向所有作业，不管是正在运行的还是停止的，重新发送SIGQUIT
       disown
       如果使用shopt打开了Bash的huponexit选项，当一个交互运行的登录shell退出时,会向所有作业发送SIGHUP
SIGINT ：所有内部wait都是可以中断的。退出任何正在进行的循环
EOF
}

bash_k_builtin_trap(){ cat - <<'EOF'
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

trap "commands" EXIT   # 脚本退出时执行commands指定的命令。
trap "commands" DEBUG  # 在脚本执行时打印调试信息，比如打印将要执行的命令及参数列表。
trap "commands" ERR    # 当命令出错，退出码非0，执行commands指定的命令。
trap "commands" RETURN # 当从shell函数返回、或者使用source命令执行另一个脚本文件时，执行commands指定的命令。

trap -l             # print a list of signal names and their corresponding numbers
trap -p CMD         # display the trap commands associated with each SIGNAL_SPEC
trap 'echo "VARIABLE-TRACE> \$DOCKER_HOST= \"$DOCKER_HOST\""' DEBUG   # debugging
trap CMD sig1 sig2  # executes a command when a signal is received by the script
trap "" sig1 sig2   # ignores that signals
trap - sig1 sig2    # resets the action taken when the signal is received to the default

当 shell 收到信号 sigspec 时，命令 arg 将被读取并执行。
1. 如果没有给出arg或者给出的是 −, 所有指定的信号被设置为它们的初始值
2. 如果arg是空字符串， sigspec 指定的信号 被 shell 和它启动的命令忽略。
3. 如果arg不存在，并且给出了−p 那么与每个 sigspec 相关联的陷阱命令将被显示出来。
4. 如果没有给出任何参数，或只给出了−p， trap将打印出与每个信号编号相关的命令列表 。
5. 如果sigspec是 EXIT (0)，命令arg将在 shell 退出时执行。
6. 如果sigspec是 DEBUG, 命令arg将在每个简单命令(simple command，参见上面的 SHELL GRAMMAR) 之后执行。
7. 如果sigspec是 ERR, 命令 arg 将在任何命令以非零值退出时执行。
   如果失败的命令是until或while循环的一部分,if语句的一部分,&&或||序列的一部分,或者命令的返回值是通过!转化而来，ERR陷阱将不会执行。
EOF
}

bash_k_builtin_caller(){ cat - <<'EOF'
-> bash实例手册.sh  bash_a_builtin_caller()
caller：返回当前活动的子程序(即shell函数，或通过内部命令.或source执行的shell脚本)调用。
  如果没有表达式，caller显示当前子程序调用的行号和源文件名。
  如果用非负整数作为表达式，caller就会显示行号、子程序名称、以及与当前调用堆栈位置相对应的源文件。这些额外信息可以用来打印堆栈跟踪信息。
  当前的帧是第0帧。
  返回值是0，除非shell并没有在执行子程序调用，或者表达式不对应调用堆栈中的有效位置。
EOF
}


bash_t_builtin_if(){ cat - <<'EOF'
[bash]   内建测试命令
if [[ $1 -eq 1 ]]; then
  echo "1 was passed in the first parameter"
elif [[ $1 -gt 2 ]]; then
  echo "2 was not passed in the first parameter"
else
  echo "The first parameter was not 1 and is not more than 2."
fi

[return] 外部调用命令
if grep "foo" bar.txt; then
if (( $1 + 5 > 91 )); then

[posix] sh (test)方式测试
if [ "$1" -eq 1 ]; then
  echo "1 was passed in the first parameter"
elif [ "$1" -gt 2 ]; then
  echo "2 was not passed in the first parameter"
else
  echo "The first parameter was not 1 and is not more than 2."
fi

@ 字符串判断和数值判断
if [ -z "${BOOTUP:-}" ]; then            字符串空
if [ "$CONSOLETYPE" = "serial" ]; then   字符串相等
if [ "${BOOTUP:-}" != "verbose" ]; then  字符串不等
if [ "$retry" -eq 3 ]; then              数值相等

[conditional && ||] 联合判断
if [[ -L $filename || -e $filename ]]; then
  echo "$filename exists (but may be a broken symbolic link)"
fi

if [[ -L $filename && ! -e $filename ]]; then
  echo "$filename is a broken symbolic link"
fi

if [ "$expr1" -a "$expr2" ] ; then
  echo "Both expr1 and expr2 are true."
else
  echo "Either expr1 or expr2 is false."
fi

@ 使用test判断
if [ -f /etc/sysconfig/i18n -a -z "${NOLOCALE:-}" -a -z "${LANGSH_SOURCED:-}" ] ; then   关键字连接
if [ -z "$makeswap" ] && cryptsetup isLuks "$src" 2>/dev/null ; then                     && || 关键字连接
if [ -n "$nconfig" ] && [ -f "$nconfig" ]; then                                          && || 关键字连接
@ 使用命令返回值判断
if ! /sbin/chkconfig --list radvd >/dev/null 2>&1; then
if ! grep search /etc/resolv.conf >/dev/null 2>&1; then
if LC_ALL=C ip -o link show dev $1 2>/dev/null | grep -q ",UP" ; then
if echo $addressgw | LC_ALL=C grep -qi "^fe80:"; then
EOF
}

bash_t_builtin_for(){ cat - <<'EOF'
[for loop] # array
arr=(a b c d e f)
for i in "${arr[@]}";do ... done

for ((i=0;i<${#arr[@]};i++));do  echo "${arr[$i]}"; done

[for loop] # brace expand 
for i in {1..10}; do ... done

for i in {5..50..5}; do ... done

[for loop] # integer
for (( i = 0; i < 10; i++ )) ; do ... done

for (( i = 0, j = 0; i < 10; i++, j = i * i )); do ... done

[for loop] # glob
files=( * )
for file in "${files[@]}"; do ... done

[for loop] # glob
for file in ./* ; do ... done

nb=0
for FILE_NAME in *.srt; do
    nb=$((nb+1))
    mv "${FILE_NAME}" "$1 $nb".srt
done

for file in /proc/[0-9]* ; do echo ${file}; done # 所有进程
for i in * ; do                                  # 所有文件(当前目录)
for i in /proc/sys/net/ipv6/conf/*               # 所有文件(指定目录)
for file in /etc/sysctl.d/* ; do                 # 所有文件
for i in /sys/class/net/*/address                # 所有文件(指定目录)
for file in /dev/.dhclient-${DEVICE}.leases /dev/.initramfs/net.${DEVICE}.lease ; do # 枚举文件
 for i in $vlaninterfaces $bridgeinterfaces $xdslinterfaces ; do                     # 枚举接口
for f in "${stdoutF}" "${stderrF}"; do                                               # 枚举文件
for idx in {0..256} ; do                            # 大括号扩展
for i in `seq 50`; do                               # 序列命令 -- 先解析命令在执行for循环
for pidf in `/bin/ls $piddir/*.pid 2>/dev/null`; do # list命令 -- 先解析命令在执行for循环
for arg in $BONDING_OPTS ; do                       # 分隔符扩展
for testcase in ${TEST_CASES}; do                   # 分隔符扩展
    
# 不指定shell的时候，使用测试所有 sh
RUNNER_SHELLS='/bin/sh ash /bin/bash /bin/dash /bin/ksh /bin/pdksh /bin/zsh'
shells=${shells:-${RUNNER_SHELLS}}
for shell in ${shells}; do ... done

# 获取指定形式文件名的字符串
echo ./*_test.sh |sed 's#./##g'

for ($j = 0; defined($options[$j]); $j++)  # 很少见
EOF
}

bash_t_builtin_while(){ cat - <<'EOF'
[while loop] # array遍历
i=0
while [ $i -lt ${#arr[@]} ]; do
  echo "${arr[$i]}"
  i=$(expr $i + 1)
done

i=0
while (( $i < ${#arr[@]} )); do
  echo "${arr[$i]}"
  ((i++))
done

[while loop] # integer序列
i=0
while [ $i -lt 5 ] ; do
  echo "i is currently $i"
  i=$[$i+1] #Not the lack of spaces around the brackets. This makes it a not a test expression
done #ends the loop

[while loop] # forever 死循环
while true; do
  echo ok
done

while :; do
  echo ok
done

while read fs_spec fs_file remaining_fields; do ... done < /etc/fstab # 读取指定文件 function
while read desc arg want; do ... done <<EOF ... EOF                   # 读取数据块   shunit2
while [ -n "$opt" ]; do opt=${opt##$arg}; opt=${opt##,} ; done        # 字符串解析   function
while [ "$1" != "${1##[-+]}" ]; do ... shift 2; done                  # 命令行解析   function
while [ "$count" -gt 0 ]; do usleep 500000;  done                     # 超时计算     function
while [ $SECONDS -lt $timeout ]; do                                   # 超时计算     ypbind
while getopts 'e:hs:t:' opt; do                                       # 命令行解析   shunit2/test_runner
LC_ALL=C grep -w "^$DEVICE" /etc/sysconfig/static-routes-ipv6 | while read device args; do # 管道数据解析 ifup-ipv6
mount | awk '{ print $1,$3 }' | while read dev dir; do                # halt
EOF
}

bash_t_builtin_until(){ cat - <<'EOF'
[until loop] # integer
i=5
until [[ i -eq 10 ]]; do #Checks if i=10
  echo "i=$i" #Print the value of i
  i=$((i+1)) #Increment i by 1
done

[until loop] # forever
until false; do
  echo ok
done
EOF
}

bash_t_case_regex(){ cat - <<'EOF'
1. 命令行参数
'') 
--check)    base=$2
--check=?*) base=${1#--check=}
--user)     user=$2
--user=?*)  user=${1#--user=}
--pidfile)     pid_file=$2
--pidfile=?*)  pid_file=${1#--pidfile=}
--force)    force="force"
[-+][0-9]*) nice="nice -n $1"
*) echo $"$0: Usage: daemon [+/-nicelevel] {program}"


"h" | "help" ) help; exit 0;
"v" | "version" ) version; exit 0;
"c" | "count" )
"t" | "tap" )
"p" | "pretty" )
* ) usage >&2  ; exit 1;
  
2. 文件类型匹配
*~ | *.bak | *.orig | *.rpmnew | *.rpmorig | *.rpmsave)

3. true|false yes |no 匹配
[tT] | [yY] | [yY][eE][sS] | [tT][rR][uU][eE])   # yes
[fF] | [nN] | [nN][oO] | [fF][aA][lL][sS][eE])   # false

4. 进程状态管理
start)  
stop)                       
status)
reload)
force-reload)
restart)
condrestart)                     
*)  # echo "Usage: $0 {start|stop|restart|force-reload|status}"

5. 注册和注销
add|register)
remove|unregister)

6. 模块性增删改查
""|"list")
"add")
"delete")
"deleteall")
"0W" )
"timestamp")
EOF
}

bash_t_builtin_case_break(){ cat - <<'EOF'
[case] # regex
case "$BASH_VERSION" in
  [34]*)
    echo {1..4}
  ;;
  *)
    seq -s" " 1 4
esac

[case] # regex
is_true() {
    case "$1" in
    [tT] | [yY] | [yY][eE][sS] | [tT][rR][uU][eE])
    return 0
    ;;
    esac
    return 1
}

is_false() {
    case "$1" in
    [fF] | [nN] | [nN][oO] | [fF][aA][lL][sS][eE])
    return 0
    ;;
    esac
    return 1
}

is_ignored_file() {
    case "$1" in
    *~ | *.bak | *.orig | *.rpmnew | *.rpmorig | *.rpmsave)
        return 0
        ;;
    esac
    return 1
}

case ${var+x$var} in
  (x) echo empty;;
  ("") echo unset;;
  (x*[![:blank:]]*) echo non-blank;;
  (*) echo blank
esac

EOF
}
bash_t_builtin_case_continue(){ cat - <<'EOF'
[fall through]
var=1
case $var in
1)
echo "Antartica"
;&
2)
echo "Brazil"
;&
3)
echo "Cat"
;&
esac

Output:
Antartica
Brazil
Cat

var=abc
case $var in
a*)
echo "Antartica"
;;&
xyz)
echo "Brazil"
;;&
*b*)
echo "Cat"
;;&
esac
Outputs:
Antartica
Cat
EOF
}

bash_k_builtin_command(){ cat - <<'EOF'
在shell中，内建(builtin)命令command，格式如下：
  command [-pVv] command [arg ...]
  command命令类似于builtin，也是为了避免调用同名的shell函数，命令包括shell内建命令和环境变量PATH中的命令。
  选项"-p"指定在默认的环境变量PATH中查找命令路径。选项"-v"和"-V"用于显示命令的描述，后者显示的信息更详细。
  command -v CMD    # posix way of checking if CMD is available
EOF
}

bash_t_builtin_command(){ cat - <<'EOF'
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
EOF
}

bash_k_builtin_compgen(){ cat - <<'EOF'
根据选项显示可能的完成度
# env variables
# COMPREPLY      array variable used to store the completions
# COMP_WORDS     array of all words typed after the name of the program the compspec belongs to
# COMP_CWORD     index of COMP_WORDS array pointing to the word the current cursor is at - index of the word the cursor was when the tab key was pressed          
# COMP_LINE      the current command line

# options:
#   -d     names of directory
#   -e     names of exported shell variables
#   -f     names of file and functions
#   -g     names of groups
#   -j     names of job
#   -s     names of service
#   -u     names of userAlias names
#   -v     names of shell variables

compgen -c x                    # names of all commands starting with x

compgen -a                      # names of alias, like alias but only alias names

compgen -A variable | grep X    # get all variables starting with X; see also: `echo ${!X*}`

compgen -b                      # names of shell builtins => list-builtins, like help

compgen -k                      # names of Shell reserved words


compgen -W "now tomorrow never"
now
tomorrow
never

compgen -W "now tomorrow never" n
now
never

compgen -W "now tomorrow never" t
tomorrow
EOF
}

bash_k_builtin_complete(){ cat - <<'EOF'
complete -W "word1 word2 .." command    # -W wordlist provide a list of words for completion
complete -A directory dothis           # only directory names

_dothis_completions() {
  COMPREPLY+=("now")                   # array variable used to store the completions        
  COMPREPLY+=("tomorrow")
  COMPREPLY+=("never")
}

complete -F _dothis_completions dothis    # -F flag defining function that will provide the completi
EOF
}

bash_k_builtin_help(){ cat - <<'EOF'
help 显示内嵌命令的相关信息。
  -d        输出每个主题的简短描述
  -m        以伪 man 手册的格式显示使用方法
  -s        为每一个匹配 PATTERN 模式的主题仅显示一个用法
  
command  # removes alias and function lookup. Only built-ins and commands found in the search path are executed
builtin  # looks up only built-in commands, ignoring functions and commands found in PATH
enable   # enables and disables shell built-ins
EOF
}

bash_k_builtin_readonly(){ cat - <<'EOF'
readonly [-af] [name[=value] ...] or readonly -p
readonly 把每个名称标志为只读。后续语句就不可以更改这些名称的值。
readpnly -p 把输出格式化成可以重新作为输入的形式。
EOF
}

bash_k_builtin_alias(){ cat - <<'EOF'
alias [-p] [name[=value] ... ]
如果没有参数或者给定了-p. alias 就会在屏幕上把别名列表以便于重新输入的形式打印出来。
如果给定参数，则对于每个给定的名称，都用对应的值作为别名；
如果没有给出值，则打印名称指定的别名。
EOF
}


bash_t_builtin_alias(){ cat - <<'EOF'
[List all Aliases]
alias -p

[Disabling the alias]
alias ls='ls --color=auto'

command ls
/bin/ls
\ls, or l\s
"ls" or 'ls'

[Create an Alias]
alias myAlias='some command --with --options'
alias print_things='echo "foo" && echo "bar" && echo "baz"'

[Remove an alias]
unalias {alias_name}
alias now='date'
now
unalias now

[BASH_ALIASES]
echo There are ${#BASH_ALIASES[*]} aliases defined.
for ali in "${!BASH_ALIASES[@]}"; do
    printf "alias: %-10s triggers: %s\n" "$ali" "${BASH_ALIASES[$ali]}"
done
EOF
}


bash_k_builtin_declare(){ cat - <<'EOF'
declare [-aAfFilrtux] [-p] [name[=value] ...]
声明变量并设置其属性。如果没有给定名称，则显示变量的值。
-p : 会显示每个名称的属性和值。
     如果使用了"-p"和参数名称，则忽略其余参数。
     如果给定"-p"却没有给定参数名称，则显示所有通过其它选项选定了属性的变量的属性和值。
     如果给定"-p"而没有给定其它选项，declare 将会显示所有bash变量的属性和值。
-f:  限制输出只显示bash的函数。
-F:  显示函数的定义
----------------------------------------------
-a: 每个名称都是下标数组变量
-A: 每个名称都是键值数组变量
-f: 只使用函数名称。
-i: 把变量当成整数；
-l: 对变量名称赋值，把大写字母转化为小写。
-r: 把名称设为只读。以后不可以用赋值语句对这些名称赋值或者把它们重置。
-t: 给每个名称都设置 trace 属性。
-u: 对变量名称赋值，把小写字母转化为大写。
-x: 通过环境把每个名称导出给后续命令
EOF
}

bash_t_builtin_declare(){ cat - <<'EOF'
declare -r foo=bar        # readonly
declare -i                # integer
declare -a                # array
declare -a arr=('aa' 'bb' 'cc' 'dd' 'ee')
declare -A                # associative array !
declare -f                # function(s)
declare -x                # export
declare -x var=$value

## print all values of one type
declare -xp         #  exported vairables
declare -f          # list sourced functions
declare -F          # list only function names
declare -p          # show variables
declare -a          # variables are treated as arrays
declare -A          # variables are treated as associative arrays
declare -f          # uses funtion names only
declare -F          # displays function names without definitions
declare -i          # the variables are treaded as integers
declare -r          # makes the variables read-only
declare -x                   # marks the variables for export via the environment

# useful for identifying variables, environmental, ..
declare | grep foo      # foo=bar
declare | grep Colors   # Colors=([0]="purple" [1]="reddish-orange" [2]="light green")
EOF
}

bash_i_token(){ cat - <<'EOF'
token=operator + word
  operator=(control operator) + (redirection operator)
  word=name + (reserved word)
定义1：控制操作符(control operator)前面提到元字符是为了把一个字符串分割为多个子串，
       而控制操作符就是为了把一系列的字符串分割成多个命令。
       || & && | ; ;; ( ) |& <newline>
定义2：关键字(reserved words) 在 Bash 中，只有 22 个关键字，它们是"! case coproc 
       do done elif else esac fi for function if in select then until while { } time [[ ]]"。
       这其中有不少的特别之处，比如'! { } [[ ]]'等符号都是关键字，也就是说它们当关键字
       使用时相当于一个单词，也就是说它们和别的单词必须以元字符分开(否则无法成为独立的单词)。
"="是一个很变态的特例，因为它既不是元字符，也不是控制操作符，更加不是关键字，它到底是什么？


operator：包括控制操作符(control operator)和重定向操作符(redirection operator)。
    operator至少要包括一个未被引用的元字符(metacharacter)
控制运算符  实现控制功能的一些符号，包括换行符和下面的任意一个符号：|| && & ; ;; | |& (或) 换行
重定向操作符: << <<< > >> &> 
字段        经过shell扩展之后的文本单元，文本单元做命令的名字和参数。
            被shell作为单个单元的一串字符。words不包括未被引用的元字符(operator)
            经过shell一些扩展之后形成的文本单元。如果是执行一个命令，扩展之后的field作为命令名和参数
元字符      当没有引用时能够分隔开单词的字符。包括空白和下面的任意一个字符：| & ; ( ) < >
运算符      包括控制运算符和重定向运算符
保留字      对shell有特殊意义的一些单词：for while then time
符号        被shell当成一个单独单位的一串字符。要么是一个单词，要么是一个运算符
            被shell作为单个单元的一串字符。是一个word或者operator
单词        被shell当成一个单位处理的一串字符。它不能包含未被引用的元字符.
signal：系统中的某种事件发生时，内核通知进程的一种机制
process group：有相同进程组ID的一系列进程
job：组成管道线的一系列命令，和这些命令的衍生进程，所有的这些进程都在一个进程组中
job control：用户可以选择性的停止或者继续某些进程的机制

------ ------ 说明token分类，有利于理解脚本
标识符=操作符+单词              token=operator+word
token：被shell作为单个单元的一串字符。是一个word或者operator
       多个tokens  可以构造 simple command还是compound command。
       
operator：包括控制操作符(control operator)和重定向操作符(redirection operator)。
          operator至少要包括一个未被引用的元字符(metacharacter)
word：被shell作为单个单元的一串字符。words不包括未被引用的元字符
操作符=控制操作符+重定向操作符  operator=(control operator)+(redirection operator)
control operator：起控制作用的token，包括换行和 || && & ; ;; | |& ( )字符
redirection operator: 见 redirection 部分 

单词=元字符+名称+保留字         word=name+(reserved word)
name：一个只包含字母数字下划线并且以字母或者下划线开始的word。name用来标示变量或者函数名，或者说是一个标识符
reserved word：对shell有特殊意义的word。大部分保留字开始一个控制流程，比如for或者while

matecharacter：未被引用的元字符用来分隔words。元字符包括tab 空格 换行和| & ; ( ) < >字符
  tokens(word和operator)被metacharacters分隔
  每个元字符对shell都有特殊意义，如果要表示他们字面意义时就必须使用引用。命令历史扩展启用时，字符!需要被引用来表示字面上的意义。
bash 的二元体系; 扩展前的内容，是脚本'原文'。扩展后的结果，是脚本'翻译'后的'文本'，依赖脚本'原文'。
token,operator,control operator,redirection operator,word,name,reserved word 是扩展前的'原文'，
field是扩展之后的'文本'，bash执行最终按照扩展之后的'文本'进行执行。

field: 经过shell一些扩展之后形成的文本单元。如果是执行一个命令，扩展之后的field作为命令名和参数
------ ------

标识符 = 单词 + 运算符 = 单词 + 控制运算符 + 重定向运算符
字段 <--> 元字段
EOF
}

bash_p_string(){ 
echo "bash_p_variable_define"
cat - <<'EOF'
"${STRING}$(command)" 进行 变量扩展、历史扩展、命令替换; 引用可以禁用对特殊字符的特殊对待，参数扩展
支持嵌套: 
${STRING}$(command)   进行 模式匹配、大括号扩展、波浪号扩展、变量扩展。用于扩展和 模式比较、正则表达式比较
$VAR 首先得到VAR对应的值，然手使用空格对各部分进行分割，最后，按照全局匹配解释被分割的各部分

calculation='2 * 3'         # 思考是避免下面执行方式
echo "$calculation"         # prints 2 * 3
echo $calculation           # prints 2, the list of files in the current directory, and 3
echo "$(($calculation))"    # prints 6

echo "$var"                 # good
echo "$(mycommand)"         # good
another=$var                # also works, assignment is implicitly double-quoted
                            # 思考是避免使用错误的值传递方式
make -D THING=$var          # BAD! This is not a bash assignment. 
make -D THING="$var"        # good
make -D "THING=$var"        # also good

                            # 思考是空白字符的压缩和维持
string="hello           world"
echo ${string}   # hello world
echo "${string}" # hello           world

newline1='
'
newline2="
"
newline3=$'\n'
empty=\
echo "Line${newline1}break"
echo "Line${newline2}break"
echo "Line${newline3}break"
echo "No line break${empty} here"

echo $'Tab: [\t]'
echo $'Tab again: [\009]'
echo $'Form feed: [\f]'
echo $'Line\nbreak'
引用是用来去掉那些对shell有特殊意义的字符或者words的特殊意义。
  1. 引用可以禁用对特殊字符的特殊对待，
  2. 阻止保留字被识别，
  3. 或者阻止参数扩展
Bash中有三种引用机制：转义字符，单引用和双引用。
双引号：特殊字符$ ` \\ ! 以及 * @ 
    如果反斜线后面跟着一个换行，并且反斜线未被引用，则换行仍有特殊意义--表示一个续行
$'string':ANSI标准C引用。\nnn :由八进制数nnn代表的一个八位字符。
#                          \xHH :由十六进制数代表的一个八位字符。
#                          \cx  :一个控制字符CTRL-X.
#                          \a \b \e \E \f \n \r \t \v \\ \' \"
    地区语言转换 在双引号引用的字符串之前加上一个$，则这个字符串会按照当前系统地区信息进行转换。
如果当前地区是C或者POSIX则表示原生地区，$被忽略。字符串被转换之后仍然使用双引号引用
tr $'\n' ' ' file
Locale专用的翻译：po2lmo
TEXDOMAINDIR/LCMESSAGES/LCMESSAGES/TEXTDOMAIN.mo # 见 C语言的locale.txt

字符串有: 未初始化,初始化为空,初始化为空白字符,和初始化为非空白字符四种状态。
未初始化判断:        declare -p xx (返回值错误，有错误输出); test -z(返回值错误，无错误输出); ${var-word} 默认值配置
初始化为空  :        declare -p xx (返回值正确，无错误输出); test -z(返回值错误，无错误输出); ${var:-word} 默认值配置； ${#nn} 
初始化为空白字符:    ${// /} 可以删除空白。-> ${#string} 字符串长度等于0.
初始化为非空白字符:  ${// /} 可以删除空白。-> ${#string} 字符串长度不等于0.

字符串有: "${string}" -- (参数展开、命令替换和算术展开) '${string}' $'string' 和 $string 四种形式。
          常用"${string}" ${!var}间接引用和eval
# 字符串状态判断 和 字符串输出方式 都是复杂的，如何合理的选择都需要思考，复杂性来自不可避免的思考。

"quote"                    'quote'
允许变量扩展               阻止变量扩展
允许历史扩展               阻止临时扩展
允许命令替换               阻止命令替换
*和@ 是特殊字符            *和@ 表示字母值
能够包含"" 或' '           不能够包含"" 或' '
$ ` ` " " \ 字面值需要通过 \ 转义
EOF
}

bash_i_command(){ cat - <<'EOF'
命令类型: 恰如其分是在适合和不适合之间的选择,不是在正确和错误之间的抉择.
    bash_i_command_simple   节制使用，因为同时对标准输出，错误输出和返回值三个点关注增加代码复杂度。
    bash_t_command_group    节制使用，命令组是一种函数的匿名简单实现方式。缺失了参数传递过程。
    bash_i_command_pipelines节制使用，过滤器;管道是输出流重定向的一种简化实现方式。可以简化复杂度也增加调试难度(被管道连接命令可能执行失败)
    bash_i_command_lists    提倡使用，通过返回值推动命令序列执行是一种简单且高效的实现方式。
    bash_i_command_compound 提倡使用，保证命令自身环境和命令参数环境的正确性，避免非预期的问题。
命令 1.简单命令 2.管道 3.队列命令 4.复合命令(4.1循环结构 4.2条件结构 4.3命令组合 4.4 协同进程)
    简单命令，管道和命令队列 是由 '控制操作符' 关联的一个或多个命令。
    复合命令  是由 保留字 关联的一个或多个命令
    命令组(单元执行)    对组的重定向操作会对组中的每个命令都有效。
                        和命令组的返回值是list返回值(list中最后一个命令的返回值)

1. 命令类型是对输入输出和返回值类型的整合。
1.1 简单命令: 关注点:标准输出，错误输出和返回值。(通常不能通过返回值单独判断代码执行结果 -- 问题); ->bash_t_command_simple
1.2 管道:     多个命令输入输出流的连接。         (贬低返回值，强调输出输入流) -- 过滤器            ->bash_t_command_pipelines
1.3 命令组  : 多个命令输入输出流的合并。         (贬低返回值，强调输出输入流) -- 扩展输出数据
1.4 队列命令: 通过命令返回值连接后续命令，返回值推动后续命令执行。 (贬低输出输入流，强调返回值) -- 连续与选择 -> bash_t_command_lists
1.5 复合命令: 通过命令返回值选择后续命令， if while until for                    -> bash_i_command_compound
              通过模式匹配选择后续命令，   case for
bash_t_builtin_if: 提倡使用，在脚本的初始化，函数参数判断，命令执行环境，多条件判断都会使用。
if: 代码块存在多条语句或被测变量不为空时被修改；
&&: 1. 被测变量为空，不存在时，使设置变量的值；2. 外部文件未被引用(source)时,引用外部对象；3. (成功)提前退出函数或者跳出循环
||: 1. (失败)提前退出函数， 2. 确保命令执行返回值正确。 || yes
bash_t_builtin_while  1. 配合read和管道对数据进行逐行分析 2. 配合$1和shift对命令参数进行分析；3. 配合 {##} {%%} 对字符串进行解析
bash_t_builtin_until  摒弃掉
bash_t_builtin_for    1. 遍历指定文件 2. 配合大括号扩展 3. 配合以枚举
bash_t_builtin_case   1. 命令行参数解析, 2, 进程状态管理 3. yes|no false|true匹配 4. 文件后缀或前缀匹配
bash_t_builtin_for    避免使用for循环进行计数处理。计数处理常常使用while方式或者{1..5} 或者 $(seq 10) 形式。

2. 命令的输入输出和返回值推动了脚本一步一步向前执行。
   变量配合以字符串切割和数值计算，使脚本编写贴近java等高级语言
   模式匹配和大括号扩展使得bash既复杂又灵活
   索引数组和关联数组简化了bash数据处理复杂性
EOF
}

bash_i_command_simple(){  cat - <<'EOF'
1. 简单命令:简单命令就是由一个或者多个空格分隔的多个words，以shell'控制操作符'(control operators)结束。
            ---- 一个以上述控制操作符结尾的字符串。
            第一个word通常是要执行的命令，其余的作为命令的参数
            简单命令的返回状态是POSIX 1003.1中的waitpid函数规定的退出状态；如果该命令由一个信号n终止，则其退出状态是128+n.

===============================================================================
总结: 关注点:标准输出，错误输出和返回值。(通常不能通过返回值单独判断代码执行结果 -- 问题); 

要求: 返回值0   + 标准输出时 = 输出内容符合要求(包含指定内容)，或者输出内容不符合要求(不包含指定内容)
      返回值非0 + 错误输出时 = 命令或函数要求参数不符合设定要求，或者输入内容不符合格式要求。
      简单命令常使用 1.$(command)                                           输出
                     2. > /dev/null 2>&1   或 2>/dev/null >/dev/null        返回值
                     3. "$@" && success $"$STRING" || failure $"$STRING"    返回值
      标准输出是必须处理的。
@ 在设计函数时，要避免简单命令导致的复杂度过高问题，尽量使用返回值决定函数执行结果；(函数设计包括bash函数设计和C语言命令行设计)
形式上:
1.1.1 正确返回+无标准输出+无错误输出 = 可用于 && ||  连接的队列命令
1.1.2 正确返回+有标准输出+无错误输出 = 可用于 pipe | 连接的管道命令
1.1.3 错误返回+无标准输出+有错误输出 = 直接退出 或者 主动忽略
就形式1.1.1和1.1.2而言，能使用形式1.1.1就避免使用形式1.1.2.
@ 在使用简单命令时，尽量使用bash提供的内建命令，
  一方面避免了系统环境中外部命令版本差异的影响，bash的内建命令参数和返回值像linux系统调用一样，具有较好的兼容性。
另一方面避免了外部命令执行(进程生命周期管理)时性能不高的问题。具有较高的性能。 
EOF
}

bash_t_command_simple(){  cat - <<'EOF'
1. 简单命令常用于输出
awk '{ print toupper($0) }' < /sys/class/net/${1}/address

2. 在执行简单命令前 要特别关注 简单命令的参数
if [[ "${opts}" =~ [[:space:]]*- ]]; then
/sbin/ethtool $opts
else
/sbin/ethtool -s ${REALDEVICE} $opts
fi

3. 忽略标准输出和错误输出
3.1 忽略返回值
ip link set dev $1 up >/dev/null 2>&1
/sbin/sysctl -e -w net.ipv6.conf.sit0.accept_redirects=0 >/dev/null 2>&1
/sbin/service radvd $action >/dev/null 2>&1

3.2 关注返回值
if ! /sbin/chkconfig --list radvd >/dev/null 2>&1; then
if ! grep search /etc/resolv.conf >/dev/null 2>&1; then
if LC_ALL=C ip -o link show dev $1 2>/dev/null | grep -q ",UP" ; then
if echo $addressgw | LC_ALL=C grep -qi "^fe80:"; then
EOF
}
bash_i_command_group(){  cat - <<'EOF'
bash提供了两种方式来把一系列命令放在一起作为整体执行。当命令被组织在一起时，可以对整个命令列表进行重定向。
( 表达式 )
{ 表达式; }
EOF
}
bash_t_command_group(){  cat - <<'EOF'
在 Bash 脚本中，子 shell(使用括号(...))是一种组织参数的便捷方式。一个常见的例子是临时地移动工作路径，代码如下：
    # do something in current dir
    (cd /some/other/dir && other-command)
    # continue in original dir
      
EOF
}
bash_i_command_pipelines(){  cat - <<'EOF'
2. 管道：管道是由'控制字符|或|&分隔开'的一系列简单命令。 
         [time [-p]] [ ! ] command1 | command2
         [time [-p]] [ ! ] command1 |& command2 
         time 关键字可以计算命令运行的时间，而 ! 关键字是将命令的返回状态取反。
      如果使用了|&，则命令一的标准错误输出将会和命令二的标准输出相连，这是2>&1 |的简写形式。
      保留字time能够在管道执行完毕后输出其执行时间的统计信息。 -p POSIX指定格式，TIMEFORMAT指定输出格式
      把time作为保留字允许我们统计内部命令，shell函数，以及管道的执行时间。
      times是内部命令。
      管道里面的每个命令是在自己子shell里面执行，管道的退出状态是最后一个命令的退出状态。
          pipefail打开则是：管道的退出状态是最后一个返回非零的那个命令的退出状态。
          |  标准输出管道 
          |& 标准错误输出管道

总结: 多个命令输入输出流的连接。  (贬低返回值，强调输出输入流) -- 过滤器
@ 在函数设计上，要禁止设计成 "过滤器" 形式的函数。即: 将输入内容转换成特定 "格式" 的输出内容。
形式上:
1.2.1 格式化过滤器 indent astyle shfmt expand unexpand dos2unix unix2dos fold jp xmlfmt tr
1.2.2 定位性过滤器 sed awk grep cut dd hexdump 
1.2.3 转换性过滤器 gcc clang make flex bison objdump 
命令行的参数设计不可避免关联过滤器设计，
ss命令:扩展功能 计时器信息(-o)，sock详细信息(-e), 内存信息(-m)，进程信息(-p) tcp内部状态(-i) 上下文信息(-z|-Z)
       过滤功能 host:port 五元组方式；-o state 连接状态方式；协议类型 tcp, udp, raw, unix, inet, inet6, link, netlink.packet, unix_dgram
扩展功能也是一种过滤功能。在ss命令中，扩展功能用以展现socket更多的信息。
socet命令: 扩展功能：-d[ddd] Prints fatal, error, warning, notice, info, and debug messages.
hostd命令: -d 选项会在messages文件中输出性能状态
EOF
}
bash_t_command_pipelines(){ cat - <<'EOF'
1. 将标准输出和错误输出传递给 awk
curl -vs 'http://www.google.com/' |& awk '/Host:/{print}/<title>/{match($0,/<title>(.*)<\/title>/,a);print a[1]}'
curl -vs 'http://www.google.com/' 2>&1 | awk '/Host:/{print}/<title>/{match($0,/<title>(.*)<\/title>/,a);print a[1]}'

2. 将标准输出传递给 less
ps -e | less

3. LANG=C 有利于屏蔽语言本地化造成的差异
LANG=C ip -o link | grep -v link/ieee802.11 | awk -F ': ' -vIGNORECASE=1 "/$1/ { print \$2 }"

4. /dev/null 忽略标准输出和错误输出 造成不必要的输出(强调返回值)
if ! grep search /etc/resolv.conf >/dev/null 2>&1; then
if LC_ALL=C ip -o link show dev $1 2>/dev/null | grep -q ",UP" ; then

5. 与grep联合使用,(强调返回值)
ethtool -i $1 2>/dev/null | grep -q "driver: bonding" && return 0

/bin/ipcalc --network $testipv4addr_globalusable 255.0.0.0   | LC_ALL=C grep -q "NETWORK=0\.0\.0\.0"     && return 10
/bin/ipcalc --network $testipv4addr_globalusable 255.0.0.0   | LC_ALL=C grep -q "NETWORK=10\.0\.0\.0"    && return 10
/bin/ipcalc --network $testipv4addr_globalusable 255.0.0.0   | LC_ALL=C grep -q "NETWORK=127\.0\.0\.0"   && return 10
/bin/ipcalc --network $testipv4addr_globalusable 255.255.0.0 | LC_ALL=C grep -q "NETWORK=169\.254\.0\.0" && return 10
/bin/ipcalc --network $testipv4addr_globalusable 255.240.0.0 | LC_ALL=C grep -q "NETWORK=172\.16\.0\.0"  && return 10
/bin/ipcalc --network $testipv4addr_globalusable 255.255.0.0 | LC_ALL=C grep -q "NETWORK=192\.168\.0\.0" && return 10
/bin/ipcalc --network $testipv4addr_globalusable 224.0.0.0   | LC_ALL=C grep -q "NETWORK=224\.0\.0\.0"   && return 10

LANG=C nmcli -t --fields device,state  dev status 2>/dev/null | grep -q "^${1}:connected$"
EOF
}

bash_i_command_lists(){  cat - <<'EOF'
3. 队列命令：; & && ||连接而成，最后可以由; & 或换行结束。"与"和"或"队列的返回值是其中最后一个被执行的命令的返回值。
(命令列表)   "&& || "优先级高于"; & "换行
            @ 如果命令以控制操作符&结束，则shell在一个子shell中异步执行。shell不等待命令的结束就直接返回0值。
        ----  如果多个简单命令或多个管道放在一起，它们之间以'; & <newline> || &&'等控制操作符分开，就称之为一个命令序列.
        异步执行的命令的标准输入将被重定向到/dev/null。

<command1>&&<command2>            #顺序执行，前面的不出错，后面的才执行   简化的 if command1; then command2; fi
<command1>||<command2>            #顺序执行，前面的出错，  后面的才执行   简化的 if command1; then :; else command2; fi
<command1>;<command2>             #顺序执行，不管前面结果，后面照样执行
<command1>&<command2>             #异步执行，不管前面结果，后面照样执行

总结:通过命令返回值连接后续命令，返回值推动后续命令执行。 (贬低输出输入流，强调返回值) -- 连续与选择
使用返回值推动命令序列执行是一种简单且高效的实现方式。该方式避免了字符串比较过程中的不确定性。
注意: 当需要字符串输出的时候，不可避免的要使用 "LANG=C" 设置命令的执行环境。
形式上:
两项连接: 1.默认值设置; 防止变量未初始化 或者 防止导入文件被多次导入
2.函数退出;3.循环跳出|继续;4.条件执行; 5.以及 if 多条件判断 6. 执行错误恢复
三项连接: 1. &&+|| 形式的成功推进+失败推进连接; 2. &&+&& 形式的成功连续推进
多项连接: 1. &&+&&+&& 后续命令依赖 前置命令执行.
EOF
}

bash_t_command_lists(){ cat - <<'EOF'
1. 默认值设置
防止变量未初始化
[ -z "${COLUMNS:-}" ] && COLUMNS=80 
[ -z "${CONSOLETYPE:-}" ] && CONSOLETYPE="$(/sbin/consoletype)"
[ -z "$name" ] && name=$0
防止导入文件重新导入
[ -z "$__sed_discard_ignored_files" ] && . /etc/init.d/functions

2. 函数退出
[ -d "/proc/$i" ] && return 0
[ ! -r "$pid_file" ] && return 4
[ -d "/sys/class/net/$1" ] && return 0

3. 循环跳出
[ -z "$remaining" ] && break

4. 条件执行
[ "$BOOTUP" != "verbose" -a -z "${LSB:-}" ] && echo_success
[ "$BOOTUP" != "verbose" -a -z "${LSB:-}" ] && echo_failure

[ -x /sbin/restorecon ] && /sbin/restorecon /etc/resolv.conf >/dev/null 2>&1
[ -e /var/lock/subsys/nscd ] && /usr/sbin/nscd -i hosts;

5. 联合条件
if [ -n "$nconfig" ] && [ -f "$nconfig" ]; then 
if [[ "$VAR_VALUE" == "y" ]] || [[ "$VAR_VALUE" == "yes" ]];

6. 执行错误忽略
echo "out" >/sys/class/gpio/gpio${gpio_index}/direction || true
===============================================================================
1. 比较方式
[[ $s = 'something' ]]  && echo 'matched'      || echo "didn't match"
[[ $s == 'something' ]] && echo 'matched'      || echo "didn't match"
[[ $s != 'something' ]] && echo "didn't match" || echo "matched"
[[ $s -eq 10 ]]         && echo 'equal'        || echo "not equal"
(( $s == 10 ))          && echo 'equal'        || echo 'not equal'

[ "$?" -eq 0 ] && success $"$base startup" || failure $"$base startup" 
[ "$RC" -eq 0 ] && failure $"$base shutdown" || success $"$base shutdown"

DEBUG被设置为on的时候，执行输入参数，否则忽略输入参数
[ "$DEBUG" == "on" ] && "$@" || :

2. 命令执行方式
cd my_directory && pwd || echo "No such directory"
cd my_directory && ls  || echo "No such directory"
"$@" && success $"$STRING" || failure $"$STRING"

3. && 连续执行
! is_false $NM_CONTROLLED && is_nm_running && USE_NM=true
EOF
}

bash_i_command_compound(){ cat - <<'EOF'
4. 复合命令: 复合命令是shell的编程结构体。每个结构体都是以保留字或者控制运算符开头，然后以与之对应的保留字或控制运算符结束。
(组合命令) ; 可以使用一个或者多个换行代替。
           任何对组合命令的重定向会应用到组合中的所有命令，除非明确的使用别的重定向
           Bash提供了循环结构，分支结构，和将多个命令放入一个组中作为一个单元执行的组命令
      ---- 如果将前面的简单命令、管道或者命令序列以更复杂的方式组合在一起，就可以构成复合命令。
      有 4 种形式的复合命令，它们分别是 (list)、{ list; } 、((expression)) 、[[ expression ]]
   
4.1命令组: 当命令被组织在一起时，可以对整个命令列表进行重定向。
         命令组的返回值是list返回值(list中最后一个命令的返回值)
(表达式)
{表达式;} 命令列表后面的逗号(或者换行符)是必须的。
{}是保留字，与命令之间必须用空白符或者其他shell元字符分开；()是运算符，与命令之间不需用空白符分开；

      
4.2 ((算术表达式)) 如果这个值不是零，则返回状态是零，否则返回1
    注意：expression既可以是n+n形式的表达式，也可以是v=n+n形式的表达式，这样会将=后面表达式进行计算并且赋值给变量v
    注意：这不同于$(())的形式，后者是一个表达式，表达式会有一个值；而这是一个命令，命令只有一个成功或者失败的返回值

4.3 [[条件表达式]] 对条件表达式求值，并根据其结果返回0或者1。
   在"[[和]]"中间的单词不会进行单词和文件名扩展，但却进行波浪号扩展、参数和变量扩展、算术扩展、命令替换、进程替换以及引用去除。
   诸如""等条件运算符不能被引用，否则它们就不是原子算术表达式了。
   结构中的<和>会按照本地区的字母顺序比较
   如果使用了"=="和"!="运算符，则运算符的右边会被看作是一个pattern。模式的任何部分都可以被引用以强制把其当作字符串来匹配。
   =~ 右边字符串认为是一个扩展的正则表达式来匹配。 BASHREMATCH
      nocasematch选项则匹配时忽略字母的大小写。 
      1. (表达式)
      2. ! 表达式
      3. 表达式1 && 表达式2
      4. 表达式1 || 表达式2
    注意：后面两个表达式也有短路操作的属性

4.4 协同进程 coproc [NAME] 命令 [重定向] 。 在子shell中执行，就像 & 一样。NAME -> COPROC
    NAME[0]: 命令的输出fd
    NAME[1]：命令的输入fd
    可以使用内部命令wait来等待协同命令的结束。协同进程的返回状态是其中命令的返回状态。
EOF
}

bash_t_command_compound(){ cat - <<'EOF'
    4.1 for((表达式一;表达式二;表达式三));do 命令块;done 其返回值是命令块中最后一个被执行的命令的返回值。如果表达式的值都是假的，则返回假。
        for ((i=0;i<${#arr[@]};i++))
        for (( i = 0; i < 10; i++ ))
        for (( i = 0, j = 0; i < 10; i++, j = i * i ))
    4.1 for 变量 [in单词] ; do 命令块 ; done            如果对单词的扩展没有得到任何元素，则不执行任何命令，并返回零。
        for i in "${arr[@]}"
        for i in {1..10}; # {..} 扩展
        argtester () { for (( i=1; i<="$#"; i++ )); do echo "${i}";done; }; argtester -ab -cd -ef # 1 2 3
          1   #i expanded to 1
          2   #i expanded to 2
          3   #i expanded to 3
        argtester () { for (( i=1; i<="$#"; i++ )); do echo "${!i}";done; }; argtester -ab -cd -ef # -ab -cd -ef
          -ab     # i=1 --> expanded to $1 ---> expanded to first argument sent to function
          -cd     # i=2 --> expanded to $2 ---> expanded to second argument sent to function
          -ef     # i=3 --> expanded to $3 ---> expanded to third argument sent to function
    4.1 until测试命令;do命令块;done                     如果命令块没有被执行则返回零。
        until [[ i -eq 10 ]];
    4.1 while测试命令;do命令块;                         如果命令块没有被执行则返回零。
        i=0
        while [ $i -lt ${#arr[@]} ];
        while (( $i < ${#arr[@]} ));
    4.2 if                                              如果命令块没有被执行则返回零。
        if [ "$1" -eq 1 ]; then
        if (( $1 + 5 > 91 )); then
        if grep "foo" bar.txt; then
        if [[ $1 -eq 1 ]]; then
    4.2 case: nocasematch选项则匹配时忽略字母的大小写。
        case word in [ [(] pattern [ | pattern ] ... ) list ;; ] ... esac
          | 用来分隔多个模式。) 用来结束模式列表。 
          ;;   匹配第一个模式以后就不会再匹配其他模式
          ;&   执行数据块后，如果还有其他的分句，就继续执行该分句
          ;;&  执行数据块后，如果还有其他的分句，就检查其模式: 如果模式为真就继续执行该分句
            word在匹配之前经过 tilde expansion、parameter expansion、command substitution、arithmetic expansion和quote removal 。
            pattern 经过 tilde expansion、parameter expansion、command substitution、arithmetic expansion
            通常会放置一个*在最后的子句作为一个默认子句，因为它总会匹配成功
            如果没有pattern匹配成功则什么也不执行，并且整个结构返回0；否则返回最后执行的那个command-list的返回值
EOF
}

bash_i_function(){ cat - <<'EOF'
5. 函数：[ function ] name () { list; } [重定向]。 
      name () compound-command [ redirections ]
      function name [()] compound-command [ redirections ]
5.1 函数定义的返回值总是0，除非出现语法错误或者和一个readonly的函数重名。
5.2 执行时函数的返回值是函数体中最后一个被执行的命令的返回值
5.3 函数和调用者的环境是一样的，除了下面几点：除非使用内置命令declare为函数添加strace属性或者
使用set命令-o functrace参数设置shell行为，否则DEBUG和RETURN traps不会被函数继承，并且除非使用
set -o errstrace设置shell选项，否则ERR traps也不会被继承.

5.4 通常情况下，函数体外的大括号与函数体之间必须用空白或者换行符分隔。使用大括号时，其中间的命令列表必须用逗号、& 或者换行符结束。
  在大部分情况下如果函数体使用大括号则函数体和后一个'}'之间要有一个'换行或者分号'。
  因为在shell中大括号是保留字只有和其他字符使用元字符分割时才能被识别。
  在其他的使用大括号情况下也一样，大括号中的list命令必须使用; &和newline分割
5.5 除了DEBUG和RETURN这两个陷阱没有被继承外，函数和其他调用者之间在shell执行环境所有其他方面都完全一样。
5.6 任何与RETURN陷阱相关联的命令都将在执行被恢复前被执行。
    unset -f            一个已经定义的函数可以使用内置命令unset加-f参数取消
    typeset|declare -F 显示所有函数名称
    typeset|declare -f 显示所有函数定义
    如果shell选项extdebug启用，也能列出文件名和行号。
    export -f          将一个函数定义导出到环境中，注意环境中的变量和函数重名会导致一些问题
5.7. 在函数中执行return内置命令，则函数会返回到调用的地方继续下面命令的执行。和RETURN trap关联的命令会在函数返回时执行
5.8. 如果return命令后面跟一个数字，则这个数字是函数的返回值，否则的话函数的返回值是return之前的一个命令的返回值
5.9  当函数执行时，函数的参数在函数体中替换了shell的位置参数(参数0没有被替换)。
     特殊字符#表示位置参数的个数，并且会随着shift的操作变化。FUNCNAME变量的第一个元素表示函数名
     FUNCNAME 是一个数组，表示函数调用的压栈顺序；位置1是当前调用函数名，最后一个是main表示脚本本身
     FUNCNEST变量如果设置为大于零则表示函数调用的最大层数，函数调用超出这个值则会立刻终止，
             函数递归调用同样受这个变量的限制，默认为0表示没有限制
5.10 使用local内置命令声明；然后这些变量只能在函数和函数中调用的命令中使用；未使用local关键字声明的变量表示全局变量

${FUNCNAME[0]}    # Current function
${FUNCNAME[1]}    # Parent function
${FUNCNAME[2]}    # So on and so forth
${FUNCNAME[@]}    # All functions including parents

declare -f
declare -F
EOF
}

bash_i_vaiable(){ cat - <<'EOF'
help vaiable 可以获得环境变量
变量: 永久环境变量,临时环境变量,全局变量,局部变量
6. 变量: alias declare typeset export readonly locol
   6.1. 变量可以有零个或者多个属性。属性的分配使用内置命令declare
   6.2. 定义一个参数之后可以使用内置命令unset来取消
   6.3. 变量可以使用这一的语句来赋值 name=[value]. 如果未给出value值，则变量被赋予空值。
6.4 help vaiable 可以获得环境变量
6.4.1.变量通过赋值来设置。
6.4.2.空字符串也是一个有效的值。
6.4.3.参数一旦设置以后，只能通过内部命令unset才能取消设置。
6.4.4.所有的值都会进行大括号扩展、参数和变量扩展、命令替换、算术扩展、以及引用去除
6.4.5.赋值语句还可以作为内部命令alias、declare、typeset、export、readonly和local的参数。
6.4.6.位置参数：set和shift内置命令可以用来重新定义和取消定义。
                位置参数不能使用普通的赋值语句赋值。
                当调用函数时位置参数临时被函数的参数代替.
6.4.7.特殊参数："$*"="$1c$2c..." "$@"="$1c""$2c"... 。c是特殊变量IFS的第一个字符。$-和$_扩展为bash选项集
  $!：展开为最后一个放入后台进程的PID
  $?：展开为上一个退出的前台进程（组）的退出状态
  $-：展开为启动shell时设置的选项标记字符所组成的字符串，标记可能是set命令设置的，或者系统设置的
  
6.5 赋值语句给一个变量和索引数组赋值;
6.5.1 +=操作符可以用来追加一个值到变量原来的值上。
  当变量名有整型的属性时，会进行数学运算。
  当使用(圆括号)结构将一个或者多个值追加到一个数组变量时，数组索引会依次增大并且将对应的值依次赋给对应的索引，
6.5.2 当使用=号操作符时，表示替换整个数组变量; 当使用关联数组时依然可用。
  当变量没有这些属性时(默认是字符串)，则会将value连接到原来的值的后面
EOF
}

bash_i_expand_glob(){ cat - <<'EOF'
被用在一下条件中:
pattern matching, pattern expansion, filename expansion, and so on

# wildcards
#   *       Matches any string, including the null string
#   ?       Matches any single (one) character
#   [...]   Matches any one of the enclosed characters

# glob
*           Matches any string, of any length
foo*        Matches any string beginning with foo
*x*         Matches any string containing an x (beginning, middle or end)
*.tar.gz    Matches any string ending with .tar.gz
*.[ch]      Matches any string ending with .c or .h
foo?        Matches foot or foo$ but not fools 

# range
[abcd]          Matches a or b or c or d
[a-d]           The same as above, if globasciiranges is set or your locale is C or POSIX. Otherwise, implementation-defined.
[!aeiouAEIOU]   Matches any character except a, e, i, o, u and their uppercase counterparts
[[:alnum:]]     Matches any alphanumeric character in the current locale (letter or number)
[[:space:]]     Matches any whitespace character
[![:space:]]    Matches any character that is not whitespace
[[:digit:]_.]   Matches any digit, or _ or . 
EOF
}

bash_i_expand_ifs(){ cat - <<'EOF'
IFS扩展发生在下面三种情况下
    Parameter expansion: ${}
    Command substitution: $()
    Arithmetic expansion: $(())
    
mystring="foo:bar baz rab"
IFS=
for word in $mystring; do
    echo "Word: $word"
done
EOF
}


bash_i_expand_brace(){ cat - <<'EOF'
1. 是一种产生任意字符串的技巧。  顺序从左到右(扩展的结果没有进行排序); 可以嵌套
   大括号扩展的格式是：一个可选的前导字符串，然后是一系列括在大括号中的逗号分隔的字符串或者序列表达式，最后一个可选的后缀字符串。
                       前导字符串会和大括号中的每一个项目连接，然后再连接后缀字符串。
   1.1 大括号扩展{x..y[..增量]} x和y可以是数字或者单个字符；incr表示增量，也是一个整数。
       当使用整数的时候，表达式扩展为x到y之间的所有数字，包括x和y。
       如：echo {0..10..2} # filename expansion中的[]
   1.1.1 整数还可以使用若干个前导0，强制扩展后的数字宽度相等；当x或者y以0开始的时候，shell会在扩展产生的每个数字前面按需要补若干个0。
   1.1.2 当使用字符的时候，扩展为x和y之间按字母顺序的所有字符；
   1.1.3 注意x和y需要时相同的类型。当提供increment时，表示每隔incr产生一个字符或数字。默认的incr是1或者-1
   1.2 a{b,c,d}e 大括号扩展
       为了避免与参数扩展冲突，大括号扩展不会识别字符串中的"${"。
       为了防止被认为是大括号扩展的一部分，{或者","可以用反斜杠转义。为了避免与参数扩展冲突，大括号扩展不会识别字符串中的"${"。
       每一个扩展的结果没有进行排序，而是从左到右的顺序排列。
       echo $\{{array[1],array[0]}\} # ${array[1]} ${array[0]}
       eval echo $\{{array[1],array[0]}\} # ${array[1]} ${array[0]} # 101 100
   1.3 在其他的扩展之前进行，并且任何被其他扩展认为是特殊字符的将会保留。bash不会对扩展前的内容进行语法解释。
   1.4 正确的brace expansion的形式是一对未引用的大括号和至少一个未引用的逗号或者一个合法的序列表达式。
       任何不正确的形式都不会进行brace expansion扩展
   注意${}是参数扩展，而{}才是大括号扩展
EOF
}

bash_t_expand_brace(){ cat - <<'EOF'
mv filename.{jar,zip}      Modifying filename extension
mkdir 20{09..11}-{01..12}  Create directories to group files by month andyear
cp .vimrc{,.bak}           Create a backup of dotfiles
echo {0..10..2}            Use increments
for c in {a..z..5}; do 
  echo -n $c; 
done

facility+=(local{0..7})

echo {a..z}          list from a to z
echo {z..a}          reverse from z to a
echo {1..20}         digits
echo {01..20}        with leading zeros
echo {20..1}         reverse digit
echo {20..01}        reversed with leading zeros
echo {a..d}{1..3}    combining multiple braces

ls *{txt,log}   # list all files ending with txt or log in the current directory
cp ~/projects/adders/verilog/{half_,full_}adder.v . # copy half_adder.v and full_adder.v to current directory
mv story.txt{,.bkp}   # rename story.txt as story.txt.bkp
cp story.txt{,.bkp}   # to create bkp file as well retain original
mv story.txt{.bkp,}   # rename story.txt.bkp as story.txt
mv story{,_old}.txt   # rename story.txt as story_old.txt
touch file{1..4}.txt  # same as touch file1.txt file2.txt file3.txt file4.txt
touch file_{x..z}.txt # same as touch file_x.txt file_y.txt file_z.txt
rm file{1..4}.txt     # same as rm file1.txt file2.txt file3.txt file4.txt

mkdir -p toplevel/sublevel_{01..09}/{child1,child2,child3}
EOF
}

bash_p_expand_brace(){ cat - <<'EOF'
形式上提供一种"数组".                             touch; mkdir -p; for in; find -name; ls
简单的也提供了source和destination之间的对应生成.  rename cp mv 

注意${}是参数扩展，而{}才是大括号扩展
EOF
}


bash_i_expand_tilde(){ cat - <<'EOF'
2. 波浪号扩展
  2.1 如果一个word以未被引用的~开始，则这个字符后面直到第一个未被引用的反斜线中间的字符都被认为是~扩展。 与'/'有关联。
  ~ $HOME的值
  ~/foo $HOME/foo
  ~fred/foo 用户fred家目录下面的foo目录
  ~+/foo $PWD/foo目录
  ~-/foo $OLDPWD/foo目录 $OLDPWD表示上一个所在的目录
  ~N 命令dirs +N显示的目录
  ~+N 命令dirs +N显示的目录
  ~-N 命令dirs -N显示的目录
EOF
}

bash_i_expand_parameter(){ cat - <<'EOF'
3. shell参数扩展 字符${}引导参数扩展,$()命令替换和$(()) 或 $[]计算扩展。基本格式: ${parameter}  parameter参数的值被替换。
   如果参数的第一个字符是个感叹号，就表示某个级别的间接变量。
   bash使用感叹号后面的这部分参数名的值作为一个参数名；然后参数名被扩展，扩展的结果作为整个替换的结果。这称为间接扩展。
   ${!prefix*}和${!prefix@} 表示间接扩展感叹号必须紧跟着大括号的左边括号
间接扩展：Bash使用后续变量的值作为新变量的名称，然后扩展这个新的变量，并用其值进行替换，而不是后续变量的值。
间接扩展：eval echo \$$B 。 Bash只识别感叹号形式的间接变量。
   ${!前缀*}和${!前缀@}  ${!名称[*]}和${!名称[@]} 属于例外情况。感叹号必须紧跟在大括号后面才表示间接变量。
   ${!前缀*}和${!前缀@}     扩展为名称中含有前缀的变量，以特殊变量IFS的第一个字符分隔。 echo ${!arr*}|${!arr@} # array
   ${!名称[*]}和${!名称[@]} 如果名称是个数组变量，扩展成名称内数组下标或者键名列表。echo ${!array[*]}|${!array[@]} # 0 1
   只有在"${!名称[*]}"和"${!名称[@]}"的时候，这两个下表才会有差别；即${!名称[*]}和${!名称[@]}位于引号内。
   差别：${变量名[*]}扩展为一个单独的单词，单词用IFS变量的第一个字符把数组名的所有元素连接而成。
         ${变量名[@]}把数组名的每一个元素都扩展为一个单独的单词，
   ${parameter:offset:length} 这表示子串扩展。在parameter的值中从offset开始取总共length个字节，作为整个替换的结果。
   1. 如果parameter是@，或者一个使用@ or *作为下标的索引数组，或者是一个关联数组名，则和下面的描述有所不同。
       [位置参数] 有效参数从第一个开始
       1. 如果parameter是@则表示从第offset个参数开始，到接下来的第length个参数。
       2. 如果offset为负值则表示从最后一个位置参数开始，-1表示最后一个位置参数。
       3. 如果length为负值则结果报错
       [索引数组] 有效参数从第0个开始
       1. 如果parameter是一个使用@ or *下标的索引数组，则扩展结果是从${array[offset]}开始的length个数组元素。
       2. 如果offset是负值则表示相对于最大下标的一个元素，最后一个元素是-1。
       3. 如果length为负值则报错
     $@    第一个参数 $0 是可执行文件名
     array 第一个参数 array[0] 就是设置的数值 
       [字符串]   有效参数从第0个开始
   2. 如果length为空，表示扩展为parameter的值从第offset字节开始到结束的所有字节。
   3. 如果offset是一个负值，则表示从parameter值的末尾开始向后取值。
   4. 如果length是一个负值则表示从offset开始一直取到第倒数length(length的绝对值)个值，这里不表示总共取length个字符。
   5. 注意如果offset为负值，符号-必须和前面的冒号至少有一个空格
${!prefix*} ${!prefix@} 
扩展为以prefix开始的所有变量名，使用IFS的第一个字符作为分隔符。如果使用@并且加双引号，每一个变量名扩展为单个的word
${!name[@]} ${!name[*]}
如果name是一个数组变量，扩展为数组的所有下标。
  1 如果不是一个数组名，并且name为非空则返回0，
  2 如果为空则返回null。
  3 如果使用"@"，并且使用双引号，则扩展后的所有下标都是一个单独的word
${parameter#word}
${parameter##word}
word按照 filename expansion的规则扩展产生一个pattern。
  如果pattern匹配parameter的值的开始部分，则扩展的结果是匹配pattern的最短(#)或者最长(##)部分被删除。
  如果parameter是@ or *则将匹配的部分移除会作用于每一个位置参数，扩展的结果是移除匹配部分后的位置参数列表。
  如果parameter是一个数组名，并且使用@ or *的下标，则匹配移除的操作会作用于数组的每一个元素，扩展的结果是移除匹配部分后的数组元素列表
${parameter/pattern/string}
  如果pattern是以#开始，则必须从parameter的值的第一个字符开始匹配，匹配成功则替换。
  如果pattern是以%开始，则pattern必须从最后一个字符开始匹配。
  如果string为空，则匹配的部分被删除。
EOF
}

bash_t_expand_parameter(){  cat - <<'EOF'
[bash_i_variable_string] 从概念上描述扩展的简要形式
[bash_p_string]          从本质上描述扩展的细节
[bash_t_string_condition]  ${:-}  ${:=}  ${:+}  ${:?}
[bash_t_string_default]  描述了 ${:-} 所能解决的问题
[bash_t_string_substr]   描述 ${string:start:length}
[bash_t_string_substr_set] 描述 数组各字段的分割问题
[bash_t_string_replace]  描述 [常规替换] 和 [模式替换]
[bash_t_string_replace2 ] ${FOO/from/to}      Replace first match
                          ${FOO//from/to}     Replace all
                          ${FOO/%from/to}     Replace suffix
                          ${FOO/#from/to}     Replace prefix
[bash_t_string_trime]     trim 删除头尾的方式 [贪婪和非贪婪]
                          ${FOO%suffix}       Remove suffix
                          ${FOO#prefix}       Remove prefix
                          ${FOO%%suffix}      Remove long suffix
                          ${FOO##prefix}      Remove long prefix
EOF
}

bash_p_expand_parameter(){  cat - <<'EOF'
参数扩展即字符串处理,既有 test -z|-n        形式的判断 ${:-}  ${:=}  ${:+}  ${:?}
                     也有 s/field/replace/g 形式的替换 ${FOO/from/to};${FOO//from/to};${FOO/%from/to};${FOO/#from/to}
                     还有 trim              形式的剪除 ${FOO%suffix} ${FOO#prefix} ${FOO%%suffix} ${FOO##prefix}
                     还有 数值级别的切割    ${string:start:length}
   既支持字符串有支持数组 数组级别的切特    ${array:start:length}
既支持整体字符串又支持单词拆分              ${array[*]} ${array[@]} 
既支持字符串长度有支持数组长度              ${#string} ${#array} 
EOF
}

bash_i_expand_command_substitution(){ cat - <<'EOF'
4.命令替换 $(命令) `命令`。 用命令的输出替代命令本身。即用字符串输出内容代替命令的执行。
  Bash先执行命令，并把该命令的标准输出中最后面的换行符删除，用结果取代命令替换。
  中间的换行符不删除，但是可能在单词拆分时被删除。
  如果命令替换出现在双引号之间，则其结果不会进行单词拆分和文件名扩展。
EOF
}
bash_t_expand_command_substitution(){ cat - <<'EOF'
与外部命令
src=$(/sbin/blkid -t "$src" -l -o device)                  # function
val=$(/bin/ipcalc --netmask "${ipaddr[$i]}/${prefix[$i]}")
val=$(/bin/ipcalc --netmask "${ipaddr[$i]}")

与printf awk grep 和 echo
local major1="$(echo $ipv4addr | awk -F. '{ print $1 }')"  # network-functions-ipv6
local minor1="$(echo $ipv4addr | awk -F. '{ print $2 }')"  # network-functions-ipv6
local major2="$(echo $ipv4addr | awk -F. '{ print $3 }')"  # network-functions-ipv6
local minor2="$(echo $ipv4addr | awk -F. '{ print $4 }')"  # network-functions-ipv6
local block1="$(printf "%x" $minor1)"                      # network-functions-ipv6
local block1="$(printf "%x%02x" $major1 $minor1)"          # network-functions-ipv6
local block2="$(printf "%x" $minor2)"                      # network-functions-ipv6
local block2="$(printf "%x%02x" $major2 $minor2)"          # network-functions-ipv6

与外部命令和awk
local ttldefault="$(/sbin/sysctl -e net.ipv4.ip_default_ttl | awk '{ print $3 }')" 
local tunnel_local_ipv4addr="$(/sbin/ip tunnel show $device | awk '{ print $4 }')"
EOF
}

bash_p_expand_command_substitution(){ cat - <<'EOF'
将命令的输出放到决定性地位.常常与 echo printf grep 和 管道连接在一起.
EOF
}
bash_i_expand_arithmetic_expansion(){ cat - <<'EOF'
5.算术扩展 $((算术表达式))
  expression就像在双引号中一样，但是小括号中的双引号不会被特殊对待。
  
$((EXPRESSION))       # is arithmetic expansion; return result
((EXPRESSION))        # don't return result; e.g. variable assignment
let myvar+=1          # same to ((EXPRESSION))

((var=1+2))           # Simple math

((var++))
((var--))
((var+=1))
((var-=1))

((var=var2*arr[2]))   # Using variables
echo $((13380009932/1024/1024/1024))

# arithmetic expansion
$((...))          # arithmetic expansion and return the result
$((1+1))
$((2*2))
$((4/2))
$((2**2))
$((base#number))  # convert number from base to decimal
$((2#1111))       # 15
$((8#16))         # 14
$((16#FF))        # 255
EOF
}

bash_i_expand_process_substitution(){ cat - <<'EOF'
6.进程替换：如果系统支持命名管道"fifo" 或能够以"/dev/fd"方式来命名打开的文件，则也就支持进程替换。
  <(命令列表) 往这个文件（描述符）写数据会作为list的标准输入
  >(命令列表) 表示将list的标准输出作为command的标准输入。
  注意，<或>与左边括号之间不能有任何空格，否则这种结构就会被解释成重定向。
  
echo >(true) # /dev/fd/63
echo <(true) # /dev/fd/63
EOF
}

bash_t_expand_process_substitution(){ cat - <<'EOF'
diff <(curl http://www.example.com/page1) <(curl http://www.example.com/page2)
paste <( ls /path/to/directory1 ) <( ls /path/to/directory2 )

while IFS=":" read -r user _ ; do
# "$user" holds the username in /etc/passwd
done < <(grep "hello" /etc/passwd)

[To avoid usage of a sub-shell]
count=0
while IFS= read -r _; do
  ((count++))
done < <(find . -maxdepth 1 -type f -print)


while read -r; do
  array[$i]="$REPLY" # Assignment by index
  let i++ # Increment index
done < <(seq 1 10) # command substitution
EOF
}

bash_i_expand_word_splitting(){ cat - <<'EOF'
7.单词拆分：
@ 拆分条件
  在单词拆分时，shell会扫描参数扩展、命令替换和计算运算的结果，如果它们不在双引号之间进行的。
@ 拆分过程
  shell会把$IFS中的每个字符都当成分隔符，并按照这些字符把其它扩展的结果拆分成单词。
@ IFS对拆分过程的影响
    1. 如果$IFS没有设置，或者它的值和默认的<space><tab><newline>完全一样。扩展结果的开头和结尾的<space><tab><newline>会被忽略。
其他位置的一串默认分隔符用来分隔操作。
    2. 如果IFS非默认值，则扩展结果中开始和结束的一连串的空格和tab也被忽略，就像空格字符也在$IFS中一样。
IFS中的其他字符用来作为 单词分割 的分隔符。一系列的空格也被当做是一个分隔符。
    3. 如果$IFS为空则不拆分单词
  1. 明确表示的空参数(""或'')会被保留下来。
  2. 由没有设置值的参数扩展后得到的未被引用的隐含空参数会被删除
  3. 如果没有设置值的参数在双引号之间扩展，则结果的空值会被保留

# newline 定义
N='
'
newline1='
'
newline2="
"
newline3=$'\n'

IFS的默认值设置
declare | grep IFS
IFS=$' \t\n'
EOF
}

bash_t_expand_word_splitting(){ cat - <<'EOF'
1. 可用于构建数组
arr=($(grep -o '[0-9]\+' file))

2. 进行for遍历
words='foo bar baz' 
for w in $words;do
  echo "W: $w"
done

[tr]
echo $sentence | tr " " "\n"

[IFS] 和 read
1. 读取整体文件到数组中
IFS=$'\n' read -r -a arr < file 
arr=()
while IFS= read -r line; do
  arr+=("$line")
done

2. 将","连接的单词分拆到数组中
my_param="foo,bar,bash"
IFS=',' read -r -a array <<< "$my_param"

3. 按照 ":" 获取/etc/passwd文件内容
while IFS=":" read -r user _
do
# "$user" holds the username in /etc/passwd
done < <(grep "hello" /etc/passwd)

4. 将"."连接的字母分拆出来
IFS=","
INPUTSTR="a,b,c,d"
for field in ${INPUTSTR}; do
    echo $field
done

[bad]
a='I am a string with spaces'
[ $a = $a ] || echo "didn't match"
[ $a = something ] || echo "didn't match"
[ $(grep . file) = 'something' ]
EOF
}

bash_p_expand_word_splitting(){ cat - <<'EOF'
提倡使用:
使用for in 实现字符串拆分成单词, 视为数据(表)驱动编程的一种实现.
while read实现文件拆分成行,      配合以 < 输入重定向, << here document < <() 进程替换转输入
while read实现行数据拆分成单词,  配合以 < 输入重定向, << here document < <() 进程替换转输入  <<< here string
while read实现行单词拆分成字母,  配合以 < 输入重定向, << here document < <() 进程替换转输入  <<< here string

使用 () 生成数组. 

避免 test
EOF
}
bash_i_expand_pathname_expansion(){ cat - <<'EOF'
8.文件名扩展：
  单词拆分以后，Bash在每个单词中搜索字符*、?、和[，
  1. 如果找到其中一个，则把这个单词当作一个模式，并把与之匹配的文件名按字母顺序排列来取代它。
  2. 如果没有找到匹配的文件名，并且禁止了Bash的nullglob选项，则不处理该单词；
  3. 如果打开了nullglob选项并且没有找到匹配的文件名，这个单词就会被删除。
  4. 如果打开了failglob选项并且没有找到匹配的文件名，则打印一条错误信息，并且不执行当前命令。
  5. 如果打开了nocaseglob选项，则匹配时不区分字母字符的大小写。
  6. 如果一个模式用于生成文件名，则对于文件名开头或紧跟在斜杠后面的"."必须明确匹配，除非打开了Bash的dotglob选项。
  GLOBIGNORE环境变量：可以用来限制匹配的文件名。
    1.如果设置了GLOBIGNORE，并且匹配的文件名中又与GLOBIGNORE中的模式匹配的，将会从列表中删除。
    2.如果设置了GLOBIGNORE，并且它的值不为空，则文件名"."和".."总是被忽略。
    3.但同时，给GLOBIGNORE设置一个非空的值会让bash的dotglob选项也生效，使得所有以"."开头的文件名也会被匹配。
     为了像以往一样忽略以"."开头的文件名，可以让".*"成为GLOBIGNORE的模式之一。如果没有设置GLOBIGNORE，则dotglob也会被取消。
  *  匹配任何字符串，包括空字符串。globstar
  ?  匹配任意单个字符。
  [] 匹配方括号中的任一字符。
     1.如果"["之后的第一个字符是"!"或者"^",这匹配没有出现的任意一字符。
     2.如果要匹配"-"，可以把它放在方括号中第一个或最后一个位置
     3.如果要匹配"]"，可以把它放在方括号中的一个位置
     4.  alnum 匹配所有字母和数字
         alpha 匹配所有字母
         ascii 匹配所有(ASCII)字符
         blank 匹配所有空白符
         cntrl 匹配所有控制字符(即ASCII中的二十个字符)
         digit 匹配所有的数字(0-9)
         graph 匹配所有可显示字符(可打印字符中，空格和退格符不可显示)
         lower 匹配所有小写字母
         print 匹配可打印字符(非控制字符都可打印)
         punct 匹配所有标点符号
         space 匹配空格
         upper 匹配所有大写字母
         word  匹配单词里面的字符(大小写字母)
         xdigit 匹配所有十六进制数字(0-9和A-F)
    extglob
        ?(pattern-list) 匹配0个或者1个pattern-list
        *(pattern-list) 匹配0个或者多个pattern-list
        +(pattern-list) 匹配1个或者多个pattern-list
        @(pattern-list) 匹配1个pattern-list
        !(pattern-list) 匹配不符合pattern-list模式
        ls +(ab|def)*.+(jpeg|gif) # 列出当前目录下以“ab”或者“def”打头的JPEG或者GIF文件
        ls ab+(2|3).jpg           # 列出当前目录下匹配与正则表达式ab(2|3)+\.jpg相同匹配结果的所有文件
        rm -rf !(*.jpeg|*.gif)    # 删除当前目录下除了以jpeg或者gif为后缀的文件
        ls !(+(ab|def)*.+(jpeg|gif))
EOF
}
bash_i_expand_quote_removal(){ cat - <<'EOF'
9.引用去除;经过上述扩展以后，对于所有没有被引用的字符'\'、"'"、以及'"'，如果它们不是由上述任何一种扩展产生的，就会被删除。

EOF
}
bash_i_expand_redirect(){ cat - <<'EOF'
重定向:/dev/tcp/主机名/端口号
       /dev/udp/主机名/端口号
       要谨慎使用比9大的文件描述符进行重定向，因为它们可能会和Bash内部使用的文件描述符相冲突。
输入重定向: [n]<单词
输入重定向会打开单词扩展后所形成的文件名以备读取，并将其作为文件描述符n；如果没有指定n则将其作为标准输入
输出重定向:  [n]>[|]单词
输出重定向会打开单词扩展后所形成的文件名以备写入，并将其作为文件描述符n；如果没有指定n则将其作为标准输出

# <<[-]单词
即插即用文本
单词
  1. 单词不会进行参数扩展，命令替换，算术扩展，或文件名扩展。
  2. 如果单词中任一字符被引用，则结束符是单词进行引用去除后的结果，这时不会对即插即用文本进行扩展。
  3. 如果单词没有被引用，则即插即用文本中的所有行都会进行参数扩展、命令替换、和算术扩展；
  4. 如果重定向运算符是"<<-"，则输入行和结束符所在行中所有的在行开头的制表符都会被删除。
文件描述符的拷贝
  [n]<&单词:用来复制输入描述符；如果单词是一个或多个数字，则文件描述符n就是与这个数字对应的文件描述符拷贝。
  [n]>&单词:用来复制输出描述符；
文件描述符的移动
  [n]<&数字- 把文件描述符数字转移到文件描述符n上；如果没有指定n，则转移到标准输入(文件描述符为0)上。转移到n后，(文件描述符)数字就会被关闭。
  [n]>&数字- 把文件描述符数字转移到文件描述符n上；如果没有指定n，则转移到标准输出(文件描述符为1)上
打开文件描述符以备读出和写入
  [n]<>单词
  可以打开单词扩展后的文件名以同时准备读取和写入，其文件描述符为n；如果没有指定n，则使用文件描述符0。如果文件不存在，则首先创建它。
EOF
}
bash_i_variable_parameter(){ cat - <<'EOF'
$0 当前脚本的名称
$# 传递给脚本或函数的参数个数
$* 传递给脚本或函数的所有参数
$@ 传递给脚本或函数的所有参数。被双引号""包含时，与 $* 稍有不同，
$? 上个命令的退出状态，或函数的返回值。
$$ 当前Shell进程ID。对于 Shell 脚本，就是这些脚本所在的进程ID。
$n 传递给脚本或函数的参数。n 是一个数字，表示第几个参数。例如，第一个参数是$1，第二个参数是$2。
$! 展开为最后一个放入后台进程的PID
*  作为匹配文件名扩展的一个通配符，能自动匹配给定目录下的每一个文件。
~  波浪号(Home directory[tilde])，这个和shell环境变量$HOME是一样的。默认表示当前用户的家目录(主目录)
-- 与~相同，表示当前用户的家目录（主目录）
~+ 当前的工作目录(current working directory)。这个和shell环境变量$PWD一样。
~- 前一个工作目录(previous working directory)。这个和内部变量$OLDPWD一致，和减号-一样。
-  减号。和~-一样，表示前一个工作目录。
ls *.sh;echo $_ # 显示最后一个数据内容
EOF
}

bash_i_variable_string(){ cat - <<'EOF'
$       美元符,放在变量前用于取变量的值，比如$PATH
${}     美元符加上大括号，大括号中放变量的名称，也是用于读取变量的值
${:-}   用法${var:-word}。表示如果变量 var 为空或已被删除(unset)，那么返回 word，但不改变 var 的值。
${:+}   用法${var:+word}。如果变量 var 被定义，那么返回 word，但不改变 var 的值。
${:=}   用法${var:=word}。如果变量 var 为空或已被删除(unset)，那么返回 word，并将 var 的值设置为 word。
${:?}   用法${var:?message}。如果变量 var 为空或已被删除(unset)，那么将消息 message 送到标准错误输出
${#}    用法${#var}。获取字符串变量var的长度
${:}    字符串提取，用法${var:n}。若n为正数，n从0开始，表示在变量var中提取第n个字符到末尾的所有字符。
                                  若n为负数，提取字符串最后面n的绝对值个字符，
        使用时在冒号后面加空格或一个算术表达式或整个num加上括号，如${var: -2}、${var:1−3}或 ${var:(-2)}均表示提取字符串最后两个字符。
${::}   字符串提取，用法${var:n1:n2}。
{,}     用法${value1,value2,value3}。逗号分割一般用于文件列表的扩展。  echo {a,b}.txt，输出a.txt b.txt。
{-}     用法${value1-value2}。用于顺序扩展。
${#}    模式匹配截断，用法${variable#pattern} 这种模式时，shell在variable中查找给定的模式pattern，
        如果找到，就从命令行把variable中的内容去掉左边最短的匹配模式。不改变原变量。
${##}   模式匹配截断，用法${variable##pattern} 这种模式时，shell在variable中查找给定的模式pattern，
        如果是存在，就从命令行把variable中的内容去掉左边最长的匹配模式。不改变原变量。
${%}    模式匹配截断，用法${variable%pattern}，这种模式时，shell在variable中查找，看它是否一给的模式pattern结尾，
        如果是，就从命令行把variable中的内容去掉右边最短的匹配模式。不改变原变量。
${%%}   模式匹配截断，用法${variable%%pattern}，这种模式时，shell在variable中查找，看它是否一给的模式pattern结尾，
        如果是，就从命令行把variable中的内容去掉右边最长的匹配模式。不改变原变量。
${/ /}  模式匹配替换。${var/pattern/pattern}表示将var字符串的第一个匹配的pattern替换为另一个pattern。不改变原变量。
${// /} 模式匹配替换。${var//pattern/pattern}表示将var字符串中的所有能匹配的pattern替换为另一个pattern。不改变原变量。
$[]     整数扩展(integer expansion)，在方括号内执行整数表达式并返回结果。
EOF
}

bash_t_string_default(){ cat - <<'EOF'
未指定环境变量时，使用指定环境变量
[ -z "${COLUMNS:-}" ] && COLUMNS=80                              未指定时设置变量 默认值
[ -z "${CONSOLETYPE:-}" ] && CONSOLETYPE="$(/sbin/consoletype)"  未指定时设置变量 默认值
if [ -z "${BOOTUP:-}" ]; then                                    判断变量是否设置
[ -n "${NICELEVEL:-}" ] && nice="nice -n $NICELEVEL"             指定时就使用指定值

未指定pid保存文件的时候，使用默认pid文件
local pid_file=${2:-/var/run/$base.pid}                          未指定时就       指定默认值

未指定参数的时候，使用默认的killlevel
[ -n "${2:-}" ] && killlevel=$2                                  指定时就使用指定值


未指定环境变量时，使用指定环境变量
pidfile=${PIDFILE-/var/run/svnserve.pid}
lockfile=${LOCKFILE-/var/lock/subsys/svnserve}

防止文件重复引用
[ -z "${RUNNER_LOADED:-}" ] || return 0
RUNNER_LOADED=0
EOF
}

cat /dev/null <<'EOF'
    在 Bash 中，变量有许多的扩展方式。${name:?error message} 用于检查变量是否存在。
此外，当 Bash 脚本只需要一个参数时，可以使用这样的代码 input_file=${1:?usage: $0 input_file}。
如果你要在之前的例子中再加一个(可选的)参数，可以使用类似这样的代码 output_file=${2:-logfile}，
在变量为空时使用默认值：${name:-default}。
数学表达式：i=$(( (i + 1) % 5 ))。
序列：{1..10}。
截断字符串：${var%suffix} 和 ${var#prefix}。

mv foo.{txt,pdf} some-dir             # 同时移动两个文件
cp somefile{,.bak}                    # 会被扩展成 cp somefile somefile.bak
mkdir -p test-{a,b,c}/subtest-{1,2,3} # 会被扩展成所有可能的组合，并创建一个目录树

string='Question%20-%20%22how%20do%20I%20decode%20a%20percent%20encoded%20string%3F%22%0AAnswer%20%20%20-%20Use%20printf%20%3A)'
printf '%b\n' "${string//%/\\x}"
# Question - "how do I decode a percent encoded string?"
# Answer   - Use printf :)

echo "http%3A%2F%2Fwww.foo.com%2Findex.php%3Fid%3Dqwerty" | sed -e "s/%\([0-9A-F][0-9A-F]\)/\\\\\x\1/g" | xargs -0 echo -e


special(indirect_expanded){
$ red="the color red"
$ green="the color green"
$ color=red
$ echo "${!color}"
the color red
$ color=green
$ echo "${!color}"
the color green

$ foo=10
$ x=foo
$ echo ${x}      #Classic variable print  
foo  

$ foo=10
$ x=foo
$ echo ${!x}     #Indirect expansion
10

$ argtester () { for (( i=1; i<="$#"; i++ )); do echo "${i}";done; }; argtester -ab -cd -ef
1   #i expanded to 1
2   #i expanded to 2
3   #i expanded to 3
$ argtester () { for (( i=1; i<="$#"; i++ )); do echo "${!i}";done; }; argtester -ab -cd -ef
-ab     # i=1 --> expanded to $1 ---> expanded to first argument sent to function
-cd     # i=2 --> expanded to $2 ---> expanded to second argument sent to function
-ef     # i=3 --> expanded to $3 ---> expanded to third argument sent to function
}
EOF


bash_i_string_quotes(){ cat - <<'EOF'
\   反斜杠，用于转义。
    如果反斜线后面跟着一个换行，并且反斜线未被引用，则换行仍有特殊意义--表示一个续行
\a  警报，响铃
\b  退格（删除键）
\f  换页(FF)，将当前位置移到下页开头
\n  换行
\r  回车
\t  水平制表符（tab键）
\v  垂直制表符
\c  produce no further output，不产生进一步的输出。也就是说在\c后，这一行后面的内容都不会输出，直接删掉了
echo -e "this is line1 \c these word will disappear"  # this is line1
EOF
}

bash_p_operator(){ cat - <<'EOF'
#   #号。注释符号。在shell文件的行首，作为include标记，#!/bin/bash;其他地方作为注释使用。
;   分号。语句的分隔符。在shell文件一行写多条语句时，使用分号分割。
;;  双分号。在使用case选项的时候，作为每个选项的终结符。
/   斜杠。路径的分隔符，路径中仅有一个斜杆表示根目录，以斜杆开头的路径表示从根目录开始的路径。
|   管道(pipe)。
>   输出重定向。
>>  输出重定向追加符。
>&  输出重定向等同符，作用于文件描述符，即左右两边的操作数是文件描述符
    echo lvlv>file 2>&1,标准输出重定向到文件file中，标准错误输出与标准输出重定向一致
&>  标准输出和标准错误输出重定向符。
    echo lvlv &>file,标准输出和标准错误输出都重定向到文件file中，与echo lvlv 1>file 2>&1 功能相同
<   输入重定向
<<  用法格式： # cmd << text。从命令行读取输入，直到一个与text相同的行结束。
    除非使用引号把输入括起来，此模式将对输入内容进行shell变量替换。
    如果使用<<- ，则会忽略接下来输入行首的tab，结束行也可以是一堆tab再加上一个与text相同的内容。
<&  标准输入重定向等同符，作用于文件描述符，即左右两边的操作数是文件描述符
    cmd <& m,将文件描述符m作为cmd的输入，省略了标准输入描述符1，即等价于cmd 1<&fd
>&- 关闭某个输出文件描述符。用法格式：exec fd>&-
    exec >&-或exec 0>&-，关闭标准输出
<&- 关闭某个输入文件描述符。用法格式：exec fd>&- 
    exec <&-或exec 1<&-关闭标准输入
&   与号。如果命令后面跟上一个&符号，这个命令将会在后台运行。 
    使用格式：command&
/   斜杠。主要有两种作用。
    1. 作为路径的分隔符，路径中仅有一个斜杆表示根目录，以斜杆开头的路径表示从根目录开始的路径；
    2. 在作为运算符的时候，表示除法符号。
()  一对小括号。主要有两种用法：
    1. 命令组。括号中的命令将会新开一个子shell顺序执行，所以括号中的变量不能够被脚本余下的部分使用。
       括号中多个命令之间用分号隔开，最后一个命令可以没有分号，各命令和括号之间不必有空格。
    2. 用于初始化数组。如：array=(a b c d)
{}  一对大括号，代码块标识符。一般用于函数定义时表明函数体。
<<< 三个小于号，作用就是将后面的内容作为前面命令的标准输入。 
    grep a <<< "$VARIABLE", 意思就是在VARIABLE这个变量值里查找字符a。
>|  大于号与竖杠。功能同>，但即便设置了noclobber属性时也会强制复盖file文件。
<>  标准输入与输出重定向运算符 	exec 6<>filename,通过exec命令，以读写的方式将文件描述符6绑定到指定文件
EOF
}

bash_i_special_math(){ cat - <<'EOF'
+   加法  a=10;b=20;expr $a + $b结果为30。注意空格。
-   减法  expr $a - $b 结果为-10。
*   乘法  expr $a * $b 结果为200。
/   除法  expr $b / $a 结果为2。
%   取余  expr $b % $a 结果为 0。
=   赋值  a=$b，将把变量 b 的值赋给 a。
(()) 双小括号算术运算符，用于expr命令的替代，即支持算法表达式，而无需expr命令
    比如for((i=0;i<10;++i))或者((out=$a*$b))或者if(($a==$b));then ... fi，
    无需添加空格了，更加符合C的编程语法
**  双星号(double asterisk)。算术运算中表示求幂运算。
,   逗号运算符comma operator。用法主要有两个：
    1. 用在连接一连串的数学表达式中，这串数学表达式均被求值，但只有最后一个求值结果被返回。
    2. 用于参数替代中，表示首字母小写，如果是两个逗号，则表示全部小写，
    
let 变量名前不需要用$,如let result=no1+no2; echo $result
(()) 如result=$(( no1 + 50 )) 或 result=$ (( $no1 + 50 ))
[] 如result=$[ no1 + no2]  或  result=$[ $no1 + 5 ]
expr 如result=反引号expr 3 + 4反引号 或 result=$(expr $no1 + 5)
bc命令（支持浮点数）echo "scale=2;3/8" | bc 设置小数位数为2; echo "obase=2;$no" | bc将数字转化为2进制; echo "obase=10;ibase=2;$no" | bc 将二进制转化为十进制
EOF
}

bash_t_special_math(){ cat - <<'EOF'
[dc]
echo '2 3 + p' | dc       print an element from the top of the stack use command p
dc <<< '2 3 + p'          print an element from the top of the stack use command p
dc <<< '1 1 + p 2 + p'    print the top element many times
dc <<< '_1 p'             For negative numbers use _ prefix
dc <<< 'A.4 p'            use capital letters from A to F for numbers between 10 and 15 and . as a decimal point
dc <<< '4 3 / p'
dc <<< '2k 4 3 / p'       increase the precision using command k
dc <<< '4k 4 3 / p'

[(())]
echo $((5 * 2))    Multiplication
echo $((5 / 2))    Division
echo $((5 % 2))    Modulo
echo $((5 ** 2))   Exponentiation
echo $(( 1 + 2 ))
((a=$a+1)) #add 1 to a
((a = a + 1)) #like above
((a += 1)) #like above
if (( a > 1 )); then echo "a is greater than 1"; fi

bc is a preprocessor for dc.
echo '2 + 3' | bc
echo '12 / 5' | bc
echo '12 / 5' | bc -l
echo '8 > 5' | bc
echo '10 == 11' | bc
bc --mathlib <<< 'e(1)' # calculator math e power 
bc <<< '2+2' # calculator math 
bc <<< 'scale = 10; sqrt ( 2 )' # calculator math precision scale float decimal 

[expr]
expr 2 + 3
expr 2 \* 3
expr $a + 3

[let]
let num=1+2
let num="1+2"
let 'num= 1 + 2'
let num=1 num+=2

let num = 1 + 2 #wrong
let 'num = 1 + 2' #right
let a[1] = 1 + 1 #wrong
let 'a[1] = 1 + 1' #right
EOF
}
bash_k_builtin_test(){ cat - <<'EOF'
[]      一对方括号，用于判断条件是否成立                        
        [ $a == $b ]，注意添加4个空格
[[]]    两对方括号，是对[]的扩展，可使用<、>、&&、||等运算符  
        [[ $a>$b ]]，只需要添加左右两边两个空格，需要注意：使用==与!=时，仍需要4个空格
-eq     检测两个数是否相等，相等返回 true。                     
        [ $a -eq $b ] 返回 true。
==      检测两个数是否相等，作用同-eq    
        [ $a == $b ] 返回 true。
-ne     检测两个数是否相等，不相等返回 true。 
        [ $a -ne $b ] 返回 true。
!=      作用同-ne  
-gt     检测左边的数是否大于右边的，如果是，则返回 true。 
        [ $a -gt $b ] 返回 false。
-lt     检测左边的数是否小于右边的，如果是，则返回 true。 
        [ $a -lt $b ] 返回 true。
-ge     检测左边的数是否大等于右边的，如果是，则返回 true。 
        [ $a -ge $b ] 返回 false。
-le     检测左边的数是否小于等于右边的，如果是，则返回 true。
        [ $a -le $b ] 返回 true。
（1）运算符[]与[[]]的区别
[]实际上是bash 中 test 命令的简写。即所有的 [ expression ] 等于 test expression。而[[ expr ]]是bash中真正的条件判断语句，其语法更符合编程习惯，建议使用。
（2）shell中没有<=与>=运算符，只能使用-le与-ge替代

=       检测两个字符串是否相等，相等返回 true。       [ $a = $b ] 返回 false。
!=      检测两个字符串是否相等，不相等返回 true。     [ $a != $b ] 返回 true。
-z      检测字符串长度是否为0，为0返回 true。         [ -z $a ] 返回 false。
-n      检测字符串长度是否为0，不为0返回 true。       [ -z $a ] 返回 true。
str     检测字符串是否为空，不为空返回 true。         [ $a ] 返回 true。
=~      正则表达式匹配运算符，用于匹配正则表达式的,配合[[]]使用  if [[ ! $file =~ check$ ]],用于判断$file是否是以check结尾
EOF
}
bash_t_builtin_test(){ cat - <<'EOF'
[[ 
if [[ "$DHCPRELEASE" = [yY1]* ]];  then
if [[ ! "$line" =~ $MATCH ]]; then
if [[ "${DEVICE}" =~ $MATCH ]]; then
if (LC_ALL=C; [[ ! "$DEVNUM" =~ $MATCH ]]); then
if [[ "${opts}" =~ [[:space:]]*- ]]; then
if [[ "$s" = *$1* ]]; then
if [[ "$s" = *$1* ]]; then
不进行单词拆分，获取变量值可以不加双引号          $MATCH
不进行路径名扩展                                  
支持算术运算，不需要用 $((expr)) 进行扩展         
==、=、!= 操作符支持使用通配符进行模式匹配        "$s" = *$1* 
=~ 操作符支持判断字符串包含关系                   "${DEVICE}" =~ $MATCH
=~ 操作符支持扩展正则表达式                       "${opts}" =~ [[:space:]]*-
使用 && 操作符进行与操作                          
使用两个竖线操作符进行或操作                      
不需要对小括号转义，也不用加引号                  
不需要对 <、> 转义、也不用加引号                  
用 <、> 比较字符串时，使用当前语言环境的编码集    

[ test
进行单词拆分，获取变量值建议加上双引号
进行路径名扩展，要对路径名扩展特殊字符进行转义
不支持，要使用 $((expr)) 算术扩展获取运算结果
不支持使用通配符模式匹配
使用 -a 操作符进行与操作
使用 -o 操作符进行或操作
需要对小括号转义、或者加引号
需要对 <、> 转义、或者加引号
用 <、> 比较字符串时，使用 ASCII 编码集
EOF
}

bash_p_comments(){
 cat - <<'EOF'
1.单行注释
shell中使用 # 进行单行注释。
2.多行注释
# :<<[字符] #这里的字符可以是数字或者是字符都可以 
语句1 
语句2 
[字符] 
#比如 
:<<!
语句1
语句2
!
#或者
:<<0
语句1
语句2
0

方法二
if false;then 
语句1 
语句2 
fi

方法三
只需要将第一个条件置为false，那么后面的大括号的内容将不会被执行，达到了多行注释的效果。
((0)) & {
语句1
语句2
}

类似的写法还有：
[ 0 -eq 1 ]&&{
语句1
语句2
}

方法四
while false;do
语句1
语句2
done

方法五
for((;false;));do
语句1
语句2
done
EOF
}

bash_t_short_snippet(){ cat - << 'EOF'
1. 更短的for循环语法
# Tiny C风格.
for((;i++<10;)){ echo "$i";}
# 未记载的方法.
for i in {1..10};{ echo "$i";}
# 扩展.
for i in {1..10}; do echo "$i"; done
# C语言风格.
for((i=0;i<=10;i++)); do echo "$i"; done

2. 更短的无限循环
# 普通方法
while :; do echo hi; done
# 更短的方式
for((;;)){ echo hi;}

3. 更短的函数声明
# 普通方法
f(){ echo hi;}
# 用于子shell
f()(echo hi)
# 用于四则运算
# 这可以被用来分配整数值。
# Example: f a=1
#          f a++
f()(($1))
# 用作测试，循环等
# NOTE: ‘while’, ‘until’, ‘case’, ‘(())’, ‘[[]]’ 也可以使用.
f()if true; then echo "$1"; fi
f()for i in "$@"; do echo "$i"; done

4. 更短的if语法
# 一行
# Note: 当第一段是正确时执行第三段
# Note: 此处利用了逻辑运算符的短路规则
[[ $var == hello ]] && echo hi || echo bye
[[ $var == hello ]] && { echo hi; echo there; } || echo bye

# 多行（没有else，单条语句）
# Note: 退出状态可能与if语句不同
[[ $var == hello ]] &&
    echo hi

# 多行 (没有 else)
[[ $var == hello ]] && {
    echo hi
    # ...
}

5. 用case语句来更简单的设置变量
内置的：可以用来避免在case语句中重复的实用variable =。 $ _变量存储最后一个命令的最后一个参数。 ：总会成功，所以它可以用来存储变量值。

case "$OSTYPE" in
    "darwin"*)
        : "MacOS"
    ;;

    "linux"*)
        : "Linux"
    ;;

    *"bsd"* | "dragonfly" | "bitrig")
        : "BSD"
    ;;

    "cygwin" | "msys" | "win32")
        : "Windows"
    ;;

    *)
        printf '%s\n' "Unknown OS detected, aborting..." >&2
        exit 1
    ;;
esac

# 最后，获取变量值.
os="$_"

# 有3种方法可以使用，任何一种都正确。 
type -p executable_name &>/dev/null 
hash executable_name &>/dev/null 
command -v executable_name &>/dev/null

# 用作检测.
if type -p executable_name &>/dev/null; then
    # Program is in PATH.
fi

# 反向检测.
if ! type -p executable_name &>/dev/null; then
    # Program is not in PATH.
fi

# 示例（如果未安装程序，则提前退出）.
if ! type -p convert &>/dev/null; then
    printf '%s\n' "error: convert is not installed, exiting..."
    exit 1
fi

绕过shell别名
# alias
ls

# command
# shellcheck disable=SC1001
\ls

绕过shell函数
# function
ls

# command
command ls
command命令 调用指定的指令并执行，命令执行时不查询shell函数。command命令只能够执行shell内部的命令。
    
EOF
}

bash_t_redirection(){ cat - << 'EOF'
那么2>&1 >/dev/null 与 >/dev/null 2>&1 的区别是什么呢？
command >/dev/null 2>&1 相当于
stdout="/dev/null"
stderr=$stdout
这时，stderr也等于"/dev/null"了
结果是标准输出和标准错误都指向了/dev/null， 也就是所有的输出都被我们丢弃。

command 2>&1 >/dev/null 相当于
stderr=$stdout #stderr指向了屏幕，因为stdout这时还是指向屏幕！
stdout="/dev/null" #stdout指向了/dev/null，但不会影响到 stderr的指向
结果是标准错误仍然被打印到屏幕上， 而标准输出被丢弃。

<(some command) 可以将输出视为文件。
diff /etc/hosts <(ssh somehost cat /etc/hosts) # 对比本地文件 /etc/hosts 和一个远程文件

# 重定向被当前的bash初始化，而不是被当前执行的命令初始化。因此，重定向命令在命令执行前执行。
内建文件描述符  数字
重定向          > < <>
外部文件描述符或路径 &1 作为文件描述符或路径
> file.txt ls 或 ls >file.txt 或 ls 1>file.txt

echo 'hello' > /dev/null 2>&1
echo 'hello' &> /dev/null

# Actual code
echo 'hello' &> /dev/null
echo 'hello' &> /dev/null 'goodbye'
# Desired behavior
echo 'hello' > /dev/null 2>&1
echo 'hello' 'goodbye' > /dev/null 2>&1
# Actual behavior
echo 'hello' &
echo 'hello' & goodbye > /dev/null

exec 3</dev/tcp/www.google.com/80
printf 'GET / HTTP/1.0\r\n\r\n' >&3
cat <&3
printf 'HI\n' >/dev/udp/192.168.1.1/6666

err(){
  echo "E: $*" >>/dev/stderr
}
err "My error message"
EOF
}

bash_i_redirection(){ cat - << 'EOF'
cmd >    file    Redirect the standard output (stdout) of cmd to a File.
cmd 1>   file    Same as cmd > file. 1 is the default File descriptor (fd) for stdout.
cmd 2>   file    Redirect the standard error (stderr) of cmd to a File. 2 is the default fd for stderr.
cmd >>   file    Append stdout of cmd to a File.
cmd 2>>  file    Append stderr of cmd to a File.
cmd &>   file    Redirect stdout and stderr of cmd to a File.
cmd > file 2>&1  Another way to redirect both stdout and stderr of cmd to a File. 
                 This is not the same as cmd 2>&1 > file. Redirection order matters!
cmd > /dev/null  Discard stdout of cmd.
cmd 2> /dev/null Discard stderr of cmd.
cmd &> /dev/null Discard stdout and stderr of cmd.
cmd < file       Redirect the contents of the file to the standard input (stdin) of cmd.
cmd << EOL
line1
line2
EOL
Redirect a bunch of lines to the stdin. If 'EOL' is quoted, text is treated literally. This is called a here-document.
cmd <<- EOL
<tab>foo
<tab><tab>bar
EOL
Redirect a bunch of lines to the stdin and strip the leading tabs.
cmd <<< "string" Redirect a single line of text to the stdin of cmd. This is called a here-string.
exec 2>   file  Redirect stderr of all commands to a file forever.
exec 3<   file  Open a file for reading using a custom file descriptor.
exec 3>   file  Open a File for writing using a custom file descriptor.
exec 3<>  file  Open a file for reading and writing using a custom file descriptor.
exec 3>&-       Close a file descriptor.
exec 4>&3       Make file descriptor 4 to be a copy of file descriptor 3. (Copy fd 3 to 4.)
exec 4>&3-      Copy file descriptor 3 to 4 and close file descriptor 3.
echo "foo" >&3  Write to a custom File descriptor.
cat <&3         Read from a custom file descriptor.
(cmd1; cmd2) > file     Redirect stdout from multiple commands to a file (using a sub-shell).
{ cmd1; cmd2; } > file  Redirect stdout from multiple commands to a file (faster; not using a sub-shell).
exec 3<> /dev/tcp/host/port    Open a TCP connection tohost:port. (This is a bash feature, not Linux feature).
exec 3<> /dev/udp/host/port    Open a UDP connection tohost:port. (This is a bash feature, not Linux feature).
cmd <(cmd1) Redirect stdout of cmd1 to an anonymous fifo, then pass the fifo to cmd as an argument.
            Useful when cmd does not read from stdin directly.
cmd < <(cmd1)  Redirect stdout of cmd1 to an anonymous fifo, then redirect the fifo to stdin of cmd.
               Best example:diff <(find /path1 | sort) <(find /path2 | sort).
cmd <(cmd1) <(cmd2)
                   Redirect stdout of cmd1 and cmd2 to two anonymous fifos, then pass both fifos as arguments tocmd.
cmd1 >(cmd2)       Run cmd2 with its stdin connected to an anonymous Fifo, and pass the filename of the pipe as an argument to cmd1.
cmd1 > >(cmd2)     Run cmd2 with its stdin connected to an anonymous fifo, then redirect stdout of cmd to this anonymous pipe.
cmd1 | cmd2        Redirect stdout of cmd1 to stdin of cmd2. Pro-tip: This is the same as cmd1 > >(cmd2),
                   same as cmd2 < <(cmd1), same as > >(cmd2) cmd1, same as < <(cmd1) cmd2.
cmd1 |& cmd2       Redirect stdout and stderr ofcmd1 to stdin of cmd2 (bash 4.0+ only). Use
cmd1 2>&1 |        cmd2for older bashes.
cmd | tee file     Redirect stdout of cmdto a File and print it to screen.
exec {filew}> file Open a File for writing using a named File descriptor called{filew}(bash 4.1+).
cmd 3>&1 1>&2 2>&3 Swap stdout and stderr ofcmd.
cmd > >(cmd1) 2> >(cmd2) Send stdout ofcmdtocmd1and stderr ofcmdtocmd2.
cmd1 | cmd2 | cmd3 | cmd4
echo ${PIPESTATUS[@]}
Find out the exit codes of all piped commands.

1. 输出重定向是 sh 语言的一部分，不是命令的一部分，所以输出重定向可以在命令开头也可以在结尾。
2. 输入重定向是数据(表)驱动编程(测试)的核心，表驱动编程抽象了数据处理过程，降低了代码扩展性。
3. 设计脚本就是规范化输入输出和返回值。重定向是输入输出设计的提升。
4. 函数，命令组和$(命令替换), read, exec 都是对输入输出重定向到规范性设计。 
EOF
}

bash_i_redirection_cheat(){ cat - << 'EOF'
cmd1|cmd2            # pipe; takes standard output of cmd1 as standard input to cmd2
> file               # directs standard output to file
< file               # takes standard input from file
>> file              # directs standard output to file; append to file if it already exists
>|file               # forces standard output to file even if noclobber is set
n>|file              # forces output to file from file descriptor n even if noclobber is set
<> file              # uses file as both standard input and standard output
n<>file              # uses file as both input and output for file descriptor n

[n]<<[-]word         # here-document
  here-document
delimiter

[n]<<< word          # here-string

<()                  # process substitution

n>file               # directs file descriptor n to file
n<file               # takes file descriptor n from file
n>>file              # directs file description n to file; append to file if it already exists

n>&                  # duplicates standard output to file descriptor n
n<&                  # duplicates standard input from file descriptor n
n>&m                 # file descriptor n is made to be a copy of the output file descriptor
n<&m                 # file descriptor n is made to be a copy of the input file descriptor
&>file               # directs standard output and standard error to file

<&-                  # closes the standard input
>&-                  # closes the standard output
n>&-                 # closes the ouput from file descriptor n
n<&-                 # closes the input from file descripor n

# dash: redirection from   stdin to stdout  or  stdout to stdin
cat -                           # redirects from stdin to stdout
echo "whatever" | cat -         # redirects from stdin to stdout
grep "foo" file | diff file2 -
EOF
}

bash_ii_redirection(){ cat - << 'EOF'
第1章 重定向
/dev/fd/fd  如果 fd 是一个合法的整数，文件描述符 fd 将被复制。
/dev/stdin  文件描述符 0 被复制。
/dev/stdout 文件描述符 1 被复制。
/dev/stderr 文件描述符 2 被复制。
/dev/tcp/host/port  bash 试图建立与相应的socket (套接字) 的 TCP 连接
/dev/udp/host/port  bash 试图建立与相应的socket (套接字) 的 TCP 连接

重定向输入: [n]<word
重定向输入使得以 word 扩展结果为名的文件被打开并通过文件描述符 n 读取，如果没有指定 n 那么就作为标准输入(文件描述符为0)读取。
重定向输出: [n]>word
重定向输出使得以 word 扩展结果为名的文件被打开并通过文件描述符 n 写入，如果没有指定 n 那么就作为标准输出 (文件描述符为 1)写入。
noclobber 与 >| # 文件名存在并且是一个普通的文件，重定向将失败。
添加到重定向后的输出尾部: [n]>>word
这种方式的输出重定向使得以 word 扩展结果为名的文件被打开并通过文件描述符 n 从尾部添加。
如果没有指定 n 就使用标准输出(文件描述符 1)。如果文件不存在，它将被创建。
标准输出和标准错误  重定向输出: 1. &>word 2. >&word 3. >word 2>&1

复制文件描述符: 1. 重定向操作符 [n]<&word 2. [n]>&word
如果 word 扩展为一个或多个数字，n 代表的文件描述符将成为那个文件描述符的复制。
如果 word 中的数字并未指定一个被用于读取的文件描述符，将产生一个重定向错误。
如果 word 扩展为 -, 文件描述符 n 将被关闭。如果没有指定 n，将使用标准输入 (文件描述符 0)。

移动为文件描述符: 1. [n]<&digit- 2. [n]>&digit- 
将文件描述符 digit 移动为文件描述符 n, 或标准输入 (文件描述符 0)，如果没有指定 n 的话。digit 复制为 n 之后就被关闭了。

打开输入输出：[n]<>word
使得以 word 扩展结果为名的文件被打开，通过文件描述符 n 进行读写。如果没有指定 n 那么就使用文件描述符0。如果文件不存在，它将被创建。
 
command | tee FILE1 FILE2 接收来自stdin的数据，将副本写入FILE1和FILE2,同时也将副本左后后续命令的stdin
cmd - 将stdin作为命令参数

[command] < <([command list])       # File Redirection and Process Substitution
[command] <<< "$([command list])"   # Here-String and Command Substitution
EOF
}

cat /dev/null << 'EOF'
[ $EUID = 0 ] || exit 4                     # 如果EUID不为0，则退出shell
[ ! -e "$PROC_IPTABLES_NAMES" ] && return 0 # 如果/proc/net/ip_tables不存在，则退出函数

[ "x$IPTABLES_SAVE_COUNTER" = "xyes" ] && OPT="-c" # ${IPTABLES_SAVE_COUNTER:+-c}
[ -z "${COLUMNS:-}" ] && COLUMNS=80                # if [ -z "${COLUMNS:-}" ]; then COLUMNS=80 fi
[[ $2 ]] && echo "$2" #  [[]] 的判断 if [[ $2 ]] ; then echo "$2" fi

"<command> && <if_success_run_this_command_too> || true"
"<command> || <if_not_success_run_this_command_too> || true"
这里末尾的"|| true"是需要的，它可以保证这个 shell 脚本在不小心使用了"-e"选项而被调用时不会在该行意外地退出。

command ls              # 忽略 alias 直接执行程序或者内建命令 ls
builtin cd              # 忽略 alias 直接运行内建的 cd 命令
enable                  # 列出所有 bash 内置命令，或禁止某命令
help {builtin_command}  # 查看内置命令的帮助(仅限 bash 内置命令)
eval $script # 对 script 变量中的字符串求值(执行)

 典型 bashism 语法列表
-------------------------------|----------------------------------|
好的：POSIX                    | 应该避免的：bashism              |
if [ "$foo" = "$bar" ] ; then …|  if [ "$foo" == "$bar" ] ; then …|
diff -u file.c.orig file.c     |  diff -u file.c{.orig,}          |
mkdir /foobar /foobaz          |  mkdir /foo{bar,baz}             |
funcname() { ... }               |  function funcname() { ... }   |
八进制格式："\377"             |  十六进制格式："\xff"            |
-------------------------------|----------------------------------|
使用 "echo" 命令的时候需要注意以下几个方面，因为根据内置 shell 和外部命令的不同，它的实现也有差别。
避免使用除"-n"以外的任何命令行选项。
避免在字符串中使用转义序列，因为根据 shell 不同，计算后的结果也不一样。
如果你想要在输出字符串中嵌入转义序列，用 "printf" 命令替代 "echo" 命令。

# 用于 shell 脚本的应用程序
"aptitude search ~E"，列出 必要的 软件包。
"dpkg -L <package_name> |grep '/man/man.*/'"，列出 <package_name> 软件包所提供的 man 手册。
EOF

bash_k_builtin_echo(){ cat - <<'EOF'
-e：打开反斜杠字符的解析，即对\n，\t等字符进行解析，而不视之为两个字符
-E：关闭反斜杠字符的解析，\n作为两个字符，这是系统缺省模式
-n：删除最后的换行
EOF
}

bash_t_builtin_echo_debug(){ cat - <<'EOF'
files=( * )
# iterate over them
for file in "${files[@]}"; do
  echo "$file"
done

runner_warn() { echo "runner:WARN $*" >&2; }
runner_error() { echo "runner:ERROR $*" >&2; }
runner_fatal() { echo "runner:FATAL $*" >&2; exit 1; }

th_trace() { echo "${MY_NAME}:TRACE $*" >&2; }
th_debug() { echo "${MY_NAME}:DEBUG $*" >&2; }
th_info() { echo "${MY_NAME}:INFO $*" >&2; }
th_warn() { echo "${MY_NAME}:WARN $*" >&2; }
th_error() { echo "${MY_NAME}:ERROR $*" >&2; }
th_fatal() { echo "${MY_NAME}:FATAL $*" >&2; }

sh4log 或者 slog
EOF
}

bash_k_builtin_printf(){ cat - <<'EOF'
%b：表示解析字符串的特殊的字符，包括\n等等。
    例如printf "%s\n" 'hello\nworld'，显示hello\nworld，要将\n作为换行符, 则需要用
        printf "%b\n" 'hello\nworld'。
%q：printf "%q\n" "greetings to the world"显示为greetings/ to/ the/ world, 可以作为shell的输入。
EOF
}

bash_t_builtin_printf(){ cat - <<'EOF'
printf "%s\n" *                # 输出当前目录所有文件
printf "%s\n" */               # 输出当前目录所有目录
printf "%s\n" *.{gif,jpg,png}  # 输出当前命令特定文件

echo "$(printf '*%.s' {1..40})"     # draw line seperator

printf "%q" "${pages}" 
printf "%q\n" *         # show non visible characters in file name e.g.

printf "\33c"           # clear screen
printf "\033c";

# arithmetic float
printf "%.3f\n" $((1+1/2))                      # 1.000
printf "%.3f\n" $( echo "1+1/2" | bc -l )       # 1.500
EOF
}

bash_t_builtin_redirect(){ cat - <<'EOF'
[Redirecting standard output]
ls >file.txt
> file.txt ls
ls 1>file.txt

[Append vs Truncate]
Truncate >
Append >>

[Redirecting both STDOUT and STDERR]
echo 'hello' > /dev/null 2>&1
echo 'hello' &> /dev/null

[Redirection]
python hello.py > output.txt   # stdout to (file)
python hello.py >> output.txt  # stdout to (file), append
python hello.py 2> error.log   # stderr to (file)
python hello.py 2>&1           # stderr to stdout
python hello.py 2>/dev/null    # stderr to (null)
python hello.py &>/dev/null    # stdout and stderr to (null)

python hello.py < foo.txt      # feed foo.txt to stdin for python

1>name 2>name
EOF
}

bash_t_named_redirect(){ cat - <<'EOF'
[pipe]
ls -l | grep ".log"

[redirect]
touch tempFile.txt
ls -l > tempFile.txt
grep ".log" < tempFile.txt

[named pipe]
mkfifo myPipe
ls -l > myPipe
grep ".log" < myPipe

[process inter]
mkfifo myPipe
echo "Hello from the other side" > myPipe
cat < myPipe

1. all commands on the same terminal / same shell
{ ls -l && cat file3; } >mypipe &
cat <mypipe

2. all commands on the same terminal / same shell
ls -l >mypipe &
cat file3 >mypipe &
cat <mypipe

3. all commands on the same terminal / same shell
{ pipedata=$(<mypipe) && echo "$pipedata"; } &
ls >mypipe

4. all commands on the same terminal / same shell
export pipedata
pipedata=$(<mypipe) &
ls -l *.sh >mypipe
echo "$pipedata"
EOF
}

bash_t_network_redirect(){ cat - <<'EOF'
exec 3</dev/tcp/www.google.com/80
printf 'GET / HTTP/1.0\r\n\r\n' >&3
cat <&3


printf 'HI\n' >/dev/udp/192.168.1.1/6666
EOF
}

bash_t_stderr_redirect(){ cat - <<'EOF'
err(){
  echo "E: $*" >>/dev/stderr
}

err "My error message"
EOF
}

bash_t_multicommand_redirect(){ cat - <<'EOF'
{
echo "contents of home directory"
ls ~
} > output.txt
EOF
}
bash_t_declare(){ cat - <<'EOF'
alias declare export local type
type # alias, keyword, function, builtin, or file

命令类型
declare [-aAfFilrtux] [-p] [name[=value] ...]  # l(convert NAMEs to lower) u(convert NAMEs to upper)

type -a declare         -- type -a typeset  # declare是内建命令
# list
declare                 -- typeset          # 显示所有变量的值和函数定义
declare -a                                  # 查看索引数组      declare -a  array    # 定义索引数组    
declare -A                                  # 查看关联数组      declare -A  Array    # 定义关联数组    
declare -r                                  # 查看所有只读变量  declare -r  const    # 定义所有只读变量
declare -f              -- typeset -f       # 显示所有函数定义
declare -F              -- typeset -F       # 显示所有函数名称
declare -p              -- typeset -p       # 显示所有变量的值
# display
declare -f func         -- typeset -f func  # 显示指定函数的定义
declare -p var          -- typeset -p var   # 显示指定变量var的值
# set
declare -r name         -- readonly name
                        -- typeset -r var   # 将变量var声明为只读变量。只读变量不允许修改，也不允许删除。
declare var=value       -- typeset var=value
                        -- var=value        # 声明变量并赋值
declare -i var          -- typeset -i var   # 将变量var定义成整数
declare -i              # 查看所有整数
# export
declare -x name         -- export name
declare -x name=VALUE   -- export name=VALUE  # 将变量var设置成环境变量，这样在随后的脚本和程序中可以使用。
declare -x # 查看所有被导出成环境变量的东西

# 在之后就可以直接对表达式求值，结果只能是整数。如果求值失败或者不是整数，就设置为0。
VAR=6/3; echo $VAR # 6/3
declare -i VAR; VAR=6/3; echo $VAR # 2 -> 如果变量被声明成整数，可以把表达式直接赋值给它，bash会对它求值。
declare -i VAR; VAR=error; echo $VAR # 0 -> 如果变量被声明成整数，把一个结果不是整数的表达式赋值给它时，就会变成0.
VAR=3.14  # 如果变量被声明成整数，把一个小数（浮点数）赋值给它时，也是不行的。因为bash并不内置对浮点数的支持。
declare +i VAR # 取消变量x的整数类型属性
declare -p VAR # declare -- VAR="1" ; 从整数类型转换成字符串类型
declare +[aA] ARRAY_NAME # declare不支持这种方式
echo $[6/3]    # 2
echo $((6/3))  # 2

declare -a var          -- typeset -a var   # 将变量var声明为数组变量。
# 所有变量都不必显式定义就可以用作数组。事实上，在某种意义上，似乎所有变量都是数组，而且赋值给没有下标的变量与赋值给"[0]"相同。
EOF
}

bash_t_alias(){ cat - <<'EOF'
别名可以看做函数的简要方式
alias print_things='echo "foo" && echo "bar" && echo "baz"'

alias ls='ls --color=auto'
设置别名之后，之后所有的ls命令输出都以 'ls --color=auto' 开头
除非使用如下方式:
1. command ls
2. /bin/ls
3. \ls 或 l\s
4. "ls" 或 'ls'

alias -p # 显示所有别名

unalias {alias_name} 删除别名

BASH_ALIASES bash内部的关联数组
echo There are ${#BASH_ALIASES[*]} aliases defined.
for ali in "${!BASH_ALIASES[@]}"; do
   printf "alias: %-10s triggers: %s\n" "$ali" "${BASH_ALIASES[$ali]}"
done
EOF
}

bash_p_variable_define(){ cat - <<'EOF'
shell变量=shell私有变量+用户环境变量
set      显示(设置)shell变量 包括shell私有变量以及用户环境变量 + 设置shell的选项和位置参数
         1. 改变shell的特性和位置参数；
         2. 显示shell的变量名和变量值
         3. 使用set更改shell特性时，符号"+"和"-"的作用分别是打开和关闭指定的模式。
         4. set命令不能够定义新的shell变量。如果要定义新的变量，可以使用declare命令以变量名=值的格式进行定义。
unset    删除已定义的shell变量(包括环境变量)和shell函数
         unset命令不能够删除具有只读属性的shell变量和环境变量
         unset [-f] [-v] [name ...]
env      显示(设置)用户环境变量；
         1. 显示系统中已存在的环境变量，以及在定义的环境中执行指令
         env [OPTION]... [NAME=VALUE]... [COMMAND [ARGS]...]
export   显示(设置)当前导出成用户变量的shell私有变量            shell私有变量导出的环境变量
readonly 不能修改；不能删除；
         可以导出为环境变量，也可以取消导出用户环境变量
         只读属性支持变量、索引数组和关联数组
         readonly [-aAf] [name[=value] ...] or readonly -p
declare  显示(设置)变量的特性和值
local    定义一个本地变量；local [option] 名称[=值] ... option可以是declare支持的选项

# Constant
readonly PATH_TO_FILES='/some/path'

# Both constant and environment
declare -xr ORACLE_SID='PROD'

shell变量 分 shell私有变量(set)，用户环境变量(env)， shell变量包含用户环境变量，
export是一种命令工具，通过export把shell私有变量导出作为用户环境变量
EOF
}


bash_t_export(){ cat - <<'EOF'
export [-fn] [名称[=值] ...] 或 export -p
[export vs declare] 
export -p          # 打印当前导出的用户环境变量                     declare -x -p
export VAR         # 导出用户环境变量VAR                            declare -x VAR
export VAR=VALUE   # 设置shell私有变量，并导出用户环境。            declare -x VAR=VALUE
export -n VAR      # 取消导出用户环境变量VAR。                      declare +x VAR
unset VAR          # 删除shell私有变量VAR(同时删除用户私有环境变量) 
set -a VAR         # 导出用户环境变量VAR                            

[export vs set|unset] 
aaa=bbb           # shell变量设定
set | grep aaa    # aaa=bbb
env | grep aaa    # 不在env环境变量中
export | grep aaa # 不在导出环境变量中

export aaa         # 导出aaa shell变量
set | grep aaa     # aaa=bbb
env | grep aaa     # aaa=bbb
export | grep aaa  # declare -x aaa="bbb"

export -n aaa      # 删除导出环境变量
set | grep aaa     # aaa=bbb
env | grep aaa     # 不在env环境变量中
export | grep aaa  # 不在导出环境变量中

unset aaa          # 删除shell变量
set | grep aaa     # 不在shell变量中
env | grep aaa     # 不在env环境变量中
export | grep aaa  # 不在导出环境变量中

[export vs readonly] 
readonly aaa=bbb  # 设置只读变量
export aaa        # 只读变量可以导出
export -n aaa     # 只读变量可以删除导出
unset aaa         # cannot unset: readonly variable

readonly bbb=(111 222 333) # 只读数组
declare -p bbb             # declare -ar bbb='([0]="111" [1]="222" [2]="333")'
bbb[4]="4444"              # 只读数组不能修改
bbb+=(4444)                # 只读数组不能修改
EOF
}

bash_t_string_substr(){  cat - <<'EOF'
string=01234567890abcdefgh
echo ${string:7}    # 7890abcdefgh
echo ${string:7:0}  #
echo ${string:7:2}  # 78
echo ${string:7:-2} # 7890abcdef
echo ${string: -7}  # bcdefgh
echo ${string: -7:0} # 
echo ${string: -7:2} # bc
echo ${string: -7:-2} # bcdef

var='0123456789abcdef'
printf '%s\n' "${var:3}" # 3456789abcdef
printf '%s\n' "${var:3:4}" # 3456
printf '%s\n' "${var:3:-5}" # 3456789a
printf '%s\n' "${var: -6}"  # abcdef
printf '%s\n' "${var:(-6)}" # abcdef
printf '%s\n' "${var: -6:-5}" # a

array[0]=01234567890abcdefgh
echo ${array[0]:7}     # 7890abcdefgh
echo ${array[0]:7:0}   #
echo ${array[0]:7:2}   # 78
echo ${array[0]:7:-2}  # 7890abcdef
echo ${array[0]: -7}   # bcdefgh
echo ${array[0]: -7:0} # 
echo ${array[0]: -7:2} # bc
echo ${array[0]: -7:-2} # bcdef
EOF
}

bash_t_string_substr_set(){  cat - <<'EOF'
set -- 01234567890abcdefgh
echo ${1:7}     # 7890abcdefgh
echo ${1:7:0}   #
echo ${1:7:2}   # 78
echo ${1:7:-2}  # 7890abcdef
echo ${1: -7}   # bcdefgh
echo ${1: -7:0} # 
echo ${1: -7:2} # bc
echo ${1: -7:-2} # bcdef
EOF
}

bash_t_arrray_subarray_set(){  cat - <<'EOF'
如果parameter是@则表示从第offset个参数开始，到接下来的第length个参数。
如果offset为负值则表示从最后一个位置参数开始，-1表示最后一个位置参数。
如果length为负值则结果报错
set -- 1 2 3 4 5 6 7 8 9 0 a b c d e f g h
echo ${@:7}     # 7 8 9 0 a b c d e f g h
echo ${@:7:0}   # 
echo ${@:7:2}   # 7 8
echo ${@:7:-2}  # bash: -2: substring expression < 0
echo ${@: -7:2} # b c
echo ${@:0}     # ./bash 1 2 3 4 5 6 7 8 9 0 a b c d e f g h
echo ${@:0:2}   # ./bash 1
echo ${@: -7:0} # 
EOF
}

bash_t_arrray_subarray(){  cat - <<'EOF'
如果parameter是一个使用@ or *下标的索引数组，则扩展结果是从${array[offset]}开始的length个数组元素。
如果offset是负值则表示相对于最大下标的一个元素，最后一个元素是-1。
如果length为负值则报错
array=(0 1 2 3 4 5 6 7 8 9 0 a b c d e f g h)
echo ${array[@]:7}     # 7 8 9 0 a b c d e f g h
echo ${array[@]:7:0}   # 
echo ${array[@]:7:2}   # 7 8
echo ${array[@]:7:-2}  # bash: -2: substring expression < 0
echo ${array[@]: -7:2} # 0 1 2 3 4 5 6 7 8 9 0 a b c d e f g h
echo ${array[@]:0}     # 0 1 2 3 4 5 6 7 8 9 0 a b c d e f g h
echo ${array[@]:0:2}   # 0 1
echo ${array[@]: -7:0} # 0 1 2 3 4 5 6 7 8 9 0 a b c d e f g h
注意：对关联数组进行取子串操作会导致未定义的结果
EOF
}

bash_t_variable_length(){  cat - <<'EOF'
[string]
var='12345'
echo "${#var}"

[array]
myarr=(1 2 3)
echo "${#myarr[@]}"

[positional parameters]
set -- 1 2 3 4
echo "${#@}"

echo "$#"
EOF
}

bash_p_here(){  cat - <<'EOL'
如何使用数据(表)驱动代码执行，是编程能力的一种提升。也是模块化程序设计的重要组成部分。
数据(表)驱动编程实现方式有多种形式，其中here的使用就是一种极致的表现。

shunit2介绍了三种方式:
方式1: here document方式
while read desc arg want; do ... done <<EOF ... EOF                   # 读取数据块   shunit2
方式2: 重定义输入流
exec 9<&0 <<EOF
test#1 value1 output_one
test#2 value2 output_two
EOF
while read desc arg want; do
done
exec 0<&9 9<&-
方式3: 从文件读取数据
while read desc arg want; do ... done </path/to/some/testfile

bash_t_here_document 中说明了here document的形式，实质上把指定多行内容作为输入内容传递给命令。
bash_t_here_document 中说明了 sudo ssh gnuplot ftp wc ex cat 命令使用 here document的方法。
bash_t_here_string   中说明了here string的形式，实质上把指定单行内容作为输入内容传递给命令。
bash_t_here_file     中说明了 输入重定向的使用形式 while for until 
bash_t_here_exec     中说明了 exec 控制流的方式
EOL
}

bash_t_here_commend(){  cat - <<'EOL'
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

gnuplot << EOF
set terminal png size 1024,768
set output "$1.png"
set title "curvedata (distance:$STP_DISTANCE_VAL pluse:$STP_PLUSE_VAL wavelen:$WLS_VAL avgs:$ALA_VAL ior:$IOR_VAL sample:$SMPINF_SAMPLES total length:$AUT_LEN)"
set xlabel "samples total length:$AUT_LEN loss:$AUT_LOSS rloss:$AUT_RLOSS"
set ylabel "dB (dB/1000)"
set yrange [ 0 : $AUT_RLOSS ]
plot "$1" using 1:2 title "curvedata" with lines
EOF

ftp -i -n<<EOF
open 192.168.27.253
user root 123456
cd /etc/rtud
lcd /etc/rtud
binary
prompt
get serial
prompt
close
bye
EOF

FTILE_NAME=$1
ftp -n <<- EOF
open 10.10.21.103
user user 123
cd test
bin
put $FTILE_NAME
bye
EOF

# Sends message to everyone logged in
wall <<zzz23EndOfMessagezzz23
E-mail your noontime orders for pizza to the system administrator.
    (Add an extra dollar for anchovy or mushroom topping.)
# Additional message text goes here.
# Note: 'wall' prints comment lines.
zzz23EndOfMessagezzz23

# Creates a 2-line dummy file
ex $word <<EOF
  :%s/$ORIGINAL/$REPLACEMENT/g
  :wq
EOF

# Multi-line message, with tabs suppressed
cat <<-ENDOFMESSAGE
	This is line 1 of the message.
	This is line 2 of the message.
	This is line 3 of the message.
	This is line 4 of the message.
	This is the last line of the message.
ENDOFMESSAGE

# Here document with parameter substitution
cat <<Endofmessage
Hello, there, $NAME.
Greetings to you, $NAME, from $RESPONDENT.
# This comment shows up in the output (why?).
Endofmessage

# Parameter substitution turned off
cat <<'Endofmessage'
Hello, there, $NAME.
Greetings to you, $NAME, from $RESPONDENT.
Endofmessage

# "Anonymous" Here Document
: <<TESTVARIABLES
${HOSTNAME?}${USER?}${MAIL?}  # Print error message if one of the variables not set.
TESTVARIABLES

# Commenting out a block of code
: <<DEBUGXXX
for file in *
do
 cat "$file"
done
DEBUGXXX

EOL
}

bash_t_here_document(){  cat - <<'EOL'
tee，cat或sftp
[COMMAND] <<[-] 'DELIMITER'
  HERE-DOCUMENT
DELIMITER
第一行以可选命令开头，后跟特殊重定向运算符<<和分隔标识符。
  您可以使用任何字符串作为分隔标识符，最常用的是EOF或END。
  如果分隔标识符未加引号，则在将here-document行传递给命令之前，shell将替换所有变量，命令和特殊字符。
  将减号添加到重定向运算符<<  - 将导致忽略所有前导制表符。 这允许您在此处写入时使用缩进 -  shell脚本中的文档。 不允许使用前导空白字符，只允许使用制表符。
  here-document块可以包含字符串，变量，命令和任何其他类型的输入。
最后一行以分隔标识符结束。分隔符前的空白是不允许的
cat <<\EOF    
cat <<-"EOF"  
cat <<"EOF"   
cat <<'EOF'   
cat <<EOF     

cat >> path/to/file/to/append-to.txt << "EOF"
export PATH=$HOME/jdk1.8.0_31/bin:$PATH
export JAVA_HOME=$HOME/jdk1.8.0_31/
EOF

1. 命令行帮助: 
bn=`basename $0`
cat << EOF
usage $bn <option> device_node
options:
  -h				displays this help message
  -s				only get partition size
  -np 				not partition.
  -f 				flash android image.
EOF

FLAGS_HELP=`cat <<EOF
commands:
  speak:  say something
  sing:   sing something
EOF`

2. shunit2 表驱动测试
while read desc arg want; do
  got=$(fn ${arg})
  rtrn=$?
  assertTrue "${desc}: fn() unexpected error; return ${rtrn}" ${rtrn}
  assertEquals "${desc}: fn() = ${got}, want ${want}" "${got}" "${want}"
done <<EOF
test#1 value1 output_one
test#2 value2 output_two
EOF

3. ftp -i -n | gnuplot | sudo -s 
command <<EOF
cmd1
cmd2 arg1
EOF

mail -s 'Backup status' vivek@nixcraft.co.in<<END_OF_EMAIL
The backup job finished.
End date: $(date)
Hostname : $(hostname)
Status : $status
END_OF_EMAIL

4.  "Anonymous" Here Document
: <<TESTVARIABLES
${HOSTNAME?}${USER?}${MAIL?}  # Print error message if one of the variables not set.
TESTVARIABLES

5. Commenting out a block of code
: <<COMMENTBLOCK
echo "This line will not echo."
This is a comment line missing the "#" prefix.
This is another comment line missing the "#" prefix.

&*@!!++=
The above line will cause no error message,
because the Bash interpreter will ignore it.
COMMENTBLOCK
EOL
}

bash_t_here_string(){  cat - <<'EOL'
awk '{print $2}' <<< "hello world - how are you?"

tr a-z A-Z <<< one
tr a-z A-Z <<< 'one two three'
FOO='one two three'
tr a-z A-Z <<< $FOO
tr a-z A-Z <<< 'one
two three'
bc <<< 2^10

read a b c <<< 'one two three' 
echo $a $b $c

while IFS=" " read -r word1 word2 rest ; do
  echo "$word1"
done <<< "hello how are you - i am fine"

if grep -q "txt" <<< "$VAR"

# Prepending a line to a file
cat - $file <<<$title > $file.new

IFS=: read -r header value <<< "$mail"
fmt -t -w 20 <<< 'Wrap this silly sentence.'
EOL
}


bash_t_here_file(){  cat - <<'EOL'
1. while
while [ "$name" != Smith ]  # Why is variable $name in quotes?
do
  read name                 # Reads from $Filename, rather than stdin.
  echo $name
  let "count += 1"
done <"$Filename"           # Redirects stdin to file $Filename. 

2. until
until [ "$name" = Smith ]     # Change  !=  to =.
do
  read name                   # Reads from $Filename, rather than stdin.
  echo $name
done <"$Filename"             # Redirects stdin to file $Filename. 

3. for
for name in `seq $line_count`  # Recall that "seq" prints sequence of numbers.
# while [ "$name" != Smith ]   --   more complicated than a "while" loop   --
do
  read name                    # Reads from $Filename, rather than stdin.
  echo $name
  if [ "$name" = Smith ]       # Need all this extra baggage here.
  then
    break
  fi  
done <"$Filename"              # Redirects stdin to file $Filename. 
EOL
}
bash_t_here_exec(){  cat - <<'EOL'
exec 9<<EOF
  Status of backup as on $(date)
  Backing up files $HOME and /etc/
EOF

## continue
echo "Starting my script..."
echo "Doing something..."

## do it
cat <&9 >$OUT
exec 9<&-
EOL
}
bash_p_string_substitution(){
cat - <<'EOF'
${FOO%suffix}   # Remove suffix
${FOO#prefix}   # Remove prefix
${FOO%%suffix}   # Remove long suffix
${FOO##prefix}   # Remove long prefix
${FOO/from/to}   # Replace first match
${FOO//from/to}   # Replace all
${FOO/%from/to}   # Replace suffix
${FOO/#from/to}   # Replace prefix
EOF
}

bash_i_string_substr(){ cat - <<'EOF'
1. 基本替换
name="John"
echo ${name}
echo ${name/J/j}    #=> "john" (substitution)
echo ${name:0:2}    #=> "Jo" (slicing)
echo ${name::2}     #=> "Jo" (slicing)
echo ${name::-1}    #=> "Joh" (slicing)
echo ${name:(-1)}   #=> "n" (slicing from right)
echo ${name:(-2):1} #=> "h" (slicing from right)
echo ${food:-Cake}  #=> $food or "Cake"

${FOO:0:3}      Substring (position, length)
${FOO:-3:3}     Substring from the right

字符串长度：
${#VAR}：$VAR的长度
字符串是以0结尾的；
    VAR="a\000bc\000" 
    echo "${#VAR}"
    printf "%s\n" ${VAR}

字符串切片：# position,length 不需要'$'取值，既支持变量也支持数值常量。
    ${VAR:position}：在$VAR中, 从位置$position开始提取子串
        VAR="language bash"
        position=1
        echo ${VAR:position}    # anguage bash
        echo ${VAR:1}           # anguage bash
    ${VAR:position:length}：在$VAR中,从位置$position开始提取长度为$length的子串
        VAR="language bash"
        position=1
        length=10
        echo ${VAR:position:length}  # anguage ba
        echo ${VAR:1:10}             # anguage ba
EOF
}

bash_p_string_psubstr(){ cat - <<'EOF'
基于模式取子串：# substring需要'$'取值，既支持变量也支持字符串常量。
    ${VAR#$substring}：从变量$VAR的开头, 删除最短匹配$substring的子串
    ${VAR##$substring}：从变量$VAR的开头, 删除最长匹配$substring的子串
        file="/var/log/messages"
        substring=$'*/' # substring='*/' ; substring="*/" 都可以
        echo  ${file#$substring}  # var/log/messages
        echo  ${file#*/}          # var/log/messages
        echo  ${file##$substring} # messages
        echo  ${file##*/}         # messages
        
# basename dirname 
        
    ${VAR%$substring}：从变量$VAR的结尾, 删除最短匹配$substring的子串
    ${VAR%%$substring}：从变量$VAR的结尾, 删除最长匹配$substring的子串
        file="var/log/messages"
        substring=$'/*' # substring='/*' ; substring="/*" 都可以 
        echo  ${file%$substring}  # var/log
        echo  ${file%/*}          # var/log
        echo  ${file%%$substring} # var
        echo  ${file%%/*}         # var
    示例：url="http://www.tmall.com:80" 
        echo ${url##*:}  #  80
        echo ${url%%:*}  #  http
    这里的模式是bash支持的模式；即: bash 通配符
    # 通配符包括* ? [...]。其中，
    # *匹配任何字符串，包括空字符串 
    # ?只能匹配单个字符，
    # [...]能够匹配任意出现在中括号里面的字符或者一类字符集。
    # [abc] [a-c] [^a-c]or[!a-c]  [[:digit:]]
    
@ 路径名解析
local base=${1##*/}             获取执行命令名称
devesc=${src##/dev/}            获取设备名称
CONFIG="${1##*/}"               获取执行命令名称

@ 字符串裁剪
DEVNAME=${CONFIG##ifcfg-}       获取指定设备名称
netmask[$i]=${val##NETMASK=}    获取指定变量对应的值
prefix[$i]=${val##PREFIX=}
broadcast[$i]=${val##BROADCAST=}

REALDEVICE=${DEVICE%%:*}        获取指定设备真实名称

@ 解析指定格式的参数。
name=value,name1=value1,...
while [ -n "$opt" ]; do
  arg=${opt%%,*}         得到",*"之前选项字段         arg="name=value"
  opt=${opt##$arg}       删除"选项字段"，剩下内容为   opt=",name1=value1,..."
  opt=${opt##,}          删除","，剩下内容为          opt="name1=value1,..."
  param=${arg%%=*}       得到                         param="name"
  value=${arg##$param=}  得到                         value="value"
done

OPTARG="name=value"
key=`expr "${OPTARG}" : '\([^=]*\)='`    # key=name
val=`expr "${OPTARG}" : '[^=]*=\(.*\)'`  # val=value
eval "${key}='${val}'"                   # name=value
eval "export ${key}"                     # 导出name
env="${env:+${env} }${key}"              # 导出给env

@ UUID获取
if [ "${src%%=*}" == "UUID" ]; then
EOF
}
bash_t_string_replace(){ cat - <<'EOF'
基于模式查找替换：# substring需要'$'取值，既支持变量也支持字符串常量。
    ${VAR/$substring/$replacement}：使用$replacement, 来代替第一个匹配的$substring
    ${VAR//$substring/$replacement}：使用$replacement, 代替所有匹配的$substring
    VAR="language bash -> bash"
    substring=bash
    replacement=shell
    [常规替换]
    echo ${VAR/$substring/$replacement}   # language shell -> bash
    echo ${VAR//$substring/$replacement}  # language shell -> shell
    echo ${VAR/bash/shell}                # language shell -> bash
    echo ${VAR//bash/shell}               # language shell -> shell
    
    [模式替换]
    echo ${VAR/b?sh/shell}                # language shell -> bash
    echo ${VAR//b?sh/shell}               # language shell -> shell
    echo ${VAR/bash*/shell}               # language shell
    echo ${VAR//bash*/shell}              # language shell
    
    str="1 2 3 4";echo ${str// /}  # 1234
    str="1 2 3 4";echo ${str// /,} # 1,2,3,4
    str="1 2 3 4";echo ${str// /+} # 1+2+3+4
    str="neo netkiller";echo ${str//neo/hello} # hello netkiller
    
    [替换最长匹配$substring的子串为$replacement]
    # #左替换 %右替换 键盘位置
    ${VAR/#$substring/$replacement}：如果$VAR的前缀匹配$substring, 那么就用$replacement来代替匹配到的$substring
    ${VAR/%$substring/$replacement}：如果$VAR的后缀匹配$substring, 那么就用$replacement来代替匹配到的$substring
    VAR="language bash -> bash"
    substring=language
    replacement=programmer
    echo ${VAR/#$substring/$replacement} # programmer bash -> bash
    echo ${VAR/#language/programmer}     # programmer bash -> bash
    echo ${VAR/#langu*/programmer}       # programmer
    substring=bash
    replacement=shell
    echo ${VAR/%$substring/$replacement} # language bash -> shell
    echo ${VAR/%bash/shell}              # programmer bash -> bash
    echo ${VAR/%*bash/shell}             # shell
EOF
}


bash_t_string_replace2(){ cat - <<'EOF'
${FOO/from/to}      Replace first match
${FOO//from/to}     Replace all
${FOO/%from/to}     Replace suffix
${FOO/#from/to}     Replace prefix

[First match:]
a='I am a string'
echo "${a/a/A}"    # I Am a string

[All matches:]
echo "${a//a/A}"   # I Am A string

[Match at the beginning:]
echo "${a/#I/y}"   # y am a string

[Match at the end]
echo "${a/%g/N}"   # I am a strinN

[Replace a pattern with nothing:]
echo "${a/g/}"     # I am a strin

[Add prefix to array items:]
A=(hello world)
echo "${A[@]/#/R}"   # Rhello Rworld
EOF
}

bash_t_string_trim(){ cat - <<'EOF'
基于查找删除：# substring需要'$'取值，既支持变量也支持字符串常量。
    ${VAR/$substring}： 删除(从左起)第一个匹配的$substring
    ${VAR//$substring}：删除(从左起)所有匹配的$substring
    VAR="language bash -> bash"
    substring=language
    echo ${VAR/$substring}              # bash -> bash
    echo ${VAR/language}                # bash -> bash
    
    substring=bash
    echo ${VAR/$substring}             # language -> bash
    echo ${VAR/bash}                   # language -> bash
    echo ${VAR//$substring}            # language ->
    echo ${VAR//bash}                  # language ->
    echo ${VAR/bash*}                  # language
    echo ${VAR//bash*}                 # language
    
    
${FOO%suffix}       Remove suffix
${FOO#prefix}       Remove prefix
${FOO%%suffix}      Remove long suffix
${FOO##prefix}      Remove long prefix

[Shortest match]
a='I am a string'
echo "${a#*a}"   # m a string

[Longest match:]
echo "${a##*a}"  # string

[Shortest match:]
a='I am a string'
echo "${a%a*}"  # I am

[Longest match:]
echo "${a%%a*}" # I


${FILENAME%.*}  Get name without extension
${FILENAME##*.} Get extension
    
FILENAME="/tmp/example/myfile.txt"
echo "${FILENAME%/*}"     # dirname
echo "${FILENAME##*/}"    # basename

STR="/path/to/foo.cpp"
echo ${STR%.cpp}    # /path/to/foo
echo ${STR%.cpp}.o  # /path/to/foo.o

echo ${STR##*.}     # cpp (extension)
echo ${STR##*/}     # foo.cpp (basepath)

echo ${STR#*/}      # path/to/foo.cpp
echo ${STR##*/}     # foo.cpp

echo ${STR/foo/bar} # /path/to/bar.cpp

STR="Hello world"
echo ${STR:6:5}   # "world"
echo ${STR:-5:5}  # "world"

SRC="/path/to/foo.cpp"
BASE=${SRC##*/}   #=> "foo.cpp" (basepath)
DIR=${SRC%$BASE}  #=> "/path/to/" (dirpath)
EOF
}

bash_t_string_case(){ cat - <<'EOF'
字符串大小写转换：
    ${VAR^^}: 把VAR的小写字母转换成大写字母；
    ${VAR,,}: 把VAR的大写字母转换成小写字母；
    HI=HellO
    echo "$HI"  # HellO
[To uppercase]
    echo ${HI^} # HellO
    echo ${HI^^} # HELLO
[To lowercase]
    echo ${HI,} # hellO
    echo ${HI,,} # hello
[Toggle Case]
    echo ${HI~} # hellO
    echo ${HI~~} #hELLo
    ^大写，,小写， ~大小写切换
    重复一次只修改首字母，重复两次则应用于所有字母。
EOF
}

bash_t_string_condition(){ cat - <<'EOF'
变量赋值：# VALUE需要'$'取值，既支持变量也支持字符串常量。
    ${VAR:-$VALUE}：如果VAR为空或未设置，返回VALUE；否则，返回VAR值；                    # VAR是否存在都返回 0
    ${VAR:=$VALUE}：如果VAR为空或未设置，返回VALUE，并将VALUE赋值给VAR；否则，返回VAR值  # VAR是否存在都返回 0
    
    ${VAR:+$VALUE}：如果VAR不为空，则返回VALUE; 否则，返回空字串；                  # 当VAR存在的时候 $? == 0; 当VAR不存在 $? == 1
    ${VAR:?$ERROR_INFO}：如果VAR为空或未设置，那么返回ERROR_INFO；否则，返回VALUE;  # 
|---------------|------------------------------|--------------------------------------|
|参数表达式形式 | 如果 var 变量已设置那么值为  | 如果 var 变量没有被设置那么值为      |
|${var:-string} | "$var"                       | "string"                             |
|${var:+string} | "string"                     | "null"                               |
|${var:=string} | "$var"                       | "string" (并运行 "var=string")       |
|${var:?string} | "$var"                       | 在 stderr 中显示 "string" (出错退出) |
|---------------|------------------------------|--------------------------------------|

Name                    Condition         Operator    Example
Assign default value    unset             =           ${var=default}
Assign default value    unset or NULL     :=          ${var:=default}
Use default value       unset             -           ${var-default}
Use default value       unset or NULL     :-          ${var:-default}
Use alternate value     set               +           ${var+alternate}
Use alternate value     set and non-NULL  :+          ${var:+alternate}

    [[ "${__usage+x}" ]] && unset -v __usage # 变量存在就删除存在变量
*(patternlist)            # 零次或者多次匹配
+(patternlist)            # 一次或者多次匹配
?(patternlist)            # 零次或者一次匹配
@(patternlist)            # 单词匹配
!(patternlist) # 不匹配

var=6
val=3
echo $[$var/$val]   # echo $[var/val]   都可以
echo $(($var/$val)) # echo $((var/val)) 都可以

(( [arithmetic expression] ))   # exit status
$(( [arithmetic expression] ))  # arithmetic value
EOF
}

cat /dev/null <<'EOF'
1. 数组被用来解析命令行参数和选项; options=()  arguments=() 用数组存储命令行参数和选项(options可以支持长短选项)
   options[${#options[*]}]="$option" 追加元素
2. "${options[@]}" 配合 for in和case option可以很好的处理命令行选项和命令行参数
EOF

bash_t_sh_array(){ cat - <<'EOF'
@ 通过 set 命令和位置参数来模拟数组
set 'word 1' word2 word3        # 定义数组
echo $1                         # 输出数组的第一个元素
echo $2                         # 输出数组的第二个元素
echo $3                         # 输出数组的第三个元素
echo $*                         # 输出数组的所有元素
echo $@                         # 输出数组的所有元素
set -- "$@" word4               # 向数组中增加一个元素
echo $4
                                # 查看数组元素的个数
echo $#

for i in do "$@"; do            # 遍历数组元素
  echo "$i"
done

shift                           # 从数组中删除一个元素
echo $@

set x; shift                    # 删除数组的所有元素


@ 使用 eval 命令模拟数组
定义数组并遍历数组元素：	
#!/bin/sh
eval a1=word1
eval a2=word2
eval a3=word3
for i in 1 2 3; do
  eval echo "The $i element of array is: \$a$i"
done
EOF
}
bash_t_array(){ cat - <<'EOF'
1. 数组元素的个数不受限制，也不限制数组的下标或赋值时要连续。 # 元素
2. 下标数组使用整数或算术表达式来访问元素，下标从零开始。     # 下标
3. 而关联数组使用任意字符串来访问元素。                       # 
1. 创建数组:
1.1 序列赋值 array=('first element' 'second element' 'third element')
1.2 下标赋值 array=([3]='fourth element' [4]='fifth element')
1.3 索引赋值 array[0]='first element'
1.4 名字赋值 array[first]='First element'
1.5 动态赋值 array=(`seq 1 10`) 来自命令; 
             array=("$@") 来自数组; 
             arrayVar=(${stringVar// / }) 来自字符串 stringVar="Apple Orange Banana Mango"
             arrayVar=(${stringVar//+/ }) 来自字符串 stringVar="Apple+Orange+Banana+Mango"
             IFS=$'\n' read -r -a arr < file 来自read
2. 访问数组
2.1 首部字段 "${array[0]}"
2.2 尾部字段 "${array[@]:-1}" 或 "${array[-1]}" 
2.3 所有字段 "${array[@]}"   #  all elements, each quoted separately
             "${array[*]}"   #  all elements as a single quoted strin
2.4 部分子都 "${array[@]:1}" 或 "${array[@]:1:3}"
echo ${#Fruits} # String length of the 1st element 
echo ${#Fruits[3]} # String length of the Nth element

3. 修改字段
3.1 索引赋值 array[10]="elevenths element" 
3.2 尾部追加 array+=('fourth element' 'fifth element') 或 array=("${array[@]}" "fourth element" "fifth element")
3.3 首部添加 array=("new element" "${array[@]}")
3.4 中间插入 arr=("${arr[@]:0:$i}" 'new' "${arr[@]:$i}")
3.5 删除字段 unset -v 'arr[1]'
3.6 数组合并 array3=("${array1[@]}" "${array2[@]}")
3.7 重新序列化 array=("${array[@]}")
3.8 删除数组 unset array
Fruits=("${Fruits[@]}" "${Veggies[@]}") # Concatenate 
lines=(`cat "logfile"`) # Read from file

4. 遍历数组
4.1 foreach  for y in "${a[@]}"; do ...; done
4.2 for-loop for ((idx=0; idx < ${#a[@]}; ++idx)); do ...; done
4.3 while    while [ $i -lt ${#arr[@]} ]; do ...; done
             while (( $i < ${#arr[@]} )); do ...; done
4.4 until    until [ $i -ge ${#arr[@]} ]; do ...; done
             until (( $i >= ${#arr[@]} )); do ...; done
5. 数组长度
5.1 echo "${#array[@]}"

6. 关联数组
6.1 index化  echo "${!aa[@]}"
6.2 遍历数组 for key in "${!aa[@]}"; do ${key} ${array[$key]} done
数组是bash向结构化编程的一次迈进，也是显式数据(表)驱动编程向抽象数据(表)驱动编程的一次迈进。
在没有提供嵌套引用能力之前，模块化编程实现都是很难的。
在sh没有提供数组功能时，怎样模拟数组功能??? 
EOF
}

bash_t_array_from(){ cat - <<'EOF'
array=(`seq 1 10`)              来自命令; 
array=("$@")                    来自数组; 
arrayVar=(${stringVar// / })    来自字符串 stringVar="Apple Orange Banana Mango"
arrayVar=(${stringVar//+/ })    来自字符串 stringVar="Apple+Orange+Banana+Mango"
IFS=$'\n' read -r -a arr < file 来自read

arr=()
while IFS= read -r line; do
  arr+=("$line")
done

mapfile -t arr < file      来自mapfile
readarray -t arr < file    来自readarray
EOF
}

bash_t_array_create(){ cat - <<'EOF'
创建数组：
  数组名[下标]=值          # array_assign[1]='help'   # declare -a array_assign='([1]="help")'
  declare -a 数组名        # declare -a array_declare # declare -a array_declare='()'
  declare -a ARRAY_NAME
  declare -a 数组名[下标]  # declare -a array_declare_index[10] 下标不标明数组大小 # declare -a array_declare_index='()'
  ARRAY_NAME=()            # declare -a ARRAY_NAME='()'
  ARRAY_NAME=('first element' 'second element' 'third element')
  ARRAY_NAME=([3]='fourth element' [4]='fifth element')
  
  declare -A 数组名        #
  declare -A ARRAY_NAME：关联数组(bash version > 4.0)
  ARRAY_NAME[hello]=world
  ARRAY_NAME[ab]=cd
  ARRAY_NAME["key with space"]="hello world"
  或
  declare -A ARRAY_NAME=([hello]=world [ab]=cd ["key with space"]="hello world")
  
  数组名=([下标=]值 [下标=]值 ...) # array_init=(one two three four)  空格是bash默认分隔符； 对下标数组，不必要指定下标
  下标数组： declare -a array # 下标数组不支持负数作为下标
  array["-1"]="help" # bad array subscript 下标不支持负数
  array[-1]="help"   # bad array subscript 下标不支持负数
  关联数组： declare -A array # 关联数组支持负数作为关联索引值
  array["-1"]="help" # declare -A array='([-1]="help" )'
  array[-1]="help"   # declare -A array='([-1]="help" )'
  
  ARRAY_NAME=([0]="VALUE" [3]="VALUE") 
  declare -p ARRAY_NAME # declare -a ARRAY_NAME='([0]="VALUE" [3]="VALUE")' 
  1. declare -p ARRAY_NAME的输出可以看做此数组的标准定义
  2. 从declare -a ARRAY_NAME=右侧可以看出：右边是一个符合数组要求格式字符串
EOF
}
bash_t_array_assign(){ cat - <<'EOF'
数组元素赋值：
  1. 一次赋值一个元素：
      ARRAY_NAME[INDEX]=VALUE
        weekdays[0]="sun"
        weekdays[1]="mon"
        arr[0]=Hello 
        arr[1]=World
        names[5]="Big John"
        names[$n + 1]="Long John"
     declare -p weekdays; 
  2. 一次赋值全部元素： # 在括号内，使用空格作为数组元素分隔符，而不是逗号。
      ARRAY_NAME=("VALUE1" "VALUE2" "VALUE3" ...)
      myarray=( foo bar quux )   # 3个元素
      myarray=( "foo bar" quux ) # 2个元素
      myfiles=( *.txt )    # 模式匹配 epoll1.txt epoll.txt flashing.txt rtud.txt
      myfiles+=( *.html )  # 数组加运算 epoll1.txt epoll.txt flashing.txt rtud.txt index.html
  3. 只赋值特定元素：
      ARRAY_NAME=([0]="VALUE" [3]="VALUE") # declare -a ARRAY_NAME='([0]="VALUE" [3]="VALUE")'
      ARRAY_NAME[1]=                       # declare -a ARRAY_NAME='([0]="VALUE" [1]="" [3]="VALUE")'
      ARRAY_NAME[2]=""                     # declare -a ARRAY_NAME='([0]="VALUE" [1]="" [2]="" [3]="VALUE")'
      echo "${#ARRAY_NAME[@]}"             # 4
      
      declare -A homedirs=( ["Peter"]=~pete ["Johan"]=~jo ["Robert"]=~rob )  # 关联数值必须先声明再使用
      declare -A homedirs='([Robert]="~rob" [Johan]="~jo" [Peter]="~pete" )' # declare 返回内容
      homedirs['Smith']=~smith
      declare -A homedirs='([Robert]="~rob" [Johan]="~jo" [Smith]="~smith" [Peter]="~pete" )' # declare 返回内容
      homedirs['wangfuli']=
      declare -A homedirs='([Robert]="~rob" [Johan]="~jo" [Smith]="~smith" [Peter]="~pete" [wangfuli]="" )' # declare 返回内容
      echo "${#homedirs[@]}"             # 5
      
      declare -a array=('1:one' '2:two' '3:three');
  4. read -a ARRAY
     IFS=, read -ra names <<< "John,Lucas,Smith,Yolanda" # declare -a names='([0]="John" [1]="Lucas" [2]="Smith" [3]="Yolanda")'
     read -ra myarray
  5. array=('1:one' '2:two' '3:three') # 从字符串到数组
      arr=(${array[*]})   # 以空格分割的数组项会被分割成多个数组项 echo "${arr[0]}" # '1:one'
      arr=(${array[@]})   # 以空格分割的数组项会被分割成多个数组项 echo "${arr[0]}" # '1:one'
      arr=("${array[*]}") # 所有数组元素成为一个数组项 echo "${arr[0]}" # '1:one 2:two 3:three'
      arr=("${array[@]}") # 以空格分割的数组项会被分割成多个数组项 echo "${arr[0]}" # '1:one'
      
      ARRAY_NAME=([0]="VALUE" [3]="VALUE")
      ARRAY_ANOTHER=ARRAY_NAME # declare -- ARRAY_ANOTHER="ARRAY_NAME"  即 ARRAY_ANOTHER为字符串
      text='John Lucas Smith Yolanda' # declare -- text="John Lucas Smith Yolanda"
      array=($text)       # 按空格分隔 text 成数组，并赋值给变量 # declare -a array='([0]="John" [1]="Lucas" [2]="Smith" [3]="Yolanda")'
      IFS="/" array=($text) # 按斜杆分隔字符串 text 成数组，并赋值给变量
      
      array=({23..32} {49,50} {81..92}) # 扩展优先执行 declare -a array='([0]="23" [1]="24" [2]="25" ...)'
  6.1 拆分字符串并转换为数组
      QUEUES="example|sss"
      STRING_NAME=$(echo $QUEUES | tr '|' ' ')     # 字符串 declare -p STRING_NAME # declare -- STRING_NAME="example sss"
      ARRAY_NAME=( $(echo $QUEUES | tr '|' ' ') )  # 数组   declare -p ARRAY_NAME  # declare -a ARRAY_NAME='([0]="example" [1]="sss")'
      echo "${STRING_NAME[0]}"   # example sss
      echo "${ARRAY_NAME[0]}"    # example
      for caption in $(echo $QUEUES | tr '|' ' '); do # 这里不能使用 ( $(echo $QUEUES | tr '|' ' ') )
        echo $caption
      done
  6.2 数组转为字符串
      ids=(1 2 3 4); lst=$( IFS='|'; echo "${ids[*]}" ); echo $lst  # 1|2|3|4
      array=(1 2 3 4); string="${array[@]}"; echo ${string// /,}    # 1,2,3,4
      
      array=(`seq 1 10`) # 命令
      array=("$@")       # 数组
      array=( * )        # 扩展
EOF
}
bash_t_array_index(){ cat - <<'EOF'
引用数组元素：${ARRAY_NAME[INDEX]}
    注意：省略[INDEX]表示引用下标为0的元素；
    ${array[-1]}           最后一个元素
    array["${#array[@]}"]  最后一个元素
EOF
}
bash_t_array_length(){ cat - <<'EOF'
数组长度：${#ARRAY_NAME[*]}, 
          ${#ARRAY_NAME[@]}
          
EOF
}
bash_t_array_reference(){ cat - <<'EOF'
引用数组中的元素：
    所有元素：${ARRAY_NAME[@]}  # 打印数组所有值
              ${ARRAY_NAME[*]}  # 打印数组所有值
              ${!ARRAY_NAME[@]} # 打印数组索引号。
              ${!ARRAY_NAME[*]} # 打印数组索引号。
    ARRAY_NAME=(one two three four)
    echo "${ARRAY_NAME[@]}"   # one two three four
    echo "${ARRAY_NAME[*]}"   # one two three four
    echo "${!ARRAY_NAME[@]}"  # 0 1 2 3
    echo "${!ARRAY_NAME[*]}"  # 0 1 2 3

    数组切片：${ARRAY_NAME[@]:offset:number}
        offset: 要跳过的元素个数；
        number: 要取出的元素个数；取出偏移量之后的所有元素：${ARRAY_NAME:offset}
    直接通过 ${数组名[@或*]:起始位置:长度} 切片原先数组，返回是字符串，中间用"空格"分开，因此如果加上"()"，将得到切片数组，
    ARRAY_NAME=(one two three four)
    postion=1
    length=2
    echo "${ARRAY_NAME[@]:1}"               # two three four
    echo "${ARRAY_NAME[*]:1}"               # two three four
    echo "${ARRAY_NAME[@]:1:2}"             # two three
    echo "${ARRAY_NAME[*]:1:2}"             # two thredd
    echo "${ARRAY_NAME[@]:position}"        # two three four
    echo "${ARRAY_NAME[*]:position}"        # two three four
    echo "${ARRAY_NAME[@]:position:length}" # two three
    echo "${ARRAY_NAME[*]:position:length}" # two three
    
    ${数组名[@或*]/查找字符/替换字符} 该操作不会改变原先数组内容
    ARRAY_NAME=(1 2 3 4 5)
    echo ${ARRAY_NAME[@]/3/100}             # 1 2 100 4 5
    ARRAY_NAME=(${ARRAY_NAME[@]/3/100}) 
    echo ${ARRAY_NAME[@]}                   # 1 2 100 4 5
EOF
}
bash_t_array_append(){ cat - <<'EOF'
向数组中追加元素：
    ARRAY_NAME=([0]="VALUE" [3]="VALUE")
    ARRAY_NAME[${#ARRAY_NAME[@]}]='wangfuli'  # declare -a ARRAY_NAME='([0]="wangfuli" [2]="wangfuli" [3]="VALUE")'
    ARRAY_NAME[${#ARRAY_NAME[@]}]='wangwenli' # declare -a ARRAY_NAME='([0]="VALUE" [2]="wangfuli" [3]="wangwenli")'
    
    ARRAY_NAME=([0]="VALUE" [3]="VALUE")
    ARRAY_NAME+=('wangfuli')  # declare -a ARRAY_NAME='([0]="VALUE" [3]="VALUE" [4]="wangfuli")'
    ARRAY_NAME+=('wangwenli') # declare -a ARRAY_NAME='([0]="VALUE" [3]="VALUE" [4]="wangfuli" [5]="wangwenli")'
    ARRAY_NAME+=('fourth element' 'fifth element')                     # 尾部追加
    ARRAY_NAME=("${ARRAY_NAME[@]}" "fourth element" "fifth element")   # 尾部追加
    ARRAY_NAME=("new element" "${ARRAY_NAME[@]}")                      # 开头添加
    ARRAY_NAME=("${ARRAY_NAME[@]:0:$i}" 'new' "${ARRAY_NAME[@]:$i}")   # 中间插入
    ARRAY_NAME3=("${ARRAY_NAME1[@]}" "${ARRAY_NAME2[@]}")              # 数组合并
    ARRAY_NAME3=("${ARRAY_NAME3[@]}")                                  # 在执行unset之后，重新序列化数组
EOF
}
bash_t_array_remove(){ cat - <<'EOF'
删除数组中的某元素：
    unset ARRAY_NAME[INDEX]
    
    ARRAY_NAME=([0]="VALUE" [3]="VALUE")
    unset ARRAY_NAME[0]  # declare -a ARRAY_NAME='([3]="VALUE")'
    unset ARRAY_NAME[1]  # declare -a ARRAY_NAME='([3]="VALUE")'
    unset ARRAY_NAME[3]  # declare -a ARRAY_NAME='()'
删除数组：
    unset ARRAY_NAME

    ARRAY_NAME=([0]="VALUE" [3]="VALUE")
    unset ARRAY_NAME  # declare: ARRAY_NAME: not found
EOF
}

bash_t_array_loop(){ cat - <<'EOF'
arr=(a b c d e f)

[Using a for..in loop:]
for i in "${arr[@]}"; do
  echo "$i"
done

for key in "${!assoc_array[@]}"; do # accessing keys using ! indirection!!!!
  printf "key: \"%s\"\nvalue: \"%s\"\n\n" "$key" "${assoc_array[$key]}"
done


[Using C-style for loop:]
for ((i=0;i<${#arr[@]};i++)); do
  echo "${arr[$i]}"
done

[Using while loop:]
i=0
while [ $i -lt ${#arr[@]} ]; do
  echo "${arr[$i]}"
  i=$((i + 1))
done

[Using while loop with numerical conditional:]
i=0
while (( $i < ${#arr[@]} )); do
  echo "${arr[$i]}"
  ((i++))
done

[Using an until loop:]
i=0
until [ $i -ge ${#arr[@]} ]; do
  echo "${arr[$i]}"
  i=$((i + 1))
done

[Using an until loop with numerical conditional:]
i=0
until (( $i >= ${#arr[@]} )); do
  echo "${arr[$i]}"
  ((i++))
done
EOF
}
bash_t_array_practice(){ cat - <<'EOF'
declare -a names
names=Jack
echo ${names[0]} # Jack
names[1]=Bone
echo ${names[1]} # Bone
echo ${names}    # Jack
echo ${names[*]} # Jack Bone
echo ${#names}   # 4
declare -a names='([0]="Jack" [1]="Bone")'

b="abc def ghi"; a=($b)    # 字符串转换为数组
array=( $(ls) )            # 把目录列表变为数组 更好实现为 array=( * ) 

echo "${names[5]}", echo "${names[n + 1]}"
echo "${names[@]}"
cp "${myfiles[@]}" /destinationdir/
rm "./${myfiles[@]}"
(IFS=,; echo "${names[*]}")
# 格式必须是"${myfiles[@]}";   file引用最好是"${file}"  使用"$file" 也好。
for file in "${myfiles[@]}"; do read -p "Delete $file? " && [[ $REPLY = y ]] && rm "$file"; done
names=(John Pete Robert); echo "${names[@]/#/Long }"
names=(John Pete Robert); echo "${names[@]:start:length}"; echo "${names[@]:1:2}"
printf '%s\n' "${names[@]}"
for name in "${!homedirs[@]}"; do echo "$name lives in ${homedirs[$name]}"; done
printf '%s\n' "${#names[@]}"

# array截取和替换
array=(1 2 3 4 5 6)
array0=${array[*]:2:2}   # 从数组全部元素中第2个元素向后截取2个元素出来（即3 4）
array1=${array[*]/5/6}   # 将数组中的5替换称6

# 数组支持模式匹配
array=(one two three foue five)
array1=${array[*]#*o}   # 从左非贪婪匹配并删除所有数组变量中匹配内容 ne three ue five
array2=${array[*]##*o}  # 从左贪婪匹配并删除所有数组变量中匹配的内容 ne three ue five
array3=${array[*]%o}    # 从右非贪婪匹配并删除所有数组变量中匹配内容 one tw three foue five
array4=${array[*]%%o}   # 从右贪婪匹配并删除所有数组变量中匹配内容   one tw three foue five

# 如果length为负值则报错 
$ array=(0 1 2 3 4 5 6 7 8 9 0 a b c d e f g h)
$ echo ${array[@]:7}
7 8 9 0 a b c d e f g h
$ echo ${array[@]:7:2}
7 8
$ echo ${array[@]: -7:2}
b c
$ echo ${array[@]: -7:-2}
bash: -2: substring expression < 0
$ echo ${array[@]:0}
0 1 2 3 4 5 6 7 8 9 0 a b c d e f g h
$ echo ${array[@]:0:2}
0 1
$ echo ${array[@]: -7:0}
注意：对关联数组进行取子串操作会导致未定义的结果
EOF
}

bash_i_function(){ cat - <<'EOF'
function positive() {
  return 0
}
function negative() {
  return 1
}

[Functions with arguments]
greet() {
  local name="$1"
  echo "Hello, $name"
  echo "$@"            # $@ refers to all arguments of a function
  local val=${1:-25}   # default value
  local val=${1:?Must provide an argument} # must argument
}
greet "John Doe"

EOF
}
bash_t_function(){ cat - <<'EOF'
source helloWorld.sh # 引入外部的函数和变量
export -f greet      # 暴露内部的函数和变量
function(){
function: 函数
过程式编程：代码重用
模块化编程
结构化编程

语法一：
    function fun_name {
        函数体
    }
语法二：
    fun_name() {
        函数体
    }
    
调用：函数只有被调用才会执行；
    调用：给定函数名
        函数名出现的地方，会被自动替换为函数代码；
        
    函数的生命周期：被调用时创建，返回时终止；
        return命令返回自定义状态结果；
            0：成功
            1-255：失败
            
函数返回值：
    函数的执行结果返回值：
        1. 使用echo或print命令进行输出；
        2. 函数体中调用命令的执行结果；
    函数的退出状态码：
        1. 默认取决于函数体中执行的最后一条命令的退出状态码；
        2. 自定义退出状态码：
            return CODE
            
函数接收参数：
    传递参数给函数：调用函数时，在函数名后面以空白分隔给定参数列表即可；
        例如：fun_name arg1 arg2 ...
    在函数体中，可以使用$1, $2, ...引用这些参数；还可以引用$@, $*, $#变量；
变量作用域：
    本地变量：当前shell进程，为了执行脚本会启动专用的shell进程；因此，本地变量的作用范围是当前shell脚本程序文件；
    局部变量：函数的生命周期，函数结束时变量被自动销毁；
        local VNAME=VALUE
        可见作用域: 函数体，以及函数体中调用的其它函数；
函数递归：
    函数直接或间接调用函数自身；
EOF
}

cat /dev/null << 'EOF'
myfunc() {
  # $1 代表第一个参数，$N 代表第 N 个参数
  # $# 代表参数个数
  # $0 代表被调用者自身的名字
  # $@ 代表所有参数，类型是个数组，想传递所有参数给其他命令用 cmd "$@" 
  # $* 空格链接起来的所有参数，类型是字符串
  {shell commands ...}
  myfunc                    # 调用函数 myfunc 
  myfunc arg1 arg2 arg3     # 带参数的函数调用
  myfunc "$@"               # 将所有参数传递给函数
  shift # 参数左移
  
  unset -f myfunc           # 删除函数
  declare -f # 列出函数定义
}
# 通过eval 进行值返回值 --- 全局变量
############################ eval #####################
a() { 
var="$1"
echo "$var"                   # arg      # value_arg
eval "$var=change"
return 0
}
arg='value_arg'               # declare -- arg="value_arg"
declare -p arg
a arg
echo "arg=$arg"               # declare -- arg="change"
declare -p arg
echo "--------------"
arg='value_arg'
a "$arg"
echo "arg=$arg"               # arg=value_arg
echo "value_arg=$value_arg"   # value_arg=change
declare -p arg                # declare -- arg="value_arg"
declare -p value_arg          # declare -- value_arg="change"
# 通过hook 进行值返回值 ---- 环境变量
############################ export #####################
a() { 
local hook="${1}"
export "PI_STACK_LIST=${PI_STACK_LIST:+$PI_STACK_LIST }$hook"
export "$hook=help"
echo "$hook ++++ $PI_STACK_LIST"
return 0
}
arg='value_arg'
a arg
echo "$arg" # help
env | grep arg

EOF

bash_t_IFS_set(){ cat - <<'EOF'
oIFS=$IFS
IFS=":"
set -- $tuple; uname="$1"; gname="$2" #通过空格或其他分隔符生成变量
IFS="="
set -- $uname; uname="$1"; uid="$2"
set -- $gname; gname="$1"; gid="$2"
IFS="$oIFS"
EOF
}
bash_t_set(){  cat - <<'EOF'
1. set 设置变量
set -- $(echo aa bb cc)
echo "$1 $2 $3" # aa bb cc
2. unset 变量销毁
unset logfile
3. 设置变量默认值
logfile=${logfile:-/tmp/test.log}

set +H
echo "Hello World!" # Hello World!
set -H
echo "Hello World!" # -bash: !: event not found
echo Hello World!   #  Hello World!
echo 'Hello World!' #  Hello World!

# 方式1
set -- 1 2 3 4 5 6 7 8 9 0 a b c d e f g h
$ echo ${@:7}
7 8 9 0 a b c d e f g h
$ echo ${@:7:0}

$ echo ${@:7:2}
7 8
$ echo ${@:7:-2}
bash: -2: substring expression < 0
$ echo ${@: -7:2}
b c
$ echo ${@:0}
./bash 1 2 3 4 5 6 7 8 9 0 a b c d e f g h
$ echo ${@:0:2}
./bash 1
$ echo ${@: -7:0}

# 方式2
$ set -- 01234567890abcdefgh
$ echo ${1:7}
7890abcdefgh
$ echo ${1:7:0}

$ echo ${1:7:2}
78
$ echo ${1:7:-2}
7890abcdef
$ echo ${1: -7}
bcdefgh
$ echo ${1: -7:0}

$ echo ${1: -7:2}
bc
$ echo ${1: -7:-2}
bcdef
}
第8章 case
case(){
case 变量引用 in   | case $BOOLEAN in               | case "$1" in
    pattern)       | [yY][eE][sS])                  |         start)
        分支       |         echo 'Thanks' $BOOLEAN |             start
        ;;         |         ;;                     |             ;;
    pattern)       |     [yY]|[nN])                 |         stop)
        分支       |         echo 'Thanks' $BOOLEAN |             stop
        ;;         |         ;;                     |             ;;
    ...            |                                | 
    *)             |       *)                       |         *)
        默认分支   |           exit 1               |             echo $"Usage: $0 {start|stop}"
        exit n     |           ;;                   |             exit 1
esac               |    esac                        | esac

2. Case/switch
case "$1" in
  start | up)
    vagrant up
    ;;

  *)
    echo "Usage: $0 {start|stop|ssh}"
    ;;
esac
EOF
}

bash_t_while(){ cat - <<'EOF'
while CONDITION; do
    循环体
done

CONDITION：循环控制条件，进入循环之前，先做一次判断；每一次循环之后会再次判断；
    条件为"true"，则执行一次循环；直到条件测试状态为false终止；
    因此，CONDITION一般应该有循环控制变量，而此变量的值在循环体中不断被修正；

while循环的特殊用法(遍历文件的每一行)：
while read line; do
循环体
done < /PATH/TO/SOMEFILE

依次读取/PATH/TO/SOMEFILE文件中的每一行，并将行赋值给变量line；
示例：找出ID号为偶数的所有用户，显示其用户名，ID以及shell；
#!/bin/bash
#
while read line; do
    id=$(echo $line | awk -F: '{print $3}')
    if [ $[$id%2] -eq 0 ]; then
        echo $line | awk -F: '{print $1,$3,$7}'
    fi
done < /etc/passwd

echo "abc xyz" | while read line ; do ... done  # 管道 
# 使得while语句在子shell中执行，这意味着while语句内部设置的变量、数组、函数等在循环外部都不再生效。
while read line ; do ... done <<< "abc xyz"     # 字符串
while read line ; do  ... done </path/filename  # 文件
while read var ; do  ... done < <(cmd_list)     # 进程替换
exec <filename                                  # 改变标准输入
while read var ; do ... done                    # 
EOF
}

bash_t_for(){ cat - <<'EOF'
for循环语法：
for VARIABLE in list; do
循环体
done

执行机制：
    依次将列表中的元素赋值给VARIABLE；
    每次赋值后即执行一次循环体；
    直到列表中的元素耗尽，循环结束；
    
seq - print a sequence of numbers    
    seq [OPTION]... LAST
    seq [OPTION]... FIRST LAST
    seq [OPTION]... FIRST INCREMENT LAST

列表生成方式：
    1. 直接给出列表：
        for VARIABLE in item1 item2 item3 ...; do
            ...
        done
        
    2. 整数列表：
        {start..end}
        $(seq FIRST INCREMENT LAST)
        
    3. glob：
        /etc/profile.d/*.sh
        
    4. 返回列表的命令：
        $(COMMAND)
        for VARIABALE in $(ls /etc); do
            ...
        done
        
    5. 变量引用
        $@, $*, ...

for循环的特殊格式：
for ((控制变量初始化；条件判断表达式；控制变量的修正表达式)); do
循环体
done

控制变量初始化：仅在运行到循环代码段时，执行一次；
控制变量的修正表达式：每轮循环结束会先进行控制变量修正运算，而后再做条件判断；

示例：求1-100之间的正整数之和；

#!/bin/bash

declare -i sum=0

for ((i=1;i<=100;i++)); do
let sum+=$i
done
echo "Sum is: $sum"
EOF
}

bash_i_builtin_read(){ cat - <<'EOF'
while read line || [ -n "$line" ] ; do echo "line $line" ; done < file.txt  # 防止文件内容未读完。

read [option ...] [name ...]
-p prompt
-t timeout

bash -n /PATH/TO/SCRIPT_FILE
脚本语法检查
bash -x /PATH/TO/SCRIPT_FILE
脚本调试执行

1. 使用read命令读取字符串到变量中。但是，如果有反斜杠，将起到转义的作用。\\表示一个\号，\<newline>表示续行，\<char>代表<char>本身。
read VAR              read -p <prompt> VAR
read -r VAR           read -p <prompt> -r VAR          # 读取一行文本，但是取消反斜杠的转义作用。
read -s PASSWORD      read -p <prompt> -s PASSWORD     # 读取密码（输入的字符不回显）
read -n <nchars> VAR  read -p <prompt> -n <nchars> VAR # 读取指定数量字符
read -t <seconds> VAR read -p <prompt> -t <seconds> VAR  # 在指定时间内读取
read VAR <file.txt # 对于read命令，可以指定-r参数，避免\转义。
read -r VAR <file.txt # { read -r LINE1; read -r LINE2; read -r LINE3; } <input.txt

EOF
}

bash_t_builtin_read_string(){ cat - <<'EOF'
read ipaddr port <<< $(echo www.netkiller.cn 80)
echo $ipaddr 
echo $port

IFS=':' read -a paths <<< "$PATH" # tokenize array 
PATH=$(IFS=':'; echo "${paths[*]}") 

cut --delimiter=':' --fields=1 /etc/group | sort
EOF
}

bash_t_builtin_read_file(){ cat - <<'EOF'
while IFS= read -r line; do
   echo "$line"
done <file

# If file may not include a newline at the end, then:
while IFS= read -r line || [ -n "$line" ]; do
   echo "$line"
done <file


# Read fields of a file into an array
arr=()
while IFS= read -d : -r field || [ -n "$field" ]; do
   arr+=("$field")
done <file

EOF
}

bash_t_builtin_read_command(){ cat - <<'EOF'
# Let's assume that the field separator is :
while IFS= read -d : -r field || [ -n "$field" ];do
  echo "**$field**"
done < <(ping google.com)

# Or with a pipe:
ping google.com | while IFS= read -d : -r field || [ -n "$field" ];do
  echo "**$field**"
done
EOF
}

bash_t_builtin_read_here(){ cat - <<'EOF'
var='line 1
line 2
line3'
while IFS= read -r line; do
   echo "-$line-"
done <<< "$var"

# Read a string field by field
var='line: 1
line: 2
line3'
while IFS= read -d : -r field || [ -n "$field" ]; do
   echo "-$field-"
done <<< "$var"
EOF
}
bash_t_builtin_read_field(){ cat - <<'EOF'
[Read a file field by field]
while IFS= read -d : -r field || [ -n "$field" ]; do
  echo "$field"
done <file

[Read a string field by field]
var='line: 1
line: 2
line3'
while IFS= read -d : -r field || [ -n "$field" ]; do
  echo "-$field-"
done <<< "$var"

[Read fields of a file into an array]
arr=()
while IFS= read -d : -r field || [ -n "$field" ]; do
  arr+=("$field")
done <file

[Read fields of a string into an array]
var='1:2:3:4:
newline'
arr=()
while IFS= read -d : -r field || [ -n "$field" ]; do
  arr+=("$field")
done <<< "$var"
EOF
}
bash_t_builtin_read_array(){ cat - <<'EOF'
var='line 1
line 2
line3'
readarray -t arr <<< "$var"
# or with a loop:
arr=()
while IFS= read -r line; do
  arr+=("$line")
done <<< "$var"


# Read fields of a string into an array
var='1:2:3:4:
newline'
arr=()
while IFS= read -d : -r field || [ -n "$field" ]; do
   arr+=("$field")
done <<< "$var"
echo "${arr[4]}"
EOF
}

bash_t_builtin_read_passwd(){ cat - <<'EOF'
#!/bin/bash
FILENAME="/etc/passwd"
while IFS=: read -r username password userid groupid comment homedir cmdshell
do
  echo "$username, $userid, $comment $homedir"
done < $FILENAM

FILENAME="/etc/passwd"
while IFS= read -r line; do
  echo "$line"
done < $FILENAME
EOF
}

bash_t_mapfile(){ cat - <<'EOF'
在shell中，内建（builtin）命令readarray和mapfile用法相同，格式如下：
readarray [-n count] [-O origin] [-s count] [-t] [-u fd] [-C callback] [-c quantum] [array] 
mapfile   [-n count] [-O origin] [-s count] [-t] [-u fd] [-C callback] [-c quantum] [array]
readarray命令用于从标准输入或选项“-u”指定的文件描述符fd中读取文本行，然后赋值给索引（下标）数组array，如果不指定数组array，则使用默认的数组名MAPFILE。

下面解释readarray命令中各选项的作用。

"-n count"：复制最多count行，如果count为0，则复制所有的行。
"-O origin"：从下标位置origin开始对数组赋值，默认为0。
"-s count"：忽略开始读取的count行。
"-t"：删除文本行结尾的换行符。
"-u fd"：从文件描述符fd中读取文本行。
"-C callback"：每当读取选项"c"指定的quantum行时（默认为5000行），就执行一次回调callback。
EOF
}

bash_t_test(){ cat - <<'EOF'
组合测试条件：
    逻辑运算：
        第一种方式：
            COMMAND1 && COMMAND2
                [ -e file ] && [ -r file ]
            COMMAND1 || COMMAND2
            ! COMMAND
            
        第二种方式:
            EXPRESSION1 -a EXPRESSION2
                [ -e file -a -r file ]
            EXPRESSION1 -o EXPRESSION2
            ! EXPRESSION
            
            必须使用测试命令进行：
                test
                [ EXPRESSION ]

bash自定义退出状态码：
exit [n]：自定义退出状态码；
注意：脚本中一旦遇到exit命令，脚本立即终止；终止退出后状态取决于exit后面的数字n.

注意：如果未给脚本指定退出状态码，整个脚本的退出状态码取决于脚本中执行的最后一条命令的状态码；
EOF
}

bash_i_start_config(){ cat - <<'EOF'
按生效范围划分，存在两类：
    全局配置：
        /etc/profile
            /etc/profile.d/*.sh
        /etc/bashrc
    个人配置：
        ~/.bash_profile
        ~/.bashrc
        
按功能划分，存在两类：
    profile类：为交互式登录的shell提供配置
        全局：/etc/profile, /etc/profile.d/*.sh
        个人：~/.bash_profile
        功用：
            1. 用于定义环境变量；
            2. 运行命令或脚本；
            
    bashrc类：为非交互式登录的shell提供配置
        全局：/etc/bashrc
        个人：~/.bashrc
        功用：
            1. 定义命令别名；
            2. 定义本地变量；
            
shell登录：
    交互式登录：
        直接通过终端输入账号密码登录；
        使用"su - username"或"su -l username"切换用户；
        /etc/profile --> /etc/profile.d/*.sh --> ~/.bash_profile -->~/.bashrc --> /etc/bashrc
        
    非交互式登录：
        su username；
        图形界面下打开的终端；
        执行脚本；
        ~/.bashrc --> /etc/bashrc --> /etc/profile.d/*.sh
        
配置文件生效的方式：
    1. 重新启动shell进程；
    2. 使用source或.命令读取配置文件；
EOF
}

bash_t_type(){ cat - <<'EOF'
变量类型：
    数据存储格式，空间大小，参与运算种类；
    
    字符型：
    数值型：
    
    强类型：定义变量时必须指定类型，参与运算必须符合类型要求；调用未声明变量会产生错误；
    弱类型：无须指定类型，默认为字符型；参与运算会自动进行隐式类型转换；变量无须事先定义，可直接调用；
    
变量种类：
    本地变量：生效范围为当前shell进程；
    环境变量：生效范围为当前shell进程及其子shell进程；
        declare -x variable; export variable
    局部变量：生效范围为当前shell进程中某代码片段
    位置变量：$1, $2, ...来表示，用于让脚本调用的参数传递
    特殊变量：$?, $0(表示命令本身)
    
本地变量：
    变量赋值：name='value'
        可以使用引用：
            value：
                1. 可以是直接字符串：name="username"
                2. 变量引用：name="$username"
                3. 命令引用：name=`command`,name=$(command)
    变量引用：${name}, $name
        ""：弱引用，其中的变量引用会被替换变量值；
        ''：强引用，其中的变量引用不会被替换变量值，而保持原字符串；
    显示已定义的所有变量：
        set
    撤销变量：
        unset name
        
环境变量：
    变量声明，赋值：
        export name=VALUE
        declare -x name=VALUE
    变量引用：${name}, $name
    显示已定义的环境变量：
        export
        env
        print env
    撤销变量：
        unset name
    bash有许多内建的环境变量：
        PATH,SHELL,UID,HISTSIZE,HOME,PWD,PS1
        
变量命名规则：
    1. 不能使用程序中的保留字：if, for, while, ...
    2. 只能使用数字，字母及下划线，且不能以数字开头；
    3. 见名知义；
        
只读变量：
    readonly name
    declare -r name 
    
位置变量：
    在脚本代码中调用命令行参数：
        $1, $2, ...：对应于参数1，参数2
            shift [n]
            
        $0：命名本身；
        
        $*：命令行所有参数；
        $@：命令行所有参数；
        $#：命令行参数个数；

type命令用来显示指定命令的类型。一个命令的类型可以是如下之一
    alias 别名
    keyword 关键字，Shell保留字
    function 函数，Shell函数
    builtin 内建命令，Shell内建命令
    file 文件，磁盘文件，外部命令
    unfound 没有找到
    
type -a type # type is a shell builtin     <== builtin就是指内建命令
type -a pwd  # pwd is a shell builtin      pwd is /bin/pwd           <== 此乃外部命令
type -a ls   # ls is aliased to `ls --color=tty'     <== 此乃别名
type -a for  # for is a shell keyword           <== 此乃Shell关键字

type命令的基本使用方式就是直接跟上命令名字。
    type -a可以显示所有可能的类型，比如有些命令如pwd是shell内建命令，也可以是外部命令。
    type -p只返回外部命令的信息，相当于which命令。
    type -f只返回shell函数的信息。
    type -t 只返回指定类型的信息。
EOF
}


bash_i_argument_list(){ cat - <<'EOF'
变量名  描述
$0      表示脚本的名字
$1--$9  表示脚本的第一到九个参数
${10}   表示脚本的第十个参数
$#      表示参数的个数
$*,$@   表示所有的参数，有双引号时除外，"$*"表示赋值到一个变量，"$@"表示赋值到多个。
"$*"    "$1 $2 $3 $4 ... "
"$@"    "$1" "$2" "$3" "$4"...
$?      表示Shell命令的返回值
$$      表示当前Shell的pid
$-      表示当前Shell的命令行选项
$!      最后一个放入后台作业的PID值

$_       mkdir -p /foo/bar && mv myfile "$_".
$!       foo ./bar & pid=$!; sleep 10; kill "$pid"; wait "$pid"
EOF
}

bash_i_null(){ cat - <<'EOF'
:   冒号。除了扩展参数以及进行重定向操作之外不做任何事情，返回值为0
    1. 可做while死循环的条件；
    2. 占位符,if某一分支什么都不做的时候；
    3. 域分隔符，比如环境变量$PATH中，或者passwd中，都有冒号的作为域分隔符的存在；
    4. 清空文件。因为冒号不向标准输出任何内容，所以可以用来清空文件，示例：:>file
    5. 配合${:=}给未定义或为空的变量赋值，示例：: ${abc:=1234};echo $abc,输出1234
    6. 注释  : echo "help world" 不输出任何内容

true (or :)
false
EOF
}

bash_i_loops(){ cat - <<'EOF'
for [name] in [words] 
# "for x in foo1 foo2 ... ; do command ; done"，该循环会将 "foo1 foo2 ..." 赋予变量 "x" 并执行 "command"。
for (( [arithmetic expression]; [arithmetic expression]; [arithmetic expression] )) # POSIX 不支持
while [command list]
# "while condition ; do command ; done"，当 "condition" 为真时，会重复执行 "command"。
until [command list]
# "until condition ; do command ; done"，当 "condition" 为假时，会重复执行 "command"。
select [name] in [words] # POSIX 不支持

"break" 可以用来退出循环。              break 2
"continue" 可以用来重新开始下一次循环。

# 模式，扩展模式，数组，字典
for file in *.mp3; do openssl md5 "$file"; done > mysongs.md5
for i in /etc/rc.*; do echo $i done
for i in {1..5}; do echo "Welcome $i" done
for i in {5..50..5}; do echo "Welcome $i" done
for i in "${arrayName[@]}"; do echo $i done

for (( i = 0; i < 50; i++ )); do printf "%02d," "$i"; done

< file.txt | while read line; do echo $line done
while read _ line; do echo "$line"; done < file
while true; do ··· done # forever

until myserver; do echo "My Server crashed with exit code: $?; restarting it in 2 seconds .."; sleep 2; done
select fruit in Apple Pear Grape Banana Strawberry; do (( credit -= 2, health += 5 )); echo "You purchased some $fruit.  Enjoy!"; done
}
第17章 hash
hash(){
hash 命令：用来显示和清除哈希表，执行命令的时候，系统将先查询哈希表。
    当你输入命令，首先在hash表中寻找，如果不存在，才会利用$PATH环境变量指定的路径寻找命令，然后加以执行。
同时也会将其放入到hash table 中，当下一次执行同样的命令时就不会再通过$PATH寻找。以此提高命令的执行效率。

hash        # 显示哈希表中命令使用频率
hash -l     # 显示哈希表
hash -t git # 显示命令的完整路径
hash -p /home/www/deployment/run run # 向哈希表中增加内容
# 命令等同于
PATH=$PATH:$HOME/www/deployment
hash -r # 删除哈希表内容
EOF
}

bash_i_ulimit(){ cat - <<'EOF'
如果系统支持，ulimit命令能够控制shell中的有效资源。选项"-H"、"-S"分别指硬限制、软限制，
硬限制设置好之后不能由非root用户来增加其值，软限制则可能增加到硬限制的值，
这两个选项都不指定时会同时设置它们的值。参数limit可以为数字，也可以是三个特殊的字符串，hard、soft和unlimited，不设置limit时显示当前软限制值，此时除非设置了"-H"才显示硬限制值。
下面是ulimit命令其它选项的含义。
"-a"：显示当前所有的限制。
"-b"：套接字socket缓冲的最大长度。
"-c"：可创建的core文件的最大个数。
"-d"：一个进程的数据段的最大长度。
"-e"：调度优先级即nice的最大值。
"-f"：shell及其子进程写文件时的最大长度。
"-i"：等待的信号的最大个数。
"-l"：锁在内存中最大长度。
"-m"：常驻内存的最大值（许多系统不支持这个限制）。
"-n"：打开的文件描述符的最大个数（许多系统禁止设置这个限制）。
"-p"：块block大小为512字节的管道长度。
"-q"：POSIX消息队列的最大字节数。
"-r"：实时调度的最大优先级。
"-s"：堆栈stack的最大长度。
"-t"：累计CPU时间（秒）的最大值。
"-u"：单个用户可以拥有的进程的最大个数。
"-v"：shell可用的虚拟内存的最大值。
"-x"：文件锁的最大个数。
"-T"：最大线程数。
EOF
}

bash_i_option(){ cat - <<'EOF'
bash [长选项] [-ir] [-abefhkmnptuvxdBCDHP] [-o选项] [-Oshopt 选项] [参数...]
bash [长选项] [-abefhkmnptuvxdBCDHP]       [-o选项] [-Oshopt 选项] -c string [参数...]
bash [长选项] -s [-abefhkmnptuvxdBCDHP]    [-o选项] [-Oshopt 选项] [参数...]
要想正确解析命令行，多字符必须出现在单字符选项的前面。
--debugger 在shell启动前准备调试器分析。打开扩展的调试模式和shell函数的跟踪。
--dump-po-strings 在标准输出中打印"$"后面的双引用字符串。除了输出的格式，其它和"-D"选项是等价的。
--dump-strings 和"-D"选项等价。
--help 在标准输出中打印使用帮助后成功退出。
--init-file文件名
--rcfile文件名 在交互式的shell中执行文件名(而不是~/.bashrc天 中的命令。
--login 和"-l"选项等价。
--noediting 当shell交互式运行时，不使用GNU ReadLine库来读取命令行。
--noprofile 当Bash作为登录shell启动时，不加载系统或个人的初始化文件/etc/profile、~/.bashprofile、~/.bashlogin、~/.profile。
--norc 在交互式的shell中，不读取初始化文件~/.bashrc。如果用sh来启动shell，这个选项默认就打开了。
--posix 如果Bash的默认行为与POSIX不同，就遵循POSIX规范。这个选项是用来让Bash成为该规范的一个超集。
--restricted 打开受限制模式。
--verbose 和"-v"选项等价，回显读取的输入行。
--version 在标准输出中显示当前Bash的版本信息后成功退出。
启动时还可以指定一些单字符选项；这些选项是内部命令set所没有提供的。
-c字符串 处理完选项以后从字符串中读取命令并执行，然后退出。剩余的参数赋值给从$0开始的位
置参数。助记词: Command, 命令字符串
-i 强制shell交互式的运行。助记词: Interactive, 交互
的
-l 使当前shell 表现得像登录后直接启动的那样。在交互式的shell 中，这和用exec -l bash命令启
   动的登录shell 是等价的。如果不是交互式的shell，则执行登录shell 的初始化文件。exec bash -l
   或exec bash --login将把当前的shell 替换成一个登录shell。关于登录shell 的特殊行为，
-r 把当前shell变为受限制的shell。助记词: Login, 登录的
-s 如果给定了这个选项，或者处理选项以后没有剩余的参数，则从标准输入读取命令。这个选项可以
    用来在启动交互式的shell时指定位置参数。助记词: Startupfile, 初始化文件
-D 在标准输出中打印所有"$"后面的双引用字符串。如果当前的语言区域不是C或POSIX，则要对这些字符串进行翻译。这个选项隐含了"-n"选项，并
   且不执行命令。助记词: Debug, 语言翻译调试
-- 单个--表示选项的结束并停止继续处理选项。它后面的任何参数都被当成文件名或参数。
EOF
}

bash_i_sh_env_variable(){ cat - <<'EOF'
CDPATH  冒号分隔的一组目录名，用作内部命令cd的搜索路径。
HOME    当前用户的主目录，也是内部命令cd的默认值。这个变量的值还用在波浪号扩展中。
IFS     用来分隔字段的一组字符；在扩展时，shell用它来拆分单词。
MAIL    如果这个变量设为一个文件名，并且没有设置MAILPATH变量，Bash将通知用户在指定文件中有新邮件。
MAILPATH 冒号分隔的一级文件名，shell会定期在这些文件中检查新邮件。每个文件名都可以名称后面
         用"?"分隔，然后指定一条消息，当新邮件到达时将把这条消息打印出来。在消息文本中，$ 扩展成当前邮箱文件名
OPTARG 内部命令getopts处理的最后一个选项。
OPTIND 内部命令getopts处理的最后一个选项参数。
PATH 冒号分隔的一组目录，shell用它来搜索命令。长度为零的目录名表示当前目录，它可以作为两个连在一起的冒号出现，也可以作为开始或结束的冒号出现。
PS1 主提示符，它的默认值是[\u@\h \W]\$。
PS2 第二提示符。默认值是">"
EOF
}
bash_i_env_variable(){ cat - <<'EOF'
BASH    执行当前Bash所用的完整路径。
BASHPID 扩展为当前bash进程的进程号。子女shell中，这时Bash不会重新初始化
BASHALIASES 一个键值数组变量，其中的元素和内部命令alias 所维护的别名列表相对应.
BASH_ARGC
BASH_ARGV
BASH_CMDS
BASH_COMMAND
BASH_ENV
BASH_EXECUTION_STRING
BASH_LINENO
BASH_REMATCH

a='I am a simple string with digits 1234'
pat='(.*) ([0-9]+)'
[[ "$a" =~ $pat ]]
echo "${BASH_REMATCH[0]}"
echo "${BASH_REMATCH[1]}"
echo "${BASH_REMATCH[2]}"

BASH_SOURCE
BASH_SUBSHELL
BASH_VERSINFO
  BASHVERSINFO[0]
  BASHVERSINFO[1]
  BASHVERSINFO[2]
  BASHVERSINFO[3]
  BASHVERSINFO[4]
  BASHVERSINFO[5]
BASH_VERSION
LANG         用来指定语言类别，如果这个类别没有特别地用LC 开头的变量指定。
LC_ALL       这个变量覆盖LANG和所有其它LC 变量指定的语言类别。
LC_COLLATE   这个变量决定文件名扩展结果的排序顺序，以及文件名扩展和文件名匹配中的范围表达式、等价字符类、语言区域序列
LC_CTYPE     这个变量决定文件名扩展和模式匹配中对字符的解释和字符类的行为
LC_MESSAGES  这个变量决定翻译$后面的双引用字符串时所使用的语言区域。
LC_NUMERIC   这个变量决定格式化数字时所使用的语言区域。
FUNCNAME
EOF
}


bash_i_link(){ cat - <<'EOF'
1. 和号操作符 (&):
'&'的作用是使命令在后台运行。只要在命令后面跟上一个空格和 '&'。你可以一口气在后台运行多个命令。
ping ­c5 www.tecmint.com &
apt-get update & mkdit test &
2. 分号操作符 (;)
分号操作符使你可以一口气运行几个命令，命令顺序执行。
apt-get update ; apt-get upgrade ; mkdir test
3. 与操作符 (&&)
如果第一个命令执行成功，与操作符 (&&)才会执行第二个命令，也就是说，第一个命令退出状态是0。
ping -c3 www.tecmint.com && links www.tecmint.com
4. 或操作符 (||)
或操作符 (||)很像编程中的else语句
操作符允许你在第一个命令失败的情况下执行第二个命令，比如，第一个命令的退出状态是1。
5. 非操作符 (!)
非操作符 (!)很像except语句。这个命令会执行除了提供的条件外的所有的语句。
mkdir tecmint 
cd tecmint 
touch a.doc b.doc a.pdf b.pdf a.xml b.xml a.html b.html
rm -r !(*.html)
6. 与或操作符 (&& – ||)
ping -c3 www.tecmint.com && echo "Verified" || echo "Host Down"
7. 管道操作符 (|)
ls -l | less
8. 命令合并操作符 {}
合并两个或多个命令，第二个命令依赖于第一个命令的执行。
[ -f /home/tecmint/Downloads/xyz.txt ] || touch /home/tecmint/Downloads/xyz.txt; echo "The file does not exist"
[ -f /home/tecmint/Downloads/xyz1.txt ] || {touch /home/tecmint/Downloads/xyz.txt; echo "The file does not exist"}
9. 优先操作符 ()
这个操作符可以让命令以优先顺序执行。
Command_x1 &&Command_x2 || Command_x3 && Command_x4.
如果Command_x1执行失败了会怎么样，Command_x2, Command_x3, Command_x4没有一个会执行，对于这种情况，我们使用优先操作符。
(Command_x1 &&Command_x2) || (Command_x3 && Command_x4)
在上面的伪代码中，如果Command_x1执行失败，Command_x2不会执行，但是Command_x3会继续执行， Command_x4会依赖于 Command_x3的退出状态。
10. 连接符 (\)
被用于连接shell中那些太长而需要分成多行的命令。可以在输入一个“\”之后就回车，然后继续输入命令行，直到输入完成。
EOF
}

bash_i_readline(){ cat - <<'EOF'
第21章 Readline
1. 移动命令 C-a C-e M-f M-b   C-f C-b C-l    
2. 删除命令 C-k C-u M-d M-Del C-w 
3. 粘贴命令 C-y M-y
4. 搜索历史 C-r C-s 
inputrc -> Readline的配置文件

条目指示符
!                    开始历史替换，除非后面跟着空格、制表符、行结束符、"="、或")"。
!n                   选择命令行n。
!-n                  选择向后第n行命令。
!!                   选择前一条命令，它和"!-1"是等价的。
!字符串              选择最近以字符串开头的命令。
!?字符串[?           ]选择最近包含字符串开头的命令。如果字符串后面紧跟着换行符就可以省略结尾的"?"。
^字符串一^字符串二^  快速替换。重复最后的命令，并把字符串一替换成字符串二；它和!!:s/字符串一/字符串二是等价的。
!#                   目前已经输入的整个命令。
单词指示符
条目指示符和单词指示符之间用":"分隔；如果单词指示符以"^"、"$"、"*"、"-"、"%"开头，则可以省略分隔符。
单词从行首开始数起，第一单词序号为0。插入到当前行中时，这些单词用空格分开。
!!                  指定前一条命令。如果输入这个指示符则整个重复前一条命令。
!!:$                指定前一条命令的最后一个参数；可以简写为!$。
!fi:2               指定最近以字母fi开头的命令的第二个参数。
下面是单词指示符：
0     即零，第零个单词。对大多数命令而言，它是指命令名。
n     第n个单词。
^     第一个参数夨单词天。
$     最后一个参数。
%     最近"?字符串?"匹配的单词。
x-y   单词范围。"0-y"可以简写为"-y"。
*     除了第零个以外的所有单词，和"1-$"同义。如果条目中只有一个单词，使用"*"也不会出错，而是返回空字符串。
x*    "x-$"的简写形式。
x-    和"x*"一样,"x-$"的简写形式,但是忽略掉最后一个单词
EOF
}