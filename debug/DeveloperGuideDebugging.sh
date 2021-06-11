1. Hello World程序也有例外(bug)。
   如果在调试printf()期间，程序接收到异步信号，而又没有代码检查其返回值，那么就可能产生不完整的输出。
2. 自动化测试是必不可少的。 --- 自动运行的测试。

bug(debug hacks 调试心得)
{
echo 7 > /proc/sys/kernel/printk  # 
mount -o commit=1                 # 文件系统日志方面的bug
ethtool -G ethX rx 64 tx 64       # e1000驱动程序的缓冲区方面的bug

内核：nosmp; e1000 禁用NAPI。
EDAC(Error Detection And Correction) bluesmoke:检查内存ECC校验错误和PCI总线的校验错误。
documentation/drivers/edac.txt documentation/edac.txt
http://bluesmoke.sourceforge.net/

*载入指定的程序： 
(gdb) file app

*显示当前的调试源文件： 
(gdb) info source
}

bug(core dump 手动开启)
{
ulimit -c
ulimit -c unlimited
ulimit -c 1073741824
gdb -c core.7561 ./a.out

/etc/sysctl.conf
kernel.core_pattern = /var/core/%t-%e-%p-%c.core
%%   %字符本身
%p   被转存进程的进程ID
%u   被转存进程的真实用户ID
%g   被转存进程的真实组ID
%s   引发转存的信号编号
%t   转存时刻
%h   主机名
%e   可执行文件名称
%c   转存文件的大小限制
kernel.core_uses_pid = 0 #我们改变文件名中PID的位置，如果设置该值为1，文件名末尾就会添加.PID
                         #当kernel.core_pattern中没有%p的时候，需要设置kernel.core_uses_pid等于1，否则可以为0.

echo "|/usr/local/sbin/core_helper" > /proc/sys/kernel/core_pattern
kernel.core_pattern = |/usr/local/sbin/core_helper %t-%e-%p-%c.core
kernel.core_uses_pid = 0

core_helper
#!/bin/sh
exec gzip - > /var/core/$1-$2-$3-$4.core.gz

又见man 5 core中实例
}

bug(core dump 自动开启)
{
/etc/profile
ulimit -S -c unlimited　> /dev/null 2>&1
DAEMON_COREFILE_LIMIT='unlimited'        ##grep /etc/init.d DAEMON_COREFILE_LIMIT -rn ./* ,该语句在daemon函数中被调用。 
fs.suid_dumpable=1
# 0 (default); 1 ("debug") 2 ("suidsafe")

利用内存转存掩码排除共享内存：
/proc/<PID>/coredump_filter
比特0     匿名专用内存
比特1     匿名共享内存
比特2     file-backed 专用内存
比特3     file-backed 共享内存
比特4     ELF文件映射

https://sourceware.org/gdb/current/onlinedocs/
man 5 core
getrlimit(RLIMIT_CORE)
signal(7)
1. 进程没有权利写coredump文件。#正常情况下，core在当前文件夹中生成。文件夹不能写入；相同文件名存在；
2. 有一个名字相同，且可以写入的普通文件存在，同时该文件有一个硬链接与之关联。
3. RLIMIT_CORE, RLIMIT_FSIZE, getrlimit, ulimit
4. 文件系统没有inode，文件系统达到限额，文件系统为只读的。
5. 没有写入权限
6. set-user-ID, set-group-ID 以及 /proc/sys/fs/suid_dumpable 中配置

}

dbg(调试宏)
{
在GCC编译程序的时候，加上-ggdb3参数，这样，你就可以调试宏了。
另外，你可以使用下述的GDB的宏调试命令 来查看相关的宏。
    info macro – 你可以查看这个宏在哪些文件里被引用了，以及宏定义是什么样的。
    macro – 你可以查看宏展开的样子。
}

dbg(源文件)
{
这个问题问的也是很多的，太多的朋友都说找不到源文件。在这里我想提醒大家做下面的检查：

    编译程序员是否加上了-g参数以包含debug信息。
    路径是否设置正确了。使用GDB的directory命令来设置源文件的目录。

下面给一个调试/bin/ls的示例（ubuntu下）
$ apt-get source coreutils
$ sudo apt-get install coreutils-dbgsym
$ gdb /bin/ls
GNU gdb (GDB) 7.1-ubuntu
(gdb) list main
1192    ls.c: No such file or directory.
in ls.c
(gdb) directory ~/src/coreutils-7.4/src/
Source directories searched: /home/hchen/src/coreutils-7.4:$cdir:$cwd
(gdb) list main
1192        }
1193    }
1194
1195    int
1196    main (int argc, char **argv)
1197    {
1198      int i;
1199      struct pending *thispend;
1200      int n_files;
}

