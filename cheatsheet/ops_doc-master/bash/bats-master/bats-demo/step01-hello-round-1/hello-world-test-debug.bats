#!/usr/bin/env bats

# two debug strategies

## say this test fails

@test "should output Hello Alice!" {
  run $BATS_TEST_DIRNAME/hello-world.sh  Alice
  [ "$status" -eq 0 ]
  [ "$output" = "Hello Alice!" ]
}

## echo the outputs of the script

@test "Debug-1 - should output Hello Alice!" {
  run $BATS_TEST_DIRNAME/hello-world.sh  Alice
  echo "status=$status"
  echo "output=$output"
  [ "$status" -eq 0 ]
  [ "$output" = "Hello Alice!" ]
}

## remove run to prevent it from catching the output

@test "Debug-2 - should output Hello Alice!" {
  $BATS_TEST_DIRNAME/hello-world.sh  Alice
  [ "$status" -eq 0 ]
  [ "$output" = "Hello Alice!" ]
}

