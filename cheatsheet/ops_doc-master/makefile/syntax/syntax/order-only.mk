#常规依赖  "order-only"依赖
TARGETS : NORMAL-PREREQUISITES | ORDER-ONLY-PREREQUISITES

CC = cc
# order-only"依赖的使用举例:
LIBS = libtest.a
foo : foo.c | $(LIBS)
	$(CC) $(CFLAGS) $< -o $@ $(LIBS)

# make在执行这个规则时,如果目标文件"foo"已经存在。当"foo.c"被修改以后,目标"foo" \
将会被重建,但是当"libtest.a"被修改以后。将不执行规则的命令来重建目标"foo"。


CC_SRCS = $(wildcard *.c)
CC_OBJS = $(patsubst %.c,%.o,$(wildcard *.c))
#首先使用"wildcard"
#函数获取工作目录下的.c 文件列表;之后将列表中所有文件名的后缀.c 替换为.o
objects := $(patsubst %.c,%.o,$(wildcard *.c))
foo : $(objects)
	cc -o foo $(objects)