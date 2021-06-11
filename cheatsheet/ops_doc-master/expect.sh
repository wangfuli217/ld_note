Expect是一个控制交互式程序的工具。用非交互的方式实现了所有交互式的功能。
写交互式程序的脚本和写非交互式程序的脚本一样简单。Expect还可以用于对对话的一部分进行自动化，因为程序的控制可以在键盘和脚本之间进行切换。
Expect提供了创建交互式进程和读写它们的输入和输出的命令。

1，使用"-c"选项，从命令行执行expect脚本
2，使用"-i"选项交互地执行expect脚本
3，当执行expect脚本的时候，输出调试信息当你用"-d"选项执行代码的时候，你可以输出诊断的信息。
4，使用"-D"选项启动expect调试器
5，逐行地执行expect脚本"-b"选项可以让expect一次只读取脚本中的一行
6，让expect不解释命令行参数

autoexpect(){
    运行autoexpect -p就进入autoexpect创建的shell中，然后输入的命令交互都被记录下来，最后输入exit退出，
expect脚本被保存在script.exp中。

autoexpect -p -f ssh.exp
}
expect(telnet){

#!/usr/bin/expect
set timeout 30
spawn telnet 192.168.3.232
expect "rdmcu login:"
send "root\r"
expect "Password:"
send "123456\r"
interact
}

expect(ssh){

#!/usr/bin/expect
set timeout 30
spawn telnet root@192.168.10.202
expect "root@192.168.10.202's password:"
send "123456\r"
interact
}

