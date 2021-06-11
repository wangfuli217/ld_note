targets := foo.c bar.c hei.c

all :
	@echo "sources : $(addprefix src/,$(targets))"
