# Commonly useful definitions
CFLAGS += -D_DEFAULT_SOURCE
CFLAGS += -D_BSD_SOURCE
CFLAGS += -D_FILE_OFFSET_BITS=64
CFLAGS += -D_FORTIFY_SOURCE=2

# C language standard (default to c99)
ifneq ($(CSTD),)
CFLAGS += -std=$(CSTD)
else
CFLAGS += -std=c99
endif

# Commonly useful warnings
CFLAGS += -pedantic
CFLAGS += -W
CFLAGS += -Wall
CFLAGS += -Wextra
CFLAGS += -Wpedantic
CFLAGS += -Wmissing-include-dirs
CFLAGS += -Wmain
CFLAGS += -Wunreachable-code
CFLAGS += -Wwrite-strings
CFLAGS += -Wpointer-arith
CFLAGS += -Wincompatible-pointer-types
CFLAGS += -Wbad-function-cast
CFLAGS += -Winline
CFLAGS += -Wsign-conversion
CFLAGS += -Wconversion
CFLAGS += -Wuninitialized
CFLAGS += -Winit-self
CFLAGS += -Wunused
CFLAGS += -Wunused-result
CFLAGS += -Wunused-value
CFLAGS += -Wundef
CFLAGS += -Wswitch
CFLAGS += -Wswitch-enum
CFLAGS += -Wswitch-default
CFLAGS += -Wmissing-format-attribute
CFLAGS += -Wshadow
CFLAGS += -Wcast-align
CFLAGS += -Wcast-qual
CFLAGS += -Wfloat-conversion
CFLAGS += -Wfloat-equal
CFLAGS += -Wmissing-prototypes
CFLAGS += -Wstrict-prototypes
CFLAGS += -Wmissing-declarations
CFLAGS += -Wold-style-definition
CFLAGS += -Wnested-externs
CFLAGS += -Wredundant-decls
CFLAGS += -Wunknown-pragmas
CFLAGS += -Wmissing-braces
CFLAGS += -Wmissing-field-initializers

CFLAGS += -fno-common
CFLAGS += -ftree-vectorize

CFLAGS += -fstrict-aliasing
CFLAGS += -Wstrict-aliasing
CFLAGS += -fstrict-overflow
CFLAGS += -Wstrict-overflow=5
# CFLAGS += -fms-extensions

ifeq ($(CC),clang)
# Warnings only supported by clang

CFLAGS += -Weverything
CFLAGS += -Wint-conversion
CFLAGS += -Wint-to-pointer-cast
CFLAGS += -Wno-padded
CFLAGS += -Wno-covered-switch-default
CFLAGS += -Wno-c++98-compat
CFLAGS += -Wno-c++98-compat-pedantic
CFLAGS += -Wno-disabled-macro-expansion
CFLAGS += -Wdocumentation
# CFLAGS += -Wno-c99-compat
# CFLAGS += -Wno-microsoft
# CFLAGS += -Wno-documentation-unknown-command
# CFLAGS += -Wno-exit-time-destructors
else
# Warnings only supported by gcc

CFLAGS += -Wsuggest-attribute=const
CFLAGS += -Wsuggest-attribute=pure
CFLAGS += -Wsuggest-attribute=noreturn
CFLAGS += -Wsuggest-attribute=format
CFLAGS += -Wno-c90-c99-compat
# CFLAGS += -Wno-c99-c11-compat
# CFLAGS += -fplan9-extensions
endif

ifeq ($(RELEASE),yes)
# Release build

CFLAGS  += -DNDEBUG
CFLAGS  += -O3
CFLAGS  += -fomit-frame-pointer

CFLAGS  += -flto
LDFLAGS += -flto
else
# Debug build (the default)

CFLAGS += -DDEBUG
CFLAGS += -O
CFLAGS += -fno-omit-frame-pointer
CFLAGS += -g

CFLAGS += -fstack-protector
CFLAGS += -fstack-protector-all
CFLAGS += -fstack-protector-strong
CFLAGS += -Wstack-protector
CFLAGS += -fstack-check

CFLAGS += -ftrapv
endif

ifeq ($(PROFILING),yes)
# Debug build with profiling

ifeq ($(RELEASE),yes)
$(error "Cannot enable profiling in a release build")
endif

CFLAGS  += -pg
LDFLAGS += -pg
endif

LDFLAGS += -lpthread
LDFLAGS += -lm
