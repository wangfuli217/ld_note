#!/usr/bin/env bash
# evaluate() test

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

NAME="Bash-Lib script test for command evaluations"
VERSION="0.1.0"
DESCRIPTION="A script to test internal 'eval()' vs library 'evaluate()' methods ...";
OPTIONS_USAGE="${COMMON_OPTIONS_USAGE}";

rearrange_script_options "$@"
[ "${#SCRIPT_OPTS[@]}" -gt 0 ] && set -- "${SCRIPT_OPTS[@]}";
[ "${#SCRIPT_ARGS[@]}" -gt 0 ] && set -- "${SCRIPT_ARGS[@]}";
[ "${#SCRIPT_OPTS[@]}" -gt 0 -a "${#SCRIPT_ARGS[@]}" -gt 0 ] && set -- "${SCRIPT_OPTS[@]}" -- "${SCRIPT_ARGS[@]}";
parse_common_options_strict
quietecho "_ go"


echo
echo "## test of 'evaluate' method with direct call:"
evaluate 'echo "std"; echo "err" >&2; exit 2;'
#evaluate 'echo std; echo err >&2;'
echo "cmd out: ${CMD_OUT}"
echo "cmd err: ${CMD_ERR}"
echo "cmd status: ${CMD_STATUS}"

echo
echo "## test of 'evaluate' method as sub-command:"
test=$(evaluate 'echo "std 2"; echo "err 2" >&2; exit 3;')
echo "test: $test"
echo "cmd out: ${CMD_OUT}"
echo "cmd err: ${CMD_ERR}"
echo "cmd status: ${CMD_STATUS}"

echo
echo "## second test of 'evaluate' method with direct call:"
evaluate 'echo "std 3"; echo "err 3" >&2; exit 4;'
#evaluate 'echo std; echo err >&2;'
echo "cmd out: ${CMD_OUT}"
echo "cmd err: ${CMD_ERR}"
echo "cmd status: ${CMD_STATUS}"

cmd='find src \(\)'

echo
echo "## classic"
out=$(eval "$cmd")
stt=$?
echo "out: $out"
echo "status: $stt"

echo
echo "## ieval"
out=$(ieval "$cmd")
stt=$?
echo "out: $out"
echo "status: $stt"
echo "cmd out: ${CMD_OUT}"
echo "cmd err: ${CMD_ERR}"
echo "cmd status: ${CMD_STATUS}"

echo
echo "## ieval with silent direct errors:"
out=$(ieval "$cmd" 2>/dev/null)
stt=$?
echo "out: $out"
echo "status: $stt"

quietecho "_ ok"
if [ "$QUIET" != 'true' ]; then libdebug "$*"; fi
exit 0

# Endfile
# vim: autoindent tabstop=4 shiftwidth=4 expandtab softtabstop=4 filetype=sh
