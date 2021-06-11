# Defines

LLVM_VERSION = 3.9.1
CMAKE_MM_VERSION = 3.7
CMAKE_VERSION = $(CMAKE_MM_VERSION).2

ifeq ($(OSTYPE),cygwin)
	CLEANUP=rm -f
	CLEANDIR=rm -rf
	MKDIR=mkdir -p
	TARGET_EXTENSION=out
else ifeq ($(OS),Windows_NT)
	CLEANUP=del /F /Q
	CLEANDIR=rd /S /Q
	MKDIR=mkdir
	TARGET_EXTENSION=exe
else
	CLEANUP=rm -f
	CLEANDIR=rm -rf
	MKDIR=mkdir -p
	TARGET_EXTENSION=out
endif

CMAKEGZ = cmake-$(CMAKE_VERSION)-Linux-x86_64
CMAKE = $(abspath ../$(CMAKEGZ)/bin/cmake)
LLVMXZ = llvm-$(LLVM_VERSION).src
LLVMSRC = $(abspath ../$(LLVMXZ))/
LLVMBUILD = $(LLVMSRC)build/
PATHL = $(abspath ../llvm)/
LLVMINC = $(PATHL)include/
PATHU = ../Unity
PATHUS = $(PATHU)/src/
PATHS = src/
PATHT = unittest/
PATHF = functional/
PATHE = release/
PATHB = build/
PATHD = build/depends/
PATHO = build/objs/
PATHR = build/results/

BUILD_PATHS = $(PATHB) $(PATHD) $(PATHO) $(PATHR)

ifndef CXX
	CXX = g++
endif

SRCS =			$(wildcard $(PATHS)*.cpp)
SRCT =			$(wildcard $(PATHT)*.cpp)
LLVMCONFIG =	$(PATHL)bin/llvm-config
LINK = 			$(CXX)
CXX_STD =		c++11
# The standard can be set to c++03, c++11, c++14 (experimental), or c++17 (experimental)
CFLAGS =		-I. -I$(PATHUS) -I$(PATHS) -Wall -Wextra -pedantic -std=$(CXX_STD) -D_POSIX_C_SOURCE=200809L
#				-I$(LLVMINC)

# LDFLAGS =		$(shell $(LLVMCONFIG) --ldflags)
LDFLAGS =
# LDLIBS =		$(shell $(LLVMCONFIG) --libs core) -lpthread -ldl -ltinfo
LDLIBS =

COMPILE =		$(CXX) $(CFLAGS) -MT $@ -MP -MMD -MF $(PATHD)$*.Td
RESULTS =		$(patsubst $(PATHT)Test%.cpp,$(PATHR)Test%.txt,$(SRCT))
OBJS =			$(filter-out $(PATHO)lisp.o, $(patsubst $(PATHS)%.cpp,$(PATHO)%.o,$(SRCS)))
POSTCOMPILE =	@mv -f $(PATHD)/$*.Td $(PATHD)/$*.d && touch $@

.PHONY: all
.PHONY: release
.PHONY: clean
.PHONY: test
.PHONY: functionaltest
.PHONY: unittest
.PHONY: coverage
.PRECIOUS: $(PATHB)Test%.$(TARGET_EXTENSION)
.PRECIOUS: $(PATHD)%.Td
.PRECIOUS: $(PATHD)%.d
.PRECIOUS: $(PATHD)Test%.Td
.PRECIOUS: $(PATHD)Test%.d
.PRECIOUS: $(PATHO)%.o
.PRECIOUS: $(PATHO)Test%.o
.PRECIOUS: $(PATHU)
.PRECIOUS: $(PATHUS)%.o
.PRECIOUS: $(PATHR)%.txt


# Rules

all: CFLAGS += -DDEBUG -DTEST -g -fprofile-arcs -ftest-coverage
all: LDFLAGS += -lgcov --coverage
all: | $(PATHU)
all: unittest coverage.txt $(PATHB)lisp.$(TARGET_EXTENSION) functionaltest

release: CFLAGS += -O3
release: | $(PATHE)
release: clean $(PATHE)lisp.$(TARGET_EXTENSION)

# $(PATHB)lisp.$(TARGET_EXTENSION): $(OBJS) | $(LLVMCONFIG)
$(PATHB)lisp.$(TARGET_EXTENSION): $(OBJS) $(PATHO)lisp.o
	$(LINK) -o $@ $^ $(LDLIBS) $(LDFLAGS)

# $(PATHE)lisp.$(TARGET_EXTENSION): $(OBJS) | $(LLVMCONFIG)
$(PATHE)lisp.$(TARGET_EXTENSION): $(OBJS) $(PATHO)lisp.o
	$(LINK) -o $@ $^ $(LDLIBS) $(LDFLAGS)

unittest: $(BUILD_PATHS) $(RESULTS)
	@echo "-----------------------\nIGNORES:\n-----------------------"
	@echo `grep --no-messages IGNORE $(PATHR)*.txt`
	@echo "-----------------------\nFAILURES:\n-----------------------"
	@echo `grep --no-messages FAIL $(PATHR)*.txt`
	@echo `grep --no-messages --with-filename 'Segmentation fault' $(PATHR)*.txt`
	@echo `grep --no-messages --with-filename 'Assertion' $(PATHR)*.txt`
	@echo "-----------------------\nPASSES:\n-----------------------"
	@echo `cat $(PATHR)*.txt | grep --count PASS` tests passed.
	@echo "\nDONE"
	@exit $$(( `cat $(PATHR)*.txt | grep --count FAIL` + `cat $(PATHR)*.txt | grep --count 'Segmentation fault'` + `cat $(PATHR)*.txt | grep --count 'Assertion'` ))

