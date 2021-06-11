# $(subst FROM,TO,TEXT) 
# 函数名称：字符串替换函数—subst。 
# 函数功能：把字串"TEXT"中的"FROM"字符替换为"TO"。 
# 返回值：替换后的新字符串。 
# 示例： 
#  
# $(subst ee,EE,feet on the street) 
#  
# 替换"feet on the street"中的"ee"为"EE"，结果得到字符串"fEEt on the strEEt"

.PHONY: all

FROM = ee
TO = "EE"
TEXT = "feet on the street"

OUTPUT = $(subst $(FROM),$(TO),$(TEXT)) 
all:
	@echo # readonly
	@echo "call(subst ee,EE,feet on the street)"
	@echo $(subst ee,EE,feet on the street) 
	@echo # call preview
	@echo "call(subst $(FROM),$(TO),$(TEXT))"
	@echo $(OUTPUT) 
	@echo # call now
	@echo "$(subst $(FROM),$(TO),$(TEXT))"