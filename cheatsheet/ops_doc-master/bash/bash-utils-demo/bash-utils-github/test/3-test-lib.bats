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

# coding

@test "[lib coding-1] function_exists" {
    # classic / func exist
    run function_exists function_exists
    $TEST_DEBUG && {
        echo "running: function_exists function_exists"
        echo "output: $output"
        echo "status: $status"
    } >&1
    [ "$status" -eq 0 ]
    # classic / func not exist
    run function_exists abcdefghijklmnopqrstuvw
    $TEST_DEBUG && {
        echo "running: function_exists abcdefghijklmnopqrstuvw"
        echo "output: $output"
        echo "status: $status"
    } >&1
    [ "$status" -ne 0 ]
}

# booleans

@test "[lib booleans-1] onoff_bit" {
    # no arg
    run onoff_bit
    $TEST_DEBUG && {
        echo "running: onoff_bit"
        echo "output: $output"
        echo "status: $status"
    } >&1
    [ "$status" -eq 0 ]
    # on
    run onoff_bit true
    $TEST_DEBUG && {
        echo "running: onoff_bit true"
        echo "output: $output"
        echo "status: $status"
    } >&1
    [ "$status" -eq 0 ]
    [ "$output" = 'on' ]
    # off
    run onoff_bit false
    $TEST_DEBUG && {
        echo "running: onoff_bit false"
        echo "output: $output"
        echo "status: $status"
    } >&1
    [ "$status" -eq 0 ]
    [ "$output" = 'off' ]
    # on
    TESTBOOL=true
    run onoff_bit "$TESTBOOL"
    $TEST_DEBUG && {
        echo "running: onoff_bit $TESTBOOL"
        echo "output: $output"
        echo "status: $status"
    } >&1
    [ "$status" -eq 0 ]
    [ "$output" = 'on' ]
    # off
    TESTBOOL=false
    run onoff_bit "$TESTBOOL"
    $TEST_DEBUG && {
        echo "running: onoff_bit $TESTBOOL"
        echo "output: $output"
        echo "status: $status"
    } >&1
    [ "$status" -eq 0 ]
    [ "$output" = 'off' ]
}

@test "[lib booleans-2] truefalse_bit" {
    # no arg
    run truefalse_bit
    $TEST_DEBUG && {
        echo "running: truefalse_bit"
        echo "output: $output"
        echo "status: $status"
    } >&1
    [ "$status" -eq 0 ]
    # on
    run truefalse_bit true
    $TEST_DEBUG && {
        echo "running: truefalse_bit true"
        echo "output: $output"
        echo "status: $status"
    } >&1
    [ "$status" -eq 0 ]
    [ "$output" = 'true' ]
    # off
    run truefalse_bit false
    $TEST_DEBUG && {
        echo "running: truefalse_bit false"
        echo "output: $output"
        echo "status: $status"
    } >&1
    [ "$status" -eq 0 ]
    [ "$output" = 'false' ]
    # on
    TESTBOOL=true
    run truefalse_bit "$TESTBOOL"
    $TEST_DEBUG && {
        echo "running: truefalse_bit $TESTBOOL"
        echo "output: $output"
        echo "status: $status"
    } >&1
    [ "$status" -eq 0 ]
    [ "$output" = 'true' ]
    # off
    TESTBOOL=false
    run truefalse_bit "$TESTBOOL"
    $TEST_DEBUG && {
        echo "running: truefalse_bit $TESTBOOL"
        echo "output: $output"
        echo "status: $status"
    } >&1
    [ "$status" -eq 0 ]
    [ "$output" = 'false' ]
}

# integers

@test "[lib integers-1] is_odd" {
    # no arg
    run is_odd
    $TEST_DEBUG && {
        echo "running: is_odd"
        echo "output: $output"
        echo "status: $status"
    } >&1
    [ "$status" -eq 0 ]
    # true
    for i in 1 3 5 13 19 99 137 18643; do
        run is_odd "$i"
        $TEST_DEBUG && {
            echo "running: is_odd $i"
            echo "output: $output"
            echo "status: $status"
        } >&1
        [ "$status" -eq 0 ]
    done
    # false
    for i in 2 4 8 14 88 162 19536; do
        run is_odd "$i"
        $TEST_DEBUG && {
            echo "running: is_odd $i"
            echo "output: $output"
            echo "status: $status"
        } >&1
        [ "$status" -ne 0 ]
    done
}

@test "[lib integers-2] is_even" {
    # no arg
    run is_even
    $TEST_DEBUG && {
        echo "running: is_even"
        echo "output: $output"
        echo "status: $status"
    } >&1
    [ "$status" -eq 0 ]
    # true
    for i in 2 4 8 14 88 162 19536; do
        run is_even "$i"
        $TEST_DEBUG && {
            echo "running: is_even $i"
            echo "output: $output"
            echo "status: $status"
        } >&1
        [ "$status" -eq 0 ]
    done
    # false
    for i in 1 3 5 13 19 99 137 18643; do
        run is_even "$i"
        $TEST_DEBUG && {
            echo "running: is_even $i"
            echo "output: $output"
            echo "status: $status"
        } >&1
        [ "$status" -ne 0 ]
    done
}

