mk_help(){
  echo "mk_variable"
  echo "mk_command:"
  echo "mk_bash:"
  echo "mk_condition:"
  echo "mk_include"
  echo "mk_function:"
  echo "mk_redis"
}

mk_variable(){
cat - <<'EOF'
A1. 递归展开式变量: "=" 或 "define"
A2. 直接展开式变量: :=
A3. 定义一个空格:   EMPTY := 
A4. 条件赋值:       ?=
A5. 变量的替换引用 $(VAR:A=B) 或 ${VAR:A=B} patsubst函数的简化实现
    var = $(foo:%.o=%.c) # 把变量foo中所有以".o"结尾的全部替换成".c"
A6: 追加变量值 "+="
A7. override 指示符
         | variable         Makefile可用变量
make -p :|     makefile     make环境变量                   make 的环境变量只是对于 make 的一次执行过程有效
         |     default      make设置默认gcc，rm等相关变量
         |     automatic    make根据位置自动推导所得变量
         |     environment  bash环境变量                   系统环境变量是这个系统所有用户所拥有的
         | rules            make自动推导规则
         |                  %.o: %.s
         | .SUFFIXES        make后缀推导规则
         | .SUFFIXES: .out .a .ln .o .c .cc .C .cpp .p .f .F .r .y .l .s .S .mod .sym .def .h .info .dvi .tex .texinfo .texi .txinfo .w .ch .web .sh .elc .el
EOF

cat - <<'EOF'
  $@      表示规则中的目标文件集。在模式规则中，如果有多个目标，那么，"$@"就是匹配于目标中模式定义的集合。注意，其是一个一个取出来的。
  $%      仅当目标是函数库文件中，表示规则中的目标成员名。例如，如果一个目标是"foo.a (bar.o)"，那么，"$%"就是"bar.o"，"$@"就是"foo.a"。
          如果目标不是函数库文件（Unix下是[.a]，Windows下是[.lib]），那么，其值为空。
  $<      依赖目标中的第一个目标名字。如果依赖目标是以模式（即"%"）定义的，那么"$<"将是符合模式的一系列的文件集。注意，其是一个一个取出来的。
  $?      所有比目标新的依赖目标的集合。以空格分隔。
  $^      所有的依赖目标的集合。以空格分隔。如果在依赖目标中有多个重复的，那个这个变量会去除重复的依赖目标，只保留一份。
  $+      这个变量很像"$^"，也是所有依赖目标的集合。只是它不去除重复的依赖目标。
  $*      这个变量表示目标模式中"%"及其之前的部分。如果目标是"dir/a.foo.b"，并且目标的模式是"a.%.b"，那么，"$*"的值就是"dir/a.foo"。
EOF

make -f  ${BASHRC_PATH}/cheatsheet/ops_doc-master/makefile/syntax/learn-makefile/pattern-rules
}


mk_command(){
cat - <<'EOF'

  \   换行符，命令或者依赖过长时，可以使用它换行
   for F in $(SRCS); do \
  ...
done
RTUDRELEASE = "\"rtud $(VERSION).$(PATCHLEVEL).$(SUBLEVEL) @ svn $(REV) @$(COMPNOY) build at $(BUILD_DATE)\""
  
  -   放在最前面，表示如果后面的语句出问题了，不要管，继续做后面的事情
-(cd ../deps && $(MAKE) distclean)
-(rm -f .make-*)
  
  @   放在最前面，表示取消当前行命令的回显，默认情况下，命令是被回显的
@echo "Hint: To run 'make test' is a good idea ;)"
  
  $   变量或者函数的前缀，如果需要真实的$符号，则需要用"$$"来表示
sed -i 's/[ \t]*$$//g' *.[ch]
EOF
}

mk_bash(){
cat - <<'EOF'
[variable]
  BUILD_DATE := $(shell LANG=C date +%Y-%m-%d_%X) 
  GCC_VERSION := $(shell LANG=C gcc -dumpversion | cut -b 1)
  sanitizer ?= $(shell test ${GCC_VERSION} -gt 4 &&  echo "yes"  ||  echo "no")

release_hdr := $(shell sh -c './mkreleasehdr.sh')
uname_S := $(shell sh -c 'uname -s 2>/dev/null || echo not')

man bash(GNU Bourne-Again SHell)|dash(command interpreter (shell))
bash -c 'command string' | dash -c 'command string'

[command]
    for F in $(SRCS); do \
  ...
done

complexity --histogram --score --thresh=3 $(SRCS)
EOF
}


