ifeq ($(SANITIZE),yes)
# Sanitizers

ifeq ($(RELEASE),yes)
$(error "Cannot enable sanitizers in a release build")
endif

ifeq ($(PCHECKS),yes)
$(error "Cannot enable sanitizers in a pointer/bounds checked build")
endif

# Hint: Also  use the  runtime environment  variable MALLOC_PERTURB_=1
# when testing. Supported by glibc.

ifeq ($(SANITIZE_THREAD),yes)
SFLAGS += -fsanitize=thread
else ifeq ($(SANITIZE_MEMORY),yes)

ifeq ($(CC),gcc)
$(error "GCC does not support the memory sanitizer")
endif

SFLAGS += -fsanitize=memory
else
SFLAGS += -fsanitize=address
endif

ifeq ($(CC),clang)
ifneq ($(SANITIZE_MEMORY),yes)
# clang only  supports the  leak sanitizer  without thread  and memory
# sanitizers enabled.
SFLAGS += -fsanitize=leak
endif
else
# gcc can support the leak sanitizer with thread and memory sanitizers
# enabled.
SFLAGS += -fsanitize=leak
endif

SFLAGS += -fsanitize=undefined
SFLAGS += -fsanitize=shift
SFLAGS += -fsanitize=integer-divide-by-zero
SFLAGS += -fsanitize=unreachable
SFLAGS += -fsanitize=vla-bound
SFLAGS += -fsanitize=null
SFLAGS += -fsanitize=return
SFLAGS += -fsanitize=signed-integer-overflow
SFLAGS += -fsanitize=bounds
SFLAGS += -fsanitize=alignment
SFLAGS += -fsanitize=object-size
SFLAGS += -fsanitize=float-divide-by-zero
SFLAGS += -fsanitize=float-cast-overflow
SFLAGS += -fsanitize=nonnull-attribute
SFLAGS += -fsanitize=returns-nonnull-attribute
SFLAGS += -fsanitize=bool
SFLAGS += -fsanitize=enum
SFLAGS += -fsanitize=vptr

ifeq ($(CC),clang)
# Sanitizers only support by clang

SFLAGS += -fsanitize=integer
SFLAGS += -fsanitize=unsigned-integer-overflow
SFLAGS += -fsanitize=cfi-nvcall
SFLAGS += -flto
SFLAGS += -fsanitize=cfi-cast-strict
# SFLAGS += -fsanitize=safe-stack

ifeq ($(SANITIZE_COVERAGE_BB),yes)
SFLAGS += -fsanitize-coverage=bb
else ifeq ($(SANITIZE_COVERAGE_EDGE),yes)
SFLAGS += -fsanitize-coverage=edge
else ifeq ($(SANITIZE_COVERAGE_FUNC),yes)
SFLAGS += -fsanitize-coverage=func
endif
endif

CFLAGS  += $(SFLAGS)
LDFLAGS += $(SFLAGS)
endif