@test "[lib integers-3] is_prime" {
    # no arg
    run is_prime
    $TEST_DEBUG && {
        echo "running: is_prime"
        echo "output: $output"
        echo "status: $status"
    } >&1
    [ "$status" -eq 0 ]
    # true
    for i in 2 5 7 61 139 337 991; do
        run is_prime "$i"
        $TEST_DEBUG && {
            echo "running: is_prime $i"
            echo "output: $output"
            echo "status: $status"
        } >&1
        [ "$status" -eq 0 ]
    done
    # false
    for i in 1 4 18 84 115 390 885; do
        run is_prime "$i"
        $TEST_DEBUG && {
            echo "running: is_prime $i"
            echo "output: $output"
            echo "status: $status"
        } >&1
        [ "$status" -ne 0 ]
    done
}

# arrays
TESTARRAY=( 'one' 'two' 'four' )

@test "[lib arrays-1] in_array" {
    # with full array and valid item
    run in_array two "${TESTARRAY[@]}"
    $TEST_DEBUG && {
        echo "running: in_array two '${TESTARRAY[@]}'"
        echo "output: $output"
        echo "status: $status"
    } >&1
    [ "$status" -eq 0 ]
    # with referenced array and valid item
    run in_array two TESTARRAY[@]
    $TEST_DEBUG && {
        echo "running: in_array two TESTARRAY[@]"
        echo "output: $output"
        echo "status: $status"
    } >&1
    [ "$status" -eq 0 ]
    # with full array and invalid item
    run in_array three "${TESTARRAY[@]}"
    $TEST_DEBUG && {
        echo "running: in_array three '${TESTARRAY[@]}'"
        echo "output: $output"
        echo "status: $status"
    } >&1
    [ "$status" -eq 1 ]
    # with referenced array and invalid item
    run in_array three TESTARRAY[@]
    $TEST_DEBUG && {
        echo "running: in_array three TESTARRAY[@]"
        echo "output: $output"
        echo "status: $status"
    } >&1
    [ "$status" -eq 1 ]
}

@test "[lib arrays-2] array_search" {
    # with full array and valid item
    run array_search two "${TESTARRAY[@]}"
    [ "$status" -eq 0 ]
    [ "$output" -eq 1 ]
    # with referenced array and valid item
    run array_search two TESTARRAY[@]
    [ "$status" -eq 0 ]
    [ "$output" -eq 1 ]
    # with full array and invalid item
    run array_search three "${TESTARRAY[@]}"
    [ "$status" -eq 1 ]
    [ -z "$output" ]
    # with referenced array and invalid item
    run array_search three TESTARRAY[@]
    [ "$status" -eq 1 ]
    [ -z "$output" ]
}

# file-system

@test "[lib file-system-1] resolve_link" {
    # no arg error
    run resolve_link
    $TEST_DEBUG && {
        echo "running: resolve_link"
        echo "output: $output"
        echo "status: $status"
    } >&1
    [ "$status" -ne 0 ]
    # classic
    binpath="$(pwd)/test/bash-utils"
    run resolve_link "$binpath"
    $TEST_DEBUG && {
        echo "running: resolve_link $binpath"
        echo "output: $output"
        echo "status: $status"
    } >&1
    [ "$status" -eq 0 ]
    [ "$output" = "../bin/bash-utils" ]
}

@test "[lib file-system-2] real_path_dirname" {
    # no arg error
    run real_path_dirname
    $TEST_DEBUG && {
        echo "running: real_path_dirname"
        echo "output: $output"
        echo "status: $status"
    } >&1
    [ "$status" -ne 0 ]
    # classic
    binpath="$(pwd)/test/bash-utils"
    run abs_dirname "$binpath"
    $TEST_DEBUG && {
        echo "running: real_path_dirname $binpath"
        echo "output: $output"
        echo "status: $status"
    } >&1
    [ "$status" -eq 0 ]
    [ "$output" = "$(pwd)/libexec" ]
}

@test "[lib file-system-3] strip_trailing_slash" {
    # no arg error
    run strip_trailing_slash
    $TEST_DEBUG && {
        echo "running: strip_trailing_slash"
        echo "output: $output"
        echo "status: $status"
    } >&1
    [ "$status" -ne 0 ]
    # classic
    binpath="$(pwd)/"
    run strip_trailing_slash "$binpath"
    $TEST_DEBUG && {
        echo "running: strip_trailing_slash $binpath"
        echo "output: $output"
        echo "status: $status"
    } >&1
    [ "$status" -eq 0 ]
    [ "$output" = "$(pwd)" ]
}

