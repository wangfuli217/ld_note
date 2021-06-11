# 隐含规则
# 例如:
foo : foo.o bar.o
	cc -o foo foo.o bar.o $(CFLAGS) $(LDFLAGS)
# 这里并没有给出重建文件"foo.o"的规则,make 执行这条规则时,无论文件"foo.o"存在与否,都会试图根据隐含规则来重建这个文件
# make 执行过程中找到的隐含规则,提供了此目标的基本依赖关系,确定了目标的依赖文件(通常是源文件,不包含对应的头文件依赖)和重建目标需要使用的命令行。
# 每一个内嵌的隐含规则中都存在一个目标模式和依赖模式
foo.o: foo.p
	pc $< -o $@


# sample Makefile
CUR_DIR = $(shell pwd)
INCS := $(CUR_DIR)/include
CFLAGS := -Wall –I$(INCS)
EXEF := foo bar
.PHONY : all clean
all : $(EXEF)
foo : CFLAGS+=-O2
bar : CFLAGS+=-g
clean :
	$(RM) *.o *.d $(EXEF)

$(LDFLAGS)
$(LDLIBS)
$(CXX) 
$(CC)
# C 预 编 译 器 " cpp "
$(CPP)
$(CFLAGs)
$(CPPFLAGS)
$(AR)
# 汇编as
$(AS)

# 在隐含规则中,命令行中的实际命令是使用一个变量计算得到
# 诸如: COMPILE.c"、"LINK.o"(这个在前面也看到过)和"PREPROCESS.S"等
# 这些变量被展开之后就是对应的命令(包括了命令行选项),
# 例如:变量"COMPILE.c"的定义为 "cc -c",(如果Makefile中存在"CFLAGS"的定义,它的值会存在于这个变量中)
# make会根据默认的约定,使用"COMPILE.x"来编译一个".x"的文件
# 似地使用"LINK.x"来连接".x"文件;
# 使用"PREPROCESS.x"对".x"文件进行预处理。

# 以下是一些作为程序名的隐含变量定义
$(RM)

# 命令参数的变量
# 执行"AR"命令的命令行参数。默认值是"rv"
$(ARFLAGS)
# 执行汇编语器"AS"的命令行参数(明确指定".s"或".S"文件时)
$(ASFLAGS)
# 执行"g++"编译器的命令行参数(编译.cc源文件的选项)。
$(CXXFLAGS)
# 执行"CC"编译器的命令行参数(编译.c源文件的选项)
$(CFLAGS)
# 执行C预处理器"cc -E"的命令行参数(C 和 Fortran 编译器会用到)。
$(CPPFLAGS)
# 链接器(如:"ld")参数。
$(LDFLAGS)

# 模式规则
# 模式规则类似于普通规则。只是在模式规则中,目标名中需要包含有模式字符"%"(一个),包含有模式字符"%"的目标被用来匹配一个文件名,"%"可以匹配任何非空字符串。
# 例如:对于模式规则"%.o : %.c",它表示的含义是:所有的.o文件依赖于对应的.c文件。我们可以使用模式规则来定义隐含规则。
# 一个模式规则的格式为:
%.o : %.c ; COMMAND...

# 模式规则中依赖文件也可以不包含模式字符"%"。当依赖文件名中不包含模式字符"%"时,其含义是所有符合目标模式的目标文件都依赖于一个指定的文件
# 例如:
%.o : debug.h
# 表示所有的.o文件都依赖于头文件"debug.h"

# 多目标模式规则
# 对于多目标模式规则来说,所有规则的目标共同拥有依赖文件和规则的命令行
# 看一个例子:
Objects = foo.o bar.o
CFLAGS := -Wall
%.x : CFLAGS += -g
%.o : CFLAGS += -O2
%.o %.x : %.c
	$(CC) $(CFLAGS) $< -o $@

# 
%.o : %.c
	$(CC) -c $(CFLAGS) $(CPPFLAGS) $< -o $@

# 内嵌的模式规则
% :: RCS/%.c
	$(CC) $(CFLAGS) $<
# 这个规则的含义是:任何一个文件"X"都可以由目录"RCS"下的相应文件"x.c"来生成。
# 双冒号表示该规则是最终规则

# 自动化变量"$?"在显式规则中也是非常有用的,使用它规则可以指定只对更新以后的依赖文件进行操作。
lib: foo.o bar.o lose.o win.o
	$(AR) r lib $?


