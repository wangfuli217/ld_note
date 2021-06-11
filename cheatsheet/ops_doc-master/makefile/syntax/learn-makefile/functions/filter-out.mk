# $(filter-out pattern...,text)
#   Removes all whitespace-separated words in text that do not match any
#   of the pattern words, removing the words that do match one or more.
#   This is the exact opposite of the filter function.
objects := main1.o foo.o main2.o bar.o
mains := main1.o main2.o
filter-out:
	@echo "\$$(filter-out pattern...,text)"
	@echo "  Removes all whitespace-separated words in text that do not match any"
	@echo "  of the pattern words, removing the words that do match one or more."
	@echo "  This is the exact opposite of the filter function."
	@echo
	@echo $(filter-out $(mains),$(objects))
