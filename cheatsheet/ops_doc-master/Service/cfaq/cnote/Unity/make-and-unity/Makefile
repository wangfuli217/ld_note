
# Determining the host
ifeq ($(OSTYPE),cygwin)
    CLEANUP=rm -f
    MKDIR=mkdir -p
    TARGET_EXTENSION=out
else ifeq ($(OS),Windows_NT)
    CLEANUP=del /F /Q
    MKDIR=mkdir
    TARGET_EXTENSION=exe
else
    CLEANUP=rm -f
    MKDIR=mkdir -p
    TARGET_EXTENSION=out
endif

# Making Paths
PATHU = unity/src/
PATHS = src/
PATHT = tests/
PATHB = build/
PATHD = build/depends/
PATHO = build/objs/
PATHR = build/results/

BUILD_PATHS = $(PATHB) $(PATHD) $(PATHO) $(PATHR)

# The source
SRCT = $(wildcard $(PATHT)*.c)

# The Toolchain
COMPILE=gcc -x c -c
LINK=gcc
DEPEND=gcc -MM -MG -MF
# - MM tells gcc to output header dependencies for the compile file(s), 
#   but only those that are in single quotes (it will exclude system headers).
# - MG tells gcc that it's okay if it runs into headers that it can't find. 
#   This is going to be all of the headers, honestly, because we also (purposefully) 
#   haven't told gcc anything about our include paths. We're looking for very 
#   shallow dependency tracking: just the files that are included in the test file.
# - MF tells gcc we want the header dependencies to be written to a file. The next 
#   argument should be the name of the file to write to, which is why we have placed 
#   the dependency file first in our rule below.

CFLAGS=-I. -I$(PATHU) -I$(PATHS) -DTEST

RESULTS = $(patsubst $(PATHT)Test%.c,$(PATHR)Test%.txt,$(SRCT))

# Summarizing Results
test: $(BUILD_PATHS) $(RESULTS)
	@echo "-----------------------\nIGNORES:\n-----------------------" 
	@echo `grep -s IGNORE $(PATHR)*.txt` 
	@echo "-----------------------\nFAILURES:\n-----------------------" 
	@echo `grep -s FAIL $(PATHR)*.txt` 
	@echo "\nDONE"

# Make Results
$(PATHR)%.txt: $(PATHB)%.$(TARGET_EXTENSION) 
	-./$< > $@ 2>&1

# Creating Executables
#  $(PATHD)Test%.d
$(PATHB)Test%.$(TARGET_EXTENSION): $(PATHO)Test%.o $(PATHO)%.o $(PATHU)unity.o
	$(LINK) -o $@ $^

# Creating Object Files
$(PATHO)%.o: $(PATHT)%.c 
	@echo "Results" $(RESULTS)
	$(COMPILE) $(CFLAGS) $< -o $@

$(PATHO)%.o: $(PATHS)%.c
	$(COMPILE) $(CFLAGS) $< -o $@

$(PATHO)%.o: $(PATHU)%.c $(PATHU)%.h 
	$(COMPILE) $(CFLAGS) $< -o $@ 

# Dependencies
$(PATHD)%.d: $(PATHT)%.c 
	$(DEPEND) $@ $<

-include $(wildcard $(PATHD)*.d)

# Creating Directories
$(PATHB): 
	$(MKDIR) $(PATHB)

$(PATHD):
	$(MKDIR) $(PATHD)

$(PATHO):
	$(MKDIR) $(PATHO)

$(PATHR):
	$(MKDIR) $(PATHR)

# CLEAN

# Clean
clean: 
	$(CLEANUP) $(PATHO)*.o 
	$(CLEANUP) $(PATHB)*.$(TARGET_EXTENSION) 
	$(CLEANUP) $(PATHR)*.txt

# Keeping our pre-built files arouind
.PRECIOUS: $(PATHB)Test%.$(TARGET_EXTENSION)
.PRECIOUS: $(PATHD)%.d
.PRECIOUS: $(PATHO)%.o
.PRECIOUS: $(PATHR)%.txt

# PHONY's
.PHONY: clean
.PHONY: test
# Without this, typing ``make`` is going to assume you meant ``make clean test``
# or ``make test clean`` because it doesn't see a file named ``test`` or a file
#  named ``clean``, so they MUST need rebuilding, right?

# Creating Results


