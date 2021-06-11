#!/bin/bash
#
# simple "test" script - just calls the unit-test and hello programs
set -x
set -e

# Warning: PATH could miss /usr/bin etc. (especially on Windows with Cygwin!)
addpath() {
    set +x
    local arg
    for arg; do
	[ -d "$arg" -a -x "$arg" ] || continue
	# assume bash here
	if ! [[ $PATH =~ "$arg" ]]; then
		PATH="$arg:$PATH"
	fi
    done
    set -x
}
addpath /bin /usr/bin /usr/local/bin /opt/local/bin
# On Windows, we also need to have the Qt mingw kit in the path,
# otherwise libstdc++6 may not be found
addpath /c/Qt/*/mingw*/bin /cygdrive/c/Qt/*/mingw*/bin 

cd build
./hello && ./unit-test

exit $?		# just get another debug output with the exit code
