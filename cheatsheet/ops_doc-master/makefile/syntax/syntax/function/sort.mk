# $(sort LIST) 
# 函数名称：排序函数—sort。 
# 函数功能：给字串"LIST"中的单词以首字母为准进行排序"升序"，并取掉重复
# 的单词。 
# 返回值：空格分割的没有重复单词的字串。 
# 函数说明：两个功能，排序和去字串中的重复单词。可以单独使用其中一个功能。 
# 示例： 
# $(sort foo bar lose foo) 
#  
# 返回值为："bar foo lose" 。

LIST = foo bar lose foo

OUTPUT = $(sort $(LIST))

.PHONY: all

all:
	@echo # readonly
	@echo "call(sort foo bar lose foo)"
	@echo $(sort foo bar lose foo)
	
	@echo # call previous
	@echo $(OUTPUT)
	
	@echo # call now
	@echo $(sort $(LIST))
