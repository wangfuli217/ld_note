#!/usr/bin/env bats

## sans run ne fait rien si on sort en code 1
## run tout seul ne teste pas les erreurs 

@test "sample-script should exit with  0" {
  run $BATS_TEST_DIRNAME/sample-script.sh 
}

@test "sample-script should exit with  1" {
  run $BATS_TEST_DIRNAME/sample-script.sh -e 1
  [ "$status" -eq 1 ]
  echo "ici" >> $BATS_TEST_DIRNAME/out.txt
}

@test "sample-script should output hello" {
  run $BATS_TEST_DIRNAME/sample-script.sh -e 0 -o "hello"
  [ "$status" -eq 0 ]
  [ "$output" = "hello" ] 
}

@test "sample-script should output hello on first line" {
  run $BATS_TEST_DIRNAME/sample-script.sh -o "hello"
  [ "$status" -eq 0 ]
  [ "${lines[0]}" = "hello" ]
}

@test "sample-script should output hello on first line with stderr" {
  run $BATS_TEST_DIRNAME/sample-script.sh -v -o "hello" 
  [ "$status" -eq 0 ]
  [ "${lines[0]}" = "hello" ]
}
