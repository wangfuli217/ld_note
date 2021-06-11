override CFLAGS += $(patsubst %,-I%,$(subst :, ,$(VPATH)))

example:
	@echo $(CFLAGS)

