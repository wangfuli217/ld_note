ifeq ($(PCHECKS),yes)
# Pointer and bounds checks (only supported by gcc)

ifeq ($(RELEASE),yes)
$(error "Cannot enable pointer/bounds checks in a release build")
endif

ifeq ($(SANITIZE),yes)
$(error "Cannot enable pointer/bounds checks in a sanitize build")
endif

ifeq ($(CC),clang)
$(error "Clang does not support pointer/bounds checks")
endif

CFLAGS += -mmpx
CFLAGS += -fcheck-pointer-bounds
CFLAGS += -fchkp-check-incomplete-type
CFLAGS += -fchkp-narrow-bounds
CFLAGS += -fchkp-narrow-to-innermost-array
CFLAGS += -fchkp-first-field-has-own-bounds
CFLAGS += -fchkp-narrow-to-innermost-array
CFLAGS += -fchkp-optimize
CFLAGS += -fchkp-use-fast-string-functions
CFLAGS += -fchkp-use-nochk-string-functions
CFLAGS += -fchkp-use-static-bounds
CFLAGS += -fchkp-use-static-const-bounds
CFLAGS += -fchkp-treat-zero-dynamic-size-as-infinite
CFLAGS += -fchkp-check-read
CFLAGS += -fchkp-check-write
CFLAGS += -fchkp-store-bounds
CFLAGS += -fchkp-instrument-calls
CFLAGS += -fchkp-instrument-marked-only
CFLAGS += -fchkp-use-wrappers
endif