# 以上罗列的自动量变量中。其中有四个在规则中代表文件名($@、$<、$%、$*)。而其它三个的在规则中代表一个文件名列表
# GUN make中,还可以通过这七个自动化变量来获取一个完整文件名中的目录部分和具体文件名部分。在这些变量中加入"D"或者"F"字符就形成了一系列变种的自动环变量。
# $< 和$(<)一样

# "$$@"、"$$(@D)"和"$$(@F)"(注意:要使用"$$"),它们分别代表了
# $$@ 目标的完整文件名
# $$(@D) 目标文件名中的目录部分
# $$(@F) 目标的实际文件名部分
# 这三个特殊的变量只能用在明确指定目标文件名的规则中或者是静态模式规则中,不用于隐含规则中。

# 实际文件名应该是以模式指定的前缀开始、后缀结束的任何文件名。文件名中除前缀和后缀以外的所有部分称之为"茎"(模式字符"%"可以代表若干字符。因此:模式"%.o"所匹配的文件"test.c"中"test"就是"茎")

# 万用规则
# 当模式规则的目标只是一个模式字符"%"(它可以匹配任何文件名)时,我们称这个规则为万用规则。

# 缺省规则
# 执行make过程中,对所有不存在的.c文件将会使用"touch"命令创建这样一个空的源文件。
%::
	@touch $@
# 实现一个缺省规则的方式也可以不使用万用规则,而使用伪目标".DEFAULT",上边的例子也可以这样实现:
.DEFAULT :
	@touch $@

# 后缀规则
# 后缀规则有两种类型:"双后缀"和"单后缀"。
# 双后缀规则定义一对后缀:目标文件的后缀和依赖目标的后缀。"%o : %c"。
# 单后缀规则只定义一个后缀:此后缀是源文件名的后缀。% : %.c"
# 例如:".c"和".o"都是make可识别的后缀。因此当定义了一个目标是".c.o"的规则时。make会将它作为一个双后缀规则来处理,它的含义是所有".o"文件的依赖文件是对应的".c"文件。
.c.o
.cc.o

# 下边是使用后缀规则定义的编译.c源文件的规则:
.c.o:
	$(CC) -c $(CFLAGS) $(CPPFLAGS) -o $@ $<
# 注意:一个后缀规则中不存在任何依赖文件。否则,此规则将被作为一个普通规则对待。
# 因此规则:
.c.o: foo.h
	$(CC) -c $(CFLAGS) $(CPPFLAGS) -o $@ $<
# 就不是一个后缀规则。它是一个目标文件为".c.o"、依赖文件是"foo.h"的普通规则。
# 它也不等价于规则:
%.o: %.c foo.h
	$(CC) -c $(CFLAGS) $(CPPFLAGS) -o $@ $<

# 可识别的后缀指的是特殊目标".SUFFIXES"所有依赖的名字。
# 通过给特殊目标"SUFFIXES"添加依赖来增加一个可被识别的后缀。像下边这样:
.SUFFIXES: .hack .win
.hack.win:
	@ echo 'xuexi'
 
# 如果需要重设默认的可识别后缀,因该这样来实现:
# 删除所有已定义的可识别后缀
.SUFFIXES:
# 重新定义
.SUFFIXES: .c .o .h

# 所有的后缀规则在make读取Makefile时,都被转换为对应的模式规则。


# 更新静态库文件
# 静态库文件也称为"文档文件",它是一些.o 文件的集合。
foolib(hack.o) : hack.o
	$(AR) cr foolib hack.o

# 如果在规则中需要同时指定库的多个成员,可以将多个成员罗列在括号内,例如:
foolib(hack.o kludge.o)
# 它就等价于:
foolib(hack.o) foolib(kludge.o)
# 在描述库的多个成员时也可以使用shell通配符
foolib(*.o)
# 它代表库文件"foolib"的所有.o成员

# 更新静态库的符号索引表
# ranlib ARCHIVEFILE
libfoo.a: libfoo.a(x.o) libfoo.a(y.o) ...
	ranlib libfoo.a

# 静态库的后缀规则
# 例如这样一个后缀规则:
.c.a:
	$(CC) $(CFLAGS) $(CPPFLAGS) -c $< -o $*.o
	$(AR) r $@ $*.o
	$(RM) $*.o
# 它相当于模式规则:
(%.o): %.c
	$(CC) $(CFLAGS) $(CPPFLAGS) -c $< -o $*.o
	$(AR) r $@ $*.o
	$(RM) $*.o


