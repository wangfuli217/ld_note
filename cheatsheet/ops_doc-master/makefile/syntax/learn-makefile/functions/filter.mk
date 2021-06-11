# $(filter pattern...,text)
#   Returns all whitespace-separated words in text that do match any of
#   the pattern words, removing any words that do not match. The patterns
#   are written using '%', just like the patterns used in the patsubst
#   function.
sources := foo.c bar.c baz.s ugh.h
filter:
	@echo "\$$(filter pattern...,text)"
	@echo "  Returns all whitespace-separated words in text that do match any of"
	@echo "  the pattern words, removing any words that do not match. The patterns"
	@echo "  are written using '%', just like the patterns used in the patsubst"
	@echo "  function."
	@echo
	@echo $(sources)
	@echo $(filter %.c %.s,$(sources))
	@echo $(filter %.h,$(sources))
