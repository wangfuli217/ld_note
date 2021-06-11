# http://www.tinylab.org/callgraph-draw-the-calltree-of-c-functions/

1. Callgraph它可以把 C 语言的函数调用树（或者说流程图）画出来。
2. 传统的命令行工具 Cscope, Ctags 可以结合 vim 等工具提供高效快捷的跳转，但是无法清晰的展示函数内部的逻辑关系。
3. 至于图形化的IDE，如 QtCreator, Source Insight, Eclipse, Android Studio 等，却显得笨重，而且不一定支持导出调用关系图。

安装 Callgraph
---------------------------------------
Callgraph 实际由三个工具组合而成。
    一个是用于生成 C 函数调用树的 cflow 或者 calltree，下文主要介绍 cflow。
    一个处理 dot 文本图形语言的工具，由 graphviz 提升。建议初步了解下：DOT 语言。
    一个用于把 C 函数调用树转换为 dot 格式的脚本：tree2dotx

以 Ubuntu 为例，分别安装它们：
    $ sudo apt-get install cflow graphviz
如果确实要用 calltree，请通过如下方式下载。不过 calltree 已经年久失修了，建议不用。
    $ wget -c https://github.com/tinyclub/linux-0.11-lab/raw/master/tools/calltree  # 没有
接下来安装 tree2dotx 和 Callgraph，这里都默认安装到 /usr/local/bin。
    $ wget -c https://github.com/tinyclub/linux-0.11-lab/raw/master/tools/tree2dotx # 没有
    $ wget -c https://github.com/tinyclub/linux-0.11-lab/raw/master/tools/callgraph # 没有
    $ sudo cp tree2dotx callgraph /usr/local/bin
    $ sudo chmod +x /usr/local/bin/{tree2dotx,callgraph}
注：部分同学反馈，tree2dotx输出结果有异常，经过分析，发现用了 mawk，所以请提交安装下gawk：
    $ sudo apt-get install gawk
    
分析 Linux 0.11
---------------------------------------
3.1 准备
先下载泰晓科技提供的五分钟 Linux 0.11 实验环境：Linux-0.11-Lab。
    $ git clone https://github.com/tinyclub/linux-0.11-lab.git && cd linux-0.11-lab
    
make cg f=main
Func: main
Match: 3
File:
     1    ./init/main.c: * main() use the stack at all after fork(). Thus, no function
     2    ./init/main.c: * wo not be any messing with the stack from main(), but we define
     3    ./init/main.c:void main(void)        /* This really IS void, no error here. */
Select: 1 ~ 3 ? 3
File: ./init/main.c
Target: ./init/main.c: main -> callgraph/main.__init_main_c.svg


    需要注意的是，上面提供了三个选项用于选择需要展示的图片，原因是这个 callgraph 目前的函数识别能力还不够智能，
可以看出 3 就是我们需要的函数，所以，上面选择序号 3。
生成的函数调用关系图默认保存为 callgraph/main.__init_main_c.svg。
图片导出后，默认会调用 chromium-browser 展示图片，如果不存在该浏览器，可以指定其他图片浏览工具，例如：
make cg b=firefox
上面的 make cg 实际调用 callgraph：
callgraph -f main -b firefox

玩转它
---------------------------------------
[匹配]
类似 main 函数，实际也可渲染其他函数，例如：

    $ callgraph -f setup_rw_floppy
    Func: setup_rw_floppy
    File: ./kernel/blk_drv/floppy.c
    Target: ./kernel/blk_drv/floppy.c: setup_rw_floppy -> callgraph/setup_rw_floppy.__kernel_blk_drv_floppy_c.svg

因为只匹配到一个 setup_rw_floppy，无需选择，直接就画出了函数调用关系图，而且函数名自动包含了函数所在文件的路径信息。

[模糊匹配]
例如，如果只记得函数名的一部分，比如 setup，则可以：
    $ callgraph -f setup
    Func: setup
    Match: 4
    File:
         1    ./kernel/blk_drv/floppy.c:static void setup_DMA(void)
         2    ./kernel/blk_drv/floppy.c:inline void setup_rw_floppy(void)
         3    ./kernel/blk_drv/hd.c:int sys_setup(void * BIOS)
         4    ./include/linux/sys.h:extern int sys_setup();
    Select: 1 ~ 4 ?
因为 setup_rw_floppy 函数是第 2 个被匹配到的，选择 2 就可以得到相同的结果。

[指定函数所在文件]
    $ callgraph -f setup -d ./kernel/blk_drv/hd.c
