################################################################# 
# A demo Makefile 
# By xbb (http://xnzaa.github.io)
# function:
#   分布式的Makefile管理多目录工程的代码，通过静态链接库生成最终程序.
# bugs: 
#   1. 需要显式指定库位置、名称； 
#   2. make 及 make clean处理得不好(对于库，要么删除再编译，要么无操作)； 
################################################################# 
CC=gcc
CFLAGS := -Wall
DEBUG = y
ifeq ($(DEBUG), y)
CFLAGS += -g
else
CFLAGS += -O2
endif
SUBDIRS := bar foo
LIBS := foo/libfoo.a bar/libbar.a
LDFLAGS = $(LIBS)
RM = -rm -rf
__OBJS := main.o
__SRCS = $(subst .o,.c,$(__OBJS))
target = bin/a.out
MAKE = make
#all: clean $(target) 
all: $(target)
$(__OBJS): $(__SRCS)
	$(CC) $(CFLAGS) -c $^ -I ./include/
$(target): $(__OBJS)
	for dir in $(SUBDIRS);do $(MAKE) -C $$dir all || exit 1; done #-C enter son dir to make
	$(CC) $(CFLAGS) $^ -o $@ $(LDFLAGS)
clean:
	@for dir in $(SUBDIRS); do make -C $$dir clean || exit 1; done
	$(RM) $(__OBJS) $(target) *.bak *~
	$(RM) ./bin/* || exit 1
.PHONY: all clean
