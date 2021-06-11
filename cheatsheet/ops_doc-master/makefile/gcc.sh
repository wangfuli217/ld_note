100个gdb小技巧   https://github.com/hellogcc/100-gdb-tips/blob/master/src/index.md
100个gcc小技巧   https://github.com/hellogcc/100-gcc-tips/blob/master/src/index.md
CGDB中文手册     https://github.com/leeyiw/cgdb-manual-in-chinese

32位版：加上 -m32 参数，生成32位的代码。
64位版：加上 -m64 参数，生成64位的代码。
debug版：加上 -g 参数，生成调试信息。
release版：加上 -static 参数，进行静态链接，使程序不再依赖动态库。加上 -O3 参数，进行最快速度优化。加上-DNDEBUG参数，定义NDEBUG宏，屏蔽断言。
make RELEASE=0：(默认位数的)debug版。
make RELEASE=1：(默认位数的)release版。
make BITS=32：32位(的debug)版。
make BITS=64：64位(的debug)版。
make RELEASE=0 BITS=32：32位的debug版。
make RELEASE=0 BITS=64：64位的debug版。
make RELEASE=1 BITS=32：32位的release版。
make RELEASE=1 BITS=64：64位的release版。

gcc --verbose
    显示gcc编译命令的最终展开式；
    显示include搜索目录并提示无效目录；
 -rdynamic
    允许连接的共享库从项目源码的目标文件中搜索符号作为自身所引用的全局变量。
    一般不建议使用该参数，特殊情况除外。

生成 -Wall 选项不包括的警告         -> -Wextra
在每个编译阶段查看中间代码的输出    -> -save-temps
让你的代码可调试和可分析            -> -g  -pg
获取系统头文件路径                  -> gcc -v file.c

-fsyntax-only 检查代码是否有语法错误，但是不要做其他事情。
-Werror       将所有警告变为错误。
-Werror=      将指定的警告变为错误
-Werror=      -Wno-error=switch  -Werror=switch
              -Wno-error=        -Werror=

gcc -E -dM - </dev/null          # 语言标准对应宏定义
gcc -std=c99 -E -dM - </dev/null # 语言标准对应宏定义
gcc -dumpspecs                   # The exact steps are determined by the spec file
gcc -v main.c                    # o observe exactly what is one on each step
gcc -save-temps a.c              # intermediate steps (.i, .s, .o) 
gcc --version
gcc -print-search-dirs | tr ':' '\n' 
gcc -print-file-name=libc.so
gcc -print-prog-name=ar

echo 'int i;' | gcc -fsyntax-only -xc -
echo 'int i' | gcc -fsyntax-only -xc -

# GCC as library
http://programmers.stackexchange.com/questions/189949/is-there-a-way-to-use-gcc-as-a-library
http://stackoverflow.com/questions/1735360/compiling-program-within-another-program-using-gcc
http://stackoverflow.com/questions/8144793/gcc-for-parsing-code
libgccjit from GCC 5 goes a long way.

Wp preprocessor; Wa assembler; Wl linker;  -Xlinker 选项

g: generate debug info for GDB
ggdb: adds more info
ggdb3: adds max info. Default if 2 when ggdb is used.

C_INCLUDE_PATH
Add to the search path after -I:
    CPATH: all languages
    C_INCLUDE_PATH: only C
    CPLUS_INCLUDE_PATH: only C++
    
static-libgcc
    Link statically to libgcc. This is not libc, but an internal GCC library.

std(){
c89-> iso9899:199409-> (cx9)c99 或 iso9899:1999 -> (c1x) c11 或 iso9899:2011 -> C17 或 iso9899:2017
# iso   标准
# cx9   草案
# c99   正式标准
# gnu99 gnu扩展标准 gnu90 gnu99 gnu11

c89
<float.h>, <limits.h>, <stdarg.h>, and <stddef.h>
c99
<stdbool.h> <stdint.h> <complex.h>
c11
<stdalign.h>and<stdnoreturn.h>.

c++98 gnu++98 c++0x gnu++0x c++1y gnu++1y

# 如果不提供C语言方言选项，默认值是 -std=gnu11 。
gcc -std=c89|c99|c1x|c11 (gnu89|gnu99|gnu9x) (c++98|gnu++98|c++0x|gnu++0x) inform.c
-ansi 
-pedantic(或 -pedanticerror，如果您希望它们是错误而不是警告) # 获得标准所需的所有诊断
}

gcc main.c -o test -v # gcc 详细执行刘彻骨
help(){
man gcc | col -b | grep -w gcc 实例信息
--help                   显示此帮助说明
--help={common|optimizers|params|target|warnings|[^]{joined|separate|undocumented}}[,...]
common      通用属性(支持所有语言)     gcc -Q --help=common -Wall -Wextra  -Wshadow 
optimizers  优化选项     gcc -Q --help=optimizers -Wall -Wextra  -Wshadow -W
params      参数         没用
target      硬件平台     没用
warnings    告警信息     如下
c|c++       特定语言选参
undocumented 没有正式文档
gcc --help=c,warnings -Wall -Wextra -Q 
gcc --help=warnings -Wall
gcc --help=warnings -Wextra
gcc --help-warnings -Wall -Wextra

gcc -Q --help-warnings               > warnings.txt
gcc -Q --help=warnings -Wall         > Wall.txt [ grep -c enabled ] [grep disabled]  [grep enabled]
gcc -Q --help=warnings -Wextra       > Wextra.txt [ grep -c enabled ] [grep disabled]  [grep enabled]
gcc -Q --help-warnings -Wall -Wextra > Wextra_all.txt [ grep -c enabled ] [grep disabled]  [grep enabled]

diff Wall.txt Wextra.txt
}
cc_help(){
cc --help -v
}
cpp_help(){
cpp --help -v
}


gcc | machine-gcc | machine-gcc-version

_GUN_SOURCE(){
/usr/include/features.h
#ifdef _GNU_SOURCE
# undef  _ISOC95_SOURCE
# define _ISOC95_SOURCE?1
# undef  _ISOC99_SOURCE
# define _ISOC99_SOURCE?1
# undef  _ISOC11_SOURCE
# define _ISOC11_SOURCE?1
# undef  _POSIX_SOURCE
# define _POSIX_SOURCE? 1
# undef  _POSIX_C_SOURCE
# define _POSIX_C_SOURCE?   200809L
# undef  _XOPEN_SOURCE
# define _XOPEN_SOURCE? 700
# undef  _XOPEN_SOURCE_EXTENDED
# define _XOPEN_SOURCE_EXTENDED?1
# undef? _LARGEFILE64_SOURCE
# define _LARGEFILE64_SOURCE?   1
# undef  _BSD_SOURCE
# define _BSD_SOURCE?   1
# undef  _SVID_SOURCE
# define _SVID_SOURCE?  1
# undef  _ATFILE_SOURCE
# define _ATFILE_SOURCE?1
#endif
}
option(){
当你使用相同种类的几种选择时，顺序是很重要的;
例如，如果您多次指定-L，目录将按照指定的顺序进行搜索。此外，-l选项的位置也很重要。
多次使用选项  -l -L -I

许多选项都有以 -f 或 -W 开头的长名称，例如，-fmove-loop-invariants、-Wformat等 等
长命令选项    -Wformat 

大多数都有正负两种形式; -ffoo 的否定形式是 -fno-foo
}

gcc_compile(编译程序-基本选项){
用例：gcc <.c> -o <.o>

gcc <.c>        无选项编译链接形成可执行文件,默认输出为a.out
    -E          仅执行编译预处理,生成<.i>文件
    -S          将C代码转换为汇编代码,生成<.s>文件
    -c          仅执行编译操作,不进行连接操作,生成<.o>文件
    -o          指定生成的输出文件
    -Wall       显示警告信息

    -I<path>    编译时指定<.h>库文件的目录
    -L<path>    链接时指定<.so><.a><.dll>库文件的目录
    -l<libname> 链接时指定库文件名,配合-L使用
                例 gcc main.c -Ipath -Lpath -lxxx -o main
                要进行编译的C文件要放在-Lpath -lxxx前面,否则将对path/libxxx.so进行编译成可执行文件
                好习惯:尽量将main所在文件靠前放
    -static     强制链接时使用静态链接库<libxxx.a>
                编译器会先在path下搜索libxxx.so文件,若无则搜索libxxx.a文件

生成共享库:	
    -fPIC       使用相对地址,配合-c编译生成地址无关代码<.o>文件,以便生成共享库
                例 gcc -fPIC -c file.c
    -shared     生成共享库,命名规范 -shared libxxx.so
                例 gcc -shared -o libxxx.so file1.o file2.o 或 gcc -shared -fPIC -o libxxx.so file1.c file.c

生成静态链接库:
使用命令 ar cr libxxx.a file1.o file2.o 其中先通过gcc -c生成<.o>文件

[-g]：包含调试信息
[-w]：关闭所有警告
[-Wall]：发出 gcc 提供的所有有用的警告
[-pedantic]：发出 ANSI C 的所有警告
}

gcc_linker_mode(编译程序-链接方式){
表 1. 三种标准库链接方式的选项及区别
标准库连接方式     示例连接选项                  优点                                              缺点
全静态             -static -pthread -lrt -ldl    不会发生应用程序在不同                           生成的文件比较大，
                                                 Linux 版本下的标准库不兼容问题。                 应用程序功能受限(不能调用动态库等)
                                                                                                  
全动态             -pthread -lrt -ldl            生成文件是三者中最小的                           比较容易发生应用程序在不同 Linux 版本下标准库
                                                                                                  依赖不兼容问题。
                                                                                                  
半静态 -static-libgcc -L. -pthread -lrt -ldl    灵活度大，能够针对不同的标准库采取不同的链接策略，比较难识别哪些库容易发生不兼容问题，
(libgcc,libstdc++)                              从而避免不兼容问题发生。                          目前只有依靠经验积累。
                                                结合了全静态与全动态两种链接方式的优点。          某些功能会因选择的标准库版本而丧失。
-std=c99

-llibrary
-l library：指定所需要的额外库
-Ldir：指定库搜索路径
-static：静态链接所有库
-static-libgcc：静态链接 gcc 库
-static-libstdc++：静态链接 c++ 库
关于上述命令的详细说明，请参阅 GCC 技术手册
}

--help
--target-help
       
gcc_env(编译程序-环境变量){
C头文件调用路径：
export C_INCLUDE_PATH=/usr/local/include:$C_INCLUDE_PATH
#也可在gcc参数中指定调用路径
-I/usr/local/include

C++头文件调用路径：
export CPLUS_INCLUDE_PATH=/usr/local/include:$CPLUS_INCLUDE_PATH

动态库调用路径：
export LIBRARY_PATH=/usr/local/lib:$LIBRARY_PATH
#也可在gcc参数中指定调用路径
-L/usr/local/lib 
#指定调用库的名字，如libcurl.so
-lcurl

pkg-config路径：
export PKG_CONFIG_PATH=/usr/local/pkgconfig/

程序运行时动态库调用路径：
export LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH
#也可添加到全局动态库
echo '/usr/local/lib' > /etc/ld.so.conf.d/local.conf
ldconfig

查看gcc默认查找头文件/动态库目录：
`gcc -print-prog-name=cc1` -v
gcc -print-search-dirs
}

gcc_header_directory(gcc查找头文件的默认路径){
gcc -v -E - # gcc查找头文件的默认路径
要设置其他的路径，用如下命令：
exportC_INCLUDE_PATH=/opt
}