mk_condition(){
cat - <<'EOF'
ifeq ifneq ifdef ifndef
ifeq (ARG1, ARG2)
ifeq 'ARG1' 'ARG2'
ifeq "ARG1" "ARG2"
ifeq "ARG1" 'ARG2'
ifeq 'ARG1' "ARG2"

else

endif

redis: MALLOC 根据系统确定默认内存管理库；然后根据配置选择指定内存管理库。
EOF

make -f ${BASHRC_PATH}/cheatsheet/ops_doc-master/makefile/syntax/gnumake/condition/Makefile
}

mk_include(){
cat - <<'EOF'
    FILENAMES 是 shell 所支持的文件名(可以使用通配符)。
    include FILENAMES...
    通常我们在 Makefile 中可使用"-include"来代替"include"，来忽略由于包含文件不存在或者无法创建时的错误提示

    -include .make-settings
EOF
}

mkt_subst(){
cat - <<'EOF'
[subst]
$(subst FROM,TO,TEXT)                  # 替换后的新字符串。
$(subst ee,EE,feet on the street)      # fEEt on the strEEt
EOF
}

mkt_patsubst(){
cat - <<'EOF'
[patsubst]
$(patsubst PATTERN,REPLACEMENT,TEXT)   # 替换后的新字符串
$(patsubst %.c,%.o,x.c.c bar.c)        # x.c.o bar.o

$(VAR:PATTERN=REPLACEMENT)
$(patsubst PATTERN,REPLACEMENT,$(VAR))

$(VAR:SUFFIX=REPLACEMENT)
$(patsubst %SUFFIX,%REPLACEMENT,$(VAR))

$(objects:.o=.c)
$(patsubst %.o,%.c,$(objects))
EOF
}

mkt_strip(){
cat - <<'EOF'
[strip]
$(strip STRINT)         # 无前导和结尾空字符、使用单一空格分割的多单词字符串。
STR = a b c
LOSTR = $(strip $(STR)) # abc
EOF
}

mkt_findstring(){
cat - <<'EOF'
[findstring]
$(findstring FIND,IN)
$(findstring a,a b c)   # a
$(findstring a,b c)     # 空字符
EOF
}

mk_function(){
cat - <<'EOF'
[process text:string]
mkt_subst
mkt_patsubst
mkt_strip
mkt_strip

[process directory:dir]

EOF
}

mk_redis(){
echo "REDIS_CC(STD,WARN,OPT,DEBUG,CFLAGS,REDIS_CFLAGS); REDIS_LD(LDFLAGS,REDIS_LDFLAGS,DEBUG); FINAL_LIBS"
cat - <<'EOF'
                                             CCCOLOR="\033[34m"       SRCCOLOR="\033[33m"   ENDCOLOR="\033[0m"
           QUIET_CC = @printf '    %b %b\n' $(CCCOLOR)CC$(ENDCOLOR) $(SRCCOLOR)$@$         (ENDCOLOR) 1>&2;
REDIS_CC=$(QUIET_CC)$(CC) $(FINAL_CFLAGS)
                            FINAL_CFLAGS+= -DUSE_TCMALLOC                            ?
                            FINAL_CFLAGS+= -DUSE_TCMALLOC                            ?
                            FINAL_CFLAGS+= -DUSE_JEMALLOC -I../deps/jemalloc/include ?
                            FINAL_CFLAGS+= -I../deps/hiredis -I../deps/linenoise -I../deps/lua/src
                            FINAL_CFLAGS=$(STD) $(WARN) $(OPT) $(DEBUG) $(CFLAGS) $(REDIS_CFLAGS)
                                           STD=-std=c99 -pedantic
                                                  WARN=-Wall
                                                          OPT=$(OPTIMIZATION)
                                                                OPTIMIZATION?=-O2
                            

                                                LINKCOLOR="\033[34;1m"      BINCOLOR="\033[37;1m"   ENDCOLOR="\033[0m"
           QUIET_LINK = @printf '    %b %b\n' $(LINKCOLOR)LINK$(ENDCOLOR) $(BINCOLOR)$@$           (ENDCOLOR) 1>&2;
REDIS_LD=$(QUIET_LINK)$(CC) $(FINAL_LDFLAGS)
                              FINAL_LDFLAGS=$(LDFLAGS) $(REDIS_LDFLAGS) $(DEBUG)

FINAL_LIBS=-lm
FINAL_LIBS+= -ldl -lnsl -lsocket -lpthread ?SunOS
FINAL_LIBS+= -pthread
FINAL_LIBS+= -ltcmalloc                              ?
FINAL_LIBS+= -ltcmalloc_minimal                      ?
FINAL_LIBS+= ../deps/jemalloc/lib/libjemalloc.a -ldl ?
EOF
}

