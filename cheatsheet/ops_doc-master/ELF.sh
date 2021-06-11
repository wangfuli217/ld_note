elf(man elf)
{
    objdump和readelf都可以用来查看二进制文件的一些内部信息. 区别在于objdump
借助BFD而更加通用一些, 可以应付不同文件格式, readelf则并不借助BFD, 
而是直接读取ELF格式文件的信息, 按readelf手册页上所说, 得到的信息也略细致一些.

1. 反汇编代码
查看源代码被翻译成的汇编代码, 大概有3种方法, 
1) 通过编译器直接从源文件生成, 如gcc -S 
2) 对目标代码反汇编, 一种是静态反汇编, 就是使用objdump
3) 另外一种就是对运行时的代码反汇编, 一般通过gdb
readelf并不提供反汇编功能.


objdump和readelf实用程序可分别用于显示目标文件（对objdump而言）和ELF文件（对readelf而言）中的任何信息。
我们可以借助于命令行参数使用命令来查看给定目标文件的文件头、文件大小及结构。
}

nm(http://www.kuqin.com/aixcmds/aixcmds4/index.html)
{
实用程序nm可以列出指定目标文件中的符号，它能够显示符号的值、类型和名字，
虽然不如其他实用程序一样有用，但调试库文件时却能大显身手。

#nm 命令使用以下符号（用同样的字符表示弱符号作为全局符号）之一来表示文件符号类型：
nm 命令把以下符号信息写入标准输出：
    1. 库或对象名
    2. 如果您指定了 -A 选项，则 nm 命令 只报告与该文件有关的或者库或者对象名。
    3. 符号名称
    4. 符号类型
    5. 值
    6. 大小
    
[符号类型]    
A 	Global absolute 符号。
a 	Local absolute 符号。
B 	Global bss 符号。
b 	Local bss 符号。
D 	Global data 符号。
d 	Local data 符号。
f 	源文件名称符号。
T 	Global text 符号。
t 	Local text 符号。
U 	未定义符号。



nm
-A 	每行或者显示全路径名称或者显示对象库名。
-B 	在 Berkeley 软件分发（BSD）格式中显示输出：
    值   类型   名称
-C 	限制解码（demangle） C++ 名称。缺省是解码所有 C++ 符号名。
    注:C++ 对象文件中的符号在被使用前它们的名称已经被解码了。

-e 	只显示静态的和外部的（全局）符号。
-f 	显示完整的输出，包括冗余的 .text、 .data 以及 .bss 符号，这些在通常都是被限制的。
    # "bsd", "sysv", or "posix"
-g 	只显示外部的（全局）符号。
-l 	通过给 WEAK 符号的编码键附加一个 * 来区分 WEAK 和 GLOBAL 符号。 如果和 -P 选项一起使用， WEAK 符号的符号类型显示如下：
    V:Weak Data 符号
    W:Weak Text 符号
    w:Weak 未定义符号
    Z:Weak bss 符号
-o 	用八进制而不是十进制数来显示符号的值和大小。
-P 	以标准可移植输出格式显示信息：
    库／对象名　 名称   类型   值   大小
    该格式以十六进制符号表示法显示数字值，除非您用 -t、-d 或 -o 标志指定不同的格式。
    如果您指定了 -A 标志 -P 标志只显示 库／对象名字段。同样，-P 标志只显示大小适用的符号大小字段。
-p 	不排序。输出按符号表顺序打印。
-r 	倒序排序。
-t Format 	显示指定格式下的数字值，其中 Format 参数是以下符号表示法之一：
   d十进制符号表示法。这是 nm 命令的缺省格式。
   o八进制符号表示法。
   x十六进制符号表示法。
-u 	只显示未定义符号。
-v 	按值而不是按字母表顺序排序输出。
-x 	用十六进制而不是十进制数来显示符号的值和大小。
-X mode 	指定 nm 应该检查的对象文件的类型。 mode 必须是下列之一：
   32只处理 32 位对象文件
   64只处理 64 位对象文件
   32_64处理 32 位和 64 位对象文件
缺省是处理 32 位对象文件（忽略 64 位对象）。 mode 也可以 OBJECT_MODE 环境变量来设置。例如，OBJECT_MODE=64 使 nm 处理任何 64 位对象并且忽略 32 位对象。 -X 标志覆盖 OBJECT_MODE 变量。
}

objcopy()
{
当你想要复制一个目标文件而忽略或改变其某方面的内容时，可以使用objcopy命令。
objcopy的常见用法是去掉测试后正在运行的目标文件中的调试符号，
这样做可以大大减小目标文件的大小，因而常用于嵌入式系统中。
}

hexdump()
{
命令hexdump可以显示给定十六进制/ASCII码/八进制格式文件的内容。
注意，在老版本的Linux中，也使用od（octal dump）。现在，绝大多数系统用hexdump取代了od。
hexdump -x -n 64 a.out 

}

hexedit()
{
编辑器hexedit能支持直接修改该文件，而不必先将其内容转换成ASCII码（或Unicode编码）
}


objdump(objdump命令是用查看目标文件或者可执行的目标文件的构成的gcc工具)
{
objdump -t test.o  
objdump -x test.o   #-x ： 显示文件的所有头文件
objdump -s test.o   #-s：  显示各个段的详细内容
                    #查看.rodata段中的信息，
                    
objdump -x test.o   #-x ： 显示文件ELF头文件信息
objdump -d test.o   #-d ： 反汇编
objdump -d -j .plt libfoobar.so #反汇编指定的section
objdump -S -j .plt libfoobar.so #反汇编指定的section


objdump -h test.o   #-h ： 查看各个段的基本信息
objdump -d xxx > 123.txt #objdump -d 如何将反汇编结果直接写入txt文件
objdump -a test.o   #显示档案库的成员信息,
objdump -g test.o   #-g 显示调试信息。企图解析保存在文件中的调试信息并以C语言的语法显示出来。仅仅支持某些类型的调试信息。有些其他的格式被readelf -w支持。
objdump -e test.o   #类似-g选项，但是生成的信息是和ctags工具相兼容的格式。

objdump -e test.o  # size test.o

objdump
  -a, --archive-headers    Display archive header information
  -f, --file-headers       Display the contents of the overall file header
  ### ####
  -p, --private-headers    Display object format specific file header contents
  -P, --private=OPT,OPT... Display object format specific contents 
  
  ### ELF头信息--显示各段信息 ###
  -h, --[section-]headers  Display the contents of the section headers
  -x, --all-headers        Display the contents of all headers
  
  ### 可执行段级别输出 ###
  -d, --disassemble        Display assembler contents of executable sections    # 汇编和C交织输出，仅以函数名输出

  -D, --disassemble-all    Display assembler contents of all sections           # 全汇编输出
  
  -S, --source             Intermix source code with disassembly                # hexdump -C 全hex码输出
  -s, --full-contents      Display the full contents of all sections requested  # 汇编和C交织输出，包含函数C与汇编对应关系
  ### 段级别的输出 ###
  -g, --debugging          Display debug information in object file             # 调试信息，包括打印输出行信息，文件信息等。
  -e, --debugging-tags     Display debug information using ctags style          # 调试信息，包括打印输出行信息，文件信息等。
  -W[lLiaprmfFsoRt] or
  --dwarf[=rawline,=decodedline,=info,=abbrev,=pubnames,=aranges,=macro,=frames,
          =frames-interp,=str,=loc,=Ranges,=pubtypes,
          =gdb_index,=trace_info,=trace_abbrev,=trace_aranges]
                           Display DWARF info in the file
  -t, --syms               Display the contents of the symbol table(s)           # 目标文件之间函数引用，也包括对libc的引用
  -T, --dynamic-syms       Display the contents of the dynamic symbol table      # 可执行文件对Libc文件的函数引用
  -r, --reloc              Display the relocation entries in the file            # 只对目标文件有意义
  -R, --dynamic-reloc      Display the dynamic relocation entries in the file    # 可执行文件对Libc文件的函数引用
  @<file>                  Read options from <file>
  -i, --info               List object formats and architectures supported
}

readelf(readelf命令用来显示一个或者多个elf格式的目标文件的信息，可以通过它的选项来控制显示哪些信息)
{
readelf -s test.o 
readelf -S test.o  # objdump -h
readelf -h test.o  # -h：目标文件首部的详细信息
readelf -d test.o  # --dynamic 显示动态段的信息。
                   # 只readelf -d有对应的功能, objdump没有. 另外需要注意, 看重定位文件不需要动态链接(加载), 所以没有.dynamic节.
readelf -l test.o  # 第二个readelf支持而objdump没有的功能. 命令参数为readelf -l. 
                   # --segments 显示程序头（段头）信息(如果有的话)。
readelf -x test.o  # objdump -s
readelf -h test.o  # 提供完整的信息, objdump -f只提供很少的信息.
readelf -s test.o  # objdump -t

一次全部
两个命令都提供了一个参数, 指定多个其他参数的集合一起显示, 但显示内容略有不同. 
readelf -a:    -h -l -S    -r -s -d -n -V
objdump -x:    -a -f       -h -p -r -t               

显示节信息: readelf -S和objdump -h
对于可重定位文件, objdump -h不能显示.rel开头的节和.shstrtab, .symtab, .strtab. 
而readelf的显示有一个.group节, 其内容为节的group, 可以用-g参数查看.

}

nm(nm命令被用于显示二进制目标文件的符号表)
{

}

file * #查看文件类型

cpp test.c  > test.i        #-E：只进行预处理，并把处理结果输出
gcc -E test.c -o test.i     #-E：只进行预处理，并把处理结果输出

gcc -S test.i -o test.s     #从C文件到汇编文件
gcc -c test.c -o test.o     # -c：只编译，不链接 ，
as test.s -o test.o         #从汇编源码编译

ar -v -q lib.a strlen.o strcpy.o #要创建一个库
ar -v -t lib.a #要显示库的目录，
ar -v -r lib.a strlen.o strcat.o #要替换或添加新成员到库中
ar -v -r -b strlen.o lib.a strcmp.o #要指定在何处插入新成员
ar -v -d lib.a strlen.o #要删除一个成员
ar -r -v libshr.a shrsub.o shrsub2.o shrsub3.o ... #要从多个用 ld 命令创建的共享模块中创建一个压缩文档库，

as -l -o file.o file.s         #要产生名为 file.lst 的列表文件和名为 file.o 的目标文件，
as -s -m 601 -o file.o file.s  #要产生将在 AIX 5.1 及较早版本的 601 处理器上运行的名为 file.o 的目标文件并要在名
                               # 为 file.lst 的汇编程序列表文件中生成 POWER 系列和 PowerPC 助记符的交叉引用
as -lxxx.lst -o file.o file.s  #

od()
{
第一种格式的标志：
-A AddressBase 	指定输入偏移底数。此 AddressBase 变量是下列的字符之一：
d
    偏移底数写为十进制的。 
o
    偏移底数写为八进制的。 
x
    偏移底数写为十六进制的。 
n
    偏移底数没有显示。 

除非指定 -A n，输出行前将有需要写的下一字节的输入偏移量，输入偏移量在输入文件间会形成。 另外，跟随在最后一个字节的字节偏移量将在所有的输入数据处理完后显示。 没有 -A 基地址选项和 [offset_string] 操作数，输入偏移量底数以八进制显示。
-j Skip 	

在开始显示输出前，跳跃过由 Skip 变量给定的字节数。 如果指定的文件超过一个，od 命令在显示输出前跳跃过分配的连接输入文件字节数。 如果混合输入不是至少跳跃字节的长度， od 命令将写出诊断消息给标准错误，并退出非零状态。

缺省情况下，Skip 变量的值解释为十进制数字。 带有前缀 0x 或 0X， 偏移量解释为十六进制数；带有前缀 0，偏移量解释为八进制数。 如果字符 b，k，或者 m 附加到 Skip 变量包含的数，偏移量在字节上等于 Skip 变量各自乘以 512，1024，或者 1024*1024 的值。
-N Count 	格式不超过由 Count 变量指定的输入字节数。缺省情况下，Count 变量解释为十进制数。带有前缀 0x 或者 0X，认为是十六进制数。 如果以 0 开始，认为是八进制数。 显示地址的底数不是由 Count 选项参数的底数提示的。
-t TypeString 	指定输出类型。TypeString 变量是一个当写出数据时，指定使用类型的字符串。 多个类型能够连接在同一个 TypeString 变量中， 并且 -t 标志能够多次指定。 对于每个指定的类型写出了输出行， 依照给定类型指定字符的顺序。TypeString 变量能够包括下列字符：

a
    显示字节为指定的字符。在 0 到 01777 范围内，带有至少 7 位的字节，对于那些字符，用相应的名称来写。 
c
    显示字节为字符。 由 c 类型字符串变换的字节数由 LC_CTYPE 本地类别确定。可打印的多个字节字符的写法对应于字符的第一个字节；两个字符序列 ** 的写法对应于字符中每个保留的字节，作为字符继续的指示。下列非图形字符作为 C－ 语言转义序列使用：

    \    反斜杠
    \a   提示符
    \b   退格符
    \f   换页
    \n   换行字符
    \0   空
    \r   回车符
    \t   制表符
    \v   垂直制表符

d
    显示字节为有符号十进制。缺省情况下，od 命令变换相应的字节数为 C －语言类型 int。d 类型字符串能够跟随无符号的十进制整数，它指定了由每个输出类型实例变换的字节数。

    可选的项 C，I，L，或者 S 字符能够附加到 d 可选项，表示转换应该分别适用于 char，int，long，或者 short。
f
    显示字节为浮点。缺省情况下，od 命令变换相应的字节数为 C － 语言类型 double。 f 类型字符串能够跟随无符号的十进制整数，它指定了由每个输出类型的实例变换的字节数。

    可选项 F，D，或者 L 字符能够附加到 f 可选项，表示转换应该分别适用于类型 float，double，或者 long double。

o
    显示字节为八进制。 缺省情况下， od 命令变换相应的字节数为 C － 语言类型 int。 o 类型字符串能够跟随无符号的十进制整数，它指定了由每个输出类型实例变换的字节数。

    可选项 C， I，L，或者 S 字符能够附加到 o 可选项，表示转换应该分别适用于类型 char，int，long，或者 short。

	

u
    显示字节为无符号的十进制。缺省情况下，od 命令变换相应的字节数为 C－语言类型 int。u 类型字符串能够跟随无符号的十进制整数，它指定了由每个输出类型的实例变换的字节数。

    可选的项 C，I，L，或者 S 字符能够附加到 u 可选项，表示转换应该分别适用于 char，int，long 或者 short。
x
    显示字节为无符号的十六进制。缺省情况下，od 命令变换相应的字节数为 C－语言类型 int。x 类型字符串能够跟随无符号的十进制整数，它指定了由每个输出类型实例变换的字节数。

    可选的项 C，I，L，或者 S 字符能够附加到 x 可选项，表示转换应该分别适用于 char，int，long 或者 short。

第二种格式的标志：
-a 	显示字节为字符，并且用它们的 ASCII 名称显示。 如果 -p 标志也给定了，带有偶校验的字节加下划线。 -P 标志引起带有奇校验的字节加下划线。 否则忽略奇偶性校验。
-b 	显示字节为八进制值。
-c 	显示字节为 ASCII 符。下列非图形字符作为 C－语言转义序列使用：

\    反斜杠
\a   提示符
\b   退格符
\f   换页
\n   换行字符
\0   空
\r   回车符
\t   制表符
\v   垂直制表符

其它表示为 3 位的八进制数。
-C 	显示扩展字符作为标准打印 ASCII 字符（使用合适的字符转义），并且以十六进制格式显示多字节字符。
-d 	显示 16 位字为无符号十进制值。
-D 	显示长字为无符号十进制值。
-e 	显示长字为双精度、浮点。（如同 -F 标志）
-f 	显示长字为浮点。
-F 	显示长字为双精度、浮点。（如同 -e 标志）
-h 	显示 16 位字为无符号十六进制。
-H 	显示长字为无符号十六进制值。
-i 	显示 16 位字为有标记十进制。
-I 	（大写 i）显示长字为有标记十进制值。
-l 	（小写 L）显示长字为有标记十进制值。
-L 	显示长字为有标记十进制值。

    注意： 标志 -I（大写 i），-l（小写 L）， 和 -L 是相同的。

-o 	显示 16 位字为无符号八进制。
-O 	显示长字为无符号八进制值。
-p 	表示对 -a 转换进行偶校验。
-P 	表示对 -a 转换进行奇校验。
-s 	显示 16 位字为有标记十进制值。
-S[N] 	搜索以空字节结束的字符的字符串。 N 变量指定了需标识的最小长度的字符串。 如果 N 变量省略了，最小长度缺省值为 3 个字符。

-v 标志对于下列两种格式是一样的：
-v 	写所有输入数据。 缺省情况下， 等同于先前输出行的输出行没有打印，但是用只包含 * （星号）的行替换。 当指定 -v 标志时，打印所有的行。
-w [N] 	指定需解释并且在每个输出行显示的输入字节的数量。 如果 -w 标志没有指定，每一显示行读取 16 字节。 如果指定了 -w 标志没有带 N 变量，每个显示行读取 32 个字节。 最大输入值是 4096 字节。 大于 4096 字节的输入值将重新分配最大值。
-x 	显示 16 位字为十六进制值。
-X 	显示长字为无符号十六进制值。（如同 -H 标志）


}

