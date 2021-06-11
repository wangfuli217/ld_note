# $(words xx xx xx xx)
count := $(word 1, red orange yellow green blue black white)

all:
	@echo count = $(count)

