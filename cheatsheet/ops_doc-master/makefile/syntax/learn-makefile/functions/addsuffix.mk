# $(addsuffix suffix,names...)
#   The argument names is regarded as a series of names, separated
#   by whitespace. suffix is used as a unit. The value of suffix
#   is appended to the end of each individual name and the resulting
#   larger names are concatenated with single spaces between them.
objs := foo  bar
addsuffix:
	@echo "\$$(addsuffix suffix,names...)"
	@echo "  The argument names is regarded as a series of names, separated"
	@echo "  by whitespace. suffix is used as a unit. The value of suffix"
	@echo "  is appended to the end of each individual name and the resulting"
	@echo "  larger names are concatenated with single spaces between them."
	@echo 
	@echo $(objs)
	@echo $(addsuffix .c,$(objs))