thread(多线程调试)
{
info threads
thread <thread_no>

info thread 查看当前进程的线程。
thread <ID> 切换调试的线程为指定ID的线程。
break file.c:100 thread all  在file.c文件第100行处为所有经过这里的线程设置断点。
set scheduler-locking off|on|step，这个是问得最多的。在使用step或者continue命令调试当前被调试线程的时候，
    其他线程也是同时执行的，怎么只让被调试程序执行呢？通过这个命令就可以实现这个需求。
    off 不锁定任何线程，也就是所有线程都执行，这是默认值。
    on 只有当前被调试程序会执行。
    step 在单步的时候，除了next过一个函数的情况(熟悉情况的人可能知道，这其实是一个设置断点然后continue的行为)以外，
    只有当前线程会执行。

}
http://www.cnblogs.com/yoncan/p/3261798.html
DAEMON_COREFILE_LIMIT(关于启动程序崩溃时不产生coredump 文件分析办法)
{
在系统设置了ulimit -SHc unlimited ,程序并不产生corefile文件;由此有下面的分析:
1. 程序使用了daemon的方式启动的, daemon是/etc/init.d/functions 上定义的函数,里面有一段是这样的

daemon() {
......
    # make sure it doesn't core dump anywhere unless requested
    corelimit="ulimit -S -c ${DAEMON_COREFILE_LIMIT:-0}"
......
    # And start it up.
    if [ -z "$user" ]; then
       $cgroup $nice /bin/bash -c "$corelimit >/dev/null 2>&1 ; $*"
    else
       $cgroup $nice runuser -s /bin/bash $user -c "$corelimit >/dev/null 2>&1 ; $*"
    fi
......    
}
解释:
其 中$corelimit变量定义了corefile的设置,变量$DAEMON_COREFILE_LIMIT 则定义了corefile大小的设置,因为这个值没有初始化,那${DAEMON_COREFILE_LIMIT:-0}使得 DAEMON_COREFILE_LIMIT的大小为0;
最后在执行程序的时候,就会设置corefile大小为0,即使你在系统启动时使用了ulimit -SHc unlimited; 也没有起到作用;
那只要在/etc/init.d/functions上添加$DAEMON_COREFILE_LIMIT变量的初始值就好了

# vi /etc/init.d/function
## user define set coredump
DAEMON_COREFILE_LIMIT="unlimited"

# 关于limits.conf上是不是要设置,表示不关心
# vim /etc/security/limits.conf
*   soft        core                unlimited
*   hard        core                unlimited
}

bug(gdb)
{
gcc -Wall -O2 -g 源代码
CFLAGS = -Wall -O2 -g
./configure CFLAGS="-Wall -O2 -g"

-Wall : 警告选项
-Werror : 可以在告警发生时，将其当做错误来处理

gdb 可执行文件名
emacs M-x gdb

break 函数名          b iseq_compile
break 行号            
break 文件名:行号     b compile.c:516
break 文件名:函数名   
break +偏移量         b +3
break -偏移量         
break *地址           b *0x08116fd6
break                 #如果不指定断点位置，就在下一行代码上设置断点。
info break
info breakpoints
delete <编号>         #删除断点
tbreak #临时断点

break 断点 if 条件
b iseq_compile if node==0
break 46 if testsize==100
condition 断点编号
condition 断点编号 条件

clear
clear 函数名
clear 行号              #清除源文件中某一代码行上的所有断点
clear 文件名:行号
clear 文件名:函数名
delete 断点号码
delete breakpoint        #删除所有的断点

disable                  #禁止所有断点
disable 断点编号
disable display 显示编号
disable mem 内存区域

enable                  #禁止所有断点
enable 断点编号
enable once   断点编号
enable delete 断点编号
enable display 显示编号
enable mem 内存区域



backtrace == where == info stack
backtrace N #bt N 只显示开头N个帧
backtrace -N #bt -N 只显示最后N个帧

backtrace full
bt full
backtrace full N
bt full N 
backtrace full -N
bt full -N
不仅显示backtrace，还要显示局部变量。


print == p
p argv
p *argv
p argv[0]
p argv[1]

对程序中函数的调用
（gdb) print find_entry（1,0)
数据结构和其他复杂对象
（gdb) print *table_start
如果a是一个数组，10个元素，如果要显示则： 
(gdb) print *a@10

info registers # info reg
p $eax

#打印输出
p/格式 变量
x   显示为16进制数
d   显示为10进制数
u   显示为无符号10进制
o   显示为8进制值
t   显示为2进制数
a   地址
c   显示为字符
f   浮点小数
s   显示为字符串
i   显示为机器语言
p/c $eax
p $pc
p $eip

#显示内存内容
x/格式 地址
b   字节 1个字节
h   半字 2个字节
w   字   4个字节
g   双字 8个字节

x $pc
x/i $pc

#反编译
disassemble == disas 
disas                    #反编译当前整个函数
disas 程序计数器         #反编译程序计数器所在函数的整个函数
disas 开始地址 结束地址  #反编译从开始地址到结束地址之间的部分
disassem $pc $pc+50

continue 5 #5次遇到断点不停止

#监视点
watch #要想找到变量在何处被改变了，可以使用watch命令
watch <表达式> #<表达式>发生变化时暂停运行

watch i != 10

awatch <表达式>
rwatch <表达式>
delete <编号> #删除监视点

#改变变量的值
set variable <变量>=<表达式>

# 生成内存转存文件
generate-core-file
gcore #从命令行直接生成内核转存文件

attach
info proc #进程信息

continue 次数
step 次数
stepi 次数
next 次数
nexti 次数
finish
until              # 执行到指定的行
until 地址         # 执行到指定的行

directory == dir #插入目录

