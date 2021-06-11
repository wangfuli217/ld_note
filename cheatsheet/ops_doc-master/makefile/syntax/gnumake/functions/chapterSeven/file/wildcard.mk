# $(wildcard PATTERN)
# ?   1 word
# or * , 1 or more words
all :
	@echo $(wildcard ?.mk)
	@echo $(wildcard *.mk)
