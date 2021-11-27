make_l_link(){ cat - <<'EOF'
https://github.com/sophalHong/prolinux-vagrant-k8s 通过make命令管理虚拟机
https://github.com/olipratt/hashdeps  根据hash值决定依赖是否被编译
syntax/makefile-multi-dir-master
EOF
}

cat - <<'EOF'
[语言特性]
    make_p_feature
    make_p_variable
    make_p_auto_variable
[function]
    make_i_functions
    make_i_func_xxx
    make_i_func_str_xxx
    make_i_func_path_xxx
[control]
    make_i_control
[make&&gcc&&bash]
    make_p_bash_gcc
[demo]
    lms(Makefile)
    redis_src(Makefile)
    hiredis
[snippet]
    syntax/gnumake
    syntax/learn-makefile
[advance]
    makecheat.txt  make_m_opt 命令行选项
    make-mini.txt
    make.bashrc

关于如何写Makefile，当前有个模板可以借鉴:
    lms/Makefile          交叉编译
    redis_top/redis_src   可执行文件
    hiredis               动态库
    automakefile_demo     根据源文件自动创建可执行文件
EOF

make_p_bash_gcc(){ cat - <<'EOF'
[gcc]
以gcc命令为"核心"，"模块设计"动态链接库，静态链接库和编译选项，链接选项。 即特定目标的gcc选项 分解成 变量定义。
"模块设计" -- 即定义代码预编译(预编译选项),编译(编译选项),链接(链接选项)和静态库,动态库(库选项),可执行文件等过程和目标"变量"。
              即对动态库，静态库和可执行文件的定义，"分解成" 预编译选项,编译选项,链接选项,链接库选项的定义。
              
动态链接库: LD(LINK) LDFLAGS LDLIBS 
                LIBNAME=libhiredis HIREDIS_MAJOR=0 HIREDIS_MINOR=10 DYLIBSUFFIX=so
                DYLIB_MINOR_NAME=$(LIBNAME).$(DYLIBSUFFIX).$(HIREDIS_MAJOR).$(HIREDIS_MINOR)
                DYLIB_MAJOR_NAME=$(LIBNAME).$(DYLIBSUFFIX).$(HIREDIS_MAJOR)
                DYLIBNAME=$(LIBNAME).$(DYLIBSUFFIX)
                DYLIB_MAKE_CMD=$(CC) -shared -Wl,-soname,$(DYLIB_MINOR_NAME) -o $(DYLIBNAME) $(LDFLAGS)
静态链接库: AR  ARFLAGS $(AR) $(ARFLAGS) $@ $<
                LIBNAME=libhiredis
                STLIBNAME=$(LIBNAME).$(STLIBSUFFIX)
                STLIB_MAKE_CMD=ar rcs $(STLIBNAME)
编译选项: CFLAGS CPPFLAGS
          FINAL_CFLAGS=$(STD) $(WARN) $(OPT) $(DEBUG) $(CFLAGS) $(REDIS_CFLAGS)
链接选项: LDFLAGS LDLIBS
          FINAL_LDFLAGS=$(LDFLAGS) $(REDIS_LDFLAGS) $(DEBUG)

[makefile]
以makefile为"主线"，描述源文件、中间文件以及可执行文件之间的构建规则依赖. -> 即特定规则的依赖 分解成 规则定义。
"主线设计" -- 即对Makefile执行规则定义描述，体现gcc特定目标(生成文件)下预编译过程,编译过程,链接过程的规则定义。
              即对Makefile默认规则,测试规则，静态代码检查规则的定义，"分解成" 预编译,编译,链接和静态库,动态库,可执行文件之间子规则定义。
Makefile -- 定义推导规则(目标与依赖关系)，条件变量用以控制目标、依赖、命令的执行参数和目标选择。
推导规则有：自定义推导， 自动推导规则， 后缀推导                     make_p_opt  make_i_rule_desc  make_i_rule_cmd_desc
可用变量有：make环境变量， bash环境变量，位置环境变量，自定义变量   make_p_opt

[bash]
以bash为"辅助工具"，实现代码格式化，代码静态检查，复杂度检查，数据字典功能；实现帮助文档，测试过程，代码覆盖率测试，性能测试。
Makefile执行环境初始化，以及定义代码格式化，静态代码检查，复杂性检查等等
 可以探测系统环境，gcc/clang环境，开发环境(date; svn info; maj,med,min-VERSMAJ,VERSMID,VERSMIN), 
 可以执行bash控制语句和内建语句 for F in $(SRCS); do 或 for flg in $$sane_makeflags; do 等等。
 可以执行gcc clang cppcheck scan-build dos2unix tscancode complexity aspell valgrind 等命令。   makecheat.txt

在Makefile中执行bash命令的方式与细节
# - 忽略命令执行结果 
# @ 不输出命令详细； 
# $ 如果需要真实的$符号，则需要用"$$"来表示;  
# \ 换行符，命令或者依赖过长时，可以使用它换行

以make命令为入口，通过参数指定makefile内可执行项以及可执行项参数    #指定那个选项执行，指定选项可定制的参数。
EOF
}

make_p_env(){ cat - <<'EOF'
[makefile] make命令预定义的makefile环境
environment variable: 环境变量
grep environment -A 1 makep.txt  | grep -v environment | grep -v "\-\-"

automatic variable:   自动变量
grep automatic -A 1 makep.txt  | grep -v automatic | grep -v "\-\-"

default variable:     默认变量
grep default -A 1 makep.txt  | grep -v default | grep -v "\-\-" | grep -v "^#"

makefile variable:   makefile变量
grep makefile -A 1 makep.txt  | grep -v makefile | grep -v "\-\-" | grep -v "^#"

自动推导规则
grep "%*: %.*" -A 2 makep.txt  | grep -v "^#" | grep -v "\-\-"

后缀推导
grep "%.*:$"  makep.txt
EOF
}

make_p_feature(){ cat - <<'EOF'
[工程编译和程序链接]
---- 学习语言就是学习语言特性 ---- 
make_i_rule       定义规则是makefile编写的灵魂，规则的灵魂是规则对应的命令; 终极目标规则; make_i_rule_cmd 
make_p_variable   使复杂规则和命令分解成简单的变量定义，将规则定义和命令选项转换成变量定义 make_i_variable
make_i_control    控制变量定义，间接影响规则定义和命令选项定义
make_i_functions  简化变量处理和环境文件名处理。

规则中包括了目标的依赖关系(目标的依赖文件)和重建目标的命令.

---- 恰如其分的使用make提供的语言特性 ----
1. 变量: 什么时候使用 "="; 什么时候使用 ":="; 什么时候使用 "?="; 什么时候使用 "+="?
         什么时候使用 ()引用; 什么时候使用 {}引用; 什么时候使用 $${}引用; 什么时候使用 不使用括号引用? 
         什么时候使用 bash环境变量; 什么时候使用 make环境变量; 什么时候使用 自动变量; 什么时候使用 自定义变量?
         使用 .bashrc传递环境变量；使用 shell传递环境变量，还是使用make 命令传递变量? 
2. 规则: 什么时候使用 自动推导；什么时候自定义推导；什么时候定义 伪规则。预编译选项的传递?
3. 命令: 什么时候使用 @； 什么时候使用 -; 什么时候使用 $ ? 合理的使用 \

[makecheat.txt]
Makefile: 定义变量，使用变量，定义推导规则和覆盖自动推导规则的文件。
          问题是管理源文件，                                  (源文件的格式，源文件自动生成，源文件关系)
              核心工具是gcc，                                 (从源文件到目标文件统一管理工具)
              -g -ggdb                                        (gdb调试 )
              -Wall -Wextra                                   (编译告警)
              -santizer leak memory                           (内存调试)
               -fprofile-arcs -ftest-coverage --coverage -lgcov (代码覆盖率)
              辅助工具有 cppcheck, astyle, rm, dos2unix 等等，(管理源文件，中间文件和目标文件) 
                         bison flex等等                       (生成中间文件)
[makep.txt]  make_p_env
         | variable         makefile可用变量
make -p :|     makefile     make环境变量                   make 的环境变量只是对于 make 的一次执行过程有效
         |     default      make设置默认gcc，rm等相关变量
         |     automatic    make根据位置自动推导所得变量
         |     environment  bash环境变量                   系统环境变量是这个系统所有用户所拥有的
         | rules            make自动推导规则
         |                  %.o: %.s
         | .SUFFIXES        make后缀推导规则
         | .SUFFIXES: .out .a .ln .o .c .cc .C .cpp .p .f .F .r .y .l .s .S .mod .sym .def .h .info .dvi .tex .texinfo .texi .txinfo .w .ch .web .sh .elc .el
[variable] 
variable: 1. make macro=value 传递变量
          make RTU_DEBUG=yes;                        # 定义
          ifeq ($(RTU_DEBUG),yes) ... endif          # 引用
          
          2. shell            shell变量
          BUILD_DATE = $(shell date +%Y-%m-%d_%X)    # 定义
          RTUDRELEASE = "\"rtud ${VERSION}.${PATCHLEVEL}.${SUBLEVEL} @${COMPNOY} build at ${BUILD_DATE}\"" # 引用
          
          $(VARIABLE_NAME)    # make 环境变量 gcc rm等命令中变量
          ${VARIABLE_NAME}    # bash 环境变量 while for 命令中使用变量
                                               # 在命令或者文件名中使用"$"时需要用两个美元符号"$$"来表示
          3. sed -i 's/[ \t]*$$//g' *.[ch]  # $ 转义变量
          4. CROSS_COMPILE = ${TARGET}-     # 引用环境变量
          5. make环境变量
            $@ 完整的目标文件名称
            $< 第一个依赖文件的名称
            CC C编译器的名称 ，默认为cc
            CFLAGS C编译器的选项
            CXX C++编译器的名称，默认为g++
            CXXFLAGS C++编译器的选项
          
在Makefile中可以用宏指代Makefile文件中的变量，在引用的时候只需在变量前加$即可，但如果变量的字符长度超过1，则必须要加一个括号。
如 有效地宏引用：
$(CFLAGS)
$Z
$(Z)

    作为一个优秀的程序员，在面对一个复杂问题时，应该是寻求一种尽可能简单、直
接并且高效的处理方式来解决，而不是将一个简单问题在实现上复杂化。如果想在简单
问题上突出自己使用某种语言的熟练程度，是一种非常愚蠢、且不成熟的行为。
EOF
}

make_p_variable(){  cat - <<'make_p_variable'
变量名是不包括":"、"#"、"="、前置空白和尾空白的任何字符串
[变量的来源]
make命令     可以传递变量给Makefile文件
Makefile文件 可以使用：自定义变量；bash环境变量；make环境变量，make命令传递变量；$(shell cmd)变量；函数变量
Makefile文件 可以给内部shell；gcc编译命令传递变量
gcc命令      可以给C文件传递变量 和 取消变量

[变量的传递]
make -p                   # 输出信息将会告诉一些预定以变量的值                             makefile环境变量  export传递
make OPTIMIZATION="-O0"   # 向makefile传递变量; 参变量                                     make命令传递
make USE_TCMALLOC=yes     # 向makefile传递变量; 开关变量                                   make命令传递
PREFIX?=/usr/local        # Makefile PREFIX?形式的变量说明：可以向makefile传递变量:参变量  bashshell环境变量 export传递

[变量的定义]
MMEDIATE = DEFERRED                         变量赋值 (递归方式)
IMMEDIATE ?= DEFERRED                       变量没有定义才赋值
IMMEDIATE := IMMEDIATE                      立即展开 (静态方式)
IMMEDIATE += DEFERRED or IMMEDIATE
define IMMEDIATE                            多行定义
DEFERRED
endef
uglify = $(uglify)                          # lazy assignment. = expressions are only evaluated when they’re being used.
compressor := $(uglify)                     # immediate assignment
prefix ?= /usr/local                        # safe assignment
hello += world                              # append

[Magic variables]
out.o: src.c src.h
  $@   # "out.o" (target)
  $<   # "src.c" (first prerequisite)
  $^   # "src.c src.h" (all prerequisites)

%.o: %.c
  ffmpeg -i $< > $@   # Input and output
  foo $^

%.o: %.c
  $*   # the 'stem' with which an implicit rule matches ("foo" in "foo.c")

also:
  $+   # prerequisites (all, with duplication)
  $?   # prerequisites (new ones)
  $|   # prerequisites (order-only?)

  $(@D) # target directory

[变量的意义]
makefile中变量：
gcc命令组织相关变量： 优化选项；编译选项；链接选项；调试选项；告警选项；
gcc命令传递给C文件：  -D__ARM__ 编译平台选项； 程序名称设置
gcc所需文件相关变量： 目标文件集，可执行文件，链接库文件
gcc编译控制相关变量： 编辑步骤详细程度；编译颜色输出；链接库选择
REDIS_CC=$(QUIET_CC)$(CC) $(FINAL_CFLAGS)
REDIS_LD=$(QUIET_LINK)$(CC) $(FINAL_LDFLAGS)
# syntax/gnumake/variable
# syntax/learn-makefile/pattern-rules/Makefile
# syntax/learn-makefile/variable-expansion/Makefile

make -f make_p_variable
make -f make_p_variable DEBUG=1
make_p_variable
}