expect(ftp){

#!/usr/bin/expect -f  
 set ip [lindex $argv 0 ]  
 set dir [lindex $argv 1 ]  
 set file [lindex $argv 2 ]  
 set timeout 10  
 spawn ftp $ip  
 expect "Name*"  
 send "zwh\r"  
 expect "Password:*"  
 send "zwh\r"  
 expect "ftp>*"  
 send "lcd $dir\r"  
 expect {  
 "*file"  { send_user "local $_dir No such file or directory";send "quit\r" }  
 "*now*"  { send "get $dir/$file $dir/$file\r"}  
 }  
 expect {  
 "*Failed" { send_user "remote $file No such file";send "quit\r" }  
 "*OK"     { send_user "$file has been download\r";send "quit\r"}  
 }  
 expect eof
 
坚持－－如果连接或者传输失败，你就可以每分钟或者每小时，甚至可以根据其他因素，比如说用户的负载，来进行不定期的重试。
通知－－传输时可以通过mail,write或者其他程序来通知你，甚至可以通知失败。
初始化－每一个用户都可以有自己的用高级语言编写的初始化文件(比如说，.ftprc)。这和C shell对.cshrc的使用很类似。
}
expect(fsck){

这个脚本一开始先派生fsck进程，然后对其中两种类型的问题回答"yes"，而对其他的问题回答"no"
for {} {1} {} {
    expect
        eof        break
        "*UNREF FILE*CLEAR?"    {send "r "}
        "*BAD INODE*FIX?"    {send "y "}
        "*?"            {send "n "}
}

for {} {1} {}{
    expect
        eof        break
        "*UNREF FILE*CLEAR?"    {send "y "}
        "*BAD INODE*FIX?"    {send "y "}
        "*?"            {interact +}
}
两个问题的回答是不同的。而且，如果脚本遇到了什么它不能理解的东西，就会执行interact命令把控制交给用户。
用户的击键直接交给fsck处理。当执行完后，用户可以通过按"+"键来退出或者把控制交还给expect。
如果控制是交还给脚本了，脚本就会自动的控制进程的剩余部分的运行。
}
expect(简介){
Expect是在Tcl基础上创建起来的，它还提供了一些Tcl所没有的命令
  spawn命令激活一个Unix程序来进行交互式的运行。
  send命令向进程发送字符串。
  expect命令等待进程的某些字符串。expect支持正规表达式并能同时等待多个字符串，并对每一个字符串执行不同的操作。
    expect还能理解一些特殊情况，如超时和遇到文件尾。
    expect命令和Tcl的case命令的风格很相似。都是用一个字符串去匹配多个字符串。
    expect patlist1 action1 patlist2 action2.....
    该命令一直等到当前进程的输出和以上的某一个模式相匹配，或者等到时间超过一个特定的时间长度，或者等到遇到了文件的结束为止。
    如果最后一个action是空的，就可以省略它。
    每一个patlist都由一个模式或者模式的表(lists)组成。如果有一个模式匹配成功，相应的action就被执行。执行的结果从expect返回。
    
    被精确匹配的字符串(或者当超时发生时，已经读取但未进行匹配的字符串)被存贮在变量expect_match里面。
    如果patlist是eof或者timeout，则发生文件结束或者超时时才执行相应的action。
    一般超时的时值是10秒，但可以用类似"set timeout 30"之类的命令把超时时值设定为30秒。
    
    下面的一个程序段是从一个有关登录的脚本里面摘取的。abort是在脚本的别处定义的过程，而其他的action使用类似与C语言的Tcl原语。
    expect "*welcome*" break
    "*busy*" {print busy;continue}
    "*failed*" abort
    timeout abort
    模式是通常的C Shell风格的正规表达式。模式必须匹配当前进程的从上一个expect或者interact开始的所有输出(所以统配符*使用的非常的普遍)。
    但是，一旦输出超过2000个字节，前面的字符就会被忘记，这可以通过设定match_max的值来改变。
    
    expect命令确实体现了expect语言的最好和最坏的性质。特别是，expect命令的灵活性是以经常出现令人迷惑的语法做代价。
    除了关键字模式 (比如说eof,timeout)那些模式表可以包括多个模式。这保证提供了一种方法来区分他们。但是分开这些表
    需要额外的扫描，如果没有恰当的用'"'括起来，这有可能会把和当成空白字符。由于Tcl提供了两种字符串引用的方法:单引
    和双引，情况变的更糟。(在Tcl里面，如果不会出现二义性话， 没有必要使用引号)。在expect的手册里面，还有一个独立的
    部分来解释这种复杂性。幸运的是：有一些很好的例子似乎阻止了这种抱怨。但是，这个复杂性很有可能在将来的版本中再度出现。
    为了增强可读性，在本文中，提供的脚本都假定双引号是足够的。
    
    字符可以使用反斜杠来单独的引用，反斜杠也被用于对语句的延续，如果不加反斜杠的话，语句到一行的结尾处就结束了。
    这和Tcl也是一致的。Tcl在发现有开的单引号或者开的双引号时都会继续扫描。
    而且，分号可以用于在一行中分割多个语句。这乍听起来有点让人困惑，但是，这是解释性语言的风格，但是，这确实是Tcl的不太漂亮的部分。
    
  callback 
  令人非常惊讶的是，一些小的脚本如何的产生一些有用的功能。
  下面是一个拨电话号码的脚本。他用来把收费反向，以便使得长途电话对计算机计费。这个脚本用 类似"expect callback.exp 12016442332"来激活。
  其中，脚本的名字便是callback.exp，而+1(201)644-2332是要拨的电话号码。
  #first give the user some time to logout
  exec sleep 4 # 如何调用没有交互的Unix程序。sleep 4会使程序阻塞4秒，以使得用户有时间来退出，因为modem总是会回叫用户已经使用的电话号码。
  spawn tip modem # 使用spawn命令来激活tip程序，以便使得tip的输出能够被expect所读取，使得tip能从send读输入。一旦tip说它已经连接上，modem就会要求去拨打电话号码。
  expect "*connected*"
  send "ATD [lindex $argv 1]\r" # 命令行参数存贮在一个叫做argv的表里面
  #modem takes a while to connect
  set timeout 60
  expect "*CONNECT*"
}
expect(passwd){
spawn passwd [lindex $argv 1] # 用户名做参数启动passwd程序
set password [lindex $argv 2] # 把密码存到一个变量里面。和shell类似，变量的使用也不需要提前声明。
expect "*password:"  # expect搜索模式"*password:"，其中*允许匹配任意输入，所以对于避免指定所有细节而言是非常有效的。
send "$password\r"   # 把密码送给当前进程，\r表明回车。
expect "*password:"
send "$password\r"
expect eof       # "expect eof"这一行的作用是在passwd的输出中搜索文件结束符，这一行语句还展示了关键字的匹配。
}
expect(passwd){
spawn passwd [lindex $argv 1]
expect eof               {exit 1}    # 1表示非预期的死亡
    timeout              {exit 2}    # 2表示锁定
    "*No such user.*"    {exit 3}
    "*New password:"
send "[index $argv 2]\r"
expect eof                   {exit 4}
    timeout                  {exit 2}  # 2表示锁定
    "*Password too long*"    {exit 5}
    "*Password too short*"   {exit 5}
    "*Retype new password:"
send "[index $argv 3] "
expect timeout               {exit 2}  # 2表示锁定
    "*Mismatch*"             {exit 6}
    "*Password unchanged*"   {exit 7}
    " "
expect timeout               {exit 2}  # 2表示锁定
    "*"                      {exit 6}
    eof                                 # 0表示passwd程序正常运行，
}
expect返回字符串和返回数字是一样简单的，即使是派生程序自身产生的消息也是一样的。即使是派生程序自身产生的消息也是一样的。
实际上，典型的做法是把整个交互的过程存到一个文件里面，只有当程序的运行和预期一样的时候才把这个文件删除。否则这个log被留待以后进一步的检查。
passwd.exp    3    bogus    -        -
passwd.exp    0    fred    abledabl    abledabl
passwd.exp    5    fred    abcdefghijklm    -
passwd.exp    5    fred    abc        -
passwd.exp    6    fred    foobar        bar
passwd.exp    4    fred    ^C        -
第一个域的名字是要被运行的回归脚本。
第二个域是需要和结果相匹配的退出值。
第三个域就是用户名。
第四个域和第五个域就是提示时应该输入的密码。
减号仅 仅表示那里有一个域，这个域其实绝对不会用到。
^C就是被切实的送给程序来验证程序是否恰当的退出。

