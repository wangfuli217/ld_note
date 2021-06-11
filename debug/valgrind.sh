valgrind(简介)
{
    Valgrind是一套Linux下，开放源代码（GPL V2）的仿真调试工具的集合。Valgrind由内核（core）以及基于内核的其他调试工具组成。
内核类似于一个框架（framework），它模拟了一个CPU环境，并提供服务给其他工具；而其他工具则类似于插件 (plug-in)，
利用内核提供的服务完成各种特定的内存调试任务。
}

valgrind(功能)
{
Memcheck。  内存泄露 这是valgrind应用最广泛的工具，一个重量级的内存检查器，能够发现开发中绝大多数内存错误使用情况，比如：使用未初始化的内存，使用已经释放了的内存，内存访问越界等。这也是本文将重点介绍的部分。
Callgrind。          它主要用来检查程序中函数调用过程中出现的问题。
Cachegrind。         它主要用来检查程序中缓存使用出现的问题。
Helgrind。           它主要用来检查多线程程序中出现的竞争问题。
Massif。    内存增值 它主要用来检查程序中堆栈使用中出现的问题。
Extension。 内存泄露 可以利用core提供的功能，自己编写特定的内存调试工具。
}

valgrind(命令)
{
Valgrind的参数
用法: valgrind [options] prog-and-args [options]: 常用选项，适用于所有Valgrind工具
--tool=<name>
最常用的选项。运行 valgrind中名为toolname的工具。默认memcheck。
-h --help
显示所有选项的帮助，包括内核和选定的工具两者。
--version
显示valgrind内核的版本，每个工具都有各自的版本。
-q --quiet
安静地运行，只打印错误信息。
--verbose
更详细的信息。
--trace-children=<yes|no>
跟踪子线程? [default: no]
--track-fds=<yes|no>
跟踪打开的文件描述？[default: no]
--time-stamp=<yes|no>
增加时间戳到LOG信息? [default: no]
--log-fd=<number>
输出LOG到描述符文件 [2=stderr]
--log-file=<file>
将输出的信息写入到filename.PID的文件里，PID是运行程序的进行ID
--log-file-exactly=<file>
输出LOG信息到 file
LOG信息输出
--xml=yes
将信息以xml格式输出，只有memcheck可用
--num-callers=<number>
show <number> callers in stack traces [12]
--error-exitcode=<number>
如果发现错误则返回错误代码 [0=disable]
--db-attach=<yes|no>
当出现错误，valgrind会自动启动调试器gdb。[default: no]
--db-command=<command>
启动调试器的命令行选项[gdb -nw %f %p]

}


memcheck(内存错误)
{
memcheck探测程序中内存管理存在的问题。它检查所有对内存的读/写操作，并截取所有的malloc/new/free/delete调用。因此memcheck工具能够探测到以下问题：
1）使用未初始化的内存
2）读/写已经被释放的内存
3）读/写内存越界
4）读/写不恰当的内存栈空间
5）内存泄漏
6）使用malloc/new/new[]和free/delete/delete[]不匹配。
7）src和dst的重叠

--leak-check=<no|summary|full>
要求对leak给出详细信息? Leak是指，存在一块没有被引用的内存空间，或没有被释放的内存空间，如summary，只反馈一些总结信息，告诉你有多少个malloc，多少个free 等；如果是full将输出所有的leaks，也就是定位到某一个malloc/free。 [default: summary]
--show-reachable=<yes|no>
如果为no，只输出没有引用的内存leaks，或指向malloc返回的内存块中部某处的leaks [default: no]
--leak-resolution=<low|med|high> [default: low]
在做内存泄漏检查时，确定memcheck将怎么样考虑不同的栈是相同的情况。当设置为low时，只需要前两层栈匹配就认为是相同的情况；当设置为med，必须要四层栈匹配，当设置为high时，所有层次的栈都必须匹配。对于hardcore内存泄漏检查，你很可能需要使用--leak-resolution=high和--num-callers=40或者更大的数字。注意这将产生巨量的信息，这就是为什么默认选项是四个调用者匹配和低分辨率的匹配。注意--leak-resolution= 设置并不影响memcheck查找内存泄漏的能力。它只是改变了结果如何输出。
--freelist-vol=<number> [default: 5000000]
当客户程序使用free(C中)或者delete(C++)释放内存时，这些内存并不是马上就可以用来再分配的。这些内存将被标记为不可访问的，并被放到一个已释放内存的队列中。这样做的目的是，使释放的内存再次被利用的点尽可能的晚。这有利于memcheck在内存块释放后这段重要的时间检查对块不合法的访问。这个选项指定了队列所能容纳的内存总容量，以字节为单位。默认的值是5000000字节。增大这个数目会增加memcheck使用的内存，但同时也增加了对已释放内存的非法使用的检测概率。
--workaround-gcc296-bugs=<yes|no> [default: no]
当这个选项打开时，假定读写栈指针以下的一小段距离是gcc 2.96的bug，并且不报告为错误。距离默认为256字节。注意gcc 2.96是一些比较老的Linux发行版(RedHat 7.X)的默认编译器，所以你可能需要使用这个选项。如果不是必要请不要使用这个选项，它可能会使一些真正的错误溜掉。一个更好的解决办法是使用较新的，修正了这个bug的gcc/g++版本。
--partial-loads-ok=<yes|no> [default: no]
控制memcheck如何处理从地址读取时字长度，字对齐，因此哪些字节是可以寻址的，哪些是不可以寻址的。当设置为yes是，这样的读取并不抛出一个寻址错误。而是从非法地址读取的V字节显示为未定义，访问合法地址仍然是像平常一样映射到内存。设置为no时，从部分错误的地址读取与从完全错误的地址读取同样处理：抛出一个非法地址错误，结果的V字节显示为合法数据。注意这种代码行为是违背ISO C/C++标准，应该被认为是有问题的。如果可能，这种代码应该修正。这个选项应该只是做为一个最后考虑的方法。
--undef-value-errors=<yes|no> [default: yes]
控制memcheck是否检查未定义值的危险使用。当设为yes时，Memcheck的行为像Addrcheck, 一个轻量级的内存检查工具，是Valgrind的一个部分，它并不检查未定义值的错误。使用这个选项，如果你不希望看到未定义值错误。

}

