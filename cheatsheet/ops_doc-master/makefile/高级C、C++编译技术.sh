https://dupengair.github.io/2016/05/28/%E9%98%85%E8%AF%BB%E7%AC%94%E8%AE%B0-%E9%AB%98%E7%BA%A7C-C-%E7%BC%96%E8%AF%91%E6%8A%80%E6%9C%AF-%E3%80%8A%E9%AB%98%E7%BA%A7C%E3%80%81C-%E7%BC%96%E8%AF%91%E6%8A%80%E6%9C%AF%E3%80%8B%E9%98%85%E8%AF%BB%E7%AC%94%E8%AE%B01-%E5%9F%BA%E7%A1%80%E7%9F%A5%E8%AF%86/

http://www.cnblogs.com/LittleHann/p/4244863.html # Linux Dynamic Shared Library && LD Linker 值得好好看看
 
https://zhiwei.li/text/2009/04/27/elf%e7%9a%84got%e5%92%8cplt%e4%bb%a5%e5%8f%8apic/ # ELF的GOT和PLT以及PIC

book(多任务操作系统基础){
1    程序的二进制文件中包含了程序运行过程中的内存映射布局的细节    7
2    链接器要对编译器生成的二进制文件进行合并，装载器进行进程内存映射的初始化工作    7
3    所有现在操作系统都是按这种角色分离的方式设计的    7

|<---------------------虚拟机------------------->|
|<--------------进程------------->|              |
|<------虚拟内存------>|<-指令集->|   操作系统   |
|                      |    CPU   |
|<-字节流->|   主存    |
|  IO设备  |

CPU寄存器 一级缓存 二级缓存 三级缓存 主存 本地磁盘 远程存储设备
容量更小|速度更快 <----------------------> 容量更大|速度更慢

虚拟地址：1.简化链接过程，2. 简化加载过程， 3. 实现运行时进程间共享 4. 简化内存分配机制

#|               +---------------+
#|               | 系统          | 控制程序执行的操作系统功能
#|               +---------------+
#|               | argv, environ |  环境变量
#|               +---------------+
#|               | Stack       ↓ |  main函数中的局部变量
#|  栈           +...............+  其他函数中的局部变量
#|               |               |
#|  共享内存     +...............+  
#|               |               |  动态链接库函数
#|               |               | 
#|               |               | 
#| Program Break +...............+
#|               |               |
#|               | 堆          ↑ |
#|               |               |
#|               +---------------+
#|               | 初始化数据    |
#|               +---------------+
#|               | 未初始化数据  |
#|               +---------------+
#|               |静态库链接库函数| 
#|               +---------------+
#|               | 其他程序函数  | 
#|               +---------------+
#|               |main函数(main.o)| 
#|               +---------------+  0x08048000
#|               |启程函数(crt0.o)| 
#|               +---------------+  0x00000000

}

book(程序生命周期阶段基础){
4    预处理阶段：头文件包含、宏替换、条件编译    12
     gcc -i <input_file> -o <output_preprocessed_file>.i         # 预处理过程
	 gcc -E -P -i <input_file> -o <output_preprocessed_file>.i   # 更加清晰的预处理过程
5    词法分析的目的在于检查程序是否满足编程语言的语法规则， # 将源代码分割成不可分割的单词                    13
     # 将提取出来的单词连接成单词序列，并根据编程语言规则验证其顺序是否合理。                                 13
     语义分析的目的是发现符合语法规则的语句是否有实际意义   # 目的是发现符合语法规则的语句是否具有实际意义。  13
	 # 比如，两个整数相加并把结果赋值给一个对象的语句，虽然能通过语法规则的检查，但可能无法通过语义检查。     13
6    汇编阶段将标准的语言集合转换成特定CPU指令集的语言集合    14
     gcc -S <input_file> -o <output_assemble_file>.s
     gcc -S -masm=att function.c -o function.s     # AT&T   objdump -D <input_file>.o
     gcc -S -masm=intel function.c -o function.s   # intel  objdump -D -M intel <input_file>.o
     
     gcc -c <input_file> -o <output_file>.o
7    1. 目标文件是通过其对应的源代码翻译得到的。
     2. 符号(symbol)和节(section)是目标文件的基本组成部分。其中符号表示的是程序的内存地址或数据内存
     3. 构建程序的目的在于：将编译的每个独立的源文件生成的节拼到一个二进制可执行文件中。
     4. 目标文件中的独立的节都有可能包含在最终的程序内存映射中，因此目标文件中每个节的起始地址都会被临时设置成0，
     5. 在将目标文件的节拼接到程序内存映射的过程中，其中唯一重要的参数是节的长度，准确地说是节的地址范围。
     6. 等待链接时调整。目标文件只需要指定堆和栈的默认长度，不影响其中的数据    23
8    程序构建过程中需要支持代码复用以及拼接来自不同项目二进制文件的能力，所以明确要求实现（C/C++）构建时分成两个阶段    25
     功能独立的代码之间的函数调用；外部变量
9    在拼接这些节之前，函数与变量的实际地址是无法确定的，此时函数调用和外部变量为未解析引用。    26
10   虚拟内存使链接器将需要填入的程序内存假设为从0开始，而且每个程序的地址范围相同，
     使得每个程序拥有一致简单的地址空间视图    27
11   链接的第一步重定位进行拼接，将多个目标文件中的小节拼接到程序的内存映射中，
     将这些节的地址范围线性地转换为程序内存映射地址范围    27
12   第二步解析引用，为不同部分的代码建立关联，使程序成为一个整体，编译器会假定外部符号未来会在进程内存映射中存在，
     但直到生成完整内存映射之前，这些符号都会当成未解析引用    27
     gcc -c function.c main.c
	 gcc function.o main.o -o demoApp
	 或者 gcc function.c main.c -o demoApp # objdump -D -M intel main.o
	                                       # objdump -D -M intel demoApp
                                           # objdump -x -j .bss demoApp
     # 用以说明 nCompletionStatus 和 add_and_multiply的变量链接和函数链接
13   可执行文件并不完全是通过编译项目源代码文件生成的。启动程序的一些代码片段是在链接阶段才添加到程序的内存映射中的，
     通常放在内存映射的起始处。    33
     用于启动程序的一部分非常重要的代码片段，是在链接阶段才添加到程序内存映射中的。
     链接器通常将这部分代码放在程序内存映射的起始处。启动代码有两种不同形式：
    1. ctr0是"纯粹"的入口点，这是程序代码的第一部分，在内和控制下执行。
    2. ctr1是更为现代化的启动例程(startuproutine)，可以在main函数执行前与程序终止后完成一些任务。
#|               +-------------------+
#|               |特定进程的数据结构 |
#|               | 页表task mm结构体 |
#|               | 以及内核栈        |控制程序执行的操作系统功能
#|               +-------------------+
#|               | 物理内存      | 每个进程相同
#|               +---------------+
#|               |内核代码和数据 | 每个进程相同
#|               +---------------+
#|               | 系统          | 控制程序执行的操作系统功能
#|               +---------------+
#|               | argv, environ |  环境变量
#|               +---------------+
#|               | Stack       ↓ |  main函数中的局部变量
#|  栈           +...............+  其他函数中的局部变量
#|               |               |  %esp
#|  共享内存     +...............+  
#|               |               |  
#|               |               | 动态链接库函数
#|               |               | 
#| Program Break +...............+
#|               |               |  brk
#|               | 堆          ↑ | 运行时堆(通过malloc函数)
#|               |               |
#|               +---------------+
#|               |  未初始化数据 |  .bss
#|               +---------------+ 
#|               |  初始化数据   |  .data
#|               +---------------+
#|               |静态库链接库函数| 
#|               +---------------+
#|               | 其他程序函数  |    
#|               +---------------+
#|               |main函数(main.o)|  程序正文 .text
#|               +---------------+  0x08048000(32) | 0x40000000(64)
#|               |启程例程(crt1.o)| 
#|               +---------------+  0x00000000

}
fork - exec -> sys_execve -> search_binary_handler -> load_elf_binary # 加载程序
PT_INTERP                                                             # 动态库加载 -static 静态库
e_entry -> _start(__libc_start_main)->_init - main ->__fini           # 启动程序加载
book(加载程序执行阶段){
14    shell会先通过派生于自身相同的子进程来创建自己的副本（fork），这样能有效的将所有shell的环境变量传递给新进程。
      等待创建好内存映射后，原始数据会被新进程的内存映射覆盖，为执行做好准备    37
15    对于前台进程，shell会等待这个clone的进程执行完成，后台进程shell则会继续监视别的命令    39
16    内核通过exec函数族接管shell，最终都会调用真正执行程序sys_execve函数。    39
17    执行的第一步是识别(search_binary_handler)可执行格式，如果识别出elf，会调用load_elf_binary()，为程序启动准备内存映射    39
      # 如何让内核启动 exec -> sys_execve -> search_binary_handler -> load_elf_binary
18    链接器是个高度复杂的模块，为何能解析引用，链接器必须非常了解各个节的内部细节。装载器要简单很多，
      它将链接器创建的节组合成段复制到进程内存映射中，只关心节的可读写属性，以及可执行文件启动前是否需要打补丁    40
19    装载器首先会定位可执行二进制文件中的PT_INTERP段，用于动态加载    40
      # PT_INTERP段，用于动态加载阶段。
      gcc main.cpp -o regularBuild
      gcc -static main.cpp -o staticBuild
20    接着装载器会读取二进制文件的头，确定每个段的地址和字节长度    42
21    # 真正的复制操作是程序启动后建立好进程的物理内存页和程序内存映射表之间的虚拟内存映射关系才执行的，
      # 程序运行需要某个段时才会加载对应的页，这种策略使程序中每一部分只有在运行时真正需要才会加载。    42
22    转载启运行程序开始，先查找ELF头的e_entry字段，这是.text段的首地址，通常是_start函数的地址。
      _start函数为__libc_start_main准备入口参数，后者启动程序并调用_init和注册__fini函数初始化程序，
      最后调用main执行用户主程序。    43
      # e_entry -> _start(__libc_start_main)->_init - main ->__fini
      __libc_start_main()函数的作用：
      1. 启动程序线程
      2. 调用_init()函数，该函数会在调用main()函数前完成必要的初始化操作。(gcc编译器利用
         __attribute__((constructor)))关键字对程序启动前的自定义操作提供支持。
      3. 利用__fini()和rtld_fini()函数，这些函数会在程序终止时调用。通常来说，
         _fini()和_init()函数操作的顺序是相反的。
23    程序流实际上是一连串的函数调用，函数变量的传递机制形成了一些特殊的汇编语言惯例，这些基于栈的实现机制就是调用惯例    44
24    若要实现若干用于导出函数与数据的动态链接库接口， cdec1调用管理是首选    45
}