list      == l   #显示函数或行
list lineNum 在lineNum的前后源代码显示出来
list + 列出当前行的后面代码行
list - 列出当前行的前面代码行
list function
set listsize count
设置显示代码的行数
show listsize
显示打印代码的行数
list first,last
显示从first到last的源代码行


sharedlibrary share #加载共享库的符号


set history expansion [on|off]
show history expansion
set history filename 文件名
show history filename 
set history save  [on|off]
show history save
set history size 数字 
show history size

}


intel(hacks：57)
{
编译时为gcc指定-fomit-frame-pointer选项，即可生成不使用帧指针的二进制文件，在这种情况下，FP和上层FP信息不会被记录在栈上，
但是即使如此，GDB也能正确理解帧，这是因为GDB是根据记录在调试信息中的栈使用量来计算帧的位置的。

frame <数值> #用于选择栈帧
i frame 1
p sum

info proc mapping
info files
info target
}

hacks(函数参数调试)
{
在x86_64中，整形和指针型的参数会从左到右依次保存到rdi,rsi,rdx,rcx,r8,r9中，浮点型参数会保存到xmm0,xmm1......中，
多于这些寄存器的参数会被保存在栈上，因此，利用GDB在希望确认的函数开头中断之后，查看寄存器或栈即可获得参数内容。



}
测试框架：
https://en.wikipedia.org/wiki/List_of_unit_testing_frameworks

http://www.tiobe.com/tics/fact-sheet/

13条黄金规则：用于发现最难捕捉的软件和硬件的问题的9条必备规则的一个扩展。
debug(13条黄金规则)
{
1. 理解需求
       在开始调试和修复任何错误之前，一定要保证正确理解需求。有没有标准文档或规格说明可供查阅？
   有没有其它文档？或许软件根本就没有故障，只是产生了误解，而不是bug.
2. 制造失败
       我们需要一个测试用例。使程序运行失败，然后亲自观察。测试用例是必不可少的。
   2.1 如果没有看到程序最后可以工作了，怎么能够知道已经修复了问题呢？
   2.2 为了遵循规则13"用回归测试来检查bug修复"，需要一个测试用例。
   2.3 必须理解造成软件失败的所有因素，并从假设中分离出事实。造成失败的因素很多：环境变量，操作系统或窗口管理器。
3. 简化测试用例
   排除不起作用的因素；减少测试用例的运行时间；使测试用例更容易调试。
4. 读取恰当的错误信息
   从首先出现错误的那条消息分析日志。
5. 检查显而易见的问题
   进程权限；内存大小；磁盘空间限制；进程限制属性等等。
6. 从解释中分离出事实
   从测试人员或用户的描述，到问题真正发生的原因的探究。
7. 分而治之
   整理一份清单，列出潜在问题以及如何调试它们
   将环境更改和源代码更改区分开
       7.1 跟踪环境的更改
       7.2 测试源代码的更改
   放大并治之
       7.3 内存调试
       7.4 常规的源代码调试
       7.5 同步调试
8. 工具要与bug匹配
   关注那些最有可能找到bug的方面，即使这可能会使工作非常乏味或进入一个不熟悉的领域。
9. 一次只做一项更改
   尽可能一次只做一项修改，然后检查它是否有意义。如果没有意义，则返回原来状态。
10. 保持审计跟踪
11. 获得全新观点
    与别人讨论一下。
12. bug不会自己修复
13. 用回归测试来检查bug修复
} 

如果问题很容易解决，则直接解决；否则就将其分解为两个或多个更小的问题。

debug(测试)
{
回归测试：自动进行的。
单元测试和系统测试：系统测试是将软件作为整体进行测试；
                    单元测试关注单个软件构建块。
单元测试 -> 白盒测试和黑盒测试.
白盒测试和黑盒测试：黑盒测试的主要目的是验证组件的预期功能，而忽略其实际的实现。
                    白盒测试主要测试实现的边界情况以及一些"弄巧成拙的错误"。          
}

debug(类型)
{
1. 常见bug:可预测的
2. 偶发性bug：在程序中添加"看门狗"代码，当bug试图绕过他时，发出警报。当然，我们需要保存并检查日志文件，否则这些代码等于做无用功。
    找到正确的诱饵。保持耐心，做好记录。
3. Heisenbug：越是能力调试，就越有可能隐藏特定的bug.
   要么是由于资源争用引起的；要么是由于非法使用内存引起的；要么是由于优化错误引起的。                    
4. 隐藏在bug背后的bug：多个bug的可能性。
5. 秘密bug --- 调试与机密性
   自己尝试再现相同的bug；现场调试(truss或strace)；使用安全的连接。
}