cachegrind()
{
    cachegrind是一个cache剖析器。它模拟执行CPU中的L1, D1和L2 cache，因此它能很精确的指出代码中的cache未命中。
如果你需要，它可以打印出cache未命中的次数，内存引用和发生cache未命中的每一行代码，每一个函数，每一个模块
和整个程序的摘要。如果你要求更细致的信息，它可以打印出每一行机器码的未命中次数。在x86和amd64上， cachegrind
通过CPUID自动探测机器的cache配置，所以在多数情况下它不再需要更多的配置信息了。

手动指定I1/D1/L2缓冲配置，大小是用字节表示的。这三个必须用逗号隔开，中间没有空格，例如： valgrind --tool=cachegrind --I1=65535,2,64你可以指定一个，两个或三个I1/D1/L2缓冲。如果没有手动指定，每个级别使用普通方式(通过CPUID指令得到缓冲配置，如果失败，使用默认值)得到的配置。
--I1=<size>,<associativity>,<line size>
指定第一级指令缓冲的大小，关联度和行大小。
--D1=<size>,<associativity>,<line size>
指定第一级数据缓冲的大小，关联度和行大小。
--L2=<size>,<associativity>,<line size>
指定第二级缓冲的大小，关联度和行大小。

}

helgrind()
{
    helgrind查找多线程程序中的竞争数据。helgrind查找内存地址，那些被多于一条线程访问的内存地址，但是没有使用一致的锁
就会被查出。这表示这些地址在多线程间访问的时候没有进行同步，很可能会引起很难查找的时序问题。
    它主要用来检查多线程程序中出现的竞争问题。Helgrind 寻找内存中被多个线程访问，而又没有一贯加锁的区域，这些区域往往是
线程之间失去同步的地方，而且会导致难以发掘的错误。Helgrind实现了名为”Eraser” 的竞争检测算法，并做了进一步改进，
减少了报告错误的次数。

--private-stacks=<yes|no> [default: no]
假定线程栈是私有的。
--show-last-access=<yes|some|no> [default: no]
显示最后一次字访问出错的位置。
}

callgrind()
{
    Callgrind收集程序运行时的一些数据，函数调用关系等信息，还可以有选择地进行cache 模拟。在运行结束时，它会把分析数据
写入一个文件。callgrind_annotate可以把这个文件的内容转化成可读的形式。
一般用法:
$valgrind --tool=callgrind ./sec_infod
会在当前目录下生成callgrind.out.[pid], 如果我们想结束程序, 可以
$killall callgrind
然后我们可以用
$callgrind_annotate --auto=yes callgrind.out.[pid] > log
$vi log


--heap=<yes|no> [default: yes]
当这个选项打开时，详细的追踪堆的使用情况。关闭这个选项时，massif.pid.txt或massif.pid.html将会非常的简短。
--heap-admin=<number> [default: 8]
每个块使用的管理字节数。这只能使用一个平均的估计值，因为它可能变化。glibc使用的分配器每块需要4~15字节，依赖于各方面的因素。管理已经释放的块也需要空间，尽管massif不计算这些。
--stacks=<yes|no> [default: yes]
当打开时，在剖析信息中包含栈信息。多线程的程序可能有多个栈。
--depth=<number> [default: 3]
详细的堆信息中调用过程的深度。增加这个值可以给出更多的信息，但是massif会更使这个程序运行得慢，使用更多的内存，并且产生一个大的massif.pid.txt或者massif.pid.hp文件。
--alloc-fn=<name>
指定一个分配内存的函数。这对于使用malloc()的包装函数是有用的，可以用它来填充原来无效的上下文信息。(这些函数会给出无用的上下文信息，并在图中给出无意义的区域)。指定的函数在上下文中被忽略，例如，像对malloc()一样处理。这个选项可以在命令行中重复多次，指定多个函数。
--format=<text|html> [default: text]
产生text或者HTML格式的详细堆信息，文件的后缀名使用.txt或者.html。

}

massif(查明程序内存被那些大数据占用)
{
    堆栈分析器，它能测量程序在堆栈中使用了多少内存，告诉我们堆块，堆管理块和栈的大小。Massif能帮助我们减少内存的使用，
在带有虚拟内存的现代系统中，它还能够加速我们程序的运行，减少程序停留在交换区中的几率。

ms_print massif.out.2436
图形化显示内存使用状态。
}

lackey()
{
lackey是一个示例程序，以其为模版可以创建你自己的工具。在程序结束后，它打印出一些基本的关于程序执行统计数据。
}

valgrind(valgrind工具)
{
/usr/bin/callgrind_annotate
/usr/bin/callgrind_control
/usr/bin/cg_annotate
/usr/bin/cg_diff
/usr/bin/cg_merge
/usr/bin/ms_print
/usr/bin/no_op_client_for_valgrind
/usr/bin/valgrind
/usr/bin/valgrind-listener
}