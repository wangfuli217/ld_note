#!/usr/bin/env bats
#
# <http://github.com/e-picas/bash-utils>
# Copyright (c) 2015 Pierre Cassat & contributors
# License Apache 2.0 - This program comes with ABSOLUTELY NO WARRANTY.
# For the full copyright and license information, please view the LICENSE
# file that was distributed with this source code or see <http://www.apache.org/licenses/LICENSE-2.0>.
#
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

setup()
{
    : # nothing
}

teardown()
{
    : # nothing
}

@test "[cmd 1] no argument / usage: usage string" {
    # no arg
    run "$TESTBASHUTILS_BIN"
    $TEST_DEBUG && {
        echo "running: $TESTBASHUTILS_BIN"
        echo "output: $output"
        echo "status: $status"
    } >&1
    [ "$status" -eq 1 ]
    noargoutput="$output"
    echo "$output" | grep '^usage:'
    # usage
    run "$TESTBASHUTILS_BIN" usage
    $TEST_DEBUG && {
        echo "running: $TESTBASHUTILS_BIN usage"
        echo "output: $output"
        echo "status: $status"
    } >&1
    [ "$status" -eq 0 ]
    echo "$output" | grep '^usage:'
    [ "$output" = "$noargoutput" ]
}

@test "[cmd 2] --help / -h / help: help string (multi-lines)" {
    # --help
    run "$TESTBASHUTILS_BIN" --help
    $TEST_DEBUG && {
        echo "running: $TESTBASHUTILS_BIN --help"
        echo "output: $output"
        echo "status: $status"
    } >&1
    [ "$status" -eq 0 ]
    [ "${#lines[@]}" -gt 1 ]
    helpopt="$output"
    # -h
    run "$TESTBASHUTILS_BIN" -h
    $TEST_DEBUG && {
        echo "running: $TESTBASHUTILS_BIN -h"
        echo "output: $output"
        echo "status: $status"
    } >&1
    [ "$status" -eq 0 ]
    [ "${#lines[@]}" -gt 1 ]
    hopt="$output"
    [ "$helpopt" = "$hopt" ]
    # help
    run "$TESTBASHUTILS_BIN" help
    $TEST_DEBUG && {
        echo "running: $TESTBASHUTILS_BIN help"
        echo "output: $output"
        echo "status: $status"
    } >&1
    [ "$status" -eq 0 ]
    [ "${#lines[@]}" -gt 1 ]
    [ "$output" = "$helpopt" ]
    [ "$output" = "$hopt" ]
}

@test "[cmd 3] --version / -V / about: version string (multi-lines)" {
    # --version
    run "$TESTBASHUTILS_BIN" --version
    $TEST_DEBUG && {
        echo "running: $TESTBASHUTILS_BIN --version"
        echo "output: $output"
        echo "status: $status"
    } >&1
    [ "$status" -eq 0 ]
    [ "${#lines[@]}" -gt 1 ]
    versionopt="$output"
    # -V
    run "$TESTBASHUTILS_BIN" -V
    $TEST_DEBUG && {
        echo "running: $TESTBASHUTILS_BIN -V"
        echo "output: $output"
        echo "status: $status"
    } >&1
    [ "$status" -eq 0 ]
    [ "${#lines[@]}" -gt 1 ]
    Vopt="$output"
    [ "$versionopt" = "$Vopt" ]
    # about
    run "$TESTBASHUTILS_BIN" about
    $TEST_DEBUG && {
        echo "running: $TESTBASHUTILS_BIN about"
        echo "output: $output"
        echo "status: $status"
    } >&1
    [ "$status" -eq 0 ]
    [ "${#lines[@]}" -gt 1 ]
    [ "$output" = "$versionopt" ]
    [ "$output" = "$Vopt" ]
}

@test "[cmd 4] --version --quiet / -Vq / version: version string (single line)" {
    # --version --quiet
    run "$TESTBASHUTILS_BIN" --version --quiet
    $TEST_DEBUG && {
        echo "running: $TESTBASHUTILS_BIN --version --quiet"
        echo "output: $output"
        echo "status: $status"
    } >&1
    [ "$status" -eq 0 ]
    vquietopt="$output"
    [ "${#lines[@]}" -eq 1 ]
    # -Vq
    run "$TESTBASHUTILS_BIN" -Vq
    $TEST_DEBUG && {
        echo "running: $TESTBASHUTILS_BIN -Vq"
        echo "output: $output"
        echo "status: $status"
    } >&1
    [ "$status" -eq 0 ]
    quietopt="$output"
    [ "${#lines[@]}" -eq 1 ]
    [ "$output" = "$vquietopt" ]
    # version
    run "$TESTBASHUTILS_BIN" version
    $TEST_DEBUG && {
        echo "running: $TESTBASHUTILS_BIN version"
        echo "output: $output"
        echo "status: $status"
    } >&1
    [ "$status" -eq 0 ]
    [ "${#lines[@]}" -eq 1 ]
    [ "$output" = "$vquietopt" ]
    [ "$output" = "$quietopt" ]
}