gdb(调试一个程序)
{ 
####调试一个程序
gdb 程序文件名
或 
gdb -q				 # -q表示不显示版本信息，输入q或quit退出gdb
(gdb)file 文件名　　 # 
shell ls             # 如果在调试过程中要运行linux命令，则可以在gdb的提示符下输入shell命令  
search get_sum       # search (字符串)和 forward(字符串)命令都用来从当前行向后查找第一个匹配的字符  
recerse-search main  # reverse-search (字符串)命令用来从当前航向前查找第一个匹配的字符串
    
###Core文件
gdb exec_file core_file
或
gdb exec_file
core-file core_file

http://blog.csdn.net/unix21/article/details/9628933
                      
运行程序                    run [arg]           F5
启动程序                    start [arg]         F10
暂停                        Ctrl-C              Ctrl-Alt-Break
继续运行                    cont                F5
                                                
step-over                   next                F10
step-into                   step                F11
step-out                    finish              Shift + F11
                                                
断点                        break file:lineno   
跟踪断点                    watch file:lineno   
观察断点                    watch expr          
                                                
栈跟踪                      bt, where           
输出表达式                  print expr          
显示表达式                  display expr        
                                                
设置变量                    set var var=expr    
设置环境变量                set env var=[val]   
                                                
显示机器代码                disassemble         
在机器代码中执行step-over   nexti               F10
在机器代码中执行step-into   stepi               F11
                                                
条件断点                    condition bnum      
事件断点                    handle,signal       
异常断点                    catch function      
函数断点                    break function      
临时断点                    tbreak              
列出所有断点                info breakpoints    
                                                
将命令连接到断点            commands bnum       
输出到命令行                printf              
                                                
查找函数                    info functions expr 
调用函数                    call expr           
修改函数返回值              return expr         
                                                
输出类型                    whatis arg     #命令可以显示某个变量的类型         
输出类型描述                ptype arg      #比whatis的功能更强，他可以提供一个结构的定义    
输出内存内容                x arg               
选择栈帧                    frame arg           
输出栈帧                    info frame          

}

list(){
####List 指令
list                 # 显示10行代码，若再次运行该命令显示接下来的10行代码  
list 5,10            # 显示第5行到第10行的代码  
list test.c:5,10     # 显示源文件test.c中的第5行到第10行的代码，调试含有多个源文件的程序时使用  
list get_sun         # 显示get_sum函数周围的代码  
list test.c:get_sum  # 显示源文件testc中get_sum函数周围的代码，在调试多个源文件的程序时使用 
}
gdb(signal)
{
gdb通常可以捕捉到发送给它的大多数信号，通过捕捉信号，它就可决定对于正在运行的进程要做些什么工作。例如，按CTRL-C将中断信号发送给gdb，通常就会终止gdb。但是你或许不想中断gdb，真正的目的是要中断gdb正在运行的程序，因此，gdb要抓住该信号并停止它正在运行的程序，这样就可以执行某些调试操作。
Handle命令可控制信号的处理，他有两个参数，一个是信号名，另一个是接受到信号时该作什么。几种可能的参数是：
nostop 接收到信号时，不要将它发送给程序，也不要停止程序。
stop 接受到信号时停止程序的执行，从而允许程序调试；显示一条表示已接受到信号的消息（禁止使用消息除外）
print 接受到信号时显示一条消息
noprint 接受到信号时不要显示消息（而且隐含着不停止程序运行）
pass 将信号发送给程序，从而允许你的程序去处理它、停止运行或采取别的动作。
nopass 停止程序运行，但不要将信号发送给程序。
例如，假定你截获SIGPIPE信号，以防止正在调试的程序接受到该信号，而且只要该信号一到达，就要求该程序停止，并通知你。要完成这一任务，可利用如下命令：
（gdb) handle SIGPIPE stop print
请注意，UNⅨ的信号名总是采用大写字母！你可以用信号编号替代信号名如果你的程序要执行任何信号处理操作，就需要能够测试其信号处理程序，为此，就需要一种能将信号发送给程序的简便方法，这就是signal命令的任务。该命令的参数是一个数字或者一个名字，如SIGINT。假定你的程序已将一个专用的SIGINT（键盘输入，或CTRL-C；信号2）信号处理程序设置成采取某个清理动作，要想测试该信号处理程序，你可以设置一个断点并使用如下命令：
（gdb） signal 2
continuing with signal SIGINT⑵
该程序继续执行，但是立即传输该信号，而且处理程序开始运行。

}
源代码调试器(source code debugger) 符号连接调试器 (symbolic debugger)
gcc -g : 调试符号(debug symbol) 符号信息(symbolic information)

gdb factorial 
run 1  #相当于factorial 1，其中1为传递给factorial的第一个参数
bt、backtrace或where用于栈跟踪。
backtrace(栈帧)
{
#5427 0x00000000004005be in factorial (n=-256653) at factorial.c:14
当前栈帧的编号为0，main()函数的编号最高。
down和up用于栈帧输出上下移动。

}

breakpoint(断点类型)
{
行断点(line breakpoint)  当到达源代码中指定行时，暂停程序。
函数断点(function breakpoint) 当到达指定函数的第一行时，暂停程序
条件断点(conditional breakpoint) 如果特定条件保持为真，则暂停程序。
事件断点(event breakpoint) 当发生特定事件时，使程序进入暂停模式。支持的事件包括来自操作系统的signals和C++的exception.

break (行号)                         # 在第某行设置端点  
break (函数名)                       # 在某个函数处设置断点  
break 行号或函数名if条件　　         # 当条件满足时中断暂停执行  
break 7 if i==99                     # 当程序中的i等于99时在第7行中断  
watch 条件表达式                     # 当条件表达式的值发生改变时中断  
watch i==99(当i等于99时表达式的值从0变为1，程序中断)     //注:必须在程序运行到变量被定义之后才可以用此方法  
info breakpoints                     # 查看当前所有的断点,Num表示断点的编号,Type指明类型  
/*
类型为breakpoints说明是中断。
*Disp指示中断点在生效一次后是否就失去作用，如果是则为dis,不是则为keep。
*Enb表明当前中断点是否还有效,是为y,不是为n。
*Address表示中断所处的内存地址。
*What列出中断发生在哪个函数的第几行。
*/
disable 断点编号      # 使这个断点失效  
enable  断点编号      # 使这个断点恢复  
clear 　　　　　　　  # 删除程序中所有的断点   
clear 行号            # 删除此行的断点  
clear 函数名          # 删除该函数的断点  
delete  断点编号      # 删除指定编号的断点。如果一次要删除多个断点，各个断点以空格隔开
}

