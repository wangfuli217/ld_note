# $(findstring FIND,IN) 
# 函数名称：查找字符串函数—findstring。 
# 函数功能：搜索字串“IN”，查找“FIND”字串。 
# 返回值：如果在“IN”之中存在“FIND” ，则返回“FIND”，否则返回空。 
# 函数说明：字串“IN”之中可以包含空格、[Tab]。搜索需要是严格的文本匹配。 
# 示例： 
# $(findstring a,a b c) 
# $(findstring a,b c) 
# 第一个函数结果是字“a”；第二个值为空字符。


IN =        a    b c 
FIND = a
OUTPUT = $(findstring $(FIND),$(IN))
all:
	@echo "call(findstring a,a b c)"
	@echo $(findstring a,a b c) 
	
	@echo "call(findstring $(FIND),$(IN))" 
	@echo $(OUTPUT) 