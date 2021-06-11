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

setup()
{
    : # nothing
}

teardown()
{
    : # nothing
}

#@test "test failure (must fail to validate all other tests)" {
#    [ true = false ]
#}

@test "[env 1] internal BASH_UTILS* variables available" {
    $TEST_DEBUG && {
        echo "BASH_UTILS_NAME = $BASH_UTILS_NAME"
        echo "BASH_UTILS_KEY = $BASH_UTILS_KEY"
        echo "BASH_UTILS_VERSION = $BASH_UTILS_VERSION"
        [ -n "$BASH_UTILS" ] && [ -f "$BASH_UTILS" ] && [ -e "$BASH_UTILS" ] && echo "BASH_UTILS = $BASH_UTILS (file exists & is executable)" || { \
            [ -n "$BASH_UTILS" ] && [ -f "$BASH_UTILS" ] && echo "BASH_UTILS = $BASH_UTILS (file exists but is NOT executable)" || { \
                [ -n "$BASH_UTILS" ] && echo "BASH_UTILS = $BASH_UTILS (file DOES NOT exist)"
            }
        };
        [ -n "$BASH_UTILS_ROOT" ] && [ -d "$BASH_UTILS_ROOT" ] && echo "BASH_UTILS_ROOT = $BASH_UTILS_ROOT (directory exists)" || { \
            [ -n "$BASH_UTILS_ROOT" ] && echo "BASH_UTILS_ROOT = $BASH_UTILS_ROOT (directory DOES NOT exist)"
        };
        [ -n "$BASH_UTILS_MODULES" ] && [ -d "$BASH_UTILS_MODULES" ] && echo "BASH_UTILS_MODULES = $BASH_UTILS_MODULES (directory exists)" || { \
            [ -n "$BASH_UTILS_MODULES" ] && echo "BASH_UTILS_MODULES = $BASH_UTILS_MODULES (directory DOES NOT exist)"
        };
    } >&1
    [ -n "$BASH_UTILS_NAME" ]
    [ -n "$BASH_UTILS_KEY" ]
    [ -n "$BASH_UTILS_VERSION" ]
    [ -n "$BASH_UTILS" ] && [ -f "$BASH_UTILS" ] && [ -e "$BASH_UTILS" ]
    [ -n "$BASH_UTILS_ROOT" ] && [ -d "$BASH_UTILS_ROOT" ]
    [ -n "$BASH_UTILS_MODULES" ] && [ -d "$BASH_UTILS_MODULES" ]
}

@test "[env 2] internal flags variables on 'false' by default" {
    $TEST_DEBUG && {
        $VERBOSE    && echo "VERBOSE = true"    || echo "VERBOSE = false";
        $QUIET      && echo "QUIET = true"      || echo "QUIET = false";
        $DEBUG      && echo "DEBUG = true"      || echo "DEBUG = false";
        $FORCE      && echo "FORCE = true"      || echo "FORCE = false";
        $DRY_RUN    && echo "DRY_RUN = true"    || echo "DRY_RUN = false";
    } >&1
    [ -n "$VERBOSE" ] && ! $VERBOSE
    [ -n "$QUIET" ] && ! $QUIET
    [ -n "$DEBUG" ] && ! $DEBUG
    [ -n "$FORCE" ] && ! $FORCE
    [ -n "$DRY_RUN" ] && ! $DRY_RUN
}

@test "[env 3] be sure to use bats'run (and not internal)" {
    run 'abcdefghijklmnopqrstuvwxyz'
    $TEST_DEBUG && {
        echo "running: run 'abcdefghijklmnopqrstuvwxyz'"
        echo "output: $output"
        echo "status: $status"
    } >&1
    [ "$status" -ne 0 ]
}