book(重用概念的作用){
25    静态库只是目标文件的集合，可以解包，从而添加或更改目标文件    49
26    装载时重定位LTR，是目标程序的私有代码与公共代码分离，部分代码可以在程序间共享。这种技术为了实现
      应用程序地址映射，装载时修改了.text的符号，导致动态库加载的地址范围可能完全不同，从而使每个应用程序
      都要在内存中加载公共代码的副本。即只共享代码，不共享运行时内存。    49
27    位置无关代码PIC，通过修改动态库代码访问符号的方式（因为进程的内存映射都从0开始），只加载一份
      动态库副本到内存中，通过内存映射实现各应用程序间共享。    50
      虚拟内存的概念为运行时共享(即PIC)的实现奠定了基础。
28    构建动态库包含了编译和解析引用的过程，生成的二进制文件与可执行文件本质相同，只是缺少可以
      独立运行的startup routines    52
29    有些符号不在编译时解析，这个过程可以在完成链接之后，生成最终的二进制文件时执行    52
30    我们可以修改动态库使其独立运行    52
31    符号查找时，链接器会将已经完成链接的动态库二进制文件与正在编译的项目合并，这一阶段要保证所有符号都能被正确解析，二进制文件所需符号都能在动态库中找到    53
32    运行时装载和符号解析：
    1、查找库位置 
    2、载入内存映射 
    3、解析符号到正确地址——动态链接    53
33    动态库特点:
    1. 构建过程更完整，包括编译和链接，之比可执行文件少了启动代码 
    2. 可以链接其它库    56
34    二进制接口ABI：编译链接过程根据源代码接口创建的符号集合(主要是函数入口)
    1. 构建阶段客户端二进制文件只检查动态库的外部接口符号，不关心函数体
    2. 运行时链接使用的动态库二进制文件，必须与构建时保持一致的ABI    57
35    静态库与动态库的导入：
    1. 静态库只导入链接目标文件需要的符号(以目标文件为单位)
    2. 动态库链接时装载整个动态库，代码体积的增长只在运行时体现
    3. 静态库的符号是全局的，链接时保留可见性，多个静态库的相同符号会引起冲突
4. 动态库通过链接器能避免符号冲突    58
36    # 链接器选项-rdynamic将.symtab节中的所有符号导出到动态符号节.dynsym以便用于动态链接    59
    当静态库的功能需要通过中介动态库连接到客户二进制文件时，我们可以采用一个技巧来对该问题进行处理；
    中介动态库自身并不使用任何动态库的功能。因此，根据前面阐述的导入选择规则，
不应该将静态库的任何内容链接到动态库中。但是，这样设计动态的唯一原因是需要引入静态库的功能，
并将其符号到处给其他的使用者。
gcc -fPIC <source files> -Wl,--whole-archive -l<static_libraries> -o <shlib_filename>
gcc -fPIC <source files> -o <executable-output-file> 
    -Wl,--whole-archive -l<libraries-to-be-entirely-linked-in> 
    -Wl,--no-whole-archive -l<all-other-libraries> 
# -Wl,--whole-archive 无论客户二进制文件是否需要库中的符号，链接器都应该无条件链接列出在该选线之后的一个或多个库。
# -rdynamic链接器选项。开发者可以通过该选项请求连接器将所有符号导出到动态库节中，使得这些符号可以用于动态库，
# 有趣的是，该符号并不需要使用-Wl前缀。
}
rdynamic(rdynamic, g, ggdb, whole-archive和no-whole-archive){
http://www.lenky.info/archives/2013/01/2190
    -rdynamic却是一个连接选项，它将指示连接器把所有符号（而不仅仅只是程序已使用到的外部符号，但不包括静态符号，
比如被static修饰的函数）都添加到动态符号表（即.dynsym表）里，以便那些通过dlopen()或backtrace()（这一系列函数
使用.dynsym表内符号）这样的函数使用。
    gcc -O0 -rdynamic -o t.rd t.c
    readelf -s t.rd
    # 可以看到添加-rdynamic选项后，.dynsym表就包含了所有的符号，不仅是已使用到的外部动态符号，
    # 还包括本程序内定义的符号，比如bar、foo、baz等。.dynsym表里的数据并不能被strip掉：
    strip t.rd 
    readelf -s t.rd

    -g是一个编译选项，即在源代码编译的过程中起作用，让gcc把更多调试信息（也就包括符号信息）收集起来并将存放到
最终的可执行文件内。
    加-g编译后，因为包含了debug信息，因此生成的可执行文件偏大（程序本身非常小，所以增加的调试信息不多）。
    gcc -O0 -o t t.c           # 
    gcc -O0 -g -o t.g t.c      # 
    readelf -a t > t.elf       # 
    readelf -a t.g > t.g.elf   # 
    加-g编译后，因为包含了debug信息，因此生成的可执行文件偏大（程序本身非常小，所以增加的调试信息不多）。
    readelf -s t # 看-g编译的符号表：注意.dynsym表，只有该程序用到的几个外部动态符号存在。
    
1. -g选项新添加的是调试信息（一系列.debug_xxx段），被相关调试工具，比如gdb使用，可以被strip掉。
2. -rdynamic选项新添加的是动态连接符号信息，用于动态连接功能，比如dlopen()系列函数、backtrace()系列函数使用，不能被strip掉，即强制strip将导致程序无法执行：
3. .symtab表在程序加载时会被加载器丢弃，gdb等调试工具由于可以直接访问到磁盘上的二进制程序文件：
4. -rdynamic选项不产生任何调试信息，因此在一般情况下，新增的附加信息比-g选项要少得多。除非是完全的静态连接，
   否则即便是没有加-rdynamic选项，程序使用到的外部动态符号，比如前面示例里的printf，也会被自动加入到.dynsym表。

-g [.debug_aranges .debug_pubnames .debug_info  .debug_abbrev .debug_line .debug_frame .debug_loc]新增 .symtab section扩展
-rdynamic .dynsym section扩展
静态编译不再需要-rdynamic选项，该选项用于。

strip --strip-all t # 程序正常启动                      去掉.symtab
strip -R .dynsym t  # 程序由于不能链接动态库而启动失败  去掉.dynsym
-------------------------------------------------------------------------------
--whole-archive 可以把 在其后面出现的静态库包含的函数和变量输出到动态库，--no-whole-archive 则关掉这个特性
-fvisibility=hidden
　　设置默认的ELF镜像中符号的可见性为隐藏。使用这个特性可以非常充分的提高连接和加载共享库的性能，
生成更加优化的代码，提供近乎完美的API输出和防止符号碰撞。我们强烈建议你在编译任何共享库的时候使用该选项。
-fvisibility-inlines-hidden
    默认隐藏所有内联函数，从而减小导出符号表的大小，既能缩减文件的大小，还能提高运行性能，我们强烈建议你
在编译任何共享库的时候使用该选项
}
book(使用静态库){
37    动态库的隐含假设是模块化，设计原则规定只提供接口    67
38    静态库的链接规则：
    1. 静态库从传递给链接器的列表的最后一个开始链接，反向逐个链接
    2. 在所有目标文件中，只有包含可执行文件使用到符号的目标文件才被链接
    3. 动态库和静态库很活使用时，用ar -x将静态库解包然后打包成动态库    68
gcc -c first.c second.c
ar rcs libstaticlib.a first.o second.o
}

book(设计动态库：基础篇){
gcc -fPIC -c first.c second.c
gcc -shared first.o second.o -o libdynamiclib.so

#ifdef __cplusplus
extern "C"
{
#endif //__cplusplus
int myFunction(int x, int y);
#ifdef __cplusplus
}
#endif //__cplusplus
39    Linux惯例，以lib前缀，.so扩展名    70
40    选项-fPIC:使用加载时重定位技术避免将动态库代码段.text绑定到第一个加载的进程,否则当更多    进程链接时,内存只能装入更多的副本    71
41    静态库与fPIC：
    静态库链接到动态库，必需使用-fPIC    72
42    C++的二进制接口问题：
    1. 复杂的符号命名规则，需要名称修饰，其实现依赖于编译器
        1) 函数接口属于类，因此有从属信息
        2) 函数重载，需要标识不同的参数    77
43    2. 静态初始化问题
    1) 对象初始化依赖于构造函数，需要编译器根据继承链执按顺序执行
    2) 静态对象的初始化顺序无法指定
    解决方案
        1) 为_init和_fini函数提供自定义实现
        2）通过函数访问对象的静态实例，编译器和C++11标准保证了线程安全性    78
44    3.模板
    1）不同的模板实例化以后产生完全不同的机器代码，用作动态库导出时产生问题
解决方案：
    1）编译器生成所有模板的特化代码，并创建弱符号
    2) 链接完成以后再将模板实例化，插入机器代码    79
45    设计ABI：
    1）通过extern ""C""使用C风格接口
    2）使用工厂模式提供C风格接口    
    3）使用被广泛支持的标准C关键字
    4）使用工厂机制C++或模块C
    5）只对外提供必需的符号
    6）利用命名空间来解决符号名称冲突问题    80
46    控制符合可见性:
    1. 编译器选项：-fvisibility=<hidden> # 影响所有代码
    2. 函数前使用编译属性修饰：__attribute__((visibility(""<default|hidden>""))) # 只影响单个符号
    3. 头文件使用编译指令：#pragma GCC visibility [push|pop] (hidden)  # 影响单个符号或一组符号
    #pragma  visibility push(hidden)
    ... //void someprivatefunction_1(void);
    #pragma  visibility pop(hidden)
    4. 使用strip    82
47    强制编译器符号解析必需成功：--no-undefined，gcc处理编译器选项必需使用-Wl,前缀：-Wl，--no-undefined，如果直接使用LD就不用    94
48    动态链接模式：
    启动时链接
    运行时加载    95
    如果将--no-undefined选项传递给gcc链接器，在构建时一旦有符号无法解析，就会导致构建失败。这样一来。
Linux默认容忍为解析符号存在的行为就与Windows那样严格的条件保持了一致。
gcc -fPIC <source files> -l <libraries> -Wl,--noundefined -o <shlib output filename>       #84
}

book(定位库文件){
      static library filename = lib + <library name>+ .a
49    Linux基于库文件命名规则进行定位：lib + <name> + .so + <version>    101
50    动态库版本信息： version = <主版本 Major>.<次版本 Minor>.<补丁号 patch>    101
51    动态库名称soname：lib + <name> + .so + <Major>  如libz.so.1.2.3.4 -> libz.so.1 (soname)   101
实际上只有主版本号的数字在库soname中起作用，这就意味着即使库的此版本号是不同的，也可能使用同一个soname值来表示。
52    "soname由链接器嵌入二进制库文件专有的ELF字段中：
    $gcc -shared <objs> -Wl, -soname, libfoo.so.1 -o libfoo.so.1.0.0
    通过readelf -d 查看：
    0x000000001(SONAME)    Library soname: [libfoo.so.1]"    102
53    linker name：foo    102
54    编译时指定库文件： -L<路径> -l<linker name>    102
      将完整的库文件路径分成两个部分：目录路径和库文件名
      1. 将目录路径添加到-L连接器选项后面，并传递给链接器
      2. 将库文件名(连接器名称)添加到-l参数后面，并传递给链接器
      gcc main.o -L../sharedlib -lworkingdemo -o demo
55    选项-L只在链接时起作用，-l在运行时也会产生影响    104
56    # linux动态库运行时定位规则：
    1. 预加载库
    2. LD_LIBRARY_PATH环境变量
    3. ldconfig缓存
    4. 默认路径(/lib和/usr/lib)    110
57    预加载库：
    1）通过LD_PRELOAD环境变量：
        export LD_PRELOAD=/path:$LD_PRELOAD
    2）通过/etc/ld.so.preload文件定义
    3）rpath/runpath选项
       对应ELF的DT_RPATH和DT_RUNPATH字段，后者优先级更高，用于避免rpath指定的是相对于应用程序启动的路径
       通过-R或-rpath想链接器传递，或者指定LD_RUN_PATH环境变量    110
       gcc test.c -L. -lmain -Wl,-rpath, path/to/lib
58    LD_LIBRARY_PATH:
    1. 临时的机制
    2. runpath被设计支持LD_LIBRARY_PATH的需求，同时避免rpath指定的是相对于应用程序启动的相对路径
      gcc -Wl, -R/path -Wl, --enable-new-dtags -lfoo        112
59    ldconfig:
    将指定路径插入动态库搜索列表/etc/ld.so.conf，库名添加到列表/etc/ld.so.cache    113
---------------------------------------
gcc main.o -L../sharedlib -lworkingdemo -o demo
gcc -wall -fPIC main.cpp -Wl,-l../sharedlib -Wl,-lworking -o demo
在使用gcc命令行一次性完成编译链接两个过程时，应该在链接器选项之前添加-Wl选项。
  1. 预加载库
预加载库应该拥有最高的搜索优先级，因为装载器会首先加载这些库，然后才开始搜索其他库。
有两种方式可以指定预加载库。
export LD_PRELOAD=/home/milan/project/libs/libmilan.so:$LD_PRELOAD
通过/etc/ld.so.preload文件: 该文件中包含的ELF共享库文件会在程序启动前加载，文件列表使用空格分隔。
指定预加载库并不符合标准的设计规范。相反，该方案仅用于特殊情况，比如设计压力测试、诊断以及对原始代码的紧急补丁等。

DT_PATH 
gcc -Wl,-R/home/milan/projects/ -lmilanlibrary
export DT_RUNPATH=/home/milan/projects/:$DT_RUNPATH

DT_RUNPATH
gcc -Wl,-R/home/milan/projects/ -Wl,--enable-new-flags -lmilanlibrary
-Wl # 在通过gcc间接调用链接器，而不是直接调用ld时，需要加上'-Wl'前缀
-R  # runpath链接器选项
--enable-new-flags # 实际的rpath值将rpath和runpath设置成同一个字符串值

export LD_LIBRARY_PATH=/home/milan/projects/:$LD_LIBRARY_PATH
---------------------------------------
总的来说，优先级方案可以归类为以下两种版本：
60    1. 如果指定了指定RUNPATH(即DT_RUNPATH字段非空)的优先级：
    1.1. LD_LIBRARY_PATH
    1.2. runpath
    1.3. ld.so.cache
    1.4. default(/lib /usr/lib)
      2. 如果没有指定RUNPATH(即DT_RUNPATH字段为空)的优先级：
    2.1. 被加载库的rpath
    2.2. 可执行文件的rpath
    2.3. LD_LIBRARY_PATH
    2.4. ld.so.cache
    2.5. default    114
    
使用-L规则的优势：程序不会因运行时库位置改变而出现问题。
当使用-L选项指定构建时库路径时，，我们可以将库文件路径和库名称有效分离，并将库名称嵌入客户二进制文件中。
当运行时需要搜索库文件时，运行时库搜索算法实现可以很好的嵌入到客户二进制中的库名称中。 # libdynamiclinkingdemo.so
}
book(共享库的查找过程){
1. 根据ELF文件中的配置信息
任何一个动态链接的模块所依赖的模块路径保存在".dynamic"段中，由DT_NEED类型的项表示，
动态链接器会按照这个路径去查找DT_RPATH所指定的路径，编译目标代码时，
可以对gcc加入链接参数"-Wl,-rpath"指定动态库搜索路径 

2. DT_NEED段中保存的是绝对路径，则动态链接器直接按照这个路径进行直接加载

3. 根据LD_PRELOAD中指定的路径加载共享库、目标文件

/*
4. /etc/ld.so.cache
到了这一步，如果动态链接器(/lib/ld-linux.so.X)没有得到可以直接打开的绝对路径，则需要开始根据相对路径进行共享库的搜索
Linux为了加速这个搜索过程，在系统中建立了一个ldconfig程序，这个程序负责
    1) 将共享库下的各个共享库维护一个SO-NAME(一一对应的符号链接)，这样每个共享库的SO-NAME就能够指向正确的共享库文件
    2) 将全部SO-NAME收集起来，集中放到/etc/ld.so.cache文件里面，并建立一个SO-NAME的缓存
当动态链接器要查找共享库时，它可以直接从/etc/ld.so.cache里面查找

所以，如果我们在系统指定的共享库目录下添加、删除或更新任何一个共享库，或者我们更改了/etc/ld.so.conf、/etc/ld.preload的配置，都应该运行一次ldconfig这个程序，以便更新SO-NAME和/etc/ld.so.cache
很多软件包的安装程序在结束共享库安装以后都会调用ldconfig
*/

5. 根据/etc/ld.so.preload中的配置进行搜索
这个配置文件中保存了需要搜索的共享库路径，Linux动态共享库加载器根据顺序进行逐行广度搜索

6. 根据环境变量LD_LIBRARY_PATH指定的动态库搜索路径 

7. DT_NEED段中保存的是相对路径，动态链接器会在按照一个约定的顺序进行库文件查找
    1) /lib
    2) /usr/lib
    3) 由/etc/ld.so.conf中配置指定的搜索路径
}


