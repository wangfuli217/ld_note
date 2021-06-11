#                                               -*- Autoconf -*-
# Process this file with autoconf to produce a configure script.

AC_PREREQ([2.69])
AC_INIT(tools, 1.1, [BUG-REPORT-ADDRESS])
AC_CONFIG_SRCDIR([tools_util/include/tools-util.h])
AC_CONFIG_HEADERS([config.h])
AM_INIT_AUTOMAKE([tools] , [1.1])
# Checks for programs.
AC_PROG_CC
AC_PROG_RANLIB
# Checks for libraries.
# FIXME: Replace `main' with a function in `-lcircle_buff':
AC_CHECK_LIB([circle_buff], [main])
# FIXME: Replace `main' with a function in `-lpthread':
AC_CHECK_LIB([pthread], [main])
# FIXME: Replace `main' with a function in `-lrt':
AC_CHECK_LIB([rt], [main])
# FIXME: Replace `main' with a function in `-ltools':
AC_CHECK_LIB([tools], [main])

# Checks for header files.
AC_CHECK_HEADERS([fcntl.h stdint.h stdlib.h string.h sys/time.h unistd.h])

# Checks for typedefs, structures, and compiler characteristics.
AC_C_INLINE
AC_TYPE_SIZE_T

# Checks for library functions.
AC_FUNC_MALLOC
AC_FUNC_MMAP
AC_CHECK_FUNCS([clock_gettime ftruncate gettimeofday memset mkdir munmap regcomp socket])

AC_CONFIG_FILES([Makefile
                 circle_buff/Makefile
                 m_alloc/Makefile
                 psignal/Makefile
                 tools_util/Makefile])
AC_OUTPUT
