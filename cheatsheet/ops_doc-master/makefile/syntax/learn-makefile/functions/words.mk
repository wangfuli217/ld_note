# $(words text)
#   Returns the nubmer of words in text.
words:
	@echo "\$$(words text)"
	@echo "  Returns the nubmer of words in text."
	@echo
	@echo $(words foo bar baz ugh)

