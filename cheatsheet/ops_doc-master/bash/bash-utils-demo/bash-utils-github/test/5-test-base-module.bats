#!/usr/bin/env bats
#
# <http://github.com/e-picas/bash-utils>
# Copyright (c) 2015 Pierre Cassat & contributors
# License Apache 2.0 - This program comes with ABSOLUTELY NO WARRANTY.
# For the full copyright and license information, please view the LICENSE
# file that was distributed with this source code or see <http://www.apache.org/licenses/LICENSE-2.0>.
#
# The "test" module is "model"
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
    [ -f "$TESTBASHUTILS_TEST_TMPSCRIPT" ] && rm -f "$TESTBASHUTILS_TEST_TMPSCRIPT" || true;
}

@test "[base-module 1.1] <module-name> no argument / usage <module-name>: usage string" {
    # no arg with global binary
    run "$TESTBASHUTILS_BIN" model
    $TEST_DEBUG && {
        echo "running: $TESTBASHUTILS_BIN model"
        echo "output: $output"
        echo "status: $status"
    } >&1
    [ "$status" -eq 1 ]
    first="$output"
    echo "$output" | grep '^usage:'
    # usage <module-name>
    run "$TESTBASHUTILS_BIN" usage model
    $TEST_DEBUG && {
        echo "running: $TESTBASHUTILS_BIN usage model"
        echo "output: $output"
        echo "status: $status"
    } >&1
    [ "$status" -eq 0 ]
    echo "$output" | grep '^usage:'
    [ "$first" = "$output" ]
}

@test "[base-module 1.2] <module_path> no argument: usage string" {
    # no arg with direct access
    run "$TESTBASHUTILS_MODELMODULE"
    $TEST_DEBUG && {
        echo "running: $TESTBASHUTILS_MODELMODULE"
        echo "output: $output"
        echo "status: $status"
    } >&1
    [ "$status" -eq 1 ]
    echo "$output" | grep '^usage:'
}

@test "[base-module 2.1] <module-name> --help|-h / help <module-name>: help string (multi-lines)" {
    # model --help
    run "$TESTBASHUTILS_BIN" model --help
    $TEST_DEBUG && {
        echo "running: $TESTBASHUTILS_BIN model --help"
        echo "output: $output"
        echo "status: $status"
    } >&1
    [ "$status" -eq 0 ]
    [ "${#lines[@]}" -gt 1 ]
    helpopt="$output"
    # model -h
    run "$TESTBASHUTILS_BIN" model -h
    $TEST_DEBUG && {
        echo "running: $TESTBASHUTILS_BIN model -h"
        echo "output: $output"
        echo "status: $status"
    } >&1
    [ "$status" -eq 0 ]
    [ "${#lines[@]}" -gt 1 ]
    hopt="$output"
    [ "$helpopt" = "$hopt" ]
    # help model
    run "$TESTBASHUTILS_BIN" help model
    $TEST_DEBUG && {
        echo "running: $TESTBASHUTILS_BIN help model"
        echo "output: $output"
        echo "status: $status"
    } >&1
    [ "$status" -eq 0 ]
    [ "${#lines[@]}" -gt 1 ]
    [ "$output" = "$helpopt" ]
    [ "$output" = "$hopt" ]
}

@test "[base-module 2.2] <module-path> --help|-h: help string (multi-lines)" {
    # model --help
    run "$TESTBASHUTILS_MODELMODULE" --help
    $TEST_DEBUG && {
        echo "running: $TESTBASHUTILS_MODELMODULE --help"
        echo "output: $output"
        echo "status: $status"
    } >&1
    [ "$status" -eq 0 ]
    [ "${#lines[@]}" -gt 1 ]
    helpopt="$output"
    # model -h
    run "$TESTBASHUTILS_MODELMODULE" -h
    $TEST_DEBUG && {
        echo "running: $TESTBASHUTILS_MODELMODULE -h"
        echo "output: $output"
        echo "status: $status"
    } >&1
    [ "$status" -eq 0 ]
    [ "${#lines[@]}" -gt 1 ]
    hopt="$output"
    [ "$helpopt" = "$hopt" ]
}