expect(rogue和伪终端){
Unix用户肯定对通过管道来和其他进程相联系的方式非常的熟悉;
expect使用伪终端来和派生的进程相联系。伪终端提供了终端语义以便程序认为他们正在和真正的终端进行I/O操作。
}
expect(控制多个进程：作业控制){
expect的作业控制概念精巧的避免了通常的实现困难。其中包括了两个问题：
  一个是expect如何处理经典的作业控制，即当你在终端上按下^Z键时expect如何处理；
    问题的处理是：忽略它。expect对经典的作业控制一无所知。
    比如说，你派生了一个程序并且发送一个^Z给它，它就会停下来(这是伪终端的完美之处)而expect就会永远的等下去。
    
    从用户的角度来看是象这样的：当一个进程通过spawn命令启动时，变量spawn_id就被设置成某进程的描述符。
    由spawn_id描述的进程就被 认为是当前进程。expect和send命令仅仅和当前进程进行交互。所以，切换一个作业所需要做的仅仅是把该进程的描述符赋给spawn_id。
  一个就是expect是如何处理多进程的。
  
  
spawn chess            ;# start player one
set id1    $spawn_id
expect "Chess "
send "first "            ;# force it to go first
read_move
 
spawn chess            ;# start player two
set id2    $spawn_id
expect "Chess "
 
for {} {1} {}{
    send_move
    read_move
    set spawn_id    $id1
 
    send_move
    read_move
    set spawn_id    $id2
}
在派生完两个进程之后，一个进程被通知先动一步。在下面的循环里面，每一步动作都送给另外一个进程。其中，
read_move和 write_move两个过程留给读者来实现。

spawn tip /dev/tty17     ;# open connection to  连接到一个终端
set tty $spawn_id        ;# tty to be spoofed
 
spawn login               # 连接到一个login进程
set login $spawn_id
 
log_user 0  # 通过命令"log_user 0"来禁止这个功能。(有很多的命令来控制可以看见或者可以记录的东西)。
 
for {} {1} {} {
    set ready [select $tty $login] # select等待终端或者login进程上的动作，并且返回一个等待输入的spawn_id表。
# 如果在表里面找到了一个值的话，case就执行一个 action。
    case $login in $ready {
        set spawn_id $login
# 比如说，如果字符串"login"出现在login进程的输出中，提示就会被记录到标准输出上，并且有一个标志被设置以便通知
# 脚本开始记录 用户的击键，直至用户按下了回车键。无论收到什么，都会回显到终端上，一个相应的action会在脚本的
# 终端那一部分执行。
        expect
          {"*password*" "*login*"}{
              send_user $expect_match # 缺省的，所有的对话都记录到标准输出上(通过send_user)。
              set log 1               
             }
          "*"        ;# ignore everything else
        set spawn_id    $tty;
        send $expect_match
    }
    case $tty in $ready {
        set spawn_id    $tty
        expect "* *"{
                if $log {
                  send_user $expect_match
                  set log 0
                }
               }
            "*" {
                send_user $expect_match
               }
        set spawn_id     $login;
        send $expect_match
    }
}
冒充程序。它能够控制一个终端以便用户能够登录和正常的工作。但是，一旦系统提示输入密码或者输入用户名的时候，
expect就开始把击键记下来，一直到用户按下回车键。这有效的收集了用户的密码和用户名，还避免了普通的冒充程序的
"Incorrect password-tryagain"。而且，如果用户连接到另外一个主机上，那些额外的登录也会被记录下来。
}
如果使用expect的话，可以使用它的交互式的作业控制来驱动shell。一个派生的shell认为它是在交互的运行着，所以会正常的处理作业控制。
它不仅能够解决检验处理作业控制的shell和其他一些程序的问题。还能够在必要的时候，让shell代替expect 来处理作业。可以支持使用shell 风格的作业控制来支持进程的运行。
这意味着：首先派生一个shell，然后把命令送给shell来启动进程。如果进程被挂起，比如说，发送了一个^Z，进程就会停下来，并把控制返回给shell。对于expect而言，它还在处理同一个进程(原来那个shell)。

