source = a.c b.c x.c.c
# $(patsubst pattern,replacement,text)
# Finds whitespace-separated words in text that match pattern and
#	  replaces them with replacement. Here pattern may contain a '%'
#	  which acts as a wildcard, matching any number of any characters
#	  within a word. If replacement also contains a '%', the '%' is
#	  replaced by the text that matched the '%' in pattern.
#
#	$(var:pattern=replacement)
#	  $(patsubst pattern,replacement,$(var))
#	$(var:suffix=replacement)
#	  $(patsubst %suffix,%replacement,$(var))
patsubst:
	@echo "\$$(patsubst pattern,replacement,text)"
	@echo "Finds whitespace-separated words in text that match pattern and"
	@echo "  replaces them with replacement. Here pattern may contain a '%'"
	@echo "  which acts as a wildcard, matching any number of any characters"
	@echo "  within a word. If replacement also contains a '%', the '%' is"
	@echo "  replaced by the text that matched the '%' in pattern."
	@echo
	@echo $(patsubst %.c,%.o,$(source))
	@echo $(source:.c=.o)

