# $(foreach var,list,text)
# 	The first two arguments, var and list, are expanded before
# 	anything else is done; note that the last argument, text, is
# 	not expanded at the same time. Then for each word of the expanded
# 	value of list, the variable named by the expanded value of var is
# 	set to that word, and text is expanded. Presumably text contains
# 	references to that variable, so its expansion will be different
# 	each time. 
# 	The result is that text is expanded as many times as there are
# 	whitespace-separated words in list. The multiple expansions of
# 	text are concatenated, with space between them, to make the result
# 	of foreach.
dirs := a b c d
foreach:
	@echo "\$$(foreach var,list,text)"
	@echo "	The first two arguments, var and list, are expanded before"
	@echo "	anything else is done; note that the last argument, text, is"
	@echo "	not expanded at the same time. Then for each word of the expanded"
	@echo "	value of list, the variable named by the expanded value of var is"
	@echo "	set to that word, and text is expanded. Presumably text contains"
	@echo "	references to that variable, so its expansion will be different"
	@echo "	each time. "
	@echo "	The result is that text is expanded as many times as there are"
	@echo "	whitespace-separated words in list. The multiple expansions of"
	@echo "	text are concatenated, with space between them, to make the result"
	@echo "	of foreach."
	@echo
	@echo $(foreach n,$(dirs),$(n).o)

