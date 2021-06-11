targets := foo bar hei
sources := $(addsuffix .c,$(targets))

all :
	@echo "sources : $(sources)"
