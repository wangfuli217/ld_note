# $(addprefix prefix,names...)
#   The argument names is regarded as a series of names, separated
#   by whitespace. prefix is used as a unit. The value of prefix
#   is prepended to the front of each individual name and the 
#   resulting larger names are concatenated with single spaces 
#   between them.
objs := foo  bar
addprefix:
	@echo "\$$(addprefix prefix,names...)"
	@echo "  The argument names is regarded as a series of names, separated"
	@echo "  by whitespace. prefix is used as a unit. The value of prefix"
	@echo "  is prepended to the front of each individual name and the "
	@echo "  resulting larger names are concatenated with single spaces "
	@echo "  between them."
	@echo 
	@echo $(objs)
	@echo $(addprefix src/,$(objs))