############
# Makefile的约定
############
SHELL = /bin/sh
.SUFFIXES:
.SUFFIXES: .c .o
# 第一行首先取消掉 make 默认的可识别后缀列表,第二行重新指定可识别的后缀列表。
#使用GNU make的变量"VPATH"指定搜索目录。当规则只有一个依赖文件时。应该使用自动化变量"$<"和"$@"代替出现在命令的依赖文件和目标文件
# 用于创建和安装的"configure"脚本以及 Makefile 中的命令
# cat cmp cp diff echo egrep expr false grep install-info ln ls mkdir mv pwd rm rmdir sed sleep sort tar test touch true
# 在目标"dist"的命令行中可以使用压缩工具"gzip"
# 对于以下的这些命令程序:
# ar bison cc flex install ld ldconfig make makeinfo ranlib texi2dvi yacc lex
# 在规则中的命令中,使用以下这些变量来代表它们:
# $(AR) $(BISON) $(CC) $(FLEX) $(INSTALL) $(LD) $(LDCONFIG) $(LEX) $(MAKE) $(MAKEINFO) $(RANLIB) $(TEXI2DVI) $(YACC)
$(LD)
$(LDCONFIG)
$(RANDLIB)
# 在我们书写的 Makefile 中应该讲所有的命令、选项作为变量定义,方便后期对命令的修改和对选项的修改。
# 任 何 需 要 执 行 链 接 的 命 令 行 中 使 用"LDFLAGS"作为命令的执行参数。
$(LDFLAGS)

# Makefile 中实现文件安装的规则
# 在 Makefile 中也需要定义变量"INSTALL_PROGRAM"和"INSTALL_DATA".
# 例如:
$(INSTALL_PROGRAM) foo $(bindir)/foo
$(INSTALL_DATA) libfoo.a $(libdir)/libfoo.a
# 另外,也可以使用变量"DESTDIR"来指定目标需要安装的目录
# 通常也可以不在Makefile 定义变量"DESTDIR",可通过 make 命令行参数的形式来指定。例如:"make DESTDIR=exec/ install"。因此上边的命令就可以这样实现:
$(INSTALL_PROGRAM) foo $(DESTDIR)$(bindir)/foo
$(INSTALL_DATA) libfoo.a $(DESTDIR)$(libdir)/libfoo.a

# 安装目录变量
# prefix 这个变量(通常作为实际文件安装目录的父目录,可以理解为其它实际文件安装目录的前缀),变量"prefix"缺省值是"/usr/local"

# Makefile的标准目标名
# all 此目标的动作是编译整个软件包。"all"应该为Makefile的终极目标。该目标的动作不重建任何文档(只编译所有的源代码,生成可执行程序)
# install 此目标的动作是完成程序的编译并将最终的可执行程序、库文件等拷贝到安装的目录。如果只是验证这些程序是否可被正确安装,它的动作应该是一个测试安装动作。
# uninstall 删除所有已安装文件——由install创建的文件拷贝。规则所定义的命令不能修改编译目录下的文件,仅仅是删除安装目录下的文件。
# install-strip 和目标install的动作类似,但是install-strip指定的命令在安装时对可执行文件进行strip(去掉程序内部的调试信息)。它的定义如下:
install-strip:
	$(MAKE) INSTALL_PROGRAM='$(INSTALL_PROGRAM) -s' install
# clean
# distclean
# dist 此目标指定的命令创建发布程序的tar文件。
# installdirs 使用目标"installdirs"创建安装目录以及它的子目录在很多场合是非常有用的。脚本"mkinstalldirs"就是为了实现这个目的而编写的
installdirs: mkinstalldirs
	$(srcdir)/mkinstalldirs $(bindir) $(datadir) \
	$(libdir) $(infodir) \
	$(mandir)

# 或者可以使用变量"DESTDIR":
installdirs: mkinstalldirs
	$(srcdir)/mkinstalldirs \
	$(DESTDIR)$(bindir)
	$(DESTDIR)$(datadir) \
	$(DESTDIR)$(libdir) $(DESTDIR)$(infodir) \
	$(DESTDIR)$(mandir)
# 该规则不能更改软件的编译目录,仅仅是创建程序的安装目录

# 安装命令分类
# 为 Makefile 书写"install"目标时,需要将其命令分为三类:正常命令、安装前命令和安装后命令。
# 分类行是由一个[Tab]字符开始的对 make 特殊变量的引用,行尾是可选的注释内容。
# 以下是三种可能的分类行,以及它们的解释:
	$(PRE_INSTALL) # 以下是安装前命令
	$(POST_INSTALL)# 以下是安装后命令
	$(NORMAL_INSTALL) # 以下是正常命令

# 自动推导规则
# 在使用make编译.c源文件时,编译.c源文件规则的命令可以不用明确给出。这是因为make本身存在一个默认的规则,能够自动完成对.c文件的编译并生成对应的.o文件