make_p_target(){ cat - <<'EOF'
target: 规则的目标 : 
1. 需要生成的文件名(target可以是空格分开的多个文件名，也可以是一个标签; 可以使用通配符)
2. 为了实现这个目标而必需的中间过程文件名; .o文件 .so文件名 .a文件名
3. 伪文件名: all clean codestyle cppcheck

目标=文件名:  .o文件 .so文件名 .a文件名 flex bison 生成的文件名。
目标!=文件名: 伪规则, .so文件名 .a文件名 与 rtud slotd hostd的依赖关系
EOF
}

make_p_prerequisites(){ cat - <<'EOF'
prerequisites: 规则的依赖
1. 生成规则目标所需要的文件名列表。通常一个目标依赖于一个或者多个文件
2. 文件名列表可以是: 可执行文件, .o文件 .so文件名 .a文件名
EOF
}

make_p_command(){ cat - <<'EOF'
命令就是在任何一个目标的依赖文件发生变化后重建目标的动作描述。
1. 关于@：用echo xxx会输出"echo xxx"，用@echo xxx才会会出"xxx"              Do not print command
2. 关于-：删除不存在的文件会出错导致make终止，前面加上-表示忽略可能的错误   Ignore errors
3. 关于\; 用于连接长度过长的命令行                                          Run even if Make is in 'do not execute' mode

@echo "make RTU_DEBUG=yes (-DRTUD_DEBUG)"
@echo ${RTUDRELEASE}

-rm -f *.o *.i *.gcno *.gcov *.gcda cppcheck-* *.gch

-@rm $(objects) main

for F in $(SRCS); do \
:;\
done;

build:
    @echo "compiling"
    -gcc $< $@

-include .depend

1. Includes
-include foo.make
# syntax/gnumake/makeclean/Makefile
EOF
}

make_p_token(){ cat - <<'EOF'
1. 显式规则。  显式规则说明了，如何生成一个或多个目标文件。这是由Makefile的书写者明显指出: 要生成的文件，文件的依赖文件，生成的命令。
2. 隐晦规则。  由于我们的make有自动推导的功能，所以隐晦的规则可以让我们比较简略地书写Makefile，这是由make所支持的。
3. 变量的定义。在Makefile中我们要定义一系列的变量，变量一般都是字符串，这个有点像你C语言中的宏，当Makefile被执行时，其中的变量都会被扩展到相应的引用位置上。
4. 文件指示。  其包括了三个部分，一个是在一个Makefile中引用另一个Makefile，就像C语言中的include一样；另一个是指根据某些情况指定Makefile中的有效部分，就像C语言中的预编译#if一样；还有就是定义一个多行的命令。
5. 注释。Makefile中只有行注释，和UNIX的Shell脚本一样，其注释是用"#"字符。如果你要在你的Makefile中使用"#"字符，可以用反斜杠进行转义，如："\#"。

最后，还值得一提的是，在Makefile中的命令，必须要以[Tab]键开始。

GNU的make工作时的执行步骤如下：(想来其它的make也是类似)
1. 读入所有的Makefile。
2. 读入被include的其它Makefile。
3. 初始化文件中的变量。
4. 推导隐晦规则，并分析所有规则。
5. 为所有的目标文件创建依赖关系链。
6. 根据依赖关系，决定哪些目标要重新生成。
7. 执行生成命令。
EOF
}

make_p_library(){ cat - <<'EOF'
常用编译项说明
1.-I:制定头文件搜索的路径
2.-L:连接需要的库文件路径
3.-l:连接需要的库文件(比如：libmylib.so写作 -lmylib)
EOF
}

make_p_subdir_and_link_together(){ cat - <<'make_p_subdir_and_link_together'
.
|-- Makefile
|-- include
|   `-- foo.h
`-- src
    |-- foo.c
    `-- main.c

make -f make_p_subdir_and_link_together
make_p_subdir_and_link_together
}

make_p_build_shared_library(){ cat - <<'make_p_build_shared_library'
.
|-- Makefile
|-- include
|   `-- foo.h
`-- src
    |-- foo.c
    `-- main.c

make -f make_p_build_shared_library
make_p_build_shared_library
}

make_p_build_shared_and_static_library(){ cat - <<'make_p_build_shared_and_static_library'
.
|-- Makefile
|-- includex
|   |-- bar.h
|   `-- foo.h
`-- srcx
    |-- Makefile
    |-- bar.c
    `-- foo.c

make -f make_p_build_shared_and_static_library
make_p_build_shared_and_static_library
}

make_p_build_recursively(){ cat - <<'make_p_build_recursively'
.
|-- Makefile
|-- includey
|   `-- bar.h
|   `-- foo.h
|-- srcy
|   |-- Makefile
|   |-- bar.c
|   `-- foo.c
`-- testy
    |-- Makefile
    `-- test.c

make -f make_p_build_recursively
make_p_build_recursively
}
make_p_auto_variable(){ cat - <<'EOF'
自动化变量说明
1. 这些变量不需要括号括住
$+ :所有的依赖文件，以空格分开，并以出现的先后为序，可能包含重复的依赖文件。
$?:所有的依赖文件，以空格分开，这些依赖文件的修改日期比目标的创建日期晚
$^ :所有的依赖文件，以空格分开，不包含重复的依赖文件。      # $^ 扩展成整个依靠的列表(除掉了里面所有重 复的文件名)
$< :第一个依赖文件的名称。                                # $< 扩展成依靠列表中的第一个依靠文件
$@ :目标的完整名称。                                     # $@ 扩展成当前规则的目的文件名，
$* :不包含扩展名的目标文件名称。                           # 
$% :如果目标是归档成员，则该变量表示目标的归档成员名称。     # 

OBJS = foo.o bar.o                   #  OBJS = foo.o bar.o
CC = gcc                             #  CC = gcc
CFLAGS = -Wall -O -g                 #  CFLAGS = -Wall -O -g
                                     #   
myprog : $(OBJS)                     #  myprog : $(OBJS)
 $(CC) $(OBJS) -o myprog             #   $(CC) $^ -o $@
                                     #   
foo.o : foo.c foo.h bar.h            #  foo.o : foo.c foo.h bar.h
 $(CC) $(CFLAGS) -c foo.c -o foo.o   #   $(CC) $(CFLAGS) -c $< -o $@
                                     #   
bar.o : bar.c bar.h                  #  bar.o : bar.c bar.h
 $(CC) $(CFLAGS) -c bar.c -o bar.o   #   $(CC) $(CFLAGS) -c $< -o $@
 
# syntax/learn-makefile/pattern-rules/Makefile
$@  The file name of the target
$<  The name of the first prerequisite
$^  The names of all the prerequisites
$+  prerequisites listed more than once are duplicated in the order
make -f make_p_auto_variable
EOF
}

