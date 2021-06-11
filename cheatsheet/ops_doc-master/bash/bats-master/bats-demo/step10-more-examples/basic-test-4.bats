#!/usr/bin/env bats

## This test assumes that script under test lies in the same folder as the test

## a way to debug is to show the content of status, output and lines
## bats tests are silent when they pass
## however when a test fail, bats shows the stdout and stderr of the test function


@test "simple-script-with-multiple-lines should output foo - debug" {
  run $BATS_TEST_DIRNAME/simple-script-with-multiple-lines.sh
  [ "$status" -eq 0 ]
  echo "content of \${output} = ${output}"
  echo "expansion of \${lines[@]} = ${lines[@]}"
  [ "${output}" = "foo" ]
  #[[ "${output}" =~ "foo" ]]  # correct test
}

## printing onto a file work fine even when the test pass
## need some naming conventions  TODO

@test "simple-script-with-multiple-lines should contain foo - output file" {
  run $BATS_TEST_DIRNAME/simple-script-with-multiple-lines.sh
  [ "$status" -eq 0 ]
  echo "expansion of \${lines[@]} = ${lines[@]}"  > out.txt
  [ "${lines[0]}" = "foo" ]  # correct test
}

## be careful of using different names for each test
## if a same name is used for many tests, a failing test might be reported as passing
## bats stores results by the test name.
## When two tests are given the same name, both results will be stored into a same table entry
## The result is misleading because two tests of same name will be reported and they bnoth show the result od the last one

@test "same name - first should fail, second should pass" {
  run $BATS_TEST_DIRNAME/simple-script.sh  "foo" 1
  [ "$status" -eq 0 ]
}

@test "same name - first should fail, second should pass" {
  run $BATS_TEST_DIRNAME/simple-script.sh  "foo" 0
  [ "$status" -eq 0 ]
}

