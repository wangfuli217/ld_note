# $(wordlist s,e,text)
#   Returns the list of words in text starting with words s and ending
#   with word e(inclusive). The legitimate values of s start from 1;
#   e may start form 0. If s is bigger than the number of words in
#   text, the value is empty. If e is bigger than the nubmer of words
#   in text, words up to end of text are returned. If s is greater
#   than e, nothing is returned.
wordlist:
	@echo "\$$(wordlist s,e,text)"
	@echo "  Returns the list of words in text starting with words s and ending"
	@echo "  with word e(inclusive). The legitimate values of s start from 1;"
	@echo "  e may start form 0. If s is bigger than the number of words in"
	@echo "  text, the value is empty. If e is bigger than the nubmer of words"
	@echo "  in text, words up to end of text are returned. If s is greater"
	@echo "  than e, nothing is returned."
	@echo
	@echo $(wordlist 2,3,foo bar baz ugh)