1. -Os -ggdb -Wall -Werror --std=gnu99 -Wmissing-declarations # 编译
2. .PHONY
3. quiet
gcc_step_compile(编译程序-单步编译){
1. 编译器由预处理器(cpp工具，C Preprocessor)
2. 编译器(cc工具，C and C++ compiler)
3. 汇编器(as工具，assembler)
4. 连接器(ld工具)
在每个编译阶段查看中间代码的输出 -> -save-temps # 保存临时文件 main.i(-E) main.s(-S) main.o(-c) main(-o)
###gcc执行三个步骤:预处理->编译->汇编->链接
1. gcc -E test.c -o test.i                      #生成预处理命令的中间文件
2. gcc -S test.i -o test.s                      #生成汇编语言文件
3. gcc -c test.s -o test.o                      #生成二进制代码文件
4. gcc test.o -o test                           #生成可执行文件
上等同于
1. gcc -c test.c -o test.o                      #先生成二进制代码文件
2. test.o -o test                               #再生成可执行文件
或者
gcc test.c -o test                              #一条指令生成可执行文件

###gcc的常用选项
-c (只编译，不链接成可执行文件，编译器只是由输入的.c等为后缀的源代码文件生成.o为后缀的目标文件，通常用于编译不包含主程序的子程序文件)
-o output_filename(确定输出文件的名称为:output_filename,同时这个名称不能和源文件同名,如果不给出这个选项gcc就 默认将输出的可执行文件命名为a.out)
-g (产生调试器gdb所必须的符号信息,要对源代码进行调试,就必须在编译程序时加入这个选项)
-O (对程序进行优化编译，链接，采用这个选项，整个源代码会在编译，链接过程中进行优化处理，这样产生的可执行文件的执行效率较高，但是编译，链接的速度就相应的要慢一些)
-O2 (比-O更好的优化编译，链接，过程会更慢
-Wall (输出所有警告信息，在编译的过程中如果gcc遇到一些人为可能发生错误的地方就是提出一些相应的警告信息，提示注意这个地方是不是有什么错误。)
-w (关闭所有警告，最好不用此选项)
-Idirname (将名为dirname的目录加入到程序头文件目录列表中，它是在预处理阶段使用的选项。I意指Include)
-Ldirname (将名为dirname的目录加入到程序的库文件搜索目录列表中,它是在链接过程中使用的参数。L意指Link)
-lname (指示编辑器，在链接时，装载名为libname.a的函数库，该函数库位于系统预定义的目录或者由-L选项制定的目录下。例如 -lm表示链接名为libm.a的数学函数库)
}

gcc_preprocessor(编译程序-预编译过程){ vim 可以直接查看； gcc -E | cpp 
标志可以是1、2、3和4四个数字，每个数字的含义如下： 
数字  含义
1      表示一个新文件的开始
2      表示从一个被包含的文件中返回
3      表示后面的内容来自于系统头文件
4      表示后面的内容应当被当做一个隐式的"extern C"块

# 938 "/usr/include/stdio.h" 3 4
# 行号 文件名                标志
其中的"行号"与"文件名"表示从它后一行开始的内容来源于哪一个文件的哪一行；

注意：当file.c使用到非系统头文件且它们不在当前目录下时，需要通过使用gcc的-I参数加以指定，
      否则gcc会因为无法获得必要的头文件进行宏展开而报错。
}
gcc_compile(编译程序-编译过程){ vim 可以直接查看； gcc -S | cc 
gcc -S file.i -o file.s 
gcc -S -O2 file.c -o file.s
}

gcc_as(编译程序-汇编过程){
gcc -c file.s -o file.o
gcc –c –I /usr/dev/mysql/include test.c –o test.o
}

gcc_linker(编译程序-链接过程){
类型              说明
-Idirectory     向GCC的头文件搜索路径中添加新的目录
-Ldirectory     向GCC的库文件搜索路径中添加新的目录
-llibrary       提示连接程序在创建可执行文件时包含指定的库文件
-static         强制使用静态链接库
-shared         生成动态库文件

gcc -L /usr/dev/mysql/lib -lmysqlclient test.o -o test
gcc -L /usr/dev/mysql/lib -static -lmysqlclient test.o -o test
gcc -Wl,-Map=file.map file.c

# 静态库链接时搜索路径顺序：
1. ld会去找GCC命令中的参数-L
2. 再找gcc的环境变量LIBRARY_PATH
3. 再找内定目录 /lib /usr/lib /usr/local/lib 这是当初compile gcc时写在程序内的

# 动态链接时、执行时搜索路径顺序:
1. 编译目标代码时指定的动态库搜索路径
2. 环境变量LD_LIBRARY_PATH指定的动态库搜索路径
3. 配置文件/etc/ld.so.conf中指定的动态库搜索路径
4. 默认的动态库搜索路径/lib
5. 默认的动态库搜索路径/usr/lib

有关环境变量：
LIBRARY_PATH环境变量：指定程序静态链接库文件搜索路径
LD_LIBRARY_PATH环境变量：指定程序动态链接库文件搜索路径
}

gcc_optimizers(O优化){
    当我们使用gcc编译程序时，一般会选用某个优化编译选项，比如-O2、-O3、-Os，但这些选项使得
gcc到底帮我打开了哪些具体优化选项呢？利用gcc的-Q和–help可以给我们答案：
gcc -c -Q -O3 --help=optimizers > /tmp/O3-opts
gcc -c -Q -O2 --help=optimizers > /tmp/O2-opts
gcc -c -Q -Os --help=optimizers > /tmp/Os-opts
diff /tmp/Os-opts /tmp/O2-opts
# http://www.lenky.info/archives/2012/08/1873
    如果，我们发现在使用某个编译选项，比如-O3时，程序执行有问题，而在使用另外一个编译选项，比如-O2时，
程序执行完好，那么就可以利用这种方法最快的定位到程序是受那个具体优化选项的影响。
}

project_demo(warn)(
jemalloc
gcc -c -std=gnu99 -Wall -pipe -g3 -O3 -funroll-loops  -fvisibility=hidden  -D_GNU_SOURCE -D_REENTRANT
-pipe :使用管道代替临时文件
-g3:  -g0 没有调试信息 -g1 最少调试信息，没有局部变量内容 -g2 默认调试信息 -g3 调试信息包括宏扩展
-funroll-loops  :展开所有迭代次数已知的循环
-fvisibility=[default|internal|hidden|protected] 设置符号的默认可见性

hiredis
-Wall -W -Wstrict-prototypes -Wwrite-strings
-Wstrict-prototypes : 使用了非原型的函数声明时给出警告
-Wwrite-strings : 参数指定 const char[length] ，实参不能是non-const char *

redis: -std=c99 -pedantic
-fprofile-arcs -ftest-coverage
-fprofile-arcs : 插入基于弧的程序取样代码
-ftest-coverage : 生成"gcov"需要的数据文件

moosefs
-fno-omit-frame-pointer -g -std=c99 -Wall -Wextra -Wshadow -pedantic -fwrapv
-fno-omit-frame-pointer: register 不使用寄存器变量，
-Wshadow : 当一个局部变量掩盖了另一个局部变量时给出警告
-fwrapv : 假定有符号运算溢出时回绕

monit
-Wunused -Wno-unused-label -funsigned-char -Wno-pointer-sign -Wno-char-subscripts 
-Wunused : 启用所有关于"XX未使用"的警告
-Wunused-label : 有未使用的标号时警告
-funsigned-char : Let the typecharbe unsigned, likeunsigned char.
-Wpointer-sign: 参数传递 sign unsign类型不一致告警
-Wchar-subscripts : 警告类型是char的数组下标.这是常见错误,程序员经常忘记在某些机器上char有符号.

libevent: debug -fstack-protector-all -fwrapv 
-Wstack-protector : 当因为某种原因堆栈保护失效时给出警告

memcached:
-Wall -Werror -pedantic -Wmissing-prototypes -Wmissing-declarations -Wredundant-decls
)

library(){
-m32        int、long和指针是32位，产生代码在i386系统上运行
-m64        int为32位、long和指针是64位，产生代码x86-64架构上运行
-mx32       int、long和指针是32位，产生代码x86-64架构上运行

1. 目录选项 Directory Option
-ldir       把dir加入到搜索头文件的路径列表中。
-Ldir       把dir加入到搜索库文件的路径列表中。
2. 链接选项 Linker Option
-lx         进行链接时搜索名为libx.so的库
-shared     生成动态库
-static     生成静态库
-rdynamic   链接器将所有符号添加到动态符号表中，方便dlopen()等使用。
-s          去除可执行文件中的符号表和重定位信息。用于减小可执行文件的大小。
-rdynmaic 传递 -export-dynamic 给链接器，连接器将把所有的符号加入动态符号表(dynamic symbol table)， 。这是调试dlopen()加载的模块时需要的。不指定则连接器会删除不使用的符号。
3. 代码生成选项 Code Generation Option
-fPIC                           编译动态库时，要求产生与位置无关代码(Position-Independent Code)
-fvisibility=default | hidden   默认情况下，设置ELF镜像中符号的可见性为public或hidden
-fvisibility=hidden可以显著地提高链接和加载共享库的性能，生成更加优化的代码，提供近乎完美的API输出和防止符号碰撞。强烈建议在编译共享库的时候使用它。

-fvisibility的缺省值是default。
-fPIC 要求编译器产生与位置无关代码，也就是代码中不使用绝对地址，而使用相对地址，因此加载器可以将它加载到内存任意位置并执行；

如果不使用-fPIC，产生的代码中包含绝对地址。加载器加载它时，要先重定位，重定位会修改代码段的内容，因此每个进程都生成这个代码段的一份拷贝。

}

gcc_march(march){
-march
指定目标CPU架构以进行对应的优化。
例：生成在早期X86架构CPU上可执行的代码(例如不使用跳转移动而使用跳转)。
$ gcc -arch=i686 prog.c
}
gcc(m32){
-m32
在64位机上产生32位兼容的代码。
例：
$ gcc -m32 prog.c
}

gcc_v(带上-v或-###参数){
gcc main.c -o test
gcc main.c -o test -v
1. 在上面显示的信息中，我们已经看到了gcc对cc的使用：
 /usr/lib/gcc/x86_64-linux-gnu/4.6/cc1 -quiet -v -imultilib . -imultiarch x86_64-linux-gnu main.c -quiet 
     -dumpbase main.c -mtune=generic -march=x86-64 -auxbase main -version -fstack-protector -o /tmp/ccDZuVeQ.s
2. 还有对as的使用：
as --64 -o /tmp/ccuI9cxX.o /tmp/ccDZuVeQ.s
---------------------------------------
相比gcc对cc1和as的直接调用，它对ld的使用是间接的，即通过程序collect2来进行。
}
gcc_MM(MM-生成依赖关系){
gcc -MM *.c #输出.c文件之间依赖关系
-M          #生成文件关联的信息。包含目标文件所依赖的所有源代码你可以用gcc -M hello.c来测试一下，很简单。
-MM         #和上面的那个一样，但是它将忽略由#include<file>造成的依赖关系。
-MD         #和-M相同，但是输出将导入到.d的文件里面
-MMD        #和-MM相同，但是输出将导入到.d的文件里面

gcc -M test.c  # 获取目标的完整依赖关系
gcc -MM test.c # 获取目标的部分依赖关系
}

gcc_U_D(D){
-imacros file  将file文件的宏,扩展到gcc/g++的输入文件,宏定义本身并不出现在输入文件中
-Dmacro        相当于C语言中的#define macro
-Dmacro=defn   相当于C语言中的#define macro=defn
-Umacro        相当于C语言中的#undef macro
-undef         取消对任何非标准宏的定义
}


在源代码中加入下面的代码
#pragma GCC diagnostic [error|warning|ignored] "-W<警告选项>"
可能有些第版本的gcc不支持在个别函数内指定，仅支持整个文件的作用域

诊断-忽略:(关闭警告)
#pragma  GCC diagnostic ignored  "-Wunused"
#pragma  GCC diagnostic ignored  "-Wunused-parameter"

诊断-警告:(开启警告)
#pragma  GCC diagnostic warning  "-Wunused"
#pragma  GCC diagnostic warning  "-Wunused-parameter"

诊断-错误:(开启警告-升级为错误)
#pragma  GCC diagnostic error  "-Wunused"
#pragma  GCC diagnostic error  "-Wunused-parameter"

在文件开头处关闭警告,在文件结尾出再开启警告,这样可以忽略该文件中的指定警告.
警告:
gcc main.c -Wall

忽略:
#开启`all`警告,但是忽略 `-unused-parameter`警告
gcc mian.c -Wall -Wno-unused-parameter  

选项格式: -W[no-]<警告选项>
如: -Wno-unused-parameter # no- 表示诊断时忽略这个警告

gcc_warn(Warn){
monit: -Wno-address -Wno-pointer-sign -Wall -Wunused -Wno-unused-label -funsigned-char
moosefs: -Wall -Wextra -Wshadow -pedantic -fwrapv 
redis: WARN=-Wall
rtu:  -Wall -Wextra -Wshadow
libevent:  -Wall -fno-strict-aliasing 
ltp: -Wall -pedantic -Wno-unused-parameter -D_REENTRANT

-Wall -Wextra -pedantic
    更新版本的编译器已经有 -Wpedantic，同时这些编译器还在支持 -pedantic 以保证向后的兼容性。
测试时，所有平台都要加上 -Werror 和 -Wshadow
    其他的不错的选项，-Wstrict-overflow -fno-strict-aliasing
要么指明 -fno-strict-aliasing，要么确定访问的指针从它们创建开始类型一值不变。
    使用 -fno-strict-aliasing 是更佳稳妥的方式，因为现存的C代码中，用到强制类型转换的地方还是挺多的。
    
-Wunreachable-code 不可到达的代码


cpp-cheat:
CFLAGS_EXTRA := \
  -Wall -Wextra \
  -DIMPLEMENTATION_SIGNAL \
  -trigraphs \
  -Wno-comment \
  -Wno-ignored-qualifiers \
  -Wno-missing-field-initializers \
  -Wno-overflow \
  -Wno-override-init \
  -Wno-sequence-point \
  -Wno-sign-compare \
  -Wno-uninitialized \
  -Wno-unused-but-set-variable \
  -Wno-unused-label \
  -Wno-unused-local-typedefs \
  -Wno-unused-value \
  -Wno-unused-variable
  #-DUNDEFINED_BEHAVIOUR \

cpp_c:
-Woverride-init
-Wcomment
-Wignored-qualifiers
-Wno-return-type
-Wsizeof-array-argument
-Wparentheses
-Wno-sequence-point
-Wuninitialized
-Wpointer-to-int-cast
cpp -P -pedantic-errors -std=c11 -Wall

auto:
warning-flags := \
		-Wall \
		-Wextra \
		-Wformat=2 \
		-Wunused-variable \
        -Wcomment \
        -Woverride-init \
		-Wold-style-definition \
		-Wstrict-prototypes \
		-Wno-unused-parameter \
		-Wmissing-declarations \
		-Wmissing-prototypes \
		-Wpointer-arith 
}

gcc_W(W){
无符号数用'>'或'<='和零做比较.
-Wimplicit-int

警告没有指定类型的声明.
-Wimplicit-function-declaration

警告在声明之前就使用的函数.
-Wimplicit
同-Wimplicit-int和-Wimplicit-function-declaration.

-Wmain
如果把main函数声明或定义成奇怪的类型,编译器就发出警告.典型情况下,这个函数
用于外部连接, 返回int数值,不需要参数,或指定两个参数.

-Wreturn-type
如果函数定义了返回类型,而默认类型是int型,编译器就发出警告.同时警告那些不
带返回值的 return语句,如果他们所属的函数并非void类型.

-Wunused
如果某个局部变量除了声明就没再使用,或者声明了静态函数但是没有定义,或者某
条语句的运算结果显然没有使用, 编译器就发出警告.

-Wswitch
如果某条switch语句的参数属于枚举类型,但是没有对应的case语句使用枚举元素,
编译器 就发出警告. ( default语句的出现能够防止这个警告.)超出枚举范围的ca
se语句同样会 导致这个警告.

-Wcomment
如果注释起始序列'/*'出现在注释中,编译器就发出警告.

-Wtrigraphs
警告任何出现的trigraph (假设允许使用他们).

-Wformat
检查对printf和scanf等函数的调用,确认各个参数类型和格式串中的一致.

-Wchar-subscripts
警告类型是char的数组下标.这是常见错误,程序员经常忘记在某些机器上char有符号.

-Wchkp
警告通过指针边界检查器(-fcheck-pointer-bounds)找到的无效内存访问。

-Wdouble-promotion (仅限 C, C++， Objective-C, Objective-C+)
当类型 float 的值隐式提升为 double 时，给出警告

-Wformat-signedness
如果指定了 -Wformat ，还要警告格式字符串是否需要一个无符号参数，并且参数是有符号的，反之亦然。

-Wformat-y2k
如果指定了 -Wformat ，也要警告可能只产生两位数年的 strftime 格式。

-Wimplicit-fallthrough
-Wimplicit-fallthrough 与 -Wimplicit-fallthrough=3 相同，而 -Wno-implicit-fallthrough 与 -Wimplicit-fallthrough=0 相同。
-Wimplicit-fallthrough=n

-Wmisleading-indentation (仅限 C 和 C++)
当代码的缩进不反映块结构时发出警告。特别地，对于 if、else、while 和带有 不使用大括号的保护语句的子句发出警告，然后是带有相同缩进的未保护语句。 在下面的示例中，对 bar 的调用被错误地缩进，就好像它是由 if 条件句保护的一 样。
if (some_condition ()) foo (); bar (); /* Gotcha: this is not guarded by the "if". */


-Wuninitialized
在初始化之前就使用自动变量.

把所有不返回的函数定义为volatile可以避免某些似是而非的警告.

-Wparentheses
在某些情况下如果忽略了括号,编译器就发出警告.

-Wtemplate-debugging
当在C++程序中使用template的时候,如果调试(debugging)没有完全生效,编译器就
发出警告. (仅用于C++).

-Wall
结合所有上述的'-W'选项.通常我们建议避免这些被警告的用法，我们相信,恰当结合宏的使用能够轻易避免这些用法。

-Werror
视警告为错误;出现任何警告即放弃编译.
}

-Wmisleading-indentation 

-fsyntax-only
gcc_Wall(Wall){
-Wall turns on the following warning flags:
-Waddress   
-Warray-bounds=1 (only with -O2)  
-Wbool-compare  
-Wbool-operation  
-Wc++11-compat  -Wc++14-compat  
-Wcatch-value (C++ and Objective-C++ only)  
-Wchar-subscripts  
-Wcomment  
-Wduplicate-decl-specifier (C and Objective-C only) 
-Wenum-compare (in C/ObjC; this is on by default in C++) 
-Wenum-conversion in C/ObjC; 
-Wformat
-Wformat-overflow  
-Wformat-truncation  
-Wint-in-bool-context  
-Wimplicit (C and Objective-C only) 
-Wimplicit-int (C and Objective-C only) 
-Wimplicit-function-declaration (C and Objective-C only) 
-Winit-self (only for C++) 
-Wlogical-not-parentheses 
-Wmain (only for C/ObjC and unless -ffreestanding)  
-Wmaybe-uninitialized 
-Wmemset-elt-size 
-Wmemset-transposed-args 
-Wmisleading-indentation (only for C/C++) 
-Wmissing-attributes 
-Wmissing-braces (only for C/ObjC) 
-Wmultistatement-macros  
-Wnarrowing (only for C++)  
-Wnonnull  
-Wnonnull-compare  
-Wopenmp-simd 
-Wparentheses  
-Wpessimizing-move (only for C++)  
-Wpointer-sign  
-Wreorder   
-Wrestrict   
-Wreturn-type  
-Wsequence-point  
-Wsign-compare (only in C++)  
-Wsizeof-pointer-div 
-Wsizeof-pointer-memaccess 
-Wstrict-aliasing  
-Wstrict-overflow=1  
-Wswitch  
-Wtautological-compare  
-Wtrigraphs  
-Wuninitialized  
-Wunknown-pragmas  
-Wunused-function  
-Wunused-label     
-Wunused-value     
-Wunused-variable  
-Wvolatile-register-var  
-Wzero-length-bounds
}

gcc_Wextra(-Wextra){
-Wclobbered  
-Wcast-function-type  
-Wdeprecated-copy (C++ only) 
-Wempty-body  
-Wignored-qualifiers 
-Wimplicit-fallthrough=3 
-Wmissing-field-initializers  
-Wmissing-parameter-type (C only)  
-Wold-style-declaration (C only)  
-Woverride-init  
-Wsign-compare (C only) 
-Wstring-compare 
-Wredundant-move (only for C++)  
-Wtype-limits  
-Wuninitialized  
-Wshift-negative-value (in C++03 and in C99 and newer)  
-Wunused-parameter (only with -Wunused or -Wall) 
-Wunused-but-set-parameter (only with -Wunused or -Wall)

 A pointer is compared against integer zero with <, <=, >, or >=.
(C++ only) An enumerator and a non-enumerator both appear in a conditional expression.
(C++ only) Ambiguous virtual bases.
(C++ only) Subscripting an array that has been declared register.
(C++ only) Taking the address of a variable that has been declared register.
(C++ only) A base class is not initialized in the copy constructor of a derived class. 
}

    当GCC在编译不符合ANSI/ISO C语言标准的源代码时，如果在编译指令中加上了-pedantic选项，那么源程序中
使用了扩展语法的地方将产生相应的警告信息。
gcc(-pedantic -pedantic-errors -Wall -Werror 警告选项){
-pedantic编译选项并不能保证被编译程序与ANSI/ISO C标准的完全兼容，它仅仅只能用来帮助Linux程序员离这个目标越来越近。
或者换句话说，-pedantic选项能够帮助程序员发现一些不符合 ANSI/ISO C标准的代码，但不是全部，事实上只有ANSI/ISO 
C语言标准中要求进行编译器诊断的那些情况，才有可能被GCC发现并提出警告。

-pedantic-errors选项和'-pedantic'类似,但是显示错误而不是警告.

除了-pedantic之外，GCC还有一些其它编译选项也能够产生有用的警告信息。这些选项大多以-W开头，其中最有价值的当数-Wall了，
使用它能够使GCC产生尽可能多的警告信息。

在编译程序时带上-Werror选项，那么GCC会在所有产生警告的地方停止编译，迫使程序员对自己的代码进行修改，
}

gcc_ldl(-rdynamic -ldl 链接动态库){
选项 -rdynamic 用来通知链接器将所有符号添加到动态符号表中(目的是能够通过使用 dlopen 来实现向后跟踪)。
选项 -ldl 表明一定要将 dllib 链接于该程序。


-g是一个编译选项，即在源代码编译的过程中起作用，让gcc把更多调试信息(也就包括符号信息)收集起来并将存放到最终的可执行文件内。
相比-g选项，-rdynamic却是一个连接选项，它将指示连接器把所有符号(而不仅仅只是程序已使用到的外部符号，但不包括静态符号，
比如被static修饰的函数)都添加到动态符号表(即.dynsym表)里，以便那些通过dlopen()或backtrace()（这一系列函数使用.
dynsym表内符号）这样的函数使用。
http://www.lenky.info/archives/2013/01/2190
}

gcc_library(-static强制链接时使用静态链接库){
gcc -L /usr/dev/mysql/lib -lmysqlclient test.o -o test           # 动态库
gcc -L /usr/dev/mysql/lib -static -lmysqlclient test.o -o test   # 静态库
}

gcc(同时使用动态/静态库){
GCC默认的链接库形式是动态的；如果要采用静态连接需要添加static参数，但是会导致整个GCC连接都是用静态连接方式。
这是可以使用-Wl,-Bstatic XXX -Wl,-Bdynamic XXX来指定需要静态连接和动态链接的库。
比如：-Wl,-Bstatic -lsqlite -Wl,-Bdynamic  -lm。
libsqlite会被静态连接，而libm则会被动态连接。注意：-Wl,-Bstatic和-Wl,-Bdynamic的逗号后面不能有空格。
-L放在-Wl,-Bstatic还是-Wl,-Bdynamic之后，不会影响结果。
-Bstatic 还有三个写法： -dn和-non_shared 和-static 
-Bdynamic 还有两个写法：-dy 和-call_shared
"--startgroup foo.o bar.o -Wl,--endgroup"表示一组。
}

gcc_g_ggdb(调试选项){
-g  以操作系统的本地格式(stabs, COFF, XCOFF,或DWARF).产生调试信息. GDB能够使
用这些调试信息.
# 加了-g选项仍然无调试符号 ->  strip $(TARGET)
-ggdb   以本地格式(如果支持)输出调试信息,尽可能包括GDB扩展.
-p      产生额外代码,用于输出profile信息,供分析程序prof使用.
-pg     产生额外代码,用于输出profile信息,供分析程序gprof使用.
}

gcc_std(STD){
STD=-std=c99 -pedantic
-ansi 支持符合ANSI标准的C程序。这样就会关闭GNU C中某些不兼容ANSI C的特性。

-std=c89 
-iso9899:1990 
指明使用标准 ISO C90 作为标准来编译程序。

-std=c99 
-std=iso9899:1999 
指明使用标准 ISO C99 作为标准来编译程序。

-std=c++98 
指明使用标准 C++98 作为标准来编译程序。

-std=gnu9x 
-std=gnu99 
使用 ISO C99 再加上 GNU 的一些扩展。
}

-Wall   启用所有警告信息
-Werror 在发生警告时取消编译操作，即将警告看作是错误
-w      禁用所有警告信息
http://blog.csdn.net/cy_cai/article/details/47001325
gcc_WARN(WARN){
WARN=-Wall
WARN=-Wall -W -Wstrict-prototypes -Wwrite-strings

gcc 提供了大量的警告选项，对代码中可能存在的问题提出警 告，通常可以使用-Wall来开启以下警告: 
           -Waddress -Warray-bounds (only with -O2) -Wc++0x-compat 
           -Wchar-subscripts -Wimplicit-int -Wimplicit-function-declaration 
           -Wcomment -Wformat -Wmain (only for C/ObjC and unless 
           -ffreestanding) -Wmissing-braces -Wnonnull -Wparentheses 
           -Wpointer-sign -Wreorder -Wreturn-type -Wsequence-point 
           -Wsign-compare (only in C++) -Wstrict-aliasing -Wstrict-overflow=1 
           -Wswitch -Wtrigraphs -Wuninitialized (only with -O1 and above) 
           -Wunknown-pragmas -Wunused-function -Wunused-label -Wunused-value 
           -Wunused-variable 
    unused-function:警告声明但是没有定义的static函数; 
    unused- label:声明但是未使用的标签; 
    unused-parameter:警告未使用的函数参数; 
    unused-variable:声明但 是未使用的本地变量; 
    unused-value:计算了但是未使用的值; 
    format:printf和scanf这样的函数中的格式字符 串的使用不当; 
    implicit-int:未指定类型; 
    implicit-function:函数在声明前使用; 
    char- subscripts:使用char类作为数组下标(因为char可能是有符号数); 
    missingbraces:大括号不匹配; 
    parentheses: 圆括号不匹配; 
    return-type:函数有无返回值以及返回值类型不匹配; 
    sequence-point:违反顺序点的代码,比如 a[i] = c[i++]; 
    switch:switch语句缺少default或者switch使用枚举变量为索引时缺少某个变量的case; 
    strict- aliasing=n:使用n设置对指针变量指向的对象类型产生警告的限制程度,默认n=3;只有在-fstrict-aliasing设置的情况下有 效; 
    unknow-pragmas:使用未知的#pragma指令; 
    uninitialized:使用的变量为初始化,只在-O2时有 效; 
以下是在-Wall中不会激活的警告选项: # 
    cast-align:当指针进行类型转换后有内存对齐要求更严格时发出警告; 
    sign- compare:当使用signed和unsigned类型比较时; 
    missing-prototypes:当函数在使用前没有函数原型时; 
    packed:packed 是gcc的一个扩展,是使结构体各成员之间不留内存对齐所需的空 间 ,有时候会造成内存对齐的问题; 
    padded:也是gcc的扩展,使结构体成员之间进行内存对齐的填充,会 造成结构体体积增大. 
    unreachable-code:有不会执行的代码时. 
    inline:当inline函数不再保持inline时 (比如对inline函数取地址); 
    disable-optimization:当不能执行指定的优化时.(需要太多时间或系统 资源). 
可以使用 -Werror时所有的警告都变成错误,使出现警告时也停止编译.需要和指定警告的参数一起使用.

-Wextra 
打印一些额外的警告信息。
-Wshadow 
当一个局部变量遮盖住了另一个局部变量，或者全局变量时，给出警告。很有用的选项，建议打开。 -Wall 并不会打开此项。
-Wpointer-arith 
对函数指针或者void *类型的指针进行算术操作时给出警告。也很有用。 -Wall 并不会打开此项。
-Wcast-qual 
当强制转化丢掉了类型修饰符时给出警告。 -Wall 并不会打开此项。
-Waggregate-return 
如果定义或调用了返回结构体或联合体的函数，编译器就发出警告。
-Winline 
无论是声明为 inline 或者是指定了-finline-functions 选项，如果某函数不能内联，编译器都将发出警告。如果你的代码含有很多 inline 函数的话，这是很有用的选项。
-Werror 
把警告当作错误。出现任何警告就放弃编译。
-Wunreachable-code 
如果编译器探测到永远不会执行到的代码，就给出警告。也是比较有用的选项。
-Wcast-align 
一旦某个指针类型强制转换导致目标所需的地址对齐增加时，编译器就发出警告。
-Wundef 
当一个没有定义的符号出现在 #if 中时，给出警告。
-Wredundant-decls 
如果在同一个可见域内某定义多次声明，编译器就发出警告，即使这些重复声明有效并且毫无差别。
-Wstrict-prototypes 
如果函数的声明或定义没有指出参数类型，编译器就发出警告。很有用的警告。
-Wmissing-prototypes 
如果没有预先声明就定义了全局函数，编译器就发出警告。即使函数定义自身提供了函数原形也会产生这个警告。这个选项 的目的是检查没有在头文件中声明的全局函数。
-Wnested-externs 
如果某extern声明出现在函数内部，编译器就发出警告。
} 
gcc(OPT优化){
OPT=-O2

gcc默认提供了5级优 化选项的集合: 
-O0:无优化(默认) 
-O和-O1:使用能减少目标文 件 大小以及执行时间并且不会使编译时间明显增加的优化.在编译大型程序的时候会显著增加编译时内存的使用. 
-O2: 包含-O1的优化并增加了不需要在目标文件大小和执行速度上进行折衷的优化.编译器不执行循环展开以及函数内联.此选项将增加编译时间和目标文件的执行性 能. 
-Os:专门优化目标文件大小,执行所有的不增加目标文件大小的-O2优化选项.并且执行专门减小目标文件大小的优化选项. 
-O3: 打开所有-O2的优化选项并且增加 -finline-functions, -funswitch-loops,-fpredictive-commoning, -fgcse-after-reload and -ftree-vectorize优化选项. 
-O1包含的选项-O1通常可以安全的和调试的选项一起使用: 
           -fauto-inc-dec -fcprop-registers -fdce -fdefer-pop -fdelayed-branch 
           -fdse -fguess-branch-probability -fif-conversion2 -fif-conversion 
           -finline-small-functions -fipa-pure-const -fipa-reference 
           -fmerge-constants -fsplit-wide-types -ftree-ccp -ftree-ch 
           -ftree-copyrename -ftree-dce -ftree-dominator-opts -ftree-dse 
           -ftree-fre -ftree-sra -ftree-ter -funit-at-a-time 
以下所有的优化选项需要在名字 前加上-f,如果不需要此选项可以使用-fno-前缀 
defer-pop:延迟到只在必要时从函数参数栈中pop参数; 
thread- jumps:使用跳转线程优化,避免跳转到另一个跳转; 
branch-probabilities:分支优化; 
cprop- registers:使用寄存器之间copy-propagation传值; 
guess-branch-probability:分支预测; 
omit- frame-pointer:可能的情况下不产生栈帧; 
-O2:以下是-O2在-O1基础上增加的优化选项: 
           -falign-functions  -falign-jumps -falign-loops  -falign-labels 
           -fcaller-saves -fcrossjumping -fcse-follow-jumps  -fcse-skip-blocks 
           -fdelete-null-pointer-checks -fexpensive-optimizations -fgcse 
           -fgcse-lm -foptimize-sibling-calls -fpeephole2 -fregmove 
           -freorder-blocks  -freorder-functions -frerun-cse-after-loop 
           -fsched-interblock  -fsched-spec -fschedule-insns 
           -fschedule-insns2 -fstrict-aliasing -fstrict-overflow -ftree-pre 
           -ftree-vrp 
cpu架构的优化选项,通常是-mcpu(将被取消);-march,-mtune
} 
gcc(DEBUG){
DEBUG=-g -ggdb

在 gcc编译源代码时指定-g选项可以产生带有调试信息的目标代码,gcc可以为多个不同平台上帝不同调试器提供调试信息,默认gcc产生的调试信息是为 gdb使用的,可以使用-gformat 指定要生成的调试信息的格式以提供给其他平台的其他调试器使用.常用的格式有 
-ggdb:生成gdb专 用的调试信息,使用最适合的格式(DWARF 2,stabs等)会有一些gdb专用的扩展,可能造成其他调试器无法运行. 
-gstabs:使用 stabs格式,不包含gdb扩展,stabs常用于BSD系统的DBX调试器. 
-gcoff:产生COFF格式的调试信息,常用于System V下的SDB调试器; 
-gxcoff:产生XCOFF格式的调试信息,用于IBM的RS/6000下的DBX调试器; 
-gdwarf- 2:产生DWARF version2 的格式的调试信息,常用于IRIXX6上的DBX调试器.GCC会使用DWARF version3的一些特性. 
可 以指定调试信息的等级:在指定的调试格式后面加上等级: 
如: -ggdb2 等,0代表不产生调试信息.在使用-gdwarf-2时因为最早的格式为-gdwarf2会造成混乱,所以要额外使用一个-glevel来指定调试信息的 等级,其他格式选项也可以另外指定等级. 
gcc可以使用-p选项指定生成信息以供porf使用.
} 
gcc_CFLAGS(CFLAGS){
CFLAGS=
REAL_CFLAGS=$(OPTIMIZATION) -fPIC $(CFLAGS) $(WARNINGS) $(DEBUG) $(ARCH)
} 

gcc_LDFLAGS(LDFLAGS){
LDFLAGS=
REAL_LDFLAGS=$(LDFLAGS) $(ARCH)
}

gcc_gcov(gcov){
CFLAGS="-fprofile-arcs -ftest-coverage" LDFLAGS="-fprofile-arcs"
}

gcc_valgrind(valgrind){
OPTIMIZATION="-O0" MALLOC="libc"
}

gcc(gprof){
CFLAGS="-pg" LDFLAGS="-pg"
}

gcc_libhiredis_so(libhiredis.so){
make dynamic
#定义动态库名称，主版本号，次要版本号和动态库后缀
LIBNAME=libhiredis
HIREDIS_MAJOR=0
HIREDIS_MINOR=10
DYLIBSUFFIX=so

#定义动态库主名称、动态库次名称和动态库名称
DYLIB_MINOR_NAME=$(LIBNAME).$(DYLIBSUFFIX).$(HIREDIS_MAJOR).$(HIREDIS_MINOR)
DYLIB_MAJOR_NAME=$(LIBNAME).$(DYLIBSUFFIX).$(HIREDIS_MAJOR)
DYLIBNAME=$(LIBNAME).$(DYLIBSUFFIX)

#定义动态库生成命令前半部
Darwin : DYLIB_MAKE_CMD=$(CC) -shared -Wl,-install_name,$(DYLIB_MINOR_NAME) -o $(DYLIBNAME) $(LDFLAGS)
Linux : DYLIB_MAKE_CMD=$(CC) -shared -Wl,-soname,$(DYLIB_MINOR_NAME) -o $(DYLIBNAME) $(LDFLAGS)
SunOS : DYLIB_MAKE_CMD=$(CC) -G -o $(DYLIBNAME) -h $(DYLIB_MINOR_NAME) $(LDFLAGS)

#组装动态库命令
OBJ=net.o hiredis.o sds.o async.o
$(DYLIB_MAKE_CMD) $(OBJ)
cc -shared -Wl,-soname,libhiredis.so.0.10 -o libhiredis.so  net.o hiredis.o sds.o async.o
}

gcc_libhiredis_a(libhiredis.a){
make static
#定义静态库名称和动态库后缀
LIBNAME=libhiredis
STLIBSUFFIX=a

#定义静态库名称
STLIBNAME=$(LIBNAME).$(STLIBSUFFIX)

#定义静态库生成命令前半部
STLIB_MAKE_CMD=ar rcs $(STLIBNAME)

#组装动态库命令
OBJ=net.o hiredis.o sds.o async.o
$(STLIB_MAKE_CMD) $(OBJ)
ar rcs libhiredis.a net.o hiredis.o sds.o async.o
}

gcc_libhiredis(libhiredis 动态库){
make hiredis-example-libevent
cc -o hiredis-example-libevent -O3 -fPIC  -Wall -W -Wstrict-prototypes -Wwrite-strings -g -ggdb    -levent example-libevent.c libhiredis.a
make hiredis-example-libev
cc -o hiredis-example-libev -O3 -fPIC  -Wall -W -Wstrict-prototypes -Wwrite-strings -g -ggdb    -lev example-libevent.c libhiredis.a
make hiredis-example-ae
cc -o hiredis-example-ae -O3 -fPIC  -Wall -W -Wstrict-prototypes -Wwrite-strings -g -ggdb    -I../../src/ ../../src/ae.o ../../src/zmalloc.o example-ae.c libhiredis.a

make test
make check
make dep
make clean
make install
make gprof
make gcov
}
gcc_redis(redis 程序细节){

# 依赖编译说明
DEPENDENCY_TARGETS=hiredis linenoise lua

#CFLAGS编译说明
FINAL_CFLAGS=$(STD) $(WARN) $(OPT) $(DEBUG) $(CFLAGS) $(REDIS_CFLAGS)
FINAL_CFLAGS+= -I../deps/hiredis -I../deps/linenoise -I../deps/lua/src
FINAL_CFLAGS+= -DUSE_TCMALLOC
FINAL_CFLAGS+= -DUSE_JEMALLOC -I../deps/jemalloc/include

#CFLAGS链接说明
FINAL_LDFLAGS=$(LDFLAGS) $(REDIS_LDFLAGS) $(DEBUG)
FINAL_LDFLAGS+= -rdynamic

FINAL_LIBS=-lm
FINAL_LIBS+= -ldl -lnsl -lsocket -lpthread #FINAL_LIBS+= -pthread
FINAL_LIBS+= -ltcmalloc # FINAL_LIBS+= -ltcmalloc_minimal
FINAL_LIBS+= ../deps/jemalloc/lib/libjemalloc.a -ldl

# make redis-server
cc   -g -ggdb -rdynamic -o redis-server 
adlist.o ae.o anet.o dict.o redis.o sds.o zmalloc.o lzf_c.o lzf_d.o pqsort.o zipmap.o sha1.o ziplist.o release.o 
networking.o util.o object.o db.o replication.o rdb.o t_string.o t_list.o t_set.o t_zset.o t_hash.o config.o aof.o 
pubsub.o multi.o debug.o sort.o intset.o syncio.o cluster.o crc16.o endianconv.o slowlog.o scripting.o bio.o rio.o 
rand.o memtest.o crc64.o bitops.o sentinel.o notify.o setproctitle.o blocked.o hyperloglog.o 
../deps/hiredis/libhiredis.a 
../deps/lua/src/liblua.a 
-lm 
-pthread 
../deps/jemalloc/lib/libjemalloc.a 
-ldl

# make  redis-sentinel
cc   -g -ggdb -rdynamic -o redis-server adlist.o ae.o anet.o dict.o redis.o sds.o zmalloc.o lzf_c.o lzf_d.o pqsort.o 
zipmap.o sha1.o ziplist.o release.o networking.o util.o object.o db.o replication.o rdb.o t_string.o t_list.o t_set.o 
t_zset.o t_hash.o config.o aof.o pubsub.o multi.o debug.o sort.o intset.o syncio.o cluster.o crc16.o endianconv.o 
slowlog.o scripting.o bio.o rio.o rand.o memtest.o crc64.o bitops.o sentinel.o notify.o setproctitle.o blocked.o 
hyperloglog.o 
../deps/hiredis/libhiredis.a 
../deps/lua/src/liblua.a 
-lm 
-pthread 
../deps/jemalloc/lib/libjemalloc.a 
-ldl
# make redis-check-aof
cc   -g -ggdb -rdynamic -o redis-check-aof redis-check-aof.o -lm -pthread ../deps/jemalloc/lib/libjemalloc.a -ldl
# make redis-cli
cc   -g -ggdb -rdynamic -o redis-cli anet.o sds.o adlist.o redis-cli.o zmalloc.o release.o ae.o crc64.o 
../deps/hiredis/libhiredis.a 
../deps/linenoise/linenoise.o 
-lm -pthread 
../deps/jemalloc/lib/libjemalloc.a 
-ldl
# make redis-benchmark
cc   -g -ggdb -rdynamic -o redis-benchmark ae.o anet.o redis-benchmark.o sds.o adlist.o zmalloc.o 
../deps/hiredis/libhiredis.a 
-lm -pthread 
../deps/jemalloc/lib/libjemalloc.a 
-ldl
}

make(make redis-check-aof V=1 控制打印输出){
REDIS_CC=$(QUIET_CC)$(CC) $(FINAL_CFLAGS)
REDIS_LD=$(QUIET_LINK)$(CC) $(FINAL_LDFLAGS)
REDIS_INSTALL=$(QUIET_INSTALL)$(INSTALL)

CCCOLOR="\033[34m"
LINKCOLOR="\033[34;1m"
SRCCOLOR="\033[33m"
BINCOLOR="\033[37;1m"
MAKECOLOR="\033[32;1m"
ENDCOLOR="\033[0m"

ifdef V
QUIET_CC = @printf '    %b %b\n' $(CCCOLOR)CC$(ENDCOLOR) $(SRCCOLOR)$@$(ENDCOLOR) 1>&2;
QUIET_LINK = @printf '    %b %b\n' $(LINKCOLOR)LINK$(ENDCOLOR) $(BINCOLOR)$@$(ENDCOLOR) 1>&2;
QUIET_INSTALL = @printf '    %b %b\n' $(LINKCOLOR)INSTALL$(ENDCOLOR) $(BINCOLOR)$@$(ENDCOLOR) 1>&2;
endif
}

ranlib(){
更新静态库的符号索引表
静态库文件需要使用"ar"来创建和维护。当给静态库增建一个成员时(加入一个.o文件到静态库中)，"ar"可直接 将需要增加的.o
文件简单的追加到静态库的末尾。之后当我们使用这个库进行连接生成可执行文件时，链接程序"ld"却提示错误，这可能是：主程序
使用了之 前加入到库中的.o文件中定义的一个函数或者全局变量，但连接程序无法找到这个函数或者变量。 

这个问题的原因是：之前我们将编译完成的.o文件直接加入到了库的末尾，却并没有更新库的有效符号表。连接程序进行连接时，
在静态库的符号索引表中无法定 位刚才加入的.o文件中定义的函数或者变量。这就需要在完成库成员追加以后让加入的所有.o文件
中定义的函数(变量)有效，完成这个工作需要使用另外一个 工具"ranlib"来对静态库的符号索引表进行更新。
}

collect2(){
    collect2主要实现了两个额外的功能，都是为C++程序准备的。其一是生成代码调用全局静态对象的构造函数和析构函数；
其二是支持Cfront方式生成模板代码。
    C++程序的全局静态对象，需要在main函数运行前构造好，在main函数执行完成后析构掉。构造函数和析构函数是由程序员
编写的，那么该由谁负责调用呢？通常来讲，调用这些函数的工作由初始化代码完成，比如，GNU ld就可以生成这些代码。
如果这些代码不能由linker自动生成，就需要collect2的帮助。
    collect2调用ld生成一个执行程序，然后调用nm程序，根据命名规则，查找所有的调用全局静态对象构造函数和析构函数
的函数，并将这些函数保存为一张表，再生成一段代码遍历每个表项，调用对应的函数。所有这些信息被保存为一个C程序，
然后编译、汇编为目标文件，在链接时作为第一个目标文件传给linker，做第二次链接。此功能实现在gcc/collect2.c文件内。
通过在config.gcc文件里查找use_collect2=yes来确定哪些系统使用了该功能，PC上默认是关闭的。
    Cfront支持代码实现在gcc/tlink.c文件里，这里的调用关系就更复杂了。gcc在编译C++程序时不生成任何模板代码，
而是使用-frepo生成一个辅助文件，collect2调用ld做链接后，分析错误信息，提取未定义的符号，然后通过分析所有的
repo文件，判断要生成哪些模板代码，并调用gcc重新编译特定文件，然后再链接，如果还有未定义的符号，则重复上述过程。
如此反复，最多17次。如果还不能正确链接，则报错。

    查看collect2的手册
}
weak(alias){
    在看glibc源代码的时候，能看到很多对函数的属性修饰，比如weak_alias(注：我当前看的是2.17版本的glibc源代码)
宏里的weak和alias：
/* Define ALIASNAME as a weak alias for NAME.
   If weak aliases are not available, this defines a strong alias.  */
# define weak_alias(name, aliasname) _weak_alias (name, aliasname)
# define _weak_alias(name, aliasname) \
  extern __typeof (name) aliasname __attribute__ ((weak, alias (#name)));
  
glibc里一个实际的gettimeofday()应用：

#else
# include <sysdep.h>
# include <errno.h>
 
int
__gettimeofday (struct timeval *tv, struct timezone *tz)
{
  return INLINE_SYSCALL (gettimeofday, 2, tv, tz);
}
libc_hidden_def (__gettimeofday)
 
#endif
weak_alias (__gettimeofday, gettimeofday)
libc_hidden_weak (gettimeofday)
对于weak、alias以及另外一个同类属性weakref， # http://gcc.gnu.org/onlinedocs/gcc-4.4.0/gcc/Function-Attributes.html

1. alias：表示当前符号是另外一个(目标target)符号的别称。比如：
void __f () { /* Do something. */; }
void f () __attribute__ ((weak, alias ("__f")));
alias修饰的是符号f，指定的目标符号是__f，也就是说符号f是符号__f的别称。

2. weak：表示当前符号是个弱类型符号(weak symbol)，而非全局符号。看个示例：
2.1，首先，准备一个库文件(以静态库为例，后文将提到为什么不以动态库为例)：
    看来weak修饰符的原本含义是让weak弱类型的函数可以被其它同名函数覆盖(即不会发生冲突)，
如果没有其它同名函数，就使用该weak函数，类似于是默认函数；
---------------------------------------mylib.c
#include <stdio.h>
 
void foo()
{
    printf("lib test\n");
}
 
void foo() __attribute__ ((weak));
---------------------------------------myapp.c
#include <stdio.h>
 
int main()
{
    foo();
    return 0;
}
--------------------------------------- myfoo.c
#include <stdio.h>
 
void foo()
{
    printf("app test\n");
}
--------------------------------------- build.sh
gcc -c mylib.c
ar crv libmylib.a mylib.o
gcc myapp.c myfoo.c libmylib.a -o myapp_weak
./myapp_weak 

gcc myapp.c libmylib.a -o myapp_weak
./myapp_weak

--------------------------------------- 去掉weak
gcc -c mylib.c;
ar crv libmylib.a mylib.o
gcc myapp.c myfoo.c libmylib.a -o myapp # OK

gcc myapp.c libmylib.a myfoo.c -o myapp # NO
}

gcc100(){ https://github.com/hellogcc/100-gcc-tips

##### [信息显示]
1. 打印gcc预定义的宏信息
gcc -dM -E - < /dev/null  # echo | gcc -dM -E -
"-dM"生成预定义的宏信息，"-E"表示预处理操作完成后就停止，不再进行下面的操作。

2. 打印gcc执行的子命令
gcc -### foo.c
cc1：
 /usr/lib/gcc/x86_64-linux-gnu/4.6/cc1 -quiet -imultilib . -imultiarch x86_64-linux-gnu foo.c -quiet -dumpbase foo.c "-mtune=generic" "-march=x86-64" -auxbase foo -fstack-protector -o /tmp/ccezMraJ.s

as：
 as --64 -o /tmp/cc9Ce7IE.o /tmp/ccezMraJ.s

collect2：
 /usr/lib/gcc/x86_64-linux-gnu/4.6/collect2 "--sysroot=/" --build-id --no-add-needed --as-needed --eh-frame-hdr -m elf_x86_64 "--hash-style=gnu" -dynamic-linker /lib64/ld-linux-x86-64.so.2 -z relro /usr/lib/gcc/x86_64-linux-gnu/4.6/../../../x86_64-
这个跟使用-v所显示的内容差不多，区别在于使用-###是只打印，不实际执行具体的命令。

3. 打印优化级别的对应选项
gcc -Q --help=optimizers
gcc -Q --help=optimizers -O
gcc -Q --help=optimizers -O1
gcc -Q --help=optimizers -O2
gcc -Q --help=optimizers -O3
gcc -Q --help=optimizers -Og
gcc -Q --help=optimizers -Os
gcc -Q --help=optimizers -Ofast

4. 打印头文件搜索路径
gcc -v foo.c
...
ignoring nonexistent directory "/usr/local/include/x86_64-linux-gnu"
ignoring nonexistent directory "/usr/lib/gcc/x86_64-linux-gnu/4.6/../../../../x86_64-linux-gnu/include"
#include "..." search starts here:
#include <...> search starts here:
 /usr/lib/gcc/x86_64-linux-gnu/4.6/include
 /usr/local/include
 /usr/lib/gcc/x86_64-linux-gnu/4.6/include-fixed
 /usr/include/x86_64-linux-gnu
 /usr/include
End of search list.
使用-v选项可以打印出gcc搜索头文件的路径和顺序。当然，也可以使用-###选项

5. 打印连接库的具体路径
gcc -print-file-name=libc.a
/usr/lib/gcc/x86_64-linux-gnu/4.6/../../../x86_64-linux-gnu/libc.a

##### [信息显示]

##### [预处理]
6. 生成没有行号标记的预处理文件
gcc -E -P foo.c -o foo.i

7. 在命令行中预定义宏
gcc -D DEBUG macro.c

8. 在命令行中取消宏定义
gcc -U DEBUG macro.c
##### [预处理]

##### [汇编]
9. 把选项传给汇编器
gcc -c -Wa,-L foo.c
使用-Wa,option可以将选项option传递给汇编器。
这里的-L是汇编器as的选项，用于在目标文件中保留局部符号（local symbol）。可以看到，反汇编代码中给出了每个局部符号。
如果此时你使用oprofile来统计性能事件，那么获得的结果将不是以函数为单位了，而是以这些符号所划分的代码块为单位。

10. 生成有详细信息的汇编文件
gcc -S -fverbose-asm foo.c
可以看到，在汇编文件中给出了gcc所使用的具体选项，以及汇编指令操作数所对应的源程序（或中间代码）中的变量。
##### [汇编]

#### [连接]
11. 把选项传给连接器
gcc -Wl,-Map=output.map foo.c

12. 设置动态连接器
gcc foo.c -Wl,-I/home/xmj/tmp/ld-2.15.so

#### [连接]

只做语法检查
gcc -fsyntax-only foo.c
保存临时文件
gcc -save-temps a/foo.c
}

gcc(打印gcc预定义的宏信息){
gcc -dM -E - < /dev/null
    如上所示，使用"gcc -dM -E - < /dev/null"命令就可以显示出gcc预定义的宏信息。
"-dM"生成预定义的宏信息，
"-E"表示预处理操作完成后就停止，不再进行下面的操作。此外，
也可以使用这个命令："echo | gcc -dM -E -"。
}
gcc(打印gcc执行的子命令){
gcc -### foo.c

如上所示，使用-###选项可以打印出gcc所执行的各个子命令，分别为，

cc1：
 /usr/lib/gcc/x86_64-linux-gnu/4.6/cc1 -quiet -imultilib . -imultiarch x86_64-linux-gnu foo.c -quiet -dumpbase foo.c "-mtune=generic" "-march=x86-64" -auxbase foo -fstack-protector -o /tmp/ccezMraJ.s

as：
as --64 -o /tmp/cc9Ce7IE.o /tmp/ccezMraJ.s

collect2：
 /usr/lib/gcc/x86_64-linux-gnu/4.6/collect2 "--sysroot=/" --build-id --no-add-needed --as-needed --eh-frame-hdr -m elf_x86_64 "--hash-style=gnu" -dynamic-linker /lib64/ld-linux-x86-64.so.2 -z relro /usr/lib/gcc/x86_64-linux-gnu/4.6/../../../x86_64-linux-gnu/crt1.o /usr/lib/gcc/x86_64-linux-gnu/4.6/../../../x86_64-linux-gnu/crti.o /usr/lib/gcc/x86_64-linux-gnu/4.6/crtbegin.o -L/home/xmj/install/cap-llvm-3.4/lib/../lib -L/usr/lib/gcc/x86_64-linux-gnu/4.6 -L/usr/lib/gcc/x86_64-linux-gnu/4.6/../../../x86_64-linux-gnu -L/usr/lib/gcc/x86_64-linux-gnu/4.6/../../../../lib -L/lib/x86_64-linux-gnu -L/lib/../lib -L/usr/lib/x86_64-linux-gnu -L/usr/lib/../lib -L/home/xmj/install/cap-llvm-3.4/lib -L/usr/lib/gcc/x86_64-linux-gnu/4.6/../../.. /tmp/cc9Ce7IE.o -lgcc --as-needed -lgcc_s --no-as-needed -lc -lgcc --as-needed -lgcc_s --no-as-needed /usr/lib/gcc/x86_64-linux-gnu/4.6/crtend.o /usr/lib/gcc/x86_64-linux-gnu/4.6/../../../x86_64-linux-gnu/crtn.o
这个跟使用-v所显示的内容差不多，区别在于使用-###是只打印，不实际执行具体的命令。
}
gcc(打印优化级别的对应选项){
gcc -Q --help=optimizers

    如上所示，使用-Q --help=optimizers选项可以打印出gcc的所有优化(相关的)选项，以及缺省情况下它们是否打开。
类似的，你也可以查看不同优化级别下，这些优化选项是否打开：
gcc -Q --help=optimizers -O
gcc -Q --help=optimizers -O1
gcc -Q --help=optimizers -O2
gcc -Q --help=optimizers -O3
gcc -Q --help=optimizers -Og
gcc -Q --help=optimizers -Os
gcc -Q --help=optimizers -Ofast
}
gcc(打印彩色诊断信息){
这是gcc-4.9新增的功能，可以通过定义环境变量GCC_COLORS来彩色打印诊断信息。
也可以使用选项-fdiagnostics-color来设定。
}
gcc(打印头文件搜索路径){
gcc -v foo.c
如上所示，使用-v选项可以打印出gcc搜索头文件的路径和顺序。当然，也可以使用-###选项
}
gcc(打印连接库的具体路径){
gcc -print-file-name=libc.a
/usr/lib/gcc/x86_64-linux-gnu/4.6/../../../x86_64-linux-gnu/libc.a
如上所示，使用-print-file-name选项就可以显示出gcc究竟会连接哪个libc库了。
/usr/local/arm/arm-2009q3/arm-none-linux-gnueabi/bin/gcc  -print-file-name=libc.a
}
gcc(生成没有行号标记的预处理文件){
gcc -E -P foo.c -o foo.i
}

gcc(配置宏定义){

gcc -D'TEST="test"' file.c # 如果宏为字符串时，则需要用单引号引起来。
int main (void)
{
  int i, sum;

  for ((i = 1, sum = 0; i <= 10; i++))
    {
      sum += i;
    #ifdef DEBUG
      printf ("sum += %d is %d\n", i, sum);
    #endif
    }
  printf ("total sum is %d\n", sum);

  return 0;
}

使用-D选项可以在命令行中预定义一个宏，比如：
gcc -D DEBUG macro.c 或 gcc -DDEBUG macro.c
}
gcc(取消宏定义){
类似于-D选项，你可以使用-U选项在命令行中取消一个宏的定义，比如：
gcc -U DEBUG macro.c
中间可以没有空格：
gcc -UDEBUG macro.c
}
gcc(把选项传给汇编器){
#include <stdio.h>

int main(void)
{
  int i;

  for ((i = 0; i < 10; i++))
    printf("%d ", i);
  putchar ('\n');

  return 0;
}
使用-Wa,option可以将选项option传递给汇编器。

注意，逗号和选项之间不能有空格。例如：

$ gcc -c -Wa,-L foo.c
$ objdump -d foo.o
这里的-L是汇编器as的选项，用于在目标文件中保留局部符号(local symbol)。可以看到，反汇编代码中给出了每个局部符号。
如果此时你使用oprofile来统计性能事件，那么获得的结果将不是以函数为单位了，而是以这些符号所划分的代码块为单位。
}
gcc(生成有详细信息的汇编文件){
使用-fverbose-asm选项就可以生成带有详细信息的汇编文件：

$ gcc -S -fverbose-asm foo.c
$ cat foo.s
可以看到，在汇编文件中给出了gcc所使用的具体选项，以及汇编指令操作数所对应的源程序(或中间代码)中的变量。
}
gcc(){
a.c:
#include <stdio.h>

int main(void) {
        // your code goes here
        int a[3] = {0};
        a[3] = 1;

        printf("%d\n", a[3]);
        return 0;
}

b.c:
#include <stdio.h>
#include <malloc.h>

int main(void) {
        int *p = NULL;

        p = malloc(10 * sizeof(int));
        free(p);
        *p = 3;
        return 0;
}
gcc从4.8版本起，集成了Address Sanitizer工具，可以用来检查内存访问的错误(编译时指定"-fsanitize=address")。以上面a.c程序为例：
gcc -fsanitize=address -g -o a a.c

}
gcc(利用Thread Sanitizer工具检查数据竞争的问题){
#include <pthread.h>
int Global;
void *Thread1(void *x) {
  Global = 42;
  return x;
}
int main(void) {
  pthread_t t;
  pthread_create(&t, NULL, Thread1, NULL);
  Global = 43;
  pthread_join(t, NULL);
  return Global;
}
gcc从4.8版本起，集成了Address Sanitizer工具，可以用来检查数据竞争的问题(编译时指定"-fsanitize=thread -fPIE -pie")。以上面程序为例：
gcc -fsanitize=thread -fPIE -pie -g -o a a.c -lpthread
执行a程序：
 ./a
}
gcc(把选项传给连接器){

#include <stdio.h>
int main (void)
{
  puts ("Hello world!");
  return 0;
}

使用-Wl,option可以将选项option传递给连接器。
注意，逗号和选项之间不能有空格。一种常见用法，就是让连接器生成内存映射文件，例如：
$ gcc -Wl,-Map=output.map foo.c
$ cat output.map
}
gcc(设置动态连接器){
技巧

有人问我，如何通过选项来指定动态连接器，而不使用缺省系统自带的动态连接器。我后来查了下ld的手册，有这么一个选项：

-Ifile
--dynamic-linker=file     
    Set the name of the dynamic linker. This is only meaningful when generating dynamically 
    linked ELF executables. The default dynamic linker is normally correct; do not use this unless you know what you are doing.

看起来，可以通过如下方式来完成：

$ gcc foo.c -Wl,-I/home/xmj/tmp/ld-2.15.so
$ ldd a.out
linux-vdso.so.1 =>  (0x00007fffce5fe000)
/usr/local/lib/libtrash.so (0x00007f1980477000)
libc.so.6 => /lib/x86_64-linux-gnu/libc.so.6 (0x00007f19800a3000)
libdl.so.2 => /lib/x86_64-linux-gnu/libdl.so.2 (0x00007f197fe9e000)
/home/xmj/tmp/ld-2.15.so => /lib64/ld-linux-x86-64.so.2 (0x00007f1980485000)

注意，tmp目录下的动态连接器因为也是动态连接的，所以它本身是依赖系统缺省的动态连接器。
}
gcc(禁止函数被优化掉){
#if (GCC_VERSION > 4000)
#define DEBUG_FUNCTION __attribute__ ((__used__))
#define DEBUG_VARIABLE __attribute__ ((__used__))
#else 
#define DEBUG_FUNCTION
#define DEBUG_VARIABLE
#endif

DEBUG_FUNCTION void
debug_bb (basic_block bb)
{
  dump_bb (bb, stderr, 0);
}
上面的例子是gcc的源码。使用gcc的扩展功能——函数属性__attribute__ ((__used__))，可以指定该函数是有用的，不能被优化掉。
}
gcc(强制函数永远以inline的形式调用){
#if defined(__GNUC__)
#define FORCEDINLINE  __attribute__((always_inline))
#else 
#define FORCEDINLINE
#endif

FORCEDINLINE int add(int a,int b)
{
  return a+b;
}
上面的例子是gcc的源码。使用gcc的扩展功能——函数属性__attribute__ ((always_inline))，
可以指定该函数永远以inline的形式调用
}
gcc(all warnings being treated as errors){
在ubuntu系统下编译一个程序包，有时会遇到这样的错误：

$ make
...
cc1: all warnings being treated as errors

这是因为缺省的CFLAGS里含有-Werror选项，将警告信息升级为错误。当然，一方面这可以让你重视这些可能会
带来隐患的警告信息；但，如果你不想修改源码，也可以把这个选项关掉，通过修改Makefile或者使用命令行：
$ make CFLAGS="... -Wno-error"
}
gcc(只做语法检查){
$ cat foo.c
union u {
  char c;
  int i;
}
$ gcc -fsyntax-only foo.c
foo.c:4:1: error: expected identifier or ‘(’ at end of input
如上所示，使用-fsyntax-only选项可以只做语法检查，不进行实际的编译输出。
}
gcc(保存临时文件){
$ gcc -save-temps a/foo.c # 生成编译过程中间所有文件(.i, .s, .o)
$ ls foo.*
foo.c  foo.i  foo.o  foo.s

$ gcc -save-temps=obj a/foo.c -o a/foo
$ ls a
foo  foo.c  foo.i  foo.o  foo.s

    如上所示，使用选项-save-temps可以保存gcc运行过程中生成的临时文件。这些中间文件的名字是基于源文件而来，
并且保存在当前目录下。
    如果你在不同目录下有重名的源文件，那么中间文件就会有冲突了。此时，你可以使用-save-temps=obj来指定中间
文件名基于目标文件而定，并保存在目标文件所在目录下。
}
gcc(打开警告信息){
    你的程序编译通过了，但并不意味着已经万事大吉，也许还存在一些不规范的地方，或者一些错误隐患。
建议，使用-Wall选项打开所有的警告信息，把所有的警告都处理掉。

$ gcc -Wall ...
}

all_option(){
  -pass-exit-codes         在某一阶段退出时返回最高的错误码
  --help                   显示此帮助说明
  --target-help            显示目标机器特定的命令行选项
  --help={common|optimizers|params|target|warnings|[^]{joined|separate|undocumented}}[,...]
                           显示特定类型的命令行选项
  (使用‘-v --help’显示子进程的命令行参数)
  --version                显示编译器版本信息
  -dumpspecs               显示所有内建 spec 字符串
  -dumpversion             显示编译器的版本号
  -dumpmachine             显示编译器的目标处理器
  -print-search-dirs       显示编译器的搜索路径
  -print-libgcc-file-name  显示编译器伴随库的名称
  -print-file-name=<库>    显示 <库> 的完整路径
  -print-prog-name=<程序>  显示编译器组件 <程序> 的完整路径
  -print-multiarch         Display the target normalized GNU triplet, used as
                           a component in the library path
  -print-multi-directory   显示不同版本 libgcc 的根目录
  -print-multi-lib         显示命令行选项和多个版本库搜索路径间的映射
  -print-multi-os-directory 显示操作系统库的相对路径
  -print-sysroot           显示目标库目录
  -print-sysroot-headers-suffix 显示用于寻找头文件的 sysroot 后缀
  -Wa,<选项>               将逗号分隔的 <选项> 传递给汇编器
  -Wp,<选项>               将逗号分隔的 <选项> 传递给预处理器
  -Wl,<选项>               将逗号分隔的 <选项> 传递给链接器
  -Xassembler <参数>       将 <参数> 传递给汇编器
  -Xpreprocessor <参数>    将 <参数> 传递给预处理器
  -Xlinker <参数>          将 <参数> 传递给链接器
  -save-temps              不删除中间文件
  -save-temps=<arg>        不删除中间文件
  -no-canonical-prefixes   生成其他 gcc 组件的相对路径时不生成规范化的
                           前缀
  -pipe                    使用管道代替临时文件
  -time                    为每个子进程计时
  -specs=<文件>            用 <文件> 的内容覆盖内建的 specs 文件
  -std=<标准>              指定输入源文件遵循的标准
  --sysroot=<目录>         将 <目录> 作为头文件和库文件的根目录
  -B <目录>                将 <目录> 添加到编译器的搜索路径中
  -v                       显示编译器调用的程序
  -###                     与 -v 类似，但选项被引号括住，并且不执行命令
  -E                       仅作预处理，不进行编译、汇编和链接
  -S                       编译到汇编语言，不进行汇编和链接
  -c                       编译、汇编到目标代码，不进行链接
  -o <文件>                输出到 <文件>
  -pie                     Create a position independent executable
  -shared                  Create a shared library
  -x <语言>                指定其后输入文件的语言
                           允许的语言包括：c c++ assembler none
                           ‘none’意味着恢复默认行为，即根据文件的扩展名猜测
                           源文件的语言

以 -g、-f、-m、-O、-W 或 --param 开头的选项将由 gcc 自动传递给其调用的
 不同子进程。若要向这些进程传递其他选项，必须使用 -W<字母> 选项。
}

help(warning){
  -W                          不建议使用此开关；请改用 -Wextra
  -Wabi                       当结果与 ABI相容的编译器的编译结果不同时给出警告
  -Wabi-tag                   Warn if a subobject has an abi_tag attribute that 
                              the complete object type does not have
  -Waddress                   使用可疑的内存地址时给出警告                      -Wall
  -Waggregate-return          当返回结构、联合或数组时给出警告
  -Waggressive-loop-optimizations Warn if a loop with constant number of
                              iterations triggers undefined behavior
  -Waliasing                  为可能的虚参重叠给出警告
  -Walign-commons             对 COMMON 块对齐的警告
  -Wall                       启用大部分警告信息
  -Wampersand                 若延续字符常量中缺少 & 则给出警告
  -Warray-bounds              当数组访问越界时给出警告                          -Wall
  -Warray-temporaries         创建临时数组时给出警告
  -Wassign-intercept          当 Objective-C
                              赋值可能为垃圾回收所介入时给出警告
  -Wattributes                当对属性的使用不合适时给出警告
  -Wbad-function-cast         当把函数转换为不兼容类型时给出警告
  -Wbuiltin-macro-redefined   当内建预处理宏未定义或重定义时给出警告
  -Wc++-compat                当在 C 语言中使用了 C 与 C++
                              交集以外的构造时给出警告
  -Wc++0x-compat              Deprecated in favor of -Wc++11-compat             -Wall
  -Wc++11-compat              Warn about C++ constructs whose meaning differs   -Wall
                              between ISO C++ 1998 and ISO C++ 2011
  -Wc-binding-type            Warn if the type of a variable might be not
                              interoperable with C
  -Wcast-align                当转换指针类型导致对齐边界增长时给出警告
  -Wcast-qual                 当类型转换丢失限定信息时给出警告
  -Wchar-subscripts           当下标类型为"char"时给出警告                      -Wall
  -Wcharacter-truncation      对被截断的字符表达式给出警告
  -Wclobbered                 对能为"longjmp"或"vfork"所篡改的变量给出警告
  -Wcomment                   对可能嵌套的注释和长度超过一个物理行长的          -Wall
                              C++ 注释给出警告
  -Wcomments                  -Wcomment 的同义词
  -Wcompare-reals             Warn about equality comparisons involving REAL or
                              COMPLEX expressions
  -Wconversion                当隐式类型转换可能改变值时给出警告
  -Wconversion-extra          对大多数隐式类型转换给出警告
  -Wconversion-null           将 NULL 转换为非指针类型时给出警告
  -Wcoverage-mismatch         Warn in case profiles in -fprofile-use do not
                              match
  -Wcpp                       Warn when a #warning directive is encountered
  -Wctor-dtor-privacy         当所有构造函数和析构函数都是私有时给出警告
  -Wdeclaration-after-statement 当声明出现在语句后时给出警告
  -Wdelete-non-virtual-dtor   Warn about deleting polymorphic objects with non-
                              virtual destructors
  -Wdeprecated                使用不建议的编译器特性、类、方法或字段时给出警告
  -Wdeprecated-declarations   对 __attribute__((deprecated)) 声明给出警告
  -Wdisabled-optimization     当某趟优化被禁用时给出警告
  -Wdiv-by-zero               对编译时发现的零除给出警告
  -Wdouble-promotion          对从"float"到"double"的隐式转换给出警告
  -Weffc++                    对不遵循《Effetive
                              C++》的风格给出警告
  -Wempty-body                当 if 或 else 语句体为空时给出警告
  -Wendif-labels              当 #elif 和 #endif
                              后面跟有其他标识符时给出警告
  -Wenum-compare              对不同枚举类型之间的比较给出警告                  -Wall
  -Werror-implicit-function-declaration 不建议使用此开关；请改用
                              -Werror=implicit-function-declaration
  -Wextra                     打印额外(可能您并不想要)的警告信息
  -Wfloat-equal               当比较浮点数是否相等时给出警告
  -Wformat                    对 printf/scanf/strftime/strfmon                  -Wall
                              中的格式字符串异常给出警告
  -Wformat-contains-nul       当格式字符串包含 NUL 字节时给出警告
  -Wformat-extra-args         当传递给格式字符串的参数太多时给出警告
  -Wformat-nonliteral         当格式字符串不是字面值时给出警告
  -Wformat-security           当使用格式字符串的函数可能导致安全问题时给出警告
  -Wformat-y2k                当 strftime 格式给出 2
                              位记年时给出警告
  -Wformat-zero-length        对长度为 0 的格式字符串给出警告
  -Wformat=                   对 printf/scanf/strftime/strfmon
                              中的格式字符串异常给出警告
  -Wfree-nonheap-object       Warn when attempting to free a non-heap object
  -Wfunction-elimination      Warn about function call elimination
  -Wignored-qualifiers        当类型限定符被忽略时给出警告。
  -Wimplicit                  对隐式函数声明给出警告                            -Wall
  -Wimplicit-function-declaration 对隐式函数声明给出警告                        -Wall
  -Wimplicit-int              当声明未指定类型时给出警告                        -Wall
  -Wimplicit-interface        对带有隐式接口的调用给出警告
  -Wimplicit-procedure        对没有隐式声明的过程调用给出警告
  -Winherited-variadic-ctor   Warn about C++11 inheriting constructors when the
                              base has a variadic constructor
  -Winit-self                 对初始化为自身的变量给出警告。                    -Wall
  -Winline                    当内联函数无法被内联时给出警告
  -Wint-to-pointer-cast       当将一个大小不同的整数转换为指针时给出警告        -Wall
  -Wintrinsic-shadow          如果用户过程有与内建过程相同的名字则警告
  -Wintrinsics-std            当内建函数不是所选标准的一部分时给出警告
  -Winvalid-memory-model      Warn when an atomic memory model parameter is
                              known to be outside the valid range.
  -Winvalid-offsetof          对"offsetof"宏无效的使用给出警告
  -Winvalid-pch               在找到了 PCH
                              文件但未使用的情况给出警告
  -Wjump-misses-init          当跳转略过变量初始化时给出警告
  -Wlarger-than-              此开关缺少可用文档
  -Wlarger-than=<N>           当目标文件大于 N 字节时给出警告
  -Wline-truncation           对被截断的源文件行给出警告
  -Wliteral-suffix            Warn when a string or character literal is
                              followed by a ud-suffix which does not begin with
                              an underscore.
  -Wlogical-op                当逻辑操作结果似乎总为真或假时给出警告            -Wall
  -Wlong-long                 当使用 -pedantic 时不对"long
                              long"给出警告
  -Wmain                      对可疑的"main"声明给出警告                        -Wall
  -Wmaybe-uninitialized       Warn about maybe uninitialized automatic variables-Wall
  -Wmissing-braces            若初始值设定项中可能缺少花括号则给出警告          -Wall
  -Wmissing-declarations      当全局函数没有前向声明时给出警告
  -Wmissing-field-initializers 若结构初始值设定项中缺少字段则给出警告
  -Wmissing-include-dirs      当用户给定的包含目录不存在时给出警告
  -Wmissing-parameter-type    K&R
                              风格函数参数声明中未指定类型限定符时给出警告
  -Wmissing-prototypes        全局函数没有原型时给出警告
  -Wmudflap                   当构造未被 -fmudflap 处理时给出警告
  -Wmultichar                 使用多字节字符集的字符常量时给出警告
  -Wnarrowing                 Warn about narrowing conversions within { } that
                              are ill-formed in C++11
  -Wnested-externs            当"extern"声明不在文件作用域时给出警告
  -Wnoexcept                  Warn when a noexcept expression evaluates to
                              false even though the expression can not actually
                              throw
  -Wnon-template-friend       在模板内声明未模板化的友元函数时给出警告
  -Wnon-virtual-dtor          当析构函数不是虚函数时给出警告
  -Wnonnull                   当将 NULL 传递给需要非 NULL                       -Wall
                              的参数的函数时给出警告
  -Wnormalized=<id|nfc|nfkc>  对未归一化的 Unicode 字符串给出警告
  -Wold-style-cast            程序使用 C
                              风格的类型转换时给出警告
  -Wold-style-declaration     对声明中的过时用法给出警告
  -Wold-style-definition      使用旧式形参定义时给出警告
  -Woverflow                  算术表示式溢出时给出警告
  -Woverlength-strings        当字符串长度超过标准规定的可移植的最大长度时给出警告
  -Woverloaded-virtual        重载虚函数名时给出警告
  -Woverride-init             覆盖无副作用的初始值设定时给出警告
  -Wpacked                    当 packed
                              属性对结构布局不起作用时给出警告
  -Wpacked-bitfield-compat    当紧实位段的偏移量因 GCC 4.4
                              而改变时给出警告
  -Wpadded                    当需要填补才能对齐结构成员时给出警告
  -Wparentheses               可能缺少括号的情况下给出警告
  -Wpedantic                  给出标准指定的所有警告信息
  -Wpmf-conversions           当改变成员函数指针的类型时给出警告
  -Wpointer-arith             当在算术表达式中使用函数指针时给出警告
  -Wpointer-sign              赋值时如指针符号不一致则给出警告
  -Wpointer-to-int-cast       将一个指针转换为大小不同的整数时给出警告
  -Wpragmas                   对错误使用的 pragma 加以警告
  -Wproperty-assign-default   Warn if a property for an Objective-C object has
                              no assign semantics specified
  -Wprotocol                  当继承来的方法未被实现时给出警告
  -Wreal-q-constant           Warn about real-literal-constants with 'q'
                              exponent-letter
  -Wrealloc-lhs               Warn when a left-hand-side array variable is
                              reallocated
  -Wrealloc-lhs-all           Warn when a left-hand-side variable is reallocated
  -Wredundant-decls           对同一个对象多次声明时给出警告
  -Wreorder                   编译器将代码重新排序时给出警告
  -Wreturn-local-addr         Warn about returning a pointer/reference to a
                              local or temporary variable.
  -Wreturn-type               当 C
                              函数的返回值默认为"int"，或者 C++
                              函数的返回类型不一致时给出警告
  -Wselector                  当选择子有多个方法时给出警告
  -Wsequence-point            当可能违反定序点规则时给出警告
  -Wshadow                    当一个局部变量掩盖了另一个局部变量时给出警告
  -Wsign-compare              在有符号和无符号数间进行比较时给出警告
  -Wsign-promo                当重载将无符号数提升为有符号数时给出警告
  -Wsizeof-pointer-memaccess  此开关缺少可用文档
  -Wstack-protector           当因为某种原因堆栈保护失效时给出警告
  -Wstack-usage=              Warn if stack usage might be larger than
                              specified amount
  -Wstrict-aliasing           当代码可能破坏强重叠规则时给出警告
  -Wstrict-aliasing=          当代码可能破坏强重叠规则时给出警告
  -Wstrict-null-sentinel      将未作转换的 NULL
                              用作哨兵时给出警告
  -Wstrict-overflow           禁用假定有符号数溢出行为未被定义的优化
  -Wstrict-overflow=          禁用假定有符号数溢出行为未被定义的优化
  -Wstrict-prototypes         使用了非原型的函数声明时给出警告
  -Wstrict-selector-match     当备选方法的类型签字不完全匹配时给出警告
  -Wsuggest-attribute=const   Warn about functions which might be candidates
                              for __attribute__((const))
  -Wsuggest-attribute=format  当函数可能是 format
                              属性的备选时给出警告
  -Wsuggest-attribute=noreturn 当函数可能是 __attribute__((noreturn))
                              的备选时给出警告
  -Wsuggest-attribute=pure    Warn about functions which might be candidates
                              for __attribute__((pure))
  -Wsurprising                对"可疑"的构造给出警告
  -Wswitch                    当使用枚举类型作为开关变量，没有提供
                              default 分支，但又缺少某个 case
                              时给出警告
  -Wswitch-default            当使用枚举类型作为开关变量，但没有提供"default"分支时给出警告
  -Wswitch-enum               当使用枚举类型作为开关变量但又缺少某个
                              case 时给出警告
  -Wsync-nand                 当 __sync_fetch_and_nand 和
                              __sync_nand_and_fetch
                              内建函数被使用时给出警告
  -Wsynth                     不建议使用。此开关不起作用。
  -Wsystem-headers            不抑制系统头文件中的警告
  -Wtabs                      允许使用不符合规范的制表符
  -Wtarget-lifetime           Warn if the pointer in a pointer assignment might
                              outlive its target
  -Wtraditional               使用了传统 C
                              不支持的特性时给出警告
  -Wtraditional-conversion    原型导致的类型转换与无原型时的类型转换不同时给出警告
  -Wtrampolines               Warn whenever a trampoline is generated
  -Wtrigraphs                 当三字母序列可能影响程序意义时给出警告
  -Wtype-limits               当由于数据类型范围限制比较结果永远为真或假时给出警告
  -Wundeclared-selector       当使用 @selector()
                              却不作事先声明时给出警告
  -Wundef                     当 #if
                              指令中用到未定义的宏时给出警告
  -Wunderflow                 数字常量表达式下溢时警告
  -Wuninitialized             自动变量未初始化时警告
  -Wunknown-pragmas           对无法识别的 pragma 加以警告
  -Wunsafe-loop-optimizations 当循环因为不平凡的假定而不能被优化时给出警告
  -Wunsuffixed-float-constants 对不带后缀的浮点常量给出警告
  -Wunused                    启用所有关于"XX未使用"的警告
  -Wunused-but-set-parameter  Warn when a function parameter is only set,
                              otherwise unused
  -Wunused-but-set-variable   Warn when a variable is only set, otherwise unused
  -Wunused-dummy-argument     对未使用的哑元给出警告。
  -Wunused-function           有未使用的函数时警告
  -Wunused-label              有未使用的标号时警告
  -Wunused-local-typedefs     Warn when typedefs locally defined in a function
                              are not used
  -Wunused-macros             当定义在主文件中的宏未被使用时给出警告
  -Wunused-parameter          发现未使用的函数指针时给出警告
  -Wunused-result             当一个带有 warn_unused_result
                              属性的函数的调用者未使用前者的返回值时给出警告
  -Wunused-value              当一个表达式的值未被使用时给出警告
  -Wunused-variable           有未使用的变量时警告
  -Wuseless-cast              Warn about useless casts
  -Wvarargs                   Warn about questionable usage of the macros used
                              to retrieve variable arguments
  -Wvariadic-macros           Warn about using variadic macros
  -Wvector-operation-performance Warn when a vector operation is compiled
                              outside the SIMD
  -Wvirtual-move-assign       Warn if a virtual base has a non-trivial move
                              assignment operator
  -Wvla                       使用变长数组时警告
  -Wvolatile-register-var     当一个寄存器变量被声明为 volatile
                              时给出警告
  -Wwrite-strings             在 C++
                              中，非零值表示将字面字符串转换为‘char
                              *’时给出警告。在 C
                              中，给出相似的警告，但这种类型转换是符合
                              ISO C 标准的。
  -Wzero-as-null-pointer-constant Warn when a literal '0' is used as null
                              pointer
  -frequire-return-statement  Functions which return values must end with
                              return statements
}

help(common){
下列选项与具体语言无关:
  --debug                     此开关缺少可用文档
  --dump                      此开关缺少可用文档
  --dump=                     此开关缺少可用文档
  --dumpbase                  此开关缺少可用文档
  --dumpdir                   此开关缺少可用文档
  --extra-warnings            此开关缺少可用文档
  --help                      显示此信息
  --help=<类型>             显示一或多项特定类型选项的描述。类型可能是
                              optimizers、target、warnings、undocumented 或
                              params
  --no-warnings               此开关缺少可用文档
  --optimize                  此开关缺少可用文档
  --output                    此开关缺少可用文档
  --output=                   此开关缺少可用文档
  --param <参数>=<值>      将参数参数设为给定值。下面给出所有参数的列表
  --param=                    此开关缺少可用文档
  --pedantic                  此开关缺少可用文档
  --pedantic-errors           此开关缺少可用文档
  --profile                   此开关缺少可用文档
  --target-help               --help=target 的别名
  --verbose                   此开关缺少可用文档
  --version                   此开关缺少可用文档
  -O<N>                       将优化等级设为 N
  -Ofast                      为速度优化，不严格遵守标准
  -Og                         Optimize for debugging experience rather than
                              speed or size
  -Os                         为最小空间而不是最大速度优化
  -W                          不建议使用此开关；请改用 -Wextra
  -Waggregate-return          当返回结构、联合或数组时给出警告
  -Waggressive-loop-optimizations Warn if a loop with constant number of
                              iterations triggers undefined behavior
  -Warray-bounds              当数组访问越界时给出警告
  -Wattributes                当对属性的使用不合适时给出警告
  -Wcast-align                当转换指针类型导致对齐边界增长时给出警告
  -Wcoverage-mismatch         Warn in case profiles in -fprofile-use do not
                              match
  -Wcpp                       Warn when a #warning directive is encountered
  -Wdeprecated-declarations   对 __attribute__((deprecated)) 声明给出警告
  -Wdisabled-optimization     当某趟优化被禁用时给出警告
  -Werror                     所有的警告都当作是错误
  -Werror=                    将指定的警告当作错误
  -Wextra                     打印额外(可能您并不想要)的警告信息
  -Wfatal-errors              发现第一个错误时即退出
  -Wframe-larger-than=<N>     当一个函数的堆栈框架需要多于 N
                              字节的内存时给出警告
  -Wfree-nonheap-object       Warn when attempting to free a non-heap object
  -Winline                    当内联函数无法被内联时给出警告
  -Winvalid-memory-model      Warn when an atomic memory model parameter is
                              known to be outside the valid range.
  -Wlarger-than-              此开关缺少可用文档
  -Wlarger-than=<N>           当目标文件大于 N 字节时给出警告
  -Wmaybe-uninitialized       Warn about maybe uninitialized automatic variables
  -Wmissing-noreturn          此开关缺少可用文档
  -Woverflow                  算术表示式溢出时给出警告
  -Wpacked                    当 packed
                              属性对结构布局不起作用时给出警告
  -Wpadded                    当需要填补才能对齐结构成员时给出警告
  -Wpedantic                  给出标准指定的所有警告信息
  -Wshadow                    当一个局部变量掩盖了另一个局部变量时给出警告
  -Wstack-protector           当因为某种原因堆栈保护失效时给出警告
  -Wstack-usage=              Warn if stack usage might be larger than
                              specified amount
  -Wstrict-aliasing           当代码可能破坏强重叠规则时给出警告
  -Wstrict-aliasing=          当代码可能破坏强重叠规则时给出警告
  -Wstrict-overflow           禁用假定有符号数溢出行为未被定义的优化
  -Wstrict-overflow=          禁用假定有符号数溢出行为未被定义的优化
  -Wsuggest-attribute=const   Warn about functions which might be candidates
                              for __attribute__((const))
  -Wsuggest-attribute=noreturn 当函数可能是 __attribute__((noreturn))
                              的备选时给出警告
  -Wsuggest-attribute=pure    Warn about functions which might be candidates
                              for __attribute__((pure))
  -Wsystem-headers            不抑制系统头文件中的警告
  -Wtrampolines               Warn whenever a trampoline is generated
  -Wtype-limits               当由于数据类型范围限制比较结果永远为真或假时给出警告
  -Wuninitialized             自动变量未初始化时警告
  -Wunreachable-code          不起作用。为向前兼容保留的选项。
  -Wunsafe-loop-optimizations 当循环因为不平凡的假定而不能被优化时给出警告
  -Wunused                    启用所有关于"XX未使用"的警告
  -Wunused-but-set-parameter  Warn when a function parameter is only set,
                              otherwise unused
  -Wunused-but-set-variable   Warn when a variable is only set, otherwise unused
  -Wunused-function           有未使用的函数时警告
  -Wunused-label              有未使用的标号时警告
  -Wunused-parameter          发现未使用的函数指针时给出警告
  -Wunused-value              当一个表达式的值未被使用时给出警告
  -Wunused-variable           有未使用的变量时警告
  -Wvector-operation-performance Warn when a vector operation is compiled
                              outside the SIMD
  -aux-info <文件>          将声明信息写入文件
  -aux-info=                  此开关缺少可用文档
  -auxbase                    此开关缺少可用文档
  -auxbase-strip              此开关缺少可用文档
  -d<字母>                  为指定的某趟汇译启用内存转储
  -dumpbase <文件>          设定内存转储使用的文件基本名
  -dumpdir <目录>           设定内存转储使用的目录名
  -fPIC                       尽可能生成与位置无关的代码(大模式)
  -fPIE                       为可执行文件尽可能生成与位置无关的代码(大模式)
  -fabi-version=              此开关缺少可用文档
  -faggressive-loop-optimizations Aggressively optimize loops using language
                              constraints
  -falign-functions           对齐函数入口
  -falign-functions=          此开关缺少可用文档
  -falign-jumps               对齐只能为跳转所到达的标号
  -falign-jumps=              此开关缺少可用文档
  -falign-labels              对齐所有的标号
  -falign-labels=             此开关缺少可用文档
  -falign-loops               对齐循环入口
  -falign-loops=              此开关缺少可用文档
  -fargument-alias            不起作用。为向前兼容保留的选项。
  -fargument-noalias          不起作用。为向前兼容保留的选项。
  -fargument-noalias-anything 不起作用。为向前兼容保留的选项。
  -fargument-noalias-global   不起作用。为向前兼容保留的选项。
  -fassociative-math          Allow optimization for floating-point arithmetic
                              which may change the result of the operation due
                              to rounding.
  -fasynchronous-unwind-tables 生成精确到每条指令边界的堆栈展开表
  -fauto-inc-dec              生成 auto-inc/dec指令
  -fbounds-check              生成检查数组访问是否越界的代码
  -fbranch-count-reg          将加/减法、比较、跳转指令序列替换为根据计数寄存器跳转指令
  -fbranch-probabilities      为分支概率使用取样信息
  -fbranch-target-load-optimize 在开始/结末线程前进行分支目标载入优化
  -fbranch-target-load-optimize2 在开始/结末线程后进行分支目标载入优化
  -fbtr-bb-exclusive          限制目标载入融合不重用任何基本块中的寄存器
  -fcall-saved-<寄存器>    认为寄存器在函数调用后值不变
  -fcall-used-<寄存器>     认为寄存器的值将被函数调用所改变
  -fcaller-saves              函数调用前后保存/恢复寄存器值
  -fcheck-data-deps           比较几个数据依赖分析的结果。
  -fcombine-stack-adjustments Looks for opportunities to reduce stack
                              adjustments and stack references.
  -fcommon                    不将未初始化的全局数据放在公共节中
  -fcompare-debug-second      只为 -fcompare-debug 运行第二遍编译
  -fcompare-debug[=<选项>]  分别在带与不带"选项"，例如
                              -gtoggle，的情况下编译，然后比较最后的指令输出
  -fcompare-elim              Perform comparison elimination after register
                              allocation has finished
  -fconserve-stack            不进行可能导致堆栈使用明显增长的优化
  -fcprop-registers           进行一趟寄存器副本传递优化
  -fcrossjumping              进行跨跳转优化
  -fcse-follow-jumps          进行 CSE 时，跟随跳转至目标
  -fcse-skip-blocks           不起作用。为向前兼容保留的选项。
  -fcx-fortran-rules          复数乘除遵循 Fortran 规则
  -fcx-limited-range          当进行复数除法时省略缩减范围的步骤
  -fdata-sections             将每个数据项分别放在它们各自的节中
  -fdbg-cnt-list              列出所有可用的调试计数器及其极限和计数。
  -fdbg-cnt=<计数器>:<极限>[,<计数器>:<极限>,...] 设定调试计数器极限。
  -fdce                       使用 RTL 死代码清除
  -fdebug-prefix-map=         在调试信息中将一个目录名映射到另一个
  -fdebug-types-section       Output .debug_types section when using DWARF v4
                              debuginfo.
  -fdefer-pop                 延迟将函数实参弹栈
  -fdelayed-branch            尝试填充分支指令的延迟槽
  -fdelete-dead-exceptions    Delete dead instructions that may throw exceptions
  -fdelete-null-pointer-checks 删除无用的空指针检查
  -fdevirtualize              Try to convert virtual calls to direct ones.
  -fdiagnostics-color         此开关缺少可用文档
  -fdiagnostics-color=[never|always|auto] Colorize diagnostics
  -fdiagnostics-show-caret    Show the source line with a caret indicating the
                              column
  -fdiagnostics-show-location=[once|every-line] 指定在自动换行的诊断信息开始给出源位置的频率
  -fdiagnostics-show-option   在诊断信息后输出控制它们的命令行选项
  -fdisable-                  -fdisable-[tree|rtl|ipa]-<pass>=range1+range2
                              disables an optimization pass
  -fdse                       使用 RTL 死存储清除
  -fdump-<类型>             将一些编译器内部信息转储到一个文件里
  -fdump-final-insns=文件名 在翻译完毕后将指令输出到文件中
  -fdump-go-spec=filename     Write all declarations to file as Go code
  -fdump-noaddr               在调试转储中不输出地址
  -fdump-passes               Dump optimization passes
  -fdump-unnumbered           在调试转储中不输出指令数、行号标记和地址
  -fdump-unnumbered-links     在调试转储中不输出前一条和后一条指令号码
  -fdwarf2-cfi-asm            用 GAS 汇编指示来启用 CFI 表
  -fearly-inlining            进行早内联
  -feliminate-dwarf2-dups     进行 DWARF2 冗余消除
  -feliminate-unused-debug-symbols 在调试信息中进行无用类型消除
  -feliminate-unused-debug-types 在调试信息中进行无用类型消除
  -femit-class-debug-always   保留 C++ 类调试信息。
  -fenable-                   -fenable-[tree|rtl|ipa]-<pass>=range1+range2
                              enables an optimization pass
  -fexceptions                启用异常处理
  -fexcess-precision=[fast|standard] 指定如何处理有额外精度的浮点数
  -fexpensive-optimizations   进行一些细微的、代价高昂的优化
  -ffast-math                 此开关缺少可用文档
  -ffat-lto-objects           Output lto objects containing both the
                              intermediate language and binary output.
  -ffinite-math-only          假定结果不会是 NaN 或无穷大浮点数
  -ffixed-<寄存器>         认为寄存器对编译器而言不可用
  -ffloat-store               不将单精度和双精度浮点数分配到扩展精度的寄存器中
  -fforce-addr                不起作用。为向前兼容保留的选项。
  -fforward-propagate         进行 RTL 上的前向传递
  -ffp-contract=              -ffp-contract=[off|on|fast] Perform floating-
                              point expression contraction.
  -ffunction-cse              允许将函数地址保存在寄存器中
  -ffunction-sections         将每个函数分别放在它们各自的节中
  -fgcse                      进行全局公共子表达式消除
  -fgcse-after-reload         Perform global common subexpression elimination
                              after register allocation has finished
  -fgcse-las                  Perform redundant load after store elimination in
                              global common subexpression elimination
  -fgcse-lm                   在全局公共子表达式消除中进行增强的读转移优化
  -fgcse-sm                   在全局公共子表达式消除后进行存储转移
  -fgnu-tm                    Enable support for GNU transactional memory
  -fgnu-unique                Use STB_GNU_UNIQUE if supported by the assembler
  -fgraphite                  启用 Graphite 表示的输入输出
  -fgraphite-identity         启用 Graphite 身份转换
  -fguess-branch-probability  启用分支概率猜测
  -fhelp                      此开关缺少可用文档
  -fhelp=                     此开关缺少可用文档
  -fhoist-adjacent-loads      Enable hoisting adjacent loads to encourage
                              generating conditional move instructions
  -fident                     处理 #ident 指令
  -fif-conversion             将条件跳转替换为没有跳转的等值表示
  -fif-conversion2            将条件跳转替换为条件执行
  -findirect-inlining         进行间接内联
  -finhibit-size-directive    不生成 .size 伪指令
  -finline                    Enable inlining of function declared "inline",
                              disabling disables all inlining
  -finline-atomics            Inline __atomic operations when a lock free
                              instruction sequence is available.
  -finline-functions          Integrate functions not declared "inline" into
                              their callers when profitable
  -finline-functions-called-once Integrate functions only required by their
                              single caller
  -finline-limit-             此开关缺少可用文档
  -finline-limit=<N>          将内联函数的大小限制在 N 以内
  -finline-small-functions    Integrate functions into their callers when code
                              size is known not to grow
  -finstrument-functions      在函数入口和出口加入取样调用
  -finstrument-functions-exclude-file-list= -finstrument-functions-exclude-file-
                              list=文件名,... 
                              取样时排除列出的文件中的函数
  -finstrument-functions-exclude-function-list= -finstrument-functions-exclude-
                              function-list=函数名,... 
                              取样时排除列出的函数
  -fipa-cp                    进行进程间的复写传递
  -fipa-cp-clone              进行复制以使跨进程常量传递更有效
  -fipa-matrix-reorg          不起作用。为向前兼容保留的选项。
  -fipa-profile               Perform interprocedural profile propagation
  -fipa-pta                   进行进程间的指向分析
  -fipa-pure-const            发现纯函数和常函数
  -fipa-reference             发现只读和不可寻址静态变量
  -fipa-sra                   为聚合类型进行跨进程标量替换
  -fipa-struct-reorg          不起作用。为向前兼容保留的选项。
  -fira-algorithm=            -fira-algorithm=|CB|priority] 设置使用的 IRA
                              算法
  -fira-hoist-pressure        Use IRA based register pressure calculation in
                              RTL hoist optimizations.
  -fira-loop-pressure         Use IRA based register pressure calculation in
                              RTL loop optimizations.
  -fira-region=               -fira-region=[one|all|mixed] 设置 IRA 的区域
  -fira-share-save-slots      为保存不同的硬寄存器的共享槽。
  -fira-share-spill-slots     为溢出的伪寄存器共享堆栈槽。
  -fira-verbose=<N>           控制 IRA 诊断信息的级别。
  -fivopts                    在树上优化归纳变量
  -fjump-tables               为足够大的 switch 语句使用跳转表
  -fkeep-inline-functions     为完全内联的函数生成代码
  -fkeep-static-consts        保留未用到的静态常量
  -fleading-underscore        给外部符号添加起始的下划线
  -floop-block                启用循环分块转换
  -floop-flatten              不起作用。为向前兼容保留的选项。
  -floop-interchange          启用循环交换转换
  -floop-nest-optimize        Enable the ISL based loop nest optimizer
  -floop-optimize             不起作用。为向前兼容保留的选项。
  -floop-parallelize-all      将所有循环标记为并行
  -floop-strip-mine           启用循环条带开采转换
  -flto                       启用链接时优化。
  -flto-compression-level=<N> 为 IL 使用 zlib 压缩级别 N
  -flto-partition=1to1        Partition symbols and vars at linktime based on
                              object files they originate from
  -flto-partition=balanced    Partition functions and vars at linktime into
                              approximately same sized buckets
  -flto-partition=max         Put every symbol into separate partition
  -flto-partition=none        Disable partioning and streaming
  -flto-report                报告各种链接时优化统计
  -flto=                      Link-time optimization with number of parallel
                              jobs or jobserver.
  -fmath-errno                执行内建数学函数后设置 errno
  -fmax-errors=<n>            报告错误数量的上限值
  -fmem-report                报告永久性内存分配
  -fmem-report-wpa            Report on permanent memory allocation in WPA only
  -fmerge-all-constants       试图合并相同的常量和常变量
  -fmerge-constants           试图合并不同编译单元中的相同常量
  -fmerge-debug-strings       试图合并不同编译单元中的相同调试字符串
  -fmessage-length=<N>        将诊断信息限制在每行 N 个字符。0
                              取消自动换行
  -fmodulo-sched              在首趟调度前进行基于 SMS 的模调度
  -fmodulo-sched-allow-regmoves 进行基于 SMS
                              且允许寄存器转移的模调度
  -fmove-loop-invariants      将每次循环中不变的计算外提
  -fnon-call-exceptions       支持同步非调用异常
  -fomit-frame-pointer        尽可能不生成栈帧
  -fopt-info                  Enable all optimization info dumps on stderr
  -fopt-info[-<type>=filename] Dump compiler optimization details
  -foptimize-register-move    进行全寄存器传送优化
  -foptimize-sibling-calls    优化同级递归和尾递归
  -foptimize-strlen           Enable string length optimizations on trees
  -fpack-struct               将结构成员不带间隔地紧实存放
  -fpack-struct=<N>           设定结构成员最大对齐边界的初始值
  -fpartial-inlining          进行部分内联
  -fpcc-struct-return         在内存而不是寄存器中返回小聚合
  -fpeel-loops                进行循环剥离
  -fpeephole                  启用机器相关的窥孔优化
  -fpeephole2                 在 sched2 前进行一趟 RTL 窥孔优化
  -fpic                       尽可能生成与位置无关的代码(小模式)
  -fpie                       为可执行文件尽可能生成与位置无关的代码(小模式)
  -fplugin-arg-<插件>-<键>[=<值>] 为插件指定参数键=值
  -fplugin=                   指定要加载的插件
  -fpost-ipa-mem-report       在跨进程优化前报告内存分配
  -fpre-ipa-mem-report        在跨进程优化前报告内存分配
  -fpredictive-commoning      启用预测公因子优化。
  -fprefetch-loop-arrays      如果可用，为循环中的数组生成预取指令
  -fprofile                   启用基本程序取样代码
  -fprofile-arcs              插入基于弧的程序取样代码
  -fprofile-correction        启用对流不一致取样数据输入的修正
  -fprofile-dir=              Set the top-level directory for storing the
                              profile data. The default is 'pwd'.
  -fprofile-generate          启用一些公共选项来生成样本文件，以便进行基于取样的优化
  -fprofile-generate=         启用生成取样信息的公共选项以支持基于取样反馈的优化，同时设置
                              -fprofile-dir=
  -fprofile-report            Report on consistency of profile
  -fprofile-use               启用一些公共选项以进行基于取样的优化
  -fprofile-use=              启用公共选项以进行基于取样反馈的优化，同时设置
                              -fprofile-dir=
  -fprofile-values            为取样表达式的值插入相关代码
  -frandom-seed               此开关缺少可用文档
  -frandom-seed=<字符串>   使用字符串使编译可以复现
  -freciprocal-math           与 -fassociative-math
                              相同，作用于包含除法的表达式。
  -frecord-gcc-switches       在目标文件中记录 gcc 命令行开关。
  -free                       Turn on Redundant Extensions Elimination pass.
  -freg-struct-return         在寄存器中返回小聚合
  -fregmove                   启用寄存器传送优化
  -frename-registers          进行寄存器重命名优化
  -freorder-blocks            基本块重新排序以改善代码布局
  -freorder-blocks-and-partition 对基本块重新排序并划分为热区和冷区
  -freorder-functions         函数重新排序以改善代码布局
  -frerun-cse-after-loop      在循环优化结束后增加一趟公共子表达式消除
  -frerun-loop-opt            不起作用。为向前兼容保留的选项。
  -freschedule-modulo-scheduled-loops 启用/禁用已经通过模调度的循环中的传统调度
  -frounding-math             禁用假定默认浮点舍入行为的优化
  -fsanitize=address          Enable AddressSanitizer, a memory error detector
  -fsanitize=thread           Enable ThreadSanitizer, a data race detector
  -fsched-critical-path-heuristic 为调度器启用关键路径启发式发现
  -fsched-dep-count-heuristic 为调度器启用依赖计数启发式发现
  -fsched-group-heuristic     在调度器中启用组启发
  -fsched-interblock          启用基本块间的调度
  -fsched-last-insn-heuristic 为调度器启用最近指令启发式发现
  -fsched-pressure            启用对寄存器压力敏感的指令调度
  -fsched-rank-heuristic      在调度器中启用秩启发
  -fsched-spec                允许非载入的投机移动
  -fsched-spec-insn-heuristic 为调度器启用投机指令启发式发现
  -fsched-spec-load           允许一些载入的投机移动
  -fsched-spec-load-dangerous 允许更多载入的投机移动
  -fsched-stalled-insns       允许对队列中的指令进行早调度
  -fsched-stalled-insns-dep   设置排队中指令的进行早调度的依赖距离检查
  -fsched-stalled-insns-dep=<N> 设置排队中指令的进行早调度的依赖距离检查
  -fsched-stalled-insns=<N>   指定能被早期调度的在排队中的指令的最大数量
  -fsched-verbose=<N>         指定调度器的冗余级别
  -fsched2-use-superblocks    在重载后调度中使用跨基本块调度
  -fsched2-use-traces         不起作用。为向前兼容保留的选项。
  -fschedule-insns            分配寄存器前重新调度指令
  -fschedule-insns2           分配寄存器后重新调度指令
  -fsection-anchors           从共享的锚点访问在同样的节中的数据
  -fsee                       不起作用。为向前兼容保留的选项。
  -fsel-sched-pipelining      在选择性调度中对内层循环进行软件流水化
  -fsel-sched-pipelining-outer-loops 在选择性调度中对外层循环进行软件流水化
  -fsel-sched-reschedule-pipelined 重新调度没有被流水线化的流水线区域
  -fselective-scheduling      用选择性调度算法调度指令
  -fselective-scheduling2     在重加载后使用选择性调度
  -fshow-column               诊断信息中给出行号。默认打开
  -fshrink-wrap               Emit function prologues only before parts of the
                              function that need it, rather than at the top of
                              the function.
  -fsignaling-nans            禁用为 IEEE NaN 可见的优化
  -fsigned-zeros              禁用忽略 IEEE 中零的符号的浮点优化
  -fsingle-precision-constant 将浮点常量转换为单精度常量
  -fsplit-ivs-in-unroller     展开循环时分离归纳变量的生存期
  -fsplit-stack               Generate discontiguous stack frames
  -fsplit-wide-types          将宽类型分割到独立的寄存器中
  -fstack-check               在程序中插入检查栈溢出的代码。与
                              fstack-check=specific 相同
  -fstack-check=[no|generic|specific] Insert stack checking code into the
                              program.
  -fstack-clash-protection    Insert code to probe each page of stack space as
                              it is allocated to protect from stack-clash style
                              attacks.
  -fstack-limit               此开关缺少可用文档
  -fstack-limit-symbol=<寄存器> 当堆栈越过寄存器时引发陷阱
  -fstack-limit-symbol=<符号> 当堆栈越过符号时引发陷阱
  -fstack-protector           使用 propolice 来保护堆栈
  -fstack-protector-all       为每个函数使用堆栈保护机制
  -fstack-protector-strong    Use a smart stack protection method for certain
                              functions
  -fstack-reuse=              -fstack-reuse=[all|named_vars|none] Set stack
                              reuse level for local variables.
  -fstack-usage               Output stack usage information on a per-function
                              basis
  -fstrength-reduce           不起作用。为向前兼容保留的选项。
  -fstrict-aliasing           假定应用强重叠规则
  -fstrict-overflow           将有符号数溢出的行为视为未定义的
  -fstrict-volatile-bitfields Force bitfield accesses to match their type width
  -fsync-libcalls             Implement __atomic operations via libcalls to
                              legacy __sync functions
  -fsyntax-only               检查语法错误，然后停止
  -ftarget-help               此开关缺少可用文档
  -ftest-coverage             生成"gcov"需要的数据文件
  -fthread-jumps              进行跳转线程优化
  -ftime-report               报告每趟汇编的耗时
  -ftls-model=[global-dynamic|local-dynamic|initial-exec|local-exec] 设定默认的线程局部存储代码生成模式
  -ftoplevel-reorder          重新排序文件作用域的函数、变量和汇编
  -ftracer                    通过尾复制进行超块合成
  -ftrapping-math             假定浮点运算可能引发陷阱
  -ftrapv                     加法、减法或乘法溢出时激活陷阱
  -ftree-bit-ccp              Enable SSA-BIT-CCP optimization on trees
  -ftree-builtin-call-dce     为内建函数启用有条件的死代码消除优化
  -ftree-ccp                  启用树上的 SSA-CCP 优化
  -ftree-ch                   启用树上的循环不变量转移
  -ftree-coalesce-inlined-vars Enable coalescing of copy-related user variables
                              that are inlined
  -ftree-coalesce-vars        Enable coalescing of all copy-related user
                              variables
  -ftree-copy-prop            在树级别进行复写传递
  -ftree-copyrename           将 SSA
                              临时变量重命名为更易理解的名称
  -ftree-cselim               将条件存储转换为非条件存储
  -ftree-dce                  启用树上的 SSA 死代码消除优化
  -ftree-dominator-opts       启用主导优化
  -ftree-dse                  删除死存储
  -ftree-forwprop             在树级别进行前向复写传递
  -ftree-fre                  启用树上的完全冗余消除(FRE)
  -ftree-loop-distribute-patterns Enable loop distribution for patterns
                              transformed into a library call
  -ftree-loop-distribution    在树上进行循环分配
  -ftree-loop-if-convert      Convert conditional jumps in innermost loops to
                              branchless equivalents
  -ftree-loop-if-convert-stores 将包含内存写入的条件跳转转换为不带分支的等效形式
  -ftree-loop-im              启用树上的循环不变量转移
  -ftree-loop-ivcanon         在循环中生成正规的归纳变量
  -ftree-loop-linear          Enable loop interchange transforms.  Same as
                              -floop-interchange
  -ftree-loop-optimize        在树级别进行循环优化
  -ftree-lrs                  在 SSA->normal 过程中分离活动范围
  -ftree-parallelize-loops=   启用循环的自动并行化
  -ftree-partial-pre          In SSA-PRE optimization on trees, enable partial-
                              partial redundancy elimination
  -ftree-phiprop              为条件指针外提内存读取操作。
  -ftree-pre                  启用树上的 SSA-PRE 优化
  -ftree-pta                  在树上进行函数内的指向分析。
  -ftree-reassoc              在树级别进行重结合
  -ftree-salias               不起作用。为向前兼容保留的选项。
  -ftree-scev-cprop           为标量演化信息进行复写传递。
  -ftree-sink                 启用树上的 SSA 代码下沉优化
  -ftree-slp-vectorize        在树上进行基本块向量化(SLP)
  -ftree-slsr                 Perform straight-line strength reduction
  -ftree-sra                  为聚合类型进行标量替换
  -ftree-store-ccp            不起作用。为向前兼容保留的选项。
  -ftree-store-copy-prop      不起作用。为向前兼容保留的选项。
  -ftree-switch-conversion    转换开关初始化
  -ftree-tail-merge           Enable tail merging on trees
  -ftree-ter                  在 SSA->normal 过程中替换临时表达式
  -ftree-vect-loop-version    在树上进行循环向量化时启用多版本循环
  -ftree-vectorize            在树上进行循环向量化
  -ftree-vectorizer-verbose=<number> This switch is deprecated. Use -fopt-info
                              instead.
  -ftree-vrp                  进行树上的值域传递
  -funit-at-a-time            一次编译一整个编译单元
  -funroll-all-loops          展开所有循环
  -funroll-loops              展开所有迭代次数已知的循环
  -funsafe-loop-optimizations 允许假定循环以"正常"方式动作的循环优化
  -funsafe-math-optimizations 允许可能违反 IEEE 或 ISO 标准的优化
  -funswitch-loops            外提循环内的测试语句
  -funwind-tables             仅为异常处理生成堆栈展开表
  -fuse-ld=bfd                Use the bfd linker instead of the default linker
  -fuse-ld=gold               Use the gold linker instead of the default linker
  -fuse-linker-plugin         此开关缺少可用文档
  -fvar-tracking              进行变量跟踪
  -fvar-tracking-assignments  评注赋值以进行变量跟踪
  -fvar-tracking-assignments-toggle 切换 -fvar-tracking-assignments
  -fvar-tracking-uninit       进行变量追踪并且标记未被初始化的变量
  -fvariable-expansion-in-unroller 展开循环时也展开变量
  -fvect-cost-model           启用向量化开销模型
  -fverbose-asm               为汇编输出添加额外注释
  -fversion                   此开关缺少可用文档
  -fvisibility=[default|internal|hidden|protected] 设置符号的默认可见性
  -fvpt                       在优化中使用表达式值样本提供的信息
  -fweb                       建立关系网并且分离对同一变量的无关应用
  -fwhole-program             进行全程序优化
  -fwrapv                     假定有符号运算溢出时回绕
  -fzee                       不起作用。为向前兼容保留的选项。
  -fzero-initialized-in-bss   将初始化为零的数据存放在 bss 节中
  -g                          生成默认格式的调试信息
  -gcoff                      生成 COFF 格式的调试信息
  -gdwarf-                    生成 DWARF v2(或更新)格式的调试信息
  -ggdb                       生成默认扩展格式的调试信息
  -gno-pubnames               Don not generate DWARF pubnames and pubtypes
                              sections.
  -gno-record-gcc-switches    Don not record gcc command line switches in DWARF
                              DW_AT_producer.
  -gno-split-dwarf            Don not generate debug information in separate .dwo
                              files
  -gno-strict-dwarf           生成较所选版本更先进的 DWARF
                              附加信息
  -gpubnames                  Generate DWARF pubnames and pubtypes sections.
  -grecord-gcc-switches       Record gcc command line switches in DWARF
                              DW_AT_producer.
  -gsplit-dwarf               Generate debug information in separate .dwo files
  -gstabs                     生成 STABS 格式的调试信息
  -gstabs+                    生成扩展 STABS 格式的调试信息
  -gstrict-dwarf              不生成较所选版本更先进的 DWARF
                              附加信息
  -gtoggle                    切换调试信息生成
  -gvms                       生成 VMS 格式的调试信息
  -gxcoff                     生成 XCOFF 格式的调试信息
  -gxcoff+                    生成 XCOFF 扩展格式的调试信息
  -imultiarch <dir>           Set <dir> to be the multiarch include subdirectory
  -iplugindir=<目录>        将目录设定为默认的插件子目录
  -o <文件>                 将输出写入文件
  -p                          启用函数取样
  -pedantic                   此开关缺少可用文档
  -pedantic-errors            与 -pedantic 类似，但将它们视作错误
  -quiet                      不显示编译的函数或逝去的时间
  -v                          启用详细输出
  -version                    显示编译器版本
  -w                          不显示警告
}