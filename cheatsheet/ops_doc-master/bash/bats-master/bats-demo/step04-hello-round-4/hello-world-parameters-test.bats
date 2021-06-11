#!/usr/bin/env bats

## This test assumes that the script under test lies in the same folder as the test
## $BATS_TEST_DIRNAME is one of the environment variables provided by Bats

@test "When no parameter is provided should exit with 1" {
  run $BATS_TEST_DIRNAME/hello-world.sh
  [ "$status" -eq 1 ]
}

@test "When no parameter is provided should output the usage" {
  skip
  run $BATS_TEST_DIRNAME/hello-world.sh
  echo "output=$output"
  [ "$output" = "Usage: hello-world.sh <name>" ]
}

@test "When no parameter is provided output should contain the usage" {
  run $BATS_TEST_DIRNAME/hello-world.sh
  #[ "$output" = "Usage: hello-world.sh <name>" ]
  echo "output = $output"
  [[ "$output" =~ "Usage: hello-world.sh <name>" ]]
}

@test "When no parameter is provided should output the usage on first line" {
  run $BATS_TEST_DIRNAME/hello-world.sh
  echo "line_0=${lines[0]}"
  [ "${lines[0]}" = "Usage: hello-world.sh <name>" ]
}


#@test "inspect bats src" {
#  ls  /tmp/bats.*.src | xargs -I{} cat {}
#  [ 1 -eq 0 ]
#}



