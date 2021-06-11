# value函数
# 函数"value"提供了一种在不对变量进行展开的情况下获取变量值的方法。
# 函数语法: $(value VARIABLE)
# 函数功能:不对变量"VARIBLE"进行任何展开操作,直接返回变量"VARIBALE"的值。这里"VARIABLE"是一个变量名,一般不包含"$"(除非计算的变量名),
# 返回值:变量"VARIBALE"所定义文本值(如果变量定义为递归展开式,其中包含对其他变量或者函数的引用,那么函数不对这些引用进行展开。函数的返回值是包含有引用值)。
# 函数说明:
# 示例:
# sample Makefile
FOO = $PATH
BAR = $(PATH)
SAR = ${PATH}
all:
	@echo $(FOO)
	@echo $(value FOO)
	@echo $(value $FOO)
	@echo 
	@echo $(BAR)
	@echo ${BAR}
	@echo $BAR
	@echo 
	@echo $(SAR)
	@echo ${SAR}
	@echo $SAR
# 执行make,可以看到的结果是:第一行为:"ATH"。这是因为变量"FOO"定义为"$PATH",所以展开为"ATH"("$P"为空,参考 6.1 变量的引用 一节)。第二行才是我们需要显示的系统环境变量"PATH"的值(value函数得到变量"FOO"的值为"$PATH")。
