http://refspecs.linuxbase.org/elf/elfspec.pdf

http://www.cnblogs.com/arnoldlu/p/7136701.html # 分析
bss(未初始化的数据){
* .bss
  该sectiopn保存着未初始化的数据，这些数据存在于程序内存映象中。
  通过定义，当程序开始运行，系统初始化那些数据为0。该section不占
  文件空间，正如它的section类型SHT_NOBITS指示的一样。
}
comment(版本控制){
* .comment
   该section保存着版本控制信息。
}
data1(已初始化数据){
* .data and .data1 # 包含用于程序内存映像的已初始化数据
# .data和.text都是属于PROGBITS类型的section，这是将来要运行的程序与代码
  这些sections保存着初始化了的数据，那些数据存在于程序内存映象中。
}
debug(标号调试的信息){
* .debug
  该section保存着为标号调试的信息。该内容是未指明的。
}
dynamic(动态链接信息){
* .dynamic
  该section保存着动态连接的信息。该section的属性将包括SHF_ALLOC位。
  是否需要SHF_WRITE是跟处理器有关。第二部分有更详细的信息。
}
dynstr(动态链接的字符串信息){
* .dynstr
  该section保存着动态连接时需要的字符串，一般情况下，名字字符串关联着符号表的入口。
  通常这些字符串是与符号表项相关联的名字。
}
dynsym(动态链接符号表){
* .dynsym # 不包括模块内部的符号
  该section保存着动态符号表，如“Symbol Table”的描述。第二部分有更
  详细的信息。
}
fini(程序结束时执行){
* .fini
  该section保存着可执行指令，它构成了进程的终止代码。
  因此，当一个程序正常退出时，系统安排执行这个section的中的代码。
}
got(全局偏移量表){
* .got
  该section保存着全局的偏移量表。看第一部分的“Special Sections”和
  第二部分的“Global Offset Table”获得更多的信息。
}
hash(符号哈希表){
* .hash
  该section保存着一个标号的哈希表。看第二部分的“Hash Table”获得更多
  的信息。
}
init(程序初始化时执行){
* .init
  该section保存着可执行指令，它构成了进程的初始化代码。因此，当一个程序开始运行时，
  在main函数被调用之前(c语言称为main)，系统安排执行这个section的中的代码。
}
interp(程序解释器的路径名){
* .interp
  该section保存了程序的解释程序(interpreter)的路径。假如在这个section
  中有一个可装载的段，那么该section的属性的SHF_ALLOC位将被设置；否则，
  该位不会被设置。看第二部分获得更多的信息。
  
  动态链接器的位置既不是系统配置决定、也不是由环境参数决定，而是由ELF文件自身决定。
  在动态链接的ELF可执行文件中，有一个专门的段叫作 ".interp段"(interpreter(解释器)段)
  
  表明可执行文件所需要的动态链接器的路径，
  在Linux中，操作系统在对可执行文件进行加载的时候，会去寻找装载该可执行文件所需要的相应的动态链接器
  
}
line(符号调试的行号){
* .line
  该section包含编辑字符的行数信息,它描述源程序与机器代码之间的对于关系。该section内容不明确的。
}
note(){
* .note
  该section保存一些信息，使用“Note Section”(在第二部分)中提到的格式。
}
plt(动态链接重定位表){
* .plt
  该section保存着过程连接表（Procedure Linkage Table）。
  所有外部函数调用都是经过一个对应桩函数，这些桩函数都在.plt段内。
[plt 使用]
  调用对应桩函数—>桩函数取出.got表表内地址—>然后跳转到这个地址.
  如果是第一次,这个跳转地址默认是桩函数本身跳转处地址的下一个指令地址(目的是通过桩函数统一集中取地址和加载地址),
  后续接着把对应函数的真实地址加载进来放到.got表对应处,同时跳转执行该地址指令.
  以后桩函数从.got取得地址都是真实函数地址了。
}


rela(重定位信息){
* .rel<name> and .rela<name>

  这些section保存着重定位的信息，看下面的``Relocation''描述。
  假如文件包含了一个可装载的段，并且这个段是重定位的，那么该section的
  属性将设置SHF_ALLOC位；否则该位被关闭。按照惯例，<name>由重定位适用
  的section来提供。因此，一个重定位的section适用的是.text，那么该名字
  就为.rel.text或者是.rela.text。

重定位的地方在.got.plt段内(注意也是.got内,具体区分而已)。 主要是针对外部函数符号。一般是函数首次被调用时候重定位。
首次调用时会重定位函数地址，把最终函数地址放到.got内，以后读取该.got就直接得到最终函数地址。我个人理解这个Section
的作用是，在重定位过程中，动态链接器根据r_offset找到.got对应表项，来完成对.got表项值的修改。
}
rodata(只读数据){
* .rodata and .rodata1
  这些section保存着只读数据，在进程映象中构造不可写的段。看第二部分的
  ``Program Header''获得更多的资料。
}
shstrtab(){
* .shstrtab # 用来保存段表中用到的字符串，最常见的就是段名(sh_name)
  该section保存着section名称。
}

strtab(与符号表项相关联的名字){
* .strtab # 存着字符串，储存着符号的名字; 
          # 用来保存普通的字符串，比如符号的名字
  该section保存着字符串，一般地，描述名字的字符串和一个标号的入口相关
  联。假如文件有一个可装载的段，并且该段包括了符号字符串表，那么section
  的SHF_ALLOC属性将被设置；否则不设置。
}

