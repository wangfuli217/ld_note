# $(word n,text)
#   Returns the nth word of text. The legitimate values of n start from 1.
#   If n is bigger than the number of words in text, the value is empty.
word:
	@echo "\$$(word n,text)"
	@echo "  Returns the nth word of text. The legitimate values of n start from 1."
	@echo "  If n is bigger than the number of words in text, the value is empty."
	@echo
	@echo $(word 2,foo bar baz)


