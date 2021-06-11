#!/bin/bash

echo "Running unit tests:"

for i in tests/*_tests;
do
    if [ -f $i ]; then
        if $VALGRIND ./$i 2>> tests/tests.log; then
            echo $i PASS
        else
            echo "ERROR in tests $i: here's tests/tests.log"
            echo "------"
            tail tests/tests.log
            exit 1
        fi
    fi
done

echo ""
