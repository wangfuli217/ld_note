# libmake

A collection of Makefiles for building C executables and
libraries. `libmake` is unlicensed, see the `LICENSE` file.

`libmake` will automatically offer the following targets to your
project:

* `all` to build all binaries.
* `install` to install your project.
* `clean` to clean your source directory.
* `cppcheck` to run cppcheck on your source files.

`libmake` supports both `clang` and `gcc` build flags and and will
offer the following options to your project:

* `RELEASE=yes` to enable release optimizations.
* `PCHECKS=yes` to enable pointer and bounds checking.
* `SANITIZE=yes` to enable undefined behavior sanitizers.
* `SANITIZE_THREAD=yes` to enable the thread sanitizer.
* `SANITIZE_MEMORY=yes` to enable the memory sanitizer.
* `SANITIZE_COVERAGE_BB` to enable block-level coverage.
* `SANITIZE_COVERAGE_EDGE` to enable edge-level coverage.
* `SANITIZE_COVERAGE_FUNC` to enable function-level coverage.

## Usage

To use libmake, you can checkout the repository as a submodule of your
git repository:

    git submodule add https://github.com/fredmorcos/libmake.git

which we will assume has checked out `libmake` into a sub-directory
called `libmake`.

## Example: Building a library

We will assume the library is called `libmy`. The first part of the
`Makefile` would be to set the name:

    NAME = libmy

The second part would be to declare the type of project we want to
build (an executable, a shared library or a static library). Since
we're building a library, we could add the following:

    ifeq ($(STATIC),yes)
    	TYPE = staticlib
    else
    	TYPE = lib
    endif

This will build a `libmy.so` or `libmy.a` depending on whether you set
`STATIC=yes` or not on the command line (`make STATIC=yes`).

**As an alternative**, you could simply pass TYPE=staticlib on the
command line and set `TYPE` as follows:

    TYPE ?= lib

To build a shared library by default.

The binary library files can be installed to `$DESTDIR/lib/libmy.so`
or `$DESTDIR/lib/libmy.a` using `make install DESTDIR=/usr/local` as
an example.

Next we can declare the list of objects our binary will be composed
of: an object is a target object file, which decomposes into a `C`
source and a `C` header file pair (eg, `module.c` and `module.h`)
according to `libmake`.

    OBJECTS = module1.o module2.o

This will help `libmake` assume there are `module1.c`, `module1.h`,
`module2.c` and `module2.h` files in your project, and that
`module1.c` and `module2.c` will be compiled into `module1.o` and
`module2.o`, respectively.

Next we can declare the list of standalone header files for the
library:

    HEADERS = my.h

All header files, `module1.h`, `module2.h` and `my.h`, will be
installed into `$DESTDIR/include/libmy`.

One or more license files can be provided as follows:

    LICENSE_FILES = LICENSE1 LICENSE2

Which will be installed into `$DESTDIR/share/libmy`.

Finally, include the project makefile from `libmake` as follows:

    include libmake/proj.mk

Which will automatically provide the `all`, `install` and `clean`
targets and the niceties from `libmake` explained above.

Additionally, you could provide a `cleanall` target, which would clean
both the shared and static library files:

    cleanall:
    	$(MAKE) clean
    	$(MAKE) STATIC=yes clean

**Or as an alternative**, `$(MAKE) TYPE=staticlib clean`.

Note that additional targets should always come after the `include
proj.mk` line.

The complete `Makefile` would look as follows:

```make
NAME = libmy

ifeq ($(STATIC),yes)
    TYPE = staticlib
else
    TYPE = lib
endif

OBJECTS = module1.o module2.o
HEADERS = my.h

LICENSE_FILES = LICENSE1 LICENSE2

include libmake/proj.mk

cleanall:
    $(MAKE) clean
    $(MAKE) STATIC=yes clean
```