run(执行控制)
{
run       run命令将运行程序，可以通过命令行参数或环境变量来控制和更改运行程序的环境。
start     start命令将运行程序，直到main()的第一行，然后停止程序的执行，这样就不必搜索包含main函数的文件，并在其第一行设置显式的端点了。
pause     将中断一个正在运行的程序。在某些调试器中，键入Ctrl-C或单击Pause键起作用。
continue  使暂停的程序恢复执行。
}

step(单步执行)
{
step-into   (GDB)step
step-over   (GDB)next
step-out    (GDB)finish
}

print(变量和表达式)
{
print n
如何打印变量的值？(print var) 
如何打印变量的地址？(print &var) 
如何打印地址的数据值？(print *address) 

print 变量或表达式　　　　　　　  # 打印变量或表达式当前的值
print i<n                         # 表达式为真值为1,假为0
print 变量＝值　　　　　　　　　  # 对变量进行赋值
print　表达式＠要打印的值的个数ｎ # 打印以表达式值开始的n个数
/*
注:当程序中（print 变量或表达式）值为假时不在执行下面的代码，而是直接返回值
*/
whatis　变量或表达式     # 显示某个变量或表达式的　数据类型
set variable 变量＝值　  # 给变量赋值
print i=200　            # 等同于　set variable i=200

display
}
如何查看当前运行的文件和行？(backtrace) 
如何查看指定文件的代码？(list file:N) 
如何立即执行完当前的函数，但是并不是执行完整个应用程序？(finish) 
如果程序是多文件的，怎样定位到指定文件的指定行或者函数？(list file:N) 
如果循环次数很多，如何执行完当前的循环？(until)


debug(剖析内存的使用：valgrind memcheck 查明内存泄露情况)
{
1. 内存泄露：            丢失或忘记了调用某条语句。
2. 内存个管理的错误使用  多次释放一个内存块、在释放一个内存块之后又访问或者释放一个从未分配的内存块
3. 缓冲区溢出            已分配内存外部的内存被改写或破坏。
4. 读取未初始化的内存    未初始化的变量将包含无法预料的值。

Purify Insure++ Valgrind 和 BoundsChecker
Purify和BoundsChecker使用程序链接时的对象代码插装进行检查；
Insure++使用源代码插装
Valgrind在虚拟机上执行程序，并监视所有内存事务。

bug(内存)
{
内存泄露
访问已释放的内存
多次释放同一个内存位置
释放从未分配的内存
混用C中的malloc()/free()和C++中的new/delete
对数组使用delete,而没有使用delete[]
数组越界错误
访问从未分配的内存
读取未初始化的内存
读或写空指针
}

valgrind --tool=memcheck --leak-check=yes ./main1
valgrind -v --tool=memcheck --leak-check=yes ./main1

/* main1.c */
无效内存的写访问：
==25653== Invalid write of size 4
==25653==    at 0x40054E: main (main1.c:10)

检查对未初始化的内存的读取操作
==25653== Use of uninitialised value of size 8
==25653==    at 0x3CCF6437DB: _itoa_word (in /lib64/libc-2.12.so)
25653：进程pid.

检查内存泄露
==25653== 400 bytes in 1 blocks are definitely lost in loss record 1 of 1
==25653==    at 0x4A0717A: malloc (vg_replace_malloc.c:298)

/* mem_alloc_bug.c */
对内存引用错误
==25298== Invalid read of size 1
==25298==    at 0x3CCF670E60: _IO_file_xsputn@@GLIBC_2.2.5 (in /lib64/libc-2.12.so)
==25298==    by 0x3CCF6476E7: vfprintf (in /lib64/libc-2.12.so)
==25298==    by 0x3CCF64EAC9: printf (in /lib64/libc-2.12.so)
==25298==    by 0x4005C4: main (mem_alloc_bug.c:18)

对内存分配-释放的不完整调用
==26130== Invalid free() / delete / delete[] / realloc()
==26130==    at 0x4A06B54: free (vg_replace_malloc.c:529)

检查内存泄露
==25298== 5 bytes in 1 blocks are definitely lost in loss record 1 of 1
==25298==    at 0x4A0717A: malloc (vg_replace_malloc.c:298)

1. 将软件移植到新操作系统上时
2. 程序崩溃时
3. 开始调试一个"奇怪的"bug时，
4. 为回归测试的一部分。

}

