sources := foo.c bar.c hei.s foo.h bar.h
c_target := $(filter %.c,$(sources))
c_s_target := $(filter %.c %.s,$(sources))
includes := $(filter %.h,$(sources))

all :
	@echo "c_target = $(c_target)"
	@echo "c_s_target = $(c_s_target)"
	@echo "includes = $(includes)"
