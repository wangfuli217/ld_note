#!/usr/bin/env bats

# let's try with a name

## This test assumes that the script under test lies in the same folder as the test
## $BATS_TEST_DIRNAME is one of the environment variables provided by Bats

@test "should output Hello Alice!" {
  run $BATS_TEST_DIRNAME/hello-world.sh  Alice
  echo "status=$status"
  echo "output=$output"
  [ "$status" -eq 0 ]
  [ "$output" = "Hello Alice!" ]
}