LD_LIBRARY_PATH(anychatcoresdk_linux_x64_r6613代码){
实践代码

在Linux系统中，LD_LIBRARY_PATH是一个由若干个路径组成的环境变量，每个路径之间由冒号隔开，默认情况下，
LD_LIBRARY_PATH为空，设置方法如下

1. LD_LIBRARY_PATH=/home/user/ /bin/ls
2. /lib64/ld-linux.so.2 -library-path /home/user /bin/ls

LD_LIBRARY_PATH对于共享库的开发和测试十分方便，但是不应该被滥用，随意修改LD_LIBRARY_PATH并且将其导出至全局范围，
将可能引起其他应用程序运行出现问题。同时，LD_LIBRARY_PATH也会影响GCC编译时查找库的路径，里里面包含的目录相当于
链接时GCC的"-L"参数
}
LD_PRELOAD(程序运行前优先加载的动态链接库){
    LD_PRELOAD是Linux系统的一个环境变量，它可以影响程序的运行时的链接（Runtime linker），它允许你定义
在程序运行前优先加载的动态链接库。这个功能主要就是用来有选择性的载入不同动态链接库中的相同函数。通过
这个环境变量，我们可以在主程序和其动态链接库的中间加载别的动态链接库，甚至覆盖正常的函数库。一方面，
我们可以以此功能来使用自己的或是更好的函数（无需别人的源码），而另一方面，我们也可以以向别人的程序
注入程序，从而达到特定的目的。

LD_PRELOAD运用总结
1. 定义与目标函数完全一样的函数，包括名称、变量及类型、返回值及类型等
2. 将包含替换函数的源码编译为动态链接库
3. 通过命令 export LD_PRELOAD="库文件路径"，设置要优先替换动态链接库
4. 如果找不替换库，可以通过 export LD_LIBRARY_PATH=库文件所在目录路径，设置系统查找库的目录
5. 替换结束，要还原函数调用关系，用命令unset LD_PRELOAD 解除
6. 想查询依赖关系，可以用ldd 程序名称

http://www.cnblogs.com/net66/p/5609026.html   # LD_PRELOAD的偷梁换柱之能
}
PKG_CONFIG_PATH(pkg-config){
    pkg-config 是一个在源代码编译时查询已安装的库的使用接口的计算机工具软件。pkg-config原本是设计用于Linux的，
但现在在各个版本的BSD、windows、Mac OS X和Solaris上都有着可用的版本。
它输出已安装的库的相关信息，包括：
1. C/C++编译器需要的输入参数
2. 链接器需要的输入参数
3. 已安装软件包的版本信息
   
    当安装一个库时（例如从RPM，deb或其他二进制包管理系统），会包括一个后缀名为pc的文件，它会放入某个文件夹
下（依赖于你的系统设置）。例如，在Linux为该软件的库文件所在文件夹lib之下的子文件夹pkgconfig。并把该子文件夹
加入pkg-config的环境变量PKG_CONFIG_PATH作为搜索路径，例如在bash配置文件中加入一行：
    $ export PKG_CONFIG_PATH=/usr/local/`库的名字`/lib/pkgconfig:$PKG_CONFIG_PATH
    在这个.pc文件里包含有数个条目。这些条目通常包含用于其他使用这个库的程序编译时需要的库设置，以及头文件的
位置，版本信息和一个简介。   
实例1：
gcc -o test test.c $(pkg-config --libs --cflags libpng) # -I/usr/include/libpng12  -lpng12
实例2：
export PKG_CONFIG_PATH=/usr/local/lib/pkgconfig:$PKG_CONFIG_PATH
pkg-config --cflags --libs fuse # -D_FILE_OFFSET_BITS=64 -I/usr/local/include/fuse  -pthread -L/usr/local/lib -lfuse


1.使用pkg-config链接OpenCV库
使用以下命令：
$ gcc -g -Wall test.c $(pkg-config --cflags --libs opencv) --std=c++11 -o Test
上面命令中的$(pkg-config --cflags --libs opencv)含义是在shell中执行：
$ pkg-config --cflags --libs opencv
之后将shell输出结果字符串替换之前的编译命令中pkg-config的部分。
如果在命令行输入：

$ pkg-config --libs --cflags opencv
会显示如下信息（给出了使用opencv编译所需要的头文件搜索目录参数和链接库参数）：
-I/usr/local/include/opencv -I/usr/local/include  -L/usr/local/lib -lopencv_shape -lopencv_stitching -lopencv_objdetect -lopencv_superres -lopencv_videostab -lippicv -lopencv_calib3d -lopencv_features2d -lopencv_highgui -lopencv_videoio -lopencv_imgcodecs -lopencv_video -lopencv_photo -lopencv_ml -lopencv_imgproc -lopencv_flann -lopencv_core

在linux上上述路径名为 /usr/lib/pkconfig/。
若是没有找到，它也会到PKG_CONFIG_PATH这个环境变量所指定的路径下去找。
若是没有找到，它就会报 错，
}

redirect(链接时重定位  装载时重定位){
1. 链接时重定位(Link Time Relocation)
-shared -fPIC
在程序链接的时候就将代码中对绝对地址的引用重定位为实际的地址

2. 装载时重定位(Load Time Relocation)
-shared 
程序模块在编译时目标地址不确定而需要在装载时将模块重定位

装载时重定位是解决动态模块中有绝对地址引用的方法之一，但是还存在一个问题，指令部分无法在多个进程间共享，
为了解决这个问题，一个基本思想就是把指令中那些需要被修改的部分分离出来，跟数据部分放在一起，这样指令就
可以保持不变，而数据部分可以在每个进程中拥有一个副本，这种方案就是地址无关代码(PIC Position-Independent Code)
}

GOT(全局偏移表){
[模块间指令访问]
GOT实现指令地址无关的方式和GOT实现模块间数据访问的方式类似，唯一不同的是，GOT中的项保存的是目标函数的地址，
当模块要调用目标函数时，可以通过GOT中的项进行间接跳转.

[模块间数据访问]
ELF的做法是在数据段里建立一个指向这些变量的指针数组，也被称为全局偏移表(global offset table GOT)，
当代码需要引用到该全局变量时，可以通过GOT中相对应的项进行间接引用。

链接器在装载动态模块的时候会查找每个变量所在的地址，然后填充GOT中的各个项，以确保每个指针所指向的地址正确，
由于GOT本身是放在数据段的，所以它可以在模块装载时被修改，并且每个进程都可以有独立的副本，相互不受影响。

1. 模块内部
    1) 指令跳转、调用: 相对跳转和调用
    2) 数据访问: 相对地址访问
2. 模块外部
    1) 指令跳转、调用: 间接跳转和调用(GOT)  -> [模块间指令访问] "-fPIC"
    2) 数据访问: 间接访问(GOT)              -> [模块间数据访问] "-fPIC"
    不管是模块间的指令调用、还是跨模块的全局静态变量的引用，ELF使用了GOT间接跳转来实现，本质上是使用了"中间层技术"
来屏蔽可能存在的外部模块引入的不确定性，中间层技术是实现兼容的一种很好的思考方式
-------------------------------------------------------------------------------

# 模块装载时被修改,并且每个进程都可以有独立的副本，相互不受影响。

1. 对于模块外部引用的全局变量和全局函数，用GOT表的表项内容作为地址来间接寻址
2. 对于本模块内的静态变量和静态函数，用GOT表的首地址作为一个基准，用相对于该基准的偏移量来引用，
因为不论程序被加载到何种地址空间，模块内的静态变量和静态函数与GOT的距离是固定的，并且在链接阶段就可知晓其距离的大小

这样，PIC使用GOT来引用变量和函数的绝对地址，把位置独立的引用重定向到真实的绝对位置，对于PIC代码，
代码段内不存在重定位项，实际的重定位项只是在数据段的GOT表内。
共享目标文件中的重定位类型有:
1. R_386_RELATIVE
2. R_386_GLOB_DAT
3. R_386_JMP_SLOT
用于在动态链接器加载映射共享库或者模块运行的时候对指针类型的静态数据、全局变量符号地址和全局函数符号地址进行重定位

}

PIC_PIE(){
readelf -d hook.so | grep TEXTREL
地址无关代码技术除了可以用在共享对象上面，它也可以用于可执行文件，一个以地址无关方式编译的可执行文件被称作
地址无关可执行文件(PIE Position-Independent Executable)，与GCC的"-fPIC"类似，产生PIE的参数为"-fPIE"

ELF格式的共享库使用"PIC技术"使代码和数据的引用与地址无关，程序可以被加载到地址空间的任意位置。
PIC在代码中的跳转和分支指令不使用绝对地址。
PIC在ELF可执行映像的数据段中建立一个存放所有全局变量指针的全局偏移量表GOT
}

PLT(过程链接表){

# 过程链接表(PLT)用于把位置独立的函数调用重定向到绝对位置。
# 通过PLT动态链接的程序支持惰性绑定模式。
    每个动态链接的程序和共享库都有一个PLT，PLT表的每一项都是一小段代码，对应于本运行模块要引用的一个全局函数。
程序对某个函数的访问都被调整为对PLT入口的访问，每个PLT入口项对应一个GOT项，执行函数实际上就是跳转到相应GOT项
存储的地址，该GOT项初始值为PLTn项中的push指令地址(即jmp的下一条指令，所以第1次跳转没有任何作用)，待符号解析
完成后存放符号的真正地址。
    

动态链接器在装载映射共享库时在GOT里设置2个特殊值:
1. GOT+4(即 GOT[1]): 设置动态库映射信息数据结构link_map地址
    操作系统运行程序时，首先将解释器程序即动态链接器ld.so映射到一个合适的地址，然后启动 ld.so。ld.so 先完成自己的
初始化工作，再从可执行文件的动态库依赖表中指定的路径名查找所需要的库，将其加载映射到内存。
    Linux用一个全局的库映射信息结构struct link_map链表来管理和控制所有动态库的加载，动态库的加载过程实际上是映射库
文件到内存中，并填充库映射信息结构添加到链表中的过程。结构 struct link_map描述共享目标文件的加载映射信息，是动态
链接器在运行时内部使用的一个结构，通过它保持对已装载的库和库中符号的跟踪。

    link_map使用双向链接中间件"l_next"和"l_prev"链接进程中所有加载的共享库。当动态链接器需要去查找符号的时候，
可以向前或向后遍历这个链表，通过访问链表上的每一个库去搜索需要查找的符号
//Link_map链表的入口由每个可执行映像的全局偏移表的第2个入口(GOT[1])指向，查找符号时先从 GOT[1]读取 link_map 结点地址，
然后沿着link-map 结点进行搜索 

2. GOT+8(即 GOT[2]): 设置动态链接器符号解析函数的地址_dl_runtime_resolve 
    PLT的第1个入口PLT0是一段访问动态链接器的特殊代码。程序对PLT入口的第1次访问都转到了PLT0，最后跳入GOT[2]存储的
地址执行符号解析函数。待完成符号解析后，将符号的实际地址存入相应的GOT项，这样以后调用函数时可直接跳到实际的函数地址，
不必再执行符号解析函数。


1. 动态链接器调用__mmap函数对动态库的所有PT_LOAD可加载段进行整体映射 
/*
l_map_start=(ElfW(Addr))__mmap ((void *)0, maplength, prot, MAP_COPY | MAP_FILE, fd, mapoff);
*/
返回值 l_map_start 是实际映射的虚拟地址，和段结构成员，p_vaddr指定的虚拟地址不一定相同，这对于位置无关代码不会产生影响。但是对于数据段和link_map结构中其它相关的位置描述信息还要进行修正 

2. 共享文件映射完毕，动态链接器处理共享库的PT_DYNAMIC动态段，将各项动态链接信息主要是哈希表、符号表、字符串表、重定位表、PLT 重定位项表等地址填写到link_map的l_info数组结构中。l_info是link_map最重要的字段之一，几乎所有与动态链接管理相关的内容都与l_info数组有关。动态链接器还要加载处理当前共享库的所有依赖库

3. 由于实际的映射地址和指定的虚拟地址有可能不同，因此还要对动态库及其依赖库进行重定位。设置动态库的第1个和第2个GOT 表项
/*
Elf32_Addr *got = (Elf32_Addr *) lmap->l_info[DT_PLTGOT].d_un.d_ptr;
got[1]=lmap;
got[2]=&_dl_runtime_resolve;
*/
对动态库的所有重定位项进行重定位，在重定位项指定的偏移地址处加上修正值l_addr。动态项DT_REL给出了重定位表的地址，DT_RELSZ给出重定位表项的数目，映射完毕后，动态链接器调用共享库(包括所有相关的依赖库)自备的初始化函数进行初始化


延迟绑定(PLT Procedure Linkage Table) - Lazy Binding
---------------------------------------
我们知道，动态链接比静态链接慢的主要原因有如下几个
1. 动态链接下对于全局和静态的数据访问都要进行复杂的的GOT定位，然后间接寻址，对于模块间的调用也要先定位GOT，然后再进行间接跳转
2. 动态链接的链接工作是在运行时完成的，动态链接器会寻找并装载所需要的共享对象，然后进行符号查找地址重定位工作等

Lazy Binding：
当函数第一次被用到时才进行绑定(符号查找、重定位等)，如果这个函数没有被用到则不进行绑定。
ELF使用PLT(Procedure Linkage Table)的方法来实现，在Glibc中，实现延迟绑定功能的函数名叫"_dl_runtime_resolve()"

    不管是模块间的指令调用、还是跨模块的全局静态变量的引用，ELF使用了GOT间接跳转来实现，本质上是使用了"中间层技术"
来屏蔽可能存在的外部模块引入的不确定性，中间层技术是实现兼容的一种很好的思考方式
    PLT为了实现延迟绑定，在GOT的基础之上又增加了一层间接跳转，调用函数并不直接通过GOT跳转，而是通过一个叫做PLT项
的结构来进行跳转。每个外部函数在PLT中有一个相应的项
}

