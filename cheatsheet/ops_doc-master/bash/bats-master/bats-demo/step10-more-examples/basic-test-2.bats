#!/usr/bin/env bats

## This test assumes that script under test lies in the same folder as the test

## run collects the return code and output

@test "simple-script should pass" {
  run $BATS_TEST_DIRNAME/simple-script.sh  "foo" 0
  [ "$status" -eq 0 ]
  [ "$output" = "foo" ]
}

## the test will fail if the run program exit with a non zero code. Bats stops upon the first failing check


@test "simple-script will fail because exit code is not as expected" {
  run $BATS_TEST_DIRNAME/simple-script.sh  "foo" 1
  [ "$status" -eq 0 ]
  [ "$output" = "foo" ]
}

## bats also fail when the program under test result in errors


@test "simple-script-with-error will fail on cat foo" {
  run $BATS_TEST_DIRNAME/simple-script-with-errors.sh
  [ "$status" -eq 0 ]
  [ "$output" = "foo" ]
}


## you may want to check for a non zero exit code (for instance the purpose of the test is to check for error detection)

@test "simple-script should pass on exit 4 " {
  run $BATS_TEST_DIRNAME/simple-script.sh  "foo" 4
  [ "$status" -eq 4 ]
  [ "$output" = "foo" ]
}

## bats also collects sdterr on output

@test "simple-script-with-stderr should pass" {
  run $BATS_TEST_DIRNAME/simple-script-with-stderr.sh
  [ "$status" -eq 0 ]
  [ "$output" = "bar" ]
}

## $output = work fine for a single line input but fail on multiple lines

@test "simple-script-with-multiple-lines will fail" {
  run $BATS_TEST_DIRNAME/simple-script-with-multiple-lines.sh
  [ "$status" -eq 0 ]
  [ "$output" = "foo" ]
}

## check basic-test-3.bats for more check examples