@test "[cmd 5] -e / --exec / piped input with --exec" {
    # --exec ...
    run "$TESTBASHUTILS_BIN" --exec='string_to_upper "test"'
    $TEST_DEBUG && {
        echo "running: $TESTBASHUTILS_BIN --exec='string_to_upper \"test\"'"
        echo "output: $output"
        echo "status: $status"
    } >&1
    [ "$status" -eq 0 ]
    [ "$output" = 'TEST' ]
    # -e ...
    run "$TESTBASHUTILS_BIN" -e='string_to_upper "test"'
    $TEST_DEBUG && {
        echo "running: $TESTBASHUTILS_BIN -e='string_to_upper \"test\"'"
        echo "output: $output"
        echo "status: $status"
    } >&1
    [ "$status" -eq 0 ]
    [ "$output" = 'TEST' ]
    # echo "..." | bash-utils --exec
    run echo 'string_to_upper "test"' | "$TESTBASHUTILS_BIN" --exec
    $TEST_DEBUG && {
        echo "running: echo 'string_to_upper \"test\"' | $TESTBASHUTILS_BIN --exec"
        echo "output: $output"
        echo "status: $status"
    } >&1
    [ "$status" -eq 0 ]
    [ "$output" = 'TEST' ]
    # echo "..." | bash-utils -e
    run echo 'string_to_upper "test"' | "$TESTBASHUTILS_BIN" -e
    $TEST_DEBUG && {
        echo "running: echo 'string_to_upper \"test\"' | $TESTBASHUTILS_BIN -e"
        echo "output: $output"
        echo "status: $status"
    } >&1
    [ "$status" -eq 0 ]
    [ "$output" = 'TEST' ]
    # --exec=filename
    run "$TESTBASHUTILS_BIN" --exec="$TESTBASHUTILS_TESTSCRIPT"
    $TEST_DEBUG && {
        echo "running: $TESTBASHUTILS_BIN --exec=$TESTBASHUTILS_TESTSCRIPT"
        echo "output: $output"
        echo "status: $status"
    } >&1
    [ "$status" -eq 0 ]
    [ "$output" = 'TEST' ]
}

@test "[cmd 6] modules: list of modules" {
    # modules
    run "$TESTBASHUTILS_BIN" modules
    $TEST_DEBUG && {
        echo "running: $TESTBASHUTILS_BIN modules"
        echo "output: $output"
        echo "status: $status"
    } >&1
    [ "$status" -eq 0 ]
    echo "$output" | grep 'model'
}

