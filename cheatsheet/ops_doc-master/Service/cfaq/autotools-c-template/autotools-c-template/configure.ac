AC_INIT([project-name], [0.0.1])

# 'foreign' specifies not to create the default GNU-style project files,
# such as touch, NEWS, README, AUTHORS ...
AM_INIT_AUTOMAKE([-Wall -Werror foreign])

# Defaults make verbosity to V=0, so that make generates a prettier, less
# verbose output. To go back to normal comment out the line, or call make with
# the 'V=1' argument to see a normal output.
AM_SILENT_RULES([yes])

AC_PROG_CC

AC_CONFIG_HEADERS([src/config.h])

AC_CONFIG_FILES([
    Makefile
    src/Makefile
])

AC_OUTPUT
