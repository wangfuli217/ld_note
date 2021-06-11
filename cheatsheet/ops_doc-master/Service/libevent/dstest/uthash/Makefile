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
		-Wpointer-arith 

optim-flags := -O0 -g3

CFLAGS := $(warning-flags) $(optim-flags)

sources := $(wildcard *.c)
bin := $(basename $(sources))

all: $(bin)

clean:
	rm -f $(bin)
codestyle:
	@indent -kr -i4 -ts4 -sob -ss -sc -npsl -pcs -bs -l200 -nut -npro -brf *.[ch]	
	-rm -f *.c~	
	-rm -f *.h~

.PHONY: clean
.PHONY: codestyle