valgrind()
{
http://blog.csdn.net/unix21/article/details/9330571
http://www.ibm.com/developerworks/cn/linux/l-cn-valgrind/

Valgrind包括如下一些工具：
    Memcheck。这是valgrind应用最广泛的工具，一个重量级的内存检查器，能够发现开发中绝大多数内存错误使用情况，比如：使用未初始化的内存，使用已经释放了的内存，内存访问越界等。这也是本文将重点介绍的部分。
    Callgrind。它主要用来检查程序中函数调用过程中出现的问题。
    Cachegrind。它主要用来检查程序中缓存使用出现的问题。
    Helgrind。它主要用来检查多线程程序中出现的竞争问题。
    Massif。它主要用来检查程序中堆栈使用中出现的问题。
    Extension。可以利用core提供的功能，自己编写特定的内存调试工具
    
Valgrind 使用
用法: valgrind [options] prog-and-args [options]: 常用选项，适用于所有Valgrind工具
    -tool=<name> 最常用的选项。运行 valgrind中名为toolname的工具。默认memcheck。
    h –help 显示帮助信息。
    -version 显示valgrind内核的版本，每个工具都有各自的版本。
    q –quiet 安静地运行，只打印错误信息。
    v –verbose 更详细的信息, 增加错误数统计。
    -trace-children=no|yes 跟踪子线程? [no]
    -track-fds=no|yes 跟踪打开的文件描述？[no]
    -time-stamp=no|yes 增加时间戳到LOG信息? [no]
    -log-fd=<number> 输出LOG到描述符文件 [2=stderr]
    -log-file=<file> 将输出的信息写入到filename.PID的文件里，PID是运行程序的进行ID
    -log-file-exactly=<file> 输出LOG信息到 file
    -log-file-qualifier=<VAR> 取得环境变量的值来做为输出信息的文件名。 [none]
    -log-socket=ipaddr:port 输出LOG到socket ，ipaddr:port

LOG信息输出

    -xml=yes 将信息以xml格式输出，只有memcheck可用
    -num-callers=<number> show <number> callers in stack traces [12]
    -error-limit=no|yes 如果太多错误，则停止显示新错误? [yes]
    -error-exitcode=<number> 如果发现错误则返回错误代码 [0=disable]
    -db-attach=no|yes 当出现错误，valgrind会自动启动调试器gdb。[no]
    -db-command=<command> 启动调试器的命令行选项[gdb -nw %f %p]

适用于Memcheck工具的相关选项：

    -leak-check=no|summary|full 要求对leak给出详细信息? [summary]
    -leak-resolution=low|med|high how much bt merging in leak check [low]
    -show-reachable=no|yes show reachable blocks in leak check? [no]

使用未初始化的内存 (Use of uninitialised memory) 
使用已经释放了的内存 (Reading/writing memory after it has been free’d) 
使用超过 malloc分配的内存空间(Reading/writing off the end of malloc’d blocks) 
对堆栈的非法访问 (Reading/writing inappropriate areas on the stack) 
申请的空间是否有释放 (Memory leaks – where pointers to malloc’d blocks are lost forever) malloc/free/new/delete
申请和释放内存的匹配(Mismatched use of malloc/new/new [] vs free/delete/delete []) 
src和dst的重叠(Overlapping src and dst pointers in memcpy() and related functions)

}

massif-visualizer()
{
安装massif-visualizer
massif-visualizer是ubuntu下的图形化分析工具
http://get.ubuntusoft.com/app/massif-visualizer
项目主页：
https://projects.kde.org/projects/extragear/sdk/massif-visualizer
massif-visualizer下载：
http://tel.mirrors.163.com/ubuntu/pool/universe/m/massif-visualizer/
软件包详细信息：
http://packages.ubuntu.com/massif-visualizer

}


debug(剖析内存的使用：valgrind massif 查明程序内存被那些大数据占用)
{
1. 检查是否有大的内存泄露
   对使用了过多内存的程序运行内存检查器；如果系统库中的内存泄露，可能泄露的数量级只有几个字节，这完全可以忽略。
2. 估计预期的内存使用
   插装代码或调试工具进行实际测量之前完成。
   Redis自身有些插装代码。
3. 用多个输入来测量内存使用随时间的变化
    top
4. 查找使用内存的数据结构

对堆剖析 (查明大部分内存被那些数据结构占用了)
/usr/local/bin/valgrind --tool=massif ./testmalloc n 100000 8
/usr/local/bin/valgrind --tool=massif ./genindex input1.txt input1.txt input1.txt input1.txt  > log

testmalloc: -DUSE_NEW
genindex:   -DFIX_LINES -DCLEAR_INDEX

输出massif.out.26512为Postscript文件。
ms_print massif.out.26512

监控nginx,redis,memcached,firefox
valgrind --tool=massif /usr/local/nginx/sbin/nginx -c /usr/local/nginx/conf/nginx.conf
valgrind --tool=massif /usr/local/memcached/bin/memcached -d -m 64 -uroot -l 0.0.0.0 -p 11211 -c 1024
valgrind --tool=massif /usr/redis-2.8.1/src/redis-server
valgrind --tool=massif /usr/bin/firefox

实例：
valgrind --smc-check=all --trace-children=yes --tool=massif --pages-as-heap=yes \ --detailed-freq=1000000 optg64/dist/bin/firefox -P cad20 -no-remote

g++ -g -o genindex_fix -DFIX_LINES genindex.cc                                           # 编译程序
valgrind --tool=massif ./genindex_fix input1.txt input1.txt input1.txt input1.txt > log  # 运行程序
ms_print massif.out.2511                                                                 # 输出运行统计信息

g++ -g -o genindex_fix_index -DFIX_LINES -DCLEAR_INDEX genindex.cc                             # 编译程序
valgrind --tool=massif ./genindex_fix_index input1.txt input1.txt input1.txt input1.txt > log  # 运行程序
ms_print massif.out.2535                                                                       # 输出运行统计信息


}

