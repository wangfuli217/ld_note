#   当我们定义了一个变量之后，就可以在 Makefile 的很多地方使用这个变量。变量的引用方式是：
# 使用"$(VARIABLE_NAME)"或者"${VARIABLE_NAME}"来引用一个变量的定义。美元符号"$"在 Makefile 
# 中有特殊的含义，所有在命令或者文件名中使用"$"时需要用两个美元符号"$$"来表示。

# 1. Makefile变量可以使用$(VARIABLE_NAME) ${VARIABLE_NAME}             两种方法引用
# 2. 环境变量可以使用$(VARIABLE_NAME) ${VARIABLE_NAME} $$VARIABLE_NAME 三种方法引用
# 3. shell变量只能使用 $$VARIABLE_NAME                                 一种方法引用
# 4. @for 命令 的"\" 行连接符后面不能有空格，否则会报错
# 5. @for 命令 中不能有注释出现，否则会报错
# 6. shell可以引用Makefile中的变量，Makefile可以通过 $(shell bash command) 方式调用shell 命令

TEST  = automatic
TEST += standard
TEST += expand
TEST += substitute

CPATH="/data/"
EPATH=$(shell pwd) 

SUBDIRS = src foo 
all:
	@echo ${CPATH}  # /data/
	@echo $(CPATH)  # /data/
	@echo $$CPATH   # 
	@echo $CPATH    # PATH

	@echo ${PATH}   # /usr/lib64/qt-3.3/bin:/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/root/bin
	@echo $(PATH)   # /usr/lib64/qt-3.3/bin:/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/root/bin
	@echo $$PATH    # /usr/lib64/qt-3.3/bin:/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/root/bin
	@echo $PATH     # ATH 

	@echo ${EPATH}  # /root/rtu/otdr/crosstool/cheatsheet/ops_doc-master/makefile/syntax/shell/variable
	@echo $(EPATH)  # /root/rtu/otdr/crosstool/cheatsheet/ops_doc-master/makefile/syntax/shell/variable
	@echo $$EPATH   # 
	@echo $EPATH    # PATH

	@for i in $(TEST) ; do \
		if test $$i = expand ; then \
			echo "$$i == expand" ; \
		else \
			echo "$$i != expand" ;\
		fi  ;\
	done 

dir:
	@echo "hello world"
	@for dir in $(SUBDIRS) ; do \
		echo "$$dir" ; \
		echo "$$PATH" ; \
	done 


# 一般在我们书写 Makefile 时，各部分变量引用的格式我们建议如下：
# make 变量(Makefile 中定义的或者是 make 的环境变量)的引用使用"$(VAR)"格式，无论"VAR"是单字符变量名还是多字符变量名。
# 出现在规则命令行中 shell 变量(一般为执行命令过程中的临时变量，它不属于 Makefile 变量，而是一个 shell 变量)引用使用 shell 的"$tmp"格式。
# 对出现在命令行中的 make 变量我们同样使用"$(CMDVAR)" 格式来引用。
