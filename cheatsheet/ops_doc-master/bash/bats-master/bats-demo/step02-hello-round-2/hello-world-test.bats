#!/usr/bin/env bats

## This test assumes that the script under test lies in the same folder as the test
## $BATS_TEST_DIRNAME is one of the environment variables provided by Bats

# let's try with a simple name

@test "should output Hello Alice!" {
  run $BATS_TEST_DIRNAME/hello-world.sh  Alice
  [ "$status" -eq 0 ]
  [ "$output" = "Hello Alice!" ]
}

# let's try with a another name in case Alice is hardcoded

@test "should output Hello Jabberwock!" {
  run $BATS_TEST_DIRNAME/hello-world.sh  Jabberwock
  [ "$status" -eq 0 ]
  [ "$output" = "Hello Jabberwock!" ]
}

# does it still wotk for composite names ?

@test "should output Hello Cheshire Cat! when name has many words - wrong version" {
  run $BATS_TEST_DIRNAME/hello-world.sh  Cheshire Cat
  echo "output=$output"
  [ "$status" -eq 0 ]
  [ "$output" = "Hello Cheshire Cat!" ]
}

# The test was wrong. Let's fix the test

@test "should output Hello Cheshire Cat! when names has many words" {
  run $BATS_TEST_DIRNAME/hello-world.sh  "Cheshire Cat"
  echo "output=$output"
  [ "$status" -eq 0 ]
  [ "$output" = "Hello Cheshire Cat!" ]
}

# what if no name is provided  ?
# what do I expect in that case ? this test requires some specification clarifications
# Let's assume for a while it just skip the name

@test "should output Hello!" {
  run $BATS_TEST_DIRNAME/hello-world.sh
  echo "output=$output"
  [ "$status" -eq 0 ]
  [ "$output" = "Hello!" ]
}