debug(解决性能问题：valgrind callgrind)
{
1. 用Callgrind运行程序，剖析数据将被写入callgrind.out.<id>文件中。
2. 运行callgrind annotate callgrind.out.<id> 命令生成一个剖析报告，或用KCachegrind来查看结果
gcc -o isort -O isort.c
valgrind --tool=callgrind ./isort -i 100 1000
callgrind_annotate callgrind.out.31612

callgrind_annotate
--tree=both : 显示调用树，列出每个函数的调用者以及它调用的其他函数。
--auto=yes  : 输出带注释的源文件

yum install kdesdk-4.3.4-4.el6.x86_64 
kcachegrind callgrind.out.31612 #图形版

./filebug s xxx.log 2000000
}

debug(解决性能问题：VTune)
{
采样(gprof)和调用图(类似于Quantify)
VTune     商业Intel
Quantify  商业IBM
}

debug(解决性能问题：gprof)
{
1. 创建一组大小不等的有意义的测试用例。确定程序能正常运行；没有崩溃，并得到正确的输出值。
   是否有能够再现性能问题的测试用例？
   程序是否计算出正确的结果？
   是否能够修改测试用来来观察问题规模、输入数据和环境的影响？
   性能问题是否确实是由程序引起的，而不是某些其他因素的副作用，如网速满、许可服务器满或内存低？
   是否使用了适合问题规模和输入数据的正确算法？
2. 用简单工具time来测量运行时间与测试用例大小之间的关联，确定程序使用了正确的算法
   使用简单的时间测量方法？
   创建测试用例
   使测试用例具有可再现性
   检查程序的正确性
   创建可扩展的测试用例
   排除对测试用例的干扰
       1. 运行时间短； 2. 文件IO； 3. 系统调用； 4. 没有足够的内存 5. CPU时钟频率不稳定 6. 其他进程。
   算法与实现之间的差异

3. 选择一个能够揭示主要的运行时瓶颈的测试用例。继续用剖析工具来识别差生瓶颈的原因

gprof、callgrind、Quantify。
gprof：测量程序的每个函数占用多长时间，以及每个函数被其他调用的次数。此外，如果程序使用调试信息编译的，
       还可以看到程序的每个基本块用的时间。
1. 用-gd标志编译并连接程序
2. 运行程序，剖析文件数据将被写入gmon.out文件中
3. 运行gprof <program> gmon.out命令生成剖析报告。
缺点：1.不剖析调用操作系统所花的时间，而且可能无法处理共享库。
      2. 插入的剖析代码极大地降低了程序的运行速度。
      
gcc -Wall -O -o isort -pg isort.c
./isort -i 10 100000  
gprof isort gmon.out > report.txt

<平面图>
Each sample counts as 0.01 seconds.
       总运行时间  函数调用本身所用的时间    函数及其所有后代中每个调用花费的平均时间
  %   cumulative   self              self     total
 time   seconds   seconds    calls  ns/call  ns/call  name
 36.17      1.14     1.14 90000000    12.62    29.04  insert_value
 29.45      2.06     0.92 450000000     2.05     2.05  less
 17.60      2.61     0.55 190000000     2.91     2.91  swap
 10.88      2.95     0.34 10000000    34.17   295.49  isort
  4.16      3.09     0.13                             main
  2.24      3.16     0.07                             frame_dummy
确保总运行时间cumulative seconds比采样间隔0.01秒高出4个数量级。

<调用图> 按区块组织
index % time    self  children    called     name
                                                 <spontaneous>
[1]     97.8    0.13    2.95                 main [1]
                0.34    2.61 10000000/10000000     isort [2]
-----------------------------------------------
每个块处理一个函数，显示该函数的调用者以及调用频率，函数自身用的总时间，被调用的子函数和这些子函数调用中所用的时间。

}

debug(调试并行程序：helgrind)
{
1. 用C和C++编写的可在不同主机上运行的多路通信程序
2. 多线程程序
3. 如信号或中断处理程序

代码走查！ --- 程序无序竞争
1. 使用基本调试功能来查找竞争条件；
2. 使用日志文件来查找竞争条件；
   2.1 对并行代码进行插装时，一定要使用线程安全的原子函数和命令，否则最后调试的就是插装代码，而不是实际代码
   2.2 printf()和fprintf()可在大多数操作系统上可靠工作。在每条IO语句后面，立即调用fflush().
       错误流stderr是未缓冲的，因此最适合用来记录。C++流是最不适合用来记录的。因为它可能产生
       来自不同线程的安全交差的文本输出。
   2.3 当转存大型程序中的线程信息时，应使用时间戳。
   2.4 如果经常调试并行程序，一种好的方法是创建辅助工具，即跟踪函数或跟踪缓冲区变量，用以自动捕获一些有用信息。
   2.5 在某些情况下使用断言是有意义的，特别是如果不使用断言，日志数量变得很大的时候。

代码走查！ --- 程序死锁
1. 循环互斥锁定
2. 协议不匹配

gdb -> Ctrl-C  ->  info stack; frame; list 12,5; info threads; thread 1; 

Thread Checker 商业软件 Intel

valgrind --tool=helgrind ./beancounter_deadlock
}