类似的， make cg 可以这么用：
    $ make cg f=setup d=./kernel/blk_drv/hd.c

分析新版 Linux
---------------------------------------
[初玩]
先来一份新版的 Linux，如果手头没有，就到 www.kernel.org 搞一份吧：
    $ wget -c https://www.kernel.org/pub/linux/kernel/v3.x/linux-3.10.73.tar.xz
    $ tar Jxf linux-3.10.73.tar.xz && cd linux-3.10.73
玩起来：
    $ callgraph -f start_kernel -d init/main.c
[酷玩]
1. 砍掉不感兴趣的函数分支
上面生成的图，有没有觉得 printk 之类的调用太多，觉得很繁琐。没关系，用 -F 砍掉。
    $ callgraph -f start_kernel -d init/main.c -F printk
如果要砍掉很多函数，则可以指定一个函数列表：
    $ callgraph -f start_kernel -d init/main.c -F "printk boot_cpu_init rest_init"
2. 指定函数调用深度：
用 -D 命令可以指定：
    $ callgraph -f start_kernel -d init/main.c -F "printk boot_cpu_init rest_init" -D 2
3. 指定函数搜索路径
我们来看看 update_process_times 的定义，用 -d 指定搜索路径：
    $ callgraph -f update_process_times -d kernel/
4. cs find g update_process_times 
    考虑到 callgraph 本身的检索效率比较低（采用grep），如果不能明确函数所在的目录，则可以先用 cscope 
之类的建立索引，先通过这些索引快速找到函数所在的文件，然后用 -d 指定文件。
例如，假设我们通过 cs find g update_process_times 找到该函数在 kernel/timer.c 中定义，则可以：
    $ callgraph -f update_process_times -d kernel/timer.c
    
calltree(){

}
callgraph(){
callgraph
   -f func_name       # 指定函数名
   -d directory|file  # 指定函数所在文件或文件夹
   -F filterstr       # 去除一些不重要调用关系
   -D depth           # 调用深度
   -o directory       # 输出文件夹
-------------------------------------------------------------------------------
[原理分析]
callgraph 实际上只是灵活组装了三个工具，一个是 cflow，一个是 tree2dotx，另外一个是 dot。
1 cflow：拿到函数调用关系
    $ cflow -b -m start_kernel init/main.c > start_kernel.txt
2 tree2dotx: 把函数调用树转换成 dot 格式
    $ cat start_kernel.txt | tree2dotx > start_kernel.dot
3 用 dot 工具生成可以渲染的图片格式
这里仅以 svg 格式为例：
    $ cat start_kernel.dot | dot -Tsvg -o start_kernel.svg
实际上 dot 支持非常多的图片格式，请参考它的手册：man dot。
}

cflow(拿到函数调用关系){
cflow -b -m start_kernel init/main.c > start_kernel.txt
}
tree2dotx(把函数调用树转换成 dot 格式){
cat start_kernel.txt | tree2dotx > start_kernel.dot
}
dot(用 dot 工具生成可以渲染的图片格式){
cat start_kernel.dot | dot -Tsvg -o start_kernel.svg
}

# http://www.tinylab.org/source-code-analysis-gprof2dot-draw-a-runtime-function-calls-the-c-program/
-------------------------------------------------------------------------------
主要介绍三款工具，                             一款是 gprof，
                                           另外一款是 valgrind，
再一款则是能够把前两款的结果导出为 dot 图形的工具，叫 gprof2dot，它的功能有点类似于我们上次介绍的 tree2dotx。

需要事先准备好几个相关的工具。
gprof2dot: converts the output from many profilers into a dot graph
    $ sudo apt-get install python python-pip
    $ sudo pip install gprof2dot
graphviz: dot 格式处理
    $ sudo apt-get install graphviz
gprof: display call graph profile data
    $ sudo apt-get install gprof # sudo apt-get install binutils
valgrind: a suite of tools for debugging and profiling programs
    $ sudo apt-get install valgrind

# #include <stdio.h>
# int fibonacci(int n);
# int main(int argc, char **argv)
# {
#     int fib;
#     int n;
#     for (n = 0; n <= 42; n++) {
#         fib = fibonacci(n);
#         printf("fibonnaci(%d) = %dn", n, fib);
#     }
#     return 0;
# }
# int fibonacci(int n)
# {
#     int fib;
#     if (n <= 0) {
#         fib = 0;
#     } else if (n == 1) {
#         fib = 1;
#     } else {
#         fib = fibonacci(n -1) + fibonacci(n - 2);
#     }
#     return fib;
# }