@test "[base-module 3.1] <module_name> --version|-V / about <module_name>: version string (multi-lines)" {
    # model --version
    run "$TESTBASHUTILS_BIN" model --version
    $TEST_DEBUG && {
        echo "running: $TESTBASHUTILS_BIN model --version"
        echo "output: $output"
        echo "status: $status"
    } >&1
    [ "$status" -eq 0 ]
    [ "${#lines[@]}" -gt 1 ]
    versionopt="$output"
    # model -V
    run "$TESTBASHUTILS_BIN" model -V
    $TEST_DEBUG && {
        echo "running: $TESTBASHUTILS_BIN model -V"
        echo "output: $output"
        echo "status: $status"
    } >&1
    [ "$status" -eq 0 ]
    [ "${#lines[@]}" -gt 1 ]
    Vopt="$output"
    [ "$versionopt" = "$Vopt" ]
    # about model
    run "$TESTBASHUTILS_BIN" about model
    $TEST_DEBUG && {
        echo "running: $TESTBASHUTILS_BIN about model"
        echo "output: $output"
        echo "status: $status"
    } >&1
    [ "$status" -eq 0 ]
    [ "${#lines[@]}" -gt 1 ]
    [ "$output" = "$versionopt" ]
    [ "$output" = "$Vopt" ]
}

@test "[base-module 3.2] <module-path> --version|-V: version string (multi-lines)" {
    # model --version
    run "$TESTBASHUTILS_MODELMODULE" --version
    $TEST_DEBUG && {
        echo "running: $TESTBASHUTILS_MODELMODULE --version"
        echo "output: $output"
        echo "status: $status"
    } >&1
    [ "$status" -eq 0 ]
    [ "${#lines[@]}" -gt 1 ]
    helpopt="$output"
    # model -V
    run "$TESTBASHUTILS_MODELMODULE" -V
    $TEST_DEBUG && {
        echo "running: $TESTBASHUTILS_MODELMODULE -V"
        echo "output: $output"
        echo "status: $status"
    } >&1
    [ "$status" -eq 0 ]
    [ "${#lines[@]}" -gt 1 ]
    hopt="$output"
    [ "$helpopt" = "$hopt" ]
}

@test "[base-module 4.1] <module_name> --version --quiet|-Vq / version <module_name>: version string (single line)" {
    # model --version --quiet
    run "$TESTBASHUTILS_BIN" model --version --quiet
    $TEST_DEBUG && {
        echo "running: $TESTBASHUTILS_BIN model --version --quiet"
        echo "output: $output"
        echo "status: $status"
    } >&1
    [ "$status" -eq 0 ]
    vquietopt="$output"
    [ "${#lines[@]}" -eq 1 ]
    # model -Vq
    run "$TESTBASHUTILS_BIN" model -Vq
    $TEST_DEBUG && {
        echo "running: $TESTBASHUTILS_BIN model -Vq"
        echo "output: $output"
        echo "status: $status"
    } >&1
    [ "$status" -eq 0 ]
    quietopt="$output"
    [ "${#lines[@]}" -eq 1 ]
    [ "$output" = "$vquietopt" ]
    # version
    run "$TESTBASHUTILS_BIN" version model
    $TEST_DEBUG && {
        echo "running: $TESTBASHUTILS_BIN version model"
        echo "output: $output"
        echo "status: $status"
    } >&1
    [ "$status" -eq 0 ]
    [ "${#lines[@]}" -eq 1 ]
    [ "$output" = "$quietopt" ]
    [ "$output" = "$vquietopt" ]
}

@test "[base-module 4.2] <module-path> --version --quiet|-Vq: version string (single line)" {
    # model --version --quiet
    run "$TESTBASHUTILS_MODELMODULE" --version --quiet
    $TEST_DEBUG && {
        echo "running: $TESTBASHUTILS_MODELMODULE --version --quiet"
        echo "output: $output"
        echo "status: $status"
    } >&1
    [ "$status" -eq 0 ]
    [ "${#lines[@]}" -eq 1 ]
    helpopt="$output"
    # model -Vq
    run "$TESTBASHUTILS_MODELMODULE" -Vq
    $TEST_DEBUG && {
        echo "running: $TESTBASHUTILS_MODELMODULE -Vq"
        echo "output: $output"
        echo "status: $status"
    } >&1
    [ "$status" -eq 0 ]
    [ "${#lines[@]}" -eq 1 ]
    hopt="$output"
    [ "$helpopt" = "$hopt" ]
}
