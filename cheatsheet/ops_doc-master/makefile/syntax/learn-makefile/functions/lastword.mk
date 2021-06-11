# $(lastword names...)
#   The argument names is regarded as a series of names, separated by
#   whitespace. The value is the last name in the series.
lastword:
	@echo "\$$(lastword names...)"
	@echo "  The argument names is regarded as a series of names, separated by"
	@echo "  whitespace. The value is the last name in the series."
	@echo
	@echo $(lastword foo bar baz ugh)