expect(shell){
为了进一步的控制，在interact执行期间，expect把控制终端(是启动expect的那个终端，而不是伪终端)设置成 生模式 
以便字符能够正确的传送给派生的进程。当expect在没有执行interact的时候，终端处于 熟模式 下，这时候作业控制就
可以作用于expect本身。

expect从标准输入中读取输入和从进程中读取输入一样的简单。但是，我们要使用 expect_user和send_user来进行标准I/O，
同时不改变spawn_id。

在一定的时间内从标准输入里面读取一行。这个脚本叫做timed_read，可以从csh里面调用，比如说，set answer="timed_read 30"
就能调用它。
set timeout [index $argv 1]  # 如果在特定的时间内没有得到任何键入，则返回也为空。
expect_user "* "         # 用户那里接收任何以新行符结束的任何一行。
send_user $expect_match  # 把它返回给标准输出。
支持"#!"的系统直接的启动脚本。
在-c后面的选项在任何脚本语句执行前就被执行。比如说，不要修改脚本本身，仅仅在命令行上加上-c "trace..."，该脚本可以加上trace功能了

在命令行里实际上可以加上多个命令，只要中间以";"分开就可以了。比如说，下面这个命令行：
expect -c "set timeout 20;spawn foo;expect"
一旦你把超时时限设置好而且程序启动之后，expect就开始等待文件结束符或者20秒的超时时限。如果遇到了文件结束符(EOF)，
该程序就会停下来，然后expect返回。如果是遇到了超时的情况，expect就返回。在这两中情况里面，都隐式的杀死了当前进程。
}


四个命令
Expect中最关键的四个命令是send,expect,spawn,interact。

send：用于向进程发送字符串
expect：从进程接收字符串
spawn：启动新的进程
interact：允许用户交互

expect(send命令)
{
send命令接收一个字符串参数，并将该参数发送到进程。

expect1.1> send "hello world\n"
hello world
}
expect(expect命令)
{
    expect命令和send命令正好相反，expect通常是用来等待一个进程的反馈。expect可以接收一个字符串参数，也可以接收
正则表达式参数。和上文的send命令结合，现在我们可以看一个最简单的交互式的例子：

expect "hi\n"
send "hello there!\n"

这两行代码的意思是：从标准输入中等到hi和换行键后，向标准输出输出hello there。

tips： $expect_out(buffer)存储了所有对expect的输入，<$expect_out(0,string)>存储了匹配到expect参数的输入。

比如如下程序：

expect "hi\n"
send "you typed <$expect_out(buffer)>"
send "but I only expected <$expect_out(0,string)>"

当在标准输入中输入

test
hi

是，运行结果如下

you typed: test
hi
I only expect: hi
}

expect(模式-动作)
{
expect最常用的语法是来自tcl语言的模式-动作。这种语法极其灵活，下面我们就各种语法分别说明。

单一分支模式语法：

expect "hi" {send "You said hi"}

匹配到hi后，会输出"you said hi"

多分支模式语法：

expect "hi" { send "You said hi\n" } \
"hello" { send "Hello yourself\n" } \
"bye" { send "That was unexpected\n" }

匹配到hi,hello,bye任意一个字符串时，执行相应的输出。等同于如下写法：

expect {
"hi" { send "You said hi\n"}
"hello" { send "Hello yourself\n"}
"bye" { send "That was unexpected\n"}
}
}

expect(spawn命令)
{
上文的所有demo都是和标准输入输出进行交互，但是我们跟希望他可以和某一个进程进行交互。spawm命令就是用来启动新的进程的。spawn后的send和expect命令都是和spawn打开的进程进行交互的。结合上文的send和expect命令我们可以看一下更复杂的程序段了。

set timeout -1
spawn ftp ftp.test.com      //打开新的进程，该进程用户连接远程ftp服务器
expect "Name"             //进程返回Name时
send "user\r"        //向进程输入anonymous\r
expect "Password:"        //进程返回Password:时
send "123456\r"    //向进程输入don@libes.com\r
expect "ftp> "            //进程返回ftp>时
send "binary\r"           //向进程输入binary\r
expect "ftp> "            //进程返回ftp>时
send "get test.tar.gz\r"  //向进程输入get test.tar.gz\r

这段代码的作用是登录到ftp服务器ftp ftp.uu.net上，并以二进制的方式下载服务器上的文件test.tar.gz。程序中有详细的注释。
}

expect(interact)
{
到现在为止，我们已经可以结合spawn、expect、send自动化的完成很多任务了。但是，如何让人在适当的时候干预这个过程了。比如下载完ftp文件时，仍然可以停留在ftp命令行状态，以便手动的执行后续命令。interact可以达到这些目的。下面的demo在自动登录ftp后，允许用户交互。

spawn ftp ftp.test.com
expect "Name"
send "user\r"
expect "Password:"
send "123456\r"
interact
}