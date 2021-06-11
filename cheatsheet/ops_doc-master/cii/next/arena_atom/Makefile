#
# A simple makefile for managing build of project composed of C source files.
#
# Julie Zelenski, for CS107, Sept 2009
#

# It is likely that default C compiler is already gcc, but explicitly
# set, just to be sure
CC = gcc

# The CFLAGS variable sets compile flags for gcc:
#  -g		   compile with debug information
#  -Wall	   give all diagnostic warnings
#  -pedantic   require compliance with ANSI standard
#  -O0		   do not optimize generated code
#  -std=gnu99  use the Gnu C99 standard language definition
#  -m32		   emit code for IA32 architecture
CFLAGS = -g -Wall -pedantic -O0 -std=gnu99 -I../include

# The LDFLAGS variable sets flags for linker
#  -lm	  link in libm (math library)
#  -m32	  link with IA32 libraries
#  -lunit  link with CUnit
LDFLAGS = -lcunit -L.. -lcii

# In this section, you list the files that are part of the project.
# If you add/change names of header/source files, here is where you
# edit the Makefile.
HEADERS = test_atom.h test_arena.h
SOURCES = test_cii.c test_atom.c test_arena.c
TARGETS =  test_cii

default: $(TARGETS)
# The first target defined in the makefile is the one
# used when make is invoked with no argument. The default
# target makes all test programs

test_cii: test_cii.o test_arena.o test_atom.o
	$(CC) $(CFLAGS) -o $@  $^ $(LDFLAGS)

# In make's default rules, a .o automatically depends on its .c file
# (so editing the .c will cause recompilation into its .o file).
# The line below creates additional dependencies, most notably that it
# will cause the .c to reocmpiled if any included .h file changes.

Makefile.dependencies:: $(SOURCES) $(HEADERS)
	$(CC) $(CFLAGS) -MM $(SOURCES) > Makefile.dependencies

-include Makefile.dependencies

# Phony means not a "real" target, it doesn't build anything
# The phony target "clean" that is used to remove all compiled object files.

.PHONY: clean

clean:
	@rm -f $(TARGETS) *.o core Makefile.dependencies

