# $(call variable,param,param...)
#   The call function is unique in that it can be used to created
#   new parameterized functions. You can write a complex expression
#   as the value of a variable, then use call to expand it with
#   different values.
#   When make expands this function, it assigns each param to 
#   temporary variable $(1), $(2), etc. The variable $(0) will
#   contain variable. There is no maximum number of parameter
#   arguments. There is no minimum, either, but it doesn't make
#   sense to use call with no parameters.
reverse = $(2) $(1)
call:
	@echo "\$$(call variable,param,param...)"
	@echo "  The call function is unique in that it can be used to created"
	@echo "  new parameterized functions. You can write a complex expression"
	@echo "  as the value of a variable, then use call to expand it with"
	@echo "  different values."
	@echo "  When make expands this function, it assigns each param to "
	@echo "  temporary variable $(1), $(2), etc. The variable $(0) will"
	@echo "  contain variable. There is no maximum number of parameter"
	@echo "  arguments. There is no minimum, either, but it doesn't make"
	@echo "  sense to use call with no parameters."
	@echo ""
	@echo $(call reverse,first,second,third)
	@echo $(call reverse,first)
