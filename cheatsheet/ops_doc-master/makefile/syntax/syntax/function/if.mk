# if 函数
# 函数"if"提供了一个在函数上下文中实现条件判断的功能。就像make所支持的条件语句—ifeq
# 函数语法: $(if CONDITION,THEN-PART[,ELSE-PART])
# 函数示例:
SUBDIR += $(if $(SRC_DIR) $(SRC_DIR),/home/src)
# 函数的结果是:如果"SRC_DIR"变量值不为空,则将变量"SRC_DIR"指定的目录作为一个子目录;否则将目录"/home/src"作为一个子目录。