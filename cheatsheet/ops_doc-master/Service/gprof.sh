gprof(简介)
{
gprof 可以为 Linux平台上的程序精确分析性能瓶颈。gprof精确地给出函数被调用的时间和次数，给出函数调用关系。
gprof 用户手册网站 http://sourceware.org/binutils/docs-2.17/gprof/index.html

注意：
程序的累积执行时间只是包括gprof能够监控到的函数。工作在内核态的函数和没有加-pg编译的第三方库函数是无法被gprof能够监控到的，（如sleep（）等）

gprof 的最大缺陷：它只能分析应用程序在运行过程中所消耗掉的用户时间，无法得到程序内核空间的运行时间。通常来说，应用程序在运行时既要花费一些时间来运行用户代码，也要花费一些时间来运行 “系统代码”，例如内核系统调用sleep()。
}

gprof(注意事项)
{
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

gprof(功能)
{
Gprof 是GNU gnu binutils工具之一，默认情况下linux系统当中都带有这个工具。
1. 可以显示“flat profile”，包括每个函数的调用次数，每个函数消耗的处理器时间，
2. 可以显示“Call graph”，包括函数的调用关系，每个函数调用花费了多少时间。
3. 可以显示“注释的源代码”－－是程序源代码的一个复本，标记有程序中每行代码的执行次数。
}

gprof(使用流程)
{
1. 在编译和链接时 加上-pg选项。一般我们可以加在 makefile 中。
2. 执行编译的二进制程序。执行参数和方式同以前。
3. 在程序运行目录下 生成 gmon.out 文件。如果原来有gmon.out 文件，将会被重写。
4. 结束进程。这时 gmon.out 会再次被刷新。
5. 用 gprof 工具分析 gmon.out 文件。
}

gprof(参数说明)
{
    -b 不再输出统计图表中每个字段的详细描述。
    -p 只输出函数的调用图（Call graph的那部分信息）。
    -q 只输出函数的时间消耗列表。
    -e Name 不再输出函数Name 及其子函数的调用图（除非它们有未被限制的其它父函数）。可以给定多个 -e 标志。一个 -e 标志只能指定一个函数。
    -E Name 不再输出函数Name 及其子函数的调用图，此标志类似于 -e 标志，但它在总时间和百分比时间的计算中排除了由函数Name 及其子函数所用的时间。
    -f Name 输出函数Name 及其子函数的调用图。可以指定多个
    -F Name 输出函数Name 及其子函数的调用图，它类似于 -f 标志，但它在总时间和百分比时间计算中仅使用所打印的例程的时间。可以指定多个 -F 标志。一个 -F 标志只能指定一个函数。-F 标志覆盖 -E 标志。
    -z 显示使用次数为零的例程（按照调用计数和累积时间计算）。
一般用法： gprof –b 二进制程序 gmon.out >report.txt
}

gprof(输出说明)
{
Gprof 产生的信息解释：
%time                   该函数消耗时间占程序所有时间百分比   
Cumulativeseconds       程序的累积执行时间（只是包括gprof能够监控到的函数）
Self Seconds            该函数本身执行时间（所有被调用次数的合共时间）
Calls                   函数被调用次数
Self TS/call            函数平均执行时间（不包括被调用时间）（函数的单次执行时间）
Total TS/call           函数平均执行时间（包括被调用时间）（函数的单次执行时间）
name                    函数名

Call Graph 的字段含义：
Index      索引值
%time      函数消耗时间占所有时间百分比
Self       函数本身执行时间
Children   执行子函数所用时间
Called     被调用次数
Name       函数名


}
