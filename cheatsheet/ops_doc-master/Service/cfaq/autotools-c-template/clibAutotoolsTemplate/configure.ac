dnl Process this file with autoconf to produce a configure script.

AC_PREREQ(2.59)
AC_INIT([LibraryName], [1.0])

AC_CONFIG_MACRO_DIR([m4])

AC_CONFIG_AUX_DIR([bin])

AC_CANONICAL_SYSTEM
AM_INIT_AUTOMAKE([-Wall foreign 1.9.6])
AM_SILENT_RULES

AM_PROG_CC_C_O
AC_PROG_CXX
AM_PROG_AR
AC_PROG_LIBTOOL

# Configure Python
AM_PATH_PYTHON([2.7])
PY_PREFIX=`$PYTHON -c 'import sys ; print sys.prefix'`
PYTHON_LIBS="-lpython$PYTHON_VERSION"
PYTHON_CFLAGS="-I$PY_PREFIX/include/python$PYTHON_VERSION"
AC_SUBST([PYTHON_LIBS])
AC_SUBST([PYTHON_CFLAGS])

# Configure Check
AS_IF([test "x$with_check" != "xno"],
      [PKG_CHECK_MODULES([CHECK], [check >= 0.9.4])])

# Configure pthreads.
ACX_PTHREAD([have_pthread=yes])

AC_HEADER_STDC
AC_CHECK_HEADERS([stdlib.h Python.h check.h])

# Configure Doxygen
DX_HTML_FEATURE(ON)
DX_CHM_FEATURE(OFF)
DX_CHI_FEATURE(OFF)
DX_MAN_FEATURE(OFF)
DX_RTF_FEATURE(OFF)
DX_XML_FEATURE(OFF)
DX_PDF_FEATURE(ON)
DX_PS_FEATURE(OFF)

#DX_INIT_DOXYGEN([$PACKAGE_NAME],[src/doxygen.cfg])


AC_FUNC_MALLOC
AC_CONFIG_HEADERS([config.h])

AC_CONFIG_FILES([ 
		  Makefile 
          src/Makefile
          #src/[LibraryName]/Makefile
          #src/[LibraryName]/[Package1]/Makefile
          bindings/Makefile
          bindings/cpp/Makefile
          bindings/python/Makefile
          examples/Makefile
          examples/c/Makefile
          examples/cpp/Makefile
          tests/Makefile
          tests/check/Makefile
])
		  

AC_OUTPUT

AC_MSG_RESULT([
Configure Information:
  Preprocessor      :
    CPPFLAGS        : $CPPFLAGS

  C Compiler        : $CC
    DEFS            :   $DEFS
    CFLAGS          :   $CFLAGS
    
  C++ Compiler      : $CXX
    CXXFLAGS        :   $CXXFLAGS

  Linker            : $LD
    LDFLAGS         :   $LDFLAGS
    LIBS            :   $LIBS

  Python            : $PYTHON
    PY_PREFIX       :   $PY_PREFIX
    PYTHON_LIBS     :   $PYTHON_LIBS
    PYTHON_CFLAGS   :   $PYTHON_CFLAGS
 ])
