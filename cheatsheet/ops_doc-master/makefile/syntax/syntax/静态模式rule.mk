# 静态模式规则的语法
# TARGETS ...: TARGET-PATTERN: PREREQ-PATTERNS ...
# COMMANDS

objects = foo.o bar.o

all: $(objects)

$(objects): %.o: %.c
	$(CC) -c $(CFLAGS) $< -o $@


# filter
files = foo.elc bar.o lose.o
# $(filter %.o,$(files))的结果为“bar.o lose.o”。过滤.o文件
$(filter %.o,$(files)): %.o: %.c
	$(CC) -c $(CFLAGS) $< -o $@

# 过滤.elc文件
$(filter %.elc,$(files)): %.elc: %.el
	emacs -f batch-byte-compile $<

# 当执行此规则的命令时，自动环变量“$*”被展开为“茎”。
#在这里就是“big”和“little”。
bigoutput littleoutput : %output : text.g
generate text.g -$* > $@