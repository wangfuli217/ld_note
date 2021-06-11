# sort
sources := book dog cat apple book dog frog egg
targets := $(sort $(sources))

all:
	@echo "list is : $(sources)"
	@echo "sorted list is : $(targets)"