@test "[cmd/core 7] common options flags" {
    # dry-run
    run "$TESTBASHUTILS_BIN" --exec='truefalse_bit "$DRY_RUN"'
    $TEST_DEBUG && {
        echo "running: $TESTBASHUTILS_BIN --exec='truefalse_bit $DRY_RUN'"
        echo "output: $output"
    } >&1
    [ "$output" = 'false' ]
    run "$TESTBASHUTILS_BIN" --dry-run --exec='truefalse_bit "$DRY_RUN"'
    $TEST_DEBUG && {
        echo "running: $TESTBASHUTILS_BIN --dry-run --exec='truefalse_bit $DRY_RUN'"
        echo "output: $output"
    } >&1
    [ "$output" = 'true' ]
    run "$TESTBASHUTILS_BIN" --exec='truefalse_bit "$DRY_RUN"' --dry-run
    $TEST_DEBUG && {
        echo "running: $TESTBASHUTILS_BIN --exec='truefalse_bit $DRY_RUN' --dry-run"
        echo "output: $output"
    } >&1
    [ "$output" = 'true' ]
    # force
    run "$TESTBASHUTILS_BIN" --exec='truefalse_bit "$FORCE"'
    $TEST_DEBUG && {
        echo "running: $TESTBASHUTILS_BIN --exec='truefalse_bit $FORCE'"
        echo "output: $output"
    } >&1
    [ "$output" = 'false' ]
    run "$TESTBASHUTILS_BIN" -f --exec='truefalse_bit "$FORCE"'
    $TEST_DEBUG && {
        echo "running: $TESTBASHUTILS_BIN -f --exec='truefalse_bit $FORCE'"
        echo "output: $output"
    } >&1
    [ "$output" = 'true' ]
    run "$TESTBASHUTILS_BIN" --force --exec='truefalse_bit "$FORCE"'
    $TEST_DEBUG && {
        echo "running: $TESTBASHUTILS_BIN --force --exec='truefalse_bit $FORCE'"
        echo "output: $output"
    } >&1
    [ "$output" = 'true' ]
    run "$TESTBASHUTILS_BIN" --exec='truefalse_bit "$FORCE"' -f
    $TEST_DEBUG && {
        echo "running: $TESTBASHUTILS_BIN --exec='truefalse_bit $FORCE' -f"
        echo "output: $output"
    } >&1
    [ "$output" = 'true' ]
    run "$TESTBASHUTILS_BIN" --exec='truefalse_bit "$FORCE"' --force
    $TEST_DEBUG && {
        echo "running: $TESTBASHUTILS_BIN --exec='truefalse_bit $FORCE' --force"
        echo "output: $output"
    } >&1
    [ "$output" = 'true' ]
    # verbose
    run "$TESTBASHUTILS_BIN" --exec='truefalse_bit "$VERBOSE"'
    $TEST_DEBUG && {
        echo "running: $TESTBASHUTILS_BIN --exec='truefalse_bit $VERBOSE'"
        echo "output: $output"
    } >&1
    [ "$output" = 'false' ]
    run "$TESTBASHUTILS_BIN" -v --exec='truefalse_bit "$VERBOSE"'
    $TEST_DEBUG && {
        echo "running: $TESTBASHUTILS_BIN -v --exec='truefalse_bit $VERBOSE'"
        echo "output: $output"
    } >&1
    [ "$output" = 'true' ]
    run "$TESTBASHUTILS_BIN" --verbose --exec='truefalse_bit "$VERBOSE"'
    $TEST_DEBUG && {
        echo "running: $TESTBASHUTILS_BIN --verbose --exec='truefalse_bit $VERBOSE'"
        echo "output: $output"
    } >&1
    [ "$output" = 'true' ]
    run "$TESTBASHUTILS_BIN" --exec='truefalse_bit "$VERBOSE"' -v
    $TEST_DEBUG && {
        echo "running: $TESTBASHUTILS_BIN --exec='truefalse_bit $VERBOSE' -v"
        echo "output: $output"
    } >&1
    [ "$output" = 'true' ]
    run "$TESTBASHUTILS_BIN" --exec='truefalse_bit "$VERBOSE"' --verbose
    $TEST_DEBUG && {
        echo "running: $TESTBASHUTILS_BIN --exec='truefalse_bit $VERBOSE' --verbose"
        echo "output: $output"
    } >&1
    [ "$output" = 'true' ]
    # quiet
    run "$TESTBASHUTILS_BIN" --exec='truefalse_bit "$QUIET"'
    $TEST_DEBUG && {
        echo "running: $TESTBASHUTILS_BIN --exec='truefalse_bit $QUIET'"
        echo "output: $output"
    } >&1
    [ "$output" = 'false' ]
    run "$TESTBASHUTILS_BIN" -q --exec='truefalse_bit "$QUIET"'
    $TEST_DEBUG && {
        echo "running: $TESTBASHUTILS_BIN -q --exec='truefalse_bit $QUIET'"
        echo "output: $output"
    } >&1
    [ "$output" = 'true' ]
    run "$TESTBASHUTILS_BIN" --quiet --exec='truefalse_bit "$QUIET"'
    $TEST_DEBUG && {
        echo "running: $TESTBASHUTILS_BIN --quiet --exec='truefalse_bit $QUIET'"
        echo "output: $output"
    } >&1
    [ "$output" = 'true' ]
    run "$TESTBASHUTILS_BIN" --exec='truefalse_bit "$QUIET"' -q
    $TEST_DEBUG && {
        echo "running: $TESTBASHUTILS_BIN --exec='truefalse_bit $QUIET' -q"
        echo "output: $output"
    } >&1
    [ "$output" = 'true' ]
    run "$TESTBASHUTILS_BIN" --exec='truefalse_bit "$QUIET"' --quiet
    $TEST_DEBUG && {
        echo "running: $TESTBASHUTILS_BIN --exec='truefalse_bit $QUIET' --quiet"
        echo "output: $output"
    } >&1
    [ "$output" = 'true' ]
    # debug
    run "$TESTBASHUTILS_BIN" --exec='truefalse_bit "$DEBUG"'
    $TEST_DEBUG && {
        echo "running: $TESTBASHUTILS_BIN --exec='truefalse_bit $DEBUG'"
        echo "output: $output"
    } >&1
    [ "$output" = 'false' ]
    run "$TESTBASHUTILS_BIN" -x --exec='truefalse_bit "$DEBUG"'
    $TEST_DEBUG && {
        echo "running: $TESTBASHUTILS_BIN -x --exec='truefalse_bit $DEBUG'"
        echo "output: $output"
    } >&1
    echo "$output" | grep 'true$'
    run "$TESTBASHUTILS_BIN" --debug --exec='truefalse_bit "$DEBUG"'
    $TEST_DEBUG && {
        echo "running: $TESTBASHUTILS_BIN --debug --exec='truefalse_bit $DEBUG'"
        echo "output: $output"
    } >&1
    echo "$output" | grep 'true$'
    run "$TESTBASHUTILS_BIN" --exec='truefalse_bit "$DEBUG"' -x
    $TEST_DEBUG && {
        echo "running: $TESTBASHUTILS_BIN --exec='truefalse_bit $DEBUG' -x"
        echo "output: $output"
    } >&1
    echo "$output" | grep 'true$'
    run "$TESTBASHUTILS_BIN" --exec='truefalse_bit "$DEBUG"' --debug
    $TEST_DEBUG && {
        echo "running: $TESTBASHUTILS_BIN --exec='truefalse_bit $DEBUG' --debug"
        echo "output: $output"
    } >&1
    echo "$output" | grep 'true$'
}

