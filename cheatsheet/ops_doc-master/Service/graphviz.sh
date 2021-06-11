    调用图的分析分析大致可分为“静态”和“动态”两种，所谓静态分析是指在不运行待分析的程序的前提下进行分析，
那么动态分析自然就是记录程序实际运行时的函数调用情况了。
静态分析又有两种方法，一是分析源码，二是分析编译后的目标文件。
1. Doxygen是源码文档化工具，也能绘制调用图，它似乎是自己分析源码获得函数调用关系的.
2. GNU cflow也是类似的工具，不过它似乎偏重分析流程图（flowchart）
3. 对编程语言的理解程度最好的当然是编译器了，所以有人想出给编译器打补丁，让它在编译时顺便记录函数调用关系。
   CodeViz（其灵感来自Martin Devera (Devik) 的工具）就属于此类，它（1.0.9版）给GCC 3.4.1打了个补丁。
4. 另外一个工具egypt的思路更巧妙，不用大动干戈地给编译器打补丁，而是
   让编译器自己dump出调用关系，然后分析分析，交给Graphviz去绘图。
5. 不过也有人另起炉灶，自己写个C语言编译器（ncc），专门分析调用图，勇气可嘉。
   
    动态分析是在程序运行时记录函数的调用，然后整理成调用图。与静态分析相比，它能获得更多的信息，比如
函数调用的先后顺序和次数；不过也有一定的缺点，比如程序中语句的某些分支可能没有执行到，这些分支中
调用的函数自然就没有记录下来。
动态分析也有两种方法，一是借助gprof的call graph功能（参数-q），
                      二是利用GCC的 -finstrument-functions 参数。
GCC的-finstrument-functions 参数的作用是在程序中加入hook，让它在每次进入和退出函数的时候分别调用下面这两个函数：

void __cyg_profile_func_enter( void *func_address, void *call_site )
                                __attribute__ ((no_instrument_function));

void __cyg_profile_func_exit ( void *func_address, void *call_site )
                                __attribute__ ((no_instrument_function));

    当然，这两个函数本身不能被钩住（使用no_instrument_function这个__attribute__），不然就反反复复万世不竭了:) 
这里获得的是函数地址，需要用binutils中的addr2line这个小工具转换为函数名，如果是C++函数，还要用c++filt进行
name demangle。
# 用 Graphviz 可视化函数调用
# https://www.ibm.com/developerworks/cn/linux/l-graphvis/
ibm(){
为了捕获并显示调用图，您需要 4 个元素：
1. GNU 编译器工具链、
2. Addr2line 工具、
3. 定制的中间代码和
4. 一个名为 Graphviz 的代码。
Addr2line 工具可以识别函数、给定地址的源代码行数和可执行映像。



}
# http://www.graphviz.org/Resources.php，
# http://www.ioplex.com/~miallen/。

