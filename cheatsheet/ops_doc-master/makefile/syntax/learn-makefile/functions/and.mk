# $(and condition1[,condition2[,condition3...]])
#   The and function provides a "short-circuiting" AND operation.
#   Each argument is expanded, in order. If an argument expands
#   to an empty string the processing stops and the result of
#   the expansion is the empty string. If all arguments expand to
#   a non-empty string then the result of the expansion is the 
#   expansion of the last argument.
obj1 = obj1
obj2 = 
obj3 = obj3
and:
	@echo "\$$(and condition1[,condition2[,condition3...]])"
	@echo "  The and function provides a "short-circuiting" AND operation."
	@echo "  Each argument is expanded, in order. If an argument expands"
	@echo "  to an empty string the processing stops and the result of"
	@echo "  the expansion is the empty string. If all arguments expand to"
	@echo "  a non-empty string then the result of the expansion is the "
	@echo "  expansion of the last argument."
	@echo 
	@echo $(and $(obj1),$(obj2))
	@echo $(and $(obj1),$(obj3))

