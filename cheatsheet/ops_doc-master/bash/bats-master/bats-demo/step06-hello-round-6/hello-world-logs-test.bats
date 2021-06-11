#!/usr/bin/env bats

## This test assumes that the script under test lies in the same folder as the test
## $BATS_TEST_DIRNAME is one of the environment variables provided by Bats

# test of functions

load $BATS_TEST_DIRNAME/hello-world-logs-functions.sh

@test "print_var outputs the name and value" {
  VAR="abcd"
  result=$( print_var "VAR" )
  echo "result=$result"
  [[ "$result" = "VAR='abcd'"  ]]
}


# test of functions through run and helpers

load hello-world-functions-test-helper

@test "severity info should start with INFO and show the message - helper" {
  run functions_test_helper log_info "this is a test"
  echo "output=$output"
  [[ "$output" = "INFO - this is a test"  ]]
}

@test "severity info should start with INFO and show the message - helper alt" {
  run log_info_test_helper "this is a test"
  echo "output=$output"
  [[ "$output" = "INFO - this is a test"  ]]
}

@test "severity error should start with ERROR and show the message" {
  run functions_test_helper log_error "this is a test"
  echo "output=$output"
  [[ "$output" = "ERROR - this is a test"  ]]
}

@test "severity error should start with ERROR and show the message - alt" {
  run log_error_test_helper "this is a test"
  echo "output=$output"
  [[ "$output" = "ERROR - this is a test"  ]]
}


# in order to test whether INFO goes on stderr, stdout is redirect nowhere
# output now only contains the content of stderr

@test "info should go on stderr" {
  #run $BATS_TEST_DIRNAME/hello-world.sh -v -n Alice 1>/dev/null
  run filter_stderr_test_helper $BATS_TEST_DIRNAME/hello-world.sh -v -n Alice
  echo "output=$output"
  [[ "${#lines[@]}" -eq 2 ]]
  [[ "${lines[0]}" = "INFO - verbose mode is on"  ]]
  [[ "${lines[1]}" = "INFO - input parameter name = 'Alice'"  ]]
}

@test "error should go on stderr" {
  run filter_stderr_test_helper $BATS_TEST_DIRNAME/hello-world.sh -v
  echo "output=$output"
  [[ "${#lines[@]}" -eq 2 ]]
  [[ "${lines[0]}" = "INFO - verbose mode is on"  ]]
  [[ "${lines[1]}" = "ERROR - No name provided. Name is mandatory!"  ]]
}
