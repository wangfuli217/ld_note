-include config.mk

SHELL := bash
ROOT := $(dir $(realpath $(firstword $(MAKEFILE_LIST))))

# defaults
BUILD ?= debug

UNAME_S := $(shell uname -s)
ifeq ($(UNAME_S),Linux)
	UNAME_O := $(shell uname -o)
endif

ifeq ($(CC),cc)
	CC=clang
endif

ifeq ($(findstring gcc, $(CC)),gcc)
	SANITIZE := -fsanitize=undefined
	CFLAGS = -falign-functions=4 -Wall -std=gnu99
	CXXFLAGS = -xc++ -falign-functions=4 -Wall -std=c++98
	OPT_FLAG=-O3
	LDFLAGS += -rdynamic
endif
ifeq ($(findstring clang, $(CC)),clang)
ifneq ($(UNAME_O),Android) # ubsan doesn't work on Termux
	SANITIZE := -fsanitize=undefined -fno-sanitize=bounds
endif
	CFLAGS = -Wall -Wextra -pedantic -std=gnu11 \
                 -Wno-gnu-zero-variadic-macro-arguments -Wno-address-of-packed-member \
                 -Wno-unknown-warning-option -Wno-zero-length-array -Wno-array-bounds \
                 -Werror=implicit-function-declaration -Werror=int-conversion
	CXXFLAGS = -xc++ -Wall -Wextra -pedantic -std=c++98 -m32
	OPT_FLAG=-O3
	LDFLAGS += -rdynamic
endif

ifeq ($(findstring emcc, $(CC)),emcc)
	CFLAGS = -Wall -DEMSCRIPTEN -s ALIASING_FUNCTION_POINTERS=0
	OPT_FLAG = -Os
endif

ifeq ($(FORCE_32_BIT),y)
	CFLAGS += -m32
	LDFLAGS += -m32
endif

ifeq ($(BUILD),debug)
	OPT_FLAG = -O0
	CFLAGS += -g $(OPT_FLAG) $(SANITIZE)
	CXXFLAGS += -g $(OPT_FLAG) $(SANITIZE)
	LIBS += $(SANITIZE)
endif

ifeq ($(BUILD),debugger)
	OPT_FLAG = -O0
	CFLAGS += -g $(OPT_FLAG) $(SANITIZE)
	CXXFLAGS += -g $(OPT_FLAG) $(SANITIZE)
	LIBS += $(SANITIZE)
endif

ifeq ($(BUILD),release)
	CFLAGS += -DNDEBUG $(OPT_FLAG)
	CXXFLAGS += -DNDEBUG $(OPT_FLAG)
endif

ifeq ($(BUILD),release-with-asserts)
	CFLAGS += $(OPT_FLAG)
	CXXFLAGS += $(OPT_FLAG)
endif

ifeq ($(BUILD),profile)
	CFLAGS += -DNDEBUG $(OPT_FLAG)
	CXXFLAGS += -DNDEBUG $(OPT_FLAG)
	LIBS += -lprofiler
endif

ifeq ($(BUILD),gprof)
	CFLAGS += -DNDEBUG -pg $(OPT_FLAG)
	CXXFLAGS += -DNDEBUG -pg $(OPT_FLAG)
	LDFLAGS += -pg
endif

INCLUDE += -I.gen
CFLAGS += $(COPT) $(INCLUDE)
CXXFLAGS += $(COPT) $(INCLUDE)

BUILD_DIR := build/$(CC)/$(BUILD)

SRC := $(wildcard *.c) $(wildcard startle/*.c)
OBJS := $(patsubst %.c, $(BUILD_DIR)/%.o, $(SRC))
DEPS := $(patsubst %.c, $(BUILD_DIR)/%.d, $(SRC))

.PHONY: example
example: $(BUILD_DIR)/example
	ln -fs $(BUILD_DIR)/example $@

include startle/startle.mk

# link
$(BUILD_DIR)/example: $(OBJS)
	$(CC) $(OBJS) $(LDFLAGS) $(LIBS) -o $@

# remove compilation products
.PHONY: clean
clean:
	rm -rf build .gen example