make_p_func(){ cat - <<'make_p_func'
1. Find files
js_files  := $(wildcard test/*.js)
all_files := $(shell find images -name "*")

2. Substitutions
file     = $(SOURCE:.cpp=.o)                # foo.cpp => foo.o
outputs  = $(files:src/%.coffee=lib/%.js)

outputs  = $(patsubst %.c, %.o, $(wildcard *.c))
assets   = $(patsubst images/%, assets/%, $(wildcard images/*))

3. More functions
$(strip $(string_var))

$(filter %.less, $(files))
$(filter-out %.less, $(files))
make_p_func
}

make_p_condtion(){ cat - <<'make_p_condtion'
foo: $(objects)
ifeq ($(CC),gcc)
        $(CC) -o foo $(objects) $(libs_for_gcc)
else
        $(CC) -o foo $(objects) $(normal_libs)
endif
make_p_condtion
}

make_p_recursive(){ cat - <<'make_p_recursive'
deploy:
    $(MAKE) deploy2
make_p_recursive
}

make_p_strict(){ cat - <<'make_p_strict'
SHELL := bash         # 2. Always use (a recent) bash
.ONESHELL:            # 3.1 each Make recipe is ran as one single shell session, rather than one new shell per line
.SHELLFLAGS := -eu -o pipefail -c # 2.1 Use bash strict mode
.DELETE_ON_ERROR:     # 3.2 Make rule fails, then it says on the box
.DEFAULT_GOAL := all

MAKEFLAGS := $(MAKEFLAGS)
MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules
MAKEFLAGS += --no-builtin-variables

## use > as prefix to avoid tab/4space or some editor problem
ifeq ($(origin .RECIPEPREFIX), undefined)
  $(error This Make does not support .RECIPEPREFIX. Please use GNU Make 4.0 or later)
endif
.RECIPEPREFIX = >  # 1. Do not use tabs

install::
$(.RECIPEPREFIX)$(a)install -d $(DESTDIR)$(PREFIX)/
endef

test:
> npm run test
.PHONY: test  # Make will not look for a file named `test` on the file system

# Default - top level rule is what gets ran when you run just `make`
build: out/image-id
.PHONY: build

# Clean up the output directories; since all the sentinel files go under tmp, this will cause everything to get rebuilt
clean:
> rm -rf tmp
> rm -rf out
.PHONY: clean

4.1. Generating output files
# Docker image - re-built if the webpack output has been rebuilt
out/image-id:                                   # $ for it is own templating variables
> image_id="example.com/my-app:$$(pwgen -1)"    # the use of $$ instead of $ for bash subshells
> docker build --tag="$${image_id}              # the use of $$ instead of $ for bash variables
> echo "$${image_id}" > out/image-id
4.2 Specifying inputs
out/image-id: $(shell find src -type f)
> image_id="example.com/my-app:$$(pwgen -1)"
> docker build --tag="$${image_id}
> echo "$${image_id}" > out/image-id
4.3 Sentinel files
# Tests - re-ran if any file under src has been changed since tmp/.tests-passed.sentinel was la
out/.packed.sentinel: $(shell find src -type f)
> node run webpack ..
> touch out/.packed.sentinel  # A better option is to have rules that yield lots of files have a “sentinel” output
4.4 On Make magic variables
out/.packed.sentinel: $(shell find src -type f)
> mkdir -p $(@D) # expands to `mkdir -p out`
> node run webpack ..
> touch $@  # expands to `touch out/.packed.sentinel`

# 来自 https://tech.davis-hansson.com/p/make/  Your Makefiles are wrong?
# 进一步 https://github.com/search?p=1&q=RECIPEPREFIX+pipefail+MAKEFLAGS+gcc&type=Code
make_p_strict
}

make_p_string(){ cat - <<'make_p_string'
SRC      = hello_foo.c hello_bar.c foo_world.c bar_world.c
SUBST    = $(subst .c,,$(SRC))
SRCST    = $(SRC:.c=.o)
PATSRCST = $(SRC:%.c=%.o)
PATSUBST = $(patsubst %.c, %.o, $(SRC))
$(filter hello_%, $(SRC))
$(filter-out hello_%, $(SRC))"
$(findstring hello, hello world)
$(findstring hello, ker)
$(findstring world, worl)
$(words $(SRC))
$(word 1,$(SRC))
$(word 2,$(SRC))
$(word 3,$(SRC))
$(word 4,$(SRC))
$(wordlist 1,3,$(SRC))

make -f make_p_string
make_p_string
}
make_k_PHONY(){ cat - <<'EOF'
.PHONY : clean
clean :
    -rm edit $(objects)

告诉 make 不用检查它们是否存在于磁碟上，也不用查找任何隐含规则，直接假设指定的目的需要被更新。

1. 为了避免在makefile中定义的只执行命令的目标和工作目录下的实际文件出现名字冲突，
   规则所定义的命令不是去创建目标文件，而是通过make命令行明确指定它来执行一些特点的命令，就像例题中的clean。
   当一个目标被声明为伪目标后，make在执行规则时不会去试图去查找隐含规则来创建它。这样就提高了make的执行效率，也不用担心由于目标和文件名重名了。
2. 提交执行makefile时的效率。
   
伪目标的另一种使用场合时在make的并行和递归执行过程中。
SUBDIRS=foo bar baz
.PHONY:subdirs $(SUBDIRS)
subdirs: $(SUBDIRS)
$(SUBDIRS):
    $(MAKE) -C $@
# 1、当子目录执行make出现错误，make退出；
# 2、使用这种shell的循环方式时，没有用到make对目录的并行处理功能。

    一般情况下，一个伪目标不作为另一个目标的依赖。当一个伪目标没有作为任何目标的依赖时，我们只能通过make命令
来明确指定它为make的终极目标，来执行它所在规则所定义的命令。
还有一个特别的伪目标all，如果我们在一个目录下创建多个可执行程序，我们可以将所有程序的重建规则在一个makefile中描述。

.PHONY : all obj tag help clean disclean

all：执行主要的编译工作，通常用作缺省目标，放在最前面。
Install：执行编译后的安装工作，把可执行文件、配置文件、文档等分别拷到不同的安装目录。
clean：删除编译生成的二进制文件。
distclean：删除除源文件之外的所有中间生成文件，如配置文件，文档等。
tags：为vim等编辑器生成tags文件。
help：打印当前Makefile的帮助信息，比如有哪些目标可以有make指定去执行。
EOF
}


make_i_func_str_subst(){ cat - <<'EOF'
1.$(subst FROM,TO,TEXT)
函数名称：字符串替换函数:subst。
函数功能：把字串"TEXT"中的"FROM"字符替换为"TO"。
返回值：替换后的新字符串。

[subst]
$(subst FROM,TO,TEXT)                  # 替换后的新字符串。
$(subst ee,EE,feet on the street)      # fEEt on the strEEt

# syntax/learn-makefile/functions/subst.mk
EOF
}

make_i_func_str_patsubst(){ cat - <<'EOF'
2.$(patsubst PATTERN,REPLACEMENT,TEXT)
函数名称：模式替换函数 patsubst。
函数功能：搜索"TEXT"中以空格分开的单词，将否符合模式"TATTERN"替换为"REPLACEMENT"。参数"PATTERN"中可以使用模
式通配符"%"来代表一个单词中的若干字符。如果参数"REPLACEMENT"中也包含一个"%"，那么"REPLACEMENT"中的"%"将是
"TATTERN"中的那个"%"所代表的字符串。在"TATTERN"和"REPLACEMENT"中，只有第一个"%"被作为模式字符来处理，后续的作为字符本上来处理。在两个参数中当使用第一个"%"本是字符本身时，可使用反斜杠"\""对它进行转义处理。
返回值：替换后的新字符串。
函数说明：参数"TEXT"单词之间的多个空格在处理时被合并为一个空格，但前导和结尾空格忽略。

[patsubst]
$(patsubst PATTERN,REPLACEMENT,TEXT)   # 替换后的新字符串
$(patsubst %.c,%.o,x.c.c bar.c)        # x.c.o bar.o

$(VAR:PATTERN=REPLACEMENT)
$(patsubst PATTERN,REPLACEMENT,$(VAR))

$(VAR:SUFFIX=REPLACEMENT)
$(patsubst %SUFFIX,%REPLACEMENT,$(VAR))

$(objects:.o=.c)
$(patsubst %.o,%.c,$(objects))

# syntax/learn-makefile/functions/patsubst.mk
EOF
}

make_i_func_str_strip(){  cat - <<'EOF'
3.$(strip STRINT)
函数名称：去空格函数 strip。
函数功能：去掉字串(若干单词，使用若干空字符分割)"STRINT"开头和结尾的空字符，并将其中多个连续空字符合并为一个空字符。
返回值：无前导和结尾空字符、使用单一空格分割的多单词字符串。
函数说明：空字符包括空格、[Tab]等不可显示字符。

[strip]
$(strip STRINT)         # 无前导和结尾空字符、使用单一空格分割的多单词字符串。
STR = a b c
LOSTR = $(strip $(STR)) # abc

# syntax/learn-makefile/functions/strip.mk
EOF
}

make_i_func_str_findstring(){ cat - <<'EOF'
4.$(findstring FIND,IN)
函数名称：查找字符串函数:findstring。
函数功能：搜索字串"IN"，查找"FIND"字串。
返回值：如果在"IN"之中存在"FIND"，则返回"FIND"，否则返回空。
函数说明：字串"IN"之中可以包含空格、[Tab]。搜索需要是严格的文本匹配。

[findstring]
$(findstring FIND,IN)
$(findstring a,a b c)   # a
$(findstring a,b c)     # 空字符

# syntax/learn-makefile/functions/findstring.mk
EOF
}

make_i_func_str_filter(){  cat - <<'EOF'
5.$(filter PATTERN...,TEXT)
函数名称：过滤函数:filter。
函数功能：过滤掉字串"TEXT"中所有不符合模式"PATTERN"的单词，保留所有符合此模式的单词。可以使用多个模式。模式中一般需要包含模式字符"%"。存在多个模式时，模式表达式之间使用空格分割。
返回值：空格分割的"TEXT"字串中所有符合模式"PATTERN"的字串。
函数说明："filter"函数可以用来去除一个变量中的某些字符串，我们下边的例子中就是用到了此函数。

[filter]
$(filter PATTERN...,TEXT)  # 空格分割的"TEXT"字串中所有符合模式"PATTERN"的字串。
sources := foo.c bar.c baz.s ugh.h
foo: $(sources)
    cc $(filter %.c %.s,$(sources)) -o foo  # foo.c bar.c baz.s 
    
# syntax/learn-makefile/functions/filter.mk
EOF
}

make_i_func_str_filter-out(){  cat - <<'EOF'
6.$(filter-out PATTERN...,TEXT)
函数名称：反过滤函数:filter-out。
函数功能：和"filter"函数实现的功能相反。过滤掉字串"TEXT"中所有符合模式"PATTERN"的单词，保留所有不符合此模式的单词。可以有多个模式。存在多个模式时，模式表达式之间使用空格分割。。
返回值：空格分割的"TEXT"字串中所有不符合模式"PATTERN"的字串。
函数说明："filter-out"函数也可以用来去除一个变量中的某些字符串，(实现和"filter"函数相反)。

[filter-out]
$(filter-out PATTERN...,TEXT)  # 空格分割的"TEXT"字串中所有不符合模式"PATTERN"的字串。
objects=main1.o foo.o main2.o bar.o
mains=main1.o main2.o
    $(filter-out $(mains),$(objects))  # foo.o bar.o

--------------------------------------------------------------------- include libtwt_dial by 
export INCLUDE_LIB_DIAL=no  # 命令开关

# 动态库关联的调试代码
ifeq ($(INCLUDE_LIB_DIAL), yes)
    APPDIRS += twttest/twt_dial
endif

# 动态库的包含libtwt_dial ( INCLUDE_LIB_DIAL=yes )或者 不包含libtwt_dial ( INCLUDE_LIB_DIAL=no )
CSRCS_ALL = $(SDK_LIB_DIRS:%src=%src/*.c)
ifeq ($(INCLUDE_LIB_DIAL), yes)
    CSRCS = $(CSRCS_ALL)
else
    CSRCS = $(filter-out ../libtwt_dial/%,$(CSRCS_ALL))
endif
CPPSRCS_ALL = $(SDK_LIB_DIRS:%src=%src/*.cpp)
ifeq ($(INCLUDE_LIB_DIAL), yes)
    CPPSRCS = $(CPPSRCS_ALL)
else
    CPPSRCS = $(filter-out ../libtwt_dial/%,$(CPPSRCS_ALL))
endif

# syntax/learn-makefile/functions/filter-out.mk
EOF
}

make_p_func_str_sort(){  cat - <<'make_p_func_str_sort'
7.$(sort LIST)
函数名称：排序函数:sort。
函数功能：给字串"LIST"中的单词以首字母为准进行排序(升序)，并取掉重复的单词。
返回值：空格分割的没有重复单词的字串。
函数说明：两个功能，排序和去字串中的重复单词。可以单独使用其中一个功能。

[sort]
$(sort LIST)               # 空格分割的没有重复单词的字串。
$(sort foo bar lose foo)   # bar foo lose
# syntax/learn-makefile/functions/sort.mk

make -f make_p_func_str_sort # using $(sort list) sort list and remove duplicates
make_p_func_str_sort
}

make_i_func_str_word(){  cat - <<'EOF'
8.$(word N,TEXT)
函数名称：取单词函数:word。
函数功能：取字串"TEXT"中第"N"个单词("N"的值从1开始)。
返回值：返回字串"TEXT"中第"N"个单词。
函数说明：如果"N"值大于字串"TEXT"中单词的数目，返回空字符串。如果"N"为0，出错！

[word]
$(word N,TEXT)         # 如果"N"值大于字串"TEXT"中单词的数目，返回空字符串。如果"N"为 0，出错！
$(word 2, foo bar baz) # bar
# syntax/learn-makefile/functions/word.mk
EOF
}

make_i_func_str_wordlist(){  cat - <<'EOF'
9.$(wordlist S,E,TEXT)
函数名称：取字串函数:wordlist。
函数功能：从字串"TEXT"中取出从"S"开始到"E"的单词串。"S"和"E"表示单词在字串中位置的数字。
返回值：字串"TEXT"中从第"S"到"E"(包括"E")的单词字串。
函数说明："S"和"E"都是从1开始的数字。
当"S"比"TEXT"中的字数大时，返回空。如果"E"大于"TEXT"字数，返回从"S"开始，到"TEXT"结束的单词串。如果"S"大于"E"，返回空。

[wordlist]
$(wordlist S,E,TEXT)  # 字串"TEXT"中从第"S"到"E"(包括"E")的单词字串。
$(wordlist 2, 3, foo bar baz) # bar baz
# syntax/learn-makefile/functions/wordlist.mk
EOF
}

make_i_func_str_words(){  cat - <<'EOF'
10.$(words TEXT)
函数名称：统计单词数目函数:words。
函数功能：字算字串"TEXT"中单词的数目。
返回值："TEXT"字串中的单词数。

[words]
$(words TEXT)        # "TEXT"字串中的单词数。
$(words, foo bar)    # 2
字串"TEXT"的最后一个单词就是：$(word $(wordsTEXT),TEXT)。
# syntax/learn-makefile/functions/words.mk
EOF
}

make_i_func_str_firstword(){  cat - <<'EOF'
11.$(firstword NAMES...)
函数名称：取首单词函数:firstword。
函数功能：取字串"NAMES..."中的第一个单词。
返回值：字串"NAMES..."的第一个单词。
函数说明："NAMES"被认为是使用空格分割的多个单词(名字)的序列。函数忽略"NAMES..."中除第一个单词以外的所有的单词。

[firstword]
$(firstword NAMES...)    # 字串"NAMES"的第一个单词。
$(firstword foo bar)   # foo
函数"firstword"实现的功能等效于"$(word 1, NAMES)"
VPATH = src:../includes
override CFLAGS += $(patsubst %,-I%,$(subst :, ,$(VPATH)))
CFLAGS += -Isrc -I../includes

# syntax/learn-makefile/functions/firstword.mk
EOF
}

make_i_func_path_dir(){ cat - <<'EOF'
1.$(dir NAMES...)
函数名称：取目录函数:dir。
函数功能：从文件名序列"NAMES..."中取出各个文件名目录部分。文件名的目录部分就是包含在文件名中的最后一个斜线("/")(包括斜线)之前的部分。
返回值：空格分割的文件名序列"NAMES..."中每一个文件的目录部分。
函数说明：如果文件名中没有斜线，认为此文件为当前目录("./")下的文件。

[dir]
$(dir NAMES...)          # 空格分割的文件名序列"NAMES..."中每一个文件的目录部分。
$(dir src/foo.c hacks)   # src/ ./
# syntax/learn-makefile/functions/dir.mk
EOF
}

make_i_func_path_notdir(){ cat - <<'EOF'
2.$(notdir NAMES...)
函数名称：取文件名函数::notdir。
函数功能：从文件名序列"NAMES..."中取出非目录部分。目录部分是指最后一个斜线("/")(包括斜线)之前的部分。删除所有文件名中的目录部分，只保留非目录部分。
返回值：文件名序列"NAMES..."中每一个文件的非目录部分。
函数说明：如果"NAMES..."中存在不包含斜线的文件名，则不改变这个文件名。以反斜线结尾的文件名，是用空串代替，因此当"NAMES..."中存在多个这样的文件名时，返回结果中分割各个文件名的空格数目将不确定！这是此函数的一个缺陷。

[notdir]
$(notdir NAMES...)        # 文件名序列"NAMES..."中每一个文件的非目录部分
$(notdir src/foo.c hacks) # foo.c hacks
# syntax/learn-makefile/functions/notdir.mk
EOF
}

make_i_func_path_suffix(){ cat - <<'EOF'
3.$(suffix NAMES...)
函数名称：取后缀函数:suffix。
函数功能：从文件名序列"NAMES..."中取出各个文件名的后缀。后缀是文件名中最后一个以点"."开始的(包含点号)部分，如果文件名中不包含一个点号，则为空。
返回值：以空格分割的文件名序列"NAMES..."中每一个文件的后缀序列。
函数说明："NAMES..."是多个文件名时，返回值是多个以空格分割的单词序列。如果文件名没有后缀部分，则返回空。

[suffix]
$(suffix NAMES...)        # 以空格分割的文件名序列"NAMES..."中每一个文件的后缀序列。
$(suffix src/foo.c src-1.0/bar.c hacks) # .c .c
# syntax/learn-makefile/functions/suffix.mk
EOF
}

make_i_func_path_basename(){ cat - <<'EOF'
4.$(basename NAMES...)
函数名称：取前缀函数:basename。
函数功能：从文件名序列"NAMES..."中取出各个文件名的前缀部分(点号之后的部分)。前缀部分指的是文件名中最后一个点号之前的部分。
返回值：空格分割的文件名序列"NAMES..."中各个文件的前缀序列。如果文件没有前缀，则返回空字串。
函数说明：如果"NAMES..."中包含没有后缀的文件名，此文件名不改变。如果一个文件名中存在多个点号，则返回值为此文件名的最后一个点号之前的文件名部分。

[basename]
$(basename NAMES...)     # 空格分割的文件名序列"NAMES..."中各个文件的前缀序列。如果文件没有前缀，则返回空字串。
$(basename src/foo.c src-1.0/bar.c /home/jack/.font.cache-1 hacks) # src/foo src-1.0/bar /home/jack/.font hacks
# syntax/learn-makefile/functions/basename.mk
EOF
}

make_i_func_path_addsuffix(){ cat - <<'EOF'
5.$(addsuffix SUFFIX,NAMES...)
函数名称：加后缀函数:addsuffix。
函数功能：为"NAMES..."中的每一个文件名添加后缀"SUFFIX"。参数"NAMES..."为空格分割的文件名序列，将"SUFFIX"追加到此序列的每一个文件名的末尾。
返回值：以单空格分割的添加了后缀"SUFFIX"的文件名序列。

[addsuffix]
$(addsuffix SUFFIX,NAMES...)  # 以单空格分割的添加了后缀"SUFFIX"的文件名序列。
$(addsuffix .c,foo bar)       # foo.c bar.c
# syntax/learn-makefile/functions/addsuffix.mk
EOF
}

make_i_func_path_addprefix(){ cat - <<'EOF'
6.$(addprefix PREFIX,NAMES...)
函数名称：加前缀函数:addprefix。
函数功能：为"NAMES..."中的每一个文件名添加前缀"PREFIX"。参数"NAMES..."是空格分割的文件名序列，将"SUFFIX"添加到此序列的每一个文件名之前。
返回值：以单空格分割的添加了前缀"PREFIX"的文件名序列。

[addprefix]
$(addprefix PREFIX,NAMES...)  # 以单空格分割的添加了前缀"PREFIX"的文件名序列。
$(addprefix src/,foo bar)     # src/foo src/bar
# syntax/learn-makefile/functions/addprefix.mk
EOF
}

make_i_func_path_join(){ cat - <<'EOF'
7.$(join LIST1,LIST2)
函数名称：单词连接函数::join。
函数功能：将字串"LIST1"和字串"LIST2"各单词进行对应连接。就是将"LIST2"中的第一个单词追加"LIST1"第一个单词字后合并为一个单词；
将"LIST2"中的第二个单词追加到"LIST1"的第二个单词之后并合并为一个单词，......依次列推。
返回值：单空格分割的合并后的字(文件名)序列。
函数说明：如果"LIST1"和"LIST2"中的字数目不一致时，两者中多余部分将被作为返回序列的一部分。

[join]
$(join LIST1,LIST2)           # 单空格分割的合并后的字（文件名）序列。
$(join a b , .c .o)           # a.c b.o
(join a b c , .c .o           # a.c b.o c
# syntax/learn-makefile/functions/join.mk
EOF
}

make_i_func_path_wildcard(){ cat - <<'EOF'
8.$(wildcard PATTERN)
函数名称：获取匹配模式文件名函数wildcard
函数功能：列出当前目录下所有符合模式"PATTERN"格式的文件名。
返回值：空格分割的、存在当前目录下的所有符合模式"PATTERN"的文件名。
函数说明："PATTERN"使用shell可识别的通配符，包括"?"(单字符)、"*"(多字符)等。

[wildcard]
$(wildcard PATTERN)           # 空格分割的、存在当前目录下的所有符合模式"PATTERN"的文件名。
$(wildcard *.c)               # 返回值为当前目录下所有.c 源文件列表。
# syntax/learn-makefile/functions/wildcard.mk
EOF
}

make_i_control_func_foreach(){ cat - <<'EOF'
1.$(foreach VAR,LIST,TEXT)
函数功能：函数"foreach"不同于其它函数。它是一个循环函数。类似于Linux的shell中的循环(for语句)。这个函数的工作过程是这样
的：如果必要(存在变量或者函数的引用)，首先展开变量"VAR"和"LIST"；而表达式"TEXT"中的变量引用不被展开。执行时把"LIST"中使
用空格分割的单词依次取出赋值给变量"VAR"，然后执行"TEXT"表达式。重复直到"LIST"的最后一个单词(为空时结束)。"TEXT"中的变量
或者函数引用在执行时才被展开，因此如果在"TEXT"中存在对"VAR"的引用，那么"VAR"的值在每一次展开式将会到的不同的值。
返回值：空格分割的多次表达式"TEXT"的计算的结果。

[foreach]
$(foreach VAR,LIST,TEXT)     # 空格分割的多次表达式“TEXT”的计算的结果。
dirs := a b c d
files := $(foreach dir,$(dirs),$(wildcard $(dir)/*))
$(wildcard a/*) $(wildcard b/*) $(wildcard c/*) $(wildcard d/*) # 
# syntax/learn-makefile/functions/foreach.mk
EOF
}

make_p_control_func_if(){ cat - <<'make_p_control_func_if'
2.$(if CONDITION,THEN-PART[,ELSE-PART])
函数功能：函数"if"提供了一个在函数上下文中实现条件判断的功能。就像make所支持的条件语句:ifeq。第一个参数"CONDITION"，在函
数执行时忽略其前导和结尾空字符并展开。"CONDITION"的展开结果非空，则条件为真，就将第二个参数"THEN_PATR"作为函数的计算表达
式，函数的返回值就是第二表达式的计算结果；"CONDITION"的展开结果为空，将第三个参数
"ELSE-PART"作为函数的表达式，返回结果为第三个表达式的计算结果。
返回值：根据条件决定函数的返回值是第一个或者第二个参数表达式的计算结果。当不存在第三个参数"ELSE-PART"，并且"CONDITION"展开为空，函数返回空。
函数说明：函数的条件表达式"CONDITION"决定了，函数的返回值只能是"THEN-PART"或者"ELSE-PART"两个之一的计算结果。

[if]
$(if CONDITION,THEN-PART[,ELSE-PART])
根据条件决定函数的返回值是第一个或者第二个参数表达式的计算结果。当不存在第三个参数"ELSE-PART"，并且"CONDITION"展开为空，函数返回空。

SUBDIR += $(if $(SRC_DIR) $(SRC_DIR),/home/src)
# syntax/learn-makefile/functions/if.mk

make -f make_p_control_func_if
make_p_control_func_if
}

make_i_func_call(){  cat - <<'EOF'
3.$(call VARIABLE,PARAM,PARAM,...)
函数功能："call"函数是唯一一个可以创建定制参数化的函数的引用函数。我们可以将一个变量定义为一个复杂的表达式，用"call"函数根据不同的参数对它进行展开来获得不同的结果。
在执行时，将它的参数"PARAM"依次赋值给临时变量"$(1)"、"$(2)"(这些临时变量定义在"VARIABLE"的值中，参考下边的例
子)......
call函数对参数的数目没有限制，也可以没有参数值，没有参数值的"call"没有任何实际存在的意义。执行时变量"VARIABLE"被展开为在函数
上下文有效的临时变量，变量定义中的"$(1)"作为第一个参数，并将函数参数值中的第一个参数赋值给它；变量中的"$(2)"一样被赋值为函数的第二个
参数值；依此类推(变量$(0)代表变量"VARIABLE"本身)。之后对变量"VARIABLE" 表达式的计算值。
返回值：参数值"PARAM"依次替换"$(1)"、"$(2)"...... 之后变量"VARIABLE"定义的表达式的计算值。
函数说明：1.
函数中"VARIBLE"是一个变量名，而不是对变量的引用。因此，通常"call"函数中的"VARIABLE"中不包含"$"(当然，除了此变量名是
一个计算的变量名)。2.
当变量"VARIBLE"是一个make内嵌的函数名时(如"if"、"foreach"、"strip"等)，对"PARAM"参数的使用需要注意，因
为不合适或者不正确的参数将会导致函数的返回值难以预料。3. 函数中多个"PARAM"之间使用逗号分割。4.
变量"VARIABLE"在定义时不能定义为直接展开式！只能定义为递归展开式。

[call]
$(call VARIABLE,PARAM,PARAM,...)

# syntax/gnumake/command/define/Makefile
# syntax/learn-makefile/functions/call.mk
EOF
}

make_i_func_value(){  cat - <<'EOF'
4.value函数
$(value VARIABLE)
函数功能：不对变量"VARIBLE"进行任何展开操作，直接返回变量"VARIBALE"代表的值。这里"VARIABLE"是一个变量名，一般不包含"$"(当然，除了计算的变量名)，
返回值：变量"VARIBALE"所定义文本值(不展开其中的变量或者函数应用)。


# sample Makefile
FOO = $PATH
all:
@echo $(FOO)        # ATH
@echo $(value FOO)  # /bin:/sbin:/usr/bin:/usr/sbin
EOF
}

make_p_func_eval(){  cat - <<'make_p_func_eval'
5.eval函数
函数功能：函数"eval"是一个比较特殊的函数。使用它我们可以在我们的Makefile中构造一个可变的规则结构关系(依赖关系链)，其中可以使用其
它变量和函数。函数"eval"对它的参数进行展开，展开的结果作为Makefile的一部分，make可以对展开内容进行语法解析。展开的结果可以包含
一个新变量、目标、隐含规则或者是明确规则等。也就是说此函数的功能主要是：根据其参数的关系、结构，对它们进行替换展开。
返回值：函数"eval"的返回值时空，也可以说没有返回值。
函数说明："eval"函数执行时会对它的参数进行两次展开。第一次展开过程发是由函数本身完成的，第二次是函数展开后的结果被作为Makefile内容
时由make解析时展开的。明确这一点对于使用"eval"函数非常重要。在理解了函数"eval"二次展开的过程后。实际使用时，当函数的展开结果中存
在引用(格式为：$(x))时，那么在函数的参数中应该使用"$$"来代替"$"。因为这一点，所以通常它的参数中会使用函数"value"来取一个变量
的文本值。

using $(eval) predefine variables
make -f make_p_func_without_eval
make -f make_p_func_eval
make_p_func_eval
}

make_i_func_origin(){  cat - <<'EOF'
$(origin VARIABLE)
函数功能：函数"origin"查询参数"VARIABLE"(通常是一个变量名)的出处。
函数说明："VARIABLE"是一个变量名而不是一个变量的引用。因此通常它不包含"$"(当然，计算的变量名例外)。
返回值：返回"VARIABLE"的定义方式。用字符串表示。
. undefined
变量"VARIABLE"没有被定义。
. default
变量"VARIABLE"是一个默认定义(内嵌变量)。如"CC"、"MAKE"、"RM"等变量。如果在Makefile中重新定义这些变量，函数返回值将相应发生变化。
. environment
变量"VARIABLE"是一个系统环境变量，并且make没有使用命令行选项"-e"(Makefile中不存在同名的变量定义，此变量没有被替代)。
. environment override
变量"VARIABLE"是一个系统环境变量，并且make使用了命令行选项"-e"。Makefile中存在一个同名的变量定义，使用"make -e"时环境变量值替代了文件中的变量定义。
. file
变量"VARIABLE"在某一个makefile文件中定义。
. command line
变量"VARIABLE"在命令行中定义。
. override
变量"VARIABLE"在makefile文件中定义并使用"override"指示符声明。
. automatic
变量"VARIABLE"是自动化变量。

$(origin VARIABLE)
# syntax/learn-makefile/functions/origin.mk
EOF
}

make_i_func_shell(){  cat - <<'EOF'
不同于除"wildcard"函数之外的其它函数。make可以使用它来和外部通信。
函数功能：函数"shell"所实现的功能和shell中的引用(``)相同。实现了命令的扩展。意味着需要一个shell
命令作为它的参数，而返回的结果是此命令在shell中的执行结果。make仅仅对它的回返结果进行处理；make将函数的返回结果中的所有换行符
("\n")或者一对"\n\r"替换为单空格；并去掉末尾的回车符号("\n")或者"\n\r"。函数展开式时，它所调用的命令(它的参数)得到执
行。除了对它的引用出现在规则的命令行中和递归的变量定义引用以外，其它决大多数情况下，make在读取Makefile时函数shell就被扩展。
返回值：函数"shell"的参数在shell中的执行结果。
函数说明：函数本身的返回值是其参数的执行结果，没有进行任何处理。对结果的处理是由make进行的。当对函数的引用出现在规则的命令行中，命令行在执行
时函数引用才被展开。展开过程函数参数的执行时在另外一个shell进程中完成的，因此对于出现在规则命令行的多级"shell"函数引用需要谨慎处理，
否则会影响效率(每一级的"shell"函数的参数都会有各自的shell进程)。

# make可以使用它来和外部通信。
contents := $(shell cat foo)
files := $(shell echo *.c)

# syntax/learn-makefile/functions/shell.mk
EOF
}

make_i_func_error(){  cat - <<'EOF'
$(error TEXT...)
函数功能：产生致命错误，并提示"TEXT..."信息给用户，之后退出make的执行。需要说明的是："error"函数是在函数展开式(函数被调用时)才
提示信息并结束make进程。因此如果函数出现在命令中或者一个递归的变量定义中时，在读取Makefile时不会出现错误。而只有包含
"error"函数引用的命令被执行，或者定义中引用此函数的递归变量被展开时，才会提示致命信息"TEXT..."同时make退出执行。
返回值：空字符
函数说明："error"函数一般不出现在直接展开式的变量定义中，否则在make读取Makefile时将会提示致命错误。
# syntax/learn-makefile/functions/errors.mk
EOF
}

make_p_func_warning(){ cat - <<'EOF'
using $(warning text) check make rules (for debug)

$(warning TEXT...)
函数功能：函数"warning"类似于函数"error"，区别在于它不会导致致命错误(make不退出)，而只是提示"TEXT..."，make的执行过程继续。
返回值：空字符
函数说明：用法和"error"类似，展开过程相同。
# syntax/learn-makefile/functions/errors.mk
make -f make_i_func_warning
EOF
}

make_i_func_warning(){ cat - <<'EOF'
# syntax/learn-makefile/functions/errors.mk
EOF
}

make_i_func_abspath(){ cat - <<'EOF'
# syntax/learn-makefile/functions/abspath.mk
EOF
}

make_i_func_or(){ cat - <<'EOF'
# syntax/learn-makefile/functions/or.mk
EOF
}

make_i_func_and(){ cat - <<'EOF'
# syntax/learn-makefile/functions/and.mk
EOF
}

make_t_control(){ cat - <<'EOF'
使用条件判断，可以让make根据运行时的不同情况选择不同的执行分支。条件表达式可以是比较变量的值，或是比较变量和常量的值。

# 判断$(CC)变量是否"gcc"，如果是的话，则使用GNU函数编译目标。
llibs_for_gcc = -lgnu
normal_libs =

foo: $(objects)
ifeq ($(CC),gcc)
    $(CC) -o foo $(objects) $(libs_for_gcc)
else
    $(CC) -o foo $(objects) $(normal_libs)
endif

ifeq、else和endif。ifeq的意思表示条件语句的开始，并指定一个条件表达式，表达式包含两个参数，以逗号分隔，表达式以圆
括号括起。else表示条件表达式为假的情况。endif表示一个条件语句的结束，任何一个条件表达式都应该以 endif结束。

<conditional-directive> <conditional-directive> 
<text-if-true>          <text-if-true> 
endif                   else 
                        <text-if-false> 
                        endif

ifeq (<arg1>, <arg2>)    ifneq (<arg1>, <arg2>) 
ifeq '<arg1>' '<arg2>'   ifneq '<arg1>' '<arg2>' 
ifeq "<arg1>" "<arg2>"   ifneq "<arg1>" "<arg2>" 
ifeq "<arg1>" '<arg2>'   ifneq "<arg1>" '<arg2>' 
ifeq '<arg1>' "<arg2>"   ifneq '<arg1>' "<arg2>"

ifdef <variable-name>    ifndef <variable-name>

注意：
1. 在<conditional-directive>这一行上，多余的空格是被允许的，但是不能以[Tab]键做为开始(不然就被认为是命令)。
   而注释符"#"同样也是安全的。"else"和"endif"也一样，只要不是以[Tab]键开始就行了。
2. 特别注意的是，make是在读取Makefile时就计算条件表达式的值，并根据条件表达式的值来选择语句，所以，你最好
   不要把自动化变量(如"$@"等)放入条件表达式中，因为自动化变量是在运行时才有的。
   
# syntax/gnumake/condition/Makefile
# syntax/learn-makefile/conditional-parts/Makefile
EOF
}

make_k_include(){ cat - <<'EOF'
FILENAMES 是 shell 所支持的文件名(可以使用通配符)。
include FILENAMES...
通常我们在 Makefile 中可使用"-include"来代替"include"，来忽略由于包含文件不存在或者无法创建时的错误提示

-include .make-settings
# syntax/gnumake/makeclean/Makefile
EOF
}

make_i_annotated(){ cat - <<'EOF'
dir := /foo/bar    # directory to put the frobs in
变量"dir"的值是"/foo/bar    ".这可能并不是想要实现的。
如果一个文件以它作为路径来表示"$(dir)/file"，那么大错特错了。

    在书写 Makefile 时。推荐将注释书写在独立的行或者多行，防止出现上边例子中
的意外情况，而且将注释书写在独立的行也使得 Makefile 清晰，便于阅读。对于特殊
的定义，比如定义包含一个或者多个空格空格的变量时进行详细地说明和注释。
EOF
}


make_i_rule(){ cat - <<'EOF'
[Makefile规则] 规则=目标+[依赖]+[命令]    目标名称即规则名称；对目标名称的引用可以出现在依赖部分，和命令输出部分。
               目标文件 = 命令(依赖文件)  命令即函数，依赖文件即函数形参，目标文件即返回值。
                                          命令(COMMAND)           : (函数) 抽象了依赖文件和目标文件之间的关系。
                                          目标文件(TARGETS)       : 多输出(返回值) 
                                                                    一个具有多目标的规则相当于多个规则。
                                                   自动化变量"$@" : 代表规则的目标。
                                          依赖文件(PREREQUISITES) : 多输入(函数形参)
规则描述了在何种情况下使用什么命令来重建一个特定的文件 ---- 目标文件  (目标文件名称即规则的名称) 即引用目标文件名称，即引用规则名称
                                                            何种情况下: 规则执行的条件。

一个规则告诉"make"两件事: 1. 目标在什么情况下已经过期； 2. 如果需要重建目标时，如何去重建这个目标。
规则的中心思想是：目标文件的内容是由依赖文件文件决定，依赖文件的任何一处改动，将导致目前已经存在的目标文件的内容过期。

规则的顺序: 其它规则的顺序在 makefile 文件中没有意义。终极目标在文件的位置很重要。

终极目标: 是 makefile 文件中第一个规则的目标. 是make默认的更新的哪一个目标。     make命令在不指定目标情况下执行终极目标。
          如果在 makefile 中第一个规则有多个目标的话，那么多个目标中的第一个将会被作为 make 的 "终极目标"。
          makefile 的 "终极目标" 应该就是重建整个程序或者多个程序的依赖关系和执行命令的描述。
例外规则: 以下规则不作为 终极目标。
          模式规则的目标。
          目标名以点号"."开始的并且其后不存在斜线"/".
          
通常规则的语法格式如下：
TARGETS : PREREQUISITES
COMMAND
...
或者：
TARGETS : PREREQUISITES ; COMMAND
COMMAND
...

EOF
# syntax/gnumake/rule
}

make_i_rule_type(){ cat - <<'EOF'
[依赖的类型]
1. 常规依赖           一类是在这些依赖文件被更新后，需要更新规则的目标； # 存在性+更新性 依赖
2. order-only依赖   另一类是更新这些依赖的，可不需要更新规则的目标。     # 存在性依赖

TARGETS : NORMAL-PREREQUISITES | ORDER-ONLY-PREREQUISITES
    书写规则时，"order-only"依赖使用管道符号"|"开始，作为目标的一个依赖文件。规则依赖列表中管道符号"|"左边的是常规依赖，
管道符号右边的就是"order-only"依赖。

LIBS = libtest.a
foo : foo.c | $(LIBS)
$(CC) $(CFLAGS) $< -o $@ $(LIBS)
make在执行这个规则时，如果目标文件"foo"已经存在。当"foo.c"被修改以后，目标"foo"将会被重建，但是当"libtest.a"被修改以后。
将不执行规则的命令来重建目标"foo"。
就是说，规则中依赖文件$(LIBS)只有在目标文件不存在的情况下，才会参与规则的执行。当目标文件存在时此依赖不会参与规则的执行过程。
EOF
}

make_i_rule_wildcard(){ cat - <<'EOF'
[文件名使用通配符]
\syntax\gnumake\rule\wildcard\errorWildcard.mk      # * 错误用法
\syntax\gnumake\rule\wildcard\functionWildcard.mk   # wildcard 正确用法
\syntax\gnumake\rule\wildcard\wordsWildcard.mk      # words 函数
*
?
...
转义 \
Makefile 中统配符可以出现在以下两种场合:
1. 可以用在规则的目标、依赖中，make 在读取 Makefile 时会自动对其进行匹配处理(通配符展开)；
2. 可出现在规则的命令中，通配符的通配处理是在 shell 在执行此命令时完成的。
除这两种情况之外的其它上下文中，不能直接使用通配符。而是需要通过函数 "wildcard" 来实现。 # 例如 变量定义 
objects=$(wildcard *.o)

#sample Makefile
objects := $(patsubst %.c,%.o,$(wildcard *.c))
foo : $(objects)
cc -o foo $(objects)
EOF
}

make_i_rule_search(){ cat - <<'EOF'
[目录搜寻] 当前目录永远是第一搜索目录
1. VPATH: makefile 环境变量
指定依赖文件的搜索路径，当规则的依赖文件在当前目录不存在时，make 会在此变量所指定的目录下去寻找这些依赖文件。
使用空格或者冒号(:)将多个需要搜索的目录分开 #  VPATH = src:../headers
VPATH:$^
GPATH:$@
\syntax\gnumake\rule\path\testUpperVPath.mk  #  make -f testUpperVPath.mk  main | error | clean
\syntax\gnumake\rule\path\testUpperVPathWithInc.mk # make -f testUpperVPathWithInc.mk error | ok  

2. vpath: makefile 关键字
1、vpath PATTERN DIRECTORIES
为所有符合模式"PATTERN"的文件指定搜索目录"DIRECTORIES"。多个目录使用空格或者冒号(:)分开。类似上一小节的"VPATH"变量。
2、vpath PATTERN
清除之前为符合模式"PATTERN"的文件设置的搜索路径。
3、vpath
清除所有已被设置的文件搜索路径。

vapth 使用方法中的"PATTERN"需要包含模式字符"%"。"%"意思是匹配一个或者多个字符，例如，"%.h"表示所有以".h"结尾的文件。
vpath %.h ../headers
并不能指定源文件中包含的头文件所在的路径(在.c 源文件中所包含的头文件路径需要使用 gcc 的"-I"选项来指定)。
vpath PATTERN DIRECTORIES # ":" 是目录的分隔符
vpath %.c     foo
vpath %.c     blish
vpath %.c     bar

vpath %.c     foo : bar
vpath %       blish

\syntax\gnumake\rule\path\testlowerVPath.mk # make -f testlowerVPath.mk
\syntax\learn-makefile\vpath\Makefile       # vpath

目录搜索的机制: 规则"foo : foo.c"，在执行搜索后可能得到的依赖文件为："../src/foo.c"。目录"../src"是使用"VPATH"或"vpath"指定的。
[命令行和搜索目录]
自动化变量"$^" : 代表所有通过目录搜索得到的依赖文件的完整路径名(目录 + 一般文件名)列表
自动化变量"$<" : 代表规则中通过目录搜索得到的依赖文件列表的第一个依赖文件。
自动化变量"$@" : 代表规则的目标。
foo.o : foo.c
    cc -c $(CFLAGS) $^ -o $@
    
VPATH = src:../headers
foo.o : foo.c defs.h hack.h
    cc -c $(CFLAGS) $< -o $@

库文件和搜索目录: Makefile 中程序链接的静态库、共享库同样也可以通过搜索目录得到.

[.LIBPATTERNS]
默认情况下在规则存在"-lNAME"格式的依赖时，链接生成目标时使用"libNAME.so"和"libNAME.a"的原因。
\syntax\gnumake\rule\lib\Makefile # 
EOF
}

make_i_rule_PHONY(){ cat - <<'EOF'
[Makefile伪目标]
伪目标不代表一个真正的文件名，在执行 make 时可以指定这个目标来执行其所在规则定义的命令，有时也可以将一个伪目标称为标签。
\syntax\gnumake\rule\phony\bad.mk    # make -f bad.mk subdir
\syntax\gnumake\rule\phony\good.mk   # make -f good.mk -j8 ; make -C foo
\syntax\gnumake\rule\phony\basic.mk  # make -f basic.mk all

SUBDIRS = foo bar baz
.PHONY: subdirs $(SUBDIRS)
subdirs: $(SUBDIRS)
$(SUBDIRS):
$(MAKE) -C $@
foo: baz
限制同步目录"foo"和"baz"的 make 过程.
在书写一个并行执行 make 的 Makefile时，目录的处理顺序是需要特别注意的。

一个伪目标可以有自己的依赖(可以是一个或者多个文件、一个或者多个伪目标)
all : prog1 prog2 prog3  
.PHONY : all                         # 一个伪目标可以有自己的依赖
prog1 : prog1.o utils.o
cc -o prog1 prog1.o utils.o
prog2 : prog2.o
cc -o prog2 prog2.o
prog3 : prog3.o sort.o utils.o
cc -o prog3 prog3.o sort.o utils.o

.PHONY: cleanall cleanobj cleandiff  #  当一个伪目标作为另外一个伪目标依赖时
cleanall : cleanobj cleandiff
rm program
cleanobj :
rm *.o
cleandiff :
rm *.diff
EOF
}

make_i_rule_FORCE(){ cat - <<'EOF'
[FORCE]       伪目标    是伪目标的一个种类；可被 伪目标 取代
如果一个规则没有命令或者依赖，并且它的目标不是一个存在的文件名。
"clean" 所在规则在被执行时其所定义的命令总会被执行。这样的一个目标通常我们将其命名为"FORCE"。
\syntax\gnumake\rule\phony\basic.mk # make -f basic.mk clean

[空目标文件] 空目标文件 是伪目标的一个变种；
             这个目标可以是一个存在的文件，但文件的具体内容我们并不关心，通常此文件是一个空文件。
[Makefile的特殊目标]
1. PHONY
    目标".PHONY"的所有的依赖被作为伪目标。伪目标时这样一个目标：当使用make命令行指定此目标时，
这个目标所在规则定义的命令、无论目标文件是否存在都会被无条件执行。
2. SUFFIXES
    特殊目标".SUFFIXES"的所有依赖指出了一系列在后缀规则中需要检查的后缀名。
    
# from makep.txt
SUFFIXES := .out .a .ln .o .c .cc .C .cpp .p .f .F .r .y .l .s .S .mod .sym .def .h .info .dvi .tex .texinfo .texi .txinfo .w .ch .web .sh .elc .el

# from cppcheck/Makefile
# Disable implicit rules so canonical targets will work.
.SUFFIXES:

# Remove some rules from gmake that .SUFFIXES does not remove.
SUFFIXES =

.SUFFIXES: .hpux_make_needs_suffix_list
    
3. DEFAULT
    Makefile 中，目标".DEFAULT"所在规则定义的命令，被用在重建那些没有具体规则的目标(明确规则和隐含规则)。
就是说一个文件作为某个规则的依赖，但却不是另外一个规则的目标时。Make 程序无法找到重建此文件的规则，
此种情况时就执行".DEFAULT"所指定的命令。
\syntax\gnumake\rule\emptyTarget\Makefile # DEFAULT

4. .PRECIOUS 忽略
5. .INTERMEDIATE
6. .SECONDARY
7. .DELETE_ON_ERROR
8. .IGNORE
9. .LOW_RESOLUTION_TIME
10 .SILENT
EOF
}

make_i_rule_static(){ cat - <<'EOF'
[静态模式]
\syntax\gnumake\rule\staticPattern\Makefile
    规则存在多个目标，并且不同的目标可以根据目标文件的名字来自动构造出依赖文件。
静态模式规则比多目标规则更通用，它不需要多个目标具有相同的依赖。但是静态模式
规则中的依赖文件必须是相类似的而不是完全相同的。

TARGETS ...: TARGET-PATTERN: PREREQ-PATTERNS ...
    COMMANDS
objects = foo.o bar.o
all: $(objects)
$(objects): %.o: %.c
    $(CC) -c $(CFLAGS) $< -o $@


files = foo.elc bar.o lose.o
$(filter %.o,$(files)): %.o: %.c
    $(CC) -c $(CFLAGS) $< -o $@
$(filter %.elc,$(files)): %.elc: %.el
    emacs -f batch-byte-compile $<

[静态模式和隐含规则]

TARGETS ...: TARGET-PATTERN: PREREQ-PATTERNS ...
COMMANDS

objects = foo.o bar.o
all: $(objects)
    $(objects): %.o: %.c
    $(CC) -c $(CFLAGS) $< -o $@

[双冒号规则]
Newprog :: foo.c
$(CC) $(CFLAGS) $< -o $@
Newprog :: bar.c
$(CC) $(CFLAGS) $< -o $@
如果"foo.c"文件被修改，执行 make 以后将根据"foo.c"文件重建目标"Newprog"。
如果"bar.c"被修改那么"Newprog"将根据"bar.c"被重建。
EOF
}

make_i_rule_automatic(){ cat - <<'EOF'
[自动产生依赖]
\syntax\gnumake\rule\depGen\Makefile  #  
redis_src                             # make dep
gcc -M main.c    # main.o : main.c defs.h
gcc -MM main.c   # 依赖关系不包含头文件

[双冒号规则]
\syntax\gnumake\rule\multiRules\Makefile

# syntax/learn-makefile/implicit-rules/Makefile
EOF
}

make_i_rule_cmd(){ cat - <<'EOF'
[规则书写]
规则中除了第一条紧跟在依赖列表之后使用分号隔开的命令以外，其它的每一行命令行必须以[Tab]字符开始。
多个命令行之间可以有空行和注释行，在执行规则时空行被忽略。
# 所谓空行，就是不包含任何字符的一行。如果以[Tab]键开始而其后没有命令的行，此行不是空行。是空命令行

[makefile sh] and $(SHELL)
执行过程所使用的 shell 决定了规则中的命令的语法和处理机制 # 命令解释和执行机制
通常系统中可能存在多个不同的shell。但在make处理Makefile过程时，如果没有明确指定，那么对所有规则中命令行的解析使用"/bin/sh"来完成。

[命令回显]
\syntax\gnumake\command\flags\Makefile # make -n ; make -s
make -n = --just-print            只是显示命令，但并不真正执行他们，方便用于调试。----- 调试;   set -x
make -s = --silent                所有的命令都不显示                              ----- 批处理  2>&1 >/dev/null
@ 控制命令回显                                                                                  # 命令级别：命令回显
.SLIENT

[命令的执行]
每一行命令将在一个独立的子 shell 进程中被执行，
在 Makefile 中书写在同一行中的多个命令属于一个完整的 shell 命令行，书写在独立行的一条命令是一个独立的 shell 命令行。
SHELL = /bin/sh                   # from make -p
# 书写格式 与 执行过程
foo : bar/lose
    cd bar; gobble lose > ../foo  #  $(SHELL) -c 'cd bar; gobble lose'
foo : bar/lose
    cd bar; \
    gobble lose > ../foo          #  $(SHELL) -c 'cd bar; gobble lose'
    
    cd src && $(MAKE) $@          # ; 命令被依次强制执行。 && 命令被依次成功执行

[命令执行的错误] make会检测命令执行的返回状态
\syntax\gnumake\command\flags\Makefile # make -i; make -k
默认: 如果一个规则中的某一个命令出错(返回非0状态)，make就会放弃对当前规则后续命令的执行，也有可能会终止所有规则的执行。
make -i = --ignore-errors         忽略命令中失败的命令，仍然继续执行                        set -e
make -k = --keep-going            如果某命令出错，则终止该命令，但是编译过程继续向下执行。  set -e
- 命令执行的错误                                                                            # 命令级别：命令执行的错误忽略
.IGNORE

[中断make的执行]
Ctrl-c
.PRECIOUS
1. 目标的重建动作是一个原子的不可被中断的过程；
2. 目标文件的存在仅仅为了记录其重建时间(不关心其内容无)；
3. 这个目标文件必须一直存在来防止其它麻烦。
EOF
}
make_i_rule_recursive(){ cat - <<'EOF'
[make的递归执行]
cd subdir && $(MAKE)
$(MAKE) -C subdir
cd src && $(MAKE) $@    # 在使用 make 的递归调用时，在 Makefile 规则的命令行中应该使用变量"MAKE"来代替直接使用"make"
$(CURDIR)

# syntax/learn-makefile/recursive-make
EOF
}
make_i_rule_export(){ cat - <<'EOF'
[变量和递归] export unexport 
\syntax\gnumake\command\flags\Makefile         # export $(MAKELEVEL) $(MAKEOVERRIDES) $(MAKE)
\syntax\gnumake\command\flags\recursion.mk     # make  [-t|-n|-q]-f recursion.mk all|param_n_t_q1|param_n_t_q2
\syntax\gnumake\command\flags\errorMakeTest.mk #  make -f errorMakeTest.mk
                                               #  make -f errorMakeTest.mk -k
                                               #  make -f errorMakeTest.mk -i
默认上层所传递给子 make 过程的变量定义不会覆盖子 make 过程所执行makefile 文件中的同名变量定义。
默认以子Makefile中的变量定义为准。除非使用make的"-e"选项

export unexport 管理当前工作环境中的变量                                       # 不覆盖子make同名变量定义
已经初始化的环境变量: make -p 中makefile标识的环境变量; make CFLAGS +=-g       # 不覆盖子make同名变量定义
使用命令行指定的变量:                                   make -e CFLAGS +=-g    #   覆盖子make同名变量定义
"SHELL"和"MAKEFLAGS", "MAKEFILES" 在makefile之间自动传递: 无需export           #   覆盖子make同名变量定义
需要明确的是，不能使用"export"或者"unexport"来实现对命令中使用变量的控制功能。 #  export unexport 和 命令行指定的变量关系

MAKELEVEL 调用的深度: 条件测试指令中 ifeq ($(MAKELEVEL),0) 

export VARIABLE ...
unexport VARIABLE ...
指示符"export"或者"unexport"的参数(变量部分)，如果它是对一个变量或者函数的引用，这些变量或者函数将会被立即展开。并赋值给export或者unexport的变量
export VARIABLE = value
export VARIABLE := value
export VARIABLE += value
其实在 Makefile 中指示符"export"和"unexport"的功能和在 shell下功能基本相同.

export和unexport单独使用都是没有作用的。
.EXPORT_ALL_VARIABLES：
VARIABLE1=var1
VARIABLE2=var2

[命令行选项和递归]
MAKEFLAGS： 最上层make的命令行选项会被自动的通过环境变量MAKEFLAGS传递给子make进程。 #  make -s -k 选项 -> MAKEFLAGS=ks
                                                                                    # make CFLAGS+=-g  -> MAKEFLAGS="CFLAGS+=-g"
$(MAKE) MAKEFLAGS= # 取消了子 make 执行时对父 make 命令行选项的继承

make -w = --print-directory       输出运行makefile之前和之后的信息。这个参数对于跟踪嵌套式调用make时很有用。
make      --no-print-directory
make -s = --silent                所有的命令都不显示 

# syntax/learn-makefile/pass-variable-to-sub-make/Makefile
EOF
}

make_i_rule_define(){ cat - <<'EOF'
[定义命令包] 同时用一个变量来代表这一组命令。
\syntax\gnumake\command\define\Makefile # define function
define run-yacc
yacc $(firstword $^)
mv y.tab.c $@
endef

foo.c : foo.y
    $(run-yacc)
    
1. 命令包中的"$^"会被"foo.y"替换；2. "$@"被"foo.c"替换。

[空命令]
target: ;
空命令行可以防止make在执行时试图为重建这个目标去查找隐含命令和".DEFAULT"指定的命令。
EOF
}

make_i_variable(){ cat - <<'EOF'
\syntax\learn-makefile\target-specific-variable-value\Makefile # 目标指定变量和模式指定变量
\syntax\learn-makefile\multi-line-variable\Makefile # define 多行变量
\syntax\learn-makefile\override\Makefile           # override with make argument
\syntax\learn-makefile\variable-expansion\Makefile # = := ?= +=  $(foo:.o=.c) $(foo:%.c=%o)
[使用变量]
=======================================
1. 在目标、依赖、命令中引用变量的地方，变量会被它的值所取代。
2. 变量是一个名字，代表一个文本字符串。

1. Makefile中变量和函数的展开(除规则命令行中的变量和函数以外)，是在make读取makefile文件时进行的，这里的变量
   包括了使用"="定义和使用指示符"define"定义的。
   
2. 变量可以用来代表一个文件名列表、编译选项列表、程序运行的选项参数列表、搜索源文件的目录列表、编译输出的目录列表
   和所有我们能够想到的事物。

3. 变量名是不包括":"、"#"、"="、前置空白和尾空白的任何字符串.
   变量名包括: 字母、数字和下划线，大小写敏感。
   Makefile 传统做法是变量名是全采用大写的方式。
   推荐的做法是在对于内部定义定义的一般变量，使用小写方式。对于一些参数列表采用大写方式。

4. 变量名之中可以包含函数或者其它变量的引用，make在读入此行时根据已定义情况进行替换展开而产生实际的变量名。
5. 变量的定义值在长度上没有限制。不过在使用时还是需要根据实际情况考虑，保证你的机器上有足够的可用的交换空间来处理一个超常的变量值。
6. 当引用一个没有定义的变量时，make 默认它的值为空。
7. 一些特殊的变量在make中有内嵌固定的值不过这些变量允许我们在Makefile中显式得重新给它赋值。       # 隐含变量
8. 还存在一些由两个符号组成的特殊变量，称之为自动环变量。它们的值不能在Makefile 中进行显式的修改. # 自动环变量
EOF
}

make_p_variable_reference(){ cat - <<'make_p_variable_reference'
[变量的引用]
======================================= 变量的风格 
$(VARIABLE_NAME)   Makefile 中定义的或者是 make 的环境变量
${VARIABLE_NAME}   出现在规则命令行中 shell 变量,引用使用 shell 的"${tmp}"格式。
对出现在命令行中的 make 变量我们同样使用"$(CMDVAR)"格式来引用。

Makefile 传统做法是变量名是全采用大写的方式。
推荐的做法是在对于内部定义定义的一般变量(例如：目标文件列表 objects)使用小写方式，而
对于一些参数列表(例如：编译选项 CFLAGS)采用大写方式，但这并不是要求的。

\syntax\gnumake\variable\define\Makefile # make {reference_env | reference2_env | reference2_make}
命令或者文件名中使用"$"时需要用两个美元符号"$$"来表示
echo $PATH     # echo $(P)ATH                                         -> ATH
echo ${PATH}   # echo /bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin    -> /bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin
echo $(PATH)   # echo /bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin    -> /bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin 
echo $$PATH    # echo $PATH                                           -> /bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin 
echo $${PATH}  # echo ${PATH}                                         -> /bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin 
echo $$(PATH)  # echo $(PATH)                                         -> /bin/sh: PATH: command not found 即 $(cmd) 中PATH命令不能执行

对一个变量的引用可以在 Makefile 的任何上下文中，目标、依赖、命令、绝大多数指示符和新变量的赋值中

make -f make_p_variable_reference
make_p_variable_reference
}

make_i_variable_define(){ cat - <<'EOF'
[变量的定义]
objects = main.o foo.o bar.o utils.o
变量名两边的空格和"="之后的空格在 make 处理时被忽略。
=======================================
1.定义方式；2. 展开时机。
A1. 递归展开式变量: "=" 或 "define"
syntax\syntax\variable\one.mk
\syntax\gnumake\variable\define\Makefile  # make recurive_expansion
\syntax\gnumake\variable\replace\Makefile #  define function; call function
\syntax\gnumake\variable\envVariables\Makefile # define function; using env variable 

其优点是: 这种类型变量在定义时,可以引用其它的之前没有定义的变量。可能在后续部分定义，或者是通过 make 的命令行选项传递的变量
其缺点是: 防止递归定义: (递归定义而导致 make 陷入到无限的变量展开过程中，最终使 make 执行失败)         递归定义
          变量定义中如果使用了函数，那么包含在变量值中的函数总会在变量被引用的地方执行(变量被展开时)   延迟展开
          

A2. 直接展开式变量: :=
\syntax\gnumake\variable\define\Makefile # make reference_direct
ifeq (0,${MAKELEVEL})
    cur-dir := $(shell pwd)
    whoami := $(shell whoami)
    host-type := $(shell arch)
    MAKE := ${MAKE} host-type=${host-type} whoami=${whoami}
endif

A3. 定义一个空格:
\syntax\gnumake\variable\define\Makefile # make reference_space
nullstring :=
space := $(nullstring) # end of the line

A4. 条件赋值: ?=
\syntax\gnumake\variable\define\Makefile # make reference_condition
FOO ?= bar
其等价于：
ifeq ($(origin FOO), undefined)
    FOO = bar
endif

A5. 变量的替换引用 $(VAR:A=B) 或 ${VAR:A=B} patsubst函数的简化实现
\syntax\gnumake\variable\replace\test.mk # make -f test.mk { variable_dot | variable_fmt }
foo := a.o b.o c.o
bar := $(foo:.o=.c)
变量"bar"的值就为"a.c b.c c.c"

# $(patsubst A,B $(VAR))
foo := a.o b.o c.o
bar := $(foo:%.o=%.c)

A6:追加变量值 "+="
\syntax\gnumake\variable\define\Makefile # make reference_append
objects += another.o
把字符串"another.o"添加到变量"objects"原有值的末尾，使用空格和原有值分开。

objects = main.o foo.o bar.o utils.o
objects += another.o
相当于：
objects = main.o foo.o bar.o utils.o
objects := $(objects) another.o

A7. override 指示符
\syntax\gnumake\variable\override\Makefile # make 
通常在执行make时，如果通过命令行定义了一个变量，那么它将替代在Makefile中出现的同名变量的定义。
如果不希望命令行指定的变量值替代在 Makefile 中的变量定义，那么我们需要在 Makefile 中使用指示符"override"来对这个变量进行声明，

override VARIABLE = VALUE
或者：
override VARIABLE := VALUE
也可以对变量使用追加方式：
override VARIABLE += MORE TEXT
变量在定义时使用了"override"，则后续对它值进行追加时，也需要使用带有"override"指示符的追加方式。否则对此变量值的追加不会生效。
override 关键字是对 "递归展开式变量" 的一次反动，有const的特性，修改也需要const

可以通过命令行来指定一些附加的编译参数，对一些通用的参数或者必需的编译参数在 Makefile 中指定，而在命令行中指定一些特殊的参数。对于
这种需求，我们就需要使用指示符"override"来实现。
override CFLAGS += -g
这样，在执行 make 时无论在命令行中指定了那些编译选项("指定 CFLAGS"的值)，编译时"-g"参数始终存在。

A8. 多行定义 define 递归展开;可以套嵌引用; 可以使用"override"在定义时声明变量
\syntax\gnumake\variable\override\Makefile 定义变量 # make 
\syntax\gnumake\variable\replace\Makefile  定义函数 # make
\syntax\gnumake\variable\envVariables\Makefile 定义函数 # make
"define"定义变量的语法格式：以指示符"define"开始，"endif"结束，之间的所有内容就是所定义变量的值。
所要定义的变量名字和指示符"define"在同一行，使用空格分开；指示符所在行的下一行开始一直到"endif"所在行的上一行之间的若干行，是变量值。


A9. 系统环境变量
\syntax\gnumake\variable\envVariables\Makefile 系统环境变量 # make
make debug                    # make变量覆盖       系统环境变量
make -e debug                 # make变量不覆盖     系统环境变量
make -e HOSTNAME=server-ftp   # make命令指定新的   系统环境变量
在 Makefile 中对一个变量的定义或者以 make 命令行形式对一个变量的定义，都将覆盖同名的环境变量
而 make 使用"-e"参数时，Makefile 和命令行定义的变量不会覆盖同名的环境变量，make 将使用系统环境变量中这些变量的定义值。

A10. 目标指定变量
\syntax\gnumake\variable\targetVariable\Makefile # 
在Makefile中定义一个变量; static 
对其它Makefile中有效变量: export
上下文中有效    有效变量: 目标指定变量

设置一个目标指定变量的语法为：
TARGET ... : VARIABLE-ASSIGNMENT
或者：
TARGET ... : override VARIABLE-ASSIGNMENT

"VARIABLE-ASSIGNMENT"可以使用任何一个有效的赋值方式，"="(递归)、":="(静态)、"+="(追加)或者"？="(条件)。
使用目标指定变量值时，目标指定的变量值不会影响同名的那个全局变量的值。
目标指定的变量和同名的全局变量属于两个不同的变量，它们在定义的风格(递归展开式和直接展开式)上可以不同。
目标指定的变量变量会作用到由这个目标所引发的所有的规则中去
prog : CFLAGS = -g
prog : prog.o foo.o bar.o
无论 Makefile 中的全局变量"CFLAGS"的定义是什么。对于目标"prog"以及其所引发的所有
(包含目标为"prog.o"、"foo.o"和"bar.o"的所有规则)规则，变量"CFLAGS"值都是'-g'。

A11. 模式指定变量
\syntax\gnumake\variable\patternVariable\Makefile  # make
使用目标定变量定义时，此变量被定义在某个具体目标和由它所引发的规则的目标上。而
模式指定变量定义是将一个变量值指定到所有符合此模式的目标上。

设置一个模式指定变量的语法和设置目标变量的语法相似：
PATTERN ... : VARIABLE-ASSIGNMENT
或者：
PATTERN ... : override VARIABLE-ASSIGNMENT
和目标指定变量语法的唯一区别就是：这里的目标是一个或者多个"模式"目标(包含模式字符"%")。

例如我们可以为所有的.o 文件指定变量"CFLAGS"的值：
%.o : CFLAGS += -O
它指定了所有.o 文件的编译选项包含"-O"选项，不改变对其它类型文件的编译选项。


[变量取值]
=======================================
在运行make时通过命令行选项来取代一个已定义的变量值。                                    override指示符
在makefile文件中通过赋值的方式或者使用"define"来为一个变量赋值                          如何设置变量 
将变量设置为系统环境变量。所有系统环境变量都可以被make使用。                            系统环境变量
自动化变量，在不同的规则中自动化变量会被赋予不同的值。它们每一个都有单一的习惯性用法。  自动化变量 
一些变量具有固定的值。 
                                                                 隐含变量
EOF
}

make_p_variable_macro_bash(){ cat - <<'EOF'
macro vs makefile: 
1. 变量是一个名字, 像是 C 语言中的宏, 代表一个文本字符串.
2. 变量的展开过程和C语言中的宏展开的过程相同，是一个严格的文本替换过程。

bash vs makefile
1. shell 中变量的引用可以是"${xx}"或者"$xx"格式。但在 Makefile 中多字符变量名的引用只能是"$(xx)"或者"${xx}"格式。
EOF
}

make_t_variable_cheat(){ cat - <<'EOF'
1.MAKEFILES变量
		如果在当前环境定义了一个"MAKEFILES"环境变量，
		make执行时首先将此变量的值作为需要读入的
		Makefile文件，
		多个文件之间使用空格分开。
		
2.变量 MAKEFILE_LIST
		make程序在读取多个makefile文件时，
		包括由环境变量"MAKEFILES"指定、命令行指、
		当前工作下的默认的以及使用指示符"include"指定包含的，
		在对这些文件进行解析执行之前make读取的文件名将会被自动依次追加到变量"MAKEFILE_LIST"的定义域中。
3.特殊的变量
		$@ 表示规则中的目标文件名 
		$< 表示第一个依赖文件的名字
		$+ 表示所有依赖文件的集合
		$^ 表示所有依赖文件的集合，去掉了重复的文件名
		$? 表示所有比目标文件新的依赖文件的集合，去掉了重复的文件名
		
		$(@D)
			表示目标文件的目录部分（不包括斜杠）。如果"$@"是"dir/foo.o"，那么"$(@D)"的值为"dir"。如果"$@"不存在斜杠，其值就是"."（当前目录）。注意它和函数"dir"的区别！
		$(@F)
			目标文件的完整文件名中除目录以外的部分（实际文件名）。如果"$@"为"dir/foo.o"，那么"$(@F)"只就是"foo.o"。"$(@F)"等价于函数"$(notdir $@)"。
		$(%D)
		$(%F)
			当以如"archive(member)"形式静态库为目标时，分别表示库文件成员"member"名中的目录部分和文件名部分。它仅对这种形式的规则目标有效。
		$(<D)
		$(<F)
			分别表示规则中第一个依赖文件的目录部分和文件名部分。
		$(^D)
		$(^F)
			分别表示所有依赖文件的目录部分和文件部分（不存在同一文件）。
		$(+D)
		$(+F)
			分别表示所有依赖文件的目录部分和文件部分（可存在重复文件）。
		$(?D)
		$(?F)
			分别表示被更新的依赖文件的目录部分和文件名部分。
		

4.隐藏变量
		隐含规则中所使用的变量（隐含变量）分为两类：1. 代表一个程序的名字（例如："CC"代表了编译器这个可执行程序）。2. 代表执行这个程序使用的参数（例如：变量"CFLAGS"），多个参数使用空格分开。当然也允许在程序的名字中包含参数。但是这种方式建议不要使用。
		以下是一些作为程序名的隐含变量定义：
		代表命令的变量
		
		AR
			函数库打包程序，可创建静态库.a文档。默认是"ar"。
		AS
			汇编程序。默认是"as"。
		CC
			C编译程序。默认是"cc"。
		CXX
			C++编译程序。默认是"g++"。
		CO
			从 RCS中提取文件的程序。默认是"co"。
		CPP
			C程序的预处理器（输出是标准输出设备）。默认是"$(CC) -E"。
		FC
			编译器和预处理Fortran 和 Ratfor 源文件的编译器。默认是"f77"。
		GET
			从SCCS中提取文件程序。默认是"get"。
		LEX
			将 Lex 语言转变为 C 或 Ratfo 的程序。默认是"lex"。
		PC
			Pascal语言编译器。默认是"pc"。
		YACC
			Yacc文法分析器（针对于C程序）。默认命令是"yacc"。
		YACCR
			Yacc文法分析器（针对于Ratfor程序）。默认是"yacc -r"。
		MAKEINFO
			转换Texinfo源文件（.texi）到Info文件程序。默认是"makeinfo"。
		TEX
			从TeX源文件创建TeX DVI文件的程序。默认是"tex"。
		TEXI2DVI
			从Texinfo源文件创建TeX DVI 文件的程序。默认是"texi2dvi"。
		WEAVE
			转换Web到TeX的程序。默认是"weave"。
		CWEAVE
			转换C Web 到 TeX的程序。默认是"cweave"。
		TANGLE
			转换Web到Pascal语言的程序。默认是"tangle"。
		CTANGLE
			转换C Web 到 C。默认是"ctangle"。
		RM
			删除命令。默认是"rm -f"。
			命令参数的变量
		
		下边的是代表命令执行参数的变量。如果没有给出默认值则默认值为空。
		ARFLAGS
			执行"AR"命令的命令行参数。默认值是"rv"。
		ASFLAGS
			执行汇编语器"AS"的命令行参数（明确指定".s"或".S"文件时）。
		CFLAGS
			执行"CC"编译器的命令行参数（编译.c源文件的选项）。
		CXXFLAGS
			执行"g++"编译器的命令行参数（编译.cc源文件的选项）。
		COFLAGS
			执行"co"的命令行参数（在RCS中提取文件的选项）。
		CPPFLAGS
			执行C预处理器"cc -E"的命令行参数（C 和 Fortran 编译器会用到）。
		FFLAGS
			Fortran语言编译器"f77"执行的命令行参数（编译Fortran源文件的选项）。
		GFLAGS
			SCCS "get"程序参数。
		LDFLAGS
			链接器（如："ld"）参数。
		LFLAGS
			Lex文法分析器参数。
		PFLAGS
			Pascal语言编译器参数。
		RFLAGS
			Ratfor 程序的Fortran 编译器参数。
		YFLAGS
			Yacc文法分析器参数。
			
5.变量取值
	MMEDIATE = DEFERRED								变量赋值
	IMMEDIATE ?= DEFERRED							变量没有定义才赋值	
	IMMEDIATE := IMMEDIATE 						    立即展开
	IMMEDIATE += DEFERRED or IMMEDIATE
	define IMMEDIATE									多行定义
		DEFERRED
	endef
	
	define two-lines
	echo foo
	echo $(bar)
	endef
	使用变量
	$(two-lines)
		
6.变量替换
		bar := $(foo:.o=.c)
		bar := $(foo:%.o=%.c)

7.override 指示符
		override VARIABLE = VALUE
		override VARIABLE := VALUE
		override VARIABLE += MORE TEXT
		指示符"override"并不是用来调整Makefile和执行时命令参数的冲突，
		其存在的目的是为了使用户可以改变或者追加那些使用make的命令行指定的变量的定义。
		从另外一个角度来说，就是实现了在Makefile中增加或者修改命令行参数的一种机制。
8.系统环境变量
	make在运行时，系统中的所有环境变量对它都是可见的。在Makefile中，可以引用任何已定义的系统环境变量。

9.条件判定
		关键字"ifeq"
		关键字"ifneq"
				ifeq (ARG1, ARG2)
				ifeq 'ARG1' 'ARG2'
				ifeq "ARG1" "ARG2"
				ifeq "ARG1" 'ARG2'
				ifeq 'ARG1' "ARG2"
		关键字"ifdef"
		关键字"ifndef"
				ifdef VARIABLE-NAME
EOF
}

make_i_control(){ cat - <<'EOF'
[Makefile的条件判断]
\syntax\gnumake\condition\Makefile  # make DEBUG=true | make DEBUG=false

条件语句可以是两个不同变量、或者变量和常量值的比较。
条件语句只能用于控制 make 实际执行的 makefile 文件部分，
条件语句不能控制规则的 shell 命令执行过程。


CONDITIONAL-DIRECTIVE
TEXT-IF-TRUE
endif

CONDITIONAL-DIRECTIVE
TEXT-IF-TRUE
else
TEXT-IF-FALSE
endif

[关键字"ifeq"]
ifeq (ARG1, ARG2)
ifeq 'ARG1' 'ARG2'
ifeq "ARG1" "ARG2"
ifeq "ARG1" 'ARG2'
ifeq 'ARG1' "ARG2"

ifeq ($(strip $(foo)),)
TEXT-IF-EMPTY
endif

[关键字"ifneq"]
ifneq (ARG1, ARG2)
ifneq 'ARG1' 'ARG2'
ifneq "ARG1" "ARG2"
ifneq "ARG1" 'ARG2'
ifneq 'ARG1' "ARG2"

[关键字"ifdef"]
ifdef VARIABLE-NAME

例1：
bar =
foo = $(bar)
ifdef foo
frobozz = yes
else
frobozz = no
endif
例 2：
foo =
ifdef foo
frobozz = yes
else
frobozz = no
endif

[关键字"ifndef"]
ifdef VARIABLE-NAME

[标记测试的条件语句]
archive.a: ...
ifneq (,$(findstring t,$(MAKEFLAGS)))
+touch archive.a
+ranlib -t archive.a
else
ranlib archive.a
endif
这个条件语句判断 make 的命令行参数中是否包含"-t"
EOF
}

make_i_functions(){ cat - <<'EOF'
GNU make 的函数提供了处理文件名、变量、文本和命令的方法.
$(FUNCTION ARGUMENTS)
${FUNCTION ARGUMENTS}
1. 对于用户自己的函数需要通过 make 的"call"函数来间接调用
2. "ARGUMENTS"是函数的参数，参数和函数名之间使用若干个空格或者[tab]字符分割
    如果存在多个参数时，参数之间使用逗号","分开。
    函数的参数不能出现逗号","和空格。这是因为逗号被作为多个参数的分隔符，前导空格会被忽略。
3. 在 Makefile 中应该这样来书写"$(sort $(x))"；而不是"$(sort ${x})"和其它几种。
4. 函数处理参数时，参数中如果存在对其它变量或者函数的引用，首先对这些引用进行展开得到参数的实际内容


[subst]
$(subst FROM,TO,TEXT)                  # 替换后的新字符串。
$(subst ee,EE,feet on the street)      # fEEt on the strEEt

[patsubst]
$(patsubst PATTERN,REPLACEMENT,TEXT)   # 替换后的新字符串
$(patsubst %.c,%.o,x.c.c bar.c)        # x.c.o bar.o

$(VAR:PATTERN=REPLACEMENT)
$(patsubst PATTERN,REPLACEMENT,$(VAR))

$(VAR:SUFFIX=REPLACEMENT)
$(patsubst %SUFFIX,%REPLACEMENT,$(VAR))

$(objects:.o=.c)
$(patsubst %.o,%.c,$(objects))

[strip]
$(strip STRINT)         # 无前导和结尾空字符、使用单一空格分割的多单词字符串。
STR = a b c
LOSTR = $(strip $(STR)) # abc

[findstring]
$(findstring FIND,IN)
$(findstring a,a b c)   # a
$(findstring a,b c)     # 空字符

[filter]
$(filter PATTERN...,TEXT)  # 空格分割的"TEXT"字串中所有符合模式"PATTERN"的字串。
sources := foo.c bar.c baz.s ugh.h
foo: $(sources)
    cc $(filter %.c %.s,$(sources)) -o foo  # foo.c bar.c baz.s

[filter-out]
$(filter-out PATTERN...,TEXT)  # 空格分割的"TEXT"字串中所有不符合模式"PATTERN"的字串。
objects=main1.o foo.o main2.o bar.o
mains=main1.o main2.o
    $(filter-out $(mains),$(objects))  # foo.o bar.o

[sort]
$(sort LIST)               # 空格分割的没有重复单词的字串。
$(sort foo bar lose foo)   # bar foo lose

[word]
$(word N,TEXT)         # 如果"N"值大于字串"TEXT"中单词的数目，返回空字符串。如果"N"为 0，出错！
$(word 2, foo bar baz) # bar

[wordlist]
$(wordlist S,E,TEXT)  # 字串"TEXT"中从第"S"到"E"(包括"E")的单词字串。
$(wordlist 2, 3, foo bar baz) # bar baz

[words]
$(words TEXT)        # "TEXT"字串中的单词数。
$(words, foo bar)    # 2
字串"TEXT"的最后一个单词就是：$(word $(wordsTEXT),TEXT)。

[firstword]
$(firstword NAMES...)    # 字串"NAMES"的第一个单词。
$(firstword foo bar)   # foo
函数"firstword"实现的功能等效于"$(word 1, NAMES)"
VPATH = src:../includes
override CFLAGS += $(patsubst %,-I%,$(subst :, ,$(VPATH)))
CFLAGS += -Isrc -I../includes



[dir]
$(dir NAMES...)          # 空格分割的文件名序列"NAMES..."中每一个文件的目录部分。
$(dir src/foo.c hacks)   # src/ ./

[notdir]
$(notdir NAMES...)        # 文件名序列"NAMES..."中每一个文件的非目录部分
$(notdir src/foo.c hacks) # foo.c hacks

[suffix]
$(suffix NAMES...)        # 以空格分割的文件名序列"NAMES..."中每一个文件的后缀序列。
$(suffix src/foo.c src-1.0/bar.c hacks) # .c .c

[basename]
$(basename NAMES...)     # 空格分割的文件名序列"NAMES..."中各个文件的前缀序列。如果文件没有前缀，则返回空字串。
$(basename src/foo.c src-1.0/bar.c /home/jack/.font.cache-1 hacks) # src/foo src-1.0/bar /home/jack/.font hacks

[addsuffix]
$(addsuffix SUFFIX,NAMES...)  # 以单空格分割的添加了后缀"SUFFIX"的文件名序列。
$(addsuffix .c,foo bar)       # foo.c bar.c

[addprefix]
$(addprefix PREFIX,NAMES...)  # 以单空格分割的添加了前缀"PREFIX"的文件名序列。
$(addprefix src/,foo bar)     # src/foo src/bar

[join]
$(join LIST1,LIST2)           # 单空格分割的合并后的字（文件名）序列。
$(join a b , .c .o)           # a.c b.o
(join a b c , .c .o           # a.c b.o c

[wildcard]
$(wildcard PATTERN)           # 空格分割的、存在当前目录下的所有符合模式“PATTERN”的文件名。
$(wildcard *.c)               # 返回值为当前目录下所有.c 源文件列表。


[foreach]
$(foreach VAR,LIST,TEXT)     # 空格分割的多次表达式“TEXT”的计算的结果。
dirs := a b c d
files := $(foreach dir,$(dirs),$(wildcard $(dir)/*))
$(wildcard a/*) $(wildcard b/*) $(wildcard c/*) $(wildcard d/*) # 

[if]
$(if CONDITION,THEN-PART[,ELSE-PART])
根据条件决定函数的返回值是第一个或者第二个参数表达式的计算结果。当不存在第三个参数"ELSE-PART"，并且"CONDITION"展开为空，函数返回空。

SUBDIR += $(if $(SRC_DIR) $(SRC_DIR),/home/src)

[call]
$(call VARIABLE,PARAM,PARAM,...)

EOF
}

make_i_automatic(){ cat - <<'EOF'
1. 我们不能改变 make 内嵌的隐含规则，但可以使用模式规则重新定义自己的隐含规则，也可以使用后追规则来重新定义隐含规则。
2. 每一个内嵌的隐含规则中都存在一个目标模式和依赖模式，而且同一个目标模式可以对应多个依赖模式。

$(CC) -c $(CPPFLAGS) $(CFLAGS)
$(CXX) -c $(CPPFLAGS) $(CFLAGS)
$(CC) $(LDFLAGS) N.o $(LOADLIBES) $(LDLIBS)

%.o : %.c
    $(CC) -c $(CFLAGS) $(CPPFLAGS) $< -o $@

.c.o:
$(CC) -c $(CFLAGS) $(CPPFLAGS) -o $@ $<
   
.c.o: foo.h
$(CC) -c $(CFLAGS) $(CPPFLAGS) -o $@ $<

%.o: %.c foo.h
$(CC) -c $(CFLAGS) $(CPPFLAGS) -o $@ $<   
EOF
}

make_t_automatic(){ cat - <<'EOF'
CUR_DIR = $(shell pwd)
INCS := $(CUR_DIR)/include
CFLAGS := -Wall –I$(INCS)
EXEF := foo bar
.PHONY : all clean
all : $(EXEF)
foo : CFLAGS+=-O2
bar : CFLAGS+=-g
clean :
$(RM) *.o *.d $(EXES)
EOF
}
