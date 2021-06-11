# $(join list1,list2)
#   Concatenates the two arguments word by word: the two first words
#   (one from each argument) concatenated form the first word of the
#   result, the two second words form the second word of the result,
#   and so on. So the nth word of the result comes from the nth word
#   of each argument. If one argument has more words than the other,
#   the extra words are copied unchanged into the result.
join:
	@echo "\$$(join list1,list2)"
	@echo "  Concatenates the two arguments word by word: the two first words"
	@echo "  (one from each argument) concatenated form the first word of the"
	@echo "  result, the two second words form the second word of the result,"
	@echo "  and so on. So the nth word of the result comes from the nth word"
	@echo "  of each argument. If one argument has more words than the other,"
	@echo "  the extra words are copied unchanged into the result."
	@echo
	@echo $(join a b,.c .o)
	@echo $(join a b c,.c .o)
	@echo $(join a b,.c .o .h)

