# $(strip STRINT) 
# 函数名称：去空格函数—strip。 
# 函数功能：去掉字串（若干单词，使用若干空字符分割） "STRINT"开头和结尾的空字符，并将其中多个连续空字符合并为一个空字符。 
# 返回值：无前导和结尾空字符、使用单一空格分割的多单词字符串。 
# 函数说明：空字符包括空格、[Tab]等不可显示字符。 
# 示例： 
# STR =        a    b c      
# LOSTR = $(strip $(STR)) 
# 结果是"a b c"。 
# "strip"函数经常用在条件判断语句的表达式中，确保表达式比较的可靠和健壮！

STR =        a    b c 
LOSTR = $(strip $(STR))
all:
	@echo "$(STR)"
	@echo "$(LOSTR)"