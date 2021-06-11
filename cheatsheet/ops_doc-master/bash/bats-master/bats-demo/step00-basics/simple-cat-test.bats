#!/usr/bin/env bats

# this one should fail as the file does not exist

@test "simple-cat should output the content of the file failure" {
  run simple-cat.sh foofile
  [ "$status" -eq 0 ]
  [ "$output" = "foo" ]
}

# this one should work

@test "simple-cat should output the content of the file success" {
  run simple-cat.sh simple-echo-test.bats
  [ "$status" -eq 0 ]
  [ "${lines[0]}" = "#!/usr/bin/env bats" ]
}
