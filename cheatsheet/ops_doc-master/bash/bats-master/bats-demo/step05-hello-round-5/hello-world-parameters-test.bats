#!/usr/bin/env bats

## This test assumes that the script under test lies in the same folder as the test
## $BATS_TEST_DIRNAME is one of the environment variables provided by Bats

USAGE_MESSAGE="Usage: hello-world.sh [-v] -n name"

@test "When no parameter is provided should exit with 1" {
  run $BATS_TEST_DIRNAME/hello-world.sh
  [ "$status" -eq 1 ]
}

@test "When no parameter is provided output should contain the usage" {
  run $BATS_TEST_DIRNAME/hello-world.sh
  [[ "$output" =~ "$USAGE_MESSAGE"  ]]
}

@test "When no parameter is provided should output the usage on first line" {
  run $BATS_TEST_DIRNAME/hello-world.sh
  echo "line_0=${lines[0]}"
  [ "${lines[0]}" = "$USAGE_MESSAGE" ]
}