@test "[lib file-system-4] get_line_number_matching" {
    # no arg error
    run get_line_number_matching
    $TEST_DEBUG && {
        echo "running: get_line_number_matching"
        echo "output: $output"
        echo "status: $status"
    } >&1
    [ "$status" -ne 0 ]
    # path error
    run get_line_number_matching "$(pwd)/abcdefg" "$mask"
    $TEST_DEBUG && {
        echo "running: get_line_number_matching $(pwd)/abcdefg $mask"
        echo "output: $output"
        echo "status: $status"
    } >&1
    [ "$status" -ne 0 ]
    # classic / line exists
    binpath="$TESTBASHUTILS_BIN"
    mask='/usr/bin/env'
    run get_line_number_matching "$binpath" "$mask"
    $TEST_DEBUG && {
        echo "running: get_line_number_matching $binpath $mask"
        echo "output: $output"
        echo "status: $status"
    } >&1
    [ "$status" -eq 0 ]
    [ "$output" = "1" ]
    # classic / line not exists
    mask='/usr/bin/enva'
    run get_line_number_matching "$binpath" "$mask"
    $TEST_DEBUG && {
        echo "running: get_line_number_matching $binpath $mask"
        echo "output: $output"
        echo "status: $status"
    } >&1
    [ "$status" -eq 0 ]
    [ -z "$output" ]
}

@test "[lib file-system-5] log" {
    # var exists
    $TEST_DEBUG && {
        echo "running: logfile is $CMD_LOGFILE"
    } >&1
    [ -n "$CMD_LOGFILE" ]
    # no arg error
    run log
    $TEST_DEBUG && {
        echo "running: log"
        echo "output: $output"
        echo "status: $status"
    } >&1
    [ "$status" -eq 0 ]
    [ -z "$output" ]
    # args
    run log 'log string'
    $TEST_DEBUG && {
        echo "running: log 'log string'"
        echo "output: $output"
        echo "status: $status"
    } >&1
    [ "$status" -eq 0 ]
    [ -z "$output" ]
    tail -n1 "$CMD_LOGFILE" | grep 'log string$'
}

@test "[lib file-system-6] resolve" {
    # no arg error
    run resolve
    $TEST_DEBUG && {
        echo "running: resolve"
        echo "output: $output"
        echo "status: $status"
    } >&1
    [ "$status" -eq 0 ]
    [ -z "$output" ]
    # args
    run resolve '~/bin'
    $TEST_DEBUG && {
        echo "running: resolve '~/bin'"
        echo "output: $output"
        echo "status: $status"
    } >&1
    [ "$status" -eq 0 ]
    [ -n "$output" ]
    [ "$output" = "${HOME}/bin" ]
}

# strings

@test "[lib strings-1] string_to_upper" {
    # no arg error
    run string_to_upper
    $TEST_DEBUG && {
        echo "running: string_to_upper"
        echo "output: $output"
        echo "status: $status"
    } >&1
    [ "$status" -ne 0 ]
    # classic
    run string_to_upper "abcdefgHIJkLM"
    $TEST_DEBUG && {
        echo "running: string_to_upper abcdefgHIJkLM"
        echo "output: $output"
        echo "status: $status"
    } >&1
    [ "$status" -eq 0 ]
    [ "$output" = 'ABCDEFGHIJKLM' ]
    # alphanum
    run string_to_upper "a1b2c3d4e5f6g7H8I9J10k11L12M"
    $TEST_DEBUG && {
        echo "running: string_to_upper a1b2c3d4e5f6g7H8I9J10k11L12M"
        echo "output: $output"
        echo "status: $status"
    } >&1
    [ "$status" -eq 0 ]
    [ "$output" = 'A1B2C3D4E5F6G7H8I9J10K11L12M' ]
}

@test "[lib strings-2] string_to_lower" {
    # no arg error
    run string_to_lower
    $TEST_DEBUG && {
        echo "running: string_to_lower"
        echo "output: $output"
        echo "status: $status"
    } >&1
    [ "$status" -ne 0 ]
    # classic
    run string_to_lower "abcdefgHIJkLM"
    $TEST_DEBUG && {
        echo "running: string_to_lower abcdefgHIJkLM"
        echo "output: $output"
        echo "status: $status"
    } >&1
    [ "$status" -eq 0 ]
    [ "$output" = 'abcdefghijklm' ]
    # alphanum
    run string_to_lower "a1b2c3d4e5f6g7H8I9J10k11L12M"
    $TEST_DEBUG && {
        echo "running: string_to_lower a1b2c3d4e5f6g7H8I9J10k11L12M"
        echo "output: $output"
        echo "status: $status"
    } >&1
    [ "$status" -eq 0 ]
    [ "$output" = 'a1b2c3d4e5f6g7h8i9j10k11l12m' ]
}