ld_so(ld.so){
在Linux中，动态链接器ld.so实际上也是一个共享对象

1. 操作系统同样通过映射的方式将它加载到进程的地址空间中
2. 操作系统在加载完动态链接器之后，就将控制权交给动态链接器的入口地址(与可执行文件一样，共享对象也有入口地址)
3. 当动态链接器得到控制权之后，它开始执行一系列自身的初始化操作，然后根据当前的环境参数，开始对可执行文件进行动态链接工作
4. 当所有动态链接工作完成之后，动态链接器会将控制权转交到可执行文件的入口地址，程序开始正式执行

解释器 ".interp段"
    值得注意的是，动态链接器的位置既不是系统配置决定、也不是由环境参数决定，而是由ELF文件自身决定。
在动态链接的ELF可执行文件中，有一个专门的段叫作 ".interp段"(interpreter(解释器)段)

    动态链接器ELF中最重要的结构应该是".dynamic"段，这个段里面保存了动态链接器所需要的基本信息，例如依赖哪些共享对象、
动态链接符号表的位置动态链接重定位表的位置、共享对象初始化代码的地址等
    ".dynamic"段里保存的信息类似于ELF文件头

动态符号表 ".dynsym"
    为了完成动态链接，最关键的是所依赖的符号和相关文件的信息。为了表示动态链接这些模块之间的符号导入导出关系，
ELF专门有一个叫作动态符号表(dynamic symbol table)的段，这个段的段名通常为".dynsym"(dynamic symbol)。与".symtab"类似，
动态符号表也需要一些辅助的表，比如用于保存符号名的字符串表，即动态符号字符串表".dynstr"(dynamic string table)，
由于在动态链接下，我们需要在程序运行时查中啊符号，为了加快符号的查找过程，往往还有辅助的符号哈希表".hash"

[动态链接重定位表]
在静态链接中，这些未知的地址引用在最终链接时会被重定位修正，但是在动态链接中，导入符号的地址在运行时才确定，
所以需要在运行时将这些导入符号的引用修正，即需要动态重定位：
1. ".rel.dyn"
对数据引用的修正，它所修正的位置位于".got"以及数据段
2. ".rel.plt"
对函数引用的修正，它所修正的位置位于".got.plt"


[动态链接时进程堆栈初始化信息]
进程初始化的时候，堆栈里保存了关于进程执行环境和命令行参数等信息，除此之外，堆栈里还保存了动态链接器所需要的
一些辅助信息数组(auxiliary vevtor)
事实上，辅助信息位于环境变量指针的后面

动态链接的步骤和实现
    动态链接基本上分为3步
    1. 启动动态链接器本身(自举)
    2. 装载所有需要的共享对象
    3. 重定位、初始化
    
    0x1: 动态链接器自举
        我们知道，对于Linux程序中的普通共享对象(DSO)文件来说
        1. 普通DSO的重定位工作由动态链接器来完成
        2. 普通DSO依赖的其他共享对象由动态链接器负责链接和装载

        而对于动态链接器对应的DSO文件来说
        1. 动态链接器本身不可以依赖于其他任何共享对象编写动态链接器时保证不使用任何系统库、运行库
        2. 动态链接器本身所需要的全局和静态变量的重定位工作由它本身完成
    动态链接器必须在启动时有一段很精巧的代码可以完成这项艰巨的工作同时又不能用到全局和静态变量。
    这种具有一定限制条件的启动代码往往被称为"自举(Boosttrap)"
        1. 动态链接器入口地址就是自举代码的入口，当操作系统将进程控制权交给动态链接器时，动态链接器的自举代码即开始执行
        2. 自举代码会找到自己的GOT。而GOT的第一个入口保存的即是".dynamic"段的偏移地址，由此获得了动态链接器本身的".dynamic"段
        3. 通过".dynamic"段中的信息，自举代码便可以获得动态链接器本身的重定位表和符号表等，从而得到动态链接器本身的重定位入口，先将它们全部重定位
        4. 从这一步开始动态链接器代码中才可以开始使用自己的全局变量和静态变量

    0x2: 装载共享对象
    完成基本自举后，动态链接器将可执行文件和链接器自身的符号表都合并到一个符号表中，我们称之为
    "全局符号表(Global Symbol Table)"。然后链接器开始寻找可执行文件所依赖的共享对象，在".dynamic"段中，
    有一种类型的入口是DT_NEEDED，它标识了该可执行文件(或共享对象)所依赖的共享对象。由此
        1. 链接器可以列出可执行文件所需要的所有共享对象，并将这些共享对象的名字放入到一个装载集合中
        2. 然后链接器开始从集合里取一个所需要的共享对象的名字，找到相应的文件后打开该文件，读取相应的ELF文件头和".dynamic"段，然后将它相应的代码段和数据段映射到进程空间中
        3. 如果这个ELF共享对象还依赖于其他共享对象，那么将所依赖的共享对象的名字放到装载集合中，如果循环知道所有依赖的共享对象都被装载进来为止
        4. 链接器对共享对象的遍历过程本质上是一个图的遍历过程，链接器可能会使用深度优先、或者广度优先的顺序来进行
        5. 当一个新的共享对象被装载进来的时候，它的符号表会被合并到全局符号表中，所以当所有的共享对象都被装载进来的时候，全局符号表里面将包含进程中所有动态链接锁需要的符号

    0x3: 重定位和初始化
    当完成动态链接器的装载、普通共享对象的装载之后，链接器开始重新遍历可执行文件和每个共享对象的重定位表，将它们的GOT/PLT中的每个需要重定位的位置进行修正
    重定位完成后就，如果某个共享对象有".init"段，那么动态链接器会执行".init"段中的代码，用以实现共享对象特有的初始化过程，例如共享对象中的C++全局/静态对象的构造就是通过"init"段来初始化
    当完成了重定位和初始化后，所有的准备工作就宣告完成了，所需要的共享对象也都已经装载并且链接完成了，这个时候进程的控制权就由动态链接器转交给程序的入口并且开始执行

    Linux动态链接器本身是一个共享对象，它的路径是"/lib/ld-linux.so.2、/lib64/ld-linux-x86-64.so.2"。共享对象本质上也是
    一个ELF文件，包含ELF文件头(包括e_entry、段表等)，而动态链接器是个非常特殊的共享对象，它不仅是个共享对象，还是一个
    可执行程序，可以直接在命令行下运行
    /lib64/ld-linux-x86-64.so.2
        执行流程如下
        1. _start()调用_dl_start()函数
        2. _dl_start()首先对ld-x.y.z.so进行重定位，因为ld-x.y.z.so自身是动态链接器，它必须自己完成重定位，即"自举"
        3. 完成自举后就可以调用其他函数、并且访问全局变量了
        4. 调用_dl_start_final()收集一些基本的运行数值，进入_dl_sysdep_start()
        5. _dl_sysdep_start()进行了一些平台相关的处理之后就进入了_dl_main()，这是动态链接器的主函数
    }

book(lib){
1. /lib: 存放系统最关键和基础的共享库，例如
    1) 动态链接器
    2) C语言运行库
    3) 数学库
这些库主要是那些/bin、/sbin下的程序以及系统启动时所要用到的库
2. /usr/lib: 存放一些非系统运行时所需要的关键性的共享库，只要是一些开发时用到的共享库
3. /usr/local/lib: 存放一些跟操作系统本身并不十分相关的库，主要是一些第三方的应用程序的库
}
    
book(设计动态库：进阶篇){

61    动态链接的重要原则是，不同进程共享一个动态库的代码段，但不共享数据段    119
62    一些指令需要在运行时获得内存地址：
# 将内存变量加1
mov eax, ds:0xBFD10000
add eax, 0x01
mov ds:0xBFD10000
    1. 数据访问指令(mov等)需要操作数的地址
    2. 子程序调用(call、jmp等)需要代码段的函数地址    120
# 子程序调用(call和jmp等)需要代码段中的函数地址，比如说为了调用一个函数，必须为调用指令指定函数入口点的代码段内存地址
call 0x0A120034 ; 调用入口点地址为0x0A120034的函数
等价于；
push eip+2     ; 返回地址是当前地址+两条指令长度
jmp 0x0A120034 ; 跳转到my_function的地址
63    动态库加载的地址范围需要加载器模块的内部算法决定，可执行文件格式在一定程度上限定了地址范围    120
64    链接器完成目标文件的初始布局后，扫描并解析引用列表，将正确地址嵌入汇编。装载器将在加载过程中执行地址转换。    121
65    只有动态库中需要对外可见的符号，以及库中用到这些符号的接口，才受地址转换的影响，链接器知道符号对外可见时才使用绝对地址，从而在装载时进行地址转换，使绝对地址失效    122
66    动态库装载的策略：
    1. 链接器识别自身符号局限性
      * 动态库内存映射的地址范围从零开始，与可执行文件不同
    　* 链接器遇到无法解析的符号以临时值填充
    2. 链接器统计失效符号引用，准备修复提示
# 通常来说，链接器会在二进制文件体中插入特殊的.rel.dyn节，链接器和装载器之间通过节进行信息交换。
      * 记录在重定位节.rel.dyn
      * 包括需要修复的地址，以及需要执行的正确动作
    3. 装载器遵循修复提示进行地址转换
      * 装载器读取动态库，将数据映射到内存，然后读取重定位节，根据修复提示完成地址转换    125
67    ELF文件格式详细定义了链接器应该如何为装载器指定重定位提示    127
68    装载时重定位LTR，不仅能大幅缩小应用程序二进制文件长度，同时使得不同类型的应用程序可以统一执行某些操作系统特定任务    129
68    位置无关代码PIC，实现需要引用的外部符号分两个步骤：
    1. 使用mov指令访问存放实际符号地址的“全局偏移表”
    2. 将该地址的数据，即符号的地址内容，加载到有效的CPU寄存器    129
69    全局偏移表GOT存放在.got节，.text和.got节之间的偏移是链接期可知的常数    131
70    延迟绑定：
    1. 程序启动后，指令用到了地址保存在.got和.got.plt小节中的符号时，装载器才会去设置这两个小节的数据
    2. 可以更快的完成加载
    3. 程序运行时对动态库的符号引用越少，获得的性能提升越大    131
71    动态链接可能形成一个递归链，中间的动态库既要解析来自其加载库的引用，也需要重新解析其自身的符号    132
}

book(动态链接时的重复符号处理){
72    重复符号定义：
        C：只要符号名相同
        C++：由于函数重载，需要函数名和参数列表都相同    136
73    目标文件或静态库同时链接到可执行文件时，不允许出现重复符号，只有局部符号可以重复(局部静态)    137
74    通常情况下，解析重复符号最好的办法就是强化符号与其特定模块的从属关系，如C++的命名空间    142
75    通过运行时加载库通常不会出现重复符号的问题，因为需要将地址赋予客户端应用程序的符号变量    143
76    链接器选择最佳符号的策略：
    1. 重复符号位置
       链接器为出现在进程内存映射中不同部分的符号赋予不同的重要等级(优先级123，如静态库与动态库之间)
    2. 链接时指定的顺序（注意是链接顺序，与使用顺序无关）
       更早传递给链接器的动态库符号有更高的优先级（同一优先级下，如多个动态库之间）    143
77    链接器选择符号的优先级：
        优先级1：客户二进制文件符号（目标文件或静态库中，不允许重复）
                 Linux通常将这些目标文件的节安排到进程内存映射的低地址
        优先级2：动态库可见符号
                 动态库导出符号存储在动态库.dynsym节中
        优先级3：不参与链接
                 包括静态符号与没有用到的符号，以及除去的符号(不可见或strip等)
                 因为链接时不可见，所以不会引发任何冲突    144
78    注意：单例模式通常要放在动态库中，如果放在静态库，链接到动态库和可执行文件时，会因为内部符号不可见，生成多个实例    160
79    被链接的库不会继承命名空间    161
}

