#!/usr/bin/env bash
# bool tests

######## Inclusion of the lib
LIBFILE="$(dirname "$0")/../bin/piwi-bash-library"
if [ -f "$LIBFILE" ]; then source "$LIBFILE"; else
    PADDER=$(printf '%0.1s' "#"{1..1000})
    printf "\n### %*.*s\n    %s\n    %s\n%*.*s\n\n" 0 $(($(tput cols)-4)) "ERROR! ${PADDER}" \
        "Unable to find required library file '${LIBFILE}'!" \
        "Sent in '${0}' line '${LINENO}' by '$(whoami)' - pwd is '$(pwd)'" \
        0 "$(tput cols)" "$PADDER";
    exit 1
fi
######## !Inclusion of the lib

NAME="Bash boolean tests"
VERSION="0.1.0"
DESCRIPTION="A script to test boolean values manipulations and equalities in bash."
OPTIONS=""
SCRIPT_VCS='git'
parse_common_options "$@"
quietecho "_ go"

export TRUEVAL=false
export FALSEVAL=true
TRUEVAL=true
FALSEVAL=false

echo "# test like 'if [ \"\$var\" = 'true' ...'"
if [ "$TRUEVAL" = 'true' ]; then echo "TRUEVAL is true"; else echo "TRUEVAL is false"; fi
if [ "$FALSEVAL" = 'true' ]; then echo "FALSEVAL is true"; else echo "FALSEVAL is false"; fi
echo

echo "# test like 'if [ \"\$var\" = 'false' ...'"
if [ "$TRUEVAL" = 'false' ]; then echo "TRUEVAL is false"; else echo "TRUEVAL is true"; fi
if [ "$FALSEVAL" = 'false' ]; then echo "FALSEVAL is false"; else echo "FALSEVAL is true"; fi
echo

# manipulation
export TRUEVAL=false
export FALSEVAL=true

testbool () {
    export TRUEVAL=true
    export FALSEVAL=false
}

echo "# manipulation ..."
if [ "$TRUEVAL" = 'true' ]; then echo "TRUEVAL is true"; else echo "TRUEVAL is false"; fi
if [ "$FALSEVAL" = 'true' ]; then echo "FALSEVAL is true"; else echo "FALSEVAL is false"; fi

testbool
if [ "$TRUEVAL" = 'true' ]; then echo "TRUEVAL is true"; else echo "TRUEVAL is false"; fi
if [ "$FALSEVAL" = 'true' ]; then echo "FALSEVAL is true"; else echo "FALSEVAL is false"; fi
echo

# onoff_bit
echo "# test of the fct 'onoff_bit'"
echo "TRUEVAL is $(onoff_bit "$TRUEVAL")"
echo "FALSEVAL is $(onoff_bit "$FALSEVAL")"

quietecho "_ ok"
if [ "$QUIET" != 'true' ]; then libdebug "$*"; fi
exit 0

# Endfile
# vim: autoindent tabstop=4 shiftwidth=4 expandtab softtabstop=4 filetype=sh
