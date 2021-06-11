#!/usr/bin/env bats

## This test assumes that the script under test lies in the same folder as the test
## $BATS_TEST_DIRNAME is one of the environment variables provided by Bats

# -v will set the verbosity on
# as this is a parameter, a message must be yield
# I do not check the status because -v is probably wrong. however it is not the purpose of this test

@test "When -v should change verbosity and output a trace" {
  run $BATS_TEST_DIRNAME/hello-world.sh -v
  echo "output=$output"
  [[ "$output" =~ "INFO - verbose mode is on" ]]
}

# When verbose is on, each input parameter must yield a trace

@test "When -v and -n should output the value of name" {
  run $BATS_TEST_DIRNAME/hello-world.sh -v -n "Alice"
  echo "output=$output"
  #[[ "$output" =~ "input parameter name = 'Alice'" ]]
  [[ "$output" =~ "INFO - input parameter name = 'Alice'" ]]
}

# When verbose is off, input parameter should not yield a trace

@test "When no -v should not output the value of name" {
  run $BATS_TEST_DIRNAME/hello-world.sh -n "Alice"
  echo "output=$output"
  #[[ ! "$output" =~ "input parameter name = 'Alice'" ]]
  [[ ! "$output" =~ "INFO - input parameter name = 'Alice'" ]]
}
