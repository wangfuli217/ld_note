# $(sort list)
#   Sorts the words of list in lexical order, removing duplicate words.
#   The output is a list of words separated by single space.
sort:
	@echo "\$$(sort list)"
	@echo "  Sorts the words of list in lexical order, removing duplicate words."
	@echo "  The output is a list of words separated by single space."
	@echo
	@echo $(sort 2,foo bar lose)

