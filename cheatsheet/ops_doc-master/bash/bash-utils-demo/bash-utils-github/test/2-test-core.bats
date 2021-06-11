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
    init_defaults
}

teardown()
{
    : # nothing
}

@test "[core 1] die" {
    # no arg error
    run die
    $TEST_DEBUG && {
        echo "running: die"
        echo "output: $output"
        echo "status: $status"
    } >&1
    [ "$status" -ne 0 ]
    [ "$status" -eq 1 ]
    [ -n "$output" ]
    # false arg error
    run die 'test string' 0
    $TEST_DEBUG && {
        echo "running: die 'test string' 0"
        echo "output: $output"
        echo "status: $status"
    } >&1
    [ "$status" -ne 0 ]
    [ "$status" -eq 1 ]
    [ -n "$output" ]
}

@test "[core 2] stack_trace" {
    run stack_trace
    $TEST_DEBUG && {
        echo "running: stack_trace"
        echo "output: $output"
        echo "status: $status"
    } >&1
    [ "$status" -eq 0 ]
    [ -n "$output" ]
    [ "${#lines[@]}" -gt 1 ]
}

@test "[core 3] error" {
    # no arg error
    run error
    $TEST_DEBUG && {
        echo "running: error"
        echo "output: $output"
        echo "status: $status"
    } >&1
    [ "$status" -ne 0 ]
    [ "$status" -eq 1 ]
    [ -n "$output" ]
    # args
    run error 'error string'
    $TEST_DEBUG && {
        echo "running: error 'error string'"
        echo "output: $output"
        echo "status: $status"
    } >&1
    [ "$status" -ne 0 ]
    [ "$status" -eq 1 ]
    [ -n "$output" ]
    # args
    run error 'error string' 23
    $TEST_DEBUG && {
        echo "running: error 'error string' 23"
        echo "output: $output"
        echo "status: $status"
    } >&1
    [ "$status" -ne 0 ]
    [ "$status" -eq 23 ]
    [ -n "$output" ]
}

@test "[core 4] warning" {
    # no arg error
    run warning
    $TEST_DEBUG && {
        echo "running: warning"
        echo "output: $output"
        echo "status: $status"
    } >&1
    [ "$status" -eq 0 ]
    [ -z "$output" ]
    # args
    run warning 'error string'
    $TEST_DEBUG && {
        echo "running: warning 'error string'"
        echo "output: $output"
        echo "status: $status"
    } >&1
    [ "$status" -eq 0 ]
    [ -n "$output" ]
}

@test "[core 5] module_exists" {
    # no arg error
    run module_exists
    $TEST_DEBUG && {
        echo "running: module_exists"
        echo "output: $output"
        echo "status: $status"
    } >&1
    [ "$status" -eq 1 ]
    # args with true module
    run module_exists model
    $TEST_DEBUG && {
        echo "running: module_exists model"
        echo "output: $output"
        echo "status: $status"
    } >&1
    [ "$status" -eq 0 ]
    # args with false module
    run module_exists abcdefghijklmnopqrstuvwxyz
    $TEST_DEBUG && {
        echo "running: module_exists abcdefghijklmnopqrstuvwxyz"
        echo "output: $output"
        echo "status: $status"
    } >&1
    [ "$status" -eq 1 ]
}

@test "[core 6] find_module" {
    # no arg error
    run find_module
    $TEST_DEBUG && {
        echo "running: find_module"
        echo "output: $output"
        echo "status: $status"
    } >&1
    [ "$status" -ne 0 ]
    # args with true module
    run find_module model
    $TEST_DEBUG && {
        echo "running: find_module model"
        echo "output: $output"
        echo "status: $status"
    } >&1
    [ "$status" -eq 0 ]
    [ -n "$output" ]
    # args with false module
    run find_module abcdefghijklmnopqrstuvwxyz
    $TEST_DEBUG && {
        echo "running: find_module abcdefghijklmnopqrstuvwxyz"
        echo "output: $output"
        echo "status: $status"
    } >&1
    [ "$status" -ne 0 ]
}

@test "[core 7] is_known_option" {
    # no arg error
    run is_known_option
    $TEST_DEBUG && {
        echo "running: is_known_option"
        echo "output: $output"
        echo "status: $status"
    } >&1
    [ "$status" -ne 0 ]
    # args with short known option 'f'
    run is_known_option f
    $TEST_DEBUG && {
        echo "running: is_known_option f"
        echo "output: $output"
        echo "status: $status"
    } >&1
    [ "$status" -eq 0 ]
    # args with short known option '-f'
    run is_known_option '-f'
    $TEST_DEBUG && {
        echo "running: is_known_option -f"
        echo "output: $output"
        echo "status: $status"
    } >&1
    [ "$status" -eq 0 ]
    # args with long known option 'force'
    run is_known_option force
    $TEST_DEBUG && {
        echo "running: is_known_option force"
        echo "output: $output"
        echo "status: $status"
    } >&1
    [ "$status" -eq 0 ]
    # args with short known option '--force'
    run is_known_option '--force'
    $TEST_DEBUG && {
        echo "running: is_known_option --force"
        echo "output: $output"
        echo "status: $status"
    } >&1
    [ "$status" -eq 0 ]
    # args with short known option 'z'
    run is_known_option z
    $TEST_DEBUG && {
        echo "running: is_known_option z"
        echo "output: $output"
        echo "status: $status"
    } >&1
    [ "$status" -eq 1 ]
    # args with short known option '-z'
    run is_known_option '-z'
    $TEST_DEBUG && {
        echo "running: is_known_option -z"
        echo "output: $output"
        echo "status: $status"
    } >&1
    [ "$status" -eq 1 ]
    # args with long known option 'abcef'
    run is_known_option abcef
    $TEST_DEBUG && {
        echo "running: is_known_option abcef"
        echo "output: $output"
        echo "status: $status"
    } >&1
    [ "$status" -eq 1 ]
    # args with short known option '--abcef'
    run is_known_option '--abcef'
    $TEST_DEBUG && {
        echo "running: is_known_option --abcef"
        echo "output: $output"
        echo "status: $status"
    } >&1
    [ "$status" -eq 1 ]
}
