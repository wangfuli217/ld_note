
# patsubst
# only match from the end!
targets := foo bar hei
sources := $(patsubst %,%.c,$(targets))
objects := $(patsubst %,%.o,$(targets))

another_sources := foo.c bar.c foo.c.c
another_objects := $(patsubst %.c,%.o,$(another_sources))
another_objects2 := $(another_sources:%.c=%.o)
another_objects3 := $(another_sources:.c=.o)

patsubst:
	@echo "sources : $(sources)"
	@echo "objects : $(objects)"
	@echo "another_objects  : $(another_objects)"
	@echo "another_objects2 : $(another_objects2)"
	@echo "another_objects3 : $(another_objects3)"

####
VPATH := src:../include
override CFLAGS += $(patsubst %,-I%,$(subst :, ,$(VPATH)))

all :
	echo "CFLAGS = $(CFLAGS)"
