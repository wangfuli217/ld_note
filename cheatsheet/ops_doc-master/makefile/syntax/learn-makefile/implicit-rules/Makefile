# Implicit Rules
#
# Compiling C programs
#	  n.o is made automatically from n.c with a recipe of the form
#   '$(CC) $(CPPFLAGS) $(CFLAGS) -c'.
#
# Compiling C++ programs
#   n.o is mode automatically from n.cc, n.cpp, or n.c with a 
#   recipe of the form '$(CXX) $(CPPCFLAGS) $(CXXFLAGS) -c'. We
#   encourage you to use the suffix '.cc' for C++ source files
#   instead of '.c'.
#
# Assembling and processing assembler programs
#   n.o is made automatically from n.s by running the assembler,
#   as. The precise recipe is '$(AS) $(ASFLAGS)'.
#   n.s is made automatically from n.S by running the C preprocessor,
#   cpp. The precise recipe is '$(CPP) $(CPPFLAGS)'.
#
# Linking a single object file
#   n is made automatically from n.o by running the linker (usually
#   called ld) via the C compiler. The precise recipe is '$(CC)
#   $(LDFLAGS) n.o $(LOADLIBES) $(LDLIBS)'.
#
#   This rule does the right thing for a simple program with only
#   only one source file. It will also do the right thing if there
#   are multiple object files (presumably coming from various other
#   source files), one of which has a name matching that of the
#   executable file.
#
#   	x: y.o z.o
#
#   When x.c, y.c and z.c all exist will execute:
#
#   	cc -c x.c -o x.o
#   	cc -c y.c -o y.o
#   	cc -c z.c -o z.o
#   	cc x.o y.o z.o -o x
#   	rm -f x.o
#   	rm -f y.o
#   	rm -f z.o
#
# Yacc for C programs
#   n.c is made automatically from n.y by running Yacc with the 
#   recipe '$(YACC) $(YFLAGS)'.
#
# Lex for C programs
#   n.c is made automatically from n.l by running Lex. The actual
#   recipe is '$(LEX) $(LFLAGS)'.
#
#
# Variables Used by Implicit Rules
#   Here is a table of some of the more common variables sued as
#   names of programs in built-in rules:
#
#   AR - Archive-maintaining program; default 'ar'.
#   AS - Program for compiling assembly files; default 'as'.
#   CC - Program for compiling C programs; default 'cc'.
#   CXX - Program for compiling C++ programs; default 'g++'.
#   CPP - Program for running the C preprocessor, with results to
#     standard output; default '$(CC) -E'.
#   LEX - Program to use to turn Lex grammers into source code;
#     default 'lex'.
#   YACC - Program to use to turn Yacc grammers into source code;
#     default 'yacc'.
#   LINT - Program to use to run lint on source code; default 'lint'.
#   TEX - Program to make TeX DVI files from TeX source; default 'tex'.
#   RM - Command to remove a file; default 'rm -f'.
#
#   Here is a table of variables whose values are additional arguments
#   for the programs above. The default values for all of these is the
#   empty string, unless otherwise noted.
#
#   ARFLAGS - Flags to give the archive-maintaining program; default 
#     'rv'.
#   ASFLAGS - Extra flags to give to assembler (when explicit
#     invoked on a '.s' or '.S' file).
#   CFLAGS - Extra flags to give to the C compiler.
#   CXXFLAGS - Extra flags to give to the C++ compiler.
#   CPPFLAGS - Extra flags to give to the C preprocessor and programs
#     that use it (the C and Fortran compilers).
#   LDFLAGS - Extra flags to give to compilers when they are supposed
#     to invoke the linker, 'ld', such as -L. Libraries (-lfoo)
#     should be added to the LDLIBS variable instead.
#   LDLIBS - Library flags or names given to compilers when they are
#     supposed to invoke the linker, 'ld'. LOADLIBES is deprecated
#     (but still supported) alternative to LDLIBS. Non-library linker
#     flags, such as -L, should go in the LDFLAGS variable.
#   LINTFLAGS - Extra flags go give to lint.
all:
