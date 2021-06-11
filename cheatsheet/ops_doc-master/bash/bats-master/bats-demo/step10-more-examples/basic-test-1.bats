#!/usr/bin/env bats

## This test assumes that script under test lies in the same folder as the test

## The simpliest way to use bats it to call the script

@test "simple-script should pass" {
  $BATS_TEST_DIRNAME/simple-script.sh  "foo" 0
}

## Bats will catch exit with a non zero code whether they are forced (test 2) or caused by a script failure (test 3)

@test "simple-script should fail on exit 1" {
  $BATS_TEST_DIRNAME/simple-script.sh  "foo" 1
}

@test "simple-script-with-error should fail on cat foo" {
  $BATS_TEST_DIRNAME/simple-script-with-errors.sh
}

## Bats TODO

@test "simple-script-with-stderr should pass" {
  $BATS_TEST_DIRNAME/simple-script-with-stderr.sh
}