gprof
---------------------------------------
Gprof 用于对某次应用的运行时代码执行情况进行分析。
它需要对源代码采用 -pg 编译，然后运行：
    $ gcc -pg -o fib fib.c
    $ ./fib
运行完以后，会生成一份日志文件：
    $ ls gmon.out
    gmon.out
可以分析之：
    $ gprof -b ./fib | gprof2dot | dot -Tsvg -o fib-gprof.svg
    
Valgrind s callgrind
---------------------------------------    
Valgrind 是开源的性能分析利器。它不仅可以用来检查内存泄漏等问题，还可以用来生成函数的调用图。
Valgrind 不依赖 -pg 编译选项，可以直接编译运行：
    $ gcc -o fib fib.c
    $ valgrind --tool=callgrind ./fib
然后会看到一份日志文件：
    $ ls callgrind*
    callgrind.out.22737
然后用 gprof2dot 分析：
    $ gprof2dot -f callgrind ./callgrind.out.22737 | dot -Tsvg -o fib-callgrind.svg
    
需要提到的是 Valgrind 提取出了比 gprof 更多的信息，包括 main 函数的父函数。
不过 Valgrind 实际提供了更多的信息，用 -n0 -e0 把执行百分比限制去掉，所有执行过的全部展示出来：
    $ gprof2dot -f callgrind -n0 -e0 ./callgrind.out.22737 | dot -Tsvg -o fib-callgrind-all.svg

考虑到上述结果太多，不便于分析，如果只想关心某个函数的调用情况，以 main 为例，则可以：
    $ gprof2dot -f callgrind -n0 -e0 ./callgrind.out.22737 --root=main | dot -Tsvg -o fib-callgrind-main.svg
    
需要提到的是，实际上除了 gprof2dot，kcachegrind 也可以用来展示 Valgrind callgrind 的数据：
    $ sudo apt-get install kcachegrind
    $ kcachegrind ./callgrind.out.22737
通过 File --> Export Graph 可以导出调用图。只不过一个是图形工具，一个是命令行，而且 kcachegrind 不能一次展示所有分支，不过它可以灵活逐个节点查看。

 What’s more?
 --------------------------------------
 结果上跟上次的静态分析稍微有些差异。
    实际运行时，不同分支的调用次数有差异，甚至有些分支可能根本就执行不到。这些数据为我们进行性能优化提供了
可以切入的热点。
    实际运行时，我们观察到除了代码中有的函数外，还有关于 main 的父函数，甚至还有库函数如 printf的内部调用
细节，给我们提供了一种途径去理解程序背后运行的细节。

