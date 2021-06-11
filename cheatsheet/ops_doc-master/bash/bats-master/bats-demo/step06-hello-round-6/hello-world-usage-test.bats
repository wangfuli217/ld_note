#!/usr/bin/env bats

## This test assumes that the script under test lies in the same folder as the test
## $BATS_TEST_DIRNAME is one of the environment variables provided by Bats

USAGE_MESSAGE=(
"Usages:"
"    hello-world.sh [-v] -n name : output Hello name!"
"    hello-world.sh -h : show the help"
"Parameters :"
"    -v : increase verbosity"
"    -n name : indicates the name of the person to say hello to"
"    -h : display the usage"
)

# check the usage for presence and check every line

@test "On -h should output the usage" {
  run $BATS_TEST_DIRNAME/hello-world.sh -h
  echo "output=${output}"
  [ "${#lines[@]}" -eq 7 ]
  for i in {0..7}; do
    [ "${lines[$i]}" = "${USAGE_MESSAGE[$i]}" ]
  done
}

# check that -h does not exit with errors unlike the no parameter check

@test "On -h should exit without error" {
  run $BATS_TEST_DIRNAME/hello-world.sh -h
  [ "$status" -eq 0 ]
}
