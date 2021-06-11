with = undefine

ifeq ($(with), ssl)
	cmd = WITH
else
	cmd = WITHOUT
endif

foo:
	@echo compiling foo $(cmd) ssl ...
	@echo "<conditional-directive>"
	@echo "<text-if-true>"
	@echo "else"
	@echo "<text-if-false>"
	@echo "endif"
	@echo 
	@echo "<conditional-directive>"
	@echo "  ifeq, ifneq, ifdef, ifndef"
	@echo "  use:"
	@echo "  ifeq (<arg1>, <arg2>)"
	@echo "  ifeq '<arg1>' '<arg2>'"
	@echo "  ifeq \"<arg1>\" \"<arg2>\""
	@echo "  ifeq '<arg1>' \"<arg2>\""

