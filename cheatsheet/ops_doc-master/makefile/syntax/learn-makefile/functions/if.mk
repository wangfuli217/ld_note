# $(if condition,then-part[,else-part])
#   The if function provides support for conditional expansion
#   in a functional context.
#   The first argument, condition, first has all preceding and
#   trailing whitespace strippted, then is expanded. If it expands
#   to any non-empty string, then the condition is considered to
#   be true. If it expands to an empty string, the considered to
#   be false.
#   If the condition is true then the second argument, then-part,
#   is evaluated and this is used as the result of the evaluation
#   of the entire if function.
#   If the condition is false then the third argument, else-part,
#   is evaluated and this is the result of the if function. If
#   there is no third argument, the if function evaluates to 
#   nothing (the empty string).
#   Note that only one of the then-part or the else-part will be 
#   evaluated, never both.
binary := bin
sources := a.c b.c
objs := $(if $(binary),$(sources:.c=.o),main.o)
if:
	@echo "\$$(if condition,then-part[,else-part])"
	@echo "  The if function provides support for conditional expansion"
	@echo "  in a functional context."
	@echo "  The first argument, condition, first has all preceding and"
	@echo "  trailing whitespace strippted, then is expanded. If it expands"
	@echo "  to any non-empty string, then the condition is considered to"
	@echo "  be true. If it expands to an empty string, the considered to"
	@echo "  be false."
	@echo "  If the condition is true then the second argument, then-part,"
	@echo "  is evaluated and this is used as the result of the evaluation"
	@echo "  of the entire if function."
	@echo "  If the condition is false then the third argument, else-part,"
	@echo "  is evaluated and this is the result of the if function. If"
	@echo "  there is no third argument, the if function evaluates to "
	@echo "  nothing (the empty string)."
	@echo "  Note that only one of the then-part or the else-part will be "
	@echo "  evaluated, never both."
	@echo ""
	@echo $(if ,then,else)
	@echo $(if condition,then,else)
	@echo $(objs)

