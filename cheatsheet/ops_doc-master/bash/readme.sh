shellcheck:用于检查shell语法错误                                                                 
shellexplain：用于解析shell的语法                                                                
bashdb：shell的debugger,  http://bashdb.sourceforge.net/bashdb.html#Command-Index               还是很有用的
bats：用于对命令或者shell进行单元测试  :https://github.com/sstephenson/bats
log4bash-master： 用于shell对外输出[常于输出颜色]
log4shell-master：用于shell对外输出[常于多目的输出]
                                             
Bash_Source：是IBM上获取的https://www.ibm.com/developerworks/cn/aix/library/au-getstartedbash/   
bash-boilerplate-master:通过一些学习的东西   

bashdb(help)
{
bashdb [options] script-name [--] [script options]
bashdb [options] -c execution-string
bash --debugger [bash-options...] script-name [[--] script options]

-A | --annotation level
#set annotation LEVEL 注释
-B | --basename
#set basename on
-n | nx
#~/.bashdbinit 不读取此文件
-c command-string #调试执行命令行
-q | --quiet #不输出版本和开源条款信息
-x debugger-cmdfile # 指定.bashdbinit
-L | --library debugger-library #../lib/bashdb
-t | --tty tty-name # 
-X | --trace # 类似set -x
}
bashdb(bashdb --debug 脚本名)
{

使用bashdb进行debug的常用命令
1.列出代码和查询代码类：
    l   列出当前行以下的10行
    -   列出正在执行的代码行的前面10行
    .   回到正在执行的代码行
    w  列出正在执行的代码行前后的代码
    /pat/  向后搜索pat
2.Debug控制类：
    h  帮助
    help 命令  得到命令的具体信息
    q  退出bashdb
    x 算数表达式  计算算数表达式的值，并显示出来
    !!空格Shell命令 参数  执行shell命令
    使用bashdb进行debug的常用命令(cont.)
3.控制脚本执行类：
    n   执行下一条语句，遇到函数，不进入函数里面执行，将函数当作黑盒
    s n  单步执行n次，遇到函数进入函数里面
    b 行号n  在行号n处设置断点
    del 行号n 撤销行号n处的断点
    c 行号n 一直执行到行号n处
    R  重新启动
    Finish 执行到程序最后
    cond n expr 条件断点
}

