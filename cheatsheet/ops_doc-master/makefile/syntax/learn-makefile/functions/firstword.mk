# $(firstword names...)
#   The argument names is regarded as a series of names, separated by
#   whitespace. The value is the first name in the series. The rest
#   of the names are ignored.
firstword:
	@echo "\$$(firstword names...)"
	@echo "  The argument names is regarded as a series of names, separated by"
	@echo "  whitespace. The value is the first name in the series. The rest"
	@echo "  of the names are ignored."
	@echo
	@echo $(firstword foo bar baz ugh)