debug(多进程调试)
{
UNIX：   PATH和LD_LIBRARY_PATH：用于定位动态载入程序共享库。    env
Windows：PATH, LIB和INCLUDE     程序使用PATH用来查找程序和DLL。 set

1. 本地安装依赖       本地动态库版本
2. 当前工作目录依赖   配置文件或可执行文件工作目录
3. 进程ID依赖         /tmp/myprog.<pid>
4. 编译器和调试也有bug

跟踪进程！
1. 用top来看进程
2. ps来查找应用程序的多个进程
    ps -u someone -H pid,cmd
3. 使用/oric/<pid>/来访问进程
4. 使用strace|truss跟踪对操作系统的调用
    strace会产生大量难以读懂的输出。
    文件IO；在OS例程中未捕获的错误或中断；OS调用的频率；内存分配/释放/映射。
    
跟踪子进程
set follow-fork-mode
mode:
  child                           # 当调用fork()后控制流程会进入父程序
  parent                          # 当调用fork()后控制流程会进入子程序
  
set detach-on-fork mode
mode:
  on(默认)                        # 只调试父进程或子进程的其中一个(根据follow-fork-mode来决定)
  off                             # 父子进程都在gdb的控制之下,其中一个进程正常调试(根据follow-fork-mode来决定),另一个被暂停。
info inferiors                    # 显示所有信息
inferior num                      # 选择num号进程
add-inferior [-copies n] [-exec executable] # 添加新的调试进程,可以用file executable来分配给inferior可执行文件。  
remove-inferiors infno

fork+exec
设置follow-fork-mode child后
catch exec                        # 可以捕获execve函数族的调用,从而进入被执行的程序
}

debug(处理链接器问题)
{
1. 丢失链接器参数
2. 搜索丢失的符号
3. 连接顺序问题
4. C++符号和名称改编
5. 符号反编译
6. 连接C和C++代码    "extern C"
7. 具有多个定义的符号

1. 系统库不匹配
2. 对象文件不匹配
3. 运行时崩溃
4. 确定编译器版本
}

debug(高级调试)
{
gdb 
break C::foo #类的成员函数
break C::foo(int) #类的成员函数
break 'C::foo(int) #'表示可以使用Tab提示重载函数
ptype C
info functions C::foo

handle SIGUSR1 print nostop pass
handle SIGUSR1 noprint nostop nopass
info signals

ulimit -c 100000
gdb answer core.4805


修改变量
start "Foofoo, foobar and Bar" foo bar
break 22
print n
set var n=3
print str+n
continue

调用函数
call captialize_str(copy, "and")

修改函数返回值
return 40

终止函数调用
return 0

跳过或重复执行个别语句
jump 25

输出和修改内存内容
whatis print x set var

}

debug(编写可以调试的代码)
{
注释：
1. 函数签名的注释；
   函数要做什么？说明函数参数；接口使用上的假设；内存分配；副作用；记录所有已知的陷阱和临时折中办法。
2. 对折中办法的注释
3. 对不确定的代码加注释

采用移植的编码风格：
1. 仔细选择名称
2. 不要使用"聪明过头"的结构
3. 不要压缩代码；
4. 为复杂表示式使用临时变量

避免使用预处理器宏：
1. 使用常量或枚举来代替宏。
2. 使用函数来代替预处理器宏
3. 调试与处理器输出
gcc -E main.c > main.post.c
4. 使用功能更强的预处理器
m4 

提供更多调试函数
1. 显示用户定义的数据类型
2. 自检查代码
3. 为操作创建一个函数，以便帮助调试

为事后调试做准备
1. 生成日志文件


}

debug(静态检查的作用即常用工具)
{
lint
splint UNIX
PC-lint 商业

ulimit -- 设置和查看用户的使用的资源限制情况
nm -- 显示目标文件的符号表信息
ldd –显示动态库的依赖信息
pstack（Solaris， Linux）， procstack（AIX）-- 打印十六进制地址和符号名称
pmap(Solaris, Linux), procmap(AIX) –打印地址空间映射
pldd(Solaris), procldd(AIX) —列出进程加载的库
pfiles(Solaris), procfiles(AIX)-- 报告有关的所有文件描述符
prstat(Solaris), ps -e -o user,pid,ppid,tid,time,%cpu,cmd --sort=%cpu(Linux)-- 检查每个线程的处理器
ps –报告进程的状态
iostat –报告中央处理单元（中央处理器）统计和输入 / 输出设备和分区统计
pwdx（Linux，Solaris）　 pid 显示当前工作目录
top（Linux，Solaris，HP），topas（AIX）


/usr/bin/gcore
/usr/bin/gdb
/usr/bin/gdb-add-index
/usr/bin/gdbtui
/usr/bin/gstack
/usr/bin/pstack
}


