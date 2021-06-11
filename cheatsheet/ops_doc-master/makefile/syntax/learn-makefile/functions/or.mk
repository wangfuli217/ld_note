# $(or condition1[,condition2[,condition3...]])
#   The or function provides a "short-circuiting" OR operation.
#   Each argument is expanded, in order. If an argument expands
#   to a non-empty string the processing stops and the result of
#   the expansion is that string. If, after all arguments are
#   expanded, all of them is false (empty), then the result of
#   the expansion is the empty string.
obj1 =
obj2 =
obj3 = obj3
or:
	@echo "\$$(or condition1[,condition2[,condition3...]])"
	@echo "  The or function provides a "short-circuiting" OR operation."
	@echo "  Each argument is expanded, in order. If an argument expands"
	@echo "  to a non-empty string the processing stops and the result of"
	@echo "  the expansion is that string. If, after all arguments are"
	@echo "  expanded, all of them is false (empty), then the result of"
	@echo "  the expansion is the empty string."
	@echo ""
	@echo $(or ,,yes)
	@echo $(or $(obj1),$(obj2),$(obj3))
	@echo $(or $(obj1),$(obj2))

