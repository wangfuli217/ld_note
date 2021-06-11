#!/usr/bin/env bats

## This test assumes that the script under test lies in the same folder as the test
## $BATS_TEST_DIRNAME is one of the environment variables provided by Bats

# let's try with a simple name

@test "should output Hello Alice!" {
  run $BATS_TEST_DIRNAME/hello-world.sh -n Alice
  echo "output=$output"
  [ "$status" -eq 0 ]
  [ "$output" = "Hello Alice!" ]
}

# let's try with a another name in case Alice is hardcoded

@test "should output Hello Jabberwock!" {
  run $BATS_TEST_DIRNAME/hello-world.sh -n Jabberwock
  [ "$status" -eq 0 ]
  [ "$output" = "Hello Jabberwock!" ]
}


# Let's try with a composite name

@test "should output Hello Cheshire Cat! when names has many words" {
  run $BATS_TEST_DIRNAME/hello-world.sh -n "Cheshire Cat"
  echo "output=$output"
  [ "$status" -eq 0 ]
  [ "$output" = "Hello Cheshire Cat!" ]
}

# Name is mandatory

@test "When no name is provided should exit with 1" {
  run $BATS_TEST_DIRNAME/hello-world.sh -n
  echo "output=$output"
  [ "$status" -eq 1 ]
}


# Absence of name is an error

@test "When no name is provided output should contain name is mandatory" {
  run $BATS_TEST_DIRNAME/hello-world.sh -n
  echo "output=$output"
  [[ "$output" =~ "No name provided. Name is mandatory!" ]]
}

