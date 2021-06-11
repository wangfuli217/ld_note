# $(origin variable)
#   The origin function does not operate on the values of variables.
#   It tells you somethign about a variable. Specifically, it tells
#   you where it came from.
#   - 'undefined'
#   	if variable was never defined.
#   - 'default'
#   	if variable has a default definition, as is usual with cc and
#   	so on.
#   - 'environment'
#   	if variable was inherited from the environment provided to make
#   - 'environment override'
#   	if variable was inherited from the environment provided to make,
#   	and is overriding a setting for variable in the makefile as a
#   	result of the '-e' option
#   - 'file'
#   	if variable was defined in a makefile
#   - 'command line'
#   	if variable was defined on the command line
#   - 'override'
#   	if variable was defined with an override directive in ta makefile
#   - 'automatic'
#   	if variable is an automatic variable defined for the executio of
#   	the recipe for each rule
EXTRA = in makefile
obj =
override env = 
origin:
	@echo "$(origin variable)"
	@echo "  The origin function does not operate on the values of variables."
	@echo "  It tells you somethign about a variable. Specifically, it tells"
	@echo "  you where it came from."
	@echo "  - 'undefined'"
	@echo "  	if variable was never defined."
	@echo "  - 'default'"
	@echo "  	if variable has a default definition, as is usual with cc and"
	@echo "  	so on."
	@echo "  - 'environment'"
	@echo "  	if variable was inherited from the environment provided to make"
	@echo "  - 'environment override'"
	@echo "  	if variable was inherited from the environment provided to make,"
	@echo "  	and is overriding a setting for variable in the makefile as a"
	@echo "  	result of the '-e' option"
	@echo "  - 'file'"
	@echo "  	if variable was defined in a makefile"
	@echo "  - 'command line'"
	@echo "  	if variable was defined on the command line"
	@echo "  - 'override'"
	@echo "  	if variable was defined with an override directive in ta makefile"
	@echo "  - 'automatic'"
	@echo "  	if variable is an automatic variable defined for the executio of"
	@echo "  	the recipe for each rule"
	@echo 
	@echo "Usage: EXTRA=C make with=ssl -e origin"
	@echo
	@echo $(origin undefined-variable)
	@echo $(origin RM)
	@echo $(origin PATH)
	@echo $(origin EXTRA)
	@echo $(origin obj)
	@echo $(origin with)
	@echo $(origin env)
	@echo $(origin @)