coverage.txt: $(OBJS) $(RESULTS)
	gcov -o $(PATHO) $(PATHS)*.cpp $(PATHT)*.cpp 2> /dev/null | head -n -2 | grep 'Lines executed:[0-9][0-9]\.' -B 1 -A 1 > $@

functionaltest: $(PATHB)lisp.$(TARGET_EXTENSION) 

$(PATHR)%.txt: $(PATHB)%.$(TARGET_EXTENSION)
	-./$< > $@ 2>&1

# # | $(LLVMCONFIG)
# $(PATHB)TestReader.$(TARGET_EXTENSION): $(PATHO)TestReader.o $(PATHO)Reader.o $(PATHUS)unity.o $(PATHO)Numbers.o $(PATHO)Strings.o $(PATHO)List.o $(PATHO)ASeq.o $(PATHO)Cons.o $(PATHO)Util.o \
# 	$(PATHO)Murmur3.o $(PATHO)Error.o $(PATHO)StringWriter.o $(PATHO)Map.o $(PATHO)Vector.o $(PATHO)AFn.o
# 	$(LINK) -o $@ $^ $(LDLIBS) $(LDFLAGS)
# 
# # | $(LLVMCONFIG)
# $(PATHB)TestList.$(TARGET_EXTENSION): $(PATHO)TestList.o $(PATHO)List.o $(PATHO)ASeq.o $(PATHO)Util.o $(PATHO)Murmur3.o $(PATHO)Numbers.o $(PATHO)Map.o $(PATHO)Cons.o $(PATHO)StringWriter.o $(PATHUS)unity.o
# 	$(LINK) -o $@ $^ $(LDLIBS) $(LDFLAGS)

# | $(LLVMCONFIG)
$(PATHB)Test%.$(TARGET_EXTENSION): $(PATHO)Test%.o $(OBJS) $(PATHUS)unity.o
	$(LINK) -o $@ $^ $(LDLIBS) $(LDFLAGS)

# | $(LLVMINC) 
$(PATHO)Test%.o: $(PATHT)Test%.cpp | $(PATHU)
	$(COMPILE) -c $< -o $@
	$(POSTCOMPILE)

# | $(LLVMINC)
$(PATHO)%.o: $(PATHS)%.cpp
	$(COMPILE) -c $< -o $@
	$(POSTCOMPILE)

$(PATHUS)%.o: $(PATHUS)%.cpp $(PATHUS)%.h | $(PATHU)
	$(CXX) $(CFLAGS) -c $< -o $@ 

$(PATHE):
	$(MKDIR) $(PATHE)

$(PATHB):
	$(MKDIR) $(PATHB)

$(PATHD):
	$(MKDIR) $(PATHD)

$(PATHO):
	$(MKDIR) $(PATHO)

$(PATHR):
	$(MKDIR) $(PATHR)

clean:
	$(CLEANDIR) $(PATHE)
	$(CLEANDIR) $(PATHB)
	$(CLEANUP) $(PATHD)*.d
	$(CLEANUP) $(PATHD)*.Td
	$(CLEANUP) $(PATHO)*.o
	$(CLEANUP) $(PATHO)*.gc*
	$(CLEANUP) $(PATHR)*.txt
	$(CLEANUP) *.gcov
	$(CLEANUP) coverage.txt

$(PATHU):
	cd .. && git clone --depth 1 https://github.com/ThrowTheSwitch/Unity.git

$(LLVMSRC):
	cd .. && curl http://releases.llvm.org/$(LLVM_VERSION)/$(LLVMXZ).tar.xz | tar -xJ

$(CMAKE):
	cd .. && curl https://cmake.org/files/v$(CMAKE_MM_VERSION)/$(CMAKEGZ).tar.gz | tar -xz

$(LLVMBUILD): $(LLVMSRC) $(CMAKE)
	cd $(LLVMSRC) && $(MKDIR) build
	# What follows should be split out, if we can decide what an appropriate target is.
	cd $(LLVMBUILD) && $(CMAKE) -G "Unix Makefiles" -DCMAKE_INSTALL_PREFIX=$(PATHL) $(LLVMSRC)

$(LLVMCONFIG):  | $(LLVMBUILD) $(PATHL)lib/libLLVMSupport.a $(PATHL)lib/libLLVMCore.a
	cd $(LLVMBUILD) && $(MAKE) install-llvm-config

$(LLVMINC): $(LLVMBUILD)
	cd $(LLVMBUILD) && $(MAKE) installhdrs

$(PATHL)lib/libLLVMSupport.a: | $(LLVMBUILD)
	cd $(LLVMBUILD) && $(MAKE) install-LLVMSupport

$(PATHL)lib/libLLVMCore.a: | $(LLVMBUILD)
	cd $(LLVMBUILD) && $(MAKE) install-LLVMCore

# Additional targets will need to be added for these
# make -j installhdrs 

-include $(wildcard $(PATHD)*.d)