bashdb(命令详解)
{

    !! (shell)
    ![-]n (history)
    # (a comment)    
    alias name command
    b (break)
    backtrace
    break
    bt (backtrace)   
    c (continue)
    cd [directory]
    clear
    commands
    condition
    continue
    d (clear)
    de (delete)
    debug
    delete
    delete display
    dis (disable)
    disable	
    disable breakpoints
    disable display
    display
    do (down)
    down

    e (eval)
    edit [line-specification]
    enable
    enable breakpoints
    enable display
    end
    eval
    examine
    
    file
    finish
    forward
    frame
    
    h (help)
    H [start-number [end-number]]
    handle
    history [-][n]
    
    i (info)
    info
    info args
    info breakpoints
    info breakpoints
    info display
    info display
    info files
    info functions
    info line
    info program
    info signals
    info signals
    info source
    info stack
    info terminal
    info terminal
    info variables
    info variables
    
    k (kill)
    
    l (list)
    list
    
    
    s (step)
    search
    set annotate
    set args
    set autoeval [ on | 1 | off | 0 ]
    set autolist [ on | 1 | off | 0 ]
    set basename
    set debugger
    set editing
    set history save
    set history size
    set linetrace
    set listsize
    set logging
    set prompt
    set showcommand
    set trace-commands
    shell (shell)
    show args
    show autoeval
    show copying
    show editing
    show history
    show listsize
    show prompt
    show version
    show warranty
    shows
    signal
    silent
    skip
    source
    step
}
bats(help)
{
-c:只计算单元测试个数，不进行任何测试
-p:以pretty的格式输出
-t:以tap的格式输出
test,setup,teardown函数的正常输出和错误输出，都统一输出到错误输出。

}
bats(Bash Automated Testing System)
{

#!/usr/bin/env bats

@test "addition using bc" {
  result="$(echo 2+2 | bc)"
  [ "$result" -eq 4 ]
}

@test "addition using dc" {
  result="$(echo 2 2+p | dc)"
  [ "$result" -eq 4 ]
} 

从bats addition.bats 到 bats --tap addition.bats
# 单文件
bats addition.bats
# 多文件
bats bats/*.bats

}
bats(run:Test other commands)
{

@test "invoking foo with a nonexistent file prints an error" {
  run foo nonexistent_filename
  [ "$status" -eq 1 ]
  [ "$output" = "foo: no such file 'nonexistent_filename'" ]
}

$status: foo命令执行状态码
$output: foo命令执行的正常输出和错误输出

@test "invoking foo without arguments prints usage" {
  run foo
  [ "$status" -eq 1 ]
   [ "${lines[0]}" = "usage: foo <filename>" ]
}
$lines数组：foo命令输出的每行内容

}

bats(load:Share common code)
{
load test_helper
相当于包含test_helper.bash文件；include包含的意思。
}

bats(skip: Easily skip tests)
{
@test "A test I don't want to execute for now" {
  skip
  run foo
   [ "$status" -eq 0 ]
}
skip:略过测试单元

skip:提示掠过测试原因
@test "A test I don't want to execute for now" {
  skip "This command will return zero soon, but not now"
  run foo
  [ "$status" -eq 0 ]
}

skip:条件性判断略过
@test "A test which should run" {
  if [ foo != bar ]; then
    skip "foo isn't bar"
  fi

  run foo
  [ "$status" -eq 0 ]
}

}

bats(setup and teardown: Pre- and post-test hooks)
{
setup    : 每个测试单元开始前执行
teardown : 每个测试单元接收后执行
}

bats(Special variables)
{
$BATS_TEST_FILENAME is the fully expanded path to the Bats test file.
$BATS_TEST_DIRNAME is the directory in which the Bats test file is located.
$BATS_TEST_NAMES is an array of function names for each test case.
$BATS_TEST_NAME is the name of the function containing the current test case.
$BATS_TEST_DESCRIPTION is the description of the current test case.
$BATS_TEST_NUMBER is the (1-based) index of the current test case in the test file.
$BATS_TMPDIR is the location to a directory that may be used to store temporary files.
}

bats(example)
{
Adept - https://github.com/technopagan/adept-jpg-compressor/tree/master/unittests
azk - https://github.com/azukiapp/azk/tree/master/spec/integration
azk - https://github.com/azukiapp/azk/tree/pure-bash/test/cli
bash-preexec - https://github.com/rcaloras/bash-preexec/tree/master/test
BSFL - https://github.com/SkypLabs/bsfl/tree/master/test
cf4ocl - https://github.com/fakenmc/cf4ocl/tree/master/tests/utils
docker-machine - https://github.com/docker/machine/tree/master/test/integration
docker-mailserver - https://github.com/tomav/docker-mailserver/tree/master/test
docker-swarm - https://github.com/docker/swarm/tree/master/test
dokku - https://github.com/progrium/dokku/tree/master/tests/unit
Doily - https://github.com/relsqui/doily/tree/master/tests
Ellipsis - https://github.com/ellipsis/ellipsis/tree/master/test
Ellipsis-TPM - https://github.com/ellipsis/ellipsis-tpm/tree/master/test
envirius - https://github.com/ekalinin/envirius
Ethereum Classic - https://github.com/ethereumproject/go-ethereum
Foreman - https://github.com/theforeman/foreman-bats
Freight - https://github.com/freight-team/freight/tree/master/test
github-markdown-toc - https://github.com/ekalinin/github-markdown-toc/tree/master/tests
git-secret - https://github.com/sobolevn/git-secret/tree/master/tests
govmomi - https://github.com/vmware/govmomi/tree/master/govc/test
grunt-install - https://github.com/GochoMugo/grunt-install/tree/master/test
Idol - https://github.com/kaizoku0506/idol
lx_kitchen (LX container tests) - https://github.com/bixu/lx_kitchen/tree/master/test/integration/default/bats
msu - https://github.com/GochoMugo/msu/tree/master/test
node-build - https://github.com/oinutter/nodenv/tree/master/test
openvpn-unroot - https://github.com/wknapik/openvpn-unroot/tree/master/test
nodenv - https://github.com/oinutter/nodenv/tree/master/test
rbenv - https://github.com/sstephenson/rbenv/tree/master/test
ruby-build - https://github.com/sstephenson/ruby-build/tree/master/test
runC - https://github.com/opencontainers/runc/tree/master/tests/integration
Shy - https://github.com/aaronroyer/shy/tree/master/test
spacecat - https://github.com/telemachus/spacecat/tree/master/test
vagrant-cachier - https://github.com/fgrehm/vagrant-cachier/blob/master/spec/acceptance/sanity_check.bats
shellfactory - https://github.com/cchaudier/shellfactory
}
tap(Test Anything Protocol)
{
    TAP, the Test Anything Protocol, is a simple text-based interface between testing modules in a test harness. 
TAP started life as part of the test harness for Perl but now has implementations in C, C++, Python, PHP, 
Perl, Java, JavaScript, and others.

Here’s what a TAP test stream looks like:
1..4
ok 1 - Input file opened
not ok 2 - First line of the input valid
ok 3 - Read the rest of the file
not ok 4 - Summarized correctly # TODO Not written yet

http://testanything.org/testing-with-tap/c-plus-plus.html
g++ -ltap++ tap-synopsis.o -o tap-synopsis


}