#!/usr/bin/env bats
#
# <http://github.com/e-picas/bash-utils>
# Copyright (c) 2015 Pierre Cassat & contributors
# License Apache 2.0 - This program comes with ABSOLUTELY NO WARRANTY.
# For the full copyright and license information, please view the LICENSE
# file that was distributed with this source code or see <http://www.apache.org/licenses/LICENSE-2.0>.
#
#@test "" {
#    run ...
#    $TEST_DEBUG && {
#        echo "running: ..."
#        echo "output: $output"
#        echo "status: $status"
#    } >&1
#    [ "$status" -eq 0 ]
#    [ -n "$output" ]
#}
#

load test-commons

declare -x BASHUTILS_TMPDIR
declare -x BASHUTILS_STASHED=false

setup()
{
    BASHUTILS_TMPDIR="$(mktemp -d)"
}

teardown()
{
    [ -n "$BASHUTILS_TMPDIR" ] && [ -d "$BASHUTILS_TMPDIR" ] && rm -rf "$BASHUTILS_TMPDIR";
}

setup_git()
{
    git stash save 'bats testing' && BASHUTILS_STASHED=true;
}

teardown_git()
{
    $BASHUTILS_STASHED && git stash pop;
}

setup_manpages()
{
    [ -f "$TESTBASHUTILS_MANPAGE1" ] && mv "$TESTBASHUTILS_MANPAGE1" "${TESTBASHUTILS_MANPAGE1}.back";
    [ -f "$TESTBASHUTILS_MANPAGE2" ] && mv "$TESTBASHUTILS_MANPAGE2" "${TESTBASHUTILS_MANPAGE2}.back";
}

teardown_manpages()
{
    [ -f "$TESTBASHUTILS_MANPAGE1" ] && rm -f "$TESTBASHUTILS_MANPAGE1";
    [ -f "$TESTBASHUTILS_MANPAGE2" ] && rm -f "$TESTBASHUTILS_MANPAGE2";
    [ -f "${TESTBASHUTILS_MANPAGE1}.back" ] && mv "${TESTBASHUTILS_MANPAGE1}.back" "$TESTBASHUTILS_MANPAGE1";
    [ -f "${TESTBASHUTILS_MANPAGE2}.back" ] && mv "${TESTBASHUTILS_MANPAGE2}.back" "$TESTBASHUTILS_MANPAGE2";
}

get_version()
{
    $TESTBASHUTILS_BIN -Vq | cut -d' ' -f2
}

#@test "test failure (must fail to validate all other tests)" {
#    [ true = false ]
#}

@test "[make 1] install" {
    run $TESTBASHUTILS_MAKE install "DESTDIR=$BASHUTILS_TMPDIR"
    $TEST_DEBUG && {
        echo "running: $TESTBASHUTILS_MAKE install DESTDIR=$BASHUTILS_TMPDIR"
        echo "output: $output"
        echo "status: $status"
    } >&1
    [ "$status" -eq 0 ]
    [ -f "${BASHUTILS_TMPDIR}/bin/bash-utils" ]
    [ -f "${BASHUTILS_TMPDIR}/libexec/bash-utils" ]
    [ -f "${BASHUTILS_TMPDIR}/share/man/man1/bash-utils.1.man" ]
}

@test "[make 2] cleanup" {
    # install
    run $TESTBASHUTILS_MAKE install "DESTDIR=$BASHUTILS_TMPDIR"
    $TEST_DEBUG && {
        echo "running: $TESTBASHUTILS_MAKE install DESTDIR=$BASHUTILS_TMPDIR"
        echo "output: $output"
        echo "status: $status"
    } >&1
    [ "$status" -eq 0 ]
    [ -f "${BASHUTILS_TMPDIR}/bin/bash-utils" ]
    [ -f "${BASHUTILS_TMPDIR}/libexec/bash-utils" ]
    [ -f "${BASHUTILS_TMPDIR}/share/man/man1/bash-utils.1.man" ]
    # add a file
    addon="${BASHUTILS_TMPDIR}/libexec/bash-util-addon"
    run touch "$addon"
    $TEST_DEBUG && {
        echo "running: touch $addon"
        echo "output: $output"
        echo "status: $status"
    } >&1
    [ -f "$addon" ]
    # install
    run $TESTBASHUTILS_MAKE cleanup "DESTDIR=$BASHUTILS_TMPDIR"
    $TEST_DEBUG && {
        echo "running: $TESTBASHUTILS_MAKE cleanup DESTDIR=$BASHUTILS_TMPDIR"
        echo "output: $output"
        echo "status: $status"
    } >&1
    [ "$status" -eq 0 ]
    [ ! -f "${BASHUTILS_TMPDIR}/bin/bash-utils" ]
    [ ! -f "${BASHUTILS_TMPDIR}/libexec/bash-utils" ]
    [ ! -f "${BASHUTILS_TMPDIR}/share/man/man1/bash-utils.1.man" ]
    [ -f "$addon" ]
}

@test "[make 3] manpages" {
    # test manpages are NOT here
    setup_manpages
    [ ! -f "$TESTBASHUTILS_MANPAGE1" ]
    [ ! -f "$TESTBASHUTILS_MANPAGE2" ]
    # build manpages
    run $TESTBASHUTILS_MAKE manpages
    $TEST_DEBUG && {
        echo "running: $TESTBASHUTILS_MAKE manpages"
        echo "output: $output"
        echo "status: $status"
    } >&1
    [ "$status" -eq 0 ]
    [ -f "$TESTBASHUTILS_MANPAGE1" ]
    [ -f "$TESTBASHUTILS_MANPAGE2" ]
    # cleanup
    teardown_manpages
}

@test "[make 4] version" {
    # git original version
    original_version="$(get_version)"
    [ -n "$original_version" ]
    # version only
    run $TESTBASHUTILS_MAKE version
    $TEST_DEBUG && {
        echo "running: $TESTBASHUTILS_MAKE version"
        echo "output: $output"
        echo "status: $status"
    } >&1
    [ "$status" -ne 0 ]
    [ "$original_version" = "$(get_version)" ]
    # version only 99.99.99
    run $TESTBASHUTILS_MAKE version VERSION=99.99.99
    $TEST_DEBUG && {
        echo "running: $TESTBASHUTILS_MAKE version VERSION=99.99.99"
        echo "output: $output"
        echo "status: $status"
    } >&1
    [ "$status" -eq 0 ]
    [ "$(get_version)" = '99.99.99' ]
    # back to original version
    run $TESTBASHUTILS_MAKE version "VERSION=$original_version"
    $TEST_DEBUG && {
        echo "running: $TESTBASHUTILS_MAKE version VERSION=$original_version"
        echo "output: $output"
        echo "status: $status"
    } >&1
    [ "$status" -eq 0 ]
    [ "$original_version" = "$(get_version)" ]
}
