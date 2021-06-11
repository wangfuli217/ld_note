# $(words xx xx xx xx)
name1 := $(word 1, red orange yellow green blue black white)
name2 := $(word 2, red orange yellow green blue black white)

all:
	@echo name1 = $(name1)
	@echo name2 = $(name2)

