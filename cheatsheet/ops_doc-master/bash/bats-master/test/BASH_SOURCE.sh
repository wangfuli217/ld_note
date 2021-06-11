#!/usr/bin/env bash

function test_func()
{
    echo "Current $FUNCNAME, \$FUNCNAME => (${FUNCNAME[@]})"
    another_func
    echo "Current $FUNCNAME, \$FUNCNAME => (${FUNCNAME[@]})"
}

function another_func()
{
    echo "Current $FUNCNAME, \$FUNCNAME => (${FUNCNAME[@]})"
}

echo "Out of function, \$FUNCNAME => (${FUNCNAME[@]})"
test_func
echo "Out of function, \$FUNCNAME => (${FUNCNAME[@]})"

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd ) 
export LD_LIBRARY_PATH=$DIR/lib 
echo ${BASH_SOURCE[*]}
echo ${BASH_SOURCE[0]}