# http://blog.csdn.net/stanjiang2010/article/details/5655143
gprof(){
gprof 用户手册网站 http://sourceware.org/binutils/docs-2.17/gprof/index.html

4 使用流程
1. 在编译和链接时 加上-pg选项。一般我们可以加在 makefile 中。
2. 执行编译的二进制程序。执行参数和方式同以前。
3. 在程序运行目录下 生成 gmon.out 文件。如果原来有gmon.out 文件，将会被重写。
4. 结束进程。这时 gmon.out 会再次被刷新。
5. 用 gprof 工具分析 gmon.out 文件。
5 参数说明
    -b 不再输出统计图表中每个字段的详细描述。
    -p 只输出函数的调用图（Call graph的那部分信息）。
    -q 只输出函数的时间消耗列表。
    -e Name 不再输出函数Name 及其子函数的调用图（除非它们有未被限制的其它父函数）。可以给定多个 -e 标志。一个 -e 标志只能指定一个函数。
    -E Name 不再输出函数Name 及其子函数的调用图，此标志类似于 -e 标志，但它在总时间和百分比时间的计算中排除了由函数Name 及其子函数所用的时间。
    -f Name 输出函数Name 及其子函数的调用图。可以指定多个 -f 标志。一个 -f 标志只能指定一个函数。
    -F Name 输出函数Name 及其子函数的调用图，它类似于 -f 标志，但它在总时间和百分比时间计算中仅使用所打印的例程的时间。可以指定多个 -F 标志。一个 -F 标志只能指定一个函数。-F 标志覆盖 -E 标志。
    -z 显示使用次数为零的例程（按照调用计数和累积时间计算）。
一般用法： gprof –b 二进制程序 gmon.out >report.txt

6 报告说明
Gprof 产生的信息解释：
  %time             # 该函数消耗时间占程序所有时间百分比
Cumulative seconds  # 程序的累积执行时间（只是包括gprof能够监控到的函数）
Self Seconds        # 该函数本身执行时间（所有被调用次数的合共时间）
Calls               # 函数被调用次数
Self TS/call        # 函数平均执行时间（不包括被调用时间）（函数的单次执行时间）
Total TS/call       # 函数平均执行时间（包括被调用时间）（函数的单次执行时间）
name                # 函数名

Call Graph 的字段含义：
Index        # 索引值
%time        # 函数消耗时间占所有时间百分比
Self         # 函数本身执行时间
Children     # 执行子函数所用时间
Called       # 被调用次数
Name         # 函数名

注意：
程序的累积执行时间只是包括gprof能够监控到的函数。工作在内核态的函数和没有加-pg编译的第三方库函数是无法被gprof能够监控到的，（如sleep（）等）
Gprof 的具体参数可以 通过 man gprof 查询。
7 共享库的支持
对于代码剖析的支持是由编译器增加的，因此如果希望从共享库中获得剖析信息，就需要使用 -pg 来编译这些库。提供已经启用代码剖析支持而编译的 C 库版本（libc_p.a）。
如果需要分析系统函数（如libc库），可以用 –lc_p替换-lc。这样程序会链接libc_p.so或libc_p.a。这非常重要，因为只有这样才能监控到底层的c库函数的执行时间，（例如memcpy()，memset()，sprintf()等）。
gcc example1.c –pg -lc_p -o example1
注意要用ldd ./example | grep libc来查看程序链接的是libc.so还是libc_p.so

9 注意事项
1. g++在编译和链接两个过程，都要使用-pg选项。
2. 只能使用静态连接libc库，否则在初始化*.so之前就调用profile代码会引起“segmentation fault”，解决办法是编译时加上-static-libgcc或-static。
3. 如果不用g++而使用ld直接链接程序，要加上链接文件/lib/gcrt0.o，如ld -o myprog /lib/gcrt0.o myprog.o utils.o -lc_p。也可能是gcrt1.o
4. 要监控到第三方库函数的执行时间，第三方库也必须是添加 –pg 选项编译的。
5. gprof只能分析应用程序所消耗掉的用户时间.
6. 程序不能以demon方式运行。否则采集不到时间。（可采集到调用次数）
7. 首先使用 time 来运行程序从而判断 gprof 是否能产生有用信息是个好方法。
8. 如果 gprof 不适合您的剖析需要，那么还有其他一些工具可以克服 gprof 部分缺陷，包括 OProfile 和 Sysprof。
9. gprof对于代码大部分是用户空间的CPU密集型的程序用处明显。对于大部分时间运行在内核空间或者由于外部因素（例如操作系统的 I/O 子系统过载）而运行得非常慢的程序难以进行优化。
10. gprof 不支持多线程应用，多线程下只能采集主线程性能数据。原因是gprof采用ITIMER_PROF信号，在多线程内只有主线程才能响应该信号。但是有一个简单的方法可以解决这一问题：http://sam.zoy.org/writings/programming/gprof.html
11. gprof只能在程序正常结束退出之后才能生成报告（gmon.out）。
a) 原因： gprof通过在atexit()里注册了一个函数来产生结果信息，任何非正常退出都不会执行atexit()的动作，所以不会产生gmon.out文件。
b) 程序可从main函数中正常退出，或者通过系统调用exit()函数退出。

}

calltree(){
使用：    
    calltree -help
    calltree -np -gb -m *.c
    calltree -np -gb lf=send_query *.c
    calltree -np -b  list=start_kernel    depth=4 `find ./init/ -name "*.c"` > maps
    calltree -np -b  list=raw_spin_lock_irqsave  `find . -name "*.c"`
    calltree -np -gb lf=raw_spin_lock_irqsave    `find . -name "*.c"`

    还可以生成一个调用图，以kernel为例
        calltree -np -b -dot list=start_kernel ./init/*.c > ~/start_kernel.dot
        dot -T png start_kernel.dot -o ./testhaha.png
       
    
    下面介绍一下各选项：
    -b 就是那个竖线了，很直观地显示缩进层次。
    -g 打印内部函数的所属文件名及行号，外部函数所属文件名和行号也是可打印的，详man
    -np 不要调用c预处理器，这样打印出的界面不会很杂乱，但也可能会产生错误哦，如果我们只看函数的调用关系的话，不会有大问题。
    -m 告诉程序从main开始
    还有一个重要的选项是listfunction ，缩写是lf，用来只打印某个函数中的调用，用法是： lf=your_function
    depth=#选项： 例如： calltree -gb -np -m bind9/bin/named/*.[c.h] depth=2 > codecalltree.txt
    
}