book(动态库的版本控制){
80    主版本号变更：客户端可执行程序需要重新构建
    1. 对功能的较大修改或重新设计
    2. ABI变更导致无法链接
    3. 修改程序依赖项    162
81    次版本号变更：在原有功能上增加或改进，不影响原有接口的定义和使用，不需要重新构建    163
82    修订版本号变更：主要代码变更在内部，不影响ABI和原有功能    163
83    
    动态库文件名：lib + <name> + .so + .<主版本 Major>.<次版本 Minor>.<补丁号 patch>
    动态库soname：lib + <name> + .so + <Major>  如libz.so.1    164
    # 软连接的复杂性
    ln -s <file path> <softlink path>
    ln -s -f <another file> <existing softlink>
    rm -rf <softlink path>
    # 库的soname和库的文件名
    library filename = lib + <library name> + .so + .<主版本 Major>.<次版本 Minor>.<补丁号 patch>
    library soname   = lib + <library name> + .so + <Major>  如libz.so.1    
    # 很显然只要有了soname，我们就基本上可以定位某个特定的库文件名了，唯一的问题在于soname只有动态库的主版本号。
    # 升级动态库时使用软链接和soname
    # 开发过程中使用软链接实现便捷功能
    gcc -shared <inputs> -l:libxyz.so.1 -o clientBinary
    gcc -shared <inputs> -lm -ldl -lpthread -lxml2 -lxyz -o clientBinary
84    动态库链接过程：
    1. 可执行文件编译时，链接到动态库的soname
    2. 运行环境下，在动态库同目录下以soname建立符号链接
    3. 由于软连接对应soname包含松散的版本信息，可以避免如果精确指定动态库版本导致无法链接到新版本    165
85    软连接不仅包含了soname，还包含了库名和.so文件扩展名    165 # 基于soname的软件控制方案
86    软链接的作用：  
    1. 不用重新构建可执行文件
    2. 不用删除当前版本的库，只要修改链接指向
    3. 可以恢复    166
    ln -s -f <new version of dynamic library file> <existing soname>
87    装载器能识别soname中可升级的子版本与不可升级的主版本号    166
88    ELF格式预留了存储soname信息的字段    167
gcc -shared <list of linker inputs> -Wl,-soname,<soname> -o <library name>
# 基于符号的版本控制方案
89    构建动态库时时用gcc指定soname：
        -soname,<soname>
        将soname嵌入库文件的DT_SONAME字段    167
90    可执行文件链接动态库时，链接器获得动态库的soname信息，写入到可执行文件的DT_NEEDED字段    168
91    ldconfig -n 显示依赖的库    169
92    ldconfig -l 从动态库解析soname，无论库文件名是什么，更加灵活    169
93    基于符号的版本控制：与soname不同，能容纳同一个符号的多个版本，通过链接器控制脚本和.symver汇编器指令实现    169
94    首先修改链接器脚本：
        int first_function_1_0(int x) { return x;//实现1 } 
        LIBSIMPLE_1.0{
            global：
                 first_function;
            local:
                 *;
        };
        LIBSIMPLE_2.0{
            global：
                 first_function;
            local:
                 *;
        };
        gcc -fPIC -c simple.c
        gcc -shared simple.o -Wl, --version-script,simpleversionscript -o libsimple.so.1.0.0    173
95    然后.symver指令实现：
        __asm(".symver first_function_1_0, first_function@SIMPLELIBVERSION_1.0")
        int first_function_1_0(int x) { //实现1 }
        __asm(".symver first_function_2_0, first_function@@SIMPLELIBVERSION_2.0")    
        int first_function_2_0(int x) { //实现2，默认使用的符号多一个@ }

        原理：
              对内会产生两个符号，first_function@SIMPLELIBVERSION_1.0和first_function@SIMPLELIBVERSION_2.0
              对外产生同一个符号first_function
            175
96    版本控制脚本由一个或多个版本节点组成，版本节点是由大括号包含的一组具名元素组成
            LIBSIMPLE_2.0.1{
                ...
            };    188
97    版本控制脚本语法：
    1. 节点名称以点或下划线分割的数字收尾，通常后续的版本节点放在后面。实际上只要确保符号名不同就行，这只是便于阅读
    2. global修饰对外提供的符号，符号间用分号分隔，内部使用的符号声明在local下
    3. 可以匹配通配符，与shell一致
    4. 可以指定extern "C"/extern "C++" 链接说明符
    5. 支持命名空间
        LIBXYZ_1.0.1{
            global：
                extern "C" {
                    libxyz_namespace::*
                }
            local: 
                *;
        };    188
98    匿名节点指不受控的版本号，一般只需要包含一个    190
}

book(动态库：其它主题){
99    插件：
    1. 可在运行时加载
    2. 添加删除不编译应用程序
    3. 插件可用性不影响应用程序正常运行    202
100    实现：
    1. 以动态库实现，对外提供标准接口
    2. 动态加载方式运行，加载时如果没有找到标准接口的符号，则卸载插件
    3.可以动态选择插件    203
101    对外提供C-linkage function    203
102    libc就是一个可执行文件：
        文件： /lib/libc.so.6 
        GNU C Library (crosstool-NG - Ambarella Linaro Multilib GCC [CortexA9 & ARMv6k] 2014.06) stable release version 2.19-2014.06, by Roland McGrath et al.
        Copyright (C) 2014 Free Software Foundation, Inc.
        This is free software; see the source for copying conditions.
        There is NO warranty; not even for MERCHANTABILITY or FITNESS FOR A
        PARTICULAR PURPOSE.
        Compiled by GNU CC version 4.9.1 20140625 (prerelease).
        Compiled on a Linux 3.10.19 system on 2014-07-09.
        Available extensions:
                crypt add-on version 2.1 by Michael Glad and others
                Native POSIX Threads Library by Ulrich Drepper et al
                BIND-8.2.3-T5B
        libc ABIs: UNIQUE
        For bug reporting instructions, please see:
        <https://bugs.launchpad.net/gcc-linaro>.      206

103    将动态库变为可执行文件的方法(原有动态库性质不变)：
    1. 代码中指定解释器为动态链接器
         #ifdef __LP64__
         const char service_interp[] __attribute((section(".interp"))) =
              "/lib/x86_64-linux-gnu/ld-linux-86-64.so.2";
         #else
         const char service_interp[] __attribute((section(".interp"))) =
              "/lib//ld-linux.so.2";
         #endif
    2. 具有main()函数，不返回值，以_exit(0)退出
         int main() {
            …
            _exit(0);
         }
    3. 编译时不开启优化，使用-O0选项
         gcc -Wall -O0 -fPIC ...
    4. 链接时用-e 传递main为入口函数
         gcc -shared -Wl,-e,main -o<libname>    206
104    弱符号：
          int __attribute((weak)) func(int a);
    1. 链接器用特殊方法处理
    2. 强符号覆盖弱符号
    3. 同名强符号报错
    4. 同名弱符号编译器确定
    5. 需要对函数指针进行保护    210
}

book(Linux工具集){

#### 快速查看工具
file(){}
查看二进制文件基本信息
$ file VS110-B2-B/main/dvsdk/libthread_db-1.0.so 
VS110-B2-B/main/dvsdk/libthread_db-1.0.so: ELF 32-bit LSB shared 
object, ARM, version 1 (SYSV), dynamically linked (uses shared 
libs), BuildID[sha1]=0xcd116fc09def3a96eb37589b5094b3baee242329, 
for GNU/Linux 2.6.16, not stripped


size(){}
获取ELF文件字节长度信息
$ size VS110-B2-B/main/dvsdk/libthread_db-1.0.so 
   text       data        bss        dec        hex    filename
  17024        612         16      17652       44f4    VS110-B2-B/main/dvsdk/libthread_db-1.0.so
  
#### 详细信息分析工具
ldd(){}
列出可执行文件启动时需要静态加载的动态库，即加载时依赖项
会递归搜索依赖项
无法列出动态加载项
$ ldd TestFwmRsl 
linux-gate.so.1 =>  (0xb774a000)
libFramework.so => ./fwlibs/libFramework.so (0xb74ff000)
libpthread.so.0 => /lib/i386-linux-gnu/libpthread.so.0 (0xb74cf000)
libuuid.so => ./fwlibs/libuuid.so (0xb74cb000)
libcrypto.so.1.0.0 => /lib/i386-linux-gnu/libcrypto.so.1.0.0 (0xb7320000)
libdl.so.2 => /lib/i386-linux-gnu/libdl.so.2 (0xb731b000)
...
某些版本的ldd可能会尝试执行程序来获得依赖信息，所以不应对不受信任的可执行文件执行ldd命令

替代命令(只会读取直接依赖的库)：

objdump(){
1.反汇编
-d:将代码段反汇编
-D: 将所有内容反汇编
-S:将代码段反汇编的同时，将反汇编代码和源代码交替显示，编译时需要给出-g，即需要调试信息。
-C:将C++符号名逆向解析。
-l:反汇编代码中插入源代码的文件名和行号。
-j section:仅反汇编指定的section。可以有多个-j参数来选择多个section。
2.查看头部信息
-x: 查看所有头部信息
-a: 查看静态库（archive文件）的头部信息
-f: 查看elf文件头部信息
-h: 查看所有节（section）的头部信息
3.显示符号表
-t: 显示符号表（symbol table）内容
-T: 显示动态符号表（dynamic symbol table）内容
-r: 显示全部重定位符号（注意：不包括动态重定位符号，适用于对可重定位目标文件*.o使用，对已丢失重定位信息的可执行文件或共享库没有什么效果）
-R：显示动态重定位符号（注意：不包含重定位符号，适用于对可执行文件或共享库文件使用，对可重定位目标文件没有效果）
4.显示所有内容
-s: 显示文件所有信息

}
objdump(只会读取直接依赖的库){objdump -p}
objdump -p
$ objdump -p TestFwmRsl | grep NEEDED
  NEEDED               libFramework.so
  NEEDED               libpthread.so.0
  NEEDED               libuuid.so
  NEEDED               libcrypto.so.1.0.0
  NEEDED               libdl.so.2
  NEEDED               librt.so.1
  NEEDED               libldap-2.4.so.2
  NEEDED               liblber-2.4.so.2
  NEEDED               libssl.so.1.0.0
  NEEDED               libSQLitePP.so
  NEEDED               libstdc++.so.6
  NEEDED               libm.so.6
  NEEDED               libgcc_s.so.1
  NEEDED               libc.so.6
readelf(ELF格式分析工具){
Usage: readelf <option(s)> elf-file(s) 
Options are:
    1) -a --all: Equivalent to: -h -l -S -s -r -d -V -A -I
    2_ -h --file-header: 仅显示ELF文件头部(ELF file header)
    3) -l --program-headers: 仅显示ELF程序头部(program headers) 
    4) -S --section-headers: 显示ELF节区头部(sections header) 
    5) -t --section-details: 显示ELF节区详细信息(section details)
    6) -e --headers: Equivalent to: -h -l -S
    7) -s --syms: 显示ELF文件符号表(symbol table) 
    8) -r --relocs: 显示ELF文件重定位表(relocations) 
    9) -d --dynamic: 显示ELF文件动态节(rdynamic section) ted bytes
}
readelf(只会读取直接依赖的库){readelf -d} 
$ readelf -d TestFwmRsl | grep NEEDED
 0x00000001 (NEEDED)                     Shared library: [libFramework.so]
 0x00000001 (NEEDED)                     Shared library: [libpthread.so.0]
 0x00000001 (NEEDED)                     Shared library: [libuuid.so]
 0x00000001 (NEEDED)                     Shared library: [libcrypto.so.1.0.0]
 0x00000001 (NEEDED)                     Shared library: [libdl.so.2]
 0x00000001 (NEEDED)                     Shared library: [librt.so.1]
 0x00000001 (NEEDED)                     Shared library: [libldap-2.4.so.2]
 0x00000001 (NEEDED)                     Shared library: [liblber-2.4.so.2]
 0x00000001 (NEEDED)                     Shared library: [libssl.so.1.0.0]
 0x00000001 (NEEDED)                     Shared library: [libSQLitePP.so]
 0x00000001 (NEEDED)                     Shared library: [libstdc++.so.6]
 0x00000001 (NEEDED)                     Shared library: [libm.so.6]
 0x00000001 (NEEDED)                     Shared library: [libgcc_s.so.1]
 0x00000001 (NEEDED)                     Shared library: [libc.so.6]

nm(输出符号以及对应类型){readelf -d} 
列出二进制文件的所有符号
无法列出strip过后的符号，需要-D参数

$ nm Asio_context.o
00000000 t _GLOBAL__sub_I__ZN8TestAsio11TaskContext15defaultMaxTasksE
         U _Unwind_Resume
         U _ZN10TestEngine11Prettyprint9EnvPrintfEPKc
         U _ZN10TestSystem4Pipe4ReadEPvj
         U _ZN10TestSystem4Pipe5WriteEPvj
         U _ZN10TestSystem4Pipe6CreateEv
         U _ZN10TestSystem4Pipe7DestroyEv
         U _ZN10TestSystem4PipeD1Ev
         U _ZN10TestSystem4Time3NowE

$ nm TestFwmRsl 
nm: TestFwmRsl: no symbols

nm(只列出动态节的符号，即动态库中对外可见的符号
可以列出strip过后的符号){
$ nm -D TestFwmRsl 
080d5f20 B BackTraceCount
080d5f40 B BackTraceMutex
0808cc70 T CountProcFromName
080b3570 W DeleteThreadLocalValue
0808ca60 T FindProcNameFromPid
0808cb70 T FindProcPidFromName    
080893f0 T _Z10HandlePipei
0808bb60 T _Z10HandleQuiti
0808bd00 T _Z10HandleSEGVi
08089ef0 T _Z10SetQuitingb
08089f20 T _Z11InitOptionsiPPcR7Options
08089510 T _Z11maskingSigni
...
}

nm(列出未经过名称修饰的符号){
$ nm -DC TestFwmRsl | head -n 30
080d5f20 B BackTraceCount
080d5f40 B BackTraceMutex
0808cc70 T CountProcFromName
080b3570 W DeleteThreadLocalValue
0808ca60 T FindProcNameFromPid
0808cb70 T FindProcPidFromName
080893f0 T HandlePipe(int)
0808bb60 T HandleQuit(int)
0808bd00 T HandleSEGV(int)
08089ef0 T SetQuiting(bool)
08089f20 T InitOptions(int, char**, Options&)
08089510 T maskingSign(int)
}

nm(){
[符号值的16进制表示] [符号属性] [符号名称]
下面详细介绍下“符号属性”不同表示的意义
| 属性字母 | 一个普通标题 |
| :---: | --- |
| A | 该符号的值是绝对的，在以后的链接过程中，不允许进行改变。这样的符号值，常常出现在中断向量表中，例如用符号来表示各个中断向量函数在中断向量表中的位置。 |
| B | 该符号的值出现在非初始化数据段\(bss\)中。例如，在一个文件中定义全局static int test。则该符号test的类型为b，位于bss section中。其值表示该符号在bss段中的偏移。一般而言，bss段分配于RAM中。 |
| C | 该符号为common。common symbol是未初始话数据段。该符号没有包含于一个普通section中。只有在链接过程中才进行分配。符号的值表示该符号需要的字节数。例如在一个c文件中，定义int test，并且该符号在别的地方会被引用，则该符号类型即为C。否则其类型为B。 |
| D | 该符号位于初始化数据段中。一般来说，分配到data section中。 |
| G | 该符号也位于初始化数据段中。主要用于small object提高访问small data object的一种方式。 |
| I | 该符号是对另一个符号的间接引用。 |
| N | 该符号是一个debugging符号。 |
| R | 该符号位于只读数据区。值得注意的是，如果在一个函数中定义const char \*test = “abc”, const char test\_int = 3。使用nm都不会得到符号信息，但是字符串”abc”分配于只读存储器中，test在rodata section中，大小为4。 |
| S | 符号位于非初始化数据区，用于small object。 |
| T | 该符号位于代码区text section。 |
| U | 该符号在当前文件中是未定义的，即该符号的定义在别的文件中。例如，当前文件调用另一个文件中定义的函数，在这个被调用的函数在当前就是未定义的；但是在定义它的文件中类型是T。但是对于全局变量来说，在定义它的文件中，其符号类型为C，在使用它的文件中，其类型为U。 |
| V | 该符号是一个weak object。 |
| W | The symbol is a weak symbol that has not been specifically tagged as a weak object symbol. |
| ? | 该符号类型没有定义 |
}
nm(列出名字修饰后的动态符号
可用来检测C++输出的C规范ABI接口，防止在ABI函数声明中忘记加入extern "C"){
nm -D –no-demangle
}

