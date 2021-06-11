sources := foo.c bar.c hei.s foo.h bar.h
target := $(filter-out %.h,$(sources))
target2 := $(filter-out %.h %.s,$(sources))
target3 := $(filter-out bar.c,$(sources))

all :
	@echo "target = $(target)"
	@echo "target2 = $(target2)"
	@echo "target3 = $(target3)"