symtab(所有section中定义的符号名字){
* .symtab # readelf -s
  该section保存着一个符号表，正如在这个section里``Symbol Table''的
  描述。假如文件有一个可装载的段，并且该段包含了符号表，那么section
  的SHF_ALLOC属性将被设置；否则不设置。
  
  .symtab section是属于SYMTAB类型的section，它描述了.strtab中的符号在"内存"中对应的"内存地址"。
}
text(可执行指令){
* .text
  该section保存着程序的``text''或者说是可执行指令。
}

segment(){
segment表， 这个表是加载指示器，操作系统（确切的说是加载器，有些elf文件，比如操作系统内核，是由其他程序加载的）,
告诉系统如何创建进程映像。用来构造进程映像的目标文件必须具有程序头部表，可重定位文件不需要这个表。

装载：对于程序的装载，我们关心这三项 readelf -h
Entry point address:               0x4000b0                 //程序的入口地址是0x4000b0
Start of program headers:          64 (bytes into file)     //segment表在文件64字节偏移处
Size of program headers:           56 (bytes)               //segment头项的长度是56字节（32系统是32字节)

readelf -l # readelf -l 读取segments
}
section(){
section表，对可执行文件来说，没有用，在链接的时候有用，是对代码段数据段在链接是的一种描述。

[allocable vs non-allocable]
ELF文件包含一些sections(如code和data)是在运行时需要的, 这些sections被称为allocable。
而其他一些sections仅仅是linker,debugger等工具需要, 在运行时并不需要, 这些sections被称为non-allocable的。
当linker构建ELF文件时, 它把allocable的数据放到一个地方, 将non-allocable的数据放到其他地方。
当OS加载ELF文件时, 仅仅allocable的数据被映射到内存, non-allocable的数据仍静静地呆在文件里不被处理. strip就是用来移除某些non-allocable sections的.

ELF header成员e_shoff指明了section header table据文件开始处的字节偏移量；
          成员e_shnum表明了table中有多少个表项；
          成员e_shentsize表示每个表项的大小（byte）。

[Section Header]         
sh_name     : section名字，但不是直接存储的名字，而是一个指向section header string table的一个index
sh_type     : section内容和语义类别
sh_flags    : 1-bit标志描述各种属性
sh_addr     : 如果这个section会被加载到内存，这个成员就是此section在内存中的地址，否则为0
sh_offset   : 此section相对于文件开始的偏移量（字节）
sh_size     : section所占的空间大小（字节）
sh_link     : 一个section header table index链接，含义取决于section类型
sh_info     : 额外信息，含义取决于section类型
sh_addralign: 有些sections有地址对齐的限制，sh_addr模sh_addralign必须为0。 0和1都表示不用地址对齐
sh_entsize  : 有些sections由一些固定大小的表项组成的表（比如符号表），对于这些sections，这个成员记录了每个表项的大小。对于不是这种类型的section，值为0
}

symtab_dynstr_VS_dynsym(){
动态符号表(.dynsym)用来保存与动态连接相关的导入导出符号，不包括模块内部的符号。而.symtab则保存所有符号，包括.dynsym中的符号。
.symtab包含大量linker,debugger需要的数据, 但并不为runtime必需, 它是non-allocable的;
.dynsym包含.symtab的一个子集, 比如共享库所需要在runtime加载的函数对应的symbols, 它是allocable的。

动态符号表(.dynsym)中所包含的符号的符号名保存在动态符号字符串表 .dynstr 中。
}


在静态链接中，这些未知的地址引用在最终链接时会被重定位修正，但是在动态链接中，导入符号的地址在运行时才确定，
所以需要在运行时将这些导入符号的引用修正，即需要动态重定位：
1. ".rel.dyn"
对数据引用的修正，它所修正的位置位于".got"以及数据段
2. ".rel.plt"
对函数引用的修正，它所修正的位置位于".got.plt"

plt_VS_dyn(rel){
重定位的地方在.got段内。主要是针对外部数据变量符号。例如全局数据。重定位在程序运行时定位，一般是在.init段内。
定位过程：获得符号对应value后，根据rel.dyn表中对应的offset，修改.got表对应位置的value。另外，

.rel.dyn 含义是指和dyn有关，一般是指在程序运行时候，动态加载。区别于rel.plt，
.rel.plt是指和plt相关，具体是指在某个函数被调用时候加载。
我个人理解这个Section的作用是，在重定位过程中，动态链接器根据r_offset找到.got对应表项，来完成对.got表项值的修改。

<重点说明>
rel.dyn和.rel.plt是动态定位辅助段。由连接器产生，存在于可执行文件或者动态库文件内。借助这两个辅助段可以动态
修改对应.got和.got.plt段，从而实现运行时重定位。
}

rec(){
以 .rec 打头的 sections 里面装载了重定位条目；
} 
  
variable(space){
变量类型            是否占用空间  
全局变量            不论是否使用，都占用空间。    因为全局变量作用域跨文件，所以即使此文件没有使用，也不能被优化。
全局静态变量        如果没被使用，会被编译器优化。
                    如果被使用，则占用空间。      全局静态变量的作用域为文件，编译器可以判定在此文件是否使用。没有使用，则别处也不会使用。没有存在意义。
局部变量            局部变量不占用空间。          局部变量只在函数内使用，分配在栈中。
局部静态变量        如果没被使用，会被编译器优化。
                    如果被使用，则占用空间。      局部静态的作用域是函数，虽然存在静态存储区，但是如果函数内没有使用。在别处再不会被使用，所以可以优化掉。
存在静态存储区。    malloc/free                   堆中分配和释放，所以是动态的。
}