nm(在动态库中查询含有指定符号的库){
nm -A <动态库> | grep <符号>
在动态库中查询含有指定符号的库
$ nm -AD * | grep 
TestFwmMsg:080b9288 V _ZTVN7testing11EnvironmentE
TestFwmRsl:080beb48 V _ZTVN7testing11EnvironmentE
TestFwmThd:080bd328 V _ZTVN7testing11EnvironmentE
TestStartFwm:080b8cc8 V _ZTVN7testing11EnvironmentE
}

nm(列出苦衷未定义的符号(这些符号在运行时由其它库提供)){
nm -Du TestFwmRsl  | head -n 20
 w _ITM_deregisterTMCloneTable
 w _ITM_registerTMCloneTable
 w _Jv_RegisterClasses
 U _Unwind_Resume
 U _ZN9Framework4Core10CFramework10GetLibraryEv
 U _ZN9Framework4Core10CFramework10GetUserPwdERKNS_6Helper4Guid4GuidESsSsRSsSs
 U _ZN9Framework4Core10CFramework10IsResourceERKNS_6Helper4Guid4GuidE
 U _ZN9Framework4Core10CFramework10RemoveHostERNS_6Helper4Guid4GuidE
 U _ZN9Framework4Core10CFramework10ResetUsersERKNS_6Helper4Guid4GuidES6_Rj
 U _ZN9Framework4Core10CFramework11AddResourceEN5boost10shared_ptrINS0_9CResourceEEERNS_6Helper4Guid4GuidEbb
 U _ZN9Framework4Core10CFramework11CloneModuleERKNS_6Helper4Guid4GuidEb
 U _ZN9Framework4Core10CFramework11GetLogLevelERNS_6Helper4Guid4GuidERKS4_RKSsS9_RjSA_
 U _ZN9Framework4Core10CFramework11GetLoggerIdESs
}

objdump(反汇编功能强大，除ELF外还支持超过50种格式){
1) 解析EFL头

$ objdump -f TestFwmRsl 

TestFwmRsl:     file format elf32-i386
architecture: i386, flags 0x00000112:
EXEC_P, HAS_SYMS, D_PAGED
start address 0x0806ff98
查看静态库时，objdump -f 会打印库中每个找到的目标文件的ELF头信息
2) 查看节信息

$ objdump -h TestFwmRsl 

TestFwmRsl:     file format elf32-i386

Sections:
Idx Name          Size      VMA       LMA       File off  Algn
  0 .interp       00000013  08048134  08048134  00000134  2**0
                  CONTENTS, ALLOC, LOAD, READONLY, DATA
  1 .note.ABI-tag 00000020  08048148  08048148  00000148  2**2
                  CONTENTS, ALLOC, LOAD, READONLY, DATA
  2 .hash         00002d48  08048168  08048168  00000168  2**2
  ...
3) 查看符号

$ objdump -t Asio_context.o | head -n 20

Asio_context.o:     file format elf32-i386

SYMBOL TABLE:
00000000 l    df *ABS*    00000000 Asio_context.cpp
00000000 l    d  .text    00000000 .text
00000000 l    d  .data    00000000 .data
00000000 l    d  .bss    00000000 .bss
00000000 l    d  .text.unlikely    00000000 .text.unlikely
00000000 l     F .text.unlikely    0000001e _ZStlsISt11char_traitsIcEERSt13basic_ostreamIcT_ES5_PKc.part.7
00000000 l    d  .text._ZNSt15basic_stringbufIcSt11char_traitsIcESaIcEED2Ev    00000000 .text._ZNSt15basic_stringbufIcSt11char_traitsIcESaIcEED2Ev
...
4) 查看动态库导出符号

$ objdump -T TestFwmRsl 

TestFwmRsl:     file format elf32-i386

DYNAMIC SYMBOL TABLE:
00000000      DF *UND*    00000000  GLIBCXX_3.4.11 _ZNSsC1ESt16initializer_listIcERKSaIcE
0807be30 g    DF .text    0000008d  Base        _ZN10TestSystem4TimeC1Ev
0807c590 g    DF .text    00000005  Base        _ZN10TestSystem11LnxThdpImpl6GetPidEv
0807cba0 g    DF .text    0000002a  Base        _ZN10TestSystem11LinuxThread11SetPriorityEi
08073e70 g    DF .text    000006e1  Base        _ZN10TestMethod12CpuUseMethod3EndERl
00000000      DF *UND*    00000000  GLIBC_2.0   waitpid
...
5) 查看动态节

$ objdump -p TestFwmRsl

TestFwmRsl:     file format elf32-i386

Program Header:
    PHDR off    0x00000034 vaddr 0x08048034 paddr 0x08048034 align 2**2
         filesz 0x00000100 memsz 0x00000100 flags r-x
  INTERP off    0x00000134 vaddr 0x08048134 paddr 0x08048134 align 2**0
         filesz 0x00000013 memsz 0x00000013 flags r--
    LOAD off    0x00000000 vaddr 0x08048000 paddr 0x08048000 align 2**12
         filesz 0x0008cebd memsz 0x0008cebd flags r-x
    LOAD off    0x0008d000 vaddr 0x080d5000 paddr 0x080d5000 align 2**12
         filesz 0x00000908 memsz 0x000012dc flags rw-
 DYNAMIC off    0x0008d058 vaddr 0x080d5058 paddr 0x080d5058 align 2**2
         filesz 0x00000158 memsz 0x00000158 flags rw-
    NOTE off    0x00000148 vaddr 0x08048148 paddr 0x08048148 align 2**2
         filesz 0x00000020 memsz 0x00000020 flags r--
EH_FRAME off    0x0007bdb4 vaddr 0x080c3db4 paddr 0x080c3db4 align 2**2
         filesz 0x00001e54 memsz 0x00001e54 flags r--
   STACK off    0x00000000 vaddr 0x00000000 paddr 0x00000000 align 2**2
         filesz 0x00000000 memsz 0x00000000 flags rw-

Dynamic Section:
  NEEDED               libFramework.so
  NEEDED               libpthread.so.0
  NEEDED               libuuid.so
  NEEDED               libcrypto.so.1.0.0
  NEEDED               libdl.so.2
  NEEDED               librt.so.1
  NEEDED               libldap-2.4.so.2
  NEEDED               liblber-2.4.so.2
  NEEDED               libssl.so.1.0.0
  NEEDED               libSQLitePP.so
  NEEDED               libstdc++.so.6
  NEEDED               libm.so.6
  NEEDED               libgcc_s.so.1
  NEEDED               libc.so.6
  RPATH                ../../usr/lib:./fwlibs
  INIT                 0x0806caf0
  FINI                 0x080bd3e8
  INIT_ARRAY           0x080d5000
  INIT_ARRAYSZ         0x00000050
  FINI_ARRAY           0x080d5050
  FINI_ARRAYSZ         0x00000004
  HASH                 0x08048168
  STRTAB               0x08052340
  SYMTAB               0x0804aeb0
  STRSZ                0x0001886c
  SYMENT               0x00000010
  DEBUG                0x00000000
  PLTGOT               0x080d51b4
  PLTRELSZ             0x00000e70
  PLTREL               0x00000011
  JMPREL               0x0806bc80
  REL                  0x0806bb90
  RELSZ                0x000000f0
  RELENT               0x00000008
  VERNEED              0x0806ba40
  VERNEEDNUM           0x00000005
  VERSYM               0x0806abac

Version References:
  required from libgcc_s.so.1:
    0x0b792650 0x00 17 GCC_3.0
    0x0d696910 0x00 11 GLIBC_2.0
  required from librt.so.1:
    0x09691974 0x00 09 GLIBC_2.3.4
  required from libc.so.6:
    0x09691974 0x00 15 GLIBC_2.3.4
    0x09691f73 0x00 12 GLIBC_2.1.3
    0x0d696911 0x00 07 GLIBC_2.1
    0x0d696910 0x00 05 GLIBC_2.0
  required from libpthread.so.0:
    0x0d696912 0x00 14 GLIBC_2.2
    0x09691973 0x00 13 GLIBC_2.3.3
    0x0d696911 0x00 06 GLIBC_2.1
    0x0d696910 0x00 03 GLIBC_2.0
  required from libstdc++.so.6:
    0x0bafd171 0x00 16 CXXABI_1.3.1
    0x056bafd3 0x00 10 CXXABI_1.3
    0x02297f89 0x00 08 GLIBCXX_3.4.9
    0x08922974 0x00 04 GLIBCXX_3.4
    0x0297f861 0x00 02 GLIBCXX_3.4.11
需要注意最后一部分内容
6) 查看重定位节

$ objdump -R TestFwmRsl  | head -n 15

TestFwmRsl:     file format elf32-i386

DYNAMIC RELOCATION RECORDS
OFFSET   TYPE              VALUE 
080d51b0 R_386_GLOB_DAT    __gmon_start__
080d5920 R_386_COPY        _ZTVSt9basic_iosIcSt11char_traitsIcEE
080d5940 R_386_COPY        _ZNSs4_Rep20_S_empty_rep_storageE
080d5950 R_386_COPY        __environ
080d5958 R_386_COPY        _ZTTSt19basic_istringstreamIcSt11char_traitsIcESaIcEE
080d5980 R_386_COPY        _ZTVSt18basic_stringstreamIcSt11char_traitsIcESaIcEE
...
7) 查看指定节中的数据

$ objdump -s -j .dynamic TestFwmRsl

TestFwmRsl:     file format elf32-i386

Contents of section .dynamic:
 80d5058 01000000 01000000 01000000 1e5c0000  .............\..
 80d5068 01000000 9c5e0000 01000000 a75e0000  .....^.......^..
 80d5078 01000000 ba5e0000 01000000 c55e0000  .....^.......^..
 80d5088 01000000 e95e0000 01000000 fa5e0000  .....^.......^..
 80d5098 01000000 0b5f0000 01000000 d3600000  ....._.......`..
 80d50a8 01000000 e2600000 01000000 0b700000  .....`.......p..
 80d50b8 01000000 15700000 01000000 45700000  .....p......Ep..
 80d50c8 0f000000 5f730000 0c000000 f0ca0608  ...._s..........
 80d50d8 0d000000 e8d30b08 19000000 00500d08  .............P..
 ...
8) 反汇编代码

指定汇编风格

osphere$ objdump -d -Mintel TestFwmRsl 

TestFwmRsl:     file format elf32-i386

Disassembly of section .init:

0806caf0 <_init>:
 806caf0:    53                       push   ebx
 806caf1:    83 ec 08                 sub    esp,0x8
 806caf4:    e8 00 00 00 00           call   806caf9 <_init+0x9>
 806caf9:    5b                       pop    ebx
 806cafa:    81 c3 bb 86 06 00        add    ebx,0x686bb
 806cb00:    8b 83 fc ff ff ff        mov    eax,DWORD PTR [ebx-0x4]
 806cb06:    85 c0                    test   eax,eax
 806cb08:    74 05                    je     806cb0f <_init+0x1f>
与源码对照

osphere$ objdump -d -S -Mintel TestFwmRs
...

8AddEventWatchPointESsPFvRN8TestAsio11TaskContextEPvES4_+0x790>
 8078208:    bb 00 e8 06 08           mov    ebx,0x806e800
 807820d:    85 db                    test   ebx,ebx
 807820f:    8d 48 fc                 lea    ecx,[eax-0x4]
 8078212:    74 48                    je     807825c <_ZN10TestEngine8Listener18AddEventWatchPointESsPFvRN8TestAsio11TaskContextEPvES4_+0x81c>
 8078214:    83 cb ff                 or     ebx,0xffffffff
 8078217:    f0 0f c1 19              lock xadd DWORD PTR [ecx],ebx
 807821b:    85 db                    test   ebx,ebx
 807821d:    0f 8f bb fc ff ff        jg     8077ede <_ZN10TestEngine8Listener
反汇编指定节：

$ objdump -d -S -Mintel -j .plt TestFwmRsl

TestFwmRsl:     file format elf32-i386
                Disassembly of section .plt:

                0806cb20 <_ZNSsC1ESt16initializer_listIcERKSaIcE@plt-0x10>:
                 806cb20:    ff 35 b8 51 0d 08        push   DWORD PTR ds:0x80d51b8
                 806cb26:    ff 25 bc 51 0d 08        jmp    DWORD PTR ds:0x80d51bc
                 806cb2c:    00 00                    add    BYTE PTR [eax],al
                    ...

                0806cb30 <_ZNSsC1ESt16initializer_listIcERKSaIcE@plt>:
                 806cb30:    ff 25 c0 51 0d 08        jmp    DWORD PTR ds:0x80d51c0
                 806cb36:    68 00 00 00 00           push   0x0
                 806cb3b:    e9 e0 ff ff ff           jmp    806cb20 <_init+0x30>
}

