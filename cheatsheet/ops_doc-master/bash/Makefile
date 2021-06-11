warning-flags := \
		-Wall \
		-Wextra \
		-Wformat=2 \
		-Wunused-variable \
		-Wno-unused-parameter \
		-Wmissing-declarations \
		-trigraphs \
		-Wpointer-arith 

optim-flags := -O0 -g3 -lm -pthread -std=gnu++0x

CPPFLAGS := $(warning-flags) $(optim-flags)

sources := $(wildcard *.cpp)

# $(basename <names...>)  
bin := $(basename $(sources))

all: $(bin)
	echo $(bin)

clean:
	rm -f $(bin)
codestyle:
	@astyle --style=google *.cpp > /dev/null 2>&1
	@astyle --style=google *.hpp > /dev/null 2>&1
	-rm -f *.orig	  > /dev/null 2>&1

.PHONY: clean
.PHONY: codestyle
