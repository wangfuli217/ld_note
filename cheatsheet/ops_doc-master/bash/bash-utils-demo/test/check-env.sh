#!/usr/bin/env bash
#
# <http://github.com/e-picas/bash-utils>
# Copyright (c) 2015 Pierre Cassat & contributors
# License Apache 2.0 - This program comes with ABSOLUTELY NO WARRANTY.
# For the full copyright and license information, please view the LICENSE
# file that was distributed with this source code or see <http://www.apache.org/licenses/LICENSE-2.0>.
#
# environment checker
#

export status=0

# usage: `run_test <test-description> "test to run" [failure-message=KO] [success-message=OK] [failure-comment=NULL]`
# the 'test to run' must return 0 (success) or 1 (failure)
run_test()
{
    [ $# -lt 2 ] && { echo "usage: run_test <test-description> \"test to run\" [failure-message=KO] [success-message=OK] [failure-comment=NULL]" >&2; exit 1; };
    result="$(eval "$2")"
    if [ $? -eq 0 ]; then
        printf ' \033[0;32m✓\033[0m %s ...' "$1"
        [ -z "${4:-}" ] && echo " OK" || echo " OK: $4";
        return 0
    else
        printf ' \033[0;31m✗ %s ... *****KO*****\033[0m\n' "$1"
        errstr=''
        [ -z "${3:-}" ] && errstr+="   !! > test KO: '$1'" || errstr+="   !! > $3";
        [ -z "${5:-}" ] || errstr+=" ; $5";
        echo "$errstr" >&2;
        return 1
    fi
}

# usage: `test_title <title-message>`
test_title()
{
    [ $# -lt 1 ] && { echo "usage: test_title <title-message>" >&2; exit 1; };
    echo
    echo "### $1 ###"
    return 0
}

## System
test_title 'System'
pwd
date +'%Y-%m-%dT%H:%M:%S%z'
uname -a

## Shell
test_title '*Bash* environment'

bashcmd="$(command -v bash)"

# $SHELL
run_test 'searching "$SHELL" environment variable' \
    '[ -z "$SHELL" ] && return 1 || return 0' \
    '"$SHELL" environment variable is NOT defined' \
    "$SHELL" \
    "you should define it as \"SHELL=$bashcmd\"";

# $SHELL=bash
run_test 'link "$SHELL" to *Bash* shell' \
    '[ "$SHELL" = "$bashcmd" ] && return 0 || return 1' \
    '"$SHELL" environment variable is NOT linked to *Bash*' \
    "$SHELL" \
    "you should define it as \"SHELL=$bashcmd\"";

# $BASH_VERSION = 3+
run_test '*Bash* version 3+' \
    '[[ "${BASH_VERSION:0:1}" -gt 2 ]] && return 0 || return 1' \
    '*Bash* version is LESS than 3' \
    "$BASH_VERSION" \
    "you should update it with \"aptitude upgrade bash\"";

# ~/.bashrc
starterfile="${HOME}/.bashrc"
run_test 'searching *Bash* starter file' \
    '[ -f "$starterfile" ] && return 0 || return 1' \
    'you do NOT have a *Bash* starter file' \
    "$starterfile" \
    "you should use a default \"\$HOME/.bashrc\"";

# $BASH_ENV
[ -n "$BASH_ENV" ] && starterfile="$BASH_ENV";
run_test 'searching for the "$BASH_ENV" variable' \
    '[ -n "$BASH_ENV" ] && [ -f "$BASH_ENV" ] && return 0 || return 1' \
    '"$BASH_ENV" environment variable is NOT defined' \
    "$BASH_ENV" \
    "you should define it as \"BASH_ENV=\$HOME/.bashrc\"";

# ~/bin
run_test 'searching for personal "bin/" directory' \
    '[ -d ~/bin ] && return 0 || return 1' \
    'you do NOT have a personal "bin/" directory' \
    "${HOME}/bin" \
    "you should create directory \"\$HOME/bin\" to store your shell scripts";

# ~/bin added in PATH
result="$(cat "$starterfile" 2>/dev/null | grep -E 'PATH=.*\${?HOME}?/bin.*')"
run_test 'searching if personal "bin/" is added in the "$PATH"' \
    '[ -z "$result" ] && return 1 || return 0' \
    'your personal "bin/" directory is NOT included in the "$PATH"' \
    "${BASH_ENV} : ${result}" \
    "you should add \"export PATH=\$PATH:\$HOME/bin\" in your \"\$HOME/.bashrc\"";


## commands
test_title 'Required commands'

cmds=(echo sed grep cut tr cat getopt mktemp)

for cmd in "${cmds[@]}"; do
    _cmd="$((type "$cmd" 2>/dev/null | grep -v 'alias') || command -v "$cmd")"
    run_test "searching for command '$cmd'" \
        "[ -z \"$_cmd\" ] && return 1 || return 0" \
        "the \"$cmd\" command can NOT be found" \
        "${_cmd}" \
        "you should install it with \"aptitude install $cmd\"";
done

## bash-utils
test_title '*Bash-Utils* installation'

result="$(/usr/bin/env bash-utils)"
out=$?
bashutilscmd="$(command -v bash-utils)"
run_test 'searching for global "bash-utils"' \
    '( [ "$out" -gt 1 ] && [ -n "$bashutilscmd" ] ) && return 1 || return 0' \
    'the *Bash-Utils* library is NOT installed' \
    "${bashutilscmd}" \
    "you should install it running \"make install DESTDIR=/usr/local/bin\"";


echo
exit $status
# vim: autoindent tabstop=4 shiftwidth=4 expandtab softtabstop=4 filetype=sh