readelf(只支持ELF文件 不依赖二进制文件描述库，因此可以独立提供ELF格式信息){
1) 解析EFL头

            $ readelf -h TestFwmRsl
            ELF Header:
              Magic:   7f 45 4c 46 01 01 01 00 00 00 00 00 00 00 00 00 
              Class:                             ELF32
              Data:                              2s complement, little endian
              Version:                           1 (current)
              OS/ABI:                            UNIX - System V
              ABI Version:                       0
              Type:                              EXEC (Executable file)
              Machine:                           Intel 80386
              Version:                           0x1
              Entry point address:               0x806ff98
              Start of program headers:          52 (bytes into file)
              Start of section headers:          580148 (bytes into file)
              Flags:                             0x0
              Size of this header:               52 (bytes)
              Size of program headers:           32 (bytes)
              Number of program headers:         8
              Size of section headers:           40 (bytes)
              Number of section headers:         28
              Section header string table index: 27

        - 查看静态库时，可以打印每个目标文件的ELF头信息

    + 2) 查看节信息

            $ readelf -S TestFwmRsl
            There are 28 section headers, starting at offset 0x8da34:

            Section Headers:
              [Nr] Name              Type            Addr     Off    Size   ES Flg Lk Inf Al
              [ 0]                   NULL            00000000 000000 000000 00      0   0  0
              [ 1] .interp           PROGBITS        08048134 000134 000013 00   A  0   0  1
              [ 2] .note.ABI-tag     NOTE            08048148 000148 000020 00   A  0   0  4
              [ 3] .hash             HASH            08048168 000168 002d48 04   A  4   0  4
              [ 4] .dynsym           DYNSYM          0804aeb0 002eb0 007490 10   A  5   1  4
              [ 5] .dynstr           STRTAB          08052340 00a340 01886c 00   A  0   0  1
              [ 6] .gnu.version      VERSYM          0806abac 022bac 000e92 02   A  4   0  2
              [ 7] .gnu.version_r    VERNEED         0806ba40 023a40 000150 00   A  5   5  4
              [ 8] .rel.dyn          REL             0806bb90 023b90 0000f0 08   A  4   0  4
              [ 9] .rel.plt          REL             0806bc80 023c80 000e70 08   A  4  11  4
              [10] .init             PROGBITS        0806caf0 024af0 000024 00  AX  0   0  4
              [11] .plt              PROGBITS        0806cb20 024b20 001cf0 04  AX  0   0 16
              [12] .text             PROGBITS        0806e810 026810 04ebd8 00  AX  0   0 16
              [13] .fini             PROGBITS        080bd3e8 0753e8 000015 00  AX  0   0  4
              [14] .rodata           PROGBITS        080bd400 075400 0069b4 00   A  0   0 32
              [15] .eh_frame_hdr     PROGBITS        080c3db4 07bdb4 001e54 00   A  0   0  4
              [16] .eh_frame         PROGBITS        080c5c08 07dc08 00ab2c 00   A  0   0  4
              [17] .gcc_except_table PROGBITS        080d0734 088734 004789 00   A  0   0  4
              [18] .init_array       INIT_ARRAY      080d5000 08d000 000050 00  WA  0   0  4
              [19] .fini_array       FINI_ARRAY      080d5050 08d050 000004 00  WA  0   0  4
              [20] .jcr              PROGBITS        080d5054 08d054 000004 00  WA  0   0  4
              [21] .dynamic          DYNAMIC         080d5058 08d058 000158 08  WA  5   0  4
              [22] .got              PROGBITS        080d51b0 08d1b0 000004 04  WA  0   0  4
              [23] .got.plt          PROGBITS        080d51b4 08d1b4 000744 04  WA  0   0  4
              [24] .data             PROGBITS        080d58f8 08d8f8 000010 00  WA  0   0  4
              [25] .bss              NOBITS          080d5920 08d908 0009bc 00  WA  0   0 32
              [26] .comment          PROGBITS        00000000 08d908 00003b 01  MS  0   0  1
              [27] .shstrtab         STRTAB          00000000 08d943 0000f1 00      0   0  1
            Key to Flags:
              W (write), A (alloc), X (execute), M (merge), S (strings)
              I (info), L (link order), G (group), T (TLS), E (exclude), x (unknown)
              O (extra OS processing required) o (OS specific), p (processor specific)

    + 3) 查看符号

            $ readelf -s TestFwmRsl 

            Symbol table '.dynsym' contains 1865 entries:
               Num:    Value  Size Type    Bind   Vis      Ndx Name
                 0: 00000000     0 NOTYPE  LOCAL  DEFAULT  UND 
                 1: 00000000     0 FUNC    GLOBAL DEFAULT  UND _ZNSsC1ESt16initializer_l@GLIBCXX_3.4.11 (2)
                 2: 0807be30   141 FUNC    GLOBAL DEFAULT   12 _ZN10TestSystem4TimeC1Ev
                 3: 0807c590     5 FUNC    GLOBAL DEFAULT   12 _ZN10TestSystem11LnxThdpI
                 4: 0807cba0    42 FUNC    GLOBAL DEFAULT   12 _ZN10TestSystem11LinuxThr
                 5: 08073e70  1761 FUNC    GLOBAL DEFAULT   12 _ZN10TestMethod12CpuUseMe
                 6: 00000000     0 FUNC    GLOBAL DEFAULT  UND waitpid@GLIBC_2.0 (3)
                ...

    + 4) 查看动态符号

            $ readelf --dyn-syms TestFwmRsl 

            Symbol table '.dynsym' contains 1865 entries:
               Num:    Value  Size Type    Bind   Vis      Ndx Name
                 0: 00000000     0 NOTYPE  LOCAL  DEFAULT  UND 
                 1: 00000000     0 FUNC    GLOBAL DEFAULT  UND _ZNSsC1ESt16initializer_l@GLIBCXX_3.4.11 (2)
                 2: 0807be30   141 FUNC    GLOBAL DEFAULT   12 _ZN10TestSystem4TimeC1Ev
                 3: 0807c590     5 FUNC    GLOBAL DEFAULT   12 _ZN10TestSystem11LnxThdpI
                 4: 0807cba0    42 FUNC    GLOBAL DEFAULT   12 _ZN10TestSystem11LinuxThr
                 5: 08073e70  1761 FUNC    GLOBAL DEFAULT   12 _ZN10TestMethod12CpuUseMe
                 6: 00000000     0 FUNC    GLOBAL DEFAULT  UND waitpid@GLIBC_2.0 (3)
                ...

    +  5) 查看动态节

            $ readelf -d TestFwmRsl 

            Dynamic section at offset 0x8d058 contains 38 entries:
              Tag        Type                         Name/Value
             0x00000001 (NEEDED)                     Shared library: [libFramework.so]
             0x00000001 (NEEDED)                     Shared library: [libpthread.so.0]
             0x00000001 (NEEDED)                     Shared library: [libuuid.so]
             0x00000001 (NEEDED)                     Shared library: [libcrypto.so.1.0.0]
             0x00000001 (NEEDED)                     Shared library: [libdl.so.2]
             0x00000001 (NEEDED)                     Shared library: [librt.so.1]
             0x00000001 (NEEDED)                     Shared library: [libldap-2.4.so.2]
             0x00000001 (NEEDED)                     Shared library: [liblber-2.4.so.2]
             0x00000001 (NEEDED)                     Shared library: [libssl.so.1.0.0]
             0x00000001 (NEEDED)                     Shared library: [libSQLitePP.so]
             0x00000001 (NEEDED)                     Shared library: [libstdc++.so.6]
             0x00000001 (NEEDED)                     Shared library: [libm.so.6]
             0x00000001 (NEEDED)                     Shared library: [libgcc_s.so.1]
             0x00000001 (NEEDED)                     Shared library: [libc.so.6]
             0x0000000f (RPATH)                      Library rpath: [../../usr/lib:./fwlibs]
             0x0000000c (INIT)                       0x806caf0
             0x0000000d (FINI)                       0x80bd3e8
             0x00000019 (INIT_ARRAY)                 0x80d5000
             0x0000001b (INIT_ARRAYSZ)               80 (bytes)
             0x0000001a (FINI_ARRAY)                 0x80d5050
             ...

    + 6) 查看重定位节

            $ readelf -r TestFwmRsl | head -n 20

            Relocation section '.rel.dyn' at offset 0x23b90 contains 30 entries:
             Offset     Info    Type            Sym.Value  Sym. Name
            080d51b0  0006f106 R_386_GLOB_DAT    00000000   __gmon_start__
            080d5920  00006805 R_386_COPY        080d5920   _ZTVSt9basic_iosIcSt11
            080d5940  0000a505 R_386_COPY        080d5940   _ZNSs4_Rep20_S_empty_r
            080d5950  00069a05 R_386_COPY        080d5950   __environ
            080d5958  0000ae05 R_386_COPY        080d5958   _ZTTSt19basic_istrings
            080d5980  0000cb05 R_386_COPY        080d5980   _ZTVSt18basic_stringst
            080d59c0  0000e205 R_386_COPY        080d59c0   _ZN9Framework6Helper4G
            080d59d8  00014605 R_386_COPY        080d59d8   _ZTTSt19basic_ostrings
            080d5a00  00016805 R_386_COPY        080d5a00   _ZN9Framework4Core7CLo
            080d5a08  00019d05 R_386_COPY        080d5a08   _ZN9Framework4Core7CLo
            080d5a10  00022405 R_386_COPY        080d5a10   _ZNSbIwSt11char_traits
            080d5a20  00022b05 R_386_COPY        080d5a20   _ZTVSt15basic_streambu
            080d5a60  00023205 R_386_COPY        080d5a60   stdout
            080d5a80  00026f05 R_386_COPY        080d5a80   _ZTVN10__cxxabiv117__c

    + 7) 查看节中的数据

            $ readelf -x .dynamic TestFwmRsl

            Hex dump of section '.dynamic':
              0x080d5058 01000000 01000000 01000000 1e5c0000 .............\..
              0x080d5068 01000000 9c5e0000 01000000 a75e0000 .....^.......^..
              0x080d5078 01000000 ba5e0000 01000000 c55e0000 .....^.......^..
              0x080d5088 01000000 e95e0000 01000000 fa5e0000 .....^.......^..
              0x080d5098 01000000 0b5f0000 01000000 d3600000 ....._.......`..
              0x080d50a8 01000000 e2600000 01000000 0b700000 .....`.......p..
              0x080d50b8 01000000 15700000 01000000 45700000 .....p......Ep..
              0x080d50c8 0f000000 5f730000 0c000000 f0ca0608 ...._s..........
              0x080d50d8 0d000000 e8d30b08 19000000 00500d08 .............P..
              0x080d50e8 1b000000 50000000 1a000000 50500d08 ....P.......PP..
              0x080d50f8 1c000000 04000000 04000000 68810408 ............h...
              0x080d5108 05000000 40230508 06000000 b0ae0408 ....@#..........
              0x080d5118 0a000000 6c880100 0b000000 10000000 ....l...........
              0x080d5128 15000000 00000000 03000000 b4510d08 .............Q..
              0x080d5138 02000000 700e0000 14000000 11000000 ....p...........
              0x080d5148 17000000 80bc0608 11000000 90bb0608 ................
              0x080d5158 12000000 f0000000 13000000 08000000 ................
              0x080d5168 feffff6f 40ba0608 ffffff6f 05000000 ...o@......o....
              0x080d5178 f0ffff6f acab0608 00000000 00000000 ...o............
              0x080d5188 00000000 00000000 00000000 00000000 ................
              0x080d5198 00000000 00000000 00000000 00000000 ................
              0x080d51a8 00000000 00000000                   ........

    + 8) 检查是否包含调试信息            

            $ readelf --debug-dump TestFwmRsl

        - 没有调试信息为空行
}

}

book(部署阶段工具){
chrpath

修改ELF二进制文件的rpath(即DT_RPATH字段)

$ readelf -d TestFwmRsl | grep RPATH
 0x0000000f (RPATH)                      Library rpath: [../../usr/lib:./fwlibs]
只能在源字符串长度范围内修改，如果原来是空的，则不能修改
可以删除原有的DT_RPATH字段
可以将DT_RPATH转换成DT_RUNPATH
patchelf

不属于标准仓库
可以设置和修改二进制文件的DT_RUNPATH字段
可以随意设置字符串
strip

清除动态加载过程中不需要的符号
ldconfig

可以通过ldconfig缓存指定装载器运行时的库搜索路径
通常将ldconfig作为软件包安装的最后一步执行，指定共享库搜索路径
/etc/ld.so.conf：搜索的目录列表
/etc/ld.so.cache：搜到的文件名以ASCII文本的形式记录
}

book(运行时分析工具){
strace

跟踪进程产生的系统调用
可以分析加载时的依赖项
addr2line - # 给出一个可执行文件的内部地址，addr2line 使用文件中的调试信息将地址翻译成源代码文件名和行号。
当使用调试模式构建二进制文件时(-g -O0)，程序崩溃处的PC计数器会打印，可以通过这个命令将其转换为源代码的行号
[27153070.538380] traps: cmdTest[2836] trap divide error ip:40053b sp:7ffc230d9280 error:0 in cmdTest[400000+1000]
addr2line -e cmdTest 40053b
/home/hyb/practice/cmdTest.c:4

# 00 pc 0000d8cc6 /usr/mylibs/libxyz.so
$ addr2line -C -f -e /usr/mylibs/libxyz.so 0000d8cc6
 /projects/mylib/src/mylib.c: 45
gdb

有用的选项：

set disassembly-flaver
disassemble <函数名>
/r：显示额外汇编指令的十六进制代码
/m：汇编指令中插入对于的C/C++代码

(gdb) disassemble /rm main
Dump of assembler code for function main:
   0x0806fb00 <+0>:    55    push   %ebp
   0x0806fb01 <+1>:    89 e5    mov    %esp,%ebp
   0x0806fb03 <+3>:    56    push   %esi
   0x0806fb04 <+4>:    53    push   %ebx
   0x0806fb05 <+5>:    83 e4 f0    and    $0xfffffff0,%esp
   0x0806fb08 <+8>:    83 ec 10    sub    $0x10,%esp
   0x0806fb0b <+11>:    8b 45 0c    mov    0xc(%ebp),%eax
   0x0806fb0e <+14>:    c6 05 5c 62 0d 08 01    movb   $0x1,0x80d625c
   0x0806fb15 <+21>:    89 44 24 04    mov    %eax,0x4(%esp)
   0x0806fb19 <+25>:    8d 45 08    lea    0x8(%ebp),%eax
   0x0806fb1c <+28>:    89 04 24    mov    %eax,(%esp)
   0x0806fb1f <+31>:    e8 cc c0 03 00    call   0x80abbf0 <_ZN7testing14InitGoogleTestEPiPPc>
   0x0806fb24 <+36>:    c7 04 24 04 01 00 00    movl   $0x104,(%esp)
   0x0806fb2b <+43>:    e8 80 d0 ff ff    call   0x806cbb0 <_Znwj@plt>
   0x0806fb30 <+48>:    c7 00 70 eb 0b 08    movl   $0x80beb70,(%eax)
   0x0806fb36 <+54>:    89 c3    mov    %eax,%ebx
   0x0806fb38 <+56>:    e8 03 66 03 00    call   0x80a6140 <_ZN7testing8UnitTest11GetInstanceEv>
   0x0806fb3d <+61>:    89 5c 24 04    mov    %ebx,0x4(%esp)
   0x0806fb41 <+65>:    89 04 24    mov    %eax,(%esp)
   0x0806fb44 <+68>:    e8 d7 5b 03 00    call   0x80a5720 <_ZN7testing8UnitTest14AddEnvironmentEPNS_11EnvironmentE>
   0x0806fb49 <+73>:    e8 62 0b 02 00    call   0x80906b0 <_ZN10TestEngine2TSIN13TestFramework5Tests9TestRsLTSEE5GetTSEv>
   0x0806fb4e <+78>:    e8 ed 65 03 00    call   0x80a6140 <_ZN7testing8UnitTest11GetInstanceEv>
   0x0806fb53 <+83>:    8b 40 24    mov    0x24(%eax),%eax
   0x0806fb56 <+86>:    8b 70 4c    mov    0x4c(%eax),%esi
   0x0806fb59 <+89>:    8b 58 48    mov    0x48(%eax),%ebx
---Type <return> to continue, or q <return> to quit---
}

