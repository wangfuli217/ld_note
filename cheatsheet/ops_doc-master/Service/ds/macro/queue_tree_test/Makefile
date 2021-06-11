warning-flags := \
		-Wall \
		-Wextra \
		-Wformat=2 \
		-Wunused-variable \
		-Wold-style-definition \
		-Wstrict-prototypes \
		-Wno-unused-parameter \
		-Wmissing-declarations \
		-Wmissing-prototypes \
		-Wpointer-arith \
		-Werror

optim-flags := -O0 -g3

CFLAGS := $(warning-flags) $(optim-flags)

sources := $(wildcard *.c)
bin := $(basename $(sources))

all: $(bin)

clean:
	rm -f $(bin)

.PHONY: clean