book(静态库工具){
静态库工具
ar
创建静态库：
ar -rcs <库文件名> <目标文件列表>
列出静态库的目标文件
ar -t <库文件名>
从静态库删除目标文件
ar -d <库文件名> <要删除的目标文件>
添加新的目标文件到静态库
ar -r <库文件名> <要添加的目标文件>
移动库文件顺序
ar -m -b <文件移动到该目标文件前面> <库文件名> <要移动的文件>
}

LD_DEBUG(){
这个变量可以打开动态链接器的调试功能，当我们设置这个变量时，动态链接器会在运行时打印出各种有用的调试信息，
对于开发和调试共享库有很大帮助
LD_DEBUG=files ./killme

动态链接器打印出了整个装载过程，显示程序依赖于哪个共享库并且按照什么步骤装载和初始化、共享库装载时的地址等
LD_DEBUG还可以设置成其他值
复制代码

1. bindings: 显示动态链接的符号绑定过程
2. libs: 显示共享库的查找过程
3. versions: 显示符号的版本依赖关系
4. reloc: 显示重定位过程
5. symbols: 显示符号表查找过程
6. statistics: 显示动态链接过程中的各种统计信息
7. all: 显示以上所有信息
8. help: 显示上面的各种可选值的帮助信息

}

book(平台实践){
设置LD_DEBUG变量
列出预设值
$ LD_DEBUG=help cat
Valid options for the LD_DEBUG environment variable are:

  libs        display library search paths
  reloc       display relocation processing
  files       display progress for input file
  symbols     display symbol table processing
  bindings    display information about symbol binding
  versions    display version dependencies
  scopes      display scope information
  all         all previous options combined
  statistics  display relocation statistics
  unused      determined unused DSOs
  help        display this help message and exit
设置方法

与调用链接器的命令写在同一行
设置环境变量，在正在shell生命周期中使用

export LD_DEBUG=<option>
撤销设置

unset LD_DEBUG
}

book(确定二进制文件类型){
file：简单、快速、优雅

$ file TestFwmRsl 
TestFwmRsl: ELF 32-bit LSB executable, Intel 80386, version 1 (SYSV), dynamically linked (uses shared libs), for GNU/Linux 2.6.24, stripped
readelf：详细信息

$ readelf -h TestFwmRsl | grep Type
  Type:                         EXEC (Executable file)
EXEC:可执行文件
DYN：共享目标文件
REL：可重定位文件
objdump：内容简单一些

$ objdump -f TestFwmRsl 

TestFwmRsl:     file format elf32-i386
architecture: i386, flags 0x00000112:
EXEC_P, HAS_SYMS, D_PAGED
start address 0x0806ff98
EXEC_P：可执行文件
DYNAMIC：共享目标文件
无输出
}

book(确定二进制入口点){
获取可执行文件入口点

即程序内存映射中第一条指令的位置
readelf：详细信息

$ readelf -h TestFwmRsl | grep Entry
  Entry point address:               0x806ff98
objdump：简单一些

$ objdump -f TestFwmRsl | grep start
start address 0x0806ff98
获取动态库入库点

动态库会映射到客户二进制文件的内存中，因此只有运行时才能获取到真正的入口点
方法：

1) 设置LD_DEBUG环境变量运行gdb，以打印出加载库信息

LD_DEBUG=files gdb -q ./TestFwmRsl
2) 在main函数设置断点，然后运行

b main        
r
3) 运行程序到断点，对entry处的地址进行反汇编：

set disassembly-flavor intel
disassemble 0xb7fd8390
}

book(列出符号信息){
列出所有符号
nm
readelf
objdump
列出对外可见符号

readelf -s 
objdump -t
列出导出符号列表，用于动态链接

readelf --dyn-syms
objdump -T
}


book(查看节信息){
查看所有节

readelf -S
objdump -t
查看动态节信息

readelf -d
objdump -p
可以看到有价值的信息：

DP_RPATH和DT_RUNPATH
SONAME字段值
所需动态库列表(DT_NEEDED)
检测是否使用-fPIC构建动态库

# 判读是否使用-fPIC的脚本
$ if readelf -d <.so> | grep TEXTREL > /dev/null;then echo "TEXTREL found, no -fPIC";else echo "use -fPIC";fi

# 示例，libFramework.so使用了-fPIC
$ if readelf -d ./fwlibs/libFramework.so | grep TEXTREL > /dev/null;then echo "TEXTREL found, no -fPIC";else echo "use -fPIC";fi
use -fPIC
构建动态库时没有使用-fPIC会在动态节生成TEXTREL字段
查看重定位信息

readelf -r
objdump -R
查看数据节

readelf -x <section> 
objdump -s -j <section>
}

book(查看段信息){
readelf --segments
objdump -p
}

book(反汇编代码){
反汇编二进制文件

反汇编文件

objdump -d
指定汇编风格

objdump -d -M intel
查看源代码

objdump -d -M intel -S
反汇编特定节

objdump -d -S -M intel -j .plt
反汇编正在运行的程序

需要使用gdb配合LD_DEBUG，运行时指定地址
}

book(判断是否为调试模式){

输出非空时为调试模式
readelf --debug-dump=line 
}

book(查看加载时依赖项){
递归查看所有依赖项，不安全的方式，可能需要执行程序

ldd
查看直接依赖项，安全

objdump -p <> | grep NEEDED
readelf -d <> | grep NEEDED
}

book(查看装载器可以找到的库文件){
对装载器已知有效的库文件运行时路径

$ ldconfig -p 
944 libs found in cache /etc/ld.so.cache
    libzip.so.2 (libc6) => /usr/lib/libzip.so.2
    libzephyr.so.4 (libc6) => /usr/lib/libzephyr.so.4
    libzeitgeist-1.0.so.1 (libc6) => /usr/lib/libzeitgeist-1.0.so.1
    libz.so.1 (libc6) => /lib/i386-linux-gnu/libz.so.1
    libz.so (libc6) => /usr/lib/i386-linux-gnu/libz.so
    libyelp.so.0 (libc6) => /usr/lib/libyelp.so.0
    libyajl.so.1 (libc6) => /usr/lib/i386-linux-gnu/libyajl.so.1
    libx86.so.1 (libc6) => /lib/libx86.so.1
    libxtables.so.7 (libc6) => /lib/libxtables.so.7
...
}

book(查看动态加载的库文件){
readelf、objdump都只能进行静态分析，无法分析动态库进行动态加载的运行时行为
通过strace列出系统调用顺序
使用LD_DEBUG=files选项
查看/proc/<pid>/maps文件
可以用gdb调试，防止程序过快结束
lsof将进程打开的文件列表输出到标准输出，可以看到各种类型的文件打开的情况
}

book(平台实战){
LD_DEBUG=help cat
export LD_DEBUG=<chosen_option>
unset LD_DEBUG
}

https://imzlp.me/posts/27118/
C和C++均使用分离编译来支持多源文件模块化机制，
    C和C++中源代码不是直接一步被编译为操作系统可执行的可执行目标文件(executable object file)的，
而是通过几个步骤来实现的分离编译——多个源文件被分别编译成几个单独的模块(一个程序具有多个翻译单元)，
最后在统一把这几个模块拼接(链接linkage)起来，才组成了可执行的二进制。
为什么声明和定义要分离？
主要是为了防止多个源文件同时包含同一个源文件时的造成的多重定义(multiple define).
# Computer Systems: A Programmer's Perspective (3rd Edition)
《深入理解计算机系统》 -> 《程序员所需要了解的计算机知识》
one(GCC工具链编译和链接参数){
# 预处理：#include和宏定义以及条件编译
$ cpp main.cc main.i
$ g++ -E main.cc -o main.i
# 编译成汇编代码
$ g++ -S main.i -o main.s
# 从汇编代码生成目标文件
$ g++ -c main.s -o main.o
# 直接从源文件生成目标文件
$ g++ -c main.cc
# 查看.o中的符号
$ nm main.o
# 将name mangling后的符号转换为原始符号
c++filt # 程序接受被 C++编译程序转换过的名字（不是被重载的） ，而且将该名字翻译成初始形式。
$ c++filt _Z3maxii
# 从源文件生成静态链接库
# 首先要生成目标文件
$ g++ -c slib.cc -o slib.o
# 然后使用ar来创建一个lib.a
$ ar rcs libslib.a slib.o
# 本地生成的libslib.a就是我们源文件编译出来的静态链接库
# 使用方法
# -L是指定链接库所在的目录(.是当前目录)，-l是gcc的链接方式会自动匹配到libxxx.a这样的链接库
# 比如-L. -lslib 就是链接当前目录下的libslib.a文件
$ g++ -o main.exe main.cc -L. -llib
# 从源文件编译动态链接库
# 生成目标文件时需要使用-fPIC/-fpic参数
# -fPIC参数声明链接库的代码段是可以共享的
$ gcc -c -fpic dylib.c -o dylib.o
# 使用-shared参数来生成动态链接库so
$ gcc -shared -fpic dylib.o -o dylib.so
# 查看二进制依赖的符号
$ ldd main.exe
# 也可以通过nm来查看静态链接库和动态链接库以及可执行程序中的符号信息
$ nm slib.a
$ nm sylib.so
$ nm main.exe
# ldd可以查看可执行程序具有的外部链接信息
$ ldd main.exe
ntdll.dll => /c/Windows/SYSTEM32/ntdll.dll (0x7ffb24f80000)
KERNEL32.DLL => /c/Windows/System32/KERNEL32.DLL (0x7ffb22d40000)
KERNELBASE.dll => /c/Windows/System32/KERNELBASE.dll (0x7ffb218a0000)
msvcrt.dll => /c/Windows/System32/msvcrt.dll (0x7ffb22e50000)

目标文件中常见的符号类型:
    A 该符号的值在今后的链接中将不再改变；
    B 该符号放在BSS段中，通常是那些未初始化的全局变量；
    D 该符号放在普通的数据段中，通常是那些已经初始化的全局变量；
    T 该符号放在代码段中，通常是那些全局非静态函数；
    U 该符号未定义过，需要自其他对象文件中链接进来；
    W 未明确指定的弱链接符号；同链接的其他对象文件中有它的定义就用上，否则就用一个系统特别指定的默认值。
    R符号位于只读数据区。比如C语言中的file scope的const int(C语言和C++不同)。
}

binutils(){
addr2line 给出一个可执行文件的内部地址，addr2line 使用文件中的调试信息将地址翻译成源代码文件名和行号。

ar      这是一个程序，可通过从文档中增加、删除和析取文件来维护库文件。通常使用该工具是为了创建和管理连接程序使用的目标库文档。

as      GNU 汇编器。实际上它是一族汇编器，因为它可以被编译或能够在各种不同平台上工作。

c++filt 程序接受被 C++编译程序转换过的名字（不是被重载的） ，而且将该名字翻译成初始形式。

elfedit 更新 ELF 文件的 ELF 头。

gprof   该程序会监督编译程序的执行过程，并报告程序中各个函数的运行时间，可以根据所提供的配置文件来优化程序。

ld  GNU 连接程序。该程序将目标文件的集合组合成可执行程序。

ld.bfd  到 ld 的硬链接。

libbfd  二进制文件描述器库。该程序是 binutils 包的一部分

libiberty   包含多个 GNU 程序会使用的途径，包括 getopt、obstack、strerror、strtol 和 strtoul。

libopcodes  一个库，用于处理 opcodes——处理器指令的 "可读文本" 版本；用于编制 objdump 这样的工具。

nlmconv 将可重定位的目标文件转换成 NetWare 可加载模块（NetWare Loadable Module，NLM） 。

nm 列出目标文件中定义的符号。

objcopy 将目标文件从一种二进制格式复制和翻译到另外一种。

objdump
	

显示一个或多个目标文件中保存的多种不同信息。

ranlib
	

创建和添加到 ar 文档的索引。该索引被 ld 使用来定位库中的模块。

readelf
	

从 ELF 格式的目标文件显示信息

size
	

列出目标文件中每个部分的名字和尺寸。

strings
	

浏览所有类型的文件，析取出用于显示的字符串。

strip
	

从目标文件或文档库中去掉符号表，以及其他调试所需的信息。

windres
	

Window 资源文件编译程序